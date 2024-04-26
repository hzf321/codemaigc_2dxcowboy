--Author:wanghongjie art:史程祥 孟祥宁;  math:tq、梁应杰  策划:锐锋
--Email:wanghongjie@bolegames.com
--2020年5月20日 11:00
--Using:主题 Theme192_WildAustralia
ThemeWildAustralia = class("ThemeWildAustralia", Theme)
local cls = ThemeWildAustralia

-- 资源异步加载相关
cls.plistAnimate = {
	"image/plist/symbol",
	"image/plist/base",
}

cls.csbList = {
	"csb/base.csb",
}

local transitionDelay = {
	["free"] 	= {["onCover"] = 15/30,["onEnd"] = 50/30}, -- 袋鼠
	["bonus"] 	= {["onCover"] = 8/30,["onEnd"] = 76/30}, -- bonus symbol
}

local SpinBoardType = {
	Normal 		= 1,
	FreeSpin 	= 2,
	Bonus 		= 3,
	Map_ReSpin 	= 4,
}

local ReSpinStep = {
	OFF = 1,
	Start = 2,
	Reset = 3,
	Over = 4,
	Playing = 5,	
	-- Check = 6,
}

local BonusGameType = { -- type1对应repsin type2对应 deal game type3对应 level
	Respin 	= 1,
	MapSlot = 2,
	MapFree = 3,
}

local FreeGameType = {
    Normal = 1,
    MultiperWild1 = 2,
    MultiperWild2 = 3,
    MultiperWild3 = 4,
    RandomWild = 5,
    MovingWild = 6,
    StickyWild = 7,
}

local jackpotWinType = {
	Grand = 0,
	Major = 1,
	Minor = 2,
	Mini = 3,
}

local moveWildTime = 1
local changeToWildTime = 1
local dialogShowOrHideTime = 0.5
local reelAddY = {505, 252.5, 0}
local singleBoardHeight = 252.5
local reelBaseY = -320
local reelCellH = 75  
local jackpotCnt = 4
local specialSymbol = {["scatter"] = 11, ["wild"] = 1, ["bonus"] = 12, ["kong"] = 0} -- , ["zeus"] = 2
local jackpotBet = {
	[21] = 0.25, [22] = 0.5, [23] = 1, [24] = 2, [25] = 3, [26] = 4, [27] = "mini", [28] = 6, [29] = 7, [30] = 8, [31] = 9, [32] = "minor", [33] = 15, [34] = 20, [35] = 25, [36] = 50, [37] = "major",
}
local jackpotType = {[27] = 3, [32] = 2, [37] = 1}
local jackpotRand = { 0.50, 0.56, 0.76, 0.91, 0.915, 0.92, 0.925, 0.965, 0.93, 0.935, 0.94, 0.970, 0.951, 0.958,  0.965, 0.984, 0.991} --  , 0.977, 
local jackpotHigh = Set({28, 29, 30, 31, 33, 34, 35, 36})
local jpLabelPos = cc.p(0, 0)
local jpLabelScale = 0.57
local jpLabelAnchorPoint = cc.p(0.5, 0.55)
local bonusSymbolRandom = 0.5

-------------- feature 解锁 相关
local unlockInfoTypeList = {3,2,100,1,0} -- 100 map /// 0 1 2 3 jp

local unlockInfoConfig = {
	Grand 	= 0,
	Major 	= 1,
	Minor 	= 2,
	Mini 	= 3,
	Map 	= 100,
}

local jackpotUnlockLbMaxCnt = 4

local jackpotLockAnimConfig = { --解锁20帧, 上锁17帧, 循环75帧
	[0] = {["unlock"] = "animation2_1", ["lock"] = "animation2_2", ["idle_l"] = "animation2_3"},
	[1] = {["unlock"] = "animation1_1", ["lock"] = "animation1_2", ["idle_l"] = "animation1_3"},
	[2] = {["unlock"] = "animation1_1", ["lock"] = "animation1_2", ["idle_l"] = "animation1_3"},
	[3] = {["unlock"] = "animation1_1", ["lock"] = "animation1_2", ["idle_l"] = "animation1_3"},
}
---------------------------- respin 相关 ----------------------------
local restJackpotSpineTime = 36/30
local respinCollectMaxWidth = 460 
-------------- movewild 相关
local wildPosConfig = {
    [1] = {1,1}, [2] = {1,2}, [3] = {1,3}, [4] = {1,4}, [5] = {2,1}, [6] = {2,2}, [7] = {2,3}, [8] = {2,4}, [9] = {3,1}, [10] = {3,2}, 
    [11] = {3,3}, [12] = {3,4}, [13] = {4,1}, [14] = {4,2}, [15] = {4,3}, [16] = {4,4}, [17] = {5,1}, [18] = {5,2}, [19] = {5,3}, [20] = {5,4}
}
local baseColCnt = 5
local boardTotalCnt = 3
local singleReelRespinCellCount = 15

------------  map 相关参数  -------------
local lockFeatureAnimName = "animation1" -- 收集解锁相关
local openFeatureAnimName = "animation2"
local maxMapPoints 	= 300
local maxMapLevel 	= 33
local maxCollectProgress = 540
local progressStartPosX = 0
local progressPosY = 50
local movePerUnit = maxCollectProgress/maxMapPoints

local collectFlyEndPos = cc.p(44.5, 971)
local flyToUpTime = 20/30
local showFullAnimTime = 1.5
local mapLevelConfig = { 
	7, 7, 1, --3
	7, 7, 7, 2, --7
	7, 7, 7, 7, 3, --13
	7, 7, 7, 7, 7, 4, --19
	7, 7, 7, 7, 7, 7, 5, --26
	7, 7, 7, 7, 7, 7, 7, 6--33
}

cls.spinTimeConfig = { -- spin 时间控制
		["base"] = 20/60, -- 数据返回前 进行滚动的时间
		["spinMinCD"] = 50/60,  -- 可以显示 stop按钮的时间，也就是可以通过quickstop停止的时间
}

function cls:getBoardConfig()
	if self.boardConfigList then
		return self.boardConfigList
	end

	local borderConfig = self.ThemeConfig["boardConfig"]

    for idx = 1, #borderConfig do
        local temp = borderConfig[idx]
        if not temp then
            return
        end
        local newReelConfig = {}
        if temp.row_single then -- respin
			local reelConfig = temp["reelConfig"]
			for _, singleBasePos in pairs(reelConfig["base_pos"]) do 
				for i=0, singleReelRespinCellCount-1 do
					local oneConfig = {}
					oneConfig["base_pos"] = cc.p((i%baseColCnt)*reelConfig["cellWidth"]+singleBasePos.x,math.floor((singleReelRespinCellCount-1-i)/baseColCnt)*reelConfig["cellHeight"]+singleBasePos.y)
			 		oneConfig["cellWidth"] = reelConfig["cellWidth"]
					oneConfig["cellHeight"] = reelConfig["cellHeight"]
					oneConfig["symbolCount"] = reelConfig["symbolCount"]
					table.insert(newReelConfig,oneConfig)
				end
			end
			borderConfig[idx]["rowReelCnt"] = baseColCnt
        else -- base and free  and slotMap
			for _, posList in pairs(temp.reelConfig) do
				for col=1, temp.colCnt do 
					local oneConfig = {}
					oneConfig["base_pos"] 	= cc.p((col-1)*temp["cellWidth"]+posList["base_pos"].x,posList["base_pos"].y)
			 		oneConfig["cellWidth"] 	= temp.cellWidth
					oneConfig["cellHeight"] = temp.cellHeight
					oneConfig["symbolCount"]= temp.rowCnt
					table.insert(newReelConfig,oneConfig)
				end
			end
            borderConfig[idx]["colReelCnt"] = temp.colCnt
        end

        borderConfig[idx]["reelConfig"] = newReelConfig
    end

	self.boardConfigList = borderConfig
	return borderConfig
end

function cls:ctor(themeid)
  	self.spinActionConfig = {
		["start_index"] = 1,
		["spin_index"] = 1,
		["stop_index"] = 1,
		["fast_stop_index"] = 1,
		["special_index"]=1,
	}
	self.ThemeConfig = {
		["theme_symbol_coinfig"]    = {
			["symbol_zorder_list"]  = {
	            [specialSymbol.scatter] = 3200,
	            [specialSymbol.bonus] 	= 3100,
			},
			["normal_symbol_list"]  = {
				2, 3, 4, 5, 6, 7, 8, 9, 10
			},
			["special_symbol_list"] = {
				specialSymbol.scatter
			},
			["no_roll_symbol_list"] = {
				specialSymbol.wild, specialSymbol.kong, specialSymbol.bonus,
				102, 103, 104, 105, 106, 107, 108, 109,
			},
			["roll_symbol_inFree_list"] = {
			},
			["special_symbol_config"] = {
				[specialSymbol.scatter] = {
					["min_cnt"] = 3,
					["type"]	= G_THEME_SYMBOL_TYPE.NUMBER,
					["col_set"] = {
						[1] 	= 1, [2] 	= 1,  [3] 	= 1, [4] 	= 1, [5] 	= 1,
						[6] 	= 1, [7] 	= 1,  [8] 	= 1, [9] 	= 1, [10] 	= 1,
						[11] 	= 1, [12] 	= 1,  [13] 	= 1, [14] 	= 1, [15] 	= 1,
					},
				},
			},
		},
		["theme_round_light_index"] = 1,
		["theme_type"] = "ways",
		["theme_type_config"] = {
			["ways_cnt"]   = 243
		},
		["boardConfig"] = {
			{ -- 3个棋盘 3*5
				["reel_single"] = true,
				["allow_over_range"] = true,
				["colCnt"] = 5,
				["rowCnt"] = 3,
				["cellWidth"] = 113,
				["cellHeight"] = 75,
				["reelConfig"] = {
					{["base_pos"] = cc.p(77.5, 209 + reelAddY[1])},
					{["base_pos"] = cc.p(77.5, 209 + reelAddY[2])},
					{["base_pos"] = cc.p(77.5, 209 + reelAddY[3])},
				},
			},
			{	-- 每个reel单独一个空间，不共用一个clipnode。例如用于lockrespin
				["row_single"] = true, 
				["reelConfig"] = {
					["base_pos"] = { cc.p(77.5, 209 + reelAddY[1]), cc.p(77.5, 209 + reelAddY[2]), cc.p(77.5, 209 + reelAddY[3]) },
					["cellWidth"] = 113,
					["cellHeight"] = 75,
					["symbolCount"] = 1,
				}
			},
			{ -- mapSlot
                ["show_parts"] = true, --gai
                ["colCnt"] = 3,
                ["rowCnt"] = 1,
                ["cellWidth"] = 194,
                ["cellHeight"] = 138,
                ["reelConfig"] = {
                    {
                        ["base_pos"] = cc.p(70, 369),
                    },
                }
            },
		}
	}
	--- add by yt
	EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_SHOW, "theme192", self.touchShowCActivity, self)
	EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_HIDE, "theme192", self.touchHideCActivity, self)
	--- end by yt

	self.baseBet = 10000
	self.DelayStopTime = 0

	self.UnderPressure = 1 -- 下压上 控制
	local use_portrait_screen = true
	local ret = Theme.ctor(self, themeid, use_portrait_screen)
    return ret
end

local G_cellHeight = 75
local G_cellWidth = 113
local delay = 0

local extraReelTime = 120 / 60
local extraReelAnimTimeInFree = 80/30
local extraReelTimeInFreeGame = extraReelAnimTimeInFree*boardTotalCnt
local specialAniTime = 60/30
local specialAniDelay = 15/30
--- new
local upBounce = G_cellHeight * 2 / 3 --G_cellHeight*2/3
local upBounceMaxSpeed = 6 * 60
local upBounceTime = 0
local speedUpTime = 20 / 60
local rotateTime = 5 / 60
local maxSpeed = -26.5 * 60 -- -30 * 60
local normalSpeed = -26.5 * 60
local fastSpeed =  -26.5 * 60

local stopDelay = 10 / 60
local speedDownTime = 45 / 60 -- 40 / 60
local downBounce = G_cellHeight*1/3
local downBounceMaxSpeed = 10 * 60 -- 6 * 60
local downBounceTime = 10 / 60 -- 20/60
local spinMinCD = 0.5

-- whj 修改速度
local stopDelayList = {
    [1] = 10 / 60,
    [2] = 10 / 60,
    [3] = 10 / 60,
}
local autoStopDelayMult = 1
local autoDownBounceTimeMult = 1
local checkStopColCnt = 5

function cls:initScene(spinNode)
	local path = self:getPic("csb/base.csb")
	self.mainThemeScene = cc.CSLoader:createNode(path)
	self.down_node 		= self.mainThemeScene:getChildByName("down_child")
	bole.adaptScale(self.mainThemeScene,true)
	bole.adaptReelBoard(self.down_node) -- 竖屏 适配 棋盘的 横屏不需要
	self.down_child 	= self.down_node:getChildByName("down_child")

	self.bgRoot 		= self.mainThemeScene:getChildByName("theme_bg")
	self.bgAnim 		= self.bgRoot:getChildByName("bg_anim")
	self.baseBg 		= self.bgRoot:getChildByName("bg_base")
	self.free1Bg 		= self.bgRoot:getChildByName("bg_free1")
	self.free2Bg 		= self.bgRoot:getChildByName("bg_free2")
	self.respinBg 		= self.bgRoot:getChildByName("bg_respin")
	self.baseBg:setVisible(true)
	self.curBg = self.baseBg
	self.free1Bg:setVisible(false)
	self.free2Bg:setVisible(false)
	self.respinBg:setVisible(false)
	
	self.mapFreeLogo 		= self.down_child:getChildByName("map_free_logo")
	self.mapFreeLogo:setVisible(false)

	self.reelRoot 			= self.down_child:getChildByName("reel_root_node")

	self.boardAniParent 	= self.down_child:getChildByName("board_ani_parent")
	self.boardRoot 			= self.boardAniParent:getChildByName("board_root")
	self.boardRoot:setLocalZOrder(1)
	self.stickyNode 		= self.boardAniParent:getChildByName("stick_node")
	self.stickyNode:setLocalZOrder(2)
	self.animateNode 		= self.boardAniParent:getChildByName("animate_node")	
	self.animateNode:setLocalZOrder(3)
	
	self.scatterAnimNode 	= self.down_child:getChildByName("scatter_anim_node")
	self.randomWildNode 	= self.down_child:getChildByName("wild_anim")
	self.moveWildNode 		= self.down_child:getChildByName("move_wild")
	self.expandNode 		= self.down_child:getChildByName("expand_node")
	self.themeAnimateKuang  = self.down_child:getChildByName("animate_kuang")

	self.featureDimmer 			= self.down_child:getChildByName("feature_dimmer")
	self.featureDimmer:setVisible(false)
	self.featureTipDialogDimmer = self.down_child:getChildByName("dialog_tip_dimmer")
	self.featureTipDialogDimmer:setVisible(false)
	self.boardDimmerParent = self.down_child:getChildByName("board_dimmer_list")
	self.boardDimmerList = self.boardDimmerParent:getChildren()
	for _, node in pairs(self.boardDimmerList) do 
		node:setVisible(false)	
	end
	
	-- self.bgAnimNode  		= self.down_child:getChildByName("bg_anim")
	self.topAnimNode  		= self.down_child:getChildByName("top_anim")
	self.featureDialogDimmer = self.mainThemeScene:getChildByName("dialog_dimmer")
	self.featureDialogDimmer:setVisible(false)

    self.mapSlotMachineSceneNode = cc.Node:create()
    self.mainThemeScene:addChild(self.mapSlotMachineSceneNode)

	-- 初始化jackpot
	self:initJackpotNode()

	-- map 相关
	self:initCollectFeatureNode()

	-- respin 相关
	self:initRespinFeatureNode()

	self:initFeatureBtnEvent()

	self:setLockFeatureState()

	self.shakyNode:addChild(self.mainThemeScene)


	-- 添加背景特效
	self:changeBgAnimState()

	-- 长屏logo相关
	self:setAdapterPhone()
    self:initLogoNode()  

end

function cls:changeBgAnimState() -- animation1 晴天循环  90帧 , animation2 晴天切下雨 30帧 , animation3 下雨循环  30帧 , animation4 下雨切晴天  30帧
	local bgAnimTime = {90/30, 30/30, 30/30, 30/30}
	local loopTotalTime = 3*60

	if not bole.isValidNode(self.bgSpineAnim) then 
		local _, bgS = self:addSpineAnimation(self.bgRoot, 20, self:getPic("spine/base/bj"), cc.p(0, 0), "animation1", nil, nil, nil, true)
		self.bgSpineAnim = bgS
	end

	self.bgSpineAnim:runAction(cc.RepeatForever:create(
		cc.Sequence:create(
			cc.CallFunc:create(function ( ... )
				bole.changeSpineNormal(self.bgSpineAnim, "animation1", true)
			end),
			cc.DelayTime:create(loopTotalTime),
			cc.CallFunc:create(function ( ... )
				bole.changeSpineNormal(self.bgSpineAnim, "animation2", false)
			end),
			cc.DelayTime:create(bgAnimTime[2]),
			cc.CallFunc:create(function ( ... )
				bole.changeSpineNormal(self.bgSpineAnim, "animation3", true)
				self:playMusic(self.audio_list.rain, true, true)
			end),
			cc.DelayTime:create(loopTotalTime),
			cc.CallFunc:create(function ( ... )
				bole.changeSpineNormal(self.bgSpineAnim, "animation4", false)
				self:stopMusic(self.audio_list.rain, true)
			end),
			cc.DelayTime:create(bgAnimTime[4])
			)))
end

function cls:playBgYunMoveAnim()
	local bgAnimBaseY = 640
	local bgAnimBaseX = 1560
	local bgAnimBaseScale = 2
	local loopTotalTime = 3*60
	local yunPath = self.fgType == FreeGameType.Normal and "#theme192_b_sp_yun1.png" or "#theme192_b_sp_yun2.png"
	if bole.isValidNode(self.bgYunSp1) then 
		bole.updateSpriteWithFile(self.bgYunSp1, yunPath)
	else
		self.bgYunSp1 = bole.createSpriteWithFile(yunPath)
	end
	self.bgAnim:addChild(self.bgYunSp1)
	self.bgYunSp1:setScale(bgAnimBaseScale)
	
	self.bgYunSp1:runAction(cc.RepeatForever:create(
		cc.Sequence:create(
			cc.CallFunc:create(function ( ... )
				self.bgYunSp1:setPosition(cc.p(0, bgAnimBaseY))
			end),
			cc.MoveTo:create(loopTotalTime, cc.p(bgAnimBaseX,bgAnimBaseY)),
			cc.CallFunc:create(function ( ... )
				self.bgYunSp1:setPosition(cc.p(-bgAnimBaseX, bgAnimBaseY))
			end),
			cc.MoveTo:create(loopTotalTime, cc.p(0, bgAnimBaseY)))))

	if bole.isValidNode(self.bgYunSp2) then 
		bole.updateSpriteWithFile(self.bgYunSp2, yunPath)
	else
		self.bgYunSp2 = bole.createSpriteWithFile(yunPath)
	end
	self.bgAnim:addChild(self.bgYunSp2)
	self.bgYunSp2:setScale(bgAnimBaseScale)
	
	self.bgYunSp2:runAction(cc.RepeatForever:create(
		cc.Sequence:create(
			cc.CallFunc:create(function ( ... )
				self.bgYunSp2:setPosition(cc.p(-bgAnimBaseX, bgAnimBaseY))
			end),
			cc.MoveTo:create(loopTotalTime*2, cc.p(bgAnimBaseX,bgAnimBaseY)),
			cc.CallFunc:create(function ( ... )
				self.bgYunSp2:setPosition(cc.p(-bgAnimBaseX, bgAnimBaseY))
			end))))
end

function cls:setAdapterPhone( ... )
    -- bole.adaptTop(self.logoNode, -0.4)
end

--function cls:initLogoNode( ... )
--    self.longLogoNode 	= self.mainThemeScene:getChildByName("long_logo_node")
--    if self:adaptationLongScreen() then
--        self.longLogoNode:setVisible(true)
--        local posY = 580
--        if bole.isIphoneX() then
--        	posY = 600
--        end
--
--        self:addSpineAnimation(self.longLogoNode, nil, self:getPic("spine/logo_name/192_cp"), cc.p(0, posY), "animation", nil, nil, nil, true, true)
--        bole.adaptTop(self.longLogoNode, -0.4)
--    else
--        self.longLogoNode:setVisible(false)
--    end
--end

-----------------------------------------------------------------------------------------------------------------------------------
-- @ 长屏logo 点击活动移动相关 add by yt
function cls:initLogoNode(...)
	self.longLogoNode = self.mainThemeScene:getChildByName("long_logo_node")
	if self:adaptationLongScreen() then
		self.longLogoNode:setVisible(true)
		--local _, s = bole.addSpineAnimationInTheme(self.longLogoNode, nil, self._mainViewCtl:getSpineFile("long_logo_name"), cc.p(0, 550), "animation", nil, nil, nil, true, true)
		--bole.adaptTop(self.longLogoNode, -0.2)
		local posY = 600
		if bole.isIphoneX() then
			posY = 620
		end
		local _, s = self:addSpineAnimation(self.longLogoNode, nil, self:getPic("spine/logo_name/192_cp"), cc.p(0, posY), "animation", nil, nil, nil, true, true)
		bole.adaptTop(self.longLogoNode, -0.4)
		self.logoLabelImg = s
		self.logoLabelImg:setScale(1)
		self.longLogoNode.basePos = cc.p(self.longLogoNode:getPosition())
		self.logoLabelImg.basePos = cc.p(self.logoLabelImg:getPosition())
		self.logoLabelImg.baseScale = 1
		if self:getHeaderStatus() == 1 then
			self:downThemeLogo(true)
		end
	else
		self.longLogoNode:setVisible(false)
	end
end

function cls:_getLogoLabelPos()
	local headerHeight = self:_getHeaderWidth()
	local activityHeight = self:_getBActivityWidth()
	local scale = 1
	local emptyPos = bole.getAdaptReelBoardY() * 2
	if emptyPos < 180 then
		scale = emptyPos / 180
	end
	local moveY = bole.getAdaptReelBoardY() + headerHeight + activityHeight
	return moveY, scale
end

function cls:touchShowCActivity(...)
	if self and bole.isValidNode(self.mainThemeScene) then
		self:downThemeLogo(...)
	end
	self.showHeaderdStatus = 1
end

function cls:touchHideCActivity(...)
	if self and bole.isValidNode(self.mainThemeScene) then
		self:upThemeLogo(...)
	end
	self.showHeaderdStatus = 2
end

function cls:downThemeLogo(noAni)
	if self.logoLabelImg then
		local endscale = self.logoLabelImg.baseScale * 0.9
		local endPosY = self.logoLabelImg.basePos.y - 40
		self.logoLabelImg:stopActionByTag(1003)
		if not noAni then
			local a1 = cc.ScaleTo:create(0.3, endscale)
			local a2 = cc.MoveTo:create(0.3, cc.p(0, endPosY))
			local a3 = cc.Spawn:create(a1, a2)
			a3:setTag(1003)
			self.logoLabelImg:runAction(a3)
		else
			self.logoLabelImg:setScale(endscale)
			self.logoLabelImg:setPositionY(endPosY)
		end
	end
end

function cls:upThemeLogo(noAni)
	if self.logoLabelImg then
		local endscale = self.logoLabelImg.baseScale
		local endPosY = self.logoLabelImg.basePos.y
		self.logoLabelImg:stopActionByTag(1003)
		if not noAni then
			local a1 = cc.ScaleTo:create(0.3, endscale)
			local a2 = cc.MoveTo:create(0.3, cc.p(0, endPosY))
			local a3 = cc.Spawn:create(a1, a2)
			a3:setTag(1003)
			self.logoLabelImg:runAction(a3)
		else
			self.logoLabelImg:setScale(endscale)
			self.logoLabelImg:setPositionY(endPosY)
		end
	end
end

function cls:getHeaderStatus()
	return self.showHeaderdStatus or 2
end
-----------------------------------------------------------------------------------------------------------------------------------

function cls:getJPLabelMaxWidth(index)
	local jackpotLabelMaxWidth = {416, 206, 206, 206}
	return jackpotLabelMaxWidth[index] or jackpotLabelMaxWidth[#jackpotLabelMaxWidth]
end

function cls:initJackpotNode( ... )
	self.jackpotNode = self.down_child:getChildByName("top_node")
	self.progressiveRoot = self.jackpotNode:getChildByName("progressive")
	self.jackpotLockRoot = self.jackpotNode:getChildByName("lock_node")
	
	self.jackpotTipslock = self.jackpotLockRoot:getChildByName("lock_tip")
	self.jackpotTipsUnlock = self.jackpotLockRoot:getChildByName("unlock_tip")
	self.jackpotTipslock:setVisible(false)
	self.jackpotTipsUnlock:setVisible(false)

	self.jackpotLabels = {}
	self.jackpotLockNodes = {}
	for i = 1, jackpotCnt do	
		local jpTemp = self.progressiveRoot:getChildByName("jp_node"..i)-- 初始化jackpot
		self.jackpotLabels[i] = jpTemp:getChildByName("label_jp" .. i)
		self.jackpotLabels[i].maxWidth = self:getJPLabelMaxWidth(i)
		self.jackpotLabels[i].baseScale = self.jackpotLabels[i]:getScale()

		local jpTemp = self.jackpotLockRoot:getChildByName("jp_node"..i)-- 初始化jackpot
		self.jackpotLockNodes[i-1] = jpTemp
		-- self.jackpotLockNodes[i-1].unlockLabel 	= jpTemp:getChildByName("unlock_bet")
		-- self.jackpotLockNodes[i-1].unlockLabel:setLocalZOrder(2)
		self.jackpotLockNodes[i-1].unlockBtn 	= jpTemp:getChildByName("unlock_btn")
		-- self.jackpotLockNodes[i-1].bg 			= jpTemp:getChildByName("bg")
		self.jackpotLockNodes[i-1].tipNode 		= jpTemp:getChildByName("tip_node")
		self.jackpotLockNodes[i-1].tipNode:setLocalZOrder(2)

		local _, s = self:addSpineAnimation(jpTemp, nil, self:getPic("spine/jackpot/jp_js_ss_01"), cc.p(0, 0), jackpotLockAnimConfig[i-1].unlock, nil, nil, nil, true)   -- 默认解锁状态
		self.jackpotLockNodes[i-1].lockSpine = s

		self.jackpotLockNodes[i-1].unlockBtn.type = i-1
	end
	self:initialJackpotNode()
	self.jpAnimNode = self.jackpotNode:getChildByName("jp_anim_node")
end

function cls:initCollectFeatureNode( )
	self.collectFeatureNode = self.down_child:getChildByName("collect_feature_node")

	local _, s = self:addSpineAnimation(self.collectFeatureNode:getChildByName("lock_node"), nil, self:getPic("spine/collect_progress/sjt_suo"), cc.p(0, 0), openFeatureAnimName, nil, nil, nil, true) -- 默认解锁状态
	self.lockSuperSpine = s

	self.bonusFlyNode 		= self.down_child:getChildByName("bonus_fly_node")
	self.collectPanel 		= self.collectFeatureNode:getChildByName("collect_panel")
	self.collectProgress 	= self.collectPanel:getChildByName("progress")
	-- self.collectProgressAni = self.collectPanel:getChildByName("anim_node")
	-- self.baseProgressAniPosX = self.collectProgressAni:getPositionX()
	self:addSpineAnimation(self.collectProgress, nil, self:getPic("spine/collect_progress/sjt_xh"), cc.p(0,0), "animation", nil, nil, nil, true, true)
	
	self.baseMapLoadNode 	= self.mainThemeScene:getChildByName("map_node")
	self.openLockBtn 		= self.collectFeatureNode:getChildByName("map_tip_btn")
	self.showMapBtn 		= self.collectFeatureNode:getChildByName("show_map_btn")
	self.showMapIcon 		= self.collectFeatureNode:getChildByName("open_map_icon")
	self.collectFullSpine 	= self.collectFeatureNode:getChildByName("collect_full_spine")
	self.collectEndSp 		= self.collectFeatureNode:getChildByName("end_sp")

	self:addSpineAnimation(self.showMapIcon, nil, self:getPic("spine/collect_progress/tb_ditu_01"), cc.p(0,0), "animation", nil, nil, nil, true, true)

	-- self.isLockFeature 	= true 

	self:initFeatureBtnEvent()
end

function cls:setLockFeatureState( ... )
	self.lockFeatureState = {} -- 默认解锁状态 -- Set(unlockInfoTypeList)
	for _, ftype in pairs(unlockInfoTypeList) do 
		self.lockFeatureState[ftype] = false
	end
end

function cls:initRespinFeatureNode( ... )
	self.respinWinSpineParent = self.down_child:getChildByName("respin_win_spine")
	self.respinDimmerList 	= self.down_child:getChildByName("respin_dimmer"):getChildren()
	self.rTotalCollectNode 	= self.down_child:getChildByName("respin_total_win")
	self.rTotalCollectLable = self.rTotalCollectNode:getChildByName("label_win")
	self.rTotalCollectAnim 	= cc.Node:create()
	self.rTotalCollectNode:addChild(self.rTotalCollectAnim)
	self.rTotalCollectNode.baseScale = 0.8

	self.respinKuangList = {}
	for _, node in pairs(self.reelRoot:getChildren()) do
		table.insert(self.respinKuangList, node:getChildByName("theme_kuang_r"))
	end

    local function parseValue( num)
        return FONTS.format(num, true)
    end
    inherit(self.rTotalCollectLable, LabelNumRoll)
    self.rTotalCollectLable:nrInit(0, 24, parseValue)

	self.rBoardCntTipList = self.down_child:getChildByName("respin_cnt_node"):getChildren()
	self.rBoardCntTipNodes = {}
	for id, node in pairs(self.rBoardCntTipList) do 
		self.rBoardCntTipNodes[id] = {}
		self.rBoardCntTipNodes[id]["parent"] = node
		for cnt = 0, 3 do
			self.rBoardCntTipNodes[id][cnt] = node:getChildByName("cnt"..cnt)
		end
	end

	self.rWinNodeList = self.down_child:getChildByName("respin_win_node"):getChildren()
	self.rWinLabelList = {}
	for id, node in pairs(self.rWinNodeList) do 
		self.rWinLabelList[id] = node:getChildByName("label_win")
		node.animNode = cc.Node:create()
		node:addChild(node.animNode, -1)
	end

	self.HoldLayer = self.down_child:getChildByName("hold_layer")
end

function cls:initFeatureBtnEvent(  )
	-- 显示map按钮事件
	self.isFeatureClick = false
	local function touchShowMapEvent(obj, eventType) -- 点击按钮
		if not self:featureBtnCheckCanTouch() then 
			return 
		end

		if self.lockFeatureState[unlockInfoConfig.Map] then
			return
		end

		if eventType == ccui.TouchEventType.began then
			self.showMapIcon:setColor(cc.c3b(125,125,125))

        elseif eventType == ccui.TouchEventType.moved then
        	self.showMapIcon:setColor(cc.c3b(125,125,125))

        elseif eventType == ccui.TouchEventType.ended then
			self:playMusic(self.audio_list.common_click)
		 	self.showMapIcon:setColor(cc.c3b(255,255,255))
		 	self:showStoreNode()

        elseif eventType == ccui.TouchEventType.canceled then
        	self.showMapIcon:setColor(cc.c3b(255,255,255))

		end
	end
	self.showMapBtn:addTouchEventListener(touchShowMapEvent)-- 设置按钮

    local function unLockOnTouchByMap(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
			if not self:featureBtnCheckCanTouch() then 
				return 
			end
            if self.lockFeatureState[unlockInfoConfig.Map] and self.unLockBetList and self.unLockBetList[unlockInfoConfig.Map] then
                self:playMusic(self.audio_list.common_click)
                self:setBet(self.unLockBetList[unlockInfoConfig.Map])
                return
            end
        end

    end
    self.openLockBtn:addTouchEventListener(unLockOnTouchByMap)

    local function unLockOnTouchByJp(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
			if not self:featureBtnCheckCanTouch() then 
				return 
			end
			local _unLockType = obj.type
            if self.lockFeatureState[_unLockType] and self.unLockBetList and self.unLockBetList[_unLockType] then
                self:playMusic(self.audio_list.common_click)
                self:setBet(self.unLockBetList[_unLockType])
                return
            end
        end

    end
    for _, node in pairs(self.jackpotLockNodes) do 
    	node.unlockBtn:addTouchEventListener(unLockOnTouchByJp)
    end
end

function cls:featureBtnCheckCanTouch()
	local canTouch  = true
	if not self.showBaseSpinBoard then
		return false
	end
	if self.isInBonusGame then
		return false
	end
	if self.isFeatureClick then
		return false
	end
	if not (self.mapLevel and self.mapPoints) then
		return false
	end
	if self.isInFreeGame then
		return false
	end
	return canTouch
end

------------------------------- map start -----------------------------------
function cls:showStoreNode()
    local data = {}
    data["mapLevel"] = self.mapLevel
    self.isFeatureClick = true
    local theDialog = WildAustraliaMapGame.new(self, self:getPic("csb/"), data)
    theDialog:showMapScene(false)
    self.storeNode = theDialog
end
function cls:closeStoreNode(isCollect)
    if not self.isFeatureClick then
        return
    end
    self.isFeatureClick = false
    if isCollect then
        self:setFooterBtnsEnable(true)
    end

end
function cls:enableMapInfoBtn(enable)
    -- self.isCanFeatureClick = enable
    -- if not enable and self.isFeatureClick then
    --     self:closeStoreNode()
    -- end
end
function cls:refreshNotEnoughMoney()
    self:closeStoreNode() -- self:enableMapInfoBtn(true)
end
------------------------------- map end -----------------------------------

-- "unlock_info": { "250000": [ 3 ], "1000000": [ 3, 2 ], "5000000": [ 3, 2, 100 ], "20000000": [ 3, 2, 100, 1 ], "100000000": [ 3, 2, 100, 1, 0 ] },
local lockTypeLevel = { [unlockInfoConfig.Mini] = 1, [unlockInfoConfig.Minor] = 2, [unlockInfoConfig.Map] = 3, [unlockInfoConfig.Major] = 4, [unlockInfoConfig.Grand] = 5 }
local lockMaxLevel = 5
local lockMinLevel = 1
function cls:checkLockFeature( bet )
	if not(self.unLockInfoData and self.lockFeatureState and self.jackpotLockNodes and self.unLockBetList) then return end
	local bet = bet or self.ctl:getCurTotalBet()

	local showUnlockFeature = {}
	local curUnlockBet = 0
	for _unlockBetL, _unlockFeature in pairs(self.unLockInfoData) do 
		local _unlockBetN = tonumber(_unlockBetL)
		if bet >=_unlockBetN then 
			if curUnlockBet < _unlockBetN then 
				showUnlockFeature = _unlockFeature
				curUnlockBet = _unlockBetN
			end
		end
	end

	local needMusicName = "unlock"
	local isChangeState = false

	local unlockLevel
	local unlockJpLevel
	if showUnlockFeature then
		local showUnlockSet = Set(showUnlockFeature)

		for unlockType, state in pairs(self.lockFeatureState) do 

			if showUnlockSet[unlockType] and state then -- 解锁的
				needMusicName = "unlock"
				isChangeState = true
				unlockLevel = unlockLevel or lockMinLevel-1
				if unlockLevel < lockTypeLevel[unlockType] then 
					unlockLevel = lockTypeLevel[unlockType]
				end
				
				if self:checkUnlockTypeIsJackpot(unlockType) then
					unlockJpLevel = unlockJpLevel or lockMinLevel-1
					if unlockJpLevel < lockTypeLevel[unlockType] then 
						unlockJpLevel = lockTypeLevel[unlockType]
					end
				end

				self:changeFeatureState(unlockType, true)
				self.lockFeatureState[unlockType] = false
			end


			if (not showUnlockSet[unlockType]) and (not state) then -- 上锁
				needMusicName = "lock"
				isChangeState = true

				unlockLevel = unlockLevel or lockMaxLevel + 1
				if unlockLevel > lockTypeLevel[unlockType] then 
					unlockLevel = lockTypeLevel[unlockType]
				end
				
				if self:checkUnlockTypeIsJackpot(unlockType) then 
					unlockJpLevel = unlockJpLevel or lockMaxLevel + 1
					if unlockJpLevel > lockTypeLevel[unlockType] then 
						unlockJpLevel = lockTypeLevel[unlockType]
					end
				end

				self:changeFeatureState(unlockType, false)
				self.lockFeatureState[unlockType] = true
			end

			-- if self.jackpotLockNodes[unlockType] and bole.isValidNode(self.jackpotLockNodes[unlockType].unlockLabel) and self.unLockBetList[unlockType] then
			-- 	self.jackpotLockNodes[unlockType].unlockLabel:setString(FONTS.formatByCount4(self.unLockBetList[unlockType], jackpotUnlockLbMaxCnt, true))
			-- end

		end
	end

	if isChangeState then 
		-- showUnlockFeature
		if needMusicName == "unlock" then 
			if self:checkUnlockTypeIsJackpot(unlockInfoTypeList[unlockLevel]) then 
				self:playMusic(self.audio_list.jp_unlock)
			else
				self:playMusic(self.audio_list.unlock)
			end
		else
			if self:checkUnlockTypeIsJackpot(unlockInfoTypeList[unlockLevel]) then 
				self:playMusic(self.audio_list.jp_lock)
			else
				self:playMusic(self.audio_list.lock)
			end
		end

		if unlockJpLevel and (unlockJpLevel ~= (lockMaxLevel + 1) and unlockJpLevel ~= (lockMinLevel - 1)) then 
			-- 展示提示弹窗
			self:playChangeJakcpotStateTip(needMusicName, unlockJpLevel)
		end
	end

	self.jpAnimNode:removeAllChildren()
end

function cls:playChangeJakcpotStateTip(_showType, unlockLevel)
	local showNode = _showType == "unlock" and self.jackpotTipsUnlock or self.jackpotTipslock

	local _type = unlockInfoTypeList[unlockLevel]
	if bole.isValidNode(showNode) and self.jackpotLockNodes[_type] and bole.isValidNode(self.jackpotLockNodes[_type].tipNode) then 
		
		if self.jackpotTipsUnlock:isVisible() then 
			self.jackpotTipsUnlock:stopAllActions()
			self.jackpotTipsUnlock:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.02, 1.2),
				cc.ScaleTo:create(0.08, 0),
				cc.Hide:create()
				))
		end
		if self.jackpotTipslock:isVisible() then 
			self.jackpotTipslock:stopAllActions()
			self.jackpotTipslock:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.02, 1.2),
				cc.ScaleTo:create(0.08, 0),
				cc.Hide:create()
				))
		end

		showNode:stopAllActions()
		showNode:setPosition(0,0)
		showNode:setScale(0)

		local nameSp = showNode:getChildByName("name")

		if bole.isValidNode(nameSp) and (_type >= 0 and _type <= 3) then
			bole.updateSpriteWithFile(nameSp, "#theme192_tj_name1"..(_type + 1)..".png")
		end

		bole.changeParent(showNode, self.jackpotLockNodes[_type].tipNode, 1)

		showNode:runAction(cc.Sequence:create(
			cc.Show:create(),
			cc.ScaleTo:create(0.2, 1.2),
			cc.ScaleTo:create(0.1, 1),
			cc.DelayTime:create(1),
			cc.ScaleTo:create(0.05, 1.2),
			cc.ScaleTo:create(0.1, 0),
			cc.Hide:create()
			))
	end
