


local parentCls = ThemeBaseView
ThemeGoldRush_MainView = class("ThemeGoldRush_MainView", parentCls)
local cls = ThemeGoldRush_MainView

function cls:ctor( ctl )
	self._mainViewCtl = ctl
	self.gameConfig = self._mainViewCtl:getGameConfig()
	parentCls.ctor(self, ctl)

end

--------------------------------------------------------------------------------------------------------------
-- @ csb 界面初始化
function cls:initScene()

	self:_initBaseNode()

	self:_initJackpotNode() -- 初始化jackpot

	self:_initCollectFeatureNode() -- 收集相关
	
	self:_initFreeGameNode()

	self:_initLogoNode()
end

function cls:_initBaseNode( ... )
	local path = self._mainViewCtl:getCsbPath("base")

	self.mainThemeScene = cc.CSLoader:createNode(path)
	self.down_node 		= self.mainThemeScene:getChildByName("down_node")
	self.down_child 	= self.down_node:getChildByName("down_node")

	self.bgRoot 		= self.mainThemeScene:getChildByName("theme_bg")
	self.baseBg 		= self.bgRoot:getChildByName("base")
	self.freeBg 		= self.bgRoot:getChildByName("free")
	self.superBg 		= self.bgRoot:getChildByName("super")
	self.baseBg:setVisible(true)
	self.curBg = self.baseBg
	self.freeBg:setVisible(false)
	self.superBg:setVisible(false)
	
	self.reelRoot 			= self.down_child:getChildByName("reel_root_node")
	self.reelBg 			= self.reelRoot:getChildByName("reel_bg")
	self.reelParent 		= cc.Node:create()
	self.reelRoot:addChild(self.reelParent, 10)

	self.boardAniParent 	= self.down_child:getChildByName("base_root")
	self.boardAniParent2 	= self.down_child:getChildByName("top_root")
	self.reelBgAnimNode 	= self.boardAniParent:getChildByName("board_bg")
	self.boardRoot 			= self.boardAniParent:getChildByName("board_root")
	self.boardRoot:setLocalZOrder(10)
	self.animateNode 		= self.boardAniParent:getChildByName("animate")
	self.animateNode:setLocalZOrder(20)
	self.scatterAnimNode 	= self.boardAniParent:getChildByName("scatter_anim_node")
	self.scatterAnimNode:setLocalZOrder(30)

	self.collectFlyNode 	= self.boardAniParent2:getChildByName("fly_node")
	self.collectFlyNode:setLocalZOrder(40)
	self.reelNotifyNode 	= self.boardAniParent2:getChildByName("reel_notify")

	self.classicBoardRoot 	= self.boardAniParent:getChildByName("classic_board_list")
	self.classicBoardList 	= self.classicBoardRoot:getChildren()

	self.featureDialogDimmer = self.mainThemeScene:getChildByName("dialog_dimmer")
	self.featureDialogDimmer:setVisible(false)

	-- jp
	self.jpRoot = self.down_child:getChildByName("jp_root")
	self.jpNode = self.jpRoot:getChildByName("jp_node")
	self.classicTipNode = self.jpRoot:getChildByName("classic_tip_node")

	-- classic
	self.miniRoot = self.down_child:getChildByName("mini_root")

	bole.adaptScale(self.mainThemeScene,false)
	-- bole.adaptReelBoard(self.down_node)
	bole.adaptBottomHorizontal(self.down_node)
	self.shakyNode:addChild(self.mainThemeScene)

	local baseBGSize = self.baseBg:getContentSize()
	local _, s = bole.addSpineAnimationInTheme(self.baseBg, nil, self._mainViewCtl:getSpineFile("base_bg"), cc.p(baseBGSize.width/2, baseBGSize.height/2), "animation", nil, nil, nil, true, true)
	s:setScale(0.8)

	local _,b1 = bole.addSpineAnimationInTheme(self.freeBg, nil, self._mainViewCtl:getSpineFile("free_bg"), cc.p(baseBGSize.width/2, baseBGSize.height/2), "animation1", nil, nil, nil, true, true)
	b1:setScale(0.8)
	
	local _,b2 = bole.addSpineAnimationInTheme(self.superBg, nil, self._mainViewCtl:getSpineFile("free_bg"), cc.p(baseBGSize.width/2, baseBGSize.height/2), "animation2", nil, nil, nil, true, true)
	b2:setScale(0.8)

	bole.addSpineAnimationInTheme(self.reelBg, nil, self._mainViewCtl:getSpineFile("reel_loop"), cc.p(0, 0), "animation", nil, nil, nil, true, true)
	

	local jp_top_anim = self.jpRoot:getChildByName("top_animate")
	
	-- self:initChestEvent()
end

