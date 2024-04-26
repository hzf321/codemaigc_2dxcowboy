-- -- @Author: xiongmeng
-- -- @Date:   2020-11-13 16:15:24
-- -- @Last Modified by:   xiongmeng
-- -- @Last Modified time: 2021-05-19 22:20:20
local bonusGame = class("MightyC_BonusControl")
function bonusGame:ctor(bonusControl, theme, csbPath, data, callback)
	self.bonusControl 	= bonusControl
	self.csbPath 		= csbPath
	self.callback 	    = callback
	self.oldCallBack 	= callback
	self.data           = data
	self.themeCtl = theme
	self.themeCtl.bonus = self 
	self.mainView = self.themeCtl.mainView
	self.gameConfig = self.themeCtl:getGameConfig()
	self._mainViewCtl = theme
end
function bonusGame:addData(key,value)
	self.data[key] = value
	self:saveBonus()
end
function bonusGame:saveBonus()
	LoginControl:getInstance():saveBonus(self.themeCtl.themeid, self.data)
end
function bonusGame:enterBonusStart( ... )
	-- self:lockJackpotValue()
	self.themeCtl:setFooterBtnsEnable(false)
    self.themeCtl:enableMapInfoBtn(false)
    self.themeCtl:stopDrawAnimate()
    self.themeCtl:hideActivitysNode()
    self.bonusItem = self.themeCtl.item_list or self.data.core_data.item_list
end
function bonusGame:lockJackpotValue( ... )
    self.progressive_list = self.data.core_data["progressive_list"] or {0,0,0,0,0}
    self.themeCtl:lockJackpotMeters(true)
    self.themeCtl:lockJackpotValue(self.progressive_list)
end

function bonusGame:exitBonusStep()
	self.themeCtl.bonus = nil
	self.themeCtl:finshSpin()
	self.themeCtl:setFooterBtnsEnable(true)
    self.themeCtl:enableMapInfoBtn(true)
	self.themeCtl:lockJackpotMeters(false)
    self.themeCtl:showActivitysNode()
end
function bonusGame:enterBonusGame( tryResume )
	self:enterBonusStart()
	
	-- self.themeCtl:setFeatureState(self.gameConfig.FeatureName.Bonus, true)
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
	self:lockJackpotValue()
    self:enterDiffcultBonus(tryResume)
end


---@desc bonus respin func ---------------------------------------------------------------------
function bonusGame:enterDiffcultBonus(tryResume)
	if self.data.core_data.theme_respin then
		self:enterRespinBonus(tryResume)
	end
end

---------------------- respin start----------------------
function bonusGame:enterRespinBonus(tryResume)
	self.themeCtl:dealMusic_StopNormalLoopMusic() -- 停掉背景音效
	self.themeCtl.cacheSpinRet = self.themeCtl.cacheSpinRet or self.themeCtl.rets
	self.themeCtl.footer.isRespinLayer = true
	self.themeCtl:resetCurrentReels(false, true)
	-- 进去bonus的时候，全部动画都删掉，重新创建新的动画，避免断线重连等情况
	self.themeCtl:getRespinViewCtl():setBonusInfo(self, tryResume)
	self.themeCtl:getRespinViewCtl():enterEpicBonus(tryResume)
end
function bonusGame:finishBonusGame(totalwin)
	self.themeCtl.footer.isRespinLayer = false
	self.themeCtl.rets["theme_respin"] = nil
	self.themeCtl:onRespinOver()
	
    local bonusOver = function()
        self.themeCtl:dealMusic_ExitBonusGame()
		self:exitBonusStep()
        if self.callback then
            self.callback()
        end
        if not self.themeCtl:noFeatureLeft() then
            self.themeCtl:enableMapInfoBtn(true)
            self.themeCtl:setFooterBtnsEnable(true)
        end
    end
    if self.themeCtl.freespin then
        if self.themeCtl.freespin < 1 then
            self.themeCtl.spin_processing = true
        end
    end
    self.themeCtl:startRollup(totalwin, bonusOver)
    self.themeCtl:getRespinViewCtl():clearBonusInfo()
end
---------------------- respin end  ----------------------

function bonusGame:onExit( ... )
    
end


return bonusGame