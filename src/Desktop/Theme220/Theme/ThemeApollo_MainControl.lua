---@program src
---@description:  theme220
---@author: rwb  art:,math:dingyifeng,other:limo,
---@create: : 2020-11-23 10:15:16
---

require("Themes/base/ThemeBaseViewControl")
require("Themes/base/ThemeBaseTransitionControl")
local ThemeBaseDialog = require("Themes/base/ThemeBaseDialog")

local jpCtl = require (bole.getDesktopFilePath("Theme/ThemeApollo_JpControl")) 
local collectCtl = require (bole.getDesktopFilePath("Theme/ThemeApollo_CollectControl")) 
local mapCtl = require (bole.getDesktopFilePath("Theme/ThemeApollo_MapControl")) 
local fgCtl = require (bole.getDesktopFilePath("Theme/ThemeApollo_FreeControl")) 
local themeConfig = require (bole.getDesktopFilePath("Theme/ThemeApollo_Config")) 
local mainView = require (bole.getDesktopFilePath("Theme/ThemeApollo_MainView")) 
local parentClass = ThemeBaseViewControl
local cls = class("ThemeApollo_MainControl", parentClass)

local SpinBoardType = nil
local specialSymbol = nil
local fs_show_type
function cls:ctor(themeid, theScene)
    self.gameConfig = themeConfig
    SpinBoardType = themeConfig.SpinBoardType
    specialSymbol = themeConfig.special_symbol
    fs_show_type = themeConfig.fs_show_type
    self:initThemeConfig()
    local ret = parentClass.ctor(self, themeid, self.gameConfig.isPortrait, theScene)
    EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_SHOW, "theme220", self.touchShowCActivity, self)
    EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_HIDE, "theme220", self.touchHideCActivity, self)
    return ret
end
function cls:initThemeConfig()

    self:initSlotConfig()
    self.ThemeConfig = tool.tableClone(self.gameConfig.theme_config.reel_symbol)
    self.musicVolumeConfig = self.gameConfig.music_volume
    self.event_callback = {}
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


--@create mainView
function cls:initGameControlAndMainView(...)
    self.mainView = mainView.new(self)
    self.jpViewCtl = jpCtl.new(self)
    self.collectViewCtl = collectCtl.new(self)
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
    for music_key, music_path in pairs(themeConfig.audioList) do
        self.audio_list[music_key] = music_path
    end
end
function cls:getLoadMusicList()
    local loadMuscList = {}
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
        newBoardConfig[idx].colCnt = temp.colCnt
        newBoardConfig[idx].cellWidth = temp.cellWidth
        newBoardConfig[idx].cellHeight = temp.cellHeight
        newBoardConfig[idx].symbolCount = temp.symbolCount
        newBoardConfig[idx].reelConfig = newReelConfig
        newBoardConfig[idx].allow_over_range = temp.allow_over_range
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
function cls:playTransition(endCallBack, tType)
    local transition = ThemeBaseTransitionControl.new(self, endCallBack)
    local transition_config = self.gameConfig.transition_config
    local config = {}
    local endTm = transition_config[tType].onEnd
    config.path = "spine/" .. self.gameConfig.spine_path["transition_" .. tType]
    config.audio = "transition_" .. tType
    config.animName = "animation"
    config.endTime = endTm
    config.coverTime = transition_config[tType].onCover
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
    self:updateStickLeftWild()
    self:updateMapFreeGame()
    self:exitMapScene()
    self.stopControlData = false
    parentClass.onSpinStart(self)
end
function cls:onSpinStop(ret)
    --self:fixRet(ret)

    parentClass.onSpinStop(self, ret)
end
function cls:stopControl(stopRet, stopCallFun)
    self.item_list = nil
    self.item_list = stopRet["item_list"]
    self.isShowGoodJILI = false
    if stopRet["bonus_level"] then
        self.tipBetList = stopRet["bonus_level"]
    end
    self.stopControlData = true
    local extraDelay = self:checkNeedFreeExtraDelay()
    if extraDelay > 0 then
        self:laterCallBack(extraDelay, function()
            self:stopControlII(stopRet, stopCallFun, 1)
        end)
    else
        self:stopControlII(stopRet, stopCallFun, 0)
    end
    self:resetFreeExtraDelay()


end
function cls:stopControlII(stopRet, stopCallFun, step)
    if self.showSpinBoard == SpinBoardType.MapFreeSpin then
        self.mapWildInfo = stopRet.theme_info.map_wild_info
        self.mainView:setMaskNodeStatus(1, false, true)
        self.freeCtl:playMapFreeStopControl(stopRet, stopCallFun)
    else
        self:refreshDiskData(stopRet.theme_info)
        if self.showSpinBoard == SpinBoardType.Normal or self.showSpinBoard == SpinBoardType.FreeSpin then
            self.curDiskData = self:getCurDiskData()
        end
        self.new_item_list = self:getNewItemList(stopRet.item_list, self.curDiskData)
        if self:checkShowHugeAction(stopRet) then
            self.isShowGoodJILI = true
            self:laterCallBack(3, function()
                self.mainView:setMaskNodeStatus(1, false, true)
                stopCallFun()
            end)

            self:showHugeWinAction()
        else
            self.mainView:setMaskNodeStatus(1, false, true)
            stopCallFun()
        end
    end
