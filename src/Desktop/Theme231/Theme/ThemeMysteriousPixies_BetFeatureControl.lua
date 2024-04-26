

local parentClass = ThemeBaseViewControlDelegate
ThemeMysteriousPixies_BetFeatureControl = class("ThemeMysteriousPixies_BetFeatureControl", parentClass)
local cls = ThemeMysteriousPixies_BetFeatureControl
require (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_BetFeatureView")) 
function cls:ctor(mainCtl)

    parentClass.ctor(self, mainCtl)

    self:setStickNodePool()
end

function cls:initLayout( nodeList )
	self._view = ThemeMysteriousPixies_BetFeatureView.new(self, nodeList)
end


function cls:resetBoardShowByFeature( state, isAnimate )
	self._view:resetBoardShowByFeature(  state, isAnimate )
end

function cls:betFeatureStopCtl( stopRet )
    self.isWinWildGame = false
    self.isHasNewDisk = false
    self.canCollectCoins = false

    if stopRet.theme_info then
        local _old_disk = tool.tableClone(self:getCurDiskData())
        if stopRet.theme_info.disk_data then 
            self:refreshDiskData(stopRet.theme_info)
        end
        local _cur_disk = self:getCurDiskData()
        if _old_disk and _cur_disk and table.nums(_old_disk) < table.nums(_cur_disk) then 
            self.isHasNewDisk = true
        end
        if stopRet.bonus_game and stopRet.bonus_game.bet_bonus then 
            self.isWinWildGame = true
            self.wildBonusData = tool.tableClone(stopRet.bonus_game.bet_bonus)
            stopRet.bonus_game.bet_bonus = nil

            if stopRet.bonus_game.bonus_type == 1 then 
                stopRet.bonus_game = nil
                self.canCollectCoins = true
            end
        end
    end
end

function cls:hasFeature( ... )
    return (self.isHasNewDisk or self.isWinWildGame)
end

function cls:themeInfoDealStick( specialData, endFuc )

    if self.isHasNewDisk then 
        self.isHasNewDisk = false
        self:addStickNodeByThemeInfo(endFuc)
    elseif self.isWinWildGame then 
        self.isWinWildGame = false
        self:winStickNode(specialData, endFuc)    
    end
end

function cls:hasWinFeature( ... )
    return self.isWinWildGame
end

---------------------------------- spin cnt 相关 ----------------------------------
-- 参数:
-- disk_data[bet] = {参数1, 参数2, 参数3}.
-- 参数1:红蓝宝石类型(红宝石计数); 参数2:位置(1-25); 参数3:计数(红宝石位0时,变成wild)
function cls:refreshDiskData(data)

	if data["all_disk_data"] then
		self.diskData = data["all_disk_data"]
	end
	if data["disk_data"] then
		local curBet = self._mainViewCtl:getCurBet() -- *self.ctl.maxLine
		if not self.diskData then self.diskData = {} end
		if data["disk_data"][tostring(curBet)] then 
			self.diskData[tostring(curBet)] = data["disk_data"][tostring(curBet)]
		end
	end
end

function cls:getCurDiskData(Bet)
	if not self.diskData then return end
	local curDiskData = {}

	-- base
	local curBet = ""
	if Bet then
		curBet = tostring(Bet)
	else
		curBet = tostring(self._mainViewCtl:getCurBet())--*self.ctl.maxLine
	end
	if self.diskData[curBet] then 
		curDiskData = self.diskData[curBet]
	else
		local maxdiskKey = nil
		for k,v  in pairs(self.diskData) do
			maxdiskKey = k
			if curBet<=k then 
				curDiskData = self.diskData[k]
				break
			end
		end
		if not curDiskData then
			curDiskData = self.diskData[maxdiskKey]
		end
	end

	return curDiskData
end

function cls:topSetBet(data) -- 后续 需要确认 是否 快速点击的时候最后停下的位置 正确的
    self:clearCurPageStickNode()
    self:initStickLeftWild()
end

function cls:refreshBetFeatureShowBySpin( rdata )
    self:removeStickNodeBySpin()
    self:changeNewStickBySpin()
end

---------------------------------------------------------------------------------------------------
------------------- stick wild start ------------------
function cls:checkNeedChangeWild(col, row, new_item_list)
    if not self:checkIsValibleColAndRow(col, row) then
        return false
    end
    if not self:checkHaveSticky(col, row) then
        return false
    end
    if new_item_list[col][row] == self.gameConfig.special_symbol.wild then
        return false
    end
    return true
end

---@desc BFS查找相邻的 lock_pos 并将该点变成wild
function cls:breadthFirstSearch(new_item_list, center_from)
    local maxDeep = 1
    local index = 1
    while #self.changeWildNodeList >= index do
        local node = self.changeWildNodeList[index]
        index = index + 1
        local col = node[1]
        local row = node[2]
        local from = node[3]
        local deep = node[4]
        if maxDeep < deep then
            maxDeep = deep
        end

        local row1 = row - 1
        local row2 = row + 1
        local leftCol = col - 1
        local rightCol = col + 1

        local checkList = { -- 顺序跟 sticky_dir 对应
            {leftCol, row1}, {leftCol, row2}, {rightCol, row1}, {rightCol, row2}, -- 斜角扩散
            {col, row1}, {col, row2}, {leftCol, row}, {rightCol, row}, -- 十字扩散
        }

        for dir, pos in pairs(checkList) do -- 方向, 位置
            if self:checkNeedChangeWild(pos[1], pos[2], new_item_list) then -- 左
                new_item_list[pos[1]][pos[2]] = self.gameConfig.special_symbol.wild
                table.insert(self.changeWildNodeList, { pos[1], pos[2], dir, deep + 1 })
            end
        end
    end

    return maxDeep
end

function cls:checkIsValibleColAndRow(realCol, realRow)
    local col_cnt = self.gameConfig.theme_config.base_col_cnt
    local row_cnt = self.gameConfig.theme_config.base_row_cnt

    if realCol > 0 and realCol <= col_cnt then
        if realRow > 0 and realRow <= row_cnt then
            return true
        end
    end
    return false
end

function cls:getStartPosByOffset(from) -- dir 类型相关, 通过类型，找相对当前坐标的扩散坐标
-- 反向
    local stickDir = self.gameConfig.sticky_config.sticky_dir
    local c_width = self.gameConfig.theme_config.g_cell_width
    local c_height = self.gameConfig.theme_config.g_cell_height
    if from == 0 then
        return cc.p(0, 0)
    elseif from == stickDir.left_up then
        return cc.p(c_width, -c_height)
    elseif from == stickDir.left_down then
        return cc.p(c_width, c_height)
    elseif from == stickDir.right_up then
        return cc.p(-c_width, -c_height)
    elseif from == stickDir.right_down then
        return cc.p(-c_width, c_height)
    elseif from == stickDir.left then
        return cc.p(c_width, 0)
    elseif from == stickDir.right then
        return cc.p(-c_width, 0)
    elseif from == stickDir.up then
        return cc.p(0, -c_height)
    elseif from == stickDir.down then
        return cc.p(0, c_height)
    end
end

function cls:getExplodeAnimNameByOffset(from) -- dir 类型相关, 通过类型，找相对当前坐标的扩散坐标
-- 反向
    local stickDir = self.gameConfig.sticky_config.sticky_dir
    local animName = "animation1"
    
    if from == stickDir.left_up then
        animName = "animation3"
    elseif from == stickDir.left_down then
        animName = "animation2"
    elseif from == stickDir.right_up then
        animName = "animation4"
    elseif from == stickDir.right_down then
        animName = "animation1"
    elseif from == stickDir.left then
        animName = "animation8"
    elseif from == stickDir.right then
        animName = "animation7"
    elseif from == stickDir.up then
        animName = "animation5"
    elseif from == stickDir.down then
        animName = "animation6"
    end
    return animName
end

function cls:initStickLeftWild()

    local lock_pos = self:getCurDiskData()
    local _state = self.gameConfig.sticky_config.item_state.reset
    if lock_pos then 
        for _, itemData in pairs(lock_pos) do 
            local col, row = self._mainViewCtl:getReelColAndRow(itemData[2])
            local data = self:getStickyInfo(itemData, col, row)
            self:createStickNode(data, _state)
        end
    end
end

function cls:checkHaveSticky(col, row)
    local col_cnt = self.gameConfig.theme_config.base_col_cnt

    local lock_pos = self:getCurDiskData()
    local index = (row - 1)*col_cnt + col

    for _, itemData in pairs(lock_pos) do 
        if itemData and itemData[2] == index then 
            return true
        end
    end

    return false
end

function cls:clearCurPageStickNode()
    self._view:clearCurPageStickNode()
end

function cls:addStickNodeByThemeInfo(endFuc)
    local col_cnt = self.gameConfig.theme_config.base_col_cnt
    local row_cnt = self.gameConfig.theme_config.base_row_cnt

    local find = false
    local lock_pos = self:getCurDiskData()
    if lock_pos then
        for _, itemData in pairs(lock_pos) do
            if itemData[2] then 
                local col, row = self._mainViewCtl:getReelColAndRow(itemData[2])

                if not self:checkIsCreateStickNode(col, row) then
                    find = true
                    break
                end
            end

        end
    end

    if find then
        self:playMusicByName("bonus_disappear")
        local state = self.gameConfig.sticky_config.item_state.disappear
        for _, itemData in pairs(lock_pos) do
            if itemData[2] then 
                local col, row = self._mainViewCtl:getReelColAndRow(itemData[2])
                local data = self:getStickyInfo(itemData, col, row)
                if not self:checkIsCreateStickNode(col, row) then
                    self:createStickNode(data, state)
                end
            end
        end
    end

    if endFuc then 
        self.node:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(15/30),
                cc.CallFunc:create(function ( ... )
                    endFuc()
                end)))
    end
