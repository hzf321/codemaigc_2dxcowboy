


local ThemeMysteriousPixies_BGMPickItemView = class("ThemeMysteriousPixies_BGMPickItemView")
local cls = ThemeMysteriousPixies_BGMPickItemView

function cls:ctor(vCtl, node, index) -- pickGame, 
	self.node = node
    self.pickGame = vCtl
    self.config = self.pickGame.config

    self.index = index
    self.notOpenNode = cc.Node:create()
    self.node:addChild(self.notOpenNode, 5)
    self.openedNode = cc.Node:create()
    self.node:addChild(self.openedNode)
end

function cls:createItem(dataInfo)
    self.itemInfo = dataInfo

    local item_state = self.config.item_state
    local anim_config = self.config.unopen

    local touchFunc = function(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            self.pickGame:onTouchOnItem(self.index)
        end
    end

    if self.itemInfo.state == item_state.can_open then
        if anim_config.isSpine then
            local data = {}
            data.file = self.pickGame:getSpineFile(anim_config.name)
            data.parent = self.notOpenNode
            data.isRetain = true
            data.animateName = anim_config.aniName[1]
            local _, s = bole.addAnimationSimple(data)
            self.notOpenNode.item = s
        end

        local touchBtn = Widget.newButton(touchFunc, "commonpics/kong.png", "commonpics/kong.png", "commonpics/kong.png", false) --10
        touchBtn:setScale(self.config.item_config.btn_scale[1], self.config.item_config.btn_scale[2])
        touchBtn:setSwallowTouches(true)
        self.notOpenNode:addChild(touchBtn, 10)
        self.touchBtn = touchBtn
    else
        self:openPickItem(self.itemInfo, false)
    end

end

function cls:openPickItem(itemInfo, isOpenAni)
    local delay = 0
    local pickConfig = self.pickGame.config
    local openType = itemInfo.open_type
    local itemAnimConfig = pickConfig.opened[openType]
    
    self:addOpenPickItem(itemAnimConfig, isOpenAni, itemInfo)

    if not isOpenAni then
        self.notOpenNode:removeAllChildren()
        self.notOpenNode.item = nil
    else

        local openDelay = 20/30
        local openTime = 14/30
        delay = openDelay

        self.notOpenNode:runAction(
            cc.Sequence:create(
                cc.CallFunc:create(function()
                    if bole.isValidNode(self.notOpenNode.item) then -- 播放出现动画
                        self.notOpenNode.item:setAnimation(0, pickConfig.unopen.aniName[3], false)
                    end
                end),
                cc.DelayTime:create(openDelay),
                cc.CallFunc:create(function()
                    self.notOpenNode:removeAllChildren()
                    self.notOpenNode.item = nil
                end)
            ))

        self.node:setLocalZOrder(10)
        self.openedNode:setVisible(false)
        self.openedNode:runAction(
            cc.Sequence:create(
                -- cc.DelayTime:create(openDelay),
                cc.Show:create(),
                cc.CallFunc:create(function()
                    local itemSpine = self.openedNode.spine
                    if bole.isValidNode(itemSpine) and itemSpine.aniName then
                        itemSpine:setAnimation(0, itemSpine.aniName, false)
                        itemSpine:addAnimation(0, itemSpine.aniName.."_3", false)
                    end
                end),
                cc.DelayTime:create(openTime),
                cc.CallFunc:create(function()
                    self.node:setLocalZOrder(0)
                end)
            )
        )
    end

    self.itemInfo.open_type = openType
    self.itemInfo.state = itemInfo.state
    self.itemInfo.value = itemInfo.value

    return delay
end

function cls:addOpenPickItem(itemConfig, isOpenAni, itemInfo)
    if not itemConfig then return end

    if isOpenAni and itemConfig.music then 
        self.pickGame:playMusicByName(itemConfig.music)
    end
    
    for key, info in pairs(itemConfig) do
        if info.isSpine then
            local data = {}

            data.file = self.pickGame:getSpineFile(info.name)
            data.parent = self.openedNode
            data.isLoop = true
            data.zOrder = info.zOrder
            local aniName = info.aniName
            if itemInfo.open_type == "jp" and itemInfo.value then 
                aniName = string.format(info.aniName, (itemInfo.value - 6))
            end
            
            data.animateName = aniName.."_1"
            if itemInfo.state == self.pickGame.config.item_state.old_open then 
                data.animateName = aniName.."_2"
            end
            
            local _, s = bole.addAnimationSimple(data)

            self.openedNode.spine = s
            self.openedNode.spine.aniName = aniName
        end
        if info.isFnt then
            local str = info.name
            local fntFile = self.pickGame:getFntFilePath(str)
            local fntLabel = NumberFont.new(fntFile, nil, true)
            fntLabel:setScale(info.scale)
            self.openedNode:addChild(fntLabel, 3)

            function fntLabel:setString( n )  -- 控制显示文字 带k,m 同时保留3位有效数字
                if n == 0 then 
                    self.font:setString("")
                else
                    self.font:setString(FONTS.formatByCount4(n, 4, true))
                end
            end

            if self.itemInfo and self.itemInfo.coins_value then 
                fntLabel:setString(self.itemInfo.coins_value)
            else
                fntLabel:setString(itemInfo.value*self.pickGame:getFeatureBet())
            end
            self.openedNode.fnt = fntLabel
        end
    end

    if itemInfo.state == self.pickGame.config.item_state.old_open then
        bole.setEnableRecursiveCascading(self.openedNode, true)
        self.openedNode:setColor(cc.c3b(125, 125, 125))
    end
end

function cls:playShowAnim()
    local pickConfig = self.pickGame.config
    if bole.isValidNode(self.notOpenNode.item) then -- 播放出现动画
        self.notOpenNode.item:setAnimation(0, pickConfig.unopen.aniName[1], false)
    end
    local _show_t = pickConfig.item_show_t
    local _move_t = pickConfig.item_move_t
    local endPos = cc.p(self.node:getPosition())
    local startPos = pickConfig.start_pos
    local endPos1 = ccp(0, endPos.y)

    self.node:setVisible(true)
    self.node:setPosition(startPos)
    self.node:runAction(
        cc.Sequence:create(
            cc.MoveTo:create(_show_t, endPos1),
            cc.MoveTo:create(_move_t, endPos)))
end

function cls:multiPickItem(dataInfo, newValue)
    self.itemInfo.value = newValue

    if bole.isValidNode(self.openedNode.fnt) and newValue then 
        self.openedNode.fnt:setString(newValue*self.pickGame:getFeatureBet())
    end
end

function cls:playLoopTipAnim()
    if bole.isValidNode(self.notOpenNode.item) then 
        self.notOpenNode.item:setAnimation(0, string.format(self.pickGame.config.unopen.aniName[2]), false)
    end
end

return cls