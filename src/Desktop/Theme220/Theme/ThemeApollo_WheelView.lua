---
--- @program src 
--- @description:220 wheel
--- @author: rwb 
--- @create: 2020/11/23 15:39
---
local cls = class("ThemeApollo_WheelView", CCSNode)
function cls:ctor(wheelCtl, parentNode, data)
    self.ctl = wheelCtl
    self.csb = self.ctl:getCsbPath("wheel")
    self.data = data
    self.parentNode = parentNode
    local wheel_config = self.ctl:getWheelConfig()
    self.totalCount = wheel_config.count
    self.myBonusData = data
    if data then
        self.stopIndex = self.myBonusData.index - 1
    else
        self.stopIndex = 2
    end
    if self.stopIndex == 0 then
        self.stopAngle = 0
    else
        self.stopIndex = 6 - self.stopIndex
        self.stopAngle = (self.stopIndex * 360 / self.totalCount)
    end
    self.randomMore = math.random(10, 20)
    CCSNode.ctor(self, self.csb)
end
function cls:loadControls()
    self.wheelRoot = self.node:getChildByName("root")
    self.dimmer = self.node:getChildByName("bg")
    self.wheelBgNode = self.wheelRoot:getChildByName("node1")

    self.wheelCenter = self.wheelRoot:getChildByName("node2")
    self.wheelLabel = self.wheelCenter:getChildByName("nums"):getChildren()
    self.imgWheelBg = self.wheelCenter:getChildByName("wheel_bg")

    self.spineNode = self.wheelRoot:getChildByName("node3")
    self.frameSpine = self.spineNode:getChildByName("bg_spine")
    self.imgWinBg = self.spineNode:getChildByName("bg2")
    self.btnSpin = self.wheelRoot:getChildByName("btn_spin")
    self.btnSpineNode = self.wheelRoot:getChildByName("btn_spine")

    self.spineWinNode = self.wheelCenter:getChildByName("win_node")
    local labelCoinsNode = self.wheelRoot:getChildByName("win_node")
    self.labelCoins = labelCoinsNode:getChildByName("label_coins")
    --self:addWheelBgAni()
    self:initWheelColor()
end
function cls:initWheelColor()
    local colorType = self.ctl:getNodeType()
    --if colorType == 1
    local img_bg = "#theme220_wheel%s_bg.png"
    img_bg = string.format(img_bg, colorType)
    bole.updateSpriteWithFile(self.imgWheelBg, img_bg)

    local img_bg2 = "#theme220_wheel%s_point.png"
    img_bg2 = string.format(img_bg2, colorType)
    bole.updateSpriteWithFile(self.imgWinBg, img_bg2)
end
function cls:wheelRunAni()
    local data = {}
    data.parent = self.frameSpine
    data.file = self.ctl:getSpineFile("wheel_roll")
    data.isLoop = true
    data.animateName = "animation3"
    bole.addAnimationSimple(data)
    self.ctl:playMusicByName("wheel_roll")
end
function cls:addBtnSpine()
    local data = {}
    data.parent = self.btnSpineNode
    data.file = self.ctl:getSpineFile("wheel_roll")
    data.isLoop = true
    data.animateName = "animation1"
    local _, s = bole.addAnimationSimple(data)
    self.btnSpineNode.spine = s
end
function cls:btnClickSpine()
    self.ctl:playMusicByName("wheel_btn")
    if self.btnSpineNode.spine and bole.isValidNode(self.btnSpineNode.spine) then
        self.btnSpineNode.spine:setAnimation(0, "animation2", false)
    end
end
function cls:addWheelWinAni()
    self.ctl:playMusicByName("wheel_win")
    local data = {}
    data.file = self.ctl:getSpineFile("wheel_stop_win")
    data.parent = self.spineWinNode
    self.spineWinNode:setRotation(-self.stopAngle)
    data.isLoop = true
    data.animateName = "animation"
    bole.addAnimationSimple(data)

end
function cls:showWheelScreen(isStart)
    self:initStartLayout(isStart)
    self.ctl:playMusicByName("wheel_appear")
    self.parentNode:addChild(self)
    self.wheelRoot:setPosition(0, -1560)
    self:dimmerIn(0.2)
    self.wheelRoot:runAction(
            cc.Sequence:create(
                    cc.MoveTo:create(0.2, cc.p(0, 20)),
                    cc.MoveTo:create(0.2, cc.p(0, 0)),
                    cc.CallFunc:create(function()
                        if not isStart then
                            self:initWheelEvent()

                        end
                    end)
            )
    )
