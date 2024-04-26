--- @program src
--- @description: theme220 map game
--- @author: rwb
--- @create: 2020/11/23 16:01

--local mapShowPos = cc.p(0, -480)
local mapHidePos = cc.p(0, 1900)
local dialogLine = require (bole.getDesktopFilePath("Theme/ThemeApollo_MapDialogLine")) 
 
local mapItem = class("ThemeApollo_MapItem")
function mapItem:ctor(ctl, selfnode, index, data)
    self.ctl = ctl
    self.node = selfnode
    self.index = index
    self.data = data
    self.isBig = data.isBig
    self.rootNode = self.node:getChildByName("root")
    self.levelNode = self.rootNode:getChildByName("level")
    self.levelLabel = self.levelNode:getChildByName("fnt")
    self.levelLabel:setString("" .. index)
    if self.isBig then
        self:initBigNode(self.data.extraFg)
    else
        self:initSmallNode()
    end
end

---@desc 点的位置+ user sp的位置
function mapItem:getTopPosition()
    local basePos = cc.p(self.node:getPosition())
    if self.isBig then
        local baseY = 255
        if self.baseScale then
            baseY = 255 * self.baseScale
        end
        basePos = cc.pAdd(basePos, cc.p(0, baseY))
    else
        basePos = cc.pAdd(basePos, cc.p(0, 120))
    end
    return basePos
end
function mapItem:updateNodeStatus(isOpen, addFg, isAni)
    if self.data.isOpen == isOpen then
        return
    end
    self.data.isOpen = isOpen
    if self.isBig then
        self:updateBigNode(addFg, isAni)
    else
        self:updateSmallNode(isAni)
    end
end
function mapItem:updateOpenStatus(isOpen, isAni)
    if self.data.isOpen == isOpen then
        return
    end
    self.data.isOpen = isOpen
    if self.isBig then
        self:setBigItemOpenAni(isAni)
    else
        self:setSmallItemOpenAni(isAni)
    end
end
-------------------- big item start----------------------------
function mapItem:initBigNode(addFg)
    self.bigFreeSpinHead = self.rootNode:getChildByName("head")
    self.bigFreeSpin = self.bigFreeSpinHead:getChildByName("cnt")
    self.bigLineNode = self.rootNode:getChildByName("line_node"):getChildByName("root")
    self.aniNode = self.rootNode:getChildByName("ani_node")
    self.baseFgCnt = 5
    --local
    local config = self.ctl:getGameConfig().map_config
    local big_node_config = config.big_node_config[self.index]
    local scale = big_node_config.scale or 1
    self.node:setScale(scale)
    self.baseScale = scale
    dialogLine.new(self.ctl, self.bigLineNode, self.index, 0)
    self:updateBigNode(addFg)
end
function mapItem:openBigItemAni(isAni)

    if not self.fireSpine or not bole.isValidNode(self.fireSpine) then
        self:addBigFire(isAni)
    end
end
function mapItem:updateBigNode(addFg, isAni)
    local free_cnt_img = "#theme220_map_level_%s.png"
    addFg = addFg or 0
    local free_cnt = self.baseFgCnt + addFg
    free_cnt_img = string.format(free_cnt_img, free_cnt)
    bole.updateSpriteWithFile(self.bigFreeSpin, free_cnt_img)
    if isAni then
        local data = {}
        data.parent = self.bigFreeSpinHead
        data.file = self.ctl:getSpineFile("map_num_change")
        bole.addAnimationSimple(data)
    end
    self:setBigItemOpenAni(isAni)
end
function mapItem:setBigItemOpenAni(isAni)
    if self.data.isOpen then
        self:openBigItemAni(isAni)
    else
        self.aniNode:removeAllChildren()
        self.fireSpine = nil
    end
