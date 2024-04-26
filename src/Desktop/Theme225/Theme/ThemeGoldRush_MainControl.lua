--Author:WangHongJie art:YuanKe  math:LiJingYi  plan:WangJinYing
--Email:wanghongjie@bolegames.com
--2020年 12 月 21 日 16:00
--Using:主题 ThemeLuckyBee

local parentClass = ThemeBaseViewControl -- Theme -- 
ThemeGoldRush_MainControl = class("ThemeGoldRush_MainControl", parentClass) -- 
local cls = ThemeGoldRush_MainControl

require (bole.getDesktopFilePath("Theme/ThemeGoldRush_FreeControl")) 
require (bole.getDesktopFilePath("Theme/ThemeGoldRush_JpControl")) 
require (bole.getDesktopFilePath("Theme/ThemeGoldRush_CollectControl")) 
require (bole.getDesktopFilePath("Theme/ThemeGoldRush_MainView")) 

local bgBConfig = require (bole.getDesktopFilePath("Theme/ThemeGoldRush_Config"))  

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
	
	self.jpViewCtl 		= ThemeGoldRush_JpControl.new(self)
	self.freeCtl 		= ThemeGoldRush_FreeControl.new(self)
	self.collectVCtl 	= ThemeGoldRush_CollectControl.new(self)

	self.mainView = ThemeGoldRush_MainView.new(self)

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

	local boardConfig = {}
	local board_temp = tool.tableClone(self.ThemeConfig["board_temp"])
	local board_cfg = tool.tableClone(self.gameConfig.board_config)

    for idx, temp in pairs(board_cfg) do
        if not temp then
            return
        end
        if temp.show_parts then 
        	for _, idx2 in pairs(temp._board_id_list) do
	        	boardConfig[idx2] = tool.tableClone(temp)
				-- boardConfig[idx2]["colReelCnt"] = board_temp.colCnt
		  --       boardConfig[idx2]["reelConfig"] = newReelConfig
		    end
        	break 
        else
	        local newReelConfig = {}
			for _, base_pos in pairs(temp.reel_pos) do -- base and free  and slotMap
				for col = 1, board_temp.colCnt do 
					local oneConfig = {}
					oneConfig["base_pos"] 	= cc.p( (col-1)*board_temp["cellWidth"]+base_pos.x, base_pos.y )
			 		oneConfig["cellWidth"] 	= board_temp.cellWidth
					oneConfig["cellHeight"] = board_temp.cellHeight
					oneConfig["symbolCount"]= board_temp.rowCnt
					table.insert(newReelConfig,oneConfig)
				end
			end
			boardConfig[idx] = tool.tableClone(board_temp)
			boardConfig[idx]["colReelCnt"] = board_temp.colCnt

	        boardConfig[idx]["reelConfig"] = newReelConfig
	    end
    end

	self.boardConfigList = boardConfig
	return boardConfig
end

