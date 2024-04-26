-- themeid: 164
-- author sj
-- date 10/31/2019

ThemeFireFortune = class("ThemeFireFortune", Theme)
local cls = ThemeFireFortune

cls.plistAnimate = 
{
	"image/plist/symbol",
}

cls.csbList = 
{
	"csb/base.csb",
}

local SpinBoardType = {
	Normal = 1,
	FreeSpin_normal = 2,
	FreeSpin_map_35 = 3,
	FreeSpin_map_36 = 4,
	FreeSpin_map_46 = 5,
	FreeSpin_map_45 = 6,
}

-- local Jsize = {
-- 	width = 180,
-- 	height = 180
-- }

-- local coinsMul = 
-- {
-- 	[21] = 0.5, [22] = 1, [23] = 2, [24] = 3, [25] = 4, [26] = 5, [27] = 6, [28] = 7, [29] = 8, [30] = 9, [31] = 10, [32] = 15, [33] = 20,
-- 	[34] = 25, [35] = 50, [36] = 75, [37] = 100
-- }

local BonusType = 
{
   MapWheel = 1,
   MapFreeGame = 2,  
}

local ReelType = 
{
	reel_36_normal = 1,
	reel_35 = 2,
	reel_36 = 3,
	reel_46 = 4,
	reel_45 = 5
}

local transitionDelay = {
	["free"] 	= {["onCover"] = 15/30,["onEnd"] = 32/30},
	["bonus"] 	= {["onCover"] = 20/30,["onEnd"] = 61/30},
}
------------------------------region initialization------------------------------
function cls:ctor(themeid)
  	self.spinActionConfig = {
		start_index = 10,
		spin_index = 1,
		stop_index = 1,
		fast_stop_index = 1,
		special_index =1,
	}

	self:miscellaneousInit()

	self.ThemeConfig = {
		theme_symbol_coinfig = {
			symbol_zorder_list = {
				[1] = 20, [21] = 20, [22] = 20, [23] = 20, [24] = 20, [25] = 20, [26] = 20, [27] = 20, [28] = 20, [29] = 20,
				[11] = 15, [12] = 16,
				[2] = 3, [3] = 3, [4] = 3, [5] = 2, [6] = 2, [7] = 2, [8] = 1, [9] = 1, [10] = 1,
				[0] = 0
			},
			normal_symbol_list = {
				1, 2, 3, 4, 5, 6, 7, 8, 9, 10
			},
			special_symbol_list = {
				11, 12
			},
			no_roll_symbol_list = {
				11, 12, 0, 21, 22, 23, 24, 25, 26, 27, 28, 29
			},
			special_symbol_config = {
				[self.eSymbol.scatter1:toint()] = {
					type = self.eSymbolNotify.columnSum,
					symbol = self.eSymbol.scatter2:toint(),
					minColumnCount = 3, 
					columnSatisfy = function(colItemList, colIndex, symbolKey)
						local satisfyNum = #colItemList
						local count = 0
						for row = 1, #colItemList do
							if colItemList[row] == symbolKey then
								count = count + 1
							end
						end
						local count2 = 0
						if self.boardType == self.eBoard.respin and colIndex <= 5 then
							for row = 1, #colItemList do
								if colItemList[row] == self.eSymbol.scatter1:toint() then
									count2 = count2 + 1
								end
							end
						end

						if count >= satisfyNum or count2 >= satisfyNum then
							return true
						else
							return false
						end
					end,
					checkColumnNotify = function(colItemList, colIndex, symbolKey)
						local ans = {}
						for row = 1, #colItemList do
							if colItemList[row] == symbolKey then
								table.insert(ans, { colIndex, row })
							end
						end
						if #ans > 0 then
							return ans
						else
							return nil
						end
					end
				}
			},
		},
		theme_type = "payLine",
		theme_type_config = {
			pay_lines = {
				{0, 0, 0, 0, 0}, {3, 3, 3, 3, 3}, {1, 1, 1, 1, 1}, {2, 2, 2, 2, 2}, {0, 1, 2, 1, 0}, --5
				{3, 2, 1, 2, 3}, {2, 1, 0, 1, 2}, {1, 2, 3, 2, 1}, {0, 1, 0, 1, 0}, {3, 2, 3, 2, 3}, --10
				{1, 0, 1, 0, 1}, {2, 3, 2, 3, 2}, {1, 2, 1, 2, 1}, {2, 1, 2, 1, 2}, {0, 1, 1, 1, 0}, --15
				{3, 2, 2, 2, 3}, {1, 0, 0, 0, 1}, {2, 3, 3, 3, 2}, {1, 2, 2, 2, 1}, {2, 1, 1, 1, 2}, --20
				{0, 0, 1, 0, 0}, {3, 3, 2, 3, 3}, {1, 1, 0, 1, 1}, {2, 2, 3, 2, 2}, {1, 1, 2, 1, 1}, --25
				{2, 2, 1, 2, 2}, {0, 0, 2, 0, 0}, {3, 3, 1, 3, 3}, {2, 2, 0, 2, 2}, {1, 1, 3, 1, 1}, --30
				{0, 2, 2, 2, 0}, {3, 1, 1, 1, 3}, {2, 0, 0, 0, 2}, {1, 3, 3, 3, 1}, {1, 0, 2, 0, 1}, --35
				{2, 3, 1, 3, 2}, {1, 2, 0, 2, 1}, {2, 1, 3, 1, 2}, {0, 2, 0, 2, 0}, {3, 1, 3, 1, 3}, --40
				{2, 0, 2, 0, 2}, {1, 3, 1, 3, 1}, {0, 2, 1, 2, 0}, {3, 1, 2, 1, 3}, {2, 0, 1, 0, 2}, --45
				{1, 3, 2, 3, 1}, {0, 3, 0, 3, 0}, {3, 0, 3, 0, 3}, {0, 0, 3, 0, 0}, {3, 3, 0, 3, 3}, --50
			},
			line_cnt = 50,
		},
		theme_round_light_index = 1,
		boardConfig = {
			{
				allow_over_range = true,
				reelConfig = {
					{ base_pos = cc.p(229, 108), cellWidth = self.const.cellWidth[1], cellHeight = self.const.cellHeight[1], symbolCount = self.const.symbolCount[1] },
					{ base_pos = cc.p(395, 108), cellWidth = self.const.cellWidth[1], cellHeight = self.const.cellHeight[1], symbolCount = self.const.symbolCount[1] },
					{ base_pos = cc.p(560, 108), cellWidth = self.const.cellWidth[1], cellHeight = self.const.cellHeight[1], symbolCount = self.const.symbolCount[1] },
					{ base_pos = cc.p(725, 108), cellWidth = self.const.cellWidth[1], cellHeight = self.const.cellHeight[1], symbolCount = self.const.symbolCount[1] },
					{ base_pos = cc.p(890, 108), cellWidth = self.const.cellWidth[1], cellHeight = self.const.cellHeight[1], symbolCount = self.const.symbolCount[1] }
				}
			},
			{-- placeholder, abandoned
				allow_over_range = true,
				reelConfig = {
					{ base_pos = cc.p(226, 108), cellWidth = self.const.cellWidth[2], cellHeight = self.const.cellHeight[2], symbolCount = self.const.symbolCount[2] },
					{ base_pos = cc.p(392, 108), cellWidth = self.const.cellWidth[2], cellHeight = self.const.cellHeight[2], symbolCount = self.const.symbolCount[2] },
					{ base_pos = cc.p(559, 108), cellWidth = self.const.cellWidth[2], cellHeight = self.const.cellHeight[2], symbolCount = self.const.symbolCount[2] },
					{ base_pos = cc.p(724, 108), cellWidth = self.const.cellWidth[2], cellHeight = self.const.cellHeight[2], symbolCount = self.const.symbolCount[2] },
					{ base_pos = cc.p(888, 108), cellWidth = self.const.cellWidth[2], cellHeight = self.const.cellHeight[2], symbolCount = self.const.symbolCount[2] }
				}
			},
			{
				allow_over_range = true,
				reelConfig = {
					{ base_pos = cc.p(145, 108), cellWidth = self.const.cellWidth[3], cellHeight = self.const.cellHeight[3], symbolCount = self.const.symbolCount[3] },
					{ base_pos = cc.p(310, 108), cellWidth = self.const.cellWidth[3], cellHeight = self.const.cellHeight[3], symbolCount = self.const.symbolCount[3] },
					{ base_pos = cc.p(476, 108), cellWidth = self.const.cellWidth[3], cellHeight = self.const.cellHeight[3], symbolCount = self.const.symbolCount[3] },
					{ base_pos = cc.p(642, 108), cellWidth = self.const.cellWidth[3], cellHeight = self.const.cellHeight[3], symbolCount = self.const.symbolCount[3] },
					{ base_pos = cc.p(807, 108), cellWidth = self.const.cellWidth[3], cellHeight = self.const.cellHeight[3], symbolCount = self.const.symbolCount[3] },
					{ base_pos = cc.p(972, 108), cellWidth = self.const.cellWidth[3], cellHeight = self.const.cellHeight[3], symbolCount = self.const.symbolCount[3] }
				}
			},
			{
				allow_over_range = true,
				reelConfig = {
					{ base_pos = cc.p(261, 112), cellWidth = self.const.cellWidth[4], cellHeight = self.const.cellHeight[4], symbolCount = self.const.symbolCount[4] },
					{ base_pos = cc.p(427, 112), cellWidth = self.const.cellWidth[4], cellHeight = self.const.cellHeight[4], symbolCount = self.const.symbolCount[4] },
					{ base_pos = cc.p(593, 112), cellWidth = self.const.cellWidth[4], cellHeight = self.const.cellHeight[4], symbolCount = self.const.symbolCount[4] },
					{ base_pos = cc.p(759, 112), cellWidth = self.const.cellWidth[4], cellHeight = self.const.cellHeight[4], symbolCount = self.const.symbolCount[4] },
					{ base_pos = cc.p(924, 112), cellWidth = self.const.cellWidth[4], cellHeight = self.const.cellHeight[4], symbolCount = self.const.symbolCount[4] }
				}
			},
			{
				allow_over_range = true,
				reelConfig = {
					{ base_pos = cc.p(179, 112), cellWidth = self.const.cellWidth[5], cellHeight = self.const.cellHeight[5], symbolCount = self.const.symbolCount[5] },
					{ base_pos = cc.p(344, 112), cellWidth = self.const.cellWidth[5], cellHeight = self.const.cellHeight[5], symbolCount = self.const.symbolCount[5] },
					{ base_pos = cc.p(511, 112), cellWidth = self.const.cellWidth[5], cellHeight = self.const.cellHeight[5], symbolCount = self.const.symbolCount[5] },
					{ base_pos = cc.p(676, 112), cellWidth = self.const.cellWidth[5], cellHeight = self.const.cellHeight[5], symbolCount = self.const.symbolCount[5] },
					{ base_pos = cc.p(841, 112), cellWidth = self.const.cellWidth[5], cellHeight = self.const.cellHeight[5], symbolCount = self.const.symbolCount[5] },
					{ base_pos = cc.p(1006, 112), cellWidth = self.const.cellWidth[5], cellHeight = self.const.cellHeight[5], symbolCount = self.const.symbolCount[5] }
				}
			},
		}
	}

	self.anticipationSpine = {}
	self.respinAnticipationSpine = nil
	self.anticipationMusic = nil

	self.baseBet = 10000
	self.DelayStopTime = 0
	self.UnderPressure = 1

	-- maximum nudge number
	self.addTop = 4
	self.addBelow = 4

	return Theme.ctor(self, themeid, false)
end

function cls:miscellaneousInit()
	local symbolName = {
		[0] = "blank", "wild", "m1", "m2", "m3", "m4", "m5", "m6", "l1", "l2", "l3", "scatter1", "scatter2",
		[21] = "wild4_1", [22] = "wild4_2", [23] = "wild4_3", [24] = "wild4_4", [25] = "wild5_1", [26] = "wild5_2", [27] = "wild5_3", [28] = "wild5_4", [29] = "wild5_5"
	}
	self.eSymbol = self:enum(symbolName, "symbol")
	self.eSymbol.isCollectible = function(tableau, item)
		return item == tableau.scatter2:toint()
	end
	self.eSymbol.isWild4 = function(tableau, item)
		return item >= tableau.wild4_1:toint() and item <= tableau.wild4_4:toint()
	end
	self.eSymbol.isWild5 = function(tableau, item)
		return item >= tableau.wild5_1:toint() and item <= tableau.wild5_5:toint()
	end
	self.eSymbol.isLongWild = function(tableau, item)
		return tableau:isWild4(item) or tableau:isWild5(item)
	end
	self.eSymbol.respinAllow = function(tableau, item)
		return item==tableau.scatter1:toint() or item==tableau.scatter2:toint() or item==tableau.blank:toint()
	end

	self:initSpineAnimation()
	self:initAudio()
	self.notifyMusicOrder = {}
	for index, symbol in pairs(getmetatable(self.eSymbol)) do
		if self.eSymbol:isenum(symbol) then
			self.notifyMusicOrder[symbol:toint()] = symbol.value
		end
	end

	self.eBoard = self:enum({
		"base", "free", "respin", "wheel", "mapRespin"
	}, "BoardType")
	self.boardType = self.eBoard.base

	self.eBoardId = self:enum({
		"base", "f4x5", "f4x6", "f5x5", "f5x6"
	}, "BoardId")
	self.activeBoard = self.eBoardId.base

	self.eFreeReel = self:enum({
		"base", "f4x5", "f4x6", "f5x5", "f5x6", "f4x5m", "f4x6m", "f5x5m", "f5x6m"
	})
	self.freeReelType = nil

	self.eSymbolNotify = self:enum({"sum", "columnSum", "consequential", "collectible"}, "ThemeSymbolNotifyType")
	self.const = {
		cellWidth = { 161, 161, 161, 161, 161 },
		cellHeight = { 109.5, 109.5, 109.5, 110, 110 },
		symbolCount = { 4, 4, 4, 5, 5},
		stickyMaskOpacity = 150,
		delStickyWildWhole = 0.2,
		delStickyWildEach = 0.4,
		delNextRespin = 1,
		delRespinStop = 1.4,
		delCollectibleBrim = 48/30,
		aCollectibleBrimZorder = 10,
		zNudge = 15,
		zNotify = {
			[self.eSymbol.scatter1:toint()] = 20
		},
		zWin = {
			[self.eSymbol.scatter1:toint()] = 15,
			[self.eSymbol.scatter2:toint()] = 16,
			[self.eSymbol.wild:toint()] = 20
		},
		anticipationExtraSpinTime = 120/60,
		respinAnticipationExtraSpinTime = 100/60,
	}
	for i = self.eSymbol.wild4_1:toint(), self.eSymbol.wild5_5:toint() do
		self.const.zWin[i] = self.const.zWin[self.eSymbol.wild:toint()]
	end
		
	self.maxMapPoints = 100

	self.emptyLambda = function() end
end

local G_cellHeight = 110
local delay = 0
local upBounce = G_cellHeight*2/3
local upBounceMaxSpeed = 6*60
local upBounceTime = 0
local speedUpTime = 12/60
local rotateTime = 5/60
local maxSpeed = -40*60
local normalSpeed = -40*60
local fastSpeed = -40*60 - 300

local stopDelay = 20/60
local speedDownTime = 30/60
local downBounce = G_cellHeight*2/3
local downBounceMaxSpeed = 6*60
local downBounceTime = 15/60
local specialAniTime = 78/30
local extraReelTime = 120/60
local extraReelTimeInFreeGame = 3+2.5
local spinMinCD = 0.5
local eachPiggyDelay = 1.5

function cls:getBoardConfig()
	if self.boardConfigList then
		return self.boardConfigList
	end
	self.boardConfigList = self.ThemeConfig.boardConfig
	return self.boardConfigList
end

function cls:getSpinColStartAction(col, reelCol)
	if self.isTurbo then
		maxSpeed = fastSpeed
	else 
		maxSpeed = normalSpeed
	end
	local spinAction = {}
	spinAction.delay = delay*(col-1)
	spinAction.upBounce = upBounce
	spinAction.upBounceMaxSpeed = upBounceMaxSpeed
	spinAction.upBounceTime = upBounceTime
	spinAction.speedUpTime = speedUpTime
	spinAction.maxSpeed = maxSpeed
	
	return spinAction
end

function cls:getSpinColStopAction(themeInfoData, col, interval)
	if self.boardType == self.eBoard.base then
		if self:checkSpeedUp(col) then
			self.DelayStopTime = self.DelayStopTime + self.const.anticipationExtraSpinTime
		end
	elseif self.boardType == self.eBoard.respin then
		if (self.respinAnticipationPlan and self.respinAnticipationPlan[col]) or self:checkSpeedUp(col) then
			self.DelayStopTime = self.DelayStopTime + self.const.respinAnticipationExtraSpinTime
		end
	end

	local specialType 
	if themeInfoData and themeInfoData["special_type"] then 
		specialType = themeInfoData["special_type"]
	end

	local function onSpecialBegain( pcol)
		if pcol == 1 then 
			self.ctl.specialSpeed = true
			self:addSpecialSpeed(specialType)
		end
	end

	local function onRandomBegain( pcol)
		if pcol == 1 then 
			self.ctl.specialSpeed = true
			self:setRandWildSymbol(self.randomWildPos)
		end
	end

	local spinAction = {}
	spinAction.actions = {}

	local temp = interval - speedUpTime - upBounceTime - (col-1)*delay
	if specialType then
		if specialType == 1 then 
			local addRandomTime = self:getPlayRandomWildAnimTime(self.randomWildPos) or 0
			local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0

			local leftFirstFreeGameTriggerTime = 0
			if self.firstFreeGameTrigger then 
				leftFirstFreeGameTriggerTime = extraReelTimeInFreeGame + rotateTime - temp > 0 and extraReelTimeInFreeGame + rotateTime - temp or 0.1
				table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = leftFirstFreeGameTriggerTime,["accelerationTime"] = 10/60})
			end
			
			table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = specialAniTime,["accelerationTime"] = 10/60,["beginFun"] = onSpecialBegain})
			table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = addRandomTime,["accelerationTime"] = 10/60,["beginFun"] = onRandomBegain})
			table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = 1000,["accelerationTime"] = 1000})
			
			
			if self.firstFreeGameTrigger then 
				spinAction.stopDelay = timeleft+(col-1)*stopDelay + specialAniTime + addRandomTime + leftFirstFreeGameTriggerTime -- 增加的 delay 时间
			else
				spinAction.stopDelay = timeleft+(col-1)*stopDelay + specialAniTime + addRandomTime -- 增加的 delay 时间
			end

			self.ExtraStopCD = spinAction.stopDelay+speedDownTime
			-- self.canFastStop = false
			spinAction.ClearAction = true
		elseif specialType == 2 then 
			local addRandomTime = self:getPlayRandomWildAnimTime(self.randomWildPos) or 0

			local leftFirstFreeGameTriggerTime = 0
			if self.firstFreeGameTrigger then 
				leftFirstFreeGameTriggerTime = extraReelTimeInFreeGame + rotateTime - temp > 0 and extraReelTimeInFreeGame + rotateTime - temp or 0.1
				table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = leftFirstFreeGameTriggerTime,["accelerationTime"] = 10/60})
			end
			
			table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = addRandomTime,["accelerationTime"] = 10/60,["beginFun"] = onRandomBegain})
			table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = 1000,["accelerationTime"] = 1000})
			local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0

			if self.firstFreeGameTrigger then 
				spinAction.stopDelay = timeleft+(col-1)*stopDelay + addRandomTime + leftFirstFreeGameTriggerTime -- 增加的 delay 时间
			else
				spinAction.stopDelay = timeleft+(col-1)*stopDelay + addRandomTime -- 增加的 delay 时间
			end

			self.ExtraStopCD = spinAction.stopDelay+speedDownTime
			-- self.canFastStop = false
			spinAction.ClearAction = true
		end

	else
		local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0

		if self.firstFreeGameTrigger then
			spinAction.stopDelay = timeleft+(col-1)*stopDelay + self.DelayStopTime + extraReelTimeInFreeGame
		else
			spinAction.stopDelay = timeleft+(col-1)*stopDelay + self.DelayStopTime
		end
		
		
		self.ExtraStopCD = spinMinCD - temp > 0 and spinMinCD - temp or 0
	end

	spinAction.maxSpeed = maxSpeed
	spinAction.speedDownTime = speedDownTime

	if self.isTurbo then
		spinAction.speedDownTime = speedDownTime - 10/60
	end
	spinAction.downBounce = downBounce
	spinAction.downBounceMaxSpeed = downBounceMaxSpeed
	spinAction.downBounceTime = downBounceTime
	spinAction.stopType = 1
	return spinAction
end

function cls:addSpecialSpeed(specialTag)
	self:playMusic(self.audio_list.random_notify)
	self:dealMusic_FadeLoopMusic(0.3,1,0.3)-- 添加出特效音效控制/减小背景音乐音量 
	-- 播放激励动画
	self:addSpineAnimation(self.baseScene.nChooseJp, 20, self:getPic("spine/base/wild_jili"), cc.p(0,0), "animation")
	self:addSpineAnimation(self.baseScene.nChooseJp, 10, self:getPic("spine/base/zhenpingluoye"), cc.p(0,0), "animation")
	-- self:shakeScreen()
	self:laterCallBack(specialAniTime,function( ... )
		self:dealMusic_FadeLoopMusic(0.3,0.3,1)
	end)
end

function cls:shakeScreen()
	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			local function shakeEnd( ... )
				self.shaker = nil
			end
			self.shaker = ScreenShaker.new(self.mainThemeScene,specialAniTime,shakeEnd)
			self.shaker.diff_max = 12
			self.shaker:run()
		end)
	))
end

function cls:initScene(spinNode)
	-- base board
	self.baseScene = cc.CSLoader:createNode(self:getPic("csb/base.csb"))
	bole.adaptScale(self.baseScene, false)
	self.shakyNode:addChild(self.baseScene)

	self.baseScene.down_node = self.baseScene:getChildByName("down_node")
	self.baseScene.down_child = self.baseScene.down_node:getChildByName("down_child")
	self.baseScene.root = self.baseScene.down_child:getChildByName("root")
	self.baseScene.symbolBoard = self.baseScene.root:getChildByName("symbolBoard")--this node will be scaled to 95% under certain circumstances

	-- jackpot labels
	self.baseScene.nProgressive = self.baseScene.root:getChildByName("nProgressive")
	self.baseScene.sChooseJpDown = self.baseScene.nProgressive:getChildByName("sChooseJpDown")
	self.baseScene.sChooseJpUp = self.baseScene.nProgressive:getChildByName("sChooseJpUp")
	self.baseScene.nChooseJp = self.baseScene.root:getChildByName("nChooseJp")
	self.baseScene.dChooseJp = self.baseScene.root:getChildByName("dChoose")

	self.jackpotLabels = {}
	local jpLabelMaxWidth = {207, 134, 134, 124, 124}
	for i = 1, 5 do
		self.jackpotLabels[i] = self.baseScene.nProgressive:getChildByName("jpLabel"..i)
		self.jackpotLabels[i].maxWidth = jpLabelMaxWidth[i]
		self.jackpotLabels[i].baseScale = self.jackpotLabels[i]:getScale()
		self.baseScene["jpBg"..i] = self.baseScene.nProgressive:getChildByName("jpBg"..i)
	end
	self:initialJackpotNode()

	-- required by other classes
	self.bgRoot = self.baseScene:getChildByName("bgRoot")
	self.baseBg = self.bgRoot:getChildByName("base")
	self.freeBg = self.bgRoot:getChildByName("free")
	self.respinBg = self.bgRoot:getChildByName("respin")
	self.boardRoot = self.baseScene.root:getChildByName("nBoard")
	self.animateNode = self.baseScene.symbolBoard:getChildByName("aDefault")
	self.themeAnimateKuang = self.baseScene.symbolBoard:getChildByName("aAnimKuang")

	-- map node
    self.baseScene.panelMap = self.baseScene.root:getChildByName("map_show_node")
	self.baseScene.panelMap:setTouchEnabled(false)
	self.baseScene.nMapLoad = self.baseScene.panelMap:getChildByName("node")

	---collect node
	self.baseScene.nCollect = self.baseScene.root:getChildByName("nCollect")
	self.baseScene.pCollect = self.baseScene.nCollect:getChildByName("pCollect")
	self.baseScene.progressBar = self.baseScene.pCollect:getChildByName("progressBar")
	local barSize = self.baseScene.progressBar:getContentSize()
	local _, s = self:addSpineAnimation(self.baseScene.progressBar, nil, self:getPic("spine/progress/jindutiao"), cc.p(barSize.width/2, barSize.height/2), "animation", nil, nil, nil, true, true)

	s:setScale(0.8)
	self.baseScene.aCollectFrontGlimming = self.baseScene.pCollect:getChildByName("aCollectFrontGlimming")
	self.baseScene.bBar = self.baseScene.nCollect:getChildByName("bBar")
	self.baseScene.bMapInfo = self.baseScene.nCollect:getChildByName("bInfo")
	local mapInfoBtnSize = self.baseScene.bMapInfo:getContentSize()
	self:addSpineAnimation(self.baseScene.bMapInfo, nil, self:getPic("spine/progress/xiaoi"), cc.p(mapInfoBtnSize.width/2, mapInfoBtnSize.height/2), "animation", nil, nil, nil, true, true)

	self.baseScene.iNextLevel = {}
    for i = 1, 5 do
    	self.baseScene.iNextLevel[i] = self.baseScene.nCollect:getChildByName("iNextStep"..i)
    	self.baseScene.iNextLevel[i]:setVisible(false)
	end
	
	-- board mutable nodes
	for i = 1, 5 do
		if i~=2 then
			self.baseScene["board"..i] = self.baseScene.root:getChildByName("board"..i)
		end
	end

	self.baseScene.mapFreeLogo = self.baseScene.root:getChildByName("map_free_logo")
	self.baseScene.lineCntNode = self.baseScene.board1:getChildByName("line_cnt")
	

	-- animation nodes
	self.baseScene.stickyAnimate = self.baseScene.symbolBoard:getChildByName("aSticky")
	self.baseScene.aRandom = self.baseScene.symbolBoard:getChildByName("aRandom")
	self.baseScene.nRandomSprite = self.baseScene.symbolBoard:getChildByName("nRandomSprite")
	self.baseScene.stickyMask = self.baseScene.symbolBoard:getChildByName("stickyMask")
	self.baseScene.stickyMask:setOpacity(0)
	self.baseScene.stickyMaskList = self.baseScene.stickyMask:getChildren()

	self.baseScene.aNudge = self.baseScene.symbolBoard:getChildByName("aNudge")
	self.baseScene.aAnticipation = self.baseScene.symbolBoard:getChildByName("aAnticipation")
	self.baseScene.aRespinAnticipation = self.baseScene.symbolBoard:getChildByName("aRespinAnticipation")

    self.baseScene.aCollectibleFly = self.baseScene.nCollect:getChildByName("aCollectibleFly")
    self.baseScene.aCollectibleLand = self.baseScene.nCollect:getChildByName("aCollectibleLand")
    self.baseScene.aFrameBrim = self.baseScene.nCollect:getChildByName("aFrameBrim")
	self.baseScene.aFrameHalo = self.baseScene.nCollect:getChildByName("aFrameHalo")
    self.baseScene.aLock = self.baseScene.nCollect:getChildByName("aLock")
    self.btn_unLock = self.baseScene.nCollect:getChildByName("btn_unlock")
    self.baseScene.nCollectTip = self.baseScene.nCollect:getChildByName("nCollectTip")
    self.baseScene.nCollectTip:setScale(1, 0)
    self.baseScene.nCollectTip:setVisible(false)
    self.baseScene.tCollectTip = {}
    for i = 1, 2 do
    	self.baseScene.tCollectTip[i] = self.baseScene.nCollectTip:getChildByName("text"..i)
    	self.baseScene.tCollectTip[i]:setVisible(false)
    end
    self.btn_collectTip = self.baseScene.nCollect:getChildByName("btn_tip")
    self.btn_collectTip:setVisible(false)
	self.baseScene.nCollectBack = self.baseScene.root:getChildByName("nCollectBack")
	
	--bonus game
	self.baseScene.bonusCntNode = self.baseScene.root:getChildByName("respin_cnt_node")
	self.baseScene.bonusCntNode:setVisible(false)
	self.baseScene.bonusCntlabel = self.baseScene.bonusCntNode:getChildByName("respin_cnt")
	self.baseScene.bonusCntTipNodeList = {}
	for i = 0, 2 do 
		self.baseScene.bonusCntTipNodeList[i] = self.baseScene.bonusCntNode:getChildByName("respin_node"..i)
	end
	self.baseScene.bonusCntNode:getChildByName("respin_cnt")
	self.baseScene.bonusRoot = self.baseScene.down_child:getChildByName("bonusRoot")
	self.baseScene.dBonus = self.baseScene.bonusRoot:getChildByName("dBonus")
	self.baseScene.dBonus:setOpacity(0)
	self.baseScene.nBonusEntry = self.baseScene.bonusRoot:getChildByName("nBonusEntry")

	self.maxMapLevel = 18
	-- the progress bar is scaled to 1.25
    self.progressStartPosX = self.baseScene.progressBar:getPositionX() - self.baseScene.progressBar:getContentSize().width*1.25
	self.progressEndPosX = self.baseScene.progressBar:getPositionX()
	self.progressPosY = self.baseScene.progressBar:getPositionY()
    self.movePerUnit = self.progressEndPosX*2/self.maxMapPoints
	self.isMapOpen = false
	self.scatterSkeleton = {}
	self.flyCoinSkeleton = {}
	self.hasUnanimity = false

end

function cls:getThemeJackpotConfig()
	return {
		link_config = {"grand", "major", "maxi", "minor", "mini"},
		allowK = {[164] = false, [664] = false, [1164] = false}
	}
end
------------------------------endregion------------------------------



------------------------------region constant initialization------------------------------
function cls:initSpineAnimation()
	local spineList = {
		["symbol"..self.eSymbol.m1:toint()] = { file = "symbol/symbol_huangbao", win = "animation" },
		["symbol"..self.eSymbol.m2:toint()] = { file = "symbol/symbol_heibao", win = "animation" },
		["symbol"..self.eSymbol.m3:toint()] = { file = "symbol/symbol_baibao", win = "animation" },
		["symbol"..self.eSymbol.m4:toint()] = { file = "symbol/symbol_xianglian", win = "animation" },
		["symbol"..self.eSymbol.m5:toint()] = { file = "symbol/symbol_jiezhi", win = "animation" },
		["symbol"..self.eSymbol.m6:toint()] = { file = "symbol/symbol_erhuan", win = "animation" },
		["symbol"..self.eSymbol.scatter1:toint()] = { file = "symbol/scatter", win = "animation3", notify11 = "animation1", notify12 = "animation2", collect = "animation4", win11 = "animation" , win12 = "animation3" },
		["symbol"..self.eSymbol.wild:toint()] = { file = "symbol/1x5nvren", win = "animation1", win4 = "animation4", win5 = "animation5" },
		randomWild = "symbol/wild1chuxian",
		nudge = { file = "symbol/wild45chuxian", nudge4 = "animation4", nudge5 = "animation5" },
		anticipation = "base/lunzhou",
		respinAntici = "bonus/quanpanjili",
	}
	for key, value in pairs(spineList) do
		if type(value)=="string" then
			spineList[key] = self:getResource("spine/"..value)
		elseif type(value)=="table" and value.file then
			value.file = self:getResource("spine/"..value.file)
		end
	end
	self.spine = spineList

	self.particle = {}
	setmetatable(self.particle, {
		__index = function(tableau, key)
			local ans = self:getResource("particle/"..key..".plist")
			tableau[key] = ans
			return ans
		end
	})
end

function cls:initAudio()
	local meta2 = {
		__index = function(tableau, key)
			local a = getmetatable(tableau)[key]
			if a then
				return a
			else
				local ans = self:getResource("audio/"..tableau.path.."/"..key)
				tableau[key] = ans
				return ans
			end
		end
	}
	local meta1 = {
		__index = function(tableau, key)
			local a = getmetatable(tableau)[key]
			if a then
				return a
			else
				local ans = {
					path = key
				}
				tableau[key] = ans
				setmetatable(ans, meta2) 
				return ans
			end
		end
	}
	self.audio = {}
	setmetatable(self.audio, meta1)
