local Lobby_View  = require (bole.getDesktopFilePath("Lobby/Lobby_View"))
local Header_Node = require (bole.getDesktopFilePath("HeaderFooter/Header_Node"))
local Footer_Node = require (bole.getDesktopFilePath("HeaderFooter/Footer_Node"))

local Lobby_Scene = class("Lobby_Scene", Scene)

function Lobby_Scene:ctor(from, enterlobby_callback)
	self.isFromTheme = from == "Play"
    self.sceneName   = "Lobby_Scene"
	self.enterlobby_callback = enterlobby_callback
	bole.playBGM ("hallbg")
	Scene.ctor(self)
	HttpManager:getInstance():doReport(ReportConfig.view_lobby)
end

function Lobby_Scene:onEnter()
	Scene.onEnter(self)
	if self.isFromTheme then
		self:addBgSpine()
 
	else
		self:initLayout()
	end
end

function Lobby_Scene:initLayout()
    local layer = Lobby_View.new(self.isFromTheme)
    self.__layer:addChild(layer, 1)

	local header = Header_Node.new(nil, false)		
	User:getInstance():setHeader(header)
	header:setPosition(0, 360)
	header:enterAction(self.isFromTheme)
	header:setScale(HEADER_FOOTER_SCALE)
	self.__layer:addChild(header, 2)

	local footer = Footer_Node.new(nil, false)		
	footer:setPosition(0, -360)
	footer:setScale(HEADER_FOOTER_SCALE)
	footer:enterAction(self.isFromTheme)
	self.__layer:addChild(footer, 3)

end

function Lobby_Scene:onExit( ... )
	Scene.onExit(self)
end

-- 加载动画
function Lobby_Scene:addBgSpine()
	local path = string.format("lobby/spines/bg/spine")
	local _, bg_spine = bole.addSpineAnimation(self.__layer, 5, path, cc.p(0,0), "loading", nil, nil, nil, true, false, nil)
	bg_spine:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(0.1),
			cc.CallFunc:create(function ()
				self:initLayout()
			end),
			cc.DelayTime:create(0.9),
			cc.CallFunc:create(function ()
				bg_spine:setAnimation(0, "lichang", false)
			end),
			cc.DelayTime:create(1),
			cc.CallFunc:create(function ()
				if User:getInstance():getCoins() < 500000 then
					PopupController:getInstance():popupDialogDirectly("freecoins")
				end
			end),
	 
			cc.RemoveSelf:create()
		)
	)
end

function Lobby_Scene:addToGuide( node, zorder )
	self.__layer:addChild(node, zorder)
end

return Lobby_Scene
