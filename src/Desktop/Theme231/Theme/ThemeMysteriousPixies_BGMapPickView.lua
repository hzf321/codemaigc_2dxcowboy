


local ThemeMysteriousPixies_BGMapPickView = class("ThemeMysteriousPixies_BGMapPickView")
local cls = ThemeMysteriousPixies_BGMapPickView

local pickItemView = require (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_BGMPickItemView"))   

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

	self.collectParent 	= cc.Node:create()
    self.vCtl:curSceneAddToTop(self.collectParent)

	self:initPickNode()
end

function cls:initPickNode( ... )
	local path 			= self.vCtl:getCsbPath("map_pick")
   	self.pickNode 		= cc.CSLoader:createNode(path)
   	self.animBg 		= self.pickNode:getChildByName("anim_bg")
   	self.pickItemParent = self.pickNode:getChildByName("pick_items")
   	self.pickCntNode 	= self.pickNode:getChildByName("cnt_node")
   	self.pickCntLb 		= self.pickCntNode:getChildByName("num")

   	self.pickParent:addChild(self.pickNode)
   	self.pickNode:setVisible(false)
end

function cls:initPickItems( state_list )
	self.pickItemParent:removeAllChildren()
	self.pickItemList = {}
	local item_config = self.config.item_config
   	for i = 1, self.config.item_max do 

   		local pos = self.vCtl:getPickItemPos(i)

		local node = cc.Node:create()
		node:setPosition(pos)
		self.pickItemParent:addChild(node)
		node:setVisible(false)

		local temp = pickItemView.new(self.vCtl, node, i)
		local dataInfo = state_list[i]
		temp:createItem(dataInfo)
		self.pickItemList[i] = temp
   	end
end

function cls:showPickNode( pageLevel, tryResume )
	self.pickNode:setVisible(true)

	local data = {}
	data.file = self.vCtl:getSpineFile("map_pick_bg")
	data.parent = self.animBg
	data.animateName = "animation"..pageLevel
	data.isRetain = true
	local _, s = bole.addAnimationSimple(data)
	self.bgSpine = s

	local showBgDelay = 40/30
	
	local delay = self:showPickItem(showBgDelay, tryResume)
	if tryResume then -- 直接切循环
		self.bgSpine:setAnimation(0, "animation"..pageLevel.."_1", true)
		self.vCtl:changeJPZorder( 1 )
	else
		self.bgSpine:addAnimation(0, "animation"..pageLevel.."_1", true)
		self.vCtl:playMusicByName("book_appear")

		self.node:runAction(cc.Sequence:create(
			cc.DelayTime:create(delay),
			cc.CallFunc:create(function ( ... )
				self.vCtl:addData("over_pick_show", true)

				self.vCtl:openPickBtnEvent()
				self.vCtl:changeJPZorder( 1 )
			end)))
	end
	
end

function cls:showPickItem( addDelay, tryResume )
	addDelay = addDelay or 0
	local delay = addDelay
	if tryResume then 
		self.pickCntNode:stopAllActions()
		self.pickCntNode:setVisible(true)
		self.pickCntNode:setOpacity(255)

		for i, item in pairs(self.pickItemList) do 
			item.node:stopAllActions()
			item.node:setScale(1)
			item.node:setVisible(true)
		end
	else

		for i, item in pairs(self.pickItemList) do 

			if i%self.config.item_config.col_count == 1 then 
				delay = addDelay
			end

			item.node:stopAllActions()
			item.node:setScale(0)
			item.node:setVisible(true)
			item.node:runAction(
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

		self.pickCntNode:stopAllActions()
		self.pickCntNode:setVisible(true)
		self.pickCntNode:setOpacity(0)
		self.pickCntNode:runAction(
			cc.Sequence:create(
				cc.DelayTime:create(delay),
				cc.FadeIn:create(0.5)))

		delay = delay + 0.5
	end

	return delay
end

function cls:changePickGameTipState( show )
	if show then 
		if self.isShowItemTip then return end
		self.isShowItemTip = true

		self.pickNode:stopAllActions()
		self.pickNode:runAction(
			cc.RepeatForever:create(
				cc.Sequence:create(
					cc.CallFunc:create(function ( ... )
						local tipList = self.vCtl:getNextNoPickPos()
						for _, index in pairs(tipList) do 
							if self.pickItemList[index] then 
								self.pickItemList[index]:playLoopTipAnim(index)	
							end
						end
						
					end),
					cc.DelayTime:create(3)
				)
			)
		)
	else
		self.isShowItemTip = false
		self.pickNode:stopAllActions()
	end
end

function cls:updatePickLeft( num, isAnim )
	self.pickCntLb:stopAllActions()

	if isAnim then 
		self.pickCntLb:runAction(
			cc.Sequence:create(
				cc.ScaleTo:create(0.3, 1.5),
				cc.CallFunc:create(function ( ... )
					self.pickCntLb:setString(num)			
				end),
				cc.ScaleTo:create(0.2, 1)))
		
	else
		self.pickCntLb:setScale(1)
		self.pickCntLb:setString(num)
	end
end

function cls:showPickValue(index, dataInfo, isOpenAni)
    return self.pickItemList[index]:openPickItem(dataInfo, isOpenAni)
end

function cls:collectCoinsToFooter( posIndex, dataInfo, jpValue )
	local value = dataInfo.value
	local pickItem = self.pickItemList[posIndex]

	local startW = bole.getWorldPos(pickItem.node)
	local startE = bole.getNodePos(self.collectParent, startW)
	
	local endW   = self.vCtl:getFooterWinWordPos()
	local endE   = bole.getNodePos(self.collectParent, endW)

	self.vCtl:playMusicByName("win_collect")
	self.collectParent:runAction(
		cc.Sequence:create(
			cc.CallFunc:create(function ( ... ) -- 进行飞粒子操作 + item循环动画关闭
			  	local file = self.vCtl:getParticleFile("map_pick_collect")
				local s1 = cc.ParticleSystemQuad:create(file)
				self.collectParent:addChild(s1)
				s1:setPosition(startE)
				self:_parabolaToAnimation(s1, startE, endE)
			end),
			cc.DelayTime:create(0.3),
			cc.CallFunc:create(function ()
				local data = {}
				data.parent = self.collectParent
				data.file = self.vCtl:getSpineFile("map_pick_collect")
				data.zOrder = 100
				data.pos = endE
				bole.addAnimationSimple(data)

				self.vCtl:refrshCollectWin( jpValue or (value or 0)*self.vCtl:getFeatureBet() )
			end),
			cc.DelayTime:create(self.config.footer_roll_delay),
			cc.CallFunc:create(function ( ... )
				self.vCtl:finshPlayOneItem()
			end)))
end

function cls:_parabolaToAnimation( obj, from, to )

    local half = cc.p((to.x + from.x) / 2, (to.y + from.y) / 2)
    local a = to.y - from.y
    local b = to.x - from.x
    local dis = math.sqrt(math.pow(a, 2) + math.pow(b, 2))
    local a1 = half.y + b / 2
    local b1 = half.x - a / 2
    local dur = dis / 1000
    if dur < 0.2 then
        dur = 0.2
    end
    if dur > 0.4 then
        dur = 0.4
	end

    obj:runAction(
		cc.Sequence:create(
			cc.BezierTo:create(dur, { from, cc.p(b1, a1), to }),
			cc.CallFunc:create(function()
			    obj:setEmissionRate(0)
			end),
			cc.DelayTime:create(0.5),
			cc.RemoveSelf:create()
        )
    )
end

function cls:updatePosIdValue(posId, dataInfo, newValue)
	self.pickItemList[posId]:multiPickItem(dataInfo, newValue)
end

function cls:playFooterWinMulti( ... )
	local endW   = self.vCtl:getFooterWinWordPos()
	local endE   = bole.getNodePos(self.collectParent, endW)

	local data = {}
	data.parent = self.collectParent
	data.file = self.vCtl:getSpineFile("map_multi_footer")
	data.zOrder = 100
	data.pos = endE
	bole.addAnimationSimple(data)
end

function cls:playShowNextPageBgAnim( pageLevel )
	self.vCtl:playMusicByName("book_appear")
	
	-- 播放背景特效
	local data = {}
	data.file = self.vCtl:getSpineFile("map_pick_bg")
	data.parent = self.pickNode
	data.animateName = "animation"..pageLevel
	bole.addAnimationSimple(data)
	
	if bole.isValidNode(self.bgSpine) then 
		self.bgSpine:runAction(
			cc.Sequence:create(
				cc.DelayTime:create(40/30),
				cc.CallFunc:create(function ( ... )
					self.bgSpine:setAnimation(0, "animation"..pageLevel.."_1", false)
				end)))
	end

end

function cls:closePickScreen( ... )
	self.pickNode:stopAllActions()
	bole.setEnableRecursiveCascading(self.pickNode, true)

	self.pickNode:runAction(
		cc.Sequence:create(
			cc.FadeOut:create(0.3),
			cc.RemoveSelf:create()))
end

return cls