end

function cls:changeNewStickBySpin( ... )
    local col_cnt = self.gameConfig.theme_config.base_col_cnt
    local row_cnt = self.gameConfig.theme_config.base_row_cnt

    local lock_pos = self:getCurDiskData()

    local playAnim = false
    for _, itemData in pairs(lock_pos) do 
        local col, row = self._mainViewCtl:getReelColAndRow(itemData[2])
        playAnim = self._view:checkItemNeedPlayToUp(col, row)
        if playAnim then 
            self:playMusicByName("bonus_up")
            break
        end
    end


    local state = self.gameConfig.sticky_config.item_state.new_spin
    for _, itemData in pairs(lock_pos) do
        local col, row = self._mainViewCtl:getReelColAndRow(itemData[2])
        local data = self:getStickyInfo(itemData, col, row, true)

        if not self:checkIsCreateStickNode(col, row) then
            self:createStickNode(data, state)
        else
            self:updateStickNode(data, state)
        end

    end
end

function cls:getStickyInfo(itemData, col, row, sub)
    local data = {
        show_type = itemData[1],
        pos_index = itemData[2],
        lb_num = sub and itemData[3] - 1 or itemData[3],
        col = col,
        row = row,
    }

    return data
end

function cls:removeStickNodeBySpin()
    local col_cnt = self.gameConfig.theme_config.base_col_cnt
    local row_cnt = self.gameConfig.theme_config.base_row_cnt
    local curDisk = self:getCurDiskData()

    local diskPosList = {{}, {}, {}, {}, {}}
    for _, data in pairs(curDisk) do 
        if data and data[2] then
            local col, row = self._mainViewCtl:getReelColAndRow(data[2])
            diskPosList[col][row] = 1
        end
    end

    for col = 1, col_cnt do
        for row = 1, row_cnt do
            if diskPosList and diskPosList[col] and diskPosList[col][row] then
            else
                if self:checkIsCreateStickNode(col, row) then
                    self:removeStickNode(col, row)
                end
            end
        end
    end
