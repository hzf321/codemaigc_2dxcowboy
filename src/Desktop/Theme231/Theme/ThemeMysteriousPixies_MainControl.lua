--Author:WangHongJie art:YuanKe  math:LiJingYi  plan:WangJinYing
--Email:wanghongjie@bolegames.com
--2020年 12 月 21 日 16:00
--Using:主题 ThemeLuckyBee

local parentClass = ThemeBaseViewControl -- Theme -- 
ThemeMysteriousPixies_MainControl = class("ThemeMysteriousPixies_MainControl", parentClass) -- 
local cls = ThemeMysteriousPixies_MainControl

require (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_FreeControl")) 
require (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_JpControl")) 
require (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_CollectControl")) 
require (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_MainView")) 
require (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_BetFeatureControl"))
local bgBConfig = require (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_Config")) 

------------------------------------ 资源异步加载相关 ----------------------------------------
function cls:ctor(themeid, theScene)
	self.gameConfig = bgBConfig
	local _theme_config = self.gameConfig.theme_config
	self.spinActionConfig = tool.tableClone(_theme_config.spin_action_config)
	self.ThemeConfig = tool.tableClone(_theme_config)
	self.baseBet = _theme_config.base_bet
	self.DelayStopTime = 0
	self.UnderPressure = _theme_config.under_pressure -- 下压上 控制

	local ret = parentClass.ctor(self, themeid, _theme_config.is_portrait, theScene)

	self.curBoardCnt = 1
	-- EventCenter:registerEvent(EVENTNAMES.THEME.CHANGE_BET, self.onBetChange, self)
	-- EventCenter:registerEvent(EVENTNAMES.THEME.SPIN_START, self.refreshReelLevelShowBySpin, self)

    return ret
end

function cls:getGameConfig()
	return self.gameConfig
end

function cls:initGameControlAndMainView()
	
	self.jpViewCtl 		= ThemeMysteriousPixies_JpControl.new(self)
	self.freeCtl 		= ThemeMysteriousPixies_FreeControl.new(self)
	self.betFeatureVCtl = ThemeMysteriousPixies_BetFeatureControl.new(self)
	self.collectVCtl 	= ThemeMysteriousPixies_CollectControl.new(self)
	

	self.mainView = ThemeMysteriousPixies_MainView.new(self)

	parentClass.initGameControlAndMainView(self)
end

function cls:getJpViewCtl()
	return self.jpViewCtl
end

function cls:getCollectViewCtl()
	return self.collectVCtl
end

function cls:getFreeVCtl()
	return self.freeCtl
end

function cls:getBetFeatureVCtl()
	return self.betFeatureVCtl
end

function cls:getThemeControl()
	return self
end

function cls:getMainView()
	return self.mainView
end

function cls:getSpecialFeatureRoot(nType)
	return self.mainView:getSpecialFeatureRoot(nType)
end

function cls:getBaseBet()
	return self.baseBet
end

function cls:getCurBoardCnt()
	return self.curBoardCnt
end

function cls:getBoardConfig()
	if self.boardConfigList then
		return self.boardConfigList
	end
	
	local boardConfig = tool.tableClone(self.ThemeConfig["boardConfig"])

    for idx = 1, #boardConfig do
        local temp = boardConfig[idx]
        if not temp then
            return
        end
        local newReelConfig = {}
         -- base and free  and slotMap
		for _, posList in pairs(temp.reelConfig) do
			for col=1, temp.colCnt do 
				local oneConfig = {}
				oneConfig["base_pos"] 	= cc.p((col-1)*temp["cellWidth"]+posList["base_pos"].x,posList["base_pos"].y)
		 		oneConfig["cellWidth"] 	= temp.cellWidth
				oneConfig["cellHeight"] = temp.cellHeight
				oneConfig["symbolCount"]= temp.rowCnt
				table.insert(newReelConfig,oneConfig)
			end
		end
		boardConfig[idx]["colReelCnt"] = temp.colCnt

        boardConfig[idx]["reelConfig"] = newReelConfig
    end

	self.boardConfigList = boardConfig

	return boardConfig
end

function cls:changeSpinBoard(pType) -- 更改背景控制 已修改
	local board_type_config = self.gameConfig.SpinBoardType

	local boardType = board_type_config[pType]

	self:stopDrawAnimate()
	self.mainView:resetBoardShowNode(pType)
	self:resetFeatureBoardShow(boardType)

	if boardType == board_type_config.Normal then -- normal情况下 需要更改棋盘底板
		self.showFreeSpinBoard = false
		self.showBaseSpinBoard = true

	elseif boardType == board_type_config.FreeSpin then
		self.showFreeSpinBoard = true
		self.showBaseSpinBoard = false

		if self.betFeatureVCtl then 
			self.betFeatureVCtl:topSetBet()
		end

	elseif boardType == board_type_config.Bonus then
		self.showBaseSpinBoard = false
		self.showFreeSpinBoard = false

	end
end

function cls:resetFeatureBoardShow( boardType, isAnimate )
	if self.collectVCtl then 
		self.collectVCtl:resetBoardShowByFeature(boardType)
	end

	if self.jpViewCtl then 
		self.jpViewCtl:resetBoardShowByFeature(boardType)
	end

	if self.jpViewCtl then 
		self.jpViewCtl:resetBoardShowByFeature(boardType)
	end

	if self.betFeatureVCtl then 
		self.betFeatureVCtl:resetBoardShowByFeature(boardType, isAnimate)
	end
end


function cls:checkIsShowFreeSpinBoard( )
	return self.showFreeSpinBoard
end

-----------------------------------------------------------------------------------------

function cls:setLockFeatureState( ... )
	self.lockFeatureState = {} -- 默认解锁状态
	for _, ftype in pairs(self.gameConfig.unlockInfoTypeList) do 
		self:changeFeatureState(ftype, true)
		self.lockFeatureState[ftype] = false
	end
end

function cls:featureUnlockBtnClickEvent( _unLockType )
	if self.lockFeatureState[_unLockType] and self.unLockBetList and self.unLockBetList[_unLockType] then
		self:setBet(self.unLockBetList[_unLockType])
		return
	end
end

function cls:checkFeatureIsLock( ftype )

	if ftype and self.lockFeatureState[ftype] then 
		return true
	end
	return false
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

	-- if not self.collectVCtl:hasMapData() then 
	-- 	return false
	-- end
	
	return canTouch
end

function cls:hasFeature( fType )
	local _hasFeature = false
	if self.featureStateList and self.featureStateList[fType] then 
		_hasFeature = true
	end
	return _hasFeature
end

function cls:checkLockFeature( bet ) 
	if not(
		self.unLockInfoData 
		and self.lockFeatureState 
		and self.jpViewCtl:checkHasJackpotLockNode() 
		and self.unLockBetList) then 
			return 
	end

	local bet = bet or self:getCurTotalBet()
	local curUnlockBet = 0
	local showUnlockLevel = 0
	local unlockJpLevel

	for _unlockLevel, _unlockBetL in pairs(self.unLockInfoData) do 
		local _unlockBetN = tonumber(_unlockBetL)
		if bet >=_unlockBetN then 
			showUnlockLevel = _unlockLevel
		end
	end

	local needMusicName
	local isChangeState
	local changeLevel
	if showUnlockLevel then
		for unlockType, state in pairs(self.lockFeatureState) do 
			if unlockType <= showUnlockLevel and state then -- 解锁的
				needMusicName = "unlock"
				isChangeState = true
				
				changeLevel = unlockType
				if self.jpViewCtl:checkUnlockTypeIsJackpot(unlockType) then
					unlockJpLevel = unlockType
				end

				self:changeFeatureState(unlockType, true)
				self.lockFeatureState[unlockType] = false
			end

			if unlockType > showUnlockLevel and (not state) then -- 上锁
				needMusicName = "lock"
				isChangeState = true
				
				changeLevel = unlockType

				if self.jpViewCtl:checkUnlockTypeIsJackpot(unlockType) and (not unlockJpLevel or unlockJpLevel > unlockType) then
					unlockJpLevel = unlockType
				end

				self:changeFeatureState(unlockType, false)
				self.lockFeatureState[unlockType] = true
			end
		end
	end

	if isChangeState and changeLevel then 
		if needMusicName == "unlock" then 
			if self.jpViewCtl:checkUnlockTypeIsJackpot(self.gameConfig.unlockInfoTypeList[changeLevel]) then 
				self:playMusicByName("jp_unlock")
			else
				self:playMusicByName("collect_unlock")
			end
		else
			if self.jpViewCtl:checkUnlockTypeIsJackpot(self.gameConfig.unlockInfoTypeList[changeLevel]) then 
				self:playMusicByName("jp_lock")
			else
				self:playMusicByName("collect_lock")
			end
		end

		if unlockJpLevel then
			-- 展示提示弹窗
			self.jpViewCtl:playChangeJakcpotStateTip(needMusicName, unlockJpLevel)
		end
	end
end

function cls:changeFeatureState( unlockType, showUnlock )
	if showUnlock then -- 解锁
		if self.jpViewCtl:checkUnlockTypeIsJackpot(unlockType) then 
			self.jpViewCtl:changeJackpotLockState(unlockType, showUnlock)

		elseif unlockType == self.gameConfig.unlockInfoConfig.Map then 
			if self.collectVCtl then 
				self.collectVCtl:changeCollectLockState(showUnlock)
			end

		end
	else -- 上锁
		if self.jpViewCtl:checkUnlockTypeIsJackpot(unlockType) then 
			self.jpViewCtl:changeJackpotLockState(unlockType, showUnlock)
		
		elseif unlockType == self.gameConfig.unlockInfoConfig.Map then 
			if self.collectVCtl then
				self.collectVCtl:changeCollectLockState(showUnlock)
			end

		end
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--@ jackpot 
function cls:updateJackpotByBet(bet) -- todo  改成event
	self.jpViewCtl:updateJackpotByBet(bet)
end

function cls:getJackpotValue(incrementList,mul)
	self.jpViewCtl:getJackpotValue(incrementList,mul)
end

function cls:getResetValue(jp_level,mul)
	self.jpViewCtl:getResetValue(jp_level,mul)
end

function cls:lockJackpotMeters(lock,index)
	self.jpViewCtl:lockJackpotMeters(lock,index)
end

function cls:formatJackpotMeter(n)
	self.jpViewCtl:formatJackpotMeter(n)
end

-- function cls:getThemeJackpotConfig()
-- 	local jackpot_config_list = self.gameConfig.jackpotConfigList
	
-- 	return jackpot_config_list
-- end
----------------------------------------- 滚轴蒙层控制 ----------------------------------
function cls:checkCanPlayMaskAnim()
	-- local canPlay = false
	-- if (self.showBaseSpinBoard or self.showFreeSpinBoard) then 
	-- 	canPlay = true
	-- end
	-- return canPlay
end

----------------------------------------------------------------------------------------------------------------------------------
--@ free 相关 
---------------------------------- freeSpin --------------------------------------------

function cls:playStartFreeSpinDialog( theData )
	
	self:stopAllLoopMusic()
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
	
	self:stopAllLoopMusic()

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

function cls:enterFreeSpin( isResume ) -- 更改背景图片 和棋盘

	self:setFeatureState(self.gameConfig.FeatureName.Free, true)
	self:changeSpinBoard("FreeSpin")--  更改棋盘显示 背景 和 free 显示类型

	if isResume then  -- 断线重连的逻辑
		self:dealMusic_PlayFreeSpinLoopMusic()-- 切换背景音乐
	end
	
	self.mainView:showAllItem()
	self.playNormalLoopMusic = false --commonMusic: freespin背景音乐
end

function cls:showFreeSpinNode( count, sumCount, first )
	self:resetPointBet()

	parentClass.showFreeSpinNode(self, count, sumCount, first)
end

function cls:hideFreeSpinNode( ... ) -- 逻辑是个啥
	
	self.curWinFreeCountList = nil

	if self.freeCtl then 
		self.freeCtl:clearFreeFeatureData(true)
	end

	self:changeSpinBoard("Normal")

	-- 手动调用一下 bet 修改
	self:removePointBet()

	parentClass.hideFreeSpinNode(self, ...)
end


function cls:collectFreeRollEnd( ... )
    self:finshSpin()

    self:setFeatureState(self.gameConfig.FeatureName.Free, false)	
end

----------------------------------------------------------------------------------------------------------------------------------
--@ 棋盘假轴
function cls:getFreeReel( )
	local data = self.gameConfig.theme_reels["free_reel"]

	local temp = {}
	local _theme_config = self.gameConfig.theme_config

	for boardID = 1, self.curBoardCnt do 
		for col = 1, _theme_config.base_col_cnt do
			local realCol = (boardID-1)*_theme_config.base_col_cnt + col
			temp[realCol] = data[col]
		end
	end 

	return temp
end

function cls:getMainReel( )
	local data = self.gameConfig.theme_reels["main_reel"]
	return data
end
----------------------------------------------------------------------------------------------------------------------------------
-- @ 初始化 enterTheme 数据
function cls:dealSpecialFeatureRet( data )
	if data.bonus_level then
		self:updateUnlockInfo(data)
	end

	if data["map_info"] and self.collectVCtl then
		self.collectVCtl:dealCollectResumeData(data)
	end

	if self.betFeatureVCtl and data["theme_info"] then 
		self.betFeatureVCtl:refreshDiskData(data["theme_info"]) -- 更新disk数据
	end

end

function cls:dealFreeGameResumeRet(data)
	if self.freeCtl then
		self.freeCtl:dealFreeGameResumeRet(data)
	end
end

function cls:updateUnlockInfo( data )
	self.unLockInfoData = tool.tableClone(data.bonus_level)
	self.unLockBetList = {}
	for _unLockType, _bet in pairs(self.unLockInfoData) do 
		self.unLockBetList[_unLockType] = _bet
	end
end

function cls:adjustTheme(data)
	self:setLockFeatureState()
	
	if self.collectVCtl then 
		self.collectVCtl:refreshMapDataShow()
	end

	self.isOverInitGame = true

	self:changeSpinBoard("Normal")

	if self:noFeatureLeft() and self:noFeatureResume(data) then 
		self:playMusicByName("welcome_theme")
		self:playWelcomeDialog()

		-- if self.collectVCtl then -- 因为主题进入的弹窗，所以不展示
		-- 	self.collectVCtl:showCollectTip()
		-- end

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

    self:playMusicByName("game_popup")
end
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- @spin相关

function cls:getSpinColStopAction(themeInfo, pCol, realCol, interval)
	local _reelSpinConfig = self.gameConfig.reel_spin_config
	local _theme_config = self.gameConfig.theme_config

	if pCol % _theme_config.base_col_cnt == 1 then -- 同时下落的时候 进行的 延迟 重置
        self.DelayStopTime = 0
    end

	local checkNotifyTag   = self:checkNeedNotify(pCol)
	if checkNotifyTag then 
		self.DelayStopTime = self.DelayStopTime + _reelSpinConfig.extraReelTime
	end

	local spinAction = {}
	spinAction.actions = {}

	local specialType = themeInfo and themeInfo["special_type"]

	local function onSpecialBegain( pcol)
		if pcol == 1 then 
			if specialType == 1 or specialType == 2 then 
				self.ctl.specialSpeed = true
				self.mainView:addSpecialSpeed(specialType)
			end
		end
	end

    local temp = interval - _reelSpinConfig.speedUpTime - _reelSpinConfig.upBounceTime
    local timeleft = _reelSpinConfig.rotateTime - temp > 0 and _reelSpinConfig.rotateTime - temp or 0
	
    local _stopDelay, _downBonusT = self:getCurSpinLayerSpinActionTime(
    	_reelSpinConfig.stopDelayList, 
    	_reelSpinConfig.downBounceTime, 
    	_reelSpinConfig.checkStopColCnt, 
    	_reelSpinConfig.autoStopDelayMult, 
    	_reelSpinConfig.autoDownBounceTimeMult 
    	)

    if specialType then
		local addSpecialTime = 0
		if specialType == 1 then 
			addSpecialTime = _reelSpinConfig.speicalSpeed
		end

		table.insert(spinAction.actions, {["endSpeed"] = _reelSpinConfig.maxSpeed,["totalTime"] = addSpecialTime, ["accelerationTime"] = 10/60,["beginFun"] = onSpecialBegain})
		table.insert(spinAction.actions, {["endSpeed"] = _reelSpinConfig.maxSpeed,["totalTime"] = 1000,["accelerationTime"] = 1000})
		
		spinAction.stopDelay = timeleft+(pCol-1)*_stopDelay + addSpecialTime

        self.ExtraStopCD = spinAction.stopDelay + _reelSpinConfig.speedDownTime
        self.canFastStop = false
        spinAction.ClearAction = true
		
    else
        spinAction.stopDelay = timeleft+(pCol-1)*_stopDelay + self.DelayStopTime
        self.ExtraStopCD = _reelSpinConfig.spinMinCD - temp > 0 and _reelSpinConfig.spinMinCD - temp or 0
    end

	spinAction.maxSpeed = _reelSpinConfig.maxSpeed
	spinAction.speedDownTime = _reelSpinConfig.speedDownTime
	if self.isTurbo then
		spinAction.speedDownTime = spinAction.speedDownTime * 3/4
	end
	spinAction.downBounce = _reelSpinConfig.downBounce
	spinAction.downBounceMaxSpeed = _reelSpinConfig.downBounceMaxSpeed
	spinAction.downBounceTime = _downBonusT
	spinAction.stopType = 1
	return spinAction
end


function cls:onSpinStart()
	parentClass.onSpinStart(self)

	self.fastStopStartCol = nil
	self.isReelSpin = true
	self.DelayStopTime = 0

	if self.collectVCtl then 
		self.collectVCtl:onSpinStartCollect()
	end

	if self.betFeatureVCtl then 
		local resetData = {self.betFeatureVCtl:getCurDiskData()}
		self.betFeatureVCtl:refreshBetFeatureShowBySpin(resetData)
	end

	self.mainView:onSpinStartMainView()

	self.reelMusicList = nil
end

function cls:refreshNotEnoughMoney()
	self.isReelSpin = false
end

function cls:stopControl( stopRet, stopCallFun )

	if stopRet["bonus_level"] then
		self:updateUnlockInfo(stopRet)
	end

	--@ 特殊玩法，数据控制
	if self.collectVCtl then 
		-- self.collectVCtl:collectMapStopCtl(stopRet)
	end

	if self.freeCtl then 
		self.freeCtl:freeStopCtl(stopRet)
	end

	if self.betFeatureVCtl then 
		self.betFeatureVCtl:betFeatureStopCtl(stopRet)
	end

	stopRet.before_win_show = true

	parentClass:stopControl(stopRet, stopCallFun)

end

function cls:playReelNotifyEffect(pCol)  -- 播放特殊的 等待滚轴结果的	
 	self.reelNotifyEffectList = self.reelNotifyEffectList or {}
 	if not (self.speedUpState and self.speedUpState[pCol] and bole.getTableCount(self.speedUpState[pCol]) > 0 ) then return end

 	local pos = self:getCellPos(pCol, 3)
 	local spineFile = self:getSpineFile("reel_notify")

 	local s1, s2 = self.mainView:addReelNotifyEffectAnim(pos, spineFile)

	self.reelNotifyEffectList[pCol] = {s1, s2}

end

function cls:stopReelNotifyEffect(pCol)
	self.reelNotifyEffectList = self.reelNotifyEffectList or {}
	if self.reelNotifyEffectList[pCol] then
		for _, node in pairs(self.reelNotifyEffectList[pCol]) do 
			if bole.isValidNode(node) then 
				node:removeFromParent()
			end
		end

		self.mainView:playSymbolAnticState("loop")
	end

	self.reelNotifyEffectList[pCol] = nil
end

function cls:dealMusic_PlayReelNotifyMusic( pCol ) -- 最后一列激励音效 跟 self.speedUpState 挂钩, 所以只会进来 1-5 
	if self.speedUpState and self.speedUpState[pCol] and bole.getTableCount(self.speedUpState[pCol]) > 0 then 

	 	local musicName = "scatter_reel_notify"

		self:playMusicByName(musicName, true, false)
		self.reelMusicList = self.reelMusicList or {}
		self.reelMusicList[pCol] = true
	end
end

function cls:dealMusic_StopReelNotifyMusic( pCol )
	if not self.reelMusicList then return end

	if self.reelMusicList and self.reelMusicList[pCol] then 
		self:stopMusicByName("scatter_reel_notify", true)
		self.reelMusicList[pCol] = nil
	end

end
----------------------------------------------------------------------------------------------------------------------------
--@ betChange
function cls:dealAboutBetChange(bet,isPointBet)
	if self.isOverInitGame then
		local data = { ["bet"] = bet, ["isPointBet"] = isPointBet}
		self:onBetChange(data)
    end
end

function cls:onBetChange( data )
	self:stopDrawAnimate()

	local bet
	local isPointBet
	if data then 
		bet = data.bet or self:getCurBet()
		isPointBet = data.isPointBet
	end

    if not bet then
        return
    end
    self:checkLockFeature(bet, isPointBet)
    
    if self.showBet and (self.showBet == bet) then
        return
    end
    self.showBet = bet

	if self.betFeatureVCtl then 
		self.betFeatureVCtl:topSetBet(data)
	end
end

function cls:finshSpin()
	if (not self:isInFG()) and (not self.autoSpin) then
		self.isReelSpin = false
	end
end

------------------------------------------------
-- free 中奖动画
function cls:playFreeSpinItemAnimation( theSpecials ,enterType)
	local delay = 0
	self:stopDrawAnimate()

	local animType = self.gameConfig.special_symbol.scatter
	if not theSpecials or not theSpecials[animType] then return end

	if enterType then

		self.footer:setSpinButtonState(true)
		self.footer:enableOtherBtns(false)
		

		if enterType == "bonus" then
			self:playMusicByName("bell")
			self:playScatterWinAnim(theSpecials[animType], animType, true) 
			delay = delay + self.gameConfig.specialSTriggerAnimTime
		elseif enterType == "free_spin" then
			self:setFeatureState(self.gameConfig.FeatureName.Free, true)
			
		elseif enterType == "more_free_spin" then
			self:playMusicByName("bell")
			delay = self.gameConfig.specialSTriggerAnimTime
			self:playScatterWinAnim(theSpecials[animType], animType, true) 
		end
	-- else
	-- 	delay = self.gameConfig.specialSTriggerAnimTime
	-- 	self:playScatterWinAnim(theSpecials[animType], animType, true) 
	end

	return delay
end

function cls:playScatterWinAnim( theSpecials, itemKey, isLoop )
	for col, rowTagList in pairs(theSpecials) do
		for row, tagValue in pairs(rowTagList) do
			self.mainView:addItemSpine("item"..itemKey, col, row, isLoop)
		end
	end

end

------------------------------------------------
-- bonus 中奖动画
function cls:playBonusAnimate(theGameData, isResume) -- 播放 bonus symbol 动画  同时 播放 开始弹窗
	local delay = 0.5
    self.footer:setSpinButtonState(true)
    self.audioCtl:dealMusic_FadeLoopMusic(0.2, 1, 0.3) -- self:stopAllLoopMusic()
    
    if theGameData.bonus_type and theGameData.bonus_type == 3 or theGameData.bonus_type == 5 then
	    delay = self:playFreeSpinItemAnimation( self.specials ,"bonus")
	end

    return delay 
end

---------------------------------- 声音相关 ---------------------------------------------

function cls:configAudioList( )
	parentClass.configAudioList(self)

	self.audio_list = self.audio_list or {}

	tool.mergeTable(self.audio_list, tool.tableClone(self.gameConfig.audioList))
end

function cls:getLoadMusicList()
	local loadMuscList = self.audio_list
	table.insert(loadMuscList, self.audio_list.welcome_theme)
	
	return loadMuscList
end

-- 播放bonus game的背景音乐
function cls:dealMusic_EnterBonusGame()
	-- 播放背景音乐
	self.audioCtl:dealMusic_PlayGameLoopMusic(self.audio_list.wheel_background)
end

-- 结束bonus game的背景音乐
function cls:dealMusic_ExitBonusGame()
	local name = self.audio_list.base_background
	local stageType = 1
	if self:isInFG() then
		self:dealMusic_PlayFreeSpinLoopMusic()
		stageType = 2
	else
		self:playLoopMusic(name)
		-- 播放背景音乐
	end
end
-- -- 播放wheel game的背景音乐
-- function cls:dealMusic_EnterWheelGame()
-- 	-- 播放背景音乐
-- 	AudioControl:stopGroupAudio("music")
-- 	self:dealMusic_PlayGameLoopMusic(self.audio_list.wheel_background)
-- end
-----------------------------------------------------------------------------
--@玩法状态控制
function cls:setFeatureState(fType, state)
	self.featureStateList = self.featureStateList or {}
	self.featureStateList[fType] = state 
end
------------------------------------------------------------

function cls:setDialogDimmerState( dialogType, sType, isShow )
	local dimmer_config = self.gameConfig.dimmer_config
	if dimmer_config[dialogType] and dimmer_config[dialogType][sType] then 
		local dType = dimmer_config[dialogType][sType]
		local state = isShow and "show" or "hide"
		self:playFeatureDimmerAnim(dType, state)
	end
end

function cls:playFeatureDimmerAnim( dType, state )
	self.mainView:showFeatureBoardDimmer(dType, state)
end

function cls:playTransition(endCallBack,tType, coverCallBack)
	local function delayAction()
		local transition = ThemeBaseTransitionControl.new(self, endCallBack, coverCallBack)

		local parent
		if tType == "free_in" then 
			parent = self.mainView:getDownChildNode()
		end
		transition:play(self.gameConfig.transitionConfig[tType], parent)
	end	
	delayAction()
end

---------------------------- 临时方法 ----------------------

function cls:refreshColCellsZOrder( pCol )
	self.mainView:refreshColCellsZOrder(pCol)
end

function cls:changeSpinLayer( spinLayer )
	self.spinLayer = spinLayer
end

function cls:adjustWithTheCellSpriteUpdate(... )
	self.mainView:adjustWithTheCellSpriteUpdate(...)
end

function cls:getSpinConfig( spinTag )
	local spinConfig = {}

	local _theme_config = self.gameConfig.theme_config

	for col,_ in pairs(self.mainView:getCurSpinLayer().spins) do
		local tempCol = (col - 1) %  _theme_config.base_col_cnt+1
		local theStartAction = self:getSpinColStartAction(tempCol, col)
		local theReelConfig = {
			["col"]     = col,
			["action"]  = theStartAction,
		}
		table.insert(spinConfig, theReelConfig)
	end	
	return spinConfig
end

function cls:getStopConfig( ret, spinTag ,interval )
	local stopConfig  = {}

	local _theme_config = self.gameConfig.theme_config
	for col,_ in pairs(self.mainView:getCurSpinLayer().spins) do
		local tempCol = (col - 1) %  _theme_config.base_col_cnt+1
		local theAction = self:getSpinColStopAction(ret["theme_info"], tempCol, col,interval)
		table.insert(stopConfig, {col, theAction})
	end 
	return stopConfig
end

function cls:getSpinColStartActionSpecial( spinAction, pCol, reelCol )

end

function cls:clearAnimate( ... )
	self.mainView:clearAnimate()
	
	self:cleanAnimateList()
end

function cls:drawLinesThemeAnimate( lines, layer, rets, specials)
	local timeList = {3, 3}
	self.mainView:drawLinesThemeAnimate(lines, layer, rets, specials, timeList)
end

function cls:checkPlaySymbolNotifyEffect( pCol ) 
	local isPlaySymbolNotify = false
	self:dealMusic_StopReelNotifyMusic(pCol) -- 停止滚轴加速的声音

	if not self.fastStopMusicTag then -- 判断是否播放特殊symbol的动画
		isPlaySymbolNotify = self:dealMusic_PlaySpecialSymbolStopMusic(pCol)-- 判断是否播放特殊symbol的动画

		self:playSymbolStopLoopEffect(pCol) -- check 一下当前列 播放循环动画的symbol
	else
		local endCol = #self.mainView:getCurSpinLayer().spins
		if pCol == endCol then
			local haveSymbolLevel = self.gameConfig.reel_stop_config.max_stop_level -- 普通下落音的等级
			local addName = "1"
			for col, colData in pairs(self.notifyState) do -- 判断在剩下停止的滚轴中是否有特殊symbol
				
			 	if bole.getTableCount(colData) > 0 then

					for checkKey, stopLevel in pairs( self.gameConfig.reel_stop_config.symbol_stop_level ) do
						if colData[checkKey] then
							if haveSymbolLevel > stopLevel then
								haveSymbolLevel = stopLevel
							end
						end
					end

					addName = col
					self:playSymbolNotifyEffect(col) -- 播放特殊symbol 下落特效

					self.notifyState[col] = {}
				end
			end
			if haveSymbolLevel< self.gameConfig.reel_stop_config.max_stop_level then
				self.audioCtl:playEffectWithInterval(self.audio_list["special_stop"..addName])
				isPlaySymbolNotify = true
			end

			if self.fastStopStartCol then 
				for _col = self.fastStopStartCol , endCol do 
					self:playSymbolStopLoopEffect(pCol) -- check 一下当前列 播放循环动画的symbol
				end
			end
		end
	end

	return isPlaySymbolNotify
end

function cls:dealMusic_PlaySpecialSymbolStopMusic( pCol )
	self.notifyState = self.notifyState or {}
	
	if (not self.notifyState[pCol]) or bole.getTableCount(self.notifyState[pCol]) == 0 then 
		return false
	end
	local colNotifyState = self.notifyState[pCol]

	local _reel_stop_config = self.gameConfig.reel_stop_config
	local haveSymbolLevel = _reel_stop_config.max_stop_level -- 普通下落音的等级

	for checkKey, stopLevel in pairs( _reel_stop_config.symbol_stop_level ) do
		if colNotifyState[checkKey] then
			if haveSymbolLevel > stopLevel then
				haveSymbolLevel = stopLevel
			end
		end
	end

	if haveSymbolLevel < _reel_stop_config.max_stop_level then 
		self:playSymbolNotifyEffect(pCol) -- 播放特殊symbol 下落特效

		self.audioCtl:playEffectWithInterval(self.audio_list["special_stop" .. pCol])
		self.notifyState[pCol] = {}
		return true
	end
end

function cls:playSpecialSymbolAnim( node, key, _addName, pos, zOrder, isLoop )
	return self.mainView:playSpecialSymbolAnim( node, key, _addName, pos, zOrder, isLoop )
end

function cls:checkSpeedUp(checkCol)
	local _theme_config = self.gameConfig.theme_config

	local isNeedSpeedUp = false
	local checkCol1 = checkCol
	local checkCol2 = checkCol + _theme_config.base_col_cnt
	if not self.specialSpeed and self.speedUpState then 
		if self.speedUpState[checkCol1] and bole.getTableCount(self.speedUpState[checkCol1])>0 then
			isNeedSpeedUp = true
		elseif self.speedUpState[checkCol2] and bole.getTableCount(self.speedUpState[checkCol2])>0 then
			isNeedSpeedUp = true
		end

	end
	return isNeedSpeedUp
end

function cls:stopDrawAnimate() -- 可能存在 手动调用的可能

	self.jpViewCtl:stopJpAnimate()

	if self.betFeatureVCtl then 
		self.betFeatureVCtl:stopFeatureAnim()
	end

	parentClass.stopDrawAnimate(self)
end

function cls:onReelStop( col, notNeedAnim )
	parentClass.onReelStop(self, col)

	if self.collectVCtl then 
		self.collectVCtl:asHintTimeStore(col)
	end
end

function cls:changeCellSpriteByPos( col, row, key )
	self.mainView:changeCellSpriteByPos(col, row, key)
end

------------------------------------------------------- handler --------------------------------------------------------

function cls:onThemeInfo(ret, callFunc)
    self.themeInfoCallFunc = callFunc

    local stopThemeInfo = ret.theme_info

    self:checkHasWinInThemeInfo(ret)
end

function cls:checkHasWinInThemeInfo(ret)
    local hasSpecialWin = false

	local endFunc = function ( ret )
		self:checkHasWinInThemeInfo(ret)
	end

	if self.collectVCtl:hasCollect() then 
		hasSpecialWin = true

		self.collectVCtl:themeInfoChangeMapData(ret, endFunc)
	elseif self.betFeatureVCtl and self.betFeatureVCtl:hasFeature() then 
		hasSpecialWin = true

		self.betFeatureVCtl:themeInfoDealStick(ret, endFunc)
	end
    if hasSpecialWin then 
        -- self.audioCtl:dealMusic_FadeLoopMusic(0.2, 1, 0.3)
    end

    if not hasSpecialWin then 
        if self.themeInfoCallFunc then 
            self.themeInfoCallFunc()
            -- self.audioCtl:dealMusic_FadeLoopMusic(0.2, 0.3, 1)
        end
    end
end

---------------------------------------------------------------------------------------------------
function cls:getActivesNodeBasePos()
	return self.mainView:activeNodeWordPos()
end
-----------------------------------------------------------------------------------------------------------------------
function cls:overBonusByEndGame(data) -- bonus 有end_game 字段 直接把 Bonus 钱加到 footer上面 如果 之后 没有 特殊feature 则直接加钱到header上面

	local bonusWin = 0

	if data and data.slots_info then 
		for _, slotInfo in pairs(data.slots_info) do 
			if slotInfo and slotInfo.slots_win then 
				bonusWin = bonusWin + slotInfo.slots_win
			end
		end

		if data.win_jp_temp and #data.win_jp_temp > 0 then 
			for _, _jpData in pairs(data.win_jp_temp) do 
				if _jpData and _jpData.jp_win then 
					bonusWin = bonusWin + _jpData.jp_win
				end
			end
		end
	end

	self.totalWin = self.totalWin + bonusWin

	self.isProcessing  = false
	if self.showFreeSpinBoard or self:isInFG() then
		local _free_win = self:isInFG()
		self.totalWin = _free_win + self.totalWin

		if self.freeCtl then 
			self.freeCtl:updateFreeWin(self.totalWin)
		end
		self:updateFooterCoin()

	else
		self:unlockLobbyBtn()
		self:removePointBet()
		self:updateFooterCoin()
		self:addCoinsToHeader()
	end
end

-----------------------------------------------------------------------------------------------------------------------
function cls:onReelFastFallBottom( pCol )

	
	if not self.fastStopMusicTag then
		self.fastStopStartCol = pCol
	end

	parentClass.onReelFastFallBottom(self, pCol)

end

--------------------------------------------------------
-- symbol 更改显示数据
function cls:checkUpdateSymbolKey( key, isWinAnim )

end
---------------------------------------------------------------------------------------------------
-- @ 角标相关
function cls:updateCellOtherAssets(cell,colid) -- 更新Symbol上除Sprite以外的Sprite
	if self.collectVCtl then 
		self.collectVCtl:updateCellStoreAssets(cell, colid)
	end
	
	parentClass.updateCellOtherAssets(self, cell, colid)
end

function cls:updateCellFastOtherAssets(pCol) --暂时不用
	if self.collectVCtl then 
		self.collectVCtl:updateCellFastStoreAssets(pCol)
	end

	parentClass.updateCellFastOtherAssets(self, pCol)
end

---------------------------------------------------------------------------------------------------
-- bet_feature
function cls:getReelColAndRow( index )
    local col_cnt = self.gameConfig.theme_config.base_col_cnt

	local col = (index - 1)%col_cnt + 1
	local row = math.ceil(index/col_cnt)

	return col, row
end

function cls:resetBoardCellsSprite( resetItemList )
	resetItemList = resetItemList or {}	

	self:cleanTheReelKeyCache()
	-- -- 开启按钮可点击状态
	-- self.footer:setSpinButtonState(false)
end

---------------------------------------------------------------------------------------------------
-- big_win 庆祝动画

function cls:beforeWinShow( ret, onEnd )
	local winMulti = ret.base_win / self.ctl:getCurBet()

    if winMulti >= 10 then
        self:playBigWinEffect()
        self.node:runAction(cc.Sequence:create(
            cc.DelayTime:create(1.5), -- wild 显示的时间
            cc.CallFunc:create(function ( ... )
                if onEnd then 
                    onEnd()
                end
            end),
            cc.DelayTime:create(1), -- wild 显示的时间
            cc.CallFunc:create(function ( ... )
            	self:stopBigWinEffect()
            end)))
    else
        if onEnd then 
            onEnd()
        end
    end
end

function cls:playBigWinEffect()
    self.mainView:playBigWinEffect()
end

function cls:stopBigWinEffect()
    self.mainView:stopBigWinEffect()
end

---------------------------------------------------------------------------------------------------

function cls:onExit( )

	if self.mainView.onExit then 
		self.mainView:onExit()
	end
	
	if self.shaker then
		self.shaker:stop()
	end

	if self.bonus and self.bonus.onExit then
		self.bonus:onExit()
	end

	if self.betFeatureVCtl and self.betFeatureVCtl.removeAllStickNode then
		self.betFeatureVCtl:removeAllStickNode()
	end

	parentClass.onExit(self)
end

return ThemeMysteriousPixies_MainControl

