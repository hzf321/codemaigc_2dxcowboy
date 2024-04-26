

ThemeGoldRush_CollectView = class("ThemeGoldRush_CollectView")
local cls = ThemeGoldRush_CollectView

function cls:ctor(ctl, nodeList)
	self.vCtl = ctl
	self.gameConfig = self.vCtl:getGameConfig()

	self.collectFeatureNode = nodeList[1]
	self.collectFlyNode = nodeList[2]
	
	self:_initLayout()
	self:_initCollectBtnEvent()
end

function cls:_initLayout()
	if self.collectFeatureNode then 

		self.openLockBtn 	= self.collectFeatureNode:getChildByName("open_btn")
		self.tipDimmer 		= self.collectFeatureNode:getChildByName("dimmer")

		self.tipBtnList 	= self.collectFeatureNode:getChildByName("tip_btn_list"):getChildren()
		self.tipNode 		= self.collectFeatureNode:getChildByName("tip_node")
		self.closeTipBtn 	= self.tipNode:getChildByName("close_btn")
	 	self.tipNode:setVisible(false)
	 	self.tipDimmer:setVisible(false)

		self.cntNode = self.collectFeatureNode:getChildByName("cnt_node") 

		self.collectList = {}
		for id = 1, 20 do
			local temp = self.cntNode:getChildByName("cnt"..id)
			self.collectList[id] = temp
		end


		local _c_config = self.gameConfig.collect_config

		local _, s1 = bole.addSpineAnimationInTheme(
			self.collectFeatureNode, 
			50, 
			self.vCtl:getSpineFile("collect_lock"), 
			cc.p(395.5, 13.5),
			_c_config.lock_anim.unlock, 
			nil, 
			nil, 
			nil, 
			true
		) -- 默认解锁状态
		self.lockSuperSpine = s1
	end
end

