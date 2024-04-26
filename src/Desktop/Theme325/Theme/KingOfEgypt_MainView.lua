-- @Author: xiongmeng
-- @Date:   2020-11-10 10:31:23
-- @Last Modified by:   xiongmeng
-- @Last Modified time: 2020-12-02 18:18:54
-- 219 @math:liangyingjie,ui:fengsijia,plan:wujunhao

local parentCls = ThemeBaseView
local cls = class("KingOfEgypt_MainView", parentCls)
local gameMasterTipShowStatus = {}
function cls:ctor( ctl )
	self._mainViewCtl= ctl
	self.gameConfig = self._mainViewCtl:getGameConfig()
	
	EventCenter:registerEvent(EVENTNAMES.THEME.SET_HELPSHIFT, "theme325_base", self.changeHelpshiftBtnEnable, self)
	
	gameMasterTipShowStatus = self.gameConfig.gameMasterStatus
	self.UnderPressure = self.gameConfig.init_config.underPressure
	parentCls.ctor(self, ctl)

end

--@csb init interface
function cls:initScene( ... )
	self:_initBaseNode()
	self:_initBaseReelBg()
	self:_initBgNode()
	self:_initJackpotNode()
	self:_initCollectNode()
	self:_initFreeGameNode()
	self:_initMapNode()
	self:_adaptLogoNode()
	self:_initHelpshiftBtn()

	self:_initGameMasterTip()
	self._mainViewCtl.hideGameRuleList = {true,nil,nil,true}

	self.footerTipParent = cc.Node:create()
	self._mainViewCtl:curSceneAddToTop(self.footerTipParent)
end

--@add board
function cls:initBoardNodes( pBoardConfigList )
	
	local boardRoot = self.boardRoot
	local boardConfigList = pBoardConfigList or self._mainViewCtl:getBoardConfig() or {}
	local reelZorder 	  = 100
	self.clipData = {}
	local pBoardNodeList = {}
	for boardIndex, theConfig in ipairs(boardConfigList) do
		local theBoardNode = nil
		local reelNodes = {}
		local reelClipNodes = {}
		theBoardNode = cc.Node:create()
		boardRoot:addChild(theBoardNode)

		self:initBoardNodesByNormal(reelNodes, theConfig, reelZorder, theBoardNode, reelClipNodes)

		theBoardNode.reelNodes 	   = reelNodes
		theBoardNode.reelClipNodes = reelClipNodes
		theBoardNode.reelConfig    = theConfig["reelConfig"]
		theBoardNode.boardIndex    = boardIndex
		theBoardNode.getReelNode   = function(theSelf,index)
			return theSelf.reelNodes[index]
		end
		theBoardNode.getReelClipNodes = function(theSelf, index)
            return theSelf.reelClipNodes[index]
        end
		pBoardNodeList[boardIndex] = theBoardNode
	end
	self:initBoardTouchBtn(boardConfigList, pBoardNodeList)
	return pBoardNodeList
end
function cls:initBoardNodesByNormal( reelNodes, theConfig, reelZorder, theBoardNode, reelClipNodes )
	self.clipData["normal"] = {}
	
	local reelNode = nil
	for reelIndex, config in ipairs(theConfig["reelConfig"]) do

		local cellCenterNode = cc.Node:create()
		-- cellCenterNode:setPosition(cc.p(250, 267))
		-- local reCellCenterNode = cc.Node:create()
		-- reCellCenterNode:setPosition(cc.p(-250, -267))
		-- cellCenterNode:addChild(reCellCenterNode)

		local reelNode = cc.Node:create()
		reelNode:setLocalZOrder(reelZorder)

		local vex = {
			config["base_pos"],
			cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], 0)),
			cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], config["cellHeight"]*config["symbolCount"])),
			cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"]*config["symbolCount"])),
		}
		if theConfig["allow_over_range"] then
			vex[1] = cc.pAdd(vex[1], cc.p(-config["cellWidth"], 0))
			vex[4] = cc.pAdd(vex[4], cc.p(-config["cellWidth"], 0))
			vex[2] = cc.pAdd(vex[2], cc.p(config["cellWidth"], 0))
			vex[3] = cc.pAdd(vex[3], cc.p(config["cellWidth"], 0))
		end
		-- if reelIndex == 1 then
		-- 	local down_rx = config.cellWidth * 6
		-- 	local boardH = config.cellHeight * config.symbolCount
		-- 	self:initTouchSpinBtn(config["base_pos"], down_rx, boardH)
		-- end

		local stencil = cc.DrawNode:create()
		stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))

		local clipAreaNode = cc.Node:create()
		clipAreaNode:addChild(stencil)

		local clipNode = cc.ClippingNode:create(clipAreaNode)
		clipNode:addChild(reelNode)

		-- theBoardNode:addChild(clipNode, reelIndex * 10)
		theBoardNode:addChild(cellCenterNode, reelIndex * 10)
		cellCenterNode:addChild(clipNode)

		reelNodes[reelIndex] = reelNode
		reelClipNodes[reelIndex] = clipNode
		reelClipNodes[reelIndex].centerParent = cellCenterNode
		self.clipData["normal"][reelIndex] = {}
		self.clipData["normal"][reelIndex]["vex"] = vex
		self.clipData["normal"][reelIndex]["stencil"] = stencil
	end
	-- local clipNode = cc.ClippingNode:create(clipAreaNode)
	-- theBoardNode:addChild(clipNode)
	-- clipNode:addChild(reelNode)
end

--------------- add spinboard spin start ---------------
function cls:initBoardTouchBtn(boardConfigList, pBoardNodeList)
    local base_config = boardConfigList
	self.boardMoveBtn = nil
    for key = 1, #boardConfigList do
        local reelConfig = base_config[key].reelConfig
        local base_pos = table.copy(reelConfig[1].base_pos)
        local boardW = reelConfig[1].cellWidth * 6 + 5 * 4
        local boardH = reelConfig[1].cellHeight * reelConfig[1].symbolCount
		self:initTouchSpinBtn(base_pos, boardW , boardH, pBoardNodeList[key])
    end
end

