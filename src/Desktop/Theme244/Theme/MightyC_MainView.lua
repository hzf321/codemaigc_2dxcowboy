-- @Author: xiongmeng
-- @Date:   2020-11-10 10:31:23
-- @Last Modified by:   xiongmeng
-- @Last Modified time: 2021-03-23 18:18:54
local parentCls = ThemeBaseView
local cls = class("MightyC_MainView", parentCls)

local bonusId = 14
local maskOpacity = 150
local usetSpinConfig = nil
function cls:ctor( ctl )
	self._mainViewCtl= ctl
	self.gameConfig = self._mainViewCtl:getGameConfig()
	self.bonusCoinsList = self.gameConfig["bonus_coin"]
	usetSpinConfig = self.gameConfig.userSpine
	parentCls.ctor(self, ctl)
end

function cls:initBoardNodesByRowSingle( reelNodes, theConfig, reelZorder, theBoardNode, boardIndex )
	local rowReelCnt = theConfig["rowReelCnt"]
	local index = 0
	local clipNode = nil
	local reelNode = nil
	for reelIndex,config in ipairs(theConfig["reelConfig"]) do
		 
		if (reelIndex-1)%rowReelCnt == 0 then 
			reelNode = cc.Node:create()
			reelNode:setLocalZOrder(reelZorder)
				
			local vex = {
				config["base_pos"], -- 第一个轴的左下角  下左边界
				cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*rowReelCnt + config["lineWidth"] * (rowReelCnt-1) , 0)),  -- 下右边界
				cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*rowReelCnt + config["lineWidth"] * (rowReelCnt-1), config["cellHeight"])),-- 上右边界
				cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"])),-- 上左边界
			}
			local stencil = cc.DrawNode:create()
			stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))

			local clipAreaNode = cc.Node:create()
			clipAreaNode:addChild(stencil)
			clipNode = cc.ClippingNode:create(clipAreaNode)
		   
			theBoardNode:addChild(clipNode)	
			clipNode:addChild(reelNode)
		end
		reelNodes[reelIndex] = reelNode
	end
end


function cls:initBoardTouchBtn(boardConfigList, pBoardNodeList)
    local base_config = boardConfigList
	self.boardMoveBtn = nil
    for key = 1, #boardConfigList do
        local reelConfig = base_config[key].reelConfig
        local base_pos = table.copy(reelConfig[1].base_pos)
        local boardW = reelConfig[1].cellWidth * 5 + 4 * 4
        local boardH = reelConfig[1].cellHeight * reelConfig[1].symbolCount
		if key == 2 then
			base_pos = table.copy(reelConfig[11].base_pos)
			boardH = reelConfig[1].cellHeight * reelConfig[1].symbolCount * 3 + 10
		end
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
    touchBtn:setAnchorPoint(anchorPos)
    touchBtn:setScaleX(boardW / unitSize)
    touchBtn:setScaleY(boardH / unitSize)
	touchBtn:setOpacity(0)
    parent:addChild(touchBtn)
	touchBtn.scaleY = boardH / unitSize
	return touchBtn
end

function cls:initScene( ... )
	local path = self._mainViewCtl:getCsbPath("base")
	self.mainThemeScene = cc.CSLoader:createNode(path)
	self.down_node 		= self.mainThemeScene:getChildByName("down_child")
	self.down_child 	= self.down_node:getChildByName("down_child")
	self.reelRootNode   = self.down_child:getChildByName("reel_root_node")
	self.boardRoot      = self.reelRootNode:getChildByName("board_root")
	self.logoLabelNode  = self.mainThemeScene:getChildByName("logo")
	self.logoLabelNode:setPositionY(0)

	self:_initBoardNode()
	self:_initAniNode()
	self:_initFlyparent()
	self:_initSpecailTip()
	self:_initJackpotNode()
	self:_initBgNode()
	self:_initCollectNode()
	self:_initFreeGameNode()
	self:_initRespinNode()
	self:adaptWideScreen()
	-- self:getBgAdaptScale()
	self.mainThemeScene:setPositionY(-2)
	bole.adaptScale(self.mainThemeScene)
	self.shakyNode:addChild(self.mainThemeScene)
end
function cls:_initAniNode()
	self.animateNodeParent = self.reelRootNode:getChildByName("animate_node")
	local animate_area = self.reelRootNode:getChildByName("animate_area")
	animate_area:setSwallowTouches(false)
	self.animateNodeScatter   = animate_area:getChildByName("animate_scatter")
	self.animateBgNode = self.reelRootNode:getChildByName("animate_bg")
	self.animateNode = cc.Node:create()
	self.animateNodeParent:addChild(self.animateNode)
	self.themeAnimateKuang = cc.Node:create()
	self.animateNodeParent:addChild(self.themeAnimateKuang, 1)
end
function cls:_initFlyparent()
	self.flyParent = cc.Node:create()
	bole.scene:addToTop(self.flyParent)
	self.flyParent:setPosition(0,0)
