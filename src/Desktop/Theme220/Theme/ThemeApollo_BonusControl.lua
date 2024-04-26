---@program src
---@description:  theme220
---@author: rwb
---@create: : 2020-11-23 21:13:16

local reelWheelCtl = require (bole.getDesktopFilePath("Theme/ThemeApollo_ReelWheelControl")) 
local wheelCtl = require (bole.getDesktopFilePath("Theme/ThemeApollo_WheelControl")) 
local parentClass = ThemeBaseViewControlDelegate
local bonusCtl = class("ThemeApollo_BonusControl", parentClass) -- ThemeBaseBonusControl
local cls = bonusCtl
-- 几种类型的bonus
function cls:ctor(bonusControl, theme, csbPath, data, callback)
    self.bonusControl = bonusControl
    self.csbPath = csbPath
    self.callback = callback
    self.oldCallBack = callback
    self.data = data

    self.themeCtl = theme
    self.themeCtl.bonus = self
    self.mainView = self.themeCtl.mainView
    self.gameConfig = self.themeCtl:getGameConfig()
    parentClass.ctor(self, self.themeCtl)
end

function cls:addData(key, value)
    self.data[key] = value
    self:saveBonus()
end
function cls:saveBonus()
    LoginControl:getInstance():saveBonus(self.themeCtl.themeid, self.data)
end
function cls:enterBonusStart(...)
    self.themeCtl:setFooterBtnsEnable(false)
    self.themeCtl:enableMapInfoBtn(false)
    self.themeCtl:stopDrawAnimate()
    self.themeCtl:hideActivitysNode()
    self.bonusItem = self.themeCtl.item_list or self.data.core_data.item_list
end
--function cls:exitBonusStepI(...)
--    if self.bonusItem then
--        self.themeCtl:resetBoardCellsByItemList(self.bonusItem)
--    end
--    self.themeCtl.bonus = nil
--    self.themeCtl:lockJackpotMeters(false)
--    self.themeCtl:setFooterBtnsEnable(true)
--    self.themeCtl:enableMapInfoBtn(true)
--    self.themeCtl:showActivitysNode()
--    self.themeCtl:finshSpin()
--end
function cls:resetProgressiveList()
    self.progressive_list = self.data.core_data["progressive_list"] or { 0, 0, 0, 0 }
    self.themeCtl:getJpViewCtl():resetProgressiveList(self.progressive_list)
    --local link_config = self.themeCtl:getThemeJackpotConfig().link_config
    --local jpLabels = self.theme.jackpotLabels
    --if self.progressive_list then
    --    for i = 1, #self.progressive_list do
    --        if jpLabels[i] then
    --            local jackpotNum = self.themeCtl:getJackpotNum(link_config[i])
    --            if self.progressive_list then
    --                jackpotNum = jackpotNum + self.progressive_list[i]
    --            end
    --            jpLabels[i]:setString(self.themeCtl:formatJackpotMeter(jackpotNum))
    --            bole.shrinkLabel(jpLabels[i], jpLabels[i].maxWidth, jpLabels[i].baseScale)
    --        end
    --    end
    --end
end
function cls:enterBonusGame(tryResume)
    self:enterBonusStart()
    self.themeCtl:lockJackpotMeters(true)
    -- self.themeCtl:setFeatureState(self.gameConfig.FeatureName.Bonus, true)
    -- self.themeCtl:setSpinButtonState(true)
    self.themeCtl:saveBonusData(self.data.core_data)
    if tryResume then
        self.callback = function(...)
            if self.themeCtl:noFeatureLeft() then
                self.themeCtl:setFooterBtnsEnable(false)
            end
            if self.oldCallBack then
                self.oldCallBack()
            end
            self.themeCtl.isProcessing = false
        end
        self.themeCtl.isProcessing = true
    end
    self.themeCtl:stopAllLoopMusic()
    self:enterBonusGame2(tryResume)
end

---@desc bonus respin func ---------------------------------------------------------------------
function cls:enterBonusGame2(tryResume)
    if self.data.core_data.jp_wheel then
        self:enterJpWheelBonus(tryResume)
    elseif self.data.core_data.map_wheel_spin then
        self:enterWheelBonus(tryResume)
    end
end