function cls:changeSpinBoard(pType) -- 更改背景控制 已修改
	local board_type_config = self.gameConfig.SpinBoardType

	local boardType = board_type_config[pType]
	self.curBoardCnt = self.gameConfig.spin_baord_cnt[pType]

	if boardType ~= board_type_config.Normal and boardType ~= board_type_config.Bonus then -- or 
		self.curBoardCnt = self.freeCtl:getFreeBoardCnt()
	end

	if self.mainView.isChest and self.mainView.getChestBoardCount then
		self.curBoardCnt = self.mainView:getChestBoardCount()
		self.mainView.isChest = false
	end
	-- self:resetCurrentReels(boardType ~= board_type_config.Normal)

	self:stopDrawAnimate()
	self.mainView:resetBoardShowNode(pType, self.curBoardCnt)

	if self.freeCtl then 
		self.freeCtl:resetBoardShowByFeature(boardType, self.curBoardCnt)
	end

	if self.collectVCtl then 
		self.collectVCtl:resetBoardShowByFeature(boardType)
	end

	if self.jpViewCtl then 
		self.jpViewCtl:resetBoardShowByFeature(boardType)
	end

	if boardType == board_type_config.Normal then -- normal情况下 需要更改棋盘底板
		self.showSFreeBoard = false
		self.showFreeSpinBoard = false
		self.showReSpinBoard = false

		self.showBaseSpinBoard = true

	elseif boardType == board_type_config.FreeSpin then
		self.showFreeSpinBoard = true

		self.showSFreeBoard = false
		self.showBaseSpinBoard = false
		self.showReSpinBoard = false

	elseif boardType == board_type_config.SFree1 or boardType == board_type_config.SFree5 then
		self.showSFreeBoard = true

		self.showBaseSpinBoard = false
		self.showFreeSpinBoard = false
		self.showReSpinBoard = false
	elseif boardType == board_type_config.Bonus then
		self.showSFreeBoard = false
		self.showBaseSpinBoard = false
		self.showFreeSpinBoard = false

		self.showReSpinBoard = true
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
				self:playMusicByName("sfg_unlock")
			end
		else
			if self.jpViewCtl:checkUnlockTypeIsJackpot(self.gameConfig.unlockInfoTypeList[changeLevel]) then 
				self:playMusicByName("jp_lock")
			else
				self:playMusicByName("sfg_lock")
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
	-- if (self.showBaseSpinBoard or self.showFreeSpinBoard) and not self.showReSpinBoard then 
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

function cls:resetPointBet() -- 仅仅在断线的时候 被调用了
    if self.freeCtl and self.freeCtl:checkHasAvgBet() then 

        self:setPointBet(self.freeCtl:checkHasAvgBet())-- 更改 锁定的bet
        self.footer:changeFreeSpinLayout3()-- 隐藏掉  footer bet 
    end
end

function cls:isSuperFree( )
	return self.freeCtl and self.freeCtl:checkIsSuperFree()
end

function cls:enterFreeSpin( isResume ) -- 更改背景图片 和棋盘

	self:setFeatureState(self.gameConfig.FeatureName.Free, true)
	if isResume then  -- 断线重连的逻辑
		if self.freeCtl then 
			self.freeCtl:changeFreeSpinBoard()--  更改棋盘显示 背景 和 free 显示类型
		end
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

	self:checkIsOverSuperFeatrue()

	if self.collectVCtl then 
		self.collectVCtl:updateMapDataAndShowByEndMapFeature()
	end
	if self.freeCtl then 
		self.freeCtl:clearFreeFeatureData(true)
	end

	self:changeSpinBoard("Normal")

	-- 手动调用一下 bet 修改
	self:removePointBet()

	parentClass.hideFreeSpinNode(self, ...)
end

function cls:checkIsOverSuperFeatrue( )
    if self.freeCtl and self.freeCtl:checkHasAvgBet() then 
        self.footer:changeNormalLayout2()
    end
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
end

function cls:dealFreeGameResumeRet(data)
	if self.freeCtl then
		self.freeCtl:dealFreeGameResumeRet(data)
	end
end

function cls:dealBonusGameResumeRet(data)
	if data.bonus_game and data.bonus_game.item_list then 
		self.miniSlotPos = {}
		
		local symbol_config = self.gameConfig.symbol_config
		local scatter_config 	= symbol_config.scatter_config
		local bonus_config 		= symbol_config.bonus_config

		local cItemList = data.bonus_game.item_list

		for col, colItemList in pairs(cItemList) do -- 遍历每
			self.miniSlotPos[col] = self.miniSlotPos[col] or {}
			for row, theItem in pairs(colItemList) do

				if bonus_config.bonus_set[theItem%scatter_config.scatter_add] then
					table.insert(self.miniSlotPos[col], {col, row, theItem})
				end
			end
		end
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

		if self.collectVCtl then 
			self.collectVCtl:showCollectTip()
		end

	end
end

