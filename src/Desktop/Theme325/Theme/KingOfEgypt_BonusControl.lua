-- @Author: 325wanghongjie 换皮 223xiongmeng
-- @Data 
-- @Last Modified by:   xiongmeng
-- @Last Modified time: 2020-12-03 10:30:25
-- 小老虎机的bonus

local wheelViewControl = require (bole.getDesktopFilePath("Theme/KingOfEgypt_WheelViewControl")) -- 添加选择界面
local chooseViewControl = require  (bole.getDesktopFilePath("Theme/KingOfEgypt_ChooseViewControl")) -- 添加选择界面
local wheelPickViewControl = require (bole.getDesktopFilePath("Theme/KingOfEgypt_WheelPickViewControl")) -- 添加选择界面
local jackpotDialogControl = require (bole.getDesktopFilePath("Theme/KingOfEgypt_JackpotDialogControl")) -- 弹窗界面

 
local bonusGame = class("KingOfEgypt_BonusControl") -- ThemeBaseBonusControl

-- 几种类型的bonus
function bonusGame:ctor(bonusControl, theme, csbPath, data, callback)
	self.bonusControl 	= bonusControl
	self.csbPath 		= csbPath
	self.callback 	    = callback
	self.oldCallBack 	= callback
	self.data           = data

	self.themeCtl = theme
	self.themeCtl.bonus = self 
	self.mainView = self.themeCtl.mainView
	self._mainViewCtl = theme
	self.gameConfig = self.themeCtl:getGameConfig()
end

function bonusGame:addData(key,value)
	self.data[key] = value
	self:saveBonus()
end
function bonusGame:saveBonus()
	LoginControl:getInstance():saveBonus(self.themeCtl.themeid, self.data)
end
function bonusGame:enterBonusStart( ... )
	self:lockJackpotValue()
	self.themeCtl:setFooterBtnsEnable(false)
    self.themeCtl:stopDrawAnimate()
    self.themeCtl:hideActivitysNode()
    self.bonusItem = self.themeCtl.item_list or self.data.core_data.item_list
end
function bonusGame:lockJackpotValue( ... )
    self.progressive_list = self.data.core_data["progressive_list"] or {0,0,0,0,0,0,0,0,0,0}
    self.themeCtl:lockJackpotMeters(true)
    self.themeCtl:lockJackpotValue(self.progressive_list)
end
function bonusGame:exitBonusStepI( ... )
	if self.bonusItem then
		self.themeCtl:resetBoardCellsByItemList(self.bonusItem)
	end
	self.themeCtl.bonus = nil

    self.themeCtl:lockJackpotMeters(false)
    self.themeCtl:setFooterBtnsEnable(true)
	self.themeCtl:showActivitysNode()
	
	self._mainViewCtl:laterCallBack(0.5, function ()
		self.themeCtl:finshSpin()
	end)
end
function bonusGame:enterBonusGame( tryResume )
	self.themeCtl:setFeatureState(self.gameConfig.FeatureName.Bonus, true)
	self:enterBonusStart()
	-- self.themeCtl:setSpinButtonState(true)
	self.themeCtl:saveBonusData(self.data.core_data)
	if tryResume then
		self.callback = function ( ... )
			if self.themeCtl:noFeatureLeft() then 
				self.themeCtl:setFooterBtnsEnable(true)
			end
			if self.oldCallBack then 
				self.oldCallBack()
			end
			self.themeCtl.isProcessing = false
		end
		self.themeCtl.isProcessing = true
	end
	local newCallBack = self.callback
	self.callback = function ( ... )
		self._mainViewCtl:laterCallBack(0.5, function ()
			newCallBack()
			self.themeCtl:setFeatureState(self.gameConfig.FeatureName.Bonus, false)
		end)
	end
		
    self:enterDiffcultBonus(tryResume)
end


---@desc bonus respin func ---------------------------------------------------------------------
function bonusGame:enterDiffcultBonus(tryResume)
	if self.data.core_data.map_pick then
		self:enterPickBonus(tryResume)
	elseif self.data.core_data.wheel_bonus then 
		self._mainViewCtl.isPickChooseRecover = nil
		self:enterWheelBonus(tryResume)
	elseif self.data.core_data.win_wheel then
		self.mainView:cleanScatterBgAni()
		self:enterWheelPickBonus(tryResume)
	elseif self.data.core_data.jackpot_bonus then
		self:enterJackpotBonus(tryResume)
	end
end
---------------------- wheel start----------------------
function bonusGame:enterWheelBonus(tryResume)
	-- 这个地方需要清掉
	self._mainViewCtl:dealMusic_StopNormalLoopMusic()
	self.wheelCtl = wheelViewControl.new(self, self.bonusControl, self.themeCtl, self.data)
	self.wheelCtl:enterBonusGame(tryResume) 
end
function bonusGame:enterWheelPickBonus(tryResume)
	self._mainViewCtl:dealMusic_StopNormalLoopMusic()
	self.wheelPickCtl = wheelPickViewControl.new(self, self.bonusControl, self.themeCtl, self.data)
	self.wheelPickCtl:enterBonusGame(tryResume) 
