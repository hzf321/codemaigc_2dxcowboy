-- @Author: litianyang
-- @Date:   2020-03-26 18:22:20
-- @Last Modified by:   litianyang
-- @Last Modified time: 2020-4-06 10:47:02
local cls = class("WestZoneRespinControl")
function cls:ctor(theme, bonus, data, ctl)
    self.data = data
    self.bonus = bonus
    self._mainViewCtl = theme
    self._mainViewCtl = ctl
    self.gameConfig = self._mainViewCtl:getGameConfig()
	self:_initNode()
    self:initData(self.data.reentry or 1)
end

function cls:_initNode()
	self.respinFlyNode = self._mainViewCtl:getRespinFlyNode()
	self.collectMultiNode = self._mainViewCtl:getRespinCollectMultiNode()
end

function cls:initData (reentry)
    self:dealWithRespinData(reentry)
    self:dealWithJackPotData()
    self:dealWithLastItemList()
    self:saveBonus()
end

function cls:saveBonus ()
    if not self.data["bonus_id"] and (self.data.core_data and self.data.core_data.bonus_id) then
		self.data["bonus_id"] = self.data.core_data.bonus_id
	end
	LoginControl:getInstance():saveBonus(self._mainViewCtl.themeid, self.data)
end

function cls:dealWithRespinData(reentry)
	local respinData = self.data.core_data["respin_info"][reentry]
	self.data.hadUsedTimes = self.data.hadUsedTimes or 0 -- 表示当前使用的次数
	self.data.start_dialog = self.data.start_dialog or false --是否弹窗
    self.data.currentRespinTimes = self.data.currentRespinTimes or 3 --当前剩余respin次数
    self.respinTotalWin = 0 --本次respin中除grand的赢钱数
	self.mutiList = {}     --保存bonus翻倍信息
	self.winTwiceFlag = false 
	self.playTwiceFlag = false
	self._mainViewCtl.totalWin  = self.data.totalWin or self._mainViewCtl.totalWin
	self.data.win_before_respin = self._mainViewCtl.totalWin or 0 
	self.reSpinData = tool.tableClone(respinData["respin_total_list"]) --全部respin信息
    table.remove(self.reSpinData, 1)
	self.reSpinNewADD =  tool.tableClone(respinData["respin_list"]) -- 新增bonus信息
	self.respinBonusSpineList = {} 
	self.jpLockStatus = self.jpLockStatus or self.data.core_data.jp_lock
end

function cls:dealWithJackPotData()
    self.progressive_list = self.data.core_data["progressive_list"] or {0,0,0}
	self.hadUserJpList = self.data.hadUserJpList or {0,0,0}
	self._mainViewCtl:lockJackpotMeters(true)
	local jpLabels = self._mainViewCtl.jpViewCtl.jackpotLabels
	local progressive_data = self._mainViewCtl:getJackpotValue(self.progressive_list)
	for i=1, #self.progressive_list do
		if jpLabels[i] then
			local maxWidth = self._mainViewCtl:getJPLabelMaxWidth(i)
			jpLabels[i]:setString(self._mainViewCtl:formatJackpotMeter(progressive_data[i]))
			bole.shrinkLabel(jpLabels[i], maxWidth, 1)
		end
	end
end

function cls:dealWithLastItemList()
    if self.data.hadUsedTimes > 0 then 
        for key = 1, self.data.hadUsedTimes do 
			table.remove(self.reSpinData, 1)
		end
    end
    self._mainViewCtl.rets["theme_respin"] = tool.tableClone(self.reSpinData)   
end

------------------------入口---------------------------
function cls:closeStartDialog()
	if self.respinStartDialog and bole.isValidNode(self.respinStartDialog) then 
		local startRoot = self.respinStartDialog.startRoot
		if startRoot and startRoot.btnStart then 
			startRoot.btnStart:setTouchEnabled(false)
			self.respinStartDialog:clickStartBtn()
		end
		self.respinStartDialog = nil

	end
end

function cls:playRespinStartDialog()
	local theData = {}
	local cabName = "dialog_welcome"
	local dialogName = "respin_start"
	theData.click_event = function ( ... )
		self.respinStartDialog = nil
		self._mainViewCtl:stopAllLoopMusic()
		self._mainViewCtl:playMusicByName("dialog_close")
		self._mainViewCtl:laterCallBack(32/30, function()
			if self.data.reentry == 2 then
				self._mainViewCtl.mainView.remainingTipNode:setVisible(true)
				self._mainViewCtl.mainView.collect_respinWin:setVisible(false)
				self:showRespinLeftTime(nil, self.data.currentRespinTimes)
				self:enterRespinBonus()
			else
				self:enterRespinByTransition()
			end
		end)
	end
	self.respinStartDialog = self._mainViewCtl:showThemeDialog(theData, 1, cabName, dialogName)

	self._mainViewCtl:laterCallBack(3, function ()
		self:closeStartDialog()
	end)
		self._mainViewCtl:playMusicByName("respin_dialog_start")
end

function cls:openRespinBonus()
	self._mainViewCtl.footer.isRespinLayer = true
	self._mainViewCtl.cacheSpinRet = self._mainViewCtl.cacheSpinRet or self._mainViewCtl.rets
    if self.data.start_dialog then
		self:showBonusNode()
    else
		self.data.start_dialog = true
		self:saveBonus()
		self:playRespinStartDialog()
    end
end

function cls:showBonusNode(delay)
	delay = delay or 0
	self._mainViewCtl:changeSpinBoard(self._mainViewCtl.gameConfig.SpinBoardType.Respin)
	self:recoverRespinLastShow()
	self:recoverBonusSpine()
	self._mainViewCtl.mainView.remainingTipNode:setVisible(true)
	self._mainViewCtl.mainView.collect_respinWin:setVisible(false)
	self:showRespinLeftTime(nil, self.data.currentRespinTimes)
	self._mainViewCtl:resetCurrentReels(false,true)
	self._mainViewCtl:updateFooterCoin()
	self._mainViewCtl:laterCallBack(delay,function ()
		self:enterRespinBonus()
	end)
	
end

function cls:enterRespinBonus()
	self:playMusicByBonusNumber(self:getNumberOfBonus())
	self:finishSpinStep(1)
end

