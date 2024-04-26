---@program src 224
---@create: : 2020/12/29 20:46
---@author: rwb
---
local parentCls = ThemeBaseView
local cls = class("ThemeGRII_MainView", parentCls)
local SpinLayerType

function cls:ctor(ctl)
    self._mainViewCt = ctl
    self.themeCtl = ctl
    self.gameConfig = self.themeCtl:getGameConfig()
    parentCls.ctor(self, ctl)
    SpinLayerType = self.gameConfig.SpinLayerType

end
function cls:getRetCell(col, row)
    local cell = self.spinLayer.spins[col]:getRetCell(row)
    return cell
end
function cls:initScene(...)

    local path = self.themeCtl:getCsbPath("base")
    self.mainThemeScene = cc.CSLoader:createNode(path)
    bole.adaptScale(self.mainThemeScene, true)
    self.bgNode = self.mainThemeScene:getChildByName("theme_bg")
    self:_initBgNode()
    self.down_node = self.mainThemeScene:getChildByName("down_node")
    bole.adaptReelBoard(self.down_node)
    self.down_child = self.down_node:getChildByName("down_node")
    --self.superNode = self.down_child:getChildByName("super_node")
    self.freePanel = self.down_child:getChildByName("free_panel")

    self.reelRootNode = self.down_child:getChildByName("node_board_root")
    self.reelRootNode2 = self.down_child:getChildByName("node_board_root2")
    self.bgBoard = self.down_child:getChildByName("bg_board")
    self:_initBgBoard()
    self:_initBoardNode()

    self.jackpotNode = self.mainThemeScene:getChildByName("progressive")
    self.jackpotNodeTip = self.jackpotNode:getChildByName("tip_node")
    self:_initJackpotNode()
    self.collectNode = self.down_child:getChildByName("collect_node")
    self:_initCollectNode()
    self:_initFreeGameNode()
    self.mapParent = self.mainThemeScene:getChildByName("store_node")
    self:_adaptCharNode()
    self:_adaptLogoNode()
    self.dimmerMaskNode = self.mainThemeScene:getChildByName("dimmer_mask")
    self.dimmerMaskNode:setVisible(false)
    self.shakyNode:addChild(self.mainThemeScene)

    self:_initMapNode()
    self.maskStatus = {}
    self.maskStatus = { false, false }

end

function cls:getDialogParent()
    return self.dialogNode
end
function cls:_initBgBoard()
    self.bgBaseBoardNode = self.bgBoard:getChildByName("board_1")
    self.bgBoardRoot = self.bgBaseBoardNode:getChildByName("root")
    self.bgBoardEar = self.bgBoardRoot:getChildByName("reel_ear")
    self.bgBoardEarFree = self.bgBoardRoot:getChildByName("reel_ear_free")
    self.bgBoardReels = self.bgBoardRoot:getChildByName("node")
    self.bgBoardSpineNode = self.bgBoardRoot:getChildByName("spine_node")
    self.bgBoardTopImg = self.bgBoardRoot:getChildByName("top_img")
    self.bgBoardDownImg = self.bgBoardRoot:getChildByName("down_img")
    self:_addBoardSpine()
end

function cls:_addBoardSpine()
    --
    self.bgBoardSpineNode:removeAllChildren()
    local data = {}
    data.file = self.themeCtl:getSpineFile("base_board")
    data.parent = self.bgBoardSpineNode
    data.isLoop = true
    data.pos = cc.p(0, 0)
    data.animateName = "animation1"
    local _, s = bole.addAnimationSimple(data)
    self.boardFrameSpine = s
end
function cls:_changeBoardSpine(board_type)

    local ani = "animation1"
    local pos = cc.p(0, 0)
    if board_type == 2 then
        ani = "animation2"
        pos = cc.p(0, 180)
    end
    self.boardFrameSpine:setPosition(pos)
    self.boardFrameSpine:setAnimation(0, ani, true)

end
function cls:initBoardTouchBtn(boardConfigList, pBoardNodeList)
    local base_config = boardConfigList

    for key = 1, #boardConfigList do
        local reelConfig = base_config[key].reelConfig
        local base_pos = reelConfig[1].base_pos
        local boardW = reelConfig[1].cellWidth * 5
        local boardH = reelConfig[1].cellHeight * reelConfig[key].symbolCount
        self:initTouchSpinBtn(base_pos, boardW, boardH, pBoardNodeList[key])
    end

