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
    local svSize     = cc.size(1280, 720)
    local theme_sv   = self.root.theme_sv
    if theme_sv then
        theme_sv:setContentSize(svSize)
        theme_sv:setScrollBarEnabled(false)
        theme_sv:setBounceEnabled(true)
        theme_sv:setInertiaScrollEnabled(true)
        theme_sv:setDirection(ccui.ScrollViewDir.horizontal)
        theme_sv:setInnerContainerSize({width = themeCount * 320, height = svSize.height})

        for index = 1, themeCount do
            local theme_node = Lobby_Theme.new(index)
            theme_sv:addChild(theme_node)
            theme_node:setLocalZOrder(themeCount - index)
            if not self.isFromTheme then
                theme_node:enterAction()
            else
                theme_node:logoAnim()
            end
        end
    end

end


-- 从登录界面进入大厅，入场动画
function Lobby_View:enterActions ()
    if self.isFromTheme then 
        self:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(0.5),
                cc.CallFunc:create(function ()
                    if User:getInstance():getCoins() < 500000 then
                        PopupController:getInstance():popupDialogDirectly("freecoins")
                    end
                end)
            )
        )
        return 
    end
    local cloudAnim = self.root.cloudAnim
   
    if cloudAnim then
        cloudAnim:setVisible(true)
        cloudAnim:setAnimation(1, "disappear", false) 
        cloudAnim:registerSpineEventHandler( function(event)
            if event.animation == "disappear" then
                cloudAnim:setVisible(false)
            end
        end, sp.EventType.ANIMATION_COMPLETE)
    end
end

return Lobby_View