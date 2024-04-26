local BLNode 			= require("UI/CreatorUI/BLNode")

local Login_View = class("Login_View", BLNode)

function Login_View:ctor()
    self.csb        = "ui/login/login_view"
    self.csbName    = "login_view"
    self.node       = CreatorUITools:getInstance():createUi(self.csb);
    self:addChild(self.node)
    self:initButtonListToNode(false)
    self:loadControls()

    Admop:getInstance():setCallback()
    local btn_google = self.root.btn_google
    local btn_googleout = self.root.btn_googleout
    btn_google:setVisible(false)
    btn_googleout:setVisible(false)

    -- GoogleSignIn:getInstance():setCallback(function ()
    --     local btn_google = self.root.btn_google
    --     local btn_googleout = self.root.btn_googleout
    --     btn_google:setVisible(false)
    --     btn_googleout:setVisible(true)
    -- end)

    -- local btn_google = self.root.btn_google
    -- local btn_googleout = self.root.btn_googleout
    -- btn_google:setVisible(true)
    -- btn_googleout:setVisible(false)
end

function Login_View:loadControls()
    self.root = self.node.root
    local login_bg =  self.root.login_bg
    local login_man =  self.root.login_man
    local btn_play = self.root.btn_play
    local mist = self.root.mist
    local cloud = self.root.cloud
    local star = self.root.star

    -- local btn_google = self.root.btn_google
    -- local btn_googleout = self.root.btn_googleout
    -- btn_google:setScale(0)
    -- btn_googleout:setScale(0)

    star:setVisible(false)
    cloud:setOpacity(0)
    mist:setVisible(false)
    login_man:setVisible(false)
    btn_play:setVisible(false)
    login_bg:setScale(1.2)
    local sequence = cc.Sequence:create(cc.ScaleTo:create(1,2.5),cc.ScaleTo:create(0.5,1), cc.CallFunc:create(function ()
        mist:setVisible(true)
        star:setVisible(true)
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
                    local forever =  cc.RepeatForever:create( cc.Sequence:create(
                        cc.ScaleTo:create(0.7,0.9),cc.ScaleTo:create(0.7,1)
                    ))
                    btn_play:runAction(forever)
                end)
            )

            -- btn_google:runAction( cc.ScaleTo:create(0.2,1))
            -- btn_googleout:runAction( cc.ScaleTo:create(0.2,1))
            btn_play:runAction(sequenceBtn)
        end))
        cloud:runAction(cc.FadeIn:create(0.33))
        login_man:runAction(sequenceMan)
    end))
    login_bg:runAction(sequence)

end
 

function Login_View:onBtnPlayClicked()
   
    local btn_play = self.root.btn_play
  


    btn_play:setTouchEnabled(false)
    btn_play:stopAllActions()
    bole.playSounds("click")

    local mist = self.root.mist
    mist:setVisible(false)
    
    local login_man =  self.root.login_man
    local seq_man = cc.Sequence:create(cc.ScaleTo:create(0.1,1.1), cc.Spawn:create( cc.ScaleTo:create(0.3,0), cc.FadeOut:create(0.2)), cc.CallFunc:create(function () 
        login_man:setVisible(false)

        local login_bg =  self.root.login_bg
        login_bg:runAction(
            cc.ScaleTo:create(0.5,1.3) 
        )
    end))

    login_man:runAction(
        seq_man
    )

    local cloud = self.root.cloud
    cloud:runAction(
       cc.FadeOut:create(0.3)
    )
 
 
    local seq = cc.Sequence:create(cc.ScaleTo:create(0.1,1.1), cc.Spawn:create( cc.ScaleTo:create(0.3,0), cc.FadeOut:create(0.2)),cc.DelayTime:create(0.5),
    cc.CallFunc:create(function ()
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
    -- btn_google:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1,1.1), cc.Spawn:create( cc.ScaleTo:create(0.3,0), cc.FadeOut:create(0.2)),cc.DelayTime:create(0.5)))
    -- btn_googleout:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1,1.1), cc.Spawn:create( cc.ScaleTo:create(0.3,0), cc.FadeOut:create(0.2)),cc.DelayTime:create(0.5)))
   

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