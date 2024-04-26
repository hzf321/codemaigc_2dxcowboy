-- @Author: xiongmeng
-- @Date:   2020-11-12 11:18:49
-- @Last Modified by:   xiongmeng
-- @Last Modified time: 2020-12-03 11:45:36
local cls = class("MightyC_CollectView")
function cls:ctor(ctl, collectRoot, collectTip)
	self.ctl = ctl
	self.gameConfig = self.ctl:getGameConfig()
	self.mapCollectRoot = collectRoot
    self.collectInfoTip = collectTip
    self.reelCoinFlyLayer = self.ctl:getFlyLayer()
	self:_initLayout()
end
function cls:_initLayout( ... )
    self.collectFullAniNode = self.mapCollectRoot:getChildByName("progress_ani")
    self.lockAniNode = self.mapCollectRoot:getChildByName("progress_lock")
    self.btnUnlockCollect = self.mapCollectRoot:getChildByName("collect_btn")
    self.collectInfoTip:setScale(0)
    self.collectInfoTip:setVisible(true)
	self:_initProgressNode()
	self:_setUnlockCollectEvent()
end
function cls:_initProgressNode()
    local progress_node = self.mapCollectRoot:getChildByName("progress_node")
    local loopFile = self.ctl:getSpineFile("collect_loop")
    local loopFile1 = self.ctl:getSpineFile("collect_loop1")
    self.progressNode = progress_node
    self.progressListNode = {}
    for key = 1, 10 do
        local progressItem = progress_node:getChildByName("progress"..key)
        local collectNode = progressItem:getChildByName("collect_node")
        bole.addSpineAnimationInTheme(collectNode,nil,loopFile,cc.p(37/2, 28/2),"animation",nil,nil,nil,true,true)
        if key == 10 then
            bole.addSpineAnimationInTheme(progressItem,nil,loopFile1,cc.p(0,0),"animation",nil,nil,nil,true,true)
        end
        collectNode.baseScale = collectNode:getScale()
        progressItem.collectNode = collectNode
        self.progressListNode[key] = progressItem
    end
end
function cls:setCollectNodeEnable(enable)
    self.progressNode:setVisible(enable)
end
function cls:addSuperBonusJili()
    if not self.superBonusJiliSpine then
        local targetNode = self.progressListNode[10]
        local targetWPos = bole.getWorldPos(targetNode)
        local targetNPos = bole.getNodePos(self.lockAniNode, targetWPos)
        local file = self.ctl:getSpineFile("collect_super_jili")
        local _, spine = bole.addSpineAnimationInTheme(self.lockAniNode, nil, file, targetNPos, "animation", nil, nil, nil, true, true)
        self.superBonusJiliSpine = spine
    end
end
function cls:cleanSuperBonusJili()
    if self.superBonusJiliSpine and bole.isValidNode(self.superBonusJiliSpine) then
        self.superBonusJiliSpine:removeFromParent()
        self.superBonusJiliSpine = nil
    end
end
function cls:_setUnlockCollectEvent( ... )
	local function onTouch(obj, eventType)
	    if eventType == ccui.TouchEventType.ended then
	    	if self.ctl:checkCollectBtnCanTouch() then
	    		self.ctl:collectBtnClickEvent()
	    	end
	    end
	end
	self.btnUnlockCollect:addTouchEventListener(onTouch)
end
function cls:showCollectTip()
    if self.collectTipStatus then 
        self:hideColelctTip(true)
        return 
    end
    self.collectTipStatus = true
    self.collectInfoTip:stopAllActions()
    local currentScale = self.collectInfoTip:getScale()
    local showTime = 0.2 * (1 - currentScale)
    local a1 = cc.ScaleTo:create(showTime, 1)
    local a2 = cc.DelayTime:create(3)
    local a3 = cc.CallFunc:create(function ()
        self:hideColelctTip(true)
    end)
    local a4 = cc.Sequence:create(a1,a2,a3)
    self.collectInfoTip:runAction(a4)
