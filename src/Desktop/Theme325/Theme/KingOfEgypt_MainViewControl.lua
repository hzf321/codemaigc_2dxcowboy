-- @Author: wanghongjie
-- 325 @math:dingyifeng,ui:luyuanyuan,plan:wujunhao

local parentClass = ThemeBaseViewControl
local cls = class("KingOfEgypt_MainViewControl", parentClass)

local _mainView = require  (bole.getDesktopFilePath("Theme/KingOfEgypt_MainView"))  
local jpViewControl = require  (bole.getDesktopFilePath("Theme/KingOfEgypt_JpViewControl"))  
local collectViewControl = require  (bole.getDesktopFilePath("Theme/KingOfEgypt_CollectViewControl"))  
local mapViewControl = require  (bole.getDesktopFilePath("Theme/KingOfEgypt_MapViewControl")) 
local freeViewControl = require  (bole.getDesktopFilePath("Theme/KingOfEgypt_FreeViewControl")) 

local ThemeBaseDialog = require "Themes/base/ThemeBaseDialog"
local themeConfig = require  (bole.getDesktopFilePath("Theme/KingOfEgypt_Config"))   

local fs_show_type
local SpinBoardType = nil
function cls:ctor( themeid, theScene )
	self.gameConfig = themeConfig
	self.baseBet = self.gameConfig.baseBet
	self.UnderPressure = self.gameConfig.init_config.underPressure
    self.themeResourceId = themeid
    SpinBoardType = self.gameConfig.SpinBoardType
    fs_show_type = self.gameConfig.fs_show_type
	self:setGameConfig()
    self:addListenEvent()
	-- self:initPreLoad()
	local ret = parentClass.ctor(self, themeid, self.gameConfig.isPortrait, theScene)
	return ret
end

function cls:configAudioList()
    parentClass.configAudioList(self)
    for music_key, music_path in pairs(self.gameConfig.audioList) do
        self.audio_list[music_key] = music_path
    end

	tool.mergeTable(self.audio_win_list, tool.tableClone(self.gameConfig.peopel_rollup_list))
	if self.audioCtl then 
		self.audioCtl:changeAudioWinListPath(tool.tableClone(self.audio_win_list))
	end
end

function cls:playTransition( endCallBack, tType )

    local transition = ThemeBaseTransitionControl.new(self, endCallBack, nil)
    local transition_config = self.gameConfig.transition_config
    local config = {}
    local endTm = transition_config[tType].onEnd
    config.path = "spine/" .. self.gameConfig.spine_path[transition_config[tType].spine]
    config.audio = "transition_" .. tType
    config.animName = transition_config[tType].animName
    config.endTime = endTm
    transition:play(config)
    
    self:playFadeToMinVlomeMusic()
    self:laterCallBack(endTm, function ()
        self:playFadeToMaxVlomeMusic()
    end)

end

--@create mainView
function cls:initGameControlAndMainView( ... )
    self.jpViewCtl = jpViewControl.new(self)
    self.collectViewCtl = collectViewControl.new(self)
    self.mapViewCtl = mapViewControl.new(self)
    self.mainView = _mainView.new(self)
    self.freeCtl = freeViewControl.new(self)
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
    if (not self.freeCtl.freewin) and (not self.autoSpin) and (not self.bonus) then
        self:enableMapInfoBtn(true)
    end
end
function cls:enableMapInfoBtn( enable )
    self.isCanFeatureClick = enable

    self.isReelSpin = not enable
end
function cls:refreshNotEnoughMoney(enable)
    self:enableMapInfoBtn(true)
end
function cls:getCanTouchFeature( ... )
    return self.isCanFeatureClick
end

--@玩法状态控制
function cls:setFeatureState(fType, state)
	self.featureStateList = self.featureStateList or {}
	self.featureStateList[fType] = state 
end

function cls:featureBtnCheckCanTouch()
	local canTouch  = true

	if self.featureStateList then 
		local inFeatureCnt = 0
		for _, state in pairs(self.featureStateList) do 
			if state then 
				inFeatureCnt = inFeatureCnt + 1
			end
        end
		if inFeatureCnt > 0 then 
			return false
		end
    end
    
    if self.isReelSpin then
        return false
    end

	return canTouch
end

function cls:setGameConfig( ... )
	self.ThemeConfig = tool.tableClone(self.gameConfig.theme_config.reel_symbol)
    self.musicVolumeConfig = self.gameConfig.music_volume
    self.LowSymbolList = self.gameConfig.symbol_config.low_symbol_list
    self.majorSymbolList = self.gameConfig.symbol_config.major_symbol_list
    -- self.majorSymbolList = self.gameConfig.symbol_config.major_symbol_list

end
function cls:getGameConfig( ... )
	return self.gameConfig
end
function cls:getMusicVConfig( ... )
    return self.musicVolumeConfig
end
function cls:getMajorSymbol()
    local len = #self.majorSymbolList
    return self.majorSymbolList[math.random(1, len)]
end
function cls:getBoardConfig( ... )
	if self.boardConfigList then
		return self.boardConfigList 
    end
    
	local borderConfig = tool.tableClone(self.ThemeConfig["boardConfig"])
    local newBoardConfig = {}
    for index = 1, #borderConfig do
        local _boardConfig = borderConfig[index]
        local _reelConfig  = _boardConfig.reelConfig
        local _basePos     = table.copy(_reelConfig[1].base_pos)
        local _lineWidth   = _boardConfig.lineWidth
        local _cellWidth   = _boardConfig.cellWidth
        local _cellHeight   = _boardConfig.cellHeight
        local _symbolCount = _boardConfig.symbolCount
        newBoardConfig[index] = {}
        newBoardConfig[index].allow_over_range = _boardConfig.allow_over_range
        newBoardConfig[index].show_parts = _boardConfig.show_parts
        newBoardConfig[index].reelConfig = {}
        for col = 1, borderConfig[index].colCnt do
            local oneConfig = {}
            if col > 1 then
                _basePos = cc.pAdd(_basePos, cc.p(_cellWidth+_lineWidth, 0))
            end
            oneConfig.base_pos = _basePos
            oneConfig.cellWidth = _cellWidth
            oneConfig.cellHeight = _cellHeight
            oneConfig.symbolCount = _symbolCount
            table.insert(newBoardConfig[index].reelConfig, oneConfig)
        end
    end
    self.boardConfigList = newBoardConfig
    return self.boardConfigList
end
function cls:getFreeReel( ... )
    if self.freeCtl:getMapFreeStatus() then
        if self.freeCtl:getYangSymbolStatus() and self.freeCtl:getYinSymbolStatus() then
            return self.theme_reels["map_free_yin_yang_reel"]
        elseif self.freeCtl:getYangSymbolStatus() then 
            return self.theme_reels["map_free_yang_reel"]
        elseif self.freeCtl:getYinSymbolStatus() then 
            return self.theme_reels["map_free_yin_reel"]
        else 
            return self.theme_reels["map_free_reel"]
        end
    end
    return nil
end
function cls:getThemeJackpotConfig()
    local jackpot_config_list = self.gameConfig.jackpotCtlConfig
    return jackpot_config_list
end
function cls:getSpineFile(file_name)
    local path2 = self.gameConfig.spine_path[file_name]
    local path = string.format("theme_resource/theme%d/spine/%s", self.themeResourceId, path2)
    return path