function cls:noFeatureResume( data )
	local no_feature_resume = true
	if data and (data["bonus_game"] or data["free_random_pick"] or data["free_game"] or data["first_free_game"]) then 
		no_feature_resume = false 
	end
	return no_feature_resume
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

	-- if self.showFreeSpinBoard then
	-- 	if self.freeCtl and self.freeCtl:checkHasRandomWild() then
	-- 		specialType = 12
	-- 	end
	-- end

	local function onSpecialBegain( pcol)
		-- if pcol == 1 then 
		-- 	if specialType == 1 or specialType == 2 then 
		-- 		self.ctl.specialSpeed = true
		-- 		self.mainView:addSpecialSpeed(specialType)
		-- 	elseif specialType == 12 then 
		-- 		self.specialSpeed = true
		-- 		if self.freeCtl then 
		-- 			self.freeCtl:playAddRandWildSymbol()
		-- 		end

		-- 	end
		-- end
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
	self.respinStep = self.gameConfig.ReSpinStep.OFF

	parentClass.onSpinStart(self)

	self.isReelSpin = true
	self.DelayStopTime = 0

	if self.collectVCtl then 
		self.collectVCtl:onSpinStartCollect()
	end

	self.reelMusicList = nil
end

function cls:onSpinStop( rets )
	self.respinStep = self.gameConfig.ReSpinStep.OFF
	if rets.bonus_game then --ret.theme_respin
		self.respinStep = self.gameConfig.ReSpinStep.Start
	end

	self:fixRet(rets)
end

function cls:onRespinStart()
	if self.showReSpinBoard then
    	self.bonus:onRespinStart()
    	self:playMusicByName("slot_spin_roll", true, true)
    end

    self.DelayStopTime = 0
    Theme.onRespinStart(self)
    self:cleanSpecialSymbolState()
    self.lastCol = nil
end

function cls:onRespinStop(ret)
	self:fixRet(ret)

    if #ret["theme_respin"] == 0 then
        self.respinStep = self.gameConfig.ReSpinStep.Over
        ret.theme_deal_show = true
    end
    Theme.onRespinStop(self, ret)
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
		self.collectVCtl:collectMapStopCtl(stopRet)
	end

	if self.freeCtl then 
		self.freeCtl:freeStopCtl(stopRet)
	end

	parentClass:stopControl(stopRet, stopCallFun)

end

function cls:playReelNotifyEffect(pCol)  -- 播放特殊的 等待滚轴结果的	
 	self.reelNotifyEffectList = self.reelNotifyEffectList or {}
 	if not (self.speedUpState and self.speedUpState[pCol] and bole.getTableCount(self.speedUpState[pCol]) > 0 ) then return end

 	local name
 	local count
 	local _addName
 	if self.speedUpState[pCol]["scatter"] then 
 		name = "scatter"
		count = self.speedUpState[pCol]["scatter"]
		_addName = count > 4 and "2" or "1"
	elseif self.speedUpState[pCol]["bonus"] then 
		name = "bonus"
		count = self.speedUpState[pCol]["bonus"]
		_addName = count > 2 and "2" or "1"
 	end

 	local pos = self:getCellPos(pCol, 2)
 	local spineFile = self:getSpineFile(string.format("%s_reel_notify", name))

 	local s1, s2 = self.mainView:addReelNotifyEffectAnim(pos, spineFile, _addName, name)

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
	end

	self.reelNotifyEffectList[pCol] = nil
end

function cls:dealMusic_PlayReelNotifyMusic( pCol ) -- 最后一列激励音效 跟 self.speedUpState 挂钩, 所以只会进来 1-5 
	if self.speedUpState and self.speedUpState[pCol] and bole.getTableCount(self.speedUpState[pCol]) > 0 then 
	 	local name
	 	local _addName
 	 	if self.speedUpState[pCol]["scatter"] then 
	 		name = "scatter"
			_addName = self.speedUpState[pCol]["scatter"] > 4 and "2" or "1"
		elseif self.speedUpState[pCol]["bonus"] then 
			name = "bonus"
			_addName = self.speedUpState[pCol]["bonus"] > 2 and "2" or "1"
	 	end

	 	local musicName = string.format("%s_reel_notify%s", name, _addName)

		self:playMusicByName(musicName, true, false)
		self.reelMusicList = self.reelMusicList or {}
		self.reelMusicList[pCol] = true
	end
