---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2021/01/18 15:00
---

local cls = class("ThemeGRII_MultiItem")
function cls:ctor(parentNode, index)

    self.parent = parentNode
    self.index = index
    self.labelNum = parentNode:getChildByName("num")
end
function cls:setString(str)
    self.labelNum:setString(tostring(str))
end
function cls:setVisible(status)
    self.parent:setVisible(status)
end
function cls:setMultiWinAni()
    self.parent:setVisible(true)
    local fs = 60
    local animate = cc.Sequence:create(
            cc.Spawn:create(
                    cc.ScaleTo:create(10 / 30, 1.1),
                    cc.MoveTo:create(10 / 30, cc.p(0, 217))
            ),
            cc.DelayTime:create(30 / 30),
            cc.Spawn:create(
                    cc.ScaleTo:create(10 / 30, 1),
                    cc.MoveTo:create(10 / 30, cc.p(0, 200))
            ),
            cc.Hide:create()
    )
    self.parent:runAction(animate)
end
return cls