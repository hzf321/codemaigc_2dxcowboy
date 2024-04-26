--[[
Author: xiongmeng
Date: 2020-11-20 10:35:58
LastEditors: xiongmeng
LastEditTime: 2021-01-08 18:19:58
Description: 
--]]
local cls = class("KingOfEgypt_FreeView")

function cls:ctor(ctl, nodeList)
	self.ctl = ctl
	self.gameConfig = self.ctl:getGameConfig()
    self.stickWildNode = nodeList[1]
    self.featureDimmer  = nodeList[2]
    -- self.nudgeAnimationNode = cc.Node:create()
    -- self.stickWildNode:addChild(self.nudgeAnimationNode, 1)
end

function cls:stopDrawAnimate( ... )
    
end
-- 
function cls:hideFreeSpinNode( ... )
    self.featureDimmer:stopAllActions()
    self.featureDimmer:setVisible(false)

    self.stickWildNode:removeAllChildren()
    self.stickWildNodeList = {}
end

local showSingleRandomDelay = 15/30
local showSingleRandomTotalT = 20/30
local specialAniDelay = 15/30
local dimmerShowTime = 0.3
local moveWildTime = 1
----------------------------stick wild start -----------------------------------------
function cls:playStackWildAppear( ... )
    self.stickWildNodeList = self.stickWildNodeList or {}
    if self.ctl.mapFgStickyWild and #self.ctl.mapFgStickyWild > 0 then
        for key, item in ipairs(self.ctl.mapFgStickyWild) do
            local col = item[1] + 1
            local row = item[2] + 1
            self.stickWildNodeList[col] = self.stickWildNodeList[col] or {}
            if not bole.isValidNode(self.stickWildNodeList[col][row]) then
                local pos = self.ctl:getCellPos(col, row)
                local img = bole.createSpriteWithFile("#theme325_s_1.png")
                self.stickWildNode:addChild(img)
                img:setPosition(pos)
                img:setScale(0.5)
                self.stickWildNodeList[col][row] = img
            end
        end
    end
end
---------------------------- more wild start -----------------------------------------
-- 添加wild激励
function cls:addMapFreeMoreWildAnticipate( ... )
    local blackInfo = {8/30, 20/30, 8/30}
    local file = self.ctl:getSpineFile("wild_anticipate")
    self:addBoardMaskSpine(blackInfo)
    self:addWildAnticipate(file)
end

function cls:addWildAnticipate( file1 )
    local symbolCount = 3
    local random1 = {}
    for col = 1, 6 do
        for key = 1, symbolCount do
            local num = math.random()
            if num >= 0.05 then
                table.insert(random1, {col, key})
            end
        end
    end
    local delayTime = {0, 20/30, 40/30}
    for key, val in ipairs(random1) do
        local pos = self.ctl:getCellPos(val[1], val[2])
        local random = math.random(1,3)
        local node = cc.Node:create()
        node:setPosition(pos)
        self.stickWildNode:addChild(node,30)
        local a1 = cc.DelayTime:create(delayTime[random])
        local a2 = cc.CallFunc:create(function ( ... )
            self.ctl._mainViewCtl.audioCtl:playEffectWithInterval(self.ctl._mainViewCtl.audio_list["map_wild_add"])
            bole.addSpineAnimation(node, 30, file1, cc.p(0,0), "animation2")
        end)
        local a3 = cc.DelayTime:create(27/30)
        local a4 = cc.RemoveSelf:create()
        local a5 = cc.Sequence:create(a1,a2,a3,a4)
        libUI.runAction(node, a5)
    end
end

function cls:addBoardMaskSpine( blackInfo )
    if not blackInfo then return end
    local blackNode = self.featureDimmer
    blackNode:setOpacity(0)
    blackNode:setVisible(true)
    local a1 = cc.FadeTo:create(blackInfo[1], 180)
    local a2 = cc.DelayTime:create(blackInfo[2])
    local a3 = cc.FadeTo:create(blackInfo[3], 0)
    local a4 = cc.Sequence:create(a1,a2,a3)
    libUI.runAction(blackNode, a4)
end
---------------------------- more wild end -----------------------------------------





---------------------------- remove lowSymbol start -----------------------------------------
---------------------------- remove lowSymbol end  -----------------------------------------

