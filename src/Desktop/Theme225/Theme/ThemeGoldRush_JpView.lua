

ThemeGoldRush_JpView = class("ThemeGoldRush_JpView")
local cls = ThemeGoldRush_JpView

function cls:ctor(vCtl, jpRoot)
	self.vCtl = vCtl

	self.gameConfig = self.vCtl:getGameConfig()

	self.jackpotNode = jpRoot
	self.hasJackpotNode = false

	self:_initLayout()
	self:_initJackpotBtnEvent()
	self:_setAdapterPhone()
end

function cls:_initLayout()
	if self.jackpotNode then
		self.progressiveRoot 	= self.jackpotNode:getChildByName("progressive")
		self.lockRoot 			= self.jackpotNode:getChildByName("lock_node")
		self.jackpotTipRoot 	= self.jackpotNode:getChildByName("tip_node")
		
		self.jackpotTipslock = self.jackpotTipRoot:getChildByName("lock_tip")
		self.jackpotTipsUnlock = self.jackpotTipRoot:getChildByName("unlock_tip")
		self.jackpotTipslock:setVisible(false)
		self.jackpotTipsUnlock:setVisible(false)

		self.jackpotLabels = {}
		self.jackpotLockNodes = {}
		self.jackpotNormalNodes = {}

		for i = 1, self.gameConfig.jp_config.jp_cnt do
			-- 普通	
			local jpTemp = self.progressiveRoot:getChildByName("jp_node"..i)-- 初始化jackpot
			self.jackpotLabels[i] = jpTemp:getChildByName("label_jp" .. i)
			self.jackpotLabels[i].maxWidth = self.vCtl:getJPLabelMaxWidth(i)
			self.jackpotLabels[i].baseScale = self.jackpotLabels[i]:getScale()

			self.jackpotNormalNodes[i-1] = jpTemp
			self.jackpotNormalNodes[i-1].label = self.jackpotLabels[i]
			-- self.jackpotNormalNodes[i-1].bg = jpTemp:getChildByName("bg")

			local animName = "animation"
			local _,s = bole.addSpineAnimationInTheme(
				jpTemp, 
				20, 
				self.vCtl:getSpineFile("jp_loop"), 
				cc.p(0,0), 
				animName,
				nil,
				nil,
				nil,
				true,
				true
			)
			self.jackpotNormalNodes[i-1].spine = s

			-- 锁定
			local jpTemp2 = self.lockRoot:getChildByName("lock_node"..i)-- 初始化jackpot
			self.jackpotLockNodes[i-1] = jpTemp2
			self.jackpotLockNodes[i-1].unlockBtn 	= jpTemp2:getChildByName("unlock_btn")
			self.jackpotLockNodes[i-1].tipNode 		= jpTemp2:getChildByName("tip_node")
			self.jackpotLockNodes[i-1].tipNode:setLocalZOrder(2)

			self.jackpotLockNodes[i-1].unlockBtn.type = i-1

		end
		self.jpAnimNode = self.jackpotNode:getChildByName("win_anim")
		self.hasJackpotNode = true
	end
end


function cls:_setAdapterPhone( ... )
    -- bole.adaptTop(self.jackpotNode, -0.3)
end
function cls:getJackpotLabels( ... )
	return self.jackpotLabels
end

