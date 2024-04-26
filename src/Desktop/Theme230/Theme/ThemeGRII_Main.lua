---@program src
---@description:  theme230
---@author: rwb  art:zhouhuipeng,math:lijingyi,other:wujunhao,
---@create: : 2020/12/19 20:15
---
local ThemeBaseDialog = require("Themes/base/ThemeBaseDialog")
local jpCtl = require (bole.getDesktopFilePath("Theme/ThemeGRII_JpControl")) 
local collectCtl = require (bole.getDesktopFilePath("Theme/ThemeGRII_CollectControl"))   
local fgCtl = require (bole.getDesktopFilePath("Theme/ThemeGRII_FreeControl"))   
local themeConfig = require (bole.getDesktopFilePath("Theme/ThemeGRII_Config")) 
local mainView = require (bole.getDesktopFilePath("Theme/ThemeGRII_MainView"))  
local mapCtl = require (bole.getDesktopFilePath("Theme/ThemeGRII_MapControl"))  
local parentClass = ThemeBaseViewControl
local cls = class("ThemeGRII_Main", parentClass)
 
local SpinBoardType = nil
local specialSymbol = nil
local ReSpinStep
local fs_show_type
local freeTypeList
function cls:ctor(themeid, theScene)
    self.gameConfig = themeConfig
    SpinBoardType = themeConfig.SpinBoardType
    specialSymbol = themeConfig.special_symbol
    fs_show_type = themeConfig.fs_show_type
    ReSpinStep = themeConfig.ReSpinStep
    freeTypeList = themeConfig.freeTypeList
    self:initThemeConfig()
    local ret = parentClass.ctor(self, themeid, self.gameConfig.isPortrait, theScene)
    EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_SHOW, "theme230", self.touchShowCActivity, self)
    EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_HIDE, "theme230", self.touchHideCActivity, self)
    return ret
end

function cls:initThemeConfig()

    self:initSlotConfig()
    self.ThemeConfig = tool.tableClone(self.gameConfig.theme_config.reel_symbol)
    self.musicVolumeConfig = self.gameConfig.music_volume
    self.event_callback = {}
end
function cls:overAutoSpeed()
    return true
end
function cls:getSpinColStopAction(themeInfoData, pCol, interval)
    local spinAction = parentClass.getSpinColStopAction(self, themeInfoData, pCol, interval)
    if self.showSpinBoard == SpinBoardType.FreeSpin or self.showSpinBoard == SpinBoardType.SuperFree then
        spinAction.stopDelay = spinAction.stopDelay + self.DelayStopTime2
        spinAction.speedDownTime = spinAction.speedDownTime + 10 / 60
    end
    if self.isTurbo then
        spinAction.speedDownTime = spinAction.speedDownTime - 8 / 60
    end
    return spinAction

end

function cls:touchShowCActivity(...)
    if self and self.mainView and bole.isValidNode(self.mainView.mainThemeScene) then
        self.mainView:downThemeLogo(...)
    end
    self.showHeaderdStatus = 1
end
function cls:touchHideCActivity(...)
    if self and self.mainView and bole.isValidNode(self.mainView.mainThemeScene) then
        self.mainView:upThemeLogo(...)
    end
    self.showHeaderdStatus = 2
end
function cls:getHeaderStatus()
    return self.showHeaderdStatus or 2
end
--function cls:initThemeType(themeType, themeTypeConfig)
--    if isFree then
--        self.lines = self.ThemeConfig["theme_type_config"]["pay_lines_free"]
--        self.maxLine = #self.lines
--    else
--        self.lines = self.ThemeConfig["theme_type_config"]["pay_lines"]
--    end
--    self.maxLine = #self.lines
--    self.themeType = themeType
--    self.themeTypeConfig = themeTypeConfig
--
--end
function cls:resetThemeType(isFree)
    if isFree then
        self.lines = self.ThemeConfig["theme_type_config"]["pay_lines_free"]
    else
        self.lines = self.ThemeConfig["theme_type_config"]["pay_lines"]
    end
    self.maxLine = #self.lines
end

function cls:getSpinColStartActionSpecial(spinAction, pCol, reelCol)

    if self.showSpinBoard == SpinBoardType.SuperFree and self.lockedReels and self.lockedReels[pCol] then
        spinAction.locked = true
    end
end

--@create mainView
function cls:initGameControlAndMainView(...)
    self.mainView = mainView.new(self)
    self.jpViewCtl = jpCtl.new(self)
    self.collectViewCtl = collectCtl.new(self)
    --self.wheelCtl = wheelCtl.new(self)
    self.mapViewCtl = mapCtl.new(self)
    self.freeCtl = fgCtl.new(self)
    parentClass.initGameControlAndMainView(self)
end

---@symbol ani
function cls:drawLinesThemeAnimate(lines, layer, rets, specials)
    local timeList = { 3, 3 }
    self.mainView:drawLinesThemeAnimate(lines, layer, rets, specials, timeList)
end
function cls:configAudioList()
    parentClass.configAudioList(self)
    --self.audio_win_list = nil
    for music_key, music_path in pairs(themeConfig.audioList) do
        self.audio_list[music_key] = music_path
    end
end
function cls:getLoadMusicList()
    local loadMuscList = {}
    table.insert(loadMuscList, self.audio_list.enter_game)
    for music_key, music_path in pairs(self.audio_list) do
        table.insert(loadMuscList, music_path)
    end
    return loadMuscList
end
function cls:enableMapInfoBtn(enable)
    self.isCanFeatureClick = enable
end
function cls:refreshNotEnoughMoney(enable)
    self:enableMapInfoBtn(true)
end
function cls:getCanTouchFeature(...)
    return self.isCanFeatureClick
end
---@param enable /true:可点击/false:不可点
function cls:setFooterBtnsEnable(enable)
    if not enable then
        self.ctl.footer:displayAutoplayInterface(false)
    end
    self.ctl.footer:setSpinButtonState(not enable)
    self.ctl.footer:enableOtherBtns(enable)

end
function cls:getGameConfig(...)
    return self.gameConfig
end
function cls:getMusicVConfig(...)
    return self.musicVolumeConfig
end
function cls:getBoardConfig(...)
    if self.boardConfigList then
        return self.boardConfigList
    end
    local borderConfig = self.ThemeConfig["boardConfig"]
    local newBoardConfig = {}
    for idx = 1, #borderConfig do
        newBoardConfig[idx] = {}
        local temp = borderConfig[idx]
        local newReelConfig = {}
        for cnt, posList in pairs(temp.reelConfig) do
            local colCnt = temp.colCnt
            for col = 1, colCnt do
                local oneConfig = {}
                local posx = (col - 1) * (temp["cellWidth"]) + posList["base_pos"].x
                local posy = posList["base_pos"].y
                oneConfig["base_pos"] = cc.p(posx, posy)
                oneConfig["symbolCount"] = temp["symbolCount"]
                oneConfig["cellWidth"] = temp["cellWidth"]
                oneConfig["cellHeight"] = temp["cellHeight"]
                table.insert(newReelConfig, oneConfig)
            end
        end
        newBoardConfig[idx] = tool.tableClone(temp)
        newBoardConfig[idx].reelConfig = newReelConfig
    end
    self.boardConfigList = newBoardConfig
    return self.boardConfigList