end
function cls:overAutoSpeed()
    return true
end
function cls:checkShowHugeAction(stopRet)
    if stopRet.theme_info and stopRet.theme_info.anticipation_flag then
        return true
    end
    return false
    --local winCoins = stopRet["total_win"] == stopRet["base_win"] and stopRet["total_win"] or stopRet["base_win"]
    --local bet = self.ctl:getCurTotalBet()
    --local randomIndex = math.random(0, 9)
    --if randomIndex > 5 then
    --    return false
    --end
    --local isShow = winCoins / bet >= 10 and randomIndex <= 6
    --if winCoins / bet >= 10 then
    --    isShow = true
    --end
    --if not isShow then
    --    if stopRet.bonus_game and stopRet.bonus_game.fire_bonus then
    --        isShow = true
    --    end
    --end
    --if not isShow then
    --    if stopRet.free_game then
    --        isShow = true
    --    end
    --end
    --return isShow

end
function cls:showHugeWinAction()
    self.mainView:showHugeWinAction()
    --self:setMaskNodeStatus(true, true)
end

function cls:onReelFallBottom(pCol)
    self.reelStopMusicTagList[pCol] = true
    --if not self:checkPlaySymbolNotifyEffect(pCol) then
    self:dealMusic_PlayReelStopMusic(pCol)
    --end

    self:playSymbolNotifyEffect(pCol)
    self:dealMusic_StopReelNotifyMusic(pCol)
    self:stopReelNotifyEffect(pCol)
    self:onReelFallBottomJiLi(pCol)
    self:refreshAccumulate(pCol)
end
function cls:thisColHasStoped(pCol)
    if pCol <= 0 then
        return true
    end
    if self.reelStopMusicTagList[pCol] then
        return true
    end
    return false
end
function cls:needChageKey(pCol)
    if self:thisColHasStoped(pCol - 1) then
        if self:checkSpeedUpByScatter(pCol) then
            return 1
        end
        if self:checkSpeedUpByJp(pCol) then
            return 2
        end
    end
    return 0

end
function cls:onReelFallBottomJiLi(pCol)
    if self.isShowGoodJILI then
        return
    end
    local nextCol = pCol + 1

    if nextCol <= 5 then
        if self:checkSpeedUpByScatter(nextCol) then
            self:playFadeToMinVlomeMusic()
            self:onReelNotifyStopBeg(nextCol, specialSymbol.scatter)
        elseif self:checkSpeedUpByJp(nextCol) then
            self:playFadeToMinVlomeMusic()
            self:onReelNotifyStopBeg(nextCol, specialSymbol.JpWheel)
        end
    end
end
function cls:onReelFastFallBottom(pCol)
    self.reelStopMusicTagList[pCol] = true
    self.fastStopMusicTag = self.fastStopMusicTag or "allow_music"
    self:dealMusic_StopReelNotifyMusic(pCol)
    self:playSymbolNotifyEffect(pCol)
    self:refreshAccumulate(pCol)
    --if not self:checkPlaySymbolNotifyEffect(pCol) then
    self:dealMusic_PlayReelStopMusic(pCol)
    --end
    self:stopReelNotifyEffect(pCol)
end
function cls:onReelStop(col)
    --if col < 5 then
    --    return
    --end
    --if self.showSpinBoard == SpinBoardType.Normal or self.showSpinBoard == SpinBoardType.FreeSpin then
    --    if self.rets.bonus_game and self.rets.bonus_game.jp_wheel then
    --
    --    else
    --        local row1 = self:getJpRowByCol(1)
    --        if row1 > 0 then
    --            self.mainView:updateCellOffsetByJp(1, row1, self.item_list[1][row1])
    --        end
    --
    --        local row2 = self:getJpRowByCol(5)
    --        if row2 > 0 then
    --            self.mainView:updateCellOffsetByJp(5, row2, self.item_list[5][row2])
    --        end
    --    end
    --end
    --parentClass.onReelStop(self, col)
end
function cls:getJpRowByCol(col)
    for row = 1, 9 do
        local jackPotID = self.item_list[col][row]
        if jackPotID == specialSymbol.jpWheel then
            return row
        end
    end
    return 0
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
function cls:checkNeedNotify(pCol)
    local isSpeedUp = false
    if self.isShowGoodJILI then
        return false
    end
    if self:checkSpeedUpByScatter(pCol) then
        return true
    end
    if self:checkSpeedUpByJp(pCol) then
        return true
    end
    return isSpeedUp
end
function cls:checkSpeedUpByScatter(pCol)

    local isSpeedUp = false
    if self:checkSpeedUp(pCol) then
        local mini1 = self.specialItemConfig[specialSymbol.scatter].min_cnt
        if self.speedUpState[pCol][specialSymbol.scatter] and self.speedUpState[pCol][specialSymbol.scatter]["cnt"] >= mini1 then
            isSpeedUp = true
            return isSpeedUp
        end
    end
    return isSpeedUp
end

function cls:checkSpeedUpByJp(pCol)

    if pCol < 5 then
        return false
    end
    if self.showSpinBoard == SpinBoardType.Normal or self.showSpinBoard == SpinBoardType.FreeSpin then
        local jpRow = self:getJpRowByCol(1)
        if jpRow > 0 then
            return true
        end
    end
    return false
