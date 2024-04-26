---
--- @program src
--- @description:230 wheel
--- @author: rwb
--- @create: 2020/12/29 20:46
---
local parentClass = ThemeBaseViewControlDelegate
local wheelView = require (bole.getDesktopFilePath("Theme/ThemeGRII_WheelView"))  
local cls = class("ThemeGRII_WheelControl", parentClass)
function cls:ctor(bonus, data)
    self.bonus = bonus
    self.data = data
    self.bonusControl = bonus.bonusControl
    self.themeCtl = bonus.themeCtl
    self.parentNode = self.themeCtl:getMapParentNode()
    self.myBonusData = self.data.core_data.wheel_info
    parentClass.ctor(self, bonus.themeCtl)
end
function cls:saveBonus()
    self.bonus:saveBonus()
end
function cls:getWheelSpinFinish()
    return self.data.wheel_spin_finish
end
function cls:setWheelSpinFinish(status)
    self.data.wheel_spin_finish = status
end
function cls:getWheelTouchSpin()
    return self.data.wheel_touched
end
function cls:setWheelTouchSpin(status)
    self.data.wheel_touched = status
end

function cls:getWheelStartBtn()
    return self.data.wheel_start
end
function cls:setWheelStartBtn(status)
    self.data.wheel_start = status
end
function cls:getWheelConfig()
    return self.themeCtl:getGameConfig().wheel_config
end
function cls:getBigWheelIndex()
    return self.myBonusData.wheel_index
end
function cls:getSmallWheelIndex()
    return self.myBonusData.wheel_multi_index
end
function cls:getWheelChoose()
    return self.myBonusData.wheel_set
end
function cls:getCurTotalBet()
    return self.themeCtl:getCurTotalBet()
end

function cls:resetWheelInfo()
    self:setWheelTouchSpin(false)
    self:setWheelSpinFinish(nil)
end
function cls:setWheelInfo(data)
    self.data = data
end
function cls:checkWinGrand()
    local winindex = self:getBigWheelIndex()
    if winindex == 1 then
        return true
    end
    return false
end
function cls:checkWinFree()
    local winindex = self:getBigWheelIndex()
    if winindex == 3 or winindex == 7 or winindex == 11 then
        return true
    end
    return false
end
function cls:checkWinJackpot()
    local winindex = self:getBigWheelIndex()
    if winindex == 5 or winindex == 9 or winindex == 1 then
        return true
    end
    return false
end
function cls:checkHaveMiniWin()
    local winindex = self:getBigWheelIndex()
    if winindex == 1 or winindex == 3 or winindex == 7 or winindex == 11 then
        return false
    end
    return true
end

function cls:showWheelStartDialog()

    local trans_type = "wheel_1"
    local cover = function()
        self.themeCtl:setMaskNodeStatus(1, false, false)
        self:enterBonusGame()
    end
    self.themeCtl:setMaskNodeStatus(1, true, true)
    self:playTransition(nil, trans_type, true, cover)
end
function cls:showWheelScreen()
    self.wheelView = wheelView.new(self, self.parentNode, self.myBonusData)
    self.wheelView:showWheelScreen(self:getWheelTouchSpin())
end
function cls:destroyWheelScreen()
    self.wheelView:closeWheelScene()
    self.wheelView = nil
    self:resetWheelInfo()
    self.wheelView = nil
end
function cls:getWheelConfig()
    return self:getGameConfig().wheel_config
end

function cls:spinWheelFinish(status)
    self:setWheelSpinFinish(status)
    self:saveBonus()
    local wheel_config = self:getWheelConfig()
    local big_win_type = wheel_config.big_wheel[self:getWheelChoose()][self:getBigWheelIndex()]
    local mini_win_type = wheel_config.mini_multi[self:getWheelChoose()][self:getSmallWheelIndex()]
    if status == 2 then
        if big_win_type < 100 then
            self:showWinMoneyDialog(big_win_type, mini_win_type)
        elseif big_win_type < 1000 then
            self:showFreeStartDialog()
        else
            self:showJackpotDialog(mini_win_type)
        end
    end
