local BLNode 			= require("UI/CreatorUI/BLNode")

local Login_View = class("Login_View", BLNode)

function Login_View:ctor()
    self.csb        = "ui/login/login_view"
    self.csbName    = "login_view"
    self.node       = CreatorUITools:getInstance():createUi(self.csb);
    self:addChild(self.node)
    self:initButtonListToNode(false)
    self:loadControls()
end

function Login_View:loadControls()
    self.root = self.node.root
    Admop:getInstance():setCallback()
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
    self:loadGodSpine()
end

-- 神动画
function Login_View:loadGodSpine ()
    self.root.process_node:setVisible(false)
    local god_spine = self.root.god_spine

    god_spine:setScale(0)
    god_spine :runAction(
        cc.Sequence:create(
            cc.ScaleTo:create(0.4,1.15),
            cc.ScaleTo:create(0.2,1),
            cc.CallFunc:create(function ()
                self:loadingProcess()
                god_spine:setAnimation(0, "loop", true) 
            end)
        )
    )

 

    local function sound01call()
        bole.playSounds("shandian")
        local function sound02call()
            bole.playSounds("shandian")
        end
        self.sound02 = cc.Director:getInstance():getScheduler():scheduleScriptFunc(sound02call, 14.5, false)
        
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.sound01)
    end
    self.sound01 = cc.Director:getInstance():getScheduler():scheduleScriptFunc(sound01call, 4, false)
  
end

-- 进度条
function Login_View:loadingProcess ()
    
    local delay = 1.8

    local process_node = self.root.process_node
    if process_node then
        process_node:setVisible(true)
        bole.setEnableRecursiveCascading(process_node, true)
        process_node:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(delay + 0.5),
                cc.FadeOut:create(0.5),
                cc.CallFunc:create(function()
                    if process_node then
                        process_node:setVisible(false)
                    end
                end)
            )
        )
        

        local progress_bar = process_node.progress_bar
        if progress_bar then
            progress_bar:setPercentage(11)
             if progress_bar then
                progress_bar:runAction(
                    cc.Sequence:create(
                        cc.EaseIn:create(cc.ProgressTo:create(delay, 100), 3),
                        cc.DelayTime:create(0.5),
                        cc.CallFunc:create(function()
                            self:showLoginButton()
                        end),
                        cc.FadeOut:create(0.5)
                    )
                )
             end
        end

        local bolt_spine = process_node.bolt_spine
        if bolt_spine then
            local posY = bolt_spine:getPositionY()
            bolt_spine:runAction(
                cc.EaseIn:create(cc.MoveTo:create(delay, cc.p(505, posY)), 3)    
            )
        end

        local process_num = process_node.process_num
        if process_num then
            process_num:setString("10%")
            process_num:runAction(
                cc.RepeatForever:create(
                    cc.Sequence:create(
                        cc.DelayTime:create(0.016),
                        cc.CallFunc:create(function()
                            if progress_bar then
                                process_num:setString(math.floor(progress_bar:getPercentage()) .. "%")
                            end
                        end)
                    )
                )
            )
        end
    end

end

-- 登录按钮
function Login_View:showLoginButton()

    local btn_play = self.root.btn_play
    if btn_play then
        btn_play:setVisible(true)
        btn_play:setOpacity(0)
        btn_play:runAction(cc.FadeIn:create(1))
    end

    local play_spine = self.root.play_spine
    if play_spine then
        play_spine:setVisible(true)
        play_spine:setOpacity(0)
        play_spine:runAction(cc.FadeIn:create(1))
    end
 
end

function Login_View:onBtnPlayClicked()
	HttpManager:getInstance():doReport(ReportConfig.btn_login)
    if self.sound02 then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.sound02)
    end
   
    if self.sound01 then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.sound01)
    end
     
    local btn_play = self.root.btn_play
    if btn_play then
        btn_play:setVisible(false)
    end
    local play_spine = self.root.play_spine
    if play_spine then
        play_spine:setVisible(false)
    end
    bole.playSounds("click")
    local Lobby_Scene = require (bole.getDesktopScenePath("Lobby"))
    local scene = Lobby_Scene.new()
    scene:run()
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