end
function cls:initTouchSpinBtn(base_pos, boardW, boardH, parent)

    local unitSize = 10
    local img = "commonpics/kong.png"
    local touchSpin = function(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            self.themeCtl:clickBoard()
        end
    end
    local touchBtn = Widget.newButton(touchSpin, img, img, img, false) --10
    touchBtn:setPosition(base_pos)
    touchBtn:setAnchorPoint(cc.p(0, 0))
    touchBtn:setScaleX(boardW / unitSize)
    touchBtn:setScaleY(boardH / unitSize)
    parent:addChild(touchBtn)
end

function cls:_initBoardNode(...)
    self.boardRoot = self.reelRootNode:getChildByName("board_root")
    self.boardRoot:setLocalZOrder(1)
    self.maskNode = self.reelRootNode:getChildByName("img_mask")
    self.maskNode:setLocalZOrder(2)
    self.maskNode:setVisible(false)
    self.stickNode = self.reelRootNode:getChildByName("stick_node")
    self.stickNode:setLocalZOrder(3)
    self.animateNode = self.reelRootNode:getChildByName("animate")
    self.animateNode:setLocalZOrder(4)

    self.boomNode = self.reelRootNode:getChildByName("boom_node")
    self.boomNode:setLocalZOrder(5)

    self.themeAnimateKuang = self.reelRootNode:getChildByName("win_line")
    self.themeAnimateKuang:setLocalZOrder(6)

    self.scatterNode = self.reelRootNode2:getChildByName("scatter_node")
    self.scatterNode:setLocalZOrder(7)
    self.flyNode = self.reelRootNode2:getChildByName("fly_node")
    self.flyNode:setLocalZOrder(10)

end
function cls:updateBaseUI()

    self.down_child:setVisible(true)

    self.collectNode:setVisible(true)
    self.bgBoard:setVisible(true)
    self:changeSpinLayerByType(SpinLayerType.Normal)
    self:changeBoardBg(1)
    self.charNode:setVisible(true)
    self.freePanel:setVisible(false)
    self.jackpotNode:setVisible(true)

end
function cls:updateFreeUI(fg_type)

    local isBase = false
    self.collectNode:setVisible(isBase)
    self.bgBoard:setVisible(true)
    self:changeSpinLayerByType(SpinLayerType.FreeSpin)
    self:changeBoardBg(2)
    self.charNode:setVisible(false)
    self.jackpotNode:setVisible(true)
    if fg_type == 1 then
        self.freePanel:setVisible(true)
    else
        self.freePanel:setVisible(false)
    end

end
function cls:updateSuperFreeUI(isAnimate)
    local isBase = false
    self.collectNode:setVisible(false)
    self.bgBoard:setVisible(true)
    self:changeBoardBg(2)
    self.freePanel:setVisible(false)
    self.charNode:setVisible(false)
    self.jackpotNode:setVisible(true)
    self:changeSpinLayerByType(SpinLayerType.SuperFree)
    self.superCharDir = 0 -- to right
    --self.superNode:setPosition(cc.p(-320, 283))
    --self:loopSuperChar()
    --self:changeSuperDir()
end
function cls:closeSuperUI()
    --self.superNode:stopAllActions()
    --self.superNode:removeAllChildren()
    self.superSpine = nil
end
--end
--function cls:loopSuperChar()
--    local data = {}
--    data.file = self.themeCtl:getSpineFile("map_head")
--    data.parent = self.superNode
--    data.isRetain = true
--    data.isLoop = true
--    data.animateName = "animation1" -- 1.walk,2.loop,3.bigwin
--    local _, s = bole.addAnimationSimple(data)
--    self.superSpine = s
--    s:setMix("animation4", "animation3", 0.2)
--    s:setMix("animation4", "animation2", 0.2)
--    s:setMix("animation2", "animation4", 0.2)
--    s:setMix("animation2", "animation3", 0.2)
--end
--function cls:changeSuperBigWin()
--    self.superNode:stopAllActions()
--    self.superNode:runAction(cc.Sequence:create(
--            cc.DelayTime:create(80 / 30),
--            cc.CallFunc:create(function()
--                self:changeSuperDir(true)
--            end)
--    ))
--    if self.superSpine and bole.isValidNode(self.superSpine) then
--        self.superSpine:setAnimation(0, "animation3", false)
--        self.superSpine:addAnimation(0, "animation3", false)
--    end
--end
--function cls:changeSuperDir(isContinue)
--    local startX = -320
--    local endX = 320
--    if not isContinue then
--        self.randomCount = self.randomCount or 0
--        local nowPos = bole.getPos(self.superNode)
--        if nowPos.x <= startX + 1 and self.superCharDir >= 2 then
--            self.superCharDir = (self.superCharDir + math.random(1, 2)) % 4 -- 0 左边循环，1，向右走，2 右边循环，3 向左走
--        elseif nowPos.x >= endX - 1 and self.superCharDir <= 1 then
--            self.superCharDir = (self.superCharDir + math.random(1, 2)) % 4 -- 0 左边循环，1，向右走，2 右边循环，3 向左走
--        elseif self.superCharDir >= 2 then
--            local random = 0
--            if self.randomCount <= 1 then
--                random = math.random(1, 2)
--                self.randomCount = self.randomCount + 1
--            else
--                self.randomCount = 0
--                random = 1
--            end
--            self.superCharDir = 2 + (self.superCharDir + random) % 2
--        elseif self.superCharDir <= 1 then
--            local random = 0
--            if self.randomCount <= 1 then
--                random = math.random(1, 2)
--                self.randomCount = self.randomCount + 1
--            else
--                self.randomCount = 0
--                random = 1
--            end
--            self.superCharDir = (self.superCharDir + random) % 2
--        end
--        if self.superCharDir == 0 then
--            self.superNode:setScaleX(1)
--        elseif self.superCharDir == 1 then
--            self.superNode:setScaleX(1)
--        elseif self.superCharDir == 2 then
--            self.superNode:setScaleX(-1)
--        elseif self.superCharDir == 3 then
--            self.superNode:setScaleX(-1)
--        end
--    end
--    local pos = bole.getPos(self.superNode)
--    local firstDelay = 0
--    local a0
--    if self.superCharDir == 0 then
--        firstDelay = 80 / 30
--        a0 = cc.DelayTime:create(firstDelay)
--        self.superSpine:setAnimation(0, "animation2", true)
--    elseif self.superCharDir == 1 then
--        --local last = endX - pos.x
--        --firstDelay = last / 160
--        --local realEndX = endX
--        --local delay = firstDelay
--        --if delay > 50 / 30 then
--        --    delay = 50 / 30
--        --    realEndX = pos.x + delay / firstDelay * last
--        --end
--        local delay, realEndX = self:getSuperCharInfo(self.superCharDir)
--        a0 = cc.MoveTo:create(delay, cc.p(realEndX, 283))
--        self.superSpine:setAnimation(0, "animation4", true)
--    elseif self.superCharDir == 2 then
--        firstDelay = 80 / 30
--        a0 = cc.DelayTime:create(firstDelay)
--        self.superSpine:setAnimation(0, "animation2", true)
--    elseif self.superCharDir == 3 then
--        --local last = pos.x - startX
--        --local realEndX = startX
--        --firstDelay = last / 160
--        --local delay = firstDelay
--        --if firstDelay > 50 / 30 then
--        --    delay = 50 / 30
--        --    realEndX = pos.x - delay / firstDelay * last
--        --end
--        local delay, realEndX = self:getSuperCharInfo(self.superCharDir)
--        a0 = cc.MoveTo:create(delay, cc.p(realEndX, 283))
--        self.superSpine:setAnimation(0, "animation4", true)
--    end
--    self.superNode:runAction(
--            cc.Sequence:create(
--                    a0,
--                    cc.CallFunc:create(function()
--                        self:changeSuperDir()
--                    end)
--            ))
--end
--function cls:getSuperCharInfo(cur_dir)
--    local startX = -320
--    local endX = 320
--    local pos = bole.getPos(self.superNode)
--    local delay
--    local realEndX
--    if cur_dir == 1 then
--        local last = endX - pos.x
--        local firstDelay = last / 160
--        realEndX = endX
--        delay = firstDelay
--        if delay > 50 / 30 then
--            delay = 50 / 30
--            realEndX = pos.x + delay / firstDelay * last
--        end
--    elseif cur_dir == 3 then
--        local last = pos.x - startX
--        realEndX = startX
--        local firstDelay = last / 160
--        delay = firstDelay
--        if firstDelay > 50 / 30 then
--            delay = 50 / 30
--            realEndX = pos.x - delay / firstDelay * last
--        end
--    end
--    return delay, realEndX
--end

------------------ small slot start ------------------
function cls:changeRootNodeParent(toMain, newParent)
    if toMain then
        bole.changeParent(self.boardRoot, self.reelRootNode, 1)
        bole.changeParent(self.animateNode, self.reelRootNode, 4)
    else
        bole.changeParent(self.boardRoot, newParent, 1)
        bole.changeParent(self.animateNode, newParent, 4)
    end
end
function cls:updateSmallSlotUI()
    self.down_child:setVisible(false)
    self:changeSpinLayerByType(SpinLayerType.SmallSlot)
end
------------------ small slot end------------------
function cls:updateWheelUI()
    self.down_child:setVisible(false)
end
function cls:changeBoardBg(board_type)
    if board_type == 1 then
        self.bgBoardEarFree:setVisible(false)
        self.bgBoardEar:setVisible(true)
        self.bgBoardReels:setScaleY(1)
        self.bgBoardEar:setPositionY(185)
        self.bgBoardTopImg:setPositionY(366)
    else
        self.bgBoardEarFree:setVisible(true)
        self.bgBoardEar:setVisible(false)
        self.bgBoardReels:setScaleY(2)
        self.bgBoardEar:setPositionY(370)
        self.bgBoardTopImg:setPositionY(726)
    end
    self:_changeBoardSpine(board_type)

end

function cls:changeBg(pType)

    local imgBG = { self.baseBg, self.freeBg, self.bonusBg }
    local showBg = imgBG[pType]
    if not showBg then
        return
    end
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
    if pType == 1 then
        local data = {}
        data.file = self.themeCtl:getSpineFile("base_bg")
        data.parent = self.spineBg
        data.isLoop = true
        data.pos = cc.p(0, -140)
        bole.addAnimationSimple(data)
    elseif pType == 2 then
        local data = {}
        data.file = self.themeCtl:getSpineFile("fg_bg")
        data.parent = self.spineBg
        data.isLoop = true
        data.pos = cc.p(0, -140)
        bole.addAnimationSimple(data)
    elseif pType == 3 then
        local data = {}
        data.file = self.themeCtl:getSpineFile("fg_bg")
        data.parent = self.spineBg
        data.isLoop = true
        data.pos = cc.p(0, -140)
        bole.addAnimationSimple(data)
    end
end
function cls:changeSpinLayerByType(pType)
    if self.spinLayer ~= self.spinLayerList[pType] then
        self.spinLayer:DeActive()
        self.spinLayer = self.spinLayerList[pType]
        self.spinLayer:Active()
    end

    self:refreshColCellsZOrder()
    self.themeCtl:changeSpinLayer(self.spinLayer)
    self.initBoardIndex = pType
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
function cls:_initFreeGameNode(...)
    self.freeMaskNode = self.freePanel:getChildByName("free_node")
    self.themeCtl:getFreeVCtl():initLayout(self.stickWildNode, self.flyNode)
end
---@param level /0: masked 4 row, /4:masked 0 row
function cls:playFreeMaskLevel(level, isAni)
    local zero_level = cc.p(360.00, 364)
    local Height = self.gameConfig.symbol_size[2]
    local addPos = 0
    if level == 4 then
        addPos = 10
    end
    local endPos = cc.pAdd(zero_level, cc.p(0, level * Height + addPos))
    if isAni then
        self.themeCtl:playMusicByName("move")
        local a1 = cc.MoveTo:create(0.5, endPos)
        self.freeMaskNode:runAction(a1)
    else
        self.freeMaskNode:setPosition(endPos)
    end
end
function cls:_initMapNode(...)
    self._mainViewCtl:getMapViewCtl():initLayout(self.mapParent)
end

function cls:adjustWithTheCellSpriteUpdate(theCellNode)
    if theCellNode.symbolTipAnim then
        if (not tolua.isnull(theCellNode.symbolTipAnim)) then
            theCellNode.symbolTipAnim:stopAllActions()
            theCellNode.symbolTipAnim:removeFromParent()
        end
    end
    theCellNode.symbolTipAnim = nil
    if theCellNode.symbolTipAnim2 then
        if (not tolua.isnull(theCellNode.symbolTipAnim2)) then
            theCellNode.symbolTipAnim2:stopAllActions()
            theCellNode.symbolTipAnim2:removeFromParent()
        end
    end
    theCellNode.symbolTipAnim2 = nil
end

function cls:_initJackpotNode(...)
    if not self.themeCtl:adaptationLongScreen() then
        local moveY = bole.getAdaptReelBoardY() * 0.3
        if moveY == 0 then
            self.jackpotNode:setPositionY(30)
        else
            self.jackpotNode:setPositionY(moveY)
        end
    else
        local moveY = self:getCharMovePos()
        self.jackpotNode:setPositionY(moveY)
    end
    self.jackpotNodeTip:setLocalZOrder(100)
    self.themeCtl:getJpViewCtl():initLayout(self.jackpotNode, self.jackpotNodeTip)
    self.jackpotNode.basePos = bole.getPos(self.jackpotNode)
end
function cls:_initCollectNode(...)
    self.themeCtl:getCollectViewCtl():initLayout(self.collectNode, self.flyNode)
end
function cls:getMapParentNode()
    return self.mapParent
end
---------------symbol start---------------
function cls:createCellSprite(key, col, rowIndex)

    local notInitSymbolSet = self.gameConfig.symbol_config.not_init_symbol_set or {}

    -- if self.initBoardIndex == 3 then
    --     key = math.random(102, 109)
    -- elseif notInitSymbolSet[key] then
        key = self.themeCtl:getNormalKey()
    -- end

    local theCellFile = self.themeCtl.pics[key]
    local theCellNode = cc.Node:create()
    if not theCellFile then
        key = self.themeCtl:getNormalKey()
        theCellFile = self.themeCtl.pics[key]
    end
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
    if self.themeCtl.symbolZOrderList[theKey] then
        theCellNode.curZOrder = self.themeCtl.symbolZOrderList[theKey]
    end
    return theCellNode
end

function cls:updateCellSprite(theCellNode, key, col, isShowResult, isReset, fromReset)
    local SpecialSymbol = self.themeCtl:getGameConfig().special_symbol
    local SpinBoardType = self.themeCtl:getGameConfig().SpinBoardType
    local multi = 1
    if self.initBoardIndex == 1 then
        if key > 200 then
            key = 12
        end
        if key == SpecialSymbol.multiWild then
            key = 1
        end
        if key == SpecialSymbol.scatter then
            if col == 1 or col == 5 then
                key = math.random(1, 10)
            end
        end
    elseif self.initBoardIndex == 2 then
        if key > 1000 then
            multi = key % 1000
            key = SpecialSymbol.multiWild
        end
        if key == 12 then
            key = math.random(1, 10)
        end
        if key == SpecialSymbol.scatter then
            key = math.random(1, 10)
        end
        if not isShowResult then
            if key == SpecialSymbol.multiWild then
                key = math.random(1, 10)
            end
        end
    elseif self.initBoardIndex == 3 then
        if key < 100 or key > 200 then
            key = math.random(102, 109)
        end
    end
    local theCellFile = self.themeCtl.pics[key]
    local theCellSprite = theCellNode.sprite
    theCellSprite:setVisible(true)
    bole.updateSpriteWithFile(theCellSprite, theCellFile)
    theCellNode.key = key
    theCellNode.curZOrder = 0
    ------------------------------------------------------------
    self:adjustWithTheCellSpriteUpdate(theCellNode, key, col)
    local theKey = theCellNode.key
    if self.themeCtl.symbolZOrderList[theKey] then
        theCellNode.curZOrder = self.themeCtl.symbolZOrderList[theKey]
    end

end
function cls:resetAllCellSpite()
    local SpecialSymbol = self.themeCtl:getGameConfig().special_symbol
    for col = 1, 5 do
        local cells = self.spinLayer.spins[col].cells
        for key, theCellNode in pairs(cells) do
            if cells.key == SpecialSymbol.goldWild or cells.key == SpecialSymbol.wild then
                self:updateCellSprite(theCellNode, math.random(2, 8), col)
            end
        end
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
    if col == 3 then
        self:playMultiWinLine(row)
    end
    self.symbolsSkeleton = self.symbolsSkeleton or {}
    local item = self.symbolsSkeleton[col .. "_" .. row]
    if item then
        local node = item[1]
        local animationName = item[2]
        if bole.isValidNode(node) and animationName then
            bole.spChangeAnimation(node, animationName)
        end
        if item[4] then
            node:addAnimation(0, item[2], false)
        end
    end
end
function cls:playItemAnimation(item, col, row)
    local symbolID
    local animateName
    local specialSymbol = self.themeCtl:getGameConfig().special_symbol
    if item > 1000 then
        symbolID = specialSymbol.wild
        animateName = "animation2"
        self:playMultiWinLine(row)
    else
        symbolID = item % 100
        animateName = "animation"
        symbolID = self.themeCtl:getRealItem(col, row) or symbolID
    end
    if symbolID == specialSymbol.wild and self.themeCtl:checkIsStickyWild() then
        animateName = "animation6"
    end

    local cell = self:getRetCell(col, row)
    self:adjustWithTheCellSpriteUpdate(cell)

    local zorder = 0
    if self.themeCtl.symbolZOrderList[symbolID] then
        zorder = self.themeCtl.symbolZOrderList[symbolID]
    else
        zorder = row
    end
    ------------------------------------------------------------------
    local pos = self.themeCtl:getCellPos(col, row)
    local spineFile = self.themeCtl:getPic("spine/item/" .. symbolID .. "/spine")

    local _, s1 = bole.addSpineAnimation(self.animateNode, zorder, spineFile, pos, animateName, nil, nil, nil, true, false)
    self.symbolsSkeleton = self.symbolsSkeleton or {}
    local isLow = false
    if self:checkIsLowSymbol(symbolID) then
        isLow = true
        s1:addAnimation(0, animateName, false)
    end
    self.symbolsSkeleton[col .. "_" .. row] = { s1, animateName, item, isLow }
    cell.sprite:setVisible(false)
end
function cls:checkIsLowSymbol(symbolID)
    if symbolID >= 7 and symbolID <= 10 then
        return true
    end
    return false

end
function cls:playCellRoundEffect(theSprite)
    bole.addSpineAnimation(theSprite, nil, self.themeCtl:getSpineFile("win_kuang"), cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
end

function cls:stopDrawAnimate()
    self.symbolsSkeleton = nil
    self:stopMultiWinLine()
    parentCls.stopDrawAnimate(self)
end
function cls:clearAnimate()
    self.scatterNode:removeAllChildren()
    --self.dialogScatterNode:removeAllChildren()
    parentCls.clearAnimate(self)
end
function cls:showGoodNotifyAction()

    if not self:getMaskStatus(1) then
        self:setMaskNodeStatus(1, true, true)
    end
    -- 播放动画
    self.themeCtl:playMusicByName("good_luck")
    local data = {}
    data.file = self.themeCtl:getSpineFile("jili_good_luck")
    data.pos = cc.p(360, 640)
    data.parent = self.flyNode
    bole.addAnimationSimple(data)
    self.logoCharSpine:setAnimation(0, "animation2", false)
    self.logoCharSpine:addAnimation(0, "animation1", true)
    self.charNode.canTouch = false
    self.charNode:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(3),
                    cc.CallFunc:create(function()
                        self.charNode.canTouch = true
                    end)
            )
    )
