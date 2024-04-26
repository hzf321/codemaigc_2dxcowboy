

ThemeMysteriousPixies_CollectView = class("ThemeMysteriousPixies_CollectView")
local cls = ThemeMysteriousPixies_CollectView

function cls:ctor(ctl, nodeList)
	self.vCtl = ctl
	self.gameConfig = self.vCtl:getGameConfig()

	self.collectFeatureNode = nodeList[1]
	self.collectFlyNode = nodeList[2]
	self.collectTipParent = nodeList[3]
	
	self:_initLayout()
	self:_initCollectBtnEvent()
end

function cls:_initLayout()
	if self.collectFeatureNode then 

		self.openLockBtn 	= self.collectFeatureNode:getChildByName("open_btn")
		self.tipDimmer 		= self.collectFeatureNode:getChildByName("dimmer")

		self.tipBtn 		= self.collectFeatureNode:getChildByName("tip_btn")
		self.tipNode 		= self.collectFeatureNode:getChildByName("tip_node")
		self.closeTipBtn 	= self.tipNode:getChildByName("close_btn")
		self.tipBg 			= self.tipNode:getChildByName("tip_bg")
	 	self.tipNode:setVisible(false)
	 	self.tipNode.closeTipBtn = self.closeTipBtn
	 	bole.changeParent(self.tipNode, self.collectTipParent)
	 	-- self.tipDimmer:setVisible(false)


		self.tipBtn2 		= self.collectFeatureNode:getChildByName("tip_btn2")
		self.tipNode2 		= self.collectFeatureNode:getChildByName("tip_node2")
		self.closeTipBtn2 	= self.tipNode2:getChildByName("close_btn2")
		self.tipNode2.closeTipBtn = self.closeTipBtn2 
		self.tipNode2:setVisible(false)
		bole.changeParent(self.tipNode2, self.collectTipParent)

	 	local bgSize = self.tipBg:getContentSize()
		local data = {}
		data.file = self.vCtl:getSpineFile("tip_loop")
		data.parent = self.tipBg
		data.pos = cc.p(bgSize.width/2 - 2, bgSize.height/2 + 10)
		data.isLoop = true
		bole.addAnimationSimple(data)

	 	-- 进度条
	 	local progressPanel = self.collectFeatureNode:getChildByName("panel")
 	    self.barAnim = progressPanel:getChildByName("bar_anim")
 	    self.progressBar = progressPanel:getChildByName("bar")

		local _c_config = self.gameConfig.collect_config

		local _, s1 = bole.addSpineAnimationInTheme(
			self.collectFeatureNode, 
			50, 
			self.vCtl:getSpineFile("collect_lock"), 
			cc.p(420, -15),
			_c_config.lock_anim.unlock, 
			nil, 
			nil, 
			nil, 
			true
		) -- 默认解锁状态
		self.lockSuperSpine = s1

		local barSize = self.progressBar:getContentSize()
		local data = {}
		data.file = self.vCtl:getSpineFile("b_collect_move")
		data.parent = self.barAnim
		data.zOrder = 20
		data.animateName = "animation1"
		data.isLoop = true
		-- data.pos = cc.p(barSize.width/2, barSize.height)
		bole.addAnimationSimple(data)
		
		local data = {}
		data.file = self.vCtl:getSpineFile("tip_icon")
		data.parent = self.collectFeatureNode
		data.pos = cc.p(421.5, 214)
		data.isLoop = true
		local _, is1 = bole.addAnimationSimple(data)
		self.tipIcon = is1
		
		local data = {}
		data.file = self.vCtl:getSpineFile("collect_icon")
		data.parent = self.collectFeatureNode
		data.pos = cc.p(421.5, -235.5)
		data.animateName = "animation1"
		data.isLoop = true
		local _, is2 = bole.addAnimationSimple(data)
		self.collectIcon = is2
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
    self.openLockBtn:setSwallowTouches(false)

    local function tipOnTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
        	if not self.vCtl:checkUnlockBtnCanTouch() then return end
			if self.vCtl:checkFeatureIsLock(self.gameConfig.unlockInfoConfig.Map) then return end
			
			self:showCollectTipAnim(self.tipNode2)
        end
    end
	self.tipBtn2:addTouchEventListener(tipOnTouch)
	self.tipBtn2:setSwallowTouches(false)

    local function tipOnTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
        	if not self.vCtl:checkUnlockBtnCanTouch() then return end
			if self.vCtl:checkFeatureIsLock(self.gameConfig.unlockInfoConfig.Map) then return end
			
			self:showCollectTipAnim(self.tipNode)
        end
    end
	self.tipBtn:addTouchEventListener(tipOnTouch)
	self.tipBtn:setSwallowTouches(false)

    local function tipCloseOnTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
			self:closeCollectTip(self.tipNode)
        end
    end
	self.closeTipBtn:addTouchEventListener(tipCloseOnTouch)	

    local function tipCloseOnTouch2(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
			self:closeCollectTip(self.tipNode2)
        end
    end
	self.closeTipBtn2:addTouchEventListener(tipCloseOnTouch2)	

end

function cls:changeCollectLockState( showUnlock )
	local _c_config = self.gameConfig.collect_config

	local animName = showUnlock and _c_config.lock_anim.unlock or _c_config.lock_anim.lock
	local animName2 = (not showUnlock) and _c_config.lock_anim.lock_loop or _c_config.lock_anim.unlock_loop
	bole.spChangeAnimation(self.lockSuperSpine, animName, false)
	if animName2 then 
		self.lockSuperSpine:addAnimation(0, animName2, true)
	end

	if showUnlock then 
		self.tipIcon:setAnimation(0, "animation", true)
		self.tipIcon:setColor(cc.c3b(255,255,255))

		self.collectIcon:setAnimation(0, "animation1", true)
		self.collectIcon:setColor(cc.c3b(255,255,255))
	else
		self.tipIcon:setAnimation(0, "animation2", false)
		self.tipIcon:setColor(cc.c3b(80,80,80))

		self.collectIcon:setAnimation(0, "animation3", false)
		self.collectIcon:setColor(cc.c3b(80,80,80))
	end
	
end

function cls:resetBoardShowByFeature( pType )
    -- if pType == self.gameConfig.SpinBoardType.Normal or pType == self.gameConfig.SpinBoardType.Bonus then -- normal情况下 需要更改棋盘底板
    -- 	self.collectFeatureNode:setVisible(true)
    -- 	self.collectTipParent:setVisible(true)
		
    -- else
    -- 	self.collectFeatureNode:setVisible(false)
    -- 	self.collectTipParent:setVisible(false)
    -- end
end
---------------------------------------------------------------------------------------------------------
-- 角标收集

function cls:updateCellStoreAssets(theCellNode, key, col) -- 更新Cell Sprite上其他图片，如商店角标Coins
	local coin_pos = self.gameConfig.collect_config.coin_pos
	local theSpriteFile = "#theme231_s_sub.png"

	if key and key > 0 and theCellNode then
		if not theCellNode.coinSprite then
			theCellNode.coinSprite = cc.Node:create()
			theCellNode:addChild(theCellNode.coinSprite,100)
		end
		local sprite = bole.createSpriteWithFile(theSpriteFile)
		sprite:setPosition(coin_pos)
		
		theCellNode.coinSprite:addChild(sprite,2)
		theCellNode.coinSprite:setVisible(true)
	end     
end

function cls:updateCellFastStoreAssets( col, colList ) -- 更新Cell Sprite上其他图片，如商店角标Coins
	local coin_pos = self.gameConfig.collect_config.coin_pos
	local theSpriteFile = "#theme231_s_sub.png"

	for i = 1, bole.getTableCount(colList) do
		local key = colList[i]
		if key > 0 then
			local cell = self.vCtl:getCellItem(col, i)
			if not cell.coinSprite then
				cell.coinSprite = cc.Node:create()
				cell:addChild(cell.coinSprite)
			end
			local sprite = bole.createSpriteWithFile(theSpriteFile)
			sprite:setPosition(coin_pos)
			cell.coinSprite:addChild(sprite)
		end
	end
end

function cls:addSubIconAnim( col, colList )
	local coin_pos = self.gameConfig.collect_config.coin_pos
	local base_col_cnt = self.gameConfig.theme_config.base_col_cnt or 5
	
    local data = {}
    data.file = self.vCtl:getSpineFile("sub_icon")
    data.parent = self.collectFlyNode
    data.isRetain = true
    data.animateName = "animation1"

	for row, value in pairs(colList) do
		if value > 0 then 
			local index = col + base_col_cnt * (row - 1)
			self.flySubSpines = self.flySubSpines or {}
			-- 添加fly 动画的落地状态
			local pos  = cc.pAdd(self.vCtl:getCellPos(col, row), coin_pos)
			data.pos = pos
			local _, s = bole.addAnimationSimple(data)

			self.flySubSpines[index] = s
			self.flySubSpines[index].value = value
			s:setVisible(false)
		end
	end
end

function cls:clearCellStoreSpriteByList( )

	local base_col_cnt = self.gameConfig.theme_config.base_col_cnt or 5
	local base_row_cnt = self.gameConfig.theme_config.base_row_cnt or 5
	for col = 1, base_col_cnt do
	    for row = 1, base_row_cnt do 
			local cell = self.vCtl:getCellItem(col, row)

			if bole.isValidNode(cell.coinSprite) then
				cell.coinSprite:removeAllChildren()
			end
	    end
	end

end

function cls:showCoinsFlyToUp( ... )
	local _collectConfig = self.gameConfig.collect_config
	local coinParticleFile = self.vCtl:getParticleFile("sub_icon")
	
	if self.flySubSpines then 
		local _flySubSpines = tool.tableClone(self.flySubSpines)

		self:clearCellStoreSpriteByList()

		self.flySubSpines = nil

		local wEndPos = bole.getWorldPosByPos(self.collectFeatureNode, _collectConfig.end_pos)
		local endNPos = bole.getNodePos(self.collectFlyNode, wEndPos)

		self.vCtl:playMusicByName("symbol_collect")
		
		for col, item in pairs(_flySubSpines) do
			item:setVisible(true)
 
			item:runAction(cc.Sequence:create(
				cc.CallFunc:create(function ()
					bole.spChangeAnimation(item, "animation2")
				end),
				cc.DelayTime:create(_collectConfig.fly_delay or 0),
				cc.CallFunc:create(function ( ... )
					self:_parabolaToAnimation( item, cc.p(item:getPosition()), endNPos )
				end)))

			if coinParticleFile then 
				local _particle = cc.ParticleSystemQuad:create(coinParticleFile)
				item:addChild(_particle, -1)
				_particle:setVisible(false)
				_particle:stopSystem()

				_particle:runAction(cc.Sequence:create(
					cc.DelayTime:create(_collectConfig.fly_delay or 0),
					cc.CallFunc:create(function ()
						_particle:resetSystem()
						_particle:setVisible(true)
					end),
					cc.DelayTime:create(_collectConfig.fly_up_time or 0),
					cc.CallFunc:create(function ( ... )
						_particle:setEmissionRate(0) -- 设置发射速度为不发射
					end)))
			end
		end
	end
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
			cc.DelayTime:create(0.5),
			cc.RemoveSelf:create()
        )
    )
