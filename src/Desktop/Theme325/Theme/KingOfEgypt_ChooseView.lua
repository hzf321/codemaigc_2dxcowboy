--[[
Author: xiongmeng
Date: 2020-12-11 14:31:35
LastEditors: xiongmeng
LastEditTime: 2021-01-08 01:15:47
Description: 
--]]
local cls = class("KingOfEgypt_ChooseView")

function cls:ctor(ctl, curScene)
	self.ctl = ctl
    -- self.gameConfig = self.ctl:getGameConfig()
    self.curScene = curScene
    self:_initNode()
    self:_initLayout()
end
function cls:_initNode()
    local path = self.ctl:getCsbPath("pick")
    self.pickResultPath = self.ctl:getCsbPath("pick_result")
    self.pickNodePath = self.ctl:getCsbPath("pick_node")
	self.pickRoot = libUI.createCsb(path)
    self.curScene:addToContentFooter(self.pickRoot)
end
function cls:_initLayout()
    self.root = self.pickRoot:getChildByName("root")
    self.pickTip = self.root:getChildByName("pick_tip")
    self.pickNodeCon = self.root:getChildByName("pick_node")
    self:_createPickNode()
    self:_jumpTip(self.pickTip)
    -- self:_addClickEvent()
end
function cls:_createPickNode()
    local pick_info = self.ctl:getPickInfo()
    local pick_pos = pick_info.pick_pos
    -- local pick_image = pick_info.pick_image
    local imageIndex = self.ctl:getLevelImage()
    self.pickNodeList = {}
    self.pickBtnList = {}
    for key, pos in ipairs(pick_pos) do
        local node = self:_createSinglePickNode(pos,imageIndex)
        self.pickNodeCon:addChild(node)
        self.pickNodeList[key] = node
        self.pickBtnList[key] = node.pickBtn
        node.pickBtn.index = key
        self:_addClickEvent(node.pickBtn)
    end 
end
function cls:_createSinglePickNode(pos,imageIndex)
    local node = libUI.createCsb(self.pickNodePath)
    -- local pick_image = node:getChildByName("pick_image")
    -- pick_image:removeFromParent()

    local pickResult = node:getChildByName("pick_result")
    local pickAni = node:getChildByName("pick_ani")
    local pickBtn = node:getChildByName("pick_btn")
    local file = self.ctl:getSpineFile("pick_board")
    local _, pickImage = bole.addSpineAnimation(node, -1, file, cc.p(0,0), "animation"..imageIndex.."_1", nil, nil, nil, true, true)
    node.pickImage = pickImage
    node.loopAni = "animation"..imageIndex.."_1"
    node.staticAni = "animation"..imageIndex.."_3"
    node.clickAni = "animation"..imageIndex.."_2"
    node.noClickAni = "animation"..imageIndex.."_4"
    node.pickResult = pickResult
    node.pickAni = pickAni
    node.pickBtn = pickBtn
    node:setPosition(pos)
    return node 
end
function cls:_addClickEvent(pickBtn)
    -- 添加点击的事件
    -- getCanTouchClick
    if not pickBtn then return end
    local clickFunc = function(obj)
        self.ctl:setBtnClickData(obj.index)
        self:handlePickResult(obj.index, true)
        self.ctl:playMusicByName("map_pick")
        local a1 = cc.DelayTime:create(2)
        local a2 = cc.CallFunc:create(function()
            self:handleOtherResult(true)
        end) 
        local a3 = cc.DelayTime:create(2)
        local a4 = cc.CallFunc:create(function ()
            self:finishDailog()
        end)   
        local a5 = cc.Sequence:create(a1,a2,a3,a4)
        self.ctl.node:runAction(a5)
    end
    local function onTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
			if self.ctl:getCanNotTouchClick() then return end
			obj:setTouchEnabled(false)
			clickFunc(obj)
		end 
    end
    pickBtn:addTouchEventListener(onTouch)
