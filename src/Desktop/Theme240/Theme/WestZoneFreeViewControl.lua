 
local parentClass = ThemeBaseFreeControl
local cls = class("WestZoneFreeViewControl", ThemeBaseFreeControl)
function cls:ctor(_mainViewCtl)
	parentClass.ctor(self, _mainViewCtl)
	self._mainViewCtl = _mainViewCtl
	self.curScene = self._mainViewCtl:getCurScene()
	self.gameConfig = self._mainViewCtl:getGameConfig()
	self.audio_list = self.gameConfig.audioList
end

function cls:stopFreeControl( stopRet )
	if self._mainViewCtl:getNormalStatus() then
		local freeGameInfo = stopRet["free_game"]
		if freeGameInfo then
			self.freeGameType = freeGameInfo["fg_type"]
			self.fgAvgBet = freeGameInfo["avg_bet"]
		end
	end
end

function cls:getSuperFgStatus()
	if self.freeGameType and self.freeGameType == 2 then 
		return true
	end
	return false
end

function cls:getNormalFgStatus()
	if self.freeGameType and self.freeGameType == 1 then 
		return true
	end
	return false
end

function cls:dealFreeGameResumeRet( data )
	if data["free_game"] then  -- 71 当前断线重连free game
		self.freeSpeical = self._mainViewCtl:getSpecialTryResume(data["free_game"]["item_list"])
		self.freeGameType = data["free_game"]["fg_type"]
		self.fgAvgBet = data["free_game"]["avg_bet"]
		if data["bonus_game"] and data["bonus_game"]["choice"] and data["bonus_game"]["choice"] == 0 then
			data["free_game"] = nil
		end
    end
end

function cls:showFreeSpinNode( ... )
	self._mainViewCtl:changeSpinBoard(self.gameConfig.SpinBoardType.FreeSpin)
end

function cls:resetPointBet( ... )
	if self.fgAvgBet then
		self._mainViewCtl:setPointBet(self.fgAvgBet)
	end
end

function cls:hideFreeSpinNode( ... )
	if self._mainViewCtl.footer then
		self._mainViewCtl.footer:changeNormalLayout2()
	end
	self.freeGameType = nil
	self.fgAvgBet = nil
end

function cls:playStartFreeSpinDialog(theData)
	if self._mainViewCtl.setFeatureState then 
		self._mainViewCtl:setFeatureState(self.gameConfig.FeatureName.Free, true)
	end

	if theData.enter_event then 
		theData.enter_event()
	end

	if theData.click_event then 
		theData.click_event()
		local delay = 0
		if self.freeGameType == 2 then 
			delay  = 5
		end
		local transitionType = self:getSuperFgStatus() and "super_free" or "free"
		local transitionDelay = self.gameConfig.transition_config[transitionType]
		self.node:runAction(
	            cc.Sequence:create(
	                    cc.CallFunc:create(function()
	                        self._mainViewCtl:playTransition(nil, transitionType)
	                    end
	                    ),
	                    cc.DelayTime:create(transitionDelay.onCover),
	                    cc.CallFunc:create(function()
							if theData.end_event then 
								theData.end_event()
							end
							self._mainViewCtl.mainView:updateSuperFgLowSymbol()
	                    end
	                    ),
	                    cc.DelayTime:create(transitionDelay.onEnd - transitionDelay.onCover),
	                    cc.CallFunc:create(function()
	                        self._mainViewCtl:showActivitysNode()
							self._mainViewCtl:dealMusic_PlayFreeSpinLoopMusic()
	                    end
	                    )
	            )
	        )
	end
end

