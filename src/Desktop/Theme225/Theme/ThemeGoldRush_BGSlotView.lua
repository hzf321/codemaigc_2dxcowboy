

ThemeGoldRush_BGSlotView = class("ThemeGoldRush_BGSlotView")
local cls = ThemeGoldRush_BGSlotView

function cls:ctor( vCtl, nodesList)
	self.vCtl = vCtl
	self.node = cc.Node:create()
	self.vCtl:curSceneAddToContent(self.node)

	self.gameConfig = self.vCtl:getGameConfig()
	self.slot_config = self.gameConfig.classic_config

	self:_initLayout(nodesList)
end

function cls:_initLayout( nodesList )

	self.miniSlotRoot 	= nodesList[1]
	self.slotBoardRoot 	= nodesList[2]
	self.classicTipNode = nodesList[3]
	self.animateNode 	= nodesList[4]
	self.boardAniParent = nodesList[5]
	self.topAnimNode 	= nodesList[6]

	self.slotBoardList 	= self.slotBoardRoot:getChildren()
	self.miniSlotDimmer = self.miniSlotRoot:getChildByName("dimmer")
	self.miniSlotParent = self.miniSlotRoot:getChildByName("mini_slot_node")

	self:createMiniSlot()
	self:initClassicTip()
end

function cls:createMiniSlot()
	local csbPath = self.vCtl:getCsbPath("slot_machine")
    self.miniSlot = cc.CSLoader:createNode(csbPath)
    self.miniSlotParent:addChild(self.miniSlot)
    self.miniSlotList = {}
    self.miniSlotNodeList = {}
    for k, v in pairs(self.miniSlot:getChildByName("mini_panel"):getChildByName("mini_slots"):getChildren()) do
    	local slot_idx = k

    	self.miniSlotList[slot_idx] = v

        self.miniSlotNodeList[slot_idx] = {}
        self.miniSlotNodeList[slot_idx]["aniNode"] 		= v:getChildByName("panel"):getChildByName("ani_node")
        self.miniSlotNodeList[slot_idx]["boardRoot"] 	= v:getChildByName("board_root_node")
        self.miniSlotNodeList[slot_idx]["bg"] 			= v:getChildByName("bg")

        bole.updateSpriteWithFile(self.miniSlotNodeList[slot_idx]["bg"], string.format("#theme225_bonus_%s.png", k))
        bole.changeParent(self.slotBoardList[k], self.miniSlotNodeList[slot_idx]["boardRoot"])

        local paytableLabels = {}
        for i, v in pairs(v:getChildByName("paytable_list"):getChildren()) do
            paytableLabels[i] = v
            
            local value = self.vCtl:getPayValueByIndex(i)
            paytableLabels[i]:setString(FONTS.formatByCount4(value, 5, true))
        end
        v:setVisible(false)
        self.miniSlotNodeList[slot_idx]["paytableLabels"] = paytableLabels
    end

    self.slotBgNode = self.miniSlot:getChildByName("bg_node")
    self.slotWinAnimNode = cc.Node:create()
    self.slotBgNode:addChild(self.slotWinAnimNode, 10)
    
    self.slotLineRoot = self.miniSlot:getChildByName("line_root")
    self.slotLineTipList = {}
    self.slotLineList = {}
    for i, node in pairs(self.slotLineRoot:getChildren()) do 
    	local slot_idx = i
    	self.slotLineTipList[slot_idx] = node:getChildByName("line_tip")
    	self.slotLineTipList[slot_idx]:setVisible(false)

    	self.slotLineList[slot_idx] = node:getChildByName("line")
    	self.slotLineList[slot_idx].lines = self.slotLineList[slot_idx]:getChildren()
    end
    
    local data = {}
	data.file = self.vCtl:getSpineFile("slot_kuang")
	data.parent = self.slotBgNode
	data.isLoop = true
	data.animateName = "animation"
	bole.addAnimationSimple(data)

    local data = {}
	data.file = self.vCtl:getSpineFile("slot_spin")
	data.parent = self.slotBgNode
	data.isLoop = true
	data.animateName = "animation1"
	local _, s = bole.addAnimationSimple(data)
	self.slotSpinAnim = s

    self.miniSlot:setVisible(false)
end