end
function cls:_initBoardNode( ... )
	self.boardNode = self.reelRootNode:getChildByName("board")
	self.baseBoard = self.boardNode:getChildByName("base_board")
	self.respinBoard = self.boardNode:getChildByName("respin_board")
	local earNode = self.baseBoard:getChildByName("ear")
	earNode:setLocalZOrder(1)
	self.respinBoard:setVisible(false)
	self.baseBoard:setVisible(true)
	self:addBoardKuangAni()
	self.currentBoard = self.baseBoard
end
function cls:_initSpecailTip()
	self.baseTipNode = self.down_child:getChildByName("base_tip_node")
	self.collectRespinTip = self.baseTipNode:getChildByName("respin_tip")
	self.collectRightTip = self.baseTipNode:getChildByName("collect_tip")
	local progressTipParent = self.baseTipNode:getChildByName("progress_tip")
	local progressiveNode = progressTipParent:getChildByName("progressive")
	progressiveNode:removeFromParent()
	self.progressiveTip = progressTipParent:getChildByName("progressive_tip")
	self.collectRespinTip:setVisible(false)
	self.collectRightTip:setVisible(false)
end
function cls:_initJackpotNode()
	local jackpotNode = self.reelRootNode:getChildByName("progress_jp")
	local jackpotNodeTip = jackpotNode:getChildByName("progressive_tip")
	jackpotNodeTip:removeFromParent()
	self.jackpotNode = jackpotNode
	self._mainViewCtl:getJpViewCtl():initLayout(jackpotNode, self.progressiveTip)
end
function cls:_initCollectNode( ... )
	local collectNode = self.reelRootNode:getChildByName("collect_node")
	self.collectNode = collectNode
	self._mainViewCtl:getCollectViewCtl():initLayout(collectNode, self.collectRightTip)
end
function cls:_initFreeGameNode( ... )
	self._mainViewCtl:getFreeVCtl():initLayout()
end
function cls:_initRespinNode()
	local respinCollectParent = self.reelRootNode:getChildByName("respin_collect")
	self.moneyGrabNode = cc.Node:create()
	self.moneyGrabNode:setPosition(cc.p(-20, 213))
	self.down_child:addChild(self.moneyGrabNode)
	local mightRespinBoard = self.down_child:getChildByName("might_respin_board")
	self.mightRespinBoard = mightRespinBoard
	self._mainViewCtl:getRespinViewCtl():initLayout(respinCollectParent, self.collectRespinTip, mightRespinBoard)
end
function cls:_initBgNode( ... )
	self.bgNode = self.mainThemeScene:getChildByName("theme_bg")
	self.bgNode:setPositionY(160)
	self.baseBgNode = self.bgNode:getChildByName("bg_base")
	self.freeBgNode = self.bgNode:getChildByName("bg_free")
	self.respinBgNode = self.bgNode:getChildByName("bg_respin")
	self.superRespinBgNode = self.bgNode:getChildByName("bg_respin_super")
	self.baseAniNode = self.bgNode:getChildByName("bg_anim")
	self.baseAniNode:setScale(1.25)
	self.currentBg = self.baseBgNode
	self.freeBgNode:setVisible(false)
	self.respinBgNode:setVisible(false)
	self.superRespinBgNode:setVisible(false)
end

function cls:updateBoardUI( pType )
	local boardUI = {self.baseBoard, self.baseBoard, self.respinBoard, self.respinBoard}
	local showBoard = boardUI[pType]
	if self.currentBoard ~= showBoard then
		showBoard:setVisible(true)
		self.currentBoard:setVisible(false)
		self.currentBoard = showBoard
	end
end
function cls:addBoardKuangAni()
	local file = self._mainViewCtl:getSpineFile("base_board")
	bole.addSpineAnimationInTheme(self.baseBoard, nil, file, cc.p(-20, -40), "animation", nil, nil, nil, true, true)
	bole.addSpineAnimationInTheme(self.respinBoard, nil, file, cc.p(-20, -40), "animation", nil, nil, nil, true, true)
end
function cls:updateBgSpineUI( pType )
	local bgFileList = {"base_bg", "free_bg", "bonus_bg", "superbonus_bg"}
	local bgAniName = {"244_base_bgxh", "244_bonus_bgxh", "244_super_bgxh", "244_free_bgxh"}
	if not bgFileList[pType] then 
		return
	end
	local file = self._mainViewCtl:getSpineFile(bgFileList[pType])
	self.baseAniNode:removeAllChildren()
	bole.addSpineAnimationInTheme(self.baseAniNode, nil, file, cc.p(0,0), bgAniName[pType], nil, nil, nil, true, true)
end
function cls:updateCollectUI( pType )
	local showCollect = {true, true, false, false}
	if pType then
		self.collectNode:setVisible(showCollect[pType])
		self.mightRespinBoard:setVisible(showCollect[pType])
	end
end
function cls:resetBoardShowNode( pType )
	self:changeSpinLayerByType(self.gameConfig.SpinLayerType[pType])
end
function cls:refreshCellsZOrder( pCol )
	self:refreshColCellsZOrder(pCol)
end
function cls:updateBg( pType )
	local bgUI = {self.baseBgNode, self.freeBgNode, self.respinBgNode, self.superRespinBgNode}
	local showBg = bgUI[pType]
	if self.currentBg ~= showBg then
		showBg:setVisible(true)
		self.currentBg:setVisible(false)
		self.currentBg = showBg
	end
