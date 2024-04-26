-- @Author: xiongmeng
-- @Date:   2020-11-20 10:36:45
-- @Last Modified by:   xiongmeng
-- @Last Modified time: 2020-12-03 11:58:16
-- require (tool.getDesktopFilePath("theme_loading/theme219/src%s/ThemePotPrizes_FreeView"))
local parentClass = ThemeBaseFreeControl
local cls = class("MightyC_FreeViewControl", parentClass)
local ThemeBaseDialog = require "Themes/base/ThemeBaseDialog"
local freeView = require (bole.getDesktopFilePath("Theme/MightyC_FreeView"))  
 
-- local freeView = require("Themes/MightyCash/MightyC_FreeView")

function cls:ctor(_mainViewCtl)
	parentClass.ctor(self, _mainViewCtl)
	self.fs_show_type = self.gameConfig.fs_show_type
	self.theme = self
	self.curScene = self._mainViewCtl:getCurScene()
end

function cls:initLayout(  )
	self.freeView = freeView.new(self)
end

function cls:checkIsSuperFree()
	
end
function cls:onSpinStart( ... )
	
end
function cls:onAllReelStop( ... )
	
end

function cls:stopFreeControl( stopRet )
	
end

function cls:checkHasFeatureFree( ... )
	return self.FeatureFree
end
function cls:stopDrawAnimate( ... )
	self.freeView:stopDrawAnimate()
end
function cls:dealFreeGameResumeRet( data )
	if data["free_game"] then 
		self.FreeGameType = data["free_game"]["fg_type"]
		self.mapAvgBet = data["free_game"]["avg_bet"]
		if data["free_game"]["free_spins"] and data["free_game"]["free_spins"] >= 0 then
			if data["free_game"]["free_spins"] == data["free_game"]["free_spin_total"] then 
				data["first_free_game"] = tool.tableClone(data["free_game"])
				data["free_game"] = nil
			elseif data["free_game"]["item_list"] then 
				local realItemList = data["free_game"]["item_list"]
				data["free_game"]["item_list"] = tool.tableClone(realItemList)
				self.freeSpeical = self._mainViewCtl:getSpecialTryResume(realItemList)
			end
		end
	end
end
function cls:showFreeSpinNode( ... )
end
function cls:resetPointBet( ... )
	if self.mapAvgBet then
		self._mainViewCtl:setPointBet(self.mapAvgBet)
	end
end
function cls:hideFreeSpinNode( ... )
	if self.FreeGameType and self.FreeGameType == 8 then
		self._mainViewCtl.mapLevel = 0
	end
end
function cls:getNormalFgStatus()
	-- body
end
----------------------------dialog start -------------------------------------
function cls:playStartFreeSpinDialog( theData )
	local dialogType = "free_start"
	local csbPath = "dialog_free"
	local curfgType
	local end_event = theData.end_event
	local changeLayer_event = theData.changeLayer_event
	local click_event = theData.click_event
	theData.changeLayer_event = nil
	theData.end_event = nil
	local counts = theData.count or 8
	self._mainViewCtl:setFooterLabelInFg(counts, counts)
	self:hideActivitysNode()
	self:setFooterBtnsEnable(false)
	theData.click_event = function()
	    if click_event then
	        click_event()
	    end
		self:playStartFreeSpinClickEvent(changeLayer_event, end_event)
	end
	local dialog = self._mainViewCtl:showThemeDialog(theData, self.fs_show_type.start, csbPath, dialogType)
	local startRoot = dialog.startRoot
	local label_node = startRoot:getChildByName("label_node")
	if label_node then
		local label_image = label_node:getChildByName("label_image")
		if label_image then
			bole.updateSpriteWithFile(label_image, "#theme244_popup_font"..counts..".png")
		end
	end
end
function cls:playStartFreeSpinClickEvent(changeLayer_event, end_event)
	local transitionDelay = self.gameConfig.transition_config.free
	self.node:runAction(
	    cc.Sequence:create(
	        cc.DelayTime:create(1),
	        cc.CallFunc:create(function()
	            self._mainViewCtl:playTransition(nil, "free")
	        end
	        ),
	        cc.DelayTime:create(transitionDelay.onCover),
	        cc.CallFunc:create(function()
	            if changeLayer_event then
	                changeLayer_event()
	            end
	            self:showFreeSpinNode()
	        end	
	        ),
	        cc.DelayTime:create(transitionDelay.onEnd - transitionDelay.onCover),
	        cc.CallFunc:create(function()
	        	if end_event then
	                end_event()
	            end
	            self:showActivitysNode()
	        end
	        ),
	        cc.DelayTime:create(0.5),
	        cc.CallFunc:create(function()
	            self:dealMusic_PlayFreeSpinLoopMusic()
	        end)
	    )
	)
