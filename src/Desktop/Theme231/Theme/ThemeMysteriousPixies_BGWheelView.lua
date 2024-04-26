

local ThemeMysteriousPixies_BGWheelView = class("ThemeMysteriousPixies_BGWheelView")
local cls = ThemeMysteriousPixies_BGWheelView

function cls:ctor( vCtl, nodesList)
    self.vCtl = vCtl
    self.node = cc.Node:create()
    self.vCtl:curSceneAddToContent(self.node)

    self.gameConfig = self.vCtl:getGameConfig()
    self.config = self.gameConfig.wheel_config
    self:_initLayout(nodesList)
end

function cls:_initLayout( nodesList )

    self.featureParent     = nodesList[1]

    self:initFeatureNode()
end

function cls:initFeatureNode( ... )
    local path          = self.vCtl:getCsbPath("fg_wheel")
    self.csbNode        = cc.CSLoader:createNode(path)
    self.animBg         = self.csbNode:getChildByName("anim_bg")
    self.root           = self.csbNode:getChildByName("root")
    self.logoNode       = self.root:getChildByName("logo")
    self.animNode       = self.root:getChildByName("anim_node")
    self.winAnimNode    = self.root:getChildByName("win_anim")
    self.startBtn       = self.root:getChildByName("start_btn")
    self.wheel          = self.root:getChildByName("wheel_node")
    self.wheelLbList    = self.wheel:getChildByName("labels"):getChildren()

    local data = {}
    data.file = self.vCtl:getSpineFile("wheel_loop")
    data.parent = self.root
    data.animateName = "animation"
    data.pos = cc.p(13, -43)
    data.zOrder = -1
    data.isLoop = true
    local _, s = bole.addAnimationSimple(data)
    self.loopAnim = s

    self.featureParent:addChild(self.csbNode)
    self.csbNode:setVisible(false)

    local function btnOnTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            self:openWheel()
        end
    end
    self.startBtn:addTouchEventListener(btnOnTouch)
    self.startBtn:setTouchEnabled(false)

    self:initMiniWheel()
end

function cls:initWheelLb( lbData )
    if not lbData then return end

    for k, value in pairs(lbData) do
        if value > self.config.jp_max_id and bole.isValidNode(self.wheelLbList[k/2]) then 
            self.wheelLbList[k/2]:setString(value)
        end
    end
end
function cls:initMiniWheel( ... )
    local finshWheel = function ( ... )
        self:onWheelStop()
    end

    local wheelData = tool.tableClone(self.config.wheel)
    self.miniWheel = BaseWheelExtend.new(self, self.wheel, nil, wheelData, finshWheel)
end

function cls:setBtnTouchState( status )
    self.startBtn:setTouchEnabled(status)
    self.startBtn:setBright(status)
end

function cls:openWheel()
    if not self.vCtl:checkCanClick() then return end

    self.vCtl:dealMusic_FadeLoopMusic(0.2, 1, 0.3)

    self.vCtl:playMusicByName("wheel_spin")

    self:changeFeatureTipState("roll")
    self.vCtl:setBtnTouchState(false)

    self.curWinData = self.vCtl:getNextWheelResult()

    local nearMiss = self.curWinData.nearMiss
    local data = {
        ["endAngle"] = 360-(self.curWinData["win"] * 360 / self.config.item_total),
        ["rotateTime"] = 1,
        ["nearMiss"] = nearMiss,
        ["DownBounceTime"] = nearMiss == 0 and 0 or self.config.wheel.downBounceTime,
        ["DownBounce"] = nearMiss*self.config.wheel.downBounce,
    }
    self.miniWheel:updateWheelData(data)
    self.miniWheel:isResetWheelState()

    self.miniWheel:start()

end

