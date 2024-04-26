---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2020/11/23 21:15
local cls = class("ThemeApollo_CollectView")

function cls:ctor(ctl, parent, parentTip, flyNode)
    self.ctl = ctl
    self.node = parent
    self.collectTipNode = parentTip
    self.flyNode = flyNode

    local collect_config = self.ctl:getGameConfig().collect_config
    self.startPosX = collect_config.progressStartPosX
    self.startPosY = 16
    self.moveAllDistance = collect_config.progressEndPosX - collect_config.progressStartPosX
    self.maxMapPoint = self.ctl:getCollectMaxPoint()

end
function cls:initCollectRoot()
    self.openStoreBtn = self.node:getChildByName("btn_map")
    self.unlockStoreBtn = self.node:getChildByName("btn_unlock")
    --self.collectTipNode = self.node:getChildByName("tip_node")
    self.collectTipNode:setVisible(false)
    local progress = self.node:getChildByName("progress_node")
    self.progressPanel = progress:getChildByName("panel")
    self.progressCell = self.progressPanel:getChildByName("node")

    self.collectItem = self.node:getChildByName("collect_item")
    self.collectAim = self.node:getChildByName("aim")
    self.bgSpineNode = self.node:getChildByName("bg_spine")
    self.topSpineNode = self.node:getChildByName("spine_node")
    self.lockNode = self.node:getChildByName("lock_node")
    self:_setFeatureEvent()
    self:_addCollectSpine()
end

function cls:_addCollectSpine()
    local topData = {}
    topData.parent = self.collectAim
    topData.file = self.ctl:getSpineFile("collect_map")
    topData.isLoop = true
    local _, s = bole.addAnimationSimple(topData)
    self.btnMapSpine = s

    local downData = {}
    downData.parent = self.collectItem
    downData.file = self.ctl:getSpineFile("collect_item")
    downData.isLoop = true
    downData.animateName = "animation"
    downData.pos = cc.p(0, 0)
    local _, s = bole.addAnimationSimple(downData)
    self.m1Spine = s

    local proData = {}
    proData.parent = self.progressCell
    proData.file = self.ctl:getSpineFile("collect_loop")
    proData.isLoop = true
    proData.animateName = "animation"
    local _, s = bole.addAnimationSimple(proData)

end
function cls:progressUping()
    local proHeadData = {}
    proHeadData.parent = self.progressCell
    proHeadData.file = self.ctl:getSpineFile("collect_uping")
    proHeadData.pos = cc.p(0, 0)
    local _, s1 = bole.addAnimationSimple(proHeadData)
end
function cls:_addReceiveLight()
    local downData = {}
    downData.parent = self.collectItem
    downData.file = self.ctl:getSpineFile("collect_item")
    downData.animateName = "animation3"
    downData.zOrder = 1
    bole.addAnimationSimple(downData)
    if self.m1Spine and bole.isValidNode(self.m1Spine) then
        self.m1Spine:setAnimation(0, "animation2", false)
        self.m1Spine:addAnimation(0, "animation", true)
    end
