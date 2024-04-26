-- @Author: xiongmeng
-- @Date:   2020-11-10 11:28:10
-- @Last Modified by:   xiongmeng
-- @Last Modified time: 2020-12-03 11:45:57
local parentClass = ThemeBaseViewControl
local cls = class("MightyC_MainViewControl", parentClass)
local ThemeBaseDialog = require "Themes/base/ThemeBaseDialog"

local themeConfig = require (bole.getDesktopFilePath("Theme/MightyC_Config")) 
local mainView = require (bole.getDesktopFilePath("Theme/MightyC_MainView")) 
local jpViewCtl = require (bole.getDesktopFilePath("Theme/MightyC_JpViewControl")) 
local collectCtl = require (bole.getDesktopFilePath("Theme/MightyC_CollectViewControl")) 
local freeCtl = require (bole.getDesktopFilePath("Theme/MightyC_FreeViewControl")) 
local respinCtl = require (bole.getDesktopFilePath("Theme/Respin/MightyC_RespinViewControl")) 

local fs_show_type 
local SpinBoardType = nil
function cls:ctor( themeid, theScene )
	self.gameConfig = themeConfig
	self.baseBet = self.gameConfig.baseBet
	self.UnderPressure = self.gameConfig.underPressure
    self.themeResourceId = themeid
    fs_show_type = self.gameConfig.fs_show_type
    SpinBoardType = self.gameConfig.SpinBoardType
	self:setGameConfig()
	local ret = parentClass.ctor(self, themeid, self.gameConfig.isPortrait, theScene)
	return ret
end

function cls:configAudioList()
    parentClass.configAudioList(self)
    for music_key, music_path in pairs(self.gameConfig.audioList) do
        self.audio_list[music_key] = music_path
    end
    -- tool.mergeTable(self.audio_win_list, tool.tableClone(self.gameConfig.peopel_rollup_list))
end

function cls:getLoadMusicList()
    local loadMuscList = {}
    table.insert(loadMuscList, self.audio_list.base_welcome)
    for music_key, music_path in pairs(self.audio_list) do
        table.insert(loadMuscList, music_path)
    end
    return loadMuscList
end

function cls:playTransition( endCallBack, tType, overCallBack)
    local transition = ThemeBaseTransitionControl.new(self, endCallBack, overCallBack)
    local transition_config = self.gameConfig.transition_config
    local config = {}
    local endTm = transition_config[tType].onEnd
    config.path = "spine/" .. self.gameConfig.spine_path[transition_config[tType].spine]
    config.audio = transition_config[tType].music
    config.animName = transition_config[tType].animName
    config.endTime = endTm
    config.coverTime = transition_config[tType].onCover
    transition:play(config)
    self:playFadeToMinVlomeMusic()
end

--@create mainView
function cls:initGameControlAndMainView( ... )
    self.mainView = mainView.new(self)
    self.jpViewCtl = jpViewCtl.new(self)
    self.collectViewCtl = collectCtl.new(self)
    self.freeCtl = freeCtl.new(self)
    self.respinCtl = respinCtl.new(self)
	parentClass.initGameControlAndMainView(self)
end

--@symbol ani
function cls:drawLinesThemeAnimate( lines, layer, rets, specials )
	local timeList = {3, 3}
	self.mainView:drawLinesThemeAnimate(lines, layer, rets, specials,timeList)
end

---@param enable /true:可点击/false:不可点击
function cls:setFooterBtnsEnable(enable)
    if not enable then
        self.footer:displayAutoplayInterface(false)
    end
    self.footer:setSpinButtonState(not enable)
    self.footer:enableOtherBtns(enable)
end
function cls:finshSpin( ... )
    if (not self:isInFG()) and (not self.autoSpin) and (not self.bonus) then
        self:enableMapInfoBtn(true)
    end
end
function cls:enableMapInfoBtn( enable )
    self:getRespinViewCtl():setRespinTipEnabled(enable)
    self.isCanFeatureClick = enable
end
function cls:refreshNotEnoughMoney(enable)
    self:enableMapInfoBtn(true)
end
function cls:getCanTouchFeature( ... )
    return self.isCanFeatureClick
end
function cls:setGameConfig( ... )
	self.ThemeConfig = tool.tableClone(self.gameConfig.theme_config.reel_symbol)
    self.musicVolumeConfig = self.gameConfig.music_volume
    self.LowSymbolList = self.gameConfig.symbol_config.low_symbol_list
    self.majorSymbolList = self.gameConfig.symbol_config.major_symbol_list
end
function cls:updateSpecailReel(pCol)
    -- if self:getHitWinBonusStatus() then 
    --     self.currentReels = self.currentReels or {}
    --     self.currentReels[pCol] = table.copy(self.theme_reels["coins_reel"])
    -- end
end
function cls:resetCurrentReels( isFree ,isBouns, isSuper) -- 重置freespin 的滚轴
	if not self.theme_reels then
		return
	end
	if (self.freeCtl and self.freeCtl:isFGEnd()) and not isFree then
		self.currentReels = self:getMainReel() or table.copy(self.theme_reels["main_reel"]) 
	else
		self.currentReels = self:getFreeReel() or table.copy(self.theme_reels["main_reel"])
	end
	if isBouns then 
		self.currentReels = self:getBonusReel() or table.copy(self.theme_reels["respin_reel"])
	end
    if isSuper then
        self.currentReels = self:getSuperBonusReel() or table.copy(self.theme_reels["respin_reel1"])
    end
	if not self.currentReels then return end
	self.currentReelsIndex = {}
	for col,reelDataList in pairs(self.currentReels) do
		local isSingleReel = false
		self.currentReelsIndex[col] = self:getReelRandomIndex(col, reelDataList, isSingleReel)
	end