function cls:initTouchSpinBtn(base_pos, boardW, boardH, parent, iscenter)
	local unitSize = 10
    local img = "commonpics/kong.png"
    local touchSpin = function()
        self._mainViewCtl:footerCopySpinBtnEvent()
    end
    local touchBtn = Widget.newButton(touchSpin, img, img, img, false) --10
    touchBtn:setPosition(base_pos)
	local anchorPos = cc.p(0, 0)
	if iscenter then 
		anchorPos = cc.p(0.5, 0)
	end
    touchBtn:setAnchorPoint(anchorPos)
    touchBtn:setScaleX(boardW / unitSize)
    touchBtn:setScaleY(boardH / unitSize)
	touchBtn:setOpacity(100)
    parent:addChild(touchBtn)
	touchBtn.scaleY = boardH / unitSize
	return touchBtn
end

--------------- add spinboard spin end ---------------
-- function cls:initTouchSpinBtn(base_pos, boardW, boardH)
-- 	local unitSize = 10
--     local parent = self.boardRoot
--     local img = "commonpics/kong.png"
--     local touchSpin = function()
--         if self._mainViewCtl:getCanTouchFeature() then
--             self._mainViewCtl:toSpin()
--         end
--     end
--     local touchBtn = Widget.newButton(touchSpin, img, img, img, false) --10
--     touchBtn:setPosition(base_pos)
--     touchBtn:setAnchorPoint(cc.p(0, 0))
--     touchBtn:setScaleX(boardW / unitSize)
--     touchBtn:setScaleY(boardH / unitSize)
--     parent:addChild(touchBtn)
-- end

function cls:_initBaseNode( ... )
	local path = self._mainViewCtl:getPic("csb/base_game.csb")
	self.mainThemeScene = libUI.createCsb(path)
	self.shakerNode = self.mainThemeScene:getChildByName("shake_node")
	self.down_node 		= self.shakerNode:getChildByName("down_child")
	self.down_child 	= self.down_node:getChildByName("down_child")
	self.reelRootNode   = self.down_child:getChildByName("reel_root_node")
	self.board = self.reelRootNode:getChildByName("board")
	self.jiliScatterBg = self.reelRootNode:getChildByName("jili_bg")
	self.jiliScatterBg:setPosition(cc.p(-640, -360))
	self.boardRoot      = self.reelRootNode:getChildByName("board_root")
	self.animateNodeParent = self.down_child:getChildByName("ani_board")
	self.animateNode = self.animateNodeParent:getChildByName("animate_node")
	self.reelCoinFlyLayer = self.animateNodeParent:getChildByName("fly_node")
	self.themeAnimateKuang = self.animateNodeParent:getChildByName("kuang_node")

	self.jiliReelUp = cc.Node:create()
	self.animateNodeParent:addChild(self.jiliReelUp, -1)

	self.specailJili = cc.Node:create()
	self.shakerNode:addChild(self.specailJili)
	bole.adaptScale(self.mainThemeScene,false)
	self.shakyNode:addChild(self.mainThemeScene)
end
function cls:updateCollectUI( pType )
	local showCollect = {true, false, false} -- normal, free, mapfree
	if pType then
		self:setCollectNodeInGoldSpin(showCollect[pType])
	end
end
function cls:setCollectNodeInGoldSpin(enable)
	enable = enable or false
	if self._mainViewCtl:getGoldSpinStatus() then 
		enable = false
	end
	self.collectNode:setVisible(enable)
end
function cls:refreshCellsZOrder( pCol )
	self:refreshColCellsZOrder(pCol)
end
function cls:_initBaseReelBg()
	self.baseBoard = self.board:getChildByName("base_board")
	self.baseBoardAnim = self.baseBoard:getChildByName("reel_anim")
	
	self.reelBgBase = self.baseBoard:getChildByName("bg")
	self.reelBgMoon = self.baseBoard:getChildByName("bg_moon")
	self.reelBgSun = self.baseBoard:getChildByName("bg_sun")

	local bg = self.baseBoard:getChildByName("bg_board")
	bg:setPosition(cc.p(-640, -360))
	self.baseBgParent = bg
	self.bigBoardBgList = {}
	for col, node in pairs(bg:getChildren()) do
		self.bigBoardBgList[col] = node
		local basePos = bole.getPos(node)
		local normalPos = cc.pAdd(basePos, cc.p(640, 360))
		local topPos = cc.pAdd(basePos, cc.p(640, 360 + 8))
		self.bigBoardBgList[col].basePos = basePos
		self.bigBoardBgList[col].normalPos = normalPos
		self.bigBoardBgList[col].topPos = topPos
		self.bigBoardBgList[col]:setPosition(normalPos)
	end
end

function cls:_initBgNode( ... )
	self.bgNode = self.mainThemeScene:getChildByName("theme_bg")
	self.baseBgNode = self.bgNode:getChildByName("bg_base") 
	self.freeMoonBgNode = self.bgNode:getChildByName("bg_moon")
	self.freeSunBgNode = self.bgNode:getChildByName("bg_sun")
	-- self.mapFreeMoonBgNode = self.bgNode:getChildByName("bg_mapfree")
	self.baseBgSpine = self.bgNode:getChildByName("bg_spine")
	self.baseBgSpine:setVisible(true)
	self.currentBg = self.baseBgNode
	self.freeMoonBgNode:setVisible(false)
	self.freeSunBgNode:setVisible(false)
	self:initBgListen()
end

---@param pType 1 base  2 moon 3 sun
function cls:updateBg( pType )
	local bgUI = {self.baseBgNode, self.freeMoonBgNode, self.freeSunBgNode}
	local showBg = bgUI[pType]
	self.baseBgNode:stopAllActions()
	-- if pType == 1 then 
	-- 	self.baseBgNode.canTouch = true 
	-- else 
	-- 	self.baseBgNode.canTouch = false
	-- end
	if self.currentBg ~= showBg then
		showBg:setVisible(true)
		self.currentBg:setVisible(false)
		self.currentBg = showBg
	end

	if bole.isValidNode(self.reelBgBase) then
		self.reelBgBase:setVisible(pType == 1)
	end
	if bole.isValidNode(self.reelBgMoon) then
		self.reelBgMoon:setVisible(pType == 2)
	end
	if bole.isValidNode(self.reelBgSun) then
		self.reelBgSun:setVisible(pType == 3)
	end

	self:addBgSpine(pType)