end

-- function cls:getLoadMusicList()
	-- return {
	-- 	self.audio.base.k,
	-- 	self.audio.bonus.k2,
	-- 	self.audio.hashtable.notify,
	-- }
-- end
------------------------------endregion------------------------------




----------------------------region spin board----------------------------

function cls:initSpinLayer()
	self.spinLayerList = {}
	for index, cofig in ipairs(self.boardNodeList) do
		self.initBoardIndex = index
		local boardNode = self.boardNodeList[index]
		local layer = SpinLayer.new(self, self.ctl, boardNode.reelConfig, boardNode)
		layer:DeActive()
		self.shakyNode:addChild(layer, -1)
		table.insert(self.spinLayerList, layer)
	end
	self.initBoardIndex = nil
	self.spinLayer = self.spinLayerList[1]
	self.spinLayer:Active()
	-- self.ctl.footer:changeNormalLayout()
end

function cls:initSpinLayerBg()
   	if self.mapPoints then
		self:setCollectProgressImagePos(self.mapPoints)
	end
	if self.mapLevel then
		self:setNextCollectTargetImage(self.mapLevel)
	end
	if self.baseScene.nCollect:isVisible() then
		self:enableMapInfoBtn(true)
	end
	self.currentBet = self.ctl:getCurTotalBet()
	if self.currentBet < self.collectEnableBet then
		self:setCollectPartState(false, false)
		self.isLocked = true
	else
		self.isLocked = false
		if not self.bDontShowInitPopup then
	       self:showCollectTip(1)
	       self:enableCollectTipBtn(true, 1)
	    end
	end

	self.showBaseSpinBoard = true
	self.bDontShowInitPopup = nil
	Theme.initSpinLayerBg(self)
end

function cls:setBoardScene(boardId)
	if boardId == self.eBoardId.f4x5 then-- no additional resources for free games without booster
		for id, i in ipairs({1, 3, 4, 5}) do
			self.baseScene["board"..i]:setVisible(i == 1)
			self.baseScene.stickyMaskList[id]:setVisible(i == 1)
		end
		self.activeBoardNode = self.baseScene.board1

	else
		for id, i in ipairs({1, 3, 4, 5}) do
			self.baseScene["board"..i]:setVisible(i == boardId:toint())
			self.baseScene.stickyMaskList[id]:setVisible(i == boardId:toint())
		end
		self.activeBoardNode = self.baseScene["board"..boardId:toint()]
	end
	if boardId ~= self.eBoardId.base then
		self.baseScene.nProgressive:setVisible(false)
		self.baseScene.nCollect:setVisible(false)
	else
		self.baseScene.nProgressive:setVisible(true)
		self.baseScene.nCollect:setVisible(true)
	end

	if boardId == self.eBoardId.f4x5 or boardId == self.eBoardId.f4x6 then
		self.baseScene.mapFreeLogo:setVisible(true)
	else
		self.baseScene.mapFreeLogo:setVisible(false)
	end
	if boardId == self.eBoardId.f5x6 or boardId == self.eBoardId.f5x5 then
		self:setSymbolBoardScale(0.95, 0.95)
	else
		self:setSymbolBoardScale(1, 1)
	end
end

function cls:setSymbolBoardScale(x, y)
	local c = self.baseScene.symbolBoard:getChildren()
	for _, child in pairs(c) do
		child:setScale(x, y)
	end
	self.boardRoot:setScale(x, y)
end

function cls:updateReelPaylineConfig(boardId)
	local payLine_list = {
        [1] = { -- 4x5 in base game
			{0, 0, 0, 0, 0}, {3, 3, 3, 3, 3}, {1, 1, 1, 1, 1}, {2, 2, 2, 2, 2}, {0, 1, 2, 1, 0}, --5
			{3, 2, 1, 2, 3}, {2, 1, 0, 1, 2}, {1, 2, 3, 2, 1}, {0, 1, 0, 1, 0}, {3, 2, 3, 2, 3}, --10
			{1, 0, 1, 0, 1}, {2, 3, 2, 3, 2}, {1, 2, 1, 2, 1}, {2, 1, 2, 1, 2}, {0, 1, 1, 1, 0}, --15
			{3, 2, 2, 2, 3}, {1, 0, 0, 0, 1}, {2, 3, 3, 3, 2}, {1, 2, 2, 2, 1}, {2, 1, 1, 1, 2}, --20
			{0, 0, 1, 0, 0}, {3, 3, 2, 3, 3}, {1, 1, 0, 1, 1}, {2, 2, 3, 2, 2}, {1, 1, 2, 1, 1}, --25
			{2, 2, 1, 2, 2}, {0, 0, 2, 0, 0}, {3, 3, 1, 3, 3}, {2, 2, 0, 2, 2}, {1, 1, 3, 1, 1}, --30
			{0, 2, 2, 2, 0}, {3, 1, 1, 1, 3}, {2, 0, 0, 0, 2}, {1, 3, 3, 3, 1}, {1, 0, 2, 0, 1}, --35
			{2, 3, 1, 3, 2}, {1, 2, 0, 2, 1}, {2, 1, 3, 1, 2}, {0, 2, 0, 2, 0}, {3, 1, 3, 1, 3}, --40
			{2, 0, 2, 0, 2}, {1, 3, 1, 3, 1}, {0, 2, 1, 2, 0}, {3, 1, 2, 1, 3}, {2, 0, 1, 0, 2}, --45
			{1, 3, 2, 3, 1}, {0, 3, 0, 3, 0}, {3, 0, 3, 0, 3}, {0, 0, 3, 0, 0}, {3, 3, 0, 3, 3}, --50
		},
		[2] = { -- 4x5
			{0, 0, 0, 0, 0}, {3, 3, 3, 3, 3}, {1, 1, 1, 1, 1}, {2, 2, 2, 2, 2}, {0, 1, 2, 1, 0}, --5
			{3, 2, 1, 2, 3}, {2, 1, 0, 1, 2}, {1, 2, 3, 2, 1}, {0, 1, 0, 1, 0}, {3, 2, 3, 2, 3}, --10
			{1, 0, 1, 0, 1}, {2, 3, 2, 3, 2}, {1, 2, 1, 2, 1}, {2, 1, 2, 1, 2}, {0, 1, 1, 1, 0}, --15
			{3, 2, 2, 2, 3}, {1, 0, 0, 0, 1}, {2, 3, 3, 3, 2}, {1, 2, 2, 2, 1}, {2, 1, 1, 1, 2}, --20
			{0, 0, 1, 0, 0}, {3, 3, 2, 3, 3}, {1, 1, 0, 1, 1}, {2, 2, 3, 2, 2}, {1, 1, 2, 1, 1}, --25
			{2, 2, 1, 2, 2}, {0, 0, 2, 0, 0}, {3, 3, 1, 3, 3}, {2, 2, 0, 2, 2}, {1, 1, 3, 1, 1}, --30
			{0, 2, 2, 2, 0}, {3, 1, 1, 1, 3}, {2, 0, 0, 0, 2}, {1, 3, 3, 3, 1}, {1, 0, 2, 0, 1}, --35
			{2, 3, 1, 3, 2}, {1, 2, 0, 2, 1}, {2, 1, 3, 1, 2}, {0, 2, 0, 2, 0}, {3, 1, 3, 1, 3}, --40
			{2, 0, 2, 0, 2}, {1, 3, 1, 3, 1}, {0, 2, 1, 2, 0}, {3, 1, 2, 1, 3}, {2, 0, 1, 0, 2}, --45
			{1, 3, 2, 3, 1}, {0, 3, 0, 3, 0}, {3, 0, 3, 0, 3}, {0, 0, 3, 0, 0}, {3, 3, 0, 3, 3}, --50
		},
        [3] = { -- 4x6
			{0, 0, 0, 0, 0, 0}, {3, 3, 3, 3, 3, 3}, {1, 1, 1, 1, 1, 1}, {2, 2, 2, 2, 2, 2}, {0, 1, 2, 1, 0, 1}, -- 5
			{3, 2, 1, 2, 3, 1}, {2, 1, 0, 1, 2, 1}, {1, 2, 3, 2, 1, 2}, {0, 1, 0, 1, 0, 1}, {3, 2, 3, 2, 3, 2}, -- 10
			{1, 0, 1, 0, 1, 0}, {2, 3, 2, 3, 2, 3}, {1, 2, 1, 2, 1, 2}, {2, 1, 2, 1, 2, 2}, {0, 1, 1, 1, 0, 1}, -- 15
			{3, 2, 2, 2, 3, 2}, {1, 0, 0, 0, 1, 0}, {2, 3, 3, 3, 2, 3}, {1, 2, 2, 2, 1, 2}, {2, 1, 1, 1, 2, 1}, -- 20
			{0, 0, 1, 0, 0, 1}, {3, 3, 2, 3, 3, 2}, {1, 1, 0, 1, 1, 0}, {2, 2, 3, 2, 2, 3}, {1, 1, 2, 1, 1, 2}, -- 25
			{2, 2, 1, 2, 2, 1}, {0, 0, 2, 0, 0, 2}, {3, 3, 1, 3, 3, 1}, {2, 2, 0, 2, 2, 0}, {1, 1, 3, 1, 1, 3}, -- 30
			{0, 2, 2, 2, 0, 2}, {3, 1, 1, 1, 3, 1}, {2, 0, 0, 0, 2, 0}, {1, 3, 3, 3, 1, 3}, {1, 0, 2, 0, 1, 2}, -- 35
			{2, 3, 1, 3, 2, 1}, {1, 2, 0, 2, 1, 0}, {2, 1, 3, 1, 2, 3}, {0, 2, 0, 2, 0, 2}, {3, 1, 3, 1, 3, 1}, -- 40
			{2, 0, 2, 0, 2, 0}, {1, 3, 1, 3, 1, 3}, {0, 2, 1, 2, 0, 1}, {3, 1, 2, 1, 3, 2}, {2, 0, 1, 0, 2, 1}, -- 45
			{1, 3, 2, 3, 1, 2}, {0, 3, 0, 3, 0, 3}, {3, 0, 3, 0, 3, 0}, {0, 0, 3, 0, 0, 3}, {3, 3, 0, 3, 3, 0}, -- 50
		},
        [4] = { -- 5x5
			{0, 0, 0, 0, 0}, {3, 3, 3, 3, 3}, {1, 1, 1, 1, 1}, {2, 2, 2, 2, 2}, {0, 1, 2, 1, 0}, -- 5
			{3, 2, 1, 2, 3}, {2, 1, 0, 1, 2}, {1, 2, 3, 2, 1}, {0, 1, 0, 1, 0}, {3, 2, 3, 2, 3}, -- 10
			{1, 0, 1, 0, 1}, {2, 3, 2, 3, 2}, {1, 2, 1, 2, 1}, {2, 1, 2, 1, 2}, {0, 1, 1, 1, 0}, -- 15
			{3, 2, 2, 2, 3}, {1, 0, 0, 0, 1}, {2, 3, 3, 3, 2}, {1, 2, 2, 2, 1}, {2, 1, 1, 1, 2}, -- 20
			{0, 0, 1, 0, 0}, {3, 3, 2, 3, 3}, {1, 1, 0, 1, 1}, {2, 2, 3, 2, 2}, {1, 1, 2, 1, 1}, -- 25
			{2, 2, 1, 2, 2}, {0, 0, 2, 0, 0}, {3, 3, 1, 3, 3}, {2, 2, 0, 2, 2}, {1, 1, 3, 1, 1}, -- 30
			{0, 2, 2, 2, 0}, {3, 1, 1, 1, 3}, {2, 0, 0, 0, 2}, {1, 3, 3, 3, 1}, {1, 0, 2, 0, 1}, -- 35
			{2, 3, 1, 3, 2}, {1, 2, 0, 2, 1}, {2, 1, 3, 1, 2}, {0, 2, 0, 2, 0}, {3, 1, 3, 1, 3}, -- 40
			{2, 0, 2, 0, 2}, {1, 3, 1, 3, 1}, {0, 2, 1, 2, 0}, {3, 1, 2, 1, 3}, {2, 0, 1, 0, 2}, -- 45
			{1, 3, 2, 3, 1}, {0, 3, 0, 3, 0}, {3, 0, 3, 0, 3}, {0, 0, 3, 0, 0}, {3, 3, 0, 3, 3}, -- 50
			{4, 4, 4, 4, 4}, {4, 3, 2, 3, 4}, {4, 4, 3, 4, 4}, {4, 3, 3, 3, 4}, {4, 2, 2, 2, 4}, -- 55
			{4, 3, 4, 3, 4}, {4, 2, 3, 2, 4}, {4, 2, 4, 2, 4}, {4, 4, 2, 4, 4}, {4, 4, 3, 2, 2}, -- 60
			{4, 3, 3, 3, 2}, {4, 3, 2, 2, 3}, {4, 3, 4, 3, 2}, {4, 4, 4, 3, 3}, {4, 4, 4, 3, 2}, -- 65
		},
        [5] = { -- 5x6
			{0, 0, 0, 0, 0, 0}, {3, 3, 3, 3, 3, 3}, {1, 1, 1, 1, 1, 1}, {2, 2, 2, 2, 2, 2}, {0, 1, 2, 1, 0, 1}, -- 5
			{3, 2, 1, 2, 3, 1}, {2, 1, 0, 1, 2, 1}, {1, 2, 3, 2, 1, 2}, {0, 1, 0, 1, 0, 1}, {3, 2, 3, 2, 3, 2}, -- 10
			{1, 0, 1, 0, 1, 0}, {2, 3, 2, 3, 2, 3}, {1, 2, 1, 2, 1, 2}, {2, 1, 2, 1, 2, 2}, {0, 1, 1, 1, 0, 1}, -- 15
			{3, 2, 2, 2, 3, 2}, {1, 0, 0, 0, 1, 0}, {2, 3, 3, 3, 2, 3}, {1, 2, 2, 2, 1, 2}, {2, 1, 1, 1, 2, 1}, -- 20
			{0, 0, 1, 0, 0, 1}, {3, 3, 2, 3, 3, 2}, {1, 1, 0, 1, 1, 0}, {2, 2, 3, 2, 2, 3}, {1, 1, 2, 1, 1, 2}, -- 25
			{2, 2, 1, 2, 2, 1}, {0, 0, 2, 0, 0, 2}, {3, 3, 1, 3, 3, 1}, {2, 2, 0, 2, 2, 0}, {1, 1, 3, 1, 1, 3}, -- 30
			{0, 2, 2, 2, 0, 2}, {3, 1, 1, 1, 3, 1}, {2, 0, 0, 0, 2, 0}, {1, 3, 3, 3, 1, 3}, {1, 0, 2, 0, 1, 2}, -- 35
			{2, 3, 1, 3, 2, 1}, {1, 2, 0, 2, 1, 0}, {2, 1, 3, 1, 2, 3}, {0, 2, 0, 2, 0, 2}, {3, 1, 3, 1, 3, 1}, -- 40
			{2, 0, 2, 0, 2, 0}, {1, 3, 1, 3, 1, 3}, {0, 2, 1, 2, 0, 1}, {3, 1, 2, 1, 3, 2}, {2, 0, 1, 0, 2, 1}, -- 45
			{1, 3, 2, 3, 1, 2}, {0, 3, 0, 3, 0, 3}, {3, 0, 3, 0, 3, 0}, {0, 0, 3, 0, 0, 3}, {3, 3, 0, 3, 3, 0}, -- 50
			{4, 4, 4, 4, 4, 4}, {4, 3, 2, 3, 4, 3}, {4, 4, 3, 4, 4, 3}, {4, 3, 3, 3, 4, 2}, {4, 2, 2, 2, 4, 3}, -- 55
			{4, 3, 4, 3, 4, 3}, {4, 2, 3, 2, 4, 3}, {4, 2, 4, 2, 4, 2}, {4, 4, 2, 4, 4, 2}, {4, 4, 3, 2, 2, 3}, -- 60
			{4, 3, 3, 3, 2, 2}, {4, 3, 2, 2, 3, 4}, {4, 3, 4, 3, 2, 3}, {4, 4, 4, 3, 3, 2}, {4, 4, 4, 3, 2, 3}, -- 65
		}
	}
	self.lines = payLine_list[boardId:toint()]
end

-- function: (1) change spin board background (call setBoardScene)
-- (2) change symbol clip area (call spinLayer.Active)
-- (3) change pay line (call updateReelPaylineConfig)
-- (4) change fake reel	(call getFreeThemeReel)
function cls:changeSpinBoard(boardId, bFree)
	if boardId == self.eBoardId.base then
		if not bFree then
			self.boardType = self.eBoard.base
			self.showBaseSpinBoard = true
			self.showFreeSpinBoard = false
			self.showMapFreeBoard = false
			self.baseScene.nCollect:setVisible(true)

			self.baseBg:setVisible(true)
			self.freeBg:setVisible(false)
			self.respinBg:setVisible(false)
		else
			self.showMapFreeBoard = false
			self.showBaseSpinBoard = false
			self.showFreeSpinBoard = true
			self.freeReelType = self.eFreeReel.base
			self.ctl.theme_reels.free_reel = self:getFreeThemeReel(1)
			self.baseScene.nCollect:setVisible(false)

			self.baseBg:setVisible(false)
			self.freeBg:setVisible(true)
			self.respinBg:setVisible(false)
		end
	elseif boardId == self.eBoardId.f4x5 then
		self.baseBg:setVisible(false)
		self.freeBg:setVisible(true)
		self.respinBg:setVisible(false)

		self.showMapFreeBoard = true
		self.showFreeSpinBoard = false
		self.showBaseSpinBoard = false
		if self.isMapFreeAddPiggy then
			self.freeReelType = self.eFreeReel.f4x5m
			self.ctl.theme_reels.free_reel = self:getFreeThemeReel(6)
		else
			self.freeReelType = self.eFreeReel.f4x5
		    self.ctl.theme_reels.free_reel = self:getFreeThemeReel(2)
		end
	elseif boardId == self.eBoardId.f4x6 then
		self.baseBg:setVisible(false)
		self.freeBg:setVisible(true)
		self.respinBg:setVisible(false)

		self.showMapFreeBoard = true
		self.showFreeSpinBoard = false
		self.showBaseSpinBoard = false
		if self.isMapFreeAddPiggy then
			self.freeReelType = self.eFreeReel.f4x6m
			self.ctl.theme_reels.free_reel = self:getFreeThemeReel(7)
		else
			self.freeReelType = self.eFreeReel.f4x6
		    self.ctl.theme_reels.free_reel = self:getFreeThemeReel(3)
		end
	elseif boardId == self.eBoardId.f5x6 then
		self.baseBg:setVisible(false)
		self.freeBg:setVisible(true)
		self.respinBg:setVisible(false)

		self.showMapFreeBoard = true
		self.showFreeSpinBoard = false
		self.showBaseSpinBoard = false
		if self.isMapFreeAddPiggy then
			self.freeReelType = self.eFreeReel.f5x6m
			self.ctl.theme_reels.free_reel = self:getFreeThemeReel(9)
		else
			self.freeReelType = self.eFreeReel.f5x6
		    self.ctl.theme_reels.free_reel = self:getFreeThemeReel(5)
		end
	elseif boardId == self.eBoardId.f5x5 then
		self.baseBg:setVisible(false)
		self.freeBg:setVisible(true)
		self.respinBg:setVisible(false)

		self.showMapFreeBoard = true
		self.showFreeSpinBoard = false
		self.showBaseSpinBoard = false
		if self.isMapFreeAddPiggy then
			self.freeReelType = self.eFreeReel.f5x5m
			self.ctl.theme_reels.free_reel = self:getFreeThemeReel(8)
		else
			self.freeReelType = self.eFreeReel.f5x5
		    self.ctl.theme_reels.free_reel = self:getFreeThemeReel(4)
		end
	end

	self.activeBoard = boardId
	if self.spinLayer ~= self.spinLayerList[boardId:toint()] then
		self.spinLayer:DeActive()
		self.spinLayer = self.spinLayerList[boardId:toint()]
		self.spinLayer:Active()
	end
	self:setBoardScene(boardId)
	self:updateReelPaylineConfig(boardId)
	return 0
end

function cls:getSpinColFastSpinAction(col)
	local speedScale = nil
	return Theme.getSpinColFastSpinAction(self, col, speedScale)
end

function cls:stopControl(stopRet, stopCallFun)
	self.item_list = stopRet.item_list
	-- self.coinCounts = 0
	
	-- self.coinSoundList = {false, false, false, false, false}
	-- self.jpSymbolLandSound = false
	-- self.piggySoundList = {false, false, false, false, false, false}

	if stopRet.bonus_level then
		self.collectEnableBet = stopRet.bonus_level
		self.bonusLevelChange = true
	end

	if stopRet.theme_info then
		if stopRet.theme_info.map_info then
			local mi = stopRet.theme_info.map_info
			if self.mapData == nil then
				self.mapData = {}
			end
		    self.mapData.extra_fg = mi.extra_fg
		    self.mapData.extra_wild = mi.extra_wild
		    self.mapData.reel_count = mi.reel_count
		    self.mapData.row_count = mi.row_count
		    self.mapData.sticky_wild = mi.sticky_wild
		    self.map_avg_bet = mi.avg_bet
		end

		-- copied from ThemeFortuneGongV
		if stopRet.theme_info.map_info and stopRet.theme_info.map_info.sticky_wild_pos then
			self.stickWildPosData = tool.tableClone(stopRet.theme_info.map_info.sticky_wild_pos) -- self:setStickyWildSymbol(stopRet.theme_info.map_info.sticky_wild_pos)
			self:fixStickWildData(self.stickWildPosData)
		end

		if stopRet.theme_info.wild_pos then
			stopRet.theme_info.special_type = stopRet.theme_info.special_type or 2
			-- if stopRet.theme_info and stopRet.theme_info.specialType then 

			self.randomWildPos = tool.tableClone(stopRet.theme_info.wild_pos)
			-- self:setRandWildSymbol(stopRet.theme_info.wild_pos)
		end

		if stopRet.theme_info.stack_reel_list then
			self.hasUnanimity = true
			local a = stopRet.theme_info
			self.stack_reel_list = a.stack_reel_list
			self.stack_symbol_list = a.stack_symbol_list
		end
	end

	-- if self.haveSpecialdelay then 
	-- 	self:runAction(cc.Sequence:create(
	-- 		cc.DelayTime:create(self.speicalDelay),
	-- 		cc.CallFunc:create(function ()
	-- 			stopCallFun()
	-- 		end)
	-- 	))
	-- else
		stopCallFun()
	-- end
	-- end
end

function cls:fixStickWildData( stickData )
	self.stickWildPosF = {}
	for _, list in pairs(stickData) do 
		local pos = list[1]
		local key = list[2]
		self.stickWildPosF[ pos[1] ] = self.stickWildPosF[ pos[1] ] or {}
		self.stickWildPosF[ pos[1] ][ pos[2] ] = key
	end
end

---- override
function cls:onThemeInfo(specialData, callFunc)
	if callFunc == nil then
		callFunc = self.emptyLambda
	end

	if self:bNudgeExists(specialData.theme_info.nudge_list) then
		self:nudge(specialData.theme_info, callFunc)
		callFunc = self.emptyLambda
	end

	if self.showBaseSpinBoard then -- self.boardType ~= self.eBoard.respin
		local themeInfoData = specialData.theme_info	
		local winMap = specialData.bonus_game and specialData.bonus_game.type ~= 1

		if themeInfoData and themeInfoData.map_info then
			self.map_avg_bet = themeInfoData.map_info.map_avg_bet
			local mapPoints = themeInfoData.map_info.map_points

			local mapLevel = themeInfoData.map_info.map_level
			self.mapLevel = mapLevel
			if mapPoints ~= self.mapPoints then
	       	    local bonusLevelDelay = 0
	       	    local isFull = winMap and true or false
	       	    if self.bonusLevelChange then
	       	    	if self.ctl:getCurTotalBet() < self.collectEnableBet then
	       	    	    bonusLevelDelay = 25/30
	       	    	    if isFull then 
	       	    	    	bonusLevelDelay = bonusLevelDelay + self.const.delCollectibleBrim
	       	    	    end
	       	    	else
	       	    		self.bonusLevelChange = nil
	       	    	end
	       	    end

	            self:runAction(cc.Sequence:create(
	          	    cc.CallFunc:create(function()
	          		    self:showCoinsFlyToUp()  		   
	            	end),
	          	    cc.DelayTime:create(25/30),
	          	    cc.CallFunc:create(function()
						self:showProgressAnimation(mapPoints, isFull)
						self.baseScene.aCollectibleFly:removeAllChildren()       		   
	            	end),
	          	    cc.DelayTime:create(bonusLevelDelay),
	          	    cc.CallFunc:create(function()
	          	    	if isFull then 
	          	    		callFunc()
	          	    	end
	          	    	if self.bonusLevelChange and self.ctl:getCurTotalBet() < self.collectEnableBet and bonusLevelDelay > 0 then
	          	    		self.bonusLevelChange = nil
	          	    		self:setCollectPartState(false, true)
	          	    	end
	          	    end) 
	            ))
	       	    if not isFull then 
	       	    	callFunc()
	       	    end
	        else
	        	if self.bonusLevelChange and self.ctl:getCurTotalBet() < self.collectEnableBet then
	        		self.bonusLevelChange = nil
	        		if self.isLocked then
	        			self:setCollectPartState(false, false)
	        		else
	        			self:setCollectPartState(false, true)    			
	        		end
	        	end
				callFunc()
			end
		else
			callFunc()
	    end
	else
		callFunc()
	end
end

function cls:bNudgeExists(nudgeList)
	if nudgeList then
		for i = 1, #nudgeList do
			if nudgeList[i] ~= 0 then
				return true
			end
		end
	end
	return false
end

local moveTime = 0.5
local moveTotalTime = 0.7
local nudgeList4 = { 21, 22, 23, 24 }
local nudgeList5 = { 25, 26, 27, 28, 29 }
function cls:nudge(themeInfoData, callFunc)
	local rets = self.ctl.rets
	local scatterAnimList = {}
	local g1 = cc.CallFunc:create(function()
		self:playMusic(self.audio_list.wild_nudge)
		for col, cnt in pairs(themeInfoData.nudge_list) do
			if cnt ~= 0 then
				local moveUp = 0
				if cnt > 0 then
					moveUp = 1
				elseif cnt < 0 then
					moveUp = -1
				end
				local count = math.abs(cnt)
				local moveSum = count
				local i = 0 

				local symbolList = #rets.item_list[col] == 4 and nudgeList4 or nudgeList5
				local symbolKey = cnt > 0 and cnt or cnt + #symbolList + 1
				while count > 0 do 
					i = i + 1
					local k = symbolList[symbolKey]
					self.spinLayer:setIconAtIndex(col, moveUp * i, k)
					if moveUp == 1 then--move down
						table.insert(rets.item_list[col], 1, k)
						table.remove(rets.item_list[col])
						symbolKey = symbolKey - 1
					else--move up
						table.insert(rets.item_list[col], k)
						table.remove(rets.item_list[col], 1)
						symbolKey = symbolKey + 1
					end
					count = count - 1
				end 
				self.spinLayer.spins[col]:refreshCellsZOrderFromBottom()
				self.spinLayer:moveReel(col, moveUp * moveSum, moveTime)
				
				-- nudge animation
				local boardIndex = self.activeBoard:toint()
				local reelPos = self:getReelLocation(col, boardIndex)
				local colSymbolNum = #rets.item_list[col]
				if colSymbolNum == 4 then
					self:playSpineAnimation(self.spine.nudge.file, self.spine.nudge.nudge4, false, false, self.spinLayer.spins[col]:getRetCell(4 - cnt), cc.p(0, self.const.cellHeight[boardIndex] * 1.5), self.const.zNudge)
				else
					self:playSpineAnimation(self.spine.nudge.file, self.spine.nudge.nudge5, false, false, self.spinLayer.spins[col]:getRetCell(5 - cnt), cc.p(0, self.const.cellHeight[boardIndex] * 2), self.const.zNudge)
				end
			end
		end
	end)

	table.insert(scatterAnimList, g1)
	table.insert(scatterAnimList, cc.DelayTime:create(moveTotalTime))
	table.insert(scatterAnimList, cc.CallFunc:create(function()
		self:dealMusic_FadeLoopMusic(0.3, 0.3, 1)
		callFunc()
	end))
	self:dealMusic_FadeLoopMusic(0.3, 1, 0.3)
	self:runAction(cc.Sequence:create(unpack(scatterAnimList)))
end