end
function cls:genSpecialSymbolState(rets)
    rets = rets or self.ctl.rets
    if not self.checkItemsState then
        self.checkItemsState = {}
        self.speedUpState = {}
        self.notifyState = {}
        self.scatterBGState = {}
        if self.showSpinBoard == SpinBoardType.Normal or self.showSpinBoard == SpinBoardType.FreeSpin then
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
                sumCnt = sumCnt + curColMaxCnt * (#self.spinLayer.spins - col + 1)
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
function cls:refreshAccumulate(pCol)
    self.mainView:refreshAccumulate(pCol)

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
function cls:playSymbolNotifyEffect(col, reelSymbolState)
    if not self.item_list then
        return
    end
    local find = false
    local extraAddCnt = self:getNormalStopAddCount()
    if self.notifyState and self.notifyState[col] then
        local notifyState = self.notifyState[col]
        for symbolKey, info in pairs(notifyState) do
            local itemInfo = info[1]
            local realRow = itemInfo[2]
            local needRow = realRow
            if not self.fastStopMusicTag then
                needRow = needRow + extraAddCnt
            end
            find = true

            local dropIndex = self:getDropIndex(col, specialSymbol.scatter)
            if dropIndex > 0 then
                self:playMusicByName("symbol_scatter" .. dropIndex)
            end
            local cell = self.mainView.spinLayer.spins[col]:getRetCell(needRow)
            self.mainView:playDropSpine(cell, symbolKey, false)
            self.mainView:changeSymbolAnimParent(cell, col, realRow)
        end
    end
    for row = 1, 9 do
        local symbolID = self.item_list[col][row]
        local needRow = row
        local realRow = row
        if not self.fastStopMusicTag then
            needRow = needRow + extraAddCnt
        end
        local firstKey = symbolID
        if firstKey > 100 then
            firstKey = (firstKey - firstKey % 100) / 100
        end
        if firstKey == specialSymbol.scatter and not find then

            local cell = self.spinLayer.spins[col]:getRetCell(needRow)
            self.mainView:playDropSpine(cell, specialSymbol.scatter, true)
            self.mainView:changeSymbolAnimParent(cell, col, realRow)
        end

        if firstKey == specialSymbol.jpWheel then
            local isOnlyLoop = true
            local cell = self.spinLayer.spins[col]:getRetCell(needRow)
            if col == 1 or (col == 5 and self:checkSpeedUpByJp(5)) then
                isOnlyLoop = false
            end
            if not isOnlyLoop then
                if col == 5 then
                    self:playMusicByName("symbol_bonus2")
                else
                    self:playMusicByName("symbol_bonus1")
                end
            end
            self.mainView:playDropSpine(cell, specialSymbol.jpWheel, isOnlyLoop)
            self.mainView:changeSymbolAnimParent(cell, col, realRow)
        end
        if firstKey == specialSymbol.goldWild then
            local cell = self.spinLayer.spins[col]:getRetCell(needRow)
            self.mainView:playDropSpine(cell, specialSymbol.goldWild, false, col, row)
            --self.mainView:changeSymbolAnimParent(cell, col, realRow)
            self:playMusicByOnce("wild_land")
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
------------结果特殊处理 end ----------
function cls:onThemeInfo(specialData, callFunc)
    if specialData.free_game and self.showSpinBoard == SpinBoardType.Normal then
        self.freeCtl:setFreeSpinInfo(specialData.free_game)
        if specialData.free_game.fg_type == 2 then
            self.rets.after_win_show = 1
        else
            self:setFreeCurDiskData(specialData.free_game)
        end
    end
    local collectDelay = self:dealFlyCollectItem(specialData)
    self:dealStickWild(callFunc, collectDelay)
end
function cls:after_win_show(rets)
    local old_after_win_show = 1
    if self.rets then
        old_after_win_show = self.rets.after_win_show
        self.rets.after_win_show = nil
    end
    if old_after_win_show == 1 then
        self:showMapSceneByFree(true, rets.free_game.free_spins)
        --else

    end
end
function cls:dealFlyCollectItem(specialData)
    if self.showSpinBoard ~= SpinBoardType.Normal then
        return 0
    end
    if self.mapInfo.map_points ~= specialData.theme_info.map_info.map_points then
        self.mapInfo = specialData.theme_info.map_info
        self.mapLevel = self.mapInfo.map_level
        self.collectViewCtl:dealFlyCollectItem(specialData)
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
--function cls:playFadeToDownVlomeMusic(endVoice)
--    local mvC = self.musicVolumeConfig
--    self.audioCtl:dealMusic_FadeLoopMusic(0.2, 1, endVoice)
--end
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
function cls:getMapInfo(...)
    --local data = {}
    --data.map
    --data.mapPoints = self.mapPoints or 0
    --data.mapLevel = self.mapLevel or 0
    --return data
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
function cls:resetMapProgress()
    self.mapPoints = 0
    self.mapInfo.map_points = 0
    if self.mapLevel == 100 then
        self.mapLevel = 0
        self.mapInfo.map_level = 0
    end
    self:updateCollectCount(self.mapPoints)
end
--------------------------------bet start----------------------------------
function cls:featureUnlockBtnClickEvent(_unLockType)
    if self.tipBetList and self.tipBetList[_unLockType] then
        self:setBet(self.tipBetList[_unLockType])
    end
end
--@setBet base class had
--@bet change
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
    if self.showBet and (self.showBet == theBet) then
        return
    end
    self:changStickWildByBet(theBet)

end
function cls:changStickWildByBet(bet)
    self.showBet = bet
    self.mainView:stopDrawAnimate()
    if self.showSpinBoard == SpinBoardType.Normal then
        self:clearCurPageStickWild()
        self.curDiskData = self:getCurDiskData(bet)
        self:stopSecondLoopMusic()
        self:initStickLeftWild()
        self:changeWildByBet()
    end
end
function cls:changeWildByBet()

    self.mainView:changeWildByBet()

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
        self.mapPoints = self.mapInfo.map_points
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
        self.notPlayEnterTheme = 1
        local collect_config = self.gameConfig.collect_config
        self:setFreeCurDiskData(data.free_game)
        if self.freeCtl:checkIsMapFree() and self.mapLevel == 0 then
            self.mapLevel = collect_config.maxMapLevel
            self.mapInfo.map_points = collect_config.max_point
            self.mapInfo.map_level = collect_config.maxMapLevel
            self.mapPoints = collect_config.max_point
        end
    end
    if self.freeCtl then
        self.freeCtl:dealFreeGameResumeRet(data)
    end


end
function cls:adjustTheme(data)
    self.loadFinish = true
    self:changeSpinBoard(SpinBoardType.Normal)
    local themeinfo = data.theme_info
    self:refreshDiskData(themeinfo)
    if not self:noFeatureLeft() then
        self:enableMapInfoBtn(false)
    else
        self:enableMapInfoBtn(true)
    end
    self:playEnterThemeMusic(0)
    self.mapPoints = self.mapPoints or 0
    self:updateCollectCount(self.mapPoints)

    self.curDiskData = self:getCurDiskData()
    if self.curDiskData then
        self:initStickLeftWild()
    end
end
function cls:playEnterThemeMusic(from)
    if from == self.notPlayEnterTheme then
        self:playMusicByName("enter_game")
        self.collectViewCtl:changeStoreTipState()
        self.notPlayEnterTheme = 3
    end
end

function cls:updateCollectCount(newCount, beforeCount, isAnimate)
    self.collectViewCtl:updateCollectCount(newCount, beforeCount, isAnimate)

end
-------------disk data start-------------
function cls:refreshDiskData(theme_info)
    if theme_info then
        if theme_info.all_disk_data then
            self.diskData = theme_info.all_disk_data
        end
        local data
        if not self.diskData then
            self.diskData = {}
        end
        if not self.freeDiskData then
            self.freeDiskData = {}
        end

        if self.showSpinBoard == SpinBoardType.Normal then
            data = theme_info.disk_data
        elseif self.showSpinBoard == SpinBoardType.FreeSpin then
            data = theme_info.free_disk_data
        end
        if data then
            local curBet = tostring(self.ctl:getCurBet()) -- *self.ctl.maxLine
            if data[curBet] then
                if self.showSpinBoard == SpinBoardType.FreeSpin then
                    self.freeDiskData[curBet] = data[curBet]
                elseif self.showSpinBoard == SpinBoardType.Normal then
                    self.diskData[curBet] = data[curBet]
                end
            end
        end
    end

end
function cls:getCurDiskData(Bet)
    local curBet = ""
    if Bet then
        curBet = tostring(Bet)
    else
        curBet = tostring(self.ctl:getCurBet())--*self.ctl.maxLine
    end
    local curDiskData
    if self.showSpinBoard == SpinBoardType.Normal then
        if not self.diskData then
            return
        end
        curDiskData = self.diskData[curBet]
    elseif self.showSpinBoard == SpinBoardType.FreeSpin then
        if not self.freeDiskData then
            return
        end
        curDiskData = self.freeDiskData[curBet]
    end
    return curDiskData
end
function cls:setFreeCurDiskData(free_game)
    if free_game.free_disk_data then
        self.freeDiskData = self.freeDiskData or {}
        local curBet = free_game.bet
        if not curBet then
            curBet = self:getCurBet()
        end
        self.freeDiskData[tostring(curBet)] = free_game.free_disk_data
    end
end
-------------disk data end-------------

function cls:changeSpinBoard(pType)
    self.mainView:clearAnimate()
    if pType == SpinBoardType.Normal then
        self.mainView:updateBaseUI()
    elseif pType == SpinBoardType.FreeSpin then

        self.mainView:updateFreeUI()
    elseif pType == SpinBoardType.MapFreeSpin then
        self.mainView:updateSuperFreeUI()
    elseif pType == SpinBoardType.JpWheel then
        self.mainView:updateReelWheelUI()
    end
    self.showSpinBoard = pType
    self.mainView:changeBg(pType)
end
---------------- bonus conection start------------------
function cls:playBonusAnimate(theGameData, isFinish)
    local delay = 2
    self.mainView:stopDrawAnimate()
    self:showAllStickLeftWild()
    self:stopAllLoopMusic()
    if not isFinish then
        self:playMusicByName("jp_trigger")
        self:stopSecondLoopMusic()
    end
    local item_list = self.item_list or theGameData.item_list
    if theGameData.jp_wheel and item_list then
        for col = 1, 5, 4 do
            for row = 1, 9 do
                local item = item_list[col][row]
                if item == specialSymbol.jpWheel then
                    self.mainView:playItemTriggerSpine(specialSymbol.jpWheel, col, row, true)
                elseif item > 100 and (item - item % 100) / 100 == specialSymbol.jpWheel then
                    self.mainView:playItemTriggerSpine(specialSymbol.jpWheel, col, row, true)
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
    -- if self:getCanTouchFeature() then
    --     self:toSpin()
    -- end
     self:footerCopySpinBtnEvent()
end

function cls:enterFreeSpin(isResume)
    if isResume then
        self:dealMusic_PlayFreeSpinLoopMusic()-- 切换背景音乐
    end
    self.mainView:showAllItem()
    self.playNormalLoopMusic = false --commonMusic: freespin背景音乐
end
function cls:showFreeSpinNode(count, sumCount, first)
    --self:resetPointBet()
    self:clearCurPageStickWild()
    if self.freeCtl:checkIsMapFree() then
        self:stopSecondLoopMusic()
        self:changeSpinBoard(SpinBoardType.MapFreeSpin)
        self.freeCtl:initMapFreeBoard()
    else
        self:changeSpinBoard(SpinBoardType.FreeSpin)
        self.curDiskData = self:getCurDiskData()
        if self.curDiskData then
            self:initStickLeftWild()
        end
    end
    self.mainView:resetGoldWildCount()
    self:changeBetByFreeStatus(true)
    parentClass.showFreeSpinNode(self, count, sumCount, first)
end
function cls:hideFreeSpinNode(...)
    self:clearCurPageStickWild()
    self:setMaskNodeStatus(1, false, false)
    if self.showSpinBoard == SpinBoardType.MapFreeSpin then
        self:resetMapProgress()
        self.freeCtl.freeSpeical = nil
    end
    self:changeBetByFreeStatus(false)
    self.freeCtl:clearFreeSpinInfo()
    self:changeSpinBoard(SpinBoardType.Normal)
    self:removePointBet()

    self.curDiskData = self:getCurDiskData()
    if self.curDiskData then
        self:initStickLeftWild()
    end
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
    self:stopDrawAnimate()
    self:showAllStickLeftWild()
    self:stopSecondLoopMusic()
    if self.freeCtl and self.freeCtl:checkIsMapFree() then
        return
    end
    if not theSpecials or (not theSpecials[specialSymbol.scatter]) or bole.getTableCount(theSpecials[specialSymbol.scatter]) == 0 then
        return 0
    end
    local delay = 0
    if enterType then
        delay = 2
        --if enterType == "more_free_spin" then
        --    self:playMusicByName("free_extra")
        --else
        self:playMusicByName("trigger_bell")
        --end
    end
    for col, rowTagList in pairs(theSpecials[specialSymbol.scatter]) do
        for row, tag in pairs(rowTagList) do
            self.mainView:playItemTriggerSpine(specialSymbol.scatter, col, row, true)
        end
    end
    return delay
end
function cls:checkNeedFreeExtraDelay()
    if self.freeCtl.needExtraStopTime and self.freeCtl.needExtraStopTime > 0 then
        local nowTime = os.time()
        if nowTime >= self.freeCtl.needExtraStopTime then
            return 0
        else
            return self.freeCtl.needExtraStopTime - nowTime
        end
    end
    return 0
end
function cls:resetFreeExtraDelay()
    self.freeCtl.needExtraStopTime = nil
end

function cls:updateMapFreeGame()
    if self.showSpinBoard == SpinBoardType.MapFreeSpin then
        if self.freeCtl:checkIsMovingWild() then
            self.mainView:stopDrawAnimate()
            self.freeCtl:playMoveWildAppear(2)
        elseif self.freeCtl:checkIsStickWild() then
            self.mainView:stopDrawAnimate()
            self.freeCtl:playStickWildAppear()
        else
        end
    end
end
--------------------- map node
function cls:showMapScene()
    self.mapViewCtl:showMapScene(false, true)
end
function cls:exitMapScene(byBonus)
    self.mapViewCtl:exitMapScene(byBonus)
end
function cls:showMapSceneByBonus(isAni)
    self.mapViewCtl:showMapScene(1, isAni)
end
function cls:showMapSceneByFree(isAni, new_cnt)
    AudioControl:stopGroupAudio("music")

    self.node:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(2),
                    cc.CallFunc:create(
                            function()
                                self.mapViewCtl:showMapScene(2, isAni, new_cnt)
                            end
                    ),
                    cc.DelayTime:create(1),
                    cc.CallFunc:create(
                            function()
                                self:getMapViewCtl():mapForward()
                            end),
                    cc.DelayTime:create(20 / 30),
                    cc.CallFunc:create(function()
                        self:getMapViewCtl():mapItemLighten()
                    end),
                    cc.DelayTime:create(1),
                    cc.CallFunc:create(function()
                        self:exitMapScene(true, true)
                    end),
                    cc.DelayTime:create(15 / 30),
                    cc.CallFunc:create(function()
                        self:handleResult()
                    end
                    )
            )
    )