end
function cls:checkWinBigMoney()
    local win = 0
    local multi = 0
    if self:getJpWinType() > 0 then
        win = self.myBonusData.win_jp_temp.jp_win
    else
        win = self:getWinMoney()
    end
    if win > 0 then
        multi = win / self.themeCtl:getCurTotalBet()
    end
    return multi >= 10
end
function cls:getWinMoney()
    return self.myBonusData.base_win
end
function cls:showWinMoneyDialog(big_win_type, mini_win_type)
    local dialog_music = "wheel_dialog_collect_show"
    self:playMusicByName(dialog_music)
    local data = {}
    data.click_event = function()
        self:stopMusicByName(dialog_music)
        self.themeCtl:collectCoins(1)

        self:exitWheelGame("money")
    end
    data.coins = self:getWinMoney() / mini_win_type
    data.total_coins = self.myBonusData.base_win
    data.multi = mini_win_type
    local dialog = self.themeCtl:showThemeDialog(data, 3, self:getGameConfig().dialog_type.wheel)

    --defauly pos 313,157
    local label_multi = dialog.collectRoot:getChildByName("label_multi")
    if mini_win_type > 0 then
        self:playMultiNodeFly(dialog, label_multi, mini_win_type, data)
    else
        label_multi:setVisible(false)
    end
end
function cls:playMultiNodeFly(dialog, label_multi, mini_win_type, data)
    if mini_win_type > 0 then
        label_multi:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(2),
                        cc.CallFunc:create(function()
                            self:playMusicByName("wheel_multiply")
                        end),
                        cc.JumpTo:create(0.5, cc.p(0, 41), 200, 1),
                        cc.CallFunc:create(
                                function()
                                    self:jumpBoom(dialog.collectRoot, cc.p(0, 41))
                                end
                        ),
                        cc.ScaleTo:create(0.2, 0),
                        cc.CallFunc:create(
                                function()
                                    dialog:rollCoinsAgain(data.coins, data.total_coins)
                                end)
                )
        )
        local multi = label_multi:getChildByName("multi")
        local multiLabel = multi:getChildByName("num")
        multiLabel:setString("" .. mini_win_type)
    else
        label_multi:setVisible(false)
    end
end
function cls:checkWinJp()
    local win_jp = false
    if self.bonus.data.core_data.jp_win and #self.bonus.data.core_data.jp_win > 0 then
        win_jp = true
    end
    return win_jp
end
function cls:getJpWinType()
    local jp_type = 0
    if self.myBonusData.win_jp_temp then
        jp_type = self.myBonusData.win_jp_temp.jp_win_type + 1
    end
    return jp_type
end
function cls:addWinJpAni()
    local jp_type = self:getJpWinType()
    if self:checkWinJp() and jp_type > 0 then
        self.themeCtl:getJpViewCtl():addWinJpAni(jp_type)
    end
end
function cls:showJackpotDialog(mini_win_type)

    local data = {}
    local dialogType = self:getGameConfig().dialog_type.wheel
    local jp_type = self:getJpWinType()
    local dialog_music
    if self:checkWinJp() then
        dialogType = self:getGameConfig().dialog_type.jp
        dialog_music = "dialog_collect_show_" .. jp_type
    else
        dialog_music = "wheel_dialog_collect_show"
    end

    data.coins = self.bonus:getNormalJpWin(jp_type)
    data.total_coins = self.myBonusData.win_jp_temp.jp_win
    data.bg = jp_type
    data.multi = mini_win_type
    self:playMusicByName(dialog_music)
    data.click_event = function()
        self.themeCtl:collectCoins(1)
        self:stopMusicByName(dialog_music)
        self:removeBaseJpWinAni(jp_type)

        self:exitWheelGame("jp")
    end
    local collect = self:getGameConfig().fs_show_type.collect
    local dialog = self.themeCtl:showThemeDialog(data, collect, dialogType)
    local label_multi = dialog.collectRoot:getChildByName("label_multi")
    if jp_type > 1 and mini_win_type > 1 then
        self:playMultiNodeFly(dialog, label_multi, mini_win_type, data)
    else
        label_multi:setVisible(false)
    end