end
function cls:_setFeatureEvent()
    local function open_store_fun(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            self.btnMapSpine:setColor(cc.c3b(255, 255, 255))
            self.ctl:clickMapBtn()
        end
        if eventType == ccui.TouchEventType.began then
            if self.ctl._mainViewCtl:getCanTouchFeature() then
                self.btnMapSpine:setColor(cc.c3b(100, 100, 100))
            end
        end
        if eventType == ccui.TouchEventType.canceled then
            self.btnMapSpine:setColor(cc.c3b(255, 255, 255))
        end
    end
    local unlock_store_fun = function(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            self.ctl:clickUnLockBtn()
        end
    end
    self.openStoreBtn:addTouchEventListener(open_store_fun)
    self.unlockStoreBtn:addTouchEventListener(unlock_store_fun)
    self.openStoreBtn:setTouchEnabled(true)
    self.unlockStoreBtn:setTouchEnabled(true)
end
function cls:getFlyStoreCoinWorldPos()
    local wEndPos = self.collectItem:convertToWorldSpace(cc.p(0, 0))
    return wEndPos
end
function cls:updateCollectCount(newCount, beforeCount, isAnimate)
    if newCount > self.maxMapPoint then
        newCount = self.maxMapPoint
    end
    local newPosX = self.startPosX + newCount / self.maxMapPoint * self.moveAllDistance
    if isAnimate then
        if beforeCount > self.maxMapPoint then
            beforeCount = self.maxMapPoint
        end
        self:progressUping()
        local oldPosX = self.startPosX + beforeCount / self.maxMapPoint * self.moveAllDistance
        self.progressCell:setPositionX(oldPosX)
        self.progressCell:runAction(cc.MoveTo:create(0.2, cc.p(newPosX, self.startPosY)))
        self:_addReceiveLight()
        if newCount >= self.maxMapPoint then
            self:playCollectFull()
        end
    else
        self.progressCell:setPositionX(newPosX)
    end
end
function cls:playCollectFull()

    local data = {}
    data.file = self.ctl:getSpineFile("collect_full")
    data.parent = self.topSpineNode
    bole.addAnimationSimple(data)
end

function cls:setCollectPartState(isLock, isAnimate)
    if not self.lockSuperSpine then
        local data = {}
        data.file = self.ctl:getSpineFile("collect_lock")
        data.parent = self.lockNode
        data.isRetain = true
        local _, s = bole.addAnimationSimple(data)
        self.lockSuperSpine = s
    end
    if isLock then
        local aniName = "animation1"
        if isAnimate then
            self.ctl:playMusicByName("collect_lock")
        end
        self.lockSuperSpine:setAnimation(0, aniName, false)
        self:changeStoreTipState(true)
    else
        local aniName = "animation2"
        self.lockSuperSpine:setAnimation(0, aniName, false)
        if isAnimate then
            self.ctl:playMusicByName("collect_unlock")
        end
        self:changeStoreTipState(false)
    end
end
function cls:changeStoreTipState(isClose, notAni)
    if isClose then
        self.closeTipStatus = true
        self.collectTipNode:stopAllActions()
        if notAni then
            self.collectTipNode:setVisible(false)
        else
            if self.collectTipNode:isVisible() then
                self.collectTipNode:runAction(
                        cc.Sequence:create(
                                cc.ScaleTo:create(0.3, 0),
                                cc.Hide:create()
                        )
                )
            end
        end

    else
        self.closeTipStatus = false
        self.collectTipNode:stopAllActions()
        self.collectTipNode:setVisible(true)
        self.collectTipNode:setScale(0)
        self.collectTipNode:runAction(
                cc.Sequence:create(
                        cc.ScaleTo:create(0.3, 1),
                        cc.DelayTime:create(2),
                        cc.CallFunc:create(
                                function()
                                    self:changeStoreTipState(true)
                                end)
                )
        )
    end
end
function cls:getIsCloseTip()
    return self.closeTipStatus
end

function cls:flyItemActions(info)

    local endWPos = self.collectItem:convertToWorldSpace(cc.p(0, 0))
    local endNPos = bole.getNodePos(self.flyNode, endWPos)
    for i = 1, #info do
        local file = self.ctl:getSpineFile("collect_fly")
        local data = {}
        data.file = file
        data.parent = self.flyNode
        data.pos = info[i][3]
        local _, s = bole.addAnimationSimple(data)
        s:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(7 / 30),
                        cc.CallFunc:create(function()
                            self:_parabolaToAnimation(s, endNPos)
                        end)

                )
        )
    end
end
function cls:_parabolaToAnimation(obj, to)
    local from = bole.getPos(obj)
    local half = cc.p((to.x + from.x) / 2, (to.y + from.y) / 2)
    local a = to.y - from.y
    local b = to.x - from.x
    local dis = math.sqrt(math.pow(a, 2) + math.pow(b, 2))
    local a1 = half.y - b / 2
    local b1 = half.x + a / 2
    --local dur = dis / 1000
    local dur = 15 / 30
    obj:runAction(
            cc.Sequence:create(
                    cc.BezierTo:create(dur, { from, cc.p(b1, a1), to }),
                    cc.DelayTime:create(10 / 30),
                    cc.RemoveSelf:create()
            )
    )
end

return cls