end

function cls:showCoinsFlyArr( )
	local _collectConfig = self.gameConfig.collect_config
	local wEndPos = bole.getWorldPosByPos(self.collectFeatureNode, _collectConfig.end_pos)
	local endNPos = bole.getNodePos(self.collectFlyNode, wEndPos)

	if bole.isValidNode(self.collectIcon) then 
		self.collectIcon:setAnimation(0, "animation2", false)
		self.collectIcon:addAnimation(0, "animation1", true)
	end
	-- local data = {}
	-- data.file = self.vCtl:getSpineFile("b_collect_arr")
	-- data.parent = self.collectFlyNode
	-- data.zOrder = 20
	-- data.pos = endNPos

	-- bole.addAnimationSimple(data)
end


function cls:playProgressMoveAnim( startPos, endPos )

	local _collectConfig = self.gameConfig.collect_config

	self.progressBar:setPosition(startPos)
    self.progressBar:runAction(cc.MoveTo:create(_collectConfig.bar_move_time, endPos))

    self.barAnim:setPosition(startPos)
    self.barAnim:runAction(cc.MoveTo:create(_collectConfig.bar_move_time, endPos))

	-- if bole.isValidNode(self.collectIcon) then
	-- 	bole.spChangeAnimation(self.collectIcon, _collectConfig.icon.anim.collect)
	-- 	self.collectIcon:addAnimation(0, _collectConfig.icon.anim.loop, true)
	-- end

	local data = {}
	data.file = self.vCtl:getSpineFile("b_collect_move")
	data.parent = self.barAnim
	data.zOrder = 20
	data.animateName = "animation2"
	-- data.pos = endPos
	bole.addAnimationSimple(data)