end
function cls:jumpBoom(parent, endPos)
    local data = {}
    data.file = self.themeCtl:getSpineFile("dialog_jump")
    data.parent = parent
    data.pos = endPos
    data.zOrder = 10
    bole.addAnimationSimple(data)
end
function cls:removeBaseJpWinAni(jp_type)
    self.themeCtl:getJpViewCtl():removeJpAni(jp_type)
end
function cls:showFreeStartDialog()
    local data = {}
    data.bg = 3 - self.themeCtl:getFreeCtl():getFreeType()
    self:playMusicByName("free_dialog_start_show")
    data.click_event = function()
        self:stopMusicByName("free_dialog_start_show")
        self.themeCtl:collectCoins(1)
        self:exitWheelGame("free")
    end
    local dialogType = self:getGameConfig().dialog_type.free
    self.themeCtl:showThemeDialog(data, 1, dialogType)
end
function cls:startSpin()
    self:setWheelTouchSpin(true)
    --self.themeCtl:playFadeToMinVlomeMusic(0.8)
end
function cls:exitWheelGame(exit_type)

    local trans_type = "wheel"
    if exit_type == "free" then
        trans_type = "free"
    end
    local transitionDelay = self:getGameConfig().transition_config[trans_type]
    self.node:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(1.5),
                    cc.CallFunc:create(function()
                        self:playTransition(nil, trans_type, true)
                    end),
                    cc.DelayTime:create(transitionDelay.onCover),
                    cc.CallFunc:create(function(...)
                        self:destroyWheelScreen()
                        self.themeCtl:changeSpinBoard(1)
                        self.bonus:recoverBaseGame(exit_type)
                        self.bonus:finishWheelBonus()
                        if exit_type == "free" then
                            self.bonus:finishBonusGame(exit_type)
                        end
                    end),
                    cc.DelayTime:create(transitionDelay.onEnd - transitionDelay.onCover),
                    cc.CallFunc:create(function(...)
                        if exit_type ~= "free" then
                            self.bonus:finishBonusGame(exit_type)
                        end
                    end)
            )
    )


end

function cls:getSuperBet()
    local mapInfo = self.myBonusData.avg_bet
    return mapInfo
end
function cls:rollEndcallFunc()
    self:setWheelSpinFinish()
    self:saveBonus()
    --self:showReelWheelCollect()
end
function cls:enterBonusGame(tryResume)
    self.themeCtl:changeSpinBoard(5)
    if tryResume then
        self:showWheelScreen()
        if self:getWheelSpinFinish() then
            self.wheelView:setFinishUI()
            self:spinWheelFinish(2)
            self:addWinJpAni()
        elseif self:getWheelTouchSpin() then
            self:dealMusic_PlayWheelLoopMusic()
            self.wheelView:setStartRoll()
        else
            self:dealMusic_PlayWheelLoopMusic()
        end
    else
        self:showWheelScreen()
        self:wheelLaterCallback(0.5, function()
            self:dealMusic_PlayWheelLoopMusic()
        end
        )
    end
end
function cls:wheelLaterCallback(...)
    self.wheelView:wheelLaterCallback(...)
end
function cls:dealMusic_FadeLoopMusic(...)
    self.themeCtl:dealMusic_FadeLoopMusic(...)
end
function cls:playTransition(...)
    self.themeCtl:playTransition(...)

end
function cls:changeWheelBtnStatus()
    self.wheelView:changeWheelBtnStatus()
end
function cls:dealMusic_PlayWheelLoopMusic()
    AudioControl:stopGroupAudio("music")
    self.themeCtl:playBgmByName("wheel_background")
    self.themeCtl:dealMusic_FadeLoopMusic(0.5, 1, 0.5)
end
return cls