end

function cls:getGameConfig( ... )
	return self.gameConfig
end
function cls:getHighDiamondSymbol(item)
    if item then
        item = item % 100
        if item then  
            if item >= 30 then 
                return 35-item
            end
            return false
        end
    end
    return false
end
function cls:getSymbolCoins(multi)
    multi = multi or 0
	local bet = self:getCurTotalBet() or 0
	return bet * multi
end
function cls:getMusicVConfig( ... )
    return self.musicVolumeConfig
end
function cls:getBoardConfig( ... )
	if self.boardConfigList then
        return self.boardConfigList
    end
    local borderConfig = self.ThemeConfig["boardConfig"]
    local newBoardConfig = {}
    for idx = 1, #borderConfig do
        newBoardConfig[idx] = {}
        local temp = borderConfig[idx]
        local newReelConfig = {}
        if temp.row_single then
            for i = 1, temp.colCnt do
                local oneConfig = {}
                local boardconfig = temp.reelConfig[1]

                local realRow = (i - 1) % 5
                local realCol = math.floor((i - 1) / 5) + 1
                local baseX = realRow * (temp["cellWidth"] + temp["lineWidth"]) + boardconfig["base_pos"].x
                local baseY = (3 - realCol) * (temp["cellHeight"] + temp["lineHeight"]) + boardconfig["base_pos"].y
                oneConfig["base_pos"] = cc.p(baseX, baseY)
                oneConfig["symbolCount"] = temp["symbolCount"]
                oneConfig["cellWidth"] = temp["cellWidth"]
                oneConfig["cellHeight"] = temp["cellHeight"]
                oneConfig["lineWidth"] = temp["lineWidth"]
                table.insert(newReelConfig, oneConfig)
            end
        else
            for cnt, posList in pairs(temp.reelConfig) do
                local colCnt = temp.colCnt
                for col = 1, colCnt do
                    local oneConfig = {}
                    local posx = (col - 1) * (temp["cellWidth"] + temp["lineWidth"]) + posList["base_pos"].x
                    local posy = posList["base_pos"].y
                    oneConfig["base_pos"] = cc.p(posx, posy)
                    oneConfig["symbolCount"] = temp["symbolCount"]
                    oneConfig["cellWidth"] = temp["cellWidth"]
                    oneConfig["cellHeight"] = temp["cellHeight"]
                    table.insert(newReelConfig, oneConfig)
                end
            end
        end
        newBoardConfig[idx] = tool.tableClone(temp)
        newBoardConfig[idx].reelConfig = newReelConfig
    end
    self.boardConfigList = newBoardConfig
    return self.boardConfigList
end
function cls:getThemeJackpotConfig()
    local jackpot_config_list = self.gameConfig.jackpotCtlConfig
    return jackpot_config_list
end

function cls:isLowSymbol( item )
    if not item then return false end
    if self.LowSymbolList[item] then
        return true
    end
    return false