end

function cls:startLockAnim(curlevel)
	if not self.curMaxLevel then return end
	if curlevel ~= self.curMaxLevel then return end
	local _level = self.curMaxLevel
	if self.jackpotSpeicialList[self.curMaxLevel-1] then 
		local lockSp = self.jackpotSpeicialList[self.curMaxLevel-1].lockSp
		bole.spChangeAnimation(lockSp,"animation",false)
		self:laterCallBack(4,function() 
			self:startLockAnim(_level)
		end)
	end

end

function cls:checkUnlockTypeIsJackpot(unlockType)
	local isJackpot = false
	if unlockType == unlockInfoConfig.Grand or unlockType == unlockInfoConfig.Major or unlockType == unlockInfoConfig.Minor or unlockType == unlockInfoConfig.Mini then 
		isJackpot = true
	end
	return isJackpot
end
function cls:changeFeatureState( unlockType, showUnlock )
	if showUnlock then -- 解锁
		if self:checkUnlockTypeIsJackpot(unlockType) then 

			if bole.isValidNode(self.jackpotLockNodes[unlockType].lockSpine) then 
				local tempS = self.jackpotLockNodes[unlockType].lockSpine
				tempS:stopAllActions()

				bole.spChangeAnimation(tempS, jackpotLockAnimConfig[unlockType].unlock)
			end
			-- if bole.isValidNode(self.jackpotLockNodes[unlockType].unlockLabel) then 
			-- 	local tempL = self.jackpotLockNodes[unlockType].unlockLabel
			-- 	tempL:stopAllActions()

			-- 	tempL:setOpacity(255)
			-- 	tempL:runAction(cc.FadeOut:create(10/30))
			-- end
			
			local animName = unlockType == unlockInfoConfig.Grand and "animation2" or "animation1"
			self:addSpineAnimation(self.jackpotNode, 20, self:getPic("spine/jackpot/jp_js_ss_02"), cc.p(self.jackpotLockNodes[unlockType]:getPosition()), animName)
			-- self.jackpotLockNodes[unlockType]:setVisible(false)

		elseif unlockType == unlockInfoConfig.Map then 
			self.lockSuperSpine:stopAllActions()
			bole.spChangeAnimation(self.lockSuperSpine, openFeatureAnimName, false)
		end
	else -- 上锁
		if self:checkUnlockTypeIsJackpot(unlockType) then 
			local animName = unlockType == unlockInfoConfig.Grand and "animation2" or "animation1"
			self:addSpineAnimation(self.jackpotNode, 20, self:getPic("spine/jackpot/jp_js_ss_02"), cc.p(self.jackpotLockNodes[unlockType]:getPosition()), animName)-- 播放 解锁 动画
			-- self.jackpotLockNodes[unlockType]:setVisible(true)
			-- self.jackpotLockNodes[unlockType].bg:setColor(cc.c3b(125,125,125))

			if bole.isValidNode(self.jackpotLockNodes[unlockType].lockSpine) then 
				local tempS = self.jackpotLockNodes[unlockType].lockSpine
				tempS:stopAllActions()

				bole.spChangeAnimation(tempS, jackpotLockAnimConfig[unlockType].lock)
				tempS:runAction(cc.Sequence:create(
					cc.DelayTime:create(17/30),
					cc.CallFunc:create(function ( ... )
						bole.spChangeAnimation(tempS, jackpotLockAnimConfig[unlockType].idle_l, true)
					end)))
			end

			-- if bole.isValidNode(self.jackpotLockNodes[unlockType].unlockLabel) then 
			-- 	local tempL = self.jackpotLockNodes[unlockType].unlockLabel
			-- 	tempL:stopAllActions()

			-- 	tempL:setOpacity(0)
			-- 	tempL:runAction(cc.FadeIn:create(10/30))
			-- end

		elseif unlockType == unlockInfoConfig.Map then 
			self.lockSuperSpine:stopAllActions()
			bole.spChangeAnimation(self.lockSuperSpine, lockFeatureAnimName, false)
		end
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------

function cls:initSpinLayerBg( )
	if self.mapPoints then
		self:setCollectProgressImagePos(self.mapPoints)
	end
	if self.mapLevel then
		self:setNextCollectTargetImage(self.mapLevel)
	end

	Theme.initSpinLayerBg(self)
	self:checkLockFeature()
end

function cls:initSpinLayer( )
	self.spinLayerList = {}
	for index,cofig in ipairs(self.boardNodeList) do
		self.initBoardIndex = index
		local boardNode = self.boardNodeList[index]
		local layer = SpinLayer.new(self, self.ctl,boardNode.reelConfig,boardNode)
		layer:DeActive()
		self.shakyNode:addChild(layer,-1)
		table.insert(self.spinLayerList,layer)
	end
	self.initBoardIndex = nil
	self.spinLayer = self.spinLayerList[1]
	self.spinLayer:Active()
end


function cls:initBoardNodes(pBoardConfigList)
	local boardRoot 	  = self.boardRoot
	local boardConfigList = pBoardConfigList or self.boardConfigList or {}
	local reelZorder 	  = 100
	self.clipData = {}
	local pBoardNodeList = {}
	-- 棋盘初始化
	for boardIndex, theConfig in ipairs(boardConfigList) do
		local theBoardNode 	= nil
		local reelNodes = {}
		if theConfig["row_single"] then -- 一行使用一个裁剪区域 等距才可以
			theBoardNode = cc.Node:create()
			boardRoot:addChild(theBoardNode)
			local rowReelCnt = theConfig["rowReelCnt"]
   			local index = 0
   			local clipNode = nil
   			local reelNode = nil
   	   		for reelIndex,config in ipairs(theConfig["reelConfig"]) do

   	   			if (reelIndex-1)%rowReelCnt == 0 then 
   	   				
   	   				reelNode = cc.Node:create()
   	   				reelNode:setLocalZOrder(reelZorder)
   	   				
					local vex = {
						config["base_pos"], -- 第一个轴的左下角  下左边界
						cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*rowReelCnt, 0)),  -- 下右边界
						cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*rowReelCnt, config["cellHeight"])),-- 上右边界
						cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"])),-- 上左边界
					}
		   		    local stencil = cc.DrawNode:create()
		   		    stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))

		   		    local clipAreaNode = cc.Node:create()
		   		    clipAreaNode:addChild(stencil)
		   		    clipNode = cc.ClippingNode:create(clipAreaNode)
		   		   
					theBoardNode:addChild(clipNode)	
					clipNode:addChild(reelNode)
   	   			end
				reelNodes[reelIndex] = reelNode
   		    end
		elseif theConfig["reel_single"] then -- 一个棋盘用一个裁剪区域
			local colReelCnt = theConfig["colReelCnt"]
			self.clipData["reel_single"] = {}
			-- local reelNode = cc.Node:create()
			-- reelNode:setLocalZOrder(reelZorder)
			theBoardNode = cc.Node:create()
			boardRoot:addChild(theBoardNode)

   			local clipNode = nil
   			local reelNode = nil
   			local vex
   			local stencil
   	   		for reelIndex,config in ipairs(theConfig["reelConfig"]) do
   	   			if (reelIndex-1)%colReelCnt == 0 then 
   	   				reelNode = cc.Node:create()
   	   				reelNode:setLocalZOrder(reelZorder)
   	   				
					vex = {
						config["base_pos"], -- 第一个轴的左下角  下左边界
						cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*colReelCnt, 0)),  -- 下右边界
						cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*colReelCnt, config["cellHeight"]*config["symbolCount"])),-- 上右边界
						cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"]*config["symbolCount"])),-- 上左边界
					}
					if theConfig["allow_over_range"] then
						vex[1] = cc.pAdd(vex[1], cc.p(-config["cellWidth"], 0))
						vex[4] = cc.pAdd(vex[4], cc.p(-config["cellWidth"], 0))

						vex[2] = cc.pAdd(vex[2], cc.p(config["cellWidth"], 0))
						vex[3] = cc.pAdd(vex[3], cc.p(config["cellWidth"], 0))
					end
		   		    stencil = cc.DrawNode:create()
		   		    stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))

		   		    local clipAreaNode = cc.Node:create()
		   		    clipAreaNode:addChild(stencil)
		   		    clipNode = cc.ClippingNode:create(clipAreaNode)
		   		   
					theBoardNode:addChild(clipNode)	
					clipNode:addChild(reelNode)
   	   			end
   	   			self:addBoardMaskNode(reelNode, config["base_pos"], reelIndex)

				reelNodes[reelIndex] = reelNode
				self.clipData["reel_single"][reelIndex] = {}
				self.clipData["reel_single"][reelIndex]["vex"] = vex
				self.clipData["reel_single"][reelIndex]["stencil"] = stencil
   		    end
		elseif theConfig["show_parts"] then
            local reelNode = cc.Node:create()
            reelNode:setLocalZOrder(reelZorder)
            theBoardNode = cc.Node:create()
            boardRoot:addChild(theBoardNode)
            local clipAreaNode = cc.Node:create()
            for reelIndex, config in ipairs(theConfig["reelConfig"]) do
                local vex = {
                    cc.pAdd(config["base_pos"], cc.p(0, -config["cellHeight"] * 0.5)), -- 第一个轴的左下角  下左边界
                    cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], -config["cellHeight"] * 0.5)), -- 下右边界
                    cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], config["cellHeight"] * (config["symbolCount"] + 0.5))), -- 上右边界
                    cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"] * (config["symbolCount"] + 0.5))), -- 上左边界
                }

                local stencil = cc.DrawNode:create()
                stencil:drawPolygon(vex, #vex, cc.c4f(1, 1, 1, 1), 0, cc.c4f(1, 1, 1, 1))
                clipAreaNode:addChild(stencil)
                reelNodes[reelIndex] = reelNode
            end
            local clipNode = cc.ClippingNode:create(clipAreaNode)

            theBoardNode:addChild(clipNode)
            clipNode:addChild(reelNode)
		end		
	
		theBoardNode.reelNodes 	   = reelNodes
		theBoardNode.reelConfig    = theConfig["reelConfig"]
		theBoardNode.boardIndex    = boardIndex
		theBoardNode.getReelNode   = function(theSelf,index)
			return theSelf.reelNodes[index]
		end
		pBoardNodeList[boardIndex] = theBoardNode
	end

	self:initBoardTouchBtn(boardConfigList)
	return pBoardNodeList
end

--------------------------------------------------------
function cls:initBoardTouchBtn(boardConfigList)
	for boardIndex, theConfig in pairs(boardConfigList) do
		if boardIndex == 1 then 
			local colReelCnt = theConfig["colReelCnt"]
			local boardBasePos, boardW, boardH
			local board_max_y
			for reelIndex, config in pairs(theConfig["reelConfig"]) do
				if reelIndex == 1 then
					board_max_y = config["base_pos"].y+config["cellHeight"]*config["symbolCount"]
				end

				if reelIndex == table.nums(theConfig["reelConfig"]) - colReelCnt +1 then 
					boardBasePos = config["base_pos"]
					boardW = config["cellWidth"]*colReelCnt
					boardH = board_max_y - config["base_pos"].y
				end
			end

			self:initTouchSpinBtn(boardBasePos, boardW, boardH)

			return 
		end
	end
end
--点击棋盘进行spin
function cls:initTouchSpinBtn(base_pos, boardW, boardH)
    local unitSize = 10
    local parent = self.boardRoot
    local img = "commonpics/kong.png"
    local touchSpin = function()
        -- if self:featureBtnCheckCanTouch() then
        --     self.ctl:toSpin()
        -- end
		self:footerCopySpinBtnEvent()
    end
    local touchBtn = Widget.newButton(touchSpin, img, img, img, false) --10
    touchBtn:setPosition(base_pos)
    touchBtn:setAnchorPoint(cc.p(0, 0))
    touchBtn:setScaleX(boardW / unitSize)
    touchBtn:setScaleY(boardH / unitSize)
    parent:addChild(touchBtn)
end

----------------------------------------- 滚轴蒙层控制 ----------------------------------
local BlackUint = {
    width = 54,
    height = 54
}
function cls:addBoardMaskNode(parentNode, base_pos, reelIndex)
    local boardIndex = math.floor((reelIndex - 1) / 5) + 1
    local startCol = reelIndex
    local endCol = reelIndex + 4

    local index = 0
    for col = startCol, endCol do

        local clipSp = bole.createSpriteWithFile("commonpics/common_black.png")
        clipSp:setAnchorPoint(0, 0)
        clipSp:setScaleX(G_cellWidth / BlackUint.width)
        clipSp:setScaleY(G_cellHeight * 3 / BlackUint.height)
        local myBase_pos = cc.pAdd(base_pos, cc.p(G_cellWidth * index, 0))
        clipSp:setPosition(myBase_pos)
        parentNode:addChild(clipSp)
        clipSp:setLocalZOrder(2000)
        self.baseBoardMaskList = self.baseBoardMaskList or {}
        self.baseBoardMaskList[col] = clipSp
        clipSp:setVisible(false)
        index = index + 1
    end

end
function cls:showBoardMaskNode(isAni)
    for col = 1, baseColCnt*boardTotalCnt do
        local maskNode = self.baseBoardMaskList[col]
        maskNode:stopAllActions()
        maskNode:setVisible(true)
        maskNode:setOpacity(0)
        maskNode:runAction(cc.FadeTo:create(0.2, 150))
    end

end

function cls:hideBoardMaskNodeByCol(pCol)

    local boardIndex = math.floor((pCol - 1) / 5) + 1

    local realCol = (pCol - 1) % 5 + 1

    local opacity = 150 - realCol * 30

    local startCol = (boardIndex - 1) * 5 + 1
    local endCol = boardIndex * 5
    for col = startCol, endCol do
        local dis = col - pCol
        if dis >= 0 then
            opacity = dis * 30
            self.baseBoardMaskList[col]:runAction(cc.FadeTo:create(0.1, opacity))
        else
            opacity = 0
            self.baseBoardMaskList[col]:setOpacity(0)
        end
    end


end

function cls:hideBoardMaskNode(isAni)
    for col = 1, baseColCnt*boardTotalCnt do
        local maskNode = self.baseBoardMaskList[col]
        maskNode:stopAllActions()
        maskNode:setVisible(false)
        maskNode:setOpacity(0)
    end
end

function cls:checkCanPlayMaskAnim()
	local canPlay = false
	if self.showBaseSpinBoard or ((not self.showReSpinBoard) and self.showFreeSpinBoard and self.fgType == FreeGameType.Normal) then 
		canPlay = true
	end
	return canPlay
end

------------------------------------------------------------------------------------------------
function cls:getThemeJackpotConfig()
	local jackpot_config_list = 
	{
		link_config = {"grand", "major", "minor", "mini"},
		allowK = {[192] = false, [692] = false, [1192] = false}
	}
	return jackpot_config_list
end

function cls:playCellRoundEffect(parent, ...) -- 播放中奖连线框
	self:addSpineAnimation(parent, nil, self:getPic("spine/kuang/spine"), cc.p(0,0), "animation", nil, nil, nil, true, true, nil)
end

------------------------------------- free 相关 ---------------------------------------
function cls:enterFreeSpin( isResume ) -- 更改背景图片 和棋盘
	self.isInFreeGame = true
	if isResume then  -- 断线重连的逻辑
		self:changeSpinBoard(SpinBoardType.FreeSpin)--  更改棋盘显示 背景 和 free 显示类型
		self:dealMusic_PlayFreeSpinLoopMusic()-- 切换背景音乐
	end
	
	self:showAllItem()
	self.playNormalLoopMusic = false --commonMusic: freespin背景音乐
end

function cls:showFreeSpinNode( count, sumCount, first )
    if self.superAvgBet then
        self.ctl:setPointBet(self.superAvgBet)-- 更改 锁定的bet
        self.ctl.footer:changeFreeSpinLayout3()-- 隐藏掉  footer bet
    end
	self:initMapFreeBoard()
	Theme.showFreeSpinNode(self, count, sumCount, first)
end

function cls:hideFreeSpinNode( ... ) -- 逻辑是个啥
	self:changeSpinBoard(SpinBoardType.Normal)

	self.curWinFreeCountList = nil

	self.stickyNode:removeAllChildren()

	if self.fgType ~= FreeGameType.Normal then 
		if self.mapLevel >= maxMapLevel then 
			self.mapLevel = 0
		end
	    self.mapPoints = 0
	    self:setCollectProgressImagePos(0, false, false)
	    self:setNextCollectTargetImage(self.mapLevel)
	end

	self.fgType = nil

	self.stickWildNodeList = nil
	self.wildStickList = nil
	self.bigWildList = nil
	self.moveWildSpine = nil
	self.wildTotalCount = nil
	self.moveWildNode:removeAllChildren()
	self.exWildFinalPos = nil
	self.beginWildPos = nil
	self.curWildMoveEndPos = nil
	self.wildNextBeginPos = nil

	self:checkIsOverSuperFeatrue()

	Theme.hideFreeSpinNode(self, ...)
end

function cls:checkIsOverSuperFeatrue( )
    if self.superAvgBet then 
        self.superAvgBet = nil

        self.ctl.footer:changeNormalLayout2()
    end
end

function cls:collectFreeRollEnd( ... )
    self:finshSpin()
    self.isInFreeGame = false
end

--------------------------------- free feature 相关  ------------------------
function cls:initMapFreeBoard()
    if self:isMultiGame() then
        self:addBigWildList()
    elseif self.fgType == FreeGameType.MovingWild then
        self:playMoveWildAppear()
    elseif self.fgType == FreeGameType.StickyWild then
        self:playStackWildAppear()
    end
end

function cls:updateFreeReelsStop(ret)
    local delatTm = 0
    if self:isMultiGame() then
        delatTm = 1
        self:removeBigWildMask(ret)

        self.ctl.rets.after_win_show = 1

    elseif self.fgType == FreeGameType.MovingWild then
        delatTm = self:updateMoveWildBoard(ret) or 0

        self.ctl.rets.after_win_show = 1

    elseif self.fgType == FreeGameType.StickyWild then
        self.ctl.rets.after_win_show = 1

    end

    if delatTm > 0 then
    	self:runAction(cc.Sequence:create(
    		cc.DelayTime:create(delatTm),
    		cc.CallFunc:create(function ()
    			self:checkHasWinInThemeInfo(ret)
    		end)))
    else
    	self:checkHasWinInThemeInfo(ret)
    end
end

function cls:isMultiGame()
    local ismuti = false
    if self.fgType == FreeGameType.MultiperWild1 or
            self.fgType == FreeGameType.MultiperWild2 or
            self.fgType == FreeGameType.MultiperWild3 then
        ismuti = true
    end
    return ismuti
end

-- random wild -----------------------------------------------------------------------------
local showSingleRandomDelay = 15/30
local showSingleRandomTotalT = 20/30
function cls:getPlayRandomWildAnimTime( newRandWildPos )
	if not newRandWildPos then return 0 end
	local maxCnt = 0
	for _, singleData in pairs(newRandWildPos) do 
		local cnt = bole.getTableCount(singleData)
		maxCnt = cnt > maxCnt and cnt or maxCnt
	end

	return  (maxCnt-1) * showSingleRandomDelay + specialAniDelay
end

local dimmerShowTime = 0.3
function cls:playAddRandWildSymbol(newRandWildPos)
    if not newRandWildPos or #newRandWildPos == 0 then return end

    self.randWildSList = {}
    local delay2 = self:getPlayRandomWildAnimTime(newRandWildPos)

    self:dealMusic_FadeLoopMusic(0.2, 1, 0.3)
    self.featureDimmer:setVisible(true)
    self.featureDimmer:setOpacity(0)
    self:runAction(cc.Sequence:create(
        cc.CallFunc:create(function ( ... )
            self.featureDimmer:runAction(cc.FadeTo:create(dimmerShowTime,170))
            self:playMusic(self.audio_list.kangroo_appear)
			self:dealMusic_FadeLoopMusic(0.3,1,0.3)-- 添加出特效音效控制/减小背景音乐音量 
			-- 播放激励动画
			self:addSpineAnimation(self.down_child, 20, self:getPic("spine/base/ds_jl_01"), cc.p(0,0), "animation")
        end),
        cc.DelayTime:create(specialAniDelay),
        cc.CallFunc:create(function ( ... )
        	self:setRandWildSymbol(newRandWildPos)
        end),
        cc.DelayTime:create(delay2),
        cc.CallFunc:create(function ( ... )
            self.featureDimmer:runAction(cc.FadeTo:create(dimmerShowTime,0))
            self:dealMusic_FadeLoopMusic(0.2, 0.3, 1)
        end)))
end

function cls:setRandWildSymbol( newRandWildPos )
    local file = self:getPic("spine/item/1/spine") -- 金币 动画
	for boardID = 1, boardTotalCnt do 
		local delay = 0
		local singleBoardNewRandPos = newRandWildPos[boardID]
		if singleBoardNewRandPos then 
			for k, posData in pairs(singleBoardNewRandPos) do
				if posData then
					local col = posData[1] + (boardID - 1)* baseColCnt
					local row = posData[2]
				    
				    local pos = self:getCellPos(col, row)
				    local _, s = self:addSpineAnimation(self.randomWildNode, 40, file, pos, "animation1", nil, nil, nil, true)-- 添加 wild symbol 动画 静止动画 
				    self.randWildSList[col] = self.randWildSList[col] or {}
				    self.randWildSList[col][row] = s
				    s:setVisible(false)

				    s:runAction(cc.Sequence:create(
				        cc.DelayTime:create(delay),
				        cc.CallFunc:create(function ( ... )
				            self:playMusic(self.audio_list.wild_appear)
				            self:addSpineAnimation(self.randomWildNode, 50, self:getPic("spine/item/1_top/wild_1"), pos, "animation1") -- 爆炸特效
				            if bole.isValidNode(s) then
				                bole.spChangeAnimation(s, "animation1")
				            end
				        end),
				        cc.Show:create()))  
				    delay = delay+showSingleRandomDelay
				end
			end
		end
	end
end
--end	       -----------------------------------------------------------------------------

-- multi wild  -----------------------------------------------------------------------------
function cls:playBigWildSpine(showType, boardIndex, multi)
    if showType == 1 then -- 展示倍乘
        if self.bigWildList[boardIndex] then
        	if bole.isValidNode(self.bigWildList[boardIndex].wild) then
        		self.bigWildList[boardIndex].wild:setAnimation(0, "animation1", false)
            end

        	if bole.isValidNode(self.bigWildList[boardIndex].mask) then 
        		self.bigWildList[boardIndex].mask:setAnimation(0, "animation1_1", false)
            end

            if multi then
                -- if not self.bigWildList[boardIndex].font then
                self:addMultiFont(self.bigWildList[boardIndex], multi)
                -- end
                self:playMultiAction(1, self.bigWildList[boardIndex].font, true)
            end
        end
    elseif showType == 2 then -- 中奖动画
        if self.bigWildList[boardIndex].wild then
        	self.bigWildList[boardIndex].wild:setAnimation(0, "animation2", false)
        end

    elseif showType == 3 then -- 隐藏倍乘
        if self.bigWildList[boardIndex] then
        	if bole.isValidNode(self.bigWildList[boardIndex].wild) then 
        		self.bigWildList[boardIndex].wild:setAnimation(0, "animation3", false)
            end
        	if bole.isValidNode(self.bigWildList[boardIndex].mask) then 
        		self.bigWildList[boardIndex].mask:setAnimation(0, "animation3_1", false)
            end
            if self.bigWildList[boardIndex].font then
                self:playMultiAction(2, self.bigWildList[boardIndex].font, true)
            end
        end
    end
end

function cls:addMultiFont(parentNode, multi)
    local value = multi .. "X"
    if not parentNode.font then
        local font_file = self:getPic("font/theme192_map1.fnt")
        local fnt = cc.Label:createWithBMFont(font_file, value)
        parentNode:addChild(fnt, 2)
        parentNode.font = fnt
        fnt:setPosition(cc.p(0, -reelCellH * 1.2))
    else
        parentNode.font:setString(value)
    end
end

---@param status 1:show 2: loop ,3:hide
function cls:playMultiAction(status, fontNode, isAni)
    if isAni then
        if status == 1 then
            fontNode:setScale(0)
            local a0 = cc.DelayTime:create(10 / 30)
            local a1 = cc.ScaleTo:create(5 / 30, 1.2)
            local a2 = cc.ScaleTo:create(5 / 30, 0.94)
            local a3 = cc.ScaleTo:create(5 / 30, 1)
            fontNode:runAction(cc.Sequence:create(a0, a1, a2, a3))
        else
            fontNode:setScale(1)
            local a1 = cc.ScaleTo:create(5 / 30, 0.94)
            local a2 = cc.ScaleTo:create(5 / 30, 1.2)
            local a3 = cc.ScaleTo:create(5 / 30, 0)
            fontNode:runAction(cc.Sequence:create(a1, a2, a3))
        end
    else
        if status == 1 then
            fontNode:setScale(1)
        else
            fontNode:setScale(0)
        end
    end
end

function cls:addBigWildSpine(boardIndex)
	local node = cc.Node:create()
    local col = (boardIndex - 1) * baseColCnt + 3
    local row = 2
    local pos = self:getCellPos(col, row)
    node:setPosition(pos)
    self.stickyNode:addChild(node)
    self.bigWildList[boardIndex] = node

    local spineFile = self:getPic("spine/item/1_big/1x3wild_01")
    local animateName = "animation4"
    local _, s1 = self:addSpineAnimation(node, 1, spineFile, cc.p(0,0), animateName, nil, nil, nil, true, false)
    self.bigWildList[boardIndex]["wild"] = s1

    local spineFile = self:getPic("spine/item/1_big/1x3wild_02")
    local animateName = "animation4_1"
    local _, s2 = self:addSpineAnimation(node, 3, spineFile, cc.p(0,0), animateName, nil, nil, nil, true, false)
    self.bigWildList[boardIndex]["mask"] = s2
end

function cls:addBigWildList()
    self.bigWildList = {}
    self.lockedReels = {}
    self.isShowBigWildMask = true
    for boardIndex = 1, boardTotalCnt do
        self:addBigWildSpine(boardIndex)
        local col = (boardIndex - 1) * baseColCnt + 3
        self.lockedReels[col] = true
        for row = 1, 3 do
            local cell = self.spinLayer.spins[col]:getRetCell(row)
            self:updateCellSprite(cell, specialSymbol.kong, col, 1, 1)
            cell.sprite:setVisible(false)
        end
    end
end

function cls:removeBigWildMask(ret)
    self.isShowBigWildMask = false
    for boardIndex = 1, boardTotalCnt do
        self:playBigWildSpine(1, boardIndex, self.multiNumList[boardIndex])
    end
    self:playMusic(self.audio_list.reel_appear)
end

function cls:showBigWildMask()
    if not self.isShowBigWildMask then

        self.isShowBigWildMask = true
        for boardIndex = 1, boardTotalCnt do
            self:playBigWildSpine(3, boardIndex)
        end
        self:playMusic(self.audio_list.reel_hide)
    end
end
-- end	       -----------------------------------------------------------------------------

-- moving wild -----------------------------------------------------------------------------
---@param moving_wild_pos : 所有wild的最终位置 final_wild_pos
---@param moving_wild_new : 会动的wild的最终位置 begin_wild_pos
function cls:getMoveWildTime()
	local delay = 0
	if self.wildTotalCount > 0 then
		delay = moveWildTime -- + changeToWildTime
	end
	return delay
end
function cls:playStopCtlMovingWild()
    if self.wildTotalCount > 0 then
        self:moveNextPos()
    end
end

---@ wild :/animation2 玫瑰循环/animation wild循环/animation3 rose->wild/animation1_1 wild->rose
function cls:playMoveWildAppear()
    if not self.exWildFinalPos then
        return
    end
    local noUseWildSpine = self.moveWildNode:getChildren()
    for _, node in pairs(noUseWildSpine) do 
    	node:setVisible(false)
    end
    self.moveWildSpine = {}
    self.mapData = self.mapData or {}
    local animName = "animation1_1"

    local spineName = specialSymbol.wild
    for boardIndex = 1, #self.exWildFinalPos do
        for k, posData in pairs(self.exWildFinalPos[boardIndex]) do
            local pos = self:getCellPos(posData[1] + (boardIndex - 1) * baseColCnt, posData[2])
            
            if #noUseWildSpine == 0 then
                local _, temp = self:addSpineAnimation(self.moveWildNode, 100, self:getPic("spine/item/1/spine"), pos, animName, nil, nil, nil, true)

                self.moveWildSpine[boardIndex] = self.moveWildSpine[boardIndex] or {}
				table.insert(self.moveWildSpine[boardIndex], temp)

                temp:runAction(cc.Sequence:create(
					cc.DelayTime:create(1),
					cc.CallFunc:create(function ( ... )
						bole.changeSpineNormal(temp, "animation2", true)
					end)))
            else
                local temp = table.remove(noUseWildSpine, 1)
                temp:setVisible(true)
                temp:setPosition(pos)
                bole.changeSpineNormal(temp, animName, false) -- 显示可移动状态

                self.moveWildSpine[boardIndex] = self.moveWildSpine[boardIndex] or {}
				table.insert(self.moveWildSpine[boardIndex], temp)

                temp:runAction(cc.Sequence:create(
					cc.DelayTime:create(1),
					cc.CallFunc:create(function ( ... )
						bole.changeSpineNormal(temp, "animation2", true)
					end)))
            end

			
        end
    end
end

function cls:moveNextPos()
	self.moveWildSList = {}
    local find = false
    if self.curWildMoveEndPos then
    	self:playMusic(self.audio_list.wild_move)

        for boardIndex = 1, #self.curWildMoveEndPos do
            if self.curWildMoveEndPos[boardIndex] and #self.curWildMoveEndPos[boardIndex] > 0 then
                local startCol = (boardIndex - 1) * baseColCnt

                self.moveWildSpine[boardIndex] = self.moveWildSpine[boardIndex] or {}
                for k, temp in pairs(self.moveWildSpine[boardIndex]) do
                	if temp and bole.isValidNode(temp) then
	                    find = true
	                    local endPos
	                    if self.curWildMoveEndPos[boardIndex][k] then
	                        local back = self.curWildMoveEndPos[boardIndex][k]
	                        endPos = { startCol + back[1], back[2] }
	                    end
	                    local pos2 = self:getCellPos(endPos[1], endPos[2]) -- 结果位置

	                    self.moveWildSList[endPos[1]] = self.moveWildSList[endPos[1]] or {}
	                    self.moveWildSList[endPos[1]][endPos[2]] = temp

	                    temp:stopAllActions()
	                    temp:runAction(cc.MoveTo:create(moveWildTime, pos2))
	                end
                end
            end
        end
        local a1 = cc.Sequence:create(
			cc.DelayTime:create(moveWildTime),
			cc.CallFunc:create(function(...)
				self.featureDimmer:runAction(cc.FadeTo:create(0.5, 0))
			end))
        libUI.runAction(self, a1)

    end
end

function cls:updateMoveWildBoard(ret) ---@desc 排面结束，重置排面
    local item_list
    if ret then
        item_list = ret.item_list
    end
    local find = false
    if self.beginWildPos and #self.beginWildPos > 0 then
        self:playMusic(self.audio_list.wild_appear)
        for boardIndex = 1, #self.beginWildPos do

            if self.moveWildSpine and self.moveWildSpine[boardIndex] then
                for k, temp in pairs(self.moveWildSpine[boardIndex]) do
                    if temp and bole.isValidNode(temp) then
                        find = true
                        self:addSpineAnimation(self.topAnimNode, -1, self:getPic("spine/item/1_down/wild_2"), cc.p(temp:getPosition()), "animation3") -- 爆炸特效
                        bole.changeSpineNormal(temp, "animation3")
                    end
                end
            end
        end
    end
    if find then
    	return 1
    end
end
-- end	       -----------------------------------------------------------------------------

-- sticky wild -----------------------------------------------------------------------------
function cls:playStackWildAppear()
    self.stickWildNodeList = self.stickWildNodeList or {}
    if self.wildStickList and #self.wildStickList > 0 then
        for boardIndex = 1, boardTotalCnt do
            if self.wildStickList[boardIndex] and #self.wildStickList[boardIndex] > 0 then
                for key, item in ipairs(self.wildStickList[boardIndex]) do
                    local realCol = (boardIndex - 1) * baseColCnt + item[1]
                    local row = item[2]

                    self.stickWildNodeList[realCol] = self.stickWildNodeList[realCol] or {}
                    if not bole.isValidNode(self.stickWildNodeList[realCol][row]) then
                        local pos = self:getCellPos(realCol, row)
                        local img = bole.createSpriteWithFile("#theme192_s_1.png")
                        self.moveWildNode:addChild(img)
                        img:setPosition(pos)
                        self.stickWildNodeList[realCol][row] = img
                    end
                end
            end
        end

    end
end
--end	       -----------------------------------------------------------------------------

----------------------------------------------- cell 相关 -----------------------------------------------
function cls:adjustWithTheCellSpriteUpdate( theCellNode, key, col ) -- 删除掉 tip 动画
	if theCellNode.symbolTipAnim then 
		if (not tolua.isnull(theCellNode.symbolTipAnim)) then 
			theCellNode.symbolTipAnim:removeFromParent()
		end
		theCellNode.symbolTipAnim = nil 
	end

	if theCellNode.symbolTipAnim2 then 
		if (not tolua.isnull(theCellNode.symbolTipAnim2)) then 
			theCellNode.symbolTipAnim2:removeFromParent()
		end
		theCellNode.symbolTipAnim2 = nil 
	end
end

function cls:getJackpotNum(key) -- 获得 金币上面显示的数字
    if jackpotBet[key] then --24 H
        return self.ctl:getCurTotalBet()*jackpotBet[key]
    else
        return ""
    end
end

function cls:newJackpotLabel(highType) -- 第一个参数：用来判断是否显示的是高级的颜色
    local highType
    local file = self:getPic("font/theme192_popup1.fnt")
    -- if highType then 
    --     file = self:getPic("font/theme192_popup1.fnt")
    -- else
    --     file = self:getPic("font/theme192_popup1.fnt")
    -- end
    local fntLabel = NumberFont.new(file, nil, true) -- ccui.TextBMFont:create() -- 
    fntLabel.font:removeFromParent() -- 设置成可以修改 字体资源的字体
    fntLabel.font = ccui.TextBMFont:create()
    fntLabel:addChild(fntLabel.font)
    fntLabel.font:setFntFile(file)
    function fntLabel:setString( n )  -- 控制显示文字 带k,m 同时保留3位有效数字
    	local ss
        if n == "" then 
        	ss = ""
            self.font:setString(ss)
        else
        	ss = FONTS.formatByCount4(n, 5, true)
            self.font:setString(ss)
        end
        return ss
    end
    fntLabel:setPosition(jpLabelPos)
    fntLabel:setScale(jpLabelScale)
    fntLabel:setAnchorPoint(jpLabelAnchorPoint)

    return fntLabel
end

local respinColor = cc.c3b(95, 95, 95)
local normalColor = cc.c3b(255, 255, 255)
local notInRespinSymbolSet = Set({specialSymbol.wild, specialSymbol.scatter, specialSymbol.kong}) 
function cls:createCellSprite(key, col, rowIndex)
	self.initialPics = self.initialPics or {}
	if self.specialItemConfig[key] then
		local colSet = self.specialItemConfig[key]["col_set"] or {}
		if colSet[col] then
			if colSet[col] == 0 then
				key = self:getNormalKey(col)
			elseif colSet[col] == 1 then
				if self.initialPics[col] then
					key = self:getNormalKey(col)
				else
					self.initialPics[col] = true
				end
			end
		end
	end
	------------------------------------------------------------
	local theCellNode   = cc.Node:create()
    theCellNode.up = cc.Node:create()
    theCellNode:addChild(theCellNode.up,20)

	if self.initBoardIndex == 2  then
		if not jackpotBet[key] then
			key = specialSymbol.kong
		end
	elseif self.initBoardIndex == 3 then
        key = math.random(102, 109)
	end

	if jackpotBet[key] then
		key = specialSymbol.bonus
	end

	if key == specialSymbol.bonus then
		local num = nil
		repeat 
			num = math.random(21,36)
		until (not jackpotType[num])
		
		theCellNode.up.label = self:newJackpotLabel(jackpotHigh[num])
        theCellNode.up.label:setString(self:getJackpotNum(num))
        theCellNode.up:addChild(theCellNode.up.label,15)
	end

	local theCellFile = self.pics[key]

	if not theCellFile then 
		print("whj: key, theCellFile",  key, theCellFile)
	end
	
	local theCellSprite = bole.createSpriteWithFile(theCellFile)
	theCellNode:addChild(theCellSprite)
	theCellNode.key 	  = key
	theCellNode.sprite 	  = theCellSprite
	theCellNode.curZOrder = 0

	bole.setEnableRecursiveCascading(theCellNode, true)

	------------------------------------------------------------
	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )
	local theKey = theCellNode.key
	if self.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self.symbolZOrderList[theKey]
	end
	if self.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self.symbolPosAdjustList[theKey])
	end
	return theCellNode