end

function cls:dealMusic_StopReelNotifyMusic( pCol )
	if not self.reelMusicList then return end

	if self.reelMusicList and self.reelMusicList[pCol] then 
		self:stopMusicByName("scatter_reel_notify1", true)
		self:stopMusicByName("scatter_reel_notify2", true)

		self:stopMusicByName("bonus_reel_notify1", true)
		self:stopMusicByName("bonus_reel_notify2", true)
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
	local bet
	local isPointBet
	if data then 
		bet = data.bet or self:getCurBet()
		isPointBet = data.isPointBet
	end

	self:checkLockFeature(bet, isPointBet)

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

	local animType = self.gameConfig.symbol_config.scatter_config.name
	if not theSpecials or not theSpecials[animType] then return end

	if enterType then

		self.footer:setSpinButtonState(true)
		self.footer:enableOtherBtns(false)
		self:setFeatureState(self.gameConfig.FeatureName.Free, true)

		if enterType == "free_spin" then
			self:playMusicByName("bell")
			local collectDelay = 0

			if not self.freeCtl:checkIsResumeFree() then
				if not self:checkFeatureIsLock(self.gameConfig.unlockInfoConfig.Map) then 
					collectDelay = self.collectVCtl:showCollectProgress(theSpecials[animType])
				else
					self:playMusicByName("lucky_clover_free_games") 
				end
			end

			self:laterCallBack(collectDelay, function ()
				self:playScatterWinAnim(theSpecials[animType], animType, false) 
			end)
			delay = delay + collectDelay + self.gameConfig.specialSTriggerAnimTime

		-- elseif enterType == "more_free_spin" then
		-- 	delay = 1
		end
	else
		-- delay = self.gameConfig.specialSTriggerAnimTime
		-- self:playScatterWinAnim(theSpecials[animType], animType, true) 
	end

	return delay
end

function cls:playScatterWinAnim( theSpecials, itemKey, isLoop )
	for col, rowTagList in pairs(theSpecials) do
		for row, tagValue in pairs(rowTagList) do
			self.mainView:addItemSpine(itemKey, col, row, isLoop)
		end
	end

end

------------------------------------------------
-- bonus 中奖动画
function cls:playBonusAnimate(theGameData, isResume) -- 播放 bonus symbol 动画  同时 播放 开始弹窗
	local delay = 0.5
    self.footer:setSpinButtonState(true)
    self.audioCtl:dealMusic_FadeLoopMusic(0.2, 1, 0.3) -- self:stopAllLoopMusic()
    
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

	return loadMuscList
end

function cls:dealMusic_PlayFreeSpinLoopMusic() -- 播放背景音乐
	if self:isSuperFree() then 
		self.audioCtl:dealMusic_PlayGameLoopMusic(self:getAudioFile("sfg_bgm")) -- sfree_background
	else
		self.audioCtl:dealMusic_PlayGameLoopMusic(self:getAudioFile("free_background"))
	end

end

-- 播放bonus game的背景音乐
function cls:dealMusic_EnterBonusGame()
	-- 播放背景音乐
	self.audioCtl:dealMusic_PlayGameLoopMusic(self.audio_list.bonus_background)
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

		transition:play(self.gameConfig.transitionConfig[tType])
	end	
	delayAction()
end

function cls:onExit( )

	if self.shaker then
		self.shaker:stop()
	end

	if self.bonus and self.bonus.onExit then
		self.bonus:onExit()
	end

	parentClass.onExit(self)
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

