-- @Author: xiongmeng
-- @Date:   2020-11-12 11:18:33
-- @Last Modified by:   xiongmeng
-- @Last Modified time: 2020-12-02 13:21:43

local collectView =  require  (bole.getDesktopFilePath("Theme/KingOfEgypt_CollectView"))
local cls = class("KingOfEgypt_CollectViewControl")

function cls:ctor(mainCtl)
	self._mainViewCtl = mainCtl
	self.node = cc.Node:create()
	self._mainViewCtl:getCurScene():addToContent(self.node)
	self.gameConfig = self:getGameConfig()
	self:_initCollectData()
end
function cls:_initCollectData(  )
	local mapCollectData = self.gameConfig.collectData
	self.progressStartPosX = mapCollectData.progressStartPosX
	self.progressEndPosX = mapCollectData.progressEndPosX
	self.progressPosY = mapCollectData.progressPosY
	self.maxMapPoints = mapCollectData.maxMapPoints
	self.mapTargetLevel  = mapCollectData.maxMapLevel
	self.movePerUnit = (self.progressEndPosX - self.progressStartPosX)/self.maxMapPoints
end
function cls:initLayout( collectRoot )
	self.collectView = collectView.new(self, collectRoot)
end

--@collect pos
function cls:setCollectProgressImagePos( map_points )
	map_points = self:getCurrentPoints(map_points)
	local cur_posX = self.movePerUnit * map_points + self.progressStartPosX
	-- self.collectView:updateCollectPrImagePos(cc.p(cur_posX, self.progressPosY))
end
function cls:showProgressAnimation( oldMapPoint, collect_points, isFull )
	oldMapPoint = self:getCurrentPoints(oldMapPoint)
	collect_points = self:getCurrentPoints(collect_points)
	self.collectView:showProgressAnimation(oldMapPoint, collect_points, isFull)
end

function cls:showCollectFullAnimation()
	self.collectView:showCollectFullAnimation()
end
function cls:getCurrentPoints( map_points )
	if map_points > self.maxMapPoints then
	    map_points = self.maxMapPoints
	elseif map_points < 0 then
	    map_points = 0
	end
	return map_points
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
--@collect unlock
function cls:collectBtnClickEvent(  )
	if not self.isLockFeature then
        return nil
    end
    local unLockBetList = self.gameConfig.unlockBetList
    self._mainViewCtl:featureUnlockBtnClickEvent(unLockBetList["Collect"])
end
--@changeBet
function cls:changeCollectBet( theBet )
	if self:getGoldSpinStatus() then 
		return
	end
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
		if self.collectView then
			self.collectView:setCollectPartState(isLock, true)
		end
	end
end
function cls:checkCollectBtnCanTouch( ... )
	return self._mainViewCtl:featureBtnCheckCanTouch()
	-- return self._mainViewCtl:getCanTouchFeature()
end

function cls:collectStopCtl( stopRet )
	local themeInfo = stopRet.theme_info
	-- if self._mainViewCtl:getCurrentBase() and themeInfo and 
	-- 	themeInfo["delta_map_points"] and themeInfo["delta_map_points"] > 0  then
	-- 		self.winCollectPoints = themeInfo["delta_map_points"]
	-- 		self.newAllCollectPoints = self.winCollectPoints + self._mainViewCtl.mapPoints
	-- 		-- 判断是否存在特殊的feature
	-- 		if self.newAllCollectPoints >= self.maxMapPoints then
	-- 			self._mainViewCtl.mapLevel = self._mainViewCtl.mapLevel + 1
	-- 			if self._mainViewCtl.mapLevel >= self.mapTargetLevel then
	-- 				self._mainViewCtl.mapLevel = self.mapTargetLevel
	-- 			end
	-- 		end
	-- end
	if self._mainViewCtl:getCurrentBase() then
		if themeInfo and themeInfo["delta_map_points"] and (themeInfo["delta_map_points"] > 0) then
			self.winCollectPoints = themeInfo["delta_map_points"]
		end
		if themeInfo and themeInfo["map_info"] then
			self.newAllCollectPoints = themeInfo["map_info"]["map_points"]
			self._mainViewCtl.mapLevel = themeInfo["map_info"]["map_level"]
			self._mainViewCtl.preMapStatus = themeInfo["map_info"]["pre_free_status"]
			self._mainViewCtl.newMapStatus = themeInfo["map_info"]["cur_free_status"]
			if self.newAllCollectPoints >= self.maxMapPoints then 
				self.winCollectPoints = 1
			end
		end
	end
