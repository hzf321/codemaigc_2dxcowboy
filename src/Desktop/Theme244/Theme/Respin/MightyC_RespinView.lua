--[[
Author: xiongmeng
Date: 2021-05-08 17:46:27
LastEditors: xiongmeng
LastEditTime: 2021-05-24 20:49:16
Description: 
--]]
local cls = class("MightyC_RespinView")
local maxZoder = 100
function cls:ctor(ctl, respinCollectParent, respinTip, respinBoard)
	self.ctl = ctl
	self.gameConfig = self.ctl:getGameConfig()
	self.respinCollectParent = respinCollectParent
    self.collectRespinTip = respinTip
    self.respinBoard = respinBoard
    self.flyParent = self.ctl:getFlyLayer()
    self._mainViewCtl = self.ctl._mainViewCtl
    self.animateNode = self._mainViewCtl:getAnimateNode()
    self.bonusCoinsList = self.gameConfig["bonus_coin"]
	self:_initLayout()
end
function cls:_initLayout( ... )
    self.respinCollectNode = self.respinCollectParent:getChildByName("collect_node")
	self.respinTimesNode = self.respinCollectParent:getChildByName("collect_respin")
    self.respinCollectTopAni = cc.Node:create()
    self.respinCollectNode:addChild(self.respinCollectTopAni)
    self.respinCollectNode:setPositionY(213)
    self.respinTimesNode:setPosition(cc.p(-1, 213))
    self.btnRespinTip = self.respinCollectNode:getChildByName("btn_tip")
    self.btnRespinTip:setLocalZOrder(1)
    self:_setTipEvent()
	self.respinTimesNode:setVisible(false)
    self.collectRespinTip:setVisible(true)
    self.collectRespinTip:setScale(0)
    self:_initRespinTimesNode()
    self:_initRespinBoard()
    self:_initCollectTopAni()
    self:_addRespinBoardBtnEvent()
end
function cls:_initRespinTimesNode()
    self.respinTimesLabel = self.respinTimesNode:getChildByName("left_times")
    self.respinAllTimesLabel = self.respinTimesNode:getChildByName("respin_times")
end
function cls:updateRespinTimes(useTimes,allTimes)
    useTimes = useTimes or 0
    allTimes = allTimes or 6
    self.respinTimesLabel:setString(useTimes)
    self.respinAllTimesLabel:setString(allTimes)
end
function cls:_initCollectTopAni()
    local file = self.ctl:getSpineFile("collect_top")
    local collectImage = self.respinCollectNode:getChildByName("collect_image")
    local _, spine = bole.addSpineAnimationInTheme(collectImage, nil, file, cc.p(44,34.5), "animation2_1",nil, nil, nil, true, true)
    -- spine:setVisible(false)
    self.respinColletImageNode = collectImage
    self.respinCollectImageSpine = spine
end
function cls:updateRespinTip(pType)
    local showBaseNode = {true, true, false, false}
    if pType then
        self.respinCollectNode:setVisible(showBaseNode[pType])
        self.respinTimesNode:setVisible(not showBaseNode[pType])
    end
end
------------------  respinBoard start ---------------------
function cls:_addRespinBoardBtnEvent()
    local unitSize = 10
    local boardW = 100
    local boardH = 300
    local img = "commonpics/kong.png"
    local respinBoardFun = function ()
        if self.ctl:checkCollectBtnCanTouch() then
	    	self.ctl:collectBtnClickEvent()
	    end
    end
    local touchBtn = Widget.newButton(respinBoardFun, img, img, img, false) --10
    touchBtn:setScaleX(boardW / unitSize)
    touchBtn:setScaleY(boardH / unitSize)
    touchBtn:setPosition(cc.p(575,135))
    touchBtn:setOpacity(0)
    self.respinBoardBtn = touchBtn
    self.respinBoard:addChild(touchBtn)
end
function cls:updateRespinBtnScale(isLock)
    if self.respinBoardBtn then
        if isLock then
            self.respinBoardBtn:setScaleY(300/10)
            self.respinBoardBtn:setPositionY(135)
        else 
            self.respinBoardBtn:setScaleY(250/10)
            self.respinBoardBtn:setPositionY(135)
        end
    end
end
function cls:_initRespinBoard()
    local file = self.ctl:getSpineFile("respin_board")
    local _, spine = bole.addSpineAnimationInTheme(self.respinBoard, nil, file, cc.p(575,135), "animation2_2", nil, nil, nil, true, true)
    self.respinBoardSpine = spine
    self.respinBoardSpine.isLock = true
    self.respinBoardSpine.showAni = "animation2_1"
    self.respinBoardSpine.loopAni = "animation2_2"
    self.respinBoardSpine.hideAni = "animation2_3"
end
function cls:changeRespinBoardTip(isLock, isAni)
    if not self.respinBoardSpine then return end
    local showAni = "animation1_1"
    local loopAni = "animation1_2"
    local hideAni = "animation1_3"
    if isLock then
        showAni = "animation2_1"
        loopAni = "animation2_2"
        hideAni = "animation2_3"
    end
    self:updateRespinBtnScale(isLock)
    bole.spChangeAnimation(self.respinBoardSpine, loopAni, true)
end
------------------  respinBoard end ---------------------
------------------  respinTip start ---------------------
function cls:_setTipEvent()
    local function onTouch(obj, eventType)
	    if eventType == ccui.TouchEventType.ended then
	    	if self.ctl:checkCollectBtnCanTouch() then
	    		self:showRespinTip()
	    	end
	    end
	end
	self.btnRespinTip:addTouchEventListener(onTouch)
end
function cls:setRespinTipEnabled(enable)
    self.btnRespinTip:setTouchEnabled(enable)