function cls:drawWaysThemeAnimate( lines, layer, rets, specials)
	local timeList = {3, 3}
	self.mainView:drawWaysThemeAnimate(lines, layer, rets, specials, timeList)
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

			for col, colData in pairs(self.notifyState) do -- 判断在剩下停止的滚轴中是否有特殊symbol
				
			 	if bole.getTableCount(colData) > 0 then

					for checkKey, stopLevel in pairs( self.gameConfig.reel_stop_config.symbol_stop_level ) do
						if colData[checkKey] then
							if haveSymbolLevel > stopLevel then
								haveSymbolLevel = stopLevel
							end
						end
					end

					self:playSymbolNotifyEffect(col) -- 播放特殊symbol 下落特效

					self.notifyState[col] = {}
				end
			end
			if haveSymbolLevel< self.gameConfig.reel_stop_config.max_stop_level then
				self.audioCtl:playEffectWithInterval(self.audio_list["special_stop" .. haveSymbolLevel])
				isPlaySymbolNotify = true
			end

			for _col = 1 , endCol do 
				self:playSymbolStopLoopEffect(_col) -- check 一下当前列 播放循环动画的symbol
			end
		end
	end

	return isPlaySymbolNotify
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

	if self.bonus then 
		self.bonus:stopLineAnimate()
	end

	parentClass.stopDrawAnimate(self)
end

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

function cls:onReelStop( col, notNeedAnim )
	parentClass.onReelStop(self, col)
end

function cls:fixRet(ret) -- 查看逻辑控制原因 拆分服务器返回的滚轴数据,分成15个结果
	if self.showFreeSpinBoard or self.showSFreeBoard then 
		local _theme_config = self.gameConfig.theme_config

		if ret["win_ways_list"] then 
			local new_win_ways = {}
			for i , _winWayData in pairs(ret["win_ways_list"]) do
				if #_winWayData > 0 then
					for _, singleWinWays in ipairs(_winWayData) do

						local new_single_win_way = tool.tableClone(singleWinWays) -- 更新新的 winLisne
						new_single_win_way.win_pos = {}
						for _, v in pairs(singleWinWays.win_pos) do 
							table.insert(new_single_win_way.win_pos, {v[1] + (i-1) * _theme_config.base_col_cnt, v[2]})
						end
						table.insert(new_win_ways, new_single_win_way)
					end
				end
			end
		    ret["win_ways"] = new_win_ways
		end
	elseif self.showReSpinBoard then 

		local miniRandomList = self.gameConfig.classic_config.random_reel
		self.resultCache = {}    -- ret["reelItem_list"] = {} -- 添加
		for k, v in pairs(ret.item_list) do
			local reelList = tool.tableClone(v)
			table.insert(reelList, 1, miniRandomList[math.random(1, table.nums(miniRandomList))]) -- 插入 第一条数据
			local extraCount = 6
			if self.isTurbo then
				extraCount = 3
			end
			for k = 1, extraCount do
				-- 向下插入 六个 值
				local key = miniRandomList[math.random(1, table.nums(miniRandomList))]
				table.insert(reelList, key)
			end
			table.insert(self.resultCache, reelList)
		end
	end
end
function cls:changeCellSpriteByPos( col, row, key )
	self.mainView:changeCellSpriteByPos(col, row, key)
end

function cls:onAllReelStop()

	-- if not self.fgType then -- 如果没有中奖 free 的话，删除掉动画
	-- 	self.mainView:clearBGEffect()
	-- end

	if self.bonus then
        self:stopMusicByName("slot_spin_roll", true)
        self.bonus:saveRespinCnt()
    end

	parentClass.onAllReelStop(self)
end

----------------------------------------------------------------------------------------


-- function cls:getSpecialTryResume(realItemList)
-- 	local specials 	 = {}
-- 	local keyCntList = {}
-- 	local miniCntList = {}

-- 	if not self.showSFreeBoard then 
-- 		local _theme_config = self.gameConfig.theme_config
-- 		local symbol_config = self.gameConfig.symbol_config

-- 		local scatterKeySet = Set(symbol_config.scatter_key_list) 
-- 		for _, key in pairs(symbol_config.scatter_key_list) do 
-- 			specials[key] = {}
-- 			keyCntList[key] = 0
-- 			miniCntList[key] = self.specialItemConfig[key].min_cnt or 3
-- 		end
		
