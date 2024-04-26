-- @Author: xiongmeng
-- @Date:   2021-03-23 11:18:33
-- @Last Modified by:   xiongmeng
-- @Last Modified time: 2021-03-23 13:21:43
-- local collectView = require ("Themes/MightyCash/MightyC_CollectView")
local collectView = require (bole.getDesktopFilePath("Theme/MightyC_CollectView"))  
 
local parentCls = ThemeBaseViewControlDelegate
local cls = class("MightyC_CollectViewControl", parentCls)
function cls:ctor(mainCtl)
	parentCls.ctor(self, mainCtl)
	self:_initCollectData()
end
function cls:_initCollectData(  )
	local mapCollectData = self.gameConfig.collectData
	self.maxMapLevel = mapCollectData.maxMapLevel
end
function cls:initLayout( collectRoot, collectTip )
	self.collectView = collectView.new(self, collectRoot, collectTip)
end
function cls:onSpinStart()
	self.collectView:hideColelctTip(true)
end
--@collect pos
function cls:setCollectProgressImagePos( mapLevel )
	self.collectView:updateCollectPrImagePos(mapLevel)
end
function cls:addSuperBonusJili()
	if self:getJiliLevel() then
		self.collectView:addSuperBonusJili()
	end
end
function cls:cleanSuperBonusJili()
	self.collectView:cleanSuperBonusJili()
end
function cls:getJiliLevel()
	local jiliLevel = false
	if self._mainViewCtl.mapLevel and self._mainViewCtl.mapLevel == 9 then
		jiliLevel = true
	end
	if self.isLockFeature then
		jiliLevel = false
	end
	return jiliLevel
end
function cls:getCurrentPoints( map_points )
	if map_points > self.maxMapPoints then
	    map_points = self.maxMapPoints
	elseif map_points < 0 then
	    map_points = 0
	end
	return map_points
end

function cls:getMapCommingWin()
	if self._mainViewCtl.mapPoints then
		if self._mainViewCtl.mapPoints/self.maxMapPoints >= 0.8 then
			return true
		end
	end
	return false
end

function cls:laterCallBack(time, func)
	self.node:runAction(cc.Sequence:create(cc.DelayTime:create(time), cc.CallFunc:create(func)))
end
--@openStore
function cls:mapBtnClickEvent(  )
	self._mainViewCtl:getMapViewCtl():showMapScene(true)
end
function cls:icLockCollect( ... )
	return self.isLockFeature
end
function cls:getPlayFirstTimeInFeature()
	return self._mainViewCtl.enterFirstTime
end
function cls:setPlayFirstTimeInFeature()
	self._mainViewCtl.enterFirstTime = false
end
--@collect unlock
function cls:collectBtnClickEvent(  )
	if not self.isLockFeature then
		self.collectView:showCollectTip()
        return nil
    end
    local unLockBetList = self.gameConfig.unlockBetList
    self._mainViewCtl:featureUnlockBtnClickEvent(unLockBetList["Collect"])
end
--@changeBet
function cls:changeCollectBet( theBet )
	local unLockBetList = self.gameConfig.unlockBetList
    local tipBet = self._mainViewCtl.tipBetList[unLockBetList.Collect]
    if self.isLockFeature == nil then
        if theBet >= tipBet then
            self.isLockFeature = true
        else
            self.isLockFeature = false
        end
    end
    local isLock = theBet < tipBet
    if self.isLockFeature ~= isLock then
        self.collectView:setCollectPartState(isLock, true)
    end
end
function cls:checkCollectBtnCanTouch( ... )
	return self._mainViewCtl:getCanTouchFeature()
end

function cls:collectStopCtl( stopRet )
	local themeInfo = stopRet.theme_info
	if themeInfo and themeInfo.map_info then
		local oldLevel = self._mainViewCtl.mapLevel
		if oldLevel ~= themeInfo.map_info.map_level then
			self.winCollectPoints = true
			self._mainViewCtl.mapLevel = themeInfo.map_info.map_level or 0
			if self._mainViewCtl.mapLevel >= self.gameConfig.collectData.maxMapLevel then
				self._mainViewCtl.mapLevel = self.gameConfig.collectData.maxMapLevel
			end
		end
	end
end
function cls:getCurrentMapLevel()
	return self._mainViewCtl.mapLevel
end
function cls:checkHasFeatureCollect( ... )
	if not self.winCollectPoints then
		self:updateBonusLevel()
	end
	return self.winCollectPoints
end
function cls:collectCollectionStrips(rets, endFunc)
	self.winCollectPoints = false
	local flyToUpTime = 15/30 
	local unlockBetList = self.gameConfig.unlockBetList
	local bonusLevelDelay = 0
	if self._mainViewCtl.bonusLevelChange then
		if self._mainViewCtl:getCurTotalBet() < self._mainViewCtl.tipBetList[unlockBetList.Collect] then
       	    bonusLevelDelay = 10/30
       	else
       	    self._mainViewCtl.bonusLevelChange = nil
       	end
	end
	local delay = bonusLevelDelay + flyToUpTime
	local isFull = false
	if self._mainViewCtl.mapLevel >= self.maxMapLevel then
		isFull = true
		delay = delay + 1
	end

	self.collectView:showCoinsFlyToUp(flyToUpTime, isFull)
	local a1 = cc.DelayTime:create(flyToUpTime)
	local a2 = cc.CallFunc:create(function ( ... )
		self.collectView:showCollectFullAnimation(isFull)
	end)
	local a3 = cc.DelayTime:create(bonusLevelDelay)
	local a4 = cc.CallFunc:create(function ( ... )
		if self._mainViewCtl.bonusLevelChange 
		and (self._mainViewCtl:getCurTotalBet() < self._mainViewCtl.tipBetList[unlockBetList.Collect]) 
		and (bonusLevelDelay > 0) then
            self._mainViewCtl.bonusLevelChange = nil
            self.collectView:setCollectPartState(false, true)
        end
	end)
	self.node:runAction(cc.Sequence:create(a1,a2,a3,a4))
	self:laterCallBack(delay, function ()
		if endFunc then
			endFunc()
		end
	end)
end
function cls:updateBonusLevel(  )
	local unlockBetList = self.gameConfig.unlockBetList
	if self._mainViewCtl.bonusLevelChange and self._mainViewCtl:getCurTotalBet() < self._mainViewCtl.tipBetList[unlockBetList.Collect] then
        self._mainViewCtl.bonusLevelChange = nil
        if self.isLockFeature then
            self.collectView:setCollectPartState(false,false)
        else
            self.collectView:setCollectPartState(false,true)
        end
    end
end
function cls:getFlyLayer()
	return self._mainViewCtl:getFlyLayer()
end
function cls:getCellPos( col, row )
	return self._mainViewCtl:getCellPos(col, row)
end
function cls:getCellNode(col, row)
	return self._mainViewCtl:getCellNode(col, row)
end
function cls:getItemList( )
	return self._mainViewCtl.item_list
end

return cls


