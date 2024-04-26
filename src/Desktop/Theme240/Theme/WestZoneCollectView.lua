local collectView = class("WestZoneCollectView")

function collectView:ctor(ctl, rootNode, collectTipNode)
	self._collectViewCtl = ctl
	self._mainViewCtl = self._collectViewCtl._mainViewCtl
	self.gameConfig = self._mainViewCtl:getGameConfig()
	self.collect_tipState = 0
	self.collectFeatureNode = rootNode
	self.hasJackpotNode = false
	self:_initLayout(collectTipNode)
	self:_initCollectBtnEvent()
end

function collectView:_initLayout(collectTipNode)
	if self.collectFeatureNode then 
		self.show_tip_btn		= self.collectFeatureNode:getChildByName("show_tip_btn")     
		self.lock_ani_node 		= self.collectFeatureNode:getChildByName("lock_ani_node")
		self.ani_full           = self.collectFeatureNode:getChildByName("ani_full")
		self.ani_encourage      = self.collectFeatureNode:getChildByName("ani_jili")
		self.progress_panel     = self.collectFeatureNode:getChildByName("progress_panel")
		self.collectItemList 	= {}
		local coinProgress = self.progress_panel:getChildByName("coin_progress")
		for key = 1, 10 do
			self.collectItemList[key] = coinProgress:getChildByName("coin_"..key)
			self.collectItemList[key]:setScale(1)
		end
		self.collectFlyNode     = self._collectViewCtl:getFlyNode()
		self.loop_ani_node      = self.progress_panel:getChildByName("loop_aniNode")
		self.collect_tip_node   = collectTipNode
		self.collect_tip_node:setVisible(false)
		self.collect_tip_node:setScale(0)
	end
end