end
function cls:playMoreFreeSpinDialog( theData )
	local csbPath     = "dialog_free"
	local dialogType = "free_more"
	self:hideActivitysNode()
	if theData.enter_event then
        theData.enter_event()
    end
    local end_event = theData.end_event
    theData.end_event = nil
	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end
		if end_event then
			end_event()
		end
		self:showActivitysNode()
	end
	local counts = theData.count or 8 
	local dialog = self._mainViewCtl:showThemeDialog(theData, self.fs_show_type.more, csbPath, dialogType)
	local moreRoot = dialog.moreRoot
	local label_node = moreRoot:getChildByName("label_node")
	if label_node then
		local label_image = label_node:getChildByName("label_image")
		if label_image then
			bole.updateSpriteWithFile(label_image, "#theme244_popup_font"..counts..".png")
		end
	end
end

function cls:playCollectFreeSpinDialog( theData )
	local fgTranType = "free"
	local transitionDelay = self.gameConfig.transition_config[fgTranType]
    local enter_event = theData.enter_event
    local end_event = theData.end_event
    theData.end_event = nil
    local changeLayer_event = theData.changeLayer_event
    theData.changeLayer_event = nil
    theData.enter_event = function()
        if enter_event then
            enter_event()
        end
    end
    self:hideActivitysNode()
	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end
		local a1 = cc.DelayTime:create(40/30)
		local a2 = cc.CallFunc:create(function ( ... )
			self._mainViewCtl:playTransition(nil, fgTranType)
		end)
		local a3 = cc.DelayTime:create(transitionDelay.onCover)
		local a4 = cc.CallFunc:create(function ( ... )
			if changeLayer_event then 
				changeLayer_event()
			end
		end)
		local a5 = cc.DelayTime:create(transitionDelay.onEnd - transitionDelay.onCover)
		local a6 = cc.CallFunc:create(function ( ... )
			if end_event then
        	    end_event()
        	end
        	self._mainViewCtl:finshSpin()
			self:setFooterBtnsEnable(true)
        	self:showActivitysNode()
		end)
		local a7 = cc.Sequence:create(a1,a2,a3,a4,a5,a6)
		self.node:runAction(a7)
	end
	local csbPath     = "dialog_free"
	local dialogType = "free_collect"
	self._mainViewCtl:showThemeDialog(theData, self.fs_show_type.collect, csbPath, dialogType)
end
----------------------------dialog end --------------------------------------


------------------------------------------------------------------------------
function cls:playFeatureDimmerAnim(dType, state)
	return self._mainViewCtl:playFeatureDimmerAnim(dType, state)
end

function cls:playNodeShowAction( node, actionData )
	return self._mainViewCtl:playNodeShowAction( node, actionData )
end

function cls:getPic(name)
	return self._mainViewCtl:getPic(name)
end

function cls:playFadeToMinVlomeMusic( ... )
	self._mainViewCtl:playFadeToMinVlomeMusic()
end
function cls:playFadeToMaxVlomeMusic( ... )
	self._mainViewCtl:playFadeToMaxVlomeMusic()
end
function cls:getCsbPath( file_name )
	return self._mainViewCtl:getCsbPath(file_name)
end


-----------------free 音效相关-------------------
-- 播放free games的背景音乐
function cls:dealMusic_PlayFreeSpinLoopMusic() -- 播放背景音乐
	self.audioCtl:dealMusic_PlayGameLoopMusic(self._mainViewCtl:getAudioFile("free_background"))
end

function cls:dealMusic_PlayFSCollectClickMusic()
	
end
function cls:dealMusic_PlayFSMoreClickMusic()

end
function cls:dealMusic_PlayFSEnterClickMusic()

end

-- freespin音效相关
function cls:playMusicByOnce(name)
    self._mainViewCtl:playMusicByOnce(name)
end

return cls