end
function cls:initBgListen()
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)

	-- local winSize = cc.Director:getInstance():getWinSize()
    -- FRAME_WIDTH = winSize.width
    -- FRAME_HEIGHT = winSize.height
	
	 local function onTouchBegan (touch, event)
        if self.baseBgNode.canTouch then
            self.baseBgNode.startPosition = cc.p(touch:getLocation())
            return true
        end
        return true
    end
    local function onTouchCancelled (touch, event)
        self.baseBgNode.startPosition = nil
    end

	local function onTouchEnded (touch, event)
		--并且在某个范围内才行
        if self.baseBgNode.startPosition and self.baseBgNode.canTouch then
            local target = event:getCurrentTarget()
			local location = touch:getLocation()
			if self:judgmentEffectiveCon(location) then 
				self:chooseGameSelectBtnClickFunc(location)
			end
        end
    end

	self.baseBgNode.canTouch = true
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED) -- 同楼上
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = self.baseBgNode:getEventDispatcher() -- 通过它管理当前节点（场景、层、精灵等）的所有事件的分发。
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.baseBgNode)-- 添加一个事件监听器到事件派发器
end
function cls:judgmentEffectiveCon(pos)
	if not pos then return false end 
	local topHeight = 67 * HEADER_FOOTER_SCALE
	local bottomHeight = 93 * HEADER_FOOTER_SCALE
	if (pos.y <= FRAME_HEIGHT - topHeight) and (pos.y >= bottomHeight) then 
		return true
	end
	return false
end
function cls:chooseGameSelectBtnClickFunc(worldPos)
	local bgType = self._mainViewCtl:getCurReelBoardType()
	local animName = "animation"
	if bgType and bgType == 2 then
		animName = "animation3"
	elseif bgType and bgType == 3 then
		animName = "animation2"
	end

	self._mainViewCtl:playMusicByName("bg_click")
    local data = {}
    data.file = self._mainViewCtl:getSpineFile("bg_touch")
	-- data.parent = self.baseBgNode
	data.parent = self.baseBgSpine
	data.animateName = animName
	
	data.pos = self.baseBgSpine:convertToNodeSpace(worldPos)
	self.baseBgNode.canTouch = false
	bole.addAnimationSimple(data)
	local a1 = cc.DelayTime:create(10/30)
	local a2 = cc.CallFunc:create(function ()
		self.baseBgNode.canTouch = true
	end)
	local a3 = cc.Sequence:create(a1, a2)
	libUI.runAction(self.baseBgNode, a3)
end

function cls:_adaptBaseBG()
     -- local bgHeight = 1560 / 2 
     -- local adaptPos = -FRAME_WIDTH / 2 + bgHeight
     -- self.bgNode:setPositionY(adaptPos)
end

---@param pType 1 base  2 moon 3 sun
function cls:addBgSpine( pType )
	pType = pType or 1
	self.baseBgSpine:removeAllChildren()
	self.baseBoardAnim:removeAllChildren()
	if pType == 1 then 
		local pFile = self._mainViewCtl:getParticleFile("bj_1")
		local lizi = cc.ParticleSystemQuad:create(pFile)
		self.baseBgSpine:addChild(lizi)

		local data = {}
		data.file = self._mainViewCtl:getSpineFile("bg_loop1")
		data.parent = self.baseBgSpine
		data.isLoop = true
		data.zOrder = -1
		bole.addAnimationSimple(data)

		local data2 = {}
		data2.file = self._mainViewCtl:getSpineFile("reel_loop1")
		data2.parent = self.baseBoardAnim
		data2.isLoop = true
		bole.addAnimationSimple(data2)
	else
		local data = {}
		data.file = self._mainViewCtl:getSpineFile("bg_loop2")
		data.parent = self.baseBgSpine
		data.isLoop = true
		data.zOrder = -1
		data.animateName = pType == 2 and "animation2" or "animation"
		bole.addAnimationSimple(data)

		local data2 = {}
		data2.file = self._mainViewCtl:getSpineFile("reel_loop2")
		data2.parent = self.baseBoardAnim
		data2.isLoop = true
		data2.animateName = pType == 2 and "animation2" or "animation1"
		bole.addAnimationSimple(data2)
	end
	local file = self._mainViewCtl:getSpineFile("bg_dec_loop"..pType)
	bole.addSpineAnimation(self.baseBgSpine, -1, file, cc.p(0,0), "animation", nil, nil, nil, true, true)
end

function cls:getSpecialFeatureRoot( pType )
	if pType == "jackpot" then
		if not bole.isValidNode(self.progressiveNode) then
			self.progressiveParent = self.down_child:getChildByName("progressive")
			self.progressiveNode = self.progressiveParent:getChildByName("progressive_node")
			self.progressiveTipParent = self.shakerNode:getChildByName("progressive_tip")
		end
		return {self.progressiveNode, self.progressiveTipParent}
	elseif pType == "collect" then
		if not bole.isValidNode(self.collectRoot) then
			self.collectNode = self.down_child:getChildByName("collect_feature_node")
			-- self.collectRoot = self.collectNode:getChildByName("root")
		end
		return self.collectRoot
	elseif pType == "map" then
		if not bole.isValidNode(self.mapParentNode) then
			self.mapParentNode = self.mainThemeScene:getChildByName("store_node")  
			-- self.mapParentNode = cc.Node:create()
			-- self._mainViewCtl:getCurScene():addToContentFooter(self.mapParentNode, 1)
		end
		return self.mapParentNode
	elseif pType == "free" then
		self.stickWild   = self.animateNodeParent:getChildByName("stick_wild")
		self.wildDimmer  = self.down_child:getChildByName("wild_dimmer")
		self.wildDimmer:setVisible(false)
		return {self.stickWild, self.wildDimmer}
	end
end
function cls:_initFreeGameNode( ... )
	local freeList = self:getSpecialFeatureRoot("free")
	if freeList then
		self._mainViewCtl:getFreeVCtl():initLayout(freeList)
	end
end
function cls:_initJackpotNode( ... )
	local jackpotNodeList = self:getSpecialFeatureRoot("jackpot") 
	if jackpotNodeList then
		self._mainViewCtl:getJpViewCtl():initLayout(jackpotNodeList)
	end
end
function cls:_initCollectNode( ... )
	local collectNode = self:getSpecialFeatureRoot("collect")
	if bole.isValidNode(collectNode) then
		self._mainViewCtl:getCollectViewCtl():initLayout(collectNode)
	end