-- 		local itemList   = realItemList or self:getRetMatrix()
-- 		if itemList then
-- 			for boardID = 1, self.curBoardCnt do 
-- 				for col=1, _theme_config.base_col_cnt do -- 遍历每一列
-- 					local col = col + (boardID - 1) * _theme_config.base_col_cnt
-- 					local colItemList  = itemList[col]
-- 					for row, theKey in pairs(colItemList) do
-- 						if scatterKeySet[theKey] then
-- 							keyCntList[theKey] = keyCntList[theKey] + 1
-- 							specials[theKey][col] 	   	= specials[theKey][col] or {}
-- 							specials[theKey][col][row] 	= true
-- 						end
-- 					end
-- 				end
-- 				for _, key in pairs(symbol_config.scatter_key_list) do 
-- 					if keyCntList[key] < miniCntList[key] then 
-- 						for col = (boardID - 1)*_theme_config.base_col_cnt + 1, boardID * _theme_config.base_col_cnt  do
-- 							specials[key][col] = nil
-- 						end
-- 					end
-- 					keyCntList[key] = 0
-- 				end
-- 			end
-- 		end
-- 	end

-- 	self.specials = specials	
-- 	return specials	
-- end

function cls:genSpecials( pWinPosList, realItemList )
	local specials 	 = {}

	local _theme_config = self.gameConfig.theme_config
	local symbol_config = self.gameConfig.symbol_config
	local scatter_config = self.gameConfig.symbol_config.scatter_config

	local scatter_key = scatter_config.name --  scatter_config.scatter_key
	specials[scatter_key] = {}
	
	local itemList   = realItemList or self:getRetMatrix()
	if itemList then

		for col, colItemList in pairs(itemList) do -- 遍历每一列
			for row, theKey in pairs(colItemList) do
				if theKey > scatter_config.scatter_add then
					specials[scatter_key][col] 	   	= specials[scatter_key][col] or {}
					specials[scatter_key][col][row] 	= true
				end
			end
		end
	end

	self.specials = specials	
	return specials	
end

function cls:genSpecialSymbolState( rets )
	rets = rets or self.rets -- 复制 通用逻辑
	if not self.checkItemsState then
		self.checkItemsState = {}  -- 都已列作为项， 各列各个sybmol相关状态，分为后面有可能，单列就有可能中，已经中了，后续没有可能中了
		self.speedUpState 	 = {}  -- 加速的列控制
		self.notifyState 	 = {}  -- 播放特殊symbol滚轴停止的时候的动画位置
		self.miniSlotPos 	 = {}

		if not self.showReSpinBoard then 
			self:genSpecialSymbolStateInNormal(rets) -- base 情况 配置 scatter
		end
	end
end