function cls:onWheelStop( )
    -- local delay  = 0
    -- if self.curWinData and self.curWinData.nearMiss then 
    --     if self.curWinData.nearMiss == 0 then -- 不动
    --     elseif self.curWinData.nearMiss == 1 then -- 左
    --     elseif self.curWinData.nearMiss == 2 then -- 右
    --     end
    -- end

    local winValue = self.vCtl:getWinWheelValue()
    local animName = "animation2"
    if winValue <= self.config.jp_max_id then -- 中奖 jp
        animName = "animation1"
        self.vCtl:playMusicByName("wheel_stop")
    else
        self.vCtl:playMusicByName("wheel_stop"..winValue)
    end
    -- 播放选中特效
    local data = {}
    data.file = self.vCtl:getSpineFile("wheel_win")
    data.parent = self.winAnimNode
    data.pos = cc.p(13, -43)
    data.animateName = animName.."_1"
    local _,s = bole.addAnimationSimple(data)
    s:setAnimation(0, animName.."_2", true)

    if self.vCtl:isOverWheel() and bole.isValidNode(self.bgLogo) then 
        self.bgLogo:setAnimation(0, "animation3", false)
        self.bgLogo:addAnimation(0, "animation2", true)
    end

    self.node:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(2),
            cc.CallFunc:create(function ( ... )
                self.vCtl:playWheelResule()            
            end)))
end

function cls:showFeatureNode( tryResume )
    self.csbNode:setVisible(true)

    local data = {}
    data.file = self.vCtl:getSpineFile("wheel_logo")
    data.parent = self.logoNode
    data.animateName = "animation1"
    data.isRetain = true
    local _, s1 = bole.addAnimationSimple(data)
    self.bgLogo = s1

    local data = {}
    data.file = self.vCtl:getSpineFile("wheel_bg")
    data.parent = self.animBg
    data.animateName = "animation1"
    data.isRetain = true
    local _, s2 = bole.addAnimationSimple(data)
    self.bgSpine = s2


    local data = {}
    data.file = self.vCtl:getSpineFile("logo_name")
    data.parent = self.root
    data.pos = cc.p(0, 370)
    data.isLoop = true
    bole.addAnimationSimple(data)

    local showBgDelay = 95/30
    
    if tryResume then -- 直接切循环
        self.bgSpine:setAnimation(0, "animation2", true)
        self.bgLogo:setAnimation(0, "animation2", true)
        self.vCtl:changeJPZorder( 1 )

    else
        self.vCtl:playMusicByName("wheel_appear")
        
        self.bgSpine:addAnimation(0, "animation2", true)
        self.bgLogo:addAnimation(0, "animation2", true)
        
        bole.setEnableRecursiveCascading(self.root, true)
        self.root:setVisible(false) -- self.root:setOpacity(0)
        self.root:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(5/30),
                cc.CallFunc:create(function ( ... )
                    self.vCtl:changeJPZorder( 1 )
                    self.root:setVisible(true)
                    self.root:setColor(cc.c3b(0,0,0))
                end),
                cc.TintTo:create(65/30, 255, 255, 255)
                -- cc.FadeIn:create(0.3)
            ))

        self.node:runAction(cc.Sequence:create(
            cc.DelayTime:create(showBgDelay),
            cc.CallFunc:create(function ( ... )
                self.vCtl:addData("feature_show", true)

                self.vCtl:openFeatureBtnEvent()
            end)))
    end
    
end

function cls:changeFeatureTipState( tType )
    if tType == "tip" then 
        if self.isShowItemTip then return end
        self.isShowItemTip = true

        if bole.isValidNode(self.tipAnim) then -- 切换动画
            self.tipAnim:setVisible(true)
            self.tipAnim:setAnimation(0, "animation1", true)
        else
            local data = {}
            data.file = self.vCtl:getSpineFile("wheel_tip")
            data.parent = self.animNode
            data.animateName = "animation1"
            data.pos = cc.p(13, -43)
            data.isLoop = true
            local _, s = bole.addAnimationSimple(data)
            self.tipAnim = s
        end

    elseif tType == "roll" then 
        self.isShowItemTip = false

        if bole.isValidNode(self.tipAnim) then 
            self.tipAnim:setVisible(true)
            self.tipAnim:setAnimation(0, "animation2", false)
        end

    else
        self.isShowItemTip = false

        if bole.isValidNode(self.tipAnim) then 
            self.tipAnim:setVisible(false)
        end

        self.animNode:removeAllChildren()
    end
end

function cls:closeFeatureScreen( ... )
    self.csbNode:stopAllActions()
    bole.setEnableRecursiveCascading(self.csbNode, true)

    self.csbNode:runAction(
        cc.Sequence:create(
            cc.FadeOut:create(0.3),
            cc.RemoveSelf:create()))
end

function cls:onExit( ... )
    if self.miniWheel then 
        if self.miniWheel.scheduler then 
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.miniWheel.scheduler)
            self.miniWheel.scheduler = nil
        end
    end
end

return cls