end
function cls:_initMapNode( ... )
	local mapParent = self:getSpecialFeatureRoot("map")
	if bole.isValidNode(mapParent) then
		mapParent:setVisible(false)
		local data = self._mainViewCtl:getMapInfoData()
		self._mainViewCtl:getMapViewCtl():initLayout(mapParent, data)
	end
end
-- function cls:_initWheelNode()
-- 	local wheelParent = self:getSpecialFeatureRoot("wheel")
-- 	if bole.isValidNode(wheelParent) then
-- 		self._mainViewCtl:getWheelVCtl():initLayout(wheelParent)
-- 	end
-- end


---------------symbol start---------------
function cls:createCellSprite( key, col, rowIndex )
	key = 2
	self.recvItemList = self.recvItemList or {}
	self.recvItemList[col] = self.recvItemList[col] or {}
	self.recvItemList[col][rowIndex] = key
	------------------------------------------------------------
	local notInitSymbolSet = {}
	if self.gameConfig.symbol_config and self.gameConfig.symbol_config.not_init_symbol_set then 
		notInitSymbolSet = self.gameConfig.symbol_config.not_init_symbol_set
	end
	-- key = 2

    key = self._mainViewCtl:getNormalKey()  -- 创建普通的cell
	local theCellFile = self._mainViewCtl.pics[key]
	self.recvItemList[col][rowIndex] = key

	local theCellNode   = cc.Node:create()
	local theCellSprite = bole.createSpriteWithFile(theCellFile)
	theCellNode:addChild(theCellSprite)
	theCellNode.key 	  = key
	theCellNode.sprite 	  = theCellSprite
	theCellNode.curZOrder = 0

	local landAnimate = cc.Node:create()
	landAnimate:setScale(2)
    theCellNode.tipNode = landAnimate
    theCellNode:addChild(landAnimate, 50)
	
	theCellNode.themeBaseScale = 0.5
	theCellNode:setScale(theCellNode.themeBaseScale)

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
function cls:updateCellSprite( theCellNode, key, col, isShowResult, isReset, isNotChange )
	local theCellFile 	= self._mainViewCtl.pics[key]
	local theCellSprite = theCellNode.sprite
	-----------low symbol changeto major symbol --------------
	if (not isReset) and (not isShowResult) then
		if self._mainViewCtl:getMapFreeGameStatus() then 
			if self._mainViewCtl.freeCtl:removeLowSymbolStatus() then
				if self._mainViewCtl.LowSymbolList[key] then
					key = self._mainViewCtl:getMajorSymbol()
					theCellFile = self._mainViewCtl.pics[key]
				end
			elseif self._mainViewCtl.freeCtl:getYangSymbolStatus() then
				if key == self.gameConfig.special_symbol.sun then 
					key = self.gameConfig.special_symbol.sun_wild
				end
			elseif self._mainViewCtl.freeCtl:getYinSymbolStatus() then
				if key == self.gameConfig.special_symbol.moon then 
					key = self.gameConfig.special_symbol.moon_wild
				end
			end
		end
	end
	bole.updateSpriteWithFile(theCellSprite, theCellFile)
	theCellNode.key 	  = key
	theCellNode.curZOrder = 0
	------------------------------------------------------------
	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )	
	local theKey = theCellNode.key
	if self._mainViewCtl.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self._mainViewCtl.symbolZOrderList[theKey]
	end	
	theCellSprite:setAnchorPoint(cc.p(0.5, 0.5))
	if self._mainViewCtl.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self._mainViewCtl.symbolPosAdjustList[theKey])
	else
		theCellSprite:setPosition(cc.p(0,0))
	end	
	if (key == self.gameConfig.special_symbol.scatter) and (not isReset) then 
		self:addScatterTailAni(col, key, theCellNode, isShowResult)
	end

	if key ~= self.gameConfig.special_symbol.scatter and self.bigBoardBgList and self.bigBoardBgList[col] and self.bigBoardBgList[col].isShow then
		theCellSprite:setColor(cc.c3b(95,95,95))
	else
		theCellSprite:setColor(cc.c3b(255,255,255))
	end
end
function cls:adjustWithTheCellSpriteUpdate( theCellNode, key, col ) -- 删除掉 tip 动画
	if theCellNode.symbolTipAnim2 then
        if (not tolua.isnull(theCellNode.symbolTipAnim2)) then
            theCellNode.symbolTipAnim2:removeFromParent()
        end
        theCellNode.symbolTipAnim2 = nil
    end
	parentCls.adjustWithTheCellSpriteUpdate(self, theCellNode, key, col )
end
function cls:addScatterTailAni(col, key, theCellNode, isShowResult)
	if self._mainViewCtl.fastStopMusicTag then return end
	if isShowResult then
        return
	end
	local _, tuoWei = bole.addSpineAnimation(theCellNode, -1, self._mainViewCtl:getSpineFile("scatter_tail"), cc.p(0,0), "animation", nil, nil, nil, true)
	theCellNode.symbolTipAnim2 = tuoWei
	-- self._mainViewCtl.audioCtl:playEffectWithInterval(self._mainViewCtl.audio_list["scatter_tail"])
end
function cls:cleanTuoweiAnimate( pCol )
	local cells = self.spinLayer.spins[pCol].cells
    for key, theCellNode in pairs(cells) do
        if theCellNode.symbolTipAnim2 and bole.isValidNode(theCellNode.symbolTipAnim2) then
            theCellNode.symbolTipAnim2:removeFromParent()
        end
        theCellNode.symbolTipAnim2 = nil
    end
end
function cls:clearCellBlack( pCol )
	local cells = self.spinLayer.spins[pCol].cells
    for key, theCellNode in pairs(cells) do
        self:stopChildActionsSpecial(theCellNode)
    end
end
function cls:stopDrawAnimate() -- 可能存在 手动调用的可能
	self.symbolsSkeleton = nil
	self.bonusAniList = nil
	self:showAllItem()
	self.spinLayer:stopChildActions()
	self:clearAnimate()
	self:clearBGEffect()
end
function cls:stopChildActionsSpecial(cellNode)
	if cellNode and bole.isValidNode(cellNode.sprite) then 
		cellNode.sprite:setColor(cc.c3b(255,255,255))
	end
