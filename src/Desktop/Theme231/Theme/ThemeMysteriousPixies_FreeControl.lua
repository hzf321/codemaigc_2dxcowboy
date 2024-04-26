


local parentClass = ThemeBaseFreeControl
ThemeMysteriousPixies_FreeControl = class("ThemeMysteriousPixies_FreeControl", ThemeBaseFreeControl)
local cls = ThemeMysteriousPixies_FreeControl

function cls:ctor(_mainViewCtl)
	parentClass.ctor(self, _mainViewCtl)

	self.fBoardCount = 1
	self.fCollectCount = 0
end

-- 数据分析
function cls:checkDealSpecialFreeData( data ) -- 断线重连
	if data.free_game then 
		self.isResmeFree = true
    end

    self:resetFreeData(data.map_info)
end

function cls:getFreeBoardCnt(  )
	return self.fBoardCount or 1
end

function cls:resetFreeData( map_info )

end

function cls:checkStopCtlSpecialFreeData( stopRet ) -- stopControl
	self.isWinMoreFree = false
	self.isResmeFree = false
	if stopRet.free_spins and stopRet.free_game then
		if (not self:isInFG()) then
			self.fgType = stopRet.free_game.free_type or 0
			self:resetFreeData(stopRet.theme_info.map_info)
		else
			self.isWinMoreFree = true
		end
	end
end

function cls:checkIsInFreeStop( ... )
    return self.newCollectCount and self.newCollectCount > 0
end

function cls:checkIsResumeFree()
    return self.isResmeFree
end

function cls:clearFreeFeatureData( byHideFree )
	-- self.fgType = nil
	-- self.fgAvgBet = nil
end

-- free 断线重连
function cls:enterThemeByFirstFreeSpin(ret, theFreeSpinData, endCallFunc)
	if ret == nil then ret = {} end
	self.isProcessing  = true
	self:setFooterBtnsEnable(false)
	self._mainViewCtl:lockLobbyBtn()
	-- if theFreeSpinData.item_list then
	-- 	local realItemList = theFreeSpinData.item_list

	-- 	self._mainViewCtl:resetBoardCellsByItemList(realItemList)

	-- 	self.freeItem = tool.tableClone(realItemList)
	-- 	-- self._mainViewCtl.specials = self._mainViewCtl:getSpecialTryResume(realItemList)
	-- 	self.freeSpeical = self._mainViewCtl:getSpecialTryResume(realItemList)
	-- end

	if theFreeSpinData.free_random_pick then 
		
		ret.free_random_pick = tool.tableClone(theFreeSpinData.free_random_pick)
		ret.free_random_pick.tryResume 	= true

		self._mainViewCtl:free_random_pick(ret)

	else
		ret["free_spins"]		= theFreeSpinData.free_spins
		self._mainViewCtl:free_spins(ret)
	end
end

-- 弹窗
function cls:playStartFreeSpinDialog( theData )
	self._mainViewCtl:stopAllLoopMusic()
	self:hideActivitysNode()
	
	local endEvent = theData.end_event
	theData.end_event = nil
	local d_end_event = function ( ... )
		self:setFooterBtnsEnable(false)
		self._mainViewCtl:dealMusic_PlayFreeSpinLoopMusic()
		if endEvent then 
			endEvent()
		end
		self:showActivitysNode()
	end


	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end

		self.node:runAction(cc.Sequence:create(
			cc.DelayTime:create(40/30),
			cc.CallFunc:create(function ( ... )
			    if d_end_event then 
			    	d_end_event()
			    end
			end)))
	end

	local dType = self.gameConfig.fs_show_type.start
	theData.num_sp = theData.count
	self._mainViewCtl:showThemeDialog(theData, dType, "d_free")

end

function cls:playMoreFreeSpinDialog( theData )

	self:hideActivitysNode()
	self._mainViewCtl:dealMusic_FadeLoopMusic(0.2, 1, 0)

    local end_event = theData.end_event
    theData.end_event = nil
    local d_end_event = function()
        if end_event then
			end_event()
		end
		self._mainViewCtl:dealMusic_FadeLoopMusic(0.2, 0, 1)
		self:showActivitysNode()
    end

	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end

		self.node:runAction(cc.Sequence:create(
			cc.DelayTime:create((90 + 27)/30),
			cc.CallFunc:create(function ( ... )
			    if d_end_event then 
			    	d_end_event()
			    end
			end)))
	end
	
	local dName = "d_free"
	local dType = self.gameConfig.fs_show_type.more
	theData.num_sp = theData.count
	local dialog = self._mainViewCtl:showThemeDialog(theData, dType, dName)
end

function cls:playCollectFreeSpinDialog( theData )
	self._mainViewCtl:stopAllLoopMusic()
	self:hideActivitysNode()

    local enter_event = theData.enter_event
    theData.enter_event = function()
        if enter_event then
            enter_event()
        end
    end

	local changeLayer_event = theData.changeLayer_event
	theData.changeLayer_event = nil
	local t_changeLayer_event = function()
		if changeLayer_event then
			changeLayer_event()
		end
	end

    local end_event = theData.end_event
    theData.end_event = nil
    local d_end_event = function()

        if end_event then
            end_event()
        end
        self:showActivitysNode()
    end

	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end

		self.node:runAction(cc.Sequence:create(
			cc.DelayTime:create(40/30),
			cc.CallFunc:create(function ( ... )
			    self._mainViewCtl:playTransition(d_end_event, "free_out", t_changeLayer_event)-- 转场动画
			end)))
	end


	local dName = "d_free"
	local dType = self.gameConfig.fs_show_type.collect
	self._mainViewCtl:showThemeDialog(theData, dType, dName)
end

--------------------------------------------------------------------------------------------------

-- freespin音效相关
function cls:dealMusic_PlayFSEnterClickMusic( )
	self:playMusicByName("common_click")
	-- self:playMusicByName("popup_out")
end

-- retrigger
function cls:dealMusic_PlayFSMoreMusic( )
	self:playMusicByName("fg_retrigger")
end

--Free Game 收集音乐
function cls:dealMusic_PlayFSCollectClickMusic()
	self:playMusicByName("common_click")
	-- self:playMusicByName("popup_out")
end
------------------------------------------------------------------------------