------------------------------------------------------------------------------------------------------------------------------------------------
function cls:initChestEvent( ... )

	local touchFunc1 = function ( ... )
		self.isChest = true
		self.chestBoardIndex = (self.chestBoardIndex or 0) + 1
		self._mainViewCtl:changeSpinBoard("FreeSpin")
	end
	local touchFunc2 = function ( ... )
		self.chestBoardIndex = 0
		self._mainViewCtl:changeSpinBoard("Normal")
	end

	self.funcList = {
		touchFunc1, touchFunc2
	}
	self.touchBtnList = {}
	local baseY = 243
	for i = 1, 2 do
		local touchBtn = Widget.newButton(self.funcList[i], "theme225_baes_map_light_2.png", "theme225_baes_map_dark_2.png", "theme225_baes_map_dark_2.png", true) --10
		self.touchBtnList[i] = touchBtn
		touchBtn:setPosition(550, baseY + (-50*(i-1)))
		self.mainThemeScene:addChild(touchBtn, 200)
	end
end

function cls:getChestBoardCount()
	local boardCountList = self.gameConfig.free_config.board_count

	self.chestBoardIndex = (self.chestBoardIndex - 1) % (#boardCountList) + 1
	local boardCount = boardCountList[self.chestBoardIndex]
	return boardCount
end
-----------------------------------------------------------------------------------------------------------------------------------

function cls:_initJackpotNode( ... )

	local jackpotNode = self:getSpecialFeatureRoot("jackpot") 
	if bole.isValidNode(jackpotNode) then 
	    self._mainViewCtl:getJpViewCtl():initLayout(jackpotNode)
	end
end

function cls:_initCollectFeatureNode( )
	local nodesList = self:getSpecialFeatureRoot("collect") 
	if nodesList then 
	    self._mainViewCtl:getCollectViewCtl():initLayout(nodesList)
	end
end

function cls:_initFreeGameNode(  )
	local nodesList = self:getSpecialFeatureRoot("free") 
	if nodesList then 
	    self._mainViewCtl:getFreeVCtl():initLayout(nodesList)
	end
end

function cls:_initLogoNode( ... )
	self.longLogoNode = self.down_child:getChildByName("long_logo_node")

	if bole.isWidescreen() then 
		self.longLogoNode:setVisible(true)
        
		bole.addSpineAnimationInTheme(self.longLogoNode, nil, self._mainViewCtl:getSpineFile("logo_name"), cc.p(0, 390), "animation", nil, nil, nil, true, true)
		-- bole.adaptTop(self.longLogoNode, -0.2)
    else
		self.longLogoNode:setVisible(false) 
	end
	
end

function cls:getSpecialFeatureRoot( rType )
	if rType == "jackpot" then 
		return self.jpNode

	elseif rType == "collect" then 
		return {self.down_child:getChildByName("feature_node"), self.collectFlyNode} -- , tip_node, tip_btn

	elseif rType == "mini_slot" then 
		local jp_top_anim = self.jpRoot:getChildByName("top_animate")
		return {self.miniRoot, self.classicBoardRoot, self.classicTipNode, self.animateNode, self.boardAniParent, jp_top_anim }

	elseif rType == "free" then 
		local freeNode = self.down_child:getChildByName("free_tip_node")
		return {freeNode, self.collectFlyNode}
		
	end
end

----------------------------------------------------------------------

function cls:getShakyNode( ... )
	return self.shakyNode
end

function cls:resetBoardShowNode( pType , boardCnt )
	local board_type_config = self.gameConfig.SpinBoardType

	local boardType = board_type_config[pType]
	
	
	local spinLayerType =( boardType == board_type_config.Normal or boardType == board_type_config.Bonus) and 0 or boardCnt
	self:changeSpinLayerState(spinLayerType, boardType)
    self:changeSpinLayerByType(spinLayerType) -- base he  free  走这个逻辑，bonus 小老虎机单独走逻辑
	self:resetBoardCntShow(boardType == board_type_config.Normal and 0 or boardCnt)

    self.jpRoot:setScale(1)
	self.jpRoot:setPosition(cc.p(-2, 0))

    local showBg
    if boardType == board_type_config.Normal then -- normal情况下 需要更改棋盘底板
    	self.miniRoot:setVisible(false)
    	self.classicTipNode:setVisible(false)
    	self.reelBg:setVisible(true)

    	showBg = self.baseBg

    elseif boardType == board_type_config.FreeSpin or boardType == board_type_config.SFree1 or boardType == board_type_config.SFree2 then
    	self.miniRoot:setVisible(false)
    	self.classicTipNode:setVisible(false)
    	self.reelBg:setVisible(false)
    	showBg = self.freeBg

    	self:resetBoardCellsByNormal()

    	if boardType ~= board_type_config.FreeSpin then 
    		showBg = self.superBg
    	end
    elseif boardType == board_type_config.Bonus then 
    	self.miniRoot:setVisible(true)
    	self.classicTipNode:setVisible(true)
    	self.reelBg:setVisible(true)

    	self.jpRoot:setScale(0.94)
		self.jpRoot:setPosition(cc.p(23, 18))

    end

    if showBg then 
		if self.curBg ~= showBg then 
			self.curBg:setVisible(false)
			showBg:setVisible(true)
			self.curBg = showBg
		end
    end
end

function cls:resetBoardCntShow( boardType )
	if boardType == self.gameConfig.SpinBoardType.Bonus then return end
	
	boardType = boardType or 0

	local boardCfg = self.gameConfig.board_config[boardType]
	local board_pos = boardCfg.board_pos
	local board_scale = boardCfg.scale

	self.reelParent:removeAllChildren()
	local path = self._mainViewCtl:getCsbPath("board")

	for _, pos in pairs(board_pos) do 
		local _reel = cc.CSLoader:createNode(path)
		_reel:setPosition(pos)

		-- if boardType == self.gameConfig.SpinBoardType.Normal then 
		-- 	bole.addSpineAnimationInTheme(_reel, nil, self._mainViewCtl:getSpineFile("reel_loop"), cc.p(0, 0), "animation", nil, nil, nil, true, true)
		-- end

		self.reelParent:addChild(_reel)
	end

	self:changeFeatureAnimNodeScale(board_scale)
end

function cls:changeFeatureAnimNodeScale(scale)
	self.reelRoot:setScale(scale)
	self.boardAniParent:setScale(scale)
	self.boardAniParent2:setScale(scale)
end

--------------------------------------------------------------------------------------------------------------

function cls:getBoardNodeList( ... )
	return self.boardNodeList
end

function cls:initSpinLayer( )
	self.spinLayerList = {}
	local _boardNodeList = self:getBoardNodeList()
	if _boardNodeList then 
		for index, cofig in pairs(_boardNodeList) do
			self.initBoardIndex = index
			local boardNode = _boardNodeList[index]
			local layer = SpinLayer.new(self._mainViewCtl, self._mainViewCtl, boardNode.reelConfig, boardNode)
			layer:DeActive()
			self.shakyNode:addChild(layer,-1)
			self.spinLayerList[index] = layer
		end
		self.initBoardIndex = nil

		self.spinLayer = self.spinLayerList[0]
		self.spinLayer:Active()
		self:changeSpinLayerByType(0)
	end
end
---------------------------------------------------------------------------
function cls:showFeatureBoardDimmer( dType, state )
	if dType == "board" then 
		self:dialogPlayLineAnim(state, self.reelBoardDimmer, nil, 150)
	elseif dType == "random" then 
		self:dialogPlayLineAnim(state, self.featurDimmer)
	elseif dType == "down_child" then 
		self:dialogPlayLineAnim(state, self.dialogDimmerDownChild)
	elseif dType == "scene" then 
		self:dialogPlayLineAnim(state, self.featureDialogDimmer)
	end
end

----------------------------------------------------------------------------------------------------------------------------------
--@ cell 相关

function cls:adjustWithTheCellSpriteUpdate( theCellNode, key, col ) -- 删除掉 tip 动画
	parentCls.adjustWithTheCellSpriteUpdate(self, theCellNode, key, col)

	if bole.isValidNode(theCellNode.tipNode2) then 
		theCellNode.tipNode2:removeAllChildren()
	end
end

function cls:createCellSprite(key, col, rowIndex)

	local theCellNode   = cc.Node:create()

	local _symbol_config = self.gameConfig.symbol_config
	local notInitSymbolSet = _symbol_config.not_init_symbol_set or {}
	if notInitSymbolSet[key] or key > _symbol_config.scatter_config.scatter_add then 
		key = self._mainViewCtl:getNormalKey()
	end

	if self.initBoardIndex > self.gameConfig.classic_config.start_idx then 
		local classic_reel = self.gameConfig.classic_config.random_reel
		key = classic_reel[math.random(1, table.nums(classic_reel))]
		key = self:getNormalKeyInBonus( key, self.initBoardIndex )
	end

	local theCellFile = self._mainViewCtl.pics[key]

	if not theCellFile then 
		print("whj: key, theCellFile",  key, theCellFile)
	end
	
	local theCellSprite = bole.createSpriteWithFile(theCellFile)
	theCellNode:addChild(theCellSprite)
	theCellNode.key 	  = key
	theCellNode.sprite 	  = theCellSprite
	theCellNode.curZOrder = 0

	local tipNode = cc.Node:create()
	theCellNode:addChild(tipNode, 2)
	theCellNode.tipNode = tipNode

	local tipNode2 = cc.Node:create()
	theCellNode:addChild(tipNode2, 20)
	theCellNode.tipNode2 = tipNode2

	local up = cc.Node:create()
	theCellNode:addChild(up, 10)
	theCellNode.up = up

	bole.setEnableRecursiveCascading(theCellNode, true)

	------------------------------------------------------------
	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )
	local theKey = theCellNode.key
	if self._mainViewCtl.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self._mainViewCtl.symbolZOrderList[theKey]
	end
	if self._mainViewCtl.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self._mainViewCtl.symbolPosAdjustList[theKey])
	end
	return theCellNode