end
function cls:getItemAnimate( item, col, row, effectStatus,parent )
	if self._mainViewCtl.freeCtl:getItemWildAnimate(col, row, effectStatus) then
		return nil
	elseif self.symbolsSkeleton and self.symbolsSkeleton[col.."_"..row] then -- 播放长wild的动画
        self:playOldAnimation(col, row)
    elseif (effectStatus == "all_first") then
        self:playItemAnimation(item, col, row, item)
    end
    return nil
end
function cls:getFreeReel()
    return self._mainViewCtl:getFreeReel()
end
function cls:playOldAnimation( col, row )
	self.symbolsSkeleton = self.symbolsSkeleton or {}
    if self.symbolsSkeleton[col .. "_" .. row] then
        local node = self.symbolsSkeleton[col .. "_" .. row][1]
		local animationName = self.symbolsSkeleton[col .. "_" .. row][2]
		local item = self.symbolsSkeleton[col .. "_" .. row][3]
        if bole.isValidNode(node) and animationName then
			bole.spChangeAnimation(node, animationName)
			-- if item >= 6 and item <= 9 and node and bole.isValidNode(node) then 
			-- 	node:addAnimation(0, animationName, false)
			-- end
        end
    end
end
function cls:playItemAnimation( item, col, row )
	local animateName = "animation"
	local fileName = item
	if item == 3 or item == 4 or item == 5 then 
		animateName = "animation"..(item - 2)
		fileName = 3
	elseif item <= 14 and item >= 10 then 
		animateName = "animation_3"
		fileName = item
	end

	local anim_z_cfg = {
		[14] = 600,
		[13] = 600,
		[12] = 600,
		[11] = 600,
		[10] = 600,
		[1] = 400,
		[2] = 300,
	}
	------------------------------------------------------------------
	local zorder = (anim_z_cfg[item] or 0) + row*10
    local cell = self.spinLayer.spins[col]:getRetCell(row)
    local pos       = self._mainViewCtl:getCellPos(col,row)
	local spineFile = self._mainViewCtl:getPic("spine/item/"..fileName.."/spine")

	local _, s1 = bole.addSpineAnimation(self.animateNode, zorder, spineFile, pos, animateName, nil, nil, nil, true)
	-- if item >= 6 and item <= 9 and s1 and bole.isValidNode(s1) then 
	-- 	s1:addAnimation(0, animateName, false)
	-- end
    self.symbolsSkeleton = self.symbolsSkeleton or {}
    self.symbolsSkeleton[col.."_"..row] = {}
    self.symbolsSkeleton[col.."_"..row] = {s1,animateName,item}
    cell.sprite:setVisible(false)
end
function cls:playCellRoundEffect(theSprite) -- 通过图片自己制作帧动画 
	bole.addSpineAnimation(theSprite, nil, self._mainViewCtl:getSpineFile("zhongjiang"), cc.p(0,0), "animation", nil, nil, nil, true, true, nil)
end
function cls:addItemSpine(item, col, row, isLoop, animName, rapidType)
	local layer			= self.animateNode
	local animName		= animName or "animation3"
	local pos			= self._mainViewCtl:getCellPos(col, row)
	local spineFile		= self._mainViewCtl:getPic("spine/item/"..item.."/spine")
	local cell = nil
	if isLoop then 
		cell = self.spinLayer.spins[col]:getRetCell(row)
		cell:setVisible(false)
	end
	local zOrder = 600
	if item == 15 then
		zOrder = 1000
	end
	local _, s1 = bole.addSpineAnimationInTheme(layer, zOrder, spineFile, pos, animName, nil, nil, nil, isLoop, isLoop)
	if rapidType then 
		self.bonusAniList = self.bonusAniList or {}
		self.bonusAniList[col] = self.bonusAniList[col] or {}
		self.bonusAniList[col][row] = s1
		-- if animName == "animation_3" then 
		-- 	rapidType = "double"
		-- end
		self.bonusAniList[col][row].rapidType = rapidType
		self.bonusAniList[col][row].cell = cell
	end
end
function cls:playSymbolNotifyEffect( pCol )
	local extraAddCnt = self._mainViewCtl:getNormalStopAddCount()
	for  key , list in pairs(self._mainViewCtl.notifyState[pCol]) do
		for _, crPos in pairs(list) do
			local cell = nil
			local item = crPos[3]
			local willGetFeature = crPos[4]
			local startAni = "animation_1"
			local loopAni = "animation_2"
			local awardAni = "animation_3"
			local scatterFile = self._mainViewCtl:getPic("spine/item/"..item.."/spine")
			if item == 15 then 
				startAni = "animation1"
				loopAni = "animation2"
				awardAni = "animation3"
				scatterFile = self._mainViewCtl:getPic("spine/item/"..item.."/spine")
				if willGetFeature then 
					self:addScatterBgAni(pCol)
				end
			end
			
			if willGetFeature then
				if item == 15 then
					self._mainViewCtl.audioCtl:playEffectWithInterval(self._mainViewCtl.audio_list["symbol_scatter"])
				else 
					self._mainViewCtl.audioCtl:playEffectWithInterval(self._mainViewCtl.audio_list["symbol_bonus"])
				end
			end

			if self._mainViewCtl:checkIsFastStop() then 
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2])
			else
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2]+extraAddCnt)
			end

			if cell and bole.isValidNode(cell.tipNode) then
				cell.tipNode:removeAllChildren()
				cell.sprite:setVisible(false)
				local _, tipAnim = bole.addSpineAnimation(cell.tipNode, item, scatterFile, cc.p(0,0), startAni, nil, nil, nil, true)
				cell.symbolTipAnim = tipAnim
				if willGetFeature then
					tipAnim:addAnimation(0, loopAni, true)
				else
					bole.spChangeAnimation(tipAnim, loopAni, true)
				end
				local a1 = cc.DelayTime:create(5/30)
				local a2 = cc.CallFunc:create(function ( ... )
					if bole.isValidNode(tipAnim) then
						if item == 15 then 
							bole.changeParent(tipAnim, self.animateNode, 1000)
						else
							bole.changeParent(tipAnim, self.animateNode, 600)
						end
						local pos = self._mainViewCtl:getCellPos(crPos[1], crPos[2])
						-- self.symbolsSkeleton = self.symbolsSkeleton or {}
						-- if not self.symbolsSkeleton[crPos[1] .. "_" .. crPos[2]] then
						-- 	self.symbolsSkeleton[crPos[1] .. "_" .. crPos[2]] = {}
						-- 	self.symbolsSkeleton[crPos[1] .. "_" .. crPos[2]] = {tipAnim, awardAni}
						-- end
						tipAnim:setPosition(pos)
					end
				end)
				local a3 = cc.Sequence:create(a1,a2)
				tipAnim:runAction(a3)
			end
		end
	end