end
function cls:updtaeJackpotPos(pType)
	local jpPos = {cc.p(0,2), cc.p(0,2), cc.p(20,2), cc.p(20,2)}
	if jpPos[pType] then
		self.jackpotNode:setPosition(jpPos[pType])
	end
end
function cls:showDimmerIn()
	self.boardDialogDimmer:stopAllActions()
    self.boardDialogDimmer:setVisible(true)
	self.boardDialogDimmer:setOpacity(0)
	local a1 = cc.FadeTo:create(0.3, 230)
	self.boardDialogDimmer:runAction(a1)
end
function cls:showDimmerOut()
	self.boardDialogDimmer:stopAllActions()
    self.boardDialogDimmer:setVisible(true)
	self.boardDialogDimmer:setOpacity(0)
	local a0 = cc.DelayTime:create(15/30)
	local a1 = cc.FadeTo:create(0.3, 0)
	local a2 = cc.CallFunc:create(function ()
		self.boardDialogDimmer:setVisible(false)
	end)
	local a3 = cc.Sequence:create(a0,a1,a2)
	self.boardDialogDimmer:runAction(a3)
end
--------------- coinsBonusAni end  ---------------

--------------- logo start  ---------------
function cls:adaptWideScreen()
	local moveY = bole.getAdaptBottomHMoveY()
	moveY = moveY / 2
    if bole.getAdaptationWidthScreen() then
        local posY = 270 + moveY
        local data = {}
        data.file = self._mainViewCtl:getSpineFile("logo_label")
        data.parent = self.logoLabelNode
        data.isLoop = true
        data.pos = cc.p(0, posY)
        bole.addAnimationSimple(data)
    end
	if bole.isWidescreen() then 
		self.down_node:setPositionY(-moveY)
		self.bgNode:setPositionY(160 - moveY)
	end
	self.bgNode:setScale(self:getBgAdaptScale())
end
function cls:getBgAdaptScale()
	local baseScale =  bole.getAdaptScale()
	local bg_width = 1560
	local scale = 1
	if FRAME_WIDTH > bg_width then
		scale = FRAME_WIDTH / (bg_width * baseScale)
	end
	return scale
end
--------------- logo end  ---------------
---------------symbol start---------------
function cls:createCellSprite( key, col, rowIndex )
	local notInitSymbolSet = self.gameConfig.symbol_config.not_init_symbol_set or {}
    local theCellFile = self._mainViewCtl.pics[key]
	local respinLayerId = 2
	if self.initBoardIndex == respinLayerId then
        key = self._mainViewCtl:getMajorSymbol()
		theCellFile = "#theme244_s_"..key.."_0.png"
    else
        key = self._mainViewCtl:getNormalKey()
		theCellFile = self._mainViewCtl.pics[key]
    end
	local theCellNode   = cc.Node:create()
	local theCellSprite = bole.createSpriteWithFile(theCellFile)
	theCellNode:addChild(theCellSprite)
	theCellNode.key 	  = key
	theCellNode.sprite 	  = theCellSprite
	theCellNode.curZOrder = 0

	local landAnimate = cc.Node:create()
    theCellNode.tipNode = landAnimate
    theCellNode:addChild(landAnimate, 20)

	local fontNode = cc.Node:create()
	theCellNode.fontNode = fontNode --用来添加字体的
	theCellNode:addChild(fontNode, 10)

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
	local fontNode = theCellNode.fontNode
	local bonus1 = 12
	local bonus2 = 13
	fontNode:removeAllChildren()

	if self._mainViewCtl:getRespinStatus() then
		if not self.bonusCoinsList[key] then 
			if self._mainViewCtl:isLowSymbol(key) then
				key = self._mainViewCtl:getMajorSymbol()
			end
			if key < 2 or key >6 then
				key = self._mainViewCtl:getMajorSymbol()
			end
			theCellFile = "#theme244_s_"..key.."_0.png"
		end
	end

	if self.bonusCoinsList[key] then 
		local labelFont = self:addSymbolFont()
		fontNode:addChild(labelFont)
		self:updateSymbolCoins(labelFont, key)
		theCellFile = self._mainViewCtl.pics[bonus1]
		if self:getYellowDiamondSymbol(key) then
			theCellFile = self._mainViewCtl.pics[bonus2]
		end

		local jpType = self._mainViewCtl:getHighDiamondSymbol(key)
		if jpType then
			local jpPng = "#theme244_s_jp_"..jpType..".png"	
			local jackpotNode = bole.createSpriteWithFile(jpPng)
			fontNode:addChild(jackpotNode)
		end
	end

	if not theCellFile then
		key = self._mainViewCtl:getNormalKey(col)
		theCellFile = self._mainViewCtl.pics[key]
	end
	bole.updateSpriteWithFile(theCellSprite, theCellFile)
	theCellNode.key 	  = key
	theCellNode.curZOrder = 0
	------------------------------------------------------------
	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )
	local theKey = theCellNode.key
	if self._mainViewCtl.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self._mainViewCtl.symbolZOrderList[theKey]
	elseif self.bonusCoinsList[key] then
		theCellNode.curZOrder = self._mainViewCtl.symbolZOrderList[12]
	end
	if isReset then 
		theCellNode:setLocalZOrder(theCellNode.curZOrder)
	end
	theCellSprite:setAnchorPoint(cc.p(0.5, 0.5))
	if self._mainViewCtl.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self._mainViewCtl.symbolPosAdjustList[theKey])
	else
		theCellSprite:setPosition(cc.p(0,0))
	end
