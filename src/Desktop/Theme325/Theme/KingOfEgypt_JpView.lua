-- @Author: xiongmeng
-- @Date:   2020-11-11 18:22:20
-- @Last Modified by:   xiongmeng
-- @Last Modified time: 2020-12-01 21:19:02
local cls = class("KingOfEgypt_JpView")

local gameMasterTipShowStatus = {}
function cls:ctor(jpCtl, jpRoot)
	self.jpCtl = jpCtl
	self.gameConfig = self.jpCtl:getGameConfig()
    self.jackpotParent = jpRoot[1]
    self.jackpotTipParent = jpRoot[2]
	self.hasJackpotNode = false
    gameMasterTipShowStatus = self.gameConfig.gameMasterStatus
    self.gameMasterJpId = 10
    self:_initLayout()
    -- self:_addBoardLight()
    -- self:updateJpShow()
end

function cls:_initLayout( ... )
	self.jackpotLabels = {}
	self.jackpotUnlockLabels = {}
	local lockFile = self.jpCtl:getSpineFile("jackpot_lock")
    local loopFile = self.jpCtl:getSpineFile("jackpot_loop")

    if not self.jackpotParent then return end
    -- self.jackpotLabels = {}
    -- self.jackpotUnlockLabels = {}

    local posY = {-49, -8.5, 28, 65, 102} -- 反向偏移 {49, 8.5, -28, -65, -102}
    local jpViewConfig = self.gameConfig.jackpotViewConfig

	self.progressiveRoot = self.jackpotParent:getChildByName("progressive")
    self.progressiveBG = self.progressiveRoot:getChildByName("bg"):getChildByName("image_jp")
    self.progressiveWin = self.progressiveRoot:getChildByName("bg"):getChildByName("win_anim")
    self.progressiveTips = self.jackpotTipParent:getChildByName("progressive_tip")

    self:_initGameMasterTip()
    -- if self.jpCtl:getGameMasterTime() then 
    self:_initGameMasterJp(jpViewConfig)
    -- end
    
	for i = 1, jpViewConfig.count do
        local jp_node = self.progressiveRoot:getChildByName("node"..i)
        local otherI = i + jpViewConfig.count
		self.jackpotLabels[i] = jp_node:getChildByName("label_jp")
		self.jackpotLabels[otherI] = jp_node:getChildByName("label_jp1")
        local jpLoopAni = jp_node:getChildByName("loop_ani")
        jpLoopAni:setLocalZOrder(1)
        
		self.jackpotLabels[i].maxWidth = jpViewConfig.width[i]
		self.jackpotLabels[i].baseScale = jpViewConfig.scale[i]
		self.jackpotLabels[otherI].maxWidth = jpViewConfig.width[i]
		self.jackpotLabels[otherI].baseScale = jpViewConfig.scale[i]

        local tip_node = self.progressiveTips:getChildByName("jp_"..i)
        tip_node:setVisible(true)
		local lock_tip = tip_node:getChildByName("lock")
        local unlock_tip = tip_node:getChildByName("unlock")
        local btn      = tip_node:getChildByName("btn")
        local ani_node = tip_node:getChildByName("lock_ani")
        local jpBasePos = bole.getPos(jp_node)

        local animationUnlock = "animation"..i
        local animationLock = "animation"..i.."_1"

        local animationUnlockRight = "animation"..i.."_2"
        local animationLockRight = "animation"..i.."_3"

        local _, lockSpine = bole.addSpineAnimation(ani_node, 1, lockFile, cc.p(0,posY[i]), animationLock, nil, nil, nil, true, nil)
        local _, lockSpine1 = bole.addSpineAnimation(ani_node, 1, lockFile, cc.p(0,posY[i]), animationLockRight, nil, nil, nil, true, nil)
        -- lockSpine1:setScaleX(-1)
        local awardNode = cc.Node:create()
        jpLoopAni:addChild(awardNode, 1)
        awardNode:setPositionY(posY[i])
        ani_node.lockSpineLeft = lockSpine
        ani_node.lockSpineRight = lockSpine1

        ani_node.animationLock = animationLock
        ani_node.animationUnlock = animationUnlock
        ani_node.animationUnlockRight = animationUnlockRight
        ani_node.animationLockRight = animationLockRight

        local jp_node_tip = jp_node:getChildByName("lock_tip")
        jp_node.jp_node_tip = jp_node_tip

        lock_tip:setVisible(false)
        unlock_tip:setVisible(false)
        btn.index = i
        self.jackpotUnlockLabels[i] = {}
		self.jackpotUnlockLabels[i].btn = btn
		self.jackpotUnlockLabels[i].isLocked = true
		self.jackpotUnlockLabels[i].basePos = jpBasePos
		self.jackpotUnlockLabels[i].lock_tip = lock_tip
		self.jackpotUnlockLabels[i].unlock_tip = unlock_tip
		self.jackpotUnlockLabels[i].ani_node = ani_node
		self.jackpotUnlockLabels[i].jp_node = jp_node
		self.jackpotUnlockLabels[i].jpLoopAni = jpLoopAni
        self.jackpotUnlockLabels[i].awardNode = awardNode
		self:_initJackTouchEvent(self.jackpotUnlockLabels[i], i)
	end
