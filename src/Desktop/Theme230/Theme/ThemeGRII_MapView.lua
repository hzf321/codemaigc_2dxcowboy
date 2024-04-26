--- @program src
--- @description: theme220 map game
--- @author: rwb
--- @create: 2020/11/23 16:01
local mapHidePos = cc.p(0, 1900)
local mapItem = class("ThemeGRII_MapItem")
function mapItem:ctor(ctl, selfnode, index, data)
    self.ctl = ctl
    self.node = selfnode
    self.index = index
    self.data = data
    self.map_type = self.data.map_type
    self.isBig = data.isBig
    if self.isBig then
        self:initBigNode()
    else
        self:initSmallNode()
    end
end

---@desc 点的位置+ user sp的位置
function mapItem:getTopPosition()
    local basePos = cc.p(self.node:getPosition())
    if self.isBig then
        local offset_pos = self.ctl:getMapConfig().pos_list[self.map_type]

        basePos = cc.pAdd(basePos, offset_pos)
    else
        basePos = cc.pAdd(basePos, cc.p(10, 0))
    end
    return basePos
end
function mapItem:updateNodeStatus(isOpen, isAni)
    if self.data.isOpen == isOpen then
        return
    end
    self.data.isOpen = isOpen
    if self.isBig then
        self:updateBigNode(isAni)
    else
        self:updateSmallNode(isAni)
    end
end
---@param isOpen: open
function mapItem:updateOpenStatus(isOpen, isAni)
    if self.data.isOpen == isOpen then
        return
    end
    local isGray = true
    if isOpen and isAni then
        isGray = false
    end
    if not isOpen then
        isGray = false
    end
    self.data.isOpen = isGray
    if self.isBig then
        self:updateBigNode(isAni)
    else
        self:updateSmallNode(isAni)
    end
end
function mapItem:setToGray()
    self:updateNodeStatus(true, false)
end
-------------------- big item start----------------------------
function mapItem:initBigNode()
    self.aniNode = self.node:getChildByName("ani_node")
    self.textBoard = self.node:getChildByName("text")
    local data = {}
    data.file = self.ctl:getSpineFile("map_big_item")
    data.parent = self.aniNode

    data.isRetain = true
    local triggerAni = "animation" .. self.map_type .. "_1"
    local loopAni = "animation" .. self.map_type .. "_2"
    local grayAni = "animation" .. self.map_type .. "_3"
    if self.data.isOpen then
        data.animateName = grayAni
        data.isLoop = false
        self.textBoard:setColor(cc.c3b(150, 150, 150))
    else
        data.animateName = loopAni
        data.isLoop = true
        self.textBoard:setColor(cc.c3b(255, 255, 255))
    end
    local _, s = bole.addAnimationSimple(data)
    self.buildNode = s
    s:setMix(loopAni, triggerAni, 0.2)
end
function mapItem:openBigItemAni()

    local triggerAni = "animation" .. self.map_type .. "_1"
    local loopAni = "animation" .. self.map_type .. "_2"

    self.buildNode:setAnimation(0, triggerAni, false)
    self.buildNode:addAnimation(0, loopAni, true)
end
function mapItem:updateBigNode(isAni)

    if isAni then
        self:openBigItemAni()
    else
        local loopAni = "animation" .. self.map_type .. "_2"
        local grayAni = "animation" .. self.map_type .. "_3"
        if self.data.isOpen then
            self.buildNode:setAnimation(0, grayAni, false)
            self.textBoard:setColor(cc.c3b(150, 150, 150))
        else
            self.buildNode:setAnimation(0, loopAni, true)
            self.textBoard:setColor(cc.c3b(255, 255, 255))
        end
    end
end
-------------------- big item end----------------------------
-------------------- small item start----------------------------
function mapItem:initSmallNode()
    self.fireBg = self.node:getChildByName("dim")
    self.aniNode = self.node:getChildByName("ani_node")
    self:updateSmallNode()
end
function mapItem:updateSmallNode(isAni)

    local config = self.ctl:getMapConfig()
    local map_type_list = config.map_type_list
    local fire = map_type_list[2]
    if self.data.isOpen and not isAni then
        fire = map_type_list[1]
    end
    if isAni then
        self:openSmallItemAni()
    end
    bole.updateSpriteWithFile(self.fireBg, fire)
end

function mapItem:openSmallItemAni()
    local data = {}
    data.file = self.ctl:getSpineFile("map_small_item")
    data.parent = self.aniNode
    bole.addAnimationSimple(data)
end

-------------------- small item end----------------------------
local cls = class("ThemeGRII_MapView", CCSNode)

function cls:ctor(ctl, mapParent)
    self.ctl = ctl
    self.parentNode = mapParent

    self.csb = self.ctl:getCsbPath("map")
    CCSNode.ctor(self, self.csb)
end
function cls:loadControls()

    self.parentNode:addChild(self, 10)
    self.dimmer = self.node:getChildByName("dimmer_node")
    self.mapRoot = self.node:getChildByName("root")
    bole.setEnableRecursiveCascading(self.dimmer, true)
    self.mapContainerNode = self.mapRoot:getChildByName("bg_panel")
    self.mapContainerNode:setLocalZOrder(1)
    self.mapChild = self.mapContainerNode:getChildByName("map_node")
    local size = self.mapContainerNode:getContentSize()
    local tempNumber
    if bole.getAdaptScale(true) < 1 then
        tempNumber = 1280 * (FRAME_WIDTH / DESIGN_WIDTH - 1) + 80
    elseif bole.isIphoneX() then
        tempNumber = 180
    else
        tempNumber = 80
    end
    local size2 = cc.size(size.width, FRAME_WIDTH - tempNumber)
    self.mapContainerNode:setContentSize(size2)

    self.bgNode = self.mapChild:getChildByName("map_bg")
    self.stepNode = self.mapChild:getChildByName("step_node")
    self.bigStep = self.stepNode:getChildByName("big_step")
    self.animNode = self.mapChild:getChildByName("anim_node")
    self.mapHeadNode = self.mapChild:getChildByName("user_sp")

    self.btnNode = self.mapRoot:getChildByName("btn_node")
    self.btnNode:setLocalZOrder(3)
    self.btnClose = self.btnNode:getChildByName("btn")
    bole.adaptReelBoard(self.mapRoot)
    self.zeroPos = cc.p(self.mapRoot:getPosition())
    self:_initCloseBtnEvent()
    self:_initMapItemNode()
    self:_addHeadNode()
    self:addBackSpine()
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
    data.animateName = "animation2"
    data.isRetain = true
    data.isLoop = true
    local _, s = bole.addAnimationSimple(data)
    self.userIcon = s
end

function cls:_initMapItemNode()
    self.stepList = {}
    local maxMapLevel = self.ctl.mapConfig.max_level
    local mapLevel = self.ctl:getMapLevel()
    for i = 1, maxMapLevel do
        self.stepList[i] = {}
        local map_type = self.ctl.mapConfig.all_node_type[i]
        if self.ctl:checkIsBigNode(i) then
            local node = self.bigStep:getChildByName("step_" .. i .. "_big")
            local data = { isOpen = mapLevel > i, isBig = true, map_type = map_type }
            self.stepList[i] = mapItem.new(self.ctl, node, i, data)
        else
            local parentName
            if i <= 10 then
                parentName = "step1_10"
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

                parentName = "step" .. mini .. "_" .. max
            end
            local node = self.stepNode:getChildByName(parentName)
            local cellNode = node:getChildByName("step_" .. i)
            local data = { isOpen = mapLevel > i, isBig = false }

            self.stepList[i] = mapItem.new(self.ctl, cellNode, i, data)
        end
    end
end
function cls:updateItemNode(byScatter, isAni)
    local maxMapLevel = self.ctl.mapConfig.max_level
    local mapLevel = self.ctl:getMapLevel()
    for i = 1, maxMapLevel do
        local mapItem = self.stepList[i]
        local isOpen = i < mapLevel
        mapItem:updateNodeStatus(isOpen, false)
    end
end
function cls:resetToOpened(mapLevel)
    if mapLevel <= 0 then
        return
    end
    local mapItem = self.stepList[mapLevel]
    mapItem:updateOpenStatus(true, false)
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
    offset = containY / 2 - self.stepList[step_index].node:getPositionY()
    if offset > 0 then
        offset = 0
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
    local pos = userStartPos
    if index > 0 and self.stepList[index] then
        pos = self.stepList[index]:getTopPosition()
    end
    return pos
end
function cls:setUserIconPosition(index, isAni)

    local pos = self:getUserPosByLevel(index)
    self.mapHeadNode:setPosition(pos)
    local dir = self:getDirByLevel(index, isAni)

    if dir == 1 then
        self.mapHeadNode:setScaleX(1)
    else
        self.mapHeadNode:setScaleX(-1)
    end
end
function cls:getDirByLevel(index, isAni)
    local dir_list = self.ctl:getMapConfig().dir_list
    local dir
    if index == 0 then
        return 1
    end
    if isAni then
        if index == self.ctl:getMapConfig().max_level then
            dir = dir_list[index]
        else
            dir = dir_list[index + 1]
        end
    else
        dir = dir_list[index]
    end
    return dir
end
function cls:showUserIconForwardAni(next_index)
    local nextPos = self:getUserPosByLevel(next_index)
    local animName = "animation1"
    bole.spChangeAnimation(self.userIcon, animName, false)
    if self.ctl:checkIsBigNode(next_index) then
        self.userIcon:addAnimation(0, "animation3", true)
    end
    self.userIcon:addAnimation(0, "animation2", true)
    self.mapHeadNode:runAction(
            cc.Sequence:create(
                    cc.MoveTo:create(25 / 30, nextPos)
            )
    )
    self.ctl:playMusicByName("pass1")
    self:setPreLevelToGray(next_index - 1)

end
function cls:setPreLevelToGray(level)
    if level == 0 then
        return
    end
    local mapItem = self.stepList[level]
    mapItem:setToGray()

end
function cls:mapItemLighten(level)
    local mapItem = self.stepList[level]
    --if mapItem.isBig then
    self.ctl:playMusicByName("pass2")
    --else
    --    self.ctl:playMusicByName("wheel_trigger")
    --end
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
        self.mapContainerNode:setTouchEnabled(false)
        self:hideCloseBtn()
    else
        self.mapContainerNode:setTouchEnabled(true)
        self:showCloseBtn(true, 0.5)
    end
    if byScatter and isAni then
        self:setMapPosition(self.ctl:getMapLevel() - 1)
        self:setUserIconPosition(self.ctl:getMapLevel() - 1, isAni)
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
                                --self.ctl:playMusicByName("map_voice")
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
                                --self.nodeTopEventListener:setSwallowTouches(false)
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