end

function cls:updateCellSprite(theCellNode, key, col, isShowResult, isReset, isNotChange)
	if bole.isValidNode(theCellNode.up) then  -- 重新创建label
		theCellNode.up:removeAllChildren()
	end

	if self.showReSpinBoard then 
		if (not isNotChange) and notInRespinSymbolSet[key] then --  (not jackpotBet[key]) and key ~= specialSymbol.kong 
			if isShowResult or isReset then 
				key = self:getNormalKey(col)
			else
				local _random = math.random()
				key = _random > bonusSymbolRandom and specialSymbol.bonus or self:getNormalKey(col)
			end
		end
	elseif self.showMapReSpinBoard then
        if type(key) == "number" and key < 100 then
            key = math.random(102, 109)
        end
	end
	local theCellFile = self.pics[key]

	if key == specialSymbol.bonus then
		local value = math.random()
		for i=1,#jackpotRand do
			if value < jackpotRand[i] then
				key = i + 20
				break
			end
		end     
	end

	if jackpotBet[key] then
		if not bole.isValidNode(theCellNode.up) then 
			theCellNode.up = cc.Node:create()
			theCellNode:addChild(theCellNode.up, 20)
		end

		local mul = jackpotBet[key]
		if type(mul) == "string" then
			-- theCellNode.up.jp = bole.createSpriteWithFile("#theme192_s_jn"..jackpotType[key]..".png")
			-- theCellNode.up:addChild(theCellNode.up.jp,15)
			theCellFile = "#theme192_s_j"..jackpotType[key]..".png"
		elseif type(mul) == "number" then
			theCellNode.up.label = self:newJackpotLabel(jackpotHigh[key])
			theCellNode.up.label:setString(self:getJackpotNum(key))
			theCellNode.up:addChild(theCellNode.up.label,15)
			theCellFile = self.pics[specialSymbol.bonus]
		end
		key = specialSymbol.bonus
	end

	if not theCellFile then 
		print("whj: key, theCellFile", key, theCellFile)
	end

	local theCellSprite = theCellNode.sprite
	bole.updateSpriteWithFile(theCellSprite, theCellFile)
	theCellNode.key 	  = key
	theCellNode.curZOrder = 0

	if self.showReSpinBoard and key ~= specialSymbol.bonus and (not isNotChange) then 
		theCellNode:setColor(respinColor)
	else
		theCellNode:setColor(normalColor)
	end

	------------------------------------------------------------
	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )	


	if (not isShowResult) and (not isReset) then
		if key == specialSymbol.scatter then  -- 添加拖尾动画
			local _, s2 = self:addSpineAnimation(theCellNode, -1, self:getPic("spine/item/" .. key .. "/scatter_tw"), cc.p(0, 0), "animation2", nil, nil, nil, true)
			theCellNode.symbolTipAnim2 = s2
		end
		if (not self.showReSpinBoard) and  key == specialSymbol.bonus then  -- 添加拖尾动画
			local _, s2 = self:addSpineAnimation(theCellNode, -1, self:getPic("spine/item/" .. key .. "/resymbol_tw"), cc.p(0, 0), "animation", nil, nil, nil, true)
			theCellNode.symbolTipAnim2 = s2
		end
	end

	local theKey = theCellNode.key
	if self.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self.symbolZOrderList[theKey]
	end	
	theCellSprite:setAnchorPoint(cc.p(0.5, 0.5))
	if self.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self.symbolPosAdjustList[theKey])
	else
		theCellSprite:setPosition(cc.p(0,0))
	end	
end

function cls:showBonusNode()
    self.ctl:resetCurrentReels(false, true) -- 更改 bonus 的棋盘
end
function cls:hideBonusNode(free, bonus)
    self.ctl:resetCurrentReels(free, bonus) -- 更改 bonus 的棋盘
end

function cls:getBonusReel()
    local data = self.ctl.theme_reels["respin"]

    if self.showMapReSpinBoard then
        data = self.ctl.theme_reels["map_slot"]
    else
    	for boardID = 1, boardTotalCnt do 
    		for col = 1, singleReelRespinCellCount do
    			local realCol = (boardID-1)*singleReelRespinCellCount + col
    			data[realCol] = self.ctl.theme_reels["respin"][(col-1)%baseColCnt + 1]
    		end
    	end 
    end
    return data
end

function cls:getFreeReel( )
	local data = self.ctl.theme_reels["free_reel"]
	if self.fgType ~= FreeGameType.Normal then 
		data = self.ctl.theme_reels["map_free_reel"]
	end

	local temp = {}
	for boardID = 1, boardTotalCnt do 
		for col = 1, baseColCnt do
			local realCol = (boardID-1)*baseColCnt + col
			temp[realCol] = data[col]
		end
	end 

	return temp
end

function cls:getMainReel( )
	local data = self.ctl.theme_reels["main_reel"]

	local temp = {}
	for boardID = 1, boardTotalCnt do 
		for col = 1, baseColCnt do
			local realCol = (boardID-1)*baseColCnt + col
			temp[realCol] = data[col]
		end
	end 

	return temp
end

function cls:adjustEnterThemeRet(data)
	data.theme_reels = {
		["main_reel"] = {
			[1] = {7,6,1,8,9,2,2,2,8,10,3,3,3,9,10,4,4,4,2,10,8,5,5,5,10,9,26,6,6,9,8,2,2,2,2,10,7,7,7,8,10,3,3,3,5,6,8,8,28,4,4,4,10,8,7,2,9,9,9,5,5,5,10,2,2,4,10,10,10,3,5},
			[2] = {7,6,1,8,9,32,2,2,8,10,3,3,3,9,10,4,4,24,10,8,5,2,5,10,9,26,6,6,9,1,2,2,2,8,10,7,7,7,8,10,23,3,3,5,6,8,8,8,24,4,4,10,8,7,6,32,9,9,5,5,5,10,9,5,4,10,10,10,3,5},
			[3] = {7,6,1,8,9,2,2,2,8,10,3,3,3,9,10,4,4,4,10,8,5,5,5,10,9,26,6,6,9,8,2,2,2,8,10,27,7,7,8,10,3,3,3,5,6,8,8,8,4,4,4,10,8,7,2,29,9,9,5,32,5,10,9,5,4,10,10,10,3,5},
			[4] = {7,6,1,8,9,2,2,27,8,10,3,23,3,9,10,4,4,4,10,28,5,5,5,10,9,6,26,6,9,1,2,25,2,8,10,7,7,7,8,10,3,3,3,5,6,8,8,28,4,4,4,10,8,7,6,9,9,9,5,5,5,10,9,32,4,10,10,10,3,5},
			[5] = {7,6,2,2,29,2,2,2,8,10,23,2,3,9,10,4,4,4,10,8,5,5,5,10,9,6,6,6,9,8,2,2,2,8,10,7,7,7,8,10,3,3,32,5,6,8,8,8,4,4,4,10,8,7,2,9,9,29,5,5,5,10,9,2,4,10,10,10,33,5},
		},
		["free_reel"] = {
			[1] = {1,1,1,28,9,2,2,2,8,10,3,3,3,9,10,5,12,12,12,9,4,4,4,10,8,5,5,5,10,4,26,6,6,5,27,7,7,3,2,2,2,8,10,5,12,12,12,9,8,28,8,3,3,3,9,10,4,9,9,9,4,4,4,10,8,5,10,10,10,25,2,24,10,4,2,11,7,5,12,12,12,9,8},
			[2] = {1,1,1,2,3,2,8,9,2,2,2,8,10,3,3,32,9,10,5,12,12,12,9,4,4,4,10,8,5,5,5,10,4,6,6,6,5,7,7,7,3,2,2,2,8,10,5,12,12,32,9,28,8,8,3,3,3,9,10,4,9,9,2,4,4,4,10,8,5,10,10,10,5,5,5,10,4,2,11,7,5,12,12,12,9,8},
			[3] = {1,1,1,2,2,2,8,9,2,2,2,8,10,3,3,23,9,10,5,12,12,12,9,4,4,24,10,8,5,5,5,10,4,6,6,6,5,7,7,7,3,2,2,2,8,10,5,12,12,12,9,8,8,8,2,3,3,3,9,10,4,9,9,9,4,4,4,10,8,2,10,10,10,5,5,5,10,24,2,11,7,5,12,12,12,9,8},
			[4] = {1,1,1,8,9,2,2,2,8,10,3,3,3,9,10,5,12,12,12,9,4,4,4,10,8,5,5,5,10,4,6,6,6,5,7,7,7,3,2,2,2,8,10,5,12,12,12,9,8,8,8,3,3,3,27,2,2,9,10,4,9,9,2,24,4,4,10,8,5,10,10,10,5,5,25,10,4,2,11,7,5,12,12,12,9,8},
			[5] = {1,1,1,2,2,3,8,9,2,2,2,8,10,3,3,2,29,10,5,12,12,12,9,4,4,2,10,8,5,5,5,10,4,6,6,6,5,7,7,7,7,7,3,2,2,2,8,10,5,12,12,12,9,8,8,8,3,3,3,9,10,24,9,9,9,4,4,4,10,8,2,10,10,10,5,5,5,10,4,2,11,7,5,12,12,12,9,8},
		},
		["map_free_reel"] = {
			[1] = {7,6,1,8,9,6,3,6,6,10,10,8,4,2,2,2,8,10,8,2,8,8,10,10,3,3,3,9,10,6,3,6,6,10,10,8,4,9,4,4,4,10,8,5,5,5,10,9,6,3,6,6,10,10,6,6,6,9,8,2,2,2,8,10,8,8,8,4,9,9,9,10,10,9,4,9,9,10,10,7,7,7,8,10,7,5,7,7,6,5,7,6,6,6,3,3,3,5,6,8,8,8,4,4,4,5,7,7,7,10,10,10,8,7,1,9,9,9,5,5,5,10,9,5,4,10,10,10,3,5},
			[2] = {7,6,1,8,9,6,3,6,6,10,10,8,4,2,2,2,8,10,8,2,8,8,10,10,3,3,3,9,10,6,3,6,6,10,10,8,4,9,4,4,4,10,8,5,5,5,10,9,6,3,6,6,10,10,6,6,6,9,8,2,2,2,8,10,8,8,8,4,9,9,9,10,10,9,4,9,9,10,10,7,7,7,8,10,7,5,7,7,6,5,7,6,6,6,3,3,3,5,6,8,8,8,4,4,4,5,7,7,7,10,10,10,8,7,1,9,9,9,5,5,5,10,9,5,4,10,10,10,3,5},
			[3] = {7,6,1,8,9,6,3,6,6,10,10,8,4,2,2,2,8,10,8,2,8,8,10,10,3,3,3,9,10,6,3,6,6,10,10,8,4,9,4,4,4,10,8,5,5,5,10,9,6,3,6,6,10,10,6,6,6,9,8,2,2,2,8,10,8,8,8,4,9,9,9,10,10,9,4,9,9,10,10,7,7,7,8,10,7,5,7,7,6,5,7,6,6,6,3,3,3,5,6,8,8,8,4,4,4,5,7,7,7,10,10,10,8,7,1,9,9,9,5,5,5,10,9,5,4,10,10,10,3,5},
			[4] = {7,6,1,8,9,6,3,6,6,10,10,8,4,2,2,2,8,10,8,2,8,8,10,10,3,3,3,9,10,6,3,6,6,10,10,8,4,9,4,4,4,10,8,5,5,5,10,9,6,3,6,6,10,10,6,6,6,9,8,2,2,2,8,10,8,8,8,4,9,9,9,10,10,9,4,9,9,10,10,7,7,7,8,10,7,5,7,7,6,5,7,6,6,6,3,3,3,5,6,8,8,8,4,4,4,5,7,7,7,10,10,10,8,7,1,9,9,9,5,5,5,10,9,5,4,10,10,10,3,5},
			[5] = {7,6,1,8,9,6,3,6,6,10,10,8,4,2,2,2,8,10,8,2,8,8,10,10,3,3,3,9,10,6,3,6,6,10,10,8,4,9,4,4,4,10,8,5,5,5,10,9,6,3,6,6,10,10,6,6,6,9,8,2,2,2,8,10,8,8,8,4,9,9,9,10,10,9,4,9,9,10,10,7,7,7,8,10,7,5,7,7,6,5,7,6,6,6,3,3,3,5,6,8,8,8,4,4,4,5,7,7,7,10,10,10,8,7,1,9,9,9,5,5,5,10,9,5,4,10,10,10,3,5},
		},
		["respin"] = {
			[1] = {22, 0, 0, 0, 0, 0, 0, 26, 36, 0, 0, 0, 0, 0, 24, 0, 29, 0, 0, 0, 0, 0, 0, 26, 0, 0, 0, 0, 0, 27, 34, 0, 0, 0, 0, 0, 22, 0, 0, 0, 37, 0, 0, 0, 0, 0, 0, 21, 27, 0, 0, 0, 30, 31, 0, 0, 0, 0, 0, 0, 33, 24, 25, 0, 0, 0, 30, 23, 0, 0, 22, 0, 0, 32, 0, 0, 0, 0, 0, 28, 21, 0, 0, 0, 0, 30, 35},
			[2] = {22, 0, 0, 0, 0, 0, 0, 26, 36, 0, 0, 24, 0, 29, 0, 0, 0, 26, 0, 0, 27, 34, 0, 0, 22, 0, 0, 0, 37, 0, 0, 0, 21, 27, 0, 0, 0, 0, 0, 0, 30, 31, 0, 0, 0, 0, 0, 0, 33, 24, 0, 0, 0, 25, 0, 0, 0, 30, 23, 0, 0, 0, 0, 0, 22, 0, 0, 32, 0, 0, 0, 0, 0, 28, 21, 0, 0, 0, 0, 30, 35},
			[3] = {22, 0, 0, 0, 0, 0, 0, 26, 36, 0, 0, 24, 0, 29, 0, 0, 0, 26, 0, 0, 27, 34, 0, 0, 22, 0, 0, 0, 37, 0, 0, 0, 21, 27, 0, 0, 0, 30, 31, 0, 0, 0, 0, 0, 0, 33, 24, 25, 0, 0, 0, 30, 23, 0, 0, 22, 0, 0, 32, 0, 0, 28, 21, 0, 0, 0, 0, 30, 35},
			[4] = {22, 0, 0, 0, 0, 0, 0, 26, 36, 0, 0, 24, 0, 29, 0, 0, 0, 0, 0, 0, 26, 0, 0, 27, 34, 0, 0, 22, 0, 0, 0, 37, 0, 0, 0, 0, 0, 0, 21, 27, 0, 0, 0, 0, 0, 0, 30, 31, 0, 0, 0, 33, 24, 25, 0, 0, 0, 30, 23, 0, 0, 0, 0, 0, 22, 0, 0, 32, 0, 0, 28, 21, 0, 0, 0, 0, 0, 0, 0, 30, 35},
			[5] = {22, 0, 0, 0, 26, 36, 0, 0, 0, 0, 0, 24, 0, 0, 0, 0, 29, 0, 0, 0, 26, 0, 0, 27, 34, 0, 0, 0, 0, 0, 22, 0, 0, 0, 37, 0, 0, 0, 21, 27, 0, 0, 0, 0, 0, 0, 30, 31, 0, 0, 0, 33, 24, 25, 0, 0, 0, 0, 0, 0, 30, 23, 0, 0, 22, 0, 0, 32, 0, 0, 0, 0, 0, 28, 21, 0, 0, 0, 0, 30, 35},

		 },
		["map_slot"] = {
			[1] = {1, 1, 1, 8, 9, 2, 2, 2, 8, 10, 3, 3, 3, 9, 10, 4, 4, 4, 10, 8, 5, 5, 5, 10, 9, 6, 6, 6, 9, 8, 7, 7, 7, 5, 6, 8, 8, 8, 7, 1, 9, 9, 9, 5, 4, 10, 10, 10, 3, 5},
			[2] = {1, 1, 1, 8, 9, 2, 2, 2, 8, 10, 3, 3, 3, 9, 10, 4, 4, 4, 10, 8, 5, 5, 5, 10, 9, 6, 6, 6, 9, 1, 7, 7, 7, 5, 6, 8, 8, 8, 7, 6, 9, 9, 9, 5, 4, 10, 10, 10, 3, 5},
			[3] = {1, 1, 1, 8, 9, 2, 2, 2, 8, 10, 3, 3, 3, 9, 10, 4, 4, 4, 10, 8, 5, 5, 5, 10, 9, 6, 6, 6, 9, 8, 7, 7, 7, 5, 6, 8, 8, 8, 7, 1, 9, 9, 9, 5, 4, 10, 10, 10, 3, 5},
		},
	}
	

	if data.unlock_info then
		self:updateUnlockInfo(data)
	end

	if data["map_info"] then
	  	self.mapPoints = data["map_info"]["map_points"]
	    self.mapLevel = data["map_info"]["map_level"]
	end

	if data["free_game"] then
		if data.free_game.fg_type then
			self.fgType = data.free_game.fg_type
		end

		if self.fgType ~= FreeGameType.Normal and data.free_game.avg_bet then 
			self.superAvgBet = data.free_game.avg_bet
		end
		if data.free_game.fg_win_count then
			self.curWinFreeCountList = tool.tableClone(data.free_game.fg_win_count)
		end

		self:dealFreeGameResumeRet(data)

		if data["free_game"]["free_spins"] and data["free_game"]["free_spins"] >= 0 then
		   	if data["free_game"]["free_spins"] == data["free_game"]["free_spin_total"] then 
    			data["first_free_game"] = {}

    			data["first_free_game"]["free_spins"] 		= data["free_game"]["free_spins"]
 				data["first_free_game"]["free_spin_total"] 	= data["free_game"]["free_spin_total"]
 				data["first_free_game"]["base_win"] 		= data["free_game"]["base_win"]
 				data["first_free_game"]["total_win"] 		= data["free_game"]["total_win"]
 				data["first_free_game"]["bet"] 				= data["free_game"]["bet"]
 				data["first_free_game"]["item_list"] 		= data["free_game"]["item_list"]
 				data["first_free_game"]["fg_type"] 			= data["free_game"]["fg_type"]
				data["first_free_game"]["wild_count"]		= data["free_game"]["wild_count"]

 				data["free_game"] = nil
			else
	            local realItemList = data["free_game"]["item_list"]
				data["free_game"]["item_list"] = tool.tableClone(realItemList)
				self.ctl.freeSpeical = self:getSpecialTryResume(realItemList)
    		end
		end
    end

	return data
end

function cls:updateUnlockInfo( data )
	self.unLockInfoData = tool.tableClone(data.unlock_info)
	local curUnlockMaxBet = 0
	for _bet, _ in pairs(self.unLockInfoData) do 
		local betN = tonumber(_bet)
		if betN > curUnlockMaxBet then 
			curUnlockMaxBet = betN
		end
	end

	self.unLockBetList = {}
	for _, _unLockType in pairs(unlockInfoTypeList) do 
		self.unLockBetList[_unLockType] = curUnlockMaxBet
	end
	
	for _bet, unlockTypeList in pairs(self.unLockInfoData) do 
		local betN = tonumber(_bet)
		for _, _unLockType in pairs(unlockTypeList) do
			if betN < self.unLockBetList[_unLockType] then 
				self.unLockBetList[_unLockType] = betN

				-- if self.jackpotLockNodes and self.jackpotLockNodes[_unLockType] and bole.isValidNode(self.jackpotLockNodes[_unLockType].unlockLabel) then
				-- 	self.jackpotLockNodes[_unLockType].unlockLabel:setString(FONTS.formatByCount4(self.unLockBetList[_unLockType], jackpotUnlockLbMaxCnt, true))
				-- end
			end
		end
	end
end

function cls:dealFreeGameResumeRet(retData)
	if retData and retData.map_extra_info then 
		local enterMapExtraInfo = retData.map_extra_info
		if self.fgType == FreeGameType.MovingWild then
		    if enterMapExtraInfo.moving_wild_pos then
		        -- free 断线重连数据 控制
		        self.wildNextBeginPos = tool.tableClone(enterMapExtraInfo.moving_wild_pos)
		        self.exWildFinalPos = tool.tableClone(enterMapExtraInfo.moving_wild_pos)
		    end
		    if enterMapExtraInfo.moving_wild_new then
		        self.beginWildPos = enterMapExtraInfo.moving_wild_new
		    end

		elseif self.fgType == FreeGameType.StickyWild then
		    self.wildStickList = enterMapExtraInfo.sticky_wild_pos or {}
		end
	end
end

function cls:getSpecialTryResume(realItemList)
	local specials = { [specialSymbol.scatter] = {} }

	if not self.curWinFreeCountList then return end
	for id, cnt in pairs(self.curWinFreeCountList) do 
		if cnt > 0 then
			for col = (id-1)*baseColCnt + 1, id*baseColCnt  do
				local colItemList = realItemList[col]
				for row,theKey in pairs(colItemList) do
					if theKey==specialSymbol["scatter"] then
						specials[theKey][col] 	   	= specials[theKey][col] or {}
						specials[theKey][col][row] 	= true
					end
				end
			end
		end
	end
    return specials

end

function cls:adjustTheme(data)
	self.isOverInitGame = true

	self:changeSpinBoard(SpinBoardType.Normal)

end

--------------------------------------------------------------------------------
function cls:changeSpinBoard(pType) -- 更改背景控制 已修改
	self:stopDrawAnimate()
	
	self.randomWildNode:removeAllChildren()

	self.jackpotNode:setVisible(true)
	self.mapFreeLogo:setVisible(false)
	self.rTotalCollectNode:setVisible(false)
	self.rTotalCollectLable:setVisible(false)

    self.HoldLayer._added = nil
    self.HoldLayer:removeAllChildren()
    self.lockedReels = nil

    self.bgAnim:removeAllChildren()

	for _, node in pairs(self.respinDimmerList) do 
		node:setVisible(false)
	end
	for _, node in pairs(self.rBoardCntTipNodes) do 
		node.parent:setVisible(false)
	end
	for _, node in pairs(self.rWinNodeList) do 
		node:setVisible(false)
	end

	local action = cc.CSLoader:createTimeline(self:getPic("csb/base.csb"))
	self.mainThemeScene:runAction(action)

	if pType == SpinBoardType.Normal then -- normal情况下 需要更改棋盘底板
		self.showFreeSpinBoard = false
		self.showReSpinBoard = false
		self.showMapReSpinBoard = false
		self.showBaseSpinBoard = true
		action:gotoFrameAndPause(0)

		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
		end

		if self.curBg ~= self.baseBg then 
			self.curBg:setVisible(false)
			self.baseBg:setVisible(true)
			self.curBg = self.baseBg
		end
	elseif pType == SpinBoardType.FreeSpin then
		self.showFreeSpinBoard = true
		self.showBaseSpinBoard = false
		self.showReSpinBoard = false
		self.showMapReSpinBoard = false
		action:gotoFrameAndPause(30)
		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
		end

		local showBG = self.fgType == 1 and self.free1Bg or self.free2Bg
		if self.curBg ~= showBG then 
			self.curBg:setVisible(false)
			showBG:setVisible(true)
			self.curBg = showBG
		end

		if self.fgType ~= FreeGameType.Normal then 
			self.mapFreeLogo:setVisible(true)
			self.jackpotNode:setVisible(false)
		end
		self:playBgYunMoveAnim()

		self.lockedReels = {}
	elseif pType == SpinBoardType.ReSpin then
		self.showBaseSpinBoard = false
		self.showReSpinBoard = true

		if self.spinLayer ~= self.spinLayerList[2] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[2]
			self.spinLayer:Active()
		end

		self.HoldLayer:removeAllChildren()
		self.lockedReels = {}
		self.HoldLayer._added = {}
	elseif pType == SpinBoardType.Map_ReSpin then
		self.showBaseSpinBoard = false
		self.showMapReSpinBoard = true
        if self.spinLayer ~= self.spinLayerList[3] then
            self.spinLayer:DeActive()
            self.spinLayer = self.spinLayerList[3]
            self.spinLayer:Active()
        end
	end
end

---------------------------------- spin 相关 ------------------------
function cls:onSpinStart()
	self.isFeatureClick = true
	self.DelayStopTime = 0

	if self.showBaseSpinBoard then
		-- if self.isDealBoardOpen then
		-- 	self:hideDealBonusSceneAnimation()
		-- end
		self.stickyNode:removeAllChildren()
		self.stickWildNodeList = nil
	end

	if self:checkCanPlayMaskAnim() then 
		self:showBoardMaskNode()
	end

	if self.showFreeSpinBoard then

        if self.fgType == FreeGameType.MovingWild and self.wildTotalCount and self.wildTotalCount >0 then
        	self.featureDimmer:setVisible(true)
        	self.featureDimmer:setOpacity(0)
        	self.featureDimmer:runAction(cc.FadeTo:create(0.5, 150))
        elseif self:isMultiGame() then
            self:showBigWildMask()
        end
    end

    self.randomWildPos = nil
    self.curWildMoveEndPos = nil
    self.multiNumList = nil
    self.scFallData = nil
	self.expandItemList = nil
	self.firstExpandCol = nil

	self.respinStep = ReSpinStep.OFF
	Theme.onSpinStart(self)
end

function cls:onSpinStop(ret)
	self.respinStep = ReSpinStep.OFF
	if ret.bonus_game then --ret.theme_respin
		self.respinStep = ReSpinStep.Start
	end
	self:fixRet(ret)
	
	Theme.onSpinStop(self, ret)