function cls:initClassicTip( ... )
    self.miniSlotAnimList = {}
    local miniSlotCntRoot = self.classicTipNode:getChildByName("panel"):getChildByName("cnt_root")
    self.classicTipNode:setVisible(true)

    local statePath = "#theme225_bonus_tip1.png"
    for id = 1, 3 do
    	local cntNode = miniSlotCntRoot:getChildByName("cnt_node"..id)
		local temp = {}
		-- temp["scaleNode"] = v:getChildByName("type_node")
		temp["cntNode"] = cntNode
		temp["cntLabel"] = cntNode:getChildByName("label")
		temp["cntLabel"]:setString("0 SPIN")
		temp["stateSp"] = cntNode:getChildByName("state_sp")
		cntNode:setPosition(self.slot_config.count_pos.base_pos[id])
		bole.updateSpriteWithFile(temp.stateSp, statePath)

		local slot_idx = id
		self.miniSlotAnimList[slot_idx] = temp

		-- local _, s1 = self:addSpineAnimation(cntNode, nil, self:getPic("spine/base/shangfang_jackpot_01"), cc.p(0, 0), "animation", nil, nil, nil, true, true)-- 播放 上方 解锁之后的 循环动画
		-- item["idle"] = s1
		-- s1:setVisible(false)
    end
end

function cls:playWinBonusAnim( ls_map, miniSlotPos )
	local delay = 0
    if ls_map then
    	local pos_config = self.slot_config.count_pos

        delay = delay + 0.5

        local flyData = {}
        for idx, cnt in pairs(ls_map) do
        	
        	local col = idx
        	local cntEndPos = pos_config.end_pos[col] or cc.p(0,0)
        	local cntMovePos = pos_config.move_pos[col] or cc.p(0,0)

            -- 播放fly 动画
            if cnt > 0 then
            	for k = 1, cnt do
                    if miniSlotPos[col] and miniSlotPos[col][k] then
						local temp = {
							col 		= col, 
							row 		= miniSlotPos[col][k][2], 
							delay 		= delay, 
							cnt 		= k, 
							cntEndPos 	= cntEndPos,
							cntMovePos 	= cntMovePos,
						}

                    	table.insert(flyData, temp)
                    	delay = delay + self.slot_config.c_move_time + self.slot_config.c_move_delay
                    end
                end
            end
        end

		if table.nums(flyData) > 0 then 
			for _, temp in pairs(flyData) do
				self:playFlyToUpAnim(temp)
			end
		end 
    end
    return delay
end

function cls:playFlyToUpAnim( tempData )

	local col 			= tempData.col
	local row 			= tempData.row
	local cnt 			= tempData.cnt
	local delay 		= tempData.delay
	local cntEndPos 	= tempData.cntEndPos
	local cntMovePos 	= tempData.cntMovePos
	local basePos 		= cc.p(640, 360)
  	
  	self.node:runAction(cc.Sequence:create(
		cc.DelayTime:create(delay),
		cc.CallFunc:create(function(...)
			-- 播放飞 星星的动画
			self.vCtl:playMusicByName("slot_fly")
			self.miniSlotAnimList[col].cntNode:runAction(cc.MoveTo:create(0.3, cntEndPos)) -- 播放下拉计数框动画

			bole.addSpineAnimation(self.topAnimNode, 22, self.vCtl:getSpineFile("slot_c"..col), basePos, "animation"..row)

		end),
		cc.DelayTime:create(self.slot_config.c_move_time),
		cc.CallFunc:create(function(...)
			-- jackpot 收集动画
			if self.miniSlotAnimList[col] then

				self.vCtl:playJPArriveAnim(3-col)
				self.miniSlotAnimList[col].cntNode:runAction(
					cc.Sequence:create(
						cc.MoveTo:create(1 / 30, cntMovePos), 
						cc.DelayTime:create(1 / 30), 
						cc.CallFunc:create(function(...)
							local str = ""
							if cnt > 1 then
							    str = cnt .. " SPINS"
							else
							    str = cnt .. " SPIN"
							end
							self.miniSlotAnimList[col].cntLabel:setString(str)
						end), 
						cc.MoveTo:create(1 / 30, cntEndPos)
					)
				)
			end
		end)))

end

