--[[
Author: xiongmeng
Date: 2020-12-16 20:28:34
LastEditors: xiongmeng
LastEditTime: 2021-01-06 20:07:00
Description: 
--]]
local _wheelPickView = require  (bole.getDesktopFilePath("Theme/KingOfEgypt_WheelPickView"))
local parentClass = ThemeBaseViewControlDelegate
local cls = class("KingOfEgypt_WheelPickViewControl", parentClass)

local result_status = nil
function cls:ctor(bonus, bonusControl, _mainViewCtl, data)
	parentClass.ctor(self, _mainViewCtl)
	self.bonus = bonus
	self.bonusControl = bonusControl
	self.data = data
    self.gameConfig = self:getGameConfig()
	self.saveDataKey   = "wheelPick"
	self.tryResume 		= self.bonus.data[self.saveDataKey] and true or false
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

function cls:enterBonusGame(tryResume)
	self:initLayout()
	
	if tryResume then 
		self._mainViewCtl:setFooterEnable(false, {true, true})
		self._mainViewCtl:setHeaderEnable(false, {true, true})
	else
		self._mainViewCtl:setFooterEnable(false)
		self._mainViewCtl:setHeaderEnable(false)
	end
end
function cls:initLayout(  )
	if self.lastItemList then
		self.themeCtl:resetBoardCellsByItemList(self.lastItemList)
	end

    self.wheelPickView = _wheelPickView.new(self, self.curScene)
    self.wheelPickView:enableWheelPickRoot(false)
	self:enterWheelBonusGame()
end
function cls:enterWheelBonusGame()
    self.wheelPickView:enableWheelPickRoot(true)
end
function cls:enterWheelNextGame(index)
    self:collectNotice(index)
end
function cls:collectNotice(index)
    local special_data = {}
    special_data.choice = index
    self._mainViewCtl:collectCoins(2,special_data)
end
function cls:exitWheelPickBonus()
	self.wheelPickView:removeChooseNode()
	self.wheelPickView = nil
	return 15/30
end
function cls:getCsbPath( file_name )
    return self._mainViewCtl:getCsbPath(file_name)
end

return cls