end
function cls:showBigWinAction()
    local addChestShakerTime = 2
    local function shakeEnd(...)
        self.addChestShaker = nil
    end

    local chestShaker = ScreenShaker.new(self.reelRootNode, addChestShakerTime, shakeEnd) -- self.down_node  mainThemeScene
    chestShaker:run()
    self.addChestShaker = chestShaker

    local chestShaker2 = ScreenShaker.new(self.reelRootNode2, addChestShakerTime, shakeEnd) -- self.down_node  mainThemeScene
    chestShaker2:run()
    self.addChestShaker2 = chestShaker2

end

function cls:_getHeaderWidth()
    local header_height = 60
    if bole.isIphoneX() then
        header_height = header_height + self:_IphoneXMoveDown()
    end
    return header_height
end

function cls:_getBActivityWidth()
    return 50
end

function cls:_IphoneXMoveDown()
    return 60
end
function cls:getLogoLabelPos()
    local headerHeight = self:_getHeaderWidth()
    local activityHeight = self:_getBActivityWidth()
    local scale = 1
    local emptyPos = bole.getAdaptReelBoardY() * 1.5

    if emptyPos < 200 then
        scale = emptyPos / 200
    end
    local moveY = bole.getAdaptReelBoardY() + headerHeight + activityHeight
    return moveY, scale