end
function bonusGame:submitLastBonusData(data)
	LoginControl:getInstance():saveBonus(self._mainViewCtl.themeid, nil)
	self.bonusTypeProgress = 1
	data = data or {}
	data.bonus_id = self.data.core_data.bonus_id
	if self._mainViewCtl.isPickChooseRecover then
		self._mainViewCtl.enterThemeDealList["open_old_bonus_game"] = {}
		self._mainViewCtl.enterThemeDealList["bonus_game"] = data
		self._mainViewCtl.enterThemeDealList["bonus_game"]["base_win"] = 0
		self:addFreeGameData(data)
	else
		self._mainViewCtl.rets["bonus_game"] = {}
		self._mainViewCtl.rets["bonus_game"] = data
		self._mainViewCtl.rets["free_game"]  = data["free_game"]
		if data["free_game"] then
			self._mainViewCtl.rets["free_spins"] = data["free_game"]["free_spin_total"]
			if self._mainViewCtl.freeCtl then 
				self._mainViewCtl.freeCtl.gameMasterFlag  = data["free_game"]["game_master_flag"]
			end
		end
	end

	local delayTime = 0 
	if self.wheelPickCtl then
		delayTime = self.wheelPickCtl:exitWheelPickBonus()
		self.wheelPickCtl = nil
	end
	self._mainViewCtl:laterCallBack(delayTime, function ()
		self.callback()
		self._mainViewCtl:hideActivitysNode()
	end)
end
function bonusGame:addFreeGameData(data)
	if data["free_game"] then
		if data["free_game"]["free_spin_total"] > 0 then
			self._mainViewCtl.enterThemeDealList["first_free_game"] = {}
			self._mainViewCtl.enterThemeDealList["first_free_game"]["free_spins"] = data["free_game"]["free_spin_total"]
			self._mainViewCtl.enterThemeDealList["first_free_game"]["free_spin_total"] = data["free_game"]["free_spin_total"]
			self._mainViewCtl.enterThemeDealList["first_free_game"]["total_win"] = data["free_game"]["total_win"]
			self._mainViewCtl.enterThemeDealList["first_free_game"]["bet"] = data["free_game"]["bet"]
			self._mainViewCtl.enterThemeDealList["first_free_game"]["item_list"] = data["free_game"]["item_list"]
			if self._mainViewCtl.freeCtl then 
				self._mainViewCtl.freeCtl.gameMasterFlag = data["free_game"]["game_master_flag"]
			end
			data["free_game"] = nil
		end
	end
end
function bonusGame:exitWheelBonus( totalWin )
	self.wheelCtl = nil
	totalWin = totalWin or 0
	local bonusEndFun = function ( ... )
		self:exitBonusStepI()
		self.reelVCtl = nil
		if self.callback then
			self.callback()
		end
	end
	self.themeCtl:startRollup(totalWin, bonusEndFun)
	if self.themeCtl:getNormalStatus() then
        self.themeCtl:dealMusic_PlayNormalLoopMusic()
    else
        self.themeCtl:dealMusic_PlayFreeSpinLoopMusic()
    end
end
function bonusGame:exitWheelFreeBonus()
	local bonusEndFun = function ( ... )
		self:exitBonusStepI()
		self.reelVCtl = nil
		if self.callback then
			self.callback()
		end
	end
	bonusEndFun()
	if self.themeCtl:getNormalStatus() then
        self.themeCtl:dealMusic_PlayNormalLoopMusic()
    else
        self.themeCtl:dealMusic_PlayFreeSpinLoopMusic()
    end
end
---------------------- wheel end  ----------------------

---------------------- jp start  --------------------
-- 关于中阴阳同时中的jp的弹窗
-- 1.在锁住的情况下，弹一次fg的收集弹窗，弹窗的总和是两个jp的总值
-- 2.在未锁住的情况下，先弹阳的弹窗，再弹阴的弹窗
function bonusGame:enterJackpotBonus(tryResume)
	self._mainViewCtl:dealMusic_StopNormalLoopMusic()
	self.jackpotDialogCtl = jackpotDialogControl.new(self, self.bonusControl, self.themeCtl, self.data)
	self.jackpotDialogCtl:enterBonusGame(tryResume) 
end

function bonusGame:exitJpBonus(totalWin)
	local bonusEndFun = function ( ... )
		self:exitBonusStepI()
		if self.callback then
			self.callback()
		end
	end
	if totalWin and totalWin > 0  then
		self._mainViewCtl.totalWin = self._mainViewCtl.totalWin - totalWin
		if not self._mainViewCtl:getNormalStatus() then
			self._mainViewCtl.freeCtl.freewin = self._mainViewCtl.freeCtl.freewin - totalWin
		end
		self.themeCtl:startRollup(totalWin, bonusEndFun)
	else
		bonusEndFun()
	end
	if self.themeCtl:getNormalStatus() then
        self.themeCtl:dealMusic_PlayNormalLoopMusic()
    else
        self.themeCtl:dealMusic_PlayFreeSpinLoopMusic()
    end
end


---------------------- jp end  ----------------------



---------------------- pick start----------------------
function bonusGame:enterPickBonus(tryResume)
	self._mainViewCtl:dealMusic_StopNormalLoopMusic()
	self.pickCtl = chooseViewControl.new(self, self.bonusControl, self.themeCtl, self.data)
	self.pickCtl:enterBonusGame(tryResume) 
end
function bonusGame:exitPickVBonus(totalWin, avgBet)
	totalWin = totalWin or 0
	local bonusEndFun = function ( ... )
		self:exitBonusStepI()
		self.reelVCtl = nil
		if self.callback then
			self.callback()
		end
	end
	self.themeCtl:startRollup(totalWin, bonusEndFun, avgBet)
	if self.themeCtl:getNormalStatus() then
        self.themeCtl:dealMusic_PlayNormalLoopMusic()
    else
        self.themeCtl:dealMusic_PlayFreeSpinLoopMusic()
    end
end
---------------------- pick end  ----------------------

function bonusGame:onExit( ... )
	if self.wheelCtl then 
		self.wheelCtl:onExit()
	end
    -- if self.coinBonus and self.coinBonus.onExit then 
    --     self.coinBonus:onExit()
    -- end
end


return bonusGame