function cls:_initCollectBtnEvent( ... )

    local function unLockOnTouchByMap(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
			if not self.vCtl:checkUnlockBtnCanTouch() then 
				return 
			end
			
			local _unLockType = self.gameConfig.unlockInfoConfig.Map
			self.vCtl:unlockBtnClickEvent(_unLockType)
        end

    end
    self.openLockBtn:addTouchEventListener(unLockOnTouchByMap)

    local function tipOnTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
        	if not self.vCtl:checkUnlockBtnCanTouch() then return end
			if self.vCtl:checkFeatureIsLock(self.gameConfig.unlockInfoConfig.Map) then return end
			
			self:showCollectTipAnim()
        end
    end
    for _, btn in pairs(self.tipBtnList) do 
    	btn:addTouchEventListener(tipOnTouch)
    	btn:setSwallowTouches(false)
    end

    local function tipCloseOnTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
			self:closeCollectTip()
        end
    end
	self.closeTipBtn:addTouchEventListener(tipCloseOnTouch)	

end

function cls:changeCollectLockState( showUnlock )
	local _c_config = self.gameConfig.collect_config

	local animName = showUnlock and _c_config.lock_anim.unlock or _c_config.lock_anim.lock
	local animName2 = (not showUnlock) and _c_config.lock_anim.lock_loop or _c_config.lock_anim.unlock_loop
	bole.spChangeAnimation(self.lockSuperSpine, animName, false)
	if animName2 then 
		self.lockSuperSpine:addAnimation(0, animName2, true)
	end

end

function cls:playCollectLevelAnim( )
	
end

function cls:resetBoardShowByFeature( pType )
    if pType == self.gameConfig.SpinBoardType.Normal or pType == self.gameConfig.SpinBoardType.Bonus then -- normal情况下 需要更改棋盘底板
    	self.collectFeatureNode:setVisible(true)
		
    else
    	self.collectFeatureNode:setVisible(false)
    end
end
---------------------------------------------------------------------------------------------------------
--@ 状态展示
function cls:getMapLevelPos( level )
	local endPosW = bole.getWorldPos(self.collectList[level])
	local endPosN = bole.getNodePos(self.collectFlyNode, endPosW)
	return endPosN
end
function cls:showCoinsFlyToUp( theSpecials, endPosN )
	self.collectFlyNode:removeAllChildren()

	if not theSpecials or not endPosN then return end

	local _c_config = self.gameConfig.collect_config
	local scatter_pos = self.gameConfig.symbol_config.scatter_config.scatter_pos
	self.vCtl:playMusicByName("scatter_collect")

	for col, rowTagList in pairs(theSpecials) do
		for row, tagValue in pairs(rowTagList) do

			local cell = self.vCtl:getCellItem(col, row)
			if bole.isValidNode(cell.up) then
				cell.up:removeAllChildren()
			end

			local pos = cc.pAdd(self.vCtl:getCellPos(col, row), scatter_pos )
			local s = cc.Node:create()
			s:setPosition(pos)
			self.collectFlyNode:addChild(s)

			local _p_path1 = self.vCtl:getParticleFile("free_c1") -- base_sc1
			local _p_path2 = self.vCtl:getParticleFile("free_c2") -- base_sc2
			local _particle1 = cc.ParticleSystemQuad:create(_p_path1)
			local _particle2 = cc.ParticleSystemQuad:create(_p_path2)
			s:addChild(_particle2, -5)
			s:addChild(_particle1, -1)
			_particle1:setVisible(false)
			_particle2:setVisible(false)

			s:runAction(cc.Sequence:create(
				cc.DelayTime:create(10/30),
				cc.CallFunc:create(function ( ... )
					_particle2:setVisible(true)
					_particle1:setVisible(true)
				end),
				cc.MoveTo:create(_c_config.fly_up_time - 10/30, endPosN),
				cc.CallFunc:create(function()
					_particle1:setEmissionRate(0) -- 设置发射速度为不发射
					_particle2:setEmissionRate(0) -- 设置发射速度为不发射
				end),
				cc.DelayTime:create(0.5),
				cc.RemoveSelf:create()))
		end
	end
end

function cls:showCoinsFlyArr( endPosN )
	local data = {}
	data.file = self.vCtl:getSpineFile("b_collect_arr")
	data.parent = self.collectFlyNode
	data.zOrder = 20
	data.pos = endPosN
	bole.addAnimationSimple(data)
end

function cls:setCollectProgress( level )
	local _c_config =  self.gameConfig.collect_config
	local item_path_list =  _c_config.item_sp_path
	local item_type_list =  _c_config.item_sp_type

	for id, node in pairs(self.collectList) do 
		local _itemType = item_type_list[id] or _c_config.item_normal_type
		local spFile = item_path_list[_itemType]["light"]
		if id > level then 
			spFile = item_path_list[_itemType]["dark"]
		end
		bole.updateSpriteWithFile(node, spFile)
	end
end

---------------------------------------------------------------------------------------------------------
function cls:addfullCollectAnim( )
	-- local _, s1 = bole.addSpineAnimationInTheme(
	-- 	self.collectFeatureNode, 
	-- 	5, 
	-- 	self.vCtl:getSpineFile("collect_full"), 
	-- 	cc.p(0,0),
	-- 	"animation"
	-- )
end
---------------------------------------------------------------------------------------------------------
-- todo
function cls:showCollectTipAnim( ... )
	if self.isShowTipNode then return end
	if bole.isValidNode(self.tipNode) and bole.isValidNode(self.tipDimmer) and bole.isValidNode(self.closeTipBtn) then 
		self.tipNode:stopAllActions()
		self.tipDimmer:stopAllActions()

		self.vCtl:playMusicByName("popup_out")

		self.tipDimmer:setOpacity(0)
		self.tipDimmer:setVisible(true)
		self.tipDimmer:runAction(cc.FadeTo:create(0.3, 200))

		self.isShowTipNode = true
		self.tipNode:setScale(0)
		self.tipNode:runAction(cc.Sequence:create(
			cc.Show:create(),
			cc.ScaleTo:create(0.2, 1.2),
			cc.ScaleTo:create(0.1, 1),
			cc.CallFunc:create(function ( ... )
				self.closeTipBtn:setTouchEnabled(true)
			end),
			cc.DelayTime:create(5),
			cc.CallFunc:create(function ( ... )
				self:closeCollectTip()
			end)
		))
	end
end

function cls:closeCollectTip( ... )
	if not self.isShowTipNode then return end
	if bole.isValidNode(self.tipNode) and bole.isValidNode(self.tipDimmer) and bole.isValidNode(self.closeTipBtn) then 

		self.vCtl:playMusicByName("popup_out")

		self.isShowTipNode = false

		self.tipNode:stopAllActions()
		self.tipDimmer:stopAllActions()

		self.tipNode:runAction(cc.Sequence:create(
			cc.CallFunc:create(function ( ... )
				self.closeTipBtn:setTouchEnabled(false)
				self.tipDimmer:stopAllActions()
				self.tipDimmer:runAction(cc.FadeTo:create(0.3, 0))
			end),
			cc.ScaleTo:create(0.05, 1.2),
			cc.ScaleTo:create(0.1, 0),
			cc.Hide:create()
		))
	end

end