end
function cls:_adaptLogoNode(...)
    self.logoNode = self.mainThemeScene:getChildByName("logo_node")
    if self.themeCtl:adaptationLongScreen() then
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
function cls:_adaptCharNode(...)
    self.charNode = self.mainThemeScene:getChildByName("char_node")
    local data = {}
    data.file = self.themeCtl:getSpineFile("main_char")
    data.parent = self.charNode
    data.isLoop = true
    data.animateName = "animation1"
    local _, s = bole.addAnimationSimple(data)
    local moveY = self:getCharMovePos()
    self.charNode:setPositionY(moveY)
    self.logoCharSpine = s
    s:setMix("animation1", "animation2", 0.2)
    s:setMix("animation1", "animation3", 0.2)
    self:initBgListen()
end
function cls:getCharMovePos()
    local moveY = bole.getAdaptReelBoardY()
    local moveUp = moveY * 0.3
    if moveUp > 80 then
        moveUp = 80
    end
    return -moveY + moveUp
end
function cls:initBgListen()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    local function onTouchBegan (touch, event)
        self.charNode.startPosition = nil
        local endRow = self.themeCtl:getEndRowByCol(1)
        if endRow == 8 then
            return false
        end
        if self.charNode.canTouch then
            local startpos = cc.p(touch:getLocation())
            local startpos2 = self.charNode:convertToNodeSpace(startpos)
            if startpos2.x < -360 or startpos2.x > 360 then
                return false
            end
            if startpos2.y < 300 and startpos2.y > -110 then
                self.charNode.startPosition = startpos2
                return true
            end
            return false
        end
        return false
    end
    local function onTouchCancelled (touch, event)
        self.charNode.startPosition = nil
    end

    local function onTouchEnded (touch, event)
        if self.charNode.startPosition and self.charNode.canTouch then
            local location = touch:getLocation()
            self:chooseGameSelectBtnClickFunc(location)
        end
    end
    self.charNode.canTouch = true
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED) -- 同楼上
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = self.charNode:getEventDispatcher() -- 通过它管理当前节点（场景、层、精灵等）的所有事件的分发。
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.charNode)-- 添加一个事件监听器到事件派发器
end
function cls:chooseGameSelectBtnClickFunc(location)
    if self.charNode.canTouch then
        self.logoCharSpine:setAnimation(0, "animation3", false)
        self.logoCharSpine:addAnimation(0, "animation1", true)
        self.themeCtl:playMusicByName("char_touch")
        self.charNode.canTouch = false
        self.charNode:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(70 / 30),
                        cc.CallFunc:create(function()
                            self.charNode.canTouch = true
                        end)
                )
        )
    end