end
function cls:getFntFilePath( file_name )
    local path = string.format("theme_resource/theme%d/%s", self.themeResourceId, file_name)
    return path
end
function cls:getParticleFile(file_name)
    local path = string.format("theme_resource/theme%d/particle/%s.plist", self.themeResourceId, file_name)
    return path
end
function cls:getCsbPath( file_name )
    local path2 = self.gameConfig.csb_list[file_name]
    local path = string.format("theme_resource/theme%d/%s", self.themeResourceId, path2)
    return path
end

function cls:isLowSymbol( item )
    if not item then return false end
    if self.LowSymbolList[item] then
        return true
    end
    return false
end

function cls:getSpinColStartAction( pCol, reelCol)
	local _reelSpinConfig = self.gameConfig.reel_spin_config
    local spinAction = {}
    spinAction.delay = _reelSpinConfig.delay*(pCol-1)
    spinAction.upBounce = _reelSpinConfig.upBounce
    if not self:getNormalStatus() then
        spinAction.upBounce = _reelSpinConfig.upBounceFree
    end
    spinAction.upBounceMaxSpeed = _reelSpinConfig.upBounceMaxSpeed
    spinAction.upBounceTime = _reelSpinConfig.upBounceTime
    spinAction.speedUpTime = _reelSpinConfig.speedUpTime
    spinAction.maxSpeed = _reelSpinConfig.maxSpeed
    -- self:getSpinColStartActionSpecial(spinAction, pCol, reelCol)
    return spinAction
end

function cls:getSpinColStopAction(themeInfoData, pCol, interval)

    local _reelSpinConfig = self.gameConfig.reel_spin_config

    if pCol == 1 then -- 同时下落的时候 进行的 延迟 重置
        self.DelayStopTime = 0
    end

    local checkNotifyTag   = self:checkNeedNotify(pCol)
    local checkAnti = self:checkSpecialFeature(themeInfoData, pCol)
    if checkAnti then
        checkNotifyTag = nil
        if pCol == 1 then
            self:addSpecailJili()
            self.canFastStop = false
            self.speedUpState = {}
            self.DelayStopTime = self.DelayStopTime + _reelSpinConfig.extraJiliTime
        end
    end
    if checkNotifyTag then
        self.DelayStopTime = self.DelayStopTime + _reelSpinConfig.extraReelTime
    end
    -- 判断需不需要额外的添加时间
    local wildDelay = 0
    if pCol == 1 and self.freeCtl:getMapFreeStatus() then
        wildDelay = self.freeCtl:getMapFreeWildTime()
        if wildDelay > 0 then
            self.canFastStop = false
        end
        self.DelayStopTime = self.DelayStopTime + wildDelay
    end


    local spinAction = {}
    spinAction.actions = {}

    local temp = interval - _reelSpinConfig.speedUpTime - _reelSpinConfig.upBounceTime
    local timeleft = _reelSpinConfig.rotateTime - temp > 0 and _reelSpinConfig.rotateTime - temp or 0
    
    local _stopDelay = _reelSpinConfig.stopDelay
    if not self:getNormalStatus() then
        _stopDelay = _reelSpinConfig.stopDelayFree
    end
    local _downBonusT = _reelSpinConfig.downBounceTime

    spinAction.stopDelay = timeleft+(pCol-1)*_stopDelay + self.DelayStopTime
    self.ExtraStopCD = _reelSpinConfig.spinMinCD - temp > 0 and _reelSpinConfig.spinMinCD - temp or 0

    spinAction.maxSpeed = _reelSpinConfig.maxSpeed
    spinAction.speedDownTime = _reelSpinConfig.speedDownTime
    if self.isTurbo then
        spinAction.speedDownTime = spinAction.speedDownTime - 20/60 --  * 3/4
    end
    spinAction.downBounce = _reelSpinConfig.downBounce
    spinAction.downBounceMaxSpeed = _reelSpinConfig.downBounceMaxSpeed
    spinAction.downBounceTime = _downBonusT
    spinAction.stopType = 1
    return spinAction
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
    if self.mapViewCtl then
        self.mapViewCtl:onSpinStart()
    end
    self:enableMapInfoBtn(false)
    -- self:hideEnterThemeDialog()

    parentClass.onSpinStart(self)
end
function cls:onSpinStop( ret )
    parentClass.onSpinStop(self, ret)
end

function cls:stopControl( stopRet, stopCallFun )
    self.isGetScatterCount = 0
    self.isScatterBgTime = nil
    self.item_list = nil
    self.item_list = stopRet["item_list"]
    local themeInfo = stopRet["theme_info"]
    self.yangBaseCount = 0
    self.yinBaseCount  = 0
    if stopRet["bonus_level"] then
        self.tipBetList = stopRet["bonus_level"]
        self.bonusLevelChange = true
    end
    if stopRet["bonus_game"] and stopRet["bonus_game"]["win_wheel"] then
        self.isScatterBgTime = true  
    end
    if themeInfo and themeInfo["yang_count"] and themeInfo["yin_count"] then 
        self.yangBaseCount = themeInfo["yang_count"]
        self.yinBaseCount  = themeInfo["yin_count"]
    end

    if self.collectViewCtl then
        self.collectViewCtl:collectStopCtl(stopRet)
    end
    if self.freeCtl then
        self.freeCtl:stopFreeControl(stopRet)
    end
    -- before_win_show
    stopCallFun()
end
function cls:drawAnimate(ret)
    -- 判断假设是存在
    local delay = 0
    self:playNormalRapidAnimate() -- 说明basewin的字段是 > 0 的，则没有中jackpotBonus
	if ret["win_pos_list"] and #ret["win_pos_list"]>0 then
		if self.winWays then
			delay = self:drawWaysThemeAnimate(self.winWays, self.mainView:getCurSpinLayer(), ret, self.specials)
		elseif self.winLines then
			delay = self:drawLinesThemeAnimate(self.winLines, self.mainView:getCurSpinLayer(), ret, self.specials)
		end
    end
	return delay
end
function cls:onReelFallBottom( pCol )
    self.reelStopMusicTagList[pCol] = true
    if not self:checkPlaySymbolNotifyEffect(pCol) then
        self:dealMusic_PlayReelStopMusic(pCol)
    end
    self:dealMusic_StopReelNotifyMusic()
    self:stopReelNotifyEffect(pCol)
    self.mainView:recoverSpeededReel(pCol)
    if self:checkSpeedUp(pCol + 1) then
        self:onReelNotifyStopBeg(pCol +1)
    end
    self.mainView:cleanTuoweiAnimate(pCol)
    if pCol == 6 and self.isGetScatterCount and self.isGetScatterCount < 2 then 
        self.mainView:cleanScatterBgAni()
        self.isGetScatterCount = 0
    end
end
function cls:onReelFastFallBottom( pCol )
    self.reelStopMusicTagList[pCol] = true
    self.fastStopMusicTag = self.fastStopMusicTag or "allow_music"
    self:dealMusic_StopReelNotifyMusic()
    if not self:checkPlaySymbolNotifyEffect(pCol) then
        self:dealMusic_PlayReelStopMusic(pCol)
    end
    self:stopReelNotifyEffect(pCol) 
    if pCol == 6 and self.isGetScatterCount and self.isGetScatterCount < 2 then 
        self.mainView:cleanScatterBgAni()
        self.isGetScatterCount = 0
    end
    self.mainView:recoverSpeededReel(pCol)
    self.mainView:cleanTuoweiAnimate(pCol)
