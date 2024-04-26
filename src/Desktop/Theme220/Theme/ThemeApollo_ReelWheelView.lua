--- @program src
--- @description: theme220 reelgame
--- @author: rwb
--- @create: 2020/11/23 10:49
local reelItem = class("ThemeApollo_ReelWheelItem", function()
    return cc.Node:create()
end)
function reelItem:ctor(index, ctl, parentNode)
    self.index = index
    self.ctl = ctl

    local csbPath = self.ctl:getCsbPath("reel_item")
    self.node = cc.CSLoader:createNode(csbPath)
    parentNode:addChild(self)
    self:addChild(self.node)
    self.rootNode = self.node:getChildByName("root")
    self.spineNode = self.rootNode:getChildByName("spine_node")
    self.bgImg = self.rootNode:getChildByName("bg_img")
    self.imgJp = self.rootNode:getChildByName("img_jp")
    self.winLabel = self.rootNode:getChildByName("label")

    self.pressNode = self.rootNode:getChildByName("press_node")
    self.config = self.ctl:getJpWheelConfig()
    self.key = self.config.bonus_wheel[self.index]
    self:updateCellIndex()
end

function reelItem:updateCellIndex()
    if self.key < 100 then
        self.imgJp:setVisible(false)
        self.winLabel:setVisible(true)
        self:showLabel()
    else
        self.imgJp:setVisible(true)
        self.winLabel:setVisible(false)
        self:showJackpot()
    end
end
function reelItem:showJackpot()

    local jpIndex = (self.key + 1) % 10
    local bg_file_name = self.config.wheel_style[1].bg
    local img_file_name = self.config.wheel_style[1].img
    bg_file_name = string.format(bg_file_name, jpIndex)
    img_file_name = string.format(img_file_name, jpIndex)
    bole.updateSpriteWithFile(self.bgImg, bg_file_name)
    bole.updateSpriteWithFile(self.imgJp, img_file_name)
end
function reelItem:showLabel()
    local bet = self.ctl:getCurBet()
    local bg_file_name = self.config.wheel_style[2].bg
    bole.updateSpriteWithFile(self.bgImg, bg_file_name)
    local coins = bet * self.key
    local countStr = FONTS.formatByCount4(coins, 5, true, true)
    --local countStr = FONTS.formatByCount4(self.key, 5, true, true)
    self.winLabel:setString(countStr)
end
function reelItem:showWinAction(isAni)
    local parent = self.imgJp
    if self.key < 100 then
        parent = self.winLabel
    end
    if isAni then
        parent:runAction(cc.ScaleTo:create(0.4, 1.2))
    else
        parent:setScale(1.2)
    end
    self.node:setLocalZOrder(1)

    local data = {}
    data.file = self.ctl:getSpineFile("jp_wheel_win")
    data.parent = self.spineNode
    data.isLoop = true
    data.animateName = "animation" .. self:getAniIndex()
    bole.addAnimationSimple(data)

end
function reelItem:getAniIndex()
    if self.key < 100 then
        return 5
    end
    local jpIndex = (self.key + 1) % 10
    return jpIndex
end

local cls = class("ThemeApollo_ReelWheelView", CCSNode)
function cls:ctor(ctl, parentNode)
    self.ctl = ctl
    self.csb = self.ctl:getCsbPath("wheel_reels")
    self.config = self.ctl:getJpWheelConfig()
    self.wheelLen = self.config.count
    self.parentNode = parentNode
    self._height = self.config.height
    self._width = self.config.width
    CCSNode.ctor(self, self.csb)
end
function cls:loadControls(...)

    self.parentNode:addChild(self)
    self.rootNode = self.node:getChildByName("root")
    self.bgRoot = self.node:getChildByName("bg")
    self.wheelPanel = self.rootNode:getChildByName("wheel_panel")
    self.wheelItemParent = self.wheelPanel:getChildByName("wheel_node")
    self.wheelPressNode = self.rootNode:getChildByName("press_node")
    self.wheelItemParent:removeAllChildren()
    self.aniNode = self.rootNode:getChildByName("ani_node")
    self.spineNode = self.rootNode:getChildByName("spine_node")
    self:_setReelPanelSize()
    self:_createWheelReelItem()
    self:_addBgSpine()

end
function cls:_addBgSpine()
    local data = {}
    data.file = self.ctl:getSpineFile("jp_wheel_bg")
    data.parent = self.spineNode
    data.isLoop = true
    bole.addAnimationSimple(data)
end
function cls:_addFireSpine()
    local data = {}
    data.file = self.ctl:getSpineFile("jp_wheel_pointer")
    data.parent = self.aniNode
    data.isLoop = true
    data.pos = cc.p(-220, -70)
    local _, s = bole.addAnimationSimple(data)

    self.fireSpine1 = s
    local data2 = {}
    data2.file = self.ctl:getSpineFile("jp_wheel_pointer")
    data2.parent = self.aniNode
    data2.isLoop = true
    data2.pos = cc.p(220, -70)
    local _1, s2 = bole.addAnimationSimple(data2)
    self.fireSpine2 = s2
    s2:setScaleX(-1)