function cls:_initJackpotBtnEvent()
 	local function unLockOnTouchByJp(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			if self.vCtl:checkJackpotBtnCanTouch() then 
				local _unLockType = self.gameConfig.jp_config.jp_level[obj.type]
				self.vCtl:jpBtnClickEvent(_unLockType)
			end
	    end
	end

    for _, node in pairs(self.jackpotLockNodes) do 
    	node.unlockBtn:addTouchEventListener(unLockOnTouchByJp)
    	node.unlockBtn:setTouchEnabled(true)
    end
end

function cls:changeJackpotLockShow( jackpotType, showUnlock )
	if showUnlock then 
		if bole.isValidNode(self.jackpotNormalNodes[jackpotType]) then -- bole.isValidNode(self.jackpotNormalNodes[jackpotType].bg) and bole.isValidNode(self.jackpotNormalNodes[jackpotType].label) then 
			local temp = self.jackpotNormalNodes[jackpotType]
			-- bole.updateSpriteWithFile(temp.bg, "#theme203_b_jp_bg"..(jackpotType)..".png")
			-- temp.label:setFntFile(self.vCtl:getPic("font/203_jpzi_0.fnt")) 
			temp:stopAllActions()
			temp:runAction(cc.Sequence:create(
				cc.DelayTime:create(5/30),
				cc.CallFunc:create(function ( ... )
					temp:setColor(self.gameConfig.normalColor) 
				end)))
			 -- 
			if bole.isValidNode(self.jackpotNormalNodes[jackpotType].spine) then 
				self.jackpotNormalNodes[jackpotType].spine:setVisible(true)
				-- bole.spChangeAnimation(self.jackpotNormalNodes[jackpotType].spine, "animation"..(jackpotType + 1), true)
			end

		end

		local animName = string.format("animation%s_1", jackpotType + 1)
		bole.addSpineAnimationInTheme(
			self.jackpotNode, 
			20, 
			self.vCtl:getSpineFile("jp_lock"),
			cc.p(self.jackpotLockNodes[jackpotType]:getPosition()), 
			animName
		)
	else
		local animName = string.format("animation%s", jackpotType + 1)
		bole.addSpineAnimationInTheme(
			self.jackpotNode, 
			20, 
			self.vCtl:getSpineFile("jp_lock"), 
			cc.p(self.jackpotLockNodes[jackpotType]:getPosition()), 
			animName
		)-- 播放 锁定 动画

		if bole.isValidNode(self.jackpotNormalNodes[jackpotType]) then -- bole.isValidNode(self.jackpotNormalNodes[jackpotType].bg) and bole.isValidNode(self.jackpotNormalNodes[jackpotType].label) then 

			local temp = self.jackpotNormalNodes[jackpotType]
			-- bole.updateSpriteWithFile(temp.bg, "#theme203_b_jp_bg1"..(jackpotType)..".png")
			-- temp.label:setFntFile(self.vCtl:getPic("font/zhihuizi_0.fnt")) 
			temp:stopAllActions()
			temp:runAction(cc.Sequence:create(
				cc.DelayTime:create(5/30),
				cc.CallFunc:create(function ( ... )
					temp:setColor(self.gameConfig.lockJackpotColor)		
				end)))
			 
			if bole.isValidNode(self.jackpotNormalNodes[jackpotType].spine) then 
				self.jackpotNormalNodes[jackpotType].spine:setVisible(false)
				-- bole.spChangeAnimation(self.jackpotNormalNodes[jackpotType].spine, "animation_"..(jackpotType + 1), true)
			end
		end
	end

end

function cls:resetBoardShowByFeature(boardType)
    local board_type_config = self.gameConfig.SpinBoardType
	if boardType == board_type_config.Normal or boardType == board_type_config.Bonus then
	    self.jackpotNode:setVisible(true)
	else
		self.jackpotNode:setVisible(false)
	end

end

function cls:checkHasJackpotLockNode( )
	return self.hasJackpotNode
end


function cls:playChangeJakcpotStateTip(_showType, unlockLevel)
	local baseScale = cc.p(0.8, 1) -- _showType == "unlock" and 1 or 0.8
	local showNode = _showType == "unlock" and self.jackpotTipsUnlock or self.jackpotTipslock
	local _type = tool.getKeyByTableItem(self.gameConfig.jp_config.jp_level, unlockLevel) -- self.gameConfig.unlockInfoTypeList[unlockLevel]

	if bole.isValidNode(showNode) and self.jackpotLockNodes[_type] and bole.isValidNode(self.jackpotLockNodes[_type].tipNode) then 
		
		if self.jackpotTipsUnlock:isVisible() then 
			self.jackpotTipsUnlock:stopAllActions()
			self.jackpotTipsUnlock:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.02, baseScale.x*1.2, baseScale.y*1.2),
				cc.ScaleTo:create(0.08, 0),
				cc.Hide:create()
				))
		end
		if self.jackpotTipslock:isVisible() then 
			self.jackpotTipslock:stopAllActions()
			self.jackpotTipslock:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.02, baseScale.x*1.2, baseScale.y*1.2),
				cc.ScaleTo:create(0.08, 0),
				cc.Hide:create()
				))
		end

		showNode:stopAllActions()
		showNode:setPosition(0,0)
		showNode:setScale(0)

		local nameSp = showNode:getChildByName("name")

		if bole.isValidNode(nameSp) and ( _type >= 0 and _type <= self.gameConfig.jp_config.jp_cnt - 1 ) then
			local sp = string.format(self.gameConfig.jp_config.unlock_sp_name, _type)
			bole.updateSpriteWithFile(nameSp, sp)
		end

		-- self:restTipSpPos( showNode, self.gameConfig.jackpotTipNodeConfig[_showType] )

		bole.changeParent(showNode, self.jackpotLockNodes[_type].tipNode, 1)

		showNode:runAction(cc.Sequence:create(
			cc.Show:create(),
			cc.ScaleTo:create(0.2, baseScale.x*1.2, baseScale.y*1.2),
			cc.ScaleTo:create(0.1, baseScale.x*1, baseScale.y*1),
			cc.DelayTime:create(1),
			cc.ScaleTo:create(0.05, baseScale.x*1.2, baseScale.y*1.2),
			cc.ScaleTo:create(0.1, 0),
			cc.Hide:create()
		))
	end