function cls:genSpecialSymbolStateInNormal( rets )

	local cItemList   = rets.item_list

	local symbol_config = self.gameConfig.symbol_config
	local win_config 		= symbol_config.win_feature_config
	local scatter_config 	= symbol_config.scatter_config
	local bonus_config 		= symbol_config.bonus_config

	if self.showBaseSpinBoard then 
		local scatterCount = 0 
		local bonusCount = 0
		for col, colItemList in pairs(cItemList) do -- 遍历每一列

			self.notifyState[col] = self.notifyState[col] or {}
			self.speedUpState[col] = self.speedUpState[col] or {}-- 此情况下，会进行特殊操作，将其状态记到self.speedUpState中
			self.miniSlotPos[col] = self.miniSlotPos[col] or {}

			if scatterCount >= win_config.check_min_cnt and win_config.col_set>0 and (scatterCount + win_config.col_set) >= win_config.min_cnt then
				self.speedUpState[col][scatter_config.name] = scatterCount
			end

			if bonusCount >= win_config.check_min_cnt and win_config.col_set>0 and (bonusCount + win_config.col_set) >= win_config.min_cnt then
				self.speedUpState[col][bonus_config.name] = bonusCount
			end

			for row, theItem in pairs(colItemList) do
				if theItem > scatter_config.scatter_add then
					self.notifyState[col][scatter_config.scatter_key] = self.notifyState[col][scatter_config.scatter_key] or {}
					table.insert(self.notifyState[col][scatter_config.scatter_key], {col, row, theItem})

					scatterCount = scatterCount + 1
				end
				if bonus_config.bonus_set[theItem%scatter_config.scatter_add] then
					local bonusKey = theItem%scatter_config.scatter_add
					self.notifyState[col][bonusKey] = self.notifyState[col][bonusKey] or {}
					table.insert(self.notifyState[col][bonusKey], {col, row})

					bonusCount = bonusCount + 1

					table.insert(self.miniSlotPos[col], {col, row, theItem})
				end
			end
		end
	else
		if not self.freeCtl:isMaxBoard() then 
			for col, colItemList in pairs(cItemList) do -- 遍历每一列
				self.notifyState[col] = self.notifyState[col] or {}

				for row, theItem in pairs(colItemList) do

					if theItem > scatter_config.scatter_add then
						self.notifyState[col][scatter_config.scatter_key] = self.notifyState[col][scatter_config.scatter_key] or {}
						table.insert(self.notifyState[col][scatter_config.scatter_key], {col, row, theItem})
					end

					if bonus_config.bonus_set[theItem%scatter_config.scatter_add] then
						local bonusKey = theItem%scatter_config.scatter_add

						self.notifyState[col][bonusKey] = self.notifyState[col][bonusKey] or {}
						table.insert(self.notifyState[col][bonusKey], {col, row, theItem})
					end
				end
			end
		end
	end

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

	if self.freeCtl:checkIsInFreeStop() then
		hasSpecialWin = true

		local animType = self.gameConfig.symbol_config.scatter_config.name
		local flyList = self.specials and self.specials[animType]

        self.freeCtl:showCollectProgress(flyList, endFunc)
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

function cls:theme_deal_show(ret)
	ret.theme_deal_show = nil

	if self.respinStep == self.gameConfig.ReSpinStep.Over then
        self.bonus:onRespinFinish(false)
	end
end

function cls:theme_respin( rets )
    self.node:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(function()
        local respinList = rets["theme_respin"]
		if respinList and #respinList>0 then

		    local win_slot_info = table.remove(respinList, 1)
		    self:resetRespinData(rets, win_slot_info)

		    local respinStopDelay = 1
		    local endCallFunc     = self:getTheRespinEndDealFunc(rets)
		    self:stopDrawAnimate()
		    self:respin(respinStopDelay, endCallFunc)
		else
		    rets["theme_respin"] = nil
		end 
    end)))
end

function cls:resetRespinData(rets, win_info_list)
    rets.slots_win 			= win_info_list.slots_win
    rets.base_win 			= win_info_list.slots_win
    rets.total_win 			= win_info_list.slots_win
    rets.item_list 			= win_info_list.item_list
    rets.slots_type 		= win_info_list.slots_type
    rets.slots_win_line 	= win_info_list.slots_win_line
    rets.slots_win_index 	= win_info_list.slots_win_index
    rets.is_jackpot 		= win_info_list.is_jackpot
end

function cls:getTheRespinEndDealFunc(rets)
    local retDealFunc = function(outDealFunc)
        self.spinning = false
        self:onAllReelStop()
        self.footer:onAllReelStop()

        local nextFunc = function(...)
            self:handleResult()
        end
        
        if self.bonus then -- 庆祝赢钱 控制 老虎机移动
            self.bonus:showWinCoins(self.rets, nextFunc)
        else
            nextFunc()
        end
    end
    return retDealFunc
end
-----------------------------------------------------------------------------------------------------------------------
-- function cls:checkNotToAutoSpin()
--     local themeNotCanToAuto = false
--     if self.storeVCtl then
--     	if self.storeVCtl:isShowStoreNode() or self.storeVCtl:hasBuyData() then 
--         	themeNotCanToAuto = true
--         end
--     end
--     return themeNotCanToAuto
-- end

