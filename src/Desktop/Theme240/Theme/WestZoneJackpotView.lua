-- @Author: xiongmeng
-- @Date:   2020-11-11 18:22:20
-- @Last Modified by:   xiongmeng
-- @Last Modified time: 2020-12-01 21:19:02
local cls = class("WestZoneJackpotView")

function cls:ctor(jpCtl, jpRoot)
	self.jpCtl = jpCtl
	self.gameConfig = self.jpCtl:getGameConfig()
	self.jackpotParent = jpRoot
	self.hasJackpotNode = false
	self:_initLayout()
end

function cls:_initLayout( ... )
	self.jackpotLabels = {} 
	self.jackpotUnlockLabels = {}
    self.jp_bg_ani = self.jpCtl:getJackpotBgAni()
    self.jpCtl._mainViewCtl:addSpineAnimation(self.jp_bg_ani, nil, self.jpCtl:getSpineFile("jackpot_loop"),cc.p(0,0),"animation",nil,nil,nil,true,true)
	local lockFile = self.jpCtl:getSpineFile("jackpot_lock")
    local unlockFile = self.jpCtl:getSpineFile("jackpot_unlock")
	if not self.jackpotParent then return end
	self.progressiveRoot = self.jackpotParent:getChildByName("progressive")
	self.progressiveTips = self.jackpotParent:getChildByName("progressive_tip")

    local jpViewConfig = self.gameConfig.jackpotViewConfig
	for i = 1, jpViewConfig.count do
		local jp_node = self.progressiveRoot:getChildByName("node_"..i)
		self.jackpotLabels[i] = jp_node:getChildByName("label_jp")
		local jpLoopAni = jp_node:getChildByName("loop_ani")
        local jp_node_bg = jp_node:getChildByName("image_jp")
        local jp_box_label = jp_node:getChildByName("jp_box_label")
		self.jackpotLabels[i].maxWidth = jpViewConfig.width[i]
        self.jackpotLabels[i].baseScale = jpViewConfig.scale[i]

		local tip_node = self.progressiveTips:getChildByName("jp_"..i)
		local lock_tip = tip_node:getChildByName("lock_tip")
        local unlock_tip = tip_node:getChildByName("unlock_tip")
        local btn      = tip_node:getChildByName("btn")
        local ani_node = tip_node:getChildByName("lock_ani")
        local jpBasePos  = bole.getPos(jp_node)

        -- local animationName = "animation"..i
        local animationUnlock = "animation"..i
        local animationType = (i == 1 and 1 or 2)
        local animationLock = "animation"..animationType
        -- local _, loopSpine = bole.addSpineAnimation(jpLoopAni, 1, loopFile, cc.p(0,0), animationName, nil, nil, nil, true, true)
        local awardNode = cc.Node:create()
        jpLoopAni:addChild(awardNode, 1)
        ani_node.animationLock = animationLock
        ani_node.animationUnlock = animationUnlock
        ani_node.lockFile = lockFile
        ani_node.unlockFile = unlockFile
        ani_node.isLocked = false
        
 
        jp_node.jp_node_bg = jp_node_bg
        jp_node.jp_box_label = jp_box_label
        lock_tip:setVisible(false)
        unlock_tip:setVisible(false)
        btn.index = i
        self.jackpotUnlockLabels[i] = {}
		self.jackpotUnlockLabels[i].btn = btn
		self.jackpotUnlockLabels[i].basePos = jpBasePos
		self.jackpotUnlockLabels[i].lock_tip = lock_tip
		self.jackpotUnlockLabels[i].unlock_tip = unlock_tip
		self.jackpotUnlockLabels[i].ani_node = ani_node
		self.jackpotUnlockLabels[i].jp_node = jp_node
		-- self.jackpotUnlockLabels[i].jpLoopAni = jpLoopAni
        self.jackpotUnlockLabels[i].awardNode = awardNode
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
    local base_pos = unlockLabels.basePos
    local ani_node = parent.ani_node
    local animationLock = ani_node.animationLock
    local animationUnlock = ani_node.animationUnlock
    local lockFile = ani_node.lockFile 
    local unlockFile =  ani_node.unlockFile 
    if isLock then
        self.jpCtl:playMusicByName("jp_lock")
        ani_node:removeAllChildren()
        ani_node.isLocked = true
        bole.addSpineAnimation(ani_node, nil, lockFile,   cc.p(0,0), animationLock,   nil, nil, nil, true, false)
    else
        self.jpCtl:playMusicByName("jp_unlock")
        ani_node.isLocked = false
        bole.addSpineAnimation(ani_node, nil, unlockFile, cc.p(0,0), animationUnlock, nil, nil, nil, true, false)
    end
end
function cls:changeJpStyle(unlockLabels, labels, index, isLock)
    local font
    local bgImage
    local bgImage1
    local jp_label = labels
    local jp_node = unlockLabels["jp_node"]
    local jackpot_config = self.gameConfig.jackpotViewConfig
    if not isLock then
        font = jackpot_config.unlock_fnt
        bgImage = string.format(jackpot_config.unlock_light_bg_img, index)
        bgImage1 = string.format(jackpot_config.unlock_box_label_img, index)
    else
        font = jackpot_config.lock_fnt
        bgImage = string.format(jackpot_config.light_bg_img, index)
        bgImage1 = string.format(jackpot_config.box_label_img, index)
    end
    jp_label:setFntFile(self.jpCtl:getFntFilePath(font))
    if bgImage then
        bole.updateSpriteWithFile(jp_node.jp_node_bg, bgImage) 
        bole.updateSpriteWithFile(jp_node.jp_box_label, bgImage1)
    end
end

function cls:getJpLockStatus(index)
    if (not index) or (not self.jackpotUnlockLabels) then return true end
    local jpNode = self.jackpotUnlockLabels[index]
    if jpNode then
        return jpNode.isLocked
    end
    return true
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
    -- local animationType = (jpWinType == 1 and 1 or 2)
    local aniName = "animation"..jpWinType
    if self.jackpotUnlockLabels and self.jackpotUnlockLabels[jpWinType] then
        local parent = self.jackpotUnlockLabels[jpWinType].awardNode
        if parent then
            bole.addSpineAnimation(parent, 2, jpFile, cc.p(0, 6), aniName, nil, nil, nil, true, true)
            -- self.jpCtl:playMusicByName("jp_win")
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