end
function cls:handlePickResult(index, isAni)
    local result = self.ctl.pickResult
    local result_node = self:_createPickResultNode(result)
    local parentNode = self.pickNodeList[index]
    local pickResultNode = parentNode.pickResult
    local pickImage = parentNode.pickImage
    if isAni then
        self.ctl:playMusicByName("map_pick_flip")
        result_node:setScale(0)
        pickImage:setAnimation(0, parentNode.clickAni, false)
        pickImage:addAnimation(0, parentNode.staticAni, false)
        local a1 = cc.DelayTime:create(4/30)
        local a2 = cc.ScaleTo:create(6/30, result_node.endScale or 1)
        local a3 = cc.Sequence:create(a1,a2)
        libUI.runAction(result_node, a3)
    else 
        bole.spChangeAnimation(pickImage, parentNode.staticAni)
    end
    pickResultNode:addChild(result_node)
    parentNode:setLocalZOrder(10)
end
function cls:handleOtherResult(isAni)
    local index = 1
    local clickIndex = self.ctl:getCanNotTouchClick()
    for key = 1, 5 do
        local result = self.ctl.pickLeftResult[index]
        if key ~= clickIndex then
            local result_node = self:_createPickResultNode(result)
            local parentNode = self.pickNodeList[key]
            local pickResultNode = parentNode.pickResult
            local pickImage = parentNode.pickImage
            bole.setEnableRecursiveCascading(result_node, true)
            bole.setEnableRecursiveCascading(parentNode, true)
            if isAni then 
                result_node:setScale(0)
                pickImage:setAnimation(0, parentNode.noClickAni, false)
                pickImage:addAnimation(0, parentNode.staticAni, false)
                local a1 = cc.DelayTime:create(4/30)
                local a2 = cc.ScaleTo:create(6/30, result_node.endScale or 1)
                local a3 = cc.Sequence:create(a1,a2)
                libUI.runAction(result_node, a3)
            else 
                bole.spChangeAnimation(pickImage, parentNode.staticAni)
            end
            result_node:setColor(cc.c3b(150,150,150))
            parentNode:setColor(cc.c3b(150,150,150))
            pickResultNode:addChild(result_node)
            index = index + 1
        end
    end
end
function cls:_createPickResultNode(pickResult)
    local node = nil
    if not self.ctl:isBoosterStatus(pickResult) then
        node = self:_createPickCoinsNode(pickResult)
    else
        node = self:_createPickBoosterNode()
    end
    return node
end
function cls:_createPickBoosterNode()
    local pickResult = self.ctl:getPickLevelConfig()
    local pick_info = self.ctl:getPickInfo()
    local pick_stick = pick_info.pick_stick
    local pick_stick_num = pick_info.pick_stick_num
    local pick_allwin_num = pick_info.pick_allwin_num
    local node = libUI.createCsb(self.pickResultPath)
    local pickResultList = {}
    for key = 1, 8 do
        local pick_result = node:getChildByName("pick_result"..key)
        pick_result:setVisible(false)
        pickResultList[key] = pick_result
    end
    if self.ctl:getSpecailResult(pickResult) then
        local num = self.ctl:getSpecailResult(pickResult)
        local pickNode = pickResultList[pickResult]
        local image1 = pickNode:getChildByName("image1")
        local fontImage = pickNode:getChildByName("font_image") 
        if num == 1 then
            bole.updateSpriteWithFile(image1, pick_stick)
        end
        local pick_num = pick_stick_num
        if pickResult == 8 then
            pick_num = pick_allwin_num
        end
        bole.updateSpriteWithFile(fontImage, string.format(pick_num, num))
    end
    pickResultList[pickResult]:setVisible(true)
    return node 
