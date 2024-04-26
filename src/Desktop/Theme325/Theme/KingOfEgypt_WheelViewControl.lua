--[[
Author: xiongmeng
Date: 2020-12-11 14:30:36
LastEditors: xiongmeng
LastEditTime: 2021-01-11 18:04:22
Description: 
--]]
local _wheelView =  require  (bole.getDesktopFilePath("Theme/KingOfEgypt_WheelView")) 
local parentClass = ThemeBaseViewControlDelegate
local cls = class("KingOfEgypt_WheelViewControl", parentClass)

local result_status = nil
function cls:ctor(bonus, bonusControl, _mainViewCtl, data)
    parentClass.ctor(self, _mainViewCtl)
	self.bonus = bonus
	self.bonusControl = bonusControl
	self.data = data
	self.wheelData = self.data.core_data.wheel_bonus
    self.gameConfig = self:getGameConfig()
    self.saveDataKey   = "wheelBonus"
    self.progressive_list = self.data.core_data["progressive_list"] or {0,0,0,0,0,0,0,0,0,0}
    self.tryResume 		= self.bonus.data[self.saveDataKey] and true or false
    self.isFirstEnter = true
	self.gameData 		= tool.tableClone(self.bonus.data[self.saveDataKey]) or {}
	self.lastItemList  = self.data.core_data["item_list"] or self._mainViewCtl.item_list
    self.theme = self
	self.curScene = self._mainViewCtl:getCurScene()
	self:saveBonus()
end

function cls:addData(key,value)
	self.gameData[key] = value
	self:saveBonus()
end
function cls:saveBonus()
	self.bonus:addData(self.saveDataKey, self.gameData)
end

-- 当前choose的情况
function cls:updateWheelData(data)
    local wheelConfig = self:getWheelConfig()
    local wheelSuper  = wheelConfig.w_super
    result_status = wheelConfig.result_status

    self.data.finishWheel = self.data.finishWheel or false
    self.data.finishWheelMul = self.data.finishWheel or false
    -- self.data.finishWheel = false
    -- self.data.finishWheelMul = false
    
    self.wheelResultList = self.wheelData.result
    self.choiceIndex     = self.wheelData.choice
    self.wheelInfo       = wheelConfig.w_sun_info
    if self.choiceIndex == 1 then 
        self.wheelInfo = wheelConfig.w_moon_info
    end
    if self._mainViewCtl.freeCtl then 
        self._mainViewCtl.freeCtl.freeGameBgType = self.choiceIndex + 1
    end
    self.wheelLen = #self.wheelInfo
    self.wheelAdd = 360 / (self.wheelLen * 2) --这样才居中
    -- 倍数的转轮
    self.mulWheelInfo = wheelConfig.w_multi_info
    if self.wheelData.super_result then
        self.mulWheelIndex = self.wheelData.super_result
        self.mulWheelLen = #self.mulWheelInfo
        self.mulStopAngle = 360-((self.mulWheelIndex - 1) * 360 / self.mulWheelLen)
        self.mulResult = self.mulWheelInfo[self.mulWheelIndex]
    end

    self.data.wheelStep = self.data.wheelStep or 0 
    
    self.jpWinJp = self.wheelData.win_jp
    self.jpWinList = self.wheelData.jp_win_list
    self.totalWin = self.wheelData.total_win
    if self.jpWinList and self.jpWinList[1] then 
        self.totalWin = 0
        self.totalWin = self.totalWin + self.jpWinList[1]["jp_win"]
    end
    if self.data.wheelStep > 0 then
        self._mainViewCtl.totalWin = self._mainViewCtl.totalWin + self.totalWin
        self._mainViewCtl:updateFooterCoin()
    end
    
    -- payout
    self.totalWinPayOut = self.wheelData.total_win_payout or self.wheelData.total_win
    if self.jpWinList and self.jpWinList[1] then 
        self.totalWinPayOut = 0
        self.totalWinPayOut = self.totalWinPayOut + (self.jpWinList[1]["jp_win_payout"] or self.jpWinList[1]["jp_win"])
    end

end
function cls:getDoubleSpinTimes()
    if self.wheelResultList and #self.wheelResultList >= 2 then 
        return true
    end
    return false
end

function cls:addWheelCoins()
    self._mainViewCtl.totalWin = self._mainViewCtl.totalWin + self.totalWin
    local rollTime = 0.3
    self._mainViewCtl.footer:setWinCoins(self.totalWin, self._mainViewCtl.totalWin - self.totalWin, rollTime)
end