end
function cls:onReelStop( col )
    parentClass.onReelStop(self, col)
end
function cls:onAllReelStop( ... )
    if self.freeCtl then
        self.freeCtl:onAllReelStop()
    end
    -- 查看是否需要清掉数据
    if not self.isScatterBgTime then
        self.mainView:cleanScatterBgAni()
    end
    parentClass.onAllReelStop(self)
end
function cls:checkSpeedUp( pCol )
    local special_jili_type = {
        self.gameConfig.special_symbol.scatter,
        self.gameConfig.special_symbol.moon,
        self.gameConfig.special_symbol.sun
    }
    local isSpeedUp = false
    for key, val in ipairs(special_jili_type) do
		local details = self.speedUpState[pCol] or {}
		local colDetails = details[val]
		if colDetails and colDetails["cnt"] >= colDetails["min_cnt"] then
			isSpeedUp = true
			return isSpeedUp
		end
	end
	return isSpeedUp
end
function cls:checkNeedNotify( pCol )
    return self:checkSpeedUp(pCol)
end
function cls:genSpecialSymbolState( rets )
    rets = rets or self.ctl.rets
    if not self.checkItemsState then
        self.checkItemsState = {}
        self.speedUpState    = {}
        self.notifyState     = {}
        self.scatterBGState = {}
        self:genSpecialSymbolStateInNormal(rets)
    end