end
function cls:updateJpShow( ... )
    local progressConfig = self.gameConfig.jackpotViewConfig.progressConfig
    local currentConfig = progressConfig.normal
    if self.jpCtl:getGameMasterTime() then 
        currentConfig = progressConfig.gameMaster
        local jp_node = self.progressiveRoot:getChildByName("node0")
        if jp_node and bole.isValidNode(jp_node) then 
            jp_node:setVisible(true)
        end
        -- self.jackpotTipParent:getChildByName("right_btn"):setVisible(true)
    else 
        local jp_node = self.progressiveRoot:getChildByName("node0")
        if jp_node and bole.isValidNode(jp_node) then 
            jp_node:setVisible(false)
        end
        -- self.jackpotTipParent:getChildByName("right_btn"):setVisible(false)
    end

    self.jackpotTipParent:getChildByName("right_btn"):setVisible(false)

    self.progressiveRoot:setScale(currentConfig.scale)
    self.progressiveRoot:setPosition(currentConfig.pos)
    self.progressiveTips:setScale(currentConfig.scale)
    self.progressiveTips:setPosition(currentConfig.pos)
end
function cls:_addBoardLight()
    local bg = self.progressiveRoot:getChildByName("bg")
    local file = self.jpCtl:getSpineFile("bg_jp_loop")
    bole.addSpineAnimation(bg, nil, file, cc.p(0,0), "animation", nil, nil, nil, true, true)
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
    local lockSpineLeft = ani_node.lockSpineLeft
    local lockSpineRight = ani_node.lockSpineRight
    local animationLock = ani_node.animationLock
    local animationUnlock = ani_node.animationUnlock
    local animationLockRight = ani_node.animationLockRight
    local animationUnlockRight = ani_node.animationUnlockRight
    -- local animationUnlock = ani_node.animationUnlock
    if (not lockSpineLeft) or (not lockSpineRight) then return end
    if isLock then
        bole.spChangeAnimation(lockSpineLeft, animationLock)
        bole.spChangeAnimation(lockSpineRight, animationLockRight)
    else
        bole.spChangeAnimation(lockSpineLeft, animationUnlock)  
        bole.spChangeAnimation(lockSpineRight, animationUnlockRight)  
    end
end
function cls:changeJpStyle(unlockLabels, labels, index, isLock)
    local jp_node = unlockLabels["jp_node"]
    if isLock then
        jp_node.jp_node_tip:setVisible(true)
    else
        jp_node.jp_node_tip:setVisible(false)
    end
end
function cls:showjpTipNode(unlockLabels, status)
    if self.showjpTipCacheNode then
        self.showjpTipCacheNode:stopAllActions()
        self.showjpTipCacheNode:runAction(
                cc.ScaleTo:create(0.1, 0)
        )
    end

    if status == 1 then
        return 
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
function cls:_addMapBtnEvent( ... )
    local onTouch = function ( obj, eventType )
        if eventType == ccui.TouchEventType.ended then
            
        end
    end
    self.backMapBtn:addTouchEventListener(onTouch)
end
function cls:addJpAwardAnimation( jpWinType )
    if not jpWinType then return end
    if jpWinType == self.gameMasterJpId then
        self:addGameMaJpAwardAnimation(jpWinType)
        return
    end
    local jpFile = self.jpCtl:getSpineFile("jackpot_award")
    local aniName = "animation"..(jpWinType + 1)
    if jpWinType + 1 > 5 then
        aniName = "animation"..(jpWinType - 4).."_1"
        jpWinType = (jpWinType) % 5 + 1
    else 
        jpWinType = (jpWinType) % 5 + 1
    end
    if self.jackpotUnlockLabels and self.jackpotUnlockLabels[jpWinType] then
        local parent = self.jackpotUnlockLabels[jpWinType].awardNode
        if bole.isValidNode(self.progressiveWin) and bole.isValidNode(parent) then
            local posW = bole.getWorldPos(parent)
            local posN = bole.getNodePos(self.progressiveWin, posW)
            bole.addSpineAnimation(self.progressiveWin, 2, jpFile, posN, aniName, nil, nil, nil, true, true)
        end
    end
end
function cls:addGameMaJpAwardAnimation( jpWinType )
    local jpFile = self.jpCtl:getSpineFile("gamem_jackpot_award")
    jpWinType = jpWinType + 1
    local aniName = "animation"
    if self.jackpotUnlockLabels and self.jackpotUnlockLabels[jpWinType] then
        local parent = self.jackpotUnlockLabels[jpWinType].awardNode
        if parent then
            bole.addSpineAnimation(parent, 2, jpFile, cc.p(0,0), aniName, nil, nil, nil, true, true)
        end
    end