end

function cls:fixRet(ret) -- 查看逻辑控制原因 拆分服务器返回的滚轴数据,分成15个结果
	if self.showReSpinBoard then
		self:fixRetByBonus(ret)
	elseif self.showMapReSpinBoard then
		self:fixRetByMapSlots(ret)
	else
		self:fixRetByNormal(ret)
	end
end

function cls:fixRetByBonus(ret)
	self.ctl.resultCache = {}
    if ret.item_list then -- 正常中奖
		local itemsList = tool.tableClone(ret.item_list)

		for id = 1, boardTotalCnt do 
			for i=0, singleReelRespinCellCount-1 do -- 横向拆分 和 棋盘一致
				local _col = 1+(i%5) + (id-1)*baseColCnt
				local _row = 1+math.floor(i/5)
				local _item = (itemsList[_col][_row])

				local respinCol = 1+i + (id-1)*singleReelRespinCellCount
				ret.item_list[respinCol] = {_item}
				self.ctl.resultCache[respinCol] = {_item}

				local extraCount = 6
				if self.isTurbo then
					extraCount = 3
				end
				for k = 1, extraCount + 1 do -- 向下插入 六个 值
					key = math.random() > bonusSymbolRandom and specialSymbol.bonus or self:getNormalKey()
					if k == 1 then 
						table.insert(self.ctl.resultCache[respinCol], 1, self:getNormalKey())
					else
						if key == 2 then 
							table.insert(self.ctl.resultCache[respinCol], self:getNormalKey())
						else
							table.insert(self.ctl.resultCache[respinCol], key)	
						end
					end
				end
			end
		end
    end
end

function cls:fixRetByMapSlots( ret )
    self.ctl.resultCache = {}
    local itemsList = table.copy(ret.item_list)
    local item_list_up = {}
    local item_list_down = {}

    for i = 1, 3 do
        item_list_up[i] = { math.random(102, 109) }
        item_list_down[i] = {}

        for j = 1, 6 do
            item_list_down[i][j] = math.random(102, 109)
        end
    end

    for k, v in pairs(itemsList) do

        local reelList = tool.tableClone(v)

        table.insert(reelList, 1, item_list_up[k][1]) -- 插入 第一条数据

        if self.isTurbo then
            for i = 1, (#item_list_down[k]) / 2 do
                -- 插入后面几条数据
                reelList[#reelList + 1] = item_list_down[k][i]
            end
        else
            for i = 1, #item_list_down[k] do
                -- 插入后面几条数据
                reelList[#reelList + 1] = item_list_down[k][i]
            end
        end

        table.insert(self.ctl.resultCache, reelList)
    end
end

function cls:fixRetByNormal( ret )
	if ret["win_ways_list"] then 
		local new_win_ways = {}
		for i , _winWayData in pairs(ret["win_ways_list"]) do
			if #_winWayData > 0 then
				for _, singleWinWays in ipairs(_winWayData) do

					local new_single_win_way = tool.tableClone(singleWinWays) -- 更新新的 winLisne
					new_single_win_way.win_pos = {}
					for _, v in pairs(singleWinWays.win_pos) do 
						table.insert(new_single_win_way.win_pos, {v[1] + (i-1) * baseColCnt, v[2]})
					end
					table.insert(new_win_ways, new_single_win_way)
				end
			end
		end
	    ret["win_ways"] = new_win_ways
	end
end


---------------------------------------------------------------
function cls:after_win_show()
    self:clearAnimate()
    self.ctl.rets = self.ctl.rets or {}
    self.ctl.rets.after_win_show = false
    local delayTime = 0
    if self.ctl.freespin and self.ctl.freespin > 0 then
        if self.showFreeSpinBoard then
            if self.fgType == FreeGameType.MovingWild then
                if self.wildNextBeginPos then
                	local hasMove = false
                	for _, posList in pairs(self.wildNextBeginPos) do
                		if #posList > 0 then 
                			hasMove = true
                		end
                	end
                	if hasMove then 
                		self.exWildFinalPos = self.wildNextBeginPos
	                    delayTime = 1
	                    self:playMoveWildAppear()
                	end
                end
            elseif self.fgType == FreeGameType.StickyWild then
                self:playStackWildAppear()
            end


        end
    end
    if delayTime and delayTime > 0 then
        self:runAction(cc.Sequence:create(
        	cc.DelayTime:create(delayTime),
        	cc.CallFunc:create(function ( ... )
        		self.ctl:handleResult()
        	end)))
    else
        self.ctl:handleResult()
    end
end

function cls:theme_deal_data( rets ) -- 用来控制 respin 过程中的 themeInfo 调用 和 赢钱控制
	rets["theme_deal_data"] = nil
	local overFunc = function ( ... )
		self.ctl:handleResult()
	end
	
	if self.bonus then 
		self.ctl.footer:setSpinButtonState(true) -- 禁用按钮
		self.bonus:checkRespinDataByThemeDealData(overFunc)
	else
		overFunc()
	end

end

function cls:theme_deal_show(ret)
	ret.theme_deal_show = nil

	if self.respinStep == ReSpinStep.Reset then 
		self.bonus:freshRespinTotalNum()    
		self:laterCallBack(restJackpotSpineTime, function ()
			self.ctl:handleResult()
		end)
	elseif self.respinStep == ReSpinStep.Over then
		if self.showReSpinBoard then
			self.bonus:onRespinStop(ret) -- self.bonus:onRespinFinish(ret, true)
        elseif self.showMapReSpinBoard then
            self.slotBonus:onRespinFinish(ret, true)
        end
    else
    	self.ctl:handleResult()
	end
end

function cls:theme_respin( rets )
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(function()
        local respinList = rets["theme_respin"]
		if respinList and #respinList>0 then
		    rets["item_list"] = table.remove(respinList, 1)

		    local respinStopDelay = 1
		    local endCallFunc     = self:getTheRespinEndDealFunc(rets)
		    self:stopDrawAnimate()
		    self.ctl:respin(respinStopDelay, endCallFunc)
		else
		    rets["theme_respin"] = nil
		end 
    end)))
end

function cls:onRespinStart()
	if self.showMapReSpinBoard then
        self.slotBonus:onRespinStart()
    elseif self.showReSpinBoard then
    	self.bonus:onRespinStart()
    end

    self.scFallData = nil
	self.expandItemList = nil

    self.DelayStopTime = 0
    Theme.onRespinStart(self)
    self:cleanSpecialSymbolState()
    self.lastCol = nil
end

function cls:onRespinStop(ret)
	self:fixRet(ret)

    if #ret["theme_respin"] == 0 then
        self.respinStep = ReSpinStep.Over
        ret.theme_deal_show = true
    end
    Theme.onRespinStop(self, ret)
end


--------------------------Start--------------------------
-----------------------多棋盘 相关属性----------------------

function cls:stopControl( stopRet, stopCallFun )
	if stopRet["unlock_info"] then
		self:updateUnlockInfo(stopRet)
	end

	if stopRet.free_spins and stopRet.free_game then
		if (not self.ctl.freewin) then -- 第一次中奖
			if stopRet.free_game.fg_type then
				self.fgType = stopRet.free_game.fg_type
			end

	        if self.fgType ~= FreeGameType.Normal then 
	            self.superAvgBet = stopRet.free_game.avg_bet
	        end
		end

		-- todo 中奖位置，和 retriger  位置
		if stopRet.free_game.fg_win_count then
			self.curWinFreeCountList = tool.tableClone(stopRet.free_game.fg_win_count)
		end
	end

	if stopRet.theme_info then
		stopThemeInfo = stopRet.theme_info

		if stopThemeInfo.map_info and stopThemeInfo.map_info.map_points and stopThemeInfo.map_info.map_points ~= self.mapPoints then
			self.winCollectPoints = true
		end

		if stopThemeInfo.sc_fall then 
			local sc_fall = tool.tableClone(stopThemeInfo.sc_fall)
			self.scFallData = {}
			self.expandItemList = {}
			self.hasExpandAnimList = {}
			self.firstExpandCol = {}
			local _itemList = stopRet.item_list or self.ctl:getRetMatrix()
			for boardID, temp in pairs(sc_fall) do
				if #temp > 0 then 
					local startCol = (boardID-1)*baseColCnt
					for _, boardCol in pairs(temp) do
						local realCol = boardCol + startCol
						self.scFallData[realCol] = true

						if not self.firstExpandCol[boardCol] then 
							self.firstExpandCol[realCol] = realCol
						end
						if realCol + baseColCnt <= baseColCnt*boardTotalCnt then 
							self.hasExpandAnimList[realCol + baseColCnt] = true
						end
						if _itemList and _itemList[realCol] then 
							self.expandItemList[realCol] = tool.tableClone(_itemList[realCol])
						end
					end
					
				end
			end
			self.canFastStop = false
		end
	end

	if self.showFreeSpinBoard then 
        self:normalFreeStopCtl(stopRet)
	end

	stopCallFun()

end

-- moving 中的 map_extra_info 内包括两个字段，"moving_wild_pos"和"moving_wild_new"，"moving_wild_pos"为本次出现的wild位置，用于下次moving，"moving_wild_new"为上次出现的wild移动到的新位置
function cls:normalFreeStopCtl( stopRet )
	if stopRet and stopRet.theme_info and stopRet.theme_info.map_extra_info then 
		self.isInMapFreeStop = true
		local mapExtraInfo = stopRet.theme_info.map_extra_info
		if mapExtraInfo.multi_num then -- fgType == 3
			self.multiNumList = tool.tableClone(mapExtraInfo.multi_num)
		end
		if mapExtraInfo.random_wild_pos then -- fgType == 3
			self.randomWildPos = tool.tableClone(mapExtraInfo.random_wild_pos)
		end

		if self.fgType == FreeGameType.MovingWild then
			if mapExtraInfo.moving_wild_pos and #mapExtraInfo.moving_wild_pos ~= 0 then
				self.wildNextBeginPos = tool.tableClone(mapExtraInfo.moving_wild_pos)
			end
			self.wildTotalCount = 0
			if mapExtraInfo.moving_wild_new then
				if mapExtraInfo.moving_wild_new then
					local count = 0
					for boardID = 1, boardTotalCnt do
					    count = #mapExtraInfo.moving_wild_new[boardID] + count
					end
					self.wildTotalCount = count

					if count > 0 then
					    self.curWildMoveEndPos = tool.tableClone(mapExtraInfo.moving_wild_new)
					    self.beginWildPos = mapExtraInfo.moving_wild_new
					end
			    end
			end
		end

		if mapExtraInfo.sticky_wild_pos then -- fgType == 5
			self.wildStickList = tool.tableClone(mapExtraInfo.sticky_wild_pos)
		end
	end
end

-------------------------------------------------------------------------
function cls:getSpinColFastSpinAction(pCol)
	local speedScale = nil
	return Theme.getSpinColFastSpinAction(self, pCol, speedScale)
end

function cls:getSpinConfig( spinTag )
	local spinConfig = {}
	if self.showReSpinBoard then
		for boardID = 1, boardTotalCnt do  
			for i=0, singleReelRespinCellCount-1 do
				local col = i+1 + (boardID - 1)*singleReelRespinCellCount
				local tempCol = i%baseColCnt+1
				local theStartAction = self:getSpinColStartAction(tempCol,col)
				local theReelConfig = {
					["col"]     = col,
					["action"]  = theStartAction,
				}
				table.insert(spinConfig, theReelConfig)
			end
		end
	else
		for col,_ in pairs(self.spinLayer.spins) do
			local theStartAction = self:getSpinColStartAction(col)
			local theReelConfig = {
				["col"]     = col,
				["action"]  = theStartAction,
			}
			table.insert(spinConfig, theReelConfig)
		end	
	end
	return spinConfig
end

function cls:getStopConfig( ret, spinTag ,interval )
	local stopConfig  = {}
	if self.showReSpinBoard then
		for boardID = 1, boardTotalCnt do  
			for i=0, singleReelRespinCellCount-1 do
				local col = i+1 + (boardID - 1)*singleReelRespinCellCount
				local tempCol = i%baseColCnt+1
				local theAction = self:getSpinColStopAction(ret["theme_info"], tempCol,interval)
				table.insert(stopConfig, {col, theAction})
			end
		end
	else 
		for col, _ in pairs(self.spinLayer.spins) do
			local theAction = self:getSpinColStopAction(ret["theme_info"], col,interval)
			table.insert(stopConfig, {col, theAction})
		end 
	end
	return stopConfig
end


function cls:getSpinColStartAction( pCol, reelCol)
    if self.isTurbo then
        maxSpeed = fastSpeed
    else 
        maxSpeed = normalSpeed
    end
    local spinAction = {}
    spinAction.delay = delay*(pCol-1)
    spinAction.upBounce = upBounce
    spinAction.upBounceMaxSpeed = upBounceMaxSpeed
    spinAction.upBounceTime = upBounceTime
    spinAction.speedUpTime = speedUpTime
    spinAction.maxSpeed = maxSpeed
    if self.showReSpinBoard then 
        if self.lockedReels and self.lockedReels[reelCol] then
            spinAction.locked = true
        else
            self.lastCol = reelCol
        end
    elseif self.showFreeSpinBoard then 
    	if self.lockedReels and self.lockedReels[pCol] then 
    		spinAction.locked = true
    	end
    end
    
    return spinAction
end

function cls:getSpinColStopAction(themeInfo, pCol, interval)
	if pCol == 1 then -- 同时下落的时候 进行的 延迟 重置
        self.DelayStopTime = 0
    end

	local checkNotifyTag   = self:checkNeedNotify(pCol)
	if checkNotifyTag then
		self.DelayStopTime = self.DelayStopTime + extraReelTime
	end

	local spinAction = {}
	spinAction.actions = {}

-- self.moveWildPos
	local specialType
	if self.showFreeSpinBoard then
		if self.randomWildPos then 
			specialType = 1
		end
		if self.wildTotalCount and self.wildTotalCount > 0 then 
			specialType = 2
		end
	end

	local function onSpecialBegain( pcol)
		if pcol == 1 then 
			if specialType == 1 then 
				self.ctl.specialSpeed = true
				self:playAddRandWildSymbol(self.randomWildPos)
			else
				self:playStopCtlMovingWild()
			end
		end
	end

    local temp = interval - speedUpTime - upBounceTime
    local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0
	
    local _stopDelay, _downBonusT = self:getCurSpinLayerSpinActionTime(stopDelayList, downBounceTime, checkStopColCnt, autoStopDelayMult, autoDownBounceTimeMult )

    if specialType then
		local addSpecialTime = specialType == 1 and (self:getPlayRandomWildAnimTime(self.randomWildPos) or 0) or (self:getMoveWildTime() or 0)
		
		local extraSymbolInFreeTime = 0
		if self.firstFreeGameTrigger then 
			local extraSymbolInFreeTime = extraReelTimeInFreeGame
			table.insert(spinAction.actions, {["endSpeed"] = extraSymbolInFreeTime,["totalTime"] = addSpecialTime, ["accelerationTime"] = 10/60})
		end

		table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = addSpecialTime, ["accelerationTime"] = 10/60,["beginFun"] = onSpecialBegain})
		table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = 1000,["accelerationTime"] = 1000})
		
		spinAction.stopDelay = timeleft+(pCol-1)*_stopDelay + addSpecialTime + extraSymbolInFreeTime -- 增加的 delay 时间 -- 

        self.ExtraStopCD = spinAction.stopDelay+speedDownTime
        self.canFastStop = false
        spinAction.ClearAction = true
	elseif self.firstFreeGameTrigger then
		table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = 1000,["accelerationTime"] = 10/60})
		spinAction.stopDelay = timeleft+(pCol-1)*_stopDelay + extraReelTimeInFreeGame + self.DelayStopTime

		self.ExtraStopCD = spinAction.stopDelay+speedDownTime
		self.canFastStop = false
		spinAction.ClearAction = true
    else
        spinAction.stopDelay = timeleft+(pCol-1)*_stopDelay + self.DelayStopTime
        self.ExtraStopCD = spinMinCD - temp > 0 and spinMinCD - temp or 0
    end

	spinAction.maxSpeed = maxSpeed
	spinAction.speedDownTime = speedDownTime
	if self.isTurbo then
		spinAction.speedDownTime = spinAction.speedDownTime * 3/4
	end
	spinAction.downBounce = downBounce
	spinAction.downBounceMaxSpeed = downBounceMaxSpeed
	spinAction.downBounceTime = _downBonusT
	spinAction.stopType = 1
	return spinAction
end

------------------------------------------------------------------------------------------
function cls:genSpecials( pWinPosList )
	local specials 	 = {[specialSymbol["scatter"]]={}}
	
	if self.showMapReSpinBoard then return end

	local itemList   = self.ctl:getRetMatrix()
	if not self.curWinFreeCountList then return end
	if itemList and self.curWinFreeCountList then
		for id, cnt in pairs(self.curWinFreeCountList) do 
			if cnt > 0 then
				for col = (id-1)*baseColCnt + 1, id*baseColCnt  do
					local colItemList = itemList[col]
					if colItemList then 
						for row,theKey in pairs(colItemList) do
							if theKey==specialSymbol["scatter"] then
								specials[theKey][col] 	   	= specials[theKey][col] or {}
								specials[theKey][col][row] 	= true
							end
						end
					end
				end
			end
		end

	end
	self.ctl.specials = specials	
end

function cls:genSpecialSymbolState( rets )
	rets = rets or self.ctl.rets -- 复制 通用逻辑
	if not self.checkItemsState then
		self.checkItemsState = {}  -- 都已列作为项， 各列各个sybmol相关状态，分为后面有可能，单列就有可能中，已经中了，后续没有可能中了
		self.speedUpState 	 = {}  -- 加速的列控制
		self.notifyState 	 = {}  -- 播放特殊symbol滚轴停止的时候的动画位置

		if self.showReSpinBoard then 
			-- self:genSpecialSymbolStateInRespin(rets)
		elseif self.showMapReSpinBoard then

		else
			self:genSpecialSymbolStateInNormal(rets) -- base 情况 配置 scatter
		end
	end
end

function cls:genSpecialSymbolStateInNormal(rets)
	local cItemList   = rets.item_list
	local checkConfig = self.specialItemConfig
	for itemKey,theItemConfig in pairs(checkConfig) do
		local itemType     = theItemConfig["type"]
		local itemCnt  	   = 0
		local isBreak 	   = false
		if itemType then
			for col=1, #self.spinLayer.spins do
				itemCnt = col%baseColCnt == 1 and 0 or itemCnt
				local colItemList  = cItemList[col]
				local colRowCnt    = self.spinLayer.spins[col].row -- self.colRowList[col]
				local curColMaxCnt = theItemConfig["col_set"][col] or colRowCnt
				-- 判断_当前列之前_是否已经中了feature(通过之前列itemKey个数判断)
				local isGetFeature = false
				if itemCnt >= theItemConfig["min_cnt"] then
					isGetFeature = true
				end
				-- 判断是否可能中feature或者更大的feature   一般用于滚轴加速
				local willGetFeatureInCol = false
				if curColMaxCnt>0 and (itemCnt+curColMaxCnt)>=theItemConfig["min_cnt"] then
					willGetFeatureInCol = true
					self.speedUpState[col] = self.speedUpState[col] or {}-- 此情况下，会进行特殊操作，将其状态记到self.speedUpState中
					self.speedUpState[col][itemKey] = true
				end
				-- 判断当前列加上之后所有列是否有可能中feature
				local willGetFeatureInAfterCols = false
				
				local sumCnt = 0
				for tempCol=(col-1)%baseColCnt + 1, baseColCnt do
					sumCnt = sumCnt + (theItemConfig["col_set"][tempCol] or colRowCnt)
				end
				if sumCnt>0 and (itemCnt+sumCnt)>=theItemConfig["min_cnt"] then
					willGetFeatureInAfterCols = true				
				end
				
				self.notifyState[col] = self.notifyState[col] or {}-- 当前列提示相关状态
				if curColMaxCnt>0 and willGetFeatureInAfterCols then
					for row, theItem in pairs(colItemList) do
						if theItem == itemKey then
							self.notifyState[col][itemKey] = self.notifyState[col][itemKey] or {}
							table.insert(self.notifyState[col][itemKey], {col, row})
						end
					end
				end
				for row, theItem in pairs(colItemList) do
					if theItem == itemKey then
						itemCnt = itemCnt + 1
					end
				end
			end
		end
	end	
	self:checkOtherFeatureSymbol(rets)
end

function cls:checkOtherFeatureSymbol(rets)
	if rets.item_list then
		for col, colItemList in pairs(rets.item_list) do
			for row, theItem in pairs(colItemList) do -- 落地动画
				if jackpotBet[theItem] then
					self.notifyState[col] = self.notifyState[col] or {}
					self.notifyState[col][specialSymbol.bonus] = self.notifyState[col][specialSymbol.bonus] or {}
					table.insert(self.notifyState[col][specialSymbol.bonus], {col, row, theItem})
				end
			end
		end
	end
end


function cls:genSpecialSymbolStateInRespin( rets )
 --    local cItemList = rets.item_list

 --    local bonusSymbolCnt = 0
 --    local miniBonusWinCnt = 15
 --    for boardId = 1, boardTotalCnt do 
 --    	local startCol = (boardId - 1)*singleReelRespinCellCount
	-- 	for boardCol=1, baseColCnt do -- bonus 落地计算
	-- 		local col = startCol + boardCol
	--         -- local colItemList = {cItemList[col][1],cItemList[5+col][1],cItemList[10+col][1],cItemList[15+col][1]}
	--         if colItemList then
	--             for row, theItem in pairs(colItemList) do -- 落地动画

	--                 local realCol = (row-1)*baseColCnt + col
	--                 if not (self.lockedReels and self.lockedReels[realCol]) then 
	--                     if bonusSymbolCnt + 1 == miniBonusWinCnt then -- 加上这个 正好中奖
	--                         self.speedUpState[realCol] = self.speedUpState[realCol] or {}-- 此情况下，会进行特殊操作，将其状态记到self.speedUpState中
	--                         self.speedUpState[realCol][specialSymbol.bonus] = true
	--                     end
	--                 end
	--             end
	--         end
	-- 	end
	-- end
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

function cls:checkPlaySymbolNotifyEffect( pCol ) 
	local isPlaySymbolNotify = false
	self:dealMusic_StopReelNotifyMusic(pCol) -- 停止滚轴加速的声音

	if not self.fastStopMusicTag then -- 判断是否播放特殊symbol的动画
		isPlaySymbolNotify = self:dealMusic_PlaySpecialSymbolStopMusic(pCol)-- 判断是否播放特殊symbol的动画
	else
		if self:checkCanPlayMaskAnim() then 
        	self:hideBoardMaskNode()
        end

		local endCol = self.showReSpinBoard and self.lastCol or #self.spinLayer.spins
		if pCol == endCol then
			local haveSymbolLevel = 3 -- 普通下落音的等级
			for k,v in pairs(self.notifyState) do -- 判断在剩下停止的滚轴中是否有特殊symbol
			 	if bole.getTableCount(v) > 0 then
					if v[specialSymbol.scatter] then -- scatter
						if haveSymbolLevel >1 then
							haveSymbolLevel = 1
						end
						self:playSymbolNotifyEffect(k) -- 播放特殊symbol 下落特效
					elseif v[specialSymbol.bonus] then -- bonus
						if haveSymbolLevel >2 then
							haveSymbolLevel = 2
						end
						self:playSymbolNotifyEffect(k) -- 播放特殊symbol 下落特效
					end	
					self.notifyState[k] = {}
				end
			end
			if haveSymbolLevel<3 then
				self:playMusic(self.audio_list["special_stop" .. haveSymbolLevel])
				isPlaySymbolNotify = true
			end
		end
	end
	return isPlaySymbolNotify
end

function cls:playReelNotifyEffect(pCol)  -- 播放特殊的 等待滚轴结果的	
 	self.reelNotifyEffectList = self.reelNotifyEffectList or {}
 	local pos = self:getCellPos(pCol,2)
	local _,s1 = self:addSpineAnimation(self.animateNode, 20, self:getPic("spine/base/sc_lzjl"), pos, "animation",nil,nil,nil,true)
	self.reelNotifyEffectList[pCol] = s1
end

function cls:stopReelNotifyEffect(pCol)
	self.reelNotifyEffectList = self.reelNotifyEffectList or {}
	if self.reelNotifyEffectList[pCol] and (not tolua.isnull(self.reelNotifyEffectList[pCol])) then
		self.reelNotifyEffectList[pCol]:removeFromParent()
	end
	self.reelNotifyEffectList[pCol] = nil
end

--------------------------Start--------------------------
-------------------------Re Spin-------------------------
function cls:showAllItem(showState)
	Theme.showAllItem(self, showState)
end

-- 滚轴滚到底部
function cls:onReelFallBottom( pCol )
	-- 标志位
	self.reelStopMusicTagList[pCol] = true	
	-- 列停音效，提示动画相关
	if not self:checkPlaySymbolNotifyEffect(pCol) then
		self:dealMusic_PlayReelStopMusic(pCol)
	end

	self:onReelFallBottomJiLi(pCol)

	-- 确定下一轴是否进行Notify
	if self:checkSpeedUp(pCol + 1) then
		self:onReelNotifyStopBeg(pCol +1)
	end

end


function cls:onReelFastFallBottom( pCol )
	Theme.onReelFastFallBottom(self, pCol)
	self:onReelFallBottomJiLi(pCol, true)
end

function cls:onReelFallBottomJiLi(pCol, isFastFall)
	if self:checkCanPlayMaskAnim() then
		self:hideBoardMaskNodeByCol(pCol)
		-- self:stopReelNotifyEffect(pCol)
		-- if not isFastFall then
		-- 	local nextCol = pCol + 1
		-- 	local scatterTag = self:checkNeedNotify(nextCol, specialSymbol.scatter)
		-- 	local bonusTag = self:checkNeedNotify(nextCol, specialSymbol.bonus)
		-- 	if scatterTag then
		-- 		self:onReelNotifyStopBeg(nextCol, specialSymbol.scatter, true)
		-- 	elseif bonusTag then
		-- 		self:onReelNotifyStopBeg(nextCol, specialSymbol.bonus, true)
		-- 	end
		-- end
	end
   


end

function cls:onReelStop( col )
	if self.showReSpinBoard then
        if not self.lockedReels then return end 
        if self.lockedReels[col] then return end 
        local item_List = self.ctl.rets.item_list
        local key = item_List[col][1]
        if jackpotBet[key] then
            self.lockedReels[col] = true
			if self.respinStep == ReSpinStep.Playing then 
				self.respinStep = ReSpinStep.Reset
				self.ctl.rets.theme_deal_show = true
			end
			self:addOneHoldLayerCell( col, 1, col, key, notNeedAnim )
			
			local cell = self.spinLayer.spins[col]:getRetCell(1)
			self:updateCellSprite(cell, specialSymbol.kong, col, true, true, true)
		end
	else
		self:checkNeedRespinExpand(col)
	end

	Theme.onReelStop(self, col)
end

local expandTime = 0.6
function cls:checkNeedRespinExpand(col)
	if self.scFallData and self.scFallData[col] and self.expandItemList[col] then 
		if self.firstExpandCol[col] then 
			local animCol = self.firstExpandCol[col]
			while animCol <= baseColCnt*boardTotalCnt do
				self:addSpineAnimation(self.expandNode, 5, self:getPic("spine/respin_expand/res_fz1"), self:getCellPos(animCol, 2), "animation",nil,nil,nil,true,true)	
				animCol = animCol + baseColCnt
			end
		end
		

		self:playMusic(self.audio_list.respin_expending)
		local reelExpandNode = cc.Node:create()
		reelExpandNode:setPosition(self:getCellPos(col, 2))
		self.expandNode:addChild(reelExpandNode, 10)
		
		self:addExpandAnim(col, reelExpandNode)

		local _, s = self:addSpineAnimation(reelExpandNode, 15, self:getPic("spine/respin_expand/resfz_ys"), cc.p(0,0), "animation",nil,nil,nil,true,true)
		reelExpandNode.top = s

		reelExpandNode:runAction(cc.Sequence:create(
			cc.Spawn:create(
				cc.MoveTo:create(expandTime, self:getCellPos(col+baseColCnt, 2)),
				cc.Sequence:create(
					cc.ScaleTo:create(expandTime/2, 1.2),	
					cc.ScaleTo:create(expandTime/2, 1))
			),
			cc.CallFunc:create(function ( ... )
				if bole.isValidNode(reelExpandNode.top) then 
					reelExpandNode.top:removeFromParent()
				end
				self:addSpineAnimation(reelExpandNode, 5, self:getPic("spine/respin_expand/res_fz2"), cc.p(0,0), "animation")
				self:playExpandNotifyAnim(reelExpandNode)
				reelExpandNode:setLocalZOrder(4)
			end)))
	end
end

function cls:addExpandAnim( col, reelExpandNode )
	for row = 1, 3 do 
		local key = self.expandItemList[col][row]
		if key and jackpotBet[key] then 

			local cellNode = cc.Node:create()
			if jackpotBet[key] then
				cellNode.up = cc.Node:create()
				cellNode:addChild(cellNode.up, 20)

				local mul = jackpotBet[key]
				if type(mul) == "string" then
					-- cellNode.up.jp = bole.createSpriteWithFile("#theme192_s_jn"..jackpotType[key]..".png")
					-- cellNode.up:addChild(cellNode.up.jp,15)
					theCellFile = "#theme192_s_j"..jackpotType[key]..".png"
				elseif type(mul) == "number" then
					cellNode.up.label = self:newJackpotLabel(jackpotHigh[key])
					cellNode.up.label:setString(self:getJackpotNum(key))
					cellNode.up:addChild(cellNode.up.label,15)
					theCellFile = self.pics[specialSymbol.bonus]
				end
			end
			local sp = bole.createSpriteWithFile(theCellFile)
			cellNode:addChild(sp, 10)
			cellNode:setPositionY((2-row)*reelCellH)
			cellNode.key = key

			reelExpandNode:addChild(cellNode, 10)
			reelExpandNode.cells = reelExpandNode.cells or {}
			reelExpandNode.cells[row] = cellNode

		end
	end
end

function cls:playExpandNotifyAnim( reelExpandNode )
	if reelExpandNode.cells then 
		for row, cellNode in pairs(reelExpandNode.cells) do 
			if bole.isValidNode(cellNode) and cellNode.key then
				self:playBonusNotifyAnim(cellNode, cellNode.key, "_1")
				-- if cellNode.up and bole.isValidNode(cellNode.up.jp) then 
				-- 	cellNode.up.jp:setVisible(false)
				-- end
			end
		end
	end
end

function cls:addOneHoldLayerCell( col, row, keyPos, key, isReset)
    local row = row or 1
    local keyPos = keyPos or col

    local holdSp = cc.Node:create()
    holdSp:setPosition(self:getCellPos(col, row))
    self.HoldLayer:addChild(holdSp, 100-keyPos)
    self.HoldLayer._added[keyPos] = holdSp


	-- s:runAction(cc.Sequence:create(
 --    cc.DelayTime:create(1),
 --    cc.CallFunc:create(function ( ... )
 --        if bole.isValidNode(s) then 
 --            bole.spChangeAnimation(s, "animation2", true)
 --        end
 --    end)))
	
	local bgS = self:playBonusNotifyAnim(holdSp, key, "_1")
    holdSp.bg = bgS
    if bgS and bgS.animType then 
    	local delay = isReset and 0 or 20/30
	    bgS:runAction(cc.Sequence:create(
	    	cc.DelayTime:create(delay),
	    	cc.CallFunc:create(function ( ... )
	    		bole.spChangeAnimation(bgS, "animation"..bgS.animType.."_2", true)
	    	end)))
	end

    -- local bgFile = "#theme192_s_"..specialSymbol.bonus..".png"
    if jackpotBet[key] then 
        local mul = jackpotBet[key]
        if type(mul) == "string" then
        	-- local bgFile = "#theme192_s_j"..jackpotType[key]..".png"

            -- local up = bole.createSpriteWithFile("#theme192_s_jn"..jackpotType[key]..".png")
            -- holdSp:addChild(up, 20)
        else
			num = self:getJackpotNum(key)
			numLabel = self:newJackpotLabel(jackpotHigh[key])
			holdSp:addChild(numLabel, 20)
			numLabel:setString(num)
			holdSp.string = numLabel
			key = specialSymbol.bonus
		end
		-- local bg = bole.createSpriteWithFile(bgFile)
		-- holdSp.bg = bg
		-- holdSp:addChild(bg, 10)
    end

    holdSp.num = num -- jackpot 是 动态值 所以为0
    holdSp.key = key -- 倍数key 变成 bonuskey
end

-- function cls:playReelTremble()
-- 	self.footerTremble = ScreenShaker.new(self.ctl.footer, showWildTime + singleFlyWildTime, function() self.footerTremble = nil end)
-- 	self.footerTremble:run()
-- 	self.headerTremble = ScreenShaker.new(self.ctl.header, showWildTime + singleFlyWildTime, function() self.headerTremble = nil end)
-- 	self.headerTremble:run()
-- 	self.reelTremble = ScreenShaker.new(self.shakyNode, showWildTime + singleFlyWildTime, function() self.reelTremble = nil end)
-- 	self.reelTremble:run()
-- end
------------------------------------------------------- handler --------------------------------------------------------

function cls:onThemeInfo(ret, callFunc)
    self.themeInfoCallFunc = callFunc

    self:checkHasWinInThemeInfo(ret)
end

function cls:checkHasWinInThemeInfo(ret)
    local hasSpecialWin = false

	if self.winCollectPoints then 
		hasSpecialWin = true
		self.winCollectPoints = false
		self:themeInfoChangeMapData(ret)
	elseif self.isInMapFreeStop then
		hasSpecialWin = true
		self.isInMapFreeStop = false
        self:updateFreeReelsStop(ret)
    end
    -- if hasSpecialWin then 
    --     self:dealMusic_FadeLoopMusic(0.2, 1, 0.3)
    -- end

    if not hasSpecialWin then 
        if self.themeInfoCallFunc then 
            self.themeInfoCallFunc()
            -- self:dealMusic_FadeLoopMusic(0.2, 0.3, 1)
        end
    end