end
function cls:genSpecialSymbolStateInNormal( rets )
    local cItemList   = rets.item_list
    local checkConfig = self.specialItemConfig
    local baseColCnt  = 6
    for itemKey,theItemConfig in pairs(checkConfig) do
        local itemType     = theItemConfig["type"]
        local symbolContain = theItemConfig["symbol_contain"]
        local itemCnt      = 0
        if itemType then
            for col=1, baseColCnt do
                local colItemList  = cItemList[col]
                local colRowCnt    = self.spinLayer.spins[col].row 
                local curColMaxCnt = theItemConfig["col_set"][col] or colRowCnt
                -- 判断_当前列之前_是否已经中了feature(通过之前列itemKey个数判断)

                local colItemCnt = 0 
                local isGetFeature = false
                -- if itemCnt >= theItemConfig["min_cnt"] then
                --     isGetFeature = true
                -- end
                for row, theItem in pairs(colItemList) do
                    if theItem == itemKey or symbolContain[theItem] then
                        colItemCnt = colItemCnt + 1
                        isGetFeature = true
                    end
                end

                local willGetFeatureInAfterCols = false
                local willGetFeature = false

                local sumCnt = 0
                local sumCnt1 = 0
                sumCnt = sumCnt + curColMaxCnt * (#self.spinLayer.spins - col + 1)
                sumCnt1 = sumCnt1 + 3 * (#self.spinLayer.spins - col + 1)
                -- for tempCol=col, baseColCnt do
                --     sumCnt = sumCnt + (theItemConfig["col_set"][tempCol] or colRowCnt)
                -- end

                if curColMaxCnt > 0 and sumCnt > 0 and (itemCnt+sumCnt) >= theItemConfig["min_cnt"] then
                    willGetFeatureInAfterCols = true
                end
                if curColMaxCnt > 0 and sumCnt1 > 0 and (itemCnt+sumCnt1) >= theItemConfig["min_cnt"] then
                    willGetFeature = true
                end
                if willGetFeatureInAfterCols then 
                    self.speedUpState[col] = self.speedUpState[col] or {}
                    self.speedUpState[col][itemKey] = self.speedUpState[col][itemKey] or {}
                    self.speedUpState[col][itemKey]["cnt"] = itemCnt + curColMaxCnt
                    self.speedUpState[col][itemKey]["is_get"] = isGetFeature
                    self.speedUpState[col][itemKey]["real_cnt"] = itemCnt + colItemCnt
                    self.speedUpState[col][itemKey]["min_cnt"] = theItemConfig["min_cnt"]
                    if self.freeCtl:gameMasterFlagStatus() and (itemKey ~= self.gameConfig.special_symbol.scatter) then 
                        self.speedUpState[col][itemKey]["min_cnt"] = theItemConfig["min_cnt"] - 1
                    end
                end

                self.notifyState[col] = self.notifyState[col] or {}-- 当前列提示相关状态
                for row, theItem in pairs(colItemList) do
                    if symbolContain[theItem] then
                        self.notifyState[col][itemKey] = self.notifyState[col][itemKey] or {}
                        if theItem ~= self.gameConfig.special_symbol.scatter then 
                            willGetFeatureInAfterCols = willGetFeature
                        end
                        table.insert(self.notifyState[col][itemKey], {col, row, theItem, willGetFeatureInAfterCols})
                    end
                    if (theItem == self.gameConfig.special_symbol.scatter) and self.isGetScatterCount then
                        self.isGetScatterCount = self.isGetScatterCount + 1
                    end
                end

                if isGetFeature then
                    itemCnt = itemCnt + colItemCnt
                end
            end
        end
    end
end
function cls:checkPlaySymbolNotifyEffect( pCol )
    self.notifyState = self.notifyState or {}
    local reelSymbolState = self.notifyState[pCol]
    if not self.fastStopMusicTag and reelSymbolState and bole.getTableCount(reelSymbolState)>0 then -- 判断是否播放特殊symbol的动画
        self:dealMusic_PlaySpecialSymbolStopMusic(pCol)
        return true
    else
        self:dealMusic_PlaySpecialSymbolStopMusic(pCol)
        return false
    end
end
function cls:dealMusic_PlaySpecialSymbolStopMusic( pCol )
    local basepCol = pCol
    local pCol = 1 + (pCol-1) % 6
    self.notifyState = self.notifyState or {}
    if (not self.notifyState[pCol]) or bole.getTableCount(self.notifyState[pCol]) == 0 then
        return false
    end
    local ColNotifyState = self.notifyState[pCol]
    local haveSymbolLevel = 4

    if ColNotifyState[self.gameConfig.special_symbol.scatter] then
        haveSymbolLevel = 1
        self:playSymbolNotifyEffect(pCol, true)
    elseif ColNotifyState[self.gameConfig.special_symbol.moon] then
        haveSymbolLevel = 1
        self:playSymbolNotifyEffect(pCol, true)
    elseif ColNotifyState[self.gameConfig.special_symbol.sun] then
        haveSymbolLevel = 1
        self:playSymbolNotifyEffect(pCol, true)
    end
    self.notifyState[pCol] = {}
    if haveSymbolLevel < 4 then
        return true
    end
end
function cls:getNormalStopAddCount()
    local config = self.gameConfig.reel_spin_config
    local G_CELL_HEIGHT = self.gameConfig.G_CELL_HEIGHT
    local addHeight = config.downBounce + G_CELL_HEIGHT * 0.5
    local extra = math.ceil(addHeight / G_CELL_HEIGHT)
    return extra
end
function cls:dealMusic_PlayReelNotifyMusic( pCol ) -- 最后一列激励音效
	-- self:playMusicByName("reel_notify", true, false)
	-- self.playR1Col = pCol
end
function cls:dealMusic_StopReelNotifyMusic( pCol )
	if not self.playR1Col then return end
	self.playR1Col = nil
	self.audioCtl:stopMusic(self.audio_list.reel_notify,true)
	self.audioCtl:stopMusic(self.audio_list.reel_notify1,true)
end
function cls:playReelNotifyEffect( pCol )
    local special_jili_type = {
        self.gameConfig.special_symbol.scatter,
        self.gameConfig.special_symbol.sun,
        self.gameConfig.special_symbol.moon,
    }
    local isSpeedUp = false
	for key, val in ipairs(special_jili_type) do
		local details = self.speedUpState[pCol] or {}
		local colDetails = details[val]
        if colDetails and colDetails["cnt"] >= colDetails["min_cnt"] then
            local path = self:getSpineFile("jili_"..val)
            local spine = nil
            local animName = "animation"
            if val == self.gameConfig.special_symbol.moon then 
                animName = "animation2"
            end
            local pos   = self:getCellPos(pCol,2)
            local _,s1 = self:addSpineAnimation(self.mainView.animateNode, 20, path, pos, animName,nil,nil,nil,true,true)
            self.reelNotifyEffectList[pCol] = s1
            self.reelNotifyEffectList[pCol].basePos = pos
            -- 判断是15的时候。棋盘的激励需要抬高
            if val == self.gameConfig.special_symbol.scatter then 
                self:playMusicByName("reel_notify", true, false)
                self:changeScaleReel(pCol)

                self:changeReel(true, pCol)
            else 
                self:playMusicByName("reel_notify1", true, false)
            end
            self.playR1Col = pCol
            return
		end
	end
end
function cls:changeScaleReel(pCol)
    self.mainView:changeScaleReel(pCol)
end
function cls:stopReelNotifyEffect( pCol )
    self.reelNotifyEffectList = self.reelNotifyEffectList or {}
    if self.reelNotifyEffectList[pCol] and (not tolua.isnull(self.reelNotifyEffectList[pCol])) then
        self.reelNotifyEffectList[pCol]:removeFromParent()
    end
    self.reelNotifyEffectList[pCol] = nil
end
------------reel end  ----------

------------结果特殊处理 end ----------
function cls:onThemeInfo( specialData,callFunc )
    self:changeReel(false) -- 去掉假轴控制

    if specialData and specialData["free_game"] and specialData["free_game"]["map_level"] then
        self.ctl.rets["after_win_show"] = 1
    end
    -- before_win_show
    if specialData and specialData["bonus_game"] and specialData["bonus_game"]["jackpot_bonus"] then 
        self:setBeforeWinShow(0.5)
    elseif specialData and specialData["base_win"] and self:getBigWinStatus(specialData["base_win"]) then 
        self:setBeforeWinShow()
    end

    self.ctl.footer:setSpinButtonState(true)
    self.themeInfoCallFunc = callFunc
    self:checkHasWinInThemeInfo(specialData)
end
function cls:checkHasWinInThemeInfo( specialData )
    local hasSpecialWin = false
    local endFunc = function ( ret )
        self:checkHasWinInThemeInfo(ret)
    end
    if self.collectViewCtl:checkHasFeatureCollect() then
        hasSpecialWin = true
        self.collectViewCtl:collectCollectionStrips(specialData, endFunc)
    elseif self.freeCtl:checkHasFeatureFree() then
        hasSpecialWin = true
        self.freeCtl:updateFreeReelsStop(specialData, endFunc)
    end
    if not hasSpecialWin then 
        if self.themeInfoCallFunc then 
            self.themeInfoCallFunc()
            self.themeInfoCallFunc = nil
        end
    end
end
function cls:setBeforeWinShow( delay )
    if self.rets then
        self.rets["before_win_show"] = true
        if delay then
            self.rets["before_win_show"] = delay
        end
    end
end
function cls:before_win_show( rets )
    local delay = rets["before_win_show"]
    rets["before_win_show"] = nil
    if delay and type(delay) == "number" then
        self:laterCallBack(delay, function ()
            self:addScreenShaker()
        end)
        
        self:laterCallBack(delay + 60/30, function ()
            self:stopScreenShaker()
            self:handleResult()
        end)
    else
        self:addScreenShaker()
        self:laterCallBack(60/30, function ()
            self:stopScreenShaker()
            self:handleResult()
        end)
    end
end

function cls:getBigWinStatus(baseWin)
    baseWin = baseWin or 0
    local mul = baseWin / self:getCurTotalBet()
    if mul >= 10 then 
        return true
    end
    return false
end
function cls:addScreenShaker()
    local function shakeEnd()
        self.shaker = nil
        self:stopMusicByName("sharke_jili")
    end
    local bgNode = cc.Node:create()
    local topNode = cc.Node:create()
    self.mainView.bgNode:addChild(bgNode, 10)
    self.mainView.down_child:addChild(topNode, 10)

    local data = {}
    data.file = self:getSpineFile("reel_anti")
    data.parent = bgNode
    data.animateName = "animation2"
    bole.addAnimationSimple(data)

    local bgType = self:getCurReelBoardType()
    -- if bgType ~= 1 then
    --     local data = {}
    --     data.file = self:getSpineFile("reel_anti")
    --     data.parent = topNode
    --     data.animateName = "animation3"
    --     bole.addAnimationSimple(data)
    -- else
        local data2 = {}
        data2.file = self:getSpineFile("reel_anti")
        data2.parent = topNode
        data2.animateName = "animation1"
        bole.addAnimationSimple(data2)
    -- end
    -- local pFile = self.ctl:getParticleFile("bj_2")
    -- local lizi = cc.ParticleSystemQuad:create(pFile)
    -- if lizi and bole.isValidNode(lizi) then
    --     node:addChild(lizi,-1)
    -- end
    -- local a1 = cc.DelayTime:create(1.2)
    -- local a2 = cc.CallFunc:create(function ()
    --     if lizi and bole.isValidNode(lizi) then
    --         lizi:stopSystem()
    --     end
    -- end)
    -- local a3 = cc.DelayTime:create(1)
    -- local a4 = cc.RemoveSelf:create()
    -- local a5 = cc.Sequence:create(a1,a2,a3,a4)
    -- node:runAction(a5)
    local time = 2
    self:playMusicByName("sharke_jili")
    self.shaker = ScreenShaker.new(self.mainView.shakerNode,time,shakeEnd)
    self.shaker:run()
end

function cls:stopScreenShaker()
    if self.shaker then
        self.shaker:stop()
        self.shaker = nil
    end
end



function cls:after_win_show( rets )
    rets["after_win_show"] = nil
    if self.freeCtl then
        self.freeCtl:after_win_show()
    else
        self:handleResult()
    end
end

function cls:playFadeToMaxVlomeMusic(  )
    local mvC = self.musicVolumeConfig
    self.audioCtl:dealMusic_FadeLoopMusic(mvC.time_volume, mvC.min_volume, mvC.max_volume)
end
function cls:playFadeToMinVlomeMusic(  )
    local mvC = self.musicVolumeConfig
    self.audioCtl:dealMusic_FadeLoopMusic(mvC.time_volume, mvC.max_volume, mvC.min_volume)
end

function cls:playRollupSound( mul )
   if mul >= 5 then 
        self:playFadeToMinVlomeMusic()
   end
   parentClass.playRollupSound(self, mul)
end

function cls:stopRollupSound(mul)
    local winLevel
    if mul >= 5 then 
        self:playFadeToMaxVlomeMusic()
    end
    parentClass.stopRollupSound(self, mul)
end
------------respin start----------
-- function cls:theme_deal_show(ret)
--     ret.theme_deal_show = nil
--     if self.respinStep == self.gameConfig.ReSpinStep.Over then
--         if self:getSlotMachineStatus() then
--             self.bonus:onRespinFinish(ret,true)
--         end
--     end
-- end
-- function cls:theme_respin( rets )
--     self.node:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(function()
--         local respinList = rets["theme_respin"]
--         if respinList and #respinList>0 then
--             rets["item_list"] = table.remove(respinList, 1)

--             local respinStopDelay = 1
--             local endCallFunc     = self:getTheRespinEndDealFunc(rets)
--             self:stopDrawAnimate()
--             self:respin(respinStopDelay, endCallFunc)
--         else
--             rets["theme_respin"] = nil
--         end 
--     end)))
-- end