end
function cls:showRespinTip()
    if self.respinTipStatus then 
        self:hideRespinTip(true)
        return 
    end
    self.respinTipStatus = true
    self.collectRespinTip:stopAllActions()
    local currentScale = self.collectRespinTip:getScale()
    local showTime = 0.2 * (1 - currentScale)
    local a1 = cc.ScaleTo:create(showTime, 1)
    local a2 = cc.DelayTime:create(3)
    local a3 = cc.CallFunc:create(function ()
        self:hideRespinTip(true)
    end)
    local a4 = cc.Sequence:create(a1,a2,a3)
    self.collectRespinTip:runAction(a4)
end
function cls:hideRespinTip(isAnimation)
    if not self.respinTipStatus then return end
    if isAnimation then 
        if self.collectRespinTip.hideCurrent then 
            return
        end
        self.collectRespinTip:stopAllActions()
        local currentScale = self.collectRespinTip:getScale()
        local hideTime = 0.2 * currentScale
        local a1 = cc.ScaleTo:create(hideTime, 0)
        local a2 = cc.CallFunc:create(function ()
            self.respinTipStatus = false
            self.collectRespinTip.hideCurrent = false
        end)
        local a3 = cc.Sequence:create(a1,a2)
        self.collectRespinTip.hideCurrent = true
        self.collectRespinTip:runAction(a3)
    else 
        self.collectRespinTip:stopAllActions()
        self.collectRespinTip:setScale(0)
        self.respinTipStatus = false
        self.collectRespinTip.hideCurrent = false
    end
end
------------------   respinTip end ---------------------


------------------ bonus2 start ------------------
function cls:collectYellowSymbol(wPos, isFirst, isBonus)
    local nPos = bole.getNodePos(self.flyParent, wPos)
    local targetWPos = bole.getWorldPos(self.respinCollectNode)
    local targetNPos = bole.getNodePos(self.flyParent, targetWPos)

    local node = cc.Node:create()
    self.flyParent:addChild(node)
    node:setPosition(nPos)
    
    if isBonus then
        self.ctl:playMusicByName("yellow_collcet2")
    else
        self.ctl:playMusicByName("yellow_collcet1")
    end
    
    local file = self.ctl:getSpineFile("collect_top")
    bole.addSpineAnimationInTheme(node, nil, file, cc.p(0,0), "animation5", nil, nil, nil, true)
    
    local a1 = cc.DelayTime:create(8/30)
    local a2 = cc.MoveTo:create(7/30, targetNPos)
    local a3 = cc.CallFunc:create(function ()
        if isFirst then
            self:addCollectTopAni(isBonus)
        end
    end)
    local a4 = cc.RemoveSelf:create()
    local a5 = cc.Sequence:create(a1,a2,a3,a4)
    node:runAction(a5)
end
function cls:addCollectTopAni(isBonus)
    local file = self.ctl:getSpineFile("collect_top1")
    if isBonus then
        self._mainViewCtl:addWareEffect()
        file = self.ctl:getSpineFile("collect_top2")
    end
    if not self.respinColletPos then
        local wPos = bole.getWorldPos(self.respinCollectTopAni)
        local pos = bole.getNodePos(self.flyParent, wPos)
        self.respinColletPos = pos
    end
    -- symbol 放大的效果
    if self.respinColletImageNode then
        local a1 = cc.ScaleTo:create(0.2, 1.25)
        local a2 = cc.ScaleTo:create(0.2, 0.9)
        local a3 = cc.ScaleTo:create(0.2, 1)
        local a4 = cc.Sequence:create(a1,a2,a3)
        self.respinColletImageNode:runAction(a4)
    end
    bole.addSpineAnimationInTheme(self.flyParent, nil, file, self.respinColletPos, "animation")
end
function cls:blueDiamondChange(cell)
    local file = self.ctl:getSpineFile("symbol_change1")
    local file1 = self.ctl:getSpineFile("collect_top")
    local a1 = cc.DelayTime:create(1)
    local a2 = cc.CallFunc:create(function ()
        self.ctl:playMusicByName("gem_change")
        self:diamondSymbolChange(cell, file, file1, -100, self.ctl:getBonus2Pic())
    end)
    local a3 = cc.Sequence:create(a1, a2)
    if cell then
        cell:runAction(a3)
    end 
end
function cls:yellowDiamondChange(cell)
    local file = self.ctl:getSpineFile("symbol_change")
    local file1 = self.ctl:getSpineFile("symbol_blue")
    self.ctl:playMusicByName("gem_change")
    self:diamondSymbolChange(cell, file, file1, 100, self.ctl:getBonus1Pic())
end
function cls:diamondSymbolChange(cell, file, file1, addNum, pic)
    if cell and bole.isValidNode(cell) then
        cell.key = cell.key + addNum
        local symbolTipAnim = cell.symbolTipAnim
        if symbolTipAnim and bole.isValidNode(symbolTipAnim) then
            local theCellSprite = cell.sprite
            local theCellAniSprite = symbolTipAnim.theCellSprite
            local spineNode = symbolTipAnim.spineNode
            local a1 = cc.DelayTime:create(15/30)
            local a2 = cc.CallFunc:create(function ()
                spineNode:removeAllChildren()
                bole.addSpineAnimationInTheme(spineNode, 1, file, cc.p(0,0), "animation")
            end)
            local a3 = cc.DelayTime:create(10/30)
            local a4 = cc.CallFunc:create(function ()
                bole.updateSpriteWithFile(theCellSprite, pic)
                bole.updateSpriteWithFile(theCellAniSprite, pic)
            end)
            local a5 = cc.DelayTime:create(14/30)
            local a6 = cc.CallFunc:create(function ()
                local _, tipAnim = bole.addSpineAnimationInTheme(spineNode, nil, file1, cc.p(0,0), "animation2", nil, nil, nil, true, true)
                symbolTipAnim.tipAnim = tipAnim
            end)
            local a7 = cc.Sequence:create(a1, a2, a3, a4, a5, a6)
            symbolTipAnim:runAction(a7)
        end
    end
end

------------------ bonus2 end ------------------