function cls:addBelowCoins()
    -- if self:getDoubleSpinTimes() then 
    --     self._mainViewCtl.totalWin = self._mainViewCtl.totalWin - self.totalWin
    -- end
end

function cls:getCurrentStatus(result_num)
    result_num = result_num or self.result
    if math.floor(result_num % 100) ~= 0 then
        local fg_count = math.floor(result_num % 100)
        return result_status.free_game, fg_count
    elseif math.floor(result_num % 1000) ~= 0 then
        local rapid_count = math.floor(math.floor(result_num % 10000)/1000)
        return result_status.rapid_super, rapid_count
    else
        local rapid_count = math.floor(math.floor(result_num % 10000)/1000)
        return result_status.rapid_game, rapid_count
    end
end

function cls:getHadMulWheel()
    return self.hadMulWheel
end
function cls:setRapidWheelStatus()
    if not self.bonus.data["finishWheel"] then 
        self.bonus.data["finishWheel"] = true
        self:saveBonus()
    end
end
function cls:setMulWheelStatus()
    if not self.bonus.data["finishWheelMul"] then 
        self.bonus.data["finishWheelMul"] = true
        self:saveBonus()
    end
end
-- function cls:setLastWheelStatus()
--     if not self.bonus.data["finishLastWheel"] then 
--         self.bonus.data["finishLastWheel"] = true
--         self:saveBonus()
--     end
-- end
function cls:enterBonusGame(tryResume)
    self:updateWheelData()
    self:initLayout(tryResume)
end
function cls:initLayout(  )
    self.wheelView = _wheelView.new(self, self.curScene)
    self.wheelView:enableWheelRoot(false)
    self:enterWheelBonusGame()

    self._mainViewCtl:setFooterEnable(false, {true, true})
    self._mainViewCtl:setHeaderEnable(false, {true, true})
end
function cls:enterWheelBonusGame()
    self.wheelView:enableWheelRoot(true)
    self.wheelView:initWheelNode()
    if self.tryResume and self.isFirstEnter then 
        self.isFirstEnter = nil
        if self.data.wheelStep > 0 then
            -- self.wheelView:_addWheelBgSpine("animation4", true)
        elseif self.bonus.data.finishWheel then 
            -- self.wheelView:_addWheelBgSpine("animation4", true)
        else 
            self.wheelView:_addWheelBgSpine("animation2", true)
        end
    end
    if not self.tryResume and self.isFirstEnter then 
        self.isFirstEnter = nil
        self.wheelView:wheelStartUp() -- 首次进入游戏
    else 
        self._mainViewCtl:dealMusic_EnterBonusGame()
        self:enterWheelByStep()
    end
end
-- 一步一步的操作
function cls:enterWheelByStep()
    local index = self.data.wheelStep
    local wheelConfig = self:getWheelConfig()
    local wheelSuper  = wheelConfig.w_super
    self.wheelIndex = nil
    if index == #self.wheelResultList then 
        self.wheelIndex = self.wheelResultList[index]
    else 
        self.wheelIndex = self.wheelResultList[index + 1]
    end
    self.hadMulWheel  = wheelSuper[self.wheelIndex] or nil
    self.result = self.wheelInfo[self.wheelIndex]
    self.stopAngle = 360-((self.wheelIndex) * 360 / self.wheelLen) + self.wheelAdd
    
    if not self.bonus.data.finishWheel then 
        self._mainViewCtl:playFadeToMaxVlomeMusic()
        self.wheelView:addSpineIdleAni()
        self.wheelView:hideWheelCoverNode()
        -- self.wheelView:setRapidWheelRo(0)
        self.wheelView:enableWheelbtnClick(true)

    elseif not self.bonus.data.finishWheelMul then 
        self.wheelView:enableWheelbtnClick(false)
        -- self.wheelView:setRapidWheelRo()
        self.wheelView:setWheelTurnPos()
        self.wheelView:spinMulWheel()
    else 
        --开始弹窗
        self.wheelView:enableWheelbtnClick(false)
        self.wheelView:setRapidWheelRo()
        if self.hadMulWheel then 
            self.wheelView:setWheelTurnPos()
            self.wheelView:setMulWheelRo()
            self.wheelView:playAwardAni(nil, nil, true)
        else 
            self.wheelView:setWheelMulHidePos()
            self.wheelView:playAwardAni(nil, nil, nil)
        end
        local currentStatus
        local count
        currentStatus, count = self:getCurrentStatus()
        if currentStatus == result_status.rapid_super then
            self.wheelView:playJpDialogCollect(count, true)
        elseif currentStatus == result_status.rapid_game then
            self.wheelView:playJpDialogCollect(count)
        elseif currentStatus == result_status.free_game then
            self._mainViewCtl:stopAllLoopMusic()
            self.wheelView:playFreeSpinDialog(count)
        end
    end
