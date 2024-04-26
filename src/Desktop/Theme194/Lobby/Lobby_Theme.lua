local BLNode      = require("UI/CreatorUI/BLNode")
local isValidNode = libUI.isValidNode

local getSpinePath = function(name)
	return string.format("theme_desktop/theme%d/lobby/spines/%s/spine", THEME_DESKTOP_ID, name)
end

local Lobby_Theme = class("Lobby_Theme", BLNode)

function Lobby_Theme:ctor(index, groupNum)
    BLNode.ctor(self)
	self.index      = index or 1
	self.groupNum 	= groupNum or 1
	self.is_lock    = self.index > 1 --是否解锁
	self.is_comming = self.index > 11 -- 即将上线
	self.csb        = string.format("ui/lobby/lobby_theme%s", self.is_lock and "_lock" or "")
    self.node       = CreatorUITools:getInstance():createUi(self.csb)
	self:addChild(self.node)
    self:initButtonListToNode(false)

	self:loadControls()
end

function Lobby_Theme:loadControls()
	self.root = self.node.root

	self:initPos()
	self:initLockNode()
	self:updateLogo()


	local btn_enter = self.root.btn_enter
	if btn_enter then
		btn_enter:setSwallowTouches(false)
	end

end

-- 初始化位置
function Lobby_Theme:initPos()
	local poxX
	local poxY
	if self.index % 2 == 0 then
		poxX = 170
	else
		poxX = 510
	end
 
	local posY =  1950 - (self.groupNum * 350)
	self:setPosition(cc.p(poxX, posY))
end

-- 初始化lock 
function Lobby_Theme:initLockNode()
	if not self.is_lock then return end
	
	local tip_node = self.root.tip_node
	if tip_node then
		bole.setEnableRecursiveCascading(tip_node, true)
		tip_node:setVisible(false)

		local label_diamonds = tip_node.label_diamonds
		if label_diamonds then
			local diamonds = (self.index - 2) * 300 + 500
			label_diamonds:setString(diamonds)
		end
	end

	local btn_lock = self.root.btn_lock
	if btn_lock then
		btn_lock:setSwallowTouches(false)
		btn_lock:setVisible(not self.is_comming)  -- 即将上线的，隐藏点击按钮
	end

	local lock_spine = self.root.lock_spine
	if lock_spine then
		lock_spine:setVisible(not self.is_comming)  -- 即将上线的，隐藏点击锁住按钮
	end
end

-- 刷新logo
function Lobby_Theme:updateLogo()
	if not self.is_lock then return end
	local theme_logo = self.root.theme_logo
	if theme_logo then
		bole.updateSpriteWithFile(theme_logo, string.format("#rukou_%d.png", self.index))
	end
end 

-- 入场动画
function Lobby_Theme:enterAction()
	if self.index > 4 then
		self:setVisible(false)
	end
	local delayTime  = 0.25 + self.index * 0.2
	local posX, posY = self:getPosition()
	self:setPositionX(posX - 1500)
	self:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(delayTime),
			cc.MoveTo:create(0.8, cc.p(posX, posY)),
			cc.CallFunc:create(function ()
				if self.index < 6 then
					if not User:getInstance():isGiftCollected() then
						PopupController:getInstance():popupDialogDirectly("gift")
					end
				end
			end),
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function()
				self:setVisible(true)
				-- 避免机台动画造成卡顿，先加载静态图片，入场动画结束后再加载动画
				local theme_logo = self.root.theme_logo
				if not self.is_lock and theme_logo then
				
					theme_logo:removeFromParent()
					bole.addSpineAnimation(self, nil, getSpinePath("logo"), cc.p(-7.5,-31.5), "animation", nil, nil, nil, true, true, nil)
				end
				-- if not User:getInstance():isGiftCollected() then
				-- 	PopupController:getInstance():popupDialogDirectly("gift")
				-- end
			end)
		)
	)
end

function Lobby_Theme: logoAnim()
	if self.index == 1 then
		self.root.theme_logo:removeFromParent()
	  	local x, q = 	bole.addSpineAnimation(self.root, nil, getSpinePath("logo"), cc.p(-7.5,-31.5), "animation", nil, nil, nil, true, true, nil)
	end
end

-- 显示气泡窗  
function Lobby_Theme:onBtnLockClicked()
	bole.playSounds("suolian")
	
	local theme = self:getParent():getChildren()[10]
	if theme then
		local tips = theme.root.tips
		if tips then
			tips:setVisible(false)	
		end
	end

	local func = function()
		local tip_node = self.root.tip_node
		if tip_node then
			tip_node:setVisible(true)
			tip_node:stopAllActions()
			tip_node:setOpacity(0)
			tip_node:setScale(0)
			tip_node:runAction(
				cc.Sequence:create(
					cc.Spawn:create(cc.FadeIn:create(0.2), cc.ScaleTo:create(0.2, 1)),
					cc.DelayTime:create(1.5),
					cc.Spawn:create(cc.FadeOut:create(0.2), cc.ScaleTo:create(0.2, 0)),
					cc.CallFunc:create(function ()
						tip_node:setVisible(false)
					end)
				)
			)
		end
		HttpManager:getInstance():doReport(ReportConfig.btn_theme_other_lobby)
	end
 



	local lock_spine = self.root.lock_spine
	if lock_spine then
		local lock = lock_spine:getChildren()[1] 
		local sequence = cc.Sequence:create(
			cc.ScaleTo:create(0.2,1.1),
			cc.RotateTo:create(0.1, 15),
			cc.RotateTo:create(0.1, 0),
			cc.RotateTo:create(0.1, -15),
			cc.RotateTo:create(0.1, 0),
			cc.RotateTo:create(0.1, 15),
			cc.RotateTo:create(0.1, 0),
			cc.RotateTo:create(0.1, -15),
			cc.RotateTo:create(0.1, 0),
			cc.ScaleTo:create(0.2,1),
			cc.CallFunc:create(function ()
				func()
			end)
		)
		lock:runAction(sequence)
	end
end

 


return Lobby_Theme