end
function cls:getMajorSymbol()
    local m1 = 2
    if self.majorSymbolList then
        return self.majorSymbolList[math.random(1, #self.majorSymbolList)]
    end
    return m1
end

function cls:getSpinColStartActionSpecial( spinAction, pCol)
    if self:getRespinStatus() and self:getLockedReels(pCol) then
        spinAction.locked = true
    end
end
function cls:getStopConfig(ret, spinTag, interval)
    local stopConfig = {}
    if self:getRespinStatus() then
        for col = 1, 15 do
            local tempCol = (col - 1) % 5 + 1
            local theAction = self:getSpinColStopAction(ret["theme_info"], tempCol, interval)
            table.insert(stopConfig, { col, theAction })
        end
    else
        for col = 1, #self.spinLayer.spins do
            local theAction = self:getSpinColStopAction(ret["theme_info"], col, interval)
            table.insert(stopConfig, { col, theAction })
        end
    end
    return stopConfig
end
function cls:getSpinColStopAction(themeInfoData, pCol, interval)
	local _reelSpinConfig = self.gameConfig.reel_spin_config
	if pCol == 1 then -- 同时下落的时候 进行的 延迟 重置
        self.DelayStopTime = 0
    end
    self:updateSpecailReel(pCol)
	local checkNotifyTag   = self:checkNeedNotify(pCol)
	if not self:checkSpecialFeature(themeInfoData) and checkNotifyTag then
		self.DelayStopTime = self.DelayStopTime + _reelSpinConfig.extraReelTime
	end
	local spinAction = {}
	spinAction.actions = {}

    local temp = interval - _reelSpinConfig.speedUpTime - _reelSpinConfig.upBounceTime
    local timeleft = _reelSpinConfig.rotateTime - temp > 0 and _reelSpinConfig.rotateTime - temp or 0
	
    local _stopDelay = _reelSpinConfig.stopDelay
	local _downBonusT = _reelSpinConfig.downBounceTime

    spinAction.stopDelay = timeleft+(pCol-1)*_stopDelay + self.DelayStopTime
    self.ExtraStopCD = _reelSpinConfig.spinMinCD - temp > 0 and _reelSpinConfig.spinMinCD - temp or 0

	spinAction.maxSpeed = _reelSpinConfig.maxSpeed
	spinAction.speedDownTime = _reelSpinConfig.speedDownTime
    if self.isTurbo and not self:overAutoSpeed() then
        spinAction.speedDownTime = spinAction.speedDownTime * 7/10
    end
	spinAction.downBounce = _reelSpinConfig.downBounce
	spinAction.downBounceMaxSpeed = _reelSpinConfig.downBounceMaxSpeed
	spinAction.downBounceTime = _downBonusT
	spinAction.stopType = 1
	return spinAction
end

function cls:checkSpecialFeature( themeInfo)
    if themeInfo and themeInfo["special_type"] and (themeInfo["special_type"] == 1) then
        return true
    end
    return false
end

------------reel start----------
-- 用于影藏spin按钮的显示
function cls:isAutoSpinNodeShow( ... )
    local show = false
    if self.footer and self.footer.autoSpinNode then
        show = self.footer.autoSpinNode:isVisible()
    end
    return show
end
function cls:onSpinStart( ... )
    if self.freeCtl then
        self.freeCtl:onSpinStart()
    end
    if self.collectViewCtl then 
        self.collectViewCtl:onSpinStart()
    end
    if self.respinCtl then
        self.respinCtl:onSpinStart()
    end
    self.mainView:playWelComeClose()
    self:enableMapInfoBtn(false)
    parentClass.onSpinStart(self)
end

function cls:onSpinStop( ret )
    parentClass.onSpinStop(self, ret)
end
function cls:stopControl( stopRet, stopCallFun )
    local delay = 0
    self.item_list = nil
    self.item_list = stopRet["item_list"]
    self.currentHitBonus = nil
    self.currentSpecailType = nil
    self.mainView.allScatterAniList = {}
    self.specailSNM = nil
    self.hitNudgeIndex = nil
    if stopRet["bonus_level"] then
        self.tipBetList = stopRet["bonus_level"]
        self.bonusLevelChange = true
    end
    if self.collectViewCtl then
        self.collectViewCtl:collectStopCtl(stopRet)
    end
    if self.respinCtl then
        self.respinCtl:collectRespinCtl(stopRet)
    end
    local delay = 0
    if self:checkSpecialFeature(stopRet["theme_info"]) then
        self.currentSpecailType = true
        self.mainView:playBoardJili()
        delay = 100/30
    end
    self:laterCallBack(delay, function ()
        stopCallFun()
    end)
end

function cls:checkSpecialFeature( themeInfo)
    if themeInfo and themeInfo["specical_type"] and (themeInfo["specical_type"] == 1) then
        return true
    end
    return false
end

function cls:onReelFallBottom( pCol )
    self.reelStopMusicTagList[pCol] = true
    self:playColLandEffect(pCol)
    if self:checkSpeedUp(pCol + 1) and (not self:getRespinStatus() )then
        self:onReelNotifyStopBeg(pCol +1)
    end
end
function cls:onReelFastFallBottom( pCol )
    self.reelStopMusicTagList[pCol] = true
    self.fastStopMusicTag = self.fastStopMusicTag or "allow_music"
    self:playColLandEffect(pCol)
    self.mainView:playScatterRecoverJili()
end

function cls:dealMusic_StopReelNotifyMusic()
    if not self.playR1Col then return end
	self.audioCtl:stopMusic(self.audio_list.reel_notify_scatter1,true)
	self.audioCtl:stopMusic(self.audio_list.reel_notify_scatter2,true)
	self.audioCtl:stopMusic(self.audio_list.reel_notify_scatter3,true)
	self.audioCtl:stopMusic(self.audio_list.reel_notify_bonus,true)
    self.playR1Col = nil
end
function cls:onReelStop( col )
    parentClass.onReelStop(self, col)
end
function cls:onAllReelStop(  )
    if self:getRespinStatus() then
        self.respinCtl:onAllReelStop()
    else
        if self.freeCtl then
            self.freeCtl:onAllReelStop()
        end
        self.mainView:playScatterRecoverJili()
        parentClass.onAllReelStop(self)
    end
end
-------- 棋盘开始上升 ---------
function cls:checkSpeedUp( checkCol )
    local isNeedSpeedUp = false
    if not self.specialSpeed and self.speedUpState and self.speedUpState[checkCol] and bole.getTableCount(self.speedUpState[checkCol])>0 then
        isNeedSpeedUp = true
    end
    if self.currentSpecailType then
        isNeedSpeedUp = false
    end
    return isNeedSpeedUp
end
function cls:checkNeedNotify( pCol )
    return self:checkSpeedUp(pCol)
end
function cls:checkSpecailNotify(pCol)
    local specialJiliType = { 
        self.gameConfig.special_symbol.scatter,
        self.gameConfig.special_symbol.bonus1
    }
    local isSpeedUp = false
    for key, val in ipairs(specialJiliType) do
        if self.speedUpState and self.speedUpState[pCol] and self.speedUpState[pCol][val] then
            return val
        end
    end
    return isSpeedUp
end

function cls:genSpecialSymbolState( rets )
    rets = rets or self.ctl.rets
    if not self.checkItemsState then
        self.checkItemsState = {}
        self.speedUpState    = {}
        self.notifyState     = {}
        self.scatterBGState = {}
        if not self:getRespinStatus() then
            self:genSpecialSymbolStateInNormal(rets)
        end
    end
end
function cls:genSpecialSymbolStateInNormal( rets )
    local cItemList   = rets.item_list
    local checkConfig = self.specialItemConfig
    local baseColCnt  = 5
    local bonus1 = 12
    local bonus2 = 13
    local bonusId1 = 120
    local bonusId2 = 220
    for itemKey,theItemConfig in pairs(checkConfig) do
        local itemType     = theItemConfig["type"]
        local itemCnt      = 0
        if itemType then
            for col=1, baseColCnt do
                local colItemList  = cItemList[col]
                local colRowCnt    = self.spinLayer.spins[col].row
                local curColMaxCnt = theItemConfig["col_set"][col] or colRowCnt
                local isGetFeature = false
                if itemCnt >= theItemConfig["min_cnt"] then
                    isGetFeature = true
                end
                local willGetFeatureInCol = false
                if curColMaxCnt>0 and (itemCnt+curColMaxCnt)>=theItemConfig["min_cnt"] then
                    willGetFeatureInCol = true
                    self.speedUpState[col] = self.speedUpState[col] or {}-- 此情况下，会进行特殊操作，将其状态记到self.speedUpState中
                    self.speedUpState[col][itemKey] = true
                end
                local willGetFeatureInAfterCols = false
                local sumCnt = 0
                for tempCol=col, baseColCnt do
                    if itemKey == self.gameConfig.special_symbol["bonus1"] then 
                        sumCnt = sumCnt + 3
                    else 
                        sumCnt = sumCnt + (theItemConfig["col_set"][tempCol] or colRowCnt)
                    end 
                end
                if sumCnt>0 and (itemCnt+sumCnt)>=theItemConfig["min_cnt"] then
                    willGetFeatureInAfterCols = true
                end
                self.notifyState[col] = self.notifyState[col] or {}-- 当前列提示相关状态
                for row, theItem in pairs(colItemList) do
                    if itemKey == self.gameConfig.special_symbol["scatter"] and theItem == self.gameConfig.special_symbol["scatter"] then
                        self.notifyState[col][theItem] = self.notifyState[col][theItem] or {}
                        table.insert(self.notifyState[col][theItem], {col, row, theItem, itemKey, willGetFeatureInAfterCols})
                    elseif itemKey == self.gameConfig.special_symbol["bonus1"] and theItem >= bonusId1 and theItem < bonusId2 then 
                        self.notifyState[col][bonus1] = self.notifyState[col][bonus1] or {}
                        table.insert(self.notifyState[col][bonus1], {col, row, theItem, itemKey, willGetFeatureInAfterCols}) 
                        
                    elseif itemKey == self.gameConfig.special_symbol["bonus2"] and theItem >= bonusId2 then
                        self.notifyState[col][bonus2] = self.notifyState[col][bonus2] or {}
                        table.insert(self.notifyState[col][bonus2], {col, row, theItem, itemKey, true}) 
                    end
                end

                for row, theItem in pairs(colItemList) do
                    if itemKey == self.gameConfig.special_symbol.scatter then
                        if theItem == itemKey then
                            itemCnt = itemCnt + 1
                            break
                        end
                    elseif itemKey == self.gameConfig.special_symbol.bonus1 then
                        if theItem >= bonusId1 and theItem < bonusId2 then
                            itemCnt = itemCnt + 1
                        end
                    end
                end

            end
        end
    end
end
function cls:checkPlaySymbolNotifyEffect( pCol )
    self.notifyState = self.notifyState or {}
    local reelSymbolState = self.notifyState[pCol]
    self:dealMusic_PlaySpecialSymbolStopMusic(pCol)
end
function cls:dealMusic_PlaySpecialSymbolStopMusic( pCol )
    local basepCol = pCol
    local pCol = 1 + (pCol-1)%5
    self.notifyState = self.notifyState or {}
    if (not self.notifyState[pCol]) or bole.getTableCount(self.notifyState[pCol]) == 0 then
        return false
    end
    local ColNotifyState = self.notifyState[pCol]
    if ColNotifyState[self.gameConfig.special_symbol["scatter"]] or 
        ColNotifyState[self.gameConfig.special_symbol["bonus1"]] or
        ColNotifyState[self.gameConfig.special_symbol["bonus2"]] then
            self:playSymbolNotifyEffect(pCol, true)
            self.notifyState[pCol] = {}
    end
end
function cls:playReelNotifyEffect( pCol )
    -- 播放列的激励动画, 可以判断当前的激励类型
    if self:getRespinStatus() then 
        return
    end
    self.mainView:addReelNotifyEffect(pCol)
end
function cls:playColLandEffect(pCol)
    self:setReelStopMusic(pCol) --设置当列音效可以停止播放
    self:playSymbolNotifyEffectInRespin(pCol)
    self:dealMusic_StopReelNotifyMusic(pCol) -- 设置之前的音效停止
    self:checkPlaySymbolNotifyEffect(pCol) -- 播放落地动画
    self:dealMusic_PlayReelStopMusic(pCol) -- 播放列停音效
    self:stopReelNotifyEffect(pCol) -- 删掉之前的激励动画
end
function cls:dealMusic_PlayReelStopMusic(pCol)
    if self.reelStopMusic and self.reelStopMusic[pCol] then 
        self.audioCtl:playEffectWithInterval(self.audio_list["reel_stop"],0.1,false)
    end
end
function cls:cleanReelStopMusic()
    self.reelStopMusic = {}
end
function cls:setReelStopMusic(pCol)
    self.reelStopMusic = self.reelStopMusic or {}
    self.reelStopMusic[pCol] = true
end
function cls:setReelSpecailLandMusic(pCol)
    self.reelStopMusic = self.reelStopMusic or {}
    self.reelStopMusic[pCol] = false
end
function cls:getNormalStopAddCount()
    local config = self.gameConfig.reel_spin_config
    local addHeight = config.downBounce + self.gameConfig.G_CELL_HEIGHT * 0.5
    local extra = math.ceil(addHeight / self.gameConfig.G_CELL_HEIGHT)
    return extra
end
function cls:stopReelNotifyEffect( pCol )
    self.mainView:stopReelNotifyEffect(pCol)
    if pCol == 5 then
        self:getCollectViewCtl():cleanSuperBonusJili()
    end
end
------------reel end  ----------

------------结果特殊处理 end ----------
function cls:onThemeInfo( specialData,callFunc )
    self.ctl.footer:setSpinButtonState(true)
    self.themeInfoCallFunc = callFunc
    self:checkHasWinInThemeInfo(specialData)
end
function cls:checkHasWinInThemeInfo( specialData )
    local hasSpecialWin = false
    local endFunc = function ( )
        self:checkHasWinInThemeInfo(specialData)
    end
    if self.respinCtl:getBonus2Flag() then
        hasSpecialWin = true
        self.respinCtl:addBonus2Collect(specialData, endFunc)
    elseif self.collectViewCtl:checkHasFeatureCollect() then
        hasSpecialWin = true
        self.collectViewCtl:collectCollectionStrips(specialData, endFunc)
    end
    if not hasSpecialWin then 
        if self.themeInfoCallFunc then 
            self.themeInfoCallFunc()
            self.themeInfoCallFunc = nil
        end
    end
end
function cls:getFlyLayer()
    return self.mainView.flyParent
end
function cls:getCellNode(col, row)
    return self.mainView:getCurSpinLayer().spins[col]:getRetCell(row)
end
function cls:playFadeToMaxVlomeMusic(  )
    local mvC = self.musicVolumeConfig
    self.audioCtl:dealMusic_FadeLoopMusic(mvC.time_volume, mvC.min_volume, mvC.max_volume)
end
function cls:playFadeToMinVlomeMusic(  )
    local mvC = self.musicVolumeConfig
    self.audioCtl:dealMusic_FadeLoopMusic(mvC.time_volume, mvC.max_volume, mvC.min_volume)
end
------------respin start----------
function cls:getRespinBoard()
    return self.mainView.respinBoard
end
function cls:getMainViewDownNode()
    return self.mainView.down_node
end
function cls:getAnimateNode()
    return self.mainView.animateNode
end
function cls:onRespinStart( ... )
    if self:getRespinStatus() then
        self:getRespinViewCtl():onRespinStart()
    end
    parentClass.onRespinStart(self)
end
function cls:onRespinStop(ret)
    if self:getRespinStatus() then
        ret.theme_deal_show = true
        self:fixRet(ret)
    end
    parentClass.onRespinStop(self, ret)
end
function cls:theme_deal_show(ret)
    ret.theme_deal_show = nil
    if self:getRespinStatus() then
        if not ret["theme_respin"] or #ret["theme_respin"] == 0 then
            self.rets["theme_respin"] = nil
            self.respinCtl:onRespinFinish(ret, true)
        end
    end
end
function cls:playSymbolNotifyEffectInRespin(pCol)
    if self:getRespinStatus() then
        local find = false
        local extraAddCnt = self:getNormalStopAddCount()
        local row = 1
        local symbolID = self.item_list[pCol][row]
        local bonus1 = 120
        if symbolID >= bonus1 then
            local cell = nil
            if self:checkIsFastStop() then 
                cell = self:getCellNode(pCol, row)
		    else
                cell = self:getCellNode(pCol, row+extraAddCnt)
		    end
            self:getRespinViewCtl():respin_symbolLand(cell, pCol, symbolID)
        end
    end
end
function cls:addSymbolFont(scale, fileName, pos)
    return self.mainView:addSymbolFont(scale, fileName, pos)
end
function cls:theme_respin(rets)
    self.node:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(function()
        local respinList = rets["theme_respin"]
        if respinList and #respinList > 0 then
            rets["item_list"] = table.remove(respinList, 1)
            -- 处理需要添加落地动画的symbol 
            local respinStopDelay = 1
            local endCallFunc = self:getTheRespinEndDealFunc(rets)
            self:respin(respinStopDelay, endCallFunc)
        else
            rets["theme_respin"] = nil
        end
    end)))