end

function cls:themeInfoChangeMapData( rets )
	local mapInfo = rets.theme_info.map_info

	self.mapLevel 		= mapInfo.map_level
	local _mapPoints 	= mapInfo.map_points
	local curMapPoints  = self.mapPoints

	if _mapPoints > maxMapPoints then
		self.mapPoints = maxMapPoints
	elseif _mapPoints < 0 then
		self.mapPoints = 0
	else
		self.mapPoints = _mapPoints
	end

	if not self.lockFeatureState[unlockInfoConfig.Map] and _mapPoints ~= curMapPoints then
		local isFull = _mapPoints >= maxMapPoints
		self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function ( ... )
				self:showCoinsFlyToUp(rets) -- 显示收集动画
			end),
			cc.DelayTime:create(flyToUpTime),
			cc.CallFunc:create(function ( ... )
      		   self:showProgressAnimation(_mapPoints,curMapPoints,isFull)
      		   self:checkHasWinInThemeInfo(rets)	
			end)))
	else
		self:setCollectProgressImagePos(self.mapPoints)
		self:setNextCollectTargetImage(self.mapLevel)
		self:checkHasWinInThemeInfo(rets)
	end
end

function cls:showCoinsFlyToUp(rets)
	self.bonusFlyNode:removeAllChildren()
	
	if not (rets and rets.item_list) then return end

	self:playMusic(self.audio_list.collect_fly)

	for col, colList in pairs(rets.item_list) do 
		for row, key in pairs(colList) do 
			if jackpotBet[key] then 
				local pos = self:getCellPos(col, row)

				local s = self:playBonusNotifyAnim(self.bonusFlyNode, key, "_4", pos, 20, self:getPic("spine/item/"..specialSymbol.bonus.."/resymbol_sj"))

				local _particle = cc.ParticleSystemQuad:create(self:getPic("particle/bsfeilizi.plist"))
				s:addChild(_particle, -1)
				_particle:setVisible(false)

				s:runAction(cc.Sequence:create(
					cc.DelayTime:create(10/30),
					cc.CallFunc:create(function ( ... )
						_particle:setVisible(true)
					end),
					cc.MoveTo:create(flyToUpTime - 10/30, collectFlyEndPos),
					cc.CallFunc:create(function()
						_particle:setEmissionRate(0) -- 设置发射速度为不发射
					end),
					cc.DelayTime:create(0.5),
					cc.RemoveSelf:create()))
			end
		end
	end
end

function cls:showProgressAnimation(map_points, curMapPoints, isFull)
	if map_points > maxMapPoints then
		map_points = maxMapPoints
	elseif map_points < 0 then
		map_points = 0
	end

	local oldPosX 	= movePerUnit * curMapPoints + progressStartPosX
	local startPos 	= cc.p(oldPosX,progressPosY)
	local newPosX 	= movePerUnit * map_points + progressStartPosX
	local endPos 	= cc.p(newPosX,progressPosY)
    self.collectProgress:setPosition(startPos)
    self.collectProgress:runAction(cc.MoveTo:create(0.5,endPos))
 --    self.collectProgressAni:setPositionX(self.baseProgressAniPosX + oldPosX) 
	-- self.collectProgressAni:runAction(cc.MoveTo:create(0.5,cc.p(self.baseProgressAniPosX + newPosX, self.collectProgressAni:getPositionY())))

	self:addSpineAnimation(self.collectProgress, 100, self:getPic("spine/collect_progress/sjt"), cc.p(0,0), "animation1")
	self:addSpineAnimation(self.collectFeatureNode, 100, self:getPic("spine/collect_progress/sjt_js"), cc.p(-315.5, 321), "animation")

	self:laterCallBack(0.5,function()
		if isFull then
			self:dealMusic_FadeLoopMusic(0.3, 1, 0.3)
			self:fullCollectAnimation()
		end
	end)
end

function cls:fullCollectAnimation( ... )
	self:playMusic(self.audio_list.collect_full)
	self:addSpineAnimation(self.collectFullSpine, nil, self:getPic("spine/collect_progress/sjt"), cc.p(0, 0), "animation2", nil, nil, nil, true, true)
end

function cls:stopCollectPartAnimation()
	self.collectFullSpine:removeAllChildren()
end

local mapProgressSpineConfig = {
	endsp1 = "spine/collect_progress/endsp/yzs_01",
	endsp2 = "spine/collect_progress/endsp/juxi_01",
	endsp3 = "spine/collect_progress/endsp/ying_01",
	endsp4 = "spine/collect_progress/endsp/yegou_01",
	endsp5 = "spine/collect_progress/endsp/xiongtou_01",
	endsp6 = "spine/collect_progress/endsp/daishu_01",
	endsp7 = "spine/collect_progress/endsp/jinbi_01",
}
function cls:setNextCollectTargetImage(level)
    level = level + 1
    if level > maxMapLevel then
        level = 1
    end
    local showIndex = mapLevelConfig[level]

    -- bole.updateSpriteWithFile(self.collectEndSp, "#theme192_c_endsp"..showIndex..".png")

    if not self.collectBuild or self.collectBuild.level ~= showIndex then 
    	local _, s = self:addSpineAnimation(self.collectEndSp, nil, self:getPic(mapProgressSpineConfig["endsp"..showIndex]), cc.p(0, 0), "animation", nil, nil, nil, true, true)
        self.collectBuild = s
        self.collectBuild.level = showIndex
    end
end

function cls:setCollectProgressImagePos(map_points) -- 显示 进度的点数
	if map_points > maxMapPoints then
		map_points = maxMapPoints
	elseif map_points < 0 then
		map_points = 0
	end

	local cur_posX = movePerUnit * map_points + progressStartPosX

	self.collectProgress:setPosition(cc.p(cur_posX, progressPosY))
	-- self.collectProgressAni:setPositionX(self.baseProgressAniPosX + cur_posX)
end

--------------------- map 相关 ------------------------ 
function cls:checkInFeature() -- whj: 作用在 feature 结束重新打开商店,时候控制锁住bet控制
    local inFeature = false
    if self.isOpenStoreNode then 
        inFeature = true
    end
    return inFeature
end

-------------------------------------------------- betFeature 相关 --------------------------------------------------

function cls:getReelCellPos( value ) -- 横向排序
    if value then 
        col = (value-1)%baseColCnt + 1
        row = math.floor((value-1)/baseColCnt) + 1
        return {col, row}
    end
end

-------------------------- 断线重连 ----------------------------
function cls:setFreeGameRecoverState(data)
	if data["free_spins"] and data["free_spins"] >= 0 then -- 断线重连如果是最后一次freespin 的时候就不在进行这个操作
		self.isFreeGameRecoverState = true
	end
end

function cls:setDealFreeCollectState()
    self.ctl.spin_processing = true
    self.ctl.isProcessing  = true
end

function cls:enterThemeByFirstFreeSpin(ret, theFreeSpinData, endCallFunc)
	ret["free_spins"]		= theFreeSpinData.free_spins

	self.ctl.isProcessing  = true
	self.ctl.footer:setSpinButtonState(true) 
	self.ctl.footer:enableOtherBtns(false) 

	if theFreeSpinData.item_list then
		local realItemList = theFreeSpinData.item_list
		for col, colList in pairs(realItemList) do
			for row, itemKey in pairs(colList) do
				local cell = self.spinLayer.spins[col]:getRetCell(row)
				self:updateCellSprite(cell, itemKey, col, true, true)
			end
		end
		self.ctl.freeItem = tool.tableClone(realItemList)
		self.ctl.specials = self:getSpecialTryResume(realItemList)
		self.ctl.freeSpeical = self:getSpecialTryResume(realItemList)
	end
	self.ctl:free_spins(ret)
end

function cls:enterThemeByBonus(theBonusGameData, endCallFunc)
	self.ctl.isProcessing  = true
	self.ctl:open_old_bonus_game(theBonusGameData, endCallFunc)
end

function cls:overBonusByEndGame(data) -- bonus 有end_game 字段 直接把 Bonus 钱加到 footer上面 如果 之后 没有 特殊feature 则直接加钱到header上面
	if data.total_win then 
		self.ctl.totalWin = data.total_win
	end
	if data.jp_win then
		for k,v in pairs(data.jp_win) do 
			if v.jp_win then 
				self.ctl.totalWin = self.ctl.totalWin +  v.jp_win
			end
		end
	end
	self.ctl.isProcessing  = false
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

function cls:saveBonusData(bonusData)
	if self.ctl.rets then
		self.ctl.bonusItem 	= tool.tableClone(self.ctl.rets.item_list)
		self.ctl.bonusRet 	= self.ctl.rets
		self.bonusSpeical = self.ctl.specials
	end	
end

function cls:outBonusStage()
	if self.bonusSpeical then 
		self.ctl.specials = self.bonusSpeical
	end


	if self.ctl.bonusItem then
		self.ctl.rets.item_list = self.ctl.bonusItem
		self.ctl:resetBoardCellsSpriteOverBonus(self.ctl.bonusItem) -- 刷新牌面 + 动画播放
	end
	self.ctl.bonusItem    = nil	
	self.ctl.bonusRet     = nil
end

function cls:saveBonusCheckData( bonusData ) -- 没有断线的情况下进入bonus时候, 判断存在bonus_id校验字段, 直接赋值存储,同时覆盖掉原来的数据(每个主题里面单独控制是否需要清空数据)
	local data = {}
	data["bonus_id"] = bonusData.bonus_id
	LoginControl:getInstance():saveBonus(self.themeid, data)
end

function cls:cleanBonusSaveData( data ) -- 断线的情况下进入bonus时候, 判断bonus_id校验字段本地与服务器不一致, 清除原来的数据(每个主题里面单独控制是否需要清空数据)
	LoginControl:getInstance():saveBonus(self.themeid, nil)
end

------------------------------------------------------------
function cls:dealAboutBetChange(bet,isPointBet)
	if self.isOverInitGame then
        self:checkLockFeature()
    end
end

function cls:setBet(unlockBet)
    local set_Bet = unlockBet
    local maxBet = self.ctl:getMaxBet()
    if maxBet >= set_Bet then
        self.ctl:setCurBet(set_Bet)
    end
end

function cls:onAllReelStop()
	if self.bonus then 
		self.bonus:freshRespinCnt()
	end

	if self.showReSpinBoard and self.ctl.rets then 
		self.ctl.rets.theme_deal_data = true
	end

	self.expandNode:removeAllChildren()

	Theme.onAllReelStop(self)
end

function cls:finshSpin()
    if (not self.ctl.freewin) and (not self.ctl.autoSpin) then
        self.isFeatureClick = false
    end
end

function cls:stopDrawAnimate() -- 可能存在 手动调用的可能
	Theme.stopDrawAnimate(self)

	self.expandNode:removeAllChildren()

	self.scatterAnimNode:removeAllChildren()
	self.jpAnimNode:removeAllChildren()

	self.animNodeList = nil

	self.randomWildNode:removeAllChildren()
    self.randWildSList = nil

    self.moveWildSList = nil
end

function cls:cleanStatus( stillEffect )
	Theme.cleanStatus(self, stillEffect)
end


----------------------------------- 弹窗通用显示效果 -----------------------------
function cls:dialogPlayLineAnim( state, dimmer, root )
    if state == "show" then 
        if bole.isValidNode(dimmer) then
            dimmer:setVisible(true)
            dimmer:setOpacity(0)
            dimmer:runAction(cc.Sequence:create(cc.FadeTo:create(0.2, 200)))
        end
        if bole.isValidNode(root) then
            root:setVisible(true)
            root:setScale(0)
            root:runAction(cc.Sequence:create(cc.ScaleTo:create(0.4, 1.2),cc.ScaleTo:create(0.1, 1)))
        end
    else
        if bole.isValidNode(dimmer) then
            dimmer:setVisible(true)
            dimmer:setOpacity(200)
            dimmer:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.FadeTo:create(0.2, 0)))
        end
        if bole.isValidNode(root) then
            root:setVisible(true)
            root:setScale(1)
            root:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1, 1.2),cc.ScaleTo:create(0.4, 0)))
        end
    end
end


---------------------------------- freeSpin --------------------------------------------
local fs_show_type = {
	start = 1,
	more = 2,
	collect = 3,
}

local freeMultiValue = {
	[FreeGameType.MultiperWild1] = {"5X", "10X"},
	[FreeGameType.MultiperWild2] = {"15X", "50X"},
	[FreeGameType.MultiperWild3] = {"50X", "100X"},
}

local freeSpinDialogConfig = {
    [FreeGameType.Normal] 			= { ["csb"] = "csb/dialog_free_n.csb", ["spine"] = {"spine/dialog/free/freetanchuang", "spine/dialog/free/freetanchuang", "spine/dialog/free/freetanchuang"}, ["animName"] = {"animation1", "animation3", "animation2"}, ["showTime"] = {34/30, 35/30, 35/30}, ["maxW"] = 466 },
    [FreeGameType.MultiperWild1] 	= { ["csb"] = "csb/dialog_free_m1.csb", ["spine"] = {"spine/dialog/m_free/ditukaishi", nil, "spine/dialog/m_free/ditutanchuang"}, ["animName"] = {"animation1", nil, "animation4"}, ["showTime"] = {35/30, nil, 31/30}, ["maxW"] = 530 },
    [FreeGameType.MultiperWild2] 	= { ["csb"] = "csb/dialog_free_m1.csb", ["spine"] = {"spine/dialog/m_free/ditukaishi", nil, "spine/dialog/m_free/ditutanchuang"}, ["animName"] = {"animation1", nil, "animation4"}, ["showTime"] = {35/30, nil, 31/30}, ["maxW"] = 530 },
    [FreeGameType.MultiperWild3] 	= { ["csb"] = "csb/dialog_free_m1.csb", ["spine"] = {"spine/dialog/m_free/ditukaishi", nil, "spine/dialog/m_free/ditutanchuang"}, ["animName"] = {"animation1", nil, "animation4"}, ["showTime"] = {35/30, nil, 31/30}, ["maxW"] = 530 },
    [FreeGameType.RandomWild] 		= { ["csb"] = "csb/dialog_free_m2.csb", ["spine"] = {"spine/dialog/m_free/ditutanchuang",nil, "spine/dialog/m_free/ditutanchuang"}, ["animName"] = {"animation2", nil, "animation4"}, ["showTime"] = {35/30, nil, 31/30}, ["maxW"] = 530 },
    [FreeGameType.MovingWild] 		= { ["csb"] = "csb/dialog_free_m2.csb", ["spine"] = {"spine/dialog/m_free/ditutanchuang",nil, "spine/dialog/m_free/ditutanchuang"}, ["animName"] = {"animation3", nil, "animation4"}, ["showTime"] = {35/30, nil, 31/30}, ["maxW"] = 530 },
    [FreeGameType.StickyWild] 		= { ["csb"] = "csb/dialog_free_m2.csb", ["spine"] = {"spine/dialog/m_free/ditutanchuang",nil, "spine/dialog/m_free/ditutanchuang"}, ["animName"] = {"animation1", nil, "animation4"}, ["showTime"] = {35/30, nil, 31/30}, ["maxW"] = 530 },
}

function cls:playFeatureDialogAnim( showNode, sType, _dConfig )
    local animName =  _dConfig.animName[sType]

    local _ ,s = self:addSpineAnimation(showNode, -1, self:getPic(_dConfig.spine[sType]), cc.p(0,0), animName, nil, nil, nil, true)
        s:runAction(cc.Sequence:create(
            cc.DelayTime:create(_dConfig.showTime[sType] or 1),
            cc.CallFunc:create(function ( ... )
                bole.spChangeAnimation(s, animName.."_1", true)
            end)))
    if sType == fs_show_type.start then -- 出现   第13 - 27帧开始出现按钮 数字在10-23帧恢复到1倍大小
        if bole.isValidNode(showNode.btnStart) then 
        	local endScale = self.fgType == FreeGameType.Normal and 1 or 1.25
        	self:playNodeShowAction(showNode.btnStart, "scale", 15/30, 0.53*endScale, {{5/30, 1.07*endScale}, {7/30, 0.94*endScale}, {8/30, 1*endScale}})
        
            local btnSize = showNode.btnStart:getContentSize()
            self:addSpineAnimation(showNode.btnStart, nil, self:getPic("spine/dialog/start"), cc.p(btnSize.width/2,btnSize.height/2), "animation", nil, nil, nil, true,true)-- 播放 结果动画
        end
        if bole.isValidNode(showNode.labelCount) and bole.isValidNode(showNode.labelCount:getParent()) then 
        	self:playNodeShowAction(showNode.labelCount:getParent(), "scale", 9/30, 0.53, {{5/30, 1.07}, {7/30, 0.94}, {8/30, 1}})
        end
        if self:isMultiGame() then 
        	local mulitValue = freeMultiValue[self.fgType]
        	local label1 = showNode:getChildByName("label1")
        	label1:setString(mulitValue[1])
        	self:playNodeShowAction(label1, "fade", 15/30, 0, {{5/30, 255}})
        	
        	local label2 = showNode:getChildByName("label2")
        	label2:setString(mulitValue[2])
        	self:playNodeShowAction(label2, "fade", 15/30, 0, {{5/30, 255}})
        end
    elseif sType == fs_show_type.more then -- 出现   第13 - 27帧开始出现按钮 数字在7-34帧恢复到1倍大小 0.62(7)-1.02(14) - 0.9(23)- 1(34) 
		if bole.isValidNode(showNode.labelCount) and bole.isValidNode(showNode.labelCount:getParent()) then 
			self:playNodeShowAction(showNode.labelCount:getParent(), "scale", 9/30, 0.53, {{5/30, 1.07}, {7/30, 0.94}, {8/30, 1}})
		end
    elseif sType == fs_show_type.collect then -- 出现   第13 - 27帧开始出现按钮 数字在7-34帧恢复到1倍大小 0.62(7)-1.02(14) - 0.9(23)- 1(34)       
        if bole.isValidNode(showNode.btnCollect) then 
        	local endScale = self.fgType == FreeGameType.Normal and 1 or 1.25
        	self:playNodeShowAction(showNode.btnCollect, "scale", 15/30, 0.53*endScale, {{5/30, 1.07*endScale}, {7/30, 0.94*endScale}, {8/30, 1*endScale}})

            local btnSize = showNode.btnCollect:getContentSize()
            self:addSpineAnimation(showNode.btnCollect, nil, self:getPic("spine/dialog/start"), cc.p(btnSize.width/2,btnSize.height/2), "animation", nil, nil, nil, true,true)-- 播放 结果动画
        end
        if bole.isValidNode(showNode:getChildByName("label_node")) then 
        	self:playNodeShowAction(showNode:getChildByName("label_node"), "scale", 9/30, 0.53, {{5/30, 1.07}, {7/30, 0.94}, {8/30, 1}})
        end
    end
end

function cls:playNodeShowAction(node, atype, delay, startState, actionData)
	local acList = {}
	local d1 = cc.DelayTime:create(delay)
	table.insert(acList, d1)
	local d2 = cc.Show:create()
	table.insert(acList, d2)

	if atype == "scale" then 
		node:setScale(startState or 0)
		node:setVisible(false)

		for _, temp in pairs(actionData) do
			local a1 = temp[3] and cc.ScaleTo:create(temp[1], temp[2], temp[3]) or cc.ScaleTo:create(temp[1], temp[2])
			table.insert(acList, a1)
		end

	elseif atype == "fade" then 
		node:setOpacity(startState or 0)
		node:setVisible(false)

		for _, temp in pairs(actionData) do
			local a1 = cc.FadeTo:create(temp[1], temp[2])
			table.insert(acList, a1)
		end
	end

	local a = cc.Sequence:create(bole.unpack(acList))
	libUI.runAction(node, a)

end

local freeCntMaxWidth = 180
function cls:showFreeSpinDialog(theData, sType)
    local _dConfig = freeSpinDialogConfig[self.fgType]

	local config = {}
	config["gen_path"] = self:getPic("csb/")
	config["csb_file"] = self:getPic(_dConfig.csb)
	config["frame_config"] = {
		-- start: 第二个参数 注册点击事件的方法; 第四个参数 .theme:onCollectFreeClick 回调(可以 理解为 点击事件立马就会被调用了,跟第四个参数没有关系); 第六个参数 回调endEvent方法(一般在 endEvent里面场景切换回调) 最后一个参数 是 延迟删除的时间
		["start"] 		 = {nil, 1, nil, 0, dialogShowOrHideTime, 0, 0.5},
		["more"] 		 = {nil, 65/30, nil,0.3,0,0,0.5},
		["collect"] 	 = {nil, 1, nil, 0, transitionDelay.free.onCover + dialogShowOrHideTime, (transitionDelay.free.onEnd - transitionDelay.free.onCover), 0},-- 最后一个参数 是延时删除的时间 -- 倒数第二个参数 回调 完成方法
	}
	if self.fgType ~= FreeGameType.Normal then
		config["frame_config"]["start"] 		 = {nil, 1, nil, 0, transitionDelay.free.onCover + dialogShowOrHideTime, (transitionDelay.free.onEnd - transitionDelay.free.onCover-dialogShowOrHideTime), 0.5}
	end
	self.freeSpinConfig = config 

	local theDialog = G_FREE_SPIN_DIALOGS["base"].new(self.ctl, self.freeSpinConfig)
	if sType == fs_show_type.start then
		bole.setSpeicalLabelScale(theDialog.startRoot.labelCount, theData.count, freeCntMaxWidth)
		
		theDialog:showStart(theData)
		self:playFeatureDialogAnim( theDialog.startRoot, sType, _dConfig )

	elseif sType == fs_show_type.more then
		bole.setSpeicalLabelScale(theDialog.moreRoot.labelCount, theData.count, freeCntMaxWidth)

		theDialog:showMore(theData)
		self:playFeatureDialogAnim( theDialog.moreRoot, sType, _dConfig )

	elseif sType == fs_show_type.collect then
		theDialog:setCollectScaleByValue(theData.coins, _dConfig.maxW)
		theDialog:showCollect(theData)
		self:playFeatureDialogAnim( theDialog.collectRoot, sType, _dConfig)
	end
	self.freeDialogNode = theDialog
end

function cls:setLabelScale( )
	-- body
end

function cls:playStartFreeSpinDialog( theData )

 
	-- self.isInFreeGame = true

	-- local enter_event = theData.enter_event
	-- theData.enter_event = function()
	-- 	self:dialogPlayLineAnim("show", self.featureDialogDimmer)
		
	-- 	if enter_event then 
	-- 		enter_event()
	-- 	end
	-- end

	-- local endEvent = theData.end_event
	-- theData.end_event = function ( ... )
	-- 	self:dealMusic_PlayFreeSpinLoopMusic()
	-- 	if endEvent then 
	-- 		endEvent()
	-- 	end
	-- end

	-- if self.fgType == FreeGameType.Normal then 
	-- 	local click_event = theData.click_event
	-- 	theData.click_event = function()
	-- 		if click_event then
	-- 			click_event()
	-- 		end
			
	-- 		if self.freeDialogNode and bole.isValidNode(self.freeDialogNode.root) then 
	--             self:dialogPlayLineAnim( "hide", self.featureDialogDimmer, self.freeDialogNode.root ) 
	--         end
	-- 		if self.freeDialogNode and self.freeDialogNode.startRoot and bole.isValidNode(self.freeDialogNode.startRoot.btnStart) then 
	-- 			self.freeDialogNode.startRoot.btnStart:removeAllChildren() -- 删除循环扫光特效
	-- 		end
	--         self.freeDialogNode = nil

	-- 		self.ctl.footer:enableOtherBtns(false)
	-- 	end
	-- 	self:showFreeSpinDialog(theData, fs_show_type.start)

	-- 	local endEvent = theData.end_event
	-- 	theData.end_event = function ( ... )
	-- 		self:runAction(cc.Sequence:create(
	-- 			cc.CallFunc:create(function ( ... )
	-- 				if endEvent then 
	-- 					endEvent()
	-- 				end
	-- 				self:dealMusic_PlayFreeSpinLoopMusic()
	-- 			end),
	-- 			cc.DelayTime:create(0.5),
	-- 		   	cc.CallFunc:create(function()
	-- 				self.firstFreeGameTrigger = true
	-- 				self:smashDiamondsIntoReel()
	-- 		   	end)))
	-- 	end
	-- else
	-- 	self:runAction(cc.Sequence:create(
	-- 		cc.DelayTime:create(1),
	-- 		cc.CallFunc:create(function()
	-- 		    local data = {}
	-- 		    data["mapLevel"] = self.mapLevel
	-- 		    local theDialog = WildAustraliaMapGame.new(self, self:getPic("csb/"), data)
	-- 		    theDialog:showMapScene(true)

	-- 		    self:stopCollectPartAnimation()
	-- 		end),
	-- 		cc.DelayTime:create(4),
	-- 		cc.CallFunc:create(function()
	-- 		    -- self:showFreeSpinDialog(theData, fs_show_type.start)
	-- 		end)
	-- 	))

	-- 	local click_event = theData.click_event
	-- 	theData.click_event = function()
	-- 		if click_event then
	-- 			click_event()
	-- 		end
			
	-- 		if self.freeDialogNode and bole.isValidNode(self.freeDialogNode.root) then 
	--             self:dialogPlayLineAnim( "hide", self.featureDialogDimmer, self.freeDialogNode.root ) 
	--         end
	-- 		if self.freeDialogNode and self.freeDialogNode.startRoot and bole.isValidNode(self.freeDialogNode.startRoot.btnStart) then 
	-- 			self.freeDialogNode.startRoot.btnStart:removeAllChildren() -- 删除循环扫光特效
	-- 		end
	--         self.freeDialogNode = nil

	-- 		self.ctl.footer:enableOtherBtns(false)

	-- 		self:runAction(cc.Sequence:create(
	-- 			cc.DelayTime:create(dialogShowOrHideTime),
	-- 			cc.CallFunc:create(function ( ... )
	-- 			    self:playTransition(nil, "free")-- 转场动画
	-- 			end)))
	-- 	end

	--     local changeLayer_event = theData.changeLayer_event
	-- 	theData.changeLayer_event = function()
	-- 		if changeLayer_event then
	-- 			changeLayer_event()
	-- 		end
	-- 		self:changeSpinBoard(SpinBoardType.FreeSpin)
	-- 	end

	-- 	local endEvent = theData.end_event
	-- 	theData.end_event = function ( ... )
	-- 		self:dealMusic_PlayFreeSpinLoopMusic()
	-- 		if endEvent then 
	-- 			endEvent() 
	-- 		end
	-- 		self:showActivitysNode()
	-- 	end
	-- end
end

function cls:playMoreFreeSpinDialog( theData )
	local enter_event = theData.enter_event
	theData.enter_event = function()
		self:dialogPlayLineAnim("show", self.featureDialogDimmer)
		
		if enter_event then 
			enter_event()
		end
	end

	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end
		
		if self.freeDialogNode and bole.isValidNode(self.freeDialogNode.root) then 
            self:dialogPlayLineAnim( "hide", self.featureDialogDimmer, self.freeDialogNode.root ) 
        end
		if self.freeDialogNode and self.freeDialogNode.startRoot and bole.isValidNode(self.freeDialogNode.startRoot.btnStart) then 
			self.freeDialogNode.startRoot.btnStart:removeAllChildren() -- 删除循环扫光特效
		end
        self.freeDialogNode = nil
	end

	self:showFreeSpinDialog(theData, fs_show_type.more)
end

function cls:playCollectFreeSpinDialog( theData )
    local enter_event = theData.enter_event
    theData.enter_event = function()
        self:stopAllLoopMusic()
        self:dialogPlayLineAnim("show", self.featureDialogDimmer)

        if enter_event then
            enter_event()
        end
    end

	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end

		if self.freeDialogNode and bole.isValidNode(self.freeDialogNode.root) then 
            self:dialogPlayLineAnim( "hide", self.featureDialogDimmer, self.freeDialogNode.root )
        end
		if self.freeDialogNode and self.freeDialogNode.collectRoot and bole.isValidNode(self.freeDialogNode.collectRoot.btnCollect) then 
			self.freeDialogNode.startRoot.btnStart:removeAllChildren() -- 删除循环扫光特效
		end
        self.freeDialogNode = nil

		self:runAction(cc.Sequence:create(
		cc.DelayTime:create(dialogShowOrHideTime),
		cc.CallFunc:create(function ( ... )
			self:playTransition(nil,"free")-- 转场动画
		end)))
	end
	self:showFreeSpinDialog(theData, fs_show_type.collect)
end

function cls:resetPointBet() -- 仅仅在断线的时候 被调用了
    if self.superAvgBet then 
        self.ctl:setPointBet(self.superAvgBet)-- 更改 锁定的bet
        self.ctl.footer:changeFreeSpinLayout3()-- 隐藏掉  footer bet 
    end
end

---------------------- free 额外添加 symbol 相关 ----------------------
function cls:smashDiamondsIntoReel()
	self:dealMusic_FadeLoopMusic(0.2, 1, 0.3)

	local file = self:getPic("spine/free_add/respin_symbol_tj_01")

	-- for _, node in pairs(self.boardDimmerList) do 
	-- 	self:dialogPlayLineAnim("show", node)
	-- end
	local startOpacity = 200
	for boardId = 1, boardTotalCnt do 
		local pos = cc.p(0, reelAddY[boardId]+reelBaseY) -- self:getCellPos(baseColCnt*(boardId-1) + 3, 2)
		local _, s = self:addSpineAnimation(self.down_child, nil, file, pos, "animation", nil, nil, nil, true)
		s:setVisible(false)
		s:runAction(cc.Sequence:create(
			cc.DelayTime:create((boardId-1)*extraReelAnimTimeInFree),
			cc.CallFunc:create(function ( ... )
				s:setVisible(true)
				bole.spChangeAnimation(s, "animation", false)
				self:playMusic(self.audio_list.respin_adding)
			end),
			cc.DelayTime:create(extraReelAnimTimeInFree),
			cc.CallFunc:create(function ( ... )
				-- for _, node in pairs(self.boardDimmerList) do 
				-- 	node:setOpacity(((boardTotalCnt - boardId)/boardTotalCnt) *startOpacity)
				-- end
			end),
			cc.RemoveSelf:create()))
	end
	local _, s = self:addSpineAnimation(self.down_child, nil, self:getPic("spine/dialog/dialog_add/xiaotiaotanchuang"), cc.p(0, reelAddY[2]+reelBaseY), "animation2")

	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(extraReelAnimTimeInFree*boardTotalCnt),
		cc.CallFunc:create(function ( ... )
			self.firstFreeGameTrigger = nil
		end)
	))
end

---------------------- symbol 动画相关 ----------------------
function cls:playBonusItemAnimate(itemList, winRespinData, isWin)
	if not winRespinData then return end

	local itemList = itemList or (self.ctl.rets.item_list or {})

	for id, dataList in pairs(winRespinData) do
		if bole.getTableCount(dataList) > 0 then 
			-- if isWin then 
			-- 	self.respinDimmerList[id]:setVisible(false)
			-- end
			for col = (id-1)*baseColCnt + 1, id*baseColCnt do
				local list  = itemList[col]
				if list then 
					for row, key in pairs(list) do
						if jackpotBet[key] then
							-- todo 添加中奖动画
							local bAnimNode = cc.Node:create()
							bAnimNode:setPosition(self:getCellPos(col, row))
							self.animateNode:addChild(bAnimNode)
							local mul = jackpotBet[key]
							local label
							if type(mul) == "string" then
							elseif type(mul) == "number" then
								label = self:newJackpotLabel(jackpotHigh[key])
								label:setString(self:getJackpotNum(key))
								bAnimNode:addChild(label, 20)
							end
							local s = self:playBonusNotifyAnim(bAnimNode, key)
						end
					end
				end
			end
		else
			-- if isWin then 
			-- 	self.respinDimmerList[id]:setVisible(true)
			-- end
		end
	end
end

function cls:playBonusAnimate(theGameData) -- 播放 bonus symbol 动画  同时 播放 开始弹窗
    local delay = 2
    self.ctl.footer:setSpinButtonState(true)
    self:stopAllLoopMusic()

    if theGameData and theGameData.bonus_type and theGameData.bonus_type == BonusGameType.Respin and theGameData.win_respin then 
    	self:stopDrawAnimate()
		self:playMusic(self.audio_list.trigger_bell)

		self:playBonusItemAnimate(theGameData.win_item_list, theGameData.win_respin, true)
    end

    return delay 
end


function cls:playBackBaseGameSpecialAnimation( theSpecials ,enterType)
	self:playFreeSpinItemAnimation(theSpecials ,enterType)
end

local showFreeTipDialogTotalTime = 2
local winFreeMusicTime = 1
local scatterAnimTime = 2
function cls:playFreeSpinItemAnimation( theSpecials ,enterType)
	local delay = 2
	if not theSpecials or not theSpecials[specialSymbol["scatter"]] then return end
	if self.fgType ~= 1 then return end

	if enterType then
		self.ctl.footer:setSpinButtonState(true)
		self.ctl.footer:enableOtherBtns(false)
		self.isInFreeGame = true
		local _transitionD = transitionDelay["free"]

		self:playMusic(self.audio_list.trigger_bell)
		delay = scatterAnimTime 

		for col, rowTagList in pairs(theSpecials[specialSymbol["scatter"]]) do -- 播放中奖动画
			for row, tagValue in pairs(rowTagList) do
				self:addItemSpine(specialSymbol["scatter"], col, row)
			end
		end
		if enterType == "free_spin" then 
			delay = delay + showFreeTipDialogTotalTime + _transitionD.onEnd

			self:runAction(cc.Sequence:create(
				cc.DelayTime:create(scatterAnimTime),
				cc.CallFunc:create(function ( ... )
					self:playWinFreeTipDialog()-- 展示提示弹窗
				end),
				cc.DelayTime:create(showFreeTipDialogTotalTime),
				cc.CallFunc:create(function ( ... )
					self:playTransition(nil,"free") -- 播放切屏动画
				end),
				cc.DelayTime:create(_transitionD.onCover),
				cc.CallFunc:create(function ( ... )
					self:changeSpinBoard(SpinBoardType.FreeSpin)
				end)))
		end
	else
		for col, rowTagList in pairs(theSpecials[specialSymbol["scatter"]]) do
			for row, tagValue in pairs(rowTagList) do
				self:addItemSpine(specialSymbol["scatter"], col, row, true)
			end
		end
	end

	return delay