------------------------ respinBonus start ------------------------
function cls:showEpicStartDialog()
    local theData = {}
    local dialogType = "respin_start"
	local csbPath = "dialog_welcome"
    local musicName = "dialog_bonus1"
    local musicOaName = "dialog_bonus_oa1"
    theData.bg = 1
    theData.bg1 = 1
    if self.ctl:getSuperRespinType() then
        theData.bg = 3
        theData.bg1 = 3
        musicName = "dialog_bonus2"
        musicOaName = nil
    elseif self.ctl:getRespinType() == 2 then
        theData.bg = 2
        theData.bg1 = 2
        musicOaName = "dialog_bonus_oa2"
    end
    theData.click_event = function ( ... )
        self.startEpicLinkDailog = nil
        self.ctl:stopDialogMusic(musicName)
        self:epicStartEvent()
	end
    self.ctl:playDialogMusic(musicName)
    if musicOaName then
        self.ctl:playMusicByName(musicOaName)
    end
    local dialog = self._mainViewCtl:showThemeDialog(theData, 1, csbPath, dialogType)
    self.startEpicLinkDailog = dialog
    local btn_node = dialog.startRoot.btnStart
    local baseScale =  bole.getAdaptScale()
	local bg_width = 555
	local scale = FRAME_HEIGHT / (bg_width * baseScale)
    scale = scale * (bg_width/720)
	btn_node:setScale(scale)

    if bole.isWidescreen() then 
		local moveY = bole.getAdaptBottomHMoveY()
		dialog:setPositionY(-moveY)
        btn_node:setPositionY(moveY)
	end

    self.ctl:laterCallBack(5, function ()
        self:autoCloseStartDialog()
    end)
end
function cls:autoCloseStartDialog()
    if self.startEpicLinkDailog and bole.isValidNode(self.startEpicLinkDailog) then
        local startRoot = self.startEpicLinkDailog.startRoot
		if startRoot and startRoot.btnStart then 
			startRoot.btnStart:setTouchEnabled(false)
            startRoot.btnStart:setBright(false)
			self.startEpicLinkDailog:clickStartBtn()
			self.startEpicLinkDailog = nil
		end
    end
end
function cls:epicStartEvent()
    self.ctl:setClickEpicStart(true)
    self.ctl:laterCallBack(1, function ()
        local onEnd = function ()
            self._mainViewCtl:dealMusic_EnterBonusGame(self.ctl:getSuperRespinType())
            self.ctl:enterEpicBonusByStep()
        end
        local onCover = function ()
            self._mainViewCtl:stopDrawAnimate()
            self.ctl:changeSpinBoard()
        end
        self:playStartTransition(onEnd, onCover)
    end)
end
function cls:playStartTransition(onEnd, onCover)
    local sType = "respin"
    if self.ctl:getSuperRespinType() then
        sType = "super_respin"
    end
    local transitionDelay = self.gameConfig.transition_config[sType]
    self._mainViewCtl:playTransition(onEnd, sType, onCover)
end
function cls:respin_symbolLand(cell, col, item)
    local featureId = 12
    if self.ctl:getRespinType() == 2 then
        featureId = 13
    end
    local pos = self._mainViewCtl:getCellPos(col, 1)
    local addJp = self.ctl:adjustHighSymbolType(item)
    local landAni = "animation1"
	local landLoopAni = "animation2"
    local file = self._mainViewCtl:getPic("spine/item/"..featureId.."/spine")
    local tipAniNode = self._mainViewCtl:getDiamondHighZorder(item, col, 1, cell.tipNode, nil, nil, true)
	local s, tipAnim = bole.addSpineAnimationInTheme(tipAniNode.spineNode, nil, file, cc.p(0,0), landAni, nil, nil, nil, true)
    tipAnim:addAnimation(0, landLoopAni, true)
	tipAniNode.tipAnim = tipAnim
    local a1 = cc.DelayTime:create(5/30)
	local a2 = cc.CallFunc:create(function ( ... )
		if cell and cell.sprite and bole.isValidNode(cell.sprite) then 
			cell.sprite:setVisible(false)
		end
		if tipAniNode and bole.isValidNode(tipAniNode) then
			bole.changeParent(tipAniNode, self.animateNode, maxZoder)
			tipAniNode:setPosition(pos)
		end
	end)
    local a3 = cc.DelayTime:create(15/30)
    local a4 = cc.CallFunc:create(function ()
        if cell and cell.sprite and bole.isValidNode(cell.sprite) then 
			cell.sprite:setVisible(true)
		end
        if addJp then
            self:setAdditionJpAni(tipAniNode, item+1, pos)
        end
        if tipAniNode and bole.isValidNode(tipAniNode) then 
            tipAniNode:setLocalZOrder(col)
		end
    end)
	local a5 = cc.Sequence:create(a1,a2,a3,a4)
	tipAniNode:runAction(a5)
end
function cls:setAdditionJpAni(tipAniNode, item, pos)
    pos = pos or cc.p(0,0)
    if tipAniNode and bole.isValidNode(tipAniNode) then
        local file = self.ctl:getSpineFile("blue_add")
        local waitTime = 0.5
        bole.addSpineAnimationInTheme(self.animateNode, 1000, file, pos, "animation")
        local jackpotNode = tipAniNode.jackpotNode
        if jackpotNode and bole.isValidNode(jackpotNode) then
            local a1 = cc.DelayTime:create(waitTime)
            local a2 = cc.CallFunc:create(function ()
                local jpType = self._mainViewCtl:getHighDiamondSymbol(item)
		        if jpType then
		        	local jpPng = "#theme244_s_jp_"..jpType..".png"	
                    bole.updateSpriteWithFile(jackpotNode, jpPng)
		        end
            end)
            local a3 = cc.Sequence:create(a1,a2)
            jackpotNode:runAction(a3)
        end 
    end