end

function cls:checkIsCreateStickNode(col, row)

    return self._view:checkIsCreateStickNode(col, row)
end

function cls:createStickNode(...)
    return self._view:createStickNode(...)
end
function cls:removeStickNode(...)

    self._view:removeStickNode(...)
end
function cls:updateStickNode(...)

    return self._view:updateStickNode(...)
end

function cls:winStickNode(ret, callFunc)
    self.winStickEndFunc = nil
    self.newDiskData = nil

    local boomDelay = self:dealChangeWild(self:getCurDiskData())

    if boomDelay > 0 then
        self.winStickEndFunc = callFunc
        self.canThemeSkip = true

        self.newDiskData = {
            disk_data = {
                [self._mainViewCtl:getCurBet()..""] = tool.tableClone(self.wildBonusData["reset_board"])
            }
        }

        self.node:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(boomDelay),
                cc.CallFunc:create(function ( ... )
                    if self.winStickEndFunc then 
                        if self.canCollectCoins then 
                            self._mainViewCtl:collectCoins(1)
                        end
                        self:winStickEndFunc()
                        self.winStickEndFunc = nil
                        self:refreshDiskData(self.newDiskData)
                    end
                end)))

        self.wildBonusData = nil
    else
        callFunc()
    end
end

function cls:dealChangeWild(map_wild_info)
    if not map_wild_info or #map_wild_info == 0 then
        return 0
    end

    local col_cnt = self.gameConfig.theme_config.base_col_cnt
    local row_cnt = self.gameConfig.theme_config.base_row_cnt
    local sticky_config = self.gameConfig.sticky_config

    self.new_item_list = tool.tableClone(self._mainViewCtl:getRetMatrix())

    if not self.new_item_list then return 0 end

    self.changeWildNodeList = {}
    local maxDeep = 0

    for _, itemData in pairs(map_wild_info) do 
        if itemData[1] == sticky_config.up_super then -- 代表计数红宝石
            if itemData[3] == sticky_config.last_num then -- 表示计数为0 
                local col, row = self._mainViewCtl:getReelColAndRow(itemData[2])
                local cellKey = self.gameConfig.special_symbol.wild
                self.new_item_list[col][row] = cellKey
                table.insert(self.changeWildNodeList, { col, row, 0, 0 })
            end
        end
    end

    maxDeep = self:breadthFirstSearch(self.new_item_list)
    if #self.changeWildNodeList > 0 then
        self:playJumpAction(self.changeWildNodeList)

        local time = (
            (maxDeep - 1) * sticky_config.jump_delay 
            + sticky_config.jump_single 
            + sticky_config.change_wild 
            + sticky_config.to_down_time
        )
        return time
    end
    return 0
end
function cls:playJumpAction(nodeList)
    self:playMusicByName("bonus_down")
    
    self._view:playJumpAction(nodeList)
end

function cls:playStackWildWinAnim( col, row )
    return self._view:playStackWildWinAnim(col, row)
end

function cls:stopFeatureAnim( )
    self._view:stopFeatureAnim()
end

------------------- stick wild end ------------------

------ stick node factory start ----------------------
function cls:setStickNodePool()

    self.stickNodeList = {}
end

function cls:getStickNode()
    if self.stickNodeList and #self.stickNodeList > 0 then
        local item = table.remove(self.stickNodeList)
        return item
    end
    return nil
end

function cls:addStickNodeToPool(item)
    table.insert(self.stickNodeList, item)
end

function cls:removeAllStickNode()
    
    for key, item in pairs(self.stickNodeList) do
        item.downNode:release()
        item.topNode:release()
    end

    self.stickNodeList = {}

end
------ stick node factory end ----------------------


------------------------------------------------------------------------------------------------
function cls:changeCellSpriteByPos( ... )
    self._mainViewCtl:changeCellSpriteByPos( ... )
end