end

function cls:addStepData()
    self.data.wheelStep = self.data.wheelStep + 1
    self.data.finishWheel = false
    self.data.finishWheelMul = false
    self:saveBonus()
end

function cls:collectNotice()
    self.bonus.themeCtl:collectCoins(1)
    self.bonus.data["end_game"] = true
    self.bonus:saveBonus()
end
function cls:exitFgReelViewBonus( ... )
	local transitionDelay = self.gameConfig.transition_config.free
	local a1 = cc.DelayTime:create(1)
	local a2 = cc.CallFunc:create(function ( ... )
		self._mainViewCtl:playTransition(nil, "free")
	end)
	local a3 = cc.DelayTime:create(transitionDelay.onCover)
	local a4 = cc.CallFunc:create(function ( ... )
		self.wheelView:removeFromParent()
		self._mainViewCtl:changeSpinBoard("FreeSpin")
		self._mainViewCtl:resetBoardCellsByItemList(self.lastItemList)
	end)
    local a5 = cc.DelayTime:create(transitionDelay.onEnd - transitionDelay.onCover)
    local a51 = cc.CallFunc:create(function ()
        self._mainViewCtl:setFooterEnable(true)
        self._mainViewCtl:setHeaderEnable(true)
    end)
    local a52 = cc.DelayTime:create(0.5)
    local a6 = cc.CallFunc:create(function ( ... )
        self.bonus:exitWheelFreeBonus()
        -- self:addBelowCoins()
		-- self.bonus:exitWheelBonus(self.totalWin)
	end)
	local a7 = cc.Sequence:create(a1,a2,a3,a4,a5,a51,a52,a6)
	self.node:runAction(a7)
end
function cls:exitJpReelViewBonus()
    local transitionDelay = self.gameConfig.transition_config.free
	local a1 = cc.DelayTime:create(1)
    local a2 = cc.CallFunc:create(function ( ... )
		self._mainViewCtl:playTransition(nil, "free")
	end)
	local a3 = cc.DelayTime:create(transitionDelay.onCover)
	local a4 = cc.CallFunc:create(function ( ... )
		-- self:removeJpAwardAnimation()
		self.wheelView:removeFromParent()
		self._mainViewCtl:resetBoardCellsByItemList(self.lastItemList)
	end)
    local a5 = cc.DelayTime:create(transitionDelay.onEnd - transitionDelay.onCover)
    local a51 = cc.CallFunc:create(function ()
        self._mainViewCtl:setFooterEnable(true)
        self._mainViewCtl:setHeaderEnable(true)
    end)
    local a52 = cc.DelayTime:create(0.5)
    local a6 = cc.CallFunc:create(function ( ... )
        -- self:addBelowCoins()
        self.bonus:exitWheelBonus(self.totalWin)
	end)
	local a7 = cc.Sequence:create(a1,a2,a3,a4,a5,a51,a52,a6)
	self.node:runAction(a7)
end

function cls:getJpLockStatus()
    if self.jpWinJp and self.jpWinList and 
        #self.jpWinJp > 0 and #self.jpWinList > 0 then
            return false
    end
    return true
end

-- 一些展示动画，以及背景音效再哪里播放的找找
function cls:getWheelConfig()
    if not self.wheelConfig then 
        self.wheelConfig = self.gameConfig.wheel_config
    end
    return self.wheelConfig
end

function cls:getCsbPath( file_name )
    return self._mainViewCtl:getCsbPath(file_name)
end

function cls:copyFuncToKeyBoard( ... )
    self._mainViewCtl:copyFuncToKeyBoard(...)
end

function cls:onExit()
    if self.wheelView.miniWheel then
        if self.wheelView.miniWheel.scheduler then 
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.wheelView.miniWheel.scheduler)
			self.wheelView.miniWheel.scheduler = nil
		end
    end
    if self.wheelView.miniMulWheel then 
        if self.wheelView.miniMulWheel.scheduler then 
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.wheelView.miniMulWheel.scheduler)
			self.wheelView.miniMulWheel.scheduler = nil
		end
    end
    if self.wheelView.miniMulWheel then 
        if self.wheelView.miniMulWheel.scheduler then 
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.wheelView.miniMulWheel.scheduler)
			self.wheelView.miniMulWheel.scheduler = nil
		end
    end

    if self.wheelView.stopScreenShaker then
        self.wheelView:stopScreenShaker()
    end
end

return cls