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
end
 
function Login_View:loadControls()

    local login_bg =  self.root.login_bg
    local login_man =  self.root.login_man
    local btn_play = self.root.btn_play
    local mist = self.root.mist
    mist:setVisible(false)
    login_man:setVisible(false)
    btn_play:setVisible(false)
    login_bg:setScaleX(-1.2)
    login_bg:setScaleY(1.2)
    local sequence = cc.Sequence:create(cc.ScaleTo:create(1,-2.5,2.5),cc.ScaleTo:create(0.5,-1,1), cc.CallFunc:create(function ()
        mist:setVisible(true)
        mist:setOpacity(0)
        mist:runAction(   cc.FadeIn:create(1))
        login_man:setVisible(true)
        login_man:setScale(0)
        local sequenceMan = cc.Sequence:create(cc.ScaleTo:create(0.23,-1.2, 1.2),cc.ScaleTo:create(0.1,-1,1),cc.CallFunc:create(function ()
            self:playStarAnimMan()
            btn_play:setVisible(true)
            btn_play:setScale(0)
            local sequenceBtn = cc.Sequence:create(
                cc.ScaleTo:create(0.2,1),
                cc.CallFunc:create(function ()
                    self: playStarAnimBtn()
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

--播放人物星星闪烁
function Login_View:playStarAnimMan()
    local login_man =  self.root.login_man
    local star_man = login_man:getChildren()[1] 
    star_man:setAnimation(0, "animation", false)
    local forever =  cc.RepeatForever:create(
        cc.Sequence:create(
            cc.DelayTime:create(2),
            cc.CallFunc:create(function ()
                if star_man then
                    local randomNum = self:getRandomNum(1,2)
                    print(randomNum)
                    local animName = ""
                    if randomNum == 1 then
                        animName = "animation"
                    else
                        animName = "animation2"
                    end
                    star_man:setAnimation(0, animName, false)
                end
            end)
        )
    )
    star_man:runAction(forever)
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
                    local x = self:getRandomNum(-150, 150)
                    local y = self:getRandomNum(-50, 50)
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
    
    local btn_play = self.root.btn_play
    btn_play:setTouchEnabled(false)
    btn_play:stopAllActions()
    bole.playSounds("click")
 
    local seq = cc.Sequence:create(cc.ScaleTo:create(0.1,1.1),cc.ScaleTo:create(0.3,0),     cc.DelayTime:create(0.1),cc.CallFunc:create(function ()
        if btn_play then
            btn_play:setVisible(false)
        end
        HttpManager:getInstance():doReport(ReportConfig.btn_login)
        local Lobby_Scene = require (bole.getDesktopScenePath("Lobby"))
        local scene = Lobby_Scene.new()
        scene:run()
    end))

    btn_play:runAction(seq)
end
 

return Login_View