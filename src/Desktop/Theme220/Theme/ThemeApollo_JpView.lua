---@program src
---@description:  theme220
---@author: rwb
---@create: : 2020-11-23 10:15:16
local jackpotTipItem = class("ThemeApollo_JackpotTipItem", function()
    return cc.Node:create()
end)

function jackpotTipItem:ctor(jpCtl, index, parent)
    self.parent = parent
    self.jpCtl = jpCtl
    self.index = index
    self.csb = self.jpCtl:getCsbPath("jp_tip")
    self.node = cc.CSLoader:createNode(self.csb)
    self:addChild(self.node)
    self:loadControls()

end
function jackpotTipItem:loadControls()

    local jackpot_config = self.jpCtl:getJackpotConfig()
    local light_img = jackpot_config.light_jp_img
    local str = string.format(light_img, self.index)
    local base_pos = jackpot_config.jp_tip_pos[self.index]
    local lock_scale = jackpot_config.lock_tip_scale[self.index]
    local unlock_scale = jackpot_config.unlock_tip_scale[self.index]

    self.rootNode = self.node:getChildByName("root")
    self.unlockNode = self.rootNode:getChildByName("unlock")
    self.unlockNode:setVisible(false)

    self.lockNode = self.rootNode:getChildByName("lock")
    self.lockNode:setVisible(false)

    local jackpot1 = self.unlockNode:getChildByName("img")
    jackpot1:setScale(unlock_scale)
    bole.updateSpriteWithFile(jackpot1, str)

    local jackpot2 = self.lockNode:getChildByName("img")
    jackpot2:setScale(lock_scale)
    bole.updateSpriteWithFile(jackpot2, str)

    self.parent:addChild(self)
    self:setPosition(base_pos)
end
function jackpotTipItem:showjpTipNode(status)
    --self.jpCtl:playMusicByName("popup_out")
    local showNode = self.lockNode
    if status == 2 then
        showNode = self.unlockNode
        self.lockNode:stopAllActions()
        self.lockNode:setVisible(false)
    else
        self.unlockNode:stopAllActions()
        self.unlockNode:setVisible(false)
    end
    showNode:setVisible(true)
    showNode:setScale(0)
    showNode:runAction(
            cc.Sequence:create(
                    cc.ScaleTo:create(0.1, 1.1),
                    cc.ScaleTo:create(0.1, 1),
                    cc.DelayTime:create(1),
                    cc.ScaleTo:create(0.1, 1, 1.1),
                    cc.ScaleTo:create(0.1, 0),
                    cc.Hide:create()
            )
    )
end
function jackpotTipItem:hideTipNode()

    if self.lockNode:isVisible() then
        self.lockNode:stopAllActions()
        self.lockNode:runAction(
                cc.Sequence:create(
                        cc.ScaleTo:create(0.1, 0),
                        cc.Hide:create()
                )
        )
    end
    if self.unlockNode:isVisible() then
        self.unlockNode:stopAllActions()
        self.unlockNode:runAction(
                cc.Sequence:create(
                        cc.ScaleTo:create(0.1, 0),
                        cc.Hide:create()
                )
        )
    end
end

local jackpotItem = class("ThemeApollo_JackpotItem")
function jackpotItem:ctor(jpCtl, node, index)
    self.jpCtl = jpCtl
    self.node = node
    self.index = index
    self.jackpotLabel = node:getChildByName("label_jp")
    local jackpot_config = self.jpCtl:getJackpotConfig()
    local width = jackpot_config.width[self.index]
    local scale = jackpot_config.scale[self.index]
    self.jackpotLabel.baseScale = scale
    self.jackpotLabel.maxWidth = width
    self.lockNode = node:getChildByName("bg_lock")
    self.unlockNode = node:getChildByName("bg_normal")
    self.btn = self.lockNode:getChildByName("btn")

    self.unlockSpineNode = self.unlockNode:getChildByName("bg_loop")
    self:_creatJpClickEvent()
    self.basePos = bole.getPos(self.node)
    self.node:setLocalZOrder(self.index)
    self.lockNode:setVisible(false)
    self:_addLoopAni()