---------------------------- wild extend start -----------------------------------------
-- 需要等到列停了之后才能复制，直接在onthemeinfo中操作即可
function cls:nudgeExpendWildBoard(rets)
    local expendInfo = {} --用来扩展的内容
    self.ctl.addNewWild = {}
    local item_list = table.copy(self.ctl.item_list)
    local wildId = self.ctl.wildSymbolId
    local rowWeight = {
        [1] = 2,
        [2] = 3,
        [3] = 1
     }
    local itemStickList = self.ctl:getItemListStickWild()
    for key, val in ipairs(self.ctl.mapFgWildReel) do
        if val > 0 then 
            if rets and rets["item_list"] and rets["item_list"][key] then 
                rets["item_list"][key] = {1,1,1}
            end
            self.ctl._mainViewCtl.rets["item_list"][key] = {1,1,1}
            self.ctl._mainViewCtl.item_list[key] = {1,1,1}
            
            local index = 0
            local noWildList = {}
            local newWildList = {0,0,0}
            local newNoWildList = {}
            local wildRow = 0
            for row, item in ipairs(item_list[key]) do 
                if item == wildId then 
                    if index < rowWeight[row] then 
                        wildRow = row
                        index = rowWeight[row]
                    end
                else 
                    table.insert(noWildList, row)
                end
            end
            if itemStickList and #itemStickList > 0 then 
                for row, item in ipairs(itemStickList[key]) do 
                    if wildRow == 0 then 
                        if item == wildId then 
                            if index < rowWeight[row] then 
                                wildRow = row
                                index = rowWeight[row]
                            end
                        end
                    end
                    if item == wildId then 
                        newWildList[row] = 1
                    end
                end 
            end
            -- 最新的需要复制到的地方
            for key, val in ipairs(noWildList) do 
                if newWildList[val] == 0 then 
                    table.insert(newNoWildList, val)
                end
            end
            expendInfo[key] = {
                wildRow, newNoWildList
            }
        end
    end
    for key, wildInfo in pairs(expendInfo) do 
        self:addNudgeCellAnim(key, wildInfo)
    end
end
function cls:addNudgeCellAnim(col, wildInfo)
    if not col or not wildInfo then return end
    col = col or 1
    local row = wildInfo[1]
    local noWildInfo = wildInfo[2]
    local startCell = self.ctl:getCellItem(col, row)
    local startWPos = bole.getWorldPos(startCell)
    local startPos = bole.getNodePos(self.stickWildNode, startWPos)

    local moveTime = 12/30
    local allWildTime = 35/30
    local file = self.ctl:getSpineFile("wild_expend")
    
    for key, val in ipairs(noWildInfo) do
        local endCell = self.ctl:getCellItem(col, val)
        local endWPos = bole.getWorldPos(endCell)
        local endPos = bole.getNodePos(self.stickWildNode, endWPos)
        if self.ctl.addNewWild then 
            table.insert(self.ctl.addNewWild, {col, val})
        end
        local flyNode = cc.Node:create()
	    flyNode:setPosition(startPos)
        self.stickWildNode:addChild(flyNode, 100)
        self.ctl._mainViewCtl.audioCtl:playEffectWithInterval(self.ctl._mainViewCtl.audio_list["map_pick_wildmoving"])
        bole.addSpineAnimation(flyNode, nil, file, cc.p(0,0), "animation3")
        local a1 = cc.MoveTo:create(moveTime, endPos)
        local a2 = cc.CallFunc:create(function ()
            self.ctl._mainViewCtl:updateCellSprite(endCell, col, true, self.ctl.wildSymbolId, true)
        end)
        local a3 = cc.DelayTime:create(allWildTime - moveTime)
        local a4 = cc.RemoveSelf:create()
        local a5 = cc.Sequence:create(a1,a2,a3,a4)
        libUI.runAction(flyNode, a5)
    end
end

---------------------------- wild extend end   -----------------------------------------

---------------------------- yin change yinwild start -----------------------------------------
---------------------------- yin change yinwild end  -----------------------------------------

---------------------------- yang change yangwild start -----------------------------------------
---------------------------- yang change yangwild end  -----------------------------------------

------------------------------------------------------------------------------------------------

function cls:getFreeDialogNodeAnimConfig( sType, state )
    local _freeDialogConfig = self.gameConfig.freeSpinDialogConfig 
    local lbAnimConfig
    local btnAnimConfig
    if _freeDialogConfig then 
        lbAnimConfig = _freeDialogConfig.actionLb[sType] and _freeDialogConfig.actionLb[sType][state] or nil
        btnAnimConfig = _freeDialogConfig.actionBtn[sType] and _freeDialogConfig.actionBtn[sType][state] or nil
    end
    return lbAnimConfig, btnAnimConfig
end

return cls