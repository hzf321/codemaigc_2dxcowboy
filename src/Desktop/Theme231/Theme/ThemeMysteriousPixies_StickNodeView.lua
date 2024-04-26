

local cls = class("ThemeMysteriousPixies_StickNodeView")

function cls:ctor(nodeList, vCtl, data)

    self.symbolDown = nodeList[1]
    self.symbolUp = nodeList[2]
    self.betFeatureCtl = vCtl
    self.data = data

    self.config = self.betFeatureCtl:getGameConfig().sticky_config
    self.showType = 1
    self:initStickNode()
    self:setStickNodePos()
    -- self:updateStickEndge()
end
function cls:initStickNode()
    self.itemData = {}
    local zorder = self.data.row + (5 - self.data.col) * 10

    self.downNode = cc.Node:create()
    self.downImg = bole.createSpriteWithFile("#theme231_s_bottom.png")
    self.downNode:addChild(self.downImg)

    self.symbolDown:addChild(self.downNode, zorder)

    self.topNode = cc.Node:create()

    local data1 = {}
    data1.file = self.betFeatureCtl:getSpineFile('stick_item')
    data1.parent = self.topNode
    data1.isRetain = true
    data1.animateName = "animation2_2"
    local _, s1 = bole.addAnimationSimple(data1)
    self.top_item = s1

    local data2 = {}
    data2.file = self.betFeatureCtl:getSpineFile('stick_num')
    data2.parent = self.topNode
    data2.animateName = "animation4_1"
    data2.isRetain = true
    local _, s2 = bole.addAnimationSimple(data2)
    self.top_num = s2
    self.top_num:setVisible(false)

    self.symbolUp:addChild(self.topNode, zorder)

    -- self:addLoopAni()
end

-- function cls:addLoopAni()
--     local data = {}
--     data.file = self.betFeatureCtl:getSpineFile('stick_loop')
--     data.parent = self.topNode
--     data.isLoop = true
--     bole.addAnimationSimple(data)
-- end

function cls:setStickNodePos()
    local pos = self.betFeatureCtl:getCellPos(self.data.col, self.data.row)
    
    self.downNode:setPosition(pos)
    self.topNode:setPosition(pos)
end

function cls:refreshStickNode(data)
    self.data = data
    
    self.symbolDown:addChild(self.downNode)
    self.symbolUp:addChild(self.topNode)

    self.downNode:setLocalZOrder(self.data.row + (5 - self.data.col) * 10)
    self.topNode:setLocalZOrder(self.data.row + (5 - self.data.col) * 10)
    self.downNode:release()
    self.topNode:release()

    self:setStickNodePos()
end

function cls:updateStickNode(data, state)
    if data then 
        local old_data = self.data
        self.data = data

        if self.data.col ~= old_data.col or self.data.row ~= old_data.row then
            self.data.row = old_data.row
            self.data.col = old_data.col
            self:setStickNodePos()
        end
    end

    self:updateStickEndge(state)
end

function cls:updateStickEndge(state)
    local item_state = self.config.item_state

    self.top_num:stopAllActions()

    if state == item_state.reset then
        self:updateStickByReset()
    elseif state == item_state.disappear then
        self:updateStickByDisapper()

    elseif state == item_state.new_spin then
        self:updateStickBySpin()

    elseif state == item_state.win_bonus then
        self:updateStickByBonus()
    end
end

function cls:updateStickByReset( ... )
    local bonus_anim = self.config.bonus_anim
    local num_anim = self.config.num_anim

    if self.data.show_type ~= self.config.up_super then 
        self.top_num:setVisible(false)

        self.top_item.animName = bonus_anim.gree_up_loop
        self.top_item:setAnimation(0, bonus_anim.gree_up_loop, false)
    else
        self.top_item:setAnimation(0, bonus_anim.red_up_loop, true)
        self.top_item.animName = bonus_anim.red_up_loop

        if self.data.lb_num and self.data.lb_num > 0 then 
            local numAnim = string.format(num_anim.num_up_loop, self.data.lb_num)
            
            self.top_num:setVisible(true)
            self.top_num:setAnimation(0, numAnim, true)
        end
    end
end

