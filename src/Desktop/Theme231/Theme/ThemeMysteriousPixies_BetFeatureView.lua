
ThemeMysteriousPixies_BetFeatureView = class("ThemeMysteriousPixies_BetFeatureView")
local cls = ThemeMysteriousPixies_BetFeatureView

local stickNodeView =  require (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_StickNodeView")) 

function cls:ctor(vCtl, nodeList)

	self.vCtl = vCtl
	self.gameConfig = self.vCtl:getGameConfig()
    self.config = self.gameConfig.sticky_config

	self:_initLayout(nodeList)
end

function cls:_initLayout(nodeList)

	self.symbolDown = nodeList[1]
	self.symbolUp = nodeList[2]
    self.symbolExplode = nodeList[3]

	self.hasCntNode = true
end

function cls:haveFeatureNode( )
	return self.hasCntNode
end


function cls:resetBoardShowByFeature( pType, isAnimate )
    if pType == self.gameConfig.SpinBoardType.Normal then -- normal情况下 需要更改棋盘底板

    elseif pType ==  self.gameConfig.SpinBoardType.FreeSpin then

    end
end

----------------------------------------------------------------------------------------------------
---------------------- stick wild start --------------------
function cls:createStickNode(stickInfo, state)
    local item_state = self.gameConfig.sticky_config.item_state

    local col = stickInfo.col
    local row = stickInfo.row
    self.curStickNodeList = self.curStickNodeList or {}
    self.curStickNodeList[col] = self.curStickNodeList[col] or {}


    if self.curStickNodeList[col][row] then
        local item = self.curStickNodeList[col][row]
        item:updateStickNode(stickInfo, state)
    else
        local item = self.vCtl:getStickNode()
        if item then
            item:refreshStickNode(stickInfo)
        else
            item = stickNodeView.new({self.symbolDown, self.symbolUp}, self.vCtl, stickInfo)
        end
        self.curStickNodeList[col][row] = item
        item:updateStickNode(stickInfo, state)
    end

    -- if state == item_state.disappear or state == item_state.win_bonus then
    --     self:addStickyAni(col, row, state == item_state.win_bonus)
    -- end
end
function cls:addStickyAni(col, row, isByBonus)
    -- local pos = self.vCtl:getCellPos(col, row)
    -- if isByBonus then
    --     local data = {}
    --     data.parent = self.symbolUp
    --     data.file = self.vCtl:getSpineFile("stick_appear")
    --     data.pos = pos
    --     bole.addAnimationSimple(data)
    -- else
    --     local data1 = {}
    --     data1.parent = self.symbolUp
    --     data1.file = self.vCtl:getSpineFile("stick_item")
    --     data1.pos = pos
    --     data1.animateName = "animation4"
    --     data1.zOrder = 101
    --     bole.addAnimationSimple(data1)
    -- end
end

function cls:removeStickNode(col, row, isAni)
    if self:checkIsCreateStickNode(col, row) then
        local item = self.curStickNodeList[col][row]
        if not item then
            return
        end
        if item.removeStickNode then
            item:removeStickNode()
        end
        self.curStickNodeList[col][row] = nil
    end
end

function cls:updateStickNode(data, state)
    -- local item_state = self.gameConfig.sticky_config.item_state

    if self:checkIsCreateStickNode(data.col, data.row) then
        local item = self.curStickNodeList[data.col][data.row]
        if not item then
            return
        end
        item:updateStickNode(data, state)

        -- if state == item_state.disappear then
        --     self:addStickyAni(data.col, data.row)
        -- end
    end
end

function cls:clearCurPageStickNode()
    local col_cnt = self.gameConfig.theme_config.base_col_cnt
    local row_cnt = self.gameConfig.theme_config.base_row_cnt

    self.curStickNodeList = self.curStickNodeList or {}
    for col = 1, col_cnt do
        for row = 1, row_cnt do
            if self.curStickNodeList[col] and self.curStickNodeList[col][row] then
                local node = self.curStickNodeList[col][row]
                node:removeStickNode()
            end
        end
    end
    self.curStickNodeList = {}
end

function cls:checkIsCreateStickNode(col, row)
    if not self.curStickNodeList or not self.curStickNodeList[col] or not self.curStickNodeList[col][row] then
        return false
    end
    return true
end

function cls:checkItemNeedPlayToUp( col, row )
    local item = self.curStickNodeList[col][row]
    if not item then
        return
    end

    return item:checkNeedPlayToUp()
end

-------------- jump nodes start
function cls:playJumpAction(nodeList)

	self.vCtl:playMusicByOnce("bonus_to_wild")
    for key = 1, #nodeList do
        local item = nodeList[key]

        local col = item[1]
        local row = item[2]
        local from = item[3]
        local deep = item[4]

        self:beforeBonusToWild(col, row, from, 0)
        if from ~= 0 then
            self:changeToWildByJump(col, row, from, deep)
        else
            self:beginToWild(col, row, from)
        end
    end
end

function cls:beforeBonusToWild(col, row, from)
    if self.curStickNodeList[col] and self.curStickNodeList[col][row] then
        local item = self.curStickNodeList[col][row]
        item:updateStickNode( nil, self.gameConfig.sticky_config.item_state.win_bonus )
    end
end

function cls:beginToWild( col, row, from )

    self.symbolExplode:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(self.config.to_down_time),
            cc.CallFunc:create(function ( ... )
                self.vCtl:playMusicByOnce("bonus_explode")

                local endPos = self.vCtl:getCellPos(col, row)
                local data = {}
                data.file = self.vCtl:getSpineFile("wild_first")
                data.parent = self.symbolExplode
                data.pos = endPos
                data.zOrder = 500
                bole.addAnimationSimple(data)

                self:changeToWild(col, row, from, 0)
            end)))