function collectView:_initCollectBtnEvent( ... )
    local function unLockOnTouchByMap(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
			if not self._collectViewCtl:checkUnlockBtnCanTouch() then 
				return 
			end
			local _unLockType = self.gameConfig.unlockBetList.Collect
			self._collectViewCtl:unlockBtnClickEvent(_unLockType)
        end
    end
    self.show_tip_btn:addTouchEventListener(unLockOnTouchByMap)
end

function collectView:changeCollectLockState( showUnlock )
	if showUnlock then
		self._collectViewCtl:playMusicByName("collect_lock")
		self.lock_ani_node:stopAllActions()
		self.lock_ani_node:removeAllChildren()
		bole.addSpineAnimationInTheme(self.lock_ani_node, nil, self._mainViewCtl:getSpineFile("collect_lock"), cc.p(0, -6),"animation1",nil,nil,nil,true,false) -- 默认解锁状态
		self.ani_encourage:setVisible(true)      
		self.progress_panel:setVisible(true)
		self.ani_full:removeAllChildren()
		self.loop_ani_node:removeAllChildren()
		self:hideCollectTipNode()
		local a1 = cc.DelayTime:create(5/30)
		local a2 = cc.CallFunc:create(function ()
			self.ani_encourage:setVisible(false)      
			self.progress_panel:setVisible(false)
		end)
		local a3 = cc.Sequence:create(a1, a2)
		self.lock_ani_node:runAction(a3)
	else
		self.lock_ani_node:stopAllActions()
		self.lock_ani_node:removeAllChildren()
		local _, s1 = bole.addSpineAnimationInTheme(self.lock_ani_node, nil, self._mainViewCtl:getSpineFile("collect_unlock"), cc.p(0, -6),"animation2",nil,nil,nil,true,false) -- 默认解锁状态
		self._collectViewCtl:playMusicByName("collect_unlock")
		local a1 = cc.DelayTime:create(15/30)
		local a2 = cc.CallFunc:create(function(...)
			self.progress_panel:setVisible(true)
			self.ani_encourage:setVisible(true)
			bole.addSpineAnimationInTheme(self.loop_ani_node,10,self._mainViewCtl:getSpineFile("collect_loop"), cc.p(0, 0), "animation", nil, nil, nil, true, true)
			self:showCollectTipNode()
		end)
		local a3 = cc.Sequence:create(a1, a2)
		self.lock_ani_node:runAction(a3)
	end
end

function collectView:resetAllNode()
	local file = "#theme240_base_collect4.png"
	for _id, node in pairs(self.collectItemList) do 
		node:removeAllChildren()
		bole.updateSpriteWithFile(node, file)
	end
end

function collectView:setCurCollectLevel(level, scatterPosList)
	if level == 0 then self:resetAllNode() end
    for _id, node in pairs(self.collectItemList) do 
		local size = node:getContentSize()
    	if _id == level then 
			local name = "animation1" 
			local delay = 22/30
			if _id == 10 then
				name = "animation2" 
			end 
			delay = scatterPosList and delay or 0
			if scatterPosList and not self._collectViewCtl.CollectState then 
				local endPos 	= bole.getWorldPos(node)
				local endPosN 	= bole.getNodePos(self.collectFlyNode, endPos)
				
				node:runAction(
					cc.Sequence:create(cc.CallFunc:create(function ( ... )
						for col, rowTagList in pairs(scatterPosList[self.gameConfig.special_symbol.scatter]) do
							for row, tagValue in pairs(rowTagList) do
								if scatterPosList[self.gameConfig.special_symbol.scatter][col][row] then
									local startPos = self._mainViewCtl:getCellPos(col, row)
									local cell = cc.Node:create()
									self.collectFlyNode:addChild(cell)
									cell:setPosition(startPos)
									local _particle = cc.ParticleSystemQuad:create(self._mainViewCtl:getPic("particle/shoji2_1.plist"))
									local _particle1 = cc.ParticleSystemQuad:create(self._mainViewCtl:getPic("particle/233_lizituowei.plist"))
									cell:addChild(_particle, -1)
									cell:addChild(_particle1, 1)
									cell:runAction(
										cc.Sequence:create(
											cc.MoveTo:create(self.gameConfig.collectFlyParTime, endPosN),
											cc.DelayTime:create(0.5),
											cc.CallFunc:create(function ( ... )
												if _particle and bole.isValidNode(_particle) then
													_particle:setEmissionRate(0)
												end
												if _particle1 and bole.isValidNode(_particle1) then
													_particle1:setEmissionRate(0)
												end
											end),
											cc.RemoveSelf:create()
										)
									)
								end
							end
						end
					end),
					cc.DelayTime:create(self.gameConfig.collectFlyParTime),
					cc.CallFunc:create(function()
						if delay ~= 0 then
							local lightNode = cc.Node:create()
							local lightWPos = bole.getWorldPos(node)
							local lightNPos = bole.getNodePos(self.collectFlyNode, lightWPos)
							self.collectFlyNode:addChild(lightNode)
							lightNode:setPosition(lightNPos)
							self._mainViewCtl:playMusicByName("collect_light")
							bole.addSpineAnimationInTheme(lightNode, nil, self._mainViewCtl:getPic("spine/collect/collect_lightup/jdt_sj"), cc.p(0,0), name,nil,nil,nil,true,false)
							self._collectViewCtl._mainViewCtl:laterCallBack(22/30,function ()
								local animation = _id == 10 and "animation4" or "animation3"
								if lightNode and bole.isValidNode(lightNode) then
									lightNode:removeFromParent()
								end
								bole.addSpineAnimationInTheme(node, nil, self._mainViewCtl:getPic("spine/collect/collect_lightup/jdt_sj"), cc.p(size.width/2,size.height/2), animation,nil,nil,nil,true,false)
								-- bole.spChangeAnimation(s1, animation, true)
							end)
						end
					end)
				))
				node:runAction(cc.Sequence:create(
				cc.DelayTime:create(delay - 0.1),
				cc.CallFunc:create(function ( ... )
					-- bole.updateSpriteWithFile(node, "#theme240_base_collect3.png")
					if _id  == 10 then
						-- bole.updateSpriteWithFile(node, "#theme240_base_collect5.png")
						self._collectViewCtl:playMusicByName("collect_full")
						self.ani_encourage:removeAllChildren()
						self._collectViewCtl._mainViewCtl:laterCallBack(0.5, function()
							 bole.addSpineAnimationInTheme(self.ani_full, nil, self._mainViewCtl:getPic("spine/collect/collect_full/jdt_zj"), cc.p(0,0), "animation")
						end)
					elseif _id == 9 then
						bole.addSpineAnimationInTheme(self.ani_encourage, nil, self._mainViewCtl:getSpineFile("collect_jili"), cc.p(0,0),"animation", nil, nil, nil, true, true)
					end
					-- self:addNodeLoopAni(level)
				end)
				))
			else
				bole.addSpineAnimationInTheme(node, nil, self._mainViewCtl:getPic("spine/collect/collect_lightup/jdt_sj"), cc.p(size.width/2,size.height/2), "animation3", nil, nil, nil, true, true)
				if level == 9 then
					bole.addSpineAnimationInTheme(self.ani_encourage, nil, self._mainViewCtl:getSpineFile("collect_jili"), cc.p(0,0),"animation", nil, nil, nil, true, true)
				end
			end
		elseif _id < level then
			bole.addSpineAnimationInTheme(node, nil, self._mainViewCtl:getPic("spine/collect/collect_lightup/jdt_sj"), cc.p(size.width/2,size.height/2), "animation3", nil, nil, nil, true, true)
			-- bole.updateSpriteWithFile(node, "#theme240_base_collect3.png")
		end
    end
end

function collectView:showCollectTipNode()
    if self.collect_tip_node and (self.collect_tipState == 1) then
    	self:hideCollectTipNode()
    else	 	
    	self.collect_tipState = 1
	    -- self.collect_tip_node:setVisible(true)
	    self.collect_tip_node:setScale(0)
	    self.collect_tip_node:runAction(
	            cc.Sequence:create(
	                    cc.ScaleTo:create(0.1, 1.4),
	                    cc.ScaleTo:create(0.1, 1.2),
	                    cc.DelayTime:create(3),
	                    cc.ScaleTo:create(0.1, 1, 1.1),
	                    cc.ScaleTo:create(0.1, 0),
	                    cc.CallFunc:create(function()
	                    	self.collect_tipState = 0
	                    end)
	            )
	    )
    end
end

function collectView:hideCollectTipNode()
	if self.collect_tip_node and (self.collect_tipState == 1) then
    	self.collect_tipState = 0
        self.collect_tip_node:stopAllActions()
        self.collect_tip_node:runAction(
            cc.ScaleTo:create(0.1, 0)
        )
    end
end

return collectView