end

function cls:downThemeLogo(noAni)

    if self.themeCtl:adaptationLongScreen() then
        self:downLogoLabelPos(noAni)
    else
        self:downJackpotPos(noAni)
    end

end
function cls:downLogoLabelPos(noAni)
    if self.logoLabelImg then
        local endscale = self.logoLabelImg.baseScale * 0.85
        local endPosY = self.logoLabelImg.basePos.y
        self.logoLabelImg:stopActionByTag(1003)
        if not noAni then
            local a1 = cc.ScaleTo:create(0.3, endscale)
            local a2 = cc.MoveTo:create(0.3, cc.p(0, endPosY))
            local a3 = cc.Spawn:create(a1, a2)
            a3:setTag(1003)
            self.logoLabelImg:runAction(a3)
        else
            self.logoLabelImg:setScale(endscale)
            self.logoLabelImg:setPositionY(endPosY)
        end
    end
end
function cls:downJackpotPos(noAni)
    if self.jackpotNode then
        local endPos = cc.pAdd(self.jackpotNode.basePos, cc.p(0, -20))
        self.jackpotNode:stopAllActions()
        if not noAni then
            local a2 = cc.MoveTo:create(0.3, endPos)
            self.jackpotNode:runAction(a2)
        else
            self.jackpotNode:setPosition(endPos)
        end
    end