end
function cls:addScatterBgAni(pCol)
	local pos  = self._mainViewCtl:getCellPos(pCol,2)
	local path = self._mainViewCtl:getSpineFile("jili_15")
	local animName = "animation2"
	bole.addSpineAnimation(self.jiliScatterBg, 20, path, pos, animName,nil,nil,nil,true,true)
end
function cls:cleanScatterBgAni()
	self.jiliScatterBg:removeAllChildren()
end

--@添加放大的激励
local MAX_ADD_SCALE = 0.2
function cls:recoveClipNodeParent(colIndex)
	local reelNode = self.spinLayer.boardNode:getReelClipNodes(colIndex)
	bole.changeParent(reelNode, reelNode.centerParent)
	reelNode.changeParent = false
	bole.changeParent(self.bigBoardBgList[colIndex], self.baseBgParent)
	self.bigBoardBgList[colIndex].changeParent = false
	if self.bigBoardBgList[colIndex].normalPos then
		self.bigBoardBgList[colIndex]:setPosition(self.bigBoardBgList[colIndex].normalPos)
	end
end
function cls:changeScaleReel(colIndex)
	if not self.bigBoardBgList[colIndex].changeParent then 
		bole.changeParent(self.bigBoardBgList[colIndex], self.animateNodeParent, -2)
		self.bigBoardBgList[colIndex].changeParent = true

		if self.bigBoardBgList[colIndex].topPos then
			self.bigBoardBgList[colIndex]:setPosition(self.bigBoardBgList[colIndex].topPos)
		end
	end
	self.bigBoardBgList[colIndex].isShow = true
	local addScale = 0
	local a1 = cc.DelayTime:create(0.05)
    local a2 = cc.CallFunc:create(
            function()
                addScale = addScale + 0.02
                local isStop = self:changeSpeededReelAction(colIndex, addScale, 1)
				if isStop then
					-- self:recoveClipNodeParent(colIndex)
                    self.bigBoardBgList[colIndex]:stopAllActions()
                end
            end)
    local a3 = cc.RepeatForever:create(
            cc.Sequence:create(a1, a2)
    )
	libUI.runAction(self.bigBoardBgList[colIndex], a3)
end
function cls:recoverSpeededReel( colIndex )
	if not self.bigBoardBgList[colIndex] or not self.bigBoardBgList[colIndex].isShow then
        return
	end
    if self.bigBoardBgList[colIndex].showing then
        return
	end
    self.bigBoardBgList[colIndex].showing = true
    self.bigBoardBgList[colIndex]:stopAllActions()
    local addScale = MAX_ADD_SCALE
    local a1 = cc.DelayTime:create(0.01) --0.05
    local a2 = cc.CallFunc:create(
            function()
                addScale = addScale - 0.06 --0.02
                local isStop = self:changeSpeededReelAction(colIndex, addScale, -1)
				if isStop then
					self:recoveClipNodeParent(colIndex)
                    self.bigBoardBgList[colIndex]:stopAllActions()
                    self.bigBoardBgList[colIndex].isShow = false
                    self.bigBoardBgList[colIndex].showing = false
					self._mainViewCtl:stopReelNotifyEffect(colIndex)
					
					self:clearCellBlack(colIndex)
                end
            end)
    local a3 = cc.RepeatForever:create(
            cc.Sequence:create(a1, a2)
    )
    libUI.runAction(self.bigBoardBgList[colIndex], a3)
end
function cls:changeSpeededReelAction(colIndex, addScale, dir)
	local reelNode = self.spinLayer.boardNode:getReelClipNodes(colIndex)
	if not reelNode.changeParent then 
		bole.changeParent(reelNode, self.jiliReelUp, -1)
		reelNode.changeParent = true
	end
	local trueWidth = self.gameConfig.G_CELL_WIDTH
	local trueHeight = self.gameConfig.G_CELL_HEIGHT
	if dir > 0 then
		reelNode:setLocalZOrder(100)
        if addScale >= MAX_ADD_SCALE then
            addScale = MAX_ADD_SCALE
        end
    else
    	if addScale <= 0 then
            addScale = 0
            reelNode:setLocalZOrder(colIndex * 10)
        end
	end

	local basePos = self.spinLayer.spins[colIndex].basePos
    local real_posX = -1 * (basePos.x + trueWidth / 2) * addScale
    -- local real_posY = -1 * basePos.y * addScale
    local real_posY = -1 * (basePos.y + trueHeight) * addScale

    reelNode:setScale(1 + addScale)
    reelNode:setPosition(cc.p(real_posX, real_posY))
    self.bigBoardBgList[colIndex]:setScale((1 + addScale))
	if self._mainViewCtl.reelNotifyEffectList and self._mainViewCtl.reelNotifyEffectList[colIndex] then
		
		if bole.isValidNode(self._mainViewCtl.reelNotifyEffectList[colIndex]) then
			local jiBasePos = self._mainViewCtl.reelNotifyEffectList[colIndex].basePos or cc.p(0,0)
			local add_posX = 0
			local add_posY = trueHeight / 2 * addScale
			self._mainViewCtl.reelNotifyEffectList[colIndex]:setScale(1 + addScale)
			self._mainViewCtl.reelNotifyEffectList[colIndex]:setPosition(cc.pAdd(cc.p(add_posX, add_posY), jiBasePos))
        end
    end
    if dir == 1 and addScale == MAX_ADD_SCALE then
        return true
    end
    if dir == -1 and addScale <= 0 then
        return true
    end
    return false
end
---------------symbol end  ---------------

-- function cls:changeRootNodeParent( toMain, newParent )
-- 	if toMain then 
-- 	    bole.changeParent(self.boardRoot, self.reelRootNode)
-- 	    bole.changeParent(self.animateNode, self.animateNodeParent)
-- 	else
-- 	    bole.changeParent(self.boardRoot, newParent)
-- 	    bole.changeParent(self.animateNode, newParent)
-- 	end
-- end