end
function cls:onExit()
    EventCenter:removeEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_SHOW, "theme220")
    EventCenter:removeEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_HIDE, "theme220")
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
function cls:changeBetByFreeStatus(isEnter)
    if isEnter then
        if self.freeCtl:checkIsMapFree() then
            self.footer:changeFreeSpinLayout3()
        end
    else
        if self.freeCtl:checkIsMapFree() then
            self.footer:changeNormalLayout2(true, true)
        else
            self.footer:changeFreeSpinLayout()
        end

    end
end
function cls:changeBetByBonus(isEnter)
    if isEnter then
        if self.bonus and self.bonus:checkIsSuper() then
            self.footer:isShowTotalBetLayout2(false, true)
        end
    else
        if self.bonus and self.bonus:checkIsSuper() then
            self.footer:changeNormalLayout2(false, true)
        end

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

---------------- free conection end  ------------------
------------------- stick wild start ------------------
function cls:getNewItemList(item_list, map_wild_info)
    if not map_wild_info or #map_wild_info == 0 then
        return item_list
    end
    local item_list = tool.tableClone(item_list)
    local boomAll = self:checkNeedBoomAll()
    for key = 1, #self.curDiskData do
        local info = self.curDiskData[key]
        local col = info[1][1] + 1
        local row = info[1][2] + 1
        local leftCount = info[2]
        local boomType = info[3]
        if boomAll then
            item_list[col][row] = specialSymbol.wild
        else
            item_list[col][row] = specialSymbol.goldWild
        end
        if boomType and boomType > 0 then
            local boomPath = self:getBoomPath(boomType, col, row)
            for key = 1, #boomPath do
                local items = boomPath[key]
                for key2 = 1, #items do
                    local offsetItem = items[key2]
                    local realCol = offsetItem[1] + col
                    local realRow = offsetItem[2] + row
                    if self:checkIsValibleColAndRow(realCol, realRow) then
                        item_list[realCol][realRow] = specialSymbol.wild
                    end
                end
            end
        end
    end
    return item_list