function cls:nudgeItemListConSilencio(list)
	local wholeWildCol4 = self:createIntegerDomain({ 21, 22, 23, 24 })
	local wholeWildCol5 = self:createIntegerDomain({ 25, 26, 27, 28, 29 })
	local calibrateCol = #list[1] == 4 and nudgeList4 or nudgeList5
	local ans = {}
	for i = 1, #list do
		local colItemListSet = Set(list[i])

		if colItemListSet[calibrateCol[1]] or colItemListSet[calibrateCol[#calibrateCol]] then
			table.insert(ans, tool.tableClone(calibrateCol))
		else
			table.insert(ans, tool.tableClone(list[i]))
		end
	end
	return ans
end

---- override
function cls:onSpinStart()
	self.isJpAnticipation = false
	self.DelayStopTime = 0
	self.isFastStop = false
	if self.boardType == self.eBoard.base then
		if self.isMapOpen then
			if self.theMapDialog then
				self.theMapDialog:exitMapScene(false, true)
				self.isMapOpen = false
			end
		end
		if self.baseScene.nCollect:isVisible() then
		   self:enableMapInfoBtn(false)
		end
		if self.isLocked then
			self.btn_unLock:setTouchEnabled(false)
		end
		if self.baseScene.tCollectTip[1]:isVisible() or self.baseScene.tCollectTip[2]:isVisible() then
			self:hideCollectTip()
		end
	end
	if self.stickWildPosData then 
		self:setStickyWildSymbol(self.stickWildPosData)
	end
	Theme.onSpinStart(self)
end

---- override
function cls:onSpinStop(ret)
	Theme.onSpinStop(self, ret)

	if ret.free_spins and (not self.ctl.freewin) then
		if ret.free_game then
		   self.freeType = ret.free_game.type
			if self.freeType > 1 then 
				if self.mapData then 
					self.freeColCnt	= self.mapData["reel_count"] > 0 and 6 or 5
					self.freeRowCnt	= self.mapData["row_count"] > 0 and 5 or 4
				   	self.freeExtraWild 	= self.mapData["extra_wild"] > 0 or false
				end
		   	end
		end
	end
end

---- abstract override
function cls:onAllReelStop()
	if self.showBaseSpinBoard then
		if self.ctl.rets.free_game or self.ctl.rets.bonus_game then
			self:enableMapInfoBtn(false)
		else
			if self.baseScene.nCollect:isVisible() then
			   self:enableMapInfoBtn(true)
			end
			if self.isLocked then
			   self.btn_unLock:setTouchEnabled(true)
			end
		end
	end
	self:clearUnanimity()-- check included
end

---- override
function cls:onReelFallBottom(col)
	if self.boardType == self.eBoard.respin then
		self:checkPlayReelTremble(col)
	end
	-- symbol notify effect
	if not self:checkPlaySymbolNotifyEffect(col) then
		self:dealMusic_PlayReelStopMusic(col)
	end
	self.reelStopMusicTagList[col] = true

	 self:stopAnticipationSpine(col) -- self:stopReelNotifyEffect(col) --
	-- local bStopAnticiMusic = true

	-- 确定下一轴是否进行Notify
	if self:checkSpeedUp(col + 1) then
		-- self:onReelNotifyStopBeg(col +1)
		self.anticipationSpine[col + 1] = self:playSpineAnimation(self.spine.anticipation, "animation", true, true, self.baseScene.aAnticipation, self:getReelLocation(col + 1, self.activeBoard:toint()))
		self:dealMusic_PlayReelNotifyMusic(col + 1)
	end
	
	if self.respinAnticipationPlan and (self.respinAnticipationPlan[col + 1] or (col == 5 and self.respinStopAnim[col])) then
		if not self.respinAnticipationSpine then 
			self.respinAnticipationSpine = self:playSpineAnimation(self.spine.respinAntici, "animation"..col, true, true, self.baseScene.aRespinAnticipation, cc.p(640, 360))
			self.respinAnticipationSpine:runAction(cc.Sequence:create(
				cc.DelayTime:create(0.5),
				cc.CallFunc:create(function ( ... )
					bole.spChangeAnimation(self.respinAnticipationSpine, "animation"..col, true)
				end)
			))
		else
			self.respinAnticipationSpine:runAction(cc.Sequence:create(
				cc.CallFunc:create(function ( ... )
					bole.spChangeAnimation(self.respinAnticipationSpine, "animation"..col.."_1", false)
				end),
				cc.DelayTime:create(0.5),
				cc.CallFunc:create(function ( ... )
					bole.spChangeAnimation(self.respinAnticipationSpine, "animation"..col, true)
				end)
			))
			
		end
		
		if self.respinStopAnim[col] then 
			self:addSpineAnimation(self.baseScene.aRespinAnticipation, nil, self:getPic("spine/bonus/baoguang"), cc.p(640, 360), "animation")
		end

		-- bStopAnticiMusic = false
		self:playMusic(self.audio_list.reel_notify2, true, true) -- self.anticipationMusic = self:playMusic_tss(self.audio_list.reel_notify, true)

	else
		self:stopRespinAnticipationSpine()
		-- if col ~= 5 then 
			-- self:stopRespinAnticipationSpine()
		-- end
	end
	-- if bStopAnticiMusic or col == #self.spinLayer.spins then
	-- 	self:stopAnticipationMusic()
	-- end
end

---- override
function cls:onReelFastFallBottom(col)
	if self.boardType == self.eBoard.respin and col == #self.spinLayer.spins then
		local tremble = nil
		for i = #self.spinLayer.spins, 1, -1 do
			if self.tremblePlan[i] then
				tremble = i
				break
			end
		end
		self:checkPlayReelTremble(tremble)
		self:fixAllItemListUpDown()
	end
	
	self.reelStopMusicTagList[col] = true

	if not self.fastStopMusicTag then
		local hasNotify = false
		for a = col, #self.spinLayer.spins do
			local reelSymbolState = self.notifyState[a]
			if reelSymbolState and bole.getTableCount(reelSymbolState) > 0 then
				hasNotify = true
				break
			end
		end
		if not hasNotify then
			self:dealMusic_PlayReelStopMusic(pCol)
		end	
	end

	self:stopRespinAnticipationSpine()

	self.fastStopMusicTag = self.fastStopMusicTag or "allow_music"
	self:checkPlaySymbolNotifyEffect(col)
	self:stopAnticipationSpine(col)
end

function cls:stopAnticipationSpine(col)-- normal anticipation, excluding respin anticipation
    if self.anticipationSpine[col] then
        self.anticipationSpine[col]:removeFromParent()
        self.anticipationSpine[col] = nil
	end
end

function cls:stopRespinAnticipationSpine()
	if bole.isValidNode(self.respinAnticipationSpine) then 
		self.respinAnticipationSpine:stopAllActions()
	end
	self.baseScene.aRespinAnticipation:removeAllChildren()
	self.respinAnticipationSpine = nil
	self:stopAnticipationMusic()
end

function cls:stopAnticipationMusic()
    self:stopMusic(self.audio_list.reel_notify2,true)
end

function cls:checkPlaySymbolNotifyEffect(col)
	local isPlaySymbolNotify = false
	self:dealMusic_StopReelNotifyMusic(pCol) -- 停止滚轴加速的声音

	local reelSymbolState = self.notifyState[col]
	if not self.fastStopMusicTag and reelSymbolState and bole.getTableCount(reelSymbolState) > 0 then
		isPlaySymbolNotify = self:dealMusic_PlaySpecialSymbolStopMusic(col)-- 判断是否播放特殊symbol的动画
	else
		if col == #self.spinLayer.spins then
			local playSymbolId = 0
			local playSymbolPriority = 0
			local notifyCheckList = { self.eSymbol.scatter1:toint() }
			for k, v in pairs(self.notifyState) do
				if bole.getTableCount(v) > 0 then
					for _, symbolId in pairs(notifyCheckList) do
						local notifyColSymbol = v[symbolId]
						if notifyColSymbol and #notifyColSymbol > 0 then
							if self.notifyMusicOrder[symbolId] and self.notifyMusicOrder[symbolId] > playSymbolPriority then
								playSymbolId = symbolId
								playSymbolPriority = self.notifyMusicOrder[symbolId]
							end
						end
					end
					self:playSymbolNotifyEffect(k, v)
					self.notifyState[k] = {}
				end
			end
			if playSymbolPriority > 0 then 
				self:playMusic(self.audio_list.anticipation)
				isPlaySymbolNotify = true
			end
		end
	end
	return isPlaySymbolNotify
end

function cls:playSymbolNotifyEffect(col, reelSymbolState)
    for itemKey, itemIndexList in pairs(reelSymbolState) do
		for _, itemIndex in pairs(itemIndexList) do
            local cellNode
			if self.fastStopMusicTag then 
				cellNode = self.spinLayer.spins[itemIndex[1]]:getRetCell(itemIndex[2])
			else
				cellNode = self.spinLayer.spins[itemIndex[1]]:getRetCell(itemIndex[2]+2)
			end
			local keyName = "symbol"..self.eSymbol.scatter1:toint()
			cellNode.notifySpine = self:playSpineAnimation(self.spine[keyName].file, self.spine[keyName]["notify"..itemKey], true, false, cellNode, cc.p(0, 0), self.const.zNotify[itemKey])
        end
    end
end

function cls:checkSpeedUp(checkCol) -- 控制出现特殊的龙 虎 预示好事发生的动画的时候 取消单个轴的 加速操作
	local isNeedSpeedUp = false
	if not self.ctl.specialSpeed and self.speedUpState and self.speedUpState[checkCol] and bole.getTableCount(self.speedUpState[checkCol])>0 then
		isNeedSpeedUp = true
	end
	return isNeedSpeedUp
end

function cls:dealMusic_PlayReelNotifyMusic( pCol ) -- 最后一列激励音效
	self:playMusic(self.audio_list.reel_notify, true, false)
	self.playR1Col = pCol
end

function cls:dealMusic_StopReelNotifyMusic( pCol )
	if not self.playR1Col then return end

	self.playR1Col = nil
	self:stopMusic(self.audio_list.reel_notify,true)
end

function cls:dealMusic_PlaySpecialSymbolStopMusic( pCol )
	self.notifyState = self.notifyState or {}
	if (not self.notifyState[pCol]) or bole.getTableCount(self.notifyState[pCol]) == 0 then 
		return false
	end
	local ColNotifyState = self.notifyState[pCol]
	local haveSymbolLevel = 2
 	if ColNotifyState[self.eSymbol.scatter1:toint()] or ColNotifyState[self.eSymbol.scatter2:toint()] then -- scatter
		if haveSymbolLevel >1 then
			haveSymbolLevel = 1
		end
		self:playSymbolNotifyEffect(pCol, ColNotifyState) -- 播放特殊symbol 下落特效
	end	

	if haveSymbolLevel<2 then 
		self:playMusic(self.audio_list.anticipation)
		self.notifyState[pCol] = {}
		return true
	else
		return false
	end
end

---- override
function cls:createCellSprite(key, col, rowIndex)
	self.recvItemList = self.recvItemList or {}
	self.recvItemList[col] = self.recvItemList[col] or {}
	self.recvItemList[col][rowIndex] = key

	local theCellFile = self.pics[key]
	if theCellFile == nil then
		-- print("symbol in function createCellSprite, key = ", key)
	end
	local theCellNode = cc.Node:create()
	local theCellSprite = bole.createSpriteWithFile(theCellFile)
	theCellNode:addChild(theCellSprite)
	theCellNode.key = key
	theCellNode.sprite = theCellSprite
	theCellNode.curZOrder = 0
	
	self:adjustWithTheCellSpriteUpdate(theCellNode, key, col)
	local theKey = theCellNode.key
	if self.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self.symbolZOrderList[theKey]
	end
	if self.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self.symbolPosAdjustList[theKey])
	end

	local ret = theCellNode
	return ret
end

---- override
-- simultaneous trueness of parameters isShowResult and isReset indicates fast stop
function cls:updateCellSprite(theCellNode, key, col, isShowResult, isReset)
	if theCellNode.aniNode then
		theCellNode.aniNode:removeAllChildren()
	end
    if theCellNode.notifySpine then
        theCellNode.notifySpine:removeFromParent()
        theCellNode.notifySpine = nil
    end

	if self.boardType == self.eBoard.respin and not self.eSymbol:respinAllow(key) then-- reset item list up and down to scatter1, scatter2, or blank in respins whence fast stop
		local a = math.random(100)
		if col == 5 then
			if a >= 50 then
				key = self.eSymbol.scatter2:toint()
			elseif a >= 10 then
				key = self.eSymbol.scatter1:toint()
			else
				key = self.eSymbol.blank:toint()
			end
		else
			if a >= 75 then
				key = self.eSymbol.scatter1:toint()
			else
				key = self.eSymbol.blank:toint()
			end
		end
	end

	local theCellFile = self.pics[key]
	if theCellFile == nil then
		-- print("symbol in function updateCellSprite, key = ", key)
	end
	local theCellSprite = theCellNode.sprite
	bole.updateSpriteWithFile(theCellSprite, theCellFile)
	theCellNode.key = key
	theCellNode.curZOrder = 0

	self:adjustWithTheCellSpriteUpdate(theCellNode, key, col, isShowResult, isReset)	
	local theKey = theCellNode.key
	if self.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self.symbolZOrderList[theKey]
	end	
	theCellSprite:setAnchorPoint(cc.p(0.5, 0.5))
	if self.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self.symbolPosAdjustList[theKey])
	else
		theCellSprite:setPosition(cc.p(0, 0))
	end	
end

function cls:adjustWithTheCellSpriteUpdate(theCellNode, key, col, isShowResult, isReset)
	if self.hasUnanimity and not isShowResult then
		local i = nil
		for j = 1, #self.stack_reel_list do
			if self.stack_reel_list[j] == col then
				i = j
				break
			end
		end
		if i ~= nil then
			theCellNode.key = self.stack_symbol_list[i]
		end
	end
end

-- function cls:setMapFreeReelSymbol(col_counts, row_counts)
-- 	for i = 1, col_counts do
-- 		for j = 1, row_counts do
-- 			local cell = self.spinLayer.spins[i]:getRetCell(j)
-- 			local key = math.random(1, 8)
-- 			self:updateCellSprite(cell, key, i, true)
-- 		end
-- 	end
-- end

---- override
function cls:adjustTheme(data)
	self:changeSpinBoard(self.eBoardId.base)
	if data.free_game then
		if data.bonus_game then
	       self.isMapFreeTriggerState = true
	    end
	end
end

---- config
function cls:adjustEnterThemeRet(data)
    if data.bonus_game or data.free_game then
        self.bDontShowInitPopup = true
	end
	
    data.theme_reels = {
        main_reel = {
            {6,7,8,2,2,2,2,9,10,6,3,3,3,3,7,8,9,4,4,4,4,10,6,7,5,5,5,5,8,9,10,6,6,6,6,2,8,5,7,7,7,7,3,9,4,8,8,8,8,2,10,5,9,9,9,9,3,6,4,10,10,10,10,2,7,8,5,12,12,12,12,12,12,12,12,9,10,3,7,8,4,9,10,6,7,8,2,7,8,5,9,10,3,7,8,4,6,12,12,12,12,12,12,12,12,9,10,2,7,8,5,9,10,3,7,8,4,9,10,6,2,7,8,5,9,10,3,7,8,4,9,10,6,24,23,22,21},
            {9,10,6,2,2,2,2,6,7,8,3,3,3,3,10,6,7,4,4,4,4,7,8,9,5,5,5,5,10,9,8,6,6,6,6,3,8,4,7,7,7,7,2,9,5,8,8,8,8,3,10,4,9,9,9,9,2,6,5,10,10,10,10,3,7,8,4,12,12,12,12,12,12,12,12,9,10,2,7,8,5,9,10,6,7,8,3,7,8,4,9,10,2,7,8,5,6,12,12,12,12,12,12,12,12,9,10,3,7,8,4,9,10,2,7,8,5,9,10,6,3,7,8,4,9,10,2,7,8,5,9,10,6,24,23,22,21},
            {6,7,8,2,2,2,2,9,10,6,3,3,3,3,7,8,9,4,4,4,4,10,6,7,5,5,5,5,8,9,10,6,6,6,6,2,8,5,7,7,7,7,3,9,4,8,8,8,8,2,10,5,9,9,9,9,3,6,4,10,10,10,10,2,7,8,5,12,12,12,12,12,12,12,12,9,10,3,7,8,4,9,10,6,7,8,2,7,8,5,9,10,3,7,8,4,6,12,12,12,12,12,12,12,12,9,10,2,7,8,5,9,10,3,7,8,4,9,10,6,2,7,8,5,9,10,3,7,8,4,9,10,6,24,23,22,21},
            {9,10,6,2,2,2,2,6,7,8,3,3,3,3,10,6,7,4,4,4,4,7,8,9,5,5,5,5,10,9,8,6,6,6,6,3,8,4,7,7,7,7,2,9,5,8,8,8,8,3,10,4,9,9,9,9,2,6,5,10,10,10,10,3,7,8,4,12,12,12,12,12,12,12,12,9,10,2,7,8,5,9,10,6,7,8,3,7,8,4,9,10,2,7,8,5,6,12,12,12,12,12,12,12,12,9,10,3,7,8,4,9,10,2,7,8,5,9,10,6,3,7,8,4,9,10,2,7,8,5,9,10,6,24,23,22,21},
            {6,7,8,2,2,2,2,9,10,6,3,3,3,3,7,8,9,4,4,4,4,10,6,7,5,5,5,5,8,9,10,6,6,6,6,2,8,5,7,7,7,7,3,9,4,8,8,8,8,2,10,5,9,9,9,9,3,6,4,10,10,10,10,2,7,8,5,12,12,12,12,12,12,12,12,9,10,3,7,8,4,9,10,6,7,8,2,7,8,5,9,10,3,7,8,4,6,12,12,12,12,12,12,12,12,9,10,2,7,8,5,9,10,3,7,8,4,9,10,6,2,7,8,5,9,10,3,7,8,4,9,10,6,24,23,22,21}
        },
        free_reel = {
        	{6,7,8,2,2,2,2,9,10,6,3,3,3,3,7,8,9,4,4,4,4,10,6,7,5,5,5,5,8,9,10,6,6,6,6,2,8,5,7,7,7,7,3,9,4,8,8,8,8,2,10,5,9,9,9,9,3,6,4,10,10,10,10,2,7,8,5,9,10,3,7,8,4,9,10,6,7,8,2,7,8,5,9,10,3,7,8,4,6,9,10,2,7,8,5,9,10,3,7,8,4,9,10,6,2,7,8,5,9,10,3,7,8,4,9,10,6,21,22,23,24},
			{9,10,6,2,2,2,2,6,7,8,3,3,3,3,10,6,7,4,4,4,4,7,8,9,5,5,5,5,10,9,8,6,6,6,6,3,8,4,7,7,7,7,2,9,5,8,8,8,8,3,10,4,9,9,9,9,2,6,5,10,10,10,10,3,7,8,4,9,10,2,7,8,5,9,10,6,7,8,3,7,8,4,9,10,2,7,8,5,6,9,10,3,7,8,4,9,10,2,7,8,5,9,10,6,3,7,8,4,9,10,2,7,8,5,9,10,6,21,22,23,24},
			{6,7,8,2,2,2,2,9,10,6,3,3,3,3,7,8,9,4,4,4,4,10,6,7,5,5,5,5,8,9,10,6,6,6,6,2,8,5,7,7,7,7,3,9,4,8,8,8,8,2,10,5,9,9,9,9,3,6,4,10,10,10,10,2,7,8,5,9,10,3,7,8,4,9,10,6,7,8,2,7,8,5,9,10,3,7,8,4,6,9,10,2,7,8,5,9,10,3,7,8,4,9,10,6,2,7,8,5,9,10,3,7,8,4,9,10,6,21,22,23,24},
			{9,10,6,2,2,2,2,6,7,8,3,3,3,3,10,6,7,4,4,4,4,7,8,9,5,5,5,5,10,9,8,6,6,6,6,3,8,4,7,7,7,7,2,9,5,8,8,8,8,3,10,4,9,9,9,9,2,6,5,10,10,10,10,3,7,8,4,9,10,2,7,8,5,9,10,6,7,8,3,7,8,4,9,10,2,7,8,5,6,9,10,3,7,8,4,9,10,2,7,8,5,9,10,6,3,7,8,4,9,10,2,7,8,5,9,10,6,21,22,23,24},
			{6,7,8,2,2,2,2,9,10,6,3,3,3,3,7,8,9,4,4,4,4,10,6,7,5,5,5,5,8,9,10,6,6,6,6,2,8,5,7,7,7,7,3,9,4,8,8,8,8,2,10,5,9,9,9,9,3,6,4,10,10,10,10,2,7,8,5,9,10,3,7,8,4,9,10,6,7,8,2,7,8,5,9,10,3,7,8,4,6,9,10,2,7,8,5,9,10,3,7,8,4,9,10,6,2,7,8,5,9,10,3,7,8,4,9,10,6,21,22,23,24},
		},
		bonus_reel = {
			{11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0},
			{11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 12, 12, 12, 12, 12, 0, 0, 0, 0, 0, 0, 0, 0}
		}
	}

	-- feature unanimity
	self.rawMainReel = tool.tableClone(data.theme_reels.main_reel)
	self.rawFreeReel = tool.tableClone(data.theme_reels.free_reel)
    
	if data.map_info then
		self.mapPoints = data.map_info.map_points
	    self.mapLevel = data.map_info.map_level
	    self.mapData = {}
	    self.mapData.extra_fg = data.map_info.extra_fg
	    self.mapData.extra_wild = data.map_info.extra_wild
	    self.mapData.reel_count = data.map_info.reel_count
	    self.mapData.row_count = data.map_info.row_count
	    self.mapData.sticky_wild = data.map_info.sticky_wild
	    self.map_avg_bet = data.map_info.avg_bet
	end

	if data.free_game then
    	if data.free_game.type then
			if data.free_game.free_spins and data.free_game.free_spins >= 0 then
	    		self.freeType = data.free_game.type
	    		if self.freeType == 1 then
			    	self.showFreeSpinBoard = true
			    end
	    		if self.freeType and self.freeType > 1 then
			   		self.mapPoints = self.maxMapPoints
			   		if self.mapData then 
			   			self.freeColCnt	= self.mapData["reel_count"] > 0 and 6 or 5
						self.freeRowCnt	= self.mapData["row_count"] > 0 and 5 or 4
			   			self.freeExtraWild 	= self.mapData["extra_wild"] > 0 or false
			   		end
			   	   
			   	end

			   	if data["bonus_game"] then 
		    		if data["bonus_game"]["type"] and data["bonus_game"]["type"] ~= 1 then -- 不是 respin 
		    			data["first_free_game"] = {}
		    			data["first_free_game"]["free_spins"] 		= data["free_game"]["free_spins"]
		 				data["first_free_game"]["free_spin_total"] 	= data["free_game"]["free_spin_total"]
		 				data["first_free_game"]["base_win"] 		= data["free_game"]["base_win"]
		 				data["first_free_game"]["total_win"] 		= data["free_game"]["total_win"]
		 				data["first_free_game"]["bet"] 				= data["free_game"]["bet"]
		 				data["first_free_game"]["item_list"] 		= data["free_game"]["item_list"]
		 				data["first_free_game"]["type"] 			= data["free_game"]["type"]
		    			data["free_game"] = nil
		    		end
		    	end
			end
    	end
    end

	self.collectEnableBet = data.bonus_level
	self.enterThemeSWPos = (data.map_info ~= nil and data.map_info.sticky_wild == 1) and tool.tableClone(data.map_info.sticky_wild_pos) or {}
	return data
end

function cls:clearUnanimity()
	if self.hasUnanimity then
		self.stack_symbol_list = nil
		self.stack_reel_list = nil
		self.hasUnanimity = false
	end
end
------------------------------endregion------------------------------



------------------------------region random wild------------------------------
function cls:setStickyWildSymbol(newStickyWildPos, isResume)
	self.baseScene.stickyAnimate:removeAllChildren()

	for _, stickData in pairs(newStickyWildPos) do 
		local posData = stickData[1]
		local pos = self:getCellPos(posData[1], posData[2])
		local key = stickData[2]
		local spriteName = "#theme164_s_"..key..".png"
		local sprite = bole.createSpriteWithFile(spriteName)
		self.baseScene.stickyAnimate:addChild(sprite, posData[2])
		sprite:setPosition(pos)
	end
end 

function cls:getPlayRandomWildAnimTime( newRandWildPos )
	if not newRandWildPos then return 0 end
	return self.const.delStickyWildWhole * 2 + #newRandWildPos * self.const.delStickyWildEach
end

function cls:setRandWildSymbol(newRandWildPos)
	local spineFile = self.spine.randomWild
	local spriteName = "#theme164_s_"..self.eSymbol.wild:toint()..".png"
	-- self.haveSpecialdelay = true
	local _startDelay = self.speicalDelay or 0
	-- self.speicalDelay = (self.speicalDelay or 0) + self.const.delStickyWildWhole * 2 + #newRandWildPos * self.const.delStickyWildEach
	self.randWildSList = {}
	self.randomWildSymbol = {}
	local delay2 = #newRandWildPos * self.const.delStickyWildEach
	self:dealMusic_FadeLoopMusic(0.2, 1, 0.3)
	self.baseScene.stickyMask:setOpacity(0)
	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(_startDelay),
		cc.CallFunc:create(function()
			self.baseScene.stickyMask:runAction(cc.FadeTo:create(self.const.delStickyWildWhole, self.const.stickyMaskOpacity))
		end),
		cc.DelayTime:create(self.const.delStickyWildWhole),
		cc.CallFunc:create(function()
			local delay = 0
			for k, posData in pairs(newRandWildPos) do
				if posData then
					self:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(function()
						self:playMusic(self.audio_list.wild_land)
						local a = posData[1]
						local b = posData[2]
						if self.randWildSList then 
							self.randWildSList[a] = self.randWildSList[a] or {}
							self.randWildSList[a][b] = self:playSpineAnimation(spineFile, "animation", false, false, self.baseScene.aRandom, self:getCellPos(a, b))
						else
						end
						
						if self.randomWildSymbol then 
							local sprite = bole.createSpriteWithFile(spriteName)
							self.baseScene.nRandomSprite:addChild(sprite, 0)
							sprite:setPosition(self:getCellPos(a, b))
							
							self.randomWildSymbol[a] = self.randomWildSymbol[a] or {}
							self.randomWildSymbol[a][b] = sprite
						else
						end
					end)))
					delay = delay + self.const.delStickyWildEach
				end
			end
		end),
		cc.DelayTime:create(delay2),
		cc.CallFunc:create(function ()
			self.baseScene.stickyMask:runAction(cc.FadeTo:create(self.const.delStickyWildWhole, 0))
			self:dealMusic_FadeLoopMusic(0.2, 0.3, 1)
		end)
	))
end
------------------------------endregion------------------------------



------------------------------region collect------------------------------
local mapLevelConfig = {5, 5, 1, 5, 5, 5, 2, 5, 5, 5, 5, 3, 5, 5, 5, 5, 5, 4}

function cls:setNextCollectTargetImage(level)
	level = level + 1
	if level > self.maxMapLevel then
	   level = 1
	end
	
	for i = 1, 5 do
		self.baseScene.iNextLevel[i]:setVisible(i == mapLevelConfig[level])
	end
end

function cls:setCollectProgressImagePos(map_points)
	if map_points > self.maxMapPoints then
		map_points = self.maxMapPoints
	elseif map_points < 0 then
		map_points = 0
	end

	local cur_posX = self.movePerUnit * map_points + self.progressStartPosX
	self.baseScene.progressBar:setPosition(cc.p(cur_posX, self.progressPosY))
	self.baseScene.aCollectFrontGlimming:setPosition(cc.p(cur_posX, self.progressPosY))
end

function cls:showProgressAnimation(map_points, isFull)
	if map_points > self.maxMapPoints then
		map_points = self.maxMapPoints
	elseif map_points < 0 then
		map_points = 0
	end
	if self.mapPoints == nil then
		self.mapPoints = 0
	end

	local oldPosX = self.movePerUnit * self.mapPoints + self.progressStartPosX
	local startPos = cc.p(oldPosX, self.progressPosY)
	local newPosX = self.movePerUnit * map_points + self.progressStartPosX
	local endPos = cc.p(newPosX, self.progressPosY)
	self.mapPoints = map_points
	self.baseScene.progressBar:setPosition(startPos)
	self.baseScene.progressBar:runAction(cc.MoveTo:create(0.5, endPos))
	self.baseScene.aCollectFrontGlimming:setPosition(startPos)
	self.baseScene.aCollectFrontGlimming:runAction(cc.MoveTo:create(0.5, endPos))

	local file = self:getPic("spine/progress/shoujitiaolizi")
	local _, s1 = self:addSpineAnimation(self.baseScene.aCollectFrontGlimming, 2, file, cc.p(345, 0), "animation")
	self:laterCallBack(0.5, function()
		if isFull then
			self:playCollectibleProgressBrim()
		end
	end)	
end

function cls:adjustProgressBar(mapPoints, bMute)
	if mapPoints > self.maxMapPoints then
		mapPoints = self.maxMapPoints
	elseif mapPoints < 0 then
		mapPoints = 0
	end

	if bMute then
		local cur_posX = self.movePerUnit * map_points + self.progressStartPosX
		self.baseScene.progressBar:setPosition(cc.p(cur_posX, self.progressPosY))
		self.baseScene.aCollectFrontGlimming:setPosition(cc.p(cur_posX, self.progressPosY))
	else
		local oldPosX = self.movePerUnit * self.mapPoints + self.progressStartPosX
		local startPos = cc.p(oldPosX, self.progressPosY)
		local newPosX = self.movePerUnit * mapPoints + self.progressStartPosX
		local endPos = cc.p(newPosX, self.progressPosY)
		self.mapPoints = mapPoints
		self.baseScene.progressBar:setPosition(startPos)
		self.baseScene.progressBar:runAction(cc.MoveTo:create(0.5, endPos))
		self.baseScene.aCollectFrontGlimming:setPosition(startPos)
		self.baseScene.aCollectFrontGlimming:runAction(cc.MoveTo:create(0.5, endPos))
	end
end

function cls:playCollectibleProgressBrim()
	self:playMusic(self.audio_list.full)
	local aCollectibleBrim = self:playSpineAnimation(self:getPic("spine/progress/jiman"), "animation", true, true, self.baseScene.aFrameBrim, cc.p(0, 0), self.const.aCollectibleBrimZorder)
	aCollectibleBrim:runAction(cc.Sequence:create(
		cc.DelayTime:create(self.const.delCollectibleBrim),
		cc.RemoveSelf:create()
	))
end

function cls:showCoinsFlyToUp()
	self.baseScene.aCollectibleFly:removeAllChildren()
	self.flyCoinSkeleton = {}
	local item_list = self.item_list
	local endPos = cc.p(238, 574)
	local isPlay = false
	local isFly = false
	local spine_file = self:getPic("spine/symbol/scatter")

	self:playMusic(self.audio_list.symbol_fly)
	for i = 1, #item_list do 
		for j = 1, #item_list[i] do
			if self.eSymbol:isCollectible(item_list[i][j]) then
				local node = cc.Node:create()
				local pos = self:getCellPos(i, j)
				node:setPosition(pos)
				self.baseScene.aCollectibleFly:addChild(node, j)
				
				local pFile = self:getPic("particles/jinbituowei_01_1.plist")
				local pPos = cc.p(0, 0)
				local lizi = cc.ParticleSystemQuad:create(pFile)
				lizi:setPosition(pPos)
				node:addChild(lizi, 10)
				
				local spine_pos = cc.p(0, 0)

				self:runAction(cc.Sequence:create(
					cc.CallFunc:create(function()
						local _, s = self:addSpineAnimation(node, nil, spine_file, spine_pos, "animation4", nil, nil, nil, true, false, nil)
						self.flyCoinSkeleton[i.."_"..j]  = s                   
					end),
					cc.DelayTime:create(6/30),
					cc.CallFunc:create(function()
						if not tolua.isnull(self.flyCoinSkeleton[i.."_"..j]) then
						   -- self.flyCoinSkeleton[i.."_"..j]:setAnimation(0, "animation2", false)
						   self:parabolaToAnimation(node, i, j, pos, endPos, 19/30)
						end
						-- if not isFly then
						-- 	isFly = true
						    
						-- end
						if bole.isValidNode(lizi) then 
							lizi:runAction(cc.ScaleTo:create(19/30, 0.4, 0.4))
						end
					end),
					cc.DelayTime:create(19/30),
					cc.CallFunc:create(function()
						if not isPlay then
							isPlay = true
							local parent = self.baseScene.aCollectibleLand
							local file = self:getPic("spine/progress/jinzitajieshou")
							local pos = cc.p(0, 0)
							self:addSpineAnimation(parent, 10, file, pos, "animation")
						end
					end)
				))
			end
		end
	end	
end

function cls:parabolaToAnimation(obj, col, row, from, to, duration)
	local radian_config = 
	{
	   {{-50, 50}, {-50, 60}, {-50, 75}, {-50, 75}},
	   {{-60, 30}, {-60, 40}, {-60, 55}, {-60, 55}},
	   {{-70, -30}, {-70, -40}, {-70, -55}, {-70, -55}},
	   {{-80, -50}, {-80, -60}, {-80, -75}, {-80, -75}},
	   {{-90, -50}, {-90, -60}, {-90, -75}, {-90, -75}},
    }
	local from = from or self:getCellPos(col, row)
	local to = to or cc.p(0, 0)
	local config = radian_config[col][row]

	local myBezier = function (p0, p1, p2, duration, frame)
		local t = frame / duration
		if t > 1 then t = 1 end
		local x = math.pow(1-t, 2) * p0.x + 2 * t*(1-t) * p1.x + math.pow(t, 2) * p2.x
		local y = math.pow(1-t, 2) * p0.y + 2*t*(1-t)*p1.y + math.pow(t, 2)*p2.y

		return cc.p(x, y)
	end

	local cp = cc.p(from.x + config[1], from.y + config[2])
	local frame = 1

	obj:runAction(cc.Repeat:create(
		cc.Sequence:create(
			cc.CallFunc:create(function () 
				frame = frame or 1
				local pos = myBezier(from, cp, to, duration*60, frame)
				obj:setPosition(pos)
				frame = frame + 1
			end),
			cc.DelayTime:create(1/60)
		), duration*60
	))
end

function cls:enableMapInfoBtn(enable)
	self.baseScene.bMapInfo:setVisible(true)
	self.baseScene.bMapInfo:setTouchEnabled(enable)
	self.baseScene.bMapInfo:setBright(enable)
    local function initBtnEvent()
		local pressFunc = function(obj)
			if self.boardType == self.eBoard.respin then
				
			else
				self.baseScene.bMapInfo:setTouchEnabled(false)
				self.baseScene.bMapInfo:setBright(false)
				self:playMusic(self.audio_list.common_click)
				self.theMapDialog = FireFortuneMapGame.new(self, self:getPic("csb/"), {
					mapLevel = self.mapLevel, mapInfo = self.mapData
				})
				self.theMapDialog:showMapScene(false)
			end
	    end
		self.baseScene.bMapInfo:addTouchEventListener(function(obj, eventType)
			if eventType == ccui.TouchEventType.ended then
				pressFunc(obj)
			end
		end)
	end

	if enable then
		initBtnEvent()
	end
end

