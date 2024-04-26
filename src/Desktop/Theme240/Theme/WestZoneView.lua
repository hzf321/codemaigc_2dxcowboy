local parentCls = ThemeBaseView
local cls = class("WestZoneView", ThemeBaseView)
function cls:ctor( ctl )
	self._mainViewCtl = ctl
	self.gameConfig = self._mainViewCtl.gameConfig
	ThemeBaseView.ctor(self, ctl)
end
--------------------------------------------------------------------------------------------------------------
function cls:initScene( ... )
	self:_initBaseNode()
	self:_initBoardNode()
	self:_initBgNode()
	self:_initJackpotNode()
	self:_initCollectNode()
	self:adaptWideScreen()
	self:_adaptBaseBG()
	self:initBgListen()
end

function cls:_initBaseNode( ... )
	local path = self._mainViewCtl:getCsbPath("base")
	self.mainThemeScene = cc.CSLoader:createNode(path)
	bole.adaptScale(self.mainThemeScene)
	self.shake_node = self.mainThemeScene:getChildByName("shake_node")
	self.down_node 		= self.shake_node:getChildByName("down_child")
	self.down_child 	= self.down_node:getChildByName("down_child")
	self.reelRoot 		= self.down_child:getChildByName("reel_root_node")
	self.shakyNode:addChild(self.mainThemeScene)
	-- self.wild_dimmer:setLocalZOrder(1)
	self.animateNode 		= self.reelRoot:getChildByName("animate_node")
	-- self.animateNode:setLocalZOrder(2)
	self.transitionDimmer = self.down_node:getChildByName("dimmer")
	self.transitionDimmer:setVisible(false)
	self.logoLabelNode  = self.down_node:getChildByName("logo")
	self.logoLabelNode:setVisible(false)
	self.themeAnimateKuang = cc.Node:create()
	self.down_child:addChild(self.themeAnimateKuang, 10)
	self.themeAnimateKuang:setPosition(cc.p(-640, -360))
	self.jpReelAnimate = cc.Node:create()
	self.jpReelAnimate:setPosition(cc.p(-640, -360))
	self.down_node:addChild(self.jpReelAnimate)
	self.bonusReelAnimate = cc.Node:create()
	self.bonusReelAnimate:setPosition(cc.p(-640, -360))
	self.down_node:addChild(self.bonusReelAnimate)
	self.board_dimmer    = self.down_child:getChildByName("dimmer_board")
	self.board_dimmer:setVisible(false)
	-- self.muti_ani_node = cc.Node:create()
	-- self.down_child:addChild(self.muti_ani_node, 2)

end

function cls:_initBoardNode( ... )
	self.freeBoard  = self.reelRoot:getChildByName("board_free")
	self.respinBorad = self.reelRoot:getChildByName("board_respin")
	self.respinBorad:setVisible(false)
	self.normalBorad = self.reelRoot:getChildByName("board")
	self.boardRoot 	= self.reelRoot:getChildByName("board_root")
	-- self.boardAni   = self.reelRoot:getChildByName("board_ani")
	self.boardAniParent = self.down_child:getChildByName("ani_board")
	self.jili_node = self.reelRoot:getChildByName("jili_node")

	---respin上面显示次数的节点
	self.remainingTipNode = self.down_child:getChildByName("remainingTipNode")
	self.remainingTipNode:setVisible(false)
	self.moveSpinTimes = self.remainingTipNode:getChildByName("times_label")
	self.moveSpinTimes_ani = self.remainingTipNode:getChildByName("flash")
	self.moveSpinTips = self.remainingTipNode:getChildByName("tip")
	self.moveLastSpinTips = self.remainingTipNode:getChildByName("tip_last")
	self.respin_bg_right  = self.remainingTipNode:getChildByName("bg_right")
	self.respin_bg_right:setAnchorPoint(1,0.5)
	self.free_bg_right = self.freeBoard:getChildByName("free_head"):getChildByName("Image_261")
	self.free_bg_right:setAnchorPoint(1,0.5)

	--respin上面显示收钱的和中间倍乘的节点
	self.collect_respinWin = self.down_child:getChildByName("collect_respin")
	self.collect_respinWin:setVisible(false)
	self.collect_respinWin_bg = self.collect_respinWin:getChildByName("Image_right")
	self.collect_respinWin_bg:setAnchorPoint(1,0.5)
	self.collect_muti_node = self.collect_respinWin:getChildByName("label_muti_node")
	self.collect_muti_node:setVisible(false)
	self.collectBox_changeAniNode = self.down_child:getChildByName("collect_change")
	--respin上面播动画的节点
	self.headAniNode = self.reelRoot:getChildByName("head_ani")
	self.wildTypeNode = self.freeBoard:getChildByName("free_head"):getChildByName("wild")
	-- self.respin_bg_right:setPosition(0,205)
	self.flyNode = self.boardAniParent:getChildByName("fly_node")
	--respin最后一个格子播激励的节点
	self.respinAniNode = self.boardAniParent:getChildByName("respinAni_node")

	--pick界面弹窗动画节点
	self.pickNode = self.down_node:getChildByName("pick_node")
end

function cls:initSpinLayer( )
	self.spinLayerList = {}
	-- self.respinAniList = {}
	for index,cofig in ipairs(self.boardNodeList) do
		self.initBoardIndex = index
		local boardNode = self.boardNodeList[index]
		local layer = SpinLayer.new(self._mainViewCtl, self._mainViewCtl.ctl,boardNode.reelConfig,boardNode)
		layer:DeActive()
		self.shakyNode:addChild(layer,-1)
		table.insert(self.spinLayerList,layer)
	end
	self.initBoardIndex = nil
	self.spinLayer = self.spinLayerList[1]
	self.spinLayer:Active()
	-- self._mainViewCtl.ctl.footer:changeNormalLayout()
	self:adaptActivityFun()
end

--鼠标点击动画--
function cls:adaptActivityFun( ... )
	local centerCell = nil
	local pos = cc.p(640, 360)
	if self.spinLayer then
		centerCell = self.spinLayer.spins[5]:getRetCell(2)
	end
	if centerCell and bole.isValidNode(centerCell) then
		pos = bole.getWorldPos(centerCell)
	end
	self._mainViewCtl.ctl.footer.adaptActivityPos = pos
end

function cls:judgmentEffectiveCon(pos)
	if not pos then return false end 
	local topHeight = 70 * HEADER_FOOTER_SCALE
	local bottomHeight = 100 * HEADER_FOOTER_SCALE
	local heigh = self._mainViewCtl.isPortrait and FRAME_WIDTH or FRAME_HEIGHT
	if (pos.y <= heigh - topHeight) and (pos.y >= bottomHeight) then 
		return true
	end
	return false
end

function cls:initBgListen()
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)
	 local function onTouchBegan (touch, event)
        if self.bgRoot.canTouch then
           self.bgRoot.startPosition = cc.p(touch:getLocation())
            return true
        end
        return true
    end
    local function onTouchCancelled (touch, event)
       self.bgRoot.startPosition = nil
    end

	local function onTouchEnded (touch, event)
		--并且在某个范围内才行
        if self.bgRoot.startPosition and self.bgRoot.canTouch then
            local target = event:getCurrentTarget()
			local location = touch:getLocation()
			if self:judgmentEffectiveCon(location) then 
				self:chooseGameSelectBtnClickFunc(location)
			end
        end
    end

	self.bgRoot.canTouch = true
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED) -- 同楼上
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = self.bgRoot:getEventDispatcher() -- 通过它管理当前节点（场景、层、精灵等）的所有事件的分发。
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.bgRoot)-- 添加一个事件监听器到事件派发器
end