function cls:enterRespinByTransition( ... )
	local transitionConfig = self._mainViewCtl.gameConfig.transition_config
	self._mainViewCtl.node:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(0.2),
			cc.CallFunc:create(function ( ... )
				self._mainViewCtl:playTransition(nil,"respin")
			end),
			cc.DelayTime:create(transitionConfig.respin.onCover),
			cc.CallFunc:create(function ( ... )
				self._mainViewCtl:resetBoardCellsByItemList(self._mainViewCtl.old_item_list)
				self:showBonusNode(transitionConfig.respin.onEnd - transitionConfig.respin.onCover)
			end)
			)
		)
end

function cls:finishSpinStep( delay )
	self._mainViewCtl.footer.spinNode:changeBtnState("ingore", false, true)
	delay = delay or 0.5
	if self.data.currentRespinTimes > 0 then		
		self._mainViewCtl.rets["theme_respin"] = tool.tableClone(self.reSpinData)
		-- 添加条件判断是不是已经集满了
		self._mainViewCtl:laterCallBack(delay, function ( ... )
			if self:getNumberOfBonus() < 18 then
				self._mainViewCtl:handleResult()
			else
				self.reSpinData	= {}
                self.data.currentRespinTimes = 0
                self:saveBonus()
                self:showRespinLeftTime(nil, 0)
				self:finishSpinStep()
			end
		end)
	else
		self:showRespinLeftTime(nil, -1)
		self._mainViewCtl:playMusicByName("respin_end")
		self._mainViewCtl.mainView:playRespinAnimate(self:getReSpinTotalList()[self.data.hadUsedTimes+ 1], true)
		self._mainViewCtl:laterCallBack(2,function ()
			self:finishRespinBonusI()
		end)
	end
end

function cls:showTopNodeAndCoins()
	self._mainViewCtl.mainView.moveLastSpinTips:runAction(cc.ScaleTo:create(0.2, 0))
	---todo过渡动画
	if not self.winTwiceFlag then
		self._mainViewCtl:playMusicByName("collectBox_change")
		if self.collectLabel then self.collectLabel:setString("") end
		self._mainViewCtl:addSpineAnimation(self._mainViewCtl.mainView.collectBox_changeAniNode,nil,
		self._mainViewCtl:getSpineFile("respin_collect_change"),cc.p(0,0),"animation1")
		self._mainViewCtl.mainView.remainingTipNode:setVisible(false)
		self._mainViewCtl:laterCallBack(20/30,function()
			self._mainViewCtl.mainView.collect_respinWin:setVisible(true)
		end)
		self.collectMultiNode:setVisible(false)
	end
	self.collectLabel = self._mainViewCtl.mainView.collect_respinWin:getChildByName("label_coins")
	self.collectLabel:setVisible(true)
	self.collect_ani_Node = self._mainViewCtl.mainView.collectBox_changeAniNode
	if self.data.grandWin then 
		self:setWinCoins(self.collectLabel, nil, self.data.grandWin)
		self._mainViewCtl.totalWin = self._mainViewCtl.totalWin + self.data.grandWin
	end
end

function cls:finishRespinBonusI(reentry, endCall)
	self:showTopNodeAndCoins()
	local doList = {}
	local doNext = nil
	local itemList = self:getReSpinTotalList()
	itemList = itemList[self.data.hadUsedTimes + 1]
	for col = 1 ,#itemList do
		if self:isBonusSymbol(itemList[col]) then
			table.insert(doList, {col,itemList[col]})
		end
	end
	doNext = function ( ... )
		if #doList == 0 then
            self:dealSpecialBonus(endCall)
		else
			local list = table.remove(doList, 1)
			self._mainViewCtl.lockedReels[list[1]] = false
			if self:isBonusSymbol(list[2]) == "muti" then
				table.insert(self.mutiList,{list[1], self._mainViewCtl.gameConfig.specialEpicLinkMul[list[2]]})
				doNext()
			elseif self:isBonusSymbol(list[2]) == "jackpot" then
				if self:getJpUnlockStatus(list[2] - 25) then
					self._mainViewCtl:addJpAwardAnimation(list[2] - 25)
				end
				self._mainViewCtl:laterCallBack(1, function ()
					self:showJpDialog(list[2], doNext, false, list[1])
				end)
			elseif self:isBonusSymbol(list[2]) == "win_again" then
				if not reentry then
					self.winTwiceFlag = list[1]
				else
					self.winTwiceFlag = false
				end
                doNext()
			elseif self:isBonusSymbol(list[2]) == "play_again" then
				self.playTwiceFlag = list[1]
                doNext()
			else
				self:hideSymbolBgSpine(list[1],list[2])
				self._mainViewCtl:playMusicByName("respin_bonus_collect")
				self._mainViewCtl:laterCallBack(14/30,function ()
					self:addCoinsToTopCon(list[1],list[2], doNext)
				end)
			end
		end
	end
	if self:getNumberOfBonus() == 18 and not self.winTwiceFlag and not self.data.grandWin then
		self._mainViewCtl:laterCallBack(15/30, function ()
			self._mainViewCtl:addSpineAnimation(self._mainViewCtl.mainView.animateNode,nil,
			self._mainViewCtl:getSpineFile("respin_grand"),cc.p(640,330),"animation1")
		end)
		if self:getJpUnlockStatus(1) then
			self._mainViewCtl:addJpAwardAnimation(1)
		end
		self._mainViewCtl:laterCallBack(47/30, function()
			self._mainViewCtl:playMusicByName("grand_land")
			local _,s = self._mainViewCtl:addSpineAnimation(self._mainViewCtl.mainView.respinAniNode,nil,
			self._mainViewCtl:getSpineFile("respin_grand"),cc.p(640,320),"animation2")
			self._mainViewCtl:laterCallBack(50/30,function()
				self._mainViewCtl.mainView.respinAniNode:removeAllChildren()
				self:showJpDialog(26, doNext, true) 
			end)
		end)
	else
		self._mainViewCtl:laterCallBack(1,function ()
			doNext()
		end)
	end
end

function cls:getJpUnlockStatus(index)
	index = index or 3
	if self.jpLockStatus and 
		self.jpLockStatus[index] and 
		self.jpLockStatus[index] == 1 then
			return true
	end
	return false
end