function cls:setCollectPartState(active, isAnimate)
	local function initCollectBtnEvent()
		local pressFunc = function(obj)
			self.btn_unLock:setVisible(false)
	        self.btn_unLock:setTouchEnabled(false)
            self:setBet()
	        self:setCollectPartState(true, true)
		end
		local function onTouch(obj, eventType)
			if eventType == ccui.TouchEventType.ended then
				pressFunc(obj)
			end
		end
		self.btn_unLock:addTouchEventListener(onTouch)
	end
	self.baseScene.pCollect:setVisible(active)
	if active then
		self.btn_unLock:setTouchEnabled(false)
		self.btn_unLock:setVisible(false)
		self.isLocked = false
	    
		local aniName = "animation1"
		self:playMusic(self.audio_list.unlock)
	    if self.collectLockSkeleton then
		   self.collectLockSkeleton:setAnimation(0, aniName, false)
		else
			self.collectLockSkeleton = self:playSpineAnimation(self:getPic("spine/progress/jdtjs_01"), aniName, true, false, self.baseScene.aLock, cc.p(0, 0))
	    end
	    local tipScaleY = self.baseScene.nCollectTip:getScaleY()
	    local backDelay = 0
	    if tipScaleY > 0 then
	    	backDelay = 0.3
	    end
	    self:runAction(cc.Sequence:create(
	    	cc.CallFunc:create(function()
	    		if tipScaleY > 0 then
	    			self:hideCollectTip()
	    		end
	    	end),
	    	cc.DelayTime:create(backDelay),
	    	cc.CallFunc:create(function()
	    		self:showCollectTip(1)
	            self:enableCollectTipBtn(true, 1)
	    	end)
		))
	else
		local aniName = ""
		if isAnimate then
			aniName = "animation3"
		else
			aniName = "animation2"
		end

		self.isLocked = true

        if isAnimate then
        	self:playMusic(self.audio_list.lock)
        end

		if self.collectLockSkeleton then
		   self.collectLockSkeleton:setAnimation(0, aniName, false)
		else
			self.collectLockSkeleton = self:playSpineAnimation(self:getPic("spine/progress/jdtjs_01"), aniName, true, false, self.baseScene.aLock, cc.p(0, 0))
	    end
	    
	    local maxBet = self.ctl:getMaxBet()
	    if maxBet >= self.collectEnableBet then
	    	self.btn_unLock:setVisible(true)
	        self.btn_unLock:setTouchEnabled(true)
			initCollectBtnEvent()
        end

        self:enableCollectTipBtn(false, 1)
	end
end

function cls:resetMapInfoData()
	self.mapData = {}
    self.mapData.extra_fg = 0
    self.mapData.extra_wild = 0
    self.mapData.reel_count = 0
    self.mapData.row_count = 0
    self.mapData.sticky_wild = 0
end

-- collect Tip related
function cls:showCollectTip(state)
	state = state or 1
	for i = 1, 2 do
	    self.baseScene.tCollectTip[i]:setVisible(i == state)
	end
	self.baseScene.nCollectTip:stopAllActions()
	self.baseScene.nCollectTip:setScale(1, 0)
	self.baseScene.nCollectTip:setVisible(true)
	self:playMusic(self.audio_list.tips)
	self.baseScene.nCollectTip:runAction(cc.Sequence:create(
		cc.ScaleTo:create(0.2, 1, 1.3),
		cc.ScaleTo:create(0.1, 1, 1),
		cc.DelayTime:create(5),
		cc.CallFunc:create(function()
			self:hideCollectTip()
		end)
	))
end

function cls:hideCollectTip()
	for i = 1, 2 do
		self.baseScene.tCollectTip[i]:setVisible(false)
	end
	self.baseScene.nCollectTip:stopAllActions()
	self.baseScene.nCollectTip:setScale(1, 1)
	self.baseScene.nCollectTip:setVisible(true)
	self:playMusic(self.audio_list.tips)
	self.baseScene.nCollectTip:runAction(cc.Sequence:create(
		cc.ScaleTo:create(0.1, 1, 1.2),
		cc.ScaleTo:create(0.2, 1, 0),
		cc.Hide:create()
	))
end

function cls:enableCollectTipBtn(enable, state)
	if enable then
		self.btn_collectTip:setVisible(true)
		self.btn_collectTip:setTouchEnabled(true)
		self:initBtnCollectEvent(state)
	else
		self.btn_collectTip:setVisible(false)
		self.btn_collectTip:setTouchEnabled(false)
		local tipScaleY = self.baseScene.nCollectTip:getScaleY()
		if tipScaleY > 0 then
			self:hideCollectTip()
		end
	end
end

function cls:initBtnCollectEvent(state)
	local pressFunc = function(obj)
        self.btn_collectTip:setTouchEnabled(false)
        local tipScaleY = self.baseScene.nCollectTip:getScaleY()
        self:runAction(cc.Sequence:create(
        	cc.CallFunc:create(function()
        		if tipScaleY ==0 then
        			self:showCollectTip(state)
        		else
        			self:hideCollectTip()
        		end
        	end),
        	cc.DelayTime:create(0.35),
        	cc.CallFunc:create(function()
				self.btn_collectTip:setTouchEnabled(true)
				if state == 2 then
					state = 1 
				end
				self:enableCollectTipBtn(true, state)
        	end)
        ))
    end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end

	self.btn_collectTip:addTouchEventListener(onTouch)
end

function cls:dealAboutBetChange(theBet, isPointBet)
	if self.currentBet then
		local recordBet = self.currentBet
		self.currentBet = theBet
		local currentState = self.currentBet >= self.collectEnableBet
		if (recordBet >= self.collectEnableBet) ~= currentState then
			if currentState then
				self:setCollectPartState(true, true)
			else
				self:setCollectPartState(false, true)
			end
		end
	end
end

function cls:setBet()
	local set_Bet = self.collectEnableBet
	self.ctl:setCurBet(set_Bet)
end

function cls:getRollUpBet(ret)
	local tb = nil
	if not self.showFreeSpinBoard and not self.showBaseSpinBoard then
		tb = self.map_avg_bet
	end
       
	return tb
end

------------------------------region symbol animations------------------------------
---- override
function cls:genSpecialSymbolState(rets)
	rets = rets or self.ctl.rets
	if not self.notifyState then
		local il = rets.item_list
		self.speedUpState = {}
		self.notifyState = {}
		self.playBonusList = {}
		for key, config in pairs(self.specialItemConfig) do
			if config.type == self.eSymbolNotify.columnSum then
				local satisfyCol = 0
				local colNum = #self.spinLayer.spins
				local noSpeedUp = false
				for col = 1, colNum do
					local colLeft = colNum - col + 1
					if config.minColumnCount > colLeft + satisfyCol then
						noSpeedUp = true
					end
					if config.minColumnCount <= satisfyCol + 1 and not noSpeedUp then
						self.speedUpState[col] = self.speedUpState[col] or {}
						self.speedUpState[col][config.symbol] = true
					end
					if config.columnSatisfy(il[col], col, config.symbol) and not noSpeedUp then--in respin, only notify when anticipation
						satisfyCol = satisfyCol + 1
						if self.boardType == self.eBoard.respin then
							self.notifyState[col] = self.notifyState[col] or {}
							local scatterKey = il[col][1]
							self.notifyState[col][scatterKey] = {}
							for i = 1, #il[col] do
								table.insert(self.notifyState[col][scatterKey], { col, i })
							end
						end

						if self.boardType == self.eBoard.base then--in base game, every scatter1 is collectible
							self.notifyState[col] = self.notifyState[col] or {}
							self.notifyState[col][config.symbol] = config.checkColumnNotify(il[col], col, config.symbol)

							self.playBonusList[col] = config.checkColumnNotify(il[col], col, config.symbol)
						end

					end
				end
			elseif config.type == self.eSymbolNotify.collectible then
				for col = 1, #self.spinLayer.spins do
					self.notifyState[col] = self.notifyState[col] or {}
					self.notifyState[col][key] = {}
					for row = 1, self.spinLayer.spins[col].row do
						if il[col][row] == config.symbol then
							table.insert(self.notifyState[col][key], {col, row})
						end
					end
				end
			end
		end
	end
	if self.boardType == self.eBoard.respin and self.respinAnticipationPlan == nil then
		self:genRespinAnticipation(rets.item_list)
	end
	-- libDebug.printTable("whj: self.notifyState ", self.notifyState)
end

function cls:genRespinAnticipation(il)
	self.respinAnticipationPlan = {}
	self.tremblePlan = {}
	self.respinStopAnim = {}
	local satisfyCol = 0
	local s1 = self.eSymbol.scatter1:toint()
	local s2 = self.eSymbol.scatter2:toint()
	local length = #self.spinLayer.spins
	for i = 1, length do
		self.respinAnticipationPlan[i] = i ~= 1
		self.respinStopAnim[i] = true
	end

	for col = 1, length do
		local symbols = il[col]
		local fillWithS1 = true
		local fillWithS2 = col == length
		for i = 1, #symbols do
			fillWithS1 = fillWithS1 and (symbols[i] == s1)
			fillWithS2 = fillWithS2 and (symbols[i] == s2)
		end
		local b = fillWithS1 or fillWithS2
		if satisfyCol >= 2 and b then
			self.tremblePlan[col] = true
		end
		if b then
			satisfyCol = satisfyCol + 1
		else
			for i = col + 1, length do
				self.respinAnticipationPlan[i] = false
			end
			for i = col, length do
				self.respinStopAnim[i] = false
			end
		end
	end
	self.bonus.satisfyCol = satisfyCol
end

function cls:playCellRoundEffect(parent)
	self:addSpineAnimation(parent, nil, self:getPic("spine/kuang/spine"), cc.p(0,0), "animation", nil, nil, nil, true, true, nil)
end

---- override
function cls:drawLinesThemeAnimate(lines, layer, rets, specials)
	self.animNodeList = self.animNodeList or {}
	local timeList = {2, 2}
	Theme.drawLinesThemeAnimate(self, lines, layer, rets, specials, timeList)
end

---- override
function cls:getItemAnimate(item, col, row, effectStatus, parent)
	local spineItemsSet = Set({2, 3, 4, 5, 6, 7, 1, 11})
	if self.stickWildPosF and self.stickWildPosF[col] and self.stickWildPosF[col][row]  then -- self.stickyWildSList and self.stickyWildSList[col] and self.stickyWildSList[col][row] then
		if effectStatus == "all_first" and self.animNodeList["sw"..col.."_"..row] == nil then
			if self.stickWildPosF[col][row] == 1 then 
				self.animNodeList["sw"..col.."_"..row] = self:playSpineAnimation(self.spine.symbol1.file, self.spine.symbol1.win, true, false, self.animateNode, self:getCellPos(col, row), self.const.zWin[self.eSymbol.wild:toint()] or 0)
			else
				local endStickRow
				local stickSpineName
				if self.stickWildPosF[col][row] < 25 then 
					endStickRow = 4
					stickSpineName = self.spine.symbol1.win4
				else
					endStickRow = 5
					stickSpineName = self.spine.symbol1.win5
				end
				local lWildSpine = self:playSpineAnimation(self.spine.symbol1.file, stickSpineName, true, false, self.animateNode, self:getReelLocation(col, self.activeBoard:toint()), self.const.zWin[self.eSymbol.wild:toint()] or 0)
				for _stickRow = 1, endStickRow do 
					self.animNodeList["sw"..col.."_".._stickRow] = lWildSpine
				end
			end
		else
			if self.stickWildPosF[col][row] == 1 then 
				if self.animNodeList["sw"..col.."_"..row] then
					self.animNodeList["sw"..col.."_"..row]:setAnimation(0, self.spine.symbol1.win, false)
				end
			else
				if self.animNodeList["sw"..col.."_"..row] then
					local animName = self.stickWildPosF[col][row] < 25 and self.spine.symbol1.win4 or self.spine.symbol1.win5
					self.animNodeList["sw"..col.."_"..row]:setAnimation(0, animName, false)
				end
			end
		end
		self.spinLayer.spins[col]:getRetCell(row):setVisible(false)
	elseif self.randomWildSymbol and self.randomWildSymbol[col] and self.randomWildSymbol[col][row] then 
		if effectStatus == "all_first" and self.animNodeList["rw"..col.."_"..row] == nil then
			self.animNodeList["rw"..col.."_"..row] = self:playSpineAnimation(self.spine.symbol1.file, self.spine.symbol1.win, true, false, self.animateNode, self:getCellPos(col, row), self.const.zWin[item] or 0)
		else
			if self.animNodeList["rw"..col.."_"..row] then
				self.animNodeList["rw"..col.."_"..row]:setAnimation(0, self.spine.symbol1.win, false)
			end
		end
		self.spinLayer.spins[col]:getRetCell(row):setVisible(false)
		return nil
	elseif spineItemsSet[item] then --normal symbol win animation
		if effectStatus == "all_first" and self.animNodeList[col.."row"..row] == nil then
			self.animNodeList[col.."_"..row] = self:playSpineAnimation(self.spine["symbol"..item].file, self.spine["symbol"..item].win, true, false, self.animateNode, self:getCellPos(col, row), self.const.zWin[item] or 0)
		else
			if self.animNodeList[col.."_"..row] then
				self.animNodeList[col.."_"..row]:setAnimation(0, self.spine["symbol"..item].win, false)
			end
		end
		self.spinLayer.spins[col]:getRetCell(row):setVisible(false)
		return nil
	elseif self.eSymbol:isWild4(item) then
		if effectStatus == "all_first" and self.animNodeList["wild"..col] == nil then
			self.animNodeList["wild"..col] = self:playSpineAnimation(self.spine.symbol1.file, self.spine.symbol1.win4, true, false, self.animateNode, self:getReelLocation(col, self.activeBoard:toint()), self.const.zWin[item] or 0)
		else
			if self.animNodeList["wild"..col] then
				self.animNodeList["wild"..col]:setAnimation(0, self.spine.symbol1.win4, false)
			end
		end
		self.spinLayer.spins[col]:getRetCell(row):setVisible(false)
		return nil
	elseif self.eSymbol:isWild5(item) then
		if effectStatus == "all_first" and self.animNodeList["wild"..col] == nil then
			self.animNodeList["wild"..col] = self:playSpineAnimation(self.spine.symbol1.file, self.spine.symbol1.win5, true, false, self.animateNode, self:getReelLocation(col, self.activeBoard:toint()), self.const.zWin[item] or 0)
		else
			if self.animNodeList["wild"..col] then
				self.animNodeList["wild"..col]:setAnimation(0, self.spine.symbol1.win5, false)
			end
		end
		self.spinLayer.spins[col]:getRetCell(row):setVisible(false)
		return nil
	else
		return self:playSAllAnimation(item, col)
	end
end

---- override
function cls:playSAllAnimation(item, col)
	local fs = 60
	local objOp = 0
	local animate = cc.Sequence:create( 
		cc.DelayTime:create(2/fs),
		cc.ScaleTo:create(26/fs, 1.15),
		cc.DelayTime:create(2/fs), 
		cc.ScaleTo:create(26/fs, 1),
		cc.DelayTime:create(2/fs)
	)
	return cc.Sequence:create(animate, animate:clone())
end

---- override
function cls:cleanStatus() -- only clean when spinning
	self.baseScene.aRandom:removeAllChildren()
	self.randWildSList = nil
	self.baseScene.nRandomSprite:removeAllChildren()
	self.randomWildSymbol = nil
	Theme.cleanStatus(self)
end

---- override
function cls:stopDrawAnimate() -- possible mannual call
	if self.stickyWildSList then 
		for col, list in pairs(self.stickyWildSList) do 
			for row, item in pairs(list) do 
				bole.changeSpineNormal(item, "animation4", false)
			end
		end
	end
	self.speicalDelay = 0
	self.haveSpecialdelay = false
	self.animNodeList = nil
	Theme.stopDrawAnimate(self)
	self:stopRespinAnticipationSpine()
end

-- function cls:playTransition()
-- 	self.node_Transition = nil
-- 	self.node_Transition = cc.Node:create()
-- 	self.curScene:addToContentFooter(self.node_Transition)
-- 	self:runAction(cc.Sequence:create(
-- 		cc.CallFunc:create(function()
-- 			self:showTransitionAnimation()
-- 			self:playMusic(self.audio_list.transition)
-- 		end)
-- 	))
-- end

-- function cls:showTransitionAnimation()
-- 	local file = self:getPic("spine/transition/spine")
-- 	local pos = cc.p(0, 0)
-- 	local _, s =self:addSpineAnimation(self.node_Transition, nil, file, pos, "animation", nil, nil, nil, false, false, nil)
-- end
------------------------------endregion------------------------------



------------------------------region lua-based static functions------------------------------
local activeDebugGroup = {
	"base",
	"board",
	"symbol",
	"nudge",
	"free",
	"random wild",
	"sticky wild",
	"bonus",
	"jp",
	"respin",
	"map",
	"bet",
	"collectible",
	"wheel",
}
function cls:p(groupName, ...)
	-- if self.eDebugGroup == nil then
	-- 	self.eDebugGroup = self:enum(activeDebugGroup, "DebugGroup")
	-- end
	-- local author = "sj"
	-- if self.eDebugGroup:contains(groupName) then
	-- 	print(author.."_debug: debug group "..groupName..":", ...)
	-- end
end

function cls:createIntegerDomain(list)
    local ans = {}
    for _, index in ipairs(list) do
        ans[index] = true
    end
    return ans
end

function cls:containsInteger(list, integer)
    if list == nil then
        return false 
    else 
        return list[integer] == true
    end
end

-- use parameter name tableau to avoid naming conflicts
local constMeta = {
	__index = function(tableau, key)
		local ans = getmetatable(tableau)[key]
		if ans then
			return ans
		else
			-- print("try to access a non-existent field '"..key.."' of a constant table.")
		end
	end,
	__newindex = function(tableau, key, value)
		local oldValue = getmetatable(tableau)[key]
		if oldValue then
			-- print("try to set an existing field '"..key.."' of a constant table.")
		else
			getmetatable[key] = value
		end
	end
}
function cls:convertToConst(tableau)
	tableau.__index = constMeta.__index
	tableau.__newindex = constMeta.__newindex
	local ans = {}
	setmetatable(ans, tableau)
	return ans
end

local isenum = function(a)
	return type(type(a)=="table" and a.value and a.printValue and a.group)=="string"
end
local enumItemMetatable = {
	toint = function(tableau)
		return tableau.value
	end,
	__tostring = function(tableau)
		return tableau.printValue
	end,
	__eq = function(left, right)
		if left == nil or right == nil then 
			return false
		else
			if isenum(left) and isenum(right) then
				return left.value == right.value
			else
				return false
			end
		end
	end,
	__lt = function(left, right)
		if left == nil or right == nil then 
			return false 
		else 
			if isenum(left) and isenum(right) then
				return left.value < right.value
			else
				return false
			end
		end
	end,
	__le = function(left, right)
		if left == nil or right == nil then 
			return false 
		else 
			if isenum(left) and isenum(right) then
				return left.value <= right.value
			else
				return false
			end
		end
	end,
	__index = function(tableau, key)
		if key == "toint" then
			return getmetatable(tableau).toint
		end
	end
}

function cls:enum(keySet, typeName)
	local enumTable = { 
		count = 0,
		__len = function(tableau) return getmetatable(tableau).count end,
		__index = function(tableau, key)
			local ans = getmetatable(tableau)[key]
			if ans then
				return ans
			end
		end,
		__newindex = function(tableau, key, value)
			if type(value)=="function" then
				getmetatable(tableau)[key] = value
			end
		end,
		isenum = function(tableau, a)
			return type(type(a)=="table" and a.value and a.group and a.printValue)=="string"
		end,
		contains = function(tableau, key)
			return tableau:isenum(getmetatable(tableau)[key])
		end
	}

	if typeName == nil then
		typeName = "_@lambda_enum_"..math.random()
	end
	for i, key in pairs(keySet) do
		enumTable[key] = { value = i, group = typeName, printValue = typeName.."."..key }
		setmetatable(enumTable[key], enumItemMetatable)
		enumTable.count = enumTable.count + 1
	end
	
	local ans = {}
	setmetatable(ans, enumTable)
	return ans
end
------------------------------endregion------------------------------

------------------------------region cocos-based static functions------------------------------
function cls:getResource(path)
	return "theme_resource/theme164/"..path
end

function cls:setLabelScale(label, string, maxWidth, maxScale)
    maxScale = maxScale or label:getScale()
    label:setString(string)
    local scale = maxWidth / label:getContentSize().width
    scale = (scale > maxScale) and maxScale or scale
    label:setScale(scale)
    label:setString("")
end

function cls:setString(label, string, maxWidth, maxScale)
    maxScale = maxScale or label:getScale()
    label:setString(string)
    local scale = maxWidth / label:getContentSize().width
    scale = (scale > maxScale) and maxScale or scale
    label:setScale(scale)
end

function cls:lerp(a, b, alpha)
    return a+(b-a)*alpha
end
function cls:plerp(a, b, alpha)
    return cc.p(a.x+(b.x-a.x)*alpha, a.y+(b.y-a.y)*alpha)
end
function cls:sizelerp(a, b, alpha)
    return cc.size(a.width+(b.width-a.width)*alpha, a.height+(b.height-a.height)*alpha)
end

function cls:playSpineAnimation(file, animationName, bHold, bLoop, parent, position, zorder, animationCompleteEventHandler)
	----animationCompleteEvent data structure: {"animation":"animation1", "type":"complete", "trackIndex":0, "loopCount":1}
	local ans = sp.SkeletonAnimation:create(file..".json", file..".atlas", 1)
	ans:setAnimation(0, animationName, bLoop)
	parent:addChild(ans, zorder or 0)
	ans:setPosition(position)
	if animationCompleteEventHandler == nil then
		if bHold then
			animationCompleteEventHandler = function(event)
				--pass
			end
		else
			animationCompleteEventHandler = function(event)
				ans:runAction(cc.Sequence:create(
					cc.DelayTime:create(0),
					cc.RemoveSelf:create()
				))
			end
		end
	end
	ans:registerSpineEventHandler(animationCompleteEventHandler, sp.EventType.ANIMATION_COMPLETE)
	return ans
end

function cls:playMusicOverride(name, bLoop, bSingleton)
    bSingleton = bSingleton or false
    bLoop = bLoop or false
    if self:isExistFile(name) then
        local audioFile = self:getPic(name)
        local ans = AudioControl:playEffect(audioFile, bLoop, bSingleton)
        return ans
    else
        return nil
    end
end

function cls:stopMusicById(audioId)
    if audioId then
        AudioControl:stopEffectById(audioId)
        audioId = nil
    end
end

function cls:stopBgm()
    AudioControl:stopGroupAudio("music")
end
function cls:playBgm(name)
    AudioControl:playMusic("music", self:getPic(name), true, true)
end

function cls:changeBgm(name)
    self:stopBgm()
    self:playBgm(name)
end

function cls:changeParent(node, parent, zorder)
	local oldPos = node:getParent():convertToWorldSpace(cc.p(node:getPosition()))
	node:retain()
	node:removeFromParent(false)
	parent:addChild(node, zorder or 0)
	node:release()
	node:setPosition(parent:convertToNodeSpace(oldPos))
end
------------------------------end region------------------------------


------------------------------region helper functions------------------------------
function cls:getReelLocation(col, boardId)
	boardId = boardId or 1
	local c = self.ThemeConfig.boardConfig[boardId].reelConfig[col]
    local x = c.base_pos.x + c.cellWidth * 0.5
	local y = c.base_pos.y + c.cellHeight * c.symbolCount / 2
	return cc.p(x, y)
end

function cls:getSymbolLocation(col, row, boardId)
	boardId = boardId or 1
    local c = self.ThemeConfig.boardConfig[boardId].reelConfig[col]
    local x = c.base_pos.x + c.cellWidth * 0.5
    local y = c.base_pos.y + c.cellHeight * (c.symbolCount + 0.5 - row)
    return cc.p(x, y)
end

------------------------------end region------------------------------


------------------------------region free game------------------------------
---- override
function cls:enterFreeSpin(isResume)
	if self.isFreeGameRecoverState == true then
		self:dealMusic_PlayMapLoopMusic()

		self.isFreeGameRecoverState = false
		if self.freeType == 1 then 
		    self:changeSpinBoard(self.eBoardId.base, true)
		else
			if self.isMapFreeTriggerState then
				self:changeSpinBoard(self.eBoardId.base, false)
			else
			    self:setFreeSceneState()
			    self.ctl.footer:changeFreeSpinLayout3()
				if self.enterThemeSWPos and #self.enterThemeSWPos > 0 then
					self:fixStickWildData(self.enterThemeSWPos)
					self:setStickyWildSymbol(self.enterThemeSWPos, isResume)
				end
				self.enterThemeSWPos = nil
			end
		end
	end 
	self:showAllItem()
	self.playNormalLoopMusic = false
end

---- override
function cls:showFreeSpinNode(count, sumCount, first)
	if self.freeType == 1 then
	    if self.ctl and self.ctl.footer then
			self.ctl.footer:setFreeSpinLabel(count, sumCount)
			self.ctl.footer:changeFreeSpinLayout()
		end
	else
		if self.ctl and self.ctl.footer then
			self.ctl.footer:setFreeSpinLabel(count, sumCount)
			self.ctl.footer:changeFreeSpinLayout3()
		end 
	end	
	self:lockLobbyBtn()
end

---- override
---- copy from ThemeFortuneGongV
function cls:hideFreeSpinNode()
	self.curStickyWildList = nil
	self.stickyWildSList = nil
	self.stickWildPosF = nil
	self.stickWildPosData = nil

	self.freeColCnt = nil
	self.freeRowCnt = nil
	self.freeExtraWild 	= nil
	self.baseScene.stickyAnimate:removeAllChildren()
	self:changeSpinBoard(self.eBoardId.base)
	Theme.hideFreeSpinNode(self)
end
---- endcopy

function cls:updatedFreeSpinCount(remainingCount, totalCount) -- only rewritte
	self.ctl.footer:setFreeSpinLabel(remainingCount, totalCount)
end

function cls:setFreeSceneState()
	if self.mapData.reel_count == 1 then
		if self.mapData.row_count == 1 then
			self:changeSpinBoard(self.eBoardId.f5x6)
		else
			self:changeSpinBoard(self.eBoardId.f4x6)
		end
	else
		if self.mapData.row_count == 1 then
			self:changeSpinBoard(self.eBoardId.f5x5)
		else
			self:changeSpinBoard(self.eBoardId.f4x5)
		end
	end
end

function cls:setFreeBoardState(state)
	if state == "start" then
		self.btn_freeNorTriggerStart:setBright(true)
		self.freeNorTriggerBoard:setVisible(true)
		self.freeNorRetriggerBoard:setVisible(false)
		self.freeNorCollectBoard:setVisible(false)
	elseif state == "retrigger" then
		self.freeNorTriggerBoard:setVisible(false)
		self.freeNorRetriggerBoard:setVisible(true)
		self.freeNorCollectBoard:setVisible(false)
		self.freeNorRetriggerTextList[1]:setVisible(false)
		self.freeNorRetriggerTextList[2]:setVisible(false)
	elseif state == "collect" then
		self.btn_norFreeCollect:setBright(true)
		self.freeNorTriggerBoard:setVisible(false)
		self.freeNorRetriggerBoard:setVisible(false)
		self.freeNorCollectBoard:setVisible(true)
	end
end

---- override
function cls:noFeatureLeft()
	local isNoFeatrueLeft = true
	if self.ctl.rets then
		if self.ctl.rets.bonus_game or (self.boardType == self.eBoard.respin and self.bonus and not self.bonus.bAllowRespinCollectMoney) then
		    isNoFeatrueLeft = false
		end
	end
	
	return isNoFeatrueLeft
end

-- no popup in this function
function cls:playStartFreeSpinDialog(theData)       
	self:enableMapInfoBtn(false)

	if self.freeType > 1 then
		if theData.enter_event then
			theData.enter_event()
		end
		if theData.click_event then
			theData.click_event()
		end
		if theData.end_event then
			theData.end_event()
			self:dealMusic_PlayFreeSpinLoopMusic()
			
			if self.freeExtraWild then
				self:runAction(cc.Sequence:create(
					cc.DelayTime:create(transitionDelay.free.onEnd - transitionDelay.free.onCover),
				   	cc.CallFunc:create(function()
						self.firstFreeGameTrigger = true
						self:smashDiamondsIntoReel()
				   	end)))
			end
		end
	end
end

---- override
function cls:playCollectFreeSpinDialog(theData)
	if self.freeType and self.freeType > 1 then
		if theData.enter_event then
			theData.enter_event()
		end

		local data = {}
		data.mapLevel = self.mapLevel
	    data.mapInfo = self.mapData
		data.theData = theData
		
		self:stopAllLoopMusic()

	    local theDialog = FireFortuneFreeCollect.new(self, self:getPic("csb/"), data)
	    theDialog:showMapFreeCollectDialog() 
	end
end

local smashMaxZOrder = 100
local nextDiamondsDelay = 0.1
local onDiamondsTime = 14/30
local addDiamondsCnt = 25
function cls:smashDiamondsIntoReel()
	self:dealMusic_FadeLoopMusic(0.2, 1, 0.3)
 	local laterDelay = addDiamondsCnt* nextDiamondsDelay + onDiamondsTime

 	local endCol = self.freeColCnt or 5
 	local maxRow = self.freeRowCnt or 4
 	local file = self:getPic("spine/base/wildjinru")

	self:playMusic(self.audio_list.add_extra_wild)
	local curColRow = ""
	self:runAction(cc.Repeat:create(cc.Sequence:create(
		cc.CallFunc:create(function()
			local col = math.random(1,endCol)
			local randomRow = math.random(1,maxRow)

			while curColRow == col..randomRow do
				col = math.random(1,endCol)
				randomRow = math.random(1,maxRow)
			end
			curColRow = col..randomRow

			local pos = self:getCellPos(col,randomRow) 
			local zOrder = smashMaxZOrder - randomRow
			self:addSpineAnimation(self.baseScene.aAnticipation, zOrder, file, pos, "animation")
		end),
		cc.DelayTime:create(nextDiamondsDelay)
	),addDiamondsCnt))

	self:laterCallBack(laterDelay,function ()
		self:showSmashDiamondTip()
		self.baseScene.aAnticipation:removeAllChildren(false)
		self.firstFreeGameTrigger = nil
	end)
end

function cls:showSmashDiamondTip()

	local dialog = cc.CSLoader:createNode(self:getPic("csb/extra_wild.csb"))--  加载 进入respin 的弹板
	local rootNode 	= dialog:getChildByName("root")

	local playLine = function (startFrame, endFrame)
		local action = cc.CSLoader:createTimeline(self:getPic("csb/extra_wild.csb"))
		dialog:runAction(action)
		action:gotoFrameAndPlay(startFrame, endFrame, false)
	end

	bole.scene:addToContentFooter(dialog)

	dialog:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			playLine(0, 30)
			self:playMusic(self.audio_list.show_extra_wild_board)
		end),
		cc.DelayTime:create(2),
		cc.CallFunc:create(function ()
			playLine(60, 90)
		end),
		cc.DelayTime:create(1),
		cc.RemoveSelf:create()
	))
end


function cls:stopBoardAnimation()
	self.freeNorBoardAniNode:removeAllChildren()
end

function cls:exitMapFreeGame(theData)
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self:playTransition(nil, "free")
		end),
		cc.DelayTime:create(transitionDelay.free.onCover),
		cc.CallFunc:create(function() 	
			self:setNextCollectTargetImage(self.mapLevel)
			self:setCollectProgressImagePos(0)
			if theData.click_event then
				theData.click_event()
			end
			self:changeSpinBoard(self.eBoardId.base, false)
			self.ctl.footer:changeNormalLayout2() 	
			if theData.changeLayer_event() then
			   theData.changeLayer_event()
			end
			self.ctl.footer:enableOtherBtns(false)
		    self.ctl.footer:setSpinButtonState(true)
		    self:stopDrawAnimate()
		end),
		cc.DelayTime:create(transitionDelay.free.onEnd - transitionDelay.free.onCover),
		cc.CallFunc:create(function()
			self:dealMusic_PlayNormalLoopMusic()
			local data = {}
	    	data.mapLevel = self.mapLevel
	    	data.mapInfo = self.mapData
			local theDialog = FireFortuneMapGame.new(self, self:getPic("csb/"), data)
	        theDialog:showMapScene(true) 	
		end),
		cc.DelayTime:create(5.5),
		cc.CallFunc:create(function()
			if theData.end_event then
				theData.end_event()
			end
			self.mapPoints = 0
			self:enableMapInfoBtn(true)
		end)
	))
end



--------------------------region bonus game manager----------------------------
FireFortuneBonusManager = class("FireFortuneBonusManager")
local bonusGameManager = FireFortuneBonusManager

