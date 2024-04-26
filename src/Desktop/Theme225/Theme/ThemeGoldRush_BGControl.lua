
-- whj 2021.1.8. ThemeGoldRush 主题bonus 玩法

ThemeGoldRush_BGControl = class("ThemeGoldRush_BGControl") -- ThemeBaseBonusControl
local bonusGame = ThemeGoldRush_BGControl
require (bole.getDesktopFilePath("Theme/ThemeGoldRush_BGSlotControl")) 

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
	self.themeCtl:setFeatureState(self.gameConfig.FeatureName.Bonus, true)

	self.themeCtl:hideActivitysNode()

	self.themeCtl.footer:setSpinButtonState(true)-- 禁掉spin按钮
	
	self.themeCtl:saveBonusData(self.data.core_data)
	self.themeCtl:showBonusNode()
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

	self.themeCtl:stopDrawAnimate()
	self:enterMiniSlotBonus(tryResume)
end

function bonusGame:clearBonusData( showActiveNode )
    self:addData("end_game",true) 
    self.themeCtl:collectCoins(1)

    if showActiveNode then 
        self.themeCtl:showActivitysNode()
    end

    if self.callback then
        self.callback()
    end

    self.themeCtl:setFeatureState(self.gameConfig.FeatureName.Bonus, false)

    self.themeCtl.bonus = nil
end

function bonusGame:playOnReelStop( col, rets, notNeedAnim )
    -- if self.respinBonus then 
    --     self.respinBonus:playOnReelStop(col, rets, notNeedAnim)
    -- end
end

function bonusGame:saveRespinCnt(  ) -- 仅respin 会用到
	if self.slotBonus then 
		self.slotBonus:saveRespinCnt()
	end
end
function bonusGame:freshRespinTotalNum(  ) -- 仅respin 会用到
    -- if self.respinBonus then 
    --     self.respinBonus:freshRespinTotalNum()
    -- end
end

function bonusGame:onRespinStart( )
    if self.slotBonus then 
        self.slotBonus:onRespinStart()
    end
end

-- function bonusGame:onRespinStop( )
--     if self.slotBonus then 
--         self.slotBonus:onRespinStop()
--     end
-- end

function bonusGame:showWinCoins( ... )
    if self.slotBonus then 
        self.slotBonus:showWinCoins(...)
    end
end

function bonusGame:onRespinFinish( tryResume )
	if self.slotBonus then 
		self.slotBonus:onRespinFinish(tryResume)
	end
end

function bonusGame:stopLineAnimate(  )
	if self.slotBonus then 
		self.slotBonus:stopLineAnimate()
	end
end

---@desc mapSlotGame func ---------------------------------------------------------------------
function bonusGame:enterMiniSlotBonus( tryResume )
    self.slotBonus = ThemeGoldRush_BGSlotControl.new(self, self.bonusControl, self.themeCtl, self.data, tryResume)   
    self.slotBonus:enterBonusGame(tryResume)
end

function bonusGame:onExit( ... )
    if self.slotBonus and self.slotBonus.onExit then 
        self.slotBonus:onExit()
    end
end



return ThemeGoldRush_BGControl