function cls:playSlotCntAnim(level, ntype )
	local pos_config = self.slot_config.count_pos
	if ntype == "hide" then 
		if not level then 
			local ls_map = self.vCtl:getMiniSlotMapData()
			for k, temp in pairs(self.miniSlotAnimList) do
				if ls_map[k] > 0 then
					temp.cntNode:runAction(
						cc.Sequence:create(
							cc.MoveTo:create(2 / 30, pos_config.move_pos[k]), 
							cc.MoveTo:create(13 / 30, pos_config.base_pos[k])
						)
					)
				end
			end
		else
	        if self.miniSlotAnimList[level] then   -- 收回计数框
	            local temp = self.miniSlotAnimList[level]
	            temp.cntNode:runAction(
	            	cc.Sequence:create(
	            		cc.MoveTo:create(3 / 30, pos_config.move_pos[level]), 
	            		cc.MoveTo:create(10 / 30, pos_config.base_pos[level])
	     --        		cc.CallFunc:create(function(...)
						-- 	bole.updateSpriteWithFile(temp.stateSp, "#theme225_bonus_tip2.png")
						-- 	temp.cntLabel:setString("")
						-- end),
						-- cc.DelayTime:create(2 / 30), 
						-- cc.MoveTo:create(10 / 30, pos_config.end_pos[level])
	            	)
	            )
	        end
		end
	elseif ntype == "show" then
		local ls_map = self.vCtl:getMiniSlotMapData()
		if self.miniSlotAnimList[level] then
			local temp = self.miniSlotAnimList[level]
			temp.cntNode:runAction(
				cc.Sequence:create(
					cc.MoveTo:create(3 / 30, pos_config.move_pos[level]), 
					cc.MoveTo:create(10 / 30, pos_config.base_pos[level]), 
					cc.CallFunc:create(function(...)
						temp.cntLabel:setString(0 .. " OF " .. ls_map[level]) -- 开始
						bole.updateSpriteWithFile(temp.stateSp, "#theme225_bonus_tip3.png")
					end), 
					cc.DelayTime:create(2 / 30), 
					cc.MoveTo:create(10 / 30, pos_config.end_pos[level])
				)
			)
		end
	end

end

function cls:playChangeSlotAnim( _curSlotIndex, nextIndex, nextFunc )
	
	self.vCtl:playMusicByName("slot_change")

	self.miniSlot:setVisible(true)

	self.miniSlotList[_curSlotIndex]:setPosition(0, 0)
	self.miniSlotList[_curSlotIndex]:setVisible(true)
	self.miniSlotList[_curSlotIndex]:setScale(1)
	self.miniSlotList[_curSlotIndex]:runAction(cc.Spawn:create(cc.MoveTo:create(self.slot_config.slot_move_time, cc.p(-self.slot_config.slot_move_dis, 0)), cc.ScaleTo:create(1, 0.7)))
	self.miniSlotList[nextIndex]:setPosition(self.slot_config.slot_move_dis, 0)
	self.miniSlotList[nextIndex]:setVisible(true)
	self.miniSlotList[nextIndex]:setScale(0.7)
	self.miniSlotList[nextIndex]:runAction(cc.Spawn:create(cc.MoveTo:create(self.slot_config.slot_move_time, cc.p(0, 0)), cc.ScaleTo:create(1, 1)))

	for _, node in pairs(self.slotLineTipList) do 
		node:stopAllActions()
		node:setVisible(false)
	end
	self.slotLineTipList[_curSlotIndex]:setOpacity(255)
	self.slotLineTipList[_curSlotIndex]:setVisible(true)
	self.slotLineTipList[_curSlotIndex]:runAction(cc.FadeOut:create(self.slot_config.slot_move_time))
	self.slotLineTipList[nextIndex]:setOpacity(0)
	self.slotLineTipList[nextIndex]:setVisible(true)
	self.slotLineTipList[nextIndex]:runAction(cc.FadeIn:create(self.slot_config.slot_move_time))

	self.node:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self:playSlotCntAnim(_curSlotIndex, "hide" ) -- 更改上拉的计数
		end),
		cc.DelayTime:create(0.1),
		cc.CallFunc:create(function()
			self:playSlotCntAnim( nextIndex, "show" ) -- 更改上拉的计数
		end),
		cc.DelayTime:create(self.slot_config.slot_move_time),
		cc.CallFunc:create(function(...)
			-- 更改棋盘父节点
			self:showCurMiniSlot()
		end),
		cc.DelayTime:create(0.1),
		cc.CallFunc:create(function()
			if nextFunc then 
		    	nextFunc()
		    end
		end)))