end
function cls:addSymbolFont(scale, fileName, pos)
	local symbolLabel = self.gameConfig.symbolLabel
	local font = fileName or symbolLabel.file
	scale = scale or symbolLabel.scale
	pos = pos or symbolLabel.pos
    local file = self._mainViewCtl:getPic(font)
    local fntLabel = ccui.TextBMFont:create()
    fntLabel:setFntFile(file)
	fntLabel:setScale(scale)
	fntLabel:setPosition(pos)
	-- 字体需要滚动
	inherit(fntLabel, LabelNumRoll)
    local function parseValue1(num)
        return FONTS.formatByCount4(num,4,true)
    end
    fntLabel:nrInit(0, 24, parseValue1)
	fntLabel.baseScale = scale
    return fntLabel
end
function cls:updateSymbolCoins(fontNode, item)
	if fontNode and bole.isValidNode(fontNode) and item then
		local labelCoins = 0
		if not self._mainViewCtl:getHighDiamondSymbol(item) then
			labelCoins = self._mainViewCtl:getSymbolCoins(self.bonusCoinsList[item])
		end
		fontNode.coins = labelCoins
		if labelCoins == 0 then
			fontNode:setString("")
		else 
			fontNode:setString(FONTS.formatByCount4(labelCoins,4,true))
		end
	end
end
function cls:stopDrawAnimate() -- 可能存在 手动调用的可能
	self.symbolsSkeleton = nil
	self.animateNodeScatter:removeAllChildren()
	self:showAllItem()
	self.spinLayer:stopChildActions()
	self.diamondList = nil
	self:clearAnimate()
	self:clearBGEffect()
end
function cls:getItemAnimate( item, col, row, effectStatus, parent )
	if self.symbolsSkeleton and self.symbolsSkeleton[col.."_"..row] then -- 播放长wild的动画
        self:playOldAnimation(col, row)
    elseif (effectStatus == "all_first") then
        self:playItemAnimation(item, col, row, item)
    end
    return nil
end
function cls:playOldAnimation( col, row )
	self.symbolsSkeleton = self.symbolsSkeleton or {}
    if self.symbolsSkeleton[col .. "_" .. row] then
        local node = self.symbolsSkeleton[col .. "_" .. row][1]
        local animationName = self.symbolsSkeleton[col .. "_" .. row][2]
        local item = self.symbolsSkeleton[col .. "_" .. row][4]
        if bole.isValidNode(node) and animationName then
            bole.spChangeAnimation(node, animationName)
			if self._mainViewCtl:isLowSymbol(item) then
				node:addAnimation(0, animationName, false)
			end
        end
		self:changeSymbolSpineZoder(col, row)
    end
end
function cls:playItemAnimation( item, col, row )
	local animateName = "animation"
    local fileName = item
	if fileName > 12 then return end
    ------------------------------------------------------------------
    local cell = self.spinLayer.spins[col]:getRetCell(row)
    local pos       = self._mainViewCtl:getCellPos(col,row)
    local spineFile = self._mainViewCtl:getPic("spine/item/"..item.."/spine")
    
	local parent = cc.Node:create()
	parent:setPosition(pos)
	self.animateNode:addChild(parent)

	local _, s1 = bole.addSpineAnimation(parent, nil, spineFile, cc.p(0,0), animateName, nil, nil, nil, true)
	if self._mainViewCtl:isLowSymbol(item) then
		s1:addAnimation(0, animateName, false)
	end
    self.symbolsSkeleton = self.symbolsSkeleton or {}
    self.symbolsSkeleton[col.."_"..row] = {}
    self.symbolsSkeleton[col.."_"..row] = {s1,animateName,parent,item}
    cell.sprite:setVisible(false)
	self:changeSymbolSpineZoder(col, row)
end

function cls:changeSymbolSpineZoder(col, row)
	col = col or 0
	row = row or 0
	if self.symbolsSkeleton and self.symbolsSkeleton[col.."_"..row] then 
		local list = self.symbolsSkeleton[col.."_"..row]
		local parent = list[3]
		if parent and bole.isValidNode(parent) then 
			parent:setLocalZOrder((row - 1) * 5 + col + 1)
			parent:stopAllActions()
			parent:runAction(cc.Sequence:create(
				cc.DelayTime:create(3),
				cc.CallFunc:create(function ()
					parent:setLocalZOrder(-1)
				end)
			))
		end
	end
end
function cls:playCellRoundEffect(theSprite) 
	bole.addSpineAnimationInTheme(theSprite, nil, self._mainViewCtl:getSpineFile("zhongjiang"), cc.p(0,0), "animation", nil, nil, nil, true, true, nil)