end
function cls:_createPickCoinsNode(pickResult)
    local pick_info = self.ctl:getPickInfo()
    local pick_font = pick_info.pick_font
    local pick_font_sca = pick_info.pick_font_sca
    local labelCoin = self.ctl:getSymbolLabel(pickResult)
    local str = FONTS.formatByCount4(labelCoin,4,true)
	local label = cc.Label:createWithBMFont(self.ctl:getFntFilePath(pick_font), str)
    label:setScale(pick_font_sca)
    label.endScale = pick_font_sca
    return label
end
function cls:recoverPickResult()
    local clickPickIndex = self.ctl:getCanNotTouchClick()
    self:handlePickResult(clickPickIndex)
    self:handleOtherResult()
    self:finishDailog()
end
function cls:showBoosterDialog()
    local theData = {}
    self.ctl:playMusicByName("dialog_pick_booster")
    theData.click_event = function ( ... )
        self.ctl:collectNotice()
        self.ctl:exitChooseViewBonus()
    end
    local pick_info = self.ctl:getPickInfo()
    local pick_stick = pick_info.pick_pop_stick
    local pick_stick_num = pick_info.pick_pop_stick_num
    local pick_allwin_num = pick_info.pick_pop_allwin_num
    
    local dialog = self.ctl._mainViewCtl:showThemeDialog(theData, 1, "dialog_booster", "pick_booster")
    local startRoot = dialog.startRoot
    local boosterParent = startRoot:getChildByName("booster_node")
    boosterParent:setVisible(true)
    local btnNode = startRoot:getChildByName("btn_node")
    btnNode:setPositionX(5)
    local boosterIndex = self.ctl:getPickLevelConfig()
    for key = 1, 8 do
        local boosterNode = boosterParent:getChildByName("booster"..key)
        if boosterIndex == key then
            local num = self.ctl:getSpecailResult(key)
            if num then
                local pick_num_image = pick_stick_num
                local image1 = boosterNode:getChildByName("image1")
                local image2 = boosterNode:getChildByName("image2")
                if num == 1 then
                    bole.updateSpriteWithFile(image1, pick_stick)
                    image2:setPosition(cc.p(-74, 0))
                end
                if key == 8 then
                    pick_num_image = pick_allwin_num
                end
                bole.updateSpriteWithFile(image2, string.format(pick_num_image, num))
            end
            boosterNode:setVisible(true)
        else
            boosterNode:setVisible(false) 
        end
    end
end
function cls:showCoinsDialog()
    local theData = {}
    self.ctl:playMusicByName("dialog_pick_collect")
    theData.bg = 3
    theData.top = 3
    theData.coins = self.ctl:getSymbolLabel(self.ctl.pickResult)
    theData.click_event = function ( ... )
        self.ctl:collectNotice()
        self.ctl:exitChooseViewBonus()
    end
    local dialog = self.ctl._mainViewCtl:showThemeDialog(theData, 3, "dialog_booster", "pick_collect")
    local collectRoot = dialog.collectRoot
    if collectRoot and collectRoot.btnCollect then 
        collectRoot.btnCollect:setPositionX(-8)
    end
end
function cls:finishDailog()
    self.ctl._mainViewCtl:stopAllLoopMusic()
    
    if self.ctl:getBoosterStatus() then
        self:showBoosterDialog()
    else
        self:showCoinsDialog()
    end
    self.ctl:updateCollectData()
end
function cls:_jumpTip(targetNode)
    if not targetNode then return end
    local time = 0.5
    local a1 = cc.ScaleTo:create(time, 1.05)
    local a2 = cc.ScaleTo:create(time, 1)
    local a3 = cc.ScaleTo:create(time, 0.95)
    local a4 = cc.Sequence:create(a1,a2,a3,a2)
    local a5 = cc.RepeatForever:create(a4)
    targetNode:runAction(a5)
end
function cls:enableChooseRoot(enable)
    self.pickRoot:setVisible(enable)
end
function cls:removeFromParent()
    self.pickRoot:removeFromParent()
    self.pickRoot = nil
end


return cls