------------respin end  ----------
------------get control start----------
-- function cls:getSlotMachineStatus( ... )
--     if self.showCurrentSpinBoard and self.showCurrentSpinBoard == SpinBoardType.MapSlot then
--         return true
--     end
--     return false
-- end
function cls:getNormalStatus( ... )
    if self.showCurrentSpinBoard and self.showCurrentSpinBoard == SpinBoardType.Normal then
        return true
    end
    return false
end
function cls:getMapFreeGameStatus()
    if self.showCurrentSpinBoard and self.showCurrentSpinBoard == SpinBoardType.MapFreeSpin then
        return true
    end
    return false
end
function cls:getGameMasterTime( ... )
    if (self.ctl and self.ctl.isMasterTheme and self.themeid and self.ctl:isMasterTheme(self.themeid)) or
        self:getFreeVCtl():gameMasterFlagStatus() then
        return true 
    else 
        return false 
    end
end
function cls:getFreeVCtl( ... )
    return self.freeCtl
end
-- function cls:getWheelVCtl(...)
--     return self.wheelCtl
-- end
function cls:getJpViewCtl( ... )
    return self.jpViewCtl
end
function cls:getCollectViewCtl( ... )
    return self.collectViewCtl
end
function cls:lockJackpotValue( data )
    data = data or {0,0,0,0}
    if self.jpViewCtl then
        self.jpViewCtl:lockJackpotValue(data)
    end
end
function cls:getBubbleViewCover( ... )
    return self.mainView.wildDimmer
end
function cls:showBaseBlackCover( ... )
    local wildDimmer = self:getBubbleViewCover()

    local _reelSpinConfig = self.gameConfig.reel_spin_config

    if wildDimmer then 
        wildDimmer:setOpacity(0)
        wildDimmer:setVisible(true)
        local a1 = cc.FadeTo:create(0.3, 150)
        local a2 = cc.DelayTime:create(_reelSpinConfig.extraJiliTime-0.5)
        local a3 = cc.FadeTo:create(0.3, 0)
        local a4 = cc.Sequence:create(a1,a2,a3)
        wildDimmer:runAction(a4)
    end
end
function cls:checkSpecialFeature( themeInfo, pCol )
    if (pCol == 1) and themeInfo and themeInfo["special_type"] and (themeInfo["special_type"] == 1) then
        return true
    end
    return false
end
function cls:addSpecailJili()
    self:dealMusic_FadeLoopMusic(0.2, 1, 0.3)
    self:laterCallBack(self.gameConfig.reel_spin_config.extraJiliTime, function ()
        self:dealMusic_FadeLoopMusic(0.2, 0.3, 1)
    end)

    self:showBaseBlackCover()
    self:playMusicByName("board_notify")
    local parent = self.mainView.specailJili
    local file = self:getSpineFile("jili_board")
    bole.addSpineAnimation(parent, 50, file, cc.p(0, 0), "animation")
end
function cls:getMapViewCtl( ... )
    return self.mapViewCtl
end
function cls:getMapInfoData( ... )
    local data = {}
    data.mapPoints = self.mapPoints or 0
    data.mapLevel  = self.mapLevel or 0
    data.preMapStatus = self.preMapStatus or {}
    data.curMapStatus = self.curMapStatus or {}
    return data
end
--------------------------------bet start----------------------------------
function cls:featureUnlockBtnClickEvent( _unLockType )
    if self.tipBetList and self.tipBetList[_unLockType] then
        self:setBet(self.tipBetList[_unLockType])
    end
end
--@setBet base class had
function cls:dealAboutBetChange( theBet, isPointBet )
    if (not self.tipBetList) or (not self.loadFinish) then
        return
    end
    theBet = theBet or self:getCurTotalBet()
    local maxBet = self:getMaxBet()
    self:changeCollectBet(theBet) 
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
function cls:changeUnlockJpBet( theBet )
    self.jpViewCtl:changeUnlockJpBet(theBet)
end
--------------------------------bet end  ----------------------------------

function cls:showBonusNode( ... )
    self:resetCurrentReels(false, false)
end
function cls:dealSpecialFeatureRet( data )
    self.tipBetList = data.bonus_level
    if data["map_info"] then
        self.mapInfo = data.map_info
        self.mapPoints = self.mapInfo.map_points
        self.mapLevel = self.mapInfo.map_level
        self.preMapStatus = self.mapInfo.pre_free_status
        self.curMapStatus = self.mapInfo.cur_free_status
    else
        self.mapInfo = {}
        self.mapLevel = 0
        self.mapPoints = 0
        self.preMapStatus = {}
        self.curMapStatus = {}
    end
    if self.mapLevel >= 100 then
        self.mapLevel = 100
    end
end
function cls:dealBonusGameResumeRet( data )
    if data["bonus_game"] and data["bonus_game"]["win_wheel"] then
		self.isPickChooseRecover = true
	end
end
function cls:adjustTheme( data )
    self.isGameMasterTime = self:getGameMasterTime()

    --ActivityCenterControl:getInstance():isMasterTheme(self.themeid)
    self.isEnterGameMaster = true

    self.loadFinish = true
    if data.bonus_game then
        self.isEnterGameMaster = false
        self.showSpecailFeatureBoard = true
        if data.free_game then
            if self.freeCtl and self.freeCtl:getMapFreeStatus() then
                self:changeSpinBoard("MapFreeSpin")
            else
                self:changeSpinBoard("FreeSpin")
            end
        else
            self:changeSpinBoard("Normal")
        end
    elseif data.free_game or data.first_free_game then
        self.isEnterGameMaster = false
        self.showSpecailFeatureBoard = true
        if data.first_free_game then
            self:changeSpinBoard("Normal")
        else
            if self.freeCtl and self.freeCtl:getMapFreeStatus() then
                self:changeSpinBoard("MapFreeSpin")
            else
                self:changeSpinBoard("FreeSpin")
            end
        end
    else
        -- self:changeSpinBoard("Normal")
        self:playMusicByName("base_welcome")
    end
    
    -- if not self.isEnterGameMaster then
    --     self:enableMapInfoBtn(false)
    -- else
    --     self:enableMapInfoBtn(true)
    -- end
    self:showCurrentCollectShow()