end
function cls:getBonusReel()
    local bonusReel = table.copy(self.theme_reels["respin_reel"])
    if bonusReel and #bonusReel == 1 then
        local maxCol = 15
        for col = 1, maxCol do
            bonusReel[col] = table.copy(self.theme_reels["respin_reel"][1])
        end
        self.theme_reels["respin_reel"] = bonusReel
    end
    return bonusReel
end
function cls:getSuperBonusReel()
    local bonusReel = table.copy(self.theme_reels["respin_reel1"])
    if bonusReel and #bonusReel == 1 then
        local maxCol = 15
        for col = 1, maxCol do
            bonusReel[col] = table.copy(self.theme_reels["respin_reel1"][1])
        end
        self.theme_reels["respin_reel1"] = bonusReel
    end
    return bonusReel
end
function cls:setLockedReels(col, status)
    self.lockedReels = self.lockedReels or {}
    self.lockedReels[col] = status
end
function cls:getLockedReels(col)
    if not self.lockedReels or not self.lockedReels[col] then
        return false
    end
    return true
end
function cls:fixRet( ret )
    if self:getRespinStatus() then
        local cacahe, item_list = self.respinCtl:getFixRet(ret)
        self:setResultCache(cacahe)
        ret.item_list = item_list
        ret.item_list_up = nil
        ret.item_list_down = nil
        self.item_list = item_list
    end