function bonusGameManager:ctor(bonusControl, theme, csbPath, data, callback)
	self.theme = theme
	self.theme.bonusManager = self

	local type = data.core_data.type
	if type == 1 then
		self.boardType = self.theme.eBoard.respin
	elseif type == 2 then
		self.boardType = self.theme.eBoard.mapRespin
	elseif type == 3 then
		self.boardType = self.theme.eBoard.wheel
	end
	self.boardType_stack = self.theme.boardType
	self.theme.boardType = self.boardType
	if type == 1 then
		self.bonus = FireFortuneBonusRespin.new(bonusControl, theme, csbPath, data, callback)
	elseif type == 2 or type == 3 then
		self.bonus = FireFortuneBonusMap.new(bonusControl, theme, csbPath, data, callback)
	end
	self.bonus.bonusManager = self

	return self
end

function bonusGameManager:enterBonusGame(tryResume)
	self.bonus:enterBonusGame(tryResume)
end

function bonusGameManager:loadControls()
	if self.boardType == self.theme.eBoard.mapRespin or self.boardType == self.theme.eBoard.wheel then
		self.bonus:loadControls()
	end
end

function bonusGameManager:exit()
	self.theme.bonusManager = nil
	self.theme.bonus = nil
	self.theme.boardType = self.boardType_stack
end
--------------------------endregion----------------------------




--------------------------region bonus game respin----------------------------
---- config
function cls:saveBonusCheckData(bonusData)
	local data = {}
	data.bonus_id = bonusData.bonus_id
	LoginControl:getInstance():saveBonus(self.themeid, data)
end

---- config
function cls:cleanBonusSaveData(data)
	LoginControl:getInstance():saveBonus(self.themeid, nil)
end

---- config

function cls:enterThemeByFirstFreeSpin(ret, theFreeSpinData, endCallFunc)
	ret["free_spins"]		= theFreeSpinData.free_spins
	self.ctl:free_spins(ret)
end

function cls:enterThemeByBonus(theBonusGameData, endCallFunc)
	self.ctl.isProcessing = true
	self.ctl:open_old_bonus_game(theBonusGameData, endCallFunc)
end

function cls:lockJackpotMetersWithProgressiveList(progressive_list)
	self:lockJackpotMeters(true)
	local jackpotMultiplier = {5000, 1250, 625, 20, 10}
	local curBet = self.ctl:getCurBet()
	for i = 1, #self.jackpotLabels do
		self.jackpotLabels[i]:setString(self:formatJackpotMeter(progressive_list[i] + jackpotMultiplier[i]*curBet))
	end
end

function cls:fixItemListUpDown(col)
	local blank = self.eSymbol.blank:toint()
    if col then
		col:setIconAtIndex(0, blank)
		for i = col.row+1, col.number do
			col:setIconAtIndex(i, blank)
		end
		col:refreshCellsZOrderFromBottom()
    end
end
function cls:fixAllItemListUpDown()
	do
		return
	end

    for _, col in pairs(self.spinLayer.spins) do
        self:fixItemListUpDown(col)
	end
end

---- abstract overrride
function cls:addItemSpine(col, row, animName)
	local layer			= self.animateNode
	local animName		= "animation3"
	local pos			= self:getCellPos(col, row)
	local spineFile		= self:getPic("spine/symbol/scatter")

	local cell = self.spinLayer.spins[col]:getRetCell(row)
	cell.sprite:setVisible(false)
	self:adjustWithTheCellSpriteUpdate(cell)
	local _, s1 = self:addSpineAnimation(layer, nil, spineFile, pos, animName, nil, nil, nil, true, true)
end

function cls:playBonusAnimate(data)
	self:stopDrawAnimate()
	self.ctl.footer:setSpinButtonState(true)
	
	if data.type == 1 then
		if not self.playBonusList or #self.playBonusList == 0 then return 0 end

		self:playMusic(self.audio_list.trigger_bell)
		for col, colTagList in pairs(self.playBonusList) do
			for _, tagValue in pairs(colTagList) do
				self:addItemSpine(tagValue[1], tagValue[2])
			end
		end
		return 2
	else
		return 0
	end
end

---- abstract override
function cls:onRespinStart()
    self.DelayStopTime = 0
	self.bRespinOngoing = true
	self.respinAnticipationPlan = nil
	self.tremblePlan = nil
	self.respinStopAnim = nil
	self.bonus.satisfyCol = nil

	if self.boardType == self.eBoard.respin and self.bonus then
		self.bonus:onRespinStart()
	end
end

---- abstract override
function cls:onRespinStop(rets)
	-- only one bonus game use respin
	if self.boardType == self.eBoard.respin then
		self:fixRet(rets)

		if rets.theme_respin and #rets.theme_respin == 0 then
			rets.theme_respin = nil
			rets.theme_deal_show = true
			self.bonus.respinStep = self.bonus.eRespinStep.over
		end

		local cd = self.bonus.data.core_data
		if (cd.respin_win_list[self.bonus.respinIndex] and cd.respin_win_list[self.bonus.respinIndex])>0 or self.bonus:getJpWinIndex() then
			rets.theme_deal_data = true
		-- else
		-- 	self.bonus:saveDataOnRespinStop()
		end
		self.bonus:saveDataOnRespinStop()
	end
end

---- abstract override
function cls:theme_deal_data(rets)
	rets.theme_deal_data = nil
	self.bonus:calculateRespinRoundWin()
end

---- abstract override
function cls:theme_deal_show(rets)
	if self.bonus.respinStep == self.bonus.eRespinStep.over then
		self.bonus.bAllowRespinCollectMoney = true
		rets.theme_deal_show = nil
		self.baseScene.bonusRoot:runAction(cc.Sequence:create(
			cc.DelayTime:create(0.8),
			cc.CallFunc:create(handler(self.bonus, self.bonus.showBonusCollectPopup))
		))
	end
end

---- abstract override
function cls:theme_respin(rets)
	self.notifyState = nil
	self.speedUpState = nil
	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(self.const.delNextRespin), 
		cc.CallFunc:create(function()
			local respinList = rets.theme_respin
			if respinList and #respinList > 0 then
				rets.item_list = table.remove(respinList, 1)
				local endCallFunc = self:getTheRespinEndDealFunc(rets)
				self:stopDrawAnimate()
				self.ctl:respin(self.const.delRespinStop, endCallFunc)
			else-- to avoid deadlock
				rets.theme_respin = nil
				self.ctl:handleResult()
			end	
		end)
	))
end

function cls:checkPlayReelTremble(col)
	if self.tremblePlan[col] then
		self:playMusic(self.audio_list["shake"..col])
		self.footerTremble = ScreenShaker.new(self.ctl.footer, 0.35, function() self.footerTremble = nil end)
		self.footerTremble:run()
		self.headerTremble = ScreenShaker.new(self.ctl.header, 0.5, function() self.headerTremble = nil end)
		self.headerTremble:run()
		self.reelTremble = ScreenShaker.new(self.shakyNode, 0.5, function() self.reelTremble = nil end)
		self.reelTremble:run()
		self.tremblePlan[col] = false
	end
end
---- abstract override
function cls:fixRet(rets) --fix item_list_up and item_list_down
	local blank = self.eSymbol.blank:toint()
	self.ctl.resultCache = {}
	local item_list = table.copy(rets.item_list)
	for i = 1, #item_list do
		self.ctl.resultCache[i] = { blank, unpack(item_list[i]) }
        local extraCount = 6
        if self.isTurbo then
            extraCount = 3
		end
		for j = 1, extraCount do
			table.insert(self.ctl.resultCache[i], blank)
		end
    end
end

---- abstract override
function cls:getBonusReel()
	if self.customizedBonusReel == nil then
		local baseBonusReel = {
			{11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0},
			{11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 12, 12, 12, 12, 12, 0, 0, 0, 0, 0, 0, 0, 0}
		}
		local unanimitySymbolCount = 60
		local baseBonusReelTimes = 3
		local symbol = { 11, 11, 11, 11, 12 }
		local bonusReelWithUnanimity = {}
		for i = 1, #baseBonusReel do
			bonusReelWithUnanimity[i] = {}
			for j = 1, baseBonusReelTimes do
				for _, s in ipairs(baseBonusReel[i]) do
					table.insert(bonusReelWithUnanimity[i], s)
				end
			end
			for j = 1, unanimitySymbolCount do
				table.insert(bonusReelWithUnanimity[i], symbol[i])
			end
		end
		self.customizedBonusReel = bonusReelWithUnanimity
	end
	return self.customizedBonusReel
end

---- abstract override
function cls:overBonusByEndGame(data)
    if data.total_win then
		self.ctl.totalWin = data.total_win
	end
	if data.jp_win then
		for k, v in pairs(data.jp_win) do 
			if v.jp_win then 
				self.ctl.totalWin = self.ctl.totalWin + v.jp_win
			end
		end
	end
	self.ctl.isProcessing = false
	if self.showFreeSpinBoard or self.ctl.freewin then
		self.ctl.totalWin = self.ctl.freewin + self.ctl.totalWin
		self.ctl.freewin = self.ctl.totalWin
		self.ctl:updateFooterCoin()

	else
		self:unlockLobbyBtn()
		self.ctl:removePointBet()
		self.ctl:updateFooterCoin()
		self.ctl:addCoinsToHeader()
	end
end



-----------------------------Transition弹窗相关------------------------------
function cls:playTransition(endCallBack,tType)
	local function delayAction()
		local transition = FireFortuneTransition.new(self,endCallBack)
		transition:play(tType)
	end	
	delayAction()
end

FireFortuneTransition = class("FireFortuneTransition", CCSNode)
local GameTransition = FireFortuneTransition

function GameTransition:ctor(theme, endCallBack)
	self.spine = nil
	self.theme = theme
	self.endFunc = endCallBack
end

function GameTransition:play(tType)
	local spineFile = self.theme:getPic("spine/base/fgqieping_01") -- 默认显示 Free transition
	local musicFile = self.theme.audio_list.transition_free
	local pos = cc.p(0,0)
	local delay1 = transitionDelay[tType]["onEnd"] -- 切屏结束 的时间
	if tType == "bonus" then 
		spineFile = self.theme:getPic("spine/base/respin_qieping_01")
		musicFile = self.theme.audio_list.transition_bonus -- 播放转场声音
	end
	self.theme.curScene:addToTop(self,30)
	bole.adaptTransition(self,true,true)
    self:setVisible(false) 
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function()
    	self:setVisible(true)
    	self.theme:playMusic(musicFile)
    	self.theme:addSpineAnimation(self, nil, spineFile, pos, "animation")
    end),
    cc.DelayTime:create(delay1), -- 切屏动画完成时间
    cc.CallFunc:create(function ( ... )
    	if self.endFunc then 
    		self.endFunc()
    	end
    end),
    cc.RemoveSelf:create()))
end
-------------------------------Transition 结束--------------------------------------


FireFortuneBonusRespin = class("FireFortuneBonusRespin")
local bonusGame = FireFortuneBonusRespin
function bonusGame:ctor(bonusControl, theme, csbPath, data, callback)
    self.bonusControl = bonusControl
    self.theme = theme
    self.csbPath = csbPath
    self.callback = callback
    self.endCallback = callback--unused
    self.data = data
    self.theme.bonus = self
    self.ctl = bonusControl.themeCtl
	self.data.bonus_id = data.core_data.bonus_id
	
	self.winList = self.data.core_data.respin_win_list
	self.jpWinList = self.data.core_data.respin_jp_win_list
	self.jpList = self.ctl.rets.jp_win
    
	self:initFunction()
	self:initConstant()
	-- three types of bonus game
	if data.core_data.type == 1 then
		self.boardType = self.theme.eBoard.respin
		self.theme.boardType = self.theme.eBoard.respin
	elseif data.core_data.type == 2 then
		self.boardType = self.theme.eBoard.mapRespin
		self.theme.boardType = self.theme.eBoard.mapRespin
	elseif data.core_data.type == 3 then
		self.boardType = self.theme.eBoard.wheel
		self.theme.boardType = self.theme.eBoard.wheel
	end
    self:initNodes()
	self:saveBonus()
	return self
end

function bonusGame:initConstant()
	self.const = {
		dBonusOpacity = 200,
		jpHighlightTimes = 3,
		delNextJpHighlight = { 0.2, 0.2, 0.3, 0.4 },
		durJpHerald = 45/30,
		delJpWin = 0.4,
		delStartJpRoll = 1.5,
		delNormalCollect = 2,
		delMultiplierChange = { 0.2, 0.2, 0.25, 0.35 },
	}
	self.eRespinStep = self:enum({
		"playing", "over"
	}, "respinStep")
end

function bonusGame:initFunction()
	self.enum = self.theme.enum
	self.p = self.theme.p
	self.createIntegerDomain = self.theme.createIntegerDomain
	self.containsInteger = self.theme.containsInteger
	self.setLabelScale = self.theme.setLabelScale
	self.setString = self.theme.setString
	self.playSpineAnimation = self.theme.playSpineAnimation
	self.playMusicOverride = self.theme.playMusicOverride
	self.stopMusicById = self.theme.stopMusicById
	self.playBgm = self.theme.playBgm
	self.stopBgm = self.theme.stopBgm
	self.changeBgm = self.theme.changeBgm

	self.spine = self.theme.spine
	self.audio = self.theme.audio
end

function bonusGame:initNodes()
	-- self.bonusScene = cc.CSLoader:createNode(self.theme:getPic("scene/respin.csb"))
	if self.boardType == self.theme.eBoard.respin then
		self.bonusScene = {}
		self.bonusScene.bonusRoot = self.theme.baseScene.down_child:getChildByName("bonusRoot")
		self.bonusScene.nScatter2Multiplier = self.bonusScene.bonusRoot:getChildByName("nScatter2Multiplier")
		self.bonusScene.aJpHerald = self.bonusScene.bonusRoot:getChildByName("aJpHerald")
		self.bonusScene.nJpHerald = self.bonusScene.bonusRoot:getChildByName("nJpHerald")
		-- self.bonusScene.nRespinTimes = self.bonusScene.bonusRoot:getChildByName("nRespinTimes")
		-- self.bonusScene.nRespinTimes:setVisible(true)
		self.bonusScene.dBonus = self.bonusScene.bonusRoot:getChildByName("dBonus")
		self.bonusScene.aMultiplierFly = self.bonusScene.bonusRoot:getChildByName("aMultiplierFly")
		self.bonusScene.nBonusCollect = self.bonusScene.bonusRoot:getChildByName("nBonusCollect")
		self.bonusScene.nJpCollect = self.bonusScene.bonusRoot:getChildByName("nJpCollect")
	elseif self.boardType == self.theme.eBoard.mapRespin then

	elseif self.boardType == self.theme.eBoard.wheel then
	
	end
end

function bonusGame:saveBonus()
    LoginControl:getInstance():saveBonus(self.theme.themeid, self.data)
end

function bonusGame:bonusUniversalInit()
    -- initialization that needs done only once for several bonus games
    self.ctl.footer:setSpinButtonState(true)
    self.ctl.footer.isRespinLayer = true
    self.ctl.bonusRet = self.ctl.rets
    self.callback = function()
        if self.endCallback then
            self.endCallback()
        end
        self.ctl.isProcessing = false
    end
    if tryResume then 
        self.ctl.isProcessing = true
    end
    self.theme:stopDrawAnimate()
    self.oldTotalWin = self.ctl.totalWin or 0
	self.theme:lockJackpotMetersWithProgressiveList(self.data.core_data.progressive_list)
	self.ctl:resetCurrentReels(false, true)
	self.theme.baseScene.nCollect:setVisible(false)
	self.theme.baseBg:setVisible(false)
	self.theme.freeBg:setVisible(false)
	self.theme.respinBg:setVisible(true)
	self.theme.baseScene.lineCntNode:setVisible(false)
end

function bonusGame:enterBonusGame(tryResume)
	 self.ctl.footer:setSpinButtonState(true)
	self.data.jpCollectIndex = self.data.jpCollectIndex or 0
	self.respinStep = self.eRespinStep.playing

    if tryResume and self.data.respinIndex then 
    	self.theme:dealMusic_PlayBonusLoopMusic()
    	self:bonusUniversalInit()
        if self.data.lastNormalSpinResult then
            self.lastNormalSpinResult = tool.tableClone(self.data.lastNormalSpinResult)
        else
            self.lastNormalSpinResult = tool.tableClone(self.data.core_data.item_list)
        end
        self:resumeBonusGame()
        self:freshRespinNum(self.respinSum)
    else
        self.lastNormalSpinResult = self.data.core_data.item_list or self.theme.item_list
        self.respinWin = 0
        self.data.respinWin = self.respinWin
        self.respinIndex = 0
		
		self.respinSum = self.data.core_data.respin_count
	    self.data.lastNormalSpinResult = tool.tableClone(self.lastNormalSpinResult)
		
		self:saveBonus()

		self.ctl.rets.theme_respin = self.data.core_data.theme_respin
    	if tryResume then 
    		self.ctl.cacheSpinRet = self.ctl.cacheSpinRet or self.ctl.rets-- spin 结果数据和 显示stop 按钮有关
    	end
		self.theme:stopAllLoopMusic()
        self:showBonusEntryPopup() 
        -- self:startOneRound()
    end
end

function bonusGame:showBonusEntryPopup()
	self.pBonusEntry = cc.CSLoader:createNode(self.theme:getPic("csb/bonusentry.csb"))
	local root = self.pBonusEntry:getChildByName("root")
	self.pBonusEntry_startBnt = root:getChildByName("btn_start")
	self.theme.baseScene.nBonusEntry:addChild(self.pBonusEntry, 0) 

	local pBonusEntry_startBntSize = self.pBonusEntry_startBnt:getContentSize()
	self.theme:addSpineAnimation(self.pBonusEntry_startBnt, nil, self.theme:getPic("spine/dialog/anniu"), cc.p(pBonusEntry_startBntSize.width/2, pBonusEntry_startBntSize.height/2), "animation", nil, nil, nil, true, true)
	local _, titleS = self.theme:addSpineAnimation(root, nil, self.theme:getPic("spine/dialog/cong"), cc.p(-3, 233.5), "animation", nil, nil, nil, true, true)
	titleS:setScale(1.25)
	self.theme:addSpineAnimation(root:getChildByName("spine_node"), nil, self.theme:getPic("spine/dialog/kuang2"), cc.p(-4, -14), "animation", nil, nil, nil, true, true)

	local pBonusEntryStartClick = function ( obj, eventType )
		if eventType == ccui.TouchEventType.ended then 
			self.pBonusEntry_startBnt:setTouchEnabled(false)

			self.data.respinIndex = 0
			self:saveBonus()

			self.theme:playMusic(self.theme.audio_list.common_click)
			self.theme:playTransition(nil,"bonus")-- 转场动画

			self.theme.baseScene.dBonus:runAction(cc.Sequence:create(
				cc.DelayTime:create(0.3),
				cc.FadeOut:create(0.2)))

			self.pBonusEntry:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.15, 1.2),
				cc.ScaleTo:create(0.35, 0),
				cc.DelayTime:create(transitionDelay.bonus.onCover - 0.5),
				cc.CallFunc:create(function ()
					
					self:bonusUniversalInit()
					self:freshRespinNum(self.respinSum)
					self:recoverBonusShowCellItems()
				end),
				cc.DelayTime:create(transitionDelay.bonus.onEnd - transitionDelay.bonus.onCover),
				cc.RemoveSelf:create(),
				cc.CallFunc:create(function()
					self.theme:dealMusic_PlayBonusLoopMusic()
					self.pBonusEntry = nil

					self:startOneRound()
				end)
			))
		end
	end

	self.theme:playMusic(self.theme.audio_list.bonus_start_show)
	self.theme.baseScene.dBonus:runAction(cc.FadeTo:create(0.5, 200))
	self.pBonusEntry:setScale(0)
	self.pBonusEntry:runAction(cc.Sequence:create(
		cc.ScaleTo:create(0.7, 1.2),
		cc.ScaleTo:create(0.2, 1),
		cc.CallFunc:create(function()
			self.pBonusEntry_startBnt:addTouchEventListener(pBonusEntryStartClick)
		end)
	))
end

function bonusGame:startOneRound()
	-- self.respinIndex = 0
	-- self.respinSum = self.data.core_data.respin_count
 --    self.data.respinIndex = 0
 --    self.data.lastNormalSpinResult = tool.tableClone(self.lastNormalSpinResult)
	-- self:saveBonus()
	-- self.ctl.rets.theme_respin = self.data.core_data.theme_respin
	self.ctl:handleResult()
end


function bonusGame:onRespinStart( )
	self.respinIndex = self.respinIndex + 1
	self.respinSum = self.respinSum -1
	self:freshRespinNum(self.respinSum) -- 更新计数

end

function bonusGame:freshRespinNum(sum)
	if sum < 0 then
		self.theme.baseScene.bonusCntNode:runAction(cc.Sequence:create(cc.FadeTo:create(1,0),cc.CallFunc:create(function ( ... )
			self.theme.baseScene.bonusCntNode:setVisible(false)
		end)))
	else
		if not self.theme.baseScene.bonusCntNode:isVisible() then 
			self.theme.baseScene.bonusCntNode:setOpacity(0)
			self.theme.baseScene.bonusCntNode:setVisible(true)
			self.theme.baseScene.bonusCntNode:runAction(cc.FadeTo:create(1,255))
		end
		self:setRespinLabel(sum or self.respinSum)
	end
end

function bonusGame:setRespinLabel(sum)
	self.theme.baseScene.bonusCntlabel:setString(sum == 0 and "" or sum)

	local showTipIndex = sum >= 2 and 2 or sum
	for k, node in pairs(self.theme.baseScene.bonusCntTipNodeList) do 
		if k == showTipIndex then 
			node:setVisible(true)
		else
			node:setVisible(false)
		end
	end
end

function bonusGame:saveDataOnRespinStop()
	-- self.respinIndex = self.respinIndex + 1
	self.data.respinIndex = self.respinIndex
	self:saveBonus()
end

function bonusGame:getJpWinIndex(index)
	index = index or self.respinIndex
	local jpWinIndex
	for i = 1, #self.jpWinList do
		if self.jpWinList[i] == index then
			jpWinIndex = i 
			break
		end
	end
	return jpWinIndex
end

function bonusGame:calculateRespinRoundWin()
	self.theme:stopRespinAnticipationSpine()
	local jpWinIndex = self:getJpWinIndex()
	if jpWinIndex then
		self:showJpHeraldPopup(jpWinIndex)
	else
		local m = self.data.core_data.bonus_multi_list[self.respinIndex]
		if m ~= 1 and self.winList[self.respinIndex] ~= 0 then
			self:showMultiplierPopup()
		elseif m == 1 and self.winList[self.respinIndex] ~= 0 then
			self:showNormalRespinPopup()
		end
	end
end

function bonusGame:resumeBonusGame()
	self.respinWin = 0
	if self.data.respinIndex and self.data.respinIndex ~= 0 then
		self.respinIndex = self.data.respinIndex
		self:recoverBonusResult(self.respinIndex)
		self.theme:fixAllItemListUpDown()
		for i = 1, self.data.respinIndex do
			local jpWinIndex = self:getJpWinIndex(i)
			if i == self.data.respinIndex then
				if jpWinIndex then
					if self.data.jpCollectIndex >= self.jpWinList[jpWinIndex] then
						self.respinWin = self.respinWin + self.jpList[jpWinIndex].jp_win
					else
						self.pJpHerald = true
						self:showJpHeraldPopup(jpWinIndex)
					end
				else
					self.respinWin = self.respinWin + self.winList[i]
				end
			else
				if jpWinIndex then
					self.respinWin = self.respinWin + self.jpList[jpWinIndex].jp_win
				else
					self.respinWin = self.respinWin + self.winList[i]
				end
			end
			table.remove(self.data.core_data.theme_respin, 1)
		end
	else
		-- self.isFirstRespin = true
		self:recoverBonusShowCellItems()
		self.respinIndex = 0
		self.data.respinIndex = 0
		self.data.jpCollectIndex = 0
	end
	
	self.respinSum = self.data.core_data.respin_count - self.respinIndex

	self.ctl.footer:setWinCoins(self.respinWin, self.oldTotalWin, 0)

	
	self.ctl.cacheSpinRet = self.ctl.cacheSpinRet or self.ctl.rets-- spin 结果数据和 显示stop 按钮有关
	-- if self.isFirstRespin then 
	-- 	self:showBonusEntryPopup() 
	-- 	if #self.data.core_data.theme_respin > 0 then
	-- 		self.ctl.rets.theme_respin = self.data.core_data.theme_respin
	-- 	else
	-- 		self.ctl.rets.theme_deal_show = true
	-- 		self.respinStep = self.eRespinStep.over
	-- 	end
	-- else
	if self.pJpHerald then--do not call handleResult() when there is jp collection reconnection
		if #self.data.core_data.theme_respin > 0 then
			self.ctl.rets.theme_respin = self.data.core_data.theme_respin
		else
			self.ctl.rets.theme_deal_show = true
			self.respinStep = self.eRespinStep.over
		end
	else
		if #self.data.core_data.theme_respin > 0 then
			self.ctl.rets.theme_respin = self.data.core_data.theme_respin
			self.ctl:handleResult()
		else
			self.ctl.rets.theme_deal_show = true
			self.respinStep = self.eRespinStep.over
			self.ctl:handleResult()
		end
	end
end

function bonusGame:recoverBonusShowCellItems()
	for col, theSpinCol in pairs(self.theme.spinLayer.spins) do
		for row, cell in pairs(theSpinCol.cells) do
			theKey = 0
			self.theme:updateCellSprite(cell, theKey, col, false, true)
		end
		self.theme:refreshColCellsZOrder(col)
	end
end

function bonusGame:recoverBonusResult(index)
	local resetItemList = self.data.core_data.theme_respin[index]
	for col, colItemList in pairs(resetItemList) do
		local theSpinCol = self.theme.spinLayer.spins[col]
		for row, theKey in pairs(colItemList) do
			self.theme:updateCellSprite(theSpinCol:getRetCell(row), theKey, col, false, true)
		end
		local r = self.ctl.bonusRet
		if r and r.item_list_up and r.item_list_up[col] then
			local key1 = r.item_list_up[col][1]
			local key2 = r.item_list_down[col][1]
			self.theme:updateCellSprite(theSpinCol:getRetCell(0), key1, col, false, true)
			self.theme:updateCellSprite(theSpinCol:getRetCell(#colItemList+1), key2, col, false, true)
		end
		self.theme:refreshColCellsZOrder(col)
	end
	self.ctl:cleanTheReelKeyCache()
end

function bonusGame:showBonusCollectPopup()
	self.pBonusCollect = cc.CSLoader:createNode(self.theme:getPic("csb/bonuscollect.csb"))
	self.bonusScene.nBonusCollect:addChild(self.pBonusCollect, 0)
	local root = self.pBonusCollect:getChildByName("root")
	self.pBonusCollect.lNumber = root:getChildByName("lNumber")
	bole.setSpeicalLabelScale(self.pBonusCollect.lNumber, self.respinWin + self.oldTotalWin, 540)

	inherit(self.pBonusCollect.lNumber, LabelNumRoll)
	self.pBonusCollect.lNumber:nrInit(0, 24, function(num) return FONTS.format(num, true) end)
	self.pBonusCollect.bCollect = root:getChildByName("bCollect")

	local pBonusCollectSize = self.pBonusCollect.bCollect:getContentSize()
	self.theme:addSpineAnimation(self.pBonusCollect.bCollect, nil, self.theme:getPic("spine/dialog/anniu"), cc.p(pBonusCollectSize.width/2, pBonusCollectSize.height/2), "animation", nil, nil, nil, true, true)
	local _, titleS = self.theme:addSpineAnimation(root, nil, self.theme:getPic("spine/dialog/cong"), cc.p(-3, 149.5), "animation", nil, nil, nil, true, true)
	titleS:setScale(1.25)
	self.theme:addSpineAnimation(root:getChildByName("spine_node"), nil, self.theme:getPic("spine/dialog/kuang2"), cc.p(-5, 3), "animation", nil, nil, nil, true, true)
	self.theme:addSpineAnimation(root, nil, self.theme:getPic("spine/dialog/kuang3"), cc.p(-5, -29.5), "animation1", nil, nil, nil, true, true)

	self.pBonusCollect.bCollect:addTouchEventListener(function(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:onCollectBonus()
		end
	end)
	self.pBonusCollect.bCollect:setTouchEnabled(false)

	self.theme:stopAllLoopMusic()
	self.theme:playMusic(self.theme.audio_list.bonus_end_show)
	self.pBonusCollect:setScale(0)
	self.pBonusCollect:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.bonusScene.dBonus:runAction(cc.FadeTo:create(0.4, self.const.dBonusOpacity))
			self.pBonusCollect.lNumber:nrStartRoll(0, self.respinWin, 2)
		end),
		cc.ScaleTo:create(0.4, 1.2),
		cc.ScaleTo:create(0.1, 1),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			self.pBonusCollect.bCollect:setTouchEnabled(true)
		end),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function ( ... )
			self.pBonusCollect.lNumber:nrOverRoll()
		end)
	))
end

function bonusGame:onCollectBonus()
	self.theme:playMusic(self.theme.audio_list.common_click)

	self.pBonusCollect.lNumber:nrOverRoll()
	self.pBonusCollect.bCollect:setTouchEnabled(false)
	self.pBonusCollect:runAction(cc.Sequence:create(
		cc.DelayTime:create(0.1),
		cc.CallFunc:create(function ( ... )
			self.bonusScene.dBonus:runAction(cc.FadeOut:create(0.4))
			self.theme:playTransition(nil, "bonus")
		end),
		cc.ScaleTo:create(0.1, 1.2),
		cc.ScaleTo:create(0.3, 0),
		cc.DelayTime:create(transitionDelay.bonus.onCover - 0.4),
		cc.CallFunc:create(function()
			self:returnToBaseGame()
		end),
		cc.DelayTime:create(transitionDelay.bonus.onEnd -  transitionDelay.bonus.onCover),
		cc.CallFunc:create(function ( ... )
			self:bonusUniversalEnd()
		end),
		cc.RemoveSelf:create()
	))
end

function bonusGame:bonusUniversalEnd()
	self.theme:dealMusic_PlayNormalLoopMusic()
	self.ctl.totalWin = 0
	self.ctl:startRollup(self.respinWin + self.oldTotalWin, function()
		if self.ctl:noFeatureLeft() then 
			self.ctl:onRespinOver()
		end
		self.ctl.footer.isRespinLayer = false
		self.ctl.rets.theme_respin = nil
		self.callback()
		self.bonusManager:exit()
		self.theme.bonus = nil
	end)
	-- self.ctl:collectCoins(1)
	-- self.theme:lockJackpotMeters(false)
	-- self.ctl:resetCurrentReels(false, false)
	-- local listAfterNudge = self.theme:nudgeItemListConSilencio(self.lastNormalSpinResult)
	-- self.ctl.rets.item_list = listAfterNudge
	-- self.ctl:resetBoardCellsSpriteOverBonus(listAfterNudge)
	-- self.theme:drawLinesThemeAnimate()

end

function bonusGame:returnToBaseGame()
	self.theme.respinAnticipationPlan = nil
	self.theme.tremblePlan = nil
	self.theme.respinStopAnim = nil
	self.data.end_game = true
	self.theme.boardType = self.theme.eBoard.base
	self.bAllowRespinCollectMoney = false
    self:saveBonus()
    self.ctl:collectCoins(1)

    -- self.bonusScene.bonusRoot:runAction(cc.Sequence:create(
        -- cc.CallFunc:create(function()
        --     if self.ctl.totalWin == nil then
        --         self.ctl.totalWin = 0
        --     end
        -- end),
        -- cc.DelayTime:create(1),
        -- cc.CallFunc:create(function()
			-- self:bonusUniversalEnd()
			self.theme.respinBg:setVisible(false)
			self.theme.freeBg:setVisible(false)
			self.theme.baseBg:setVisible(true)
			self.theme.baseScene.lineCntNode:setVisible(true)
			-- self.bonusScene.nRespinTimes:setVisible(false)
			self.theme.baseScene.nCollect:setVisible(true)
			self.theme:enableCollectTipBtn(true)
			self.theme:enableMapInfoBtn(true)
			self.theme:lockJackpotMeters(false)
			self.theme.baseScene.bonusCntNode:setVisible(false)
			self.ctl:resetCurrentReels(false, false)
			local listAfterNudge = self.theme:nudgeItemListConSilencio(self.lastNormalSpinResult)
			self.ctl.rets.item_list = listAfterNudge
			self.ctl:resetBoardCellsSpriteOverBonus(listAfterNudge)

			-- self.bonusManager:exit()
        -- end)
    -- ))