end

function cls:playWinFreeTipDialog()
	if self.curWinFreeCountList then 
		self:playMusic(self.audio_list.normal_popup)

		for id, cnt in pairs(self.curWinFreeCountList) do 
			if cnt > 0 then 
				local csbPath = self:getPic("csb/dialog_wfree_tip.csb")
				local dialog 		= cc.CSLoader:createNode(csbPath)
				local showNode 		= dialog:getChildByName("root")
				local winCntLabel	= showNode:getChildByName("win_cnt")
				winCntLabel:setString(cnt)

				self.down_child:addChild(dialog)
				dialog:setPositionY(reelBaseY + reelAddY[id])
		
				dialog:runAction(cc.Sequence:create(
					cc.CallFunc:create(function ( ... )
						self:playMusic(self.audio_list.popup_out)
						self:dialogPlayLineAnim("show", self.boardDimmerList[id], showNode)
					end),
					cc.DelayTime:create(1.5), 
					cc.CallFunc:create(function ( ... )
						self:dialogPlayLineAnim("hide", self.boardDimmerList[id], showNode)
						self:playMusic(self.audio_list.popup_out)
					end),
					cc.DelayTime:create(0.5), 
					cc.RemoveSelf:create()))
			end
		end
	end
end

function cls:addItemSpine(item, col, row, animName, isLoop)
	local layer			= self.scatterAnimNode
	local animName		= animName or "animation"
	local pos			= self:getCellPos(col, row)
	local spineFile		= self:getPic("spine/item/"..item.."/spine")

	if isLoop then 
		local cell = self.spinLayer.spins[col]:getRetCell(row)
		cell:setVisible(false)
	end
	local _, s1 = self:addSpineAnimation(layer, 100, spineFile, pos, animName, nil, nil, nil, isLoop, isLoop)
end

function cls:playSAllAnimation(item ,col)

	local fs = 60
	local objOp = 0
	local animate = cc.Sequence:create(		
		cc.DelayTime:create(2/fs),
		cc.ScaleTo:create(26/fs,1.085),
		cc.DelayTime:create(2/fs),		
		cc.ScaleTo:create(26/fs,1),
		cc.DelayTime:create(2/fs))
	return cc.Sequence:create(animate, animate:clone())
end

function cls:getItemAnimate(item, col, row, effectStatus,parent) -- 重新给 parent  节点 不在使用draw
	local spineItemsSet = Set({specialSymbol.wild, 1, 3, 4, 5, 6, 7, 8, 9, 10})

    if self.moveWildSList and self.moveWildSList[col] and bole.isValidNode(self.moveWildSList[col][row]) then 
        local item = self.moveWildSList[col][row]
        bole.spChangeAnimation(item,"animation",false)
    elseif self.showFreeSpinBoard and self:isMultiGame() and col % baseColCnt == 3 then
		local boardIndex = math.floor((col - 1) / 5) + 1
		self:playBigWildSpine(2, boardIndex)
	elseif self.randWildSList and self.randWildSList[col] and bole.isValidNode(self.randWildSList[col][row]) then 
		local item = self.randWildSList[col][row]
		item:stopAllActions()
		bole.spChangeAnimation(item,"animation",false)
	elseif spineItemsSet[item] then 
		if effectStatus == "all_first" then
			self:playItemAnimation(item, col, row, parent)
		else
			self:playOldAnimation(col,row)
		end
		return nil
	else
		return self:playSAllAnimation(item ,col)
	end
end

function cls:playItemAnimation(item, col, row, parent) -- 修改这个方法，让有动画的symbol 在animationNode上面播放动画
	local animateName = "animation"
	local fileName = item

	------------------------------------------------------------------
	local cell = self.spinLayer.spins[col]:getRetCell(row)
	local pos		= self:getCellPos(col,row)
	local spineFile = self:getPic("spine/item/" .. fileName .. "/spine")
	local _, s1	= self:addSpineAnimation(parent, row, spineFile, pos, animateName, nil, nil, nil, true)

	self.animNodeList = self.animNodeList or {}
	 
	self.animNodeList[col.."_"..row] = {}
	self.animNodeList[col.."_"..row][1] = s1 
	self.animNodeList[col.."_"..row][2] = animateName
	cell:setVisible(false)
end

function cls:playOldAnimation(col,row)
	self.animNodeList = self.animNodeList or {}
	if self.animNodeList[col.."_"..row] then 
		node = self.animNodeList[col.."_"..row][1]
		animationName = self.animNodeList[col.."_"..row][2]

		if bole.isValidNode(node) and animationName then 
			bole.spChangeAnimation(node,animationName,false)
		end
	end
end

function cls:drawWaysThemeAnimate( lines, layer, rets, specials)
	local timeList = {2,2}
	Theme.drawWaysThemeAnimate(self, lines, layer, rets, specials,timeList)
end

function cls:playSymbolNotifyEffect( pCol, reelSymbolState ) 
	for  key , list in pairs(self.notifyState[pCol]) do
		if key == specialSymbol.bonus and self.hasExpandAnimList and self.hasExpandAnimList[pCol] and not self.fastStopMusicTag then 
			break
		end
		for _, crPos in pairs(list) do
			local cell = nil
			if self.fastStopMusicTag then 
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2])
			else
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2]+1)
			end
			if cell then 
				local tipAnim
				if key == specialSymbol.bonus then 
					tipAnim = self:playBonusNotifyAnim(cell, crPos[3], "_1")
				else
					local animateName = "animation1"
					local fileName = key

					local spineFile		= self:getPic("spine/item/"..fileName.."/spine")
					local _,s = self:addSpineAnimation(cell, 10, spineFile, cc.p(0,0), animateName,nil,nil,nil,true)
					tipAnim = s
				end
				cell.sprite:setVisible(false)
				cell.symbolTipAnim = tipAnim
			end	
		end
	end
end

function cls:playBonusNotifyAnim( node, key, _addName, pos, zOrder, spineFile )
	local animType = jackpotType[key] or 4
	local animNameAdd = _addName or ""
	local animateName = "animation".. animType .. animNameAdd
	local pos = pos or cc.p(0,0)
	local zOrder = zOrder or 10

	local spineFile		= spineFile or self:getPic("spine/item/"..specialSymbol.bonus.."/spine")
	local _, s = self:addSpineAnimation(node, zOrder, spineFile, pos, animateName,nil,nil,nil,true)
	s.animType = animType

	return s
end
				

function cls:dealMusic_PlaySpecialSymbolStopMusic( pCol )
	self.notifyState = self.notifyState or {}
	if (not self.notifyState[pCol]) or bole.getTableCount(self.notifyState[pCol]) == 0 then 
		return false
	end
	local ColNotifyState = self.notifyState[pCol]
	local haveSymbolLevel = 3
 	if ColNotifyState[specialSymbol.scatter] then -- scatter
		if haveSymbolLevel >1 then
			haveSymbolLevel = 1
		end
		self:playSymbolNotifyEffect(pCol) -- 播放特殊symbol 下落特效
	elseif ColNotifyState[specialSymbol.bonus] then -- bonus 落地
		if haveSymbolLevel >2 then
			haveSymbolLevel = 2
		end
		self:playSymbolNotifyEffect(pCol) -- 播放特殊symbol 下落特效
	end	

	if haveSymbolLevel < 3 then 
		self:playMusic(self.audio_list["special_stop" .. haveSymbolLevel])
		self.notifyState[pCol] = {}
		return true
	end
end


---------------------------------- 声音相关 ---------------------------------------------

function cls:configAudioList( )
	Theme.configAudioList(self)

	self.audio_list = self.audio_list or {}

	-- base
	self.audio_list.special_stop1 		= "audio/base/symbol_scatter.mp3"	-- scatter落地音
	self.audio_list.special_stop2 		= "audio/base/symbol_respin.mp3"	-- bonus落地音
	self.audio_list.respin_expending 	= "audio/base/respin_expending.mp3"	-- respin symbol的整列延拓复制到下一棋盘音效
	self.audio_list.collect_unlock 		= "audio/base/unlock.mp3"			-- 收集条解锁
	self.audio_list.collect_lock 		= "audio/base/lock.mp3"				-- 收集条上锁
	self.audio_list.collect_full 		= "audio/base/meter_full.mp3"		-- 集满收集条
	self.audio_list.collect_fly 		= "audio/base/symbol_fly.mp3"		-- respin symbol向收集条飞+收集条接收音
	self.audio_list.jp_lock 			= "audio/base/jp_lock.mp3"			-- jp上锁音
	self.audio_list.jp_unlock 			= "audio/base/jp_unlock.mp3"		-- jp解锁音
	self.audio_list.map_open 			= "audio/base/map_open.mp3"			-- 地图打开
	self.audio_list.map_close 			= "audio/base/map_close.mp3"		-- 地图关闭
	self.audio_list.common_click 		= "audio/base/click.mp3"			-- 通用点击
	self.audio_list.rain 				= "audio/base/rain.mp3"				-- 下雨音效

	-- free
	self.audio_list.respin_adding	 		= "audio/free/respin_adding.mp3" -- respin symbol在free期间添加动画音效
	self.audio_list.retrigger_bell	 		= "audio/base/bell.mp3"
	self.audio_list.win_free_cnt_d_show 	= "audio/base/normal_popup.mp3" -- 10 free game文字提示小弹板弹出音效
	self.audio_list.free_dialog_more_show 	= "audio/free/free_dialog_start_show.mp3"

	-- bonus
	self.audio_list.respin_anticipation = "audio/bonus/respin_anticipation.mp3"	-- respin最后一个框激励音效
	self.audio_list.spins_remaining 	= "audio/bonus/spins_remaining.mp3"		-- spins remaining提示文字出现
	self.audio_list.respin_full 		= "audio/bonus/respin_full.mp3"			-- 棋盘集满出GRAND炸粒子音效
	self.audio_list.chance_reset 		= "audio/bonus/chance_reset.mp3"		-- spin次数重置回3次
	self.audio_list.respin_collect 		= "audio/bonus/respin_collect.mp3"		-- respin symbol飞入结算框+结算框接收
	self.audio_list.game_active 		= "audio/bonus/game_active.mp3"			-- respin被激活棋盘外框特效出现音效
	self.audio_list.collect_change 		= "audio/bonus/collect_change.mp3"		-- 棋盘上方结算弹窗弹出
	self.audio_list.collect_move 		= "audio/bonus/collect_move.mp3"		-- 结算弹窗移动到已结算棋盘中央音效

	-- map
	self.audio_list.map_popup 		= "audio/map/map_popup.mp3" 		-- 地图触发弹窗
	self.audio_list.map_popclose 	= "audio/map/map_popclose.mp3" 	-- 地图结算弹窗
	self.audio_list.wild_move 		= "audio/map/wild_move.mp3" 		-- 单个袋鼠WILD移动（moving wild）
	self.audio_list.wild_appear 	= "audio/map/wild_appear.mp3" 	-- 单个WILD在棋盘上出现（random wild）
	self.audio_list.reel_hide 		= "audio/map/reel_hide.mp3" 		-- 整列树叶遮罩挡住
	self.audio_list.reel_appear 	= "audio/map/reel_appear.mp3" 	-- 整列树叶遮罩打开出现整列WILD
	self.audio_list.kangroo_appear 	= "audio/map/kangroo_appear.mp3" 	-- 袋鼠出现+消失
	self.audio_list.map_node 		= "audio/map/map_node.mp3" 		-- 地图移动到达一个动物大节点
	self.audio_list.map_move 		= "audio/map/map_move.mp3" 		-- 地图点亮一个金币小节点

	--slot
	self.audio_list.slot_popup = "audio/slot_machine/slot_popup.mp3"
	self.audio_list.slot_spin = "audio/slot_machine/slot_spin.mp3"
	self.audio_list.slot_win = "audio/slot_machine/slot_win.mp3"
end

function cls:getLoadMusicList()
	local loadMuscList = {
		self.audio_list.special_stop1,
		self.audio_list.special_stop2,
		self.audio_list.popup_out,
		self.audio_list.lightning1,
		self.audio_list.lightning2,
		-- self.audio_list.jp,
		self.audio_list.expand,
		self.audio_list.change_wild,
		self.audio_list.collect_unlock,
		self.audio_list.collect_lock,
		self.audio_list.collect_full,
		self.audio_list.collect_fly,
		self.audio_list.common_click,

		self.audio_list.retrigger_bell,
		self.audio_list.free_dialog_collect_click,
		self.audio_list.free_dialog_start_close,

		self.audio_list.mul,
		self.audio_list.grail_out,
		self.audio_list.grail_open,
		self.audio_list.grail_fly,
		self.audio_list.bonus_click,
		self.audio_list.choose,
		self.audio_list.change3,
		self.audio_list.change2,
		self.audio_list.change1,
		self.audio_list.bonus_end,
		self.audio_list.num_change,
	}
	return loadMuscList
end

function cls:dealMusic_PlayFSEnterMusic( ) -- 进入freespin 弹窗显示的音效
	if self.fgType == FreeGameType.Normal then 
		self:playMusic(self.audio_list.free_dialog_start_show)
	else
		self:playMusic(self.audio_list.map_popup)
	end
end

-- retrigger
function cls:dealMusic_PlayFSMoreMusic( )
	self:playMusic(self.audio_list.free_dialog_more_show)
end

function cls:dealMusic_PlayFSCollectMusic( )
	if self.fgType == FreeGameType.Normal then 
		self:playMusic(self.audio_list.free_dialog_collect_show)
	else
		self:playMusic(self.audio_list.map_popclose)
	end
end

-- 播放bonus game的背景音乐
function cls:dealMusic_EnterBonusGame()
	-- 播放背景音乐
	AudioControl:stopGroupAudio("music")
	self:playLoopMusic(self.audio_list.bonus_background)
	AudioControl:volumeGroupAudio(1)
end

--------------------------------------
function cls:hideActivitysNode()
    if self.ctl.footer then
        self.ctl.footer:hideActivitysNode()
    end
end
function cls:showActivitysNode()
    if self.ctl.footer then
        self.ctl.footer:showActivitysNode()
    end
end

---@param enable /true:可点击/false:不可点击
function cls:setFooterBtnsEnable(enable)
    self.ctl.footer:setSpinButtonState(not enable) -- 禁用spin 按钮
    self.ctl.footer:enableOtherBtns(enable) -- 禁用spin 按钮

end

-----------------------------Transition弹窗相关------------------------------
function cls:playTransition(endCallBack,tType)
	local function delayAction()
		local transition = WildAustraliaTransition.new(self,endCallBack)
		transition:play(tType)
	end	
	delayAction()
end

WildAustraliaTransition = class("WildAustraliaTransition", CCSNode)
local GameTransition = WildAustraliaTransition

function GameTransition:ctor(theme, endCallBack)
	self.spine = nil
	self.theme = theme
	self.endFunc = endCallBack
end

function GameTransition:play(tType)
	local spineFile = self.theme:getPic("spine/transition_free/qieping_01") -- 默认显示 Free transition
	local pos = cc.p(0,0)
	local delay1 = transitionDelay[tType]["onEnd"] -- 切屏结束 的时间
	local animName = "animation"
	local audioFile = self.theme.audio_list.transition_free
	
	if tType == "bonus" then 
		spineFile = self.theme:getPic("spine/transition_respin/respine_qp_01") -- 默认显示 Free transition
		animName = "animation"
		audioFile = self.theme.audio_list.transition_bonus
	end

	-- if tType == "bonus" then
		self.theme.curScene:addToContentFooter(self)
	-- else
	-- 	self.theme.down_child:addChild(self)
	-- end
	
	bole.adaptTransition(self,true,true)
    self:setVisible(false) 
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function()
    	self.theme:playMusic(audioFile)-- 播放转场声音
    	self:setVisible(true)
    	self.theme:addSpineAnimation(self, nil, spineFile, pos, animName)
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

function cls:onExit( )
	if self.reelTremble then
		self.reelTremble:stop()
	end
	if self.footerTremble then
		self.footerTremble:stop()
	end
	if self.headerTremble then
		self.headerTremble:stop()
	end

	if self.shaker then
		self.shaker:stop()
	end
	Theme.onExit(self)
end

--------------------------------- take it or leave it && Bonus ---------------------------------

WildAustraliaBonus = class("WildAustraliaBonus")
local bonusGame = WildAustraliaBonus

function bonusGame:ctor(bonusControl, theme, csbPath, data, callback)
	self.bonusControl 	= bonusControl
	self.theme 			= theme
	self.csbPath 		= csbPath
	self.callback 	    = callback
	self.oldCallBack 	= callback
	self.data           = data
	self.theme.bonus 	= self 
	self.ctl 			= bonusControl.themeCtl

	self.data["bonus_id"] = data.core_data.bonus_id
	self:saveBonus()
end

function bonusGame:addData(key,value)
	self.data[key] = value
	self:saveBonus()
end
function bonusGame:saveBonus()
	LoginControl:getInstance():saveBonus(self.theme.themeid, self.data)
end

function bonusGame:enterBonusGame( tryResume )
	self.theme.isInBonusGame = true

	self.theme:hideActivitysNode()

	self.bonusType 		= self.data.core_data.bonus_type -- type1对应repsin ,type2对应 deal game type3对应 level
	self.theme:stopDrawAnimate()
	self.theme.ctl.footer:setSpinButtonState(true)-- 禁掉spin按钮
	
	self.theme:saveBonusData(self.data.core_data)
	self.theme:showBonusNode()
	if tryResume then
		self.callback = function ( ... )
			-- 断线重连回调方法
			local endCallFunc2 = function ( )
				if self.ctl:noFeatureLeft() then 
					self.theme.ctl.footer:setSpinButtonState(false)
				end
				if self.oldCallBack then 
					self.oldCallBack()
				end
				self.ctl.isProcessing = false
			end
			endCallFunc2()
		end
		self.ctl.isProcessing = true
	end

	if self.bonusType == BonusGameType.Respin then	
	    self.ctl.footer.isRespinLayer = true
		self:enterRespinBonus(tryResume)
	elseif self.bonusType == BonusGameType.MapSlot then
	    self.ctl.footer.isRespinLayer = true
		self:enterMapReSpinBonus(tryResume)
	-- elseif self.bonusType == BonusGameType.MapFree then
	-- 	self:onRespinEnd()
	end
end


-------------------------------------- respin ---------------------------------
function bonusGame:enterRespinBonus(tryResume)
	
	self.theme:changeSpinBoard(SpinBoardType.ReSpin)

    self:initRespinBonusData()
    self:initShowRespinNode(tryResume)
    self:initBonusShowJackpotLabels()

    if tryResume and self.data.isClickStart then 
    	self.theme:dealMusic_EnterBonusGame()
        self:initResumeRespinShowOnCover(tryResume)
        self:initResumeRespinShowOnEnd(tryResume)

        local function startSpin( )
            -- 通过判断来进行操作是继续respin 还是进行收集操作
            if #self.ctl.rets.theme_respin >0 then 
                self.theme:theme_respin(self.ctl.rets)
            else -- 是否有小游戏的相关逻辑在 主题里面自行判断
                self.theme.respinStep = ReSpinStep.Over 
                self:onRespinStop(self.ctl.rets,true)
            end
        end
        startSpin()
    else
        self:showStartRespinBonusDialog()
    end
end

function bonusGame:initRespinBonusData() -- respin{ 每次结果，isWinGrand: 是否中奖 grand}
    self.progressiveData    = tool.tableClone(self.data.core_data.progressive_list)
    self.respinBonusData    = tool.tableClone(self.data.core_data.win_respin)
	
    self.respinItemlist = {}
	self.respinWinList = {}
	self.jpWinDataList = {}
	self.respinTotalWinList = {}
	self.respinLeftList = {}
	self.isWinGrandList = {}
	self.isWinRespinBoard = {false, false, false}
	self.finshBoardList = {true, true, true}
	self.respinMaxCnt = 0

	self.firstCollectBoardID = 0

    for id, singleBoardData in pairs(self.respinBonusData) do 

    	table.insert(self.respinItemlist, tool.tableClone(singleBoardData.theme_respin or {}))
    	table.insert(self.respinWinList, tool.tableClone(singleBoardData.respin_list or {}))
    	table.insert(self.jpWinDataList, tool.tableClone(singleBoardData.jp_win_temp or {}))
    	table.insert(self.respinTotalWinList, ((singleBoardData.total_win or 0) + (singleBoardData.jp_total_win or 0)) )
    	table.insert(self.respinLeftList, tool.tableClone(singleBoardData.respin_left or {}))
    	self.isWinGrandList[id] = singleBoardData.coin_count and singleBoardData.coin_count == singleReelRespinCellCount

    	if singleBoardData.respin_all_count and singleBoardData.respin_all_count > self.respinMaxCnt then 
    		self.respinMaxCnt = singleBoardData.respin_all_count
    	end
    	if bole.getTableCount(singleBoardData) > 0 then 
    		self.isWinRespinBoard[id] = true
    		self.finshBoardList[id] = false
    		if self.firstCollectBoardID == 0 then 
    			self.firstCollectBoardID = id
    		end
    	end
    end
    self:getBonusEndItemListByBoard(self.data.core_data.win_item_list, self.respinItemlist)

    self:fixBonusItemList()

    self:initResumeRespinData()
end

function bonusGame:initResumeRespinData( ... )
	-- 计数数据
    self.curCollectBoardID = 1-- self.data["collect_barod_id"] or 1
    self.respinTimes    = self.data["have_respin_index"] or 0
    self.respinCurSumList = {-1, -1, -1}

    if self.respinTimes > 0 then 
		for i = 1, boardTotalCnt do 
			if self.respinLeftList and self.respinLeftList[i] and self.respinLeftList[i][self.respinTimes] then 
				self.respinCurSumList[i] = self.respinLeftList[i][self.respinTimes]
			end
		end
    else
		for i = 1, boardTotalCnt do 
			if self.respinLeftList and self.respinLeftList[i] and self.respinLeftList[i][1] then 
				self.respinCurSumList[i] = 3
			end
		end
    end

    -- 牌面
    self.ctl.rets.item_list = self.data.core_data.win_item_list
    if self.respinTimes and self.respinTimes>0 then
        for i=1, self.respinTimes do
        	if #self.respinItemlist < 0 then 
				break
			else
				self.ctl.rets.item_list = table.remove(self.respinItemlist, 1)
			end
        end 
    end
    
    self.theme:fixRetByBonus(self.ctl.rets) -- 对数据进行区分

    for col, reel in pairs(self.theme.spinLayer.spins) do
        local key = self.ctl.rets.item_list[col][1]
        local cell = reel:currentCell()
        local boardID = math.ceil(col/singleReelRespinCellCount)
        self.theme:updateCellSprite(cell, key, col, true, true, not self.isWinRespinBoard[boardID])
    end

    self.ctl.rets["win_type"] = nil
    self.ctl.rets["total_win"] = 0
    self.ctl.rets.theme_respin  = tool.tableClone(self.respinItemlist)

    -- 音效播放标志位 
    self.theme.reelStopMusicTagList = self.theme.reelStopMusicTagList or {}
    -- spin 结果数据和 显示stop 按钮有关
    self.ctl.cacheSpinRet               = self.ctl.cacheSpinRet or self.ctl.rets

    -- 赢钱
    self.onlyBonusWin = 0 -- onlyBonusWin  显示的是 bonus 的 总赢钱
	if self.respinTotalWinList then
		for col, winValue in pairs(self.respinTotalWinList) do 
			self.onlyBonusWin = self.onlyBonusWin + winValue or 0
		end
	end

	self.respinWin  = self.ctl.totalWin or 0
	self.respinCollectShowWin = 0
	if self.curCollectBoardID > 1 then
		for id = 1, self.curCollectBoardID do 
			if self.curCollectBoardID > boardTotalCnt then break end
			if self.curCollectBoardID == id then 
				if self.isWinGrandList and self.isWinGrandList[id] and self.data["collect_grand"] and self.data["collect_grand"][id] and self.jpWinDataList[id] and self.jpWinDataList[id][1] then 
					local winGrandData = table.remove(self.jpWinDataList[id], 1)
					self.respinWin = self.respinWin + winGrandData.jp_win or 0
					self.respinCollectShowWin = self.respinCollectShowWin + winGrandData.jp_win or 0
				end
			elseif self.isWinRespinBoard[id] then 
				self.respinWin = self.respinWin + self.respinTotalWinList[id] or 0

				self.theme.rWinNodeList[id]:setVisible(true)
				local winValue = self.respinTotalWinList[id] or 0
				self.theme.rWinLabelList[id]:setString(FONTS.format(winValue, true))

				self.theme:addSpineAnimation(self.theme.rWinNodeList[id].animNode, -1, self.theme:getPic("spine/respin/youwinchuxian"), cc.p(0, 0), "animation1_1", nil, nil, nil, true)
			end
		end
	end

    self.ctl.footer:reSetWinCoinsString(self.respinWin,0, 0)
end