end
function cls:addItemSpine(item, col, row, isLoop, animationName, file)
	local layer			= self.animateNode
	local animName		= animationName or "animation2"
	local pos			= self._mainViewCtl:getCellPos(col, row)
	local spineFile		= file or self._mainViewCtl:getPic("spine/item/"..item.."/spine")
	if isLoop then
		local cell = self.spinLayer.spins[col]:getRetCell(row)
		cell:setVisible(false)
	end
	local node = cc.Node:create()
	layer:addChild(node, 100)
	node:setPosition(pos)
	if self.bonusCoinsList[item] then 
		local labelFont = self:addSymbolFont()
		node:addChild(labelFont)
		self:updateSymbolCoins(labelFont, item)
		local jpType = self._mainViewCtl:getHighDiamondSymbol(item)
		if jpType then
			local jpPng = "#theme244_s_jp_"..jpType..".png"	
			local jackpotNode = bole.createSpriteWithFile(jpPng)
			node:addChild(jackpotNode)
		end
	end
	bole.addSpineAnimationInTheme(node, -1, spineFile, cc.p(0,0), animName, nil, nil, nil, isLoop, false)
end
function cls:addReelNotifyEffect(pCol)
	self.reelNotifyEffectList = self.reelNotifyEffectList or {}
	self.reelNotifyBgEffectList = self.reelNotifyBgEffectList or {}
	local featureId = self._mainViewCtl:checkSpecailNotify(pCol)
	if featureId == self.gameConfig.special_symbol.scatter then
		self:addScatterNotifyEffect(pCol)
	else 
		self:addBonusNotifyEffect(pCol)
		self._mainViewCtl:getCollectViewCtl():addSuperBonusJili()
	end
end
function cls:addScatterNotifyEffect(pCol)
	local pos   = self._mainViewCtl:getCellPos(pCol,2)
	local file  = self._mainViewCtl:getSpineFile("jili_scatter")
	local animateName = "animation"..(pCol-2)
	local animateNameBg = "animation4"
	local _,s1 = bole.addSpineAnimationInTheme(self.animateNode, 20, file, pos, animateName,nil,nil,nil,true,true)
	local _,s2 = bole.addSpineAnimationInTheme(self.animateBgNode, nil, file, pos, animateNameBg,nil,nil,nil,true,true)
	s1:setOpacity(0)
	s1:runAction(cc.FadeTo:create(0.2, 255))
	s2:setOpacity(0)
	s2:runAction(cc.FadeTo:create(0.2, 255))
	self._mainViewCtl:playMusicByName("reel_notify_scatter"..(pCol-2), true, false)
	self:playScatterJili(pCol)
	self._mainViewCtl.playR1Col = pCol
	self.reelNotifyEffectList[pCol] = s1
	self.reelNotifyBgEffectList[pCol] = s2
end
function cls:addBonusNotifyEffect(pCol)
	local pos   = self._mainViewCtl:getCellPos(pCol,2)
	local file  = self._mainViewCtl:getSpineFile("jili_bonus")
	local _,s1 = bole.addSpineAnimationInTheme(self.animateNode, 20, file, pos, "animation",nil,nil,nil,true,true)
	s1:setOpacity(0)
	s1:runAction(cc.FadeTo:create(0.2, 255))
	self.reelNotifyEffectList[pCol] = s1
	self._mainViewCtl.playR1Col = pCol
	self._mainViewCtl:playMusicByName("reel_notify_bonus", true, false)
end
function cls:stopReelNotifyEffect(pCol)
	self.reelNotifyEffectList = self.reelNotifyEffectList or {}
	self.reelNotifyBgEffectList = self.reelNotifyBgEffectList or {}
    if self.reelNotifyEffectList[pCol] and (not tolua.isnull(self.reelNotifyEffectList[pCol])) then
		local jili = self.reelNotifyEffectList[pCol]
		jili:stopAllActions()
		jili:runAction(cc.FadeTo:create(0.2, 0))
    end
	if self.reelNotifyBgEffectList[pCol] and (not tolua.isnull(self.reelNotifyEffectList[pCol])) then
		local jili = self.reelNotifyBgEffectList[pCol]
		jili:stopAllActions()
		jili:runAction(cc.FadeTo:create(0.2, 0))
	end
    self.reelNotifyEffectList[pCol] = nil
    self.reelNotifyBgEffectList[pCol] = nil
end
function cls:playSymbolNotifyEffect( pCol )
	local extraAddCnt = self._mainViewCtl:getNormalStopAddCount()
	for  key , list in pairs(self._mainViewCtl.notifyState[pCol]) do
		for _, crPos in pairs(list) do
			local cell = nil
			local item = crPos[3]
			local featureId = crPos[4]
			local willGetFeature = crPos[5]
			local isScatter = true
			self:playSymbolLandMusic(willGetFeature, featureId, pCol)
			if self._mainViewCtl:checkIsFastStop() then 
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2])
			else
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2]+extraAddCnt)
			end
			if featureId ~= self.gameConfig.special_symbol.scatter then
				isScatter = false
			end
			self:addFeatureLandAni(cell, crPos, item, featureId, willGetFeature)
		end
	end