end
function cls:getBoomPath(path_type, col, row)
    local stick_wild_config = self:getGameConfig().stick_wild_config
    local realBoomType = path_type
    if path_type == 20 and row == 1 then
        realBoomType = 200
    end
    if path_type == 20 and row == 9 then
        realBoomType = 201
    end
    return stick_wild_config.boom_path[realBoomType]

end
function cls:checkNeedBoomAll()
    if not self.curDiskData then
        return false
    end
    for key = 1, #self.curDiskData do
        local info = self.curDiskData[key]
        local leftCount = info[2]
        local boomType = info[3]
        if leftCount == 0 and boomType > 0 then
            return true
        end
    end
    return false
end
function cls:checkIsValibleColAndRow(realCol, realRow)
    if realCol > 0 and realCol <= 5 then
        if realRow > 0 and realRow <= 9 then
            return true
        end
    end
    return false

end
function cls:getRealItem(col, row)
    if self.showSpinBoard == SpinBoardType.MapFreeSpin then
        return self.freeCtl:getFreeReelItem(col, row)
    else
        if self.new_item_list and self.new_item_list[col] and self.new_item_list[col][row] then
            return self.new_item_list[col][row]
        end
        return nil
    end

end
function cls:checkHaveStickNode(col, row)
    if self.mainView.curStickWildList and self.mainView.curStickWildList[col] and self.mainView.curStickWildList[col][row] then
        return true
    end
    return false