function cls:changeJpParent( toMain, newParent )
	if toMain then
		bole.changeParent(self.progressiveNode, self.progressiveParent)
	else
		bole.changeParent(self.progressiveNode, newParent)
	end
end

function cls:_adaptLogoNode()
	if bole.getAdaptationWidthScreen(0.8) then
		self.logoNode   = cc.Node:create()
		self.progressiveParent:addChild(self.logoNode, 10)

        bole.adaptBottomHorizontal(self.mainThemeScene, 2)
        self.mainThemeScene.posY = self.mainThemeScene:getPositionY()
        local moveY              = bole.getAdaptBottomHMoveY(1) / 2
        self.logoNode:setVisible(true)
        self.logoNode:setPosition(cc.p(0, 345 + moveY))
        local data  = {}
        data.file   = self._mainViewCtl:getSpineFile("logo_label")
        data.parent = self.logoNode
        data.isLoop = true
        bole.addAnimationSimple(data)
    end
end
function cls:setAdapterPhone( ... )
    if SHRINKSCALE_H < 1 then
        self.mainThemeScene:setPosition(cc.p(0, 5))
    else
        self.mainThemeScene:setPosition(cc.p(0, 5))
    end
end

function cls:getBoardNodeList( ... )
	return self.boardNodeList
end
function cls:getFlyLayer( ... )
	return self.reelCoinFlyLayer
end


---
function cls:_initGameMasterTip( ... )
	self.tipShowStatus = gameMasterTipShowStatus["hide"]
	self.gameMasterTip = self.shakerNode:getChildByName("gamemaster_tip")
	self:setGameMasterTipEnable(false)
	if self.gameMasterTip and bole.isValidNode(self.gameMasterTip) then 
		self.gameMasterTipRoot = self.gameMasterTip:getChildByName("root")
		self.gameMasterTipBtn = self.gameMasterTipRoot:getChildByName("node_start"):getChildByName("btn_start")
		self.gameMasterTipNode = self.gameMasterTipRoot:getChildByName("tip_node")
		self.gameMasterTipNode:setScale(0)
		self.gameMasterTipNode:setVisible(false)
		local function onTouch(obj, eventType)
			if eventType == ccui.TouchEventType.ended then
				self._mainViewCtl:playMusicByName("common_click")
				self:showGameMasterTipNode(self.gameMasterTipNode)
			end
		end
		self.gameMasterTipBtn:addTouchEventListener(onTouch)
	end
end

function cls:setGameMasterTipEnable( enable )
	enable = enable or false
	if self.gameMasterTip and bole.isValidNode(self.gameMasterTip) then 
		self.gameMasterTip:setVisible(enable)
	end
end

function cls:showGameMasterTipNode(tips)
	if tips and bole.isValidNode(tips) then 
		tips:stopAllActions()
		tips:setVisible(true) 
	end
	if self.tipShowStatus == gameMasterTipShowStatus["show"] then 
		self.tipShowStatus = gameMasterTipShowStatus["hide"]
		self:displayTips(tips, 0.3, 3)
	else
		self.tipShowStatus = gameMasterTipShowStatus["show"]
		self:displayTips(tips, 0.3, 3, self.tipShowStatus)
	end
end

function cls:displayTips(tips, time, delayTime, flag)
	if flag then 
		local a1 = cc.ScaleTo:create(time, 0.95)
		local a2 = cc.ScaleTo:create(time/3, 0.85)
		local a3 = cc.DelayTime:create(delayTime)
		local a4 = cc.ScaleTo:create(time / 2, 0)
		local a5 = cc.CallFunc:create(function ( ... )
			tips:setVisible(false)
		end)
		local a6 = cc.Sequence:create(a1,a2,a3,a4,a5)
		tips:runAction(a6)
	else
		local a1 = cc.ScaleTo:create(time / 2, 0)
		tips:runAction(a1)
	end
end

function cls:spinButtonPressed( ... )
	if self.gameMasterTipNode.showStatus == gameMasterTipShowStatus["show"] then 
		self:showGameMasterTipNode(self.gameMasterTipNode, 1)
	end
end
---
--------------------------------------------------------------------------------------------------------\
--@region footer tip
function cls:changeFooterTips(changeType , changeLevel)
	if self._mainViewCtl:getThemeFooterFlag() then
		return 
	end

	if changeType and changeLevel then 
		if not bole.isValidNode(self.footerTips) then
			local posW = self._mainViewCtl:getFooterNodesPos("total_bet")
			local posN = bole.getNodePos( self.footerTipParent, posW)
			
			local path = self._mainViewCtl:getCsbPath("footer_tip")
			self.footerTips = libUI.createCsb(path)
			self.footerTips:setPosition(cc.pAdd(posN, cc.p(0,35)))
			self.footerTipParent:addChild(self.footerTips)
			local unlockNode = self.footerTips:getChildByName("lock")
			unlockNode.num = unlockNode:getChildByName("num")
			self.footerTipList = {
				unlock = unlockNode,
			}
			unlockNode:setVisible(false)
		end

		local baseScale = cc.p(1, 1)
		local showNode
		if changeType == "unlock" and bole.isValidNode(self.footerTipList.unlock) and bole.isValidNode(self.footerTipList.unlock.num) then
			showNode = self.footerTipList.unlock
			showNode.num:setString(changeLevel)
		end

		for _, temp in pairs(self.footerTipList) do 
			if bole.isValidNode(temp) and temp:isVisible() then 
				temp:stopAllActions()
				temp:runAction(cc.Sequence:create(
					cc.ScaleTo:create(0.02, baseScale.x*1.2, baseScale.y*1.2),
					cc.ScaleTo:create(0.08, 0),
					cc.Hide:create()
					))
			end
		end
	
		if bole.isValidNode(showNode) then 
			showNode:stopAllActions()
			showNode:setScale(0)
	
			self._mainViewCtl:playMusicByName("popup_out")

			showNode:runAction(cc.Sequence:create(
				cc.Show:create(),
				cc.ScaleTo:create(0.2, baseScale.x*1.2, baseScale.y*1.2),
				cc.ScaleTo:create(0.1, baseScale.x*1, baseScale.y*1),
				cc.DelayTime:create(1),
				cc.ScaleTo:create(0.05, baseScale.x*1.2, baseScale.y*1.2),
				cc.ScaleTo:create(0.1, 0),
				cc.Hide:create()
			))
		end
		
	end
