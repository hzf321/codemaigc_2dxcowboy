--[[
Author: xiongmeng
Date: 2021-04-25 10:09:50
LastEditors: xiongmeng
LastEditTime: 2021-04-26 16:12:25
Description: 
--]]
local collectViewControl = class("WestZoneCollectViewControl")

 
local collectView = require (bole.getDesktopFilePath("Theme/WestZoneCollectView")) 

 
 

function collectViewControl:ctor(_mainViewCtl)
	self._mainViewCtl = _mainViewCtl
	self.gameConfig = self._mainViewCtl:getGameConfig()
	print("litianyang===========collectViewControl")
end

function collectViewControl:initLayout( root, collectTipNode )
	self.collectView = collectView.new(self, root, collectTipNode)
end

function collectViewControl:checkUnlockBtnCanTouch()
	return self._mainViewCtl:getCanTouchFeature()
end

function collectViewControl:unlockBtnClickEvent(_jptype)
	local tipBet = self._mainViewCtl.tipBetList[_jptype]
	local theBet = self._mainViewCtl:getCurBet()
	if theBet >= tipBet then
		self._mainViewCtl:stopDrawAnimate()
		self.collectView:showCollectTipNode()
	end
	return self._mainViewCtl:featureUnlockBtnClickEvent(_jptype)
end

function collectViewControl:changeCollectLockState(shouUnlock)
	if self.CollectState ~= shouUnlock then
		self.CollectState = shouUnlock
		self.collectView:changeCollectLockState(shouUnlock)
	end
end

function collectViewControl:onSpinStart()
	self:hideCollectTipNode()
end

function collectViewControl:hideCollectTipNode()
	self.collectView:hideCollectTipNode()
end

function collectViewControl:setCurCollectLevel(level, enterFree)
	self.collectView:setCurCollectLevel(level, enterFree)
end

function collectViewControl:changeCollectBet( theBet )
	local unLockBetList = self.gameConfig.unlockBetList
    local tipBet = self._mainViewCtl.tipBetList[unLockBetList["Collect"]]
    local isLock = false
    if theBet >= tipBet then
        isLock = false
    else
        isLock = true
    end
	if not self._mainViewCtl.showFreeSpinBoard then
    	self:changeCollectLockState(isLock)
	end
end

function collectViewControl:playMusicByName(name, singleton, loop)
	self._mainViewCtl:playMusicByName(name, singleton, loop)
end

function collectViewControl:getFlyNode()
	return self._mainViewCtl.mainView.flyNode
end

return collectViewControl 