function cls:chooseGameSelectBtnClickFunc(worldPos)
    local file = self._mainViewCtl:getSpineFile("danji")
	local parent = self.bgAnimNode
	local pos = self.bgAnimNode:convertToNodeSpace(worldPos)
	self.bgRoot.canTouch = false
	self._mainViewCtl:addSpineAnimation(parent ,nil, file, pos,"animation")
	-- self._mainViewCtl:playMusicByName("trigger_bell")
	
	local a1 = cc.DelayTime:create(3/30)
	local a2 = cc.CallFunc:create(function ()
		self.bgRoot.canTouch = true
	end)
	local a3 = cc.Sequence:create(a1, a2)
	libUI.runAction(self.bgAnimNode, a3)
end
-----end------

function cls:_adaptBaseBG(baseScale)
    baseScale = baseScale or bole.getAdaptScale()
	-- local baseFgY = 90
    local width = FRAME_WIDTH
	local bg_width = 1248
    if width > bg_width and self.bgRoot then
        -- local scale = FRAME_WIDTH / bg_width * baseScale
		local scale = self:getBgAdaptScale()
		-- baseFgY = baseFgY + self:getWideMoveY()
        self.bgRoot:setScale(scale)
    end
	if self.transitionDimmer then 
		self.transitionDimmer:setScale(55)
	end
	-- self.free_bgRoot:setPositionY(baseFgY)
end

function cls:getBgAdaptScale()
	local baseScale =  bole.getAdaptScale()
	local bg_width = 1248
	local scale = FRAME_WIDTH / bg_width * baseScale
	return scale
end

function cls:adaptWideScreen()
	-- local moveY = self:getWideMoveY()
	local moveY = bole.getAdaptBottomHMoveY()
	moveY = moveY / 2
    if bole.getAdaptationWidthScreen() then
        local posY = 320 + moveY
        self.logoLabelNode:setVisible(true)
        local data = {}
        data.file = self._mainViewCtl:getSpineFile("logo")
        data.parent = self.logoLabelNode
        data.isLoop = true
        data.pos = cc.p(0, posY)
        bole.addAnimationSimple(data)
    end
	if bole.isWidescreen() then 
		self.down_node:setPositionY(-moveY)
	end
end

-- function cls:getWideMoveY()
--     if bole.isWidescreen() then
--         local moveY = (FRAME_HEIGHT * (1 - bole.getAdaptScale()) / 2)/bole.getAdaptScale()
--         return moveY/2
--     end
--     return 0
-- end
function cls:initBoardNodesByNormal( reelNodes, theConfig, reelZorder, theBoardNode, boardIndex )
	self.clipData["normal"] = {}
	local oldReelNode = nil
	local oldStencil = nil
	local oldVex = nil
	local limitCol = 4
	local maxCol = 6
	local reelOrder = 100
	for reelIndex,config in ipairs(theConfig["reelConfig"]) do
		local reelNode = nil
		local vex = nil
		local order = reelOrder - 50

		if reelIndex == limitCol then
			reelNode = cc.Node:create()
			reelNode.reelIndex = reelIndex
			reelNode:setLocalZOrder(reelZorder)
			order = reelOrder
			vex = {
				cc.pAdd(config["base_pos"], cc.p(0, config["symbolCount"] > 1 and 2 or -1)), -- 第一个轴的左下角  下左边界
				cc.pAdd(config["base_pos"], cc.p(config["cellWidth"] * 3, config["symbolCount"] > 1 and 2 or -1)),  -- 下右边界
				cc.pAdd(config["base_pos"], cc.p(config["cellWidth"] * 3, config["cellHeight"] * config["symbolCount"] - (config["symbolCount"] > 1 and (config["lineWidth"]-1)/2 or -0.5))),-- 上右边界
				cc.pAdd(config["base_pos"], cc.p(0,	config["cellHeight"] * config["symbolCount"] - (config["symbolCount"] > 1 and (config["lineWidth"] -1)/2 or -0.5))),-- 上左边界
			}
		elseif reelIndex < limitCol or reelIndex > maxCol then
			reelNode = cc.Node:create()
			reelNode:setLocalZOrder(reelZorder)
			reelNode.reelIndex = reelIndex
			vex = {
				cc.pAdd(config["base_pos"], cc.p(0, config["symbolCount"] > 1 and 2 or -1)), -- 第一个轴的左下角  下左边界
				cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], config["symbolCount"] > 1 and 2 or -1)),  -- 下右边界
				cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], config["cellHeight"] * config["symbolCount"] - (config["symbolCount"] > 1 and (config["lineWidth"]-1)/2 or -0.5))),-- 上右边界
				cc.pAdd(config["base_pos"], cc.p(0,	config["cellHeight"] * config["symbolCount"] - (config["symbolCount"] > 1 and (config["lineWidth"] -1)/2 or -0.5))),-- 上左边界
			}
		end
		if theConfig["allow_over_range"] and vex then
			vex[1] = cc.pAdd(vex[1], cc.p(-config["cellWidth"], 0))
			vex[4] = cc.pAdd(vex[4], cc.p(-config["cellWidth"], 0))
			vex[2] = cc.pAdd(vex[2], cc.p(config["cellWidth"], 0))
			vex[3] = cc.pAdd(vex[3], cc.p(config["cellWidth"], 0))
		end
		if reelNode and vex then
			local stencil = cc.DrawNode:create()
			stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))
			local clipAreaNode = cc.Node:create()
			clipAreaNode:addChild(stencil)
			local clipNode = cc.ClippingNode:create(clipAreaNode)
			theBoardNode:addChild(clipNode, order)
			clipNode:addChild(reelNode)
			oldReelNode = reelNode
			oldStencil = stencil
			oldVex = vex
		end
		reelNodes[reelIndex] = oldReelNode
		self.clipData["normal"][reelIndex] = {}
		self.clipData["normal"][reelIndex]["vex"] = oldVex
		self.clipData["normal"][reelIndex]["stencil"] = oldStencil
	end
end

function cls:initBoardTouchBtn(boardConfigList, pBoardNodeList)
    local base_config = boardConfigList
	for key = 1 ,#boardConfigList do
		local lineWidth = self._mainViewCtl.gameConfig.lineWidth
		local lineHeight = self._mainViewCtl.gameConfig.lineHeight
		local cellWidth = self._mainViewCtl.gameConfig.G_CELL_WIDTH
		local cellHeight = self._mainViewCtl.gameConfig.G_CELL_HEIGHT
		-- for key = 1, #boardConfigList do
		local reelConfig = base_config[1].reelConfig
		local base_pos_part1 = reelConfig[3].base_pos
		local base_pos_part2 = cc.pAdd(reelConfig[4].base_pos, cc.p(0, (cellHeight + lineWidth) * 3 ))
		local boardW_part1 = cellWidth * 5 + lineHeight * 4
		local boardH_part1 = cellHeight * 3 + lineWidth * 3
		local boardW_part2 = cellWidth  * 3 + lineHeight * 2
		local boardH_part2 = cellHeight
		self:initTouchSpinBtn(base_pos_part1, boardW_part1, boardH_part1, pBoardNodeList[key])
		self:initTouchSpinBtn(base_pos_part2, boardW_part2, boardH_part2, pBoardNodeList[key])
    end
end