end
function jackpotItem:_creatJpClickEvent()

    local function onTouchJp(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            self.jpCtl:jpBtnClickEvent(self.index)
        end
    end
    self.btn:addTouchEventListener(onTouchJp)
    self.btn:setTouchEnabled(false)
end
function jackpotItem:_addLoopAni()
    local data = {}
    data.parent = self.unlockSpineNode
    data.file = self.jpCtl:getSpineFile("jackpot_loop")
    data.isLoop = true
    local win_ani = "animation%s_1"
    data.animateName = string.format(win_ani, self.index)
    local _, s = bole.addAnimationSimple(data)
    self.loopAni = s
end
function jackpotItem:addWinJpAni()
    local data = {}
    self.node:setLocalZOrder(100)

    if self.isLock then
        return
    end
    data.parent = self.unlockSpineNode
    data.file = self.jpCtl:getSpineFile("jackpot_win")
    data.isLoop = true
    local win_ani = "animation%s_1"
    data.animateName = string.format(win_ani, self.index)
    local _, s = bole.addAnimationSimple(data)
    s:setName("jp_win")
    local jp_type = self.unlockNode:getChildByName("jp_type")
    local fs = 60
    local animate = cc.Sequence:create(
            cc.DelayTime:create(2 / fs),
            cc.ScaleTo:create(26 / fs, 1.15),
            cc.DelayTime:create(2 / fs),
            cc.ScaleTo:create(26 / fs, 1),
            cc.DelayTime:create(2 / fs))
    jp_type:runAction(cc.RepeatForever:create(animate))
end
function jackpotItem:removeJpAni()
    self.node:setLocalZOrder(self.index)
    --self.lockSpineNode:removeAllChildren()
    --self.unlockSpineNode:removeAllChildren()
    local jp_win = self.unlockSpineNode:getChildByName("jp_win")
    if jp_win and bole.isValidNode(jp_win) then
        jp_win:removeFromParent()
    end
    local jp_type = self.unlockNode:getChildByName("jp_type")
    jp_type:stopAllActions()
    jp_type:setScale(1)
end
function jackpotItem:changeJpStyle(isLock)

    if self.isLock and self.isLock == isLock then
        return
    end
    self.lockNode:setVisible(isLock)
    self.unlockNode:setVisible(not isLock)
    local jackpot_config = self.jpCtl:getJackpotConfig()
    local font
    if isLock then
        font = jackpot_config.lock_fnt
        self.jackpotLabel.baseScale = jackpot_config.scale_lock[self.index]
    else
        font = jackpot_config.unlock_fnt
        font = string.format(font, self.index)
        self.jackpotLabel.baseScale = jackpot_config.scale[self.index]
    end
    self.jackpotLabel:setFntFile(self.jpCtl:getFntFilePath(font))
    self.isLock = isLock
end
function jackpotItem:setBtnTouchEnable(enable)
    self.btn:setTouchEnabled(enable)
end

local cls = class("ThemeApollo_JpView")
function cls:ctor(jpCtl, jpRoot, jpTipRoot)
    self.jpCtl = jpCtl
    self.gameConfig = self.jpCtl:getGameConfig()
    self.node = jpRoot
    self.parentTip = jpTipRoot
    self.hasJackpotNode = false
    self:_initLayout()
end
function cls:_initLayout(...)

    self.jackpotSpine = self.node:getChildByName("bg_spine")
    local jackpot_config = self.jpCtl:getGameConfig().jackpot_config
    self.jackpotNodes = {}
    for i = 1, jackpot_config.count do
        self.jackpotNodes[i] = {}

        local node = self.node:getChildByName("node_" .. i)
        self.jackpotNodes[i].node = node
        local jackpotItemNode = jackpotItem.new(self.jpCtl, node, i)
        self.jackpotNodes[i].jpNode = jackpotItemNode
        local tipNode = jackpotTipItem.new(self.jpCtl, i, self.parentTip)
        self.jackpotNodes[i].tipNode = tipNode
    end
    --self:_addLoopJpAni()
end
function cls:getJackpotLabel(index)
    return self.jackpotNodes[index].jpNode.jackpotLabel
end
function cls:getJackpotLabels()
    if not self.jackpotLabels then
        self.jackpotLabels = self.jackpotLabels or {}
        for key = 1, #self.jackpotNodes do
            self.jackpotLabels[key] = self:getJackpotLabel(key)
        end
    end
    return self.jackpotLabels

end
function cls:setJackpotPartState(index, isLock)
    local jpNode = self.jackpotNodes[index].jpNode
    local parent = jpNode
    local base_pos = jpNode.basePos

    jpNode:setBtnTouchEnable(isLock)
    --:setTouchEnabled(isLock)
    if isLock then

        local lock_ani = "animation%s_2"
        lock_ani = string.format(lock_ani, index)
        if not parent.lockSpine then
            local file = self.jpCtl:getSpineFile("jackpot_lock")
            local _, s = bole.addSpineAnimation(self.parentTip, -1, file, base_pos, lock_ani, nil, nil, nil, true, false)
            parent.lockSpine = s
        else
            bole.spChangeAnimation(parent.lockSpine, lock_ani, false)
        end
        self.jpCtl:playMusicByOnce("jp_lock")
        local action = cc.Sequence:create(
                cc.DelayTime:create(30 / 30),
                cc.CallFunc:create(
                        function()
                            if parent.isLocked then
                                bole.spChangeAnimation(parent.lockSpine, "animation1", true)
                            end
                        end
                )
        )
        action:setTag(1001)
        parent.lockSpine:runAction(action)
    else
        local unlock_ani = "animation%s_1"
        unlock_ani = string.format(unlock_ani, index)
        if not parent.lockSpine then
            local file = self.jpCtl:getSpineFile("jackpot_lock")
            local _, s = bole.addSpineAnimation(self.parentTip, -1, file, base_pos, unlock_ani, nil, nil, nil, true, false)
            parent.lockSpine = s
        else
            bole.spChangeAnimation(parent.lockSpine, unlock_ani, false)
        end
        self.jpCtl:playMusicByOnce("jp_unlock")
    end
    if parent.lockSpine then
        parent.lockSpine:stopActionByTag(1001)
    end
    self:changeJpStyle(index, isLock)
end
function cls:changeJpStyle(index, isLock)

    self.jackpotNodes[index].jpNode:changeJpStyle(isLock)
end

function cls:showjpTipNode(index, status)
    local showNode = self.jackpotNodes[index].tipNode
    if self.showjpTipCacheNode then
        self.showjpTipCacheNode:hideTipNode()
    end
    showNode:showjpTipNode(status)
    self.showjpTipCacheNode = showNode
end
function cls:addWinJpAni(jpIndex)
    self.jackpotNodes[jpIndex].jpNode:addWinJpAni()
end
function cls:removeJpAni(jpIndex)
    self.jackpotNodes[jpIndex].jpNode:removeJpAni()
end

return cls