end
function cls:initStickLeftWild()
    if self:checkNeedAddWild() then
        for key = 1, #self.curDiskData do
            local stickItem = self.curDiskData[key]
            local leftCount = stickItem[2]
            local boomType = stickItem[3]
            if leftCount > 0 and boomType == 0 then
                self:createStickWildAndNum(stickItem, 0, true)
            end
        end
    end
end
function cls:checkNeedAddWild()
    if not self.curDiskData or #self.curDiskData == 0 then
        return false
    end
    for key = 1, #self.curDiskData do
        local stickItem = self.curDiskData[key]
        local leftCount = stickItem[2]
        local boomType = stickItem[3]
        if boomType and boomType > 0 then
            return false
        end
    end
    return true

end
function cls:clearCurPageStickWild()
    self.curDiskData = nil
    self.mainView:clearCurPageStickWild()
end
function cls:updateStickLeftWild()
    if self.showSpinBoard == SpinBoardType.FreeSpin or self.showSpinBoard == SpinBoardType.Normal then
        self.mainView:updateStickLeftWild()
    else
        self.mainView:resetGoldWildCount()
    end
end
function cls:showAllStickLeftWild()
    self.mainView:showAllStickLeftWild()
end
function cls:addStickWildByRoll()
    local find = false
    if self.curDiskData then
        for key = 1, #self.curDiskData do
            local _stickItem = self.curDiskData[key]
            local col = _stickItem[1][1] + 1
            local row = _stickItem[1][2] + 1
            if self.mainView.haveGoldWildList and self.mainView.haveGoldWildList[col] >= 2 then

            else
                if not self:checkIsCreateStickWild(col, row) then
                    self:createStickWildAndNum(_stickItem, 2, true)
                    find = true
                end
            end
        end
        if find then

            self:playMusicByName("icon_appear")
            return 0.2
        end
    end
    return 0