end
function cls:getThemeJackpotConfig()
    local jp_name = themeConfig.jackpot_config.name
    local jackpot_config_list = {
        link_config = jp_name,
        allowK      = themeConfig.jackpot_config.allowK
    }
    return jackpot_config_list
end
function cls:isLowSymbol(item)
    if not item then
        return false
    end
    if self.LowSymbolList[item] then
        return true
    end
    return false
end
function cls:getFreeReel()
    if self.freeCtl:getFreeType() == freeTypeList.stickWild or self.freeCtl:getFreeType() == freeTypeList.mapSticky then
        return self.theme_reels["free_reel"]
    else
        return self.theme_reels["free2"]
    end
end
function cls:playTransition(endCallBack, tType, isEnter, coverCallback)
    local transition = ThemeBaseTransitionControl.new(self, endCallBack, coverCallback)
    local transition_config = self.gameConfig.transition_config[tType]
    local config = {}
    local endTm = transition_config.onEnd

    if tType == "free" then
        if isEnter then
            config.animName = "animation1"
            config.audio = transition_config.audio
        else
            config.animName = "animation2"
            config.audio = transition_config.audio2
        end
    elseif tType == "wheel_1" then
        config.animName = "animation1"
        transition:setPosition(cc.p(0, -300))
        bole.adaptReelBoard(transition)
        config.audio = transition_config.audio
    elseif tType == "wheel" then
        transition:setPosition(cc.p(0, -300))
        config.animName = "animation2"
        bole.adaptReelBoard(transition)
        config.audio = transition_config.audio
    else
        config.animName = "animation"
        config.audio = transition_config.audio
    end
    config.path = "spine/" .. self.gameConfig.spine_path[transition_config.spine_file]
    config.endTime = endTm
    config.coverTime = transition_config.onCover
    transition:play(config)
end
function cls:finshSpin()
    if (not self:isInFG()) and (not self.autoSpin) and (not self.bonus) then
        self:enableMapInfoBtn(true)
    end
end

------------reel start----------
function cls:onSpinStart(...)
    self:enableMapInfoBtn(false)
    self.DelayStopTime2 = 0
    if self.showSpinBoard == SpinBoardType.FreeSpin or self.showSpinBoard == SpinBoardType.SuperFree then
        self:dealFreeStart(true)
    else
        self.collectViewCtl:changeStoreTipState(true)
    end
    self:exitMapScene()
    parentClass.onSpinStart(self)
end
function cls:onSpinStop(ret)
    parentClass.onSpinStop(self, ret)
end
function cls:getBonusReel()
    local data = self.ctl.theme_reels["bonus_reel"]
    return data
end

function cls:stopControl(stopRet, stopCallFun)

    self.item_list = stopRet.item_list
    if stopRet.calculate_list then
        self.new_item_list = stopRet.calculate_list
    elseif stopRet.theme_info and stopRet.theme_info.calculate_list then
        self.new_item_list = stopRet.theme_info.calculate_list
    else
        self.new_item_list = nil
    end
    self.isShowGoodJILI = false
    if stopRet["bonus_level"] then
        self.tipBetList = stopRet["bonus_level"]
    end
    if self.showSpinBoard == SpinBoardType.FreeSpin then
        self:dealFreeStopControl(stopRet, stopCallFun)
    elseif self.showSpinBoard == SpinBoardType.SuperFree then
        self:dealSuperStopControl(stopRet, stopCallFun)
    else
        if self:checkShowGoodNotify(stopRet) then
            self.isShowGoodJILI = true
            self.audioCtl:dealMusic_FadeLoopMusic(1, 0.5, 0.5)
            self:resetBaseReel()
            self:laterCallBack(2, function()
                self:setMaskNodeStatus(1, false, true)
                stopCallFun()
            end)
            self:showGoodNotifyAction()
        else
            stopCallFun()
        end
    end
end
function cls:resetBaseReel(isEnter)
    if isEnter then
        self.currentReels = self.theme_reels.jili_reel
    else
        self.currentReels = self.theme_reels.main_reel
    end
end
function cls:canSkipLaterCallBack(...)

    self.mainView:canSkipLaterCallBack(...)