end

function cls:getNormalKeyInBonus( oldKey, boardIndex )
	local key = oldKey
	local boardIndex = boardIndex or 10
	if boardIndex > self.gameConfig.classic_config.start_idx then 
		local classic_reel = self.gameConfig.classic_config.random_reel
		local classic_reel_set = Set(classic_reel)
		local jp_s_list = self.gameConfig.classic_config.jp_s_list
		local jp_s_set = Set(jp_s_list)

		if not classic_reel_set[oldKey] then 
			if oldKey == self.gameConfig.special_symbol.kong then
				key = oldKey
			else
				key = classic_reel[math.random(1, table.nums(classic_reel))]
			end
		end

		if jp_s_set[key] then 
			local bonus_level = boardIndex - self.gameConfig.classic_config.start_idx
			if bonus_level < 1 then 
				bonus_level = 1
			elseif bonus_level > 3 then 
				bonus_level = 3
			end
			key = jp_s_list[bonus_level]
		end
	end

	return key
end
function cls:updateCellSprite(theCellNode, key, col, isShowResult, isReset, isNotChange)
	
	if bole.isValidNode(theCellNode.up) then  -- 重新创建label
		theCellNode.up:removeAllChildren()
		theCellNode.up:setVisible(true)
	end

	if self.bonusBoardIndex then
		key = self:getNormalKeyInBonus(key, self.bonusBoardIndex)
	end

	local theCellFile = self._mainViewCtl.pics[key]

	local keyData = self._mainViewCtl:checkUpdateSymbolKey(key)
	if keyData then 
		key = keyData.fileKey
		theCellFile = self._mainViewCtl.pics[keyData.fileKey]

		if keyData.has_scatter then 
			local multiSp = bole.createSpriteWithFile("#theme225_s_8.png")
			multiSp:setPosition(keyData.scatter_pos or cc.p(0,0))
			if not bole.isValidNode(theCellNode.up) then 
				theCellNode.up = cc.Node:create()
				theCellNode:addChild(theCellNode.up, 10)
			end

			theCellNode.up:addChild(multiSp)
		end
	end

	if not theCellFile then 
		print("whj: key, theCellFile", key, theCellFile)
	end

	local theCellSprite = theCellNode.sprite
	bole.updateSpriteWithFile(theCellSprite, theCellFile)
	theCellNode.key 	  = key
	theCellNode.curZOrder = 0

	------------------------------------------------------------
	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col, isShowResult, isReset )	

	local theKey = theCellNode.key
	local scatter_config = self.gameConfig.symbol_config.scatter_config
	if theKey > scatter_config.scatter_add and self._mainViewCtl.symbolZOrderList[scatter_config.scatter_key] then
		theCellNode.curZOrder = self._mainViewCtl.symbolZOrderList[scatter_config.scatter_key]
	end	
	theCellSprite:setAnchorPoint(cc.p(0.5, 0.5))
	if self._mainViewCtl.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self._mainViewCtl.symbolPosAdjustList[theKey])
	else
		theCellSprite:setPosition(cc.p(0,0))
	end	