end
function cls:showCurrentCollectShow( ... )
    if self.mapPoints and self.collectViewCtl then
        self.collectViewCtl:setCollectProgressImagePos(self.mapPoints)
    end
end
function cls:changeSpinBoard( pType )
    local boardType = SpinBoardType[pType]
    if pType == "MapFreeSpin" then
        if self.footer then
            self.footer:changeFreeSpinLayout3()
        end
    end
    self.lockedReels = nil
    self.showCurrentSpinBoard = boardType
    self.showCurReelBoard = boardType
    local reelType = boardType
    if boardType ~= 1 then 
        local sType = self.freeCtl:getFreeBgType()
        reelType = sType
        self.showCurReelBoard = sType
        self.mainView:updateBg(sType)
        if self:getGameMasterTime() then 
            self.mainView:setGameMasterTipEnable(true)
        else 
            self.mainView:setGameMasterTipEnable(false)
        end
    else 
        self.mainView:setGameMasterTipEnable(false)
        self.mainView:updateBg(boardType)
    end 
    self.mainView:updateCollectUI(boardType)
    self:setThemeType()

    if self.jpViewCtl then 
        self.jpViewCtl:changeSpinBoard(reelType)
    end
end

function cls:getCurSpinBoardType()
    return self.showCurrentSpinBoard or 1
end

function cls:getCurReelBoardType()
    return self.showCurReelBoard or 1
end

function cls:stopDrawAnimate( ... )
    self.mainView:stopDrawAnimate()
    if self.freeCtl then
        self.freeCtl:stopDrawAnimate()
    end
end

function cls:stopChildActionsSpecial(...)
    self.mainView:stopChildActionsSpecial(...)
end

---------------- bonus conection start------------------
function cls:showMapFeature(delay)
    delay = delay or 1
    local a1 = cc.DelayTime:create(delay)
    local a2 = cc.CallFunc:create(function ( ... )
        self:getMapViewCtl():showMapScene(nil, true)
        if self.newMapStatus then 
            self.curMapStatus = self.newMapStatus
            self.newMapStatus = nil
        end
    end)
    local a3 = cc.DelayTime:create(3)
    local a4 = cc.CallFunc:create(function ( ... )
        self:getMapViewCtl():exitMapScene(true)
    end)
    local a5 = cc.Sequence:create(a1,a2,a3,a4)
    libUI.runAction(self.node, a5)
end
function cls:playBonusAnimate( theGameData )
    local delay = 3
    if theGameData and theGameData["map_pick"] then

        self:stopAllLoopMusic()

        delay = 5 + 2
        self.collectViewCtl:showCollectFullAnimation()
        self:showMapFeature(3)
    elseif theGameData and theGameData["jackpot_bonus"] then 
        delay = 0
        self.yinBaseCount = 0
        self.yangBaseCount = 0
    elseif theGameData and theGameData["wheel_bonus"] then
        delay = 0
    elseif theGameData and theGameData["win_wheel"] then
        self:stopDrawAnimate()
        self:stopAllLoopMusic()
        self:playMusicByName("trigger_bell")
        self:playScatterAnimate(self.specials, self.gameConfig.special_symbol["scatter"], true)
    end
    return delay
end
function cls:playNormalRapidAnimate()
    local yinSymbolContain = self.specialItemConfig[self.gameConfig.special_symbol.moon]["symbol_contain"]
    local yangSymbolContain = self.specialItemConfig[self.gameConfig.special_symbol.sun]["symbol_contain"]
    local yangAward = 0
    local yinAward = 0
    if self.yinBaseCount and self.yinBaseCount >= 3 and self.yinBaseCount <= 4 then 
        yinAward = 1
    end
    if self.yangBaseCount and self.yangBaseCount >= 3 and self.yangBaseCount <= 4 then  
        yangAward = 1
    end
    self:addJpBonusAnimate(yinAward, yangAward)
    -- self:playJpBonusAnimate(1,1)
end

function cls:playJpBonusAnimate(jackpotData, item_list)
    item_list = item_list or self.item_list
    local yinAward  = 0
    local yangAward = 0
    local gameMasterJpId = 10

    local jpWinJp = jackpotData.win_jp
    if jpWinJp and #jpWinJp > 1 then
        yinAward = 1
        yangAward = 1
    elseif jpWinJp and #jpWinJp > 0 then
        if jpWinJp[1]["jp_win_type"] == gameMasterJpId then 
            local status = self:getGameJpCount(item_list)
            if status == "sun" then 
                yangAward = 1
            elseif status == "moon" then
                yinAward = 1
            end
        else 
            if jpWinJp[1]["jp_win_type"] < 5 then 
                yangAward = 1
            else 
                yinAward = 1
            end
        end
    end
    if jackpotData.yin_total_win > 0 then 
        yinAward = 1
    end
    if jackpotData.yang_total_win > 0 then 
        yangAward = 1
    end
    self:addJpBonusAnimate(yinAward, yangAward, item_list)
end
function cls:getGameJpCount( item_list )
    local yin_count = 0
    local yang_count = 0
    local yinSymbolContain = self.specialItemConfig[self.gameConfig.special_symbol.moon]["symbol_contain"]
    local yangSymbolContain = self.specialItemConfig[self.gameConfig.special_symbol.sun]["symbol_contain"]
    if item_list then 
        for col, val in ipairs(item_list) do
            for row, item in ipairs(val) do 
                if yinSymbolContain[item] then
                    yin_count = yin_count + 1
                end 
                if yangSymbolContain[item] then
                    yang_count = yang_count + 1
                end
            end
        end
    end 
    if yin_count >= 9 then 
        return "moon"
    elseif yang_count >= 9 then 
        return "sun"
    end
    return "normal"
end
function cls:addJpBonusAnimate(yinAward, yangAward, item_list)
    yinAward = yinAward or 0
    yangAward = yangAward or 0
    item_list = item_list or self.item_list
    if yinAward == 0 and yangAward == 0 then return end
    local yinSymbolContain = self.specialItemConfig[self.gameConfig.special_symbol.moon]["symbol_contain"]
    local yangSymbolContain = self.specialItemConfig[self.gameConfig.special_symbol.sun]["symbol_contain"]
    local doubleItem = self.gameConfig.special_symbol.double_rapid

    if item_list then 
        for col, val in ipairs(item_list) do
            for row, item in ipairs(val) do 
                local animName = "animation_3"-- "animation"..(item - 9).."_3"
                local rapidType = "double"
                if (yinAward > 0) and yinSymbolContain[item] then
                    rapidType = doubleItem ~= item and "moon" or rapidType
                    self.mainView:addItemSpine(item, col, row, true, animName, rapidType) -- self.gameConfig.special_symbol.double_rapid
                elseif (yangAward > 0) and yangSymbolContain[item] then
                    rapidType = doubleItem ~= item and "sun" or rapidType
                    self.mainView:addItemSpine(item, col, row, true, animName, rapidType)
                end
                
            end
        end
    end
end
function cls:continueNextBouns(data)
    if self.bonus then
        self.bonus:submitLastBonusData(data)
    end
end
---------------- bonus conection end  ------------------