end
function cls:addCoinsToSymbolAni(count)
    count = count or 1
    local rollTime = 1.7
    local aniTime = 3
    local random = 1 -- 1 是从左到右
    if math.random() > 0.5 then 
        random = 2 -- 2 是从右到左
    end

    if math.random() > 0.7 then
        self.ctl:playMusicByName("respin_jili")
    else 
        self.ctl:playMusicByName("respin_jili1")
    end
    
    local file = self.ctl:getSpineFile("jili_board")
    local pos = cc.p(0,0)
    if bole.isWidescreen() then 
        pos = cc.p(0, -bole.getAdaptBottomHMoveY()/2)
	end
    self.ctl:laterCallBack(aniTime, function ()
        self:addCoinsToSymbol(random)
    end)
    local parent = self._mainViewCtl:getMainViewDownNode()
    local _, spine = bole.addSpineAnimationInTheme(parent, nil, file, pos, "animation1")
    if random == 2 then
        spine:setScaleX(-1)
    end
    return count * rollTime + aniTime
end

function cls:addCoinsToSymbol(random)
    -- 是从左到右还是从右到左
    local addAllCoinsList = self.ctl:getExtraAddCoinsData()

    local file = self.ctl:getSpineFile("label_add")
    local file1 = self.ctl:getSpineFile("respin_blue_label")
    if self.ctl:getRespinType() == 2 then
        file1 = self.ctl:getSpineFile("respin_yellow_label")
    end

    local delay = 0
    local rollTime = 1
    local showCoinsTime = 0.7
    local startCol = 1
    local maxCol = 5
    local addCol = 1
    if random == 2 then 
        startCol = 5
        maxCol = 1
        addCol = -1
    end

    local changeScaleFun = function (node, colIndex, cellNode, addCoins)
        colIndex = colIndex or 1
        addCoins = addCoins or 1
        if node and bole.isValidNode(node) then
            local a1 = cc.ScaleTo:create(0.2, 1.25)
            -- local a10 = cc.ScaleTo:create(0.1, 1.1)
            -- local a11 = cc.ScaleTo:create(0.05, 1.25)
            local a6 = cc.DelayTime:create(1.2)
            local a7 = cc.CallFunc:create(function ()
                if node and bole.isValidNode(node) then
                    node:setLocalZOrder(colIndex)
                end
                if cellNode and bole.isValidNode(cellNode) then
                    cellNode:setVisible(true)
                end
            end)
            local a2 = cc.ScaleTo:create(0.2, 0.9)
            local a3 = cc.ScaleTo:create(0.1, 1)
            local a8 = cc.Sequence:create(a1,a6,a2,a3,a7)
            if node and bole.isValidNode(node) then
                node:setLocalZOrder(maxZoder)
            end
            node:runAction(a8)
        end
    end

    for col = startCol, maxCol, addCol do
        for row = 1, 3 do
            local addCoins = addAllCoinsList[col][row]
            if addCoins > 0 then
                local colIndex = (row - 1) * 5 + col
                local node = self._mainViewCtl:getDiamondHighNode(colIndex, 1)
                local cellNode = self._mainViewCtl:getCellNode(colIndex, 1)
                local startWPos = bole.getWorldPos(cellNode)
                local startNPos = bole.getNodePos(self.flyParent, startWPos)
                if node and bole.isValidNode(node) then
                    cellNode:setVisible(false)
                    local a1 = cc.DelayTime:create(delay)
                    local a2 = cc.CallFunc:create(function ()
                        
                        bole.addSpineAnimationInTheme(self.flyParent, 4, file1, startNPos, "animation")
                        changeScaleFun(node, colIndex, cellNode, addCoins)
                    end)
                    local a3 = cc.DelayTime:create(showCoinsTime)
                    local a4 = cc.CallFunc:create(function ()
                        -- if node.jackpotNode then
                        --     bole.addSpineAnimationInTheme(self.flyParent, 5, file, startNPos, "animation2")
                        -- else 
                            self.ctl:playMusicByName("respin_coin_rise")
                            bole.addSpineAnimationInTheme(self.flyParent, 5, file, startNPos, "animation")
                        -- end
                    end)
                    local a5 = cc.DelayTime:create(5/30)
                    local a6 = cc.CallFunc:create(function ()
                        self:addOtherCoinsInJpSymbol(node, addCoins, 0)
                    end)
                    local a7 = cc.Sequence:create(a1,a2,a3,a4,a5,a6)
                    node:runAction(a7)
                    delay = delay + rollTime + showCoinsTime
                end
            end
        end
    end
end
function cls:addRollLableNode(tipAniNode, colIndex, cellNode, addCoins)
    local node = nil
    colIndex = colIndex or 1
    addCoins = addCoins or 0
    if not cellNode then return end
    if self.addRollLableList and self.addRollLableList[colIndex] and bole.isValidNode(self.addRollLableList[colIndex]) then
        node = self.addRollLableList[colIndex]
    else 
        local csbName = "addLabel"
        local csbPath = self._mainViewCtl:getCsbPath(csbName)
        node = cc.CSLoader:createNode(csbPath)
        local wPos = bole.getWorldPos(cellNode)
        local nPos = bole.getNodePos(self.flyParent, wPos)
        self.flyParent:addChild(node)
        node:setPosition(nPos)
        self.addRollLableList = self.addRollLableList or {}
        self.addRollLableList[colIndex] = node
    end
    
    -- cellNode:setVisible(true)
    local content = node:getChildByName("content")
    local itemNode = content:getChildByName("item")
    local label = itemNode:getChildByName("label")
    itemNode:setPosition(cc.p(88,25))  --中间位置是 0,67
    label:setString(FONTS.formatByCount4(addCoins,7,true))
    content:setClippingEnabled(true)
    bole.setEnableRecursiveCascading(itemNode, true)
    itemNode:setScale(0)
    itemNode:setOpacity(0)
    node:setVisible(true)
    
    -- 最初的版本1
    -- local a1 = cc.ScaleTo:create(1, 1.25)
    -- local a2 = cc.FadeTo:create(1, 255)
    -- local a3 = cc.EaseIn:create(cc.MoveTo:create(1, cc.p(88, 90)), 4) --90
    -- local a4 = cc.Spawn:create(a1, a2, a3)
    -- local a6 = cc.DelayTime:create(0.2)
    -- local a7 = cc.EaseOut:create(cc.MoveTo:create(0.3, cc.p(88, 150)), 4)
    -- local a8 = cc.CallFunc:create(function ()
    --     node:setVisible(false)
    -- end)
    -- local a9 = cc.Sequence:create(a4,a6,a7,a8)
    -- itemNode:runAction(a9)
    -- local f1 = cc.ScaleTo:create(0.2, 0.9)
    -- local f2 = cc.ScaleTo:create(0.1, 1)
    -- local f3 = cc.Sequence:create(f1,f2)


    -- 最新的版本1
    local a1 = cc.ScaleTo:create(1, 1.25)
    local a2 = cc.FadeTo:create(1, 255)
    local a3 = cc.EaseIn:create(cc.MoveTo:create(1, cc.p(88, 90)), 4) --90
    local a4 = cc.Spawn:create(a1, a2, a3)
    local a6 = cc.DelayTime:create(0.2)
    local a7 = cc.EaseOut:create(cc.MoveTo:create(0.3, cc.p(88, 110)), 4)
    local a5 = cc.ScaleTo:create(0.3, 0)
    local a8 = cc.FadeTo:create(0.3, 0)
    local a9 = cc.Spawn:create(a7,a8,a5)
    local a10 = cc.CallFunc:create(function ()
        node:setVisible(false)
    end)
    local a11 = cc.Sequence:create(a4,a6,a9,a10)
    itemNode:runAction(a11)