end

-- function cls:playExplodeAnim( node, from )

        
--     -- local p1 = cc.ParticleSystemQuad:create(self.vCtl:getParticleFile("jump_tail"))
--     -- s:addChild(p1)
--     -- s:setPosition(startPos)
--     -- s:runAction(cc.Sequence:create(
--     --         cc.MoveTo:create(0.35, cc.p(0, 0)),
--     --         cc.CallFunc:create(function()
--     --             p1:setEmissionRate(0)
--     --         end)
--     -- ))

-- end

function cls:changeToWildByJump(col, row, from, deep)
    local node = cc.Node:create()
    local startPos = self.vCtl:getStartPosByOffset(from)
    local endPos = self.vCtl:getCellPos(col, row)

    self.symbolExplode:addChild(node, 100)
    node:setPosition(endPos)
    local delay1 = self.config.to_down_time 
    delay1 = delay1 + (deep - 1) * (self.config.jump_delay) --  + self.config.jump_delay

    local a1 = cc.DelayTime:create(delay1)
    local a2 = cc.CallFunc:create(function()

        self.vCtl:playMusicByOnce("bonus_wild")
        -- self:playExplodeAnim(node, from)
        local animName = self.vCtl:getExplodeAnimNameByOffset(from) or "animation1"
        local data = {}
        data.file = self.vCtl:getSpineFile("wild_expand")
        data.parent = node
        data.animateName = animName
        local _, s = bole.addAnimationSimple(data)

    end)
    local a3 = cc.DelayTime:create(10 / 30)
    local a4 = cc.CallFunc:create(function()
        self:changeToWild(col, row, from, deep)
    end)
    node:runAction(cc.Sequence:create(a1, a2, a3, a4))
end

function cls:addExpandWildReceive(pos)
    -- local data = {}
    -- data.file = self.vCtl:getSpineFile("wild_expand")
    -- data.parent = self.symbolExplode
    -- data.pos = pos
    -- local _, s = bole.addAnimationSimple(data)
end

function cls:changeToWild(col, row, from, deep)
    local endPos = self.vCtl:getCellPos(col, row)
    
    -- if from < 7 and from > 0 then
        self:addExpandWildReceive(endPos)
    -- end

    self.symbolsSkeleton = self.symbolsSkeleton or {}
    local symbolID = self.gameConfig.special_symbol.wild
    local cell = self.vCtl:getCellItem(col, row)
    if not self.symbolsSkeleton[col .. "_" .. row] then
        local data1 = {}
        data1.file = self.vCtl:getPic("spine/item/" .. symbolID .. "/spine")
        data1.parent = self.symbolExplode
        data1.pos = endPos
        data1.animateName = "animation2"
        data1.isRetain = true
        data1.zOrder = 200
        local _, s1 = bole.addAnimationSimple(data1)
        self.symbolsSkeleton[col .. "_" .. row] = { s1, "animation" }
        
        self.vCtl:changeCellSpriteByPos(col, row, symbolID)
        cell.sprite:setVisible(false)
    end

    self:removeStickNode(col, row)
end

function cls:playStackWildWinAnim( col, row )
    local hasNode = false
    if self.symbolsSkeleton and self.symbolsSkeleton[col .. "_" .. row] then
        local node = self.symbolsSkeleton[col .. "_" .. row][1]
        local animName = self.symbolsSkeleton[col .. "_" .. row][2]
        if node and animName then 
            node:setAnimation(0, animName, false)
        end
        
        hasNode = true
    end

    return hasNode
end

function cls:stopFeatureAnim( ... )
    self.symbolsSkeleton = nil
    self.symbolExplode:stopAllActions()
    self.symbolExplode:removeAllChildren()
end
---------------------- stick wild end ----------------------
-- function cls:changeWildByBet()
--     -- for col = 1, 5 do
--     --     for row = 1, 9 do
--     --         local cell = self.spinLayer.spins[col]:getRetCell(row)
--     --         if cell.key == 14 then
--     --             local key = self.vCtl:getNormalKey()
--     --             self:updateCellSprite(cell, key, col, true, true)
--     --         end
--     --     end
--     -- end
-- end