end

function cls:changeCellSpriteByPos( col, row, key )
	local cell = self:getCurSpinLayer().spins[col]:getRetCell(row)
	self:updateCellSprite(cell, key, col, true, true, true)
	cell.sprite:setVisible(true)
	cell:setVisible(true)
end
--@刷新牌面
-- function cls:resetBoardCellsByItemList(_itemList)
-- 	if _itemList then 
-- 		for col, colList in pairs(_itemList) do
-- 			for row, itemKey in pairs(colList) do
-- 				local cell = self.spinLayer.spins[col]:getRetCell(row)
-- 				self:updateCellSprite(cell, itemKey, col, true, true)
-- 			end
-- 		end
-- 	end

-- end

-- function cls:resetBoardCellsByNormal( ... )
-- 	for col, reel in pairs(self.spinLayer.spins) do
-- 		for row, cell in pairs(reel.cells) do 
-- 			local key = self._mainViewCtl:getNormalKey()
-- 			self:updateCellSprite(cell, key, col, true, true, true)
-- 		end
-- 	end
-- end

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--@动画相关
function cls:drawPayLineItem(reel, row, specials, itemList, effectStatus, tipIndex,parent)
	local sprite = cc.Sprite:create()
	sprite:setPosition(self._mainViewCtl:getCellPos(reel,row))
	local tt 		= itemList[reel][row]
	local action    = self:getItemAnimate(tt, reel, row, effectStatus,parent) -- 获得相应动画
	if action then	
		local s = self.spinLayer.spins[reel]:getRetCell(row) -- 获得相应位置 
		s:setCascadeOpacityEnabled(true) -- 子节点透明度随父节点变化
		if type(action) == "table" then
			local i = action[2]
			s = s:getChildren()[i]
			action = action[1]
		end
		s:runAction(action)
	end
	self:playCellRoundEffect(sprite, tt, reel, row, effectStatus) -- 播放中奖连线 调用每个主题本身的方法, 直接播放spine 动画来实现
	return sprite