end
function cls:addOtherCoinsInJpSymbol(node, addCoins, rollTime)
    addCoins = addCoins or 0
    rollTime = rollTime or 0
    local jackpotNode = node.jackpotNode
    local labelNode = node.labelNode
    local addNode = node.addNode
    if jackpotNode and bole.isValidNode(jackpotNode) then
        jackpotNode:setPositionY(30)
        labelNode:setPositionY(-30)
        if not addNode then
            local addPng = "#theme244_s_add.png"	
            addNode = bole.createSpriteWithFile(addPng)
            node:addChild(addNode, 1)
            node.addNode = addNode
        end
    end
    if labelNode and bole.isValidNode(labelNode) then
        local startCoins = labelNode.coins
        local endCoins = startCoins + addCoins
        labelNode.coins = endCoins
        if rollTime == 0 then
            labelNode:setString(FONTS.formatByCount4(endCoins,4,true))
        else 
            labelNode:nrStartRoll(startCoins, endCoins, rollTime)
        end
    end
end

function cls:playJackpotDialog(jpType, colIndex, doNext)
    local theData = {}
    local dialogType = "jp_collect"
	local csbPath = "dialog_jp"
    self.ctl:playDialogMusic("dialog_jp"..jpType)

    theData.bg = jpType
    theData.click_event = function ( ... )
        self.ctl:stopDialogMusic("dialog_jp"..jpType)
        self.jackpotDialog = nil
        self._mainViewCtl:getJpViewCtl():removeJpAwardAnimation(jpType)
        self:collectJackpotCoins(colIndex, doNext)
        self.ctl:setLockJackpotValue(jpType)
	end
    -- 将钱变成coins的钱吧
    local singleJpCoins = 0
    local symbolInfo = self.ctl:getSymbolInfoByIndex(colIndex)
    if jpType ~= 0 then
        local jackpotInfo = self.ctl:getJackpotInfo(jpType)
        singleJpCoins = jackpotInfo.jp_win  -- 真实的钱数了
        self.ctl.jpHadWin[jpType] = 1
    end
    local addCoins = symbolInfo.addCoins
    symbolInfo.coins = singleJpCoins
    theData.coins = singleJpCoins

    local dialogNode = self._mainViewCtl:showThemeDialog(theData, 3, csbPath, dialogType)
    self.jackpotDialog = dialogNode
    local collectRoot = dialogNode.collectRoot
    local addNode = collectRoot:getChildByName("add_node")
    if addCoins > 0 then
        addNode:setVisible(true)
        self:addJackpotCoins(collectRoot, addNode, addCoins, singleJpCoins, singleJpCoins+addCoins, jpType)
    else 
        addNode:setVisible(false)
    end
    
    local a1 = cc.DelayTime:create(10)
    local a2 = cc.CallFunc:create(function ()
        collectRoot.btnCollect:setTouchEnabled(false)
        collectRoot.btnCollect:setBright(false)
		dialogNode:clickCollectBtn()
    end)
    local a3 = cc.Sequence:create(a1,a2)
    dialogNode:runAction(a3)
end
function cls:addJackpotCoins(collectRoot, addNode, addCoins, startCoins, endCoins, jpType)
    local addDouble = addNode:getChildByName("add_double")
    local addLabel = addNode:getChildByName("add_label")
    local bgNode = collectRoot:getChildByName("bg")
    local bgAniName = {
        "animation1", "animation2", "animation2", "animation3", "animation3"
    }
    collectRoot.btnCollect:setTouchEnabled(false)
    if addCoins > 0 then
        if self.ctl.doubleCurrent then
            addLabel:setVisible(false)
            addDouble:setVisible(true)
        else 
            addDouble:setVisible(false)
            addLabel:setString(FONTS.formatByCount4(addCoins,4,true))
            addLabel:setVisible(true)
        end
    end
    -- if jpType == 1?
    -- bole.setEnableRecursiveCascading(addNode, true)

    local a1 = cc.DelayTime:create(2)
    local a10 = cc.CallFunc:create(function ()
        self.ctl:playMusicByName("jackpot_fly")
    end)
    local a2 = cc.JumpTo:create(0.5, cc.p(0, -55), 200, 1)
    local a3 = cc.CallFunc:create(function ()
        local file = self.ctl:getSpineFile("dialog_jackpot_double")
        bole.addSpineAnimationInTheme(bgNode, 100, file, cc.p(0,-60), bgAniName[jpType])
        self.jackpotDialog:rollCoinsAgain(startCoins, endCoins)
    end)
    local a4 = cc.ScaleTo:create(0.2, 0)
    local a5 = cc.DelayTime:create(1)
    local a6 = cc.CallFunc:create(function ()
        addNode:setVisible(false)
        collectRoot.btnCollect:setTouchEnabled(true)
    end)
    local a7 = cc.Sequence:create(a1,a10,a2,a3,a4,a5,a6)
    addNode:runAction(a7)
