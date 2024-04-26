--[[
Author: xiongmeng
Date: 2020-12-07 19:41:03
LastEditors: xiongmeng
LastEditTime: 2021-01-08 17:35:07
Description: 
--]]

local parentClass = ThemeBaseViewControlDelegate
local cls = class("KingOfEgypt_MapViewControl", parentClass) 
-- local _mapView =  require  (bole.getDesktopFilePath("Theme/KingOfEgypt_MapView")) 

function cls:ctor( _mainViewCtl )
	parentClass.ctor(self, _mainViewCtl)
	self.gameConfig = self:getGameConfig()
end

function cls:getMapConfig()
	if not self.mapConfig then
		self.mapConfig = self.gameConfig.map_config
	end
	return self.mapConfig
end

function cls:getMapTargetLevel()
	if not self.mapTargetLevel then
		local mapConfig = self:getMapConfig()
		self.mapTargetLevel = mapConfig.buildingLevel
	end
	return self.mapTargetLevel
end

function cls:initLayout( mapParent, data )
	self:updateMapData(data)
	-- self.mapView = _mapView.new(self, mapParent)
end
function cls:updateMapData( data )
	self.data = data or self.data
	if data then
		self.mapLevel = data.mapLevel
		self.preMapStatus = data.preMapStatus
		self.curMapStatus = data.curMapStatus
		if self.mapLevel > self:getMapTargetLevel() then
			self.mapLevel = self:getMapTargetLevel()
		end
	end
	-- self._mainViewCtl.mapLevel = self.mapLevel + 1
end
function cls:showMapScene( fromClick, isAnimate, fromBonus )
	self.isOpenMapStatus = true
	self._mainViewCtl:hideActivitysNode()
	self._mainViewCtl:setFooterBtnsEnable(false)
	self._mainViewCtl:setFeatureState(self.gameConfig.FeatureName.OpenMap, true)-- self._mainViewCtl:enableMapInfoBtn(false)
	-- showActivitysNode
	self._mainViewCtl:stopDrawAnimate()
	if fromClick or fromBonus then
		self:playMusicByName("map_open")
	end
	-- 有个展示的过程
	self:updateMapData(self._mainViewCtl:getMapInfoData())
	if fromClick then
		self.mapView:setMapPosition(self.mapLevel)
		self.mapView:setUserIconPosition(self.mapLevel)
	elseif fromBonus then
		local nextBuildLevel = self:getPickLevelConfig()
		self.mapView:setMapPosition(nextBuildLevel)
		self.mapView:setUserIconPosition(self.mapLevel)
	else
		self.mapView:setMapPosition(self.mapLevel-1)
		self.mapView:setUserIconPosition(self.mapLevel-1)
	end
	self.mapView:updateMapBuilding(isAnimate)
	self.mapView:showMapAni(fromClick, isAnimate, fromBonus)
end
function cls:exitMapScene( isAnimate, fromBonus )
	self.mapView:hideMapAni(isAnimate, fromBonus)
	self.isOpenMapStatus = false
end
function cls:checkInFeature(  )
    local inFeature = false
    if self.isOpenMapStatus then
        inFeature = true
    end
    return inFeature
end
function cls:onSpinStart( ... )
	if self:checkInFeature() then
		self:exitMapScene(true)
	end
end
-- 当前的level,是否是完成的情况
function cls:getPreBigBuildStatus(level)
	if self.preMapStatus and #self.preMapStatus >= level then
		local decNum = self.preMapStatus[level]
		return decNum
	end
	return 0
end
function cls:getCurBigBuildStatus()
	return self.curMapStatus
end
function cls:getPickLevelConfig()
    local level = self.mapLevel
    local map_booster_config = self.gameConfig.map_config.map_booster_config
    local nextIndex = 0
    for key, val in ipairs(map_booster_config) do
        if level <= val then
            nextIndex = val
            break
        end
	end
	return nextIndex
end
function cls:getBoosterNums(buildStatus)
	local nums = 0
	if buildStatus and #buildStatus > 0 then 
		for key, val in ipairs(buildStatus) do
            if val > 0 then 
                nums = nums + 1
            end
        end
	end
	return nums
end
function cls:getStickNums(mapLevel)
	mapLevel = mapLevel or self.mapLevel
	if mapLevel < 50 then
		return 1
	elseif mapLevel <= 77 then
		return 2
	else
		return 3
	end
end
function cls:getAllWinsMul(mapLevel)
	mapLevel = mapLevel or self.mapLevel
	if mapLevel < 50 then
		return 2
	elseif mapLevel <= 77 then
		return 3
	else
		return 4
	end	
end
-- function cls:setMapPosition( ... )
-- 	-- body
-- end
function cls:getSpineFile( name )
	return self._mainViewCtl:getSpineFile(name)
end
-- function cls:getPic( name )
-- 	self._mainViewCtl:getPic(name)
-- end

return cls