end
function cls:upThemeLogo(noAni)
    if self.themeCtl:adaptationLongScreen() then
        self:upLogoLabelPos(noAni)
    else
        self:upJackpotPos(noAni)
    end
end
function cls:upJackpotPos(noAni)
    if self.jackpotNode then
        local endPos = self.jackpotNode.basePos
        if not noAni then
            self.jackpotNode:stopAllActions()
            local a2 = cc.MoveTo:create(0.3, endPos)
            self.jackpotNode:runAction(a2)
        else
            self.jackpotNode:setPosition(endPos)
        end
    end
end
function cls:upLogoLabelPos(noAni)
    if self.logoLabelImg then
        local endscale = self.logoLabelImg.baseScale
        local endPosY = self.logoLabelImg.basePos.y + self:_getBActivityWidth()/2
        self.logoLabelImg:stopActionByTag(1003)
        if not noAni then
            local a1 = cc.ScaleTo:create(0.3, endscale)
            local a2 = cc.MoveTo:create(0.3, cc.p(0, endPosY))

            local a3 = cc.Spawn:create(a1, a2)
            a3:setTag(1003)
            self.logoLabelImg:runAction(a3)
        else
            self.logoLabelImg:setScale(endscale)
            self.logoLabelImg:setPositionY(endPosY)
        end

    end
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
    local maskLevel = 150
    if imgIndex == 2 then
        parent = self.dimmerMaskNode
        maskLevel = 200
    else
        --if self.themeCtl:getEndRowByCol(1) == 4 then
        local endRow = self.themeCtl:getEndRowByCol(1)
        parent:setScaleY(endRow * 90 / 720)
        --end
    end
    if self.maskStatus[imgIndex] == isShow then
        return
    end
    if not parent then
        return
    end
    self.maskStatus[imgIndex] = isShow
    if not isAni then
        if isShow then
            parent:setVisible(true)

            parent:setOpacity(maskLevel)
        else
            parent:setVisible(false)
        end
    else
        if isShow then
            parent:setVisible(true)

            parent:setOpacity(0)
            parent:runAction(cc.FadeTo:create(0.4, maskLevel))

        else
            parent:setVisible(true)
            parent:setOpacity(maskLevel)
            parent:runAction(
                    cc.Sequence:create(
                            cc.FadeOut:create(0.4),
                            cc.Hide:create()
                    )
            )
        end
    end
end
function cls:playReelNotifyEffect(pCol, symbolID, cnt)
    self.reelNotifyEffectList = self.reelNotifyEffectList or {}
    local row = self.themeCtl:getEndRowByCol(pCol)
    local pos = self._mainViewCtl:getCellPos(pCol, row / 2 + 0.5)
    local data = {}
    local specialSymbol = self._mainViewCtl:getGameConfig().special_symbol
    data.parent = self.themeAnimateKuang

    if symbolID == specialSymbol.scatter then
        data.file = self._mainViewCtl:getSpineFile("jili_free")
        data.animateName = "animation"
        self._mainViewCtl:playMusicByName("reel_notify")
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
    local cell = self:getRetCell(col, row)
    local pos = self.themeCtl:getCellPos(col, row)
    --local specialSymbol = self.themeCtl:getGameConfig().special_symbol
    local animName
    if isLoop then
        animName = "animation2"
    else
        animName = "animation3"
    end

    local spineFile = self.themeCtl:getPic("spine/item/" .. item .. "/spine")
    local data = {}
    data.file = spineFile
    data.parent = self.scatterNode
    data.pos = pos
    data.animateName = animName
    data.isLoop = isLoop
    data.zOrder = col * 10 + row
    local _, s = bole.addAnimationSimple(data)
    cell:setVisible(false)
    return s
end

function cls:playDropSpine(cell, key, isOnlyLoop, col, row)
    local animateName
    local loopName
    if cell.symbolTipAnim2 then
        cell.symbolTipAnim = cell.symbolTipAnim2
        cell.symbolTipAnim2 = nil
    end
    local spineFile = self.themeCtl:getPic("spine/item/" .. key .. "/spine")
    local specialSymbol = self.themeCtl:getGameConfig().special_symbol
    if key == specialSymbol.scatter then
        animateName = "animation"
        loopName = "animation2"
    elseif key == specialSymbol.bonusSymbol then
        animateName = "animation1"
        loopName = "animation2"
    end

    local data = {}
    data.parent = cell

    data.isRetain = true

    data.file = spineFile
    data.zOrder = 22
    data.animateName = animateName
    if isOnlyLoop then
        data.animateName = loopName
        data.isLoop = true
    else
        self.themeCtl:playMusicByName("symbol_scatter")
    end
    if cell.symbolTipAnim then
        cell.symbolTipAnim:setLocalZOrder(22)
        cell.symbolTipAnim:setAnimation(0, animateName, false)
        cell.symbolTipAnim:addAnimation(0, loopName, true)
    else
        local _, s = bole.addAnimationSimple(data)
        if not isOnlyLoop then
            s:addAnimation(0, loopName, true)
        end
        cell.symbolTipAnim = s
        s.parent = 1
    end
    cell.sprite:setVisible(false)