end
function cls:collectJackpotCoins(colIndex, doNext)
    self.ctl:laterCallBack(1, function ()
        self:collectCoinsToFooter(colIndex, doNext)
    end)
end
function cls:lightAllDiamondSymbol()
    self.ctl:playMusicByName("respin_congrats")
end
function cls:addCollectJpLight(colIndex)
    local node = self._mainViewCtl:getDiamondHighZorder(nil, colIndex, 1)
    if node and bole.isValidNode(node) then
        node:setLocalZOrder(100)
        local spineNode = node.spineNode
        local featureId = 12
        if self.ctl:getRespinType() == 2 then
            featureId = 13
        end
        local file = self._mainViewCtl:getPic("spine/item/"..featureId.."/spine")
        local _, spine = bole.addSpineAnimationInTheme(spineNode, 1, file, cc.p(0,0), "animation4_1", nil, nil, nil, true, true)
        local a1 = cc.DelayTime:create(2.5)
        local a2 = cc.RemoveSelf:create()
        local a3 = cc.Sequence:create(a1,a2)
        spine:runAction(a3)
    end
end
function cls:collectCoinsToFooter(colIndex, doNext)
    local symbolInfo = self.ctl:getSymbolInfoByIndex(colIndex)
    local cellNode = self._mainViewCtl:getCellNode(colIndex, 1)
    local coins = symbolInfo.coins 
    local jpType = symbolInfo.jp
    local addCoins = symbolInfo.addCoins
    local allCoins = 0
    if coins then
        allCoins = coins + allCoins
    end
    if addCoins then
        allCoins = addCoins + allCoins
    end

    self.ctl:playMusicByName("respin_finish")

    local node = self._mainViewCtl:getDiamondHighZorder(nil, colIndex, 1)
    if node and bole.isValidNode(node) then
        node:setLocalZOrder(100)
        local tipAnim = node.tipAnim
        local theCellSprite = node.theCellSprite
        if tipAnim and bole.isValidNode(tipAnim) then
            if node.jackpotNode then
                bole.spChangeAnimation(tipAnim, "animation4_1")
            else 
                bole.spChangeAnimation(tipAnim, "animation4")
            end
            local s1 = cc.DelayTime:create(15/30)
            local s2 = cc.CallFunc:create(function ()
                tipAnim:setVisible(false)
                if theCellSprite and bole.isValidNode(theCellSprite) then
                    theCellSprite:setVisible(true)
                end
                node:setLocalZOrder(colIndex)
            end)
            local s3 = cc.Sequence:create(s1,s2)
            tipAnim:runAction(s3)
            -- tipAnim:addAnimation(0, "animation4_1", false)
            -- tipAnim:setVisible(false)
        end
        
    end
    
    -- local file = self.ctl:getSpineFile("respin_finish")
    local file = self.ctl:getSpineFile("respin_collect")
    local fileFooter = self.ctl:getSpineFile("respin_footer1")


    local animateName = "animation"..colIndex
    local animateSymbolName = "animation31"
    local animateFooterName = "animation"
    if self.ctl:getRespinType() == 2 then
        fileFooter = self.ctl:getSpineFile("respin_footer2")
        animateName = "animation"..(colIndex + 15)
        animateSymbolName = "animation33"
        -- animateFooterName = "animation34"
    end
    local startWPos = bole.getWorldPos(cellNode)
    local startNPos = bole.getNodePos(self.flyParent, startWPos)
    local endPos = self.ctl:getWinFooterWorldPos(self.flyParent)
    local node = cc.Node:create()
    self.flyParent:addChild(node)
    node:setPosition(cc.p(0, 0))

    local moveEnd = cc.p(0, 0)
    if bole.isWidescreen() then
        moveEnd = cc.p(0, -bole.getAdaptBottomHMoveY()) 
		node:setPositionY(-bole.getAdaptBottomHMoveY()/2)
	end
        
    -- local a0 = cc.DelayTime:create(3/30)
    -- local a01 = cc.CallFunc:create(function ()
    --     self.ctl:playMusicByName("respin_collect")
    --     bole.addSpineAnimationInTheme(self.flyParent, nil, file, startNPos, animateSymbolName)
    --     bole.addSpineAnimationInTheme(node, nil, file, cc.p(0,0), animateName)
    --     bole.addSpineAnimationInTheme(self.flyParent, 1, file, endPos, animateFooterName)
    -- end)
    -- local a1 = cc.DelayTime:create(10/30)
    -- local a2 = cc.MoveTo:create(8/30, moveEnd)
    -- local a5 = cc.CallFunc:create(function ()
    --     self.ctl:addFooterCoins(allCoins, doNext)
    -- end)
    -- local a6 = cc.DelayTime:create(1)
    -- local a7 = cc.RemoveSelf:create()
    -- local a8 = cc.Sequence:create(a0,a01,a1,a2,a5,a6,a7)
    -- node:runAction(a8)

    local a0 = cc.DelayTime:create(5/30)
    local a01 = cc.CallFunc:create(function ()
        self.ctl:playMusicByName("respin_collect")
        bole.addSpineAnimationInTheme(self.flyParent, nil, file, startNPos, animateSymbolName)
        bole.addSpineAnimationInTheme(node, nil, file, cc.p(0,0), animateName)
        bole.addSpineAnimationInTheme(self.flyParent, 1, fileFooter, endPos, animateFooterName)
    end)
    local a1 = cc.DelayTime:create(10/30)
    local a2 = cc.MoveTo:create(8/30, moveEnd)
    local a5 = cc.CallFunc:create(function ()
        self.ctl:addFooterCoins(allCoins, doNext)
    end)
    local a6 = cc.DelayTime:create(1)
    local a7 = cc.RemoveSelf:create()
    local a8 = cc.Sequence:create(a0,a01,a1,a2,a5,a6,a7)
    node:runAction(a8)
