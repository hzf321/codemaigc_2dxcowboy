

ThemeMysteriousPixies_JpControl = class("ThemeMysteriousPixies_JpControl", ThemeBaseJackpotControl)
local cls = ThemeMysteriousPixies_JpControl

require (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_JpView")) 
function cls:ctor(mainCtl)
	ThemeBaseJackpotControl.ctor(self, mainCtl)

	self.gameConfig = self._mainViewCtl:getGameConfig()
	self.audioCtl = self._mainViewCtl:getAudioCtl()
end

function cls:initLayout( nodeList )
	self.jpView = ThemeMysteriousPixies_JpView.new(self, nodeList)

	self:initialJackpotNode()
end

function cls:getJPLabelMaxWidth( index )
	local jackpotLabelMaxWidth = self.gameConfig.jp_config.jp_max_width
	return jackpotLabelMaxWidth[index] or jackpotLabelMaxWidth[#jackpotLabelMaxWidth]
end

function cls:checkUnlockTypeIsJackpot(unlockType)
	local isJackpot = false
	local lockJackpotInfoSet = Set(self.gameConfig.unlockJpInfoConfig)
	if lockJackpotInfoSet[unlockType] then 
		isJackpot = true
	end
	return isJackpot
end

function cls:changeJackpotLockState( unlockType, showUnlock )
	local jackpotType = tool.getKeyByTableItem(self.gameConfig.jp_config.jp_level, unlockType) 
	self.jpView:changeJackpotLockShow(jackpotType, showUnlock)
end

function cls:resetBoardShowByFeature(boardType)
	self.jpView:resetBoardShowByFeature(boardType)
end

function cls:checkJackpotBtnCanTouch()
	return self._mainViewCtl:featureBtnCheckCanTouch()
end

function cls:jpBtnClickEvent(_jptype)
	return self._mainViewCtl:featureUnlockBtnClickEvent(_jptype)
end

function cls:checkHasJackpotLockNode()
	return self.jpView:checkHasJackpotLockNode()
end

function cls:playChangeJakcpotStateTip(_showType, unlockLevel)
	self.jpView:playChangeJakcpotStateTip(_showType, unlockLevel)
end

function cls:playWinJpAnim(jpWinType)
	if 
		jpWinType 
		and (not self:checkFeatureIsLock(self.gameConfig.jp_config.jp_level[jpWinType])) 
		then

		return self.jpView:playWinJpAnim(jpWinType)
	end

end

function cls:showWinJackpotDialog(winData, endFunc)
	local jpWinType = winData.jp_win_type

	local isLock = self:checkFeatureIsLock(self.gameConfig.jp_config.jp_level[jpWinType])

	if isLock then 
		local winNum = winData.jp_win or 0
		endFunc(winNum)
	else
		self.jpView:showWinJackpotDialog(winData, endFunc)
	end

end

function cls:stopJpAnimate()
	self.jpView:stopJpAnimate()
end

function cls:changeJackpotLabelsState( lock, progressData )
	self:lockJackpotMeters(lock)

	if lock and progressData then 
		local jpLabels = self.jpView:getJackpotLabels()
		-- 获取jackpot
		local _progressive_list = self:getJackpotValue(progressData)
		
		for i=1, #_progressive_list do -- 设置jackpot label值
			if jpLabels[i] then
				jpLabels[i]:setString(self:formatJackpotMeter(_progressive_list[i]))
				bole.shrinkLabel(jpLabels[i], self:getJPLabelMaxWidth(i), jpLabels[i]:getScale())
			end
		end
	end
end

function cls:checkFeatureIsLock( ftype )
	return self._mainViewCtl:checkFeatureIsLock( ftype )
end

function cls:playNodeShowAction( node, actionData )
	return self._mainViewCtl:playNodeShowAction( node, actionData )
end

-------------------------------------------------------------------------------------------
function cls:changeJPZorder( zType )
	self.jpView:changeJPZorder( zType )
end


