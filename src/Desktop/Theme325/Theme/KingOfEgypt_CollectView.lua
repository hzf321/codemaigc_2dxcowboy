-- @Author: xiongmeng
-- @Date:   2020-11-12 11:18:49
-- @Last Modified by:   xiongmeng
-- @Last Modified time: 2020-12-03 11:45:36
local cls = class("KingOfEgypt_CollectView")

function cls:ctor(ctl, collectNode)
	self.ctl = ctl
	self.gameConfig = self.ctl:getGameConfig()
	self.mapCollectRoot = collectNode
	self:_initLayout()
end
function cls:_initLayout( ... )
	self.collectLeft = self.mapCollectRoot:getChildByName("map_left")
    -- self.collectLeft = self.collectLeft:getChildByName("left_ani")
    self.rightMapSpine = self.mapCollectRoot:getChildByName("map_right")
    self.collectLeft:removeAllChildren()
    -- self.rightMapSpine:removeAllChildren()
	-- self.rightMapSpine = self.collectRight:getChildByName("right_ani")
	local collectPrPanel = self.mapCollectRoot:getChildByName("progress_panel")
	self.collectPrImage = collectPrPanel:getChildByName("coinProgressImage")
	self.collectPrAniLoopNode = self.collectPrImage:getChildByName("progress_all_node")
    self.collectPrAniAddNode = self.collectPrImage:getChildByName("progress_ani_node")
	self.collectFullAniNode = self.mapCollectRoot:getChildByName("collect_full_ani_node")
	self.btnOpenMap = self.mapCollectRoot:getChildByName("show_map_btn")
	self.lockAniNode = self.mapCollectRoot:getChildByName("lock_ani_node")
	self.btnUnlockCollect = self.mapCollectRoot:getChildByName("open_lock_btn")

    self:_addLoopSpine()
	self:_setOpenMapEvent()
	self:_setUnlockCollectEvent()
end
function cls:_addLoopSpine( ... )
    local leftFile = self.ctl:getSpineFile("collect_left")
    local rightFile = self.ctl:getSpineFile("collect_right")
    local file = self.ctl:getSpineFile("collect_lock")
    local _, spineR =  bole.addSpineAnimation(self.rightMapSpine, nil, rightFile, cc.p(0,0), "animation", nil, nil, nil, true, true)
    local _, spine = bole.addSpineAnimation(self.collectLeft, nil, leftFile, cc.p(0,0), "animation1", nil, nil, nil, true, true)
    self.collectLeftSpine = spine
    self.collectRightSpine = spineR
    bole.addSpineAnimation(self.collectPrAniLoopNode, nil, file, cc.p(-938/2,0), "animation1", nil, nil, nil, true, true)
    bole.setEnableRecursiveCascading(self.rightMapSpine, true)
end
function cls:_setOpenMapEvent( ... )
	local showGrey = function ( enable )
        if self.rightMapSpine and bole.isValidNode(self.rightMapSpine) then
            if enable then
                self.rightMapSpine:setColor(cc.c3b(83,83,83))
            else
                self.rightMapSpine:setColor(cc.c3b(255,255,255))
            end
        end
    end
    local function onTouch( obj, eventType )
        if eventType == ccui.TouchEventType.began then
            if not self.ctl:icLockCollect() then
                if self.ctl:checkCollectBtnCanTouch() then
                    showGrey(true)
                end
            end
        elseif eventType == ccui.TouchEventType.ended then
            showGrey(false)
            --  if self.ctl:checkCollectBtnCanTouch() and (not self.ctl._mainViewCtl:isAutoSpinNodeShow()) then
			-- 	self.ctl:mapBtnClickEvent()
			-- end
            if self.ctl:icLockCollect() then
                if self.ctl:checkCollectBtnCanTouch() then
                    self.ctl:collectBtnClickEvent()
                    self.ctl:mapBtnClickEvent()
                end
            else
                if self.ctl:checkCollectBtnCanTouch() then
                    self.ctl:mapBtnClickEvent()
                end
            end
            
        elseif eventType == ccui.TouchEventType.canceled then
            showGrey(false)
        end
    end
    self.btnOpenMap:addTouchEventListener(onTouch)
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
function cls:updateCollectPrImagePos( pos )
	if not pos then return end
	self.collectPrImage:setPosition(pos)
end
function cls:showProgressAnimation( old_points,collect_points,isFull )
	local time = 10/30
    local oldPosX = self.ctl.movePerUnit * old_points + self.ctl.progressStartPosX
    local startPos = cc.p(oldPosX, self.ctl.progressPosY)
    local newPosX = self.ctl.movePerUnit * collect_points + self.ctl.progressStartPosX
    if isFull then
        newPosX = self.ctl.progressEndPosX
    end
    local endPos = cc.p(newPosX, self.ctl.progressPosY)
    self.collectPrImage:setPosition(startPos)
    self.collectPrImage:runAction(cc.MoveTo:create(time,endPos))
    local parent = self.collectPrAniAddNode
    local file = self.ctl:getSpineFile("collect_add")
    if parent and file then
        bole.addSpineAnimation(parent,10,file,cc.p(0, 0),"animation")
    end
    if isFull then
    	local time = 0.5
    	self.ctl:laterCallBack(time,function( ... )
            -- self:showCollectFullAnimation()
        end)
    end