end
function cls:checkIsCreateStickWild(col, row)

    return self.mainView:checkIsCreateStickWild(col, row)

end
function cls:createStickWildAndNum(...)

    self.mainView:createStickWildAndNum(...)
end

function cls:dealStickWild(callFunc, collectDelay)
    if self.showSpinBoard == SpinBoardType.Normal or self.showSpinBoard == SpinBoardType.FreeSpin then
        local extraDelay = self:addStickWildByRoll()
        local boomDelay = self:dealBoomItems(collectDelay + extraDelay)
        if boomDelay > 0 then
            self:laterCallBack(boomDelay + extraDelay + collectDelay, callFunc)
        elseif extraDelay > 0 then
            self:laterCallBack(extraDelay + collectDelay, callFunc)
        else
            callFunc()
        end
    else
        local boomDelay = self:dealMapBoomItems()
        if boomDelay > 0 then
            self:laterCallBack(boomDelay, callFunc)
        else
            callFunc()
        end
    end
end
function cls:getBoomDelay()
    local needBoom = false
    local haveBeBoomed = false
    if self.curDiskData and #self.curDiskData > 0 then
        for key = 1, #self.curDiskData do
            local info = self.curDiskData[key]
            if info[2] == 0 then
                needBoom = true
            end
            if info[2] > 0 then
                haveBeBoomed = true
            end
        end
    end
    local delayTm = 0
    if needBoom then
        delayTm = 2
        if haveBeBoomed then
            delayTm = delayTm + 1
        end
    end
    return delayTm
end
function cls:getDropFireNode()
    if not self.curDiskData then
        return nil
    end
    for key = 1, #self.curDiskData do
        local info = self.curDiskData[key]
        local leftCount = info[2]
        local boomType = info[3]
        local col = info[1][1] + 1
        local row = info[1][2] + 1
        if self.mainView.haveGoldWildList and self.mainView.haveGoldWildList[col] >= 2 then
            if boomType > 0 then
                if not self.mainView:checkIsCreateStickWild(col, row) then
                    return info
                end
            end
        end
    end
    return nil
end
function cls:dealBoomItems(beforeDelay)
    beforeDelay = beforeDelay or 0
    local leftBoomList = {}
    local firstBoomList = {}
    local toNormalList = {}

    local needBoomAll = self:checkNeedBoomAll()
    if not self.curDiskData then
        return 0
    end
    local dropFireNode
    if needBoomAll then
        dropFireNode = self:getDropFireNode()
    end
    for key = 1, #self.curDiskData do
        local info = self.curDiskData[key]
        local leftCount = info[2]

        if leftCount == 0 and info[3] == 0 then
            table.insert(toNormalList, info) --abandon
        elseif needBoomAll then
            if dropFireNode then
                if #firstBoomList == 0 then
                    table.insert(firstBoomList, dropFireNode)
                end
                local centerCol = dropFireNode[1][1]
                local centerRow = dropFireNode[1][2]
                if info[1][1] ~= centerCol or info[1][2] ~= centerRow then
                    table.insert(leftBoomList, info)
                end
            else
                if #firstBoomList == 0 and leftCount == 0 then
                    table.insert(firstBoomList, info)
                else
                    table.insert(leftBoomList, info)
                end
            end
        end
    end
    local actions = {}
    local totalDelay = 0
    if beforeDelay > 0 then
        local a1 = cc.DelayTime:create(beforeDelay)
        table.insert(actions, a1)
    end
    if #toNormalList > 0 then
        self:playBoomItems(toNormalList, 0)
        local totalCount = 1
        local a1 = cc.DelayTime:create(totalCount)
        table.insert(actions, a1)
        totalDelay = totalCount
    end
    if #firstBoomList > 0 then
        totalDelay = 1
        local fristStepType = 1
        if dropFireNode then
            fristStepType = 3
        end
        local a2 = cc.CallFunc:create(function()
            self:stopSecondLoopMusic()
            self:playBoomItems(firstBoomList, fristStepType)
        end)
        table.insert(actions, a2)
        local boomType = firstBoomList[1][3]
        local col = firstBoomList[1][1][1] + 1
        local row = firstBoomList[1][1][2] + 1
        local delatTm = self:getBoomTmByType(boomType, col, row)
        local a2_1 = cc.DelayTime:create(delatTm * 0.15 + 0.5)
        table.insert(actions, a2_1)

        table.insert(actions, cc.DelayTime:create(18 / 30))
        local firstDelay = delatTm * 0.2 + 1
        totalDelay = totalDelay + firstDelay + 0.5
        if #leftBoomList > 0 then
            local a2 = cc.CallFunc:create(function()
                self:flashingNextBoomItems(leftBoomList)
            end)
            table.insert(actions, a2)
            local a3 = cc.DelayTime:create(43 / 30)
            table.insert(actions, a3)
            local a4 = cc.CallFunc:create(function()
                self:playBoomItems(leftBoomList, 2)
            end)
            local maxDelay = self:getMaxBoomDelay(leftBoomList)
            local leftDelay = maxDelay * 0.2 + 0.5
            table.insert(actions, a4)
            table.insert(actions, cc.DelayTime:create(leftDelay))
            totalDelay = totalDelay + leftDelay + 0.5
        end
        local a5 = cc.CallFunc:create(function()
            self.mainView:changeFireSymbolToWild()
        end)
        table.insert(actions, a5)
        table.insert(actions, cc.DelayTime:create(0.5))
    end
    if #actions > 0 then
        self.node:runAction(cc.Sequence:create(unpack(actions)))
    end
    return totalDelay