function cls:addCoinsToTopCon( col, realKey, doNext )
	local delay1 = 10/30 -- 15/30
	local addWin = self:getSymbolCoin(realKey)
	self._mainViewCtl.node:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			self._mainViewCtl.totalWin = self._mainViewCtl.totalWin + addWin
			self.respinTotalWin = self.respinTotalWin + addWin
			self:setWinCoins(self.collectLabel, addWin, self._mainViewCtl.totalWin - addWin - self.data.win_before_respin)
		end),
		cc.DelayTime:create(delay1),
		cc.CallFunc:create(function ( ... )
			if doNext then
				doNext()
			end
		end)
		))
end

function cls:showJpDialog(stype, doNext, triggerByFull, col)
	local index = stype - 25
	local delay = 30/30
	local csbName = self:getJpUnlockStatus(index) and "dialog_jp" or "dialog_jp_locked"
	local dialogType = self:getJpUnlockStatus(index) and "jp_collect" or "respin_collect"
	local theData = {}
    theData.bg = index
	local jpWin = self:getSymbolCoin(stype)
	theData.coins = jpWin
	local pressFunc = function ( obj )
		self._mainViewCtl:playMusicByName("dialog_close")
		self._mainViewCtl:removeJpAwardAnimation(index)
		self._mainViewCtl.totalWin = self._mainViewCtl.totalWin + jpWin
		if index == 1 then
			self.data.grandWin = jpWin
			self.data.winGrandTimes = self.data.winGrandTimes or 0
			self.data.winGrandTimes = self.data.winGrandTimes + 1
			self:saveBonus()
		end
		self._mainViewCtl:laterCallBack(delay,function()
			if not triggerByFull then 
				self:hideSymbolBgSpine(col ,stype) 
			end
			self._mainViewCtl:laterCallBack(0.5, function()
			self._mainViewCtl:playMusicByName("respin_bonus_collect")
			self:setWinCoins(self.collectLabel, jpWin, self._mainViewCtl.totalWin - jpWin - self.data.win_before_respin)
			jpWin = triggerByFull and 0 or jpWin
			self.respinTotalWin = self.respinTotalWin + jpWin
			end)
		end)
		self._mainViewCtl.node:runAction(cc.Sequence:create(
			cc.DelayTime:create(1.3 + delay),
			cc.CallFunc:create(function ( ... )
				self.jpDialog = nil
				if doNext then
					doNext()
				end
			end)
			))
	end
	theData.click_event = function ( ... )
       pressFunc()
	end
	if not self:getJpUnlockStatus(index) then 
		self._mainViewCtl:playMusicByName("dialog_lock_jackpot_"..index)
	else
		self._mainViewCtl:playMusicByName("dialog_jackpot_"..index)
	end
	self.jpDialog = self._mainViewCtl:showThemeDialog(theData, 3, csbName, dialogType)
end

function cls:addMutiToFooter(muti)
	self._mainViewCtl.node:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			local addWin =  self.respinTotalWin * (muti - 1)
			for i = 2, #self.hadUserJpList do
				if self.hadUserJpList[i] == 1 then
					addWin = addWin - self.progressive_list[i] * (muti - 1)
					self.hadUserJpList[i] = 2
				end
			end
			self._mainViewCtl.totalWin = self._mainViewCtl.totalWin + addWin
			self.respinTotalWin = self.respinTotalWin + addWin
			self:setWinCoins(self.collectLabel, addWin,  self._mainViewCtl.totalWin - addWin - self.data.win_before_respin)
			self.finalMuti = nil
		end)
	))
end

function cls:finishRespinBonusII( ... )
	local transitionDelay = self._mainViewCtl.gameConfig.transition_config
	-- 可以切屏且收钱了
	self.data["end_game"] = true
	self:saveBonus()
	self._mainViewCtl:collectCoins(1)
	self._mainViewCtl:onRespinOver()
	self._mainViewCtl.rets["theme_respin"] = nil

	local bonusEndFun = function ( ... )
		self._mainViewCtl.footer.isRespinLayer = false
		if self.bonus.callback then
			if not self._mainViewCtl.showFreeSpinBoard then
				self._mainViewCtl.footer.isFreeSpin = false
				self._mainViewCtl.footer.isFreeSpinLayer = false
			else
				self._mainViewCtl.footer.isFreeSpin = true
			end
			self.bonus.callback()
		end
		self.bonus:exitBonusStepI()
	end

	self._mainViewCtl.node:runAction(cc.Sequence:create(
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function ( ... )
			self._mainViewCtl:playTransition(nil,"respin") 
			self._mainViewCtl.collectViewCtl:setCurCollectLevel(self._mainViewCtl.fg_level)
		end),
		cc.DelayTime:create(transitionDelay["respin"]["onCover"]),
		cc.CallFunc:create(function ( ... )
			self._mainViewCtl.mainView.collect_respinWin:setVisible(false)
			self.collectLabel:setString("")
			if self._mainViewCtl.showFreeSpinBoard or (self._mainViewCtl.rets and self._mainViewCtl.rets["free_spins"]) then
				self._mainViewCtl.footer.isFreeSpin = true
				self._mainViewCtl.footer:changeLabelDescription("FS_Win")
				self._mainViewCtl:changeSpinBoard(self._mainViewCtl.gameConfig.SpinBoardType.FreeSpin)
				self._mainViewCtl:resetCurrentReels(true,false)
			else
				self._mainViewCtl.footer:changeLabelDescription("notFS_Win")
				self.saveWin = false
				self._mainViewCtl:resetCurrentReels(false,false)
				self._mainViewCtl:changeSpinBoard(self._mainViewCtl.gameConfig.SpinBoardType.Normal)
			end
			-- self._mainViewCtl:resetBoardCellsByItemList(self._mainViewCtl.old_item_list)
			self._mainViewCtl:outBonusStage(self:getReSpinTotalList())
		end),
		cc.DelayTime:create(transitionDelay["respin"]["onEnd"] - transitionDelay["respin"]["onCover"]),
		cc.CallFunc:create(function ( ... )
			if self._mainViewCtl.showFreeSpinBoard then
	   			self._mainViewCtl:dealMusic_PlayFreeSpinLoopMusic()
	   		else
	   			self._mainViewCtl:dealMusic_PlayNormalLoopMusic()
	   		end
	   		if self._mainViewCtl.showFreeSpinBoard and self._mainViewCtl.freewin then
				if self._mainViewCtl.freespin < 1 then
					self._mainViewCtl.spin_processing = true
				end
			end
			if self:getNumberOfBonus() == 18 then 
				self.respinTotalWin = self.respinTotalWin + self:getSymbolCoin(26) *self.data.winGrandTimes
			end
			self.respinTotalWin = self.data.core_data.respin_info[1].respin_win 
			if self.data.core_data.respin_info[2] then
				self.respinTotalWin = self.respinTotalWin + self.data.core_data.respin_info[2].respin_win
			end
			self._mainViewCtl.totalWin  = self._mainViewCtl.totalWin - self.respinTotalWin
			-- self._mainViewCtl.totalWin = self._mainViewCtl.totalWin - self.respinTotalWin
			self._mainViewCtl:startRollup(self.respinTotalWin, bonusEndFun)
		end)
		))