end
function cls:setResultCache(data)
    self.resultCache = data
end
------------respin end  ----------

------------get control start----------
function cls:getRespinStatus( ... )
    if self.showCurrentSpinBoard and self.showCurrentSpinBoard == SpinBoardType.Respin then
        return true
    elseif self.showCurrentSpinBoard and self.showCurrentSpinBoard == SpinBoardType.SuperRespin then
        return true
    end
    return false
end
function cls:getNormalStatus( ... )
    if self.showCurrentSpinBoard and self.showCurrentSpinBoard == SpinBoardType.Normal then
        return true
    end
    return false
end
function cls:getFreeStatus()

end
function cls:getFreeVCtl( ... )
    return self.freeCtl
end
function cls:getJpViewCtl( ... )
    return self.jpViewCtl
end
function cls:getCollectViewCtl( ... )
    return self.collectViewCtl
end
function cls:lockJackpotValue( data )
    data = data or {0,0,0,0,0}
    if self.jpViewCtl then
        self.jpViewCtl:lockJackpotValue(data)
    end
end
function cls:getRespinViewCtl( ... )
    return self.respinCtl
end
function cls:getMapInfoData( ... )
    local data = {}
    data.mapPoints = self.mapPoints or 0
    data.mapLevel  = self.mapLevel or 0
    return data