-- function cls:checkInFeature() -- whj: 作用在 feature 结束重新打开商店,时候控制锁住bet控制
--     local inFeature = false
--     if self.storeVCtl then
--     	if self.storeVCtl:isShowStoreNode() or self.storeVCtl:hasBuyData() then 
--         	inFeature = true
--         end

--     end
--     return inFeature
-- end


function cls:onReelFastFallBottom( pCol )
	self.reelStopMusicTagList[pCol] = true
	-- 列停音效，提示动画相关
	if not self.fastStopMusicTag then
		local hasNotify = false
		for col=pCol,#self.mainView:getCurSpinLayer().spins do
			local reelSymbolState = self.notifyState[col]
			if reelSymbolState and bole.getTableCount(reelSymbolState)>0 then
				hasNotify = true
				break
			end
		end
		if not hasNotify then
			self:dealMusic_PlayReelStopMusic(pCol)
		end	
	end

	self.fastStopMusicTag = self.fastStopMusicTag or "allow_music"
	self:checkPlaySymbolNotifyEffect(pCol)
	self:stopReelNotifyEffect(pCol)

end

--------------------------------------------------------
-- symbol 更改显示数据
function cls:checkUpdateSymbolKey( key, isWinAnim )
	local scatter_feature = self.gameConfig.symbol_config.scatter_config

	local data

	if key > scatter_feature.scatter_add then 
		data = {
			["key"] = key, 
			["has_scatter"] = true, 
			["scatter_pos"] = scatter_feature.scatter_pos, 
			["fileKey"] = key% scatter_feature.scatter_add
		}
		if isWinAnim and (self:isInFG() and not self.freeCtl:isMaxBoard()) then 
			data.has_scatter = false
		end
	end

	return data
end

------ slot 相关
function cls:getMiniSlotPos( )
	return self.miniSlotPos or {}
end

function cls:playBonusItemAnim( ... )
	self.mainView:playBonusItemAnim(self.miniSlotPos)
end

function cls:changeSpinLayerNotHide( sType )
	self.mainView:changeSpinLayerNotHide(sType)
end
------ top wheel 相关
-- function cls:getTopWheelResetList( index )
-- 	local wheel_cfg = self.gameConfig.wheel_game_config
-- 	local wheel_reel = wheel_cfg.wheel_reel-- tool.reverseTable(tool.tableClone(wheel_cfg.wheel_reel))
-- 	local cell_count = wheel_cfg.cell_count
-- 	local list = {}
-- 	-- local index = #wheel_reel - index + 1
	

-- 	local startId = -(cell_count-1)/2 + index
-- 	local endId = startId + cell_count
	
-- 	for i = startId, endId do
-- 		local real_index = (i - 1)%#wheel_reel + 1
-- 		table.insert(list, wheel_reel[real_index])
-- 	end

-- 	return list
-- end

-- function cls:getTopWheelStartIndex( index )
-- 	local wheel_cfg = self.gameConfig.wheel_game_config
-- 	local wheel_reel = wheel_reel or wheel_cfg.wheel_reel
-- 	local cell_count = wheel_cfg.cell_count
-- 	local list = {}

-- 	local startId = -(cell_count-1)/2 + index
-- 	local real_index = (startId - 1)%#wheel_reel + 1
		

-- 	return real_index
-- end

-- function cls:saveBonusLastNum( value )
-- 	self.lastBonusWinBalls = value
-- end
-- function cls:getBonusLastNum( value )
-- 	return self.lastBonusWinBalls
-- end

-- function cls:changeLogoAnimState( curData, repadData )
-- 	self.mainView:changeLogoAnimState( curData, repadData )
-- end

---------
function cls:getActivesNodeBasePos()
	return self.mainView:activeNodeWordPos()
end

function cls:stopChildActionsSpecial( cellNode )
	self.mainView:stopChildActionsSpecial(cellNode)
end
---------

return ThemeGoldRush_MainControl

