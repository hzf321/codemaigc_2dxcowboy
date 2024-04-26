

ThemeGoldRush_CollectControl = class("ThemeGoldRush_CollectControl", ThemeBaseViewControlDelegate)
local cls = ThemeGoldRush_CollectControl

require (bole.getDesktopFilePath("Theme/ThemeGoldRush_CollectView")) 

function cls:ctor(_mainViewCtl)
	self._mainViewCtl = _mainViewCtl

	self.node = cc.Node:create()
	self._mainViewCtl:getCurScene():addToContent(self.node)

	self.gameConfig = self:getGameConfig()
end

function cls:initLayout( nodesList )
	self._view = ThemeGoldRush_CollectView.new(self, nodesList)
end

function cls:checkUnlockBtnCanTouch()
	return self._mainViewCtl:featureBtnCheckCanTouch()
end

function cls:unlockBtnClickEvent(_jptype)
	self._mainViewCtl:featureUnlockBtnClickEvent(_jptype)
end

function cls:checkFeatureIsLock( ftype )
	return self._mainViewCtl:checkFeatureIsLock( ftype )
end

function cls:changeCollectLockState(shouUnlock)
	self._view:changeCollectLockState(shouUnlock)
end

function cls:resetBoardShowByFeature( state )
	self._view:resetBoardShowByFeature(  state )
end

---------------------------------------------------------------------------------------------------------------------------------------
function cls:collectMapStopCtl( stopRet )
	if stopRet.theme_info and stopRet.theme_info.map_info then
		self.mapInfo = stopRet.theme_info.map_info

		self.mapLevel = stopRet.theme_info.map_info.map_level
		-- self.mapAvgBet = stopRet.theme_info.map_info.avg_bet
	end
end

function cls:dealCollectResumeData( data )
	if data.map_info then
		self.mapInfo = data.map_info

		self.mapLevel = data.map_info.map_level
		-- self.mapAvgBet = data.map_info.avg_bet
	end
end
---------------------------------------------------------------------------------------------------------------------------------------
--@ 状态显示相关
function cls:hasMapData( mapInfo )
	return self.mapLevel
end

function cls:updateMapDataAndShowByEndMapFeature( ... )
	if self.mapLevel >= self.gameConfig.collect_config.max_level then 
		self.mapLevel = 0
	end

	self:refreshMapDataShow(self.mapLevel)
end

function cls:refreshMapDataShow( level )
	
	level = level or self.mapLevel
	if level < 0 then 
		level = 0
	end
	
	self._view:setCollectProgress( level )
end

function cls:showCollectProgress( list )
	local _c_config = self.gameConfig.collect_config
	local isSuper = self.mapLevel >= _c_config.max_level
	local isMega = _c_config.mega_level_set[self.mapLevel]
	local delay = isSuper and (_c_config.fly_up_time +  _c_config.full_time ) or _c_config.fly_up_time

	local endPosN = self._view:getMapLevelPos(self.mapLevel)

	self:refreshMapDataShow(self.mapLevel - 1 )

	self.node:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			self:showCoinsFlyToUp(list, endPosN) -- 显示收集动画
		end),
		cc.DelayTime:create(_c_config.fly_up_time),
		cc.CallFunc:create(function ( ... )
			
			if isMega then 
				self:playMusicByName("mega_bonus")
			elseif isSuper then 
				self:playMusicByName("super_bonus")
			else
				self:playMusicByName("lucky_clover_free_games") 
				self:showCoinsFlyArr(endPosN)
			end

			self:refreshMapDataShow(self.mapLevel)

			

			if isSuper then 
				self:fullCollectAnimation()
			end
		end)))
	return delay
end

function cls:showCoinsFlyToUp(list, endPosN)
	self._view:showCoinsFlyToUp(list, endPosN)
end

function cls:showCoinsFlyArr(endPosN)
	self._view:showCoinsFlyArr(endPosN)
end
---------------------------------------------------------------------------------------------------------------------------------------
-- @ 集满动画
function cls:fullCollectAnimation()
	self:playMusicByName("collect_full")

	self._view:addfullCollectAnim()
end

---------------------------------------------------------------------------------------------------------------------------------------
--@ 提示相关
function cls:showCollectTip( ... )
    if self._view then 
        self._view:showCollectTipAnim()
    end
end
---------------------------------------------------------------------------------------------------------------------------------------
--@ 地图相关
function cls:refreshNotEnoughMoney()
    self._view:closeCollectTip()
end

function cls:onSpinStartCollect( )
	if self._view then
		self._view:closeCollectTip()
	end
end


