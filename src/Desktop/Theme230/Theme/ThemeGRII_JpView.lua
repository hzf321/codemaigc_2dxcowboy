---@program src
---@description:  theme230
---@author: rwb
---@create: : 2020/12/29 20:46
local jackpotTipItem = require (bole.getDesktopFilePath("Theme/Jackpot/jackpotTipItem")) 
local jackpotItem = require (bole.getDesktopFilePath("Theme/Jackpot/jackpotItem")) 
 
local cls = class("ThemeGRII_JpView")
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
        local label = self.node:getChildByName("label_jp" .. i)
        local jackpotItemNode = jackpotItem.new(self.jpCtl, node, i, label)
        self.jackpotNodes[i].jpNode = jackpotItemNode
        local tipNode = jackpotTipItem.new(self.jpCtl, i, self.parentTip)
        self.jackpotNodes[i].tipNode = tipNode
    end
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

    if isLock then
        local lock_ani = "animation%s_1"
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
        local unlock_ani = "animation%s_2"
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

    local jpNode = self.jackpotNodes[index].jpNode

    local delay = 0
    if isLock then
        delay = 5 / 30
    else
        delay = 17 / 30
    end
    local action = cc.Sequence:create(
            cc.DelayTime:create(delay),
            cc.CallFunc:create(
                    function()
                        self.jackpotNodes[index].jpNode:changeJpStyle(isLock)
                    end)
    )
    action:setTag(1001)
    jpNode.lockSpine:runAction(action)
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

local viewCenter = {}
viewCenter.view = cls

return viewCenter