end
function cls:hideColelctTip(isAnimation)
    if not self.collectTipStatus then return end
    if isAnimation then 
        if self.collectInfoTip.hideCurrent then 
            return
        end
        self.collectInfoTip:stopAllActions()
        local currentScale = self.collectInfoTip:getScale()
        local hideTime = 0.2 * currentScale
        local a1 = cc.ScaleTo:create(hideTime, 0)
        local a2 = cc.CallFunc:create(function ()
            self.collectTipStatus = false
            self.collectInfoTip.hideCurrent = false
        end)
        local a3 = cc.Sequence:create(a1,a2)
        self.collectInfoTip.hideCurrent = true
        self.collectInfoTip:runAction(a3)
    else 
        self.collectInfoTip:stopAllActions()
        self.collectInfoTip:setScale(0)
        self.collectTipStatus = false
        self.collectInfoTip.hideCurrent = false
    end
end

function cls:updateCollectPrImagePos( mapLevel )
    self:updateCollectRightImage(mapLevel)
end
function cls:updateCollectRightImage(mapLevel)
    mapLevel = mapLevel or self.ctl:getCurrentMapLevel()
    if not self.progressListNode then return end
    for key, val in ipairs(self.progressListNode) do 
        local collectNode = val.collectNode
        if mapLevel >= key then
            collectNode:setVisible(true)
        else 
            collectNode:setVisible(false)
        end
    end
end
function cls:setCollectPartState(isLock, isAnimate)
    local collectFeatureAnimation = self.gameConfig.collectAnimation
    self.lockAniNode:stopAllActions()
    local pos = cc.p(470, -38) --475
    if isLock then 
        if not self.lockSuperSpine then
            local file = self.ctl:getSpineFile("collect_unlock")
            local _, s = bole.addSpineAnimationInTheme(self.lockAniNode, nil, file, pos, collectFeatureAnimation["lock"], nil, nil, nil, true, nil)
            self.lockSuperSpine = s
        end
        local changeDelay = 0
        self.ctl.isLockFeature = true
        if isAnimate then
            if self.notFirstEnterTheme then
                self.ctl:playMusicByName("collect_lock")
            end
            bole.spChangeAnimation(self.lockSuperSpine, collectFeatureAnimation["lock"])
            changeDelay = 25/30
        end
        self.lockSuperSpine:setVisible(true)
        local a1 = cc.DelayTime:create(changeDelay)
        local a2 = cc.CallFunc:create(function ()
            bole.spChangeAnimation(self.lockSuperSpine, collectFeatureAnimation["lockLoop"], true)
        end)
        local a3 = cc.Sequence:create(a1, a2)
        self.lockAniNode:runAction(a3)
        self:setCollectNodeEnable(false)
        self:hideColelctTip()
    else 
        self.ctl.isLockFeature = false
        if not self.lockSuperSpine then
            local file = self.ctl:getSpineFile("collect_unlock")
            local _, s = bole.addSpineAnimationInTheme(self.lockAniNode, nil, file, pos, collectFeatureAnimation["unlock"], nil, nil, nil, true, nil)
            self.lockSuperSpine = s
        end
        self:setCollectNodeEnable(true)
        if isAnimate then
            self.lockSuperSpine:setVisible(true)
            bole.spChangeAnimation(self.lockSuperSpine, collectFeatureAnimation["unlock"])
            if self.notFirstEnterTheme then
                self.ctl:playMusicByName("collect_unlock")
            end
            if self.ctl:checkCollectBtnCanTouch() then
                self:showCollectTip()
		    end
        else 
            self.lockSuperSpine:setVisible(false)
        end
    end
    self.notFirstEnterTheme = true
    self.ctl:setPlayFirstTimeInFeature()