end
function cls:changeSymbolAnimParent(cell, col, row)
    self.themeCtl:laterCallBack(5 / 30, function()
        if cell.symbolTipAnim and bole.isValidNode(cell.symbolTipAnim) then
            local symbolTipAnim = cell.symbolTipAnim
            local pos = self.themeCtl:getCellPos(col, row)
            bole.changeParent(symbolTipAnim, self.themeAnimateKuang, 2)
            symbolTipAnim.parent = 2
            symbolTipAnim:setPosition(pos)
        end
    end)
end


---------------------- jp wheel  end --------------------

function cls:changeRevealSymbol(col, row, symbolID)

    local cell = self:getRetCell(col, row)
    local pos = self.themeCtl:getCellPos(col, row)

    self:updateCellSprite(cell, symbolID % 100, col, true, true)
    local data = {}
    data.parent = self.animateNode
    data.file = self.themeCtl:getSpineFile("item_reveal")
    data.pos = pos
    data.animateName = "animation1"
    bole.addAnimationSimple(data)
end
---------------------- stick wild start --------------------

function cls:clearCurPageStickNode()
    self.stickNode:removeAllChildren()
    self.curStickNodeList = {}
end
function cls:checkIsCreateStickNode(col, row)
    if not self.curStickNodeList or not self.curStickNodeList[col] or not self.curStickNodeList[col][row] then
        return false
    end
    return true
end
function cls:createStickNode(col, row, isAni, isGold)
    self.curStickNodeList = self.curStickNodeList or {}
    self.curStickNodeList[col] = self.curStickNodeList[col] or {}
    if not self:checkIsCreateStickNode(col, row) then
        local data = {}
        data.file = self.themeCtl:getSpineFile("item_1")
        data.parent = self.stickNode
        data.pos = self.themeCtl:getCellPos(col, row)
        data.isRetain = true

        if isAni then
            if isGold then
                data.animateName = "animation5"
            else
                data.animateName = "animation4"
            end
        else
            if isGold then
                data.animateName = "animation7"
            else
                data.animateName = "animation9"
            end
        end
        local _, s = bole.addAnimationSimple(data)
        self.curStickNodeList[col][row] = s
    end
end
function cls:addStickyAni(col, row, realNode)

    local pos = self.themeCtl:getCellPos(col, row)
    local data1 = {}
    data1.parent = self.themeAnimateKuang
    data1.file = self.themeCtl:getPic("spine/item/1/spine")
    data1.pos = pos
    data1.animateName = "animation4"
    data1.zOrder = 101
    bole.addAnimationSimple(data1)
    realNode:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(30 / 30),
                    cc.Show:create()
            )
    )
end
function cls:dealStickyWild(stickWildList)
    if stickWildList and #stickWildList > 0 then
        local item = table.remove(stickWildList, 1)
        local col = item[1] + 1
        local row = item[2] + 1
        local data = {}
        data.file = self.themeCtl:getSpineFile("wild_stick_mask")
        data.parent = self.animateNode
        data.pos = self.themeCtl:getCellPos(col, row)
        bole.addAnimationSimple(data)
        self:canSkipLaterCallBack(18 / 30, function()
            self:createStickNode(col, row, true, true)
        end)

        self.themeCtl:playMusicByName("stickywild")
        if #stickWildList > 0 then
            self:canSkipLaterCallBack(30 / 30,
                    function()
                        self:dealStickyWild(stickWildList)
                    end)
        end
    end

end

-------- stick end
-------- random start
function cls:createRandom(randomList)

    if randomList and #randomList > 0 then
        local item = table.remove(randomList, 1)
        local col = item[1] + 1
        local row = item[2] + 1
        self:createStickNode(col, row, true)
        self.themeCtl:playMusicByName("randomwild")
        if #randomList > 0 then
            self:canSkipLaterCallBack(30 / 30,
                    function()
                        self:createRandom(randomList)
                    end)
        end
    end
end
-------- random end
-------- 3.multi start
---@param showType /1:show /2:mask_show/3:mask_hide/4:remove
function cls:playMapMultiByStep(showType, multi)

    if showType == 1 then
        self:addBigWildList()
    elseif showType == 2 then
        self:showBigWildMask()
        self.themeCtl:playMusicByName("doorclose")
    elseif showType == 3 then
        self:showBigWildMulit(multi)
        self.themeCtl:playMusicByName("dooropen")
    elseif showType == 4 then
        self:removeBigWildMask()
    end
end
function cls:removeBigWildMask()
    self.cellLabelList = nil
    self.boomNode:removeAllChildren()
    if self.cellMaskList and #self.cellMaskList > 0 then

        for row = 1, 8 do
            self.cellMaskList[row]:removeFromParent()
        end
    end
    self.cellMaskList = nil
end
function cls:showBigWildMask()

end
function cls:showBigWildMulit(multi)
    for row = 1, 8 do
        local labelNode = self.cellLabelList[row]
        local str = multi .. "X"
        labelNode:setString(str)
        self.cellMaskList[row]:setAnimation(0, "animation1", false)
    end