end
function cls:checkHasFeatureCollect( ... )
	local hadCollect = false
	if self:getGoldSpinStatus() then 
		return hadCollect
	end
	if self.winCollectPoints then
		if self.winCollectPoints > 0 then
			hadCollect = true
		end
	end
	if not hadCollect then
		self:updateBonusLevel()
	end
	self.winCollectPoints = 0
	return hadCollect
end
function cls:collectCollectionStrips( rets, endFunc)
	local flyToUpTime = 23/30 
	local unlockBetList = self.gameConfig.unlockBetList
	local bonusLevelDelay = 0
	if self._mainViewCtl.bonusLevelChange then
		if self._mainViewCtl:getCurTotalBet() < self._mainViewCtl.tipBetList[unlockBetList.Collect] then
       	    bonusLevelDelay = 10/30
       	else
       	    self._mainViewCtl.bonusLevelChange = nil
       	end
	end
	local delay = bonusLevelDelay
	local isFull = false
	local oldMapPoints = self._mainViewCtl.mapPoints
	local mapPoints = self.newAllCollectPoints

	self.winCollectPoints = 0
	if mapPoints > self.maxMapPoints then
		isFull = true
		mapPoints = self.maxMapPoints
		delay = delay + 1
	end
	self._mainViewCtl.mapPoints = mapPoints

	local a1 = cc.CallFunc:create(function ( ... )
		self.collectView:showCoinsFlyToUp(flyToUpTime)
	end)
	local a2 = cc.DelayTime:create(flyToUpTime)
	local a3 = cc.CallFunc:create(function ( ... )
		self.collectView:showProgressAnimation(oldMapPoints, mapPoints, isFull)
	end)
	local a4 = cc.DelayTime:create(bonusLevelDelay)
	local a5 = cc.CallFunc:create(function ( ... )
		if self._mainViewCtl.bonusLevelChange and (self._mainViewCtl:getCurTotalBet() < self._mainViewCtl.tipBetList[unlockBetList.Collect]) and (bonusLevelDelay > 0) then
            self._mainViewCtl.bonusLevelChange = nil
            self.collectView:setCollectPartState(false, true)
        end
	end)

	self.node:runAction(cc.Sequence:create(
		a1,a2,a3,a4,a5
		))
	local a11 = cc.DelayTime:create(delay)
	local a22 = cc.CallFunc:create(function ( ... )
		if endFunc then
			endFunc()
		end
	end)
	local a33 = cc.Sequence:create(a11, a22)
	self.node:runAction(a33)
end
function cls:updateBonusLevel(  )
	if self:getGoldSpinStatus() then 
		return
	end
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

function cls:getGoldSpinStatus()
	return self._mainViewCtl:getGoldSpinStatus()
end

function cls:getGameConfig( ... )
	return self._mainViewCtl.gameConfig
end
function cls:getSpineFile( file_name )
	return self._mainViewCtl:getSpineFile(file_name)
end
function cls:playMusicByName( name, singleton, loop )
	self._mainViewCtl:playMusicByName(name, singleton, loop)
end
function cls:getFntFilePath( file_name )
	return self._mainViewCtl:getFntFilePath(file_name)
end
function cls:getFlyLayer( ... )
	return self._mainViewCtl.mainView:getFlyLayer()
end
function cls:getCellPos( col, row )
	return self._mainViewCtl:getCellPos(col, row)
end
function cls:getParticleFile( file_name )
	return self._mainViewCtl:getParticleFile(file_name)
end
function cls:getItemList( ... )
	return self._mainViewCtl.item_list
end

return cls