end
function mapItem:addBigFire(isAni)
    local data = {}
    data.file = self.ctl:getSpineFile("map_small_light")
    data.parent = self.aniNode
    data.isLoop = true
    data.animateName = "animation2"
    data.pos = cc.p(-104, 40)
    if isAni then
        data.isLoop = false
        data.animateName = "animation1"
        data.isRetain = true
    end
    local _, s = bole.addAnimationSimple(data)
    self.fireSpine = s
    s:addAnimation(0, "animation2", true)
    s:setScale(0.5)
    local data2 = {}
    data2.file = self.ctl:getSpineFile("map_small_light")
    data2.parent = self.aniNode
    data2.isLoop = true
    data2.animateName = "animation2"
    data2.pos = cc.p(104, 40)
    if isAni then
        data2.isLoop = false
        data2.animateName = "animation1"
        data2.isRetain = true
    end
    local _, s2 = bole.addAnimationSimple(data2)
    self.fireSpine2 = s2
    s2:addAnimation(0, "animation2", true)
    s2:setScale(0.5)
end
-------------------- big item end----------------------------
-------------------- small item start----------------------------
function mapItem:initSmallNode()
    self.fireBg = self.rootNode:getChildByName("bg")
    self.aniNode = self.rootNode:getChildByName("ani_node")
    self:updateSmallNode()
end
function mapItem:updateSmallNode(isAni)
    local config = self.ctl:getMapConfig()
    local lineType = config.all_node_type[self.index]
    local map_type_list = config.map_type_list[lineType]
    --if lineType == 1 then
    local fire = map_type_list[1][1]
    self:setSmallItemOpenAni(isAni)
    bole.updateSpriteWithFile(self.fireBg, fire)
end
function mapItem:setSmallItemOpenAni(isAni)
    if self.data.isOpen then
        if not self.fireSpine or not bole.isValidNode(self.fireSpine) then
            self:addSmallFire(isAni)
        end
    else
        self.aniNode:removeAllChildren()
        self.fireSpine = nil
    end
end
function mapItem:addSmallFire(isAni)
    local data = {}
    data.file = self.ctl:getSpineFile("map_small_light")
    data.parent = self.aniNode
    data.isLoop = true
    data.animateName = "animation2"
    data.pos = cc.p(0, 40)
    if isAni then
        data.isLoop = false
        data.animateName = "animation1"
        data.isRetain = true
    end
    local _, s = bole.addAnimationSimple(data)
    self.fireSpine = s
    s:addAnimation(0, "animation2", true)
end


-------------------- small item end----------------------------

--function mapItem:mapItemAddExtraFg(addFg)
--    local newExtra = self.baseFgCnt + addFg

--end

local cls = class("ThemeApollo_MapView", CCSNode)

function cls:ctor(ctl, mapParent)
    self.ctl = ctl
    self.parentNode = mapParent

    self.csb = self.ctl:getCsbPath("map")
    CCSNode.ctor(self, self.csb)
end
function cls:loadControls()

    self.parentNode:addChild(self)
    self.mapRoot = self.node:getChildByName("root")
    self.dimmer = self.node:getChildByName("dimmer_node")
    bole.setEnableRecursiveCascading(dimmer, true)
    self.mapContainerNode = self.mapRoot:getChildByName("bg_panel")
    self.mapContainerNode:setLocalZOrder(1)
    local size = self.mapContainerNode:getContentSize()
    local tempNumber
    if bole.getAdaptScale(true) < 1 then
        tempNumber = 1280 * (FRAME_WIDTH / DESIGN_WIDTH - 1) + 100
    else
        tempNumber = 100
    end
    local size2 = cc.size(size.width, FRAME_WIDTH - tempNumber)
    self.mapContainerNode:setContentSize(size2)

    self.baseNode = self.mapContainerNode:getChildByName("base_node")
    self.bgNode = self.baseNode:getChildByName("bg_node")
    self.stepNode = self.baseNode:getChildByName("step_node")
    self.animNode = self.baseNode:getChildByName("anim_node")
    self.mapHeadNode = self.stepNode:getChildByName("user_sp")

    self.btnNode = self.mapRoot:getChildByName("btn_root")
    self.btnNode:setLocalZOrder(3)
    self.btnClose = self.btnNode:getChildByName("btn")
    --local moveY = bole.getAdaptReelBoardY()
    bole.adaptReelBoard(self.mapRoot)
    self.zeroPos = cc.p(self.mapRoot:getPosition())
    --self.mapRoot:setPositionY(self.mapRoot:getPositionY()  )
    self:_initCloseBtnEvent()
    self:_init100Node()
    self:_addHeadNode()
    self:addBackSpine()
    self:_initMapNodeTouch()

end
function cls:_initMapNodeTouch()
    local node = cc.Node:create()
    self.mapRoot:addChild(node, 2)
    local function onTouchBegan(touch, event)
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    -- listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_MOVED )
    -- listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_ENDED )
    -- listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_CANCELLED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)
    self.nodeTopEventListener = listener
end

function cls:addBackSpine()
    local data = {}
    data.parent = self.btnNode
    data.file = self.ctl:getSpineFile("map_back_btn")
    data.isLoop = true
    bole.addAnimationSimple(data)
end
function cls:_addHeadNode()
    local data = {}
    data.parent = self.mapHeadNode
    data.file = self.ctl:getSpineFile("map_head")
    data.animateName = "animation1"
    data.isRetain = true
    local _, s = bole.addAnimationSimple(data)
    self.userIcon = s
end

function cls:_init100Node()
    self.stepList = {}
    local maxMapLevel = self.ctl.mapConfig.max_level
    local buildingLevel = self.ctl.mapConfig.build_level
    local extra_Fg = self.ctl:getMapInfo().extra_fg
    local mapLevel = self.ctl:getMapLevel()
    for i = 1, maxMapLevel do
        self.stepList[i] = {}
        if buildingLevel[i] then
            local node = self.stepNode:getChildByName("step" .. i .. "_big")
            local extraFg = 0
            if i >= mapLevel then
                extraFg = extra_Fg
                extra_Fg = 0
            end
            local data = { isOpen = mapLevel >= i, isBig = true, extraFg = extraFg }
            self.stepList[i] = mapItem.new(self.ctl, node, i, data)
        else
            local parentName
            if i <= 10 then
                parentName = "item01_10"
            else
                local mini
                local max
                if i % 10 == 0 then
                    mini = i - 9
                    max = i
                else
                    mini = i - i % 10 + 1
                    max = i - i % 10 + 10
                end

                parentName = "item" .. mini .. "_" .. max
            end
            local node = self.stepNode:getChildByName(parentName)
            local cellNode = node:getChildByName("step" .. i)
            local data = { isOpen = mapLevel >= i, isBig = false, addExtra = 0 }

            self.stepList[i] = mapItem.new(self.ctl, cellNode, i, data)
        end
    end
end
function cls:update100Node(byScatter, isAni, totalFG)
    local maxMapLevel = self.ctl.mapConfig.max_level
    local mapLevel = self.ctl:getMapLevel()
    if byScatter and isAni then
        mapLevel = mapLevel - 1
    end
    local extra_Fg = self.ctl:getAddExtraFg(byScatter, isAni)
    if byScatter and byScatter == 2 then
        extra_Fg = totalFG - 5
    end
    for i = 1, maxMapLevel do
        local mapItem = self.stepList[i]
        local isOpen = mapLevel >= i
        local addFg = 0
        if i > mapLevel and mapItem.isBig and extra_Fg > 0 then
            addFg = extra_Fg
            extra_Fg = 0
        end
        mapItem:updateNodeStatus(isOpen, addFg, false)
    end
end
function cls:resetToUnopen(mapLevel)
    local mapItem = self.stepList[mapLevel]
    --local addFg
    if mapItem.isBig then
        mapItem:updateOpenStatus(false, false)
    else
        mapItem:updateOpenStatus(false, false)
    end
end
function cls:setMapPosBeforeAddFg()
    local buildingLevel = self.ctl.mapConfig.build_level
    local step_index = self.ctl:getMapLevel()
    while true do
        step_index = step_index + 1
        if step_index >= 100 then
            step_index = 100
        end
        if buildingLevel[step_index] then
            break
        end
    end
    step_index = step_index > 0 and step_index or 1
    local posy = self:getContainerPosY(step_index)
    local container_node = self.mapContainerNode:getInnerContainer()
    local posx = container_node:getPositionX()
    container_node:runAction(cc.MoveTo:create(0.3, cc.p(posx, posy)))
end
function cls:getContainerPosY(step_index)
    local step_index = step_index or 1
    local offset = 0
    if not self.stepList[step_index] or not bole.isValidNode(self.stepList[step_index].node) then
        return
    end
    local containY = self.mapContainerNode:getContentSize().height
    local innerContainY = self.mapContainerNode:getInnerContainerSize().height

    local sizeY = containY - innerContainY
    offset = containY / 2 - self.stepList[step_index].node:getPositionY() - 1000
    if offset > -20 then
        offset = -20
    elseif offset < sizeY then
        offset = sizeY
    end
    return offset
end
function cls:setMapPosition(step_index)
    step_index = step_index or 0
    step_index = step_index > 0 and step_index or 1
    local posy = self:getContainerPosY(step_index)
    local container_node = self.mapContainerNode:getInnerContainer()
    local posx = container_node:getPositionX()
    container_node:setPosition(cc.p(posx, posy))
end
function cls:showMapForwardPosition(next_index)
    if next_index == 0 or next_index - 1 == 0 then
        return
    end
    local mapIndex = next_index - 1
    local container_node = self.mapContainerNode:getInnerContainer()
    self:setMapPosition(next_index - 1)
    local posY = self:getContainerPosY(next_index)
    local posX = container_node:getPositionX()

    container_node:runAction(cc.MoveTo:create(0.2, cc.p(posX, posY)))
end
function cls:getUserPosByLevel(index)

    local userStartPos = self.ctl.mapConfig.user_start_pos
    --local maxMapLevel = self.ctl.mapConfig.max_level

    local pos = userStartPos
    if index > 0 and self.stepList[index] then
        pos = self.stepList[index]:getTopPosition()
    end
    return pos
end
function cls:setUserIconPosition(index)

    local pos = self:getUserPosByLevel(index)
    self.mapHeadNode:setPosition(pos)
end
function cls:showUserIconForwardAni(next_index)

    --local currentPos = cc.p(self.mapHeadNode:getPosition())
    local nextPos = self:getUserPosByLevel(next_index)
    local animName = "animation2"
    bole.spChangeAnimation(self.userIcon, animName)
    self.userIcon:addAnimation(0, "animation1", false)
    self.mapHeadNode:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(10 / 30),
                    cc.MoveTo:create(10 / 30, nextPos)
            )
    )
    self.ctl:playMusicByName("ui_move")
end
function cls:mapItemAddExtraFg(level, extra_fg, isAni)
    local maxMapLevel = self.ctl.mapConfig.max_level

    for key = level, maxMapLevel do
        local mapItem = self.stepList[key]
        if mapItem.isBig then
            mapItem:updateBigNode(extra_fg, isAni)
            break
        end
    end
end
function cls:mapItemLighten(level)
    local mapItem = self.stepList[level]
    if mapItem.isBig then
        self.ctl:playMusicByName("mapfg_trigger")
    else
        self.ctl:playMusicByName("wheel_trigger")
    end
    mapItem:updateOpenStatus(true, true)
end
function cls:_initCloseBtnEvent()
    local function onTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            obj:setTouchEnabled(false)

            self.ctl:playMusicByName("common_click")
            self:exitMapScene()
        end
    end
    -- 设置按钮
    self.btnClose:addTouchEventListener(onTouch)
end
function cls:showCloseBtn(isAni, delayTm)
    if isAni then
        delayTm = delayTm or 0.5
        self.btnNode:setVisible(true)
        self.btnNode:setScale(0)
        self.btnClose:setBright(true)
        self.btnNode:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(delayTm),
                        cc.ScaleTo:create(0.2, 1.1),
                        cc.ScaleTo:create(0.2, 0.95),
                        cc.ScaleTo:create(0.2, 1),
                        cc.CallFunc:create(function()
                            self.btnClose:setTouchEnabled(true)

                        end)
                )
        )
    else
        self.btnNode:setVisible(true)
        self.btnNode:setScale(1)
    end

end
function cls:hideCloseBtn(isAni)
    if isAni then
        self.btnNode:setVisible(true)
        self.btnNode:setScale(1)
        self.btnNode:runAction(
                cc.Sequence:create(
                        cc.ScaleTo:create(0.2, 1.1),
                        cc.ScaleTo:create(0.3, 0),
                        cc.CallFunc:create(function()
                            self.btnClose:setTouchEnabled(false)
                        end),
                        cc.Hide:create()
                )
        )
    else
        self.btnNode:setVisible(false)
    end
end
function cls:showMapScene(byScatter, isAni)
    self.nodeEventListener:setSwallowTouches(true)
    self:setVisible(true)
    self:dimmerIn(0.3)
    self.ctl:playMusicByName("map_open")
    if byScatter then
        self.nodeTopEventListener:setSwallowTouches(true)
        self:hideCloseBtn()
    else
        self.nodeTopEventListener:setSwallowTouches(false)
        self:showCloseBtn(true, 0.5)
    end
    if byScatter and isAni then
        self:setMapPosition(self.ctl:getMapLevel() - 1)
        self:setUserIconPosition(self.ctl:getMapLevel() - 1)
    else
        self:showIdleAnimation()
        self:setMapPosition(self.ctl:getMapLevel())
        self:setUserIconPosition(self.ctl:getMapLevel())
    end
    if isAni then
        self.mapRoot:setPosition(mapHidePos)
        self.mapRoot:runAction(
                cc.Sequence:create(
                        cc.MoveTo:create(0.3, self.zeroPos),
                        cc.CallFunc:create(function()
                            if byScatter then
                                self.ctl:playMusicByName("map_voice")
                            end
                        end)
                )
        )
    else
        self.mapRoot:setPosition(self.zeroPos)
    end


end
function cls:showIdleAnimation()

end
function cls:exitMapScene(byBonus, isAni)
    if not byBonus then
        self:hideCloseBtn(true)
    end
    if not byBonus then
        self.mapContainerNode:stopAutoScroll()
    end
    self.ctl:playMusicByName("map_close")
    local duration1 = 0.15
    local duration2 = 0.35
    self:hideCloseBtn(not byBonus)
    self.node:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(0.3),
                    cc.CallFunc:create(function()
                        self.mapRoot:runAction(cc.MoveTo:create(duration2, mapHidePos))
                        self:dimmerOut(duration1)
                    end),
                    cc.DelayTime:create(duration2),
                    cc.CallFunc:create(
                            function(...)
                                self.nodeEventListener:setSwallowTouches(false)
                                self.nodeTopEventListener:setSwallowTouches(false)
                                self.ctl:exitMapSceneFinish(byBonus)
                                self:setVisible(false)
                            end)
            )
    )
end
function cls:dimmerOut(spentTm)
    self.dimmer:setOpacity(255)
    self.dimmer:setVisible(true)
    self.dimmer:runAction(cc.FadeOut:create(spentTm))

end
function cls:dimmerIn(spentTm)
    self.dimmer:setOpacity(0)
    self.dimmer:setVisible(true)
    self.dimmer:runAction(cc.FadeIn:create(spentTm))

end
return cls