---------------- free conection start  ------------------
function cls:getNormalFgStatus( ... )
    if self.showCurrentSpinBoard == SpinBoardType.MapFreeSpin then
        return false
    end
    return true
end
function cls:enterFreeSpin( isResume )
    self:setFeatureState(self.gameConfig.FeatureName.Free, true)

    if isResume then  -- 断线重连的逻辑
        if self.freeCtl then
            if self.freeCtl:getNormalFgStatus() then
                self:changeSpinBoard("FreeSpin")
            else
                self:changeSpinBoard("MapFreeSpin")
            end
        end
        -- self:changeSpinBoard("FreeSpin")--  更改棋盘显示 背景 和 free 显示类型
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
    -- self:changeSpinBoard(SpinBoardType.FreeSpin)
end
function cls:hideFreeSpinNode( ... )
    self:changeSpinBoard("Normal")
    self:removePointBet()
    self:setDealFreeCollectState()
    if self.freeCtl then
        self.freeCtl:hideFreeSpinNode()
    end
    if self.jpViewCtl then 
        self.jpViewCtl.jpView:updateJpShow()
    end
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
    self:setFeatureState(self.gameConfig.FeatureName.Free, true)

    if self.freeCtl then 
        self.freeCtl:playStartFreeSpinDialog(theData)
    else
        if theData.enter_event then 
            theData.enter_event()
        end

        if theData.click_event then 
            theData.click_event()
        end

        if theData.changeLayer_event then 
            theData.changeLayer_event()
        end

        if theData.end_event then 
            theData.end_event()
        end
    end
end
function cls:playMoreFreeSpinDialog( theData )
    if self.freeCtl then 
        self.freeCtl:playMoreFreeSpinDialog(theData)
    else
        if theData.enter_event then 
            theData.enter_event()
        end

        if theData.click_event then 
            theData.click_event()
        end

        if theData.end_event then 
            theData.end_event()
        end
    end
end
function cls:playCollectFreeSpinDialog( theData )
    if self.freeCtl then 
        self.freeCtl:playCollectFreeSpinDialog(theData)
    else
        if theData.enter_event then 
            theData.enter_event()
        end

        if theData.click_event then 
            theData.click_event()
        end

        if theData.changeLayer_event then 
            theData.changeLayer_event()
        end

        if theData.end_event then 
            theData.end_event()
        end
    end
end

function cls:collectFreeRollEnd( ... )
    self:finshSpin()

	self:setFeatureState(self.gameConfig.FeatureName.Free, false)	
end

function cls:playFreeSpinItemAnimation( theSpecials ,enterType )
    if (not theSpecials) then
        return 0
    end
    if enterType then
        self:setFeatureState(self.gameConfig.FeatureName.Free, true)
    end
    local delay = 0
    self:stopDrawAnimate()
    if enterType == 'free_spin' then
    elseif enterType == 'more_free_spin' then
        delay = 3
        self:playMusicByName("trigger_bell")
        self:playScatterAnimate(theSpecials, self.gameConfig.special_symbol["scatter"], true)
    else
        self:playScatterAnimate(theSpecials, self.gameConfig.special_symbol["scatter"], true)
        delay = 3
    end
    return delay
end
function cls:playScatterAnimate( theSpecials, itemKey, isLoop )
    local scatterNumber = 0
    if theSpecials and theSpecials[itemKey] then 
        for col, rowTagList in pairs(theSpecials[itemKey]) do
            for row, tagValue in pairs(rowTagList) do
                scatterNumber = scatterNumber + 1
            end
        end
    end
    if theSpecials and theSpecials[itemKey] then 
        for col, rowTagList in pairs(theSpecials[itemKey]) do
            for row, tagValue in pairs(rowTagList) do
                if scatterNumber >= 3 then
                    self.mainView:addItemSpine(itemKey, col, row, isLoop)
                end
            end
        end
    end
end



---------------- free conection end  ------------------
function cls:setThemeType( ... )
    local themeType = "payLine"
    local themeTypeConfig = self:getPayLineData()
    self.lines   = themeTypeConfig.pay_lines
    self.maxLine = themeTypeConfig.line_cnt
    self.themeType       = themeType
    self.themeTypeConfig = themeTypeConfig
end
function cls:getPayLineData( ... )
    local _payLine = self.gameConfig.pay_line.pay_line_normal
    return _payLine
end
function cls:getCurrentBase( ... )
    if self.showCurrentSpinBoard == SpinBoardType["Normal"] then
        return true
    end
    return false
end

function cls:dealMusic_EnterBonusGame()
    local mvC = self.musicVolumeConfig
    AudioControl:stopGroupAudio("music")
    self:playLoopMusic(self.audio_list.wheel_background)
    AudioControl:volumeGroupAudio(mvC.max_volume)
end

function cls:dealMusic_MapFreeBonusGame()
    local mvC = self.musicVolumeConfig
    AudioControl:stopGroupAudio("music")
    self:playLoopMusic(self.audio_list.mapfree_background)
    AudioControl:volumeGroupAudio(mvC.max_volume)
end
function cls:dealMusic_PlayNormalLoopMusic()
    -- 播放背景音乐
    local mvC = self.musicVolumeConfig
	AudioControl:stopGroupAudio("music")
    self.audioCtl:playLoopMusic(self.audio_list.base_background)
    AudioControl:volumeGroupAudio(mvC.max_volume)
end
-- 播放free games的背景音乐
function cls:dealMusic_PlayFreeSpinLoopMusic() -- 播放背景音乐
    local mvC = self.musicVolumeConfig
    AudioControl:stopGroupAudio("music")
    if self.freeCtl then
        if self.freeCtl:getMapFreeStatus() then
            self.audioCtl:dealMusic_PlayGameLoopMusic(self.audio_list.mapfree_background)
        else
            self.audioCtl:dealMusic_PlayGameLoopMusic(self.audio_list.free_background)
        end
    end
    AudioControl:volumeGroupAudio(mvC.max_volume)
end
function cls:dealMusic_StopNormalLoopMusic()
    AudioControl:stopGroupAudio("music")
    AudioControl:volumeGroupAudio(0)
end
--------------- bigwin start stop ---------------

function cls:dec2Bin(dec)
	local temp = {}
    local result = ''
    local sign = 1
    dec = dec or 0
    if dec < 0 then
        sign = -1
    end
	dec = math.abs(dec)
	while dec ~= 0  do
		local quo = dec % 2
		dec = math.floor(dec/2)
        table.insert(temp, quo)
        result = result..quo
    end
	return temp
end
------------------- gamemaster start ---------------
function cls:addListenEvent()
	EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.C_GAME_MASTER_START, "theme325", self.showGameMasterUI, self)
	EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.C_GAME_MASTER_END, "theme325", self.hideGameMasterUI, self)
end
function cls:removeListenEvent()
	EventCenter:removeEvent(EVENTNAMES.ACTIVITY_THEME.C_GAME_MASTER_START, "theme325")
    EventCenter:removeEvent(EVENTNAMES.ACTIVITY_THEME.C_GAME_MASTER_END, "theme325")
    
    EventCenter:removeTag("theme325_base")
end
function cls:showGameMasterUI()
    if self.showCurrentSpinBoard ~= 1 then --展示fg中的显示情况
        if self:getGameMasterTime() then 
            self.mainView:setGameMasterTipEnable(true)
        else 
            self.mainView:setGameMasterTipEnable(false)
        end
    end
    if self.jpViewCtl and self.jpViewCtl.jpView then 
        self.jpViewCtl.jpView:updateJpShow()
    end
