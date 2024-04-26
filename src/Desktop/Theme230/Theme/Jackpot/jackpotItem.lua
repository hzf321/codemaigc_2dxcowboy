---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2021/01/25 21:52
---
local cls = class("ThemeEaster_JackpotItem")
function cls:ctor(jpCtl, node, index, label)
    self.jpCtl = jpCtl
    self.node = node
    self.index = index
    self.jackpotLabel = label
    local jackpot_config = self.jpCtl:getJackpotConfig()
    local width = jackpot_config.width[self.index]
    local scale = jackpot_config.scale[self.index]
    self.jackpotLabel.baseScale = scale
    self.jackpotLabel.maxWidth = width
    self.lockNode = node:getChildByName("bg_lock")
    self.unlockNode = node:getChildByName("bg_normal")
    self.bgLoop = self.unlockNode:getChildByName("bg_loop")
    self.btn = self.lockNode:getChildByName("btn")

    self.unlockSpineNode = self.unlockNode:getChildByName("bg_loop")
    self:_creatJpClickEvent()
    self.basePos = bole.getPos(self.node)
    self.node:setLocalZOrder(self.index)
    self.jackpotLabel:setLocalZOrder(self.index + 10)
    self.lockNode:setVisible(false)
    self:_addLoopAni()
end
function cls:_creatJpClickEvent()

    local function onTouchJp(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            self.jpCtl:jpBtnClickEvent(self.index)
        end
    end
    self.btn:addTouchEventListener(onTouchJp)
    self.btn:setTouchEnabled(false)
end
function cls:_addLoopAni()
    local data = {}
    data.parent = self.unlockSpineNode
    data.file = self.jpCtl:getSpineFile("jackpot_loop")
    data.isLoop = true
    local win_ani = self.jpCtl:getJackpotConfig().jp_loop_ani
    data.animateName = string.format(win_ani, self.index)
    local _, s = bole.addAnimationSimple(data)
    self.loopAni = s
end
function cls:addWinJpAni()
    local data = {}
    self.node:setLocalZOrder(100)
    self.jackpotLabel:setLocalZOrder(100 + 10)
    if self.isLock then
        return
    end
    data.parent = self.unlockSpineNode
    data.file = self.jpCtl:getSpineFile("jackpot_win")
    data.isLoop = true
    local win_ani = self.jpCtl:getJackpotConfig().jp_win_ani
    data.animateName = string.format(win_ani, self.index)
    local _, s = bole.addAnimationSimple(data)
    s:setName("jp_win")
end
function cls:removeJpAni()
    self.node:setLocalZOrder(self.index)
    self.jackpotLabel:setLocalZOrder(self.index + 10)
    local jp_win = self.unlockSpineNode:getChildByName("jp_win")
    if jp_win and bole.isValidNode(jp_win) then
        jp_win:removeFromParent()
    end
end
function cls:changeJpStyle(isLock)

    if self.isLock and self.isLock == isLock then
        return
    end
    self.lockNode:setVisible(isLock)
    self.unlockNode:setVisible(not isLock)
    local jackpot_config = self.jpCtl:getJackpotConfig()
    local font
    if isLock then
        font = jackpot_config.lock_fnt
    else
        font = jackpot_config.unlock_fnt
    end
    self.jackpotLabel:setFntFile(self.jpCtl:getFntFilePath(font))
    self.isLock = isLock
end
function cls:setBtnTouchEnable(enable)
    self.btn:setTouchEnabled(enable)
end
return cls