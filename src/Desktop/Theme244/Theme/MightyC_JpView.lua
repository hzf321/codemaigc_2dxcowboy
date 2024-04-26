-- @Author: xiongmeng
-- @Date:   2020-11-11 18:22:20
-- @Last Modified by:   xiongmeng
-- @Last Modified time: 2020-12-01 21:19:02
local cls = class("MightyC_JpView")
function cls:ctor(jpCtl, jpRoot, jpTip)
	self.jpCtl = jpCtl
	self.gameConfig = self.jpCtl:getGameConfig()
	self.jackpotParent = jpRoot
    self.progressiveTips = jpTip
	self.hasJackpotNode = false
	self:_initLayout()
end
function cls:_initLayout( ... )
	self.jackpotLabels = {}
	self.jackpotUnlockLabels = {}
	local lockFile = self.jpCtl:getSpineFile("jackpot_lock")
	local unlockFile = self.jpCtl:getSpineFile("jackpot_unlock")
	local loopFile = self.jpCtl:getSpineFile("jackpot_loop")
	if not self.jackpotParent then return end
    self.progressiveAni = self.jackpotParent:getChildByName("progressive_ani")
	self.progressiveRoot = self.jackpotParent:getChildByName("progressive")

	local jpViewConfig = self.gameConfig.jackpotViewConfig
    self.progressiveTips:setVisible(true)
	for i = 1, jpViewConfig.count do
		local jp_node = self.progressiveRoot:getChildByName("node_"..i)
		self.jackpotLabels[i] = jp_node:getChildByName("label_jp")
		local jpLoopAni = jp_node:getChildByName("loop_ani")
        
		self.jackpotLabels[i].maxWidth = jpViewConfig.width[i]
		self.jackpotLabels[i].baseScale = jpViewConfig.scale[i]

		local tip_node = self.progressiveTips:getChildByName("jp_"..i)
        tip_node:setVisible(true)
		local lock_tip = tip_node:getChildByName("lock_tip")
        local unlock_tip = tip_node:getChildByName("unlock_tip")
        local btn      = tip_node:getChildByName("btn")
        local ani_node = self.progressiveAni:getChildByName("ani"..i)

        local animationLoop = "animation"..i
        local animationUnlock = "animation"..i
        local animationLock = "animation1_"..i

        if i == 1 then
            animationLoop = "animation"
            animationUnlock = "animation"
            animationLock = "animation"
        else
            animationLock = "animation2"
        end
        

        local _, lockSpine = bole.addSpineAnimationInTheme(ani_node, 1, lockFile, cc.p(0,0), animationLock, nil, nil, nil, true, nil)
        local _, unLockSpine = bole.addSpineAnimationInTheme(ani_node, 1, unlockFile, cc.p(0,0), animationUnlock, nil, nil, nil, true, nil)
        local _, loopSpine = bole.addSpineAnimationInTheme(jpLoopAni, 1, loopFile, cc.p(0,0), animationLoop, nil, nil, nil, true, true)

        local awardNode = cc.Node:create()
        jpLoopAni:addChild(awardNode, 1)
        if i == 1 then 
            awardNode:setPosition(cc.p(2, 0))
        else
            awardNode:setPosition(cc.p(1, -1))
        end

        ani_node.lockSpine = lockSpine
        ani_node.unLockSpine = unLockSpine
        ani_node.animationLock = animationLock
        ani_node.animationUnlock = animationUnlock

        local jp_node_bg = jp_node:getChildByName("jp_bg")
        local jp_node_tip = jp_node:getChildByName("jp_title")
        local coverNode = jp_node:getChildByName("cover")
        coverNode:setVisible(false)
        jp_node.jp_node_bg = jp_node_bg
        jp_node.jp_node_tip = jp_node_tip
        jp_node.loopSpine = loopSpine
        jp_node.coverNode = coverNode

        lock_tip:setVisible(false)
        unlock_tip:setVisible(false)
        btn.index = i

        self.jackpotUnlockLabels[i] = {}
		self.jackpotUnlockLabels[i].btn = btn
		self.jackpotUnlockLabels[i].lock_tip = lock_tip
		self.jackpotUnlockLabels[i].unlock_tip = unlock_tip
		self.jackpotUnlockLabels[i].ani_node = ani_node
		self.jackpotUnlockLabels[i].jp_node = jp_node
		self.jackpotUnlockLabels[i].jpLoopAni = jpLoopAni
        self.jackpotUnlockLabels[i].awardNode = awardNode
        self.jackpotUnlockLabels[i].awardAniName = animationLock

		self:_initJackTouchEvent(self.jackpotUnlockLabels[i], i)
	end