end
function cls:hideGameMasterUI()
    if self.jpViewCtl and self.jpViewCtl.jpView then 
        self.jpViewCtl.jpView:updateJpShow()
    end
    self.mainView:setGameMasterTipEnable(false)
end
------------------- gamemaster end -----------------


------------------- map free end ------------------
---@param theData /info
---@param sType /1:start 2:more 3:collect
---@param index /1:free 2:jp 3:map/wheel,pick
function cls:showThemeDialog(theData, sType, csbName, dialogType)
    self:playFadeToMinVlomeMusic()
    local end_event = theData.click_event
    local theDialog = nil
    dialogType = dialogType or csbName
    theData.click_event = function()
        self:playFadeToMaxVlomeMusic()
        if end_event then
            end_event()
        end
        if sType == fs_show_type.start or sType == fs_show_type.collect then
            self:playMusicByName("common_click")
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
    config["csb_file"] = self:getCsbPath(csbName)
    config["frame_config"] = {
        ["start"]   = { nil, 1, nil, 2 },
        ["more"]    = { nil, 3, nil, 2 },
        ["collect"] = { nil, 1, nil, 2 },
    }
    config.dialog_config = themeConfig.dialog_config[dialogType]
    theDialog = ThemeBaseDialog.new(self.ctl, config, themeConfig.dialog_config["black_common"])
    if sType == fs_show_type.start then
        theDialog:showStart(theData)
    elseif sType == fs_show_type.more then
        theDialog:showMore(theData)
    elseif sType == fs_show_type.collect then
        theDialog:showCollect(theData)
    end
    return theDialog
end

function cls:getShowDialogData(d_name)
	if d_name and self.gameConfig and self.gameConfig.dialog_config and self.gameConfig.dialog_config[d_name] then 
		local data = {
			dType = 1,
			dName = d_name,
			dConfig = self.gameConfig.dialog_config[d_name],
            -- extra_click_event = function()
            --     self:laterCallBack(25/30, function ()
            --         self.mainView:playWelComePersonAni()
            --     end)
            -- end
		}
		return data
	end
end

function cls:noFeatureResume()
    return true
end

function cls:onExit()
    parentClass.onExit(self)
    if self.bonus then 
        self.bonus:onExit()
        self.bonus = nil
    end
    self:removeListenEvent()
    self:stopScreenShaker()
end

function cls:spinButtonPressed( ... )
    if self.mainView and self.mainView.spinButtonPressed then 
        self.mainView:spinButtonPressed()
        -- self:hideMasterGameStartPopup()  
    end

end

function cls:checkInFeature()
    if self.mapViewCtl and self.mapViewCtl.checkInFeature then
        return self.mapViewCtl:checkInFeature()
    end
end

function cls:changeFooterTips(changeType , changeLevel)
	--self.mainView:changeFooterTips(changeType , changeLevel)
end

function cls:setHeaderEnable( enable, pushData )
    if enable then
        EventCenter:pushEvent(EVENTNAMES.THEME.HEADER_SHOW, pushData)
    else 
        EventCenter:pushEvent(EVENTNAMES.THEME.HEADER_HIDE, pushData)
	end
	
	local pushData = {
		state = not enable,
	}
	EventCenter:pushEvent(EVENTNAMES.THEME.SET_HELPSHIFT, pushData )
end

--------------------------------------------------------------------------------------------------------------------
--@region 激励假轴
function cls:changeReel(isChangeReel, colIndex)
	if isChangeReel then
		self.reelJiliStatus = self.reelJiliStatus or {}
		self.reelJiliStatus[colIndex] = isChangeReel
	else
		self.reelJiliStatus = nil
	end
end

function cls:getJiliReel(colid)
    if self.theme_reels.scatter_reel and self.theme_reels.scatter_reel[colid] then
        return self.theme_reels.scatter_reel[colid]
    end
end

---@override
function cls:getNextSprite(colid, rowIndex)
    self.caches[colid] = self.caches[colid] or {}
    self.theCaches[colid] = self.theCaches[colid] or {}

    -- 初始化棋盘 指定样式
    if rowIndex and self.theCaches[colid][rowIndex] then
        local theKey = self.theCaches[colid][rowIndex]
        self.theCaches[colid][rowIndex] = nil
        return theKey
    end
    if self.reelJiliStatus and self.reelJiliStatus[colid] then
        local jiliReel = self:getJiliReel(colid)
        if jiliReel then
            local c = self:addCurrentReelIndex(colid, true)
            local retKey = jiliReel[c]
            return retKey
        end
    end
	return parentClass.getNextSprite(self, colid)
end
---@override
function cls:addCurrentReelIndex(colid, isJili)
	if not isJili then
		return parentClass.addCurrentReelIndex(self, colid)
	else
        local jiliReel = self:getJiliReel(colid)
        if jiliReel then 
            local nextIndex = self.currentReelsIndex[colid] % #jiliReel + 1
            self.currentReelsIndex[colid] = nextIndex
            return nextIndex
        else 
            return 1
        end
	end
end
--@endregion
--------------------------------------------------------------------------------------------------------------------
--@region
-- for payout
---@overload for payout
function cls:adjustWithBetChange( theBet, isPointBet )
    -- if User:getInstance():getThemePayoutTestAnim(self.themeid) then 
    --     if self:checkIsPayoutBet() then
    --         self.mainView:showFooterPayoutLoop(true)
    --     else
    --         self.mainView:showFooterPayoutLoop(false)
    --     end
    -- end
	-- if self:checkIsPayoutBetSingle(theBet) then
    --     self:setThemeFooterFlag(true)
    -- else
		-- self:setThemeFooterFlag(false)
	-- end
	self:dealAboutBetChange(theBet, isPointBet)
	local data = { ["bet"] = theBet, ["isPointBet"] = isPointBet}
	EventCenter:pushEvent(EVENTNAMES.THEME.CHANGE_BET, data)
end

function cls:playExtraFooterEffect(rollTime)
	self:checkShowPayoutFooterAni(rollTime)
end

function cls:checkShowPayoutFooterAni(rollTime)
	local isPayoutExtraWin = User:getInstance():getThemePayoutTestAnim(self.themeid) and self:checkIsPayoutBet()
	if isPayoutExtraWin then
		self.mainView:showFooterPayoutEffect(rollTime)
	end
end

function cls:getFooterWinNode( ... )
	return self.footer:getFooterWinNode( ... )
end


--@endregion
--------------------------------------------------------------------------------------------------------------------
--@region
-- for welcome 逻辑
function cls:getEnterThemeProcess()
    self.enterThemeProcessList = {
        common_first = true,
        common_reconnect_feature = true,
        common_hide_loading_delay = true,
        theme_pop = false,
        theme_pop_gm = true,
        theme_pop_ac = true,
        theme_pop_wel = true,
        common_system_push = true,
        theme_last_action = true,
    }
    if self:noFeatureResume() and self:noFeatureLeft() then
        self.enterThemeProcessList.theme_pop = true
    end
	return self.enterThemeProcessList
end
--@endregion
--------------------------------------------------------------------------------------------------------------------


return cls