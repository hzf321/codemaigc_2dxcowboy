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
    self:initAnim()
    self:configThemeScrollView()
end

function Lobby_View: initAnim()
    self.root.themePlay.rukou:removeFromParent()
    local path = string.format("lobby/spines/rukouBg/spine")
    bole.addSpineAnimation( self.root.themePlay, 0, path, cc.p(0,0), "animation", nil, nil, nil, true, true, nil)
    local path = string.format("lobby/spines/rukouKing/spine")
    bole.addSpineAnimation( self.root.themePlay, 0, path, cc.p(0,0), "animation", nil, nil, nil, true, true, nil)
    self.root:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(2),
   			cc.CallFunc:create(function ()
				local path = string.format("lobby/spines/bg/spine")
				bole.addSpineAnimation(  self.root.animBox, 0, path, cc.p(0,0), "animation", nil, nil, nil, true, true, nil)

      
    		end)
		)
	)
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
        theme_sv:setInnerContainerSize({width = svSize.width, height = 5 * 350 })
        
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

-- 进入游戏
function Lobby_View:onBtnEnterClicked()
	local Play_Scene = require (bole.getDesktopScenePath("Play"))
    local scene = Play_Scene.new(THEME_DESKTOP_ID, "")
	bole.playSounds("click")
	bole.stopMusic ("hallbg")
    scene:run()
    HttpManager:getInstance():doReport(ReportConfig.btn_theme_lobby)
end
 

return Lobby_View