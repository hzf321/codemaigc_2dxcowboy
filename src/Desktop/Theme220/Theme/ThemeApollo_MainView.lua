---@program src 220
---@create: : 2020-11-23 10:15:16
---@author: rwb
---
local parentCls = ThemeBaseView
local cls = class("ThemeApollo_MainView", parentCls)
local SpinLayerType
--local cls = ThemeApollo_MainView

function cls:ctor(ctl)
    self._mainViewCtl = ctl
    self.gameConfig = self._mainViewCtl:getGameConfig()
    parentCls.ctor(self, ctl)
    SpinLayerType = self.gameConfig.SpinLayerType

end

--@csb init interface
function cls:initScene(...)

    local path = self._mainViewCtl:getCsbPath("base")
    self.mainThemeScene = cc.CSLoader:createNode(path)
    bole.adaptScale(self.mainThemeScene, true)
    self.bgNode = self.mainThemeScene:getChildByName("theme_bg")
    self:_initBgNode()
    self.down_node = self.mainThemeScene:getChildByName("down_node")
    bole.adaptReelBoard(self.down_node)
    self.down_child = self.down_node:getChildByName("down_node")
    self.jpWheelNode = self.down_child:getChildByName("jp_wheel_node")
    self.reelRootNode = self.down_child:getChildByName("node_board_root")
    self.reelRootNode2 = self.down_child:getChildByName("node_board2")
    self.bgBoard = self.down_child:getChildByName("bg_board")
    local gameBoardNode = self.bgBoard:getChildByName("board_1")
    local boardRootNode = gameBoardNode:getChildByName("root")
    self.baseBoardNode = boardRootNode:getChildByName("reel1")
    self.freeBoardNode = boardRootNode:getChildByName("reel2")
    --self:_initBaseNode()
    self:_initBoardNode()

    self.jackpotNode = self.down_child:getChildByName("progressive")
    self.jackpotNodeTip = self.down_child:getChildByName("tip_node")
    self:_initJackpotNode()
    self.collectNode = self.down_child:getChildByName("collect_node")
    self:_initCollectNode()
    self.freeTipNode = self.down_child:getChildByName("free_tip")
    self:_initFreeGameNode()
    self.superTipNode = self.down_child:getChildByName("super_tip")
    self.superTipNode:setVisible(false)
    self.mapParent = self.mainThemeScene:getChildByName("store_node")
    self:_initMapNode() --点击的时候才创建
    self:_adaptLogoNode()
    self.dimmerMaskNode = self.mainThemeScene:getChildByName("dimmer_mask")
    self.dimmerMaskNode:setVisible(false)
    self.shakyNode:addChild(self.mainThemeScene)
    self:_addBoardSpine()
    self.maskStatus = {}
    self.maskStatus = { false, false }


    --self:setAdapterPhone()
end

function cls:_addBoardSpine()
    --
    local data = {}
    local parent = self.down_child:getChildByName("bg_board")
    data.file = self._mainViewCtl:getSpineFile("base_board")
    data.parent = parent
    data.isLoop = true
    data.pos = cc.p(0, -30)
    bole.addAnimationSimple(data)

end


--@add board
function cls:initBoardNodes(pBoardConfigList)
    local boardRoot = self.boardRoot
    local boardConfigList = pBoardConfigList or self._mainViewCtl:getBoardConfig() or {}
    local reelZorder = 100
    self.clipData = {}
    local pBoardNodeList = {}
    for boardIndex, theConfig in ipairs(boardConfigList) do
        local theBoardNode = nil
        local reelNodes = {}
        theBoardNode = cc.Node:create()
        boardRoot:addChild(theBoardNode)
        self:initBoardNodesByNormal(reelNodes, theConfig, reelZorder, theBoardNode, boardIndex)

        theBoardNode.reelNodes = reelNodes
        theBoardNode.reelConfig = theConfig["reelConfig"]
        theBoardNode.boardIndex = boardIndex
        theBoardNode.getReelNode = function(theSelf, index)
            return theSelf.reelNodes[index]
        end
        pBoardNodeList[boardIndex] = theBoardNode
    end
    self.clipAreaNode = self.flyNode

    return pBoardNodeList