end

function cls:getItemAnimate(item, col, row, effectStatus,parent)
	local spineItemsSet = Set({ 
		1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	})

	local itemData = self._mainViewCtl:checkUpdateSymbolKey(item)

    if (itemData and spineItemsSet[itemData.fileKey]) or spineItemsSet[item] then 
		if effectStatus == "all_first" then
			self:playItemAnimation(item, col, row, parent)
		else
			self:playOldAnimation(col,row)
		end
		return nil
	else
		return self:getItemAnimateScale_120(item)
	end
end


function cls:playItemAnimation(item, col, row, parent) -- 修改这个方法，让有动画的symbol 在animationNode上面播放动画
	local animateName = "animation"
	local itemData = self._mainViewCtl:checkUpdateSymbolKey(item, true)
	local fileName = itemData and itemData.fileKey or item

	local cell = self.spinLayer.spins[col]:getRetCell(row)
	local pos		= self._mainViewCtl:getCellPos(col,row)
	local spineFile = self._mainViewCtl:getPic("spine/item/" .. fileName .. "/spine")

	local _, s1	= bole.addSpineAnimationInTheme(parent, row, spineFile, pos, animateName, nil, nil, nil, true)

	self.animNodeList = self.animNodeList or {}
	 
	self.animNodeList[col.."_"..row] = {}
	self.animNodeList[col.."_"..row][1] = s1 
	self.animNodeList[col.."_"..row][2] = animateName

	if itemData and itemData.has_scatter then 
		self:playSpecialSymbolAnim(s1, itemData.key, self.gameConfig.symbol_config.anim_suffix.loop, nil, nil, true)
	end

	cell:setVisible(false) -- cell.sprite:setVisible(false)
end

function cls:playOldAnimation(col,row)
	self.animNodeList = self.animNodeList or {}
	if self.animNodeList[col.."_"..row] then 
		local temp = self.animNodeList[col.."_"..row]
		local node = temp[1]
		local animationName = temp[2]

		if bole.isValidNode(node) and animationName then 
			bole.spChangeAnimation(node, animationName, false)
		end

		local node2 = temp[3]
		local animationName2 = temp[4]

		if bole.isValidNode(node2) and animationName2 then 
			bole.spChangeAnimation(node2, animationName2, false)
		end
	end
end

function cls:addReelNotifyEffectAnim( pos, spineFile, _addName, a_name )
	local _, s1 = bole.addSpineAnimationInTheme(self.reelNotifyNode, 20, spineFile, pos, "animation".._addName, nil, nil, nil, true, true) -- , true
	local p1
	if a_name == "scatter" then 
		p1 = bole.createSpriteWithFile("#theme225_baes_13.png")
		p1:setPosition(pos)
		p1:setScale(2.05)
		self.reelBgAnimNode:addChild(p1)
	end

	return s1, p1
end

function cls:stopDrawAnimate() -- 可能存在 手动调用的可能
	if bole.isValidNode(self.scatterAnimNode) then 
		self.scatterAnimNode:removeAllChildren()
		self.reelNotifyNode:removeAllChildren()
		-- self.collectFlyNode:removeAllChildren()
		
		self.animNodeList = nil

		parentCls.stopDrawAnimate(self)

		self:clearBGEffect()
	end

end

function cls:stopChildActionsSpecial(cellNode)
	if cellNode and bole.isValidNode(cellNode.up) then 
		cellNode.up:setVisible(true)
	end
end

function cls:addItemSpine(item, col, row, isLoop)
	local layer			= self.scatterAnimNode
	local animName		= "animation"..self.gameConfig.symbol_config.anim_suffix.win
	local pos			= self._mainViewCtl:getCellPos(col, row)
	local spineFile		= self._mainViewCtl:getSpineFile(item)

	local cell = self.spinLayer.spins[col]:getRetCell(row)
	if item == self.gameConfig.symbol_config.scatter_config.name and bole.isValidNode(cell.up) then
		cell.up:removeAllChildren()
		if bole.isValidNode(cell.tipNode2) then 
			cell.tipNode2:removeAllChildren()
		end
		pos = cc.pAdd(pos, self.gameConfig.symbol_config.scatter_config.scatter_pos)
	else
		cell:setVisible(false)
	end

	local _, s1 = bole.addSpineAnimationInTheme(layer, 100, spineFile, pos, animName, nil, nil, nil, isLoop, isLoop)
