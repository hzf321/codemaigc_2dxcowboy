--- @program src
--- @description: theme230 collect ctl
--- @author: rwb
--- @create: 2020/12/29 20:46


local parentClass = ThemeBaseViewControlDelegate
local cls = class("ThemeGRII_CollectControl", parentClass)
local view = require (bole.getDesktopFilePath("Theme/ThemeGRII_CollectView")) 
function cls:ctor(mainCtl)
    parentClass.ctor(self, mainCtl)
end
function cls:initLayout(parentNode, flyNode)

    self.collectView = view.new(self, parentNode, flyNode)
    self.collectView:initCollectRoot()
end
function cls:getIsLockFeature()
    return self.isLockFeature
end
function cls:getTipBetList()
    return self._mainViewCtl.tipBetList
end

---@desc click map btn
function cls:clickUnLockBtn()
    if not self._mainViewCtl:getCanTouchFeature() then
        return
    end
    if self.isLockFeature then
        local unLockBetList = self:getGameConfig().unlockBetList
        self._mainViewCtl:featureUnlockBtnClickEvent(unLockBetList["Collect"])
    else
        self.collectView:changeStoreTipState()
    end


end
--@collect unlock
function cls:clickMapBtn()
    if not self._mainViewCtl:getCanTouchFeature() then
        return
    end
    if self.isLockFeature then
        self:clickUnLockBtn()
    end
    self:playMusicByName("common_click")
    self._mainViewCtl:showMapScene()
end
--@changeBet
function cls:changeCollectBet(theBet)
    local tipBetList = self:getTipBetList()
    local unLockBetList = self.gameConfig.unlockBetList
    local tipBet = tipBetList[unLockBetList.Collect]
    if self.isLockFeature == nil then
        self.isLockFeature = false
    end
    local isLock = theBet < tipBet
    if self.isLockFeature ~= isLock then
        self.isLockFeature = isLock
        self.collectView:setCollectPartState(isLock, true)
    end

end
function cls:changeStoreTipState(...)
    self.collectView:changeStoreTipState(...)
end
function cls:checkCollectBtnCanTouch(...)
    return self._mainViewCtl:getCanTouchFeature()
end
function cls:setCollectPartState(isLock, isAnimate)
    self.collectView:setCollectPartState(isLock, isAnimate)
end
function cls:getCollectConfig()
    return self:getGameConfig().collect_config
end
function cls:getCollectMaxPoint()
    return self:getCollectConfig().max_point
end
function cls:getCollectMaxLevel()
    return self:getCollectConfig().max_level
end
function cls:updateCollectCount(newCount, beforeCount, isAnimate)
    self.featurePoints = newCount
    self.collectView:updateCollectCount(newCount, beforeCount, isAnimate)
end
function cls:getMapPoint()
    return self.featurePoints or 0
end
function cls:dealFlyCollectItem(specialData)
    if self.isLockFeature then
        return
    end
    local old_map_point = self.featurePoints
    local collectID = self:getCollectConfig().collect_id
    local _flyClawList = self:_getFlyItemList(specialData.item_list, collectID)
    if #_flyClawList <= 0 then
        return
    end
    self.featurePoints = specialData.theme_info.map_info.collect_count
    local max_point = self:getCollectMaxPoint()
    if self.featurePoints > max_point then
        self.featurePoints = max_point
    end
    self:playMusicByName("collect_fly")
    self.collectView:flyItemActions(_flyClawList)
    self.node:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(18 / 30),
                    cc.CallFunc:create(function()
                        self:updateCollectCount(self.featurePoints, old_map_point, true)
                    end)
            )
    )
end
function cls:_getFlyItemList(cItemList, collectID)
    local _flyClawList = {}
    for col = 1, 5 do
        for row = 1, 4 do
            local storeCoinCount = cItemList[col][row]
            if storeCoinCount % 100 == collectID then
                local pos = self:getCellPos(col, row)
                table.insert(_flyClawList, { col, row, pos })
            end
        end
    end
    return _flyClawList
end

return cls