function cls:updateStickByDisapper( ... )
    local bonus_anim = self.config.bonus_anim
    local num_anim = self.config.num_anim

    if self.data.show_type ~= self.config.up_super then 
        self.top_num:setVisible(false)

        self.top_item.animName = bonus_anim.n_to_green
        self.top_item:setAnimation(0, bonus_anim.n_to_green, false)
    else
        self.top_item:setAnimation(0, bonus_anim.n_to_red, false)
        self.top_item.animName = bonus_anim.n_to_red
        
        if self.data.lb_num and self.data.lb_num > 0 then
            self.top_item:addAnimation(0, bonus_anim.red_loop, true)
            self.top_item.animName = bonus_anim.red_loop
        end

        if self.data.lb_num and self.data.lb_num > 0 then 
            local numAnim = string.format(num_anim.num_loop, self.data.lb_num)

            self.top_num:setVisible(true)
            self.top_num:setAnimation(0, numAnim, true)
        end
    end
end

function cls:checkNeedPlayToUp( ... )
    local bonus_anim = self.config.bonus_anim
    if self.top_item.animName 
        and (
            self.top_item.animName == bonus_anim.n_to_green 
            or self.top_item.animName == bonus_anim.red_loop) 
        then 
        return true
    end
end

function cls:updateStickBySpin( ... )
    local bonus_anim = self.config.bonus_anim
    local num_anim = self.config.num_anim

    if self.data.show_type ~= self.config.up_super then 
        if self.top_item.animName == bonus_anim.n_to_green then 
            self.top_item.animName = bonus_anim.gree_to_up
            self.top_item:setAnimation(0, bonus_anim.gree_to_up, false)
        end
    else
        if self.data.lb_num then 
            if self.data.lb_num ~= 0 then 
                local numAnimList = {}
                if self.top_item.animName == bonus_anim.red_loop then 
                    local numAnim1 = string.format(num_anim.num_to_up, self.data.lb_num)
                    table.insert(numAnimList, {numAnim1, false})
                end
                local numAnim = string.format(num_anim.num_up_loop, self.data.lb_num)
                table.insert(numAnimList, {numAnim, self.data.lb_num ~= 0})

                for k, animData in pairs(numAnimList) do 
                    if k == 1 then 
                        self.top_num:setAnimation(0, animData[1], animData[2])
                    else
                        self.top_num:addAnimation(0, animData[1], animData[2])
                    end
                end
            else
                self.top_num:setVisible(false)
            end

            if self.data.lb_num == 0 then 
                self.top_item:setAnimation(0, bonus_anim.red_will_win, true)
                self.top_item.animName = bonus_anim.red_will_win
            end
        end

        if self.top_item.animName == bonus_anim.red_loop then 
            self.top_item:setAnimation(0, bonus_anim.red_to_up, false)
            self.top_item:addAnimation(0, bonus_anim.red_up_loop, true)
            self.top_item.animName = bonus_anim.red_up_loop
        end
    end
end

function cls:updateStickByBonus( ... )
    local bonus_anim = self.config.bonus_anim

    self.top_num:setVisible(false)
    
    if self.top_item.animName == bonus_anim.n_to_red then return end -- 新出现的 红色不播放 up_to_down

    local isHasAnim = false
    if self.data.show_type ~= self.config.up_super then
        self.top_item:setAnimation(0, bonus_anim.green_to_down, false)
        self.top_item.animName = bonus_anim.green_to_down

        isHasAnim = true
    else
        self.top_item:setAnimation(0, bonus_anim.red_to_down, false)
        self.top_item.animName = bonus_anim.red_to_down

        isHasAnim = true
    end
    
    -- if isHasAnim then 
    --     local cell = self.betFeatureCtl:getCellItem(self.data.row, self.data.col)
    --     if cell and bole.isValidNode(cell.sprite) then 
    --         cell.sprite:runAction(cc.FadeOut:create(0.2))
    --     end
    -- end
end

function cls:removeStickNode()

    self.top_num:stopAllActions()

    self.downNode:retain()
    self.downNode:removeFromParent()

    self.topNode:retain()
    self.topNode:removeFromParent()

    self.betFeatureCtl:addStickNodeToPool(self)

end

return cls