end

function bonusGame:showJpHeraldPopup(jpWinIndex)
	self.theme:dealMusic_FadeLoopMusic(0.3, 1, 0.3)
	self.theme:playMusic(self.theme.audio_list.mystery_jackpot)
	self.theme:addSpineAnimation(self.bonusScene.nJpHerald, 10, self.theme:getPic("spine/bonus/myst"), cc.p(0, 0), "animation")

	self.bonusScene.dBonus:runAction(cc.Sequence:create(
		cc.FadeTo:create(25/30, self.const.dBonusOpacity),
		cc.DelayTime:create(self.const.durJpHerald),
		cc.FadeOut:create(10/30),
		cc.CallFunc:create(function()
			self:pickJp(jpWinIndex)
		end)
	))
end


function bonusGame:switchJpHighlight(animationList, jpIndex, delay)
	table.insert(animationList, cc.CallFunc:create(function()
		for k = 1, 5 do
			self["aJpHighlight"..k]:setVisible(k == jpIndex)
		end
	end))
	table.insert(animationList, cc.DelayTime:create(delay))
end

local chooseJpAnimConfig = {
	[0] = 3,
	[1] = 2,
	[2] = 4,
	[3] = 1,
	[4] = 5,
}
local chooseRoundTimeConfig = {
	[1] = {0.2, 0.3, 0.3 ,0.3, 0.3},
	[2] = {0.4, 0.5, 0.5 ,0.6, 0.7},
	[3] = {0.8, 0.9, 1	 ,1.1, 1.2},
	[4] = {1.3, 1.3, 1.4 ,1.4, 1.5},
}
local chooseSingleRoundMaxCnt = 5
function bonusGame:pickJp(jpWinIndex)

	local animationList = {} 	-- 出现火柱子动画
	local f1 = cc.CallFunc:create(function ( ... ) -- 
		self.theme.baseScene.dChooseJp:runAction(cc.FadeTo:create(0.3, 200))
		local _, bgS = self.theme:addSpineAnimation(self.theme.baseScene.nChooseJp, nil, self.theme:getPic("spine/bonus/huozhu"), cc.p(0, 0), "animation", nil, nil, nil, true, true) -- 出现火柱子动画
		bgS:setOpacity(0)
		bgS:runAction(cc.FadeIn:create(0.5))
	end)
	table.insert(animationList, f1)
	local d1 = cc.DelayTime:create(0.5)
	table.insert(animationList, d1)

	-- 配置时间控制
	local chooseAnimList = self:getChoosePlayAnimJpData(jpWinIndex)
	if chooseAnimList and #chooseAnimList > 0 then -- 添加选择效果
		local _, chooseDeng = self.theme:addSpineAnimation(self.theme.baseScene.nChooseJp, 1, self.theme:getPic("spine/bonus/deng"), cc.p(0, 0), "animation1", nil, nil, nil, true)
		chooseDeng:setVisible(false)
		for _index, chooseAnimData in pairs(chooseAnimList) do 
			local f2 = cc.CallFunc:create(function ( ... ) -- 
				local animName = "animation"..chooseAnimData[1]
				if bole.isValidNode(chooseDeng) then -- 灯特效控制
					chooseDeng:setVisible(true) 
					bole.spChangeAnimation(chooseDeng, animName)
				end

				local _, kuang = self.theme:addSpineAnimation(self.theme.baseScene.sChooseJpUp, nil, self.theme:getPic("spine/bonus/5kuang"), cc.p(0, 0), "animation"..chooseAnimData[1]) -- 出现火柱子动画
				if _index == #chooseAnimList then 
					self.theme:playMusic(self.theme.audio_list.fire)
					local _, bgS = self.theme:addSpineAnimation(self.theme.baseScene.sChooseJpDown, nil, self.theme:getPic("spine/bonus/kuanghuo"), cc.p(0, 0), "animation"..chooseAnimData[1], nil, nil, nil, true, true) -- 出现火柱子动画
				end
				self.theme:playMusic(self.theme.audio_list["jp_select_"..chooseAnimData[1]])
			end)
			table.insert(animationList, f2)

			if _index ~= #chooseAnimList then 
				local d1 = cc.DelayTime:create(chooseAnimData[2])
				table.insert(animationList, d1)
			end
		end
	end

	local d2 = cc.DelayTime:create(3)
	table.insert(animationList, d2)
	
	local f3 = cc.CallFunc:create(function ( ... ) -- 
		self.theme.baseScene.dChooseJp:runAction(cc.FadeTo:create(0.3, 0))
		self.theme.baseScene.nChooseJp:removeAllChildren()
		self.theme.baseScene.sChooseJpDown:removeAllChildren()
		self:showJpCollectPopup(jpWinIndex)
	end)
	table.insert(animationList, f3)

	self.theme.baseScene.nChooseJp:runAction(cc.Sequence:create(unpack(animationList)))
end

function bonusGame:getChoosePlayAnimJpData( jpWinIndex )
	local jpType = self.jpList[jpWinIndex].jp_win_type
	local chooseJpSpineConfig = chooseJpAnimConfig[jpType]

	local randomRoundCnt = 3 -- math.random(2,3)
	local chooseJpList = {}
	for round = 1, randomRoundCnt + 1 do 
		local curRoundCnt = round > randomRoundCnt and chooseJpSpineConfig or chooseSingleRoundMaxCnt

		for i = 1, curRoundCnt do 
			table.insert(chooseJpList, {i, chooseRoundTimeConfig[round][i]})
		end
	end
	return chooseJpList
end

function bonusGame:showJpCollectPopup(jpWinIndex)
	self.pJpCollect = cc.CSLoader:createNode(self.theme:getPic("csb/jpcollect.csb"))
	self.bonusScene.nJpCollect:addChild(self.pJpCollect, 10)
	self.pJpCollect.root = self.pJpCollect:getChildByName("root")
	self.pJpCollect.jpName = self.pJpCollect.root:getChildByName("jpName")
	bole.updateSpriteWithFile(self.pJpCollect.jpName, "#jackpot_popup_jp0"..(self.jpList[jpWinIndex].jp_win_type + 1)..".png")
	self.pJpCollect.bCollect = self.pJpCollect.root:getChildByName("bCollect")

	
	self.theme:addSpineAnimation(self.pJpCollect.root:getChildByName("spine_node"), -1, self.theme:getPic("spine/dialog/jptanchuang"), cc.p(0, 0), "animation", nil, nil, nil, true, true)

	self.pJpCollect.bCollect:addTouchEventListener(function(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:onClickJpCollect(jpWinIndex)
		end
	end)
	self.pJpCollect.bCollect:setTouchEnabled(false)

	self.pJpCollect.lMoney = self.pJpCollect.root:getChildByName("lMoney")
	bole.setSpeicalLabelScale(self.pJpCollect.lMoney, self.jpList[jpWinIndex].jp_win, 620)

	inherit(self.pJpCollect.lMoney, LabelNumRoll)
    self.pJpCollect.lMoney:nrInit(0, 24, function(num) return FONTS.format(num, true) end)

    self.theme:playMusic(self.theme.audio_list["jp_win_dialog"..(self.jpList[jpWinIndex].jp_win_type + 1)])
	self.pJpCollect:setScale(0)
	self.bonusScene.dBonus:runAction(cc.FadeTo:create(0.5, self.const.dBonusOpacity))
	self.pJpCollect:runAction(cc.Sequence:create(
		cc.ScaleTo:create(0.7, 1.2),
		cc.ScaleTo:create(0.2, 1),
		cc.CallFunc:create(function()
			self.pJpCollect.lMoney:nrStartRoll(0, self.jpList[jpWinIndex].jp_win, 2)
		end),
		cc.DelayTime:create(0.7),
		cc.CallFunc:create(function()
			self.pJpCollect.bCollect:setTouchEnabled(true)
		end),
		cc.DelayTime:create(1.3),
		cc.CallFunc:create(function ( ... )
			self.pJpCollect.lMoney:nrOverRoll()
		end)
	))
end

function bonusGame:onClickJpCollect(jpWinIndex)
	self.theme:playMusic(self.theme.audio_list.common_click)


	local a = self.jpList[jpWinIndex].jp_win
	self.data.jpCollectIndex = self.jpWinList[jpWinIndex]
	-- self:saveDataOnRespinStop()
	self:saveBonus()
	local cd = self.data.core_data
	-- self.ctl.rets.base_win = a
	self.respinWin = self.respinWin + a
	self.pJpCollect.lMoney:nrOverRoll()

	local rollOverFunc = function ( ... )
		self.ctl:handleResult()
		self.theme:dealMusic_FadeLoopMusic(0.3, 1, 1)
	end

	self.bonusScene.dBonus:runAction(cc.FadeOut:create(0.4))
	self.pJpCollect.bCollect:setTouchEnabled(false)
	self.pJpCollect:runAction(cc.Sequence:create(
		cc.ScaleTo:create(0.4, 0),
		cc.RemoveSelf:create(),
		cc.CallFunc:create(function()
			self.pJpCollect = nil
			self.ctl.footer:setWinCoinsEffectByMuti(a, self.oldTotalWin+self.respinWin - a, rollOverFunc, 2)
		end)
	))
end

function bonusGame:showNormalRespinPopup()
	self.pMultiplier = cc.CSLoader:createNode(self.theme:getPic("csb/multiplier.csb"))
	self.bonusScene.nScatter2Multiplier:addChild(self.pMultiplier, 0)
	local root = self.pMultiplier:getChildByName("root")
	root:getChildByName("reelNumber"..self.satisfyCol):setVisible(true)
	local lWin = root:getChildByName("lWin")
	self:setString(lWin, FONTS.format(self.winList[self.respinIndex], true, false, false), 403)

	self.pMultiplier:setScale(0)
	self.pMultiplier:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			self.theme:playMusic(self.theme.audio_list.full_reel_show)
			self.bonusScene.dBonus:runAction(cc.FadeTo:create(0.2, self.const.dBonusOpacity))
		end),
		cc.ScaleTo:create(0.3, 1.2),
		cc.CallFunc:create(function ( ... )
			self.theme:addSpineAnimation(root, 5, self.theme:getPic("spine/dialog/tc_01"), cc.p(4,-25), "animation")
		end),
		cc.ScaleTo:create(0.1, 1),
		cc.DelayTime:create(self.const.delNormalCollect),
		cc.CallFunc:create(function()
			self.bonusScene.dBonus:runAction(cc.FadeOut:create(0.2))
		end),
		cc.ScaleTo:create(0.1, 1.2),
		cc.ScaleTo:create(0.3, 0),
		cc.CallFunc:create(function()
			self.ctl.footer:setWinCoins(self.winList[self.respinIndex], self.oldTotalWin+self.respinWin, 0)
			self.respinWin = self.respinWin + self.winList[self.respinIndex]
			self.pMultiplier = nil
			self.ctl:handleResult()
		end),
		cc.RemoveSelf:create()
	))
end

function bonusGame:getMultiplierFlyParabola(startPos, endPos, runTime)
	local sy = math.abs(endPos.y - startPos.y)
	local sx = endPos.x - startPos.x

	local bezier = {
		cc.p(endPos.x - (sx * math.random(7, 8) / 10), endPos.y + math.random(9, 11) * 10),
		cc.p(endPos.x - (sx * math.random(3, 4) / 10), endPos.y + math.random(6, 8)* 10 ),
		endPos
	}
	return cc.BezierTo:create(runTime, bezier)
end

function bonusGame:showMultiplierPopup()
	self.pMultiplier = cc.CSLoader:createNode(self.theme:getPic("csb/multiplier.csb"))
	self.bonusScene.nScatter2Multiplier:addChild(self.pMultiplier, 0)
	local root = self.pMultiplier:getChildByName("root")
	root:getChildByName("reelNumber"..self.satisfyCol):setVisible(true)
	local m = self.data.core_data.bonus_multi_list[self.respinIndex]
	local lWin = root:getChildByName("lWin")
	local winNumber = self.winList[self.respinIndex]
	self:setString(lWin, FONTS.format(winNumber, true), 403)
	inherit(lWin, LabelNumRoll)
	lWin:setString(FONTS.format(winNumber/m, true))
	lWin:nrInit(0, 24, function(num) return FONTS.format(num, true) end)
	self.pMultiplier.mul = {
		root:getChildByName("mul2"),
		root:getChildByName("mul3"),
		root:getChildByName("mul5")
	}

	local t
	if m == 2 then
		t = 1
	elseif m == 3 then
		t = 2
	elseif m == 5 then
		t = 3
	end

	local mult = self.pMultiplier.mul[t]
	local multPos = cc.p(330.5, -30) -- cc.pAdd(cc.p(-640, -360), self.theme:getCellPos(5, 2.5))
	for k = 1, 3 do
		self.pMultiplier.mul[k]:setVisible(false)
		self.pMultiplier.mul[k]:setPosition(multPos)
	end
	-- local animationList = {}

	-- local times = 3
	-- local mulNum = 3
	-- for i = 1, times do
	-- 	for j = 1, mulNum do
	-- 		table.insert(animationList, cc.CallFunc:create(function()
	-- 			for k = 1, mulNum do
	-- 				self.pMultiplier.mul[k]:setVisible(j == k)
	-- 			end
	-- 		end))
	-- 		table.insert(animationList, cc.DelayTime:create(self.const.delMultiplierChange[i]))
	-- 	end
	-- end
	-- for j = 1, t do
	-- 	table.insert(animationList, cc.CallFunc:create(function()
	-- 		for k = 1, mulNum do
	-- 			self.pMultiplier.mul[k]:setVisible(j == k)
	-- 		end
	-- 	end))
	-- 	table.insert(animationList, cc.DelayTime:create(self.const.delMultiplierChange[4]))
	-- end

	self.pMultiplier:setScale(0)
	self.pMultiplier:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			self.theme:playMusic(self.theme.audio_list.full_reel_show)
			self.bonusScene.dBonus:runAction(cc.FadeTo:create(0.4, self.const.dBonusOpacity))
		end),
		cc.ScaleTo:create(0.3, 1.2),
		cc.CallFunc:create(function ( ... )
			self.theme:addSpineAnimation(root, 5, self.theme:getPic("spine/dialog/tc_01"), cc.p(4,-25), "animation")
		end),
		cc.ScaleTo:create(0.1, 1),
		cc.CallFunc:create(function ( ... )
			self.theme:playMusic(self.theme.audio_list.multiple_fly)
			self.theme:addSpineAnimation(root:getChildByName("spine_node"), 5, self.theme:getPic("spine/bonus/beijing"), multPos, "animation")
		end),
		cc.DelayTime:create(39/30),
		cc.CallFunc:create(function()
			mult:setVisible(true)
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			mult:runAction(cc.Sequence:create(
				self:getMultiplierFlyParabola(cc.p(mult:getPosition()), cc.p(lWin:getPosition()), 0.8),
				cc.RemoveSelf:create()
			))
		end),
		cc.DelayTime:create(0.8),
		cc.CallFunc:create(function()
			-- play static animation
			self.theme:addSpineAnimation(root, 5, self.theme:getPic("spine/bonus/fanbei"), cc.p(0,0), "animation")
			lWin:nrStartRoll(winNumber / m, winNumber, 1)
		end),
		cc.DelayTime:create(1.8),
		cc.CallFunc:create(function()
			self.bonusScene.dBonus:runAction(cc.FadeOut:create(0.4))
		end),
		cc.ScaleTo:create(0.3, 1.2),
		cc.ScaleTo:create(0.1, 1),
		cc.CallFunc:create(function()
			self.ctl.footer:setWinCoins(winNumber, self.oldTotalWin + self.respinWin, 0)
			self.respinWin = self.respinWin + winNumber
			self.pMultiplier = nil
			self.ctl:handleResult()
		end),
		cc.RemoveSelf:create()
	))
end
------------------------------endregion------------------------------




----------------------------region bonus game map free game and wheel------------------------------
FireFortuneBonusMap = class("FireFortuneBonusMap", CCSNode)
local BSGame = FireFortuneBonusMap

function BSGame:ctor(bonusControl, theme, csbPath, data, callback)
	self.bonusControl = bonusControl
	self.theme = theme
	self.csbPath = csbPath
	self.callback = callback
	self.endCallBack = callback
	self.data = data
	self.theme.bonus = self 
	self.ctl = bonusControl.themeCtl
	self.mapLevel = self.theme.mapLevel
	if self.data.core_data.map_wheel_spin then
		self.csb = csbPath.."wheel.csb"
		self.wheelConfigList = self.data.core_data.map_wheel_spin.wheel
		self.baseBet = 1
		self.avgBet = self.data.core_data.map_wheel_spin.avg_bet
		self.winIndex = self.data.core_data.map_wheel_spin.index+1
		self.isBooster = self.winIndex == 1
		self.winValue = self.data.core_data.map_wheel_spin.total_win
		self.stopAngle = 360-((self.winIndex-1) * 360 / #self.wheelConfigList)

		self.data.isStart = self.data.isStart or false
		self.data.isWheelStop = self.data.isWheelStop or false
		self.data.isWheelStopExtra = self.data.isWheelStopExtra or false
		self.data.isWheelCollect = self.data.isWheelCollect or false

	    self:saveBonus()
	    self.boosterItem = self.wheelConfigList[1] - 10 

	    if self.isBooster then
	    	self.theme.mapData = self.theme.mapData or {}
	    	if self.theme.mapData.extra_fg == 0 then
	    	   self.theme.mapData.extra_fg = self.data.core_data.map_wheel_spin.extra_fg
	    	end
	    	if self.theme.mapData.extra_wild == 0 then
		       self.theme.mapData.extra_wild = self.data.core_data.map_wheel_spin.extra_wild
		    end
		    if self.theme.mapData.reel_count == 0 then
		        self.theme.mapData.reel_count = self.data.core_data.map_wheel_spin.add_reel
		    end
		    if self.theme.mapData.row_count == 0 then
		       self.theme.mapData.row_count = self.data.core_data.map_wheel_spin.add_row
		    end
		    if self.theme.mapData.sticky_wild == 0 then
		       self.theme.mapData.sticky_wild = self.data.core_data.map_wheel_spin.sticky_wild
		    end
		end

	    self.bonusType = 1
	else
		local boosterCountsList = {[3] = 2, [7] = 3, [12] = 4, [18] = 5}
		self.csb = csbPath.."map_free.csb"

		self.data.isBoard = self.data.isBoard or false
		self:saveBonus()
        
		self.mapInfoList = {}
		self.mapInfoList.extra_fg = self.theme.mapData.extra_fg
		self.mapInfoList.extra_wild = self.theme.mapData.extra_wild
		self.mapInfoList.reel_count = self.theme.mapData.reel_count
		self.mapInfoList.row_count = self.theme.mapData.row_count
		self.mapInfoList.sticky_wild = self.theme.mapData.sticky_wild

		self.boosterTriggerList = {}
	    local data = self.mapInfoList
	    self.boosterGetInfo = {}
	    self.boosterGetInfo = self.theme:getBoosterInfo(data)

		if self.mapLevel == 0 then
			self.boosterAllCount = 5
		else
		    self.boosterAllCount = boosterCountsList[self.mapLevel]
		end
		self.bonusType = 2
	end

	CCSNode.ctor(self, self.csb)
	return self
end

function BSGame:saveBonus()
	LoginControl:getInstance():saveBonus(self.theme.themeid, self.data)
end

function BSGame:loadControls()
	self.const = {
		wheelAppearPos = cc.p(0, -1100), -- cc.p(0, -830),
		wheelDisplayPos = cc.p(0, -212), -- cc.p(0, -200),
	}

	if self.bonusType == 1 then
		self.wheel_root = self.node:getChildByName("wheel_node")
		self.wheel_root:setPosition(self.const.wheelAppearPos)
	    self.wheel = self.wheel_root:getChildByName("wheel_bg")
	    local num_node = self.wheel:getChildByName("num_node")
	    self.num_list = {}
		for i = 1, 4 do 
	        self.num_list[i] = num_node:getChildByName("num_"..i)
	        if i == 1 then
	        	local num = self.avgBet / self.baseBet
	            self.num_list[i]:setString(FONTS.formatByCount2(num, 4, true))
	        else
	           local num = self.wheelConfigList[i] * self.avgBet / self.baseBet
	           self.num_list[i]:setString(FONTS.formatByCount2(num, 4, true))
	        end
	    end

	    local booster_node = self.wheel:getChildByName("booster_node")
	    local booster_item = self.boosterItem
	    for i = 1, 5 do
	    	local item = booster_node:getChildByName(i)
	    	item:setVisible(i == booster_item)
	    end

	    self.btn_spin = self.wheel_root:getChildByName("btn_spin")
        self.btn_aniNode = self.wheel_root:getChildByName("spinBtn_ani_node")
        self.win_aniNode = self.wheel_root:getChildByName("win_ani_node")
        self.dimmer1 = self.node:getChildByName("dimmer_node1")
	    self.dimmer1:setVisible(false)
	    self.dimmer2 = self.node:getChildByName("dimmer_node2")
	    self.dimmer2:setVisible(false)

	    self.triggerBoardNode = self.node:getChildByName("trigger_board_node")
	    self.triggerBoardNode:setVisible(false)
	    self.wheel_boardT_aniNode = self.triggerBoardNode:getChildByName("board_ani_node")
	    self.btn_start = self.triggerBoardNode:getChildByName("btn_start")

	    self.collectBoardNode = self.node:getChildByName("collect_board_node")
	    self.collectBoardNode:setVisible(false)
	    self.wheelCollectBoardBg = self.collectBoardNode:getChildByName("board_bg")
	    self.wheel_boardC_aniNode = self.wheelCollectBoardBg:getChildByName("board_ani_node")
	    self.collectBoard_normal = {}
	    self.collectBoard_normal.node = self.collectBoardNode:getChildByName("board1")
	    self.collectBoard_normal.node:setVisible(false)
	    self.collectBoard_normal.label_win = self.collectBoard_normal.node:getChildByName("label_wheel_win")
	    inherit(self.collectBoard_normal.label_win, LabelNumRoll)
		local function parseValue( num)
			return FONTS.format(num, true)
		end
		self.collectBoard_normal.label_win:nrInit(0, 25, parseValue)
		self.collectBoard_normal.btn = self.collectBoard_normal.node:getChildByName("btn_collect")
	    
        self.collectBoard_booster = {}
        self.collectBoard_booster.node = self.collectBoardNode:getChildByName("board2")
	    self.collectBoard_booster.node:setVisible(false)
	    self.collectBoard_booster.label_win = self.collectBoard_booster.node:getChildByName("label_wheel_win")
	    inherit(self.collectBoard_booster.label_win, LabelNumRoll)
		self.collectBoard_booster.label_win:nrInit(0, 25, parseValue)
		self.collectBoard_booster.booster = {}
		for i = 1, 5 do
			self.collectBoard_booster.booster[i] = self.collectBoard_booster.node:getChildByName("booster"..i)
			self.collectBoard_booster.booster[i]:setVisible(false)
		end
		self.collectBoard_booster.btn = self.collectBoard_booster.node:getChildByName("btn_collect")
		
	    self.label_wheelWin = nil
		self.btn_collect = nil
		self.extra_spin = nil
    elseif self.bonusType == 2 then
    	self.dimmer = self.node:getChildByName("dimmer_node1")
	    self.dimmer:setVisible(false)
	    local mapFreeCollectNode = self.node:getChildByName("collect_board_node")
	    mapFreeCollectNode:setVisible(false)

	    self.mapFreeTriggerNode = self.node:getChildByName("trigger_board_node")
	    self.mapFreeTriggerNode:setVisible(false)
	    self.mapFreeT_board_aniNode = self.mapFreeTriggerNode:getChildByName("board_ani_node")
	    self.mapFreeT_board_boosterNode = self.mapFreeTriggerNode:getChildByName("booster_node")

	    self.boosterGetList = {}
	    self.boosterDimmerList = {}
	    for i = 1, 5 do
	    	self.boosterGetList[i] = self.mapFreeT_board_boosterNode:getChildByName("booster"..i)
	    	self.boosterGetList[i]:setVisible(false)
	    	self.boosterDimmerList[i] = self.mapFreeT_board_boosterNode:getChildByName("dimmer"..i)
	    	self.boosterDimmerList[i]:setVisible(false)
	    end
	    self.label_mapFreeCounts = self.mapFreeTriggerNode:getChildByName("label_freeCount")
	    self.btn_mapFreestart = self.mapFreeTriggerNode:getChildByName("btn_start")
	    self.btn_mapFreestart:setBright(true)
    end
end

function BSGame:enterBonusGame(tryResume)
	self.theme:stopDrawAnimate()
	self.theme:enableMapInfoBtn(false)
	self.theme:stopAllLoopMusic()
	
	if self.theme.isLocked then
		self.theme.btn_unLock:setTouchEnabled(false)
	end
	self.theme.ctl.footer:setSpinButtonState(true)

	if tryResume then
		self.callback = function ()
        	local endCallFunc2 = function ()
        		self.ctl.rets.setWinCoins = nil
        		self.ctl:handleResult()
        		if self.endCallBack then 
        			self.endCallBack()
        		end
        	end
	        endCallFunc2()
        end

		self.ctl.isProcessing = true
	end

	if self.bonusType == 1 then
		self:enterMapWheelBonus(tryResume)
	elseif self.bonusType == 2 then
		self:enterMapFreeBonus(tryResume)
	end

end

function BSGame:enterMapWheelBonus(tryResume)
	local function playIntro()
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				self.theme:playMusic(self.theme.audio_list.trigger_bell)
			end),
			cc.DelayTime:create(1),
			cc.CallFunc:create(function()
				self:playTriggerBoard()
			end),
			cc.DelayTime:create(0.3),
			cc.CallFunc:create(function()
				--self.theme.collectProgressAniNode:removeAllChildren()
				--self.theme.collectWheelAniNode:removeAllChildren()
			end) 
		))	
		
	end

	local function snapIntro()
		local function recoverSpin()
			local winIndex = self.data.core_data.map_wheel_spin.index_2+1
			self.winIndex = winIndex
			self.isBooster = self.winIndex == 1 and true or false
			self.winValue = self.data.core_data.map_wheel_spin.total_win_2
			self.stopAngle = 360-((self.winIndex-1) * 360 / #self.wheelConfigList)
		end

        local function recoverTriggerBoardState()
        	self:playTriggerBoard()
        end 

		local function recoverCollectState()
			self.wheel:setRotation(self.stopAngle)
			self:playWheelBonusCollect()
		end

		local function recoverSpinState()
			self:showWheelScene()
			self:runAction(cc.Sequence:create(
				cc.CallFunc:create(function()
					self:playSpinBtnAnimation("idle")
				end),
				cc.DelayTime:create(0.5),
				cc.CallFunc:create(function()
					self:initSpinEvent()
				end)
			))
		end
		
		if not self.data.isStart then
		    self.data.isWheelStop = false
		    self.data.isWheelStopExtra = false
		    self:saveBonus()
		    recoverTriggerBoardState()
		elseif self.data.isWheelStopExtra then
			recoverCollectState()
		elseif self.data.isWheelStop then
			if self.data.isWheelCollect then
				recoverCollectState()
			else	
				recoverCollectState()	
			end
		else
			recoverSpinState()
		end
		
	end

	self.theme.curScene:addToContentFooter(self)

	if tryResume then
		snapIntro()
	else
		playIntro()
	end
end

function BSGame:initStartEvent()
	self.isWheelStartPress = false
	local pressFunc = function(obj)
	    self.data.isStart = true
	    self:saveBonus()
		self.isWheelStartPress = true
		self.btn_start:setBright(false)
        self.btn_start:setTouchEnabled(false)
        self.theme:playMusic(self.theme.audio_list.common_click)

		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				self.triggerBoardNode:runAction(cc.Sequence:create(
					cc.ScaleTo:create(0.1, 1.5, 1.5),
					cc.ScaleTo:create(0.2, 0, 0)
				))
			end),
			cc.DelayTime:create(0.35),
			cc.CallFunc:create(function()
				self:stopBonusBoardAnimation(self.wheel_boardT_aniNode)
				self.theme:stopDrawAnimate()
				self:playWheelScene()
			end),
			cc.DelayTime:create(0.67),
			cc.CallFunc:create(function()
				self:playSpinBtnAnimation("idle")
			end),
			cc.DelayTime:create(0.3),
			cc.CallFunc:create(function()
				self.btn_spin:setTouchEnabled(true)
				self:initSpinEvent()
			end) 
		)) 
	end

	local function onTouch(obj, eventType)
		if self.isWheelStartPress then return nil end
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end

	self.btn_start:addTouchEventListener(onTouch)
end

function BSGame:playTriggerBoard()

	local btn_startSize = self.btn_start:getContentSize()
	self.theme:addSpineAnimation(self.btn_start, nil, self.theme:getPic("spine/dialog/anniu"), cc.p(btn_startSize.width/2, btn_startSize.height/2), "animation", nil, nil, nil, true, true)
		
	local _, titleS = self.theme:addSpineAnimation(self.triggerBoardNode, nil, self.theme:getPic("spine/dialog/wheel"), cc.p(-1, 147), "animation", nil, nil, nil, true, true)
	titleS:setScale(1.25)

	self.triggerBoardNode:setScale(0)
	self.triggerBoardNode:setVisible(true)
	self.dimmer1:setOpacity(0)
    self.dimmer1:setVisible(true)

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.triggerBoardNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.2, 1.5, 1.5),
				cc.ScaleTo:create(0.1, 1, 1)
			))
			self.dimmer1:runAction(cc.FadeIn:create(0.3))
			self:showBonusBoardAnimation(self.wheel_boardT_aniNode, cc.p(-3, 6))
			self.theme:playMusic(self.theme.audio_list.wheel_start_show)
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			self.btn_start:setTouchEnabled(true)
			self:initStartEvent()
		end)
	))
end

function BSGame:playWheelScene()
    local duration = 0.5
	self.wheel_root:runAction(cc.MoveTo:create(duration, self.const.wheelDisplayPos))
	self.theme:playMusic(self.theme.audio_list.wheel_land)
end

function BSGame:showWheelScene()
    self.dimmer1:setOpacity(255)
    self.dimmer1:setVisible(true)
	self.wheel_root:setPosition(self.const.wheelDisplayPos)
end

function BSGame:playSpinBtnAnimation(state)
	self.btn_aniNode:removeAllChildren()
	if state == "idle" then
		local file = self.theme:getPic("spine/map/zhuanpan1")
		self.theme:addSpineAnimation(self.btn_aniNode, nil, file, cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
	elseif state == "click" then
		local file = self.theme:getPic("spine/map/zhuanpan2")
		self.theme:addSpineAnimation(self.btn_aniNode, nil, file, cc.p(0, 0), "animation")
	end
end

function BSGame:initSpinEvent()
	self.isClick = false
    
	local pressFunc = function(obj)
		self.isClick = true
		self.btn_spin:setTouchEnabled(false)
        self.theme:playMusic(self.theme.audio_list.wheel_click)
       
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				self:playSpinBtnAnimation("click")
			end),
			cc.DelayTime:create(0.3),
			cc.CallFunc:create(function()
				-- self.spinText:setColor(cc.c3b(92, 92, 92))
				self:spin() 
			end)
		)) 	        		
	end

	local function onTouch(obj, eventType)
		if self.isClick then return nil end
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end

	self.btn_spin:addTouchEventListener(onTouch)
end

