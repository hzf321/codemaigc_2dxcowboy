--[[
Author: litianyang
Date: 2021-4-6 16:28:34
LastEditors: xiongmeng
LastEditTime: 2021-04-26 23:27:28
--]]
local fgPickView = require (bole.getDesktopFilePath("Theme/WestZoneFGPickView")) 
 
local parentClass = ThemeBaseViewControlDelegate
local cls = class("WestZoneFGPickViewControl", parentClass)

function cls:ctor(bonus, _mainViewCtl, data)
	parentClass.ctor(self, _mainViewCtl)
	self.bonus = bonus
	self.data = data
    self.theme = _mainViewCtl
	self.curScene = self._mainViewCtl:getCurScene()
end

function cls:enterBonusGame(tryResume)
	self.fgPickView = fgPickView.new(self, self.curScene, self.theme, self.data)
    self.fgPickView:enterFgPickBonus(tryResume)  
end

function cls:collectCoins(index)
    self._mainViewCtl:collectCoins(index)
end

function cls:exitfgPickBonus()
	local delayTime = 37/30
	if self.fgPickView and self.fgPickView.removeChooseNode then
		delayTime =self.fgPickView:removeChooseNode()
	end
	self.fgPickView = nil
	return delayTime
end

return cls
 