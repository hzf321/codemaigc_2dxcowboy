--[[
Author: xiongmeng
Date: 2020-12-11 14:32:44
LastEditors: xiongmeng
LastEditTime: 2021-01-07 18:46:50
Description: 
--]]
local chooseView = require  (bole.getDesktopFilePath("Theme/KingOfEgypt_ChooseView")) 
local parentClass = ThemeBaseViewControlDelegate
local cls = class("KingOfEgypt_ChooseViewControl", parentClass)

function cls:ctor(bonus, bonusControl, _mainViewCtl, data)
	parentClass.ctor(self, _mainViewCtl)
	self.bonus = bonus
	self.bonusControl = bonusControl
	self.data = data
	self.pickData = self.data.core_data.map_pick
    self.gameConfig = self:getGameConfig()
	self.saveDataKey   = "chooseBonus"
	self.tryResume 		= self.bonus.data[self.saveDataKey] and true or false
	self.gameData 		= tool.tableClone(self.bonus.data[self.saveDataKey]) or {}
	self.lastItemList  = self.data.core_data["item_list"] or self._mainViewCtl.item_list
    self.theme = self
    -- self.avgBet = self.pickData.avg_bet

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
function cls:updateWheelData()
    self.mapLevel = self._mainViewCtl.mapLevel or 1
    self.avgBet = self.pickData.avg_bet
    self.pickResult = self.pickData.result
    self.pickLeftResult = self.pickData.rest_list
    self.pickTotalWin = self.pickData.total_win or 0
    self.allTotalWin = self.data.core_data.total_win or 0
    self.bonus.data["btn_click"] = self.bonus.data["btn_click"] or nil
end
function cls:enterBonusGame(tryResume)
    self:updateWheelData()
    self:initLayout()
end

function cls:initLayout(  )
    self.chooseView = chooseView.new(self, self.curScene)
    self.chooseView:enableChooseRoot(false)
    if not self.tryResume then
        local transitionDelay = self.gameConfig.transition_config.wheel
		local a0 = cc.DelayTime:create(0)
		local a1 = cc.CallFunc:create(function ( ... )
            self._mainViewCtl:playTransition(nil, "wheel")

            self._mainViewCtl:setFooterEnable(false)
            self._mainViewCtl:setHeaderEnable(false)
        end)
		local a2 = cc.DelayTime:create(transitionDelay.onCover)
        local a3 = cc.CallFunc:create(function ( ... )
            self.chooseView:enableChooseRoot(true)
		end)
        local a4 = cc.DelayTime:create(transitionDelay.onEnd - transitionDelay.onCover)
		local a5 = cc.CallFunc:create(function ( ... )
            self._mainViewCtl:dealMusic_MapFreeBonusGame()

		end)
		local a6 = cc.Sequence:create(a0,a1,a2,a3,a4,a5)
        self.node:runAction(a6)
    elseif not self:getCanNotTouchClick() then
        self._mainViewCtl:dealMusic_MapFreeBonusGame()
        self.chooseView:enableChooseRoot(true)
        
        self._mainViewCtl:setFooterEnable(false, {true, true})
        self._mainViewCtl:setHeaderEnable(false, {true, true})
    else
        self._mainViewCtl:setFooterEnable(false, {true, true})
        self._mainViewCtl:setHeaderEnable(false, {true, true})

        self.chooseView:enableChooseRoot(true)
        self.chooseView:recoverPickResult()
    end
end

function cls:setBtnClickData(index)
    if not self.bonus.data["btn_click"] then
        index = index or 1
        self.bonus.data["btn_click"] = index
        self:saveBonus()
    end
end
function cls:collectNotice()
    self.bonus.themeCtl:collectCoins(1)
    self.bonus.data["end_game"] = true
    self.bonus:saveBonus()
end
function cls:updateCollectData()
    self._mainViewCtl.mapPoints = 0
	self._mainViewCtl:showCurrentCollectShow()