end

function cls:dealMutiBonus(endCall)
    self.finalMuti = self.finalMuti or 0
    if self.mutiList and #self.mutiList ~= 0 then 
		self:playMuitlCollect(endCall)
    else 
        if self.finalMuti ~= 0 then 
			self:mutiFlyToCollectionBox(endCall)
        end
    end
end

function cls:playMuitlCollect(endCall)
	local list = table.remove(self.mutiList, 1)
	self.finalMuti = self.finalMuti + list[2] 
	self:hideSymbolBgSpine(list[1],"muti", endCall)
end


function cls:creatMultiLabelNode(len)
	self.collectMulLabel = self.collectMultiNode:getChildByName("label_muti")
	local mutiNode = self.collectMultiNode:getChildByName("muti")
	if mutiNode then
		mutiNode:setVisible(false)
	end

	self.collectMultiNode.base_scale = 0.5
	self.collectMultiNode.add_scale = 0.1/len
	self.collectMulLabel:setString("")
	self.collectMultiNode:setVisible(true)
	self.collectMultiNode:setPosition(cc.p(0,-197))
	self.collectMultiNode:setOpacity(255)
	self.collectMultiNode:setScale(1)
	self.collectMulLabel:setPosition(cc.p(0,0))
	self.collectMulLabel:setScale(1.5)

	if self.curMuti and self.curMuti > 1 then
		self.curMuti = 0
	else
		inherit(self.collectMulLabel, LabelNumRoll)
		local function fontFormat2(num)
			return FONTS.format(num, true).."X"
		end
		self.collectMulLabel:nrInit(0, 25, fontFormat2)
	end
end

