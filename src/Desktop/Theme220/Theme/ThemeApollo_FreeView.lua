--- @program src
--- @description: theme220 free game
--- @author: rwb
--- @create: 2020/11/30 18:49:58
local cls = class("ThemeApollo_FreeView")
function cls:ctor(ctl, stickNode, movingNode, flyNode)
    self.ctl = ctl
    self.stickNode = stickNode
    self.movingNode = movingNode
    self.flyNode = flyNode
end

------------ normal free fall wild start--------------------
function cls:playWildFall(count, wildType)
    local endList = {
        { 2, 6 }, { 4, 5 }, { 3, 9 },
        { 2, 1 }, { 3, 7 }, { 4, 3 },
        { 2, 7 }, { 3, 1 }, { 4, 6 },
        { 2, 3 }, { 3, 4 }, { 4, 3 },
        { 2, 5 }, { 3, 7 }, { 4, 7 },
        { 2, 6 }, { 3, 5 }, { 4, 9 },
        { 2, 1 }, { 3, 7 }, { 4, 3 },
    }
    local actionList = {}
    local index = 0
    while index < count do

        local random = 1
        index = index + random
        if index > count then
            index = count
        end
        local startIndex = index - random + 1
        local a1 = cc.DelayTime:create(0.1)
        local a2 = cc.CallFunc:create(
                function()
                    local info = endList[startIndex]
                    self:playWildFallAction(info, wildType)
                end
        )
        table.insert(actionList, a1)
        table.insert(actionList, a2)
    end
    local a3 = cc.DelayTime:create(0.5)
    local a4 = cc.CallFunc:create(function()
        self.ctl:fallFinish()
    end)
    table.insert(actionList, a3)
    table.insert(actionList, a4)
    self.flyNode:runAction(cc.Sequence:create(unpack(actionList)))
end
function cls:playWildFallAction(info, wildType)
    local endPos = self.ctl:getCellPos(info[1], info[2])
    local data = {}
    self.ctl:playMusicByName("wild_fill")
    data.parent = self.flyNode
    data.pos = endPos
    if wildType == 1 then
        data.file = self.ctl:getSpineFile("free_wild_fall")
    else
        data.file = self.ctl:getSpineFile("free_wild_fall2")
    end
    local _, s = bole.addAnimationSimple(data)
end

------------ normal free fall wild end--------------------

------------ map free wild start--------------------------

function cls:clearMapFreeNode()
    self.stickWildNodeList = nil
    self.noUseWildSpine = nil
    self.moveWildSpine = nil

end
------------ Moving start
function cls:playMoveWildAppear()
    if not self.ctl.exWildFinalPos then
        return
    end
    local specialSymbol = self.ctl:getGameConfig().special_symbol
    self.noUseWildSpine = self.movingNode:getChildren() -- self.noUseWildSpine or
    self.moveWildSpine = {}
    self.mapData = self.mapData or {}
    local animName = "animation4"
    self.moveWildSpine = self.moveWildSpine or {}
    local spineName = specialSymbol.wild
    for k, posData in pairs(self.ctl.exWildFinalPos) do
        local temp
        local pos = self.ctl:getCellPos(posData[1], posData[2])
        if #self.noUseWildSpine == 0 or not bole.isValidNode(self.noUseWildSpine[1]) then
            local file = self.ctl:getPic("spine/item/" .. specialSymbol.goldWild .. "/spine")
            local _, s = bole.addSpineAnimation(self.movingNode, 100, file, pos, animName, nil, nil, nil, true)
            self.moveWildSpine = self.moveWildSpine or {}
            table.insert(self.moveWildSpine, s)
            s.posData = tool.tableClone(posData)
            temp = s
        else
            temp = table.remove(self.noUseWildSpine, 1)
            self.moveWildSpine = self.moveWildSpine or {}
            table.insert(self.moveWildSpine, temp)
            temp:setVisible(true)
            temp:setPosition(pos)
            temp:setAnimation(0, animName, false) -- 显示可移动状态
            temp.posData = tool.tableClone(posData)
        end
        temp:addAnimation(0, "animation1", true)
    end
end
function cls:moveNextPos()
    local moveWildTime = 15 / 30
    self.moveWildSpine = self.moveWildSpine or {}
    for k, temp in pairs(self.moveWildSpine) do
        local endPos = self.ctl.curWildMoveEndPos[k]
        local pos2 = self.ctl:getCellPos(endPos[1], endPos[2])
        libUI.runAction(temp, cc.MoveTo:create(moveWildTime, pos2))
    end
end
------------ Moving end
---
------------ stick wild start
function cls:playStickWildAppear()
    self.stickWildNodeList = self.stickWildNodeList or {}
    if self.ctl.wildStickList and #self.ctl.wildStickList > 0 then
        if self.ctl.wildStickList and #self.ctl.wildStickList > 0 then
            for key, item in ipairs(self.ctl.wildStickList) do
                local realCol = item[1]
                local row = item[2]
                self.stickWildNodeList[realCol] = self.stickWildNodeList[realCol] or {}
                if not self.stickWildNodeList[realCol][row] then
                    local pos = self.ctl:getCellPos(realCol, row)
                    local data = {}
                    data.file = self.ctl:getPic("spine/item/15/spine")
                    data.parent = self.stickNode
                    data.pos = pos
                    data.isRetain = true
                    data.animateName = "animation4"

                    local _, s = bole.addAnimationSimple(data)
                    s:addAnimation(0, "animation1", true)
                    self.stickWildNodeList[realCol][row] = s
                else
                    local node = self.stickWildNodeList[realCol][row]

                    node:setVisible(true)
                    node:setAnimation(0, "animation4", false)
                    node:addAnimation(0, "animation1", true)
                end
            end
        end
    end
end
function cls:hideMapFreeWild(col, row)

    if self.stickWildNodeList and self.stickWildNodeList[col] and self.stickWildNodeList[col][row] then
        if self.stickWildNodeList[col][row] then
            self.stickWildNodeList[col][row]:setVisible(false)
        end
    end
    if self.moveWildSpine then
        for k, temp in pairs(self.moveWildSpine) do
            temp:setVisible(false)
        end
    end

end

function cls:showMapFreeWild(col, row)
    if self.stickWildNodeList and self.stickWildNodeList[col] and self.stickWildNodeList[col][row] then

        self.stickWildNodeList[col][row]:setVisible(true)
    end
    if self.moveWildSpin then
        for k, temp in pairs(self.moveWildSpine) do
            temp:setVisible(true)
        end
    end

end

------------  map free  wild end------------------------
return cls