end
function cls:exitChooseViewBonus( ... )
	local transitionDelay = self.gameConfig.transition_config.wheel
	local a1 = cc.DelayTime:create(1)
	local a2 = cc.CallFunc:create(function ( ... )
        self._mainViewCtl:playTransition(nil, "wheel")
        
        -- self._mainViewCtl:setFooterEnable(false)
        -- self._mainViewCtl:setHeaderEnable(false)
	end)
	local a3 = cc.DelayTime:create(transitionDelay.onCover)
	local a4 = cc.CallFunc:create(function ( ... )
		self.chooseView:removeFromParent()
		self._mainViewCtl:resetBoardCellsByItemList(self.lastItemList)
	end)
    local a5 = cc.DelayTime:create(transitionDelay.onEnd - transitionDelay.onCover)
    local a51 = cc.CallFunc:create(function ()
        self._mainViewCtl:setFooterEnable(true)
        self._mainViewCtl:setHeaderEnable(true)
    end)
    local a52 = cc.DelayTime:create(0.5)
    local a6 = cc.CallFunc:create(function ( ... )
        self:showMapFeature()

		-- self.bonus:exitPickVBonus(self.pickTotalWin, self.avgBet)
	end)
	local a7 = cc.Sequence:create(a1,a2,a3,a4,a5,a51,a52,a6)
	self.node:runAction(a7)
end

function cls:showMapFeature()
    local a2 = cc.CallFunc:create(function ( ... )
        self._mainViewCtl:getMapViewCtl():showMapScene(nil, nil, true)
    end)
    local a3 = cc.DelayTime:create(3)
    local a4 = cc.CallFunc:create(function ( ... )
        self._mainViewCtl:getMapViewCtl():exitMapScene(true, true)
    end)
    local a41 = cc.DelayTime:create(1)
    local a42 = cc.CallFunc:create(function ( ... )
        self.bonus:exitPickVBonus(self.pickTotalWin, self.avgBet)
    end)
    local a5 = cc.Sequence:create(a2,a3,a4,a41,a42)
    libUI.runAction(self.node, a5)
end

function cls:getCanNotTouchClick()
    return self.bonus.data["btn_click"]
end
function cls:getLevelImage()
    local level = self.mapLevel
    local step = 1
    local imageIndex = 1
    local map_booster_config = self.gameConfig.map_config.map_booster_config
    for key, val in ipairs(map_booster_config) do
        if level <= val then 
            step = key
            break
        end
    end 
    imageIndex = (step - 1) % 3 + 1
    return imageIndex
end
function cls:getSpecailResult(result)
    result = result or 1
    if result == 2 then
        return self:getStickNums()
    elseif result == 8 then
        return self:getAllWinsMul()
    end
    return false
end
function cls:getBoosterStatus()
    return self.pickResult == 100
end
function cls:isBoosterStatus(pickResult)
    if not pickResult then 
        return false
    end
    return pickResult == 100
end
function cls:getBoosterType()
    -- 
end
function cls:getStickNums()
    return self._mainViewCtl.mapViewCtl:getStickNums()
end
function cls:getAllWinsMul()
    return self._mainViewCtl.mapViewCtl:getAllWinsMul()
end

function cls:getPickInfo()
    if not self.pickInfo then
        self.pickInfo = self.gameConfig.map_pick_config
    end
    return self.pickInfo
end
function cls:getPickLevelConfig()
    local level = self.mapLevel
    if not self.pickLevelConfig then
        local map_booster_config = self.gameConfig.map_config.map_booster_config
        local map_building_config = self.gameConfig.map_config.map_building_config
        local lastIndex = 0
        for key, val in ipairs(map_booster_config) do
            if level <= val then
                local pickLevelConfig = map_building_config[val]
                self.pickLevelConfig = pickLevelConfig[level - lastIndex]
                break
            end
            lastIndex = val
        end
    end
    return self.pickLevelConfig
end

function cls:getSymbolLabel(num)
    local currentBet = self.avgBet
    num = num or 0
    return currentBet * num
end
function cls:getCsbPath( file_name )
    return self._mainViewCtl:getCsbPath(file_name)
end
function cls:getFntFilePath( file_name )
    return self._mainViewCtl:getFntFilePath(file_name)
end
function cls:playFadeToMinVlomeMusic( ... )
	self._mainViewCtl:playFadeToMinVlomeMusic()
end
function cls:playFadeToMaxVlomeMusic( ... )
	self._mainViewCtl:playFadeToMaxVlomeMusic()
end

return cls