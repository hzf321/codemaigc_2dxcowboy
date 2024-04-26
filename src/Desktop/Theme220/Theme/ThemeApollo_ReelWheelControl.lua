--- @program src
--- @description: theme220 reelgame
--- @author: rwb
--- @create: 2020/11/23 16:00
local parentClass = ThemeBaseViewControlDelegate
local cls = class("ThemeApollo_ReelWheelControl", parentClass)
local view = require (bole.getDesktopFilePath("Theme/ThemeApollo_ReelWheelView")) 
 
function cls:ctor(bonus, data)

    parentClass.ctor(self, bonus.themeCtl)
    self.bonus = bonus
    self.data = data
    self.themeCtl = bonus.themeCtl
    self.bonusControl = bonus.bonusControl
    self.myBonusData = self.data.core_data.jp_wheel
end
function cls:addData(key, value)
    self.data[key] = value
    self:saveBonus()
end
function cls:saveBonus()
    self.bonus:saveBonus()
end
function cls:setClickStartBtn()
    self.data.reel_wheel_start = 1
    self:saveBonus()
end
function cls:setRollFinish()
    self.data.reel_wheel_finish = 1
end
function cls:isClickStart()
    return self.data.reel_wheel_start
end
function cls:isRollFinish()
    return self.data.reel_wheel_finish
end
function cls:enterBonusGame(tryResume)
    --self:dealWithReelData()
    --self:initLayout()
    if tryResume then

        self:showReelWheelScreen(false)
        if self:isRollFinish() then
            self.reelView:setFinishUI()
            self.reelView:rollEndCallFunc()
            --self:showReelWheelCollect()
            --self:addWinJpAni()
        elseif self:isClickStart() then
            self:laterCallBack(2, function(...)
                self.reelView:setStartRoll()
            end)
        else
            self:showStartSpinBtn()
        end
    else
        self:showJpWheelStart()
    end
end
function cls:showJpWheelStart()
    local data = {}
    local dialog_music = "jackpot_dialog_start"
    self:playMusicByName(dialog_music)
    local gameConfig = self:getGameConfig()
    data.click_event = function()
        self:stopMusicByName(dialog_music)
        local transitionDelay = gameConfig.transition_config.bonus
        self.node:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(1),
                        cc.CallFunc:create(
                                function()
                                    self:playTransition(nil, "bonus")
                                end),
                        cc.DelayTime:create(transitionDelay.onCover),
                        cc.CallFunc:create(function()
                            self:showReelWheelScreen(true)
                        end),
                        cc.DelayTime:create(transitionDelay.onEnd - transitionDelay.onCover - 0.5),
                        cc.CallFunc:create(function()
                            self:showStartSpinBtn(true)
                        end)
                )
        )
    end

    self.themeCtl:showThemeDialog(data, gameConfig.fs_show_type.more, gameConfig.dialog_type.reel)

end
function cls:showStartSpinBtn()
    local data = {}
    data.click_event = function()
        self:playMusicByName("jp_wheel_click")
        self.node:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(0.8),
                        cc.CallFunc:create(function()
                            self:setClickStartBtn()
                            self:saveBonus()
                            self.reelView:setStartRoll()
                        end)
                )
        )
    end
    local gameConfig = self:getGameConfig()
    local dialog = self.themeCtl:showThemeDialog(data, gameConfig.fs_show_type.start, gameConfig.dialog_type.reel)
    bole.adaptReelBoard(dialog)
end
function cls:showReelWheelScreen()
    local SpinBoardType = self:getGameConfig().SpinBoardType
    self.themeCtl:changeSpinBoard(SpinBoardType.JpWheel)
    local parent = self._mainViewCtl:getJpWheelParent()
    self.reelView = view.new(self, parent)

    self.bonus:resetProgressiveList()
end
function cls:destroyReelWheelScreen()
    self.reelView:removeFromParent()
    self.reelView = nil
end
function cls:dealWithReelData(...)
    self.wheelIndex = self.myBonusData.wheel_index
end
function cls:getJpWheelConfig(...)
    return self:getGameConfig().reel_wheel_config
end

function cls:addBaseJpWinAni()
    local config = self:getJpWheelConfig()
    local list = config.bonus_wheel[self:getWheelIndex()]
    if list >= 100 then
        local index = (list + 1) % 100
        self.themeCtl:getJpViewCtl():addWinJpAni(index)
    end
end
function cls:removeBaseJpWinAni()
    local config = self:getJpWheelConfig()
    local list = config.bonus_wheel[self:getWheelIndex()]
    if list >= 100 then
        local index = (list + 1) % 100
        self.themeCtl:getJpViewCtl():removeJpAni(index)
    end
end

function cls:showReelWheelCollect()
    local config = self:getJpWheelConfig()
    local list = config.bonus_wheel[self:getWheelIndex()]
    local data = {}

    local dialog_name = "jackpot_dialog_collect"
    local dialogType = self:getGameConfig().dialog_type.jp
    if list < 100 then
        data.coins = self.myBonusData.total_win
        dialogType = self:getGameConfig().dialog_type.reel
    else
        if #self.myBonusData.jp_win > 0 then
            data.coins = self.myBonusData.jp_win[1].jp_win
            data.bg = self.myBonusData.jp_win[1].jp_win_type + 1
            self:playMusicByName("jp_dialog_" .. data.bg)
        else
            data.coins = self.myBonusData.jp_win_list[1].jp_win
            dialogType = self:getGameConfig().dialog_type.reel
        end

    end
    self:playMusicByName(dialog_name)
    data.click_event = function()
        self:stopMusicByName(dialog_name)
        self.themeCtl:collectCoins(1)
        self:removeBaseJpWinAni()
        local transitionDelay = self:getGameConfig().transition_config.bonus
        self.node:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(2),
                        cc.CallFunc:create(function()
                            self:playTransition(nil, "bonus")
                        end),
                        cc.DelayTime:create(transitionDelay.onCover),
                        cc.CallFunc:create(function()
                            self:destroyReelWheelScreen()
                            self.bonus:recoverBaseGame("reel")

                        end),
                        cc.DelayTime:create(transitionDelay.onEnd - transitionDelay.onCover),
                        cc.CallFunc:create(function()
                            --self.reelWheelCtl = nil
                            self.bonus:finishJpWheelBonus()
                            self.bonus:finishBonusGame("reel")
                        end)
                )
        )

    end
    self.themeCtl:showThemeDialog(data, self:getGameConfig().fs_show_type.collect, dialogType)

end
function cls:getCurBet()
    if self.data.core_data.bet then
        return self.data.core_data.bet
    end
    local bet = self._mainViewCtl:getCurBet()
    return bet
end
function cls:getWheelIndex()
    return self.myBonusData.result
end
function cls:playTransition(...)
    self.themeCtl:playTransition(...)

end
function cls:onExit()
    if self.reelView then
        self.reelView:onExit()
    end
end

return cls