function cls:initTouchSpinBtn(base_pos, boardW, boardH, parent, isCenter)
	local unitSize = 10
    -- local parent = self.boardRoot
    local img = "commonpics/kong.png"
    local touchSpin = function()
        self._mainViewCtl:footerCopySpinBtnEvent()
    end
    local touchBtn = Widget.newButton(touchSpin, img, img, img, false) --10
	local anchorPoint = cc.p(0,0)
	if isCenter then
		anchorPoint = cc.p(0.5,0)
	end
    touchBtn:setPosition(base_pos)
    touchBtn:setAnchorPoint(anchorPoint)
    touchBtn:setScaleX(boardW / unitSize)
    touchBtn:setScaleY(boardH / unitSize)
    parent:addChild(touchBtn)
	touchBtn.scale  = boardH / unitSize
	return touchBtn
end


function cls:resetBoardShowNode( pType )
	self:changeSpinLayerByType(pType)
end

function cls:refreshCellsZOrder( pCol )
	self:refreshColCellsZOrder(pCol)
end

function cls:_initBgNode( ... )
	self.bgRoot 		= self.mainThemeScene:getChildByName("theme_bg")
	self.bgRoot:setVisible(true)
	self.bgAnimNode 		= self.bgRoot:getChildByName("bg_anim")
	self.base_bgRoot		= self.bgRoot:getChildByName("bg_base")
	self.base_bgRoot:setVisible(true)
	self.free_bgRoot 		= self.bgRoot:getChildByName("bg_free")
	self.free_bgRoot:setVisible(false)
	self.respin_bgRoot 		= self.bgRoot:getChildByName("bg_respin")
	self.respin_bgRoot:setVisible(false)
	-- self.bgAnimNode:setLocalZOrder(1)
	-- self.baseBgNode:setVisible(true)
	-- self.currentBg = self.baseBgNode
	-- self.freeBgNode:setVisible(false)
	-- self.sfreeBgNode:setVisible(false)
end

function cls:playBgAni(pType)
	if not self.bgAnimNode then return end 
	self.bgAnimNode:removeAllChildren()
	self.headAniNode:removeAllChildren()
	if pType == 1 then  -- normal 
		self.bgAnimNode:setScale(1)
		local spineFile = self._mainViewCtl:getSpineFile("bg_base")
		bole.addSpineAnimation(self.bgAnimNode, nil, spineFile, cc.p(0,0), "animation", nil, nil, nil, true, true)
	elseif pType == 2 then  -- normal free 
		local spineFile = self._mainViewCtl:getSpineFile("bg_free")
		local spineFile1 = self._mainViewCtl:getSpineFile("free_top_box")
		-- local moveY = self:getWideMoveY()
		-- local baseScale = self:getBgAdaptScale()
		self.bgAnimNode:setScale(1.25)
		bole.addSpineAnimation(self.bgAnimNode, 1, spineFile, cc.p(0, 0), "animation", nil, nil, nil, true, true)
		bole.addSpineAnimation(self.headAniNode, nil, spineFile1, cc.p(0,0), "animation",nil,nil,nil,true,true)
		-- spine:setScale(1/baseScale)
		-- bole.addSpineAnimation(self.bgAnimNode, nil, spineFile, cc.p(0, -moveY), "animation", nil, nil, nil, true, true)
	elseif pType == 3 then  -- super free
		local spineFile = self._mainViewCtl:getSpineFile("bg_respin")
		self._mainViewCtl:addSpineAnimation(self.bgAnimNode, nil, spineFile, cc.p(0, 0) , "animation", nil, nil, nil,true, true)
		self.bgAnimNode:setScale(1.25)
	end
end

function cls:getSpecialFeatureRoot( pType )
	if pType == "jackpot" then
		if not self.progressiveNode then
			self.progressiveParent = self.down_child:getChildByName("progressive")
			self.progressiveNode = self.progressiveParent:getChildByName("progressive_node")
		end
		return self.progressiveNode
	elseif pType == "collect" then
		if not self.collectNode then
			self.collectNode = self.reelRoot:getChildByName("collect_feature_node")
		end
		return self.collectNode
	end
end

-- function cls:_initFreeGameNode( ... )
-- 	self._mainViewCtl:getFreeVCtl():initLayout()
-- end

function cls:_initJackpotNode( ... )
	local jackpotNode = self:getSpecialFeatureRoot("jackpot") 
	if bole.isValidNode(jackpotNode) then
		self._mainViewCtl:getJpViewCtl():initLayout(jackpotNode)
	end
end

function cls:_initCollectNode( ... )
	local collectNode = self:getSpecialFeatureRoot("collect")
	self.collect_tip_node = self.down_node:getChildByName("collect_tip")
	if bole.isValidNode(collectNode) then
		self._mainViewCtl:getCollectViewCtl():initLayout(collectNode, self.collect_tip_node)
	end
end

---------------symbol start---------------
function cls:addFirstBoardItem()
	local randomBoard = math.random(1, 7)
	local itemList = self.gameConfig.welComeList[randomBoard]
	local limitCol = 4
	local maxCol = 6
	for col, val in ipairs(itemList) do
		if col >= limitCol and col <= maxCol then
			if val[1] == 12 or val[1] == 13 then
				local cell = self:getCellItem(col, 1)
				for row = 1, 4 do
					local cell1 = self:getCellItem(col, row)
					if cell1 then
						self:updateCellSprite(cell1, 0, col, true, true)
					end
				end
				if cell then
					local staticAnimate = cell.staticAnimate
					local file = self._mainViewCtl:getSpineFile("change_"..val[1])
					local animation = "animation4_2"
					local height = 3/2 * (self.gameConfig.G_CELL_HEIGHT + self.gameConfig.lineWidth)
					bole.addSpineAnimationInTheme(staticAnimate, nil, file, cc.p(0,-height), animation, nil, nil, nil, true)
					cell:setLocalZOrder(1000)
				end
			else 
				for row, item in ipairs(val) do
					local cell = self:getCellItem(col, row)
					if cell then
						self:updateCellSprite(cell, item, col, true, true)
					end
				end
			end
		else 
			local cell = self:getCellItem(col, 1)
			if cell then
				self:updateCellSprite(cell, val[1], col, true, true)
			end
		end
	end
end

function cls:createCellSprite(key, col, rowIndex)
	------------------------------------------------------------
	-- local notInitSymbolSet = {}
	-- if self.gameConfig.symbol_config and self.gameConfig.symbol_config.not_init_symbol_set then 
	-- 	notInitSymbolSet = self.gameConfig.symbol_config.not_init_symbol_set
	-- end
	local lastKey = key
	-- local zOrder = 50
	-- if key == 30 or key == 31 then zOrder = 200 end
	-- local key = self._mainViewCtl:getNormalKey() 
	local key = math.random(2,9)

	local theCellFile = self._mainViewCtl.pics[key]
	local theCellNode   = cc.Node:create()
	local theCellSprite = bole.createSpriteWithFile(theCellFile)
	theCellNode:addChild(theCellSprite)
	theCellNode.key 	  = key
	theCellNode.sprite 	  = theCellSprite
	theCellNode.curZOrder = 0
	local landAnimate = cc.Node:create()
    theCellNode.tipNode = landAnimate
    theCellNode:addChild(landAnimate, 50)

	local staticAnimate = cc.Node:create()
	theCellNode.staticAnimate = staticAnimate
    theCellNode:addChild(staticAnimate, 51)

	local ingotNode = cc.Node:create()
	theCellNode.ingotNode = ingotNode
	theCellNode:addChild(ingotNode, 100)

	bole.setEnableRecursiveCascading(theCellNode, true)
	------------------------------------------------------------
	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )
	local theKey = theCellNode.key
	if self._mainViewCtl.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self._mainViewCtl.symbolZOrderList[theKey]
	end
	return theCellNode