end
function cls:addFeatureLandAni(cell, crPos, item, featureId, willGetFeature)
	if (not cell) or (cell and not bole.isValidNode(cell)) then return end
	local file = self._mainViewCtl:getPic("spine/item/"..featureId.."/spine")
	local tipNode = cell.tipNode
	local tipAniNode = nil
	local tipAnim = nil
	local landAni = "animation1"
	local landLoopAni = "animation2"
	local isScatter = false
	local s = nil
	tipNode:removeAllChildren()
	if featureId == self.gameConfig.special_symbol.scatter then
		tipAniNode = cc.Node:create()
		cell.tipNode:addChild(tipAniNode)
		s, tipAnim = bole.addSpineAnimationInTheme(tipAniNode, nil, file, cc.p(0,0), landAni, nil, nil, nil, true)
		self.allScatterAniList = self.allScatterAniList or {}
		table.insert(self.allScatterAniList, {tipAnim, crPos[1]})
		isScatter = true
	else 
		tipAniNode = self:getDiamondHighZorder(item, crPos[1], crPos[2], cell.tipNode, nil, nil, willGetFeature)
		s, tipAnim = bole.addSpineAnimationInTheme(tipAniNode.spineNode, nil, file, cc.p(0,0), landAni, nil, nil, nil, true)
		tipAniNode.tipAnim = tipAnim
	end
	cell.symbolTipAnim = tipAniNode
	if willGetFeature then
		tipAnim:addAnimation(0, landLoopAni, true)
	else
		bole.spChangeAnimation(tipAnim, landLoopAni, true)
	end

	local a1 = cc.DelayTime:create(5/30)
	local a2 = cc.CallFunc:create(function ( ... )
		if cell and cell.sprite and bole.isValidNode(cell.sprite) then 
			cell.sprite:setVisible(false)
		end
		if tipAniNode and bole.isValidNode(tipAniNode) then
			if isScatter then 
				bole.changeParent(tipAniNode, self.animateNodeScatter)
			else 
				bole.changeParent(tipAniNode, self.animateNode)
			end
			local pos = self._mainViewCtl:getCellPos(crPos[1], crPos[2])
			tipAniNode:setPosition(pos)
		end
	end)
	local a3 = cc.Sequence:create(a1,a2)
	tipAniNode:runAction(a3)
end

function cls:playBoardJili()
	local file = self._mainViewCtl:getSpineFile("jili_halfboard")
	self._mainViewCtl:playMusicByName("reel_notify_board")
	-- bole.addSpineAnimationInTheme(self.flyParent, nil, file, cc.p(0,0), "animation")
	local _s, spine = bole.addSpineAnimationInTheme(self.mainThemeScene, 10, file, cc.p(0,0), "animation")
	if bole.isWidescreen() then 
		spine:setPositionY(-bole.getAdaptBottomHMoveY()/2)
	end
	self:addScreenShaker()
end
function cls:addScreenShaker()
    local function shakeEnd()
        self.shaker = nil
    end
    local time = 3
    self.shaker = ScreenShaker.new(self.down_node,time,shakeEnd)
	self._mainViewCtl:playMusicByName("base_shake")
	self.shaker:run()
end
function cls:stopScreenShaker()
    if self.shaker then
        self.shaker:stop()
        self.shaker = nil
    end
end

function cls:playScatterJili(pCol)
	local animate = "animation2"
	if pCol then
		-- self._mainViewCtl:playFadeToMinVlomeMusic()
		animate = "animation4"
	else 
		-- self._mainViewCtl:playFadeToMaxVlomeMusic()
	end
	if self.allScatterAniList and #self.allScatterAniList > 0 then
		for key, val in ipairs(self.allScatterAniList) do
			local col = val[2]
			local spineNode = val[1]
			if spineNode and bole.isValidNode(spineNode) then
				if pCol then
					if col < pCol and (not spineNode.jili) then
						spineNode:stopAllActions()
						local a1 = cc.DelayTime:create(25/30)
						local a2 = cc.CallFunc:create(function ()
							spineNode.jili = true
							if animate then
								bole.spChangeAnimation(spineNode, animate, true)
							end
						end)
						local a3 = cc.Sequence:create(a1, a2)
						spineNode:runAction(a3)
					end
				else
					spineNode:stopAllActions()
					bole.spChangeAnimation(spineNode, animate, true)
				end
			end
		end
	end
end

function cls:playScatterRecoverJili()
	self:playScatterJili()
	self.allScatterAniList = {}
end

function cls:playSymbolLandMusic( willGetFeature, item, pCol, isRespin)
	if not willGetFeature then return end
	self._mainViewCtl:setReelSpecailLandMusic(pCol)
	if item == self.gameConfig.special_symbol.scatter then
		self._mainViewCtl.audioCtl:playEffectWithInterval(self._mainViewCtl.audio_list["scatter_land"])
	elseif item == 12 then
		self._mainViewCtl.audioCtl:playEffectWithInterval(self._mainViewCtl.audio_list["bonus_land1"])
	elseif item == 13 then
		self._mainViewCtl.audioCtl:playEffectWithInterval(self._mainViewCtl.audio_list["bonus_land2"])
	end
	if isRespin then
		local colId = (pCol - 1) % 5 + 1
		self._mainViewCtl:setReelSpecailLandMusic(colId)
		self._mainViewCtl:setReelSpecailLandMusic(colId + 5)
		self._mainViewCtl:setReelSpecailLandMusic(colId + 10)
	end
