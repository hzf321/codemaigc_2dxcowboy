


local ThemeMysteriousPixies_BGPickNumView = class("ThemeMysteriousPixies_BGPickNumView")
local cls = ThemeMysteriousPixies_BGPickNumView

function cls:ctor( vCtl, nodesList)
	self.vCtl = vCtl
	self.node = cc.Node:create()
	self.vCtl:curSceneAddToContent(self.node)

	self.gameConfig = self.vCtl:getGameConfig()
	self.config = self.gameConfig.pick_config

	self:_initLayout(nodesList)
end

function cls:_initLayout( nodesList )

	self.pickParent 	= nodesList[1]

	self:initPickNode()
end

function cls:initPickNode( ... )
	local path 		= self.vCtl:getCsbPath("pick_num")
   	self.pickNode 	= cc.CSLoader:createNode(path)
   	self.pickRoot 	= self.pickNode:getChildByName("root")
   	self.dimmer 	= self.pickRoot:getChildByName("common_black")
   	self.animBg 	= self.pickRoot:getChildByName("anim_bg")
   	self.pickItemNode = self.pickRoot:getChildByName("pick_items")
   	local pickItems = self.pickItemNode:getChildren()
   	self.dimmer:setOpacity(0)

   	self.canPick = false
   	local function btnOnTouch(obj, eventType)
   		if not self.canPick then return end
	    if eventType == ccui.TouchEventType.ended then
	    	self.canPick = false

			self:showPickResult(obj.index)
	    end
	end
	
	self.pickList = {}
   	for i, node in pairs(pickItems) do 
   		self.pickList[i] = node

   		self.pickList[i].btn = node:getChildByName("btn")
   		self.pickList[i].btn.index = i
   		self.pickList[i].btn:addTouchEventListener(btnOnTouch)

		local data = {}
		data.file = self.vCtl:getSpineFile(string.format("pick_num_item%s", i))
		data.parent = node
		data.animateName = "animation1"
		data.isLoop = true
		data.zOrder = -1
		local _, s = bole.addAnimationSimple(data)
		self.pickList[i].bg = s

		self.pickList[i].num_sp = node:getChildByName("num")
		self.pickList[i].num_sp:setVisible(false)

		node:setVisible(false)
   	end

   	self.pickParent:addChild(self.pickNode)
   	self.pickNode:setVisible(false)
end

function cls:showNumPickNode( tryResume )
	self.pickNode:setVisible(true)
	local showBgDelay = 30/30-- 90/30

	local data = {}
	data.file = self.vCtl:getSpineFile("pick_num_bg")
	data.parent = self.animBg
	data.animateName = "animation"
	data.isRetain = true
	local _, s = bole.addAnimationSimple(data)
	self.bgSpine = s

	local data = {}
	data.file = self.vCtl:getSpineFile("pick_num_lb")
	data.parent = self.animBg
	data.animateName = "animation2_1"
	data.isRetain = true
	data.pos = cc.p(0, -234)
	local _, lbs = bole.addAnimationSimple(data)
	self.bgLb = lbs
	
	local delay = self:showPickItem(showBgDelay, tryResume)
    if tryResume then 
    	self.dimmer:setOpacity(self.config.dimmer_end)
    	self.bgSpine:setAnimation(0, "animation2", true)
    	self.bgLb:setAnimation(0, "animation1", true)
    else
    	self.vCtl:playMusicByName("pick_appear")

    	self.dimmer:runAction(cc.FadeTo:create(0.3, self.config.dimmer_end))

    	self.bgSpine:addAnimation(0, "animation2", true)
    	self.bgLb:addAnimation(0, "animation1", true)

	    self.node:runAction(cc.Sequence:create(
			cc.DelayTime:create(delay),
			cc.CallFunc:create(function ( ... )
				self:openPickBtnEvent()
			end)))
	end
end

function cls:showPickItem( addDelay, tryResume )
	addDelay = addDelay or 0
	local delay = addDelay
	if tryResume then 
		for i, item in pairs(self.pickList) do 
			item:stopAllActions()
			item:setScale(1)
			item:setVisible(true)
		end
	else
		for i, item in pairs(self.pickList) do 
			item:stopAllActions()
			item:setScale(0)
			item:setVisible(true)
			item:runAction(
				cc.Sequence:create(
					cc.DelayTime:create(delay),
					cc.ScaleTo:create(0.3, 1.2),
					cc.ScaleTo:create(0.1, 1)
				)
			)
			delay = delay + self.config.item_show_delay
		end

		if delay and delay > addDelay then 
			delay = delay + self.config.item_show_time
		end
	end

	return delay
end

function cls:openPickBtnEvent( ... )
	self.canPick = true
end

function cls:showPickResult( index )
	self.vCtl:playMusicByName("reward_reveal")
	if bole.isValidNode(self.bgSpine) then 
		self.bgSpine:setAnimation(0, "animation3", false)
		self.bgSpine:addAnimation(0, "animation2", true)
	end

	if bole.isValidNode(self.bgLb) then 
		self.bgLb:setAnimation(0, "animation1_1", false)
		self.bgLb:addAnimation(0, "animation2", true)
	end

	self.vCtl:setPickResultPos(index)

	if bole.isValidNode(self.pickList[index]) then

		local pickResult = self.vCtl:getPickResult()
		self.vCtl:playMusicByName("reward_congrat"..pickResult)

		local item = self.pickList[index]
		local data = {}
		data.file = self.vCtl:getSpineFile("pick_num_open")
		data.parent = self.pickList[index]
		bole.addAnimationSimple(data)

		if bole.isValidNode(item.bg) then 
			item.bg:setAnimation(0, "animation2", false)
			item.bg:addAnimation(0, "animation3", true)
		end

		if bole.isValidNode(item.num_sp) then 
			item.num_sp:runAction(
				cc.Sequence:create(
					cc.DelayTime:create(5/30),
					cc.CallFunc:create(function ( ... )
						bole.updateSpriteWithFile(item.num_sp, string.format("#theme231_p1_num%s.png", pickResult))
					end),
					cc.Show:create()
					))
		end
	end

	self.node:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(2),
			cc.CallFunc:create(function ( ... )
				self:showOtherResult()
			end)))
end

function cls:showOtherResult( ... )
	local otherResultList, overPos = self.vCtl:getOtherResult()

	for index, node in pairs(self.pickList) do
		if index ~= overPos and table.nums(otherResultList) then 
			local value = table.remove(otherResultList, 1)

			if self.pickList[index] then
				self.pickList[index]:setColor(cc.c3b(125, 125, 125))

				local item = self.pickList[index]
				if bole.isValidNode(item.bg) then 
					item.bg:setAnimation(0, "animation2", false)
				end
				if bole.isValidNode(item.num_sp) then 
					bole.updateSpriteWithFile(item.num_sp, string.format("#theme231_p1_num%s.png", value))
					item.num_sp:setVisible(true)
				end
			end
		end
	end

	self.node:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(2),
			cc.CallFunc:create(function ( ... )
				self:closeNumPickNode()
			end),
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function ( ... )
				self.vCtl:isOverPickGame()
			end)))
end

function cls:closeNumPickNode( ... )
	self.pickNode:runAction(
		cc.Sequence:create(
			cc.FadeOut:create(0.3),
			cc.RemoveSelf:create()))
end

return cls