end
--@collectM1
function cls:showCoinsFlyToUp( flyTime, isFull )
    if isFull then
        self.ctl:playMusicByName("white_collect2")
    else
        self.ctl:playMusicByName("white_collect1")
    end
    
    local targetNode = self:getTagetCollectNodePos()
    local endNPos = bole.getWorldPos(targetNode)
    local endPos  = bole.getNodePos(self.reelCoinFlyLayer, endNPos)
    local isPlay = true
    local item_list = table.copy(self.ctl:getItemList())
    local targetSymbol = 120
    if item_list then
        for col, item in pairs(item_list) do
            for row, collectId in pairs(item) do
                if collectId >= targetSymbol then
                    self:getFlyM1Node(col, row, endPos, isPlay, flyTime)
                    isPlay = false
                end
            end
        end
    end
end
function cls:getTagetCollectNodePos()
    local level = self.ctl:getCurrentMapLevel()
    if level >= self.ctl.maxMapLevel then
        level = 10
    elseif level <= 1 then
        level = 1
    end
    return self.progressListNode[level]
end
function cls:getFlyM1Node( col, row, endPos, isPlay, flyToUpTime )
    -- local pos = self.ctl:getCellPos(col, row)
    local cell = self.ctl:getCellNode(col, row)
    local wPos = bole.getWorldPos(cell)
    local pos = bole.getNodePos(self.reelCoinFlyLayer, wPos)

    local node = cc.Node:create()
    local flyTime = flyToUpTime
    local delayTime = 7/30
    node:setPosition(pos)
    self.reelCoinFlyLayer:addChild(node, row)
    local pFile = self.ctl:getParticleFile("flyCoins")
    local lizi = cc.ParticleSystemQuad:create(pFile)
    node:addChild(lizi, -1)
    node:runAction(cc.Sequence:create(
        cc.CallFunc:create(function ( ... )
            self:parabolaToAnimation(node, endPos, flyTime)
        end),
        cc.DelayTime:create(flyTime),
        cc.CallFunc:create(function ( ... )
            if lizi and bole.isValidNode(lizi) then
                lizi:stopSystem()
            end
            if isPlay then
                self:addCollectLeftAni(endPos)
            end
        end),
        cc.DelayTime:create(1),
        cc.RemoveSelf:create()
        ))
end
function cls:parabolaToAnimation(obj,to,duration)
    if not obj then return end
    local waitTime = 1/30
    local a1 = cc.DelayTime:create(waitTime)
    local a2 = cc.MoveTo:create(duration - waitTime, to)
    local a3 = cc.Sequence:create(a1,a2)
    obj:runAction(a3)
end
function cls:addCollectLeftAni(endPos)
    local flyParent = self.ctl:getFlyLayer()
    local file = self.ctl:getSpineFile("collect_jieshou")
    bole.addSpineAnimationInTheme(flyParent, 1, file, endPos, "animation")
    local progressItem = self:getTagetCollectNodePos()
    local collectNode = progressItem.collectNode
    local baseScale = collectNode.baseScale
    local addScale = 1.25
    local lowScale = 0.9
    local level = self.ctl:getCurrentMapLevel()
    if level - 1 >= 1 then
        self:updateCollectRightImage(level - 1)
    end
    collectNode:setScale(0)
    collectNode:setVisible(true)
    local a1 = cc.ScaleTo:create(0.3, baseScale * addScale)
    local a2 = cc.ScaleTo:create(0.1, baseScale * lowScale)
    local a3 = cc.ScaleTo:create(0.1, baseScale)
    local a4 = cc.Sequence:create(a1,a2,a3)
    collectNode:runAction(a4)
end
function cls:showCollectFullAnimation(isFull)
    if isFull then
        local pos = cc.p(475, -38)
        local collectFull = self.ctl:getSpineFile("collect_award")
        self.ctl:playMusicByName("collect_win")
        bole.addSpineAnimationInTheme(self.collectFullAniNode, nil, collectFull, pos, "animation")
    end 
end
return cls