end
function cls:closeWheelScene()
    self.ctl:playMusicByName("wheel_disappear")
    self.wheelRoot:setPosition(0, 0)
    self:dimmerOut(0.2)
    self.wheelRoot:runAction(
            cc.Sequence:create(
                    cc.MoveTo:create(0.2, cc.p(0, 20)),
                    cc.MoveTo:create(0.2, cc.p(0, -1560)),
                    cc.CallFunc:create(
                            function()
                                self:removeFromParent()
                            end)
            )
    )
end
function cls:initWheelNumber()
    if not self.myBonusData then
        return
    end
    local wheelData = self.myBonusData.wheel
    local count = 0
    for key = 1, self.totalCount do
        if wheelData[key] >= 100 then
            bole.updateSpriteWithFile(self.wheelLabel[key], "#theme220_wheel_muti_100.png")
        else
            local img = "#theme220_wheel_muti_%s.png"
            img = string.format(img, wheelData[key])
            bole.updateSpriteWithFile(self.wheelLabel[key], img)
        end
    end
end
function cls:initStartLayout(isStart)

    self:initWheelNumber()
    local str = FONTS.formatByCount4(self.ctl:getSuperBet(), 13, true, true)
    self.labelCoins:setString(str)
    if not isStart then
        self:addBtnSpine()
    end

end
function cls:initWheelEvent()
    local isClick = false

    local pressFunc = function(obj, eventType)
        isClick = true

        self:setStartRoll()
    end

    local function onTouch2(obj, eventType)
        if isClick then
            return nil
        end
        if eventType == ccui.TouchEventType.ended then
            self.btnSpin:setBright(false)
            pressFunc(obj)
        end
    end
    self.btnSpin:addTouchEventListener(onTouch2)-- 设置按钮
end
function cls:showStartSpinBtn()
    --self.btnSpin:setTouchEnabled(true)
end

function cls:setStartRoll()
    self.btnSpin:setTouchEnabled(false)
    self.ctl:setWheelTouchSpin(true)
    self.ctl:saveBonus()
    self:btnClickSpine()
    self:runAction(cc.Sequence:create(
            cc.DelayTime:create(4 / 30), -- 按钮特效时间
            cc.CallFunc:create(function()
                self:wheelRunAni()
                self:spinWheel()
            end)
    ))
end
function cls:spinWheel()
    local function finishSpin()
        self.miniWheel = nil
        self:saveBonus()
        self:runAction(cc.Sequence:create(
                cc.CallFunc:create(function()
                    self.frameSpine:removeAllChildren()
                    self.wheelCenter:runAction(cc.RotateBy:create(0.5, -self.randomMore))

                    self.ctl:setWheelSpinFinish(true)
                    self.ctl:saveBonus()
                end),
                cc.DelayTime:create(0.5),
                cc.CallFunc:create(function()
                    self:addWheelWinAni()
                end),
                cc.DelayTime:create(2),
                cc.CallFunc:create(function()
                    self.ctl:spinWheelFinish()
                end)))
    end
    self.ctl:playMusicByName("wheel_spin")
    local speed = self.ctl:getWheelConfig().speed_config
    local wheelData = tool.tableClone(speed)
    wheelData.endAngle = self.stopAngle + self.randomMore
    self.miniWheel = BaseWheelExtend.new(self, self.wheelCenter, nil, wheelData, finishSpin)
    self.miniWheel:start()
end
function cls:setFinishUI()
    self.wheelCenter:setRotation(self.stopAngle)
end

function cls:saveBonus()
    if self.bonus then
        self.ctl.bonus:saveBonus()
    end
end
function cls:onExit()
    if self.miniWheel and self.miniWheel.scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.miniWheel.scheduler)
        self.miniWheel.scheduler = nil
    end
end
function cls:dimmerOut(spentTm)
    self.dimmer:setOpacity(180)
    self.dimmer:setVisible(true)
    self.dimmer:runAction(cc.FadeOut:create(spentTm))

end
function cls:dimmerIn(spentTm)
    self.dimmer:setOpacity(0)
    self.dimmer:setVisible(true)
    self.dimmer:runAction(cc.FadeTo:create(spentTm, 180))
end
return cls