end
function cls:collectDoubleDiamondStep()
    local delay = 0
    local showDoubleTime = 0.5
    local file = self.ctl:getSpineFile("blue_add")
    if self.ctl:getRespinType() == 2 then
        file = self.ctl:getSpineFile("yellow_add")
    end
    for row = 1, 3 do
        for col = 1, 5 do
            local symbolId = self.ctl.initItemList[col][row]
            local colIndex = (row - 1) * 5 + col
            local node = self._mainViewCtl:getDiamondHighNode(colIndex, 1)
            if node and bole.isValidNode(node) then
                local a1 = cc.DelayTime:create(delay)
                local a2 = cc.CallFunc:create(function ()
                    local wPos = bole.getWorldPos(node)
                    local nPos = bole.getNodePos(self.flyParent, wPos)
                    self.ctl:playMusicByName("respin_coin_rise")
                    if node.jackpotNode then 
                        bole.addSpineAnimationInTheme(self.flyParent, nil, file, nPos, "animation2")
                    else 
                        bole.addSpineAnimationInTheme(self.flyParent, nil, file, nPos, "animation")
                    end
                end)
                local a3 = cc.DelayTime:create(showDoubleTime/2)
                local a4 = cc.CallFunc:create(function ()
                    local symbolInfo = self.ctl:getSymbolInfoByIndex(colIndex)
                    local extraAddCoins = symbolInfo.addCoins
                    local addCoins = self.ctl:getSymbolCoins(self.bonusCoinsList[symbolId])
                    self.ctl:setDiamondSymbolList(symbolId, symbolInfo, addCoins+extraAddCoins)

                    local addNode = nil
                    
                    local jackpotNode = node.jackpotNode
                    local labelNode = node.labelNode
                    if jackpotNode and bole.isValidNode(jackpotNode) then
                        local addPng = "#theme244_s_double.png"	
                        addNode = bole.createSpriteWithFile(addPng)
                        node:addChild(addNode, 1)
                        addNode:setScale(0)
                        addNode:setPosition(cc.p(0, 0))
                        local a1 = cc.ScaleTo:create(0.2, 1)
                        local a2 = cc.MoveTo:create(0.2, cc.p(0, -25))
                        local a3 = cc.Spawn:create(a1,a2)
                        addNode:runAction(a3)
                        jackpotNode:runAction(cc.MoveTo:create(0.2, cc.p(0, 25)))
                    else 
                        self:addOtherCoinsInJpSymbol(node, addCoins)
                    end
                    node.addNode = addNode
                    -- if labelNode and bole.isValidNode(labelNode) then
                    --     labelNode:runAction(cc.MoveTo:create(0.2, cc.p(0, 25)))
                    -- end
                end)
                local a5 = cc.Sequence:create(a1,a2,a3,a4)
                node:runAction(a5)
                delay = delay + showDoubleTime
            end
        end
    end
    self.ctl:laterCallBack(delay, function ()
        self.ctl:collectDiamondStep()
    end)
end
-------------------- respin pick start --------------------
function cls:playExtraPickDailog()
    -- 弹窗自己添加吧
    self.ctl:playDialogMusic("dialog_extra")
    self.ctl:playMusicByName("dialog_extra_pick")
    local csbName = "dialog_pick"
    local csbPath = self._mainViewCtl:getCsbPath(csbName)
    local dialog = cc.CSLoader:createNode(csbPath)
    self.extraPickDialog = dialog
    self._mainViewCtl.curScene:addToContentFooter(dialog)
    self.commonBlack = self:addBlackMask(dialog)
    self.commonBlackAction = {
        stepFade     = { { 0 },  { 8 / 30, 200 } },
        stepEndFade  = { { 200 }, { 10 / 30, 200 }, { 8 / 30, 0 } },
    }
    self.pickBgAni = {
        startAni = "animation1",
        loopAni  = "animation2",
        changeAni = "animation3",
        changeLoop = "animation4",
        hideAni = "animation5"
    }
    self.extraImageAni = {
        startAni = "animation1",
        loopAni = "animation2",
        award1 = "animation3_1",
        award2 = "animation3_2",
        award3 = "animation3_3",
        awardLoop1 = "animation6_1",
        awardLoop2 = "animation6_2",
        awardLoop3 = "animation6_3",
        awardHide1 = "animation7_1",
        awardHide2 = "animation7_2",
        awardHide3 = "animation7_3",
        gray1 = "animation4_1",
        gray2 = "animation4_2",
        gray3 = "animation4_3",
        grayHide1 = "animation8_1",
        grayHide2 = "animation8_2",
        grayHide3 = "animation8_3",
    }

    local root = dialog:getChildByName("root")
    local nodeStart = root:getChildByName("node_start")
    local bg = nodeStart:getChildByName("bg")
    local contentNode = nodeStart:getChildByName("content_node")
    self.contentList = {}
    for key = 1, 3 do
        local cotentItem = contentNode:getChildByName("conten"..key)
        local btn = cotentItem:getChildByName("btn")
        local aniNode = cotentItem:getChildByName("ani")
        btn.index = key
        cotentItem.btnNode = btn
        cotentItem.aniNode = aniNode
        self.contentList[key] = cotentItem
        self:initPickBtnEvent(btn, key)
    end
    self:addPickDialogSpine(bg)
    self:allBtnEnabled(false)
end
function cls:addBlackMask(parent)
    local mask = cc.LayerColor:create(cc.c4b(0, 0, 0, 0))
    mask:setAnchorPoint(cc.p(0.5, 0.5))
    mask:setContentSize(4000, 4000)
    mask:setPosition(-2000, -2000)
    parent:addChild(mask, -1)
    return mask
