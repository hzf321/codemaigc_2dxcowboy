local BSGame = class("WestZoneBonusControl")
local fgPickCtl = require (bole.getDesktopFilePath("Theme/WestZoneFGPickViewControl"))
local respinControl = require (bole.getDesktopFilePath("Theme/WestZoneRespinControl")) 
function BSGame:ctor(bonusControl, theme, csbPath, data, callback)
	self.bonusControl 	= bonusControl
	self.theme 			= theme
	self.csbPath 		= csbPath
	self.callback 	    = callback
	self.endCallBack    = callback
	self.data           = data
	self.theme.bonus 	= self
	self.ctl 			= bonusControl.themeCtl
end

function BSGame:enterBonusGame( tryResume )
	self.data["bonus_id"] = self.data.core_data.bonus_id
	self.theme.old_item_list = self.data.core_data.item_list or self.theme.item_list
	self:enterBonusGameStepI()
 	if tryResume then
 		self.callback = function ( ... )
 			local endCallFunc2 = function ( ... )
 				if self.endCallBack then
 					self.endCallBack()
 				end
 				if self.ctl:noFeatureLeft() then
	        		self.theme:enableAllFooterBtns(false)
	        	end
	        	self.ctl.isProcessing = false
 			end
 			endCallFunc2()
 		end
 		self.ctl.isProcessing = true
 	end
 	self:enterDiffcultBonus(tryResume)
end

function BSGame:enterDiffcultBonus( tryResume )
	local choice = self.data.core_data.choice
	if choice == 0 then
		if tryResume then
			self.theme:resetBoardCellsByItemList(self.theme.old_item_list)
		end
		self:enterFreeGameBonus()
	else
		self.respinCtl = respinControl.new(self.theme, self, self.data, self.ctl)
		self.theme.respinCtl = self.respinCtl
		-- if tryResume then
			self.theme:resetPointBet()
			self.theme:resetBoardCellsByItemList(self.theme.old_item_list)
		-- end
		self.respinCtl:openRespinBonus(tryResume)
	end
end

function BSGame:enterFreeGameBonus( tryResume)
	self.fgPickCtl = fgPickCtl.new(self, self.theme, self.data)
	self.fgPickCtl:enterBonusGame(tryResume)
	-- self.theme:dealMusic_StopNormalLoopMusic()
	self.theme:stopAllLoopMusic()
end

function BSGame:saveBonus()
	if not self.data["bonus_id"] and (self.data.core_data and self.data.core_data.bonus_id) then
		self.data["bonus_id"] = self.data.core_data.bonus_id
	end
	LoginControl:getInstance():saveBonus(self.theme.themeid, self.data)
end

function BSGame:submitLastBonusData(data)
	LoginControl:getInstance():saveBonus(self.theme.themeid, nil)
	data = data or {}
	data.bonus_id = self.data.core_data.bonus_id
	if self.theme.isPickChooseRecover then
		self:addFreeGameData(data)
	else
		self.theme.rets["free_game"]  = data
		self.theme.rets["free_spins"] = data["free_spin_total"]
	end
	local delayTime = 0
	if self.fgPickCtl then
		delayTime = self.fgPickCtl:exitfgPickBonus()
		self.fgPickCtl = nil
	end
	self.theme:laterCallBack(delayTime, function()
		self.theme.bonus = nil
		self.theme:lockJackpotMeters(false)
		self.callback() 
		self.theme:hideActivitysNode()
	end)
end

function BSGame:addFreeGameData(data)        
	-- self.theme.freeCtl.freeType = data["fg_type"]
	if data["free_spin_total"] > 0 then
		self.theme.enterThemeDealList["first_free_game"] = {}
		self.theme.enterThemeDealList["first_free_game"]["free_spins"] =  data["free_spin_total"]
		self.theme.enterThemeDealList["first_free_game"]["free_spin_total"] =  data["free_spin_total"]
		self.theme.enterThemeDealList["first_free_game"]["total_win"] =   data["win_box"] 
		self.theme.enterThemeDealList["first_free_game"]["bet"] =  data["bet"]
		self.theme.enterThemeDealList["first_free_game"]["item_list"] = data["item_list"]
		data = nil
	end
	self.theme.isPickChooseRecover = nil
end

function BSGame:enterBonusGameStepI( ... )
	self.theme:stopDrawAnimate()
	self.theme:saveBonusData()
	self.theme:enableAllFooterBtns(true)
    self.theme:enableMapInfoBtn(false)
    self.theme:hideActivitysNode()
end

function BSGame:exitBonusStepI( ... )
	self.data.grandWin = nil
	self.data.currentRespinTimes = nil
	self.data.hadUsedTimes = nil
	self.data.reentry = nil
	self.data.respinTotalWin = nil
	self.fgBonus = nil
	self.theme.bonus = nil
	self.respinCtl = nil
	self.theme.respinCtl = nil
	self.theme:lockJackpotMeters(false)
	self.theme:showActivitysNode()
	self.theme:finishSpin()
end

function BSGame:onExit( )

end

return BSGame