end
--------------------------------bet start----------------------------------
function cls:featureUnlockBtnClickEvent( _unLockType )
    if self.tipBetList and self.tipBetList[_unLockType] then
        self:setBet(self.tipBetList[_unLockType])
    end
end
--@setBet base class had
--@bet change
function cls:dealAboutBetChange( theBet, isPointBet )
    if (not self.tipBetList) or (not self.loadFinish) then
        return
    end
    theBet = theBet or self:getCurTotalBet()
    local maxBet = self:getMaxBet()
    self:changeCollectBet(theBet) 
    self:changeRespinTipBet(theBet)
    if maxBet >= theBet then
        self:changeUnlockJpBet(theBet) --放在前面是以防升级的时候,jp解锁的情况
    end
    if self.currentUnlockBet and (self.currentUnlockBet == theBet) then
        return
    end
    self.currentUnlockBet = theBet
end
function cls:changeCollectBet( theBet )
    self.collectViewCtl:changeCollectBet(theBet)
end
function cls:changeRespinTipBet(theBet)
    self.respinCtl:changeRespinTipBet(theBet)
end
function cls:changeUnlockJpBet( theBet )
    self.jpViewCtl:changeUnlockJpBet(theBet)
end
--------------------------------bet end  ----------------------------------
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
                self.footer:changeFreeSpinLayout() --普通的free
            end
        else
            self:removePointBet()
            self.footer:changeNormalLayout2()
        end
    elseif footer_type == 2 then
        self.footer:changeFreeSpinLayout3()
    elseif footer_type == 3 then
        self.footer:changeFreeSpinLayout()
    elseif footer_type == 4 then
        self.footer:isShowTotalBetLayout2(true, true)
    end
end
function cls:showBonusNode( isBonus, isBonus2 )
    self:resetCurrentReels(false, isBonus, isBonus2)
end
function cls:dealSpecialFeatureRet( data )
    self.tipBetList = data.bonus_level
    if data["map_info"] then
        self.mapInfo = data.map_info
        self.mapLevel = self.mapInfo.map_level or 0
    else 
        self.mapInfo = {}
        self.mapLevel = 0
    end
end
function cls:dealBonusGameResumeRet( data )
    -- body
end
function cls:adjustTheme( data )
    self.loadFinish = true
    self:changeSpinBoard("Normal")
    self:enableMapInfoBtn(false)
    if self:noFeatureResume(data) then
        self:playWelcomeDialog()
        self:hideActivitysNode()
        self:playMusicByName("base_welcome")
        self:resetBoardCellsByItemList(self.gameConfig.enterGameList[math.random(1, 5)], true)
    else 
        self.enterFirstTime = true
    end
    self:showCurrentCollectShow()
end

function cls:resetBoardCellsByItemList(_itemList, isFirst)
    if self.mainView then
        self.mainView:resetBoardCellsByItemList(_itemList, isFirst)
    end
end

function cls:noFeatureResume( data )
	local no_feature_resume = true
	if data and (data["bonus_game"] or data["free_random_pick"] or data["free_game"] or data["first_free_game"]) then 
		no_feature_resume = false 
	end
	return no_feature_resume
end

function cls:playWelcomeDialog()
    self.mainView:playWelcomeDialog()
end

function cls:showCurrentCollectShow( ... )
    if self.mapLevel and self.collectViewCtl then
        self.collectViewCtl:setCollectProgressImagePos(self.mapLevel)
    end
end
function cls:collectRestData()
    self.mapLevel = 0
    self:showCurrentCollectShow()
end

function cls:changeSpinBoard( pType )
    local boardType = SpinBoardType[pType]
    if pType == "Normal" then
        self:hideBonusNode(false, false)
    elseif pType == "FreeSpin" then
    elseif pType == "Respin" then
    elseif pType == "SuperRespin" then
        if self:isInFG() then
            self:setFooterStyle(2)
        else 
            self:setFooterStyle(0)
        end
    end
    self.lockedReels = nil
    self.showCurrentSpinBoard = boardType
    self.mainView:resetBoardShowNode(pType)
    self.mainView:updateBoardUI(boardType)
    self.mainView:updateBg(boardType)
    self.mainView:updtaeJackpotPos(boardType)
    self.respinCtl:updateRespinTip(boardType)
    self.mainView:updateCollectUI(boardType)
    self.mainView:updateBgSpineUI(boardType)
