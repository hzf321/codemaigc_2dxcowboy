local BLNode 			= require("UI/CreatorUI/BLNode")

local Login_View = class("Login_View", BLNode)

function Login_View:ctor()
    self.csb        = "ui/login/login_view"
    self.csbName    = "login_view"
    self.node       = CreatorUITools:getInstance():createUi(self.csb);
    self:addChild(self.node)
    self:initButtonListToNode(false)
    self.root = self.node.root
    self:loadControls()
    -- self:initSdk()

    local btn_google = self.root.btn_google
    local btn_googleout = self.root.btn_googleout
    btn_google:setVisible(false)
    btn_googleout:setVisible(false)
end
 
-- function Login_View: initSdk()
--     Admop:getInstance():setCallback()
--     GoogleSignIn:getInstance():setCallback(function ()
--         local btn_google = self.root.btn_google
--         local btn_googleout = self.root.btn_googleout
--         btn_google:setVisible(false)
--         btn_googleout:setVisible(true)
--     end)

--     local btn_google = self.root.btn_google
--     local btn_googleout = self.root.btn_googleout
--     btn_google:setVisible(true)
--     btn_google:setScale(0)
  
--     local sequencelogin = cc.Sequence:create(
--         cc.DelayTime:create(1.8),
--         cc.ScaleTo:create(0.2,1),
--         cc.CallFunc:create(function ()
--             btn_google:stopAllActions()
--             local forever =  cc.RepeatForever:create( cc.Sequence:create(
--                 cc.ScaleTo:create(0.7,0.9),cc.ScaleTo:create(0.7,1)
--             ))
--             btn_google:runAction(forever)
--         end)
--     )
--     btn_google:runAction(sequencelogin)

--     btn_googleout:setScale(0)
--     local loginOutAnim = cc.Sequence:create(
--         cc.DelayTime:create(1.8),
--         cc.ScaleTo:create(0.2,1),
--         cc.CallFunc:create(function ()
--             btn_googleout:stopAllActions()
--             local forever =  cc.RepeatForever:create( cc.Sequence:create(
--                 cc.ScaleTo:create(0.7,0.9),cc.ScaleTo:create(0.7,1)
--             ))
--             btn_googleout:runAction(forever)
--         end)
--     )
--     btn_googleout:runAction(loginOutAnim)

--     btn_googleout:setVisible(false)
-- end

function Login_View:loadControls()

    local login_bg =  self.root.login_bg
    local login_man =  self.root.login_man
    local btn_play = self.root.btn_play
    local mist = self.root.mist
    local starAnim = self.root.starAnim
 
    mist:setVisible(false)
    starAnim:setVisible(false)
    login_man:setVisible(false)
    btn_play:setVisible(false)
    login_bg:setScale(1.2)
    local sequence = cc.Sequence:create(
        cc.Spawn:create( cc.ScaleTo:create(1,2.5)),
        cc.Spawn:create( cc.ScaleTo:create(0.5,1), cc.MoveTo:create(0.5,cc.p(0,0))),
    
        cc.CallFunc:create(function ()
        mist:setVisible(true)
        mist:setOpacity(0)
        mist:runAction(   cc.FadeIn:create(1))
        login_man:setVisible(true)
        login_man:setScale(0)
        local sequenceMan = cc.Sequence:create(cc.ScaleTo:create(0.23,1.2),cc.ScaleTo:create(0.1,1),cc.CallFunc:create(function ()
            btn_play:setVisible(true)
           
            btn_play:setScale(0)
            local sequenceBtn = cc.Sequence:create(
                cc.ScaleTo:create(0.2,1),
                cc.CallFunc:create(function ()
                    -- self: playStarAnimBtn()

                    starAnim:setVisible(true)
                    local forever =  cc.RepeatForever:create( cc.Sequence:create(
                        cc.ScaleTo:create(0.7,0.9),cc.ScaleTo:create(0.7,1)
                    ))
                    btn_play:runAction(forever)
                end)
            )
            btn_play:runAction(sequenceBtn)
        end))
        login_man:runAction(sequenceMan)
    end))
    login_bg:runAction(sequence)
end



 
function Login_View:playStarAnimBtn()
    local btn_play = self.root.btn_play
    local star1 = btn_play:getChildren()[1] 
    local star2 = btn_play:getChildren()[2] 
    local star3 = btn_play:getChildren()[3]
    local forever =  cc.RepeatForever:create(
        cc.Sequence:create(
            cc.CallFunc:create(function ()
                local randomAnim = self:getRandomNum(1,3)
                local randomName = self:getRandomNum(1,2)
                local animName = ""
                local anim = nil
                if randomAnim == 1 then
                    anim = star1
                elseif randomAnim == 2 then
                    anim = star2
                else
                    anim = star3
                    local x = self:getRandomNum(-90, 90)
                    local y = self:getRandomNum(10, 36)
                    anim:setPosition(x, y)
                end

                if randomName == 1 then
                    animName = "animation"
                else
                    animName = "animation2"
                end
                anim:setVisible(true)
                anim:setAnimation(0, animName, false)
            end),
            cc.DelayTime:create(2)
        )
    )
    self:runAction(forever)
end

function Login_View: getRandomNum(num1, num2)
    math.randomseed(os.time()) -- 设置随机数种子
    local random_num = math.random(num1, num2) -- 生成1到10之间的随机整数 
    return random_num
end

function Login_View:setMusicSize(num)
    if SettingControl:getInstance():isMusicOpen() then
        AudioEngine.setMusicVolume(num)
    end
end
 

function Login_View:onBtnPlayClicked()
    Admop:getInstance():setCallback()
    Facebook:getInstance():setCallback()
    local starAnim = self.root.starAnim
    starAnim:setVisible(false)
    local btn_play = self.root.btn_play
    btn_play:setTouchEnabled(false)
    btn_play:stopAllActions()
    bole.playSounds("click")
 
    local seq = cc.Sequence:create(cc.ScaleTo:create(0.1,1.1),cc.ScaleTo:create(0.3,0),  cc.DelayTime:create(0.1),cc.CallFunc:create(function ()
        if btn_play then
            btn_play:setVisible(false)
        end
        HttpManager:getInstance():doReport(ReportConfig.btn_login)
        local Lobby_Scene = require (bole.getDesktopScenePath("Lobby"))
        local scene = Lobby_Scene.new()
        scene:run()
    end))

    btn_play:runAction(seq)

    -- local btn_google = self.root.btn_google
    -- local btn_googleout = self.root.btn_googleout
    -- btn_google:stopAllActions()
    -- btn_googleout:stopAllActions()
    -- btn_google:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1,1.1),cc.ScaleTo:create(0.3,0)))
    -- btn_googleout:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1,1.1),cc.ScaleTo:create(0.3,0)))
end
 

-- function Login_View:onBtnGoogleClicked()
--     print("注册回调 ------------ 点击登录")
--     GoogleSignIn:getInstance():login(function ()
--         local btn_google = self.root.btn_google
--         local btn_googleout = self.root.btn_googleout
--         btn_google:setVisible(false)
--         btn_googleout:setVisible(true)
--     end)
-- end

-- function Login_View:onBtnGoogleoutClicked()
--     print("注册回调 ------------退出登录")
--     GoogleSignIn:getInstance():loginOut(function ()
--         local btn_google = self.root.btn_google
--         local btn_googleout = self.root.btn_googleout
--         btn_google:setVisible(true)
--         btn_googleout:setVisible(false)
--     end)
-- end
 

return Login_View