end

function cls:showSlotNodeByAnim( ... )
	local ls_map = self.vCtl:getMiniSlotMapData()
	local curSlotIndex = self.vCtl:getSlotIndex()
	local respinTime = self.vCtl:getRespinTime()

	local pos_config = self.slot_config.count_pos

	self.miniSlot:setOpacity(0)
    self.miniSlot:setVisible(true)
    self.miniSlot:runAction(cc.FadeTo:create(10 / 30, 255))

    for k, temp in pairs(self.miniSlotAnimList) do
        if ls_map[k] > 0 then
            if curSlotIndex > k then
                
                temp.cntNode:setPosition(pos_config.base_pos[k])-- 完成状态  不显示

                -- 完成状态展示完成提示
                -- local movePos = pos_config.end_pos[k]
                -- local statePath = "#theme225_bonus_tip2.png"
                -- local str = ""

                -- temp.cntLabel:setString(str)
                -- bole.updateSpriteWithFile(temp.stateSp, statePath)
                -- temp.cntNode:setPosition(pos_config.base_pos[k])
                -- temp.cntNode:runAction(cc.Sequence:create(cc.MoveTo:create(10 / 30, movePos)))

            else
                local movePos = pos_config.end_pos[k]
                local statePath = "#theme225_bonus_tip1.png"
                local str = ls_map[k] .. " SPINS"
                if ls_map[k] <= 1 then
                    -- 没有进行
                    str = ls_map[k] .. " SPIN"
                end
                if curSlotIndex == k then
                    -- 正在进行
                    movePos = pos_config.end_pos[k]
                    statePath = "#theme225_bonus_tip3.png"
                    str = respinTime .. " OF " .. ls_map[k]
                end
                temp.cntLabel:setString(str)
                bole.updateSpriteWithFile(temp.stateSp, statePath)
                temp.cntNode:setPosition(pos_config.base_pos[k])
                temp.cntNode:runAction(cc.Sequence:create(cc.MoveTo:create(10 / 30, movePos)))
            end
        end
    end
end

function cls:showCurMiniSlot()
	local curSlotIndex = self.vCtl:getSlotIndex()
	
    self.miniSlot:stopAllActions()

    self.miniSlotList[curSlotIndex]:setVisible(true)
    self.miniSlotList[curSlotIndex]:setPosition(0, 0)
    self.miniSlotList[curSlotIndex]:setScale(1)

	self.slotLineTipList[curSlotIndex]:setOpacity(255)
	self.slotLineTipList[curSlotIndex]:setVisible(true)

    self.vCtl:changeSpinLayerNotHide(curSlotIndex + self.slot_config.start_idx)
    self.curMiniSlotNode = self.miniSlotNodeList[curSlotIndex]
    bole.changeParent(self.animateNode, self.curMiniSlotNode.aniNode)
end

-- function cls:setRespinLabel(cur, sum)
--     self.themeCtl.respinCurLabel:setString(cur)
--     self.themeCtl.respinSumLabel:setString(sum)
-- end

function cls:freshRespinNum(cur, sum)
	local curSlotIndex = self.vCtl:getSlotIndex()
    if self.miniSlotAnimList[curSlotIndex] and self.miniSlotAnimList[curSlotIndex]["cntLabel"] then
        self.miniSlotAnimList[curSlotIndex]["cntLabel"]:setString(cur .. " OF " .. sum)
    end
end

function cls:recoverSlotAndBoard()
    local statePath = "#theme225_bonus_tip1.png"
    local str = 0 .. " SPIN"
    local pos_config = self.slot_config.count_pos

    for k, temp in pairs(self.miniSlotAnimList) do
        temp.cntLabel:setString(str)
        bole.updateSpriteWithFile(temp.stateSp, statePath)
        temp.cntNode:setPosition(pos_config.base_pos[k])
    end

    -- 删除 显示
    for k = 1, 3 do
        bole.changeParent(self.slotBoardList[k], self.slotBoardRoot)
    end
    bole.changeParent(self.animateNode, self.boardAniParent, 20)

    self.slotWinAnimNode:removeAllChildren()
    self.miniSlotParent:removeAllChildren()