end
function cls:showCollectFullAnimation( ... )
	self.ctl:playMusicByName("collect_full")
	local file = self.ctl:getSpineFile("collect_full")
    bole.addSpineAnimation(self.collectFullAniNode,nil,file,cc.p(0,0),"animation")
    self.collectRightSpine:setAnimation(0, "animation2", false)
    self.collectRightSpine:addAnimation(0, "animation", true)
end
function cls:setCollectPartState( isLock, isAnimate )
	self.lockAniNode:stopAllActions()
    local _delayTime1 = 25/30
    local animation2 = nil
    local isLoop = true
    local collectFeatureAnimation = self.gameConfig.collectAnimation
    
    if not self.lockSuperSpine then
        local file = self.ctl:getSpineFile("collect_lock")
        local _, s = bole.addSpineAnimation(self.lockAniNode, 2, file, cc.p(0,0), collectFeatureAnimation["lockLoop"], nil, nil, nil, true, nil)
        self.lockSuperSpine = s
    end
    
    if isLock then
        local aniName = collectFeatureAnimation["lockLoop"]
        if isAnimate then
            aniName = collectFeatureAnimation["lock"]
            animation2 = collectFeatureAnimation["lockLoop"]
            isLoop = false
            self.ctl:playMusicByName("collect_lock")
        end
        self.lockSuperSpine.lastSpine = aniName
        self.ctl.isLockFeature = true
        bole.spChangeAnimation(self.lockSuperSpine, aniName, isLoop)
        self.collectPrAniLoopNode:setVisible(false)
    else
        self.collectPrAniLoopNode:setVisible(true)
        self.ctl.isLockFeature = false
        local aniName = collectFeatureAnimation["unlockLoop"]
        if isAnimate then
            aniName = collectFeatureAnimation["unlock"]
            animation2 = collectFeatureAnimation["unlockLoop"]
            isLoop = false 
            self.ctl:playMusicByName("collect_unlock") 
        end
        self.lockSuperSpine.lastSpine = aniName
        bole.spChangeAnimation(self.lockSuperSpine, aniName, isLoop)
    end

    if animation2 then
        local a1 = cc.DelayTime:create(_delayTime1)
        local a2 = cc.CallFunc:create(function ( ... )
                self.lockSuperSpine.lastSpine = animation2 
                bole.spChangeAnimation(self.lockSuperSpine, animation2, true)
            end)
        local a3 = cc.Sequence:create(a1, a2)
        libUI.runAction(self.lockAniNode, a3)
    end
end
--@collectM1
function cls:showCoinsFlyToUp( flyTime )
    self.reelCoinFlyLayer = self.ctl:getFlyLayer()
    self.reelCoinFlyLayer:removeAllChildren()
    self.ctl:playMusicByName("collect_fly")
    local endNPos = bole.getWorldPos(self.collectLeft)
    local endPos  = bole.getNodePos(self.reelCoinFlyLayer, endNPos)
    local isPlay = true
    local item_list = table.copy(self.ctl:getItemList())
    local targetSymbol = 2
    if item_list then
        for col, item in pairs(item_list) do
            for row, collectId in pairs(item) do
                if collectId == targetSymbol then
                    self:getFlyM1Node(col, row, endPos, isPlay, flyTime)
                    isPlay = false
                end
            end
        end
    end
end
function cls:getFlyM1Node( col, row, endPos, isPlay, flyToUpTime )
    local pos = self.ctl:getCellPos(col, row)
    local node = cc.Node:create()
    local flyTime = flyToUpTime
    local delayTime = 10/30
    node:setPosition(pos)
    self.reelCoinFlyLayer:addChild(node, row)
    local m1File = self.ctl:getSpineFile("collect_m1")
    local _,spine = bole.addSpineAnimation(node, nil, m1File, cc.p(0,0), "animation")
    local pFile = self.ctl:getParticleFile("mi_tw_1")
    local lizi = cc.ParticleSystemQuad:create(pFile)
    if lizi and bole.isValidNode(lizi) then
        lizi:setVisible(false)
        node:addChild(lizi,-1)
    end
    node:runAction(cc.Sequence:create(
        cc.CallFunc:create(function ( ... )
            self:parabolaToAnimation(node, endPos, flyTime)
        end),
        cc.DelayTime:create(delayTime),
        cc.CallFunc:create(function ( ... )
            if lizi and bole.isValidNode(lizi) then
                lizi:setVisible(true)
            end
        end),
        cc.DelayTime:create(flyTime - delayTime),
        cc.CallFunc:create(function ( ... )
            if lizi and bole.isValidNode(lizi) then
                lizi:stopSystem()
            end
            if isPlay then
                self:addCollectLeftAni()
            end
        end),
        cc.DelayTime:create(1),
        cc.RemoveSelf:create()
        ))
end
function cls:parabolaToAnimation(obj,to,duration)
    if not obj then return end
    local waitTime = 10/30
    local a1 = cc.DelayTime:create(waitTime)
    local a2 = cc.MoveTo:create(duration - waitTime, to)
    local a3 = cc.Sequence:create(a1,a2)
    obj:runAction(a3)
end
function cls:addCollectLeftAni(  )
    self.collectLeftSpine:setAnimation(0, "animation2", false)
    self.collectLeftSpine:addAnimation(0, "animation1", true)
    local file = self.ctl:getSpineFile("collect_left")
    bole.addSpineAnimation(self.collectLeft, 1, file, cc.p(0, 0), "animation3")
end





return cls