end

function cls:setFooterLabelInFg(leftCnt, sumCnt)
    if self.footer then
        self.footer:setFreeSpinLabel(leftCnt, sumCnt)
    end
end
function cls:stopDrawAnimate( ... )
    self:cleanReelStopMusic()
    self.mainView:stopDrawAnimate()
    if self.freeCtl then
        self.freeCtl:stopDrawAnimate()
    end
end
function cls:changeRootNodeParent(toMain, newParent)
    self.mainView:changeRootNodeParent(toMain, newParent)
end
---------------- bonus conection start------------------
function cls:playBonusAnimate( theGameData )
    local delay = 3
    self:stopDrawAnimate()
    self:playMusicByName("trigger_bell")
    self:playDiamondSymbolAnimate()
    return delay
end
function cls:playDiamondSymbolAnimate()
    local bonus1 = 120
    if self.item_list then
        for col, list in ipairs(self.item_list) do
            for row, item in ipairs(list) do
                if item >= bonus1 then
                    local file = self:getSpineFile("symbol_blue")
                    if self:getRespinViewCtl():getWinBonus2Type() then
                        file = self:getSpineFile("collect_top")
                    end
                    self.mainView:addItemSpine(item, col, row, true, "animation3", file)
                end
            end
        end
    end
end
function cls:getDiamondHighZorder(item, col, row, parent, pos, fromBonus, isShow)
    return self.mainView:getDiamondHighZorder(item, col, row, parent, pos, fromBonus, isShow)
end
function cls:getDiamondHighNode(col,row)
    if self.mainView.diamondList then
        if self.mainView.diamondList[col] and self.mainView.diamondList[col][row] then
            return self.mainView.diamondList[col][row]
        end
    end
    return nil
end

function cls:getTransitionDisTime(stype)
    local transition_config = self.gameConfig.transition_config
    stype = stype or "slot_machine"
    return transition_config[stype].onEnd - transition_config[stype].onCover 
end
---------------- bonus conection end  ------------------



---------------- free conection start  ------------------
function cls:getNormalFgStatus( ... )
    if self.showCurrentSpinBoard == SpinBoardType.Normal then
        return true
    end
    return false
end
function cls:enterFreeSpin( isResume )
    if isResume then  -- 断线重连的逻辑
        self:changeSpinBoard("FreeSpin")
        self:dealMusic_PlayFreeSpinLoopMusic()-- 切换背景音乐
    end
    self.mainView:showAllItem()
    self.playNormalLoopMusic = false --commonMusic: freespin背景音乐
end
function cls:showFreeSpinNode( count, sumCount, first )
    parentClass.showFreeSpinNode(self, count, sumCount, first)
    self:resetPointBet()
    if self.freeCtl then
        self.freeCtl:showFreeSpinNode()
    end
    self:changeSpinBoard("FreeSpin")
end
function cls:hideFreeSpinNode( ... )
    self:removePointBet()
    if self.freeCtl then
        self.freeCtl:hideFreeSpinNode()
    end
    self:changeSpinBoard("Normal")
    self:setDealFreeCollectState()
    parentClass.hideFreeSpinNode(self, ...)
end
function cls:setDealFreeCollectState()
    self.ctl.spin_processing = true
    self.ctl.isProcessing = true
end
function cls:resetPointBet( ... )
    if self.freeCtl then
        self.freeCtl:resetPointBet()
    end
end
function cls:playStartFreeSpinDialog( theData )
    if self.freeCtl then 
        self.freeCtl:playStartFreeSpinDialog(theData)
    end
end
function cls:playMoreFreeSpinDialog( theData )
    if self.freeCtl then 
        self.freeCtl:playMoreFreeSpinDialog(theData)
    end
end
function cls:playCollectFreeSpinDialog( theData )
    if self.freeCtl then 
        self.freeCtl:playCollectFreeSpinDialog(theData)
    end
end
function cls:playFreeSpinItemAnimation( theSpecials ,enterType )
    if (not theSpecials) then
        return 0
    end
    local delay = 0
    self:stopDrawAnimate()
    if enterType == 'free_spin' then
        delay = 3
        self:playMusicByName("trigger_bell")
        self:playScatterAnimate(theSpecials, self.gameConfig.special_symbol["scatter"], true)
    elseif enterType == 'more_free_spin' then
        delay = 3
        self:playMusicByName("trigger_bell")
        self:playScatterAnimate(theSpecials, self.gameConfig.special_symbol["scatter"], true)
    else
        -- self:playScatterAnimate(theSpecials, self.gameConfig.special_symbol["scatter"], true)
        -- delay = 3
    end
    return delay
end
function cls:playScatterAnimate( theSpecials, itemKey, isLoop )
    local scatterNumber = 0
    if theSpecials and theSpecials[itemKey] then 
        for col, rowTagList in pairs(theSpecials[itemKey]) do
            for row, tagValue in pairs(rowTagList) do
                self.mainView:addItemSpine(itemKey, col, row, isLoop, "animation3")
            end
        end
    end
end
function cls:getCurrentBase( ... )
    if self.showCurrentSpinBoard == SpinBoardType["Normal"] then 
        return true
    end
    return false
end
function cls:dealMusic_EnterBonusGame(isSuper)
    local mvC = self.musicVolumeConfig
    AudioControl:stopGroupAudio("music")
    if isSuper then
        self.audioCtl:dealMusic_PlayGameLoopMusic(self.audio_list.superBonus_background)
    else
        self.audioCtl:dealMusic_PlayGameLoopMusic(self.audio_list.bonus_background)
    end
    AudioControl:volumeGroupAudio(mvC.max_volume)