function cls:dealSpecialBonus(endCall)
	if self.mutiList and #self.mutiList > 0 then 
		if #self.mutiList == 1 then self.singleMuti = self.mutiList[1] end
		self:creatMultiLabelNode(#self.mutiList)
		self:dealMutiBonus(endCall)
	else 
		self:dealOtherBonus(endCall)
	end
end

function cls:dealOtherBonus(endCall)
	if endCall then endCall() end
    if not self.winTwiceFlag and not self.playTwiceFlag then
		self:moveCollectionBoxMoneyToFooter()
		self._mainViewCtl:laterCallBack(35/30,function ()
			self._mainViewCtl.footer:setWinCoins(self._mainViewCtl.totalWin - self.data.win_before_respin, self.data.win_before_respin, 1)
			self._mainViewCtl:laterCallBack(1.5,function ()
				self:playBonusCollectDialog()
			end)
		end)	
    end
    if self.winTwiceFlag then 
		local a7 = cc.CallFunc:create(function()
			self._mainViewCtl:addSpineAnimation(self._mainViewCtl.mainView.animateNode,nil,
			self._mainViewCtl:getSpineFile("respin_grand"),cc.p(640,330),"animation1")
   	 	end)
		local node = cc.Node:create()
		self._mainViewCtl.mainView.respinAniNode:addChild(node)
		node:setPosition(self._mainViewCtl:getCellPos(self.winTwiceFlag,1))
		local endPos = cc.p(640,330)
    	local a2 = cc.EaseIn:create(cc.MoveTo:create(18/30, endPos), 2)
    	local a3 = cc.CallFunc:create(function()
		self._mainViewCtl:playMusicByName("all_win2")
		local spineFile = self._mainViewCtl:getSpineFile("respin_winAgain")
		self._mainViewCtl:addSpineAnimation(node, 
		nil, spineFile,cc.p(0,0),"animation")
   	 	end)
		local a1 = cc.DelayTime:create(18/30)
		local a4 = cc.DelayTime:create(31/30)
		local a5 = cc.RemoveSelf:create()
    	local a6 = cc.Sequence:create(a3,a2,a1,a7,a4,a5)
		node:runAction(a6)
		self:hideSymbolBgSpine(self.winTwiceFlag, "win_again")
        self.playTwiceFlag = false
		self.respinTotalWin = 0
		local endCall = function ()
			self.respinTotalWin = self.respinTotalWin * 2
			for i = 2, #self.hadUserJpList do
				if self.hadUserJpList[i] == 2 then
					self.respinTotalWin = self.respinTotalWin + self.progressive_list[i]
				end
			end
		end
		self._mainViewCtl:laterCallBack(1,function ()
			self:recoverBonusSpine({["win_again"] = true, ["play_again"] = true})
			self:finishRespinBonusI(true, endCall)
		end)
	end
    if self.playTwiceFlag then
		self._mainViewCtl:addSpineAnimation(self.collect_ani_Node, nil,
		self._mainViewCtl:getSpineFile("before_playAgain"), cc.p(0,0), "animation")
		self._mainViewCtl:laterCallBack(40/30,function()
			self:moveCollectionBoxMoneyToFooter()
			self._mainViewCtl:laterCallBack(35/30,function ()
				self._mainViewCtl.footer:setWinCoins(self._mainViewCtl.totalWin - self.data.win_before_respin, self.data.win_before_respin, 1)
			end)
			self._mainViewCtl:laterCallBack(30/30,function ()
				self._mainViewCtl:playMusicByName("bonus_bell")
				self._mainViewCtl.mainView:setCellAniOrder(31,self.playTwiceFlag,1,nil,self._mainViewCtl:getCellPos(self.playTwiceFlag,1),true,nil,true)
				self._mainViewCtl:laterCallBack(90/30, function ()
					self:hideSymbolBgSpine(self.playTwiceFlag,"play_again")
					self._mainViewCtl:laterCallBack(0.5, function()
						self:dealReentryData()
						self:openRespinBonus()
					end)   		
				end)
			end)
		end)
    end
end

function cls:dealReentryData()
	self:setGrandExcitation(false)
	self.musicFlag = 0
    self.data.hadUsedTimes = nil
    self.data.reentry = 2
    self.data.currentRespinTimes = 3
	self.data.totalWin = self._mainViewCtl.totalWin
	self.data.start_dialog = false
	self.data.hadUserJpList = self.hadUserJpList
	self.data.grandWin = nil
    self:saveBonus()
    self:initData(self.data.reentry)
end

function cls:fixRet( ret )
	self._mainViewCtl.resultCache = {}
	local item_list_up = {}
	local item_list_down = {}
	for r = 1, 18 do
		item_list_up[r] = {}
		item_list_down[r] = {}
		for a = 1, 5 do 
			local num = math.random(2,5)
			table.insert(item_list_down[r], num)
			if a == 1 then
				table.insert(item_list_up[r], num)
			end
		end
	end

	if not ret then return end
    local itemsList = table.copy(ret.item_list)

    local index = 0
    for col = 1, 18 do
        index = index + 1
        ret.item_list[index] = { itemsList[index] }
        self._mainViewCtl.resultCache[index] = {math.random(2, 5), itemsList[index]} --向上插入一个值
        local extraCount = 6
        if self._mainViewCtl.isTurbo then
            extraCount = 3
        end
        for k = 1, extraCount do
            table.insert(self._mainViewCtl.resultCache[index], math.random(2,5))
        end
	end

	if self._mainViewCtl.cacheSpinRet then
		self._mainViewCtl.cacheSpinRet["item_list_up"] = item_list_up
		self._mainViewCtl.cacheSpinRet["item_list_down"] = item_list_down
	end
	self.recvItemList = ret.item_list
    -- self.recvNewADDItemList = ret.respin_info[self.data.reentry or 1].respin_list[self.data.hadUsedTimes + 1]
end

function cls:fixRespinResult()
	local delateRespinData = table.remove(self.reSpinData, 1)
	local bonusLimit = 22
	self.lastSingleFature = nil
	if self:getGrandExcitation() then
		self:playRespinExcitation(self:getGrandExcitation())
	else 
		local noBonusNum = 0
		local colIndex = 0
		for key, val in ipairs(delateRespinData) do
			if val < bonusLimit then
				noBonusNum = noBonusNum + 1
				colIndex = key
			end
		end
		if noBonusNum == 1 then
			local lastRespinList = self:getLastRespinItemList()
			local isGetFeature = true
			local lastKey = nil
			if lastRespinList and #lastRespinList > 0 then
				for key, val in ipairs(lastRespinList) do
					if val < bonusLimit and delateRespinData[key] >= bonusLimit then
						if key > colIndex then
							isGetFeature = false
						else 
							lastKey = key
						end
					end
				end
			end
			self:setGrandExcitation(colIndex)
			if isGetFeature and lastKey then
				self.lastSingleFature = lastKey
			end
		end
	end
	return  delateRespinData
end

function cls:onRespinStart( ... )
	self.DelayStopTime = 0
    if self._mainViewCtl.showReSpinBoard then
        self._mainViewCtl.respinStep = self._mainViewCtl.gameConfig.ReSpinStep.Playing
	    self.data.hadUsedTimes = self.data.hadUsedTimes + 1
	    self.data.currentRespinTimes = self.data.currentRespinTimes - 1
    end
    self:saveBonus()
    self:showRespinLeftTime(nil, self.data.currentRespinTimes)
    self._mainViewCtl:cleanSpecialSymbolState()
end

function cls:beforeRespinStop( ret )
	if self._mainViewCtl.showReSpinBoard then
        self:fixRet(ret)
    end
    if #ret["theme_respin"] == 0 then
        self._mainViewCtl.respinStep = self._mainViewCtl.gameConfig.ReSpinStep.Over
        ret.theme_deal_show = true
    end
end

function cls:onRespinStop( ret )
	self:playMusicByBonusNumber(self:getNumberOfBonus())
    local times = self:dealWithCurrentData()
	if times then
			self.data.currentRespinTimes = times
			self:showRespinLeftTime(times == 3, times)
            self:saveBonus()
			self:finishSpinStep()
    end
	if times == 0 then 
		self:killExcitation()
	end
end

function cls:respin_onReelStop( col )
	-- self.respinTotalCount = self.respinTotalCount or  0 
    if self._mainViewCtl.lockedReels[col] then
        return
    end
    local item_List = self.reSpinNewADD[self.data.hadUsedTimes + 1]
    if not item_List then
        return
    end
    local key = item_List[col]
    if self:isBonusSymbol(key) then
    	self:respin_symbolLand(col, key)
	elseif self:getGrandExcitation() then
		self:killExcitation()
    end
	if not self:isBonusSymbol(key) then
		self._mainViewCtl.audioCtl:playEffectWithInterval(self._mainViewCtl.audio_list["reel_stop"],0.1,false)
	end
	if self.lastSingleFature and self.lastSingleFature == col then
		self:playRespinExcitation(self:getGrandExcitation())
	end
end

function cls:respin_symbolLand( col, key )
	self._mainViewCtl.audioCtl:playEffectWithInterval(self._mainViewCtl.audio_list.bonus_land, 0.1, false)
	self._mainViewCtl.isReelChange = true
	self._mainViewCtl.lockedReels[col] = true
	local curBonus = 0
	local tempCol  = 0
	for col = 1, 18 do
		if self._mainViewCtl.lockedReels[col] then
			curBonus = curBonus + 1
		else
			tempCol = col
		end
	end
	
	if curBonus == 17 then
		self:setGrandExcitation(tempCol)
	else
		self:setGrandExcitation(false)
	end
	if curBonus == 18 then
		self._mainViewCtl:playMusicByName("respin_board_full")
	end
	self:killExcitation()
    self:setOutBoardSymbolAni(col, key)
end
--View

function cls:playRespinExcitation(tempCol)
	if not tempCol then return end
	self._mainViewCtl:playMusicByName("respin_excitation")
	local spineFile = self._mainViewCtl:getSpineFile("respin_last")
	local cellPos = self._mainViewCtl:getCellPos(tempCol, 1)
	self._mainViewCtl:addSpineAnimation(self._mainViewCtl.mainView.respinAniNode, nil, spineFile, cellPos, "animation", nil, nil, nil, true, true)
end
function cls:hideSymbolBgSpine(col, stype, endCall)
	local hideNode = self.respinBonusSpineList[col]
	local destination = self.collect_ani_Node
	if stype == "muti" or 
		stype == "play_again" or 
		stype =="win_again" then
			destination = nil
	end
	if destination then
		self:flyToCollectBoard(col, destination)
	end
	local a2 = cc.RemoveSelf:create()
	hideNode:runAction(a2)
	if stype == "muti" then
		if not self.singleMuti then 
			self:setSuperpositionOfMuti(col, endCall)
		else
			self:mutiFlyToCollectionBox(endCall)
		end
	end
end

function cls:flyToCollectBoard(col, destination)
	if not destination then return end
	local baseLength = 410
	local endPos =	bole.getWorldPos(destination)
	local startPos = self._mainViewCtl:getCellPos(col, 1)
	local endNPos = bole.getNodePos(self.respinFlyNode,endPos)
	local angle = -(90 + math.atan2((endNPos.y - startPos.y), (endNPos.x - startPos.x)) * 180 / math.pi) + 180
	local endLength = math.sqrt(math.pow((endNPos.y - startPos.y), 2) + math.pow((endNPos.x - startPos.x), 2))
	local scale = endLength / (baseLength)

	local _particle = cc.Node:create()
	self.respinFlyNode:addChild(_particle, -1)
	local _, spine = self._mainViewCtl:addSpineAnimation(_particle, nil, self._mainViewCtl:getSpineFile("respin_collect_tuowei"),cc.p(0,0),"animation")
	_particle:setPosition(startPos)
	
	spine:setScaleY(scale)
	if scale < 0.8 then
		scale = 0.8
	end
	spine:setScaleX(scale)
	spine:setRotation(angle)

	local a1 = cc.DelayTime:create(23/30)
	local a2 = cc.RemoveSelf:create()
	local a3 = cc.Sequence:create(a1, a2)
	_particle:runAction(a3)
end

function cls:playMuitl()

end

function cls:showRespinLeftTime(isAnimation, currentTimes)
	if isAnimation then
		self._mainViewCtl:playMusicByName("respin_times_reset")
		local file = self._mainViewCtl:getSpineFile("flash")
		bole.addSpineAnimation(self._mainViewCtl.mainView.moveSpinTimes_ani, nil, file, cc.p(0,0), "animation")
	end
	if currentTimes < 0 then 
		self:changeTimesLabelState(false)
		self._mainViewCtl.mainView.moveLastSpinTips:runAction(cc.ScaleTo:create(0.2, 0))
	end
	if currentTimes == 0 then
			self:changeTimesLabelState(false)
			self._mainViewCtl.mainView.moveLastSpinTips:runAction(cc.ScaleTo:create(0.2, 1))
            self._mainViewCtl.mainView.moveSpinTimes:runAction(cc.ScaleTo:create(0.2, 0))
			self._mainViewCtl.mainView.moveSpinTips:runAction(cc.ScaleTo:create(0.2, 0))
	elseif currentTimes > 0 then
        self:changeTimesLabelState(true)
		if currentTimes == 1 then
            self._mainViewCtl.mainView.moveSpinTimes:setString(currentTimes)
			bole.updateSpriteWithFile(self._mainViewCtl.mainView.moveSpinTips,"#theme240_base_35.png")
		elseif currentTimes == 2 then
			self._mainViewCtl.mainView.moveSpinTimes:setString(currentTimes)
		else
			bole.updateSpriteWithFile(self._mainViewCtl.mainView.moveSpinTips,"#theme240_base_32.png")
			self._mainViewCtl.mainView.moveSpinTimes:setString(currentTimes)
			self._mainViewCtl.mainView.moveLastSpinTips:runAction(cc.ScaleTo:create(0.2, 0))
			self._mainViewCtl.mainView.moveSpinTimes:runAction(cc.ScaleTo:create(0.2, 1))
			self._mainViewCtl.mainView.moveSpinTips:runAction(cc.ScaleTo:create(0.2, 1))
		end
	end
end

function cls:recoverBonusSpine(list)
	local itemList = self:getReSpinTotalList()
	local grandJili = 0
	local tempCol = 0
	local jiliNum = 17
	itemList = itemList[self.data.hadUsedTimes + 1]
	for col = 1, #itemList do
        local symbol = self:isBonusSymbol(itemList[col])
		if symbol and (not list or (list and not list[symbol])) then
		self.respinBonusSpineList[col] = self._mainViewCtl.mainView:setCellAniOrder(itemList[col], col, 1, self._mainViewCtl.mainView.jili_node,self._mainViewCtl:getCellPos(col,1),true,false)
			self._mainViewCtl.lockedReels[col] = true
			grandJili = grandJili + 1
		else 
			tempCol = col
		end
	end
	if jiliNum == grandJili then
		self:setGrandExcitation(tempCol)
	end
end
function cls:setGrandExcitation(enable)
	self.grandExcitationStatus = enable
end
function cls:getGrandExcitation()
	return self.grandExcitationStatus
end
function cls:recoverRespinLastShow( ... )
	local respin_last_show = self:getReSpinTotalList()
	local item_list = respin_last_show[self.data.hadUsedTimes + 1] or {}
	local row = 1
	for col, list in ipairs(item_list) do
		local cell =  self._mainViewCtl.mainView.spinLayer.spins[col]:getRetCell(row)
		if item_list[col] and cell then
			self._mainViewCtl.mainView:updateCellSprite(cell, item_list[col], col, nil, true)
			local cellUp =  self._mainViewCtl.mainView.spinLayer.spins[col]:getRetCell(row - 1)
			if cellUp then
				self._mainViewCtl.mainView:updateCellSprite(cellUp, math.random(2,5), col, nil, true)
			end
			local cellDown =  self._mainViewCtl.mainView.spinLayer.spins[col]:getRetCell(row + 1)
			if cellDown then
				self._mainViewCtl.mainView:updateCellSprite(cellDown, math.random(2,5), col, nil, true)
			end
		end
	end
end

function cls:setOutBoardSymbolAni(col, key)
	local node = self._mainViewCtl.mainView.spinLayer.spins[col]:getRetCell(1)
    if not node then
    	return
    end
	-- self._mainViewCtl:addSpineAnimation(node.tipNode, col, self._mainViewCtl:getSpineFile("bonus"),cc.p(0,0),"animation1",nil,nil,nil,true,true)
    self._mainViewCtl.lockedReels[col] = true
	self.respinBonusSpineList[col] = self._mainViewCtl.mainView:setCellAniOrder(key,col,1,self._mainViewCtl.mainView.jili_node,self._mainViewCtl:getCellPos(col,1),true,true)
end

-----------------Tools-------------------
function cls:setWinCoins(label, coins ,start)
	start = start or 0
    coins = coins or 0 
	if coins > 0 then
		inherit(label, LabelNumRoll)
		local function fontFormat2(num)
	    	return FONTS.format(num, true)
		end
		label:nrInit(0, 25, fontFormat2)
		-- label:setString(FONTS.format(start,true))--(self:parserWinLabelFunc(number))
		label:setString(FONTS.format(start+coins,true))
		bole.shrinkLabel(label, 500, 1)
		label:setString(FONTS.format(start,true))
		local dur = 0.7
		label:nrStartRoll(start, start+coins, dur)	
		self._mainViewCtl:addSpineAnimation(self.collect_ani_Node, nil,
		self._mainViewCtl:getSpineFile("collect_flash"), cc.p(0,0), "animation")
	else 
		label:setString(FONTS.format(start,true))
		bole.shrinkLabel(label, 500, 1)
	end
end

function cls:addSymbolFont(scale, fileName, pos)
	local font = fileName or "font/theme240_font_3.fnt"
	scale = scale or 1
	pos = pos or cc.p(0,0)
    local file = self._mainViewCtl:getPic(font)
    local fntLabel = ccui.TextBMFont:create()
    fntLabel:setFntFile(file)
	fntLabel:setScale(scale)
	fntLabel:setPosition(pos)
	fntLabel.baseScale = scale
    return fntLabel
end

function cls:setSuperpositionOfMuti(col, endCall)
	local musicName = "muti_fly"
	self._mainViewCtl:playMusicByName(musicName)
    local rollTime = 0.3
	col = col or 1
	self.oldMuti = self.curMuti or 0
	self.curMuti = self.finalMuti
	local endScale = self.collectMultiNode.base_scale + self.collectMultiNode.add_scale
    self.collectMultiNode.base_scale = endScale

    local file = self._mainViewCtl:getSpineFile("muti_convergence")

    local node = cc.Node:create()
	local label = self:addSymbolFont()
	local cell = self._mainViewCtl:getCellItem(col, 1)
	local startPos = bole.getWorldPos(cell)
	local startNPos = bole.getNodePos(self.collectMultiNode, startPos)

	local endPos = cc.p(0, 0)
	node:setPosition(startNPos)
	node:addChild(label)
	local addMul = self.finalMuti - self.oldMuti
	label:setString(addMul.."X")
	self.collectMultiNode:addChild(node)
	bole.setEnableRecursiveCascading(node, true)

	local a1 = cc.ScaleTo:create(0.5, 2)
	local a2 = cc.MoveTo:create(0.5, endPos)
	local a3 = cc.Spawn:create(a1, a2)
	local a4 = cc.ScaleTo:create(0.2, 1)
	local a5 = cc.CallFunc:create(function ()
    	bole.addSpineAnimation(node, -1, file, cc.p(0,0), "animation")
		self.collectMulLabel:setString(self.curMuti.."X")
		self.collectMulLabel:setScale(endScale)
		self:dealMutiBonus(endCall)
	end)
	local a6 = cc.FadeOut:create(0.3)
	local a7 = cc.RemoveSelf:create()
	local a8 = cc.Sequence:create(a3, a4, a5, a6, a7)
	node:runAction(a8)
end

function cls:mutiFlyToCollectionBox(endCall)
	local endPos = bole.getPos(self.collectLabel)
	local node = nil
	local musicName = "muti_collect"
	if self.singleMuti then
		node = cc.Node:create()
		local label = self:addSymbolFont()
		local cell = self._mainViewCtl:getCellItem(self.singleMuti[1], 1)
		local startPos = bole.getWorldPos(cell)
		local startNPos = bole.getNodePos(self.collectMultiNode, startPos)
		node:setPosition(startNPos)
		node:addChild(label)
		label:setString(self.singleMuti[2].."X")
		self.collectMultiNode:addChild(node,10)
		bole.setEnableRecursiveCascading(node, true)
		endPos = cc.p(0,197)
	end

	local a0 = cc.CallFunc:create(function ()
		self._mainViewCtl:playMusicByName(musicName)
	end)
	local a1 = cc.DelayTime:create(0.5)
    local a2 = cc.EaseIn:create(cc.MoveTo:create(0.5, endPos), 2)
	local a11 = cc.ScaleTo:create(0.5, 2)
	local a12  =cc.Spawn:create(a2,a11)
    local a3 = cc.CallFunc:create(function()
		local spineFile = self._mainViewCtl:getSpineFile("muti_toCollectionBox")
		self._mainViewCtl:addSpineAnimation(self._mainViewCtl.mainView.collectBox_changeAniNode, 
		nil, spineFile,cc.p(0,0),"animation")
		self:addMutiToFooter(self.finalMuti)
    end)
    local a4 = cc.Spawn:create(cc.FadeOut:create(0.5), cc.ScaleTo:create(0.5, 0))
    local a5 = cc.CallFunc:create(function ()
		self.collectMultiNode:setVisible(false)
    end)
	local a6 = cc.DelayTime:create(1)
	local a7 = cc.CallFunc:create(function ()
		self:dealSpecialBonus(endCall)
	end)
	local a10 = cc.RemoveSelf:create()
	local a8 = cc.Sequence:create(a1,a0,a2,a3,a4,a5,a6,a7)
	local a9 = cc.Sequence:create(a1,a0,a12,a3,a4,a6,a7,a10)
	if not self.singleMuti then
    	self.collectMultiNode:runAction(a8)
	else
		node:runAction(a9)
	end
end

function cls:moveCollectionBoxMoneyToFooter()
	self._mainViewCtl:playMusicByName("collect_fly")
	self.flyParent = cc.Node:create()
	bole.scene:addToTop(self.flyParent)
	self.flyParent:setPosition(0,0)
	-- local labelPos = cc.p(0, 197)
    local pos = bole.getWorldPos(self.collectLabel)
    local nodePos = bole.getNodePos(self.flyParent, pos)
    -- nodePos = cc.pAdd(nodePos, labelPos)
    local endPos = bole.getNodePos(self.flyParent,self._mainViewCtl:getFooterWinWordPos(self.flyParent))
	bole.changeParent(self.collectLabel, self.flyParent)
	
	self.collectLabel:setPosition(nodePos)
    -- local endPos = bole.getPos(self._mainViewCtl.footer)
    local a2 = cc.MoveTo:create(0.8, endPos)
	local a1 = cc.ScaleTo:create(0.5, 1.5)
	local a3 = cc.CallFunc:create(function()
		self._mainViewCtl:addSpineAnimation(self.flyParent, 10, self._mainViewCtl:getSpineFile("respin_footer_flash"), endPos, "animation")
	end)
	-- local a1 = cc.DelayTime:create(0.5)
    -- local a4 = cc.ScaleTo:create(0.3, 0)
    local a5 = cc.CallFunc:create(function ()
		self.collectLabel:setVisible(false)
		bole.changeParent(self.collectLabel, self._mainViewCtl.mainView.collect_respinWin,3)
		self.collectLabel:setPosition(cc.p(0,0))
    end)
    local a6 = cc.Sequence:create(a1, a2, a3, a5)
    -- self._mainViewCtl:playMusicByName("diamond_collectall")
    self.collectLabel:runAction(a6)
end

function cls:dealWithCurrentData( itemList )
	local newAdd = self.reSpinNewADD[self.data.hadUsedTimes + 1]
	local times  = self.data.currentRespinTimes
	for key = 1 ,#newAdd do
		if self:isBonusSymbol(newAdd[key]) then
			self._mainViewCtl:addSpineAnimation(self._mainViewCtl.mainView.headAniNode, nil, self._mainViewCtl:getSpineFile("respin_collect_flash"),
		cc.p(0,0),"animation")
			times = 3
			break
		end
	end
	return times
end

function cls:isBonusSymbol(key)
    if key < 22 then return false
	elseif key >= 100 then return "coins"
    elseif key == 31 then return "play_again"
    elseif key == 30 then return "win_again"
    elseif key >= 26 then return "jackpot"
    elseif key >= 22 then return "muti"
    end
end

function cls:getSymbolCoin( key, rate)
	local addWin = 0
	local prolist = 0
	local fontRate = 0
	if self._mainViewCtl.gameConfig.epicLinkMul[key] then
		fontRate = self._mainViewCtl.gameConfig.epicLinkMul[key]
	elseif self._mainViewCtl.gameConfig.jpEpicLinkMul[key] then
		fontRate = self._mainViewCtl.gameConfig.jpEpicLinkMul[key]
		local index = key - 25
		if self.hadUserJpList[index] and self.hadUserJpList[index] == 0 then
			self.hadUserJpList[index] = 1
			prolist = self.progressive_list[index]
		end
	end
	addWin = self._mainViewCtl:getSymbolLabel(fontRate)
	addWin = addWin + prolist
	return addWin
end

function cls:getReSpinTotalList()
	return table.copy(self.data.core_data.respin_info[self.data.reentry or 1].respin_total_list)
end

function cls:getLastRespinItemList()
	if self.data.hadUsedTimes and self.data.hadUsedTimes > 0 then
		local allRespinList = self:getReSpinTotalList()
		return allRespinList[self.data.hadUsedTimes]
	end
	return false
end

function cls:changeTimesLabelState(state)
    self._mainViewCtl.mainView.moveSpinTimes:setVisible(state)
	self._mainViewCtl.mainView.moveSpinTips:setVisible(state)
    self._mainViewCtl.mainView.moveLastSpinTips:setVisible(not state)
end

function cls:getNumberOfBonus()
	local list = self:getReSpinTotalList()
	list = list[self.data.hadUsedTimes + 1]
	local count = 0
	for col = 1, #list do
		if list[col] >= 22 then
			count = count + 1
		end
	end
	return count
end

function cls:killExcitation()
	if self._mainViewCtl.mainView.respinAniNode then 
		self._mainViewCtl.audioCtl:stopMusic(self._mainViewCtl.audio_list.respin_excitation,true)
		self._mainViewCtl.mainView.respinAniNode:removeAllChildren()
	end
end

function cls:playMusicByBonusNumber(number)
	self.musicFlag = self.musicFlag or 0
	if number >= 0 and number < 12 and self.musicFlag ~= 1 then
		self.musicFlag = 1
		self._mainViewCtl:stopAllLoopMusic()
		self._mainViewCtl:dealMusic_PlayRespinLoopMusic(1)
	elseif number >= 12 and self.musicFlag ~= 2 then
		self.musicFlag = 2
		self._mainViewCtl:stopAllLoopMusic()
		self._mainViewCtl:dealMusic_PlayRespinLoopMusic(2)
	end
end
function cls:playBonusCollectDialog()
	local csbName = "dialog_jp_locked"
	local dialogType = "respin_collect"
	local theData = {}
	local addCoins = self.data.core_data.respin_info[1].respin_win
	if self.data.reentry == 2 then
		addCoins = addCoins + self.data.core_data.respin_info[2].respin_win
		-- addCoins = self.data.core_data.respin_info[2].respin_win
	end
	theData.coins = addCoins
	self:setGrandExcitation(false)
	local pressFunc = function ( obj )
		local rollTime = 0.3
    	self._mainViewCtl.footer:setWinCoins(addCoins, self._mainViewCtl.totalWin - addCoins, rollTime)
	end
	theData.click_event = function ( ... )
		self._mainViewCtl:stopAllLoopMusic()
		self._mainViewCtl:playMusicByName("dialog_close")
       	pressFunc()
	   	self._mainViewCtl:laterCallBack(30/30, function()
		   	self:finishRespinBonusII()
	   	end)
	end
	self._mainViewCtl:playMusicByName("respin_dialog_collect")
	self.respinCollectDialog = self._mainViewCtl:showThemeDialog(theData, 3, csbName, dialogType)
end

return cls
