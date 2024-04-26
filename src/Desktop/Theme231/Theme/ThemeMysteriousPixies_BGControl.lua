
-- whj 2021.1.8. ThemeMysteriousPixies 主题bonus 玩法
ThemeMysteriousPixies_BGControl = class("ThemeMysteriousPixies_BGControl") -- ThemeBaseBonusControl
local bonusGame = ThemeMysteriousPixies_BGControl

local betFeatureBonus = require  (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_BGBetFeatureControl"))  
local mapPickBonus = require  (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_BGMapPickControl"))  
local freeWheelBonus = require  (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_BGWheelControl"))  

function bonusGame:ctor(bonusControl, theme, csbPath, data, callback)
	self.bonusControl 	= bonusControl
	self.csbPath 		= csbPath
	self.callback 	    = callback
	self.oldCallBack 	= callback
	self.data           = data

	self.themeCtl = theme
	self.themeCtl.bonus = self 
	self.gameConfig = self.themeCtl:getGameConfig()
end

function bonusGame:addData(key,value)
	self.data[key] = value
	self:saveBonus()
end
function bonusGame:saveBonus()
	LoginControl:getInstance():saveBonus(self.themeCtl.themeid, self.data)
end

function bonusGame:enterBonusGame( tryResume )

	self:initCheckList()
	self.themeCtl:setFeatureState(self.gameConfig.FeatureName.Bonus, true)

	-- self.bonusType = self.data.core_data.bonus_type
	self.isTryResume = tryResume
	self.themeCtl.footer:setSpinButtonState(true)-- 禁掉spin按钮
	
	self.themeCtl:saveBonusData(self.data.core_data)
	if tryResume then
		self.callback = function ( ... )
			-- 断线重连回调方法
			if self.themeCtl:noFeatureLeft() then 
				self.themeCtl.footer:setSpinButtonState(false)
			end
			if self.oldCallBack then 
				self.oldCallBack()
			end
			self.themeCtl:setDelayToFadeOutLoopMusic() -- 新增，静音音效
			
			self.themeCtl.isProcessing = false
		end
		self.themeCtl.isProcessing = true
	end

	self:checkIsOverBonus()
end

function bonusGame:initCheckList( )
	self.checkList = {
		bet_bonus = false,
		map_pick = false,
		fg_wheel = false,
	}

	if self.data.core_data.bet_bonus then 
		self.checkList.bet_bonus = true
	end
	if self.data.core_data.wheel_bonus then 
		self.checkList.fg_wheel = true
	end
	if self.data.core_data.map_pick then 
		self.checkList.map_pick = true
	end

	-- if self.data.core_data.bet_bonus and not self:isOverSingleBonus("bet_bonus") then 
	-- 	self.checkList.bet_bonus = true
	-- end
	-- if self.data.core_data.wheel_bonus and not self:isOverSingleBonus("fg_wheel") then 
	-- 	self.checkList.fg_wheel = true
	-- end

	-- if self.data.core_data.map_pick then
	-- 	if not self:isOverSingleBonus("map_pick") then 
	-- 		self.checkList.map_pick = true
	-- 	else

	-- 		self.collectData = {
	-- 			pos_list = self.data.pick_save_data and self.data.pick_save_data.pick_over_list
	-- 		}
	-- 	end
	-- end
end

function bonusGame:isOverSingleBonus( bType )
	local isOver = false
	if self.data.over_list and self.data.over_list[bType] then 
		isOver = true
	end

	return isOver
end

function bonusGame:setSingleBonusOver( bType )
	self.checkList[bType] = false

	self.data.over_list = self.data.over_list or {}
	self.data.over_list[bType] = true

	self:saveBonus()
end

function bonusGame:getCheckList( )
	return {
		{"bet_bonus", self.enterBetFeatureBonus},
		{"map_pick",  self.enterMapPickBonus},
		{"fg_wheel",  self.enterWheelBonus},
	}
end

function bonusGame:checkIsOverBonus(data)
	if data then 
		self.collectData = data
	end
	self.checkList = self.checkList or {}

	local process = self:getCheckList()
	for i = 1, #process do
		local aa = process[i]
		if self.checkList[aa[1]] and aa[2] then
			local isResume = self.isTryResume
			-- self.isTryResume = nil

			-- self.themeCtl:laterCallBack(1, function ( ... )
				aa[2](aa[3] or self, isResume)
			-- end)
			return
		end
	end

	self:clearBonusData()
end

function bonusGame:clearBonusData( )
    -- self:addData("end_game",true)

	if self.collectData then 
		self.themeCtl:collectCoins(1, self.collectData)
	    self.themeCtl:showActivitysNode()
	else
		self.themeCtl:collectCoins(1)
	end

    if self.callback then
        self.callback()
    end

    self.themeCtl:setFeatureState(self.gameConfig.FeatureName.Bonus, false)
    self.themeCtl.bonus = nil
end

---@desc bet_feature func ---------------------------------------------------------------------
function bonusGame:enterBetFeatureBonus(tryResume)

	self.betBonus = betFeatureBonus.new(self, self.data, tryResume)
	self.betBonus:enterBonusGame(tryResume)

end

---@desc map_pick func ---------------------------------------------------------------------
function bonusGame:enterMapPickBonus( tryResume )
	self.themeCtl:hideActivitysNode()

    self.pickBonus = mapPickBonus.new(self, self.data, tryResume)   
    self.pickBonus:enterBonusGame(tryResume)
end

---@desc map_pick func ---------------------------------------------------------------------
function bonusGame:enterWheelBonus( tryResume )
	self.themeCtl:hideActivitysNode()

    self.wheelBonus = freeWheelBonus.new(self, self.data, tryResume)   
    self.wheelBonus:enterBonusGame(tryResume)
end

function bonusGame:onExit( ... )
    if self.wheelBonus and self.wheelBonus.onExit then 
        self.wheelBonus:onExit()
    end
end


return ThemeMysteriousPixies_BGControl