function BSGame:spin()
	local function finishSpin() 
		self.theme:playMusic(self.theme.audio_list.wheel_end)
		if self.data.isWheelStop then
			self.data.isWheelStopExtra = true
		end

		self.data.isWheelStop = true
		self:saveBonus()
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				local file = self.theme:getPic("spine/map/zhuanpan3")
				self.theme:addSpineAnimation(self.win_aniNode, nil, file, cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
			end),
			cc.DelayTime:create(2.6),
			cc.CallFunc:create(function()
				self:playWheelBonusCollect()
			end)
		)) 
	end

	local node = self.wheel
	local wheelData= {
		itemCount = 4, -- 上下加一个 cell 之后的个数
		delayBeforeSpin = 0.0,   --开始旋转前的时间延迟
		upBounce = 0,    --开始滚动前，向上滚动距离
		upBounceTime = 0,   --开始滚动前，向上滚动时间
		speedUpTime = 1,   --加速时间
		rotateTime = 3,   -- 匀速转动的时间之和
		maxSpeed = 60*10,    --每一秒滚动的距离
		downBounce = 0,  --滚动结束前，向下反弹距离  都为正数值
		speedDownTime = 2, -- 4
		downBounceTime = 0,
		bounceSpeed = 0,
		direction = 1,
		endAngle = self.stopAngle
	}
	self.miniWheel = BaseWheelExtend.new(self, node, nil, wheelData, finishSpin)
	self.miniWheel:start()
	self.theme:playMusic(self.theme.audio_list.wheel_spin)
end

function BSGame:playWheelBonusCollect()	
	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			self:setCollectBoardState()
			self.collectBoardNode:setScale(0)
			self.btn_collect:setBright(true)
			self.collectBoardNode:setVisible(true)

			local rollupDuration = 3
			bole.setSpeicalLabelScale(self.label_wheelWin, self.winValue, self.labelWheelWinMaxWidth)
			self.label_wheelWin:nrStartRoll(0, self.winValue, rollupDuration)
			-- self:stopMusic(self.audio_list.win_rollUp)
			-- self:playMusic(self.audio_list.win_rollUp, true)
			self.collectBoardNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.2, 1.3, 1.3),
				cc.ScaleTo:create(0.1, 1, 1)
			))
			self.theme:playMusic(self.theme.audio_list.wheel_end_show)
			self.dimmer2:setOpacity(0)
            self.dimmer2:setVisible(true)
            self.dimmer2:runAction(cc.FadeIn:create(0.3))
            self:showBonusBoardAnimation(self.wheel_boardC_aniNode, cc.p(-3, -16))
            self.win_aniNode:removeAllChildren()
            self.data.end_game = true
			self:saveBonus()
			self.ctl:collectCoins(1)
		end),
		cc.DelayTime:create(0.3),
		cc.CallFunc:create(function()
			self.btn_collect:setTouchEnabled(true)
			self:initBonusCollectEvent()
		end)
	))
end

function BSGame:setCollectBoardState()
	if self.isBooster then
		local btn_collectSize = self.collectBoard_booster.btn:getContentSize()
		self.theme:addSpineAnimation(self.collectBoard_booster.btn, nil, self.theme:getPic("spine/dialog/anniu"), cc.p(btn_collectSize.width/2, btn_collectSize.height/2), "animation", nil, nil, nil, true, true)
		
		local _, titleS = self.theme:addSpineAnimation(self.collectBoard_booster.node, nil, self.theme:getPic("spine/dialog/cong"), cc.p(-2.5, 214.5), "animation", nil, nil, nil, true, true)
		titleS:setScale(1.25)
		self.theme:addSpineAnimation(self.collectBoard_booster.node, nil, self.theme:getPic("spine/dialog/kuang3"), cc.p(-4, 57.5), "animation2", nil, nil, nil, true, true)
		
		self.wheelCollectBoardBg:setPositionY(0)
		self.collectBoard_normal.node:setVisible(false)
		self.collectBoard_booster.node:setVisible(true)
		local booster_item = self.boosterItem
		for i = 1, 5 do
			self.collectBoard_booster.booster[i]:setVisible(i == booster_item)
		end
		self.label_wheelWin = self.collectBoard_booster.label_win
		self.btn_collect = self.collectBoard_booster.btn
		self.labelWheelWinMaxWidth = 470
	else
		
		local btn_collectSize = self.collectBoard_normal.btn:getContentSize()
		self.theme:addSpineAnimation(self.collectBoard_normal.btn, nil, self.theme:getPic("spine/dialog/anniu"), cc.p(btn_collectSize.width/2, btn_collectSize.height/2), "animation", nil, nil, nil, true, true)

		local _, titleS = self.theme:addSpineAnimation(self.collectBoard_normal.node, nil, self.theme:getPic("spine/dialog/cong"), cc.p(-3, 140), "animation", nil, nil, nil, true, true)
		titleS:setScale(1.25)

		self.wheelCollectBoardBg:setPositionY(22)
		local _, winKuangS = self.theme:addSpineAnimation(self.collectBoard_normal.node, nil, self.theme:getPic("spine/dialog/kuang3"), cc.p(-3.5, -27), "animation2", nil, nil, nil, true, true)
		winKuangS:setScale(1.2)

		self.collectBoard_normal.node:setVisible(true)
		self.collectBoard_booster.node:setVisible(false)
		self.label_wheelWin = self.collectBoard_normal.label_win
		self.btn_collect = self.collectBoard_normal.btn
		self.labelWheelWinMaxWidth = 560
	end
end

function BSGame:initBonusCollectEvent()
	self.isBonusCollectPress = false
	local pressFunc = function(obj)
		self.isBonusCollectPress = true
		self.btn_collect:setBright(false)
        self.btn_collect:setTouchEnabled(false)
        self.theme:playMusic(self.theme.audio_list.common_click)

		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				self.label_wheelWin:nrOverRoll()

				self.label_wheelWin:setString(FONTS.formatByCount2(self.winValue, 13, true))
				self.collectBoardNode:setScale(1)
		        self.collectBoardNode:setVisible(true)
		    	self.collectBoardNode:runAction(cc.Sequence:create(
					cc.ScaleTo:create(0.1, 1.3, 1.3),
					cc.ScaleTo:create(0.2, 0, 0)
				))
				self.dimmer2:setOpacity(255)
	            self.dimmer2:setVisible(true)
	            self.dimmer2:runAction(cc.FadeOut:create(0.3))
			end),
			cc.DelayTime:create(0.35),
			cc.CallFunc:create(function()
				self:stopBonusBoardAnimation(self.wheel_boardC_aniNode)
				self.dimmer2:setVisible(false)
				self.collectBoardNode:setVisible(false)
				self:onBonusExit()
			end)
		)) 
	end

	local function onTouch(obj, eventType)
		if self.isBonusCollectPress then return nil end
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end

	self.btn_collect:addTouchEventListener(onTouch)
end


function BSGame:playOutOfScene()
    local duration = 0.5
    self.dimmer1:setOpacity(255)
    self.dimmer1:setVisible(true)
	self.wheel_root:runAction(cc.MoveTo:create(duration, self.const.wheelAppearPos))
	self.dimmer1:runAction(cc.FadeOut:create(0.3))
end

function BSGame:onBonusExit()
	local function respinOver()
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				self.ctl.footer.isFreeSpin = false
				self.ctl.footer:changeLabelDescription("notFS_Win")
				self.saveWin = false
				self.ctl:removePointBet()
	            self.callback()
			end),
			cc.RemoveSelf:create()
		))
	end
	local user = User:getInstance()
	local curretCoin = user.coins
	local lineWin = self.ctl.totalWin

	local win = self.winValue
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.theme:setNextCollectTargetImage(self.theme.mapLevel)
			self.theme.mapPoints = 0
			self.theme:setCollectProgressImagePos(0)
			self:playOutOfScene()
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			self.theme:dealMusic_PlayNormalLoopMusic() -- baseBGM
			local data = {}
	    	data.mapLevel = self.mapLevel
	    	data.mapInfo = self.theme.mapData
			local theDialog = FireFortuneMapGame.new(self.theme, self.theme:getPic("csb/"), data)
	        theDialog:showMapScene(true)
		end),
		cc.DelayTime:create(5.5),
		cc.CallFunc:create(function()
			self.theme.boardType = self.bonusManager.boardType_stack
			self.ctl:startRollup(win, respinOver)
		end)
	))
end

function BSGame:showBonusBoardAnimation(node, pos)
	node:removeAllChildren()
	pos = pos or cc.p(0, 0)
	local file = self.theme:getPic("spine/dialog/kuang1")
	self.theme:addSpineAnimation(node, 2, file, pos, "animation", nil, nil, nil, true, true, nil)
end

function BSGame:stopBonusBoardAnimation(node)
	node:removeAllChildren()
end

function BSGame:onExit( ... )
	if self.miniWheel then 
		if self.miniWheel.scheduler then
	        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.miniWheel.scheduler)
	        self.miniWheel.scheduler = nil
	    end
	end
end


------------------------------------region map free------------------------------------
function BSGame:enterMapFreeBonus(tryResume)
	self.theme.curScene:addToContentFooter(self)
	if tryResume then
		self:playMapTriggerBoard()
	else
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				self.theme:playMusic(self.theme.audio_list.trigger_bell)
			end),
			cc.DelayTime:create(1),
			cc.CallFunc:create(function() 		
				self:playMapTriggerBoard()
			end)
		))
	end
end

function BSGame:setMapFreeTriggerBoardState()
	local mapFreeIndex = {[3] = 1, [7] = 2, [12] = 3, [18] = 4}
	local count = self.boosterAllCount
	 
	for i = 1, count do
		self.boosterGetList[i]:setVisible(true)
		if self.boosterGetInfo[i] then
			if i == 5 then
			   self.theme.isMapFreeAddPiggy = true
			end 	
		else
            self.boosterDimmerList[i]:setVisible(true)
		end
	end

	local index = self.mapLevel == 0 and 4 or mapFreeIndex[self.mapLevel]
	local free_counts_sp = self.boosterGetInfo[1] and "#164_congratulations_4_cnt24.png" or "#164_congratulations_4_cnt12.png"
	bole.updateSpriteWithFile(self.label_mapFreeCounts, free_counts_sp)
end

function BSGame:playMapTriggerBoard()
	local btn_mapFreestartSize = self.btn_mapFreestart:getContentSize() -- 
	self.theme:addSpineAnimation(self.btn_mapFreestart, nil, self.theme:getPic("spine/dialog/anniu"), cc.p(btn_mapFreestartSize.width/2, btn_mapFreestartSize.height/2), "animation", nil, nil, nil, true, true)

	local _, titleS = self.theme:addSpineAnimation(self.mapFreeTriggerNode, nil, self.theme:getPic("spine/dialog/cong"), cc.p(-2.5, 219), "animation", nil, nil, nil, true, true)
	titleS:setScale(1.25)

	self:setMapFreeTriggerBoardState()
	self.mapFreeTriggerNode:setScale(0)
	self.mapFreeTriggerNode:setVisible(true)
	self.dimmer:setOpacity(0)
    self.dimmer:setVisible(true)

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.mapFreeTriggerNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.2, 1.2),
				cc.ScaleTo:create(0.1, 1)
			))
			self.dimmer:runAction(cc.FadeIn:create(0.3))
			self:showBonusBoardAnimation(self.mapFreeT_board_aniNode, cc.p(-3, -14))
			self.theme:playMusic(self.theme.audio_list.map_dialog_start_show)
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			self:initMapFreeStartEvent()
		end)
	))
end

function BSGame:initMapFreeStartEvent()
	self.isMapFreeStartPress = false
	
	local pressFunc = function(obj)
	    self.data.isBoard = true
	    self.data.end_game = true
	    self.ctl:collectCoins(1)
	    self:saveBonus()
		self.isMapFreeStartPress = true
		self.btn_mapFreestart:setBright(false)
        self.btn_mapFreestart:setTouchEnabled(false)
        self.theme:playMusic(self.theme.audio_list.common_click)

		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				self.mapFreeTriggerNode:runAction(cc.Sequence:create(
					cc.ScaleTo:create(0.1, 1.2),
					cc.ScaleTo:create(0.2, 0)
				))
				self.dimmer:runAction(cc.FadeOut:create(0.3))
			end),
			cc.DelayTime:create(0.35),
			cc.CallFunc:create(function()
				self:stopBonusBoardAnimation(self.mapFreeT_board_aniNode)
				self:exitMapFreeBonus()
			end)
		)) 
	end

	local function onTouch(obj, eventType)
		if self.isMapFreeStartPress then return nil end
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end

	self.btn_mapFreestart:addTouchEventListener(onTouch)
end

function BSGame:exitMapFreeBonus()
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.theme:playTransition(nil, "free")
		end),
		cc.DelayTime:create(transitionDelay.free.onCover),
		cc.CallFunc:create(function()
			self.theme:setFreeSceneState()
			self.theme:setNextCollectTargetImage(self.theme.mapLevel)
			self.theme:setCollectProgressImagePos(0)
		end),
		cc.DelayTime:create(transitionDelay.free.onEnd - transitionDelay.free.onCover),
		cc.CallFunc:create(function()
			self.ctl.footer.isFreeSpin = false
			self.ctl.footer:changeLabelDescription("notFS_Win")
			self.saveWin = false
			self.theme:dealMusic_PlayMapLoopMusic()
			self.ctl:removePointBet()
			self.theme.bonusManager:exit()
            self.callback()
		end),
		cc.RemoveSelf:create()
	))
end

------------------------------region map free collect------------------------------
FireFortuneFreeCollect = class("FireFortuneFreeCollect", CCSNode)
local MapFreeCollect = FireFortuneFreeCollect

function MapFreeCollect:ctor(theme, csbPath, data)
	self.theme = theme
	self.csbPath = csbPath
	self.csb = csbPath .."map_free.csb"
	self.data = data

	self.mapLevel = self.data.mapLevel
	self.mapInfo = self.data.mapInfo
	self.free_theData = self.data.theData
	self.freeWin = self.free_theData.coins or 0

	self.enum = self.theme.enum
	self.p = self.theme.p
	if self.theme.mapPoints >= self.theme.maxMapPoints and self.mapLevel == 0 then
		self.mapLevel = self.theme.maxMapLevel
	end

	local boosterCountsList = {[3] = 2, [7] = 3, [12] = 4, [18] = 5}
	if self.mapLevel == 0 then
		self.boosterAllCount = 5
	else
	    self.boosterAllCount = boosterCountsList[self.mapLevel]
	end

	self.boosterCollectList = {}
	local data = self.mapInfo
	self.boosterCollectList = self.theme:getBoosterInfo(data)
	CCSNode.ctor(self, self.csb)
end

function MapFreeCollect:loadControls()
	self.dimmer = self.node:getChildByName("dimmer_node1")
    self.dimmer:setVisible(false)

    local mapFreeTriggerNode = self.node:getChildByName("trigger_board_node")
    mapFreeTriggerNode:setVisible(false)

    self.mapFreeCollectNode = self.node:getChildByName("collect_board_node")
    self.mapFreeCollectNode:setVisible(false)
    self.mapFreeC_board_aniNode = self.mapFreeCollectNode:getChildByName("board_ani_node")
    self.mapFreeC_board_boosterNode = self.mapFreeCollectNode:getChildByName("booster_node")
    self.boosterGetList = {}
    self.boosterDimmerList = {}
    for i = 1, 5 do
    	self.boosterGetList[i] = self.mapFreeC_board_boosterNode:getChildByName("booster"..i)
    	self.boosterGetList[i]:setVisible(false)
    	self.boosterDimmerList[i] = self.mapFreeC_board_boosterNode:getChildByName("dimmer"..i)
    	self.boosterDimmerList[i]:setVisible(false)
    end
    
    self.label_mapFreeCollectWin = self.mapFreeCollectNode:getChildByName("label_win")

    inherit(self.label_mapFreeCollectWin, LabelNumRoll)

	local function parseValue( num)
		return FONTS.format(num, true)
	end
	self.label_mapFreeCollectWin:nrInit(0, 25, parseValue)

    self.btn_mapFreeCollect = self.mapFreeCollectNode:getChildByName("btn_collect")
    self.btn_mapFreeCollect:setBright(true)

	local btn_mapFreeCollectSize = self.btn_mapFreeCollect:getContentSize()
	self.theme:addSpineAnimation(self.btn_mapFreeCollect, nil, self.theme:getPic("spine/dialog/anniu"), cc.p(btn_mapFreeCollectSize.width/2, btn_mapFreeCollectSize.height/2), "animation", nil, nil, nil, true, true)

	local _, titleS = self.theme:addSpineAnimation(self.mapFreeCollectNode, nil, self.theme:getPic("spine/dialog/cong"), cc.p(-3, 220), "animation", nil, nil, nil, true, true)
	titleS:setScale(1.25)
	self.theme:addSpineAnimation(self.mapFreeCollectNode, nil, self.theme:getPic("spine/dialog/kuang3"), cc.p(0, 64.50), "animation2", nil, nil, nil, true, true)
end

function MapFreeCollect:showMapFreeBoardAnimation(node, pos)
	node:removeAllChildren()
	local file = self.theme:getPic("spine/dialog/kuang1")
	local pos = pos or cc.p(0, 0)
	self.theme:addSpineAnimation(node, 2, file, pos, "animation", nil, nil, nil, true, true, nil)
end

function MapFreeCollect:stopMapFreeBoardAnimation(node)
	node:removeAllChildren()
end

function MapFreeCollect:setMapFreeCollectBoardState()
	local mapFreeIndex = {[3] = 1, [7] = 2, [12] = 3, [18] = 4}
	local count = self.boosterAllCount
	for i = 1, count do
		self.boosterGetList[i]:setVisible(true)
		if not self.boosterCollectList[i] then
			self.boosterDimmerList[i]:setVisible(true)
		end
	end
end

function MapFreeCollect:showMapFreeCollectDialog()
    self.theme.ctl.footer:setSpinButtonState(true)
	self.theme.curScene:addToContentFooter(self)
	self:setMapFreeCollectBoardState()
	self.mapFreeCollectNode:setScale(0)
	self.mapFreeCollectNode:setVisible(true)
	self.dimmer:setOpacity(0)
    self.dimmer:setVisible(true)
    if self.gameMasterSpineBS then
    	self.gameMasterSpineBS:setScale(0)
    end

    local delay_time = 0.5
    if self.theme.gameMasterFlag and self.theme.gameMasterFlag == 1 then
    	delay_time = 1.1
    end 

	self.theme:playMusic(self.theme.audio_list.map_dialog_collect_show)
	
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			if self.theme.gameMasterFlag and self.theme.gameMasterFlag == 1 then
				bole.setSpeicalLabelScale(self.label_mapFreeCollectWin, self.freeWin * 2, 470)
				self.label_mapFreeCollectWin:setString(FONTS.format(self.freeWin, true))
			else
				bole.setSpeicalLabelScale(self.label_mapFreeCollectWin, self.freeWin, 470)
				local rollupDuration = 3
				self.label_mapFreeCollectWin:nrStartRoll(0, self.freeWin, rollupDuration)
			end

			self.mapFreeCollectNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.2, 1.5, 1.5),
				cc.ScaleTo:create(0.1, 1, 1)
			))
			self.dimmer:runAction(cc.FadeIn:create(0.3))
			self:showMapFreeBoardAnimation(self.mapFreeC_board_aniNode, cc.p(-3, -12))
			self.theme:stopDrawAnimate()
			self.theme.ctl.theme_reels.free_reel = self.theme:getFreeThemeReel(1)
		end),
		cc.DelayTime:create(delay_time),
		cc.CallFunc:create(function()
			self.btn_mapFreeCollect:setTouchEnabled(true)
			self:initMapFreeCollectEvent()
		end)
	))
end

function MapFreeCollect:initMapFreeCollectEvent()
	self.isMapFreeCollectPress = false
	local pressFunc = function(obj)
		self.isMapFreeCollectPress = true
		self.btn_mapFreeCollect:setBright(false)
        self.btn_mapFreeCollect:setTouchEnabled(false)
        self.theme:playMusic(self.theme.audio_list.common_click)
        self.label_mapFreeCollectWin:nrOverRoll()

		self:runAction(cc.Sequence:create(
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function()
				self.mapFreeCollectNode:runAction(cc.Sequence:create(
					cc.ScaleTo:create(0.1, 1.5, 1.5),
					cc.ScaleTo:create(0.2, 0, 0)
				))
				self.dimmer:runAction(cc.FadeOut:create(0.3))
			end),
			cc.DelayTime:create(0.35),
			cc.CallFunc:create(function()
				self:stopMapFreeBoardAnimation(self.mapFreeC_board_aniNode)
				self.theme:exitMapFreeGame(self.free_theData)
			end),
			cc.RemoveSelf:create()
		)) 
	end

	local function onTouch(obj, eventType)
		if self.isMapFreeCollectPress then return nil end
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end

	self.btn_mapFreeCollect:addTouchEventListener(onTouch)
end
------------------------------endregion------------------------------



------------------------------region map------------------------------
function cls:setReelSymbolsState(isShow)
	for i = 1, 5 do
		for j = 1, 3 do
			local cell = self.spinLayer.spins[i]:getRetCell(j)
			cell:setVisible(isShow)
		end
	end
	self.animateNode:setVisible(isShow)
end

function cls:getBoosterInfo(data)
	if not data then return end

	local table = {false, false, false, false, false}
	if data.extra_fg > 0 then table[1] = true end
	if data.extra_wild == 1 then table[2] = true end
	if data.reel_count == 1 then table[3] = true end
	if data.row_count == 1 then table[4] = true end
	if data.sticky_wild == 1 then table[5] = true end

	return table
end

FireFortuneMapGame = class("FireFortuneMapGame", CCSNode)
local MapGame = FireFortuneMapGame
---- data structure
-- "map_info": {"map_level": 0, "booster_count": 0, "avg_bet": 0, "reel_count": 0, "extra_fg": 0, "wager_count": 0, "map_points": 0,
-- "wild_double": 0, "row_count": 0, "map_level_accu": 0, "wager": 0, "extra_wild": 0}

local buildingLevel = Set({3, 7, 12, 18})
local nextBuildingLevel = {[0] = 3, 3, 3, 7, 7, 7, 7, 12, 12, 12, 12, 12, 18, 18, 18, 18, 18, 18, 3}
local boosterLevelCount = {[0] = 0, 1, 2, 0, 1, 2, 3, 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 5, 5}
local boosterLevelCount_bonus = {[0] = 0, 1, 2, 2, 1, 2, 3, 3, 1, 2, 3, 4, 4, 1, 2, 3, 4, 5, 5}
local boosterCountsList = {[3] = 2, [7] = 3, [12] = 4, [18] = 5}
local buildingAnimName = {[3] = "animation1", [7] = "animation2" , [12] = "animation3" , [18] = "animation4" }

function MapGame:ctor(theme, csbPath, data)
	self.theme = theme
	self.csbPath = csbPath
	self.csb = csbPath .. "map.csb"
	self.data = data
	
	self.const = {
		mapAvantPos = cc.p(410, 676),
		mapFinalPos = cc.p(410, 216),
	}
	self:initFunction()
	self.mapLevel = self.data.mapLevel
	self.mapInfo = self.data.mapInfo
	if self.theme.mapPoints >= self.theme.maxMapPoints and self.mapLevel == 0 then
		self.mapLevel = self.theme.maxMapLevel
	end
	local data = self.mapInfo
	self.boosterTriggerList = self.theme:getBoosterInfo(data)

	CCSNode.ctor(self, self.csb)
end

function MapGame:initFunction()
	self.enum = self.theme.enum
	self.p = self.theme.p
	self.createIntegerDomain = self.theme.createIntegerDomain
	self.containsInteger = self.theme.containsInteger
	self.setLabelScale = self.theme.setLabelScale
	self.setString = self.theme.setString
	self.playSpineAnimation = self.theme.playSpineAnimation
	self.playMusicOverride = self.theme.playMusicOverride
	self.stopMusicById = self.theme.stopMusicById
	self.playBgm = self.theme.playBgm
	self.stopBgm = self.theme.stopBgm
	self.changeBgm = self.theme.changeBgm
end

function MapGame:loadControls()
	self.root = self.node:getChildByName("root")
	local map_node = self.root:getChildByName("map_node")
	map_node:setScrollBarEnabled(false)
	self.mapContainerNode = map_node
	self.mapNode = map_node:getChildByName("map_items")
	self.userIcon = self.mapNode:getChildByName("user_icon")
	self.userIcon:setScale(1)
	local bg_node = self.mapNode:getChildByName("bg_node")
	self.startPos = bg_node:getChildByName("startPos")

	self.mapItemList = {}
	for i = 1, 18 do
		local node = self.mapNode:getChildByName("map_item"..i)
		self.mapItemList[i] = node
		self.mapItemList[i].nIconPos = node:getChildByName("iconPos")
		if buildingLevel[i] then
			self.mapItemList[i].tableNode = node:getChildByName("booster_table_node")
			self.mapItemList[i].tableNode:setCascadeOpacityEnabled(true)
			self.mapItemList[i].tableNode:setOpacity(255)
			self.mapItemList[i].booster = {}
			self.mapItemList[i].right = {}
			self.mapItemList[i].wrong = {}
			self.mapItemList[i].lBoosters = self.mapItemList[i].tableNode:getChildByName("label")
			self.mapItemList[i].lBoosterTriggered = self.mapItemList[i].lBoosters:getChildByName("lBoosterTriggered")
			self.mapItemList[i].lBoosterTriggered:setString(0)
			for k = 1, boosterCountsList[i] do
				self.mapItemList[i].booster[k] = self.mapItemList[i].tableNode:getChildByName("booster"..k)
				self.mapItemList[i].booster[k]:setVisible(false)
	            self.mapItemList[i].right[k] = self.mapItemList[i].tableNode:getChildByName("right"..k)
	            self.mapItemList[i].right[k]:setVisible(false)
	            self.mapItemList[i].wrong[k] = self.mapItemList[i].tableNode:getChildByName("wrong"..k)
	            self.mapItemList[i].wrong[k]:setVisible(false)
	        end
	        self.mapItemList[i].buildImage = node:getChildByName("state0")
	    else
	    	self.mapItemList[i].stageImage1 = node:getChildByName("state1")
	    	self.mapItemList[i].stageImage1:setVisible(false)
			self.mapItemList[i].aniNode = node:getChildByName("aIgnite")
	    end
	end
end

function MapGame:configMapInfo(index, isBonus)
	local next_bul_level = nextBuildingLevel[index]
	local itemTriggerCounts = 0
	for i = 1, 18 do
		if i <= index then
			if buildingLevel[i] then
				self.mapItemList[i].tableNode:setOpacity(0)
			    -- self.mapItemList[i].buildImage:setColor(cc.c3b(92, 92, 92))
			    local buildSize = self.mapItemList[i].buildImage:getContentSize()
    			self.theme:addSpineAnimation(self.mapItemList[i].buildImage, 5, self.theme:getPic("spine/map/dianliang"), cc.p(buildSize.width/2, buildSize.height/2), buildingAnimName[i].."_1", nil, nil, nil, true, true)
			else
				self.mapItemList[i].stageImage1:setVisible(false) -- self.mapItemList[i].stageImage1:setVisible(true)
				local file = self.theme:getPic("spine/map/dituhuo")
    			local parent = self.mapItemList[i].aniNode
				local _, s = self.theme:addSpineAnimation(parent, 5, file, cc.p(0, 0), "animation2", nil, nil, nil, true, true, nil)
			end
		else
			if buildingLevel[i] then
				for n = 1, boosterCountsList[i] do
					self.mapItemList[i].booster[n]:setVisible(false)
					self.mapItemList[i].right[n]:setVisible(false)
					self.mapItemList[i].wrong[n]:setVisible(false)
				end
				self.mapItemList[i].tableNode:setOpacity(255)
				
				if i == next_bul_level then
				    local showBoosterCount = boosterLevelCount[index]
				    if isBonus then -- if bonus, we should display all the win
				    	showBoosterCount = boosterLevelCount_bonus[index+1]
				    end
				    self.mapItemList[i].lBoosterTriggered:setString(itemTriggerCounts)
				    if showBoosterCount > 0 then
				   	    for m = 1, showBoosterCount do
				   	  	    self.mapItemList[i].booster[m]:setVisible(true)
				   	  	    if self.boosterTriggerList[m] then
				   	  	  	   self.mapItemList[i].right[m]:setVisible(true)
				   	  	  	   itemTriggerCounts = itemTriggerCounts + 1
				   	  	  	   self.mapItemList[i].lBoosterTriggered:setString(itemTriggerCounts)
				   	  	    else
				   	  	  	   self.mapItemList[i].wrong[m]:setVisible(true)
				   	  	    end
				   	  	end
				   	end
				end
			else
				self.mapItemList[i].stageImage1:setVisible(false)
			end
		end
	end

end

function MapGame:getContainerPosX(step_index)
	local sizex = self.mapContainerNode:getContentSize().width - self.mapContainerNode:getInnerContainerSize().width
	local offset = self.mapContainerNode:getContentSize().width/2 - self.mapItemList[step_index]:getPositionX()
	if offset > 0 then
		offset = 0
	elseif offset < sizex then
		offset = sizex
	end
	return offset
end

function MapGame:setMapPosition(step_index)
	step_index = step_index > 0 and step_index or 1
	local posx = self:getContainerPosX(step_index)
	local layout = self.mapContainerNode:getInnerContainer()
	local posy = layout:getPositionY()
	layout:setPosition(cc.p(posx, posy))
end

function MapGame:showMapForwardPosition(next_index)
	if next_index == 0 or next_index - 1 == 0 then return end
	local layout = self.mapContainerNode:getInnerContainer()
	self:setMapPosition(next_index - 1)
	local posX = self:getContainerPosX(next_index)
	local posY = layout:getPositionY()
	layout:runAction(cc.MoveTo:create(0.5, cc.p(posX, posY)))
end

function MapGame:getIndexPosition(index)
	if index == 0 or index == -1 then
		local b = self.startPos
		return self.mapNode:convertToNodeSpace(b:getParent():convertToWorldSpace(cc.p(b:getPosition())))
	else
		local a = self.mapItemList[index].nIconPos
		return self.userIcon:getParent():convertToNodeSpace(a:getParent():convertToWorldSpace(cc.p(a:getPosition())))
	end
end

function MapGame:setUserIconPosition(index)
	self.userIcon:setPosition(self:getIndexPosition(index))
end

function MapGame:showUserIconForwardPosition(next_index)
	local start_pos = self:getIndexPosition(next_index-1)
	local pos = self:getIndexPosition(next_index)
    self:parabolaToAnimation(self.userIcon, next_index, start_pos, pos, 0.5)
    self.theme:playMusic(self.theme.audio_list.move)
end

function MapGame:parabolaToAnimation(obj, index, from, to, duration)
	local radian_config = 
	{
       [1] = {54, 150}, [2] = {54, 90}, [3] = {91, 112}, [7] = {93, 126}, [12] = {99, 126}, [18] = {92, 126}
	}
	
	local from = from or self:getIndexPosition(index-1)
	local to = to or self:getIndexPosition(index)
	local config = radian_config[2]
	if index == 1 or buildingLevel[index] then
	   config = radian_config[index]
	end

	local myBezier = function (p0, p1, p2, duration, frame)
		local t = frame / duration
		if t > 1 then t = 1 end
		local x = math.pow(1-t, 2)*p0.x + 2*t*(1-t)*p1.x + math.pow(t, 2)*p2.x
		local y = math.pow(1-t, 2)*p0.y + 2*t*(1-t)*p1.y + math.pow(t, 2)*p2.y

		return cc.p(x, y)
	end

	local cp = cc.p(from.x + config[1], from.y + config[2])
	local frame = 1

	obj:runAction(cc.Repeat:create(cc.Sequence:create(
		cc.CallFunc:create(function () 
			frame = frame or 1
			local pos = myBezier(from, cp, to, duration*60, frame)
			obj:setPosition(pos)
			frame = frame + 1
		end),
		cc.DelayTime:create(1/60)
		), duration*60
	))
end