end

function cls:playBGEffectByCol(key, pCol)
end

function cls:clearBGEffect()
	-- self.reelDownAnimNode:removeAllChildren()
end

function cls:playSymbolNotifyEffect( pCol, reelSymbolState ) 

	local symbol_config = self.gameConfig.symbol_config
	for  key , list in pairs(self._mainViewCtl.notifyState[pCol]) do
		
		for _, crPos in pairs(list) do
			local cell = nil
			if self._mainViewCtl:checkIsFastStop() then 
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2])
			else
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2]+1)
			end

			if cell and bole.isValidNode(cell.tipNode) and bole.isValidNode(cell.tipNode2) then
				local animParent
				if key == symbol_config.scatter_config.scatter_key then 
					animParent = cell.tipNode2
					cell.tipNode2:removeAllChildren()
				else
					animParent = cell.tipNode
					cell.tipNode:removeAllChildren()
				end

				local tipAnim, hasScatter = self:playSpecialSymbolAnim(animParent, crPos[3] or key, symbol_config.anim_suffix.notify)

				if hasScatter then
					if bole.isValidNode(cell.up) then 
						cell.up:setVisible(false)
					end
				else
					cell.sprite:setVisible(false)
				end

				-- tipAnim:runAction(cc.Sequence:create( -- 不需要更改层级
				-- 	cc.DelayTime:create(5 / 30), -- 触底的时间延迟
				-- 	cc.CallFunc:create(function ( ... )
				-- 		if key == symbol_config.scatter_config.scatter_key and bole.isValidNode(tipAnim) then
				-- 			local posW = bole.getWorldPos(tipAnim)
				-- 			local posN = bole.getNodePos(self.scatterAnimNode, posW)

				-- 			bole.changeParent(tipAnim, self.scatterAnimNode)
				-- 			tipAnim:setPosition(posN)
				-- 		end
				-- 	end)
				-- ))
				tipAnim:addAnimation(0, tipAnim.firstName..symbol_config.anim_suffix.loop, true)
			end	
		end
		-- self:playBGEffectByCol(key, pCol)
	end
end

function cls:playSymbolStopLoopEffect(pCol)
	-- local checkHasLoopList = {}
	-- if pCol <= 5 then 
	-- 	checkHasLoopList = {
	-- 		{pCol, 1}, 
	-- 		{pCol, 2}, 
	-- 		{pCol, 3},
	-- 	}
	-- end

	-- local symbol_config = self.gameConfig.symbol_config
	-- for _, crPos in pairs(checkHasLoopList) do
	-- 	local cell = nil
	-- 	if self._mainViewCtl:checkIsFastStop() then 
	-- 		cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2])
	-- 	else
	-- 		cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2]+1)
	-- 	end

	-- 	if cell and symbol_config.loop_symbol_list[cell.key] and not(bole.isValidNode(cell.symbolTipAnim)) and bole.isValidNode(cell.tipNode) and bole.isValidNode(cell.tipNode2) then
			
	-- 		cell.tipNode:removeAllChildren()
	-- 		cell.tipNode2:removeAllChildren()

	-- 		local animParent = cell.tipNode
	-- 		if key == symbol_config.scatter_config.name then 
	-- 			animParent = cell.tipNode2
	-- 		end

	-- 		local tipAnim, hasScatter = self:playSpecialSymbolAnim(animParent, cell.key, symbol_config.anim_suffix.loop, nil, nil, true )
	-- 		cell.sprite:setVisible(false)
	-- 		cell.symbolTipAnim = tipAnim
	-- 		if hasScatter and bole.isValidNode(cell.up) then 
	-- 			cell.up:setVisible(false)
	-- 		end

	-- 		tipAnim:runAction(cc.Sequence:create(
	-- 			cc.DelayTime:create(5 / 30), -- 触底的时间延迟
	-- 			cc.CallFunc:create(function ( ... )
	-- 				if cell.key > symbol_config.scatter_config.scatter_add and bole.isValidNode(tipAnim) then
	-- 					local posW = bole.getWorldPos(tipAnim)
	-- 					local posN = bole.getNodePos(self.animateNode, posW)

	-- 					bole.changeParent(tipAnim, self.animateNode)
	-- 					tipAnim:setPosition(posN)
	-- 				end
	-- 			end)
	-- 		))
	-- 	end	
	-- end
end