end

function cls:setCollectProgress( cur_posY )
	self.progressBar:setPosition(cc.p(self.gameConfig.collect_config.progress_s_posx, cur_posY))
	self.barAnim:setPosition(cc.p(self.gameConfig.collect_config.progress_s_posx, cur_posY))
end

---------------------------------------------------------------------------------------------------------
function cls:addfullCollectAnim( )
	local _, s1 = bole.addSpineAnimationInTheme(
		self.collectFeatureNode:getChildByName("full_node"), 
		5, 
		self.vCtl:getSpineFile("collect_full"), 
		cc.p(420, -8),
		"animation"
	)
end
---------------------------------------------------------------------------------------------------------
-- todo
function cls:showCollectTipAnim( showNode )
	if not bole.isValidNode(showNode) then return end
	if showNode.isShowTipNode then return end
	if bole.isValidNode(showNode.closeTipBtn) then -- and bole.isValidNode(self.tipDimmer)
		showNode:stopAllActions()
		-- self.tipDimmer:stopAllActions()

		self.vCtl:playMusicByName("popup_out")

		-- self.tipDimmer:setOpacity(0)
		-- self.tipDimmer:setVisible(true)
		-- self.tipDimmer:runAction(cc.FadeTo:create(0.3, 200))

		showNode.isShowTipNode = true
		showNode:setScale(0)
		showNode:runAction(cc.Sequence:create(
			cc.Show:create(),
			cc.ScaleTo:create(0.2, 1.2),
			cc.ScaleTo:create(0.1, 1),
			cc.CallFunc:create(function ( ... )
				showNode.closeTipBtn:setTouchEnabled(true)
			end),
			cc.DelayTime:create(5),
			cc.CallFunc:create(function ( ... )
				self:closeCollectTip(showNode)
			end)
		))
	end
end

function cls:closeCollectTip( showNode )
	if not bole.isValidNode(showNode) then return end
	if not showNode.isShowTipNode then return end
	if bole.isValidNode(showNode.closeTipBtn) then --  and bole.isValidNode(self.tipDimmer)

		self.vCtl:playMusicByName("popup_out")

		showNode.isShowTipNode = false

		showNode:stopAllActions()
		-- self.tipDimmer:stopAllActions()

		showNode:runAction(cc.Sequence:create(
			cc.CallFunc:create(function ( ... )
				showNode.closeTipBtn:setTouchEnabled(false)
				-- self.tipDimmer:stopAllActions()
				-- self.tipDimmer:runAction(cc.FadeTo:create(0.3, 0))
			end),
			cc.ScaleTo:create(0.05, 1.2),
			cc.ScaleTo:create(0.1, 0),
			cc.Hide:create()
		))
	end

end

function cls:closeCollectAllTip( ... )
	self:closeCollectTip( self.tipNode )
	self:closeCollectTip( self.tipNode2 )
end



function cls:removeCollectFullAnimation()
	-- self.collectFullNode:removeAllChildren()
end