end
function cls:removeJpAwardAnimation( jpWinType )
    if not jpWinType then return end
    if jpWinType ~= self.gameMasterJpId then 
        jpWinType = (jpWinType) % 5 + 1
    else 
        jpWinType = jpWinType + 1
    end
    if self.jackpotUnlockLabels and self.jackpotUnlockLabels[jpWinType] then
        local parent = self.jackpotUnlockLabels[jpWinType].awardNode
        if parent then
            parent:removeAllChildren()
        end
    end 

    if bole.isValidNode(self.progressiveWin) then
        self.progressiveWin:removeAllChildren()
    end
end
---- gameMaster start -----
function cls:_initGameMasterJp( jpViewConfig )
    jpViewConfig = jpViewConfig
    local jp_node = self.progressiveRoot:getChildByName("node0")
    local labelJp = jp_node:getChildByName("label_jp")
    local awardNode = cc.Node:create()
    jp_node:addChild(awardNode)
    self.jackpotLabels[1 + jpViewConfig.count * 2] = labelJp
    local jpLoopAni = jp_node:getChildByName("loop_ani")
    local jpFile1 = self.jpCtl:getSpineFile("gamem_jp_loop")
    labelJp:setLocalZOrder(1)
    bole.addSpineAnimation(jpLoopAni, nil, jpFile1, cc.p(0,0), "animation", nil, nil, nil, true, true)
    self.jackpotLabels[1 + jpViewConfig.count * 2].maxWidth = jpViewConfig.width[jpViewConfig.count + 1]
    self.jackpotLabels[1 + jpViewConfig.count * 2].baseScale = jpViewConfig.scale[jpViewConfig.count + 1]
    self.jackpotUnlockLabels[1 + jpViewConfig.count * 2] = {}
    self.jackpotUnlockLabels[1 + jpViewConfig.count * 2].awardNode = awardNode
end
function cls:_initGameMasterTip( ... )
    -- self.noteTipShowStatus = gameMasterTipShowStatus["hide"]
    -- local starRoot = self.jackpotTipParent:getChildByName("right_btn"):getChildByName("star_root")
    -- local starLoopAni = starRoot:getChildByName("loop_ani")
    -- local starFile1 = self.jpCtl:getSpineFile("gamem_star_loop")
    -- bole.addSpineAnimation(starLoopAni, nil, starFile1, cc.p(0,0), "animation", nil, nil, nil, true, true)

    -- if bole.isValidNode(self.jackpotTipParent) then 
    --     self.noteTipBtn = self.jackpotTipParent:getChildByName("right_btn"):getChildByName("btn_start")
    --     self.starBtn = self.jackpotTipParent:getChildByName("right_btn"):getChildByName("star_root"):getChildByName("btn_start")
    --     self.noteTipDialog = self.jackpotTipParent:getChildByName("right_btn"):getChildByName("tip")
    --     self.noteTipDialog:setVisible(false)
    --     self.noteTipDialog:setScale(0)
    --     local function onTouch(obj, eventType)
    --         if eventType == ccui.TouchEventType.ended then
    --             self.jpCtl:playMusicByName("common_click")
    --             self:showNoteTipDialog(self.noteTipDialog)
    --         end
    --     end
    --     self.noteTipBtn:addTouchEventListener(onTouch)
    --     self.starBtn:addTouchEventListener(onTouch)
    -- end
end
function cls:showNoteTipDialog(tips)
    -- local time = 0.3
    -- local delayTime = 2
    -- if tips and bole.isValidNode(tips) then 
    --     tips:stopAllActions()
    --     tips:setVisible(true)
    -- end
    -- if self.noteTipShowStatus == gameMasterTipShowStatus["show"] then 
    --     self.noteTipShowStatus = gameMasterTipShowStatus["hide"]
    --     local a1 = cc.ScaleTo:create(time/2, 0)
    --     tips:runAction(a1)
    -- else
    --     self.noteTipShowStatus = gameMasterTipShowStatus["show"]
    --     local a1 = cc.ScaleTo:create(time, 1.1)
    --     local a2 = cc.ScaleTo:create(time/3, 1)
    --     local a3 = cc.DelayTime:create(delayTime)
    --     local a4 = cc.ScaleTo:create(time/2, 0)
    --     local a5 = cc.CallFunc:create(function ( ... )
    --         tips:setVisible(false)
    --     end)
    --     local a6 = cc.Sequence:create(a1,a2,a3,a4,a5)
    --     tips:runAction(a6)
    -- end
end
---- gameMaster end -----
function cls:getJackpotLabels(  )
	return self.jackpotLabels or {}
end

---@param pType 1 base  2 moon 3 sun
function cls:changeSpinBoard(pType)
    local bgFile = "#theme325_jp_1.png"
    if pType == 2 then
        bgFile = "#theme325_moon_reel_jp1.png"
    elseif pType == 3 then
        bgFile = "#theme325_sun_reel_jp1.png"
    end
    bole.updateSpriteWithFile(self.progressiveBG, bgFile)
end

return cls