end
function cls:initBoardNodesByNormal(reelNodes, theConfig, reelZorder, theBoardNode, boardIndex)
    --self.clipData["normal"] = {}
    local reelNode = cc.Node:create()
    reelNode:setLocalZOrder(reelZorder)
    local clipAreaNode = cc.Node:create()
    for reelIndex, config in ipairs(theConfig["reelConfig"]) do
        if (reelIndex - 1) % theConfig.colCnt == 0 then
            local down_rx = config.cellWidth * theConfig.colCnt
            local boardH = config.cellHeight * config.symbolCount
            local vex1 = {
                config["base_pos"],
                cc.pAdd(config["base_pos"], cc.p(down_rx, 0)),
                cc.pAdd(config["base_pos"], cc.p(down_rx, boardH)),
                cc.pAdd(config["base_pos"], cc.p(0, boardH)),
            }
            local vex2 = tool.tableClone(vex1)
            if theConfig["allow_over_range"] then
                vex2[1] = cc.pAdd(vex2[1], cc.p(-config["cellWidth"], 0))
                vex2[4] = cc.pAdd(vex2[4], cc.p(-config["cellWidth"], 0))
                vex2[2] = cc.pAdd(vex2[2], cc.p(config["cellWidth"], 0))
                vex2[3] = cc.pAdd(vex2[3], cc.p(config["cellWidth"], 0))
            end
            local stencil = cc.DrawNode:create()
            stencil:drawPolygon(vex2, #vex2, cc.c4f(1, 1, 1, 1), 0, cc.c4f(1, 1, 1, 1))
            clipAreaNode:addChild(stencil)
            local clipNode = cc.ClippingNode:create(clipAreaNode)
            theBoardNode:addChild(clipNode)
            clipNode:addChild(reelNode)
            if boardIndex == 1 then
                --
                --    local stencil2 = cc.DrawNode:create()
                --    stencil2:drawPolygon(vex1, #vex1, cc.c4f(1, 1, 1, 1), 0, cc.c4f(1, 1, 1, 1))
                --    local clipAreaNode2 = cc.Node:create()
                --    clipAreaNode2:addChild(stencil2)
                --    local clipNode2 = cc.ClippingNode:create(clipAreaNode2)
                --    local aniNode = cc.Node:create()
                --    clipNode2:addChild(aniNode)
                --    self.boomNode:addChild(clipNode2)
                --    self.boomClipNode = aniNode
                self:initTouchSpinBtn(config["base_pos"], down_rx, boardH)
            end
        end
        reelNodes[reelIndex] = reelNode
    end
end
--点击棋盘进行spin
function cls:initTouchSpinBtn(base_pos, boardW, boardH)
    local unitSize = 10
    local parent = self.boardRoot
    local img = "commonpics/kong.png"
    local touchSpin = function(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            self._mainViewCtl:clickBoard()
        end

    end
    local touchBtn = Widget.newButton(touchSpin, img, img, img, false) --10
    touchBtn:setPosition(base_pos)
    touchBtn:setAnchorPoint(cc.p(0, 0))
    touchBtn:setScaleX(boardW / unitSize)
    touchBtn:setScaleY(boardH / unitSize)
    parent:addChild(touchBtn)
end
--function cls:_initBaseNode(...)
--    local path = self._mainViewCtl:getCsbPath("base")
--    self.mainThemeScene = cc.CSLoader:createNode(path)
--    self.down_node = self.mainThemeScene:getChildByName("down_node")
--    self.down_child = self.down_node:getChildByName("down_node")
--    self.reelRootNode = self.down_child:getChildByName("reel_root_node")
--    self.boardRoot = self.reelRootNode:getChildByName("board_root")
--    self.animateNodeParent = self.down_child:getChildByName("animate_node")
--    self.animateNode = cc.Node:create()
--    self.animateNodeParent:addChild(self.animateNode)
--
--    self.reelCoinFlyLayer = self.down_child:getChildByName("top_fly_node")
--
--    bole.adaptScale(self.mainThemeScene, true)
--    bole.adaptReelBoard(self.down_node) -- 竖屏 适配 棋盘的 横屏不需要
--    self.shakyNode:addChild(self.mainThemeScene)
--end

function cls:_initBoardNode(...)
    self.boardRoot = self.reelRootNode:getChildByName("board_root")
    self.maskNode = self.reelRootNode:getChildByName("mask_node")
    self.maskNode:setVisible(false)
    self.animateNode = self.reelRootNode2:getChildByName("animate")
    self.stickWildNode = self.reelRootNode2:getChildByName("stick_node")
    self.boomNode = self.reelRootNode2:getChildByName("boom_node")
    self.themeAnimateKuang = self.reelRootNode2:getChildByName("win_line")
    self.movingNode = self.reelRootNode2:getChildByName("moving_node")
    self.scatterNode = self.reelRootNode2:getChildByName("scatter_node")
    self.flyNode = self.reelRootNode2:getChildByName("fly_node")
    --self.stickWildNumNode = self.reelRootNode2:getChildByName("stick_num_node")
    self.stickNumNode = self.reelRootNode2:getChildByName("stick_num_node")
end
function cls:updateBaseUI()
    local isBase = true
    self.collectNode:setVisible(isBase)
    self.freeTipNode:setVisible(not isBase)
    self.superTipNode:setVisible(not isBase)
    self.reelRootNode:setVisible(true)
    self.reelRootNode:setVisible(true)
    self.reelRootNode2:setVisible(true)
    self.bgBoard:setVisible(true)
    self.baseBoardNode:setVisible(isBase)
    self.freeBoardNode:setVisible(not isBase)
    self.jackpotNode:setVisible(true)
    self:changeSpinLayerByType(SpinLayerType.Normal)
    self:resetProgressNode(false)
end
function cls:updateFreeUI()
    local isBase = false
    self.collectNode:setVisible(isBase)
    self.freeTipNode:setVisible(not isBase)
    self.superTipNode:setVisible(false)
    self.reelRootNode:setVisible(true)
    self.reelRootNode2:setVisible(true)
    self.bgBoard:setVisible(true)
    self.baseBoardNode:setVisible(isBase)
    self.freeBoardNode:setVisible(not isBase)
    self.jackpotNode:setVisible(true)
    self:changeSpinLayerByType(SpinLayerType.FreeSpin)
    self:resetProgressNode(false)
end
function cls:updateSuperFreeUI()
    local isBase = false
    self.collectNode:setVisible(isBase)
    self.freeTipNode:setVisible(false)
    self.superTipNode:setVisible(true)
    self.reelRootNode:setVisible(true)
    self.reelRootNode2:setVisible(true)
    self.bgBoard:setVisible(true)
    self.baseBoardNode:setVisible(isBase)
    self.freeBoardNode:setVisible(not isBase)
    self.jackpotNode:setVisible(false)
    self:changeSpinLayerByType(SpinLayerType.MapFreeSpin)
    self:resetProgressNode(false)
end

function cls:updateReelWheelUI()
    self.collectNode:setVisible(false)
    self.reelRootNode:setVisible(false)
    self.freeTipNode:setVisible(false)
    self.superTipNode:setVisible(false)
    self.reelRootNode:setVisible(false)
    self.reelRootNode2:setVisible(false)
    self.bgBoard:setVisible(false)
    self.jackpotNode:setVisible(true)
    self:resetProgressNode(true)
end
function cls:resetProgressNode(isMoreTop)
    local addMoreY = 30
    if isMoreTop then
        self.jackpotNode:setPosition(cc.p(0, addMoreY))

    else
        self.jackpotNode:setPosition(cc.p(0, 0))
    end
    --if self._mainViewCtl:adaptationLongScreen() then
    --    if isMoreTop then
    --        self.logoNode:setPositionY(self.logoNode.basePos.y + addMoreY)
    --    else
    --        self.logoNode:setPositionY(self.logoNode.basePos.y)
    --    end
    --
    --end
end
function cls:changeBg(pType)

    local imgBG = { self.baseBg, self.freeBg, self.bonusBg }
    local showBg = imgBG[pType]
    if not showBg then
        return
    end
    self:stopCloudMoveAction()
    if self.curBg ~= showBg then
        local _curBg = self.curBg
        _curBg:runAction(cc.Sequence:create(cc.FadeTo:create(0.5, 0), cc.DelayTime:create(0.5), cc.CallFunc:create(function(...)
            _curBg:setVisible(false)
        end)))
        showBg:setOpacity(0)
        showBg:setVisible(true)
        showBg:runAction(cc.FadeTo:create(0.5, 255))
        self.curBg = showBg
    end
    self.spineBg:removeAllChildren()
    self.superTipNode:removeAllChildren()
    if pType == 1 then
        local data = {}
        data.file = self._mainViewCtl:getSpineFile("base_bg")
        data.parent = self.spineBg
        data.isLoop = true
        data.pos = cc.p(0, -140)
        --data.animateName = "animation"
        bole.addAnimationSimple(data)
    elseif pType == 2 then
        local data = {}
        data.file = self._mainViewCtl:getSpineFile("fg_bg")
        data.parent = self.spineBg
        data.isLoop = true
        data.pos = cc.p(0, -140)
        bole.addAnimationSimple(data)
    elseif pType == 3 then
        self:playCloudMoveAction()
        self:_addSuperScatterAni()

    end
end
function cls:_addSuperScatterAni()
    --local data1 = {}
    --data1.parent = self.superTipNode
    --data1.file = self._mainViewCtl:getPic("spine/item/15/spine")
    --data1.pos = cc.p(0, 0)
    --data1.isLoop = true
    --data1.animateName = "animation8"
    --local _, s1 = bole.addAnimationSimple(data1)

end
function cls:playCloudMoveAction()
    local cloud1 = self.bonusBg:getChildByName("cloud_1")
    local cloud2 = self.bonusBg:getChildByName("cloud_2")
    local cloud3 = self.bonusBg:getChildByName("cloud_3")

    local action1_1 = cc.CallFunc:create(
            function()
                cloud1:setPosition(cc.p(-200, 620))
            end)
    local action1_2 = cc.MoveTo:create(40, cc.p(800, 620))
    cloud1:runAction(cc.RepeatForever:create(cc.Sequence:create(action1_1, action1_2)))

    local action2_1 = cc.CallFunc:create(
            function()
                cloud2:setPosition(cc.p(-180, 520))
            end)
    local action2_2 = cc.MoveTo:create(35, cc.p(800, 520))
    cloud2:runAction(cc.RepeatForever:create(cc.Sequence:create(action2_1, action2_2)))

    local action3_1 = cc.CallFunc:create(
            function()
                cloud3:setPosition(cc.p(-150, 470.00))
            end)
    local action3_2 = cc.MoveTo:create(30, cc.p(800, 470))
    cloud3:runAction(cc.RepeatForever:create(cc.Sequence:create(action3_1, action3_2)))

end
function cls:stopCloudMoveAction()
    local cloud1 = self.bonusBg:getChildByName("cloud_1")
    local cloud2 = self.bonusBg:getChildByName("cloud_2")
    local cloud3 = self.bonusBg:getChildByName("cloud_3")
    cloud1:stopAllActions()
    cloud2:stopAllActions()
    cloud3:stopAllActions()
end

function cls:updateCollectUI(pType)
    local showCollect = { true, false, false, false }
    if pType then
        self.collectNode:setVisible(showCollect[pType])
    end
end
function cls:resetBoardShowNode(pType)
    self:changeSpinLayerByType(self.gameConfig.SpinLayerType[pType])
end

function cls:_initBgNode(...)
    self.baseBg = self.bgNode:getChildByName("bg_base")
    self.curBg = self.baseBg
    self.freeBg = self.bgNode:getChildByName("bg_free")
    self.freeBg:setVisible(false)
    self.bonusBg = self.bgNode:getChildByName("bg_bonus")
    self.bonusBg:setVisible(false)
    self.spineBg = self.bgNode:getChildByName("bg_spine")

    local bgHeight = 1560 / 2
    local adaptPos = -FRAME_WIDTH / 2 + bgHeight
    self.bgNode:setPositionY(adaptPos)
end

--function cls:getSpecialFeatureRoot(pType)
--    if pType == "jackpot" then
--        if not self.progressiveNode then
--            self.progressiveParent = self.mainThemeScene:getChildByName("progressive_parent")
--            self.progressiveNode = self.progressiveParent:getChildByName("progressive_node")
--        end
--        return self.progressiveNode
--    elseif pType == "collect" then
--        if not self.collectNode then
--            self.collectNode = self.down_child:getChildByName("collect_node")
--        end
--        return self.collectNode
--    elseif pType == "map" then
--        if not self.mapParentNode then
--            self.mapParentNode = cc.Node:create()
--            self.mapParentNode:setLocalZOrder(1)
--            self.mainThemeScene:addChild(self.mapParentNode)
--        end
--        return self.mapParentNode
--    elseif pType == "free" then
--        self.moveingWild = self.down_child:getChildByName("moveing_wild")
--        self.stickWild = self.down_child:getChildByName("stick_wild")
--        self.randomWild = self.down_child:getChildByName("random_wild")
--        return { self.moveingWild, self.stickWild, self.randomWild }
--    end
--end
function cls:_initFreeGameNode(...)
    --local freeList = self:getSpecialFeatureRoot("free")
    --if freeList then
    self._mainViewCtl:getFreeVCtl():initLayout(self.stickNumNode, self.movingNode, self.flyNode)
    --end
end

function cls:_initJackpotNode(...)
    self._mainViewCtl:getJpViewCtl():initLayout(self.jackpotNode, self.jackpotNodeTip)
end
function cls:_initCollectNode(...)
    self.collectTip = self.jackpotNodeTip:getChildByName("tip_node")
    self._mainViewCtl:getCollectViewCtl():initLayout(self.collectNode, self.collectTip, self.flyNode)
end
function cls:_initMapNode(...)

    self._mainViewCtl:getMapViewCtl():initLayout(self.mapParent)
end
function cls:getMapParentNode()
    return self.mapParent
end
---------------symbol start---------------
function cls:createCellSprite(key, col, rowIndex)

    local notInitSymbolSet = self.gameConfig.symbol_config.not_init_symbol_set or {}
    if notInitSymbolSet[key] then
        key = self._mainViewCtl:getNormalKey()
    end
    local theCellFile = self._mainViewCtl.pics[key]
    local theCellNode = cc.Node:create()
    local theCellSprite = bole.createSpriteWithFile(theCellFile)
    theCellNode:addChild(theCellSprite)
    theCellNode.key = key
    theCellNode.sprite = theCellSprite
    theCellNode.curZOrder = 0
    local landAnimate = cc.Node:create()
    theCellNode.tipNode = landAnimate
    theCellNode:addChild(landAnimate, 50)
    ------------------------------------------------------------
    self:adjustWithTheCellSpriteUpdate(theCellNode, key, col)
    local theKey = theCellNode.key
    if self._mainViewCtl.symbolZOrderList[theKey] then
        theCellNode.curZOrder = self._mainViewCtl.symbolZOrderList[theKey]
    end
    return theCellNode
end
function cls:updateCellSprite(theCellNode, key, col, isShowResult, isReset, fromReset)
    if key > 100 then
        local fiststKey = (key - key % 100) / 100
        if self._mainViewCtl.pics[fiststKey] then
            key = fiststKey
        end
    end
    local SpecialSymbol = self._mainViewCtl:getGameConfig().special_symbol

    if not isShowResult then
        local math_index = math.random(1, 10)
        if math_index == 1 then
            local key_type = self._mainViewCtl:needChageKey(col)
            if key_type > 0 then
                if key_type == 1 then
                    key = SpecialSymbol.scatter
                elseif key_type == 2 then
                    key = SpecialSymbol.jpWheel
                end
            end

        end
    end

    local theCellFile = self._mainViewCtl.pics[key]
    local theCellSprite = theCellNode.sprite
    theCellSprite:setVisible(true)
    bole.updateSpriteWithFile(theCellSprite, theCellFile)
    theCellNode.key = key
    theCellNode.curZOrder = 0
    ------------------------------------------------------------
    self:adjustWithTheCellSpriteUpdate(theCellNode, key, col)
    local theKey = theCellNode.key
    if self._mainViewCtl.symbolZOrderList[theKey] then
        theCellNode.curZOrder = self._mainViewCtl.symbolZOrderList[theKey]
    end
    if  not  isReset then
        if self.haveGoldWildList and self.haveGoldWildList[col] >= 2 and key == SpecialSymbol.goldWild then
            self:accumulateGoldWild(theCellNode, SpecialSymbol.goldWild)
        end
    end
end
function cls:refreshAccumulate(pCol)
    local cells = self.spinLayer.spins[pCol].cells
    for key, theCellNode in pairs(cells) do

        if theCellNode.symbolTipAnim2 and bole.isValidNode(theCellNode.symbolTipAnim2) then
            theCellNode.symbolTipAnim2:removeFromParent()

        end
        theCellNode.symbolTipAnim2 = nil
    end
end
function cls:refreshCellsZOrder(pCol)
    self.spinLayer:refreshCellsZOrder(pCol)
end
function cls:getItemAnimate(item, col, row, effectStatus, parent)
    if self.symbolsSkeleton and self.symbolsSkeleton[col .. "_" .. row] then
        self:playOldAnimation(col, row, effectStatus)
    else
        self:playItemAnimation(item, col, row, item)
    end
end
function cls:playOldAnimation(col, row, effectStatus)
    self.symbolsSkeleton = self.symbolsSkeleton or {}
    local item = self.symbolsSkeleton[col .. "_" .. row]
    if item then
        local node = item[1]
        local animationName = item[2]
        if bole.isValidNode(node) and animationName then
            bole.spChangeAnimation(node, animationName)
        end
        if item[4] then
            node:addAnimation(0, item[4], true)
        end
    end
end
function cls:playItemAnimation(item, col, row)
    local animateName = "animation"
    local cell = self.spinLayer.spins[col]:getRetCell(row)
    self:adjustWithTheCellSpriteUpdate(cell)
    local realItem = self._mainViewCtl:getRealItem(col, row)
    if realItem then
        item = realItem % 100
    end
    local loopName
    local specialSymbol = self._mainViewCtl:getGameConfig().special_symbol
    if item == specialSymbol.wild then
        animateName = "animation4"
    elseif item == specialSymbol.goldWild then
        animateName = "animation2"
        loopName = "animation1"
    end
    local zorder = 0
    if self._mainViewCtl.symbolZOrderList[item] then
        zorder = self._mainViewCtl.symbolZOrderList[item]
    else
        zorder = row
    end
    ------------------------------------------------------------------
    local pos = self._mainViewCtl:getCellPos(col, row)
    local spineFile = self._mainViewCtl:getPic("spine/item/" .. item .. "/spine")

    local _, s1 = bole.addSpineAnimation(self.animateNode, zorder, spineFile, pos, animateName, nil, nil, nil, true)
    self.symbolsSkeleton = self.symbolsSkeleton or {}
    self.symbolsSkeleton[col .. "_" .. row] = { s1, animateName, item, loopName }
    cell.sprite:setVisible(false)
    if loopName then
        s1:addAnimation(0, loopName, true)
    end
    self:hideStickWildNode(col, row, true)
end
function cls:playCellRoundEffect(theSprite)
    bole.addSpineAnimation(theSprite, nil, self._mainViewCtl:getSpineFile("win_kuang"), cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
end

function cls:stopDrawAnimate()
    self.symbolsSkeleton = nil
    parentCls.stopDrawAnimate(self)
end
function cls:clearAnimate()
    self.scatterNode:removeAllChildren()
    parentCls.clearAnimate(self)
end
function cls:showHugeWinAction()
    local function shakeEnd(...)
        self.addChestShaker = nil
    end
    local addChestShakerTime = 2

    local chestShaker = ScreenShaker.new(self.down_node, addChestShakerTime, shakeEnd) -- self.down_node  mainThemeScene
    chestShaker:run()
    self.addChestShaker = chestShaker

    if not self:getMaskStatus(1) then
        self:setMaskNodeStatus(1, true, true)
    end
    -- 播放动画
    self._mainViewCtl:playMusicByName("good_luck")
    local data = {}
    data.file = self._mainViewCtl:getSpineFile("jili_good_luck")
    data.pos = cc.p(360, 780)
    data.parent = self.flyNode
    bole.addAnimationSimple(data)
end
function cls:onExit()
    if self.addChestShaker then
        self.addChestShaker:stop()
    end
end
function cls:changeWildByBet()
    for col = 1, 5 do
        for row = 1, 9 do
            local cell = self.spinLayer.spins[col]:getRetCell(row)
            if cell.key == 15 then
                local key = self._mainViewCtl:getNormalKey()
                self:updateCellSprite(cell, key, col, true, true)
            end
        end
    end
end
---------------symbol end  ---------------


function cls:_adaptLogoNode(...)
    self.logoNode = self.mainThemeScene:getChildByName("logo_node")
    if self._mainViewCtl:adaptationLongScreen() then
        local posY, scale = self:getLogoLabelPos()
        bole.adaptComponent(self.logoNode, ComponentType.Top, 0, posY, true)
        local file1 = self._mainViewCtl:getSpineFile("logo_label")
        local _, s = bole.addSpineAnimation(self.logoNode, nil, file1, cc.p(0, 0), "animation", nil, nil, nil, true, true)
        self.logoNode:setVisible(true)
        self.logoLabelImg = s
        self.logoLabelImg:setScale(scale)
        self.logoNode.basePos = cc.p(self.logoNode:getPosition())
        self.logoLabelImg.basePos = cc.p(self.logoLabelImg:getPosition())
        self.logoLabelImg.baseScale = scale
    else
        self.logoNode:setVisible(false)
    end
    if self._mainViewCtl:getHeaderStatus() == 1 then
        self:downThemeLogo()
    end

end
function cls:downThemeLogo(noAni)

    if self.logoLabelImg then
        local endscale = self.logoLabelImg.baseScale * 0.8
        local endPosY = self.logoLabelImg.basePos.y
        self.logoLabelImg:stopActionByTag(1003)
        if not noAni then
            --local a1 = cc.ScaleTo:create(0.3, endscale)
            local a2 = cc.MoveTo:create(0.3, cc.p(0, endPosY))
            a2:setTag(1003)
            --self.logoLabelImg:runAction(cc.Spawn:create(a1, a2))
            self.logoLabelImg:runAction(a2)
        else
            self.logoLabelImg:setScale(endscale)
            self.logoLabelImg:setPositionY(endPosY)
        end
    end
end
function cls:upThemeLogo(noAni)
    if self.logoLabelImg then
        local endscale = self.logoLabelImg.baseScale
        local endPosY = self.logoLabelImg.basePos.y + 30
        self.logoLabelImg:stopActionByTag(1003)
        if not noAni then
            --local a1 = cc.ScaleTo:create(0.3, endscale)
            local a2 = cc.MoveTo:create(0.3, cc.p(0, endPosY))
            a2:setTag(1003)
            --self.logoLabelImg:runAction(cc.Spawn:create(a1, a2))
            self.logoLabelImg:runAction(a2)
        else
            self.logoLabelImg:setScale(endscale)
            self.logoLabelImg:setPositionY(endPosY)
        end

    end
end
function cls:_getHeaderWidth()
    local header_height = 40
    if bole.isIphoneX() then
        header_height = header_height + self:_IphoneXMoveDown()
    end
    return header_height
end

function cls:_getBActivityWidth()
    return 100
end

function cls:_IphoneXMoveDown()
    return 50
end
function cls:getLogoLabelPos()
    local headerHeight = self:_getHeaderWidth()
    local activityHeight = self:_getBActivityWidth()
    local scale = 1
    local emptyPos = bole.getAdaptReelBoardY() * 2

    if emptyPos < 180 then
        scale = emptyPos / 180
    end
    local moveY = bole.getAdaptReelBoardY() + headerHeight + activityHeight
    return moveY, scale
end

function cls:getBoardNodeList(...)
    return self.boardNodeList
end
function cls:getFlyLayer(...)
    return self.flyNode
end
function cls:getMaskStatus(index)
    if not self.maskStatus then
        return false
    end
    return self.maskStatus[index]

end
function cls:setMaskNodeStatus(imgIndex, isShow, isAni)
    local parent = self.maskNode
    if imgIndex == 2 then
        parent = self.dimmerMaskNode
    end
    if self.maskStatus[imgIndex] == isShow then
        return
    end
    self.maskStatus[imgIndex] = isShow
    if not isAni then
        if isShow then
            parent:setVisible(true)

            parent:setOpacity(200)
        else
            parent:setVisible(false)
        end
    else
        if isShow then
            parent:setVisible(true)

            parent:setOpacity(0)
            parent:runAction(cc.FadeTo:create(0.4, 200))

        else
            parent:setVisible(true)
            parent:setOpacity(200)
            parent:runAction(
                    cc.Sequence:create(
                            cc.FadeOut:create(0.4),
                            cc.Hide:create()
                    )
            )
        end
    end
end
function cls:playReelNotifyEffect(pCol, symbolID)
    self.reelNotifyEffectList = self.reelNotifyEffectList or {}
    local pos = self._mainViewCtl:getCellPos(pCol, 5)
    local data = {}
    local specialSymbol = self._mainViewCtl:getGameConfig().special_symbol
    data.parent = self.themeAnimateKuang

    if symbolID == specialSymbol.scatter then
        data.file = self._mainViewCtl:getSpineFile("jili_free")
        local index = pCol - 2
        if index > 1 then
            data.animateName = "animation" .. index
        else
            data.animateName = "animation"
        end
        self._mainViewCtl:playMusicByName("reel_notify_free" .. index)

    else
        data.file = self._mainViewCtl:getSpineFile("jili_free")
        data.animateName = "animation3"
        self._mainViewCtl:playMusicByName("reel_notify_free3")

    end
    data.isLoop = true
    data.pos = pos
    local _, s1 = bole.addAnimationSimple(data)
    self.reelNotifyEffectList[pCol] = s1
end
function cls:stopReelNotifyEffect(pCol)
    self.reelNotifyEffectList = self.reelNotifyEffectList or {}
    if self.reelNotifyEffectList[pCol] and (not tolua.isnull(self.reelNotifyEffectList[pCol])) then
        self.reelNotifyEffectList[pCol]:removeFromParent()
    end
    self.reelNotifyEffectList[pCol] = nil
end
-------- scatter
function cls:playItemTriggerSpine(item, col, row, isLoop)
    local cell = self.spinLayer.spins[col]:getRetCell(row)
    local pos = self._mainViewCtl:getCellPos(col, row)
    local specialSymbol = self._mainViewCtl:getGameConfig().special_symbol
    local animName
    if item == specialSymbol.scatter then
        animName = "animation2"
    elseif item == specialSymbol.jpWheel then
        animName = "animation2"
    end
    local spineFile = self._mainViewCtl:getPic("spine/item/" .. item .. "/spine")
    if isLoop then
        cell:setVisible(false)
        self:adjustWithTheCellSpriteUpdate(cell)
    end

    local data = {}
    data.file = spineFile
    data.parent = self.scatterNode
    data.pos = pos
    data.animateName = animName
    data.isLoop = isLoop
    bole.addAnimationSimple(data)
end
function cls:accumulateGoldWild(cell, key)
    local data = {}
    data.parent = cell.tipNode
    data.file = self._mainViewCtl:getPic("spine/item/" .. key .. "/spine")
    data.zOrder = 22
    data.animateName = "animation7"
    data.isRetain = true
    data.isLoop = true
    local _, s = bole.addAnimationSimple(data)
    cell.symbolTipAnim2 = s
end

function cls:playDropSpine(cell, key, isOnlyLoop, col, row)
    local animateName
    local loopName
    local fromGold = false
    if cell.symbolTipAnim2 then
        cell.symbolTipAnim = cell.symbolTipAnim2
        cell.symbolTipAnim2 = nil
        fromGold = true
        return
    end
    if cell.symbolTipAnim and isOnlyLoop then
        return
    end
    local spineFile = self._mainViewCtl:getPic("spine/item/" .. key .. "/spine")
    local specialSymbol = self._mainViewCtl:getGameConfig().special_symbol
    if key == specialSymbol.scatter then
        animateName = "animation"
        loopName = "animation1"
        --if not isOnlyLoop then
        --    self._mainViewCtl:playMusicByName("symbol_scatter")
        --end
    elseif key == specialSymbol.jpWheel then
        animateName = "animation"
        loopName = "animation1"
        --if not isOnlyLoop then
        --    self._mainViewCtl:playMusicByName("symbol_jpwheel")
        --end
    elseif key == specialSymbol.goldWild then
        animateName = "animation"
        loopName = "animation1"
    end

    local data = {}
    data.parent = cell

    data.isRetain = false
    if self._mainViewCtl:needRetainDropGold(col, row) then
        data.isRetain = true
    end
    data.file = spineFile
    data.zOrder = 22
    data.animateName = animateName
    if isOnlyLoop then
        data.animateName = loopName
        data.isLoop = true
    end
    local _, s = bole.addAnimationSimple(data)
    if not isOnlyLoop then
        s:addAnimation(0, loopName, true)
    end
    cell.symbolTipAnim = s
    s.parent = 1
    cell.sprite:setVisible(false)
end
function cls:changeSymbolAnimParent(cell, col, row)
    self._mainViewCtl:laterCallBack(5 / 30, function()
        if cell.symbolTipAnim and bole.isValidNode(cell.symbolTipAnim) then
            local symbolTipAnim = cell.symbolTipAnim
            local pos = self._mainViewCtl:getCellPos(col, row)
            bole.changeParent(symbolTipAnim, self.animateNode)
            symbolTipAnim.parent = 2
            symbolTipAnim:setPosition(pos)
            cell.symbolTipAnim = nil
        end
    end)
end
--function cls:updateCellOffsetByJp(col, row, key)
--
--
--    local symbolID = key % 100
--    local cell = self.spinLayer.spins[col]:getRetCell(row)
--    cell.key = symbolID
--    local theCellFile = self._mainViewCtl.pics[symbolID]
--    bole.updateSpriteWithFile(cell.sprite, theCellFile)
--    cell.sprite:setVisible(true)
--    self.spinLayer.spins[col]:refreshCellZOrder(cell)
--    if self._mainViewCtl.symbolZOrderList[symbolID] then
--        cell.curZOrder = self._mainViewCtl.symbolZOrderList[symbolID]
--    end
--    local symbolTipAnim = cell.symbolTipAnim
--    local cell_zise = self._mainViewCtl:getGameConfig().symbol_size
--    if symbolTipAnim and bole.isValidNode(symbolTipAnim) then
--        local a1 = cc.ScaleTo:create(0.3, 0.3)
--        local a2 = cc.MoveTo:create(0.3, cc.p(cell_zise[1] / 4, -cell_zise[2] / 4))
--        symbolTipAnim:removeFromParent()
--        local img_path = self._mainViewCtl.pics[13]
--        local img2 = bole.createSpriteWithFile(img_path)
--        cell.symbolTipAnim = img2
--        cell:addChild(img2)
--        img2:runAction(cc.Spawn:create(a1, a2))
--    end
--
--
--end
---------------------- jp wheel  start --------------------
function cls:getJpWheelParent()
    return self.jpWheelNode
end
---------------------- jp wheel  end --------------------
---------------------- stick wild start --------------------
function cls:createStickWildAndNum(stickInfo, isAnimate, isAllStop)
    local col = stickInfo[1][1] + 1
    local row = stickInfo[1][2] + 1
    local left = stickInfo[2]
    local isNumAni = isAnimate >= 2
    local isWildAni = isAnimate == 3
    self.curStickWildList = self.curStickWildList or {}
    self.curStickWildList[col] = self.curStickWildList[col] or {}
    local stickNode
    if self.curStickWildList[col][row] then
        stickNode = self.curStickWildList[col][row]
    else
        stickNode = cc.Node:create()
        self.stickWildNode:addChild(stickNode, row)
        stickNode.stick_info = tool.tableClone(stickInfo)
        self.curStickWildList[col][row] = stickNode
    end
    local zorder = row * 5
    stickNode:setLocalZOrder(zorder)
    local pos = self._mainViewCtl:getCellPos(col, row)

    if isAllStop then
        self:addStickNum(stickNode, left, pos, isNumAni)
        --local cell = self.spinLayer.spins[col]:getRetCell(row)
        --local specialSymbol = self._mainViewCtl:getGameConfig().special_symbol
        --local toWild = specialSymbol.goldWild
        --self:updateCellSprite(cell, toWild, col, row, true, true)
    end
    if not stickNode.stickSpine then
        self:addStickWild(stickNode, isWildAni)
    end
    stickNode:setPosition(pos)
end
function cls:addStickWild(parentNode, isAnimate)
    if parentNode.stickSpine then
        return
    end
    local data = {}
    data.file = self._mainViewCtl:getPic("spine/item/" .. 15 .. "/spine")
    data.animateName = "animation1"
    data.parent = parentNode
    data.isLoop = true
    local _, s = bole.addAnimationSimple(data)
    parentNode.stickSpine = s
    if isAnimate then
        self:playMusic(self.audio_list.phoenix_land)
    end
end
function cls:addStickNum(parentNode, left, pos, isAnimate)
    if parentNode.stickNum then
        return
    end
    if left <= 0 then
        return
    end
    local stick_wild_config = self._mainViewCtl:getGameConfig().stick_wild_config
    local num_config = stick_wild_config.num_config
    local NUM_OFFSET = num_config.num_offset
    local realPos = cc.pAdd(pos, NUM_OFFSET)
    local stickNumNode = cc.Node:create()
    self.stickNumNode:addChild(stickNumNode)
    stickNumNode:setPosition(realPos)
    local data = {}
    data.file = self._mainViewCtl:getSpineFile("stick_num")
    data.parent = stickNumNode
    data.animateName = "animation"
    if left > 0 then
        data.animateName = "animation" .. left
    end
    data.isLoop = true
    local _, s = bole.addAnimationSimple(data)
    stickNumNode.leftLabel = s
    parentNode.stickNum = stickNumNode

    if isAnimate then
        stickNumNode:setScale(0)
        stickNumNode:runAction(
                cc.Sequence:create(
                        cc.ScaleTo:create(0.2, 1)
                )
        )
    end
end
function cls:updateStickNum(stickNum, left, isAni, callBack)
    if stickNum and bole.isValidNode(stickNum) then
        local nextName = "animation"
        if left > 0 then
            nextName = "animation" .. left
        end
        if isAni then
            if stickNum.isHide then
                stickNum.leftLabel:setAnimation(0, nextName, true)
                stickNum:runAction(cc.ScaleTo:create(0.2, 1))
            else
                stickNum:runAction(
                        cc.Sequence:create(
                                cc.ScaleTo:create(0.1, 0.5),
                                cc.CallFunc:create(function()
                                    stickNum.leftLabel:setAnimation(0, nextName, true)
                                end),
                                cc.ScaleTo:create(0.2, 1),
                                cc.CallFunc:create(function()
                                    if callBack then
                                        callBack()
                                    end
                                end)
                        )
                )
            end

        else
            stickNum:setScale(1)
            stickNum.leftLabel:setAnimation(0, nextName, true)
        end
        stickNum.isHide = false
    end
end
function cls:removeStickNode(col, row, isAni)
    if self:checkIsCreateStickWild(col, row) then
        local node = self.curStickWildList[col][row]
        self.curStickWildList[col][row] = nil
        if not node then
            return
        end
        if node.stickSpine and bole.isValidNode(node.stickSpine) then
            node.stickSpine:removeFromParent()
        end
        if node.stickNum and bole.isValidNode(node.stickNum) then
            if isAni then
                node.stickNum:runAction(
                        cc.Sequence:create(
                                cc.ScaleTo:create(0.2, 1.2),
                                cc.ScaleTo:create(0.2, 0),
                                cc.RemoveSelf:create()
                        )
                )
            else
                node.stickNum:removeFromParent()
            end
        end
        if bole.isValidNode(node) then
            node:removeFromParent()
        end
    end
end
function cls:resetGoldWildCount()
    self.haveGoldWildList = { 0, 0, 0, 0, 0 }
end
function cls:updateStickLeftWild()
    self:resetGoldWildCount()
    self.curStickWildList = self.curStickWildList or {}
    self.stickNumNode:stopAllActions()
    local find = false
    local ROW_REEL_COUNT = 9
    local COL_REEL_COUNT = 5
    for col = 1, COL_REEL_COUNT do
        if self.curStickWildList[col] then
            for row = 1, ROW_REEL_COUNT do
                local itemNode = self.curStickWildList[col][row]
                if itemNode then
                    if not itemNode.stick_info then
                        self:removeStickNode(col, row, false)
                    elseif itemNode.stick_info[2] == 0 or itemNode.stick_info[3] > 0 then
                        self:removeStickNode(col, row, true)
                    else
                        local left = itemNode.stick_info[2] - 1
                        itemNode.stick_info[2] = left
                        self:updateStickNum(itemNode.stickNum, left, true)
                        self:showStickWildNode(col, row)
                        self.haveGoldWildList[col] = self.haveGoldWildList[col] + 1
                        find = true
                    end
                end
            end
        end
    end
    if find then
        self._mainViewCtl:playSecondLoopMusic()
    else
        self._mainViewCtl:stopSecondLoopMusic()
    end
end
function cls:showAllStickLeftWild()
    self.curStickWildList = self.curStickWildList or {}
    local ROW_REEL_COUNT = 9
    local COL_REEL_COUNT = 5
    for col = 1, COL_REEL_COUNT do
        if self.curStickWildList[col] then
            for row = 1, ROW_REEL_COUNT do
                local itemNode = self.curStickWildList[col][row]
                if itemNode then
                    if itemNode.stickNum then
                        local left = itemNode.stick_info[2]
                        self:updateStickNum(itemNode.stickNum, left)
                    end
                    self:showStickWildNode(col, row)
                end
            end
        end
    end
end
function cls:clearCurPageStickWild()
    self.stickWildNode:removeAllChildren()
    self.stickNumNode:removeAllChildren()
    self.movingNode:removeAllChildren()
    self.curStickWildList = {}
end
function cls:checkIsCreateStickWild(col, row)
    if not self.curStickWildList or not self.curStickWildList[col] or not self.curStickWildList[col][row] then
        return false
    end
    return true
end
function cls:updateCellByChangeWild(theCellNode, key)
    local theCellFile = self._mainViewCtl.pics[key]
    local theCellSprite = theCellNode.sprite
    bole.updateSpriteWithFile(theCellSprite, theCellFile)
    theCellNode.key = key
    theCellNode.curZOrder = 0
    local theKey = theCellNode.key
    if self._mainViewCtl.symbolZOrderList[theKey] then
        theCellNode.curZOrder = self._mainViewCtl.symbolZOrderList[theKey]
    end
end
function cls:playBoomCenterItem(col, row, boomType, step)

    local specialSymbol = self._mainViewCtl:getGameConfig().special_symbol
    if boomType > 0 then
        local boomCount = self._mainViewCtl:getBoomTmByType(boomType, col, row)
        local boomDelay = boomCount * 0.15
        if step == 1 or step == 3 then
            self:flashingBoomItem(col, row, step)
            self._mainViewCtl.node:runAction(
                    cc.Sequence:create(
                            cc.DelayTime:create(15 / 30),
                            cc.CallFunc:create(function()
                                self:playBoomAction(col, row)
                                self:removeStickNode(col, row, false)
                                self:fireOtherCell(col, row, boomType)
                            end),
                            cc.DelayTime:create(boomDelay / 30),
                            cc.CallFunc:create(function()
                                self:playBoomCenter(col, row)
                            end)

                    )
            )
        else
            self:playBoomAction(col, row)
            self:fireOtherCell(col, row, boomType)
        end
    else
        self:playFlameOutAction(col, row)
        local cell = self.spinLayer.spins[col]:getRetCell(row)
        self:updateCellByChangeWild(cell, specialSymbol.normalWild)
    end

end
function cls:playBoomCenter(col, row)
    local data = {}
    data.file = self._mainViewCtl:getSpineFile("gold_wild_center")
    data.parent = self.boomNode
    data.pos = self._mainViewCtl:getCellPos(col, row)
    bole.addAnimationSimple(data)
    self._mainViewCtl:playMusicByName("wild_success1")

end
function cls:playBoomAction(col, row)
    local specialSymbol = self._mainViewCtl:getGameConfig().special_symbol
    local cell = self.spinLayer.spins[col]:getRetCell(row)
    self:updateCellSprite(cell, specialSymbol.wild, col, true, true, true)
    local data = {}
    data.file = self._mainViewCtl:getSpineFile("wild_boom")
    data.parent = self.flyNode
    data.pos = self._mainViewCtl:getCellPos(col, row)
    self._mainViewCtl:playMusicByOnce("wild_red")
    bole.addAnimationSimple(data)
    self.symbolsSkeleton = self.symbolsSkeleton or {}
    if not self.symbolsSkeleton[col .. "_" .. row] then
        self._mainViewCtl:hideMapFreeWild(col, row)
        local data1 = {}
        data1.file = self._mainViewCtl:getPic("spine/item/" .. specialSymbol.wild .. "/spine")
        data1.parent = self.animateNode
        data1.pos = self._mainViewCtl:getCellPos(col, row)
        data1.animateName = "animation"
        data1.isRetain = true
        local _, s1 = bole.addAnimationSimple(data1)
        s1:addAnimation(0, "animation1", true)
        self.symbolsSkeleton[col .. "_" .. row] = { s1, "animation4", 1, "animation3" }
        s1:runAction(cc.Sequence:create(
                cc.DelayTime:create(5 / 30),
                cc.CallFunc:create(function()
                    local cell = self.spinLayer.spins[col]:getRetCell(row)
                    self:updateCellByChangeWild(cell, specialSymbol.wild)
                    cell.sprite:setVisible(false)
                end)
        )
        )
    end
end
function cls:playFlameOutAction(col, row)
    if self:checkIsCreateStickWild(col, row) then
        local node = self.curStickWildList[col][row]
        if not node then
            return
        end
        if node.stickSpine and bole.isValidNode(node.stickSpine) then
            node.stickSpine:setAnimation(0, "animation5", false)
        end
        local stickNum = node.stickNum
        node.stickNum = nil
        if stickNum and bole.isValidNode(stickNum) then
            stickNum:runAction(
                    cc.Sequence:create(
                            cc.ScaleTo:create(0.2, 1.2),
                            cc.ScaleTo:create(0.2, 0),
                            cc.RemoveSelf:create()
                    )
            )
        end
    end
    local specialSymbol = self._mainViewCtl:getGameConfig().special_symbol
    local cell = self.spinLayer.spins[col]:getRetCell(row)
    self:updateCellSprite(cell, specialSymbol.normalWild, col, true, true, true)
end
function cls:fireOtherCell(col, row, boomType)

    --local stick_wild_config = self._mainViewCtl:getGameConfig().stick_wild_config
    local boomPath = self._mainViewCtl:getBoomPath(boomType, col, row)
    for key = 1, #boomPath do
        local delatTm = key
        local items = boomPath[key]
        for key2 = 1, #items do
            local realCol = items[key2][1] + col
            local realRow = items[key2][2] + row
            if self._mainViewCtl:checkIsValibleColAndRow(realCol, realRow) then
                self.mainThemeScene:runAction(
                        cc.Sequence:create(
                                cc.DelayTime:create(delatTm * 0.15),
                                cc.CallFunc:create(function()
                                    self:playBoomAction(realCol, realRow)
                                end)
                        )
                )
            end
        end
    end
end
function cls:flashingBoomItem(col, row, step)
    if step and step == 3 then
        local cell = self.spinLayer.spins[col]:getRetCell(row)

        if cell.symbolTipAnim and bole.isValidNode(cell.symbolTipAnim) then
            local symbolTipAnim = cell.symbolTipAnim
            cell.symbolTipAnim = nil
            bole.changeParent(symbolTipAnim, self.stickWildNode, 10)
            local pos = self._mainViewCtl:getCellPos(col, row)
            symbolTipAnim:setPosition(pos)
            symbolTipAnim:setAnimation(0, "animation3", false)
            symbolTipAnim:runAction(
                    cc.Sequence:create(
                            cc.DelayTime:create(45 / 30),
                            cc.RemoveSelf:create()
                    )
            )
        end
    else
        if self:checkIsCreateStickWild(col, row) then
            local itemNode = self.curStickWildList[col][row]
            self:changeStickNumToZero(itemNode)
            if itemNode.stickSpine then
                itemNode.stickSpine:setAnimation(0, "animation3", false)
            end
        end
    end

end
function cls:changeStickNumToZero(itemNode)
    if not itemNode or not itemNode.stick_info then
        return
    end
    if itemNode.stick_info[2] == 0 then
        local stickNum = itemNode.stickNum
        itemNode.stickNum = nil
        itemNode.stick_info = nil
        if stickNum and bole.isValidNode(stickNum) then
            stickNum:runAction(cc.Sequence:create(
                    cc.ScaleTo:create(0.2, 0),
                    cc.RemoveSelf:create()
            )
            )
        end
    else
        itemNode.stick_info[2] = itemNode.stick_info[2] - 1
        local callBack = function()
            self:changeStickNumToZero(itemNode)
        end
        self:updateStickNum(itemNode.stickNum, itemNode.stick_info[2], true, callBack)
    end
end
function cls:changeFireSymbolToWild()

    if self.symbolsSkeleton then
        for key, value in pairs(self.symbolsSkeleton) do
            local item = value[1]
            item:setAnimation(0, "animation2", false)
            item:addAnimation(0, "animation3", true)
        end
    end

end
function cls:hideStickWildNode(col, row, isAni)
    if not self.curStickWildList or not self.curStickWildList[col] then
        return
    end
    local itemNode = self.curStickWildList[col][row]
    if not itemNode then
        return
    end
    if isAni then
        if itemNode.stickSpine then
            itemNode.stickSpine:stopActionByTag(2001)
            local action = cc.FadeOut:create(0.3)
            action:setTag(2001)
            itemNode.stickSpine:runAction(action)
        end
        if itemNode.stickNum and bole.isValidNode(itemNode.stickNum) then
            itemNode.stickNum:stopActionByTag(2001)
            local action = cc.ScaleTo:create(0.3, 0)
            itemNode.stickNum:runAction(action)
            itemNode.stickNum.isHide = true
        end
    else
        if itemNode.stickSpine and bole.isValidNode(itemNode.stickNum) then
            itemNode.stickSpine:stopActionByTag(2001)
            itemNode.stickSpine:setOpacity(0)
        end
        if itemNode.stickNum then
            itemNode.stickNum:stopActionByTag(2001)
            itemNode.stickNum:setScale(0)
            itemNode.stickNum.isHide = true
        end
    end

end
function cls:showStickWildNode(col, row, isAni)
    if not self.curStickWildList or not self.curStickWildList[col] then
        return
    end
    local itemNode = self.curStickWildList[col][row]
    if not itemNode then
        return
    end
    if itemNode.stickSpine then
        itemNode.stickSpine:stopActionByTag(2001)
        itemNode.stickSpine:setOpacity(255)
    end


end
---------------------- stick wild end ----------------------
return cls










