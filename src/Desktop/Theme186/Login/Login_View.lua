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
    local logoAnim = self.root.logoAnim:setVisible(false)
    local btnAnim = self.root.btnAnim:setVisible(false)
    local btn_play = self.root.btn_play:setVisible(false)
    self.root.tansitionAnim:setVisible(false)
    logoAnim:setAnimation(1, "animation", true) 

    -- 背景动画
    local readBg = self.root.rearBg
    readBg:setAnimation(1, "Transition", false)  
    readBg:registerSpineEventHandler( function(event)
        if event.animation == "Loading" then
            readBg:setAnimation(1, "Loading", true) 
        end
    end, sp.EventType.ANIMATION_COMPLETE)

    -- 人物
    logoAnim:setVisible(true)
    logoAnim:setScale(2.6)
    logoAnim:setOpacity(0)
    logoAnim:setPositionY(-1100)
    logoAnim:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(4),
            cc.CallFunc:create(function ()
                bole.playSounds("suofang")
            end),
            cc.Spawn:create(
                cc.FadeIn:create(0.6),
                cc.ScaleTo:create(0.6,1),
                cc.MoveTo:create(0.6, cc.p(0,0))
            )
        )
    )
    -- 按钮
    btnAnim:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(4.3),
            cc.CallFunc:create(function ()
                btnAnim:setVisible(true)
                btn_play:setVisible(true)
                btnAnim:setAnimation(1, "chuxian", false) 
                btnAnim:registerSpineEventHandler( function(event)
                    if event.animation == "chuxian" then
                        btnAnim:setAnimation(1, "loading", true) 
                    end
                end, sp.EventType.ANIMATION_COMPLETE)
            end)
        )
    )

end
 

function Login_View:onBtnPlayClicked()
    Admop:getInstance():setCallback()
	HttpManager:getInstance():doReport(ReportConfig.btn_login)
    bole.playSounds("click")
    self.root.btn_play:setTouchEnabled(false)
    local bg_spine = self.root.tansitionAnim
    bg_spine:setVisible(true)
    bole.playSounds("guafeng")
    bg_spine:setAnimation(1, "1_chuxian", false) 
    bg_spine:registerSpineEventHandler( function(event)
        if event.animation == "1_chuxian" then
            local Lobby_Scene = require (bole.getDesktopScenePath("Lobby"))
            local scene = Lobby_Scene.new()
            scene:run()
            -- bg_spine:setAnimation(1, "2_loop", false) 
        elseif event.animation == "2_loop"  then
            -- bg_spine:setAnimation(1, "3_stop", false) 
            -- local Lobby_Scene = require (bole.getDesktopScenePath("Lobby"))
            -- local scene = Lobby_Scene.new()
            -- scene:run()
        end
    end, sp.EventType.ANIMATION_COMPLETE)
    
    -- local Lobby_Scene = require (bole.getDesktopScenePath("Lobby"))
    -- local scene = Lobby_Scene.new()
    -- scene:run()
end


return Login_View