end

function cls:updateCellSprite(theCellNode, key, col, isShowResult, isReset, isNotChange )
	local theCellSprite = theCellNode.sprite
	local staticAnimate = theCellNode.staticAnimate
	local ingotNode = theCellNode.ingotNode
	local fontRate = nil
	local lastKey = key
	if self.gameConfig.epicLinkMul[key] then
		fontRate = self.gameConfig.epicLinkMul[key]
		lastKey = 11
	elseif self.gameConfig.jpEpicLinkMul[key] then
		lastKey = 11
	elseif self.gameConfig.specialEpicLinkMul[key] then
		lastKey = 11
		if key == 31 then
			lastKey = 20
		end
	end
	if staticAnimate then
		staticAnimate:removeAllChildren()
		staticAnimate:setVisible(true)
	end
	if self._mainViewCtl:getSuperFreeStatus() then 
		if self._mainViewCtl:isLowSymbol(lastKey) then 
			lastKey = self._mainViewCtl:getMajorSymbol()
		end
	end
	local theCellFile 	= self._mainViewCtl.pics[lastKey]
	if self._mainViewCtl.showReSpinBoard and (lastKey <= 13) and lastKey ~= 11 then
		theCellFile = "#theme240_dark_"..lastKey..".png"
	end 

	if not theCellFile then
		lastKey = self._mainViewCtl:getMajorSymbol()
		theCellFile 	= self._mainViewCtl.pics[lastKey]
	end

	self:adjustWithTheCellSpriteUpdate( theCellNode, lastKey, col )

	if ingotNode then
		ingotNode:removeAllChildren()
		ingotNode:setVisible(true)
	end

	if fontRate then
		local labelCoin = self:getSymbolLabel(fontRate)
		local str = FONTS.formatByCount4(labelCoin,4,true)
		local label = cc.Label:createWithBMFont(self._mainViewCtl:getPic("font/theme240_font_4.fnt"), str)
		ingotNode:addChild(label)
		label:setScale(1)
	elseif self.gameConfig.jpEpicLinkMul[key] then
		local node = cc.Node:create()
		local sprite = bole.createSpriteWithFile("#theme240_jp_"..key..".png")
		node:addChild(sprite)
		ingotNode:addChild(node)
	elseif self.gameConfig.specialEpicLinkMul[key] then
		local node = cc.Node:create()
		local sprite = bole.createSpriteWithFile("#theme240_special_"..key..".png")
		node:addChild(sprite)
		ingotNode:addChild(node)
	end

	bole.updateSpriteWithFile(theCellSprite, theCellFile)
	theCellNode.key 	  = lastKey
	theCellNode.curZOrder = 0

	local theKey = theCellNode.key
	if self._mainViewCtl.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self._mainViewCtl.symbolZOrderList[theKey]
	end

	if isReset then
		theCellNode:setLocalZOrder(theCellNode.curZOrder)
	end


	theCellSprite:setVisible(true)
	theCellSprite:setAnchorPoint(cc.p(0.5, 0.5))
	if self._mainViewCtl.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self._mainViewCtl.symbolPosAdjustList[theKey])
	else
		theCellSprite:setPosition(cc.p(0,0))
	end
end

function cls:getSymbolLabel(num, rate)
	local coins = 0
	num = num or 0
	local currentBet = self._mainViewCtl:getCurBet()
	rate = rate or 1
	coins = currentBet * num
	return coins * rate
end

function cls:changeSpinBoard(pType)
	 local respinShow = function (type)
		local list = {self.respinBorad, self.freeBoard, self.normalBorad}
		for i = 1, type - 1 do
			list[i]:setVisible(false)
		end
		list[type]:setVisible(true)
		for i = type + 1, #list do
			list[i]:setVisible(false)
		end
		
		local isRespin  = false
		local isFree = false
		if type == 1 then isRespin  = true end
		if type == 2 then isFree = true end
		self.respinBorad:setVisible(isRespin)
		self.normalBorad:setVisible(not isRespin and not isFree)
		self.freeBoard:setVisible(isFree)
		self.collectNode:setVisible(not isRespin and not isFree)
		self.collect_tip_node:setVisible(not isRespin and not isFree)
		self.respin_bgRoot:setVisible(isRespin)
		self.free_bgRoot:setVisible(isFree)
		self.base_bgRoot:setVisible(not isFree and not isRespin)
		-- self.logoLabelNode:setVisible(not isRespin)

	end
	if pType == self.gameConfig.SpinBoardType.Normal then
		-- self:updateLogoState(true)
		respinShow(3)
		self:resetBoardShowNode(1)
		-- self:lockTopBar()
	elseif pType == self.gameConfig.SpinBoardType.FreeSpin then
		-- self:updateLogoState()
		respinShow(2)
		self:resetBoardShowNode(1)
		if self._mainViewCtl:getSuperFreeStatus() then
			self._mainViewCtl.footer:changeFreeSpinLayout3()
		end
		if self._mainViewCtl:getFgTwinSymbol() then 
            local file =  "#theme240_s_"..self._mainViewCtl:getFgTwinSymbol()..".png" 
            bole.updateSpriteWithFile(self.wildTypeNode, file)
        end
		-- if self._mainViewCtl and self._mainViewCtl.fg_type == 2 then
        --     self._mainViewCtl.footer:changeFreeSpinLayout3()
        -- end
	elseif pType == self.gameConfig.SpinBoardType.Respin then
		respinShow(1)
		-- 将所有的都隐藏
		self:resetBoardShowNode(2)
		-- self._mainViewCtl:setFooterStyle(0)
	end
	self:playBgAni(pType)
end

function cls:updateSuperFgLowSymbol(specailId, cleanWild)
	local wildId = 1
	if self._mainViewCtl:getSuperFreeStatus() or specailId or cleanWild then 
		if self.spinLayer then
			for col, temp in pairs(self.spinLayer.spins) do 
				for row, cell in pairs(temp.cells) do
					if cell and bole.isValidNode(cell) then 
						local item = cell.key
						if specailId then
							if item == specailId then 
								item = self._mainViewCtl:getMajorSymbol()
								self:updateCellSprite(cell, item, col, true, true)
							end
						else 
							if self._mainViewCtl:isLowSymbol(item) then 
								item = self._mainViewCtl:getMajorSymbol()
								self:updateCellSprite(cell, item, col, true, true)
							end
						end
						if item == wildId then 
							item = self._mainViewCtl:getMajorSymbol()
							self:updateCellSprite(cell, item, col, true, true)
						end
					end	
				end
			end
		end
	end
end

function cls:stopDrawAnimate() -- 可能存在 手动调用的可能
	self.symbolsSkeleton = nil
	self:showAllItem()
	self.spinLayer:stopChildActions()
	self:clearAnimate()
	self:clearBGEffect()
	if self.changeCombine then
		self:showChangeCombieAni()
	end
end

function cls:getItemAnimate(item, col, row, effectStatus, parent, isLoop, pos )
	if self.symbolsSkeleton and self.symbolsSkeleton[col.."_"..row] then -- 播放长wild的动画
        self:playOldAnimation(col, row)
    elseif (effectStatus == "all_first") then
        self:playItemAnimation(item, col, row, effectStatus, parent, isLoop)
    end
    return nil
end

