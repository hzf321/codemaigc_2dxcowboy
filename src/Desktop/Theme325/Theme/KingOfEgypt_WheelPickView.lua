--[[
Author: xiongmeng
Date: 2020-12-16 20:28:51
LastEditors: xiongmeng
LastEditTime: 2021-01-06 17:36:47
Description: 
--]]
local cls = class("KingOfEgypt_WheelPickView")

function cls:ctor(ctl, curScene)
	self.ctl = ctl
    self.gameConfig = self.ctl:getGameConfig()
    self.curScene = curScene
    self:_initNode()
end

function cls:_initNode()
    local csbList = self.gameConfig.csb_list
	local path = self.ctl:getPic(csbList.choose)
	self.chooseRoot = libUI.createCsb(path)
    -- self.curScene:addToContent(self.chooseRoot)
    self.curScene:addToContentFooter(self.chooseRoot)
    self:_initChooseNode()
    self:playStartDialog()
end
function cls:_initChooseNode()
    self.chooseDimmer = self.chooseRoot:getChildByName("dimmer")
    self.root = self.chooseRoot:getChildByName("root")
    self.chooseSun = self.root:getChildByName("sun")
    self.chooseMoon = self.root:getChildByName("moon")
    self.sunChooseBtn = self.chooseSun:getChildByName("btn_choose")
    self.sunChooseBtn.index = 1
    self.moonChooseBtn = self.chooseMoon:getChildByName("btn_choose")
    self.moonChooseBtn.index = 2
    self:enableWheelClickNode(false)
    self:_addChooseEvent()
    self:showDimmerNode()
end
function cls:playStartDialog()
    self:addChooseSpine()
    self.ctl:playMusicByName("dialog_wheel_start")
    local a1 = cc.DelayTime:create(31/30)
    local a2 = cc.CallFunc:create(function ()
        self:enableWheelClickNode(true)
        self:addChooseSpine("animation2", true)
    end)
    local a3 = cc.Sequence:create(a1,a2)
    libUI.runAction(self.root, a3)
end
function cls:addChooseSpine(animateName, isLoop)
    animateName = animateName or "animation1"
    isLoop = isLoop or nil
    if not self.chooseSpine then 
        local file = self.ctl:getSpineFile("wheel_choose")
        local _, spine = bole.addSpineAnimation(self.root, -1, file, cc.p(0,0), animateName, nil, nil, nil, true, isLoop)
        self.chooseSpine = spine
    else 
        bole.spChangeAnimation(self.chooseSpine, animateName, isLoop)
    end
end

function cls:enableWheelPickRoot(enable)
    self.chooseRoot:setVisible(enable)
end
function cls:_addChooseEvent()
    local isClick = false
    local pressFunc = function(obj, eventType)
        isClick = true
        self:_addChooseAni(obj.index)
    end
    local function onTouch1(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            if isClick then return end
            self.ctl:playMusicByName("wheel_feature_choose")
            self:enableWheelClickNode(false)
            pressFunc(obj)
        end
    end
    self.sunChooseBtn:addTouchEventListener(onTouch1)-- 设置按钮
    self.moonChooseBtn:addTouchEventListener(onTouch1)-- 设置按钮
end
function cls:enableWheelClickNode(enable)
    self.sunChooseBtn:setTouchEnabled(enable)-- 设置按钮
    self.moonChooseBtn:setTouchEnabled(enable)-- 设置按钮
end
function cls:showDimmerNode()
    self.chooseDimmer:setOpacity(0)
    self.chooseDimmer:runAction(cc.FadeTo:create(10/30, 180))
end
function cls:_addChooseAni(index)
    local animation = "animation"..(index + 2)
    self:addChooseSpine(animation, true)
    self.ctl:enterWheelNextGame(index)
end
function cls:removeChooseNode()
    if self.chooseRoot and bole.isValidNode(self.chooseRoot) then
        -- self.chooseDimmer:runAction(cc.FadeOut:create(10/30))
        bole.setEnableRecursiveCascading( self.chooseRoot, true)
        -- self.chooseDimmer:runAction(cc.FadeTo:create(10/30, 200))
        -- self.root:runAction(cc.FadeOut:create(15/30))
        
        -- local a1 = cc.DelayTime:create(15/30)
        local a1 = cc.FadeOut:create(15/30)
        local a2 = cc.RemoveSelf:create()
        local a3 = cc.CallFunc:create(function ()
            self.chooseRoot = nil
        end)
        local a4 = cc.Sequence:create(a1,a2,a3)
        libUI.runAction( self.chooseRoot, a4)
    end
end

return cls