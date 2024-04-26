---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2021/01/25 21:49
---  
local cls = class("ThemeGRII_JackpotTipItem", function()
    return cc.Node:create()
end)
function cls:ctor(jpCtl, index, parent)
    self.parent = parent
    self.jpCtl = jpCtl
    self.index = index
    self.csb = self.jpCtl:getCsbPath("jp_tip")
    self.node = cc.CSLoader:createNode(self.csb)
    self:addChild(self.node)
    self:loadControls()

end
function cls:loadControls()

    local jackpot_config = self.jpCtl:getJackpotConfig()
    local light_img = jackpot_config.light_jp_img
    local str = string.format(light_img, self.index)
    local base_pos = jackpot_config.jp_tip_pos[self.index]
    self.rootNode = self.node:getChildByName("root")
    self.unlockNode = self.rootNode:getChildByName("unlock")
    self.unlockNode:setVisible(false)

    self.lockNode = self.rootNode:getChildByName("lock")
    self.lockNode:setVisible(false)

    local jackpot1 = self.unlockNode:getChildByName("img")
    bole.updateSpriteWithFile(jackpot1, str)

    local jackpot2 = self.lockNode:getChildByName("img")
    bole.updateSpriteWithFile(jackpot2, str)

    self.parent:addChild(self)
    self:setPosition(base_pos)
end
function cls:showjpTipNode(status)
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
function cls:hideTipNode()
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
return cls