function cls:playOldAnimation( col, row )
	self.symbolsSkeleton = self.symbolsSkeleton or {}
    if self.symbolsSkeleton[col .. "_" .. row] then
        local node = self.symbolsSkeleton[col .. "_" .. row][1]
        local animationName = self.symbolsSkeleton[col .. "_" .. row][2]
		local isLowSymbolKey = self.symbolsSkeleton[col .. "_" .. row][3]
		local wildSpine = self.symbolsSkeleton[col .. "_" .. row][4]
		local staticWLoop = self.symbolsSkeleton[col .. "_" .. row][5]
        if node and bole.isValidNode(node) and animationName then
			node:setLocalZOrder(11)
            bole.spChangeAnimation(node, animationName)
			if isLowSymbolKey then
				node:addAnimation(0, animationName, false)
			end
			local a1 = cc.DelayTime:create(3)
			local a2 = cc.CallFunc:create(function ()
				node:setLocalZOrder((row - 1) * 5 + col)
			end)
			local a3 = cc.Sequence:create(a1, a2)
			node:runAction(a3)
        end
		if wildSpine and bole.isValidNode(wildSpine) and staticWLoop then
			bole.spChangeAnimation(wildSpine, staticWLoop)
		end
    end
end

function cls:playItemAnimation(item, col, row, effectStatus, parent, isLoop)
	local animateName = "animation"
	if item == 12 or item == 13 then
		animateName = "animation1"
	end
	local fileName = item
	local cell = self.spinLayer.spins[col]:getRetCell(row)
	local pos       = self._mainViewCtl:getCellPos(col,row)
	local spineFile = self._mainViewCtl:getPic("spine/item/"..item.."/spine")--M1-M6：中奖动画 wild中奖 scatter落地
		--if item == 12 then animateName = "animation1" end
	local _, s1 = bole.addSpineAnimation(self.animateNode, row, spineFile, pos, animateName, nil, nil, nil, true, isLoop)
	local isLowSymbolKey = false
	if self._mainViewCtl:isLowSymbol(item) then 
		isLowSymbolKey = true
		s1:addAnimation(0, animateName, false)
	end
	s1:setLocalZOrder((row - 1) * 5 + col)
	self.symbolsSkeleton = self.symbolsSkeleton or {}
	self.symbolsSkeleton[col.."_"..row] = {}
	self.symbolsSkeleton[col.."_"..row] = {s1,animateName,isLowSymbolKey}
	cell.sprite:setVisible(false)
end

function cls:playCellRoundEffect(theSprite)
	bole.addSpineAnimation(theSprite, nil, self._mainViewCtl:getSpineFile("win_line"), cc.p(0,0), "animation", nil, nil, nil, true, true, nil)
end

function cls:playSymbolNotifyEffect( pCol, reelSymbolState )
	local extraCount = self._mainViewCtl:getNormalStopAddCount()
	local scatterFile = self._mainViewCtl:getPic("spine/item/10/scatter")
	local musicFile = nil
	for  key, list in pairs(self._mainViewCtl.notifyState[pCol]) do
		for _, crPos in pairs(list) do
			local cell = nil
			local item = crPos[3]
			local willGetFeature = crPos[4]
			scatterFile = key == 10 and scatterFile or self._mainViewCtl:getPic("spine/respin/bonus")
			musicFile = key == 10 and "scatter_land" or "bonus_land"
			local startAni = "animation"
			local loopAni = "animation1"
			if key == 11 then
				startAni = "animation1"
				loopAni = "animation1_1"
				if item == 30 then
					startAni = "animation2"
					loopAni = "animation2_1"
				elseif item == 31 then
					startAni = "animation3"
					loopAni = "animation3_1"
				end
			end
			if willGetFeature then 
				self._mainViewCtl:setReelSpecailLandMusic(pCol)
				self._mainViewCtl.audioCtl:playEffectWithInterval(self._mainViewCtl.audio_list[musicFile])
			end
			if self._mainViewCtl:checkIsFastStop() then 
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2])
			else
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2]+extraCount)
			end
			if cell and bole.isValidNode(cell.tipNode) then
				local s = nil
				local tipAnim = nil
				if willGetFeature then
					s, tipAnim = bole.addSpineAnimation(cell.tipNode, item, scatterFile, cc.p(0,0), startAni, nil, nil, nil, true)
					tipAnim:addAnimation(0, loopAni, true)
				else
					s, tipAnim = bole.addSpineAnimation(cell.tipNode, item, scatterFile, cc.p(0,0), loopAni, nil, nil, nil, true, true)
				end
				if item == 30 or item == 31 then
					cell.ingotNode:setLocalZOrder(50)
					cell.tipNode:setLocalZOrder(100)
				else
					cell.ingotNode:setLocalZOrder(100)
					cell.tipNode:setLocalZOrder(50)
				end
				if key == 10 then
					cell.symbolTipAnim = tipAnim
					local a1 = cc.DelayTime:create(5/30)
					local a2 = cc.CallFunc:create(function ( ... )
						if cell and cell.sprite and bole.isValidNode(cell.sprite) then 
							cell.sprite:setVisible(false)
						end
						-- if bole.isValidNode(tipAnim) then
						-- 	bole.changeParent(tipAnim, self.animateNode)
						-- 	local pos = self._mainViewCtl:getCellPos(crPos[1], crPos[2])
						-- 	tipAnim:setPosition(pos)
						-- end 
					end)
					local a3 = cc.Sequence:create(a1,a2)
					tipAnim:runAction(a3)
				end
				-- if key == 11 then 
				-- 	self:setCellAniOrder(key,crPos[1],crPos[2],nil,self._mainViewCtl:getCellPos(crPos[1], crPos[2]),nil,willGetFeature)
				-- end
			end
		end
	end
end


-- function cls:_adaptLogoNodeTip( ... )
--     if not self.progressiveNode then return end
--     self.logoNode = cc.Node:create()
--     self.progressiveNode:addChild(self.logoNode, -1)
--     self.logoNode:setPosition(0, 560)
--     if self._mainViewCtl:adaptationLongScreen() then
--         local file1 = self._mainViewCtl:getSpineFile("logo_spine")
--         bole.addSpineAnimation(self.logoNode, nil, file1, cc.p(0, 0), "animation", nil, nil, nil, true, true)
--         self.logoNode:setVisible(true)
--     else
--         self.logoNode:setVisible(false)
--     end
--     self.logoNode:setScale(1.5)
-- end

function cls:getBoardNodeList( ... )
	return self.boardNodeList
end

function cls:playTransition(endCallBack, tType)--过渡
    local transition = ThemeBaseTransitionControl.new(self._mainViewCtl, endCallBack)
    local transition_config = self.gameConfig.transition_config
    local config = {}
    local endTm = transition_config[tType].onEnd
    config.path = "spine/" .. self.gameConfig.spine_path[transition_config[tType].spine]
    config.audio = "transition_" .. tType
	
    config.animName = "animation"
	-- if tType == "super_free" then config.animName = "animation2" end 
    config.endTime = endTm
    transition:play(config)
end


------scatter动画
function cls:playScatterAnimate(theSpecials, notLoop)
    for col, rowTagList in pairs(theSpecials[self.gameConfig.special_symbol.scatter]) do  ----base里不会出现retrigger，只有scatter
        for row, tagValue in pairs(rowTagList) do
            local animName = self.gameConfig.scatterAniCfg["zj_ani"]
            self:addItemSpine(nil, col, row, animName, notLoop)
        end
    end
	
end