end
function cls:addBigWildList()
    self.cellLabelList = {}
    self.cellMaskList = {}
    for row = 1, 8 do
        local pos = self.themeCtl:getCellPos(3, row)
        local cell = self.spinLayer.spins[3]:getRetCell(row)
        self:updateCellSprite(cell, 1000 + 10, 3, true, true)
        local path = self.themeCtl:getFntFilePath("theme230_wild_num.fnt")
        local str = 10 .. "X"
        local labelNode = libUI.createFont(self.boomNode, path)
        labelNode:setString(str)
        labelNode:setPosition(cc.p(pos.x, pos.y - 20))
        self.cellLabelList[row] = labelNode

        local data = {}
        data.file = self.themeCtl:getSpineFile("super_reveal")
        data.parent = self.flyNode
        data.animateName = "animation1"
        data.isRetain = true
        data.zOrder = 10
        data.pos = pos
        local _, s = bole.addAnimationSimple(data)
        self.cellMaskList[row] = s
    end
end
function cls:playMultiWinLine(row)

    if not self.cellLabelList or not self.cellLabelList[row] then
        return
    end
    local fs = 60
    local cell = self.cellLabelList[row]
    local animate = cc.Sequence:create(
            cc.DelayTime:create(2 / fs),
            cc.ScaleTo:create(26 / fs, 1.085),
            cc.DelayTime:create(2 / fs),
            cc.ScaleTo:create(26 / fs, 1),
            cc.DelayTime:create(2 / fs))
    local actions = cc.Sequence:create(animate, animate:clone())
    cell:runAction(actions)
end
function cls:stopMultiWinLine()
    if not self.cellLabelList then
        return
    end
    for row = 1, 8 do
        if self.cellLabelList[row] then
            local cell = self.cellLabelList[row]
            cell:stopAllActions()
            cell:setScale(1)
            self.cellMaskList[row]:setAnimation(0, "animation2", false)
        end

    end
end

--------3.multi end

------- free moving start(moving)
function cls:dealFreeMoving(moving_pos, center_pos, isAni, isRecover)

    local movingList = {}

    if isAni and not isRecover then
        self:playMovingMask(center_pos)
    end
    local center_col = center_pos[1] + 1
    local center_row = center_pos[2] + 1
    for col = 1, 5 do
        for row = 1, self.themeCtl:getEndRowByCol(col) do
            if col ~= center_col or row ~= center_row then
                if self:checkIsCreateStickNode(col, row) then
                    local node = self.curStickNodeList[col][row]
                    table.insert(movingList, node)
                    self.curStickNodeList[col][row] = nil
                end
            end
        end
    end
    local count = 0
    if isRecover then

    else

    end

    for key = 1, #moving_pos do
        local item = moving_pos[key]
        local col = item[1] + 1
        local row = item[2] + 1
        local endPos = self.themeCtl:getCellPos(col, row)
        local node
        if (col ~= center_col or row ~= center_row) then
            if count < #movingList then
                count = count + 1

                node = movingList[count]
                self.curStickNodeList[col] = self.curStickNodeList[col] or {}
                self.curStickNodeList[col][row] = node
            else
                self:createStickNode(col, row, isAni)
            end
            if node then
                if isAni then
                    if isRecover then
                        local startpos = bole.getPos(node)
                        self:playFadeOutWild(startpos)
                        node:setOpacity(0)
                        node:setPosition(endPos)
                        node:runAction(cc.Sequence:create(
                                cc.DelayTime:create(10 / 30),
                                cc.CallFunc:create(function()
                                    node:setAnimation(0, "animation8_1", false)
                                    node:setOpacity(255)
                                end)

                        ))
                    else
                        node:runAction(cc.MoveTo:create(1, endPos))
                    end
                else
                    node:setPosition(endPos)
                end
            end
        end
    end

end
function cls:playFadeOutWild(pos)

    local data = {}
    data.file = self.themeCtl:getSpineFile("item_1")
    data.parent = self.stickNode
    data.pos = pos
    data.animateName = "animation8"
    bole.addAnimationSimple(data)
end
function cls:playMovingMask(center_pos)
    local data = {}
    data.file = self.themeCtl:getSpineFile("wild_move_mask")
    data.parent = self.flyNode
    data.pos = self.themeCtl:getCellPos(center_pos[1] + 1, center_pos[2] + 1)
    data.zOrder = 100
    data.isLoop = true
    local _, s = bole.addAnimationSimple(data)
    self.movingMaskSpine = s
    self.themeCtl:playMusicByName("groupwild")
end
function cls:stopMovingMask()

    if self.movingMaskSpine and bole.isValidNode(self.movingMaskSpine) then
        local node = self.movingMaskSpine
        node:runAction(cc.Sequence:create(
                cc.FadeOut:create(0.2),
                cc.RemoveSelf:create()
        ))
    end
    self.movingMaskSpine = nil
end
function cls:recoverFreeSticky(sticky_pos, isAni)
    for key = 1, #sticky_pos do
        local item = sticky_pos[key]
        local col = item[1] + 1
        local row = item[2] + 1
        self:createStickNode(col, row, isAni, true)
    end
end
function cls:recoverFreeMoving(moving_pos)
    for key = 1, #moving_pos do
        local item = moving_pos[key]
        local col = item[1] + 1
        local row = item[2] + 1
        self:createStickNode(col, row, false)
    end
    --else
end
function cls:recoverWildBoard(random_pos, isGold)
    for key = 1, #random_pos do
        local item = random_pos[key]
        local col = item[1] + 1
        local row = item[2] + 1
        local cell = self.spinLayer.spins[col]:getRetCell(row)
        local symbolID = 1
        if isGold then
            symbolID = 15
        end
        self:updateCellSprite(cell, symbolID, col, true, true)
    end
end
function cls:onExit()
    if self.addChestShaker then
        self.addChestShaker:stop()
    end
end
function cls:canSkipLaterCallBack(time, func)

    self.boomNode:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(time),
                    cc.CallFunc:create(func)
            )
    )

end
function cls:skipAllActions()
    self.boomNode:stopAllActions()
end

return cls