---------------------- jp wheel start----------------------
function cls:enterJpWheelBonus(tryResume)
    self.jpWheelBonusInfo = self.data
    self.reelWheelCtl = reelWheelCtl.new(self, self.data)
    self.reelWheelCtl:enterBonusGame(tryResume)
end
function cls:finishJpWheelBonus()
    self.reelWheelCtl = nil
end

---------------------- jp wheel end----------------------

---------------------- wheel start----------------------
function cls:enterWheelBonus(tryResume)


    self.wheelCtl = wheelCtl.new(self, self.data)
    self.wheelCtl:enterBonusGame(tryResume)
end
function cls:finishWheelBonus()
    --self.tryResume = nil
    self.wheelCtl = nil
end
function cls:checkIsSuper()
    if self.data.core_data.map_wheel_spin then
        return true
    end
    return false
end
---------------------- wheel end  ---------------------
function cls:recoverBaseGame(from)
    self.themeCtl:showAllItem()
    self.themeCtl:lockJackpotMeters(false)
    self.themeCtl.spinning = false
    self.themeCtl.footer.isRespinLayer = false
    self.themeCtl:changeBetByBonus(false)
    local SpinBoardType = self.themeCtl:getGameConfig().SpinBoardType
    if self.themeCtl:isInFG() then
        self.themeCtl:hideBonusNode(true, false)
        self.themeCtl:stopDrawAnimate()

        self.themeCtl:changeSpinBoard(SpinBoardType.FreeSpin)
        self.themeCtl:getFreeVCtl():adjustWithFreeSpin()
        self.themeCtl.footer:changeLabelDescription("FS_Win")
        self.themeCtl.footer.isFreeSpin = true
    else
        self.themeCtl.footer:changeNormalLayout2()
        self.themeCtl:changeSpinBoard(SpinBoardType.Normal)
        self.themeCtl:hideBonusNode(false, false)
        self.themeCtl.footer.isFreeSpin = false
        self.themeCtl.superAvgBet = nil
        self.themeCtl:removePointBet()
        self.themeCtl.footer:changeLabelDescription("notFS_Win")
    end
    self.themeCtl:outBonusStage()
    self.themeCtl:lockJackpotMeters(false)
    if from == "wheel" then
        self.themeCtl:resetMapProgress()
    end
    self.themeCtl:playBonusAnimate(self.data.core_data, true)

    --self.theme.flyNode:removeAllChildren()

    --self.theme.lockedReels = nil
end
function cls:finishBonusGame(from)
    self.themeCtl.bonus = nil
    if not self.themeCtl:noFeatureLeft() then
        self.themeCtl:setFooterBtnsEnable(false)
    else
        self.themeCtl:setFooterBtnsEnable(true)
    end
    local bonusOver2 = function()
        self.themeCtl:dealMusic_ExitBonusGame()
        if self.callback then
            self.callback()
        end
        if self.themeCtl:noFeatureLeft() then
            self.themeCtl:enableMapInfoBtn(true)
            self.themeCtl:setFooterBtnsEnable(true)
        end
        self.themeCtl:collectBonusRollEnd()
        self.themeCtl:dealMusic_ExitBonusGame()
    end
    self.themeCtl:showActivitysNode()
    if self.themeCtl:noFeatureLeft() then
        self.themeCtl.superAvgBet = nil
        self.themeCtl:removePointBet()
    else
        self.themeCtl.remainPointBet = true
    end
    local totoalWin = 0
    totoalWin = self:getFinalTotalWin(from)
    if self.themeCtl.freespin then
        if self.themeCtl.freespin < 1 then
            self.themeCtl.spin_processing = true
        end
    end
    self.themeCtl:startRollup(totoalWin, bonusOver2)
end
function cls:getFinalTotalWin(from)
    local coins = 0
    if from == "reel" then
        local data = self.data.core_data.jp_wheel
        coins = data.total_win
        if #data.jp_win_list > 0 then
            coins = data.jp_win_list[1].jp_win
        end
    elseif from == "wheel" then
        local data = self.data.core_data.map_wheel_spin
        coins = data.total_win
    end
    return coins
end
function cls:onExit(...)

    if self.reelWheelCtl then
        self.reelWheelCtl:onExit()
    end
end

return cls