end
function cls:_initJackTouchEvent( unlockLables, index )
	local btn = unlockLables.btn
    self:_creatJpClickEvent(btn, index)
end
function cls:_creatJpClickEvent( btnNode, index )
	local function unLockOnTouchByJp(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			if self.jpCtl:checkJackpotBtnCanTouch() then
				self.jpCtl:jpBtnClickEvent(obj.index)
			end
	    end
	end
    btnNode:addTouchEventListener(unLockOnTouchByJp)
    btnNode:setTouchEnabled(true)
end

function cls:setJackpotPartState(unlockLabels, index, isLock)
    local parent = unlockLabels
    local ani_node = parent.ani_node
    local lockSpine = ani_node.lockSpine
    local unLockSpine = ani_node.unLockSpine
    local animationLock = ani_node.animationLock
    local animationUnlock = ani_node.animationUnlock
    if (not lockSpine) or (not unLockSpine) then return end
    lockSpine:setVisible(false)
    unLockSpine:setVisible(false)
    if isLock then
        lockSpine:setVisible(true)
        bole.spChangeAnimation(lockSpine, animationLock)
    else
        unLockSpine:setVisible(true)
        bole.spChangeAnimation(unLockSpine, animationUnlock)  
    end
end
function cls:changeJpStyle(unlockLabels, labels, index, isLock)
    local font
    local tipImage
    local bgImage
    local jp_label = labels
    local jp_node = unlockLabels["jp_node"]
    local jackpot_config = self.gameConfig.jackpotViewConfig
    local scaleX = jackpot_config.lightScaleX
    local coverNode = jp_node.coverNode
    if isLock then
        jp_node.loopSpine:setVisible(false)
        font = jackpot_config.lock_fnt[1]
        tipImage = string.format(jackpot_config.light_tip_img, "0_"..index)
        scaleX = jackpot_config.grayScaleX
        if index == 1 then
            bgImage = string.format(jackpot_config.light_bg_img, "0_"..index)  
        else 
            bgImage = "#theme244_jp_bg2_0.png"
        end
        coverNode:setVisible(true)
    else
        jp_node.loopSpine:setVisible(true)
        font = jackpot_config.unlock_fnt[1]
        tipImage = string.format(jackpot_config.light_tip_img, "_"..index)
        bgImage = string.format(jackpot_config.light_bg_img, index)
        coverNode:setVisible(false)
    end
    jp_label:setFntFile(self.jpCtl:getFntFilePath(font))
    if tipImage then
       bole.updateSpriteWithFile(jp_node.jp_node_tip, tipImage) 
    end
    if bgImage then
        jp_node.jp_node_bg:setScaleX(scaleX[index])
        bole.updateSpriteWithFile(jp_node.jp_node_bg, bgImage)
    end
end
function cls:showjpTipNode(unlockLabels, status)
    if self.showjpTipCacheNode then
        self.showjpTipCacheNode:stopAllActions()
        self.showjpTipCacheNode:runAction(
                cc.ScaleTo:create(0.1, 0)
        )
    end
    local jpTipNode = unlockLabels
    local showNode = jpTipNode.lock_tip
    if status == 2 then
        showNode = jpTipNode.unlock_tip
    end
    showNode:setVisible(true)
    showNode:setScale(0)
    showNode:runAction(
            cc.Sequence:create(
                    cc.ScaleTo:create(0.1, 1.1),
                    cc.ScaleTo:create(0.1, 1),
                    cc.DelayTime:create(1),
                    cc.ScaleTo:create(0.1, 1, 1.1),
                    cc.ScaleTo:create(0.1, 0),
                    cc.CallFunc:create(function()
                        self.showjpTipCacheNode = nil
                    end)
            )
    )
    self.showjpTipCacheNode = showNode
end
function cls:addJpAwardAnimation( jpWinType )
    if not jpWinType then return end
    local jpFile = self.jpCtl:getSpineFile("jackpot_award")
    if self.jackpotUnlockLabels and self.jackpotUnlockLabels[jpWinType] then
        local parent = self.jackpotUnlockLabels[jpWinType].awardNode
        local aniName = self.jackpotUnlockLabels[jpWinType].awardAniName
        if parent then
            bole.addSpineAnimationInTheme(parent, 2, jpFile, cc.p(0,0), aniName, nil, nil, nil, true, true)
        end
    end
end
function cls:removeJpAwardAnimation( jpWinType )
    if not jpWinType then return end
    if self.jackpotUnlockLabels and self.jackpotUnlockLabels[jpWinType] then
        local parent = self.jackpotUnlockLabels[jpWinType].awardNode
        if parent then
            parent:removeAllChildren()
        end
    end
end
function cls:getJackpotLabels(  )
	return self.jackpotLabels or {}
end
return cls
