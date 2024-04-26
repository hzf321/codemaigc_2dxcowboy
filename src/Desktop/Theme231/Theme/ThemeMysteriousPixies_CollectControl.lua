
local parentClass = ThemeBaseCollectMapViewControl
ThemeMysteriousPixies_CollectControl = class("ThemeMysteriousPixies_CollectControl", parentClass)
local cls = ThemeMysteriousPixies_CollectControl

require (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_CollectView")) 
function cls:ctor(_mainViewCtl)
	self._mainViewCtl = _mainViewCtl

	self.node = cc.Node:create()
	self._mainViewCtl:getCurScene():addToContent(self.node)
	
	self.betFeatureVCtl = self._mainViewCtl:getBetFeatureVCtl()
	self.gameConfig = self:getGameConfig()
end

function cls:initLayout( nodesList )
	self._view = ThemeMysteriousPixies_CollectView.new(self, nodesList)
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
	if stopRet.theme_info.delta_map_info then 
		local themeMap = stopRet.theme_info.delta_map_info
		if themeMap.delta_map_points and themeMap.delta_map_points > 0 then 
			self.winCollectPoints = true
			self:getFlyCoinsData(themeMap.delta_map_pos)
		else
			self:refreshMapDataShow()
		end
	end
end

function cls:dealCollectResumeData( data )
	if data.map_info then
		self:updateMapData( data.map_info )
	end
end

function cls:hasMapData( )
	return self.mapLevel and self.mapPoints
end

function cls:updateMapData( mapInfo )
	local _c_config = self.gameConfig.collect_config

	local _mapPoints 	= mapInfo.map_points
	if _mapPoints > _c_config.max_points then
		self.mapPoints = _c_config.max_points
	elseif _mapPoints < 0 then
		self.mapPoints = 0
	else
		self.mapPoints = _mapPoints
	end

	self.mapLevel 		= mapInfo.map_level
end

---------------------------------------------------------------------------------------------------------------------------------------
-- 角标相关
function cls:getFlyCoinsData(delta_map_pos)
	self.subIconList = nil
	if delta_map_pos then
		local col_cnt = self.gameConfig.theme_config.base_col_cnt
		local row_cnt = self.gameConfig.theme_config.base_row_cnt

		local deltaPosSet = Set(delta_map_pos)
		self.subIconList = {
			{0,0,0,0,0},
			{0,0,0,0,0},
			{0,0,0,0,0},
			{0,0,0,0,0},
			{0,0,0,0,0},
		}

		for _, index in pairs(delta_map_pos) do 
			local col, row = self._mainViewCtl:getReelColAndRow( index )
			if self.subIconList[col] then 
				self.subIconList[col][row] = 1
			end
		end

		self:fixSubRet(self.subIconList)
	end
end

function cls:fixSubRet(item_list) -- 用于正常停止时的Coin数据重构
	self.resultSubCache = {}
	local isTurbo = self._mainViewCtl:getIsTrubo()
	for k,v in pairs(item_list) do
		local reelList = tool.tableClone(v)
		table.insert(reelList,1,0) -- 插入 第一条数据
		if isTurbo then
			for i=1,3 do -- 插入后面几条数据
				reelList[#reelList+1] = 0
			end
		else
			for i=1,6 do -- 插入后面几条数据
				reelList[#reelList+1] = 0
			end
		end

		table.insert(self.resultSubCache, reelList)
	end
end

function cls:updateCellStoreAssets(cell,colid)

	if (not self._mainViewCtl.lockFeatureState[self.gameConfig.unlockInfoConfig.Map]) and self.resultSubCache and #self.resultSubCache > 0 then
		local theCoinKey = table.remove(self.resultSubCache[colid], #self.resultSubCache[colid])
		self._view:updateCellStoreAssets(cell,theCoinKey,colid)
	end
end

function cls:updateCellFastStoreAssets(pCol)
	
	if self.subIconList and self.subIconList[pCol] and bole.getTableCount(self.subIconList[pCol]) > 0 then
		self._view:updateCellFastStoreAssets(pCol, self.subIconList[pCol])
	end
end

function cls:asHintTimeStore(col) 
    if self.subIconList and self.subIconList[col] then
    	self._view:addSubIconAnim(col, self.subIconList[col])
    end
end

---------------------------------------------------------------------------------------------------------------------------------------
function cls:hasCollect( ... )
	return self.winCollectPoints
end

function cls:themeInfoChangeMapData( rets, endFuc )
	self.winCollectPoints = false

	local mapInfo = rets.theme_info.map_info

	local curMapPoints  = self:getMapPoints()
	self:updateMapData(mapInfo)

	local _mapPoints 	= mapInfo.map_points

	if not self._mainViewCtl.lockFeatureState[self.gameConfig.unlockInfoConfig.Map] and _mapPoints ~= curMapPoints then
		self:showCollectProgress( rets, curMapPoints, _mapPoints, endFuc )

	else
		-- self._view:clearCellStoreSpriteByList( )
		self:refreshMapDataShow()

		if endFuc then 
			endFuc(rets)
		end

	end
end

function cls:showCollectProgress( rets, curMapPoints, _mapPoints, endFuc )
	local _c_config = self.gameConfig.collect_config

	local isFull = _mapPoints >= _c_config.max_points
	local hasWinBetF = self.betFeatureVCtl:hasWinFeature()

	if (not (isFull or hasWinBetF)) and endFuc then 
		endFuc(rets)	
	end
	
	self.node:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			self:showCoinsFlyToUp(rets) -- 显示收集动画
		end),
		cc.DelayTime:create(_c_config.fly_delay + _c_config.fly_up_time),
		cc.CallFunc:create(function ( ... )
			self:showCoinsFlyArr()

			self:showProgressAnimation(_mapPoints, curMapPoints, isFull)

			if (isFull or hasWinBetF) and endFuc then 
				endFuc(rets)
			end

		end)))
end

function cls:showProgressAnimation(map_points, curMapPoints, isFull)
	local _c_config = self.gameConfig.collect_config

	if map_points > _c_config.max_points then
		map_points = _c_config.max_points
	elseif map_points < 0 then
		map_points = 0
	end

	local oldPosY 	= _c_config.move_per_unit * curMapPoints + _c_config.progress_s_posy
	local startPos 	= cc.p(_c_config.progress_s_posx, oldPosY)
	local newPosY 	= _c_config.move_per_unit * map_points + _c_config.progress_s_posy
	local endPos 	= cc.p(_c_config.progress_s_posx, newPosY)

	self._view:playProgressMoveAnim(startPos, endPos)

	if isFull then 
		self.node:runAction(
			cc.Sequence:create(
				cc.DelayTime:create(_c_config.bar_move_time),
				cc.CallFunc:create(function ( ... )
					self:fullCollectAnimation()
				end)))
	end
end
------------------------------------------------------------------------------------
--@ 状态显示相关
function cls:updateMapDataAndShowByEndMapFeature( ... )
	if self.mapLevel >= self.gameConfig.collect_config.max_level then 
		self.mapLevel = 0
	end
	self.mapPoints = 0

	self:refreshMapDataShow()
end

function cls:refreshMapDataShow( level )
	self:setCollectProgressImagePos()
end

function cls:setCollectProgressImagePos(map_points) -- 显示 进度的点数

	local _c_config = self.gameConfig.collect_config
	
	local map_points = map_points or self:getMapPoints()

	if not map_points then return end
	
	if map_points > _c_config.max_points then
		map_points = _c_config.max_points
	elseif map_points < 0 then
		map_points = 0
	end

	local cur_posY = _c_config.move_per_unit * map_points + _c_config.progress_s_posy

	self._view:setCollectProgress(cur_posY)
end

--

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

function cls:stopCollectPartAnimation()
	self._view:removeCollectFullAnimation()
end

---------------------------------------------------------------------------------------------------------------------------------------
--@ 提示相关
-- function cls:showCollectTip( ... )
--     if self._view then 
--         self._view:showCollectTipAnim()
--     end
-- end
---------------------------------------------------------------------------------------------------------------------------------------
--@ 地图相关
function cls:refreshNotEnoughMoney()
    self._view:closeCollectAllTip()
end

function cls:onSpinStartCollect( )
	self.subIconList = nil
	self.winCollectPoints = nil
	self.resultSubCache = nil

	if self._view then
		self._view:closeCollectAllTip()
	end
end