end
function cls:_addCommonBlackSpine(target, fadeAction)
    if fadeAction then
        bole.setEnableRecursiveCascading(target, true)
        target:setOpacity(fadeAction[1][1])
        target:setVisible(true)
        local fadeList = {}
        for key = 2, #fadeAction do
            local info = fadeAction[key]
            local a1 = cc.FadeTo:create(info[1], info[2])
            table.insert(fadeList, a1)
        end
        target:runAction(cc.Sequence:create(unpack(fadeList)))
    end
end
function cls:_removeCommonBlackSpine(target, fadeAction)
    self:_addCommonBlackSpine(target, fadeAction)
end
function cls:addPickDialogSpine(bgNode)
    local bgFile = self.ctl:getSpineFile("dialog_pick")
    local _, spine = bole.addSpineAnimationInTheme(bgNode, nil, bgFile, cc.p(0,0), self.pickBgAni["startAni"], nil, nil, nil, true)
    spine:addAnimation(0, self.pickBgAni["loopAni"], true)
    self.pickBgSpine = spine
    for key, val in ipairs(self.contentList) do
        if key == 2 then
            self:_addExtraImageSpine(val, 6/30)
        else 
            self:_addExtraImageSpine(val, 9/30)
        end
    end
    self:_addCommonBlackSpine(self.commonBlack, self.commonBlackAction["stepFade"])
    self.ctl:laterCallBack(1, function ()
        self:allBtnEnabled(true)
    end)
end
function cls:_addExtraImageSpine(node, delay)
    local bgFile1 = self.ctl:getSpineFile("dialog_pick1") -- 个数
    local a1 = cc.DelayTime:create(delay)
    local a2 = cc.CallFunc:create(function ()
        local aniNode = node.aniNode
        local _, spine = bole.addSpineAnimationInTheme(aniNode, nil, bgFile1, cc.p(0,0), self.extraImageAni["startAni"], nil, nil, nil, true)
        spine:addAnimation(0, self.extraImageAni["loopAni"], true)
        node.spine = spine
    end)
    local a3 = cc.Sequence:create(a1,a2)
    node:runAction(a3)
end
function cls:initPickBtnEvent(btnNode, index)
    local function btnOnTouch( obj, eventType )
        if eventType == ccui.TouchEventType.ended then
            self.ctl:playMusicByName("respin_click")
            self:pickClickResult(obj.index)
            self:allBtnEnabled(false)
        end
    end
    btnNode:addTouchEventListener(btnOnTouch)
end
function cls:pickClickResult(index)
    local leftResult = {}
    local clickResult = self.ctl.extraSpin
    for key = 1, 3 do
        if key ~= clickResult then
            table.insert(leftResult, key)
        end
    end
    if math.random() > 0.5 then
        table.sort(leftResult, function (a, b)
            return a > b
        end)
    end

    if self.pickBgSpine and bole.isValidNode(self.pickBgSpine) then
        bole.spChangeAnimation(self.pickBgSpine, self.pickBgAni["changeAni"])
        self.pickBgSpine:addAnimation(0, self.pickBgAni["changeLoop"], true)
    end
    
    for key, val in ipairs(self.contentList) do
        local spine = val.spine
        if spine and bole.isValidNode(spine) then
            if key == index then
                bole.spChangeAnimation(spine, self.extraImageAni["award"..clickResult])
                spine:addAnimation(0, self.extraImageAni["awardLoop"..clickResult], true)
                spine.hideName = self.extraImageAni["awardHide"..clickResult]
            else 
                local leftIndex = table.remove(leftResult, 1)
                local a1 = cc.DelayTime:create(10/30)
                local a2 = cc.CallFunc:create(function ()
                    bole.spChangeAnimation(spine, self.extraImageAni["gray"..leftIndex])
                end)
                local a3 = cc.Sequence:create(a1,a2)
                spine.hideName = self.extraImageAni["grayHide"..leftIndex]
                spine:runAction(a3)
            end
        end
    end

    local a1 = cc.DelayTime:create(2)
    local a2 = cc.CallFunc:create(function ()
        self:hidePickDialog()
    end)
    local a3 = cc.DelayTime:create(1)
    local a4 = cc.CallFunc:create(function ()
        self.ctl:playFadeToMaxVlomeMusic()
        self:addExtraSpinTimes()
        self:cleanPickDialog()
    end)
    local a5 = cc.RemoveSelf:create()
    local a6 = cc.Sequence:create(a1,a2,a3,a4,a5)
    self.extraPickDialog:runAction(a6)
end
function cls:addExtraSpinTimes()
    local boardParent = self._mainViewCtl:getRespinBoard()
    local file = self.ctl:getSpineFile("respin_times_add")
    bole.addSpineAnimationInTheme(self.respinTimesNode, 1, file, cc.p(0,0), "animation")
    local file1 = self.ctl:getSpineFile("respin_times_board")
    local _, spine = bole.addSpineAnimationInTheme(boardParent, 1, file1, cc.p(-20, 210), "animation")
    spine:setScaleX(1.01)
    self.ctl:playMusicByName("respin_add")
    self.ctl:laterCallBack(6/20, function ()
        self.ctl:finishExtraAdd()
    end)
end
function cls:hidePickDialog()
    if self.pickBgSpine and bole.isValidNode(self.pickBgSpine) then
        bole.spChangeAnimation(self.pickBgSpine, self.pickBgAni["hideAni"])
    end
    for key, val in ipairs(self.contentList) do
        local spine = val.spine
        if spine and bole.isValidNode(spine) then
            bole.spChangeAnimation(spine, spine.hideName)
        end
    end
    self:_removeCommonBlackSpine(self.commonBlack, self.commonBlackAction["stepEndFade"])
end
function cls:cleanPickDialog()
    self.pickBgSpine = nil 
    self.contentList = {}
    self.extraPickDialog = nil
end
function cls:allBtnEnabled(enable)
    if not self.contentList then return end 
    for key, val in ipairs(self.contentList) do
        if val.btnNode then
            val.btnNode:setVisible(enable)
        end
    end
end
-------------------- respin pick end --------------------

------------------------ respinBonus end ------------------------
return cls