end
function cls:dealFreeStopControl(stopRet, stopCallFun)
    local before_fg_info = self.freeCtl:getFreeStickyWild(self.freeCtl:getFreeType())
    self.DelayStopTime2 = 0
    self.canSkipInRoll = false
    local fg_info = stopRet.theme_info.fg_info
    self.freeCtl:setFreeStickyWild(fg_info)
    local extraDelay = 0
    local fg_info = self.freeCtl:getFreeStickyWild(self.freeCtl:getFreeType())
    if self.freeCtl:getFreeType() == freeTypeList.stickRandom then
        if before_fg_info.moving_pos and #before_fg_info.moving_pos > 1 then
            self.DelayStopTime2 = 1
            extraDelay = 1
        end
        local new_random_pos = fg_info.new_random_pos
        if new_random_pos and #new_random_pos > 0 then
            self.canSkipInRoll = true
            self:canSkipLaterCallBack(self.DelayStopTime2, function()
                self:setMaskNodeStatus(1, true, true)
                local new_pos = tool.tableClone(new_random_pos)
                self:dealFreeGameRandom(new_pos)
            end)
            self.DelayStopTime2 = self.DelayStopTime2 + #new_random_pos + 1
            if fg_info.moving_pos and #fg_info.moving_pos > 1 then
                self:canSkipLaterCallBack(self.DelayStopTime2, function()
                    local center_item = new_random_pos[#new_random_pos]
                    self:dealFreeMoving(fg_info.moving_pos, center_item, true)
                end)
                self.DelayStopTime2 = self.DelayStopTime2 + 2
            end
            local canSkipLaterCallBack = function()
                self.canSkipInRoll = false
                self.mainView:stopMovingMask()
                self:setMaskNodeStatus(1, false, true)
            end
            self:canSkipLaterCallBack(self.DelayStopTime2, canSkipLaterCallBack)
            if extraDelay > 0 then
                self:laterCallBack(extraDelay, stopCallFun)
            else
                stopCallFun()
            end
        else
            stopCallFun()
        end
    else
        stopCallFun()
    end
end
function cls:dealFreeMoving(...)
    self.mainView:dealFreeMoving(...)
end
function cls:recoverWildBoard(...)
    self.mainView:recoverWildBoard(...)
end
function cls:recoverFreeSticky(...)

    self.mainView:recoverFreeSticky(...)
end
function cls:recoverFreeMoving(...)
    self.mainView:recoverFreeMoving(...)
end

function cls:dealSuperStopControl(stopRet, stopCallFun)
    --local before_fg_info = self.freeCtl:getFreeStickyWild(self.freeCtl:getFreeType())
    local fg_info = stopRet.theme_info.fg_info
    self.freeCtl:setFreeStickyWild(fg_info)
    self.canSkipInRoll = false
    self.DelayStopTime2 = 0
    if self.freeCtl:getFreeType() == freeTypeList.mapRandom then
        local map_info = self.freeCtl:getFreeStickyWild(freeTypeList.mapRandom)
        local random_pos = map_info.random_pos
        if random_pos and #random_pos > 0 then
            self.DelayStopTime2 = #random_pos + 1
            self.canSkipInRoll = true
            local new_pos = tool.tableClone(random_pos)
            --self:canSkipLaterCallBack(self.DelayStopTime2, function()
            self:setMaskNodeStatus(1, true, true)
            self:dealFreeGameRandom(new_pos)
            --end)
        end
    elseif self.freeCtl:getFreeType() == freeTypeList.mapMoving then
        local map_info = self.freeCtl:getFreeStickyWild(freeTypeList.mapMoving)
        local new_random_pos = map_info.new_random_pos
        if new_random_pos and #new_random_pos > 0 then
            self.canSkipInRoll = true
            local new_pos = tool.tableClone(new_random_pos)
            self:canSkipLaterCallBack(self.DelayStopTime2, function()
                self:setMaskNodeStatus(1, true, true)
                self:dealFreeGameRandom(new_pos)
            end)
            self.DelayStopTime2 = self.DelayStopTime2 + #new_random_pos + 1
        end
        if map_info.moving_pos and #map_info.moving_pos > 1 then
            local center_item = new_random_pos[#new_random_pos]
            self:canSkipLaterCallBack(self.DelayStopTime2, function()
                self:dealFreeMoving(map_info.moving_pos, center_item, true)
            end)
            self.DelayStopTime2 = self.DelayStopTime2 + 2
        end
    end
    if self.DelayStopTime2 > 0 then
        local stopCallFun2 = function()
            self.mainView:stopMovingMask()
            self:setMaskNodeStatus(1, false, true)
        end
        self:canSkipLaterCallBack(self.DelayStopTime2, stopCallFun2)
    end
    stopCallFun()
end

function cls:dealFreeGameRandom(random_pos)
    self.mainView:createRandom(random_pos)
end
function cls:dealStickyWild(new_sticky_pos)
    self.mainView:dealStickyWild(new_sticky_pos)
end
function cls:checkShowGoodNotify(stopRet)
    local random = math.random(1, 10)
    if random <= 5 then
        return false
    end
    if (stopRet.bonus_game and stopRet.bonus_game.wheel_info) then
        return true
    end
    if (stopRet.base_win / self:getCurTotalBet()) >= 10 then
        return true
    end
    return false

end
function cls:showGoodNotifyAction()
    self.mainView:showGoodNotifyAction()
end
function cls:showBigWinAction()
    self:playMusicByName("bell")
    self.mainView:showBigWinAction()
    --if self.showSpinBoard == SpinBoardType.SuperFree then
    --    self.mainView:changeSuperBigWin()
    --end
end

function cls:onReelFallBottom(pCol)
    self.reelStopMusicTagList[pCol] = 1
    if not self:isDropScatter(pCol) then
        self:dealMusic_PlayReelStopMusic(pCol)
    end

    if self.showSpinBoard == SpinBoardType.SmallSlot then
        return
    end
    self:playSymbolNotifyEffect(pCol)
    self:dealMusic_StopReelNotifyMusic(pCol)
    self:stopReelNotifyEffect(pCol)
    self:onReelFallBottomJiLi(pCol)
end

function cls:onReelFallBottomJiLi(pCol)
    if self.isShowGoodJILI then
        return
    end
    local nextCol = pCol + 1

    if nextCol <= 5 then
        if self:checkSpeedUpByScatter(nextCol) then
            self:onReelNotifyStopBeg(nextCol, specialSymbol.scatter)
        end
    end
end
function cls:onReelFastFallBottom(pCol)
    self.reelStopMusicTagList[pCol] = 2
    self.fastStopMusicTag = self.fastStopMusicTag or "allow_music"
    self:dealMusic_StopReelNotifyMusic(pCol)
    self:dealMusic_PlayReelStopMusic(pCol)
    if self.showSpinBoard == SpinBoardType.SmallSlot then
        return
    end
    self:playSymbolNotifyEffect(pCol)

    self:stopReelNotifyEffect(pCol)
end
function cls:onReelStop(col)

end

function cls:onAllReelStop(...)
    parentClass.onAllReelStop(self)
end
function cls:checkSpeedUp(checkCol)
    local isNeedSpeedUp = false
    if self.speedUpState and self.speedUpState[checkCol] then
        isNeedSpeedUp = true
    end
    return isNeedSpeedUp
end
function cls:isDropScatter(col)
    local find = false
    if self:checkSpeedUp(col) and self.speedUpState[col][specialSymbol.scatter].is_get then
        find = true
    end
    return find
end

function cls:checkNeedNotify(pCol)
    local isSpeedUp = false
    if self.isShowGoodJILI then
        return false
    end
    if self:checkSpeedUpByScatter(pCol) then
        return true
    end
    return isSpeedUp
end
function cls:checkSpeedUpByScatter(pCol)

    local isSpeedUp = false
    if self:checkSpeedUp(pCol) then
        local mini1 = self:getTriggerMin(specialSymbol.scatter)
        if self.speedUpState[pCol][specialSymbol.scatter] and self.speedUpState[pCol][specialSymbol.scatter]["cnt"] >= mini1 then
            isSpeedUp = true
            return isSpeedUp
        end
    end
    return isSpeedUp
end
function cls:getTriggerMin(symbolID)
    local mini1 = self.specialItemConfig[symbolID].min_cnt
    return mini1
end
function cls:genSpecialSymbolState(rets)
    rets = rets or self.ctl.rets
    if not self.checkItemsState then
        self.checkItemsState = {}
        self.speedUpState = {}
        self.notifyState = {}
        self.scatterBGState = {}
        if self.showSpinBoard == SpinBoardType.Normal then
            self:genSpecialSymbolStateInNormal(rets)
        end
    end
end
function cls:genSpecialSymbolStateInNormal(rets)
    local cItemList = rets.item_list
    local checkConfig = self.specialItemConfig
    for itemKey, theItemConfig in pairs(checkConfig) do
        local itemType = theItemConfig["type"]
        local itemCnt = 0
        if itemType then
            for col = 1, #self.spinLayer.spins do
                local colItemList = cItemList[col]
                local colRowCnt = self.spinLayer.spins[col].row -- self.colRowList[col]
                local curColMaxCnt = theItemConfig["col_set"][col] or colRowCnt
                local colItemCnt = 0
                local isGetFeature = false
                for row, theItem in pairs(colItemList) do
                    if theItem == itemKey then
                        colItemCnt = colItemCnt + 1
                        isGetFeature = true
                    end
                end
                local willGetFeatureInAfterCols = false

                local sumCnt = 0
                sumCnt = sumCnt + curColMaxCnt * (#self.spinLayer.spins - col)
                if curColMaxCnt > 0 and sumCnt > 0 and (itemCnt + sumCnt) >= theItemConfig["min_cnt"] then
                    willGetFeatureInAfterCols = true
                end
                local mini = theItemConfig["col_set"][col]
                if willGetFeatureInAfterCols then
                    self.speedUpState[col] = self.speedUpState[col] or {}
                    self.speedUpState[col][itemKey] = self.speedUpState[col][itemKey] or {}
                    self.speedUpState[col][itemKey]["cnt"] = itemCnt + mini
                    self.speedUpState[col][itemKey]["real_cnt"] = itemCnt + colItemCnt
                    self.speedUpState[col][itemKey]["is_get"] = isGetFeature
                    --end
                end
                self.notifyState[col] = self.notifyState[col] or {}
                if willGetFeatureInAfterCols then
                    for row, theItem in pairs(colItemList) do
                        if theItem == itemKey then
                            self.notifyState[col][itemKey] = self.notifyState[col][itemKey] or {}
                            table.insert(self.notifyState[col][itemKey], { col, row })
                        end
                    end
                end
                if isGetFeature then
                    itemCnt = itemCnt + colItemCnt
                end

            end
        end
    end
end
function cls:getNormalStopAddCount()

    local config = self.gameConfig.reel_spin_config
    local symbol_size = self.gameConfig.symbol_size

    local addHeight = config.downBounce + symbol_size[2] * 0.5
    local extra = math.ceil(addHeight / symbol_size[2])
    return extra
end
function cls:getDropIndex(col, key)
    if self.speedUpState and self.speedUpState[col] and self.speedUpState[col][key] then
        return self.speedUpState[col][key].real_cnt
    end
    return 0

end
function cls:getEndRowByCol(pCol)
    if self.showSpinBoard == SpinBoardType.Normal then
        return 4
    end
    return 8
end
function cls:playSymbolNotifyEffect(col, reelSymbolState)
    if not self.item_list then
        return
    end
    local find = false
    local extraAddCnt = self:getNormalStopAddCount()
    local endRow = self:getEndRowByCol(col)
    for row = 1, endRow do
        local symbolID = self.item_list[col][row]
        local realRow = row
        local needRow = realRow
        if not self.fastStopMusicTag then
            needRow = needRow + extraAddCnt
        end
        if symbolID == specialSymbol.scatter then
            local cell = self.mainView.spinLayer.spins[col]:getRetCell(needRow)
            if self:isDropScatter(col) then
                self.mainView:playDropSpine(cell, specialSymbol.scatter, false)
                self.mainView:changeSymbolAnimParent(cell, col, realRow)
            else
                self.mainView:playDropSpine(cell, specialSymbol.scatter, true)
                self.mainView:changeSymbolAnimParent(cell, col, realRow)
            end
        end

    end
end
function cls:onReelNotifyStopBeg(col, SymbolID)
    self:playReelNotifyEffect(col, SymbolID)

end
function cls:playReelNotifyEffect(col, SymbolID, cnt)
    self.mainView:playReelNotifyEffect(col, SymbolID, cnt)
end
function cls:stopReelNotifyEffect(pCol)

    self.mainView:stopReelNotifyEffect(pCol)
end
------------reel end  ----------
------------ end ----------
function cls:onThemeInfo(specialData, callFunc)

    if self.isShowGoodJILI then
        self:resetBaseReel()
    end
    if specialData.free_game and self.showSpinBoard == SpinBoardType.Normal then
        self.freeCtl:setFreeSpinInfo(specialData.free_game)
        local fg_info = specialData.theme_info.fg_info
        self.freeCtl:setFreeStickyWild(fg_info)
        if self.freeCtl:getFreeType() > 2 then
            self.superAvgBet = specialData.free_game.avg_bet
        end
    end
    self:skipAllAction(1)
    self:dealThemeInfo(callFunc)
end
function cls:dealThemeInfo(callFunc)
    local delayTm = 0
    if self.showSpinBoard == SpinBoardType.Normal then
        local revealList = self:getRevealList()
        if revealList and #revealList > 0 then
            delayTm = delayTm + 25 / 30
            self:playMusicByName("symbol_bonus")
        end
        self.canThemeSkip = true
        self:openRevealSymbol(revealList)

    elseif self.showSpinBoard == SpinBoardType.FreeSpin then
        if self.freeCtl:getFreeType() == freeTypeList.stickWild then
            local fg_info = self.freeCtl:getFreeStickyWild(freeTypeList.stickWild)
            local new_sticky_pos = fg_info.new_sticky_pos
            if #new_sticky_pos > 0 then
                self.canThemeSkip = true
                delayTm = delayTm + #new_sticky_pos
                self:dealStickyWild(tool.tableClone(new_sticky_pos))
            end
        end
    elseif self.showSpinBoard == SpinBoardType.SuperFree then
        if self.freeCtl:getFreeType() == freeTypeList.mapMulti then
            delayTm = delayTm + 25 / 30
            local multi = self.item_list[3][1]
            self:playMapMultiByStep(3, multi % 1000)
        elseif self.freeCtl:getFreeType() == freeTypeList.mapSticky then
            local fg_info = self.freeCtl:getFreeStickyWild(freeTypeList.mapSticky)
            local new_sticky_pos = fg_info.new_sticky_pos
            if #new_sticky_pos > 0 then
                delayTm = delayTm + #new_sticky_pos
                self.canThemeSkip = true
                self:dealStickyWild(tool.tableClone(new_sticky_pos))
            end
        end
    end
    self.afterOnThemeInfo = function()
        self:dealFlyCollectItem()
        self.canThemeSkip = false
        self.afterOnThemeInfo = nil
        if self.rets.base_win / self:getCurTotalBet() >= 10 then
            self:showBigWinAction()
            self:laterCallBack(1, callFunc)
        else
            callFunc()
        end

    end
    if self.canThemeSkip then
        self.ctl.footer:setSpinButtonState(false)
    end
    self:canSkipLaterCallBack(delayTm, function()
        if self.afterOnThemeInfo then
            self.afterOnThemeInfo()
        end
    end)
end

----- reveal start
function cls:getRevealList()
    local revealList = {}
    if self.item_list and #self.item_list > 0 then
        for col = 1, 5 do
            for row = 1, self:getEndRowByCol(col) do
                if self.item_list[col][row] > 200 then
                    table.insert(revealList, { col, row, self.item_list[col][row] })
                end
            end
        end
    end
    return revealList
end
function cls:openRevealSymbol(revealList)

    for key, item in ipairs(revealList) do

        local col = item[1]
        local row = item[2]
        local symbolID = item[3]
        self:changeRevealSymbol(col, row, symbolID)
    end
end
function cls:changeRevealSymbol(...)
    self.mainView:changeRevealSymbol(...)
end
----- reveal end
function cls:dealFlyCollectItem()
    if self.showSpinBoard ~= SpinBoardType.Normal then
        return 0
    end
    if not self.mapInfo then
        return
    end

    self.mapInfo = self.ctl.rets.theme_info.map_info
    self.mapLevel = self.mapInfo.map_level

    if self.mapPoints ~= self.ctl.rets.theme_info.map_info.collect_count then
        self.mapPoints = self.ctl.rets.theme_info.map_info.collect_count
        self.collectViewCtl:dealFlyCollectItem(self.ctl.rets)
        return 0.5
    end
    return 0

end

function cls:playFadeToMaxVlomeMusic()
    local mvC = self.musicVolumeConfig
    self.audioCtl:dealMusic_FadeLoopMusic(mvC.time_volume, mvC.min_volume, mvC.max_volume)
end
function cls:playFadeToMinVlomeMusic()
    local mvC = self.musicVolumeConfig
    self.audioCtl:dealMusic_FadeLoopMusic(mvC.time_volume, mvC.max_volume, mvC.min_volume)
end

------------get control start----------

function cls:getNormalStatus(...)
    if self.showSpinBoard == SpinBoardType.Normal then
        return true
    end
    return false
end
function cls:getFreeGameStatus(...)

end
function cls:getFreeVCtl(...)
    return self.freeCtl
end
function cls:getJpViewCtl(...)
    return self.jpViewCtl
end
function cls:getCollectViewCtl(...)
    return self.collectViewCtl
end
function cls:getMapViewCtl(...)
    return self.mapViewCtl
end
--function cls:getWheelCtl(...)
--    return self.wheelCtl
--end
function cls:getMapInfo(...)
    return self.mapInfo
end
function cls:setMapInfo(key, value)
    self.mapInfo[key] = value
end
function cls:getMapLevel()
    return self.mapLevel or 0
end
function cls:getMapPoints()
    return self.mapPoints or 0
end
function cls:getMapMulti()
    return self.mapViewCtl:getMapMulti()
end
function cls:resetMapProgress()
    self.mapPoints = 0
    self.mapInfo.collect_count = 0
    if self.mapLevel == 33 then
        self.mapLevel = 0
    end
    self:updateCollectCount(self.mapPoints)
end
function cls:getCollectIsLock()
    return self.collectViewCtl:getIsLockFeature()
end
--------------------------------bet start----------------------------------
function cls:featureUnlockBtnClickEvent(_unLockType)
    if self.tipBetList and self.tipBetList[_unLockType] then
        self:setBet(self.tipBetList[_unLockType])
    end
end
function cls:dealAboutBetChange(theBet, isPointBet)
    if (not self.tipBetList) or (not self.loadFinish) then
        return
    end
    theBet = theBet or self:getCurTotalBet()
    local maxBet = self:getMaxBet()
    self:changeCollectBet(theBet)
    if maxBet >= theBet then
        self:changeUnlockJpBet(theBet) --放在前面是以防升级的时候,jp解锁的情况
    end
    if not theBet then
        return
    end
end

function cls:changeCollectBet(theBet)
    self.collectViewCtl:changeCollectBet(theBet)
end
function cls:changeUnlockJpBet(theBet)
    self.jpViewCtl:changeUnlockJpBet(theBet)
end
--------------------------------bet end  ----------------------------------
function cls:showBonusNode(...)
    self:resetCurrentReels(false, false)
end
function cls:dealSpecialFeatureRet(data)
    self.tipBetList = data.bonus_level
    self.notPlayEnterTheme = 0
    if data["map_info"] then
        self.mapInfo = data.map_info
        self.mapPoints = self.mapInfo.collect_count
        self.mapLevel = self.mapInfo.map_level
    else
        self.mapLevel = 0
        self.mapInfo = {}
    end
end

function cls:dealBonusGameResumeRet(data)
    -- body
    if data.bonus_game then
        self.notPlayEnterTheme = 2
    end
end
function cls:dealFreeGameResumeRet(data)
    if data.free_game then
        self.freeCtl:setFreeStickyWild(data.fg_info)

        self.notPlayEnterTheme = 1
        local collect_config = self.gameConfig.collect_config
        if data.free_game.super_wheel and self.mapLevel == 0 then
            self.mapLevel = collect_config.max_level
            self.mapInfo.fg_count = collect_config.maxMapLevel
        end
        if data.free_game.fg_type > 2 then
            self.superAvgBet = data.map_info.avg_bet
        end
    end
    if self.freeCtl then
        self.freeCtl:dealFreeGameResumeRet(data)
    end


end
function cls:adjustTheme(data)
    self.loadFinish = true
    self.DelayStopTime2 = 0
    self:changeSpinBoard(SpinBoardType.Normal)
    if not self:noFeatureLeft() then
        self:enableMapInfoBtn(false)
    else
        self:enableMapInfoBtn(true)
    end
    if self.notPlayEnterTheme == 0  then
        self.collectViewCtl:changeStoreTipState()
    end
    self:playEnterThemeMusic(0)
    self.mapPoints = self.mapPoints or 0
    self:updateCollectCount(self.mapPoints)
end
function cls:playEnterThemeMusic(from)
    if from == self.notPlayEnterTheme then
        self:playMusicByName("enter_game")
        self.notPlayEnterTheme = 3
    end
end

function cls:updateCollectCount(newCount, beforeCount, isAnimate)
    self.collectViewCtl:updateCollectCount(newCount, beforeCount, isAnimate)

end
function cls:changeSpinBoard(pType, isAnimate)
    self.showSpinBoard = pType
    isAnimate = isAnimate or false
    self.mainView:clearAnimate()
    if pType == SpinBoardType.Normal then
        self.mainView:updateBaseUI()
        self.lockedReels = nil
    elseif pType == SpinBoardType.FreeSpin then
        self:getCollectViewCtl():changeStoreTipState(true)
        self.mainView:updateFreeUI(self.freeCtl:getFreeType())
        --self:setFooterStyle(2)
        self.lockedReels = nil

    elseif pType == SpinBoardType.SuperFree then
        self:getCollectViewCtl():changeStoreTipState(true)
        self.mainView:updateSuperFreeUI()
        self:setFooterStyle(2)
        if self.freeCtl:getFreeType() == freeTypeList.mapMulti then
            self.lockedReels = { [3] = true }
        end

    elseif pType == SpinBoardType.SmallSlot then
        self:getCollectViewCtl():changeStoreTipState(true)
        self.mainView:updateSmallSlotUI()
        self:setFooterStyle(0)
        self.lockedReels = nil

    elseif pType == SpinBoardType.Wheel then
        self:getCollectViewCtl():changeStoreTipState(true)
        self.mainView:updateWheelUI()
        self.lockedReels = nil

    end
    self.mainView:changeBg(pType)
end
function cls:getSpinBoardType()
    return self.showSpinBoard
end
function cls:checkSpinBoardInBase()
    return self.showSpinBoard == SpinBoardType.Normal
end
---------------- bonus conection start------------------
function cls:playBonusAnimate(theGameData, isFinish)
    local delay = 2
    self.mainView:stopDrawAnimate()
    self:stopAllLoopMusic()
    if not isFinish then
        if theGameData.wheel_info then
            self:playMusicByName("bell")
            self:laterCallBack(1, function()
                self:playMusicByName("bomb")
            end)
        end
    end
    local item_list = self.item_list or theGameData.item_list

    if theGameData.wheel_info and item_list then
        for col = 2, 4, 1 do
            for row = 1, 4 do
                local item = item_list[col][row]
                if item == specialSymbol.scatter then
                    local isLoop = isFinish
                    self.mainView:playItemTriggerSpine(specialSymbol.scatter, col, row, isLoop)
                end
            end
        end
        delay = 2
    end
    return delay
end
---------------- bonus conection end  ------------------

---------------- free conection start  ------------------
function cls:freeStartClicked(callFunc, isMore)
    if self.freeCtl.freeStartClicked then
        self.freeCtl:freeStartClicked(callFunc, isMore)
    else
        callFunc()
    end
end
function cls:clickBoard()
    --if self:getCanTouchFeature() then
    self:footerCopySpinBtnEvent()
    --end
end

function cls:enterFreeSpin(isResume)
    if isResume then
        self:dealMusic_PlayFreeSpinLoopMusic()-- 切换背景音乐
    end
    self.mainView:showAllItem()
    self.playNormalLoopMusic = false --commonMusic: freespin背景音乐
end
function cls:showFreeSpinNode(count, sumCount, first)
    if self.freeCtl:checkIsSuperFree() then
        self:resetPointBet()
        self:changeSpinBoard(SpinBoardType.SuperFree)
        self.mainView:resetAllCellSpite()
    else
        self:changeSpinBoard(SpinBoardType.FreeSpin)
    end
    self:resetThemeType(true)
    self:dealFreeStart(false)
    parentClass.showFreeSpinNode(self, count, sumCount, first)
end
function cls:getFreeMaskLevel(fg_count)

    local cnt = fg_count
    if cnt >= 6 then
        return 0
    elseif cnt >= 4 then
        return 1
    elseif cnt >= 3 then
        return 2
    elseif cnt >= 2 then
        return 3
    else
        return 4
    end
end
function cls:hideFreeSpinNode(...)
    self:setMaskNodeStatus(1, false, false)
    if self.freeCtl:getFreeType() == freeTypeList.mapMulti then
        self:playMapMultiByStep(4)
    end
    local beforeBoard = self.showSpinBoard
    if beforeBoard == SpinBoardType.SuperFree then
        self.freeCtl.freeItem = nil
        self.freeCtl.freeSpeical = nil
        self:resetMapProgress()
        self.mainView:resetAllCellSpite()
        self.mainView:closeSuperUI()
        self:setFooterStyle(1, 2)
        self:removePointBet()
        self.superAvgBet = nil
    else
        self:setFooterStyle(1, 1)
    end
    self.freeCtl:clearFreeSpinInfo()
    self.mainView:clearCurPageStickNode()

    self:changeSpinBoard(SpinBoardType.Normal)
    self:removePointBet()
    self:resetThemeType(false)
    parentClass.hideFreeSpinNode(self, ...)
end
function cls:collectFreeRollEnd()
    self:playEnterThemeMusic(1)
end
function cls:collectBonusRollEnd()
    self:playEnterThemeMusic(2)
end
function cls:resetPointBet(...)
    if self.superAvgBet then
        self:setPointBet(self.superAvgBet)-- 更改 锁定的bet
    end
    self.collectViewCtl:changeStoreTipState(true)
end
function cls:playStartFreeSpinDialog(theData)
    self.freeCtl:playStartFreeSpinDialog(theData)
end
function cls:playMoreFreeSpinDialog(theData)
    self.freeCtl:playMoreFreeSpinDialog(theData)
end
function cls:playCollectFreeSpinDialog(theData)
    self.freeCtl:playCollectFreeSpinDialog(theData)
end
function cls:playFreeSpinItemAnimation(theSpecials, enterType)
    for col, rowTagList in pairs(theSpecials[specialSymbol.scatter]) do
        for row, tag in pairs(rowTagList) do
            self.mainView:playItemTriggerSpine(specialSymbol.scatter, col, row, true)
        end
    end
    return 0
end

function cls:onExit()
    EventCenter:removeEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_SHOW, "theme230")
    EventCenter:removeEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_HIDE, "theme230")
    parentClass.onExit(self)
    if self.mainView.onExit then
        self.mainView:onExit()
    end
    if self.bonus and self.bonus.onExit then
        self.bonus:onExit()
    end
end
function cls:getMapParentNode()
    return self.mainView:getMapParentNode()
end
function cls:noFeatureLeftSpecial()
    if self.bonus then
        return false
    end
    return true
end
---@param footer_type /0: bet hide /1: normal base, /2 free bet hide /3:normal free /
---@param from_free  /1:back from normal free,/2:back from super free. be used when footer_type == 1
function cls:setFooterStyle(footer_type, from_free)
    if footer_type == 0 then
        self.footer:isShowTotalBetLayout(false, true)-- 隐藏掉  footer bet
    elseif footer_type == 1 then
        if from_free then
            if from_free == 2 then
                self.footer:changeNormalLayout2(true, true)
            elseif from_free == 1 then
                self.footer:changeFreeSpinLayout()
            end
        else
            self.footer:changeNormalLayout2()
        end
    elseif footer_type == 2 then
        self.footer:changeFreeSpinLayout3()
    elseif footer_type == 3 then
        self.footer:changeFreeSpinLayout()
    end
end
function cls:saveBonusData(bonusData)
    if self.new_item_list then
        self.bonusItem = tool.tableClone(self.new_item_list)
        self.bonusRet = self.rets
    else
        if bonusData.item_list then
            self.bonusItem = tool.tableClone(bonusData.item_list)
        end
    end
    self.bonusSpeical = nil
end


---------------- free connection end  ------------------
------------------- stick wild start ------------------

function cls:getRealItem(col, row)
    if self.showSpinBoard == SpinBoardType.FreeSpin or self.showSpinBoard == SpinBoardType.SuperFree then
        if self:checkIsCreateStickNode(col, row) then
            return specialSymbol.wild
        end
    end
    return nil
end
function cls:checkIsStickyWild()
    if self.showSpinBoard == SpinBoardType.normal then
        return false
    end
    if self.freeCtl:getFreeType() == freeTypeList.stickWild or self.freeCtl:getFreeType() == freeTypeList.mapSticky then
        return true
    end
    return false
end
------------------------ map part start -----------
function cls:showMapScene()
    self.mapViewCtl:showMapScene(false, true)
end
function cls:exitMapScene(byBonus)
    self.mapViewCtl:exitMapScene(byBonus)
end
function cls:showMapSceneByBonus(isAni)
    self.mapViewCtl:showMapScene(1, isAni)

    local isBig = self.mapViewCtl:checkIsBigNode(self:getMapLevel())
    local close_delay = isBig and 45 / 30 or 30 / 30
    self.node:runAction(cc.Sequence:create(
            cc.DelayTime:create(1),
            cc.CallFunc:create(
                    function()
                        self:getMapViewCtl():mapForward()
                    end),
            cc.DelayTime:create(25 / 30),
            cc.CallFunc:create(function()
                self:getMapViewCtl():mapItemLighten()
            end),
            cc.DelayTime:create(close_delay),
            cc.CallFunc:create(function()
                self:exitMapScene(isAni)
            end)
    ))
    return close_delay + 45 / 30 + 25 / 30
end
------------------------ map part end -----------


--------------------respin start--------------------
function cls:onRespinStart(...)
    if self.bonus then
        self.bonus:onRespinStart()
    end
    parentClass.onRespinStart(self)
end
function cls:onRespinStop(ret)
    if self.showSpinBoard == SpinBoardType.SmallSlot then
        self:fixRet(ret, 3)
    end
    if #ret["theme_respin"] == 0 then
        self.respinStep = ReSpinStep.Over
        ret.theme_deal_show = true
    end
    parentClass.onRespinStop(self, ret)
end
function cls:theme_deal_show(ret)
    ret.theme_deal_show = nil
    if self.respinStep == ReSpinStep.Over then
        self.rets["theme_respin"] = nil
        if self.showSpinBoard == SpinBoardType.SmallSlot then
            self.bonus:onRespinFinish(ret, true)
        end
    end
end
function cls:fixRet(ret, respin_type)
    if respin_type == 3 then
        self:smallSlotFixRet(ret)
    end
end
--------------------respin end--------------------
--------------------jp wheel start--------------------
function cls:getJpWheelParent()
    return self.mainView:getJpWheelParent()
end
--------------------jp wheel end--------------------

------------------- map free end ------------------
---@param theData /info
---@param sType /1:start 2:more 3:collect
---@param index /1:free 2:jp 3:map/wheel,pick
function cls:showThemeDialog(theData, sType, dialogType)
    self:playFadeToMinVlomeMusic()
    --self:stopSecondLoopMusic()
    local end_event = theData.click_event
    theData.click_event = function()
        if end_event then
            end_event()
        end
        if sType == fs_show_type.start or sType == fs_show_type.collect then
            self:playMusicByName("common_click")
        end
        self:laterCallBack(0.2, function()
            self:playMusicByName("dialog_close")
            self.mainView:setMaskNodeStatus(2, false, true)
        end)
    end
    local config = {}
    config["csb_file"] = self:getCsbPath("dialog_" .. dialogType)
    config["frame_config"] = {
        ["start"]   = { nil, 1, nil, 2 },
        ["more"]    = { nil, 3, nil, 2 },
        ["collect"] = { nil, 1, nil, 2 },
    }
    config.dialog_config = themeConfig.dialog_config[dialogType][sType]
    local parent = self.mainView:getDialogParent()
    if sType == fs_show_type.collect then
        self:fixDialogData(theData, config.dialog_config)
    end
    local theDialog = ThemeBaseDialog.new(self.ctl, config)
    if sType == fs_show_type.start then
        theDialog:showStart(theData, nil, parent)
    elseif sType == fs_show_type.more then
        theDialog:showMore(theData, nil, parent)
    elseif sType == fs_show_type.collect then
        theDialog:showCollect(theData, nil, parent)
    end

    self.mainView:setMaskNodeStatus(2, true, true)
    return theDialog
end
function cls:fixDialogData(theData, dialog_config)

    local multi = theData.multi or 1
    if multi > 1 then
        dialog_config.btn_node.stepScale[2][1] = 8 / 30 + 3
    else
        dialog_config.btn_node.stepScale[2][1] = 8 / 30
    end

end

function cls:setMaskNodeStatus(...)
    self.mainView:setMaskNodeStatus(...)
end
function cls:dealMusic_StopReelNotifyMusic(pCol)
    if not pCol then
        return
    end
    self:stopMusicByName("reel_notify")
end
function cls:dealMusic_PlayReelNotifyMusic(pCol)

end
function cls:dealMusic_ExitBonusGame()
    local name = self.audio_list.base_background
    local stageType = 1
    if self:isInFG() then
        name = self.audio_list.free_background
        stageType = 2
    end
    -- 播放背景音乐
    self:playLoopMusic(name)
    self.playNormalLoopMusic = false
end
function cls:dealMusic_PlayFreeSpinLoopMusic()
    self.freeCtl:dealMusic_PlayFreeSpinLoopMusic()
end
function cls:dealMusic_playRollCoins()
    self:playMusicByName("win_rollup")
end
function cls:dealMusic_stopRollCoins()
    self:stopMusicByName("win_rollup")
end
-------------------- free start ---------------------
function cls:addStickWildRoll(fg_type, isAni)
    local fg_info = self.freeCtl:getFreeStickyWild(fg_type)
    if fg_type == freeTypeList.stickWild or fg_type == freeTypeList.mapSticky then
        if not isAni then
            local new_sticky_pos = fg_info.new_sticky_pos
            self:recoverFreeSticky(new_sticky_pos, isAni)
            local sticky_pos = fg_info.sticky_pos
            self:recoverFreeSticky(sticky_pos, isAni)
        else
            if fg_info.sticky_pos and #fg_info.sticky_pos > 0 then
                self:recoverWildBoard(fg_info.sticky_pos, true)
            end
        end
    elseif fg_type == freeTypeList.stickRandom then
        if not isAni then
            local random_pos = fg_info.random_pos
            self:recoverFreeMoving(random_pos)
            if fg_info.moving_pos and #fg_info.moving_pos > 0 then
                fg_info.moving_pos = {}
            end
        else
            if fg_info.moving_pos and #fg_info.moving_pos > 0 then
                local new_random_pos = fg_info.new_random_pos
                self:dealFreeMoving(fg_info.random_pos, new_random_pos[#new_random_pos], true, true)
                self:recoverWildBoard(fg_info.moving_pos)
            else
                local random_pos = fg_info.random_pos
                self:recoverWildBoard(random_pos)
            end
        end
    elseif fg_type == freeTypeList.mapRandom then
        if isAni then
            if fg_info.random_pos and #fg_info.random_pos > 0 then
                self:recoverWildBoard(fg_info.random_pos)
            end
        end
    elseif fg_type == freeTypeList.mapMoving then
        if not isAni then
            if fg_info.moving_pos and #fg_info.moving_pos > 0 then
                self:recoverFreeMoving(fg_info.moving_pos)
            end
        else
            if fg_info.moving_pos and #fg_info.moving_pos > 0 then
                self:recoverWildBoard(fg_info.moving_pos)
            end
        end
    elseif fg_type == freeTypeList.mapMulti then
        if isAni then
            self:playMapMultiByStep(2)
        else
            self:playMapMultiByStep(1)
        end
    end
end
function cls:checkIsCreateStickNode(col, row)
    return self.mainView:checkIsCreateStickNode(col, row)
end
function cls:createStickNode(...)
    self.mainView:createStickNode(...)
end
function cls:dealFreeStart(isAni)
    local fg_type = self.freeCtl:getFreeType()
    if fg_type == freeTypeList.stickWild then
        local start = self.freeCtl:getFGCnt()
        local level = self:getFreeMaskLevel(start)
        if isAni then
            local before_level = self:getFreeMaskLevel(start + 1)
            if before_level < level then
                self.mainView:playFreeMaskLevel(level, isAni)
            end
        else
            self.mainView:playFreeMaskLevel(level, isAni)
        end
        self:addStickWildRoll(fg_type, isAni)
    elseif fg_type == freeTypeList.mapRandom then
        if isAni then
            self.mainView:clearCurPageStickNode()
        end
        self:addStickWildRoll(fg_type, isAni)
    else
        self:addStickWildRoll(fg_type, isAni)
    end
    --end
end
function cls:playMapMultiByStep(...)
    self.mainView:playMapMultiByStep(...)
end
-------------------- free end ---------------------

----- skip start
function cls:spinButtonPressed()
    self:themeSkipAction()
end
function cls:themeSkipAction()

    if not self.canThemeSkip then
        return
    end
    self.ctl.footer:setSpinButtonState(true)
    self:skipAllAction(2)
    self.canThemeSkip = false
    self:dealMusic_FadeLoopMusic(0.3, 1, 0.3)
    self:stopMusicByName("bonus_to_wild")
    if self.afterOnThemeInfo then
        self.afterOnThemeInfo()
    end
end
function cls:skipAllAction(step)
    if step == 1 and self.canSkipInRoll then
        if self.showSpinBoard == SpinBoardType.FreeSpin or self.showSpinBoard == SpinBoardType.SuperFree then
            self:dealSkipInReelRoll()
        end
    elseif step == 2 then
        if self.showSpinBoard == SpinBoardType.FreeSpin or
                self.showSpinBoard == SpinBoardType.SuperFree or
                self.showSpinBoard == SpinBoardType.Normal then
            self:dealSkipInReelStop()
        end
    end
end
function cls:dealSkipInReelRoll()

    self.mainView:skipAllActions()
    self.mainView.animateNode:removeAllChildren()
    self:stopMusicByName("randomwild")
    self:stopMusicByName("groupwild")
    if self.freeCtl:getFreeType() == freeTypeList.stickRandom then
        self.mainView:stopMovingMask()
        self:setMaskNodeStatus(1, false, false)
        local fg_info = self.freeCtl:getFreeStickyWild(self.freeCtl:getFreeType())
        if fg_info.moving_pos and #fg_info.moving_pos > 1 then
            self.mainView:clearCurPageStickNode()
            self:recoverFreeMoving(fg_info.moving_pos)
        else
            self:recoverFreeMoving(fg_info.random_pos)
        end
    elseif self.freeCtl:getFreeType() == freeTypeList.stickWild then
        -- do nothing
    elseif self.freeCtl:getFreeType() == freeTypeList.mapRandom then
        self:setMaskNodeStatus(1, false, false)
        local fg_info = self.freeCtl:getFreeStickyWild(self.freeCtl:getFreeType())
        self:recoverFreeMoving(fg_info.random_pos)
    elseif self.freeCtl:getFreeType() == freeTypeList.mapSticky then
        -- do nothing
    elseif self.freeCtl:getFreeType() == freeTypeList.mapMoving then
        self.mainView:stopMovingMask()
        self:setMaskNodeStatus(1, false, false)
        local map_info = self.freeCtl:getFreeStickyWild(self.freeCtl:getFreeType())
        self.mainView:clearCurPageStickNode()
        self:recoverFreeMoving(map_info.moving_pos)
    end
end
function cls:dealSkipInReelStop()
    self.mainView:skipAllActions()
    self.mainView.animateNode:removeAllChildren()
    self:stopMusicByName("stickywild")
    if self.showSpinBoard == SpinBoardType.Normal then
        self:stopMusicByName("symbol_bonus")
        --self.mainView.animateNode:removeAllChildren()
    else
        local fg_type = self.freeCtl:getFreeType()
        if fg_type == freeTypeList.stickWild or fg_type == freeTypeList.mapSticky then
            local fg_info = self.freeCtl:getFreeStickyWild(fg_type)
            local new_sticky_pos = fg_info.new_sticky_pos
            --local sticky_pos = fg_info.sticky_pos
            self:recoverFreeSticky(new_sticky_pos, false)
            --self:recoverFreeSticky(sticky_pos, false)
        end
    end
end
----- skip end
-------------------- small slot start -------------------
function cls:changeRootNodeParent(...)
    self.mainView:changeRootNodeParent(...)
end

function cls:showSmallSlotUI()
    self:changeSpinBoard(SpinBoardType.SmallSlot)
end
function cls:smallSlotFixRet(ret)
    self.ctl.resultCache = {}
    local itemsList = table.copy(ret.item_list)
    local item_list_up = {}
    local item_list_down = {}

    for i = 1, 3 do
        item_list_up[i] = { math.random(102, 109) }
        item_list_down[i] = {}

        for j = 1, 6 do
            item_list_down[i][j] = math.random(102, 109)
        end
    end
    for k, v in pairs(itemsList) do

        local reelList = tool.tableClone(v)

        table.insert(reelList, 1, item_list_up[k][1]) -- 插入 第一条数据

        if self.isTurbo then
            for i = 1, (#item_list_down[k]) / 2 do
                -- 插入后面几条数据
                reelList[#reelList + 1] = item_list_down[k][i]
            end
        else
            for i = 1, #item_list_down[k] do
                -- 插入后面几条数据
                reelList[#reelList + 1] = item_list_down[k][i]
            end
        end
        table.insert(self.ctl.resultCache, reelList)
    end
end
function cls:getSmallSlotBaseBet()
    return 20000
end
-------------------- small slot end -------------------

return cls