end
function cls:getYellowDiamondSymbol(item)
	if item and item > 200 then
		return true
	end
	return false
end
function cls:getDiamondHighZorder(item, col, row, parent, pos, fromBonus, isShow)
	pos = pos or cc.p(0,0)
	self.diamondList = self.diamondList or {}
	self.diamondList[col] = self.diamondList[col] or {}
	if self.diamondList[col][row] then return self.diamondList[col][row] end
	if not item then return end
	parent = parent or self.animateNode
	local node = cc.Node:create()
	parent:addChild(node)
	local featureId = 12
	if self:getYellowDiamondSymbol(item) then
		featureId = 13
	end
	local spritePng = "#theme244_s_"..featureId..".png"	
	local theCellSprite = bole.createSpriteWithFile(spritePng)
	node:addChild(theCellSprite)

	local spineNode = cc.Node:create()
	node:addChild(spineNode)

	local jackpotNode = nil

	local labelNode = self:addSymbolFont()
	node:addChild(labelNode, 3)
	self:updateSymbolCoins(labelNode, item)

	local jpType = self._mainViewCtl:getHighDiamondSymbol(item)
	if jpType then
		local jpPng = "#theme244_s_jp_"..jpType..".png"	
		jackpotNode = bole.createSpriteWithFile(jpPng)
		jackpotNode.baseScale = 1
		node:addChild(jackpotNode, 2)
	end

	-- 判断是否存在jp的情况
	local aniName = "animation2"
	local aniNameLoop = "animation2"

	if fromBonus then 
		local scatterFile = self._mainViewCtl:getPic("spine/item/"..featureId.."/spine")
		local isLoop = true
		local s, tipAnim = bole.addSpineAnimationInTheme(spineNode, nil, scatterFile, cc.p(0,0), aniName, nil, nil, nil, true, isLoop)
		node.tipAnim = tipAnim
		theCellSprite:setVisible(false)
	end

	if isShow then 
		if labelNode then
			labelNode:setScale(0)
			-- local a1 = cc.DelayTime:create(2/30)
			local a2 = cc.ScaleTo:create(5/30, 1.28 * labelNode.baseScale)
			local a3 = cc.ScaleTo:create(10/30, 1 * labelNode.baseScale)
			-- local a4 = cc.ScaleTo:create(2/30, 1 * labelNode.baseScale)
			local a5 = cc.Sequence:create(a2,a3)
			labelNode:runAction(a5)
		end
		if jackpotNode then
			jackpotNode:setScale(0)
			local a2 = cc.ScaleTo:create(5/30, 1.28 * jackpotNode.baseScale)
			local a3 = cc.ScaleTo:create(10/30, 1 * jackpotNode.baseScale)
			-- local a1 = cc.DelayTime:create(2/30)
			-- local a2 = cc.ScaleTo:create(5/30, 1.15 * jackpotNode.baseScale)
			-- local a3 = cc.ScaleTo:create(3/30, 0.95 * jackpotNode.baseScale)
			-- local a4 = cc.ScaleTo:create(2/30, 1 * jackpotNode.baseScale)
			local a5 = cc.Sequence:create(a2,a3)
			jackpotNode:runAction(a5)
		end
	end

	node.aniNameLoop = aniNameLoop
	node.theCellSprite = theCellSprite
	node.spineNode = spineNode
	node.labelNode = labelNode
	node.jackpotNode = jackpotNode
	node:setPosition(pos)
	self.diamondList[col][row] = node 
	return node
end
---------------symbol end  ---------------
----------------------------------------------------------------------------------------
function cls:playWelcomeDialog()
	local data = {}
	local theData = {}
    local cabName = "dialog_welcome"
    local dialogName = "welcome_start"
    theData.click_event = function ( ... )
        self.wheelStartDialog = nil
		self._mainViewCtl:setFooterBtnsEnable(true)
		self._mainViewCtl:enableMapInfoBtn(true)
		self._mainViewCtl:showActivitysNode()
	end
	self.wheelStartDialog = self._mainViewCtl:showThemeDialog(theData, 1, cabName, dialogName)
	local btn_node = self.wheelStartDialog.startRoot.btnStart

	local baseScale =  bole.getAdaptScale()
	local bg_width = 555
	local scale = FRAME_HEIGHT / (bg_width * baseScale)
    scale = scale * (bg_width/720)
	btn_node:setScale(scale)

	if bole.isWidescreen() then 
		local moveY = bole.getAdaptBottomHMoveY()
		self.wheelStartDialog:setPositionY(-moveY / 2)
		btn_node:setPositionY(moveY / 2)
	end
	self._mainViewCtl:laterCallBack(5, function ()
		self:closeWelcomeTip()
	end)
end