function cls:playSpecialSymbolAnim( node, key, _addName, pos, zOrder, isLoop )
	local firstName = "animation"
	local fileKey = key
	local pos = pos or cc.p(0,0)
	local zOrder = zOrder or 10

	local symbol_config = self.gameConfig.symbol_config
	local scatter_config 	= symbol_config.scatter_config
	local bonus_config 		= symbol_config.bonus_config

	local hasScatter = false
	if type(key) == "number" then
		if key > scatter_config.scatter_add then 
			fileKey = scatter_config.name
			pos = cc.pAdd(scatter_config.scatter_pos, pos)
			hasScatter = true
		elseif bonus_config.bonus_set[key%scatter_config.scatter_add] then 
			fileKey = bonus_config.name..(key%scatter_config.scatter_add)
			firstName = "animation"
		end
	end	

	local spineFile	= self._mainViewCtl:getSpineFile(fileKey)

	local animNameAdd = _addName or ""
	local animateName = firstName..animNameAdd

	local _, s = bole.addSpineAnimationInTheme(node, zOrder, spineFile, pos, animateName,nil,nil,nil,true, isLoop)
	s.firstName = firstName

	return s, hasScatter
end

--------------------------------------------------------------------------------------------------------------------------------
-- mini_slot

function cls:initBoardNodes(pBoardConfigList)
	local boardRoot 	  = self.boardRoot
	local boardConfigList = pBoardConfigList or self._mainViewCtl:getBoardConfig() or {}
	local reelZorder 	  = 100
	self.clipData = {}
	local pBoardNodeList = {}
	-- 棋盘初始化
	for boardIndex, theConfig in pairs(boardConfigList) do
		local theBoardNode 	= nil
		local reelNodes = {}
		
		theBoardNode = cc.Node:create()

		if theConfig["reel_single"] then -- 一个棋盘用一个裁剪区域
			boardRoot:addChild(theBoardNode)
			self:initBoardNodesByReelSingle(reelNodes, theConfig, reelZorder, theBoardNode, boardIndex)

		elseif theConfig["show_parts"] then -- 一个棋盘用一个裁剪区域
			boardRoot = self.classicBoardList[boardIndex- self.gameConfig.classic_config.start_idx] or self.classicBoardList[1]
			boardRoot:addChild(theBoardNode)

			self:initBoardNodesByParts(reelNodes, theConfig, reelZorder, theBoardNode, boardIndex)
		end		
	
		theBoardNode.reelNodes 	   = reelNodes
		theBoardNode.reelConfig    = theConfig["reelConfig"]
		theBoardNode.boardIndex    = boardIndex
		theBoardNode.getReelNode   = function(theSelf,index)
			return theSelf.reelNodes[index]
		end
		pBoardNodeList[boardIndex] = theBoardNode
	end

	self:initBoardTouchBtn(boardConfigList, pBoardNodeList)

	return pBoardNodeList
end

----
function cls:initBoardTouchBtn(boardConfigList, pBoardNodeList)
	for boardIndex, theConfig in pairs(boardConfigList) do
		
		if boardIndex <= self.gameConfig.classic_config.start_idx then 
			local colReelCnt = theConfig["colReelCnt"]
			local boardBasePos, boardW, boardH
			for reelIndex, config in pairs(theConfig["reelConfig"]) do
				if (reelIndex - 1)%self.gameConfig.theme_config.base_col_cnt + 1 == 1 then
					boardBasePos = config["base_pos"]
					boardW = config["cellWidth"]*colReelCnt
					boardH = config["cellHeight"]*config["symbolCount"]
					self:initTouchSpinBtn(boardBasePos, boardW, boardH, pBoardNodeList[boardIndex])
				end
			end
		end
	end
end

--点击棋盘进行spin
function cls:initTouchSpinBtn(base_pos, boardW, boardH, parent)
    local unitSize = 10
    local parent = parent or self.boardRoot
    local img = "commonpics/kong.png"
    local touchSpin = function()
    	self._mainViewCtl:footerCopySpinBtnEvent()
        -- if self._mainViewCtl:featureBtnCheckCanTouch() then
        --     self._mainViewCtl:toSpin()
        -- end
    end
    local touchBtn = Widget.newButton(touchSpin, img, img, img, false) --10
    touchBtn:setPosition(base_pos)
    touchBtn:setAnchorPoint(cc.p(0, 0))
    touchBtn:setScaleX(boardW / unitSize)
    touchBtn:setScaleY(boardH / unitSize)
    parent:addChild(touchBtn)
end
----