function cls:playMoreFreeSpinDialog( theData )
	if theData.enter_event then theData.enter_event() end

	self:setFooterBtnsEnable(false)
    local csbName = "dialog_free"
    local dialogName = "free_more"
    
	self._mainViewCtl:hideActivitysNode()
	self.freeMoreDialog = self._mainViewCtl:showThemeDialog(theData, 2, csbName, dialogName)
	self._mainViewCtl:laterCallBack(3, function ()
		if theData.click_event then theData.click_event() end
		-- self._mainViewCtl:playMusicByName("dialog_close")
		self._mainViewCtl:laterCallBack(1,function ()
			self._mainViewCtl:showActivitysNode()
			if theData.end_event then theData.end_event() end
		end)
	end)
end

function cls:playCollectFreeSpinDialog(theData)
    self.isFreeClick = false
	local end_event = theData.end_event
	theData.end_event = nil
	self:setFooterBtnsEnable(false)
 	local dialogType = self:getSuperFgStatus() and "superFree_collect" or "free_collect"
	local csbPath = self:getSuperFgStatus() and "dialog_superFree" or "dialog_free"  
	local transitionType = self:getSuperFgStatus() and "super_free" or "free"
    local enter_event = theData.enter_event
    theData.enter_event = function()
		if enter_event then
            enter_event()
        end
		-- if self.freeGameType == 2 then
		-- 	self:playMusicByName("free_dialog_collect")
		-- else
		-- 	self:playMusicByName("mapFree_dialog_collect")
		-- end 
    end
	local transitionDelay = self.gameConfig.transition_config[transitionType]
    local changeLayer_event = theData.changeLayer_event
    theData.changeLayer_event = nil
    local click_event = theData.click_event
    theData.click_event = function()
	        if click_event then
	            click_event()
	        end
     		self.node:runAction(
	            cc.Sequence:create(
						cc.CallFunc:create(function()
							self._mainViewCtl:stopAllLoopMusic()
							self:playMusicByName("dialog_close")   -- 弹窗消失音效
						end),
						cc.DelayTime:create(33/30),
	                    cc.CallFunc:create(function()
	                        self._mainViewCtl:playTransition(nil, transitionType)
	                    end
	                    ),
	                    cc.DelayTime:create(transitionDelay.onCover),
	                    cc.CallFunc:create(function()
	                        if changeLayer_event then
	                            changeLayer_event()
							end
	                    end
	                    ),
	                    cc.DelayTime:create(transitionDelay.onEnd - transitionDelay.onCover),
	                    cc.CallFunc:create(function()
	                    	if end_event then
	                            end_event()
	                        end
	                        self._mainViewCtl:showActivitysNode()
	                    end
	                    )
	            )
	        )
	    end
    self._mainViewCtl:hideActivitysNode() 
    self.freeDialogNode = self._mainViewCtl:showThemeDialog(theData, self.gameConfig.fs_show_type.collect, csbPath, dialogType)
end

function cls:dealMusic_PlayFSEnterMusic( ) -- 进入freespin 弹窗显示的音效
end
function cls:dealMusic_StopFSEnterMusic( )
end
function cls:dealMusic_PlayFSEnterClickMusic( )
end

function cls:dealMusic_PlayFSMoreMusic( )
	self:playMusicByName("free_dialog_more_close")
end

function cls:dealMusic_StopFSMoreMusic( )
end

function cls:dealMusic_PlayFSMoreClickMusic( )
	self:playMusicByName("dialog_close")
end

--Free Game 收集音乐
function cls:dealMusic_PlayFSCollectMusic( )
	if self:getSuperFgStatus() then
		self:playMusicByName("mapFree_dialog_collect")
	else 
		self:playMusicByName("free_dialog_collect_show")
	end
end
function cls:dealMusic_StopFSCollectMusic( )
	if self:getSuperFgStatus() then
		self:stopMusicByName("mapFree_dialog_collect")
	else 
		self:stopMusicByName("free_dialog_collect_show")
	end
end
function cls:dealMusic_PlayFSCollectClickMusic()
	-- self:playMusicByName("free_dialog_collect_click")
end	
function cls:dealMusic_PlayFSCollectEndMusic( )
	-- self:playMusicByName("free_dialog_collect_close")
end

return cls