function cls:closeWelcomeTip()
	if self.wheelStartDialog and bole.isValidNode(self.wheelStartDialog) then 
		self._mainViewCtl:stopMusicByName("base_welcome")
		local startRoot = self.wheelStartDialog.startRoot
		if startRoot and startRoot.btnStart then 
			self._mainViewCtl:setFooterBtnsEnable(true)
			self._mainViewCtl:enableMapInfoBtn(true)
			self._mainViewCtl:showActivitysNode()
			startRoot.btnStart:setTouchEnabled(false)
			self.wheelStartDialog:clickStartBtn()
			self.wheelStartDialog = nil
		end
	end
end

function cls:resetBoardCellsByItemList(_itemList, isFirst)
	if _itemList then 
		for col, colList in pairs(_itemList) do
			for row, itemKey in pairs(colList) do
				local cell = self.spinLayer.spins[col]:getRetCell(row)
				self:updateCellSprite(cell, itemKey, col, true, true)
				if isFirst and cell and itemKey == 14 then
					cell.sprite:setVisible(false)
					local file = self._mainViewCtl:getPic("spine/item/14/spine")
					local pos = self._mainViewCtl:getCellPos(col, row)
					local node = cc.Node:create()
					node:setPosition(pos)
					self.animateNodeScatter:addChild(node)
					bole.addSpineAnimationInTheme(node, nil, file, cc.p(0,0), "animation2",  nil, nil, nil, true, true)	
				end
			end
			local cellUp = self.spinLayer.spins[col]:getRetCell(0)
			if cellUp then
				self:updateCellSprite(cellUp, math.random(6, 11), col, true, true)
			end
			local cellDown = self.spinLayer.spins[col]:getRetCell(4)
			if cellDown then
				self:updateCellSprite(cellDown, math.random(6, 11), col, true, true)
			end
		end
	end

end

function cls:playWelComeClose()
	self:closeWelcomeTip()
end
----------------------------------------------------------------------------------------
function cls:addWareEffect()
	if self.isWaving then
		return
	end
	self.isWaving = true
	self:removeWareEffect()
	local renderNode = self.shakyNode
	local renderNodeZOrder = renderNode:getLocalZOrder()
	self.renderNode = renderNode

	local winSize = cc.Director:getInstance():getWinSize()
	self.renderTexture = cc.RenderTexture:create(winSize.width, winSize.height, 2, 0x88f0)
	if not self.renderTexture then
		self:removeWareEffect()
		return
	end
	self.renderTexture:retain()
	self.renderNode:setPosition(cc.p(winSize.width/2, winSize.height/2))
	self.renderTexture:beginWithClear(0, 0, 0, 0)
	self.renderNode:visit()
	self.renderTexture:endToLua()
	self.renderNode:setPosition(cc.p(0, 0))
	self.pgeRippleSprite = cc.PgeRippleSprite:create(self.renderTexture:getSprite():getTexture())
	self:addChild(self.pgeRippleSprite, renderNodeZOrder)
	self.pgeRippleSprite:setScaleY(-1)
	self.pgeRippleSprite:setPositionY(winSize.height/2)
	self.pgeRippleSprite:setPositionX(-winSize.width/2)
	local count = 0
	self.pgeRippleSprite:setVisible(false)
	local function update(dt)
		if self.renderTexture then
			count = count + 1
			
			self.renderNode:setVisible(true)
			self.renderNode:setPosition(cc.p(winSize.width/2, winSize.height/2))
			self.renderTexture:beginWithClear(0, 0, 0, 0)
			self.renderNode:visit()
			self.renderTexture:endToLua()
			self.renderNode:setPosition(cc.p(0, 0))
		
			if count >= 3 then
				self.renderNode:setVisible(false)
				self.pgeRippleSprite:setVisible(true)
			end
		end
    end
	local timerNode = cc.Node:create()
	self.pgeRippleSprite:addChild(timerNode)
    timerNode:scheduleUpdateWithPriorityLua(update, 0)
	local pos1 = bole.getWorldPos(self.moneyGrabNode)
    self.pgeRippleSprite:addRipple(self.pgeRippleSprite:convertToWorldSpace(pos1), 2, 20)
	self._mainViewCtl:laterCallBack(2.1, function ()
		self:removeWareEffect()
	end)
end
function cls:removeWareEffect()
	if self.renderNode then
		self.renderNode:setVisible(true)
	end
	if self.renderTexture then
		self.renderTexture:release()
		self.renderTexture = nil
	end	
	self.isWaving = false
	if self.pgeRippleSprite then
		self.pgeRippleSprite:removeFromParent(true)
		self.pgeRippleSprite = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------
function cls:setAdapterPhone( ... )
	if not self._mainViewCtl:adaptationLongScreen() then
        self.progressiveParent:setPositionY(0)
    else
		local moveY = self:getCharMovePos()
        self.progressiveParent:setPositionY(moveY)
    end
	self.mainThemeScene:setPosition(cc.p(0, 5))
end
function cls:getCharMovePos()
	local moveY = bole.getAdaptReelBoardY()
	local addPosY = 0
    local moveUp = moveY * 0.8
    if moveUp > 80 then -- 80
        moveUp = 80
	end
	if bole.isIphoneX() then 
		addPosY = -20
	end
	return -moveY + moveUp + addPosY
end

function cls:getBoardNodeList( ... )
	return self.boardNodeList
end
function cls:onExit()
	self:stopScreenShaker()
	self:removeWareEffect()
end

return cls