end
function cls:dealMapBoomItems()
    local boomList = self.mapWildInfo
    if boomList and #boomList > 0 then
        self:playBoomItems(boomList, 2)
        local max = self:getMaxBoomDelay(boomList)
        local boomDelay = max * 0.2 + 0.5
        self:laterCallBack(max * 0.2 + 0.5, function()
            self.mainView:changeFireSymbolToWild()
        end)
        return boomDelay + 0.5
    else
        return 0
    end
end
function cls:hideMapFreeWild(...)
    self.freeCtl:hideMapFreeWild(...)
end

function cls:getBoomTmByType(boomType, col, row)

    --local stick_wild_config = self:getGameConfig().stick_wild_config
    --local boomPath = stick_wild_config.boom_path[boomType]
    local boomPath = self:getBoomPath(boomType, col, row)
    local count = 0
    if boomPath then
        count = #boomPath
    else
    end
    return count or 0
end
function cls:getMaxBoomDelay(boomLists)
    local max = 0
    for key = 1, #boomLists do
        local info = boomLists[key]
        local boomType = info[3]
        local col = info[1][1] + 1
        local row = info[1][2] + 1
        local delay = self:getBoomTmByType(boomType, col, row)
        max = max < delay and delay or max
    end
    return max
end
function cls:playBoomItems(boomLists, step)
    for key = 1, #boomLists do
        local info = boomLists[key]
        local col = info[1][1] + 1
        local row = info[1][2] + 1
        local boomType = info[3]
        self.mainView:playBoomCenterItem(col, row, boomType, step)
    end
end

function cls:flashingNextBoomItems(boomLists)
    self:playMusicByName("wild_success2")
    for key = 1, #boomLists do
        local info = boomLists[key]
        local col = info[1][1] + 1
        local row = info[1][2] + 1
        --local boomType = info[3]

        --local delayTm = key - 1
        --self:laterCallBack(delayTm, function()
        self.mainView:flashingBoomItem(col, row, 2)
        --end)

    end
end
function cls:needRetainDropGold(col, row)
    if self.showSpinBoard == SpinBoardType.FreeSpin or self.showSpinBoard == SpinBoardType.Normal then
        if self.mainView:checkIsCreateStickWild(col, row) then
            return false
        else
            return true
        end
    elseif self.showSpinBoard == SpinBoardType.MapFreeSpin then
        if self.freeCtl:checkIsHaveGoldWild(col, row) then
            return false
        else
            return true
        end
    end
    return false
end

------------------- stick wild end ------------------
------------------- map free start ------------------

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
    self:stopSecondLoopMusic()
    local end_event = theData.click_event
    theData.click_event = function()
        if end_event then
            end_event()
        end
        if sType == fs_show_type.start or sType == fs_show_type.collect then
            self:playMusicByName("common_click")
        end
        self.mainView:setMaskNodeStatus(2, false, true)
    end
    local config = {}
    config["csb_file"] = self:getCsbPath("dialog_" .. dialogType)
    config["frame_config"] = {
        ["start"]   = { nil, 1, nil, 2 },
        ["more"]    = { nil, 3, nil, 2 },
        ["collect"] = { nil, 1, nil, 2 },
    }
    config.dialog_config = themeConfig.dialog_config[dialogType][sType]
    local theDialog = ThemeBaseDialog.new(self.ctl, config)
    if sType == fs_show_type.start then
        theDialog:showStart(theData)
    elseif sType == fs_show_type.more then
        theDialog:showMore(theData)
    elseif sType == fs_show_type.collect then
        theDialog:showCollect(theData)
    end
    self.mainView:setMaskNodeStatus(2, true, true)
    return theDialog
end
function cls:setMaskNodeStatus(...)
    self.mainView:setMaskNodeStatus(...)
end
function cls:getFreeReel()
    local data = self.ctl.theme_reels["free_reel"]
    if self.freeCtl:checkIsMapFree() then
        data = self.ctl.theme_reels["map_reel"]
    end
    return data
end
function cls:dealMusic_StopReelNotifyMusic(pCol)
    if not pCol then
        return
    end
    local index = pCol - 2
    if index >= 1 and index <= 3 then
        self:stopMusicByName("reel_notify_free" .. index)
    end
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
function cls:playSecondLoopMusic()
    --if self.showSpinBoard == SpinBoardType.FreeSpin then
    --    self:playMusicByName("wild_stick_2", true, true)
    --else
    --    self:playMusicByName("wild_stick_1", true, true)
    --end
end
function cls:stopSecondLoopMusic()
    --local file = self.audio_list.wild_stick
    --self:stopMusicByName("wild_stick_2")
    --self:stopMusicByName("wild_stick_1")
end
function cls:dealMusic_PlayFreeSpinLoopMusic()

    local name = self.audio_list.free_background
    if self.freeCtl:checkIsMapFree() then
        name = self.audio_list.super_background
    end
    self:playLoopMusic(name)
    self.playNormalLoopMusic = false
end
return cls