function cls:initBoardNodesByReelSingle( reelNodes, theConfig, reelZorder, theBoardNode, boardIndex )
	local colReelCnt = theConfig["colReelCnt"]
	self.clipData["reel_single"] = {}

	local clipNode = nil
	local reelNode = nil

	for reelIndex,config in ipairs(theConfig["reelConfig"]) do
		if (reelIndex-1)%colReelCnt == 0 then 
			reelNode = cc.Node:create()
			reelNode:setLocalZOrder(reelZorder)
			
			local vex = {
				config["base_pos"], -- 第一个轴的左下角  下左边界
				cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*colReelCnt, 0)),  -- 下右边界
				cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*colReelCnt, config["cellHeight"]*config["symbolCount"])),-- 上右边界
				cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"]*config["symbolCount"])),-- 上左边界
			}
			if theConfig["allow_over_range"] then
				vex[1] = cc.pAdd(vex[1], cc.p(-config["cellWidth"], 0))
				vex[4] = cc.pAdd(vex[4], cc.p(-config["cellWidth"], 0))

				vex[2] = cc.pAdd(vex[2], cc.p(config["cellWidth"], 0))
				vex[3] = cc.pAdd(vex[3], cc.p(config["cellWidth"], 0))
			end
			local stencil = cc.DrawNode:create()
			stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))

			local clipAreaNode = cc.Node:create()
			clipAreaNode:addChild(stencil)
			clipNode = cc.ClippingNode:create(clipAreaNode)
			   
			theBoardNode:addChild(clipNode)	
			clipNode:addChild(reelNode)
			self:addBoardMaskNode(reelNode, config["base_pos"], reelIndex)

		end

		reelNodes[reelIndex] = reelNode

	end
end

function cls:initBoardNodesByParts( reelNodes, theConfig, reelZorder, theBoardNode, boardIndex )
	
	local reelNode = cc.Node:create()
	reelNode:setLocalZOrder(reelZorder)

	local clipAreaNode = cc.Node:create()
	local mask_bottom = theConfig["mask_bottom"]
	local mask_top 	= theConfig["mask_top"]
	for reelIndex, config in ipairs(theConfig["reelConfig"]) do
	    local vex = {
	        cc.p(config["base_pos"].x, mask_bottom), -- 第一个轴的左下角  下左边界
	        cc.p(config["base_pos"].x + config["cellWidth"], mask_bottom), -- 下右边界  * 0.5
	        cc.p(config["base_pos"].x + config["cellWidth"], mask_top), -- 上右边界  + 0.5
	        cc.p(config["base_pos"].x, mask_top), -- 上左边界  + 0.5
	    }

	    local stencil = cc.DrawNode:create()
	    stencil:drawPolygon(vex, #vex, cc.c4f(1, 1, 1, 1), 0, cc.c4f(1, 1, 1, 1))
	    clipAreaNode:addChild(stencil)
	    reelNodes[reelIndex] = reelNode
	end
	local clipNode = cc.ClippingNode:create(clipAreaNode)

	theBoardNode:addChild(clipNode)
	clipNode:addChild(reelNode)
end

function cls:playBonusItemAnim( posList )
	if not posList then return end

	self._mainViewCtl:playMusicByName("slot_spin")
	local symbol_config = self.gameConfig.symbol_config

	for col, colPosList in pairs(posList) do
		for _, posData in pairs(colPosList) do 
			local pos = self._mainViewCtl:getCellPos(posData[1], posData[2])
			
			self:playSpecialSymbolAnim( self.animateNode, posData[3]%symbol_config.scatter_config.scatter_add, symbol_config.anim_suffix.win, pos )

			if posData[3] > symbol_config.scatter_config.scatter_add then 
				self:playSpecialSymbolAnim( self.animateNode, posData[3], symbol_config.anim_suffix.loop, pos )				
			end
		end
	end
end

function cls:changeSpinLayerState( pType, bType )
	local board_type_config = self.gameConfig.SpinBoardType


	if bType ~= board_type_config.Bonus then 
		self.bonusBoardIndex = nil
		for idx, _layer in pairs(self.spinLayerList) do 
			if idx > self.gameConfig.classic_config.start_idx then
				_layer:DeActive()
			end
		end
	else
		for idx, _layer in pairs(self.spinLayerList) do 
			if idx > self.gameConfig.classic_config.start_idx then 
				_layer:Active(true)
			end
		end
	end

end

function cls:changeSpinLayerNotHide(pType)
    if self.spinLayer ~= self.spinLayerList[pType] then
        if self.spinLayer then
            self.spinLayer:DeActive(true) -- 不隐藏board
        end
        self.spinLayer = self.spinLayerList[pType]
        self.spinLayer:Active()
    end

    self.bonusBoardIndex = pType
end
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
function cls:activeNodeWordPos( )
	if bole.isValidNode(self.activePosNode) then 
		return bole.getWorldPos(self.activePosNode)
	end
end
--------------------------------------------------------------------------------------------------------------------------------
-- function cls:addSpecialSpeed(specialTag)
-- 	-- 添加出特效音效控制 

-- 	self._mainViewCtl:playMusicByName("reel_notify2") -- 播放龙的动画 暂时放在动画层上面 播放
-- 	local _, s1 = bole.addSpineAnimation(self.down_child, 20, self._mainViewCtl:getPic("spine/base/specialSpeed/jili"), cc.p(0, 0), "animation")
-- end






