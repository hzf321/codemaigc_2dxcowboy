local BLNode 		   = require("UI/CreatorUI/BLNode")
local CreatorTableView = require("UI/CreatorUI/CreatorTableView")
local Lobby_Theme      = require (bole.getDesktopFilePath("Lobby/Lobby_Theme"))

local Lobby_View = class("Lobby_View", BLNode)


function Lobby_View:ctor(isFromTheme)
    self.isFromTheme = isFromTheme
    self.csb         = "ui/lobby/lobby_view"
    self.csbName     = "lobby_view"
    self.node        = CreatorUITools:getInstance():createUi(self.csb);
    self:addChild(self.node)
    self:initButtonListToNode(false)
    self:loadControls()
end

function Lobby_View:loadControls()
    self.root = self.node.root
    self:configThemeScrollView()
    self:enterActions()
end

-- 机台列表  
function Lobby_View:configThemeScrollView()
    local themeCount = 10
    local svSize     = cc.size(677, 550)
    local theme_sv   = self.root.theme_sv
    if theme_sv then
        theme_sv:setContentSize(svSize)
        theme_sv:setScrollBarEnabled(false)
        theme_sv:setBounceEnabled(true)
        theme_sv:setInertiaScrollEnabled(true)
        theme_sv:setDirection(ccui.ScrollViewDir.vertical)
        theme_sv:setInnerContainerSize({width = svSize.width, height = 5 * 355 })
        
        local groupNum = 0
        local count = 0
        for index = 2, themeCount do
            self.root:runAction(
                cc.Sequence:create(
                    cc.DelayTime:create((index - 1) * 0.05),
                    cc.CallFunc:create(function ()
                        local theme_node = Lobby_Theme.new(index, groupNum)
                        theme_sv:addChild(theme_node)
            
                        count = count + 1
                        if count == 2 then
                            count = 0
                            groupNum = groupNum + 1
                        end
                        theme_node:setLocalZOrder(themeCount - index)
                    end)
                )
            )
        end
    end


end


-- 从登录界面进入大厅，入场动画
function Lobby_View:enterActions ()
    
    local bg_node = self.root.bg_node
    if bg_node then
        if self.isFromTheme then
            if bg_node.bg_temp then
                bg_node.bg_temp:removeFromParent()
                 
            end
            if bg_node.lobby_bg then
                bg_node.lobby_bg:setPositionY(0)
            end
            return 
        end

     

        bg_node:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(0.15),
                cc.CallFunc:create(function()
                    bole.playSounds("zhuanchang")
                end)
            )
        )
        bg_node:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(0.3),
                cc.Spawn:create(
                    cc.MoveTo:create(0.9,cc.p(0, 3120)),
                    cc.ScaleTo:create(0.9, 1),
                    cc.Sequence:create(
                        cc.ScaleTo:create(0.2, 1.5),
                        cc.DelayTime:create(0.3),
                        cc.CallFunc:create(function()
                        end),
                        cc.ScaleTo:create(1, 1),
                        cc.CallFunc:create(function()
                            if bg_node and bg_node.bg_temp then
                                bg_node.bg_temp:removeFromParent()
                            end
                        end)
                )
            )
            )
        )
    end


    local btn_enter = self.root.btn_enter
    local themePlay = self.root.themePlay
    local theme_sv = self.root.theme_sv

	btn_enter:setVisible(false)
	themePlay:setVisible(false)
    theme_sv:setVisible(false)

    btn_enter: setPosition(0,1000)
    themePlay: setPosition(0,1000)
    theme_sv: setPosition(0,-1000)

    self:runAction(cc.Sequence:create(
        cc.DelayTime:create(1.2),
        cc.CallFunc:create(function ()
            btn_enter:setVisible(true)
	        themePlay:setVisible(true)
            theme_sv:setVisible(true)
            btn_enter:runAction(
                cc.Sequence:create(
                    cc.MoveTo:create(0.5,cc.p(0, 230)),
                    cc.MoveTo:create(0.1,cc.p(0, 270)),
                    cc.MoveTo:create(0.1,cc.p(0, 250))
                )
            )

            themePlay:runAction(
                cc.Sequence:create(
                    cc.MoveTo:create(0.5,cc.p(0, 230)),
                    cc.MoveTo:create(0.1,cc.p(0, 270)),
                    cc.MoveTo:create(0.1,cc.p(0, 250))
                )
            )
          
        end)
    ))
    
    theme_sv:runAction(cc.Sequence:create(
        cc.DelayTime:create(1),
        cc.CallFunc:create(function ()
            theme_sv:setVisible(true)
        end),
        cc.MoveTo:create(0.5,cc.p(0, -210))
    ))
end


function Lobby_View:onBtnEnterClicked ()
    local Play_Scene = require (bole.getDesktopScenePath("Play"))
    local scene = Play_Scene.new(THEME_DESKTOP_ID, "")
	bole.playSounds("click")
	bole.stopMusic ("hallbg")
    scene:run()
    HttpManager:getInstance():doReport(ReportConfig.btn_theme_lobby)
end
    

function Lobby_View:hideNoClick()
    local noclick = self.root.noclick
	noclick:setVisible(false)
end



return Lobby_View