end
--@endregion footer tip
--------------------------------------------------------------------------------------------------------
function cls:_initHelpshiftBtn()
    -- 客服按钮
    local btn_img_normal = "loading/loading_btn21.png"
    local btn_img_pressed = "loading/loading_btn22.png"
    if cc.FileUtils:getInstance():isFileExist(btn_img_normal) and cc.FileUtils:getInstance():isFileExist(btn_img_pressed) then
        local help_btn = ccui.Button:create(btn_img_normal, btn_img_pressed, btn_img_pressed)
        help_btn:setPosition(cc.p(-507*HEADER_FOOTER_RATE_H, 310))
		self._mainViewCtl:curSceneAddToTop(help_btn, 1)
		
        self.help_btn = help_btn
        help_btn:setVisible(false)
        help_btn:addTouchEventListener(function (sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                -- 没有函数说明没有加载完plugin代码，无法打开helpshift
                if isHelpshiftEnabled and isHelpshiftEnabled() then
                    Helpshift:getInstance():setContactUsCount(0) -- 点开此界面，要给未读消息清0
                    Helpshift:getInstance():showFAQs()
                else
                    if tonumber(Config.versionCode) > 170 then
                        bole.shareToEmail("Cash Frenzy™ Casino - TOP FREE casino slot games!", "Hey! Come play the best slots with me at Cash Frenzy. It’s such an addicting game with so much fun! <br> Weekly updates and loads of new feature games makes it more interesting and enjoyable! <br> It’s totally FREE and gives you 1,0000,000 welcome bonus! Let’s go get spinning! Cheers and enjoy! <br> Click here to download: <br> https://bit.ly/CashFrenzyEMAIL <br> <img src='https://d105xpbtjj9cjp.cloudfront.net/phoenix/V723/images/loading_back.png'>")
                    else
                        local url = "mailto:?subject=Cash Frenzy™ Casino - TOP FREE casino slot games!&body= Hey! Come play the best slots with me at Cash Frenzy. It’s such an addicting game with so much fun! %0d%0a Weekly updates and loads of new feature games makes it more interesting and enjoyable! %0d%0a It’s totally FREE and gives you 1,0000,000 welcome bonus! Let’s go get spinning! Cheers and enjoy! %0d%0a Click here to download: %0d%0a https://bit.ly/CashFrenzyEMAIL  %0d%0a <img src='https://d105xpbtjj9cjp.cloudfront.net/phoenix/V723/images/loading_back.png'>"
                        if bole.isIOS() then
                            url = string.gsub(url, " ", "%%20")
                        end
                        cc.Application:getInstance():openURL(url)
                    end
                end
            end
        end)
	end
end

function cls:changeHelpshiftBtnEnable(data)
	if bole.isValidNode(self.help_btn) then 
		local state = data.state
		self.help_btn:setVisible(state)
	end
end

--------------------------------------------------------------------------------------------------------------
--@region
-- for payOut
-- payout 中奖特效
function cls:showFooterPayoutEffect(rollTime)
	local footerWinNode = self._mainViewCtl:getFooterWinNode()
	if bole.isValidNode(footerWinNode) and not bole.isValidNode(self.topAniParent) then
		self.topAniParent = cc.Node:create()
		bole.scene:addToTop(self.topAniParent)

		local wPos = self._mainViewCtl:getFooterNodesPos("win")
		local nPos = bole.getNodePos(self.topAniParent, wPos)
		self.topAniParent:setPosition(nPos)
	end

    rollTime = rollTime or 0.7
    local parent = self.topAniParent
	parent:removeAllChildren()
	
	local data1 = {}
	data1.file = self._mainViewCtl:getSpineFile("payout_footer_win")
	data1.parent = self.topAniParent
	data1.isRetain = true
	local _, s1 = bole.addAnimationSimple(data1)
	self.footerSpine = s1
	
    self.footerSpine:runAction(cc.Sequence:create(
        cc.DelayTime:create(rollTime),
        cc.FadeOut:create(0.2),
        cc.RemoveSelf:create()
    ))
end

function cls:showFooterPayoutLoop(enable)
	if enable then 
		local footerWinNode = self._mainViewCtl:getFooterWinNode()
		if bole.isValidNode(footerWinNode) and not bole.isValidNode(self.topAniParent2) then
			self.topAniParent2 = cc.Node:create()
			footerWinNode:addChild(self.topAniParent2, -1)

			local wPos = self._mainViewCtl:getFooterNodesPos("win")
			local nPos = bole.getNodePos(self.topAniParent2, wPos)
			self.topAniParent2:setPosition(nPos)

			local payout_img_path = self.gameConfig.payout_footer_img[self._mainViewCtl:getThemeId()]
			local footer_img1 = bole.createSpriteWithFile(payout_img_path)
			local footer_img2 = bole.createSpriteWithFile(payout_img_path)
			self.topAniParent2:addChild(footer_img1, 1)
			self.topAniParent2:addChild(footer_img2, 1)
			footer_img1:setAnchorPoint(0, 0.5)
			footer_img1:setPosition(-1.5, -3)
			footer_img2:setAnchorPoint(0, 0.5)
			footer_img2:setScaleX(-1)
			footer_img2:setPosition(0.5, -3)

			local data1 = {}
			data1.file = self._mainViewCtl:getSpineFile("payout_footer_loop")
			data1.parent = self.topAniParent2
			data1.isLoop = true
			data1.zOrder = 2
			local _, s1 = bole.addAnimationSimple(data1)
			
			self.topAniParent2:setVisible(false)
		end

		if not self.topAniParent2:isVisible() then 
			self.topAniParent2:setVisible(true)

			local data2 = {}
			data2.file = self._mainViewCtl:getSpineFile("payout_footer_open")
			data2.parent = self.topAniParent2
			data2.zOrder = 3
			local _, s2 = bole.addAnimationSimple(data2)
		end

	else
		if bole.isValidNode(self.topAniParent2) then
			self.topAniParent2:setVisible(false)
		end
	end
end

--@endregion
--------------------------------------------------------------------------------------------------------------

return cls







