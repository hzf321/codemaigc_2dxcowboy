---
--- @program src
--- @description:220 wheel
--- @author: rwb
--- @create: 2020/11/23 15:39
---
local parentClass = ThemeBaseViewControlDelegate
local wheelView = require (bole.getDesktopFilePath("Theme/ThemeApollo_WheelView")) 
 
local cls = class("ThemeApollo_WheelControl", parentClass)
function cls:ctor(bonus, data)
    self.bonus = bonus
    self.data = data
    self.bonusControl = bonus.bonusControl
    self.themeCtl = bonus.themeCtl

    self.parentNode = self.themeCtl:getMapParentNode()
    self.myBonusData = self.data.core_data.map_wheel_spin
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
function cls:getWheelIndex()
    return self.myBonusData.index
end

function cls:resetWheelInfo()
    self:setWheelTouchSpin(false)
    self:setWheelSpinFinish(false)
end
function cls:setWheelInfo(data)
    self.data = data
end
function cls:clickWheelBtn()

end
function cls:getMapLevel()
    local level = self.themeCtl:getMapLevel()
    return level
end
function cls:getNodeType()

    local level = self:getMapLevel()
    local map_config = self:getGameConfig().map_config
    local node_type = map_config.all_node_type[level]
    return node_type
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

function cls:spinWheelFinish()
    self:setWheelSpinFinish(true)
    self:saveBonus()
    local dialog_music = "wheel_dialog_collect"
    self:playMusicByName(dialog_music)
    local list = self.myBonusData.wheel[self:getWheelIndex()]
    local data = {}
    local openType = self:getGameConfig().fs_show_type.start
    if list < 100 then
        openType = self:getGameConfig().fs_show_type.collect
        data.coins = self.myBonusData.total_win
    else
    end
    data.click_event = function()
        self:stopMusicByName(dialog_music)
        self.themeCtl:collectCoins(1)
        self:exitWheelGame()
    end
    self.themeCtl:showThemeDialog(data, openType, self:getGameConfig().dialog_type.wheel)

end
function cls:exitWheelGame()
    local firstDelay = 0
    if self.myBonusData.extra_fg > 0 then
        firstDelay = firstDelay + 2
    end
    self.node:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(2),
                    cc.CallFunc:create(function()
                        self:destroyWheelScreen()
                    end),
                    cc.DelayTime:create(1),
                    cc.CallFunc:create(function()
                        if self.myBonusData.extra_fg > 0 then
                            self.themeCtl:getMapViewCtl():addExtraFgByBonus()
                        end
                        self.bonus:recoverBaseGame("wheel")
                    end),
                    cc.DelayTime:create(firstDelay),
                    cc.CallFunc:create(function()
                        self.themeCtl:getMapViewCtl():exitMapScene(true)
                    end),
                    cc.DelayTime:create(0.5),
                    cc.CallFunc:create(function()
                        --self.reelWheelCtl = nil
                        self.bonus:finishWheelBonus()
                        self.bonus:finishBonusGame("wheel")
                    end)
            --cc.RemoveSelf:create()
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
    self.themeCtl:changeBetByBonus(true)
    if tryResume then
        self.themeCtl:showMapSceneByBonus(false)
        self.themeCtl:changeBetByBonus(true)
        self:showWheelScreen()
        if self:getWheelSpinFinish() then
            self.wheelView:setFinishUI()
            --self:rollEndcallFunc()
            self:spinWheelFinish()
        elseif self:getWheelTouchSpin() then
            self.wheelView:setStartRoll()
        else
            --self.wheelView:showStartSpinBtn()
        end
    else
        self.themeCtl:showMapSceneByBonus(true)
        self.node:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(1),
                        cc.CallFunc:create(
                                function()
                                    self.themeCtl:getMapViewCtl():mapForward()
                                end),
                        cc.DelayTime:create(20 / 30),
                        cc.CallFunc:create(function()
                            self.themeCtl:getMapViewCtl():mapItemLighten()

                        end),
                        cc.DelayTime:create(1),
                        cc.CallFunc:create(function()
                            self:showWheelScreen()
                        end)
                )
        )

        --self.reelView:showStartSpinBtn()
    end
end
function cls:playTransition(...)
    self.themeCtl:playTransition(...)

end
return cls


