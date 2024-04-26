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
    self.root :runAction(
        cc.Sequence:create(
            cc.DelayTime:create(0.1),
            cc.CallFunc:create(function ()
                self:setMusicSize(0.4)
                bole.playSounds("longyin")
            end),
            cc.DelayTime:create(4),
            cc.CallFunc:create(function ()
                self:setMusicSize(0.7)
            end)
        )
    )

    self.root.dragon:setAnimation(1, "animation2", false)
    self.root.dragon:registerSpineEventHandler( function(event)
        if event.animation == "animation2" then
            self.root.dragon:setAnimation(1, "animation", true) 
            self.randomNum =  math.random(10,30)
            self.root.dragon: runAction(
                cc.Sequence:create(
                    cc.DelayTime:create(self.randomNum),
                    cc.CallFunc:create(function ()
                        self.root :runAction(   
                            cc.Sequence:create(
                                cc.DelayTime:create(0.1),
                                cc.CallFunc:create(function ()
                                    self:setMusicSize(0.4)
                                    bole.playSounds("longyin")
                                end),
                                cc.DelayTime:create(4),
                                cc.CallFunc:create(function ()
                                    self:setMusicSize(0.7)
                                end)
                            )
                        )
                        self.root.dragon:setAnimation(1, "animation2", false)
                    end)
                )
            )
        end
    end, sp.EventType.ANIMATION_COMPLETE)
end

function Login_View:setMusicSize(num)
    if SettingControl:getInstance():isMusicOpen() then
        AudioEngine.setMusicVolume(num)
    end
end
 

function Login_View:onBtnPlayClicked()
    Admop:getInstance():setCallback()
    Facebook:getInstance():setCallback()
    local btn_play = self.root.btn_play
    if btn_play then
        btn_play:setVisible(false)
    end
    bole.playSounds("click")
    bole.playSounds("zhuanchang")
    self:cloudAnim()
    HttpManager:getInstance():doReport(ReportConfig.btn_login)
end


function Login_View: cloudAnim()
    local cloudAnim = self.root.cloudAnim
    if cloudAnim then
        cloudAnim:setVisible(true)
        cloudAnim:setAnimation(1, "appear", false) 
        cloudAnim:registerSpineEventHandler( function(event)
            if event.animation == "appear" then
          
                cloudAnim:setAnimation(1, "loop", false) 
            end
            if event.animation == "loop" then
                cloudAnim:setVisible(false)
                local Lobby_Scene = require (bole.getDesktopScenePath("Lobby"))
                local scene = Lobby_Scene.new()
                scene:run()
            end
            if event.animation == "disappear" then
                cloudAnim:setVisible(false)
            end
        end, sp.EventType.ANIMATION_COMPLETE)
    end
end

return Login_View