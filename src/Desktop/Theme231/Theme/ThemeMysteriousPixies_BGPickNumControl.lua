
local ThemeMysteriousPixies_BGPickNumControl = class("ThemeMysteriousPixies_BGPickNumControl")
local cls = ThemeMysteriousPixies_BGPickNumControl

local pickNumView = require (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_BGPickNumView")) 

function cls:ctor(bonusParent, data, tryResume)

	self.bonusParent 	= bonusParent
	self.bonusControl 	= bonusParent.bonusControl
	self.themeCtl 		= bonusParent.themeCtl
	self.data          	= data
	self.isTryResume 	= tryResume

	self.jackpotVCtl = self.themeCtl:getJpViewCtl()
	self.audioCtl = self.themeCtl:getAudioCtl()
	self.gameConfig = self:getGameConfig()
	self.config = self.gameConfig.pick_config

	self.node = cc.Node:create()
    self:curSceneAddToContent(self.node)
	self:initData()

	self:initGameLayout()
end

function cls:initGameLayout( )
	local nodesList = self.themeCtl:getSpecialFeatureRoot("bet_bonus")
	self._view = pickNumView.new(self, nodesList)
end

function cls:initData()
	self.curSaveData = self.data.num_save_data or {}

	self.curBonusData 	= self.data.core_data.map_pick
    self.pickNum 		= self.curBonusData.pick_num -- pick 次数
    self.numList 		= self.curBonusData.num_list -- pick 次数其他结果

end

function cls:addData(key, value)
	self.curSaveData = self.curSaveData or {}
	self.curSaveData[key] = value

	self.bonusParent:saveBonus("num_save_data", self.curSaveData)
end

function cls:enterBonusGame(tryResume)
	if tryResume then 
		self.themeCtl:dealMusic_PlayNormalLoopMusic()
	end
	self.themeCtl:dealMusic_FadeLoopMusic(0.2, 1, 0.3)
	-- if not self.curSaveData.over_num_start then -- 展示 pick_num 开始弹窗
	-- 	self:showStartNumPickDialog()
	-- else
	if not self.curSaveData.over_num_pick_show then -- 直接展示pick界面
		self:showNumPickNode()
	elseif not self.curSaveData.over_pick then -- 打开点击事件
		self:showNumPickNode(true)
		self:openPickBtnEvent()
	else -- 直接展示pick结果界面
		self:showNumPickNode(true)
		self:showPickResult()
	end
end

-- function cls:showStartNumPickDialog()	

-- 	local data = {}
-- 	data.file = self:getSpineFile("dialog_pick_num")
-- 	data.parent = self.node
-- 	data.animateName = "animation2"
-- 	bole.addAnimationSimple(data)

--     self:playMusicByName("bonus_start_show")

-- 	self.node:runAction(cc.Sequence:create(
-- 		cc.DelayTime:create(159/30),
-- 		cc.CallFunc:create(function ( ... )
-- 			self:showNumPickNode()
-- 		end)))

-- 	self:addData("over_num_start", true)
	
-- end

function cls:showNumPickNode( ... )
	self:addData("over_num_pick_show", true)

	self._view:showNumPickNode(...)
end

function cls:openPickBtnEvent( ... )
	self._view:openPickBtnEvent()
end

function cls:setPickResultPos( index )
	self:addData("over_pick", true)

	self:addData("num_result", index)
end

function cls:getPickResult( ... )
	return self.pickNum
end

function cls:showPickResult( ... )
	self._view:showPickResult(self.curSaveData.num_result or 1)
end

function cls:getOtherResult( ... )
	local overPos = self.curSaveData.num_result or 1
	local otherValue = tool.tableClone(self.numList) or {}

	return otherValue, overPos
end

function cls:isOverPickGame( ... )
	self:addData("over_num_bonus", true)

	self.bonusParent:isOverNumPickGame()
end

----------------------------------------------------------------------------------------------------------------------------------
function cls:getCsbPath(file_name)
    return self.themeCtl:getCsbPath(file_name)
end

function cls:getGameConfig( )
	return self.themeCtl:getGameConfig()
end

function cls:playMusicByName(name, singleton, loop)
	self.themeCtl:playMusicByName(name, singleton, loop)
end

function cls:getSpineFile(file_name, notPathSpine)
    return self.themeCtl:getSpineFile(file_name, notPathSpine)
end

function cls:curSceneAddToContent( node )
    self.themeCtl:curSceneAddToContent(node)
end

return cls