end

-- 播放free games的背景音乐
function cls:dealMusic_PlayFreeSpinLoopMusic() -- 播放背景音乐
    local mvC = self.musicVolumeConfig
    AudioControl:stopGroupAudio("music")
    if self.freeCtl then
        self.audioCtl:dealMusic_PlayGameLoopMusic(self.audio_list.free_background)
    end
    AudioControl:volumeGroupAudio(mvC.max_volume)
end
function cls:dealMusic_StopNormalLoopMusic()
    AudioControl:stopGroupAudio("music")
    AudioControl:volumeGroupAudio(0)
end
function cls:playSymbolLandMusic(willGetFeature, item, pCol, isRespin)
    self.mainView:playSymbolLandMusic( willGetFeature, item, pCol, isRespin)
end

--------------- bigwin start stop ---------------
function cls:addWareEffect()
    if bole.isWaveAvailable() then
        self.mainView:addWareEffect()
    end
end
function cls:stopRollUpFunction(mul)
    parentClass.stopRollUpFunction(self, mul)
end
function cls:playRollupSound(mul)
    parentClass.playRollupSound(self, mul)
end
function cls:getDialogParent()
    return self.mainView.boardDialogParent
end
function cls:getCharMovePos()
    return self.mainView:getCharMovePos()
end
function cls:showThemeDialog(theData, sType, csbName, dialogType, blackDimmer, parent, hideSpineNode)
    -- self:playFadeToMinVlomeMusic()
    local end_event = theData.click_event
    local theDialog = nil
    theData.click_event = function()
        if end_event then
            end_event()
        end
        if sType == fs_show_type.start or sType == fs_show_type.collect then
            self:playMusicByName("common_click")
            self:playMusicByName("popup_out")
            -- 获取按钮
            if theDialog and theDialog.startRoot and theDialog.startRoot.btnStart then 
                theDialog.startRoot.btnStart:removeAllChildren()
            end
            -- 获取按钮
            if theDialog and theDialog.collectRoot and theDialog.collectRoot.btnCollect then 
                theDialog.collectRoot.btnCollect:removeAllChildren()
            end
        end
    end
    local config = {}
    local btnInfo = table.copy(themeConfig.dialog_config["black_common"])
    if blackDimmer then 
        btnInfo = nil
    end
    -- theData.roll_time = themeConfig.dialog_config["coins_roll_time"]
    config["csb_file"] = self:getCsbPath(csbName)
    config["frame_config"] = {
        ["start"]   = { nil, 1, nil, 2 },
        ["more"]    = { nil, 5.5, nil, 2 },
        ["collect"] = { nil, 1, nil, 2 },
    }
    config.dialog_config = table.copy(themeConfig.dialog_config[dialogType])
    if dialogType == "jp_collect" and theData.bg ~= 1 then
        config.dialog_config["btn_node"]["stepPos"] = {{cc.p(0, -84)}, {14/30, cc.p(0, -87)}, { 10 / 30, cc.p(0, -207)}, { 8 / 30, cc.p(0, -175)}, { 8 / 30, cc.p(0, -194)}}
    end
    if hideSpineNode then
        if config.dialog_config and config.dialog_config[hideSpineNode] then
            config.dialog_config[hideSpineNode] = nil
        end
    end
    theDialog = ThemeBaseDialog.new(self.ctl, config, btnInfo)
    if sType == fs_show_type.start then
        theDialog:showStart(theData, nil, parent)
    elseif sType == fs_show_type.more then
        theDialog:showMore(theData, nil, parent)
    elseif sType == fs_show_type.collect then
        if dialogType == "jp_collect" then
            local bgType = theData.bg
            local jpLabelConfig = {
                [1] = {
                    scale = 1,
                    pos = cc.p(0, -17),
                    maxWidth = 836
                },
                [2] = {
                    scale = 0.9,
                    pos = cc.p(0, -4),
                    maxWidth = 836 * 0.9
                },
                [3] = {
                    scale = 0.9,
                    pos = cc.p(0, -4),
                    maxWidth = 836 * 0.9
                },
                [4] = {
                    scale = 0.85,
                    pos = cc.p(0, -2),
                    maxWidth = 836 * 0.85
                },
                [5] = {
                    scale = 0.85,
                    pos = cc.p(0, -2),
                    maxWidth = 836 * 0.85
                },
            }
            local collecelLabel = theDialog.collectRoot.labelWin
            local collectBtnNode = theDialog.collectRoot:getChildByName("btn_node")
            collecelLabel:setScale(jpLabelConfig[bgType]["scale"])
            collecelLabel:setPosition(jpLabelConfig[bgType]["pos"])
            theDialog.dialog_config.maxWidth = jpLabelConfig[bgType]["maxWidth"]
            collectBtnNode:setLocalZOrder(-1)
            local a1 = cc.DelayTime:create(20/30)
            local a2 = cc.CallFunc:create(function ()
                collectBtnNode:setLocalZOrder(1)
            end)
            local a3 = cc.Sequence:create(a1,a2)
            collectBtnNode:runAction(a3)
        end
        theDialog:showCollect(theData, nil, parent)
    end
    return theDialog
end

function cls:onExit()
    if self.bonus and self.bonus.onExit then
        self.bonus:onExit()
    end
    if self.mainView and self.mainView.onExit then
        self.mainView:onExit()
    end
    parentClass.onExit(self)
end

return cls