local Lobby_View  = require (bole.getDesktopFilePath("Lobby/Lobby_View"))
local Header_Node = require (bole.getDesktopFilePath("HeaderFooter/Header_Node"))
local Footer_Node = require (bole.getDesktopFilePath("HeaderFooter/Footer_Node"))

local Lobby_Scene = class("Lobby_Scene", Scene)

function Lobby_Scene:ctor(from, enterlobby_callback)
	self.isFromTheme = from == "Play"
    self.sceneName   = "Lobby_Scene"
	self.enterlobby_callback = enterlobby_callback
	bole.playBGM ("hallbg")
	local screenCtl = ScreenControl:getInstance()
    screenCtl:setScreenOrientation(true)

	Scene.ctor(self)
	self:initLayout()
	HttpManager:getInstance():doReport(ReportConfig.view_lobby)
end

function Lobby_Scene:onEnter()
	Scene.onEnter(self)
	-- if self.isFromTheme then
	-- 	self:addBgSpine()
	-- else
	-- 	self:loadingAnim()
	-- end
end

function Lobby_Scene:initLayout()

    self.layer = Lobby_View.new(self.isFromTheme)
    self:addChild(self.layer, 2)
	self.layer:setPosition(FRAME_HEIGHT / 2, FRAME_WIDTH / 2)

	local animDelaytime = 0
	local enterDelaytime = 0
	if self.isFromTheme then
		animDelaytime = 0
		enterDelaytime = 0
		self:addBgSpine()
	else
		self:newhandGuide()
		enterDelaytime = 0.5
		animDelaytime = 1
	end

	if User:getInstance():isGiftCollected() then
		self.layer:hideNoClick()
	end

	self:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(animDelaytime),
            cc.CallFunc:create(function ()
				local header = Header_Node.new(nil, false)		
				User:getInstance():setHeader(header)
				header:setPosition(FRAME_HEIGHT / 2, FRAME_WIDTH  - 50)
				header:enterAction(enterDelaytime)
				header:setScale(HEADER_FOOTER_SCALE)
				self:addChild(header,3)
			
				local footer = Footer_Node.new(nil, false)		
				footer:setPosition(FRAME_HEIGHT / 2, 70)
				footer:setScale(HEADER_FOOTER_SCALE)
				footer:enterAction(enterDelaytime)
				self:addChild(footer, 4)
        end)
    ))

 
  

end

function Lobby_Scene:onExit( ... )
	Scene.onExit(self)
end

-- play ----- 加载动画
function Lobby_Scene:addBgSpine()
 
	self:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(1),
   			cc.CallFunc:create(function ()
				if User:getInstance():getCoins() < 500000 then
					PopupController:getInstance():popupDialogDirectly("freecoins")
				end
    		end)
		)
	)
end

-- loading --- 加载动画
function Lobby_Scene:newhandGuide()
	
	self:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(2.5),
   			cc.CallFunc:create(function ()
        		if not User:getInstance():isGiftCollected() then
					self.layer:hideNoClick()
					self.layer:showBtnEnter()
					PopupController:getInstance():popupDialogDirectly("gift")
				end
    		end)
		)
	)
end

function Lobby_Scene:addToGuide( node, zorder )
	self.__layer:addChild(node, zorder)
end

return Lobby_Scene