function bonusGame:getBonusEndItemListByBoard(itemList, respinTList)
	if itemList and respinTList then 
		self.finshItemListB = {}
		for boardId = 1, boardTotalCnt do 
			if #respinTList[boardId] > 0 then 
				table.insert(self.finshItemListB, tool.tableClone(respinTList[boardId][#respinTList[boardId]]))
			else
				local boardItemList = {}
				for startCol = (boardId-1)*baseColCnt + 1, boardId*baseColCnt do 
					table.insert(boardItemList, itemList[startCol])
				end
				table.insert(self.finshItemListB, tool.tableClone(boardItemList))
			end
		end
	end
end

function bonusGame:fixBonusItemList()
	local data = tool.tableClone(self.respinItemlist)

	local newItemListTotal = {}
	local kongItemList = {{0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}}
	for index = 1, self.respinMaxCnt do 
		local newItemList = {}
		for id, _itemList in pairs(data) do 
			if #_itemList > 0 then 
				tool.mergeTableOrder(newItemList, table.remove(_itemList, 1))
			else
				local tempList = self.finshItemListB and self.finshItemListB[id] or kongItemList
				tool.mergeTableOrder(newItemList, tool.tableClone(tempList))
			end
		end
		table.insert(newItemListTotal, newItemList)
	end
	self.respinItemlist = newItemListTotal
end

function bonusGame:updateLockReelState()
	self.theme.lockedReels = self.theme.lockedReels or {}
	for id, isWinBoard in pairs(self.isWinRespinBoard) do 
		if not isWinBoard then
			self:changeLockReelStateSingleBoard(id)
		end
	end
end

function bonusGame:changeLockReelStateSingleBoard( id )
	for col = (id-1)*singleReelRespinCellCount + 1, id*singleReelRespinCellCount do 
		self.theme.lockedReels[col] = true
	end
end

function bonusGame:initBonusShowJackpotLabels()
    self.theme:lockJackpotMeters(true)  -- 锁住jackpot meter
    local jpLabels = self.theme.jackpotLabels
    -- 获取jackpot
    local _progressive_list = self.theme:getJackpotValue(self.progressiveData)
    
    for i=1, #_progressive_list do -- 设置jackpot label值
        if jpLabels[i] then
            jpLabels[i]:setString(self.theme:formatJackpotMeter(_progressive_list[i]))
            bole.shrinkLabel(jpLabels[i], self.theme:getJPLabelMaxWidth(i), jpLabels[i]:getScale())
        end
    end
end

function bonusGame:initShowRespinNode(tryResume)
	
	-- if tryResume then 
 --    	-- self.theme:changeSpinBoard(SpinBoardType.ReSpin)
 --    end
	self:updateLockReelState()

	for i= 1,singleReelRespinCellCount*boardTotalCnt do -- 显示lock住的动画
		self.theme:onReelStop(i, true) -- 第二个参数 控制不播放停止动画 第三个参数控制>100 才lock
	end

	self:playRespinTipNoWinAndWinKuang(tryResume)
end

function bonusGame:initResumeRespinShowOnCover( tryResume )
	local action = cc.CSLoader:createTimeline(self.theme:getPic("csb/base.csb"))
	self.theme.mainThemeScene:runAction(action)
	action:gotoFrameAndPause(60)

	self.theme.longLogoNode:setVisible(false)

	if self.theme.curBg ~= self.theme.respinBg then 
		self.theme.curBg:setVisible(false)
		self.theme.respinBg:setVisible(true)
		self.theme.curBg = self.theme.respinBg
	end

	for _, node in pairs(self.theme.respinKuangList) do
		node:setVisible(true)
	end
end

function bonusGame:initResumeRespinShowOnEnd( tryResume )
	self:freshRespinNumAll(self.respinTimes)-- 刷新次数显示
	self:playRespinWinGrandTips(tryResume)
	self:checkRespinDataByThemeDealData()
end

function bonusGame:playRespinTipNoWinAndWinKuang(tryResume)

	local path = self.theme:getPic("spine/dialog/respin/respintanchuang")
	local canPlayM = true
	for id, isWinBoard in pairs(self.isWinRespinBoard) do 
		if not isWinBoard then 
			local _, s = self.theme:addSpineAnimation(self.theme.respinWinSpineParent, nil, path, cc.p(0,reelBaseY + reelAddY[id]), "animation1", nil, nil, nil, true)
			s:runAction(cc.Sequence:create(
				cc.DelayTime:create(20/30),
				cc.CallFunc:create(function ()
					bole.spChangeAnimation(s, "animation1_2", true)
				end)))
		else
			self:playRespinWinKuangAnim(id)
			if canPlayM then 
		    	self.theme:playMusic(self.theme.audio_list.game_active)
		    	canPlayM = false
		    end
		end

		self.theme.respinDimmerList[id]:setVisible(not isWinBoard)
	end
end

function bonusGame:playRespinWinKuangAnim(id, winGrand)
	local path2 = winGrand and self.theme:getPic("spine/respin/waikuangzhongjiang") or self.theme:getPic("spine/respin/waikuangxunhuan")
	local _, s2 = self.theme:addSpineAnimation(self.theme.respinWinSpineParent, nil, path2, cc.p(0,reelBaseY + reelAddY[id]), "animation", nil, nil, nil, true, true)
	
	self.winRespinKuangAnimList = self.winRespinKuangAnimList or {}
	if bole.isValidNode(self.winRespinKuangAnimList[id]) then 
		self.winRespinKuangAnimList[id]:removeFromParent()
	end
	self.winRespinKuangAnimList[id] = s2
end

function bonusGame:playRespinWinGrandTips(tryResume)
	self.winGrandSpineList = self.winGrandSpineList or {}
	local notPlayMusic = true
	for id, isWinGrand in pairs(self.isWinGrandList) do 
		if isWinGrand then -- and (not self.winGrandSpineList[id]) then (not (self.data["collect_grand"] and self.data["collect_grand"][id])) 
			if self.respinLeftList and #self.respinLeftList[id] > 0 then 
				if self.respinTimes and not self.respinLeftList[id][self.respinTimes + 1] then -- 因为没有次数 直接展示grand 弹窗动画
					if (not self.winGrandSpineList[id]) and (not (self.data["collect_grand"] and self.data["collect_grand"][id])) then 
						self:addWinGrandAnim(id, ((not tryResume)and notPlayMusic))	
						if (not tryResume)and notPlayMusic then 
							notPlayMusic = false
						end
					end
					self:playRespinWinKuangAnim(id, true)
				end
			else -- 直接展示grand 弹窗动画
				self:addWinGrandAnim(id, ((not tryResume)and notPlayMusic))
				self:playRespinWinKuangAnim(id, true)
				if (not tryResume)and notPlayMusic then 
					notPlayMusic = false
				end
			end
		end
	end
end

function bonusGame:addWinGrandAnim( id, playMusic )
	if playMusic then 
		self.theme:playMusic(self.theme.audio_list.respin_full)
	end

	local path = self.theme:getPic("spine/respin/grand")
	local _, s = self.theme:addSpineAnimation(self.theme.respinWinSpineParent, nil, path, cc.p(0,reelBaseY + reelAddY[id]), "animation1", nil, nil, nil, true)
	s:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(function ()
			bole.spChangeAnimation(s, "animation1_1", true)
		end)))

	self.winGrandSpineList[id] = s
end

function bonusGame:showStartRespinBonusDialog( ... )
    local path      = self.theme:getPic("csb/dialog_respin_s.csb")
    local dialog    = cc.CSLoader:createNode(path)
    self.theme.down_child:addChild(dialog)

    local root = dialog:getChildByName("root")
    
    local btnStart = root:getChildByName("btn_start")
    local show_node = root:getChildByName("show_node")

    local startID
    local endID
    for id, isWin in pairs(self.isWinRespinBoard) do 
    	if isWin then
    		if not startID then 
    			startID = id
    		end
    		endID = id
    	end
    end
    show_node:setPositionY(reelBaseY + reelAddY[endID] + (singleBoardHeight * (endID-startID))/2)

    self.theme:playMusic(self.theme.audio_list.bonus_start_show)

	local _, s = self.theme:addSpineAnimation(show_node, nil, self.theme:getPic("spine/dialog/respin/respintanchuang"), cc.p(0, 0), "animation2", nil, nil, nil, true)
	s:runAction(cc.Sequence:create(
		cc.DelayTime:create(22/30),
		cc.CallFunc:create(function ()
			bole.spChangeAnimation(s, "animation2_1", true)
		end)))

    local clickEndFunction = function ( obj, eventType )
        if eventType == ccui.TouchEventType.ended then 
            btnStart:setTouchEnabled(false)
            self.theme:playMusic(self.theme.audio_list.common_click)
            	
            self.data.isClickStart = true
            self:saveBonus()

            dialog:runAction(cc.Sequence:create(
                cc.DelayTime:create(0.2),
                cc.CallFunc:create(function ( ... )
                    self.theme:dialogPlayLineAnim("hide", nil, show_node) -- 关闭弹窗
                end),
                cc.DelayTime:create(21/30),
                cc.CallFunc:create(function ()
                	self.theme:playTransition(nil,"bonus")-- 转场动画
				end),
				cc.DelayTime:create(transitionDelay.bonus.onCover),-- 覆盖全屏的时间
				cc.CallFunc:create(function ()
					-- self.theme:changeSpinBoard(SpinBoardType.ReSpin)
					self:initResumeRespinShowOnCover()
				end),
				cc.DelayTime:create(transitionDelay.bonus.onEnd - transitionDelay.bonus.onCover),-- 覆盖全屏的时间
				cc.CallFunc:create(function ()
					self.theme:dealMusic_EnterBonusGame()
					self:initResumeRespinShowOnEnd()
					self:checkPlayRespin()
				end),
                cc.RemoveSelf:create()
            ))
        end
    end

    dialog:runAction(cc.Sequence:create(
        cc.DelayTime:create(1.5),
        cc.CallFunc:create(function()
            btnStart:addTouchEventListener(clickEndFunction)
        end)))
end

function bonusGame:checkPlayRespin()
    if #self.ctl.rets.theme_respin >0 then 
        self.ctl:handleResult()
    else -- 是否有小游戏的相关逻辑在 主题里面自行判断
        self.theme.respinStep = ReSpinStep.Over 
        self:onRespinStop(self.ctl.rets,true)
    end
end

function bonusGame:freshRespinTotalNum()
    self:freshRespinCnt()-- 同时更新保存 spin 次数和 总次数
    
    self.theme:playMusic(self.theme.audio_list.chance_reset)
    
    for boardID = 1, boardTotalCnt do 
		local showCnt = -1
		if self.respinTimes then
			if self.respinLeftList[boardID] and self.respinLeftList[boardID][self.respinTimes] and self.respinLeftList[boardID][self.respinTimes] == 3 then 
				local tempNode = self.theme.rBoardCntTipNodes[boardID]
				self.theme:addSpineAnimation(tempNode.parent, 20, self.theme:getPic("spine/respin/shuzibianhua"), cc.p(-127, 0), "animation")
			end
		end
	end

    self:freshRespinNumAll(self.respinTimes)
end

function bonusGame:freshRespinCnt(sum,cur)
    -- self:addData("respin_total", sum or self.respinSum)
    self:addData("have_respin_index", cur or self.respinTimes)
end

function bonusGame:setRespinLabel(tempNode, sum)
    for id, node in pairs(tempNode) do
    	if type(id) == "number" then 
    		node:setVisible(id == sum)
    	end
    end
end

function bonusGame:freshRespinNumAll(_rTimes)
	
	for boardID = 1, boardTotalCnt do 
		local showCnt = -1 -- self.respinCurSumList[boardID]
		if _rTimes then
			showCnt = _rTimes == 0 and self.respinCurSumList[boardID] or showCnt
			if self.respinLeftList[boardID] and self.respinLeftList[boardID][_rTimes] then 
				showCnt = self.respinLeftList[boardID][_rTimes]
			end
		else
			if self.respinCurSumList and self.respinCurSumList[boardID] then 
				showCnt = (self.respinCurSumList[boardID] or 0) - 1
			end
		end
		self.respinCurSumList[boardID] = showCnt

		self:freshRespinNumSingle(boardID, showCnt)
	end
end

function bonusGame:freshRespinNumSingle(boardID, showCnt)
	if boardID and showCnt and self.theme.rBoardCntTipNodes[boardID] then
		local tempNode = self.theme.rBoardCntTipNodes[boardID]
		if tempNode and bole.isValidNode(tempNode.parent) then 
			if showCnt <= -1 then
				tempNode.parent:runAction(cc.Sequence:create(
					cc.FadeTo:create(0.3,0),
					cc.CallFunc:create(function ( ... )
						tempNode.parent:setVisible(false)
					end)))
			else
				if not tempNode.parent:isVisible() then 
					tempNode.parent:setOpacity(0)
					tempNode.parent:setVisible(true)
					tempNode.parent:runAction(cc.FadeTo:create(0.5,255))
					self.theme:playMusic(self.theme.audio_list.spins_remaining)
				end
				self:setRespinLabel(tempNode, showCnt)
			end
		end
	end
end

function bonusGame:checkCurBoardIsFinshByID( boardID )
	local isFinsh = false
	if self.finshBoardList and self.finshBoardList[boardID] then 
		isFinsh = true
	elseif self.respinTimes and self.respinLeftList and self.respinLeftList[boardID] and (not self.respinLeftList[boardID][self.respinTimes + 1]) then
		isFinsh = true
	end
	return isFinsh
end

function bonusGame:checkRespinDataByThemeDealData( overFunc )
	local winGrand = self:checkHasFinshBoard()
	self:checkHasLastToWinGarnd()
	
	if winGrand then 
		self.theme:runAction(cc.Sequence:create(
			cc.DelayTime:create(1),
			cc.CallFunc:create(function ( ... )
				if overFunc then 
					overFunc()
				end
			end)))
	else
		if overFunc then 
			overFunc()
		end
	end
end

function bonusGame:checkHasFinshBoard()
	self.finshBoardList = self.finshBoardList or {}
	local isWinGrand = false
	for boardId = 1, boardTotalCnt do 
		if not self.finshBoardList[boardId] then 

			local isNewFinsh = self:checkCurBoardIsFinshByID(boardId)
			if isNewFinsh then 
				self.finshBoardList[boardId] = isNewFinsh
				self:changeLockReelStateSingleBoard(boardId)

				self.respinCurSumList = self.respinCurSumList or {}
				self.respinCurSumList[boardId] = -1
				self:freshRespinNumSingle(boardId, -1)

				if not isWinGrand then 
					isWinGrand = self.isWinGrandList[boardId]
				end
				if self.isWinGrandList[boardId] then 
					self:addWinGrandAnim(boardId, true)
					self:playRespinWinKuangAnim(boardId, true)
				end

				if self.lastSpinList and bole.isValidNode(self.lastSpinList[boardId]) then 
					self.lastSpinList[boardId]:removeFromParent()
					self.lastSpinList[boardId] = nil
				end
			end
		end
	end
	return isWinGrand
end

function bonusGame:checkHasLastToWinGarnd()
	self.finshBoardList = self.finshBoardList or {}
	for boardId = 1, boardTotalCnt do 
		if not self.finshBoardList[boardId] then 
			local lockCnt = 0
			local isAnimPos
			for col = (boardId-1)*singleReelRespinCellCount + 1, boardId*singleReelRespinCellCount do 
				if self.theme.lockedReels and self.theme.lockedReels[col] then 
					lockCnt = lockCnt+1
				else
					isAnimPos = col
				end
			end
			if lockCnt == singleReelRespinCellCount -1 and isAnimPos then 
				self:playRespinLastAnticiAnim(boardId, isAnimPos)
			end
		end
	end
end

function bonusGame:playRespinLastAnticiAnim( boardId, isAnimPos )
	self.lastSpinList = self.lastSpinList or {} 
	if not bole.isValidNode(self.lastSpinList[boardId]) then 
		self.theme:playMusic(self.theme.audio_list.respin_anticipation, true, true)
		local _, s = self.theme:addSpineAnimation(self.theme.HoldLayer, 300, self.theme:getPic("spine/respin/res_end"), self.theme:getCellPos(isAnimPos,1), "animation", nil, nil, nil, true, true, nil)
		self.lastSpinList[boardId] = s
	end
end

function bonusGame:onRespinStart( )
    self.theme.respinStep = ReSpinStep.Playing  -- 用来更改 不在 Start 状态
    self.respinTimes = self.respinTimes + 1
    self:freshRespinNumAll() -- 更新计数
end

function bonusGame:onRespinStop(ret,tryResume)
    if self.theme.respinStep == ReSpinStep.Over then
        --respin 收集
        self.ctl.footer:setSpinButtonState(true) -- 禁用 spin 按钮
        self:freshRespinNumAll(self.respinMaxCnt + 1) -- self:freshRespinNum(-1)

        self.theme:dealMusic_FadeLoopMusic(0.2, 1, 0.3)
        local delay = 1
        if not tryResume then 
            delay = 2
            self.theme:playMusic(self.theme.audio_list.respin_end) -- 播放respin结束的音效
        end
        self.theme:runAction(cc.Sequence:create(
            cc.DelayTime:create(delay),
            cc.CallFunc:create(function ()
            	self:showRespinCollectNode(tryResume)
            	self:bonusCheckIsOverSingleBoard(tryResume)
            end)))
    end
end

function bonusGame:showRespinCollectNode( tryResume )
	self.flyParent = cc.Node:create()
	self.theme.down_child:addChild(self.flyParent)

	self:showCollectLaterDialog()
end

function bonusGame:showCollectLaterDialog()
	local path = self.theme:getPic("spine/dialog/respin/respintanchuang")
	local collectID = self.curCollectBoardID > self.firstCollectBoardID and self.curCollectBoardID or self.firstCollectBoardID
	for id, isWinBoard in pairs(self.isWinRespinBoard) do 
		if isWinBoard and collectID < id then 
			local _, s = self.theme:addSpineAnimation(self.theme.respinWinSpineParent, 20, path, cc.p(0,reelBaseY + reelAddY[id]), "animation3", nil, nil, nil, true)
			s:runAction(cc.Sequence:create(
				cc.DelayTime:create(22/30),
				cc.CallFunc:create(function ()
					bole.spChangeAnimation(s, "animation3_1", true)
				end)))
			self.collectTipBoard = self.collectTipBoard or {}
			self.collectTipBoard[id] = s
		end
	end
end

local showCollectNodeTime = 1
local hideTipBoardTime = 0.5
function bonusGame:bonusCheckIsOverSingleBoard(tryResume)
	self.curBoardWinRespinData 	= self.respinBonusData[self.curCollectBoardID]
	self.curBoardIsWinGrand 	= self.isWinGrandList[self.curCollectBoardID]
	self.curBoardRespinWinList 	= self.respinWinList[self.curCollectBoardID]
	self.curBoardJPWinDataList 	= self.jpWinDataList[self.curCollectBoardID]
	self.curBoardRespinTotalWin = self.respinTotalWinList[self.curCollectBoardID]
	self.curBoardIsCollectGrand = self.data["collect_grand"] and self.data["collect_grand"][self.curCollectBoardID]

	if self.isWinRespinBoard[self.curCollectBoardID] then 
		local delay = tryResume and 0 or showCollectNodeTime

		self:showRespinCollectDialog((self.respinCollectShowWin and self.respinCollectShowWin <= 0))

		if self.collectTipBoard and bole.isValidNode(self.collectTipBoard[self.curCollectBoardID]) then 
			local temp = self.collectTipBoard[self.curCollectBoardID]
			temp:runAction(cc.Sequence:create(
				cc.DelayTime:create(delay),
				cc.FadeOut:create(hideTipBoardTime),
				cc.RemoveSelf:create()))
			self.collectTipBoard[self.curCollectBoardID] = nil

			delay = delay + hideTipBoardTime
		end

		self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(delay),
		cc.CallFunc:create(function ( ... )
			if self.curBoardIsWinGrand and (not self.curBoardIsCollectGrand) then 
				self:showCollectGrandAnim()
			else
				self:showCollectWinAnim()
			end
		end)))
	else
		self:bonusCheckIsOverAll()
	end
end

function bonusGame:bonusCheckIsOverAll()
	self.respinCollectShowWin = 0
	self.curCollectBoardID = self.curCollectBoardID + 1
	self.data["collect_barod_id"] = self.curCollectBoardID
	self:saveBonus()
	if self.curCollectBoardID <= boardTotalCnt then 
		self:bonusCheckIsOverSingleBoard()
    else
    	self.theme:runAction(cc.Sequence:create(
    		cc.DelayTime:create(1),
    		cc.CallFunc:create(function ( ... )
    			self:showRespinCollectTotalDialog()
    		end)))
	end
end


function bonusGame:showRespinCollectDialog(showAnim)
    local str = self.respinCollectShowWin > 0 and FONTS.format(self.respinCollectShowWin,true) or ""
	self.theme.rTotalCollectLable:setString(str) -- 显示收集 node节点
	bole.shrinkLabel(self.theme.rTotalCollectLable, respinCollectMaxWidth, self.theme.rTotalCollectLable:getScale())
    self.theme.rTotalCollectLable:setOpacity(255)
    self.theme.rTotalCollectLable:stopAllActions()

    -- if not self.theme.rTotalCollectNode:isVisible() then  
    	local animName = showAnim and "animation1" or "animation1_1"
    	if showAnim then 
	        self.theme:playMusic(self.theme.audio_list.collect_change)
	        self.theme.rTotalCollectLable:setOpacity(0)
			self.theme.rTotalCollectLable:runAction(cc.FadeIn:create(0.5))
	    end
	    self.theme.rTotalCollectNode:setVisible(true)
	    local _,s = self.theme:addSpineAnimation(self.theme.rTotalCollectNode, -1, self.theme:getPic("spine/respin/mubanchuxian"), cc.p(0, 0), animName, nil, nil, nil, true)
        self.collectWinDialog = s
        self.collectWinDialog:setScale(1.25)
        self.theme.rTotalCollectLable:setVisible(true)
    -- end
end

function bonusGame:showCollectGrandAnim()
	self:showCollectGrandDialog(ret) 
--     -- self.theme:addSpineAnimation(self.theme.down_child, nil, self.theme:getPic("spine/respin/qipanbao"), cc.p(0,0), "animation")-- 播放 点亮棋盘动画
--     -- self.theme:playMusic(self.theme.audio_list.jp_win)

--     self.theme:runAction(cc.Sequence:create(
--         -- cc.DelayTime:create(1), -- 特效延迟时间
--         cc.CallFunc:create(function ( ... )
--             self:showCollectGrandDialog(ret)        
--         end)))
end

local grandMoveTime = 1
function bonusGame:showCollectGrandDialog()
	local grandWin = 0

    if self.curBoardJPWinDataList and self.curBoardJPWinDataList[1] and self.curBoardJPWinDataList[1].jp_win then 
        local item = table.remove(self.curBoardJPWinDataList, 1)
        grandWin = item.jp_win
    end

	if self.winGrandSpineList and self.winGrandSpineList[self.curCollectBoardID] then 
		local temp = self.winGrandSpineList[self.curCollectBoardID]
		if bole.isValidNode(temp) then 
			temp:removeFromParent()
		end
		self.winGrandSpineList[self.curCollectBoardID] = nil
	end

	self:playWinJpAnim(jackpotWinType.Grand)
    
    local _, grandDialog = self.theme:addSpineAnimation(self.flyParent, nil, self.theme:getPic("spine/respin/grandtuowei"), cc.p(0,reelBaseY + reelAddY[self.curCollectBoardID]), "animation")
    grandDialog:runAction(cc.MoveTo:create(grandMoveTime, cc.p(self.theme.rTotalCollectNode:getPosition())))
    self.theme:playMusic(self.theme.audio_list.dialog_grand_collect)

    self.flyParent:runAction(cc.Sequence:create(
        cc.DelayTime:create(grandMoveTime),
        cc.CallFunc:create(function ( ... )
            self.ctl.footer:setWinCoins(grandWin, self.respinWin, 0) -- 添加金额到 footer 
            self.respinWin = self.respinWin + grandWin
            
            local curShowWin = self.respinCollectShowWin
            self.respinCollectShowWin = self.respinCollectShowWin + grandWin

            self.theme.rTotalCollectLable:setString(FONTS.format(self.respinCollectShowWin,true)) -- 显示收集 node节点
            bole.shrinkLabel(self.theme.rTotalCollectLable, respinCollectMaxWidth, self.theme.rTotalCollectLable:getScale())
            self.theme.rTotalCollectLable:setString(FONTS.format(curShowWin, true)) -- 显示收集 node节点
            self.theme.rTotalCollectLable:stopAllActions()

            self.theme.rTotalCollectLable:nrStartRoll(curShowWin, self.respinCollectShowWin, 0.3)-- 播放numberRoll
            self.theme.rTotalCollectLable:runAction(
                cc.Sequence:create(
                    cc.DelayTime:create(0.3),
                    cc.CallFunc:create(function ( ... )
                        self.theme.rTotalCollectLable:nrOverRoll()-- 停止滚动
                    end)))

			self.data["collect_grand"] = self.data["collect_grand"] or {}
			self.data["collect_grand"][self.curCollectBoardID] = true
			self:saveBonus()

			self.theme.jpAnimNode:removeAllChildren()
			self:showCollectWinAnim()
        end)))
end

function bonusGame:playWinJpAnim( winType )
	if winType and not self.theme.lockFeatureState[winType] then
		local animName
		if winType == jackpotWinType.Grand then 
			animName = "animation1"
		elseif winType == jackpotWinType.Major or winType == jackpotWinType.Minor or winType == jackpotWinType.Mini then 
			animName = "animation2"
		end
		if animName then 
			local _, jpAnim = self.theme:addSpineAnimation(self.theme.jpAnimNode, nil, self.theme:getPic("spine/jackpot/jpkuang"), cc.p(self.theme.jackpotLockNodes[winType]:getPosition()), animName, nil, nil, nil, true, true)
			return jpAnim 
		end
	end
	
end

function bonusGame:getResultItemList()
	self.doList = {}
	self.doValueList = {}
	local startCol = ((self.curCollectBoardID or 1) - 1)* singleReelRespinCellCount
	if self.curBoardRespinWinList and #self.curBoardRespinWinList > 0 then 
		for col, colList in pairs(self.curBoardRespinWinList) do 
			for row, key in pairs(colList) do
				local index = (row-1)*5+col + startCol
				if jackpotBet[key] then
					if self.theme.HoldLayer._added[index] then 
						table.insert(self.doList, index)
						table.insert(self.doValueList, key)
					end
				end
			end
		end
	end
end

function bonusGame:showCollectWinAnim()
	self:getResultItemList()

	self:checkIsOverCollectAnim() -- 收钱动画
	-- self.theme:runAction(cc.Sequence:create(
	-- 	cc.DelayTime:create(1),
	-- 	cc.CallFunc:create(function ( ... )
	-- 		self:checkIsOverCollectAnim() -- 收钱动画
	-- 	end)))
end

function bonusGame:checkIsOverCollectAnim(tryResume)
    if (not self.doList) or #self.doList == 0 then
    	self:showCollectSingleBoardFinsh()
    else
        local item = table.remove(self.doList, 1)

        local value = #self.doValueList > 0 and table.remove(self.doValueList, 1) or 0

        self:addWinToDialog(item, value)
    end
end

local showFlyWinNodeAnimTime = 15/30
function bonusGame:showCollectSingleBoardFinsh( )
	self.theme:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			self.theme:playMusic(self.theme.audio_list.collect_move)
			self.theme.rTotalCollectNode:setVisible(false)
			-- 播放移动 收集框的动画
			local flyWinNode = self.theme.rWinNodeList[self.curCollectBoardID]
			local flyWinLabel = self.theme.rWinLabelList[self.curCollectBoardID]
			flyWinNode:setVisible(true)

			local startScale = self.theme.rTotalCollectNode:getScale()
			local endScale = flyWinNode:getScale()
			local startPos = cc.p(self.theme.rTotalCollectNode:getPosition())
			local endPos = cc.p(flyWinNode:getPosition())

			
			flyWinNode:setPosition(startPos)
			flyWinNode:setScale(startScale)
			flyWinLabel:setString(FONTS.format(self.curBoardRespinTotalWin,true)) -- 显示收集 node节点
			bole.shrinkLabel(flyWinLabel, respinCollectMaxWidth, flyWinLabel:getScale())
			
			local _, s = self.theme:addSpineAnimation(flyWinNode.animNode, -1, self.theme:getPic("spine/respin/youwinchuxian"), cc.p(0, 0), "animation1", nil, nil, nil, true)
			s:setScale(1/startScale)
			s:runAction(cc.ScaleTo:create(showFlyWinNodeAnimTime, 1))
			flyWinNode:runAction(cc.Spawn:create(
				cc.ScaleTo:create(showFlyWinNodeAnimTime, endScale),
				cc.MoveTo:create(showFlyWinNodeAnimTime, endPos)))
		end),
		cc.DelayTime:create(showFlyWinNodeAnimTime*2),
		cc.CallFunc:create(function ( ... )
			-- 重新展示收集框
			self:bonusCheckIsOverAll()
		end)))
    	
end

local collectAnimTime = 16/30
local addResultLiziTime = 8/30
function bonusGame:addWinToDialog(item, theNum)
    local cell = self.theme.HoldLayer._added[item]
    if cell and bole.isValidNode(cell.bg) and cell.bg.animType then 
        bole.spChangeAnimation(cell.bg,"animation"..cell.bg.animType.."_3") -- 播放消失动画
    end

    local winJPAnim
	local theKey = cell.key 
    self.theme:runAction(cc.Sequence:create(
    	cc.DelayTime:create(10/30),
        cc.CallFunc:create(function ()
            if theKey ~= specialSymbol.bonus then -- jp
            	winJPAnim = self:playWinJpAnim(jackpotType[theKey])
                self.theme:playMusic(self.theme.audio_list.respin_collect)
            else -- 普通
                self.theme:playMusic(self.theme.audio_list.respin_collect)
            end

            if not bole.isValidNode(self.FlyliziNode) then
                local _, s = self.theme:addSpineAnimation(self.flyParent, nil, self.theme:getPic("spine/respin/respinshouji"), cc.p(0,0), "animation"..item, nil, nil, nil, true)
                self.FlyliziNode = s
            else
                bole.spChangeAnimation(self.FlyliziNode,"animation"..item,false)
            end
        end),
        cc.DelayTime:create(addResultLiziTime),
        cc.CallFunc:create(function ( ... )
			if not bole.isValidNode(self.FlyliziNode1) then -- 收集接受动画
			    local _, s = self.theme:addSpineAnimation(self.theme.rTotalCollectAnim, nil, self.theme:getPic("spine/respin/respinjieshou"), cc.p(0,0), "animation", nil, nil, nil, true)
			    s:setScale(1.25)
			    self.FlyliziNode1 = s
			else
			    bole.spChangeAnimation(self.FlyliziNode1,"animation",false)
			end

			local startScale = self.theme.rTotalCollectNode.baseScale
			self.theme.rTotalCollectNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(collectAnimTime/2, startScale*1.2),
				cc.ScaleTo:create(collectAnimTime/2, startScale*1)))

			local theNum = cell.num 
			if theKey ~= specialSymbol.bonus then 
			    if self.curBoardJPWinDataList and self.curBoardJPWinDataList[1] and self.curBoardJPWinDataList[1].jp_win then 
			        local item = table.remove(self.curBoardJPWinDataList,1)
			        theNum = item.jp_win
			    end
			end

            self.ctl.footer:setWinCoins(theNum, self.respinWin, 0)
            self.respinWin = self.respinWin + theNum
            local curShowWin = self.respinCollectShowWin
            self.respinCollectShowWin = self.respinCollectShowWin + theNum

            self.theme.rTotalCollectLable:setString(FONTS.format(self.respinCollectShowWin,true)) -- 显示收集 node节点
            bole.shrinkLabel(self.theme.rTotalCollectLable, respinCollectMaxWidth, self.theme.rTotalCollectLable:getScale())
            self.theme.rTotalCollectLable:setString(FONTS.format(curShowWin, true)) -- 显示收集 node节点
            self.theme.rTotalCollectLable:stopAllActions()

            self.theme.rTotalCollectLable:nrStartRoll(curShowWin, self.respinCollectShowWin, 0.3)-- 播放numberRoll
            self.theme.rTotalCollectLable:runAction(
                cc.Sequence:create(
                    cc.DelayTime:create(0.3),
                    cc.CallFunc:create(function ( ... )
                        self.theme.rTotalCollectLable:nrOverRoll()-- 停止滚动
                    end)))

            
        end),
		cc.DelayTime:create(10/30),
		cc.CallFunc:create(function ( ... )
			if bole.isValidNode(winJPAnim) then 
				winJPAnim:removeFromParent()
			end

			self:checkIsOverCollectAnim()
		end)
    ))
end

function bonusGame:respinOver()
    if self.flyParent then 
        self.flyParent:removeFromParent()
        self.flyParent = nil
        self.FlyliziNode = nil
        self.FlyliziNode2 = nil
    end

    self.theme.rTotalCollectAnim:removeAllChildren()

    for k, node in pairs(self.theme.rWinNodeList) do 
    	if bole.isValidNode(node.animNode) then 
    		node.animNode:removeAllChildren()
    	end
    end
    self.theme.respinWinSpineParent:removeAllChildren()
    self.theme.respinWinSpineParent:removeAllChildren()

    self.winRespinKuangAnimList = nil
	self.winGrandSpineList = nil

    
    if bole.isValidNode(self.collectWinDialog) then
        self.collectWinDialog:removeFromParent()
    end

    if self.ctl.freewin or self.theme.showFreeSpinBoard then
        self.theme:changeSpinBoard(SpinBoardType.FreeSpin)
        self.theme:hideBonusNode(true, false)
        -- 延迟播放bgm
        self.theme:runAction(cc.Sequence:create(cc.DelayTime:create(0.8),cc.CallFunc:create(function ( ... )
            self.theme:dealMusic_PlayFreeSpinLoopMusic()
        end))) 
    else
        self.theme:changeSpinBoard(SpinBoardType.Normal)
        self.theme:hideBonusNode(false, false)
        -- 延迟播放bgm
        self.theme:runAction(cc.Sequence:create(cc.DelayTime:create(0.8),cc.CallFunc:create(function ( ... )
            self.theme:dealMusic_PlayNormalLoopMusic()
        end))) 
    end

    self.theme.longLogoNode:setVisible(true)

    self.theme:outBonusStage() -- 恢复牌面 和 中奖两线
    -- 解锁jackpot meter
    self.theme:lockJackpotMeters(false)

    self.onlyBonusWin = 0
    self.respinWin = 0
    self.respinCollectShowWin = 0
end

function bonusGame:onRespinEnd()
	self.theme:showActivitysNode()

    self.ctl:onRespinOver()-- 激活spin按钮
    self.ctl.rets["theme_respin"] = nil
    self.ctl:collectCoins(1)-- 收钱

    self.theme.isInBonusGame = false
    self.theme.bonus = nil
    self.callback()
end

function bonusGame:showRespinCollectTotalDialog(ret)
	local csbPath = self.theme:getPic("csb/dialog_respin.csb")
	local dialog = cc.CSLoader:createNode(csbPath)
	local root = dialog:getChildByName("root")
	local showNode = root:getChildByName("node_collect")
	local labelNode = showNode:getChildByName("label_node")
	local labelCoins = labelNode:getChildByName("label_coins")
	local btn = showNode:getChildByName("btn_collect")
	local winNum = self.onlyBonusWin

    -- 显示弹窗
    self.theme.curScene:addToContentFooter(dialog)

    local _ ,s = self.theme:addSpineAnimation(showNode, -1, self.theme:getPic("spine/dialog/respin/respinjiesuan"), cc.p(0,0), "animation1", nil, nil, nil, true)
    s:runAction(cc.Sequence:create(
        cc.DelayTime:create(26/30),
        cc.CallFunc:create(function ( ... )
            bole.spChangeAnimation(s, "animation1_1", true)
        end)))

	self.theme:playNodeShowAction(labelNode, "scale", 6/30, 0.53, {{5/30, 1.07}, {7/30, 0.94}, {8/30, 1}})
	self.theme:playNodeShowAction(btn, "scale", 9/30, 0.53, {{5/30, 1.07}, {7/30, 0.94}, {8/30, 1}})

    local btnSize = btn:getContentSize()
    self.theme:addSpineAnimation(btn, nil, self.theme:getPic("spine/dialog/start"), cc.p(btnSize.width/2, btnSize.height/2), "animation", nil, nil, nil, true)
    
    self.theme:dialogPlayLineAnim("show", self.theme.featureDialogDimmer)
    self.theme:playMusic(self.theme.audio_list.bonus_end_show)

	local function parseValue( num)
		return FONTS.format(num, true)
	end
	bole.setSpeicalLabelScale(labelCoins, winNum, 390)
	inherit(labelCoins, LabelNumRoll)
	labelCoins:nrInit(0, 24, parseValue)
	labelCoins:nrStartRoll(0, winNum, 2)-- 播放numberRoll

	local clickEndFunction = function ( obj, eventType )
		if eventType == ccui.TouchEventType.ended then
			btn:setTouchEnabled(false)
			btn:removeAllChildren()

			labelCoins:nrOverRoll()-- 停止滚动
			self.theme:playMusic(self.theme.audio_list.common_click)

			dialog:runAction(cc.Sequence:create(
				cc.DelayTime:create(0.2),
				cc.CallFunc:create(function ( ... )
					self.theme:dialogPlayLineAnim("hide", self.theme.featureDialogDimmer, showNode) -- 关闭弹窗
					self.theme:playMusic(self.theme.audio_list.popup_out)
				end),
				cc.DelayTime:create(0.5),
				cc.CallFunc:create(function ()
					self:collectOverFunc()
				end),
				cc.RemoveSelf:create()
			))
		end
	end

	dialog:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(function ( ... )
			btn:addTouchEventListener(clickEndFunction)
		end),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function ( ... )
			labelCoins:nrOverRoll()-- 停止滚动
		end)
	))
end


function bonusGame:collectOverFunc( )
    if self.ctl.freewin then
        self.ctl.footer:changeLabelDescription("FS_Win")
    else
        -- 直接收集钱的操作 给用户加钱 播放动画 主要原因是因为 self.saveWin 设置的原因
        self.ctl.footer.isFreeSpin = false
        self.ctl.footer:changeLabelDescription("notFS_Win")
        self.saveWin = false
    end
    -- 在此之后断电重连就不用恢复了
    self.data["end_game"] = true
    self:saveBonus()

    self.theme.showReSpinBoard = false
    self.ctl.footer.isRespinLayer = false
    self.theme.lockedReels = nil

    if self.ctl.freespin and self.ctl.freespin < 1 then
        self.ctl.spin_processing = true
    end

    local overFunc = function ( ... )
        self.theme:runAction(cc.Sequence:create(
            -- cc.DelayTime:create(1),
            cc.CallFunc:create(function ( ... )
                self.theme:dealMusic_FadeLoopMusic(0.2, 1, 0.3)-- 降低背景音乐
                self.theme:playTransition(nil,"bonus")-- 转场动画
            end),
            cc.DelayTime:create(transitionDelay.bonus.onCover),-- 覆盖全屏的时间
            cc.CallFunc:create(function ()
                self:respinOver()
            end),
            cc.DelayTime:create(transitionDelay.bonus.onEnd - transitionDelay.bonus.onCover),-- 覆盖全屏的时间
            cc.CallFunc:create(function ()
                self:onRespinEnd()
            end)
        ))
    end
    self.ctl.isRespin = false -- 设置 变量 控制在返回base 庆祝赢钱的时候 stop 按钮 仅可以用来做暂停rollup 使用
    self.ctl.totalWin = self.respinWin - self.onlyBonusWin--  respin 里面庆祝银钱 这样做的原因是 respin 结束的时候 庆祝的是respin赢钱总金额 从base 或者free 的基础上进行 滚动

    self.ctl:startRollup(self.onlyBonusWin, overFunc) -- 向freeWin 里面 加钱在这里 自动进行
end


---@desc 小老虎机---------------------------------------------------------------------
function bonusGame:enterMapReSpinBonus(tryResume)
	self:initMapReSpinData()
    local function recoverSpin(tryResume2)
        local theDialog = WildAustraliaSlotGame.new(self.theme, self, self.theme:getPic("csb/"), self.data)
        theDialog:showSlotMachineScene(tryResume2)
    end
    local function recoverMap(tryResume3)
        self.theme:runAction(cc.Sequence:create(
                cc.DelayTime:create(1),
                cc.CallFunc:create(function()
                    local theDialog = WildAustraliaMapGame.new(self.theme, self.theme:getPic("csb/"), self.data)
                    theDialog:showMapScene(true)

                    self.theme:stopCollectPartAnimation()
                end),
                cc.DelayTime:create(1),
                cc.CallFunc:create(function()
                    self.data.isMapShow = true
                    self:saveBonus()
                    recoverSpin(tryResume3)
                end)
        ))
    end

    local function playIntro(...)
        recoverMap(false)
    end
    local function snapIntro(...)
        recoverSpin(true)
    end
    if self.data.isMapShow and tryResume then
        snapIntro()
    else
        playIntro()
    end
end

function bonusGame:initMapReSpinData()
	self.data.isMapShow = self.data.isMapShow or false
	self.data.lsSpinCount = self.data.lsSpinCount or 0
	self.data.mapLevel = self.theme.mapLevel or 1
	self.data.slotBet = self.data.core_data["map_ls_spin"]["avg_bet"]
	self.theme.superAvgBet = self.data.slotBet
	self:saveBonus()
	-- self.theme.mapSlot = true
end

function bonusGame:finishBonusGame()
    self.data["end_game"] = true
    self.theme.bonus = nil

    local bonusOver2 = function()
        self.theme:dealMusic_ExitBonusGame()

        if self.ctl:noFeatureLeft() then
            self.theme:enableMapInfoBtn(true)
        end
        if self.callback then
            self.callback()
        end
        self.theme.isInBonusGame = false
    end
    self.theme:showActivitysNode()

-- self.bonusType == BonusGameType.MapFree

    if self.bonusType == BonusGameType.Respin then
        local winMoney = self.data.core_data.respin_bonus.respin_total_win
        local winJp = 0
        local jpList = self.data.core_data.respin_bonus.win_jp

        if jpList and #jpList > 0 then
            for key, jp_item in ipairs(jpList) do
                winJp = winJp + jp_item .jp_win
            end
        end
        self.bonusWin = winJp + winMoney

        self.ctl.footer.isRespinLayer = false

        self.ctl:onRespinOver()
    elseif self.bonusType == BonusGameType.MapSlot then
        self.bonusWin = self.data.core_data["map_ls_spin"]["total_win"]

        self.ctl.footer.isRespinLayer = false
        self.ctl:onRespinOver()
    end

    if self.bonusWin then
        self.ctl:startRollup(self.bonusWin, bonusOver2)
    else
        self:bonusOver2()
    end