function cls:addItemSpine(spineFile, col, row, animName, isNotLoop)--scatter中奖
    local layer = self.animateNode
    local animName = animName or self.gameConfig.scatterAniCfg["zj_ani"]
    local isLoop = not isNotLoop
    
    local pos = self._mainViewCtl:getCellPos(col, row)
    local spineFile = spineFile or self._mainViewCtl:getPic(self.gameConfig.scatterAniCfg["path"])
    local cell = self.spinLayer.spins[col]:getRetCell(row)
    cell:setVisible(false)
    local _, s1 = self._mainViewCtl:addSpineAnimation(layer, 100, spineFile, pos, animName, nil, nil, nil, true, isLoop)
	-- if isNotLoop then 
	-- 	local a1 = cc.DelayTime:create(88/30)
	-- 	local a2 = cc.CallFunc:create(function ()
	-- 		bole.spChangeAnimation(s1, "animation1")
	-- 	end)
	-- 	local a4 = cc.Sequence:create(a1, a2)

	-- end
end

function cls:playRespinAnimate(itemList, fromBonus)
	local itemList = itemList
	if not itemList then return end
	self:stopDrawAnimate()
	if fromBonus then
		for col = 1, #itemList do
			local key = itemList[col]
			if key >= 22 then
				local node = self:setCellAniOrder(key, col, 1, nil, self._mainViewCtl:getCellPos(col,1),true,nil,true)
				self._mainViewCtl:laterCallBack(89/30, function ()
					node:removeFromParent()
					node = nil             
				end)
			end
		end
	else
		for col, list in ipairs(itemList) do
			for row, key in ipairs(list) do
				if key >= 22 then
					self:setCellAniOrder(key, col, row, nil, self._mainViewCtl:getCellPos(col,row),nil,nil,true)
				end
			end
		end
	end
end



---------------welcomeDialog处理-------------
function cls:playWelcomeDialog()
	local theData = {}
    local cabName = "dialog_welcome"
    local dialogName = "welcome_start"
    theData.click_event = function ( ... )
        self.wheelStartDialog = nil
	end
	self.wheelStartDialog = self._mainViewCtl:showThemeDialog(theData, 1, cabName, dialogName)
	self._mainViewCtl:laterCallBack(4, function()
		self:closeWelcomeTip()
	end)
end

function cls:closeWelcomeTip()
	if self.wheelStartDialog and bole.isValidNode(self.wheelStartDialog) then 
		local startRoot = self.wheelStartDialog.startRoot
		if startRoot and startRoot.btnStart then 
			startRoot.btnStart:setTouchEnabled(false)
			self.wheelStartDialog:clickStartBtn()
			self.wheelStartDialog = nil
		end
	end
end

function cls:playWelComStart()
	self:closeWelcomeTip()
end

-- function cls:inTable(val, list)
-- 	for i  = 1, #list do
-- 		if val == list[1] then 
-- 			return i
-- 		end
-- 	end
-- 	return false
-- end

------------------激励动画 start-------------------
function cls:addSpecailJili()
	local parent = self.themeAnimateKuang
	-- local parent = self.animateNode
	local file = self._mainViewCtl:getSpineFile("specialEncourage")
	-- self:showBaseBlackCover(210, self.board_top_dimmer)
    -- self:showBaseBlackCover(210, self.board_bottom_dimmer)
	self.board_dimmer:setVisible(true)
        self.board_dimmer:setOpacity(0)
        self.board_dimmer:runAction(
            cc.Sequence:create(
                cc.FadeIn:create(0.5)
            )
        )
	
	bole.addSpineAnimationInTheme(parent, nil, file, cc.p(640, 360-5), "animation")
	-- self:hideBaseBlackCover(3/30, 5, self.board_top_dimmer)
	-- self:hideBaseBlackCover(3/30, 5, self.board_bottom_dimmer)
	-- self.board_dimmer:setVisible(true)
        -- coin_bg:setOpacity(0)
        self.board_dimmer:runAction(
            cc.Sequence:create(
				cc.DelayTime:create(80/30),
                cc.FadeOut:create(0.5)
            )
        )
	self._mainViewCtl:playMusicByName("board_jili")
	return 80/30
end

function cls:showBaseBlackCover(opacity, dimmer)
    local node = dimmer or self.transitionDimmer
    node:setOpacity(0)
    node:setVisible(true)
    node:stopAllActions()
    local a1 = cc.FadeTo:create(0.5, opacity or 200)
    node:runAction(a1)
end

function cls:hideBaseBlackCover( delay, wiatDelay ,dimmer)
    local node = dimmer or self.transitionDimmer
	wiatDelay = wiatDelay or 0
    local a0 = cc.DelayTime:create(wiatDelay)
    local a1 = cc.FadeTo:create(delay or 0.5 , 0)
    local a2 = cc.DelayTime:create(delay or 0.5)
    local a3 = cc.CallFunc:create(function(...)
       node:setVisible(false)
       node = nil
    end)
    local a4 = cc.Sequence:create(a0, a1, a2, a3)
	if wiatDelay == 0 then
		node:stopAllActions()
	end
    node:runAction(a4)
end
------------------激励动画 end  -------------------


------------------中奖连线处理-------------------
function cls:getEndCol(index, cols)
	if index == 3 then return 5
	elseif index == 4 then return 6
	elseif index == 5 then
		return cols[index] + 6
	end
end

function cls:fixWinLineData(winLineData)
	local newTable = {}
	for index = 1, 3 do
		if index ~= winLineData[1] then
			newTable[index] = -1
		else 
			newTable[index] = 0
		end
	end
	for index = 4, 6 do
		newTable[index] = winLineData[index - 2]
	end

	for index = 7, 9 do
		if index - 6 ~= winLineData[5] then
			newTable[index] = -1
		else 
			newTable[index] = 0
		end
	end
	return newTable
end

-- function cls:getStartRow(col, row, item_list)
-- 	local span = row
-- 	while span - 1 > 0  do
-- 		if item_list[col][span] == item_list[col][span - 1] then
-- 			span = span - 1
-- 		else
-- 			break
-- 		end
-- 	end
-- 	while row + 1 < 5 do
-- 		if item_list[col][row] == item_list[col][row + 1] then
-- 			row = row + 1
-- 		else
-- 			break
-- 		end
-- 	end
-- 	return span, row
-- end


-- function cls:getResultList(winPosList, itemList)
-- 	local finalResult = {{{},{}},{{},{}},{{},{}}}
-- 	local reelResult = {}
-- 	-- for col = 1, 3 do
-- 	-- 	for row = 1, 2 do
-- 	-- 		finalResult[col][row] = reelResult
-- 	-- 	end
-- 	-- end
-- 	for _,pos in ipairs(winPosList) do
-- 		local col = pos[1]
-- 		local row = pos[2]
-- 		local key = itemList[col][row]
-- 		if col > 3 and col < 7  and (key == 12 or key == 13) then
-- 			local startRow, endRow = self:getStartRow(col, row, itemList)
-- 			if endRow - startRow > 0 then
-- 				finalResult[col - 3][key - 11]["startRow"] = startRow
-- 				finalResult[col - 3][key - 11]["endRow"] = endRow
-- 			end
-- 		end
-- 	end
-- 	return finalResult
-- end
function cls:onSpinStart()
	self:playWelComStart()
	self.changeCombine = nil
end

function cls:showChangeCombieAni()
	local item_list = self._mainViewCtl.item_list
	if item_list then
		for col, val in ipairs(item_list) do
			for row, item in ipairs(val) do
				local cell = self:getCellItem(col, row)
				if cell then
					local staticAnimate = cell.staticAnimate
					if staticAnimate and bole.isValidNode(staticAnimate) and #staticAnimate:getChildren() > 0 then
						staticAnimate:setVisible(true)
						cell:setLocalZOrder(1000)
					end
				end
			end
		end
	end
	self.changeCombine = nil