end

function cls:playRespinStartAnim( ... )
	
	self.vCtl:playMusicByName("roll_up")

	bole.spChangeAnimation(self.slotSpinAnim, "animation2", false)
end

function cls:stopLineAnimate( ... )
	for i, single_node in pairs(self.slotLineList) do 
		if bole.isValidNode(single_node) then 
			single_node:stopAllActions()

			for _, node in pairs(single_node.lines) do 
				node:setVisible(false)
			end
		end
	end
	if bole.isValidNode(self.slotWinAnimNode) then 
		self.slotWinAnimNode:removeAllChildren()
	end
end

function cls:playSlotItemAnim( slot_info ) -- 播放中奖动画
	local slots_type = slot_info.slots_type
	local win_pos_list = self.slot_config.win_pos[slots_type]
	if slot_info.slots_win_line and #slot_info.slots_win_line>0 then 
		for _, id in pairs(slot_info.slots_win_line) do 
			for _, posData in pairs(win_pos_list[id]) do 
				local col = posData[1]
				local row = posData[2]
				local key = slot_info.item_list[col][row]
				local pos = self.vCtl:getCellPos(col, row)
				local spineFile = self.vCtl:getSpineFile("item_slot")
				bole.addSpineAnimation(self.animateNode, nil, spineFile, pos, "animation"..(key-20), nil, nil, nil, true, true)
			end
		end

		if bole.isValidNode(self.slotLineList[slots_type]) then 
			local node = self.slotLineList[slots_type]
			local winLineSet = Set(slot_info.slots_win_line)
			for id, line in pairs(node.lines) do 
				if winLineSet[id] then 
					line:setVisible(true)
				else
					line:setVisible(false)
				end
			end

			node:stopAllActions()
			local fs = 60/60
			node:runAction(
				cc.RepeatForever:create(
					cc.Sequence:create(
						cc.FadeTo:create(fs*0.1, 255),
						cc.DelayTime:create(fs*0.4),		
						cc.FadeTo:create(fs*0.1, 0),
						cc.DelayTime:create(fs*0.4),
						cc.FadeTo:create(fs*0.05, 255),
						cc.DelayTime:create(fs*0.2),		
						cc.FadeTo:create(fs*0.05, 0),
						cc.DelayTime:create(fs*0.2)
					)
				)
			)
				
		end
	end

	if slot_info.slots_win_index and table.nums(slot_info.slots_win_index)>0 then 
		for _, id in pairs(slot_info.slots_win_index) do 
			if id >= 1 and id <= 8 then 
				local data = {}
				data.file = self.vCtl:getSpineFile("slot_win_pay")
				data.parent = self.slotWinAnimNode
				data.isLoop = true
				data.animateName = "animation"..id
				bole.addAnimationSimple(data)
			end
		end
	end
end

function cls:playSlotJpItemAnim( slot_info ) -- 播放中奖动画
	local delay = 1

	self.vCtl:playMusicByName("win_jp")

    local data = {}
	data.file = self.vCtl:getSpineFile("slot_win_kuang")
	data.parent = self.slotWinAnimNode
	data.isLoop = true
	data.animateName = "animation"
	bole.addAnimationSimple(data)

	for _, posData in pairs(slot_info.is_jackpot) do 
		local col = posData[1]
		local row = posData[2]
		local key = slot_info.item_list[col][row]
		local pos = self.vCtl:getCellPos(col, row)
		local spineFile = self.vCtl:getSpineFile("bonus_active")
		bole.addSpineAnimation(self.animateNode, nil, spineFile, pos, "animation"..(key-20)) -- , nil, nil, nil, true, true
	end

	-- if slot_info.slots_win_index and table.nums(slot_info.slots_win_index)>0 then 
	-- 	for _, id in pairs(slot_info.is_jackpot) do 
	-- 		if id ==1 then 
	-- 			local data = {}
	-- 			data.file = self.vCtl:getSpineFile("slot_win_pay")
	-- 			data.parent = self.slotWinAnimNode
	-- 			data.isLoop = true
	-- 			data.animateName = "animation"..id
	-- 			bole.addAnimationSimple(data)
	-- 		end
	-- 	end
	-- end

	return delay 
end




    



