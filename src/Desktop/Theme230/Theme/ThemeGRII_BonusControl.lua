---@program src
---@description:  theme230
---@author: rwb
---@create: : 2020/12/29 20:46

local slotMachine = require("Themes/base/component/SlotMachineV/ThemeSlotMachineVControl")
local wheelCtl = require (bole.getDesktopFilePath("Theme/ThemeGRII_WheelControl")) 
local parentClass = ThemeBaseViewControlDelegate
local bonusCtl = class("ThemeGRII_BonusControl", parentClass) -- ThemeBaseBonusControl
local cls = bonusCtl
local bonusType = {
    wheel     = "wheel_info",
    jp        = "jp",
    money     = "money",
    free      = "free",
    map_slots = "map_slots",
    map       = "map",
}
-- 几种类型的bonus
function cls:ctor(bonusControl, theme, csbPath, data, callback)
    self.bonusControl = bonusControl
    --self.csbPath = csbPath
    self.callback = callback
    self.oldCallBack = callback
    self.data = data

    self.themeCtl = theme
    self.themeCtl.bonus = self
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

function cls:resetProgressiveList()
    self.progressive_list = self.data.core_data["progressive_list"] or { 0, 0, 0 }
    self.themeCtl:getJpViewCtl():resetProgressiveList(self.progressive_list)
end
function cls:recoverBaseGame(from)
    self.themeCtl:showAllItem()
    self.themeCtl:lockJackpotMeters(false)
    self.themeCtl.spinning = false
    self.themeCtl.footer.isRespinLayer = false
    self.themeCtl:setFooterStyle(1, false)
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
        if self.themeCtl:noFeatureLeft() then
            self.themeCtl.superAvgBet = nil
            self.themeCtl:removePointBet()
        else
            self.themeCtl.remainPointBet = true
        end
        self.themeCtl.footer:changeLabelDescription("notFS_Win")
    end
    self.themeCtl:outBonusStage()
    self.themeCtl:lockJackpotMeters(false)
    if from == bonusType.map_slots then
        self.themeCtl:resetMapProgress()
    end
    if from == bonusType.jp or from == bonusType.money then
        self.themeCtl:playBonusAnimate(self.data.core_data, true)
    end
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
    if from == "money" then
        coins = self.data.core_data.wheel_info.base_win
    elseif from == "jp" then
        coins = self.data.core_data.wheel_info.win_jp_temp.jp_win
    elseif from == bonusType.map_slots then
        coins = self.data.core_data[bonusType.map_slots].base_win
    end
    return coins
end
function cls:onExit(...)

    if self.WheelCtl then
        self.WheelCtl:onExit()
    end
    if self.slotMachineCtl then
        self.slotMachineCtl:onExit()
    end
end
function cls:enterBonusGame(tryResume)
    self:enterBonusStart()
    self:resetProgressiveList()
    self.themeCtl:lockJackpotMeters(true)
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
    else
        self.data.core_data.jp_win = self.themeCtl.rets.jp_win
        self.data.core_data.item_list = self.themeCtl.rets.item_list
    end
    self.themeCtl:stopAllLoopMusic()
    self:enterBonusGame2(tryResume)
end

---@desc bonus respin func ---------------------------------------------------------------------
function cls:enterBonusGame2(tryResume)
    if self.data.core_data[bonusType.wheel] then
        self:enterWheelBonus(tryResume)
    elseif self.data.core_data[bonusType.map_slots] then
        self:enterSlotMachineBonus(tryResume)
    elseif self.data.core_data[bonusType.map] then
        self:enterMapFreeBonus(tryResume)
    end
end

function cls:getNormalJpWin(jp_type)
    local multi_win = self.themeCtl:getJpViewCtl():getJackpotNum(jp_type)
    local tail = self.progressive_list[jp_type]
    return multi_win + tail
end
---------------------- jp wheel end----------------------

---------------------- wheel start----------------------
function cls:enterWheelBonus(tryResume)
    self.wheelCtl = wheelCtl.new(self, self.data)
    if not tryResume then
        self.wheelCtl:showWheelStartDialog()
    else
        self.wheelCtl:enterBonusGame(tryResume)
    end

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

---------------------- slot_machine start----------------------
function cls:enterSlotMachineBonus(tryResume)
    local delayTm = 0
    if not tryResume then
        delayTm = self.themeCtl:showMapSceneByBonus(true)
    end
    local showSlot = function()
        local bonus_key = bonusType.map_slots
        self.slotMachineCtl = slotMachine.new(self, self.themeCtl, self.data, bonus_key)
        self.slotMachineCtl:enterBonusGame(tryResume)
    end
    local trams = function()
        self.themeCtl:playTransition(nil, "map",true,showSlot)
    end
    if delayTm > 0 then
        self.themeCtl:laterCallBack(delayTm, trams)
    else
        showSlot()
    end
end
function cls:onRespinStart(...)
    if self.slotMachineCtl then
        self.slotMachineCtl:onRespinStart()
    end
end
function cls:onRespinFinish()
    if self.slotMachineCtl then
        self.slotMachineCtl:onRespinFinish()
    end
end
function cls:overSlotMachineScene(totalWin)
    self.themeCtl.isRespin = false
    self.slotMachineCtl = nil
    self:finishBonusGame(bonusType.map_slots)
end
---------------------- slot_machine end----------------------
---------------------- map free bonus start-------------------
function cls:enterMapFreeBonus(tryResume)
    local delayTm = 0
    if not tryResume then
        delayTm = self.themeCtl:showMapSceneByBonus(true)
    end

    local callback = function()
        self:showMapFreeDialog()
    end
    if delayTm > 0 then
        self.themeCtl:laterCallBack(delayTm, callback)
    else
        callback()
    end

end
function cls:showMapFreeDialog()

    local data = {}
    data.click_event = function()
        self.themeCtl:collectCoins(1)
    end
    data.change_layer = function()
        self:recoverBaseGame(bonusType.map)
    end
    data.end_event = function()
        self:finishBonusGame(bonusType.map)
    end

    self.themeCtl:getMapViewCtl():showMapFreeDialog(data)
end
function cls:getSpineTyppe()

end
function cls:changeWheelBtnStatus()
    self.wheelCtl:changeWheelBtnStatus()
end

---------------------- map free bonus end----------------------


return cls