end


function cls:addCombineAni(finalResult, wildResult)
	-- 添加合成动画，并且修改底部的资源图片
	local fileNv = self._mainViewCtl:getSpineFile("change_13")
	local fileNan = self._mainViewCtl:getSpineFile("change_12")
	local fileWild = self._mainViewCtl:getSpineFile("symbol_wild")
	self.changeCombine = true
	self._mainViewCtl.audioCtl:playEffectWithInterval(self._mainViewCtl.audio_list.wild_appear, 0.1)
	self:addCombineWildAni(wildResult, fileNv, fileNan, fileWild)
	self:addCombineLongSymbolAni(finalResult, fileNv, fileNan, fileWild)
end

function cls:addCombineWildAni(wildResult, fileNv, fileNan, fileWild)
	if wildResult and #wildResult > 0 then
		for key, val in ipairs(wildResult) do
			local col = val[1]
			local row = val[2]
			local item = val[3]
			local cell = self:getCellItem(col, row)
			local pos = self._mainViewCtl:getCellPos(col,row)
			local staticAnimate = cell.staticAnimate

			local sprite = cell.sprite
			sprite:setVisible(false)
			
			local file = fileNv
			if item == 12 then
				file = fileNan
			end

			local nodeStatic = cc.Node:create()
			staticAnimate:addChild(nodeStatic)

			self._mainViewCtl:addSpineAnimation(nodeStatic, nil, file, cc.p(0, 0), "animation1_2", nil,nil,nil,true,false) 
			self._mainViewCtl:addSpineAnimation(nodeStatic, nil, fileWild, cc.p(0, 0), "animation3", nil,nil,nil,true,false) 

			local node = cc.Node:create()
			node:setPosition(pos)
			self.animateNode:addChild(node)

			local _, s1 = self._mainViewCtl:addSpineAnimation(node, nil, file, cc.p(0, 0), "animation1_1", nil,nil,nil,true,false) 
			local _, s2 = self._mainViewCtl:addSpineAnimation(node, 1000, fileWild, cc.p(0, 0), "animation1", nil,nil,nil,true,false) 
			self.symbolsSkeleton = self.symbolsSkeleton or {}
			self.symbolsSkeleton[col.."_"..row] = {}	
			self.symbolsSkeleton[col.."_"..row] = {s1, "animation1_2", nil, s2, "animation2"}
		end
	end
end

function cls:addCombineLongSymbolAni(finalResult, fileNv, fileNan, fileWild)

	if finalResult and #finalResult > 0 then
		for startcol, val in ipairs(finalResult) do
			for index = 1, 2 do
				local symbolList = val[index]
				if symbolList and symbolList.startRow then
					-- 开始添加动画，并且判断是不是需要变化
					local col = startcol + 3
					local cell = self:getCellItem(col, symbolList.startRow)
					local posStart = self._mainViewCtl:getCellPos(col, symbolList.startRow)
					
					local startRow = symbolList.startRow 
					local endRow = symbolList.endRow
					local disRow = endRow - symbolList.startRow + 1
					local posWild = cc.p(0, (startRow - endRow)*(self.gameConfig.G_CELL_HEIGHT + self.gameConfig.lineWidth))
					local itemKey = symbolList.item

					local staticAnimate = cell.staticAnimate
					local file = fileNv
					if itemKey == 12 then
						file = fileNan
					end

					local height = (disRow - 1) * (self.gameConfig.G_CELL_HEIGHT + self.gameConfig.lineWidth)
					local pos = cc.pAdd(posStart, cc.p(0, - height/2))
					local nodeStatic = cc.Node:create()
					staticAnimate:addChild(nodeStatic)
					local staticAni = "animation"..disRow.."_2"
					local combaAni = "animation"..disRow.."_1"
					local loopAni = "animation"..disRow
					staticAnimate:setVisible(false)

					local staticWAni = "animation3"
					local staticWLoop = "animation1"
					local wildAward = "animation2"

					self._mainViewCtl:addSpineAnimation(nodeStatic, nil, file, cc.p(0, -height/2), staticAni, nil,nil,nil,true,false) 
					local wildSpine = nil
					local node = cc.Node:create()
					self.animateNode:addChild(node, 20)
					-- node:setPosition(pos)
					local _,spine = self._mainViewCtl:addSpineAnimation(node, nil, file, pos, combaAni, nil,nil,nil,true,false) 
					local a
					if symbolList.changeWild then
						self._mainViewCtl:addSpineAnimation(nodeStatic, nil, fileWild, posWild, staticWAni, nil,nil,nil,true,false) 
						a, wildSpine = self._mainViewCtl:addSpineAnimation(node, 1000, fileWild, cc.pAdd(posWild, posStart), staticWLoop, nil,nil,nil,true,false) 
					end
					self.symbolsSkeleton = self.symbolsSkeleton or {}
					for i = startRow, endRow do
						local cell1 = self:getCellItem(col, i)
						self.symbolsSkeleton[col.."_"..i] = {}
						self.symbolsSkeleton[col.."_"..i] = {spine, loopAni, nil, wildSpine, wildAward}
						if cell1 and cell1.sprite then
							cell1.sprite:setVisible(false)
							local theCellFile = self._mainViewCtl.pics[0]
							bole.updateSpriteWithFile(cell1.sprite, theCellFile)
						end
					end
				end
			end
		end
	end
end

function cls:drawLinesThemeAnimate( lines, layer, rets, specials,timeList, boardIndex)
	lines = lines or {}
	local payLines = self._mainViewCtl:getPayLines()
	local itemList  = rets["item_list"]
	local draw 	    = cc.Node:create()
	local symboldraw= cc.Node:create()
	local doFirst   = true
	local function drawEachLine(theLineData, tipIndex)
		self:showAllItem("draw")
		local lineIndex = theLineData[1]
		local cols 		= payLines[lineIndex]
		local begCol 	= 1 -- 开始的列
		local endCol 	= self:getEndCol(theLineData[2], cols) -- 结束的列
		cols  = self:fixWinLineData(cols)
		local symbol 	= theLineData[3] -- 中奖 symbol
		local adjustCol = 1 -- 每次增量 1 
		if theLineData[4] then
			begCol 		= #self.spinLayer.spins
			endCol 		= #self.spinLayer.spins - theLineData[2] + 1
			adjustCol 	= -1
		end
		local effectStatus 	= "half"
		for col = begCol, endCol, adjustCol do
			local row = cols[col] + 1
			if cols[col] ~= -1 then
				local sprite = self:drawPayLineItem(col+theLineData.col_ck, row, specials, itemList, effectStatus, tipIndex,symboldraw)
				if sprite then draw:addChild(sprite) end
			end
		end
	end
	local function drawEachCRPosGroup(theGroupItem, theGroupCRPosList, tipIndex)
		self:showAllItem("draw")
		draw:removeAllChildren()
		local effectStatus 	= "half"
		for _,crPos in ipairs(theGroupCRPosList) do
			local col = crPos[1]
			local row = crPos[2]
			local sprite = self:drawPayLineItem(col, row, specials, itemList, effectStatus, tipIndex,symboldraw)
			if sprite then draw:addChild(sprite) end
		end
	end
	local function drawAllWinPos(winPosList)
		self:showAllItem("draw")
		draw:removeAllChildren()
		local effectStatus 	= "all"
		if doFirst then
			effectStatus = "all_first"
			doFirst = false
		end		
		local tipIndex      = 0
		for _, theData in pairs(winPosList) do
			local col = theData[1] -- 列
			local row = theData[2] -- 行
			local sprite = self:drawPayLineItem(col, row, specials, itemList, effectStatus, tipIndex,symboldraw)
			if sprite then draw:addChild(sprite) end			
		end
		-- self.fuse_flag = 2
	end
	self.animateNode:addChild(symboldraw,2)
	if self.themeAnimateKuang then -- whj 添加存放中奖连线框动画，让他始终在 动画曾的最上面，包括lock 动画
		self.themeAnimateKuang:addChild(draw,10)
	else
		self.animateNode:addChild(draw,10)
	end
	
	if rets and rets["win_pos_list"] and #rets["win_pos_list"]>0 then
		local delay = 0		
		self.fuse_flag = 1
		draw:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(function()
			local asList = {}
			local a1 = cc.CallFunc:create(function()
				drawAllWinPos(rets["win_pos_list"])
			end)
			local a2 = cc.DelayTime:create(timeList and timeList[1] or 3)
			table.insert(asList, a1) -- 同时播放动画放到数组中
			table.insert(asList, a2)
			local tipIndex = 0
			if self.winCRPosGroupList and bole.getTableCount(self.winCRPosGroupList)>0 then
				for theItem,theCRPosList in pairs(self.winCRPosGroupList) do
					tipIndex = tipIndex + 1
					local g1 = cc.CallFunc:create(function()
						drawEachCRPosGroup(theItem, theCRPosList, tipIndex)
					end)
					local g2 = cc.DelayTime:create(timeList and timeList[2] or 1)
					table.insert(asList, g1) -- 特殊的 单条线播放
					table.insert(asList, g2)
				end				
			end
			local sameTimePlay = false
			for index,theLineData in pairs(lines) do
				if theLineData.play_idx then sameTimePlay = true; break end

				tipIndex = tipIndex + 1
				local t1 = cc.CallFunc:create(function()
					draw:removeAllChildren()
					drawEachLine(theLineData, tipIndex)
				end)
				local t2 = cc.DelayTime:create(timeList and timeList[2] or 1)
				table.insert(asList, t1)-- 普通的单条线播放
				table.insert(asList, t2)
			end
			--多表同时播
			if sameTimePlay then
				for i=1, 100 do
					local iIndexs = {}
					for index,theLineData in ipairs(lines) do
						if theLineData.play_idx == i then
							table.insert(iIndexs, theLineData)
						end
					end
					if #iIndexs == 0 then
						break
					else
						local t1 = cc.CallFunc:create(function()
							draw:removeAllChildren()
							for k,v in ipairs(iIndexs) do
								drawEachLine(v, i)
							end
						end)
						local t2 = cc.DelayTime:create(timeList and timeList[2] or 1)
						table.insert(asList, t1) -- 线排序 然后播放动画
						table.insert(asList, t2)
					end
				end
			end
			draw:runAction(cc.RepeatForever:create(cc.Sequence:create(bole.unpack(asList))))
		end)))
	end	
end

function cls:setCellAniOrder(key, col, row, parent, pos, fromBonus, willGetFeature, winBonus)
	if not key then return end
	key  = fromBonus and key or self._mainViewCtl.item_list[col][row]
	pos = pos or cc.p(0,0)
	parent = parent or self.animateNode
	local node = cc.Node:create()
	parent:addChild(node)
	local zorder = 2
	local spritePng = "#theme240_s_11.png"
	if key == 31  then
		spritePng = "#theme240_s_20.png"
	end
	if key == 30 or key == 31 then
		zorder = 4
	end
	local theCellSprite = bole.createSpriteWithFile(spritePng)
	node:addChild(theCellSprite,1)
	local tipNode = cc.Node:create()
	node:addChild(tipNode,zorder)
	local spineNode = cc.Node:create()
	node:addChild(spineNode,3)
	node.theCellSprite = theCellSprite
	node.tipNode = tipNode
	node.spineNode = spineNode

	local fontRate = nil
	if self.gameConfig.epicLinkMul[key] then
		fontRate = self.gameConfig.epicLinkMul[key]
	end
	if fontRate then
		local labelCoin = self:getSymbolLabel(fontRate)
		local str = FONTS.formatByCount4(labelCoin,4,true)
		local label = cc.Label:createWithBMFont(self._mainViewCtl:getPic("font/theme240_font_4.fnt"), str)
		spineNode:addChild(label)
	elseif self.gameConfig.jpEpicLinkMul[key] then
		local sprite = bole.createSpriteWithFile("#theme240_jp_"..key..".png")
		spineNode:addChild(sprite)
	elseif self.gameConfig.specialEpicLinkMul[key] then
		local sprite = bole.createSpriteWithFile("#theme240_special_"..key..".png")
		spineNode:addChild(sprite)
	end
	local aniName = "animation1"
	local aniNameLoop = "animation1_1"
	local aniNameWin = "animation1_2"
	if key == 30 then
		aniName = "animation2"
		aniNameLoop = "animation2_1"
		aniNameWin ="animation2_2"
	elseif key == 31 then
		aniName = "animation3"
		aniNameLoop = "animation3_1"
		aniNameWin ="animation3_2"
	end

	if not winBonus then
		if willGetFeature then
			local s, tipAnim = bole.addSpineAnimation(node.tipNode, key, self._mainViewCtl:getPic("spine/respin/bonus"), cc.p(0,0), aniName, nil, nil, nil, true)
			tipAnim:addAnimation(0, aniNameLoop, true)
		else
			bole.addSpineAnimation(node.tipNode, key, self._mainViewCtl:getPic("spine/respin/bonus"), cc.p(0,0), aniNameLoop, nil, nil, nil, true, true)
		end
	else
		bole.addSpineAnimation(node.tipNode, key, self._mainViewCtl:getPic("spine/respin/bonus"), cc.p(0,0), aniNameWin, nil, nil, nil, true, false)
	end
	-- if self._mainViewCtl:getHighDiamondSymbol(item) then 
	-- 	aniName = "animation4"
	-- 	aniNameLoop = "animation4"
	-- end

	-- if fromBonus then 
	-- 	local scatterFile = self._mainViewCtl:getPic("spine/item/14/spine")
	-- 	local isLoop = true
	-- 	local s, tipAnim = bole.addSpineAnimationInTheme(spineNode, nil, scatterFile, cc.p(0,0), aniName, nil, nil, nil, true, isLoop)
	-- 	node.tipAnim = tipAnim
	-- 	theCellSprite:setVisible(false)
	-- 	if isShow then 
	-- 		isLoop = false
	-- 		aniName = "animation7"
	-- 		labelNode:setScale(0)
	-- 		local a1 = cc.DelayTime:create(8/30)
	-- 		local a2 = cc.ScaleTo:create(5/30, 1.15 * labelNode.baseScale)
	-- 		local a3 = cc.ScaleTo:create(3/30, 0.95 * labelNode.baseScale)
	-- 		local a4 = cc.ScaleTo:create(2/30, 1 * labelNode.baseScale)
	-- 		local a5 = cc.Sequence:create(a1,a2,a3,a4)
	-- 		labelNode:runAction(a5)
	-- 		tipAnim:addAnimation(0, aniNameLoop, true)
	-- 	end
	-- end

	-- node.aniNameLoop = aniNameLoop

	-- node.theCellSprite = theCellSprite
	-- node.spineNode = spineNode
	-- node.labelNode = labelNode
	node:setPosition(pos)
	-- self.diamondList[col][row] = node 
	return node
end

return cls

