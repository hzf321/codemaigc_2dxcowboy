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
	HttpManager:getInstance():doReport(ReportConfig.view_lobby)
end

function Lobby_Scene:onEnter()
	Scene.onEnter(self)
	if self.isFromTheme then
		self:addBgSpine()
	else
		self:loadingAnim()
	end
end

function Lobby_Scene:initLayout()

    local layer = Lobby_View.new(self.isFromTheme)
    self:addChild(layer, 2)
	layer:setPosition(FRAME_HEIGHT / 2, FRAME_WIDTH / 2)
 
    local header = Header_Node.new(nil, false)		
	User:getInstance():setHeader(header)
	header:setPosition(FRAME_HEIGHT / 2, FRAME_WIDTH  - 50)
	header:enterAction(0.5)
	header:setScale(HEADER_FOOTER_SCALE)
	self:addChild(header,3)

	local footer = Footer_Node.new(nil, false)		
	footer:setPosition(FRAME_HEIGHT / 2, 70)
	footer:setScale(HEADER_FOOTER_SCALE)
	footer:enterAction(0.5)
	self:addChild(footer, 4)
  

end

function Lobby_Scene:onExit( ... )
	Scene.onExit(self)
end

-- play ----- 加载动画
function Lobby_Scene:addBgSpine()
	self.__layer:setPosition(0,0)
	self.__layer:setLocalZOrder(5)
	local path = string.format("login/spines/tansition/spine")
	local winSize = cc.Director:getInstance():getWinSize()
	bole.playSounds("guafeng")
	local _, bg_spine = bole.addSpineAnimation(self.__layer, 5, path, cc.p(winSize.width / 2, winSize.height / 2), "1_chuxian", nil, nil, nil, true, false, nil)
    bg_spine:registerSpineEventHandler( function(event)
        if event.animation == "1_chuxian" then
			self:initLayout()
            bg_spine:setAnimation(1, "2_loop", false) 
        elseif event.animation == "2_loop"  then
			bole.playSounds("sanfeng")
			bg_spine:setAnimation(1, "3_stop", false) 
			bg_spine:runAction(
				cc.Sequence:create(
					cc.DelayTime:create(1),
					cc.RemoveSelf:create()
				)
			)
        end	
    end, sp.EventType.ANIMATION_COMPLETE)

	    
	
	self:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(4),
   			cc.CallFunc:create(function ()
				if User:getInstance():getCoins() < 500000 then
					PopupController:getInstance():popupDialogDirectly("freecoins")
				end
    		end)
		)
	)
end

-- loading --- 加载动画
function Lobby_Scene:loadingAnim()
	self.__layer:setPosition(0,0)
	self.__layer:setLocalZOrder(5)

	local path = string.format("login/spines/tansition/spine")
	local winSize = cc.Director:getInstance():getWinSize()
	local _, bg_spine = bole.addSpineAnimation( self.__layer, 5, path, cc.p(winSize.width / 2, winSize.height / 2), "2_loop", nil, nil, nil, true, false, nil)
	bg_spine:registerSpineEventHandler( function(event)
        if event.animation == "2_loop" then
			bole.playSounds("sanfeng")
            bg_spine:setAnimation(1, "3_stop", false) 
        	self:initLayout()
        end
    end, sp.EventType.ANIMATION_COMPLETE)
    
	
	self:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(4),
   			cc.CallFunc:create(function ()
        		if not User:getInstance():isGiftCollected() then
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