function MapGame:showMapScene(isBonus)
	self.theme.isMapOpen = true
	
	-- close blast tip window
	-- BlastController:getInstance():showBlastTips(false)

	if isBonus then
		self:setMapPosition(self.mapLevel-1)
	    self:configMapInfo(self.mapLevel-1, isBonus)
	    self:setUserIconPosition(self.mapLevel-1)
	else
		self:setMapPosition(self.mapLevel)
	    self:configMapInfo(self.mapLevel, isBonus)
	    self:setUserIconPosition(self.mapLevel)

		self.old_parent_btnInfo = self.theme.baseScene.bMapInfo:getParent()
		self.old_Zorder_btnInfo = self.theme.baseScene.bMapInfo:getLocalZOrder()
		bole.changeParent(self.theme.baseScene.bMapInfo, self.theme.baseScene.nCollectBack)
	end

	local function initBackBtn()
		local pressFunc = function(obj)
	        self.theme.baseScene.bMapInfo:setTouchEnabled(false)
	        self.theme.baseScene.bMapInfo:setBright(false)
	    	self.theme:playMusic(self.theme.audio_list.common_click)
	        self:exitMapScene(false)
	    end

		local function onTouch(obj, eventType)
			if eventType == ccui.TouchEventType.ended then
				pressFunc(obj)
			end
		end

		self.theme.baseScene.bMapInfo:addTouchEventListener(onTouch)
	end
    
    self.theme.baseScene.nMapLoad:addChild(self)
    self.theme.baseScene.nMapLoad:setPosition(self.const.mapAvantPos)
    self.theme:playMusic(self.theme.audio_list.map_open)
	self.theme.baseScene.nMapLoad:runAction(cc.Sequence:create(
		cc.MoveTo:create(0.3, self.const.mapFinalPos),
        cc.CallFunc:create(function()
        	self.theme:setReelSymbolsState(false)
        	if isBonus then
        		self:showIncreaseAnimation(isBonus)
        	else
	        	self.theme.baseScene.bMapInfo:setTouchEnabled(true)
		        self.theme.baseScene.bMapInfo:setBright(true)
		        initBackBtn()
		    end
        end)
	))
end

function MapGame:showIncreaseAnimation(isBonus)
    local function showCustomLevelAnimation()
    	local file = self.theme:getPic("spine/map/dituhuo")
    	local parent = self.mapItemList[self.mapLevel].aniNode
    	
    	self:runAction(cc.Sequence:create(
    		cc.CallFunc:create(function()
    			local _, s = self.theme:addSpineAnimation(parent, 5, file, cc.p(0, 0), "animation1", nil, nil, nil, true, false, nil)
    	        self.safeBoxSkeleton = s
    	        self.theme:playMusic(self.theme.audio_list.totem_fire)
    		end),
    		cc.DelayTime:create(1),
    		cc.CallFunc:create(function()
    			self.safeBoxSkeleton:setAnimation(0, "animation2", true)
    			-- self.theme:addSpineAnimation(parent, 10, file, cc.p(0, 0), "animation3", nil, nil, nil, false, false, nil)
    		end)
    	))
    end

    local function showBuildingLevelAnimation()
    	self.mapItemList[self.mapLevel].tableNode:setOpacity(255)
    	-- self.mapItemList[self.mapLevel].buildImage:setColor(cc.c3b(92, 92, 92))
    	self.mapItemList[self.mapLevel].tableNode:runAction(cc.FadeOut:create(0.3))
    	self.theme:playMusic(self.theme.audio_list.house_fire)
    	local buildSize = self.mapItemList[self.mapLevel].buildImage:getContentSize()
    	local _, s = self.theme:addSpineAnimation(self.mapItemList[self.mapLevel].buildImage, 5, self.theme:getPic("spine/map/dianliang"), cc.p(buildSize.width/2, buildSize.height/2), buildingAnimName[self.mapLevel], nil, nil, nil, true)
    	s:runAction(cc.Sequence:create(
    		cc.DelayTime:create(0.5),
    		cc.CallFunc:create(function ( ... )
    			if bole.isValidNode(s) then 
    				bole.spChangeAnimation(s, buildingAnimName[self.mapLevel].."_1", true)
    			end
    		end)))
    end

    local aniDelay = 1
    if buildingLevel[self.mapLevel] then
    	aniDelay = 1
    end

    self:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()   		
			if buildingLevel[self.mapLevel] then
				showBuildingLevelAnimation()
			else
				showCustomLevelAnimation()
			end	   	
		end),
		cc.DelayTime:create(aniDelay),
		cc.CallFunc:create(function()   		
			self:showUserIconForwardPosition(self.mapLevel)
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			self:showMapForwardPosition(self.mapLevel)
		end),
		cc.DelayTime:create(2.8),
		cc.CallFunc:create(function()
			self:exitMapScene(isBonus)
		end)
	))
end


function MapGame:exitMapScene(isBonus, isForbid)
	self.theme.isMapOpen = false
	if not isBonus then
	   bole.changeParent(self.theme.baseScene.bMapInfo, self.old_parent_btnInfo, self.old_Zorder_btnInfo)
	   self.mapContainerNode:stopAutoScroll()
	end
	
	self.theme.baseScene.nMapLoad:setPosition(self.const.mapFinalPos)
	self.theme:setReelSymbolsState(true)
	self.theme.baseScene.nMapLoad:stopAllActions()
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.theme.baseScene.nMapLoad:runAction(cc.MoveTo:create(0.3, self.const.mapAvantPos))	
			self.theme:playMusic(self.theme.audio_list.map_close)	       
		end),
		cc.CallFunc:create(function()
			if isForbid then
				self.theme:enableMapInfoBtn(false)
			else
        	    self.theme.baseScene.bMapInfo:setTouchEnabled(true)
	            self.theme.baseScene.bMapInfo:setBright(true)
	            self.theme:enableMapInfoBtn(true)
	        end
        end),
		cc.DelayTime:create(0.3),
		cc.CallFunc:create(function()
			if isBonus then
				self.theme.ctl.footer:enableOtherBtns(true)
				if buildingLevel[self.mapLevel] then
					self.theme:resetMapInfoData()
					self.theme.mapPoints = 0
					if self.mapLevel == 18 then
						self.theme:showCollectTip(2)
					end 		    
				end
			end
		end),
		cc.RemoveSelf:create()
	))
end
------------------------------endregion------------------------------



---------------------------声音相关----------------------------------------------

function cls:configAudioList()
	Theme.configAudioList(self)
	self.audio_list = self.audio_list or {}

	-- base
	self.audio_list.anticipation	= "audio/base/symbol_scatter.mp3" --- scatter落地
	self.audio_list.symbol_fly 		= "audio/base/symbol_fly.mp3" -- Scatter向收集条收集+接受+增长音效
	self.audio_list.full 			= "audio/base/full.mp3"
	self.audio_list.unlock			= "audio/base/unlock.mp3"
	self.audio_list.lock			= "audio/base/lock.mp3"
	self.audio_list.wild_nudge		= "audio/base/wild_nudge.mp3" -- Wild充满整个轮轴的音效
	self.audio_list.wild_land		= "audio/base/wild_land.mp3" -- 单个random wild出现
	self.audio_list.random_notify	= "audio/base/random_notify.mp3" -- random wild出现提示动画（女人墩矛）
	self.audio_list.transition_bonus = "audio/base/transition_respin.mp3"
	self.audio_list.common_click 	= "audio/base/common_click.mp3"

	-- respin
	self.audio_list.bonus_background = "audio/bonus/respin_bgm.mp3" -- 超级轮轴激励（火焰燃烧），只有正框点亮的音效
	self.audio_list.reel_notify2 	= "audio/bonus/reel_notify2.mp3" -- 超级轮轴激励（火焰燃烧），只有正框点亮的音效
	self.audio_list.shake2 			= "audio/bonus/shake1.mp3" 
	self.audio_list.shake3 			= "audio/bonus/shake2.mp3" 
	self.audio_list.shake4 			= "audio/bonus/shake3.mp3" 
	self.audio_list.shake5 			= "audio/bonus/shake4.mp3" 
	self.audio_list.full_reel_show 	= "audio/bonus/full_reel_show.mp3" -- respin内小赢钱弹窗出现音效
	self.audio_list.fire 			= "audio/bonus/fire.mp3" 		-- respin内小赢钱弹窗出现音效
	self.audio_list.multiple_fly 	= "audio/bonus/multiple_fly.mp3" -- 第五列出现+旋转+数字飞行+爆炸接收
	self.audio_list.mystery_jackpot = "audio/bonus/mystery_jackpot.mp3" -- 触发神秘JP弹板
	self.audio_list.jp_select_1 	= "audio/bonus/jp_select_1.mp3" -- jp选择音效，5种选择音效
	self.audio_list.jp_select_2 	= "audio/bonus/jp_select_2.mp3" -- jp选择音效，5种选择音效
	self.audio_list.jp_select_3 	= "audio/bonus/jp_select_3.mp3" -- jp选择音效，5种选择音效
	self.audio_list.jp_select_4 	= "audio/bonus/jp_select_4.mp3" -- jp选择音效，5种选择音效
	self.audio_list.jp_select_5 	= "audio/bonus/jp_select_5.mp3" -- jp选择音效，5种选择音效
	self.audio_list.jp_win_dialog1 	= "audio/bonus/jp_win_grand.mp3" -- jp选择音效，5种选择音效
	self.audio_list.jp_win_dialog2 	= "audio/bonus/jp_win_major.mp3" -- jp选择音效，5种选择音效
	self.audio_list.jp_win_dialog3 	= "audio/bonus/jp_win_maxi.mp3" -- jp选择音效，5种选择音效
	self.audio_list.jp_win_dialog4 	= "audio/bonus/jp_win_minor.mp3" -- jp选择音效，5种选择音效
	self.audio_list.jp_win_dialog5 	= "audio/bonus/jp_win_mini.mp3" -- jp选择音效，5种选择音效

	-- free
	self.audio_list.retrigger_bell 		= "audio/base/bell.mp3"

	-- wheel
	self.audio_list.wheel_land			= "audio/wheel/wheel_land.mp3" -- 转盘出现
	self.audio_list.wheel_click			= "audio/wheel/wheel_click.mp3" -- 转盘点击
	self.audio_list.wheel_spin			= "audio/wheel/wheel_spin.mp3" -- 转盘转
	self.audio_list.wheel_end			= "audio/wheel/wheel_end.mp3" -- 小转盘停选中区域
	
	-- map
	self.audio_list.map_background 			= "audio/map/map_bgm.mp3"
	self.audio_list.add_extra_wild 			= "audio/map/100wild.mp3"
	self.audio_list.show_extra_wild_board 	= "audio/map/100wild_board.mp3"
	
	self.audio_list.map_open 		= "audio/map/map_open.mp3"
	self.audio_list.map_close 		= "audio/map/map_close.mp3"
	self.audio_list.move 			= "audio/map/move.mp3"
	self.audio_list.totem_fire 		= "audio/map/totem_fire.mp3" -- 图腾点火
	-- self.audio_list.house_fire 		= "audio/map/house_fire.mp3" -- 图腾点火
	self.audio_list.tips 			= "audio/map/tips.mp3" -- 提示栏打开合上提示音
	self.audio_list.map_dialog_start_show 	= "audio/map/map_dialog_start_show.mp3" -- 地图free 开始
	self.audio_list.map_dialog_collect_show = "audio/map/map_dialog_collect_show.mp3" -- 地图free 结束
end

function cls:getLoadMusicList()
	local loadMuscList = 
	{
		self.audio_list.anticipation,
		self.audio_list.symbol_fly,
		self.audio_list.full,
		self.audio_list.unlock,
		self.audio_list.lock,
		self.audio_list.wild_nudge,
		self.audio_list.wild_land,
		self.audio_list.random_notify,
		self.audio_list.common_click,

		self.audio_list.reel_notify2,
		self.audio_list.shake2,
		self.audio_list.shake3,
		self.audio_list.shake4,
		self.audio_list.shake5,
		self.audio_list.full_reel_show,
		self.audio_list.fire,
		self.audio_list.multiple_fly,
		self.audio_list.mystery_jackpot,
		self.audio_list.jp_select_1,
		self.audio_list.jp_select_2,
		self.audio_list.jp_select_3,
		self.audio_list.jp_select_4,
		self.audio_list.jp_select_5,
		self.audio_list.jp_win_dialog1,
		self.audio_list.jp_win_dialog2,
		self.audio_list.jp_win_dialog3,
		self.audio_list.jp_win_dialog4,
		self.audio_list.jp_win_dialog5,

		self.audio_list.retrigger_bell,
		self.audio_list.add_extra_wild,
		self.audio_list.show_extra_wild_board,

		self.audio_list.wheel_land,
		self.audio_list.wheel_click,
		self.audio_list.wheel_spin,
		self.audio_list.wheel_end,

		self.audio_list.map_open,
		self.audio_list.map_close,
		self.audio_list.move,
		self.audio_list.totem_fire,
		-- self.audio_list.house_fire,
		self.audio_list.tips,
		self.audio_list.map_dialog_start_show,
		self.audio_list.map_dialog_collect_show,
	}
	return loadMuscList
end

function cls:dealMusic_PlayBonusLoopMusic()
	self:stopAllLoopMusic()
	self:playLoopMusic(self.audio_list.bonus_background)
end

function cls:dealMusic_PlayMapLoopMusic()
	self:stopAllLoopMusic()
	self:playLoopMusic(self.audio_list.map_background)
end

function cls:dealMusic_PlayFreeSpinLoopMusic( ... )
end

function cls:getFreeThemeReel(FreeType)
	local freeReel
	if FreeType == 1 then -- normal
		freeReel = {
			{6,7,8,2,2,2,2,9,10,6,3,3,3,3,7,8,9,4,4,4,4,10,6,7,5,5,5,5,8,9,10,6,6,6,6,2,8,5,7,7,7,7,3,9,4,8,8,8,8,2,10,5,9,9,9,9,3,6,4,10,10,10,10,2,7,8,5,12,12,12,12,12,12,12,12,9,10,3,7,8,4,9,10,6,7,8,2,7,8,5,9,10,3,7,8,4,6,12,12,12,12,12,12,12,12,9,10,2,7,8,5,9,10,3,7,8,4,9,10,6,2,7,8,5,9,10,3,7,8,4,9,10,6,24,23,22,21},
			{9,10,6,2,2,2,2,6,7,8,3,3,3,3,10,6,7,4,4,4,4,7,8,9,5,5,5,5,10,9,8,6,6,6,6,3,8,4,7,7,7,7,2,9,5,8,8,8,8,3,10,4,9,9,9,9,2,6,5,10,10,10,10,3,7,8,4,12,12,12,12,12,12,12,12,9,10,2,7,8,5,9,10,6,7,8,3,7,8,4,9,10,2,7,8,5,6,12,12,12,12,12,12,12,12,9,10,3,7,8,4,9,10,2,7,8,5,9,10,6,3,7,8,4,9,10,2,7,8,5,9,10,6,24,23,22,21},
			{6,7,8,2,2,2,2,9,10,6,3,3,3,3,7,8,9,4,4,4,4,10,6,7,5,5,5,5,8,9,10,6,6,6,6,2,8,5,7,7,7,7,3,9,4,8,8,8,8,2,10,5,9,9,9,9,3,6,4,10,10,10,10,2,7,8,5,12,12,12,12,12,12,12,12,9,10,3,7,8,4,9,10,6,7,8,2,7,8,5,9,10,3,7,8,4,6,12,12,12,12,12,12,12,12,9,10,2,7,8,5,9,10,3,7,8,4,9,10,6,2,7,8,5,9,10,3,7,8,4,9,10,6,24,23,22,21},
			{9,10,6,2,2,2,2,6,7,8,3,3,3,3,10,6,7,4,4,4,4,7,8,9,5,5,5,5,10,9,8,6,6,6,6,3,8,4,7,7,7,7,2,9,5,8,8,8,8,3,10,4,9,9,9,9,2,6,5,10,10,10,10,3,7,8,4,12,12,12,12,12,12,12,12,9,10,2,7,8,5,9,10,6,7,8,3,7,8,4,9,10,2,7,8,5,6,12,12,12,12,12,12,12,12,9,10,3,7,8,4,9,10,2,7,8,5,9,10,6,3,7,8,4,9,10,2,7,8,5,9,10,6,24,23,22,21},
			{6,7,8,2,2,2,2,9,10,6,3,3,3,3,7,8,9,4,4,4,4,10,6,7,5,5,5,5,8,9,10,6,6,6,6,2,8,5,7,7,7,7,3,9,4,8,8,8,8,2,10,5,9,9,9,9,3,6,4,10,10,10,10,2,7,8,5,12,12,12,12,12,12,12,12,9,10,3,7,8,4,9,10,6,7,8,2,7,8,5,9,10,3,7,8,4,6,12,12,12,12,12,12,12,12,9,10,2,7,8,5,9,10,3,7,8,4,9,10,6,2,7,8,5,9,10,3,7,8,4,9,10,6,24,23,22,21}
		}
	elseif FreeType == 2 then -- 4*5
		freeReel = {
			{6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 24, 23, 22, 21},
			{9, 10, 6, 2, 2, 2, 2, 6, 7, 8, 3, 3, 3, 3, 10, 6, 7, 4, 4, 4, 4, 7, 8, 9, 5, 5, 5, 5, 10, 9, 8, 6, 6, 6, 6, 3, 8, 4, 7, 7, 7, 7, 2, 9, 5, 8, 8, 8, 8, 3, 10, 4, 9, 9, 9, 9, 2, 6, 5, 10, 10, 10, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 7, 8, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 6, 9, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 24, 23, 22, 21},
			{6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 24, 23, 22, 21},
			{9, 10, 6, 2, 2, 2, 2, 6, 7, 8, 3, 3, 3, 3, 10, 6, 7, 4, 4, 4, 4, 7, 8, 9, 5, 5, 5, 5, 10, 9, 8, 6, 6, 6, 6, 3, 8, 4, 7, 7, 7, 7, 2, 9, 5, 8, 8, 8, 8, 3, 10, 4, 9, 9, 9, 9, 2, 6, 5, 10, 10, 10, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 7, 8, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 6, 9, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 24, 23, 22, 21},
			{6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 24, 23, 22, 21},			
	    }
	elseif FreeType == 3 then -- 4*6
		freeReel = {
			{6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 24, 23, 22, 21},
			{9, 10, 6, 2, 2, 2, 2, 6, 7, 8, 3, 3, 3, 3, 10, 6, 7, 4, 4, 4, 4, 7, 8, 9, 5, 5, 5, 5, 10, 9, 8, 6, 6, 6, 6, 3, 8, 4, 7, 7, 7, 7, 2, 9, 5, 8, 8, 8, 8, 3, 10, 4, 9, 9, 9, 9, 2, 6, 5, 10, 10, 10, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 7, 8, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 6, 9, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 24, 23, 22, 21},
			{6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 24, 23, 22, 21},
			{9, 10, 6, 2, 2, 2, 2, 6, 7, 8, 3, 3, 3, 3, 10, 6, 7, 4, 4, 4, 4, 7, 8, 9, 5, 5, 5, 5, 10, 9, 8, 6, 6, 6, 6, 3, 8, 4, 7, 7, 7, 7, 2, 9, 5, 8, 8, 8, 8, 3, 10, 4, 9, 9, 9, 9, 2, 6, 5, 10, 10, 10, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 7, 8, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 6, 9, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 24, 23, 22, 21},
			{6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 24, 23, 22, 21},
			{9, 10, 6, 2, 2, 2, 2, 6, 7, 8, 3, 3, 3, 3, 10, 6, 7, 4, 4, 4, 4, 7, 8, 9, 5, 5, 5, 5, 10, 9, 8, 6, 6, 6, 6, 3, 8, 4, 7, 7, 7, 7, 2, 9, 5, 8, 8, 8, 8, 3, 10, 4, 9, 9, 9, 9, 2, 6, 5, 10, 10, 10, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 7, 8, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 6, 9, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 24, 23, 22, 21},
	    }
	elseif FreeType == 4 then --5*6
		freeReel = {
			{6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 29, 28, 27, 26, 25},
			{9, 10, 6, 2, 2, 2, 2, 6, 7, 8, 3, 3, 3, 3, 10, 6, 7, 4, 4, 4, 4, 7, 8, 9, 5, 5, 5, 5, 10, 9, 8, 6, 6, 6, 6, 3, 8, 4, 7, 7, 7, 7, 2, 9, 5, 8, 8, 8, 8, 3, 10, 4, 9, 9, 9, 9, 2, 6, 5, 10, 10, 10, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 7, 8, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 6, 9, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 29, 28, 27, 26, 25},
			{6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 29, 28, 27, 26, 25},
			{9, 10, 6, 2, 2, 2, 2, 6, 7, 8, 3, 3, 3, 3, 10, 6, 7, 4, 4, 4, 4, 7, 8, 9, 5, 5, 5, 5, 10, 9, 8, 6, 6, 6, 6, 3, 8, 4, 7, 7, 7, 7, 2, 9, 5, 8, 8, 8, 8, 3, 10, 4, 9, 9, 9, 9, 2, 6, 5, 10, 10, 10, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 7, 8, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 6, 9, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 29, 28, 27, 26, 25},
			{6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 29, 28, 27, 26, 25},
			{9, 10, 6, 2, 2, 2, 2, 6, 7, 8, 3, 3, 3, 3, 10, 6, 7, 4, 4, 4, 4, 7, 8, 9, 5, 5, 5, 5, 10, 9, 8, 6, 6, 6, 6, 3, 8, 4, 7, 7, 7, 7, 2, 9, 5, 8, 8, 8, 8, 3, 10, 4, 9, 9, 9, 9, 2, 6, 5, 10, 10, 10, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 7, 8, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 6, 9, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 29, 28, 27, 26, 25},
	    }
	elseif FreeType == 5 then --5*5
		freeReel = {
			{6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 29, 28, 27, 26, 25},
			{9, 10, 6, 2, 2, 2, 2, 6, 7, 8, 3, 3, 3, 3, 10, 6, 7, 4, 4, 4, 4, 7, 8, 9, 5, 5, 5, 5, 10, 9, 8, 6, 6, 6, 6, 3, 8, 4, 7, 7, 7, 7, 2, 9, 5, 8, 8, 8, 8, 3, 10, 4, 9, 9, 9, 9, 2, 6, 5, 10, 10, 10, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 7, 8, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 6, 9, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 29, 28, 27, 26, 25},
			{6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 29, 28, 27, 26, 25},
			{9, 10, 6, 2, 2, 2, 2, 6, 7, 8, 3, 3, 3, 3, 10, 6, 7, 4, 4, 4, 4, 7, 8, 9, 5, 5, 5, 5, 10, 9, 8, 6, 6, 6, 6, 3, 8, 4, 7, 7, 7, 7, 2, 9, 5, 8, 8, 8, 8, 3, 10, 4, 9, 9, 9, 9, 2, 6, 5, 10, 10, 10, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 7, 8, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 6, 9, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 29, 28, 27, 26, 25},
			{6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 29, 28, 27, 26, 25},		
	    }
	elseif FreeType == 6 then 
		freeReel = {
		    [1] = {7, 6, 6, 6, 7, 10, 10, 2, 2, 7, 6, 10, 10, 5, 10, 6, 10, 7, 6, 6, 6, 10, 10, 10, 7, 7, 6, 10, 6, 6, 10, 10, 3, 5, 7, 10, 4, 4, 10, 7, 7, 7, 10, 5, 10, 7, 7, 10, 7, 7, 10, 7, 6, 10, 5, 5},
			[2] = {1, 1, 5, 5, 10, 10, 2, 2, 2, 10, 5, 10, 5, 5, 10, 10, 6, 1, 6, 6, 10, 6, 7, 7, 7, 10, 7, 6, 7, 1, 3, 10, 3, 5, 6, 5, 4, 4, 4, 10, 10, 1, 10, 5, 10, 10, 6, 1, 7, 7, 10, 10, 6, 10, 5, 5},
	        [3] = {1, 1, 10, 6, 7, 10, 2, 2, 2, 5, 10, 10, 5, 10, 5, 7, 6, 1, 6, 10, 10, 7, 10, 7, 7, 7, 10, 5, 7, 1, 3, 10, 10, 6, 7, 5, 4, 4, 10, 6, 10, 1, 5, 5, 10, 7, 10, 10, 7, 7, 6, 6, 6, 6, 6, 7},
	        [4] = {1, 1, 6, 10, 5, 2, 2, 2, 10, 6, 5, 6, 10, 5, 10, 6, 5, 1, 6, 10, 10, 5, 6, 7, 7, 10, 10, 6, 6, 1, 3, 10, 10, 5, 5, 10, 4, 4, 10, 10, 7, 1, 10, 5, 5, 5, 7, 1, 7, 7, 5, 6, 6, 10, 10, 5},
	        [5] = {6, 5, 6, 10, 10, 2, 2, 10, 10, 6, 7, 6, 10, 5, 10, 7, 7, 6, 6, 6, 6, 5, 10, 7, 7, 7, 6, 5, 6, 5, 3, 3, 10, 10, 7, 7, 4, 4, 4, 10, 10, 6, 5, 10, 5, 6, 5, 10, 10, 7, 6, 7, 10, 6, 7, 7}
		}
	elseif FreeType == 7 then
		freeReel = {
		    [1] = {7, 6, 6, 6, 7, 10, 10, 2, 2, 7, 6, 10, 10, 5, 10, 6, 10, 7, 6, 6, 6, 10, 10, 10, 7, 7, 6, 10, 6, 6, 10, 10, 3, 5, 7, 10, 4, 4, 10, 7, 7, 7, 10, 5, 10, 7, 7, 10, 7, 7, 10, 7, 6, 10, 5, 5},
	        [2] = {1, 1, 5, 5, 10, 10, 2, 2, 2, 10, 5, 10, 5, 5, 10, 10, 6, 1, 6, 6, 10, 6, 7, 7, 7, 10, 7, 6, 7, 1, 3, 10, 3, 5, 6, 5, 4, 4, 4, 10, 10, 1, 10, 5, 10, 10, 6, 1, 7, 7, 10, 10, 6, 10, 5, 5},
	        [3] = {1, 1, 10, 6, 7, 10, 2, 2, 2, 5, 10, 10, 5, 10, 5, 7, 6, 1, 6, 10, 10, 7, 10, 7, 7, 7, 10, 5, 7, 1, 3, 10, 10, 6, 7, 5, 4, 4, 10, 6, 10, 1, 5, 5, 10, 7, 10, 10, 7, 7, 6, 6, 6, 6, 6, 7},
	        [4] = {1, 1, 6, 10, 5, 2, 2, 2, 10, 6, 5, 6, 10, 5, 10, 6, 5, 1, 6, 10, 10, 5, 6, 7, 7, 10, 10, 6, 6, 1, 3, 10, 10, 5, 5, 10, 4, 4, 10, 10, 7, 1, 10, 5, 5, 5, 7, 1, 7, 7, 5, 6, 6, 10, 10, 5},
	        [5] = {6, 5, 6, 10, 10, 2, 2, 10, 10, 6, 7, 6, 10, 5, 10, 7, 7, 6, 6, 6, 6, 5, 10, 7, 7, 7, 6, 5, 6, 5, 3, 3, 10, 10, 7, 7, 4, 4, 4, 10, 10, 6, 5, 10, 5, 6, 5, 10, 10, 7, 6, 7, 10, 6, 7, 7},
	        [6] = {6, 5, 10, 7, 7, 10, 2, 10, 2, 6, 7, 10, 10, 10, 5, 7, 10, 6, 10, 6, 10, 5, 5, 10, 10, 7, 6, 10, 6, 5, 10, 10, 3, 10, 7, 7, 4, 4, 10, 7, 5, 10, 5, 10, 5, 10, 5, 10, 7, 7, 6, 7, 10, 10, 7, 7}
		}
	elseif FreeType == 8 then
		freeReel = {
		    [1] = {7, 6, 6, 6, 7, 10, 10, 2, 2, 7, 6, 10, 10, 5, 10, 6, 10, 7, 6, 6, 6, 10, 10, 10, 7, 7, 6, 10, 6, 6, 10, 10, 3, 5, 7, 10, 4, 4, 10, 7, 7, 7, 10, 5, 10, 7, 7, 10, 7, 7, 10, 7, 6, 10, 5, 5},
	        [2] = {1, 1, 5, 5, 10, 10, 2, 2, 2, 10, 5, 10, 5, 5, 10, 10, 6, 1, 6, 6, 10, 6, 7, 7, 7, 10, 7, 6, 7, 1, 3, 10, 3, 5, 6, 5, 4, 4, 4, 10, 10, 1, 10, 5, 10, 10, 6, 1, 7, 7, 10, 10, 6, 10, 5, 5},
	        [3] = {1, 1, 10, 6, 7, 10, 2, 2, 2, 5, 10, 10, 5, 10, 5, 7, 6, 1, 6, 10, 10, 7, 10, 7, 7, 7, 10, 5, 7, 1, 3, 10, 10, 6, 7, 5, 4, 4, 10, 6, 10, 1, 5, 5, 10, 7, 10, 10, 7, 7, 6, 6, 6, 6, 6, 7},
	        [4] = {1, 1, 6, 10, 5, 2, 2, 2, 10, 6, 5, 6, 10, 5, 10, 6, 5, 1, 6, 10, 10, 5, 6, 7, 7, 10, 10, 6, 6, 1, 3, 10, 10, 5, 5, 10, 4, 4, 10, 10, 7, 1, 10, 5, 5, 5, 7, 1, 7, 7, 5, 6, 6, 10, 10, 5},
	        [5] = {6, 5, 6, 10, 10, 2, 2, 10, 10, 6, 7, 6, 10, 5, 10, 7, 7, 6, 6, 6, 6, 5, 10, 7, 7, 7, 6, 5, 6, 5, 3, 3, 10, 10, 7, 7, 4, 4, 4, 10, 10, 6, 5, 10, 5, 6, 5, 10, 10, 7, 6, 7, 10, 6, 7, 7},
	        [6] = {6, 5, 10, 7, 7, 10, 2, 10, 2, 6, 7, 10, 10, 10, 5, 7, 10, 6, 10, 6, 10, 5, 5, 10, 10, 7, 6, 10, 6, 5, 10, 10, 3, 10, 7, 7, 4, 4, 10, 7, 5, 10, 5, 10, 5, 10, 5, 10, 7, 7, 6, 7, 10, 10, 7, 7}
		}
	elseif FreeType == 9 then 
		freeReel = {
		    [1] = {7, 6, 6, 6, 7, 10, 10, 2, 2, 7, 6, 10, 10, 5, 10, 6, 10, 7, 6, 6, 6, 10, 10, 10, 7, 7, 6, 10, 6, 6, 10, 10, 3, 5, 7, 10, 4, 4, 10, 7, 7, 7, 10, 5, 10, 7, 7, 10, 7, 7, 10, 7, 6, 10, 5, 5},
	        [2] = {1, 1, 5, 5, 10, 10, 2, 2, 2, 10, 5, 10, 5, 5, 10, 10, 6, 1, 6, 6, 10, 6, 7, 7, 7, 10, 7, 6, 7, 1, 3, 10, 3, 5, 6, 5, 4, 4, 4, 10, 10, 1, 10, 5, 10, 10, 6, 1, 7, 7, 10, 10, 6, 10, 5, 5},
	        [3] = {1, 1, 10, 6, 7, 10, 2, 2, 2, 5, 10, 10, 5, 10, 5, 7, 6, 1, 6, 10, 10, 7, 10, 7, 7, 7, 10, 5, 7, 1, 3, 10, 10, 6, 7, 5, 4, 4, 10, 6, 10, 1, 5, 5, 10, 7, 10, 10, 7, 7, 6, 6, 6, 6, 6, 7},
	        [4] = {1, 1, 6, 10, 5, 2, 2, 2, 10, 6, 5, 6, 10, 5, 10, 6, 5, 1, 6, 10, 10, 5, 6, 7, 7, 10, 10, 6, 6, 1, 3, 10, 10, 5, 5, 10, 4, 4, 10, 10, 7, 1, 10, 5, 5, 5, 7, 1, 7, 7, 5, 6, 6, 10, 10, 5},
	        [5] = {6, 5, 6, 10, 10, 2, 2, 10, 10, 6, 7, 6, 10, 5, 10, 7, 7, 6, 6, 6, 6, 5, 10, 7, 7, 7, 6, 5, 6, 5, 3, 3, 10, 10, 7, 7, 4, 4, 4, 10, 10, 6, 5, 10, 5, 6, 5, 10, 10, 7, 6, 7, 10, 6, 7, 7}
		}
	end
	return freeReel
end

function cls:onExit()
	if self.reelTremble then
		self.reelTremble:stop()
	end
	if self.footerTremble then
		self.footerTremble:stop()
	end
	if self.headerTremble then
		self.headerTremble:stop()
	end
	if self.bonus and self.bonus.onExit then
		self.bonus:onExit()
	end
	Theme.onExit(self)
end

-- common_click

return cls