end
function cls:_removePointerFire(isAni)

    if self.fireSpine2 and bole.isValidNode(self.fireSpine2) then
        if isAni then

            local node = self.fireSpine2
            node:runAction(
                    cc.Sequence:create(
                            cc.FadeOut:create(0.5),
                            cc.RemoveSelf:create()
                    )
            )
        else
            self.fireSpine2:removeFromParent()

        end
        self.fireSpine2 = nil
    end
    if self.fireSpine1 and bole.isValidNode(self.fireSpine1) then
        if isAni then
            local node = self.fireSpine1
            node:runAction(
                    cc.Sequence:create(
                            cc.FadeOut:create(0.5),
                            cc.RemoveSelf:create()
                    )
            )
        else
            self.fireSpine1:removeFromParent()
        end
        self.fireSpine1 = nil
    end
end
function cls:_addWinAni()
    local data = {}
    data.file = self.ctl:getSpineFile("jp_wheel_stop_win")
    data.parent = self.aniNode
    data.isLoop = true
    data.pos = cc.p(0, -70)
    local _, s = bole.addAnimationSimple(data)
    local index = self.ctl:getWheelIndex()
    local winCell = self:getCellByIndex(index)
    if winCell then
        winCell:showWinAction(true)
    end
    self.ctl:addBaseJpWinAni()
end
function cls:getCellByIndex(index)
    for k, v in pairs(self.wheelNodeAllItem) do
        if v[2].index == index then
            return v[2]
        end
    end
    return nil
end

function cls:_setReelPanelSize()
    local height = (10 - 2) * self._height
    self.wheelPanel:setContentSize(cc.size(self._width, height))
    self.wheelItemParent:setPosition(cc.p(self._width / 2, height))
end

function cls:_createWheelReelItem(...)
    self.wheelNodeAllItem = {}
    for key = 1, self.config.count do
        local item = reelItem.new(key, self.ctl, self.wheelItemParent)
        self.wheelNodeAllItem[key] = { key, item }
    end
    self:_createMiniReel()

end
function cls:_createMiniReel(...)
    local data = table.copy(self.config.speed_config)
    local callFunc = function(...)

        self.ctl:setRollFinish()
        self.ctl:saveBonus()
        self.ctl:laterCallBack(22 / 60, function(...)
            self:rollEndCallFunc()
        end)
    end
    self.miniReel = BaseReel.new(self, self.wheelNodeAllItem, data, callFunc)
end
function cls:rollEndCallFunc(...)
    self:_addWinAni()
    self.ctl:playMusicByName("jp_wheel_win")
    self.node:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(2),
                    cc.CallFunc:create(
                            function()
                                self.ctl:showReelWheelCollect()
                            end
                    )
            )
    )

end
function cls:_miniReelStartSpin(...)
    local addEndPos = self._height
    local reelResult = self.ctl:getWheelIndex()

    local data = { ["key"] = reelResult, ["addEndPos"] = addEndPos }
    local a1 = cc.DelayTime:create(23 / 30)
    local a2 = cc.CallFunc:create(function(...)
        self.miniReel:resetCurData(data)
        self.ctl:playMusicByName("jp_wheel_spin")
        self.miniReel:startSpin()
        self:_addFireSpine()
    end)
    local a4 = cc.DelayTime:create(5.5)
    local a5 = cc.CallFunc:create(function()
        self:_removePointerFire(true)
    end)
    local a3 = cc.Sequence:create(a1, a2, a4, a5)
    libUI.runAction(self.ctl.node, a3)
end
function cls:getFirstIndex(endIndex)

    local firstIndex = (endIndex - 5 + self.wheelLen) % self.wheelLen + 1
    return firstIndex

end
---@desc show finial ui
function cls:setFinishUI()
    local endIndex = self.ctl:getWheelIndex()
    local firstIndex = self:getFirstIndex(endIndex)
    self:setWheelCellResult(firstIndex)
end
function cls:setWheelCellResult(firstIndex)
    local items = {}
    for i = 1, #self.miniReel.Icons do
        local realIndex = (self.miniReel.Icons[i][1] - firstIndex) % self.miniReel.IconCount + 1
        local posY = (realIndex) * (-self.miniReel._cellSize.y)
        items[realIndex] = self.miniReel.Icons[i]
        items[realIndex][2]:setPositionY(posY)
    end
    self.miniReel.Icons = items
end
---@desc begin to roll
function cls:setStartRoll()
    self:_miniReelStartSpin()
end
function cls:onExit()
    if self.miniReel.scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.miniReel.scheduler)
        self.miniReel.scheduler = nil
    end

end
return cls