end

function cls:restTipSpPos( showNode, nodeData )

	local sp1 = showNode:getChildByName(nodeData.node1)
	local sp2 = showNode:getChildByName(nodeData.node2)
	sp1:setAnchorPoint(0.5, 0.5)
	sp2:setAnchorPoint(0.5, 0.5)

	local contentSize1 = sp1:getContentSize()
	local contentSize2 = sp2:getContentSize()
	local extra_width = nodeData.extra_width

	local halfWidth = (contentSize1.width + contentSize2.width + extra_width)/2
	local posX1 = - halfWidth + contentSize1.width/2
	local posX2 = halfWidth - contentSize2.width/2

	sp1:setPositionX(posX1)
	sp2:setPositionX(posX2)
end

function cls:showWinJackpotDialog( dData, endFunc )

	local winNum = dData.jp_win or 0
	local winJPType = dData.jp_win_type or 4
-----
	local delay = 35/30
	local dName = "jp"
	local dType = 3

	local data = {}
	data.coins = winNum or 0
	data.bg = (winJPType + 1)

	data.click_event = function ( )
		
		self.vCtl:playMusicByName("common_click")

		self.jackpotNode:runAction(cc.Sequence:create(
			cc.DelayTime:create(0.2),
			cc.CallFunc:create(function ( ... )
				self.vCtl:playMusicByName("popup_out")
			end),
			cc.DelayTime:create(delay),
			cc.CallFunc:create(function ()
				if endFunc then 
					endFunc(winNum)
				end
				-- self:stopJpAnimate() -- 策划要求下次spin 消失动画
				self.vCtl:dealMusic_FadeLoopMusic(0.2, 0, 1)
			end)
		))
	end

    self.vCtl:playMusicByName("person_jp"..winJPType)
    self.vCtl:playMusicByName("win_jp_show")

    self.vCtl:dealMusic_FadeLoopMusic(0.2, 1, 0)

	local dialog = self.vCtl:showThemeDialog(data, dType, dName)

	-- dialog:runAction(
	--     cc.Sequence:create(
	-- 		cc.DelayTime:create(5),
	-- 		cc.CallFunc:create(function()
	-- 			if dialog then
	-- 				dialog:clickCollectBtn()
	-- 			end
	-- 		end)
	--     )
	-- )
end

function cls:playWinJpAnim( winType )
		
	local animName = "animation" -- winType 0开始
	if (not self.jpWinAnimList or not bole.isValidNode(self.jpWinAnimList[winType])) and animName then 
		local _, jpAnim = bole.addSpineAnimationInTheme(self.jpAnimNode, nil, self.vCtl:getSpineFile("jp_win"), cc.p(self.jackpotNormalNodes[winType]:getPosition()), animName, nil, nil, nil, true, true)

		self.jpWinAnimList = self.jpWinAnimList or {}
		self.jpWinAnimList[winType] = jpAnim

		-- if bole.isValidNode(self.jackpotNormalNodes[winType].spine) then 
		-- 	self.jackpotNormalNodes[winType].spine:setVisible(false)
		-- end

		return jpAnim 
	end

end

function cls:stopJpAnimate()
	if bole.isValidNode(self.jpAnimNode) then 
		self.jpAnimNode:removeAllChildren()
	end

	-- for _, node in pairs(self.jackpotNormalNodes) do 
	-- 	if bole.isValidNode(node.spine) then 
	-- 		node.spine:setVisible(true)
	-- 	end
	-- end

	self.jpWinAnimList = nil
end


-------------------------------------------------------
-- slot
function cls:playJPArriveAnim(jpType)
	-- if jpType and bole.isValidNode(self.jackpotNormalNodes[jpType]) then 
	-- 	local spineFile2 = self.vCtl:getSpineFile("jp_arr")
	-- 	bole.addSpineAnimationInTheme(self.jackpotNormalNodes[jpType], 22, spineFile2, cc.p(0, 0), "animation")
	-- end
end
-------------------------------------------------------