end
function bonusGame:recoverBaseGame()
    self.theme.themeAnimateKuang:removeAllChildren()
    self.ctl.spinning = false
    self.theme:showAllItem()

    if self.ctl.freewin then
        -- 切换滚轴回 free
        self.theme:hideBonusNode(true, false)
        self.theme:stopDrawAnimate()
        self.theme:changeSpinBoard(SpinBoardType.FreeSpin)
        self.ctl:adjustWithFreeSpin()
        self.ctl.footer.isFreeSpin = true
    else
        if self.theme.superAvgBet then
            self.ctl.footer:changeNormalLayout2()
        else
            self.ctl.footer:changeNormalLayout()
        end
        self.theme:changeSpinBoard(SpinBoardType.Normal)
        -- 切换滚轴回 base
        self.theme:hideBonusNode(false, false)
        self.ctl.footer.isFreeSpin = false
    end
    self.theme:outBonusStage()
    if self.showFreeSpinBoard or self.ctl.freewin then
        self.ctl.footer:changeLabelDescription("FS_Win")
        if not self.theme.superAvgBet then
            self.theme:showActivitysNode()
        end
    else
        self.ctl.footer.isFreeSpin = false
        self.ctl.footer:changeLabelDescription("notFS_Win")
        self.saveWin = false
        self.theme:showActivitysNode()

    end

    self.theme:lockJackpotMeters(false)

    self.theme.lockedReels = nil
    -- 播放背景音乐

    if self.ctl:noFeatureLeft() then
        self.theme.superAvgBet = nil
        self.ctl:removePointBet()
    else
        self.theme.remainPointBet = true
    end
end


------------------------------------MapRespin相关-----------------------------------
WildAustraliaSlotGame = class("WildAustraliaSlotGame", CCSNode)
local paytableValueList = { 12500000, 100000, 62500, 30000, 37500, 30000, 20000, 10000 }
local slotMGame = WildAustraliaSlotGame
function slotMGame:ctor(theme, bonusTheme, csbPath, data)
    --todo  small slots
    self.theme = theme
    self.bonusTheme = bonusTheme
    self.csb = csbPath .. "slot_machine_portrait_3x1.csb"
    self.data = data
    self.theme.slotBonus = self
    self.ctl = self.bonusTheme.ctl
    self.avgBet = self.data.slotBet
    CCSNode.ctor(self, self.csb)
end
function slotMGame:loadControls()
    self.dimmer = self.node:getChildByName("dimmer_node")
    self.dimmer:setVisible(false)
    self.reelRoot = self.node:getChildByName("Node_root_node")
    self.triggerNode = self.node:getChildByName("popup_trigger_node")
    self.triggerNode:setVisible(false)
    self.btn_start = self.triggerNode:getChildByName("btn_start")
    self.startPopWindowAniNode = self.triggerNode:getChildByName("popup_window_ani_node")
    self.collectNode = self.node:getChildByName("popup_collect_node")
    self.collectNode:setVisible(false)
    self.label_win = self.collectNode:getChildByName("label_mapSlotWin")
    inherit(self.label_win, LabelNumRoll)
    local function fontFormat(num)
        return FONTS.formatByCount4(num, 15, true)
    end

    self.label_win:nrInit(0, 25, fontFormat)
    self.btn_collect = self.collectNode:getChildByName("btn_collect")
    self.collectPopWindowAniNode = self.collectNode:getChildByName("popup_window_ani_node")
    self.slotRespinData = tool.tableClone(self.data.core_data["map_ls_spin"]["theme_respin"])
    self.allSpinCounts = #self.slotRespinData
    self.spinCount = self.data.lsSpinCount
    self.totalWin = self.data.core_data["map_ls_spin"]["total_win"]
    self.slotTransitionDimmer = self.node:getChildByName("tansition_dimmer")
    self.slotTransitionDimmer:setVisible(false)
    self.reelDimmerNode = self.node:getChildByName("reelDimmerNode")
    self.reelDimmerNode:setVisible(false)
    self.symbolAniNode = self.node:getChildByName("symbol_ani_node")
    self.symbolAniNodeList = {}
    self.paytableListNode = self.node:getChildByName("paytable_list")
    self.paytableLabels = {}
    for i = 1, 8 do
        self.paytableLabels[i] = self.paytableListNode:getChildByName("label" .. i)
        local value = paytableValueList[i] * self.avgBet / 5000
        self.paytableLabels[i]:setString(FONTS.formatByCount4(value, 5, true))
    end

    self.bg_root = self.node:getChildByName("background")
    self.bg_lightAniNode = self.bg_root:getChildByName("bg_light_ani_node")
end

function slotMGame:setData(...)

    self.boardRootThemeZorder = self.theme.boardRoot:getLocalZOrder()
    self.animateNodeThemeZorder = self.theme.animateNode:getLocalZOrder()
    bole.changeParent(self.theme.boardRoot, self.reelRoot, self.boardRootThemeZorder)
    bole.changeParent(self.theme.animateNode, self.reelRoot, self.animateNodeThemeZorder)
end

function slotMGame:showSlotMachineScene(tryResume)
    self.theme:changeSpinBoard(SpinBoardType.Map_ReSpin)
    if self.theme.superAvgBet then
        self.ctl:setPointBet(self.theme.superAvgBet)-- 更改 锁定的bet
        self.ctl.footer:isShowTotalBetLayout(false)-- 隐藏掉  footer bet
    end
    self.theme.mapSlotMachineSceneNode:addChild(self) -- todo 放一个节点
    self:showBgAnimation()
    self.ctl.rets = self.ctl.rets or {}
    local function playIntro()
        self:setData()
        self.ctl.rets["theme_respin"] = tool.tableClone(self.data.core_data["map_ls_spin"]["theme_respin"])

        self:setBoard()
        self.ctl.spinning = false
    end

    local function snapIntro()
        self.theme:stopAllLoopMusic()
        local function recoverSpin()
            self:setData()
            if self.bonusTheme.data.lsSpinCount > 1 then
                self.bonusTheme.data.lsSpinCount = self.bonusTheme.data.lsSpinCount - 1
                self.bonusTheme:saveBonus()
            end

            local showItemList = {}
            if self.bonusTheme.data.lsSpinCount == 0 then
                for i = 1, 3 do
                    showItemList[i] = { math.random(102, 109) }
                end
            else
                showItemList = self.slotRespinData[self.bonusTheme.data.lsSpinCount + 1]
            end
            local x, y = self.theme.boardRoot:getPosition()
            for i = 1, 3 do

                local cell = self.theme.spinLayer.spins[i]:getRetCell(1)
                local key = showItemList[i][1]
                local x, y = cell:getPosition()

                self.theme:updateCellSprite(cell, key, i, 1)
            end

            if self.allSpinCounts > 1 and self.bonusTheme.data.lsSpinCount > 0 then

                local removeCount = self.bonusTheme.data.lsSpinCount

                self.ctl.rets["theme_respin"] = tool.tableClone(self.data.core_data["map_ls_spin"]["theme_respin"])
                for i = 1, removeCount do
                    table.remove(self.ctl.rets["theme_respin"], 1)
                end
            else
                self.ctl.rets["theme_respin"] = tool.tableClone(self.data.core_data["map_ls_spin"]["theme_respin"])
            end

            self.theme:laterCallBack(1, function()
                self.ctl:handleResult()
            end)

        end

        local function recoverCollect(...)
            self:setData()
            local showItemList = self.slotRespinData[#self.slotRespinData]
            for i = 1, 3 do
                local cell = self.theme.spinLayer.spins[i]:getRetCell(1)
                local key = showItemList[i][1]
                self.theme:updateCellSprite(cell, key, i, 1)
            end
            self:onRespinFinish(nil, false)
        end

        if self.allSpinCounts == self.bonusTheme.data.lsSpinCount then
            recoverCollect()
        else
            recoverSpin()
        end
    end

    if tryResume then

        snapIntro()
        --end

    else

        playIntro()
    end
end

function slotMGame:showBgAnimation()
    local file = self.theme:getPic("spine/map_slot/bg_light/spine")
    self.theme:addSpineAnimation(self.bg_lightAniNode, nil, file, cc.p(0, -57), "animation", nil, nil, nil, true, true, nil)
end

function slotMGame:setBoard(item_list)
    local item_list = item_list or {}
    if #item_list == 0 then
        for i = 1, 3 do
            item_list[i] = { math.random(102, 109) }
        end
    end
    for i = 1, 3 do
        local cell = self.theme.spinLayer.spins[i]:getRetCell(1)
        local x, y = cell:getPosition()
        local key = item_list[i][1]
        self.theme:updateCellSprite(cell, key, i, 1)
    end
end

function slotMGame:showStartPopUpWindow()
    self.theme:stopAllLoopMusic()
    self.triggerNode:setScale(0)
    self.triggerNode:setVisible(true)
    self:showPopUpWindowEffect("start")
    self:runAction(cc.Sequence:create(
            cc.DelayTime:create(0.5),
            cc.CallFunc:create(function()
                local startBtnFile = self.theme:getPic("spine/map_slot/btn_start/spine")
                self.theme:addSpineAnimation(self.btn_start, nil, startBtnFile, cc.p(149, 45.5), "animation", nil, nil, nil, true, true, nil)
                self.triggerNode:runAction(cc.Sequence:create(
                        cc.ScaleTo:create(0.25, 1.3, 1.3),
                        cc.ScaleTo:create(0.15, 1, 1)
                ))
                self.theme:playMusic(self.theme.audio_list.slot_popup)
                self.dimmer:setOpacity(0)
                self.dimmer:setVisible(true)
                self.dimmer:runAction(cc.FadeIn:create(0.2))
            end),
            cc.DelayTime:create(0.35),
            cc.CallFunc:create(function()
                self.btn_start:setBright(true)
                self.btn_start:setTouchEnabled(true)
                self:initStartEvent()
            end)
    ))
end

function slotMGame:initStartEvent()
    -- 点击按钮
    local pressFunc = function(obj)

        self.bonusTheme.data.start_dialog = true
        self.bonusTheme:saveBonus()
        self.btn_start:setTouchEnabled(false)
        self.btn_start:setBright(false)

        self.btn_start:removeAllChildren()
        -- 播放点击音乐
        self.theme:playMusic(self.theme.audio_list.common_click)
        self:runAction(cc.Sequence:create(
                cc.CallFunc:create(function()
                    self.triggerNode:setScale(1)
                    self.triggerNode:runAction(cc.Sequence:create(
                            cc.ScaleTo:create(0.15, 1.3, 1.3),
                            cc.ScaleTo:create(0.25, 0, 0)
                    ))
                    self.dimmer:setOpacity(255)
                    self.dimmer:runAction(cc.FadeOut:create(0.3))
                end),
                cc.DelayTime:create(0.35),
                cc.CallFunc:create(function(...)
                    self.startPopWindowAniNode:removeAllChildren()
                    self.ctl:handleResult()
                end)
        ))

    end

    local function onTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            pressFunc(obj)
        end
    end

    -- 设置按钮
    self.btn_start:addTouchEventListener(onTouch)
end

function slotMGame:drawWinLineSymbols()
    self.reelDimmerNode:setVisible(true)
    local winList = self.slotRespinData[#self.slotRespinData]
    for i = 1, 3 do
        local key = winList[i][1]
        self.symbolAniNodeList[i] = cc.Node:create()
        local pos = self.theme:getCellPos(i, 1)
        self.symbolAniNodeList[i]:setPosition(pos)
        self.symbolAniNode:addChild(self.symbolAniNodeList[i])
        local theCellFile = self.theme.pics[key]
        local theCellSprite = bole.createSpriteWithFile(theCellFile)
        self.symbolAniNodeList[i]:addChild(theCellSprite)
        self:playSymbolAnimation(self.symbolAniNodeList[i], key)
    end

    self.theme:playMusic(self.theme.audio_list.slot_win)

    self.symbolAniNode:runAction(cc.Repeat:create(cc.Sequence:create(
            cc.DelayTime:create(0.3),
            cc.CallFunc:create(function()
                self.symbolAniNode:setVisible(false)
            end),
            cc.DelayTime:create(0.3),
            cc.CallFunc:create(function(...)
                self.symbolAniNode:setVisible(true)
            end)

    ), 9))
end

function slotMGame:playSymbolAnimation(parent, key)

    local file = self.theme:getPic("spine/map_slot/symbols/" .. key .. "/spine")
    local _, s = self.theme:addSpineAnimation(parent, 5, file, cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)

end

function slotMGame:showCollectPopUpWindow()
    self.collectNode:setScale(0)
    self.collectNode:setVisible(true)
    self.ctl.footer:setSpinButtonState(true) -- 禁用spin 按钮
    self:showPopUpWindowEffect("collect")
    self:runAction(cc.Sequence:create(
            cc.DelayTime:create(0.5),
            cc.CallFunc:create(function()
                local rollupDuration = 3
                self.label_win:nrStartRoll(0, self.totalWin, rollupDuration)
                self.theme:stopMusic(self.theme.audio_list.win_rollUp)
                self.theme:playMusic(self.theme.audio_list.win_rollUp, true)
                local collectBtnFile = self.theme:getPic("spine/map_slot/btn_collect/spine")
                self.theme:addSpineAnimation(self.btn_collect, nil, collectBtnFile, cc.p(149, 45.5), "animation", nil, nil, nil, true, true, nil)
                self.collectNode:runAction(cc.Sequence:create(
                        cc.ScaleTo:create(0.25, 1.3, 1.3),
                        cc.ScaleTo:create(0.15, 1, 1)
                ))
                self.theme:playMusic(self.theme.audio_list.slot_popup)
                self.dimmer:setOpacity(0)
                self.dimmer:setVisible(true)
                self.dimmer:runAction(cc.FadeIn:create(0.2))
            end),
            cc.DelayTime:create(0.35),
            cc.CallFunc:create(function()
                self.btn_collect:setBright(true)
                self.btn_collect:setTouchEnabled(true)
                self:initCollectEvent()
                -- 在此之后断电重连就不用恢复了

                -- 收钱
            end)
    ))

end

function slotMGame:initCollectEvent(...)
    -- 点击按钮
    local pressFunc = function(obj)
        self.bonusTheme.ctl:collectCoins(1)
        self.bonusTheme.data["end_game"] = true
        self.bonusTheme:saveBonus()
        self.btn_collect:setTouchEnabled(false)
        self.btn_collect:setBright(false)
        self.btn_collect:removeAllChildren()
        -- 播放点击音乐
        self.theme:playMusic(self.theme.audio_list.common_click)
        self:runAction(cc.Sequence:create(
                cc.CallFunc:create(function(...)
                    self.label_win:nrStopRoll()
                    self.theme:stopMusic(self.theme.audio_list.win_rollUp)
                    self.label_win:setString(FONTS.formatByCount4(self.totalWin, 15, true))

                end),
                cc.DelayTime:create(0.3),
                cc.CallFunc:create(function()
                    self.collectNode:setScale(1)
                    self.collectNode:runAction(cc.Sequence:create(
                            cc.ScaleTo:create(0.15, 1.3, 1.3),
                            cc.ScaleTo:create(0.25, 0, 0)
                    ))
                    self.dimmer:setOpacity(255)
                    self.dimmer:runAction(cc.FadeOut:create(0.3))
                end),
                cc.DelayTime:create(0.35),
                cc.CallFunc:create(function(...)
                    self.collectPopWindowAniNode:removeAllChildren()
                    self:exitSlotMachineScene()
                end)
        ))

    end

    local function onTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            pressFunc(obj)
        end
    end

    -- 设置按钮
    self.btn_collect:addTouchEventListener(onTouch)
end

function slotMGame:showPopUpWindowEffect(windowType)
    local parent
    if windowType == "start" then
        parent = self.startPopWindowAniNode
    elseif windowType == "collect" then
        parent = self.collectPopWindowAniNode
    end

    local file = self.theme:getPic("spine/map_slot/popup_window/spine")
    self.theme:addSpineAnimation(parent, nil, file, cc.p(0, -20), "animation", nil, nil, nil, true, true, nil)
end

function slotMGame:onRespinStart(...)
    self.bonusTheme.data.lsSpinCount = self.bonusTheme.data.lsSpinCount + 1
    self.bonusTheme:saveBonus()
    self.theme:stopMusic(self.theme.audio_list.slot_spin)
    self.theme:playMusic(self.theme.audio_list.slot_spin, true)
end

function slotMGame:onMapRepsinAllReelStop()
    self.theme:stopMusic(self.theme.audio_list.slot_spin)
end

function slotMGame:onRespinFinish(ret, isAnimate)
    local animationTime = 0
    if isAnimate then
        animationTime = 4.5
    end
    self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function()
                if isAnimate then
                    self:drawWinLineSymbols()
                end
            end),
            cc.DelayTime:create(animationTime),
            cc.CallFunc:create(function()
                self:showCollectPopUpWindow()
            end)
    ))

end

function slotMGame:playDimmerTransitionIn()
    self.slotTransitionDimmer:setOpacity(0)
    self.slotTransitionDimmer:setVisible(true)
    self.slotTransitionDimmer:runAction(cc.FadeIn:create(0.2))
end

function slotMGame:exitSlotMachineScene(...)
    self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function()
                self:playDimmerTransitionIn()
            end),
            cc.DelayTime:create(0.2),
            cc.CallFunc:create(function()
                ---- 切换滚轴回 base
                self.ctl.footer.isRespinLayer = false
                self.theme:hideBonusNode(false, false)
                bole.changeParent(self.theme.boardRoot, self.theme.boardAniParent, self.boardRootThemeZorder)
                bole.changeParent(self.theme.animateNode, self.theme.boardAniParent, self.animateNodeThemeZorder)
                self.theme.mapPoints = 0
                self.theme:setNextCollectTargetImage(self.theme.mapLevel)

                self.theme:setCollectProgressImagePos(0)
                self.ctl.rets["theme_respin"] = nil
                -- self.theme.mapSlot = nil
                --self.theme:playDimmerTransition("FadeOut", 0.2)
                self.bonusTheme:recoverBaseGame()
                self.bonusTheme:finishBonusGame()
            end),
            cc.RemoveSelf:create()
    ))
end
------------------------------------Map start---------------------------------------
WildAustraliaMapGame = class("WildAustraliaMapGame", CCSNode)
local MapGame = WildAustraliaMapGame

local buildingLevel = Set({ 3, 7, 12, 18, 25, 33 })

local mapShowPos = cc.p(0, -420)
local mapHidePos = cc.p(0, 1280)
local mapTopShowPos = cc.p(0, 0)
local mapTopHidePos = cc.p(0, 1700)
local userStartPos = cc.p(-214, 230)

local mapSpineConfig = {
    map_user = "spine/map/ds_xh", 
    map_small = "spine/map/xjd_xh_dl_01", --
    map_big1 = "spine/map/yzs_01",
    map_big2 = "spine/map/juxi_01",
    map_big3 = "spine/map/ying_01",
    map_big4 = "spine/map/yegou_01",
    map_big5 = "spine/map/xiongtou_01",
    map_big6 = "spine/map/daishu_01",
    moveToBig = "spine/map/xzdjd_01", -- 到达大节点
}

function MapGame:ctor(theme, csbPath, data)
    self.theme = theme
    self.csbPath = csbPath
    self.csb = csbPath .. "map.csb"
    self.data = data
    CCSNode.ctor(self, self.csb)
    if self.data.core_data then
        self.bonusType = self.data.core_data["type"]
    end
    self.mapLevel = self.theme.mapLevel
    if self.theme.mapPoints >= maxMapPoints and self.mapLevel == 0 then
        self.mapLevel = maxMapLevel
    end
end

function MapGame:loadControls()
    self.dimmer = self.node:getChildByName("dimmer_node")
    self.dimmer:setVisible(false)

    self.root = self.node:getChildByName("root")
    self.root_child = self.root:getChildByName("root_child")
    local mapPanel = self.root_child:getChildByName("bg_panel")
    mapPanel:setScrollBarEnabled(false)
    self.mapContainerNode = mapPanel
    local tempNumber = 1000 * (1 - FRAME_WIDTH / DESIGN_WIDTH)
    self.mapContainerNode:setContentSize(cc.size(self.mapContainerNode:getContentSize().width, self.mapContainerNode:getContentSize().height - tempNumber))

    self.mapBG = mapPanel:getChildByName("map_bg")
    self.mapNode = self.mapBG:getChildByName("map_node")
    self.mapBaseNpde = self.mapNode:getChildByName("base_node")

    self.mapTopNpde = self.root_child:getChildByName("kuang_node")

    self.buttonNode = self.root_child:getChildByName("btn_node")
    self.btn_back = self.buttonNode:getChildByName("btn")
    self.buttonNode:setScale(0)
    self.buttonNode:setVisible(false)
    

    self.bg_aniNode = self.mapNode:getChildByName("bg_ani_node")
    self.bg_aniNode:setPosition(cc.p(0, 0))
    -- self.bg_aniNode:setScale(0.5)

    self.mapSpineNode = self.mapNode:getChildByName("spine_node")
    -- self.mapSpineNode:setScale(0.5)

    local _, usp = bole.addSpineAnimation(self.mapSpineNode, nil, self.theme:getPic(mapSpineConfig["map_user"]), cc.p(0, 0), "animation1", nil, nil, nil, true, true)
    self.userIcon = usp

    self.stepList = {}

    local big_index = 1
    for i = 1, maxMapLevel do
        self.stepList[i] = {}
        if buildingLevel[i] then
            self.stepList[i].node = self.mapBaseNpde:getChildByName("step" .. i .. "_big")

            local aniNode = cc.Node:create()
            self.stepList[i].node:addChild(aniNode, -1)
            self.stepList[i].aniNode = aniNode
            local ani = "animation1"
            local _, s = bole.addSpineAnimation(aniNode, nil, self.theme:getPic(mapSpineConfig["map_big"..big_index]), cc.p(0, -120), ani, nil, nil, nil, true, true)
            self.stepList[i].aniSpine = s
            s.index = big_index

            big_index = big_index + 1
        else
            self.stepList[i].node = self.mapBaseNpde:getChildByName("step" .. i)
            self.stepList[i].dim = self.stepList[i].node:getChildByName("dim")
            local ani_node = cc.Node:create()
            self.stepList[i].node:addChild(ani_node)
            self.stepList[i].aniNode = ani_node
        end
    end

end

function MapGame:getContainerPosY(step_index)
    local step_index = step_index or 1
    local offset = 0

    if self.stepList[step_index] and bole.isValidNode(self.stepList[step_index].node) then
        local sizex = self.mapContainerNode:getContentSize().height - self.mapContainerNode:getInnerContainerSize().height
        offset = self.mapContainerNode:getContentSize().height / 2 - self.stepList[step_index].node:getPositionY()
        if offset > 0 then
            offset = 0
        elseif offset < sizex then
            offset = sizex
        end
    end

    return offset
end

function MapGame:setMapPosition(step_index)
    step_index = step_index > 0 and step_index or 1
    local posy = self:getContainerPosY(step_index)
    local container_node = self.mapContainerNode:getInnerContainer()
    local posx = container_node:getPositionX()
    container_node:setPosition(cc.p(posx, posy))
end

function MapGame:showMapForwardPosition(next_index)
    if next_index == 0 or next_index - 1 == 0 then
        return
    end
    local mapIndex = next_index - 1
    local container_node = self.mapContainerNode:getInnerContainer()
    self:setMapPosition(next_index - 1)
    local posY = self:getContainerPosY(next_index)
    local posX = container_node:getPositionX()

    container_node:runAction(cc.MoveTo:create(0.2, cc.p(posX, posY)))
end

function MapGame:setUserIconPosition(index)
	local pos = userStartPos
	if index > 0 then 
		pos = cc.p(self.stepList[index].node:getPosition())
	end
	if index+1 <= maxMapLevel and self.stepList[index+1] and bole.isValidNode(self.stepList[index+1].node) then 
		if pos.x > self.stepList[index+1].node:getPositionX() then 
			self.userIcon:setScaleX(-1)
		end
	end
	self.userIcon:setPosition(pos)
end

function MapGame:showUserIconForwardPosition(next_index)
	local start_pos = (next_index - 1) == 0 and userStartPos or cc.p(self.stepList[next_index-1].node:getPosition())
	local pos = cc.p(self.stepList[next_index].node:getPosition())
	self.userIcon:setPosition(start_pos)

	if start_pos.x > pos.x then 
		self.userIcon:setScaleX(-1)
	end

	local animName = buildingLevel[next_index] and "animation3" or "animation2"
	bole.spChangeAnimation(self.userIcon, animName)
	self.userIcon:runAction(cc.Sequence:create(
		cc.MoveTo:create(10/30, pos),
		cc.DelayTime:create(10/30),
		cc.CallFunc:create(function ( ... )
			bole.spChangeAnimation(self.userIcon, "animation1")
		end)))

	self.theme:playMusic(self.theme.audio_list.move)
end


function MapGame:showMapScene(isAnimate)
    --self.theme.isShowMap = true
    -- 隐藏B级活动栏
    self.theme:hideActivitysNode()
    self.theme.isOpenStoreNode = true

    local duration1 = 0.15
    local duration2 = 0.35
    local showBtnDelay = 0.35

    if isAnimate then
        showBtnDelay = 0
        self:setMapPosition(self.mapLevel - 1)
        self:setUserIconPosition(self.mapLevel-1)
    else
        -- 暂停主题
        --bole.pauseTheme()
        self.theme:setFooterBtnsEnable(false)
        self:showIdleAnimation()
        self:setMapPosition(self.mapLevel)
        self:setUserIconPosition(self.mapLevel)
    end

    self.theme.ctl.curScene:addToContentFooter(self, 999)
    if HEADER_FOOTER_SCALE_H < 1 then
        bole.adaptBackground(self.root)
    end
    bole.adaptReelBoard(self.root)
    
    self.mapContainerNode:setPosition(mapHidePos)
    self.mapTopNpde:setPosition(mapTopHidePos)

    self:setData(self.mapLevel, isAnimate)

    local function initBackBtnEvent(...)
        -- 点击按钮
        local pressFunc = function(obj)
            self.btn_back:setTouchEnabled(false)
            self.btn_back:setBright(false)
            -- 播放点击音乐
            self.theme:playMusic(self.theme.audio_list.common_click)

            self:exitMapScene()

        end

        local function onTouch(obj, eventType)
            if eventType == ccui.TouchEventType.ended then
                pressFunc(obj)
            end
        end

        -- 设置按钮
        self.btn_back:addTouchEventListener(onTouch)
    end
    local function showBackGameBtn()
        self.buttonNode:setScale(0)
        self.buttonNode:setVisible(true)
        self.buttonNode:runAction(cc.Sequence:create(
                cc.ScaleTo:create(0.2, 1.5, 1.5),
                cc.ScaleTo:create(0.15, 1, 1)
        ))
    end

    self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function()
                self.dimmer:setOpacity(0)
                self.dimmer:setVisible(true)
                self.dimmer:runAction(cc.FadeIn:create(0.3))
                self.theme:playMusic(self.theme.audio_list.map_open)
            end),
            cc.DelayTime:create(duration1 + 0.1),
            cc.CallFunc:create(function(...)
                self.mapContainerNode:runAction(cc.MoveTo:create(duration2, mapShowPos))
                self.mapTopNpde:runAction(cc.MoveTo:create(duration2, mapTopShowPos))
            end),
            cc.DelayTime:create(duration2 + 0.1),
            cc.CallFunc:create(function(...)
                self.mapContainerNode:setPosition(mapShowPos)
                if not isAnimate then
                    showBackGameBtn()
                end
            end),
            cc.DelayTime:create(showBtnDelay),
            cc.CallFunc:create(function()
                if isAnimate then
                    self:showIncreaseAnimation()
                else
                    self.btn_back:setTouchEnabled(true)
                    initBackBtnEvent()
                end
            end)
    ))
end

function MapGame:showIncreaseAnimation(...)
    local bgAniDelay = 0.2
    if self.mapLevel >= 1 then
        bgAniDelay = 20 / 30
        -- if buildingLevel[self.mapLevel] then
        --     self.theme:playMusic(self.theme.audio_list.map_node)
        -- end
        -- if not buildingLevel[self.mapLevel] then
        --     self.theme:playMusic(self.theme.audio_list.map_move)
        -- end
    end

    self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function(...)
            	-- self:showUserIconForwardPosition(self.mapLevel)
                -- self:showMapForwardPosition(self.mapLevel)
            end),
            cc.DelayTime:create(bgAniDelay),
            cc.CallFunc:create(function()

                if buildingLevel[self.mapLevel] then
                    self:lightingBigBuild(self.mapLevel)
                    self.theme:playMusic(self.theme.audio_list.map_node)
                end

                if not buildingLevel[self.mapLevel] then
                    -- self:lightingSmallHeart(self.mapLevel)
                    -- self.theme:playMusic(self.theme.audio_list.map_move)
                end
            end),
            -- cc.DelayTime:create(0.5),
            -- cc.CallFunc:create(function()
            --     if not buildingLevel[self.mapLevel] then
            --         self:lightingSmallHeart(self.mapLevel)
            --     end
            -- end),
            cc.DelayTime:create(1),
            cc.CallFunc:create(function()
                self:exitMapScene(true)
            end)
    ))
end
function MapGame:lightingBigBuild(level)
	local aniNode = self.stepList[level].aniNode
	bole.addSpineAnimation(aniNode, nil, self.theme:getPic(mapSpineConfig.moveToBig), cc.p(0, -120), "animation")

    local aniSpine = self.stepList[level].aniSpine
    local aniName1 = "animation"
    bole.spChangeAnimation(aniSpine, aniName1, true)
end
function MapGame:lightingSmallHeart(level)
    local aniNode = self.stepList[level].aniNode
    bole.updateSpriteWithFile(self.stepList[self.mapLevel].dim, "#theme192_map_c1.png") -- self.stepList[level].dim:setVisible(false)
    local aniName1 = "animation1"
    local aniName2 = "animation2"
    local _, s2 = bole.addSpineAnimation(aniNode, nil, self.theme:getPic(mapSpineConfig.map_small), cc.p(0, 0), aniName1, nil, nil, nil, true, false)
    local aniSpine = s2
    aniSpine:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(
			function()
				bole.spChangeAnimation(aniSpine, aniName2, true)
			end
		)))
end
function MapGame:showIdleAnimation(...)

    if self.mapLevel == 0 then
        return
    end
    if buildingLevel[self.mapLevel] then
        self:showIdleBig()
    else
        self:showIdleSmall()
    end
end
function MapGame:showIdleSmall()
    local aniName = "animation2"
    local parent = self.stepList[self.mapLevel].aniNode
    local file = self.theme:getPic(mapSpineConfig.map_small)
    local _, s = self.theme:addSpineAnimation(parent, nil, file, cc.p(0, 0), aniName, nil, nil, nil, true, true, nil)

    bole.updateSpriteWithFile(self.stepList[self.mapLevel].dim, "#theme192_map_c1.png")
end
function MapGame:showIdleBig()
    local aniSpine = self.stepList[self.mapLevel].aniSpine
    local aniName1 = "animation"
    bole.spChangeAnimation(aniSpine, aniName1, true)
end
function MapGame:setData(level, isAnimate)
    if isAnimate then
        level = level - 1
    end

    if level < 0 then
        level = 0
    end

    if level > 0 then
        for i = 1, level do
            if i < level or isAnimate then
                if buildingLevel[i] then
                    local aniSpine = self.stepList[i].aniSpine
                    local aniName1 = "animation1"
                    bole.spChangeAnimation(aniSpine, aniName1, false)
                else
                    bole.updateSpriteWithFile(self.stepList[i].dim, "#theme192_map_c1.png")
                end
            end
        end
    end
end

function MapGame:exitMapScene(isAnimate)
    --self.theme.isShowMap = false

    self.theme.isOpenStoreNode = false

    -- 恢复主题
    --bole.resumeTheme()
    local duration1 = 0.15
    local duration2 = 0.35
    local hideBtnDelay = 0.3

    if isAnimate then
        hideBtnDelay = 0
        self.mapContainerNode:stopAutoScroll()
    else
        self.theme:showActivitysNode()
        self.theme:setFooterBtnsEnable(true)
    end

    local function hideBackGameBtn()
        self.buttonNode:setScale(1)
        self.buttonNode:setVisible(true)
        self.buttonNode:runAction(cc.Sequence:create(
                cc.ScaleTo:create(0.15, 1.5, 1.5),
                cc.ScaleTo:create(0.2, 0, 0)
        ))
    end

    self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function(...)
                if not isAnimate then
                    hideBackGameBtn()
                end
            end),
            cc.DelayTime:create(hideBtnDelay),
            cc.CallFunc:create(function(...)
                self.theme:playMusic(self.theme.audio_list.map_close)
                self.mapContainerNode:runAction(cc.MoveTo:create(duration2, mapHidePos))
                self.mapTopNpde:runAction(cc.MoveTo:create(duration2, mapTopHidePos))
            end),
            cc.DelayTime:create(duration2),
            cc.CallFunc:create(function(...)
                self.dimmer:setOpacity(255)
                self.dimmer:setVisible(true)
                self.dimmer:runAction(cc.FadeOut:create(duration1))
            end),
            cc.DelayTime:create(duration1),
            cc.CallFunc:create(function(...)
                if isAnimate then
                    if buildingLevel[self.mapLevel] then
                    else
                        if self.theme.slotBonus then
                            self.theme.slotBonus:showStartPopUpWindow()
                        end

                    end
                else
                    -- self.theme:enableMapInfoBtn(true)
                end
                self.theme:closeStoreNode()
            end),
            cc.RemoveSelf:create()
    ))
end

------------------------------------Map end-----------------------------------------



return ThemeWildAustralia
