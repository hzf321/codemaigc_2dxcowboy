--Author:wanghongjie art:许铮 math:tq  策划:静茹
--Email:wanghongjie@bolegames.com
--2020年4月23日 11:00
--Using:主题 188雷神

ThemeZeus = class("ThemeZeus", Theme)
local cls = ThemeZeus

-- 资源异步加载相关
cls.plistAnimate = {
	"image/plist/symbol",
	"image/plist/base",
}

cls.csbList = {
	"csb/base.csb",
}

local transitionDelay = {
	["free"] 	= {["onCover"] = 25/30,["onEnd"] = 45/30}, -- 雷神
	["bonus"] 	= {["onCover"] = 35/30,["onEnd"] = 47/30}, -- 圣杯
}

local SpinBoardType = {
	Normal 		= 1,
	FreeSpin 	= 2,
	Bonus 		= 3,
}

local BonusGameType = { -- type1对应repsin type2对应 deal game type3对应 level
	["level"] 	= 1,
	["deal"] 	= 2,
}

local moveWildTime = 1

local specialSymbol = {["scatter"] = 8, ["wild"] = 1, ["blank"] = 9, ["zeus"] = 2}
local dialogShowOrHideTime = 0.5
-------------- movewild 相关
local wildPosConfig = {
    [1] = {1,1}, [2] = {1,2}, [3] = {1,3}, [4] = {1,4}, [5] = {2,1}, [6] = {2,2}, [7] = {2,3}, [8] = {2,4}, [9] = {3,1}, [10] = {3,2}, 
    [11] = {3,3}, [12] = {3,4}, [13] = {4,1}, [14] = {4,2}, [15] = {4,3}, [16] = {4,4}, [17] = {5,1}, [18] = {5,2}, [19] = {5,3}, [20] = {5,4}
}
local baseColCnt = 5
local masterAddPos = 100

local singleColPosConfig = {
	[1] = {1, 6, 11, 16},
	[2] = {2, 7, 12, 17},
	[3] = {3, 8, 13, 18},
	[4] = {4, 9, 14, 19},
	[5] = {5, 10, 15, 20},
}

------------  map 相关参数  -------------
local lockFeatureAnimName = "lock" -- 收集解锁相关
local openFeatureAnimName = "unlock"
local idleFeatureAnimName = "idle"
local collectFeatureAnimName = "collect"
local maxMapPoints 	= 100
local maxMapLevel 	= 26
local maxCollectProgress = 585
local progressStartPosX = 0
local progressPosY = 50
local movePerUnit = maxCollectProgress/maxMapPoints
local tipType = {
	["normal"] = 1, -- 正常点击
	["isOver"] = 2, -- 完成一遍地图
}
local collectFlyEndPos = cc.p(55, 607.5)
local flyToUpTime = 30/30
local showFullAnimTime = 1.5
local multiData = {2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 15, 20, 30, 50, 60, 70, 80, 90, 100, 150, 200, 300, 500, 750, 1000, 1500}
local fakeDataMax = 1500
local fakeDataMini = 1000
local multiValueIndexConfig = {
	[2] = 1, [3] = 2, [4] = 3, [5] = 4, [6] = 5, [7] = 6, [8] = 7, [9] = 8, [10] = 9, [12] = 10, 
	[15] = 11, [20] = 12, [30] = 13, [50] = 14, [60] = 15, [70] = 16, [80] = 17, [90] = 18, [100] = 19, [150] = 20, 
	[200] = 21, [300] = 22, [500] = 23, [750] = 24, [1000] = 25, [1500] = 26}
local multState = {["disable"] = 1,["normal"] = 2, ["dim"] = 3}
local roundPickCnt = {1,7,6,5,4,2,1}
local yourGiftEndPos = cc.p(2, 314.5)

cls.spinTimeConfig = { -- spin 时间控制
		["base"] = 20/60, -- 数据返回前 进行滚动的时间
		["spinMinCD"] = 50/60,  -- 可以显示 stop按钮的时间，也就是可以通过quickstop停止的时间
}

function cls:getBoardConfig()
	if self.boardConfigList then
		return self.boardConfigList
	end
	self.boardConfigList = self.ThemeConfig["boardConfig"]
	return self.boardConfigList
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
	            [specialSymbol.scatter] 	= 600,
	            [specialSymbol.blank] 	= 500,
			},
			["normal_symbol_list"]  = {
				3, 4, 5, 6, 7,
			},
			["special_symbol_list"] = {
				specialSymbol.scatter
			},
			["no_roll_symbol_list"] = {
				specialSymbol.zeus, specialSymbol.wild, specialSymbol.blank, specialSymbol.scatter
			},
			["roll_symbol_inFree_list"] = {
			},
			["special_symbol_config"] = {
				[specialSymbol.scatter] = {
					["min_cnt"] = 3,
					["type"]	= G_THEME_SYMBOL_TYPE.NUMBER,
					["col_set"] = {
						[1] = 1,
						[2] = 1, 
						[3] = 1,
						[4] = 1,
						[5] = 1,
					},
				},
			},
		},
		["theme_round_light_index"] = 1,
		["theme_type"] = "payLine",
		["theme_type_config"] = {
			["pay_lines"] = {
				{0, 0, 0, 0, 0}, {1, 1, 1, 1, 1}, {2, 2, 2, 2, 2}, {3, 3, 3, 3, 3}, {0, 1, 0, 1, 0}, {1, 2, 1, 2, 1}, {2, 3, 2, 3, 2}, {1, 0, 1, 0, 1}, {2, 1, 2, 1, 2}, {3, 2, 3, 2, 3}, 
				{0, 0, 1, 0, 0}, {1, 1, 2, 1, 1}, {2, 2, 3, 2, 2}, {1, 1, 0, 1, 1}, {2, 2, 1, 2, 2}, {3, 3, 2, 3, 3}, {0, 0, 1, 2, 2}, {1, 1, 2, 3, 3}, {2, 2, 1, 0, 0}, {3, 3, 2, 1, 1}, 
				{1, 0, 1, 2, 1}, {2, 1, 2, 3, 2}, {0, 0, 2, 0, 0}, {1, 1, 3, 1, 1}, {2, 2, 0, 2, 2}, {3, 3, 1, 3, 3}, {0, 1, 2, 1, 0}, {1, 2, 3, 2, 1}, {2, 1, 0, 1, 2}, {3, 2, 1, 2, 3}, 
			},
			["line_cnt"] = 30,
		},
		["boardConfig"] = {
			{ -- 4x5
				["allow_over_range"] = true,
				["reelConfig"] = {
					{
						["base_pos"] 	= cc.p(47.50, 178.50),
						["cellWidth"] 	= 125,
						["cellHeight"] 	= 96,
						["symbolCount"] = 4
					},
					{
						["base_pos"] 	= cc.p(172.50, 178.50),
						["cellWidth"] 	= 125,
						["cellHeight"] 	= 96,
						["symbolCount"] = 4
					},
					{
						["base_pos"] 	= cc.p(297.50, 178.50),
						["cellWidth"] 	= 125,
						["cellHeight"] 	= 96,
						["symbolCount"] = 4
					},
					{
						["base_pos"] 	= cc.p(422.50, 178.50),
						["cellWidth"] 	= 125,
						["cellHeight"] 	= 96,
						["symbolCount"] = 4
					},
					{
						["base_pos"] 	= cc.p(547.50, 178.50),
						["cellWidth"] 	= 125,
						["cellHeight"] 	= 96,
						["symbolCount"] = 4
					},
				}
			}
		}
	}
	--- add by yt
	EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_SHOW, "theme188", self.touchShowCActivity, self)
	EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_HIDE, "theme188", self.touchHideCActivity, self)
	--- end by yt

	self.baseBet = 10000
	self.DelayStopTime = 0
	self.gameRuleGMConfig = {
		"spine/game_master/paytable/188_1"
	}
	self.UnderPressure = 1 -- 下压上 控制
	local use_portrait_screen = true
	local ret = Theme.ctor(self, themeid, use_portrait_screen)
    return ret
end

local G_cellHeight = 96
local delay = 0

local extraReelTime = 120/60
local extraReelTimeInFreeGame = 480/60

-- new
local upBounce = G_cellHeight * 2 / 3 --G_cellHeight*2/3
local upBounceMaxSpeed = 6 * 60
local upBounceTime = 0
local speedUpTime = 20 / 60
local rotateTime = 5 / 60
local maxSpeed = -25 * 60 -- -30 * 60
local normalSpeed = -25 * 60
local fastSpeed =  -25 * 60

local stopDelay = 20 / 60
local speedDownTime = 45 / 60 -- 40 / 60
local downBounce = G_cellHeight*1/5
local downBounceMaxSpeed = 10 * 60 -- 6 * 60
local downBounceTime = 15 / 60 -- 20/60
local spinMinCD = 0.5

local stopDelayList = {
    [1] = 15 / 60,
    [2] = 15 / 60,
    [3] = 15 / 60,
}
local autoStopDelayMult = 1
local autoDownBounceTimeMult = 1
local checkStopColCnt = 5
------


function cls:getSpinColStartAction( pCol )
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

	return spinAction
end
 
function cls:getSpinColStopAction(themeInfo, pCol, interval)
	local checkNotifyTag   = self:checkNeedNotify(pCol)
	if checkNotifyTag then
		self.DelayStopTime = self.DelayStopTime + extraReelTime
	end

    local _stopDelay, _downBonusT = self:getCurSpinLayerSpinActionTime(stopDelayList, downBounceTime, checkStopColCnt, autoStopDelayMult, autoDownBounceTimeMult )

	local spinAction = {}
	spinAction.actions = {}

	local temp = interval - speedUpTime - upBounceTime
	local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0
	spinAction.stopDelay = timeleft+(pCol-1)*_stopDelay + self.DelayStopTime
	self.ExtraStopCD = spinMinCD - temp > 0 and spinMinCD - temp or 0
	
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

function cls:initScene(spinNode)
	local path = self:getPic("csb/base.csb")
	self.mainThemeScene = cc.CSLoader:createNode(path)
	self.down_node 		= self.mainThemeScene:getChildByName("down_child")
	bole.adaptScale(self.mainThemeScene,true)
	bole.adaptReelBoard(self.down_node) -- 竖屏 适配 棋盘的 横屏不需要
	self.down_child 	= self.down_node:getChildByName("down_child")

	self.bgRoot 		= self.mainThemeScene:getChildByName("theme_bg")
	self.baseBg 		= self.bgRoot:getChildByName("bg_base")
	self.freeBg 		= self.bgRoot:getChildByName("bg_free")
	self.baseBg:setVisible(true)
	self.curBg = self.baseBg
	self.freeBg:setVisible(false)
	
	self.reelRoot 			= self.down_child:getChildByName("reel_root_node")
	self.reelKuangBase		= self.down_child:getChildByName("theme_kuang_b")
	self.reelKuangFree		= self.down_child:getChildByName("theme_kuang_f")

	self.boardRoot 			= self.down_child:getChildByName("board_root")
	self.animateNode 		= self.down_child:getChildByName("animate_node")	
	self.scatterAnimNode 	= self.down_child:getChildByName("scatter_anim_node")
	self.stickySymbolNode 	= self.down_child:getChildByName("stick_node")
	self.randomWildNode 	= self.down_child:getChildByName("wild_anim")
	self.addWildAnimDimmer 	= self.down_child:getChildByName("add_wild_dimmer")
	self.addWildAnimDimmer:setVisible(false)
	self.addWildAnimNode 	= self.down_child:getChildByName("add_wild_anim")
	self.themeAnimateKuang  = self.down_child:getChildByName("animate_kuang")
	self.bgAnimNode  		= self.down_child:getChildByName("bg_anim")
	self.topAnimNode  		= self.down_child:getChildByName("top_anim")
	self.featureDialogDimmer = self.mainThemeScene:getChildByName("dialog_dimmer")
	self.featureDialogDimmer:setVisible(false)

	-- 初始化jackpot
	self.topNode = self.mainThemeScene:getChildByName("top_node")
	self.progressiveRoot = self.topNode:getChildByName("progressive")
	local progressive_nodes = self.progressiveRoot:getChildByName("jackpots_labels")-- 初始化jackpot
	self.jackpotLabels = {}
	for i = 1, 3 do	
		self.jackpotLabels[i] = progressive_nodes:getChildByName("label_jp" .. i)
		self.jackpotLabels[i].maxWidth = self:getJPLabelMaxWidth(i)
		self.jackpotLabels[i].baseScale = self.jackpotLabels[i]:getScale()
	end
	self:initialJackpotNode()
	self.jpAnimNode = self.topNode:getChildByName("jp_anim_node")

	-- map 相关
	self:initCollectFeatureNode()

	self:initDealBonusNode()

	self.shakyNode:addChild(self.mainThemeScene)

	-- 添加背景特效
	self:addSpineAnimation(self.baseBg, nil, self:getPic("spine/base/base_bj_01"), cc.p(0, 0), "animation", nil, nil, nil, true, true)
	self:addSpineAnimation(self.freeBg, nil, self:getPic("spine/base/freegame_bj_01"), cc.p(0, 0), "animation", nil, nil, nil, true, true)

	-- 添加烛台特效
	if self.reelKuangBase then
		self:addSpineAnimation(self.reelKuangBase, nil, self:getPic("spine/fire/spine"), cc.p(323, -395), "blue", nil, nil, nil, true, true)
		self:addSpineAnimation(self.reelKuangBase, nil, self:getPic("spine/fire/spine"), cc.p(-331, -395), "blue", nil, nil, nil, true, true)	
	end
	if self.reelKuangFree then
		self:addSpineAnimation(self.reelKuangFree, nil, self:getPic("spine/fire/spine"), cc.p(323, -395), "yellow", nil, nil, nil, true, true)
		self:addSpineAnimation(self.reelKuangFree, nil, self:getPic("spine/fire/spine"), cc.p(-331, -395), "yellow", nil, nil, nil, true, true)	
	end

	-- local _, logos = self:addSpineAnimation(self.down_child, -1, self:getPic("spine/base/basezhousi_01"), cc.p(0, 0), "animation1", nil, nil, nil, true, true)
	-- self.logoSpine = logos
	-- self.logoAnimName = "animation1"

	-- 长屏logo相关
	self:setAdapterPhone()
    self:initLogoNode()  

	-- self.btnList = self.mainThemeScene:getChildByName("btn_list"):getChildren()
	-- self:initCheatBtnEvent()
end

function cls:setAdapterPhone( ... )
    bole.adaptTop(self.topNode, -0.4)
    -- bole.adaptTop(self.logoNode, -0.4)
end

--function cls:initLogoNode( ... )
--    self.longLogoNode 	= self.mainThemeScene:getChildByName("long_logo_node")
--
--    if self:adaptationLongScreen() then
--        self.longLogoNode:setVisible(true)
--        self:addSpineAnimation(self.longLogoNode, nil, self:getPic("spine/base/188_cp_01"), cc.p(0, 600), "animation", nil, nil, nil, true, true)
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
		local _, s = self:addSpineAnimation(self.longLogoNode, nil, self:getPic("spine/base/188_cp_01"), cc.p(0, 600), "animation", nil, nil, nil, true, true)
		bole.adaptTop(self.longLogoNode, -0.2)
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
	local jackpotLabelMaxWidth = {428, 256, 256}
	return jackpotLabelMaxWidth[index] or jackpotLabelMaxWidth[#jackpotLabelMaxWidth]
end

function cls:initSpinLayerBg( )
    if self.mapPoints then
		self:setCollectProgressImagePos(self.mapPoints)
	end

	Theme.initSpinLayerBg(self)
	self:checkLockFeature()

	if self.ctl and self.ctl.isMasterTheme and self.themeid and self.ctl:isMasterTheme(self.themeid) and not self.isNotShowMasterDialog then
        self:showMasterGameStartPopup()
    end
end


function cls:showMasterGameStartPopup()
    local node = cc.CSLoader:createNode(self:getPic("csb/dialog_game_master.csb"))
    if node then
        local root = node:getChildByName("root")
        local _, masterSpine = self:addSpineAnimation(root, -1, self:getPic("spine/game_master/popup/gmtanchuang"), cc.p(0,0), "animation", nil, nil, nil, true)
        masterSpine:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(40/30),
                cc.CallFunc:create(function ( ... )
                    if bole.isValidNode(masterSpine) then 
                        bole.spChangeAnimation(masterSpine, "animation_1", true)
                    end
                end)))

        local btnStart = root:getChildByName("start_btn")
        if btnStart then
            local size = btnStart:getContentSize()
            -- self:addSpineAnimation(btnStart, nil, self:getPic("spine/game_master/gamemaster_anniu_01"), cc.p(size.width / 2, size.height / 2), "animation", nil, nil, nil, true, true)
            
            btnStart:setScale(0)
            btnStart:runAction(cc.Sequence:create(
                cc.DelayTime:create(18/30),
                cc.ScaleTo:create(8/30, 1.18),
                cc.ScaleTo:create(6/30, 0.97),
                cc.ScaleTo:create(6/30, 1)))

            local function onTouch(obj, eventType)
                if eventType == ccui.TouchEventType.ended then
                    btnStart:setTouchEnabled(false)

                    if bole.isValidNode(masterSpine) then 
                        bole.spChangeAnimation(masterSpine, "animation_2")
                    end

                    btnStart:setScale(1)
					btnStart:runAction(cc.Sequence:create(
						cc.ScaleTo:create(7/30, 0.97),
						cc.ScaleTo:create(8/30, 1.18),
						cc.ScaleTo:create(7/30, 0)))
                    
                    self:playMusic(self.audio_list.popup_out)

                    node:runAction(cc.Sequence:create(
                        cc.DelayTime:create(20/30), 
                        cc.CallFunc:create(function ( ... )
                        	if bole.isValidNode(root) then 
		                        self:dialogPlayLineAnim( "hide", self.featureDialogDimmer )
		                    end
                        end),
                        cc.DelayTime:create(35/30), 
                        cc.RemoveSelf:create()))
                end
            end
            btnStart:addTouchEventListener(onTouch)
        end
        
        self.curScene:addToContentFooter(node, 10)

        self.featureDialogDimmer:setVisible(true)
        self.featureDialogDimmer:setOpacity(0)
        self.featureDialogDimmer:runAction(cc.FadeTo:create(0.3, 200))
        self:playMusic(self.audio_list.popup_out)
    end
end
function cls:initStickAnim( ... )
	self.stickyAnimList = {}
	for id = 1, 20 do
		local posData = self:getReelCellPos(id)
		local pos = self:getCellPos(posData[1],posData[2])
		local _, s = self:addSpineAnimation(self.stickySymbolNode, id, self:getPic("spine/item/kuang/shandiankuang_01"), pos, "animation1", nil, nil, nil, true)
		s:setVisible(false)
		self.stickyAnimList[id] = s
	end

	-- game_master
	for id = 1 + masterAddPos, 20 + masterAddPos do
		local posData = self:getReelCellPos(id)
		local pos = self:getCellPos(posData[1],posData[2])
		local _, s = self:addSpineAnimation(self.stickySymbolNode, id, self:getPic("spine/game_master/kuang/shandiankuang_02"), pos, "animation1", nil, nil, nil, true)
		s:setVisible(false)
		self.stickyAnimList[id] = s
	end
end

function cls:initCollectFeatureNode( )
	self.collectFeatureNode = self.down_child:getChildByName("collect_feature_node")

	local _, s = self:addSpineAnimation(self.collectFeatureNode:getChildByName("lock_anim"), nil, self:getPic("spine/collect_progress/lock"), cc.p(0, -41), idleFeatureAnimName, nil, nil, nil, true, true)
	self.lockSuperSpine = s
	local _, s2 = self:addSpineAnimation(self.collectFeatureNode, nil, self:getPic("spine/collect_progress/shandian_icon"), cc.p(-305, -32.5), idleFeatureAnimName, nil, nil, nil, true, true)
	self.collectIconSpine = s2

	self.isLockFeature 	= true
	self.bonusFlyNode 		= self.down_child:getChildByName("bonus_fly_node")
	self.collectPanel 		= self.collectFeatureNode:getChildByName("collect_panel")
	self.collectProgress 	= self.collectPanel:getChildByName("progress")
	self.collectProgressAni = self.collectFeatureNode:getChildByName("anim_node")
	self.baseProgressAniPosX = self.collectProgressAni:getPositionX()
	self:addSpineAnimation(self.collectProgress, nil, self:getPic("spine/collect_progress/sjt_idle_01"), cc.p(0,0), "animation", nil, nil, nil, true, true)
	self.collectProgress:setVisible(false)

	self.baseMapLoadNode 	= self.mainThemeScene:getChildByName("map_node")
	self.openLockBtn 		= self.collectFeatureNode:getChildByName("map_tip_btn")
	self.showMapBtn 		= self.collectFeatureNode:getChildByName("show_map_btn")
	self.showMapIcon 		= self.collectFeatureNode:getChildByName("open_map_icon")
	self.collectFullSpine 	= self.collectFeatureNode:getChildByName("collect_full_spine")

	self:initFeatureBtnEvent()
end

function cls:initDealBonusNode()
	self.dealBonusNode = cc.CSLoader:createNode(self:getPic("csb/map.csb"))
	self.baseMapLoadNode:addChild(self.dealBonusNode)
 	self.dealBonusNode:setVisible(false)
	self.theDealNodeRoot 	= self.dealBonusNode:getChildByName("root")
	self.blackBG    	= self.theDealNodeRoot:getChildByName("common_black")
	self.pickItemsNode 	= self.theDealNodeRoot:getChildByName("pick_items")
	self.multItemsNode 	= self.theDealNodeRoot:getChildByName("mult_items")

    self.dealBonusDimmer = self.theDealNodeRoot:getChildByName("dimmer")
    self.dealBonusDimmer:setVisible(false)

	self.dealBonusGiftList = {}
	self.dealBonusMultList = {}
	self.dealBonusGiftAniNodeList = {}
	self.dealBonusGiftBtnList = {}
	-- self.dealBonusGiftDownNodeList = {}
	local pickItems = self.pickItemsNode:getChildren()
	local multItems = self.multItemsNode:getChildren()
	local file = "commonpics/kong.png"
	for i = 1, maxMapLevel do
		local pickTemp = pickItems[i]
		self.dealBonusGiftList[i] = {}
    	local pickTempChilds = pickTemp:getChildren()
    	self.dealBonusGiftList[i].image = pickTempChilds[1]
    	self.dealBonusGiftList[i].label = pickTempChilds[2]:getChildren()[1]
    	self.dealBonusGiftList[i].node 	= pickTemp
    	self.dealBonusGiftList[i].index = i
    	self.dealBonusGiftAniNodeList[i] = pickTempChilds[3]
    	
    	-- local node = cc.Node:create()
    	-- pickTemp:addChild(node, -1)
    	-- self.dealBonusGiftDownNodeList[i] = node

    	self.dealBonusGiftBtnList[i] = Widget.newButton( nil, file, file, file)
    	pickTemp:addChild(self.dealBonusGiftBtnList[i]) 
    	self.dealBonusGiftBtnList[i]:setScale(13,9.5)

    	local multTemp = multItems[i]
		self.dealBonusMultList[i] = {}
    	local multTempChilds = multTemp:getChildren()
    	self.dealBonusMultList[i].sp = multTempChilds[1]
    	self.dealBonusMultList[i].label = multTempChilds[2]
    	multTempChilds[2]:setString(multiData[i].."X")
    	self.dealBonusMultList[i].node = multTemp
	end
   
	-- tipNode 
	self.dealBonusTipNode = self.theDealNodeRoot:getChildByName("tip_node")
	self.dealBonusGiftTextList = {}
	self.dealBonusGiftTextList["start"] = self.dealBonusTipNode:getChildByName("tip_label3")
	self.dealBonusGiftTextList["start"]:setVisible(false)
	self.dealBonusGiftTextList["choose"] = self.dealBonusTipNode:getChildByName("tip_label1")
	self.dealBonusGiftTextList["choose"].lb =  self.dealBonusGiftTextList["choose"]:getChildByName("tip_label1")
	self.dealBonusGiftTextList["choose"]:setVisible(false)
	self.dealBonusGiftTextList["last"] = self.dealBonusTipNode:getChildByName("tip_label1")
	self.dealBonusGiftTextList["last"]:setVisible(false)
	self.dealBonusGiftTextList["tip"] = self.dealBonusTipNode:getChildByName("tip_label2")
	
	-- dealNode 
    self.dealBonusTopNode = self.theDealNodeRoot:getChildByName("deal_node")
    self.dealBonusYourBoxNode = self.dealBonusTopNode:getChildByName("your_box_node")
    self.dealBonusYourBoxNode:setVisible(false)
    self.dealBonusYourBoxLabel = self.dealBonusYourBoxNode:getChildByName("cnt_label")


    self.dealBonusBaseExplain = self.theDealNodeRoot:getChildByName("explain_node")

    self.dealBonusRoundTipNode = self.theDealNodeRoot:getChildByName("tip_board")
    self.dealBonusRoundTipNode:setVisible(false)
    self.dealBonusRoundTipList = {}
    for i = 1,2 do
    	self.dealBonusRoundTipList[i] = {}
    	self.dealBonusRoundTipList[i].node = self.dealBonusRoundTipNode:getChildByName("type"..i)
    	self.dealBonusRoundTipList[i].node:setVisible(false)
    	if i == 1 then
    		self.dealBonusRoundTipList[i].labelRoundCount = self.dealBonusRoundTipList[i].node:getChildByName("round_num")
    		self.dealBonusRoundTipList[i].labelPickCount = self.dealBonusRoundTipList[i].node:getChildByName("gitf_cnt")
    	end
    end

	self.dealbonusDealLabels = self.dealBonusTopNode:getChildByName("deal_labels"):getChildren()

    self.dealBonusOpenGiftNode = self.theDealNodeRoot:getChildByName("open_gift_node")
    self.dealBonusOpenGiftNode:setVisible(false)
    self.dealBonusOpenGiftBoxNode = self.dealBonusOpenGiftNode:getChildByName("box_node")
    self.dealBonusOpenGiftBoxNode:setCascadeOpacityEnabled(true)
    self.dealBonusOpenGiftBoxBgAniNode = self.dealBonusOpenGiftNode:getChildByName("box_bg_node")
    self.dealBonusOpenGiftBoxBgAniNode:setCascadeOpacityEnabled(true)
    self.dealBonusOpenGiftBoxImage = self.dealBonusOpenGiftBoxNode:getChildByName("box")
    self.label_dealBonusOpenGiftNum = self.dealBonusOpenGiftBoxNode:getChildByName("label_cnt")
    self.label_dealBonusOpenMulti = self.dealBonusOpenGiftBoxNode:getChildByName("label_mul")
    self.label_dealBonusOpenMulti:setScale(0)
    self.label_dealBonusOpenMulti:setVisible(false)

	self.btn_dealBonusClose = self.theDealNodeRoot:getChildByName("close_btn")
	self.btn_dealBonusClose:setVisible(false)
	self.btn_dealBonusCloseTip = self.theDealNodeRoot:getChildByName("close_btn_tip")
	self.btn_dealBonusCloseTip:setVisible(false)
    self.isDealBoardOpen = false

    -- offerNode
    self.dealbonusOfferNode = self.theDealNodeRoot:getChildByName("choose_node")
    self.dealbonusOfferNode:setVisible(false)
    self.label_offerMul = self.dealbonusOfferNode:getChildByName("label_mul")
    self.label_offerWin = self.dealbonusOfferNode:getChildByName("label_win")
    self.btn_offerTakeIt = self.dealbonusOfferNode:getChildByName("btn1")
    self.btn_offerLeaveIt = self.dealbonusOfferNode:getChildByName("btn2")
    self.dealBonusOfferCharacterNode = self.dealbonusOfferNode:getChildByName("logo_sp")

    -- lastOfferNode 
    self.dealBonusLastOfferNode = self.theDealNodeRoot:getChildByName("last_choose_node")
    self.dealBonusLastOfferNode:setVisible(false)
    self.dealBonusLastOfferBoxLeft = self.dealBonusLastOfferNode:getChildByName("box_left")
    self.label_lastOfferNumLeft = self.dealBonusLastOfferBoxLeft:getChildByName("label_num1")
    self.dealBonusLastOfferBoxRight = self.dealBonusLastOfferNode:getChildByName("box_right")
    self.label_lastOfferNumRight = self.dealBonusLastOfferBoxRight:getChildByName("label_num2")
    self.btn_lastOfferKeepIt = self.dealBonusLastOfferNode:getChildByName("btn1")
    self.btn_lastOfferTradeIt = self.dealBonusLastOfferNode:getChildByName("btn2")
    self.label_dealBonusLastOfferMul = self.dealBonusLastOfferNode:getChildByName("label_mul")
    self.label_dealBonusLastOfferMul:setVisible(false)
    self.dealBonusLastBoxAniNode = self.dealBonusLastOfferNode:getChildByName("box_ani_node")
    self.dealBonusLastDimmer = self.dealBonusLastOfferNode:getChildByName("dimmer_last")
	self.dealBonusLastDimmer:setVisible(false)
	self.dealBonusLastOfferCharacterNode = self.dealBonusLastOfferNode:getChildByName("logo_sp")

    -- 显示 offer 之前的 提示 弹板
    -- todo offerTipJumpNode
    self.showOfferDialog 		= self.theDealNodeRoot:getChildByName("show_offer_dialog")
    self.showOfferBtn 			= self.showOfferDialog:getChildByName("btn_open_offer")
    self.offerTipJumpNode 		= self.showOfferDialog:getChildByName("offer_tip_node")
    self.showOfferDialog:setVisible(false)
end

function cls:initFeatureBtnEvent(  )
	-- 显示map按钮事件
	self.isFeatureClick = false
	local function touchShowMapEvent(obj, eventType) -- 点击按钮
		if not self:featureBtnCheckCanTouch() then 
			return 
		end

		if self.isLockFeature then
			return
		end

		if eventType == ccui.TouchEventType.began then
			self.showMapIcon:setColor(cc.c3b(125,125,125))
        elseif eventType == ccui.TouchEventType.moved then
        	self.showMapIcon:setColor(cc.c3b(125,125,125))
        elseif eventType == ccui.TouchEventType.ended then
			self:playMusic(self.audio_list.common_click)
		 	self:showDealBonusSceneAnimation(self.mapLevel)
		 	self.showMapIcon:setColor(cc.c3b(255,255,255))
        elseif eventType == ccui.TouchEventType.canceled then
        	self.showMapIcon:setColor(cc.c3b(255,255,255))
		end
	end
	self.showMapBtn:addTouchEventListener(touchShowMapEvent)-- 设置按钮

    local function unLockOnTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
			if not self:featureBtnCheckCanTouch() then 
				return 
			end
            if self.isLockFeature then
                self:playMusic(self.audio_list.common_click)
                self:setBet()
                return
            end
        end

    end
    self.openLockBtn:addTouchEventListener(unLockOnTouch)
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

function cls:checkLockFeature( bet ) -- 1是循环, 2是解锁, 3是锁上; 屏幕中心; 解锁26帧, 锁上10帧 
	if not self.tipBet or not self.lockSuperSpine then return end
	local bet = bet or self.ctl:getCurTotalBet()
	if bet >= self.tipBet and self.isLockFeature then -- 播放解锁动画
		self.isLockFeature = false
		self:playMusic(self.audio_list.collect_unlock)

		self.lockSuperSpine:stopAllActions()
		bole.spChangeAnimation(self.lockSuperSpine, openFeatureAnimName, false)
		bole.spChangeAnimation(self.collectIconSpine, openFeatureAnimName, false)

	elseif bet < self.tipBet and not self.isLockFeature then -- 播放锁定动画
		self.isLockFeature = true

		self.lockSuperSpine:stopAllActions()
		bole.spChangeAnimation(self.lockSuperSpine, lockFeatureAnimName, false)
		self.lockSuperSpine:runAction(cc.Sequence:create(
			cc.DelayTime:create(1),
			cc.CallFunc:create(function ( ... )
				if bole.isValidNode(self.lockSuperSpine) then 
					bole.spChangeAnimation(self.lockSuperSpine, idleFeatureAnimName, true)
				end
				if bole.isValidNode(self.collectIconSpine) then 
					bole.spChangeAnimation(self.collectIconSpine, idleFeatureAnimName, true)
				end
			end)))
		self:playMusic(self.audio_list.collect_lock)
	end
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

--------------- add spinboard spin start ---------------
function cls:initBoardTouchBtn(boardConfigList, pBoardNodeList)
    local base_config = boardConfigList
    self.boardMoveBtn = nil
    for key = 1, #boardConfigList do
        local reelConfig = base_config[key].reelConfig
        local base_pos = table.copy(reelConfig[1].base_pos)
        local boardW = reelConfig[1].cellWidth * 5
        local boardH = reelConfig[1].cellHeight * reelConfig[1].symbolCount
        self:initTouchSpinBtn(base_pos, boardW , boardH, pBoardNodeList[key])
    end
end

function cls:initTouchSpinBtn(base_pos, boardW, boardH, parent, iscenter)
    local unitSize = 10
    local img = "commonpics/kong.png"
    local touchSpin = function()
        self:footerCopySpinBtnEvent()
    end
    local touchBtn = Widget.newButton(touchSpin, img, img, img, false) --10
    touchBtn:setPosition(base_pos)
    local anchorPos = cc.p(0, 0)
    if iscenter then 
        anchorPos = cc.p(0.5, 0)
    end
    touchBtn:setAnchorPoint(anchorPos)
    touchBtn:setScaleX(boardW / unitSize)
    touchBtn:setScaleY(boardH / unitSize)
    touchBtn:setOpacity(0)
    parent:addChild(touchBtn)
    touchBtn.scaleY = boardH / unitSize
    return touchBtn
end

--------------- add spinboard spin end ---------------

-------------------------------------------------------------------------------------------
function cls:getThemeJackpotConfig()
	local jackpot_config_list = 
	{
		link_config = {"grand", "major", "minor"},
		allowK = {[188] = false, [688] = false, [1188] = false}
	}
	return jackpot_config_list
end

function cls:playCellRoundEffect(parent, ...) -- 播放中奖连线框
	self:addSpineAnimation(parent, nil, self:getPic("spine/kuang/spine"), cc.p(0,0), "animation", nil, nil, nil, true, true, nil)
end

function cls:enterFreeSpin( isResume ) -- 更改背景图片 和棋盘
	self.isInFreeGame = true
	if isResume then  -- 断线重连的逻辑
		self:changeSpinBoard(SpinBoardType.FreeSpin)--  更改棋盘显示 背景 和 free 显示类型
		self:dealMusic_PlayFreeSpinLoopMusic()-- 切换背景音乐
		self:topSetBet(self:getCurDiskData())
	end
	self:showAllItem()
	self.playNormalLoopMusic = false --commonMusic: freespin背景音乐
end

function cls:showFreeSpinNode( count, sumCount, first )
	
	self:topSetBet(self:getCurDiskData())

	Theme.showFreeSpinNode(self, count, sumCount, first)
end

function cls:hideFreeSpinNode( ... ) -- 逻辑是个啥
	self:changeSpinBoard(SpinBoardType.Normal)

	self.diskDataF      = {}

	self:topSetBet(self:getCurDiskData())

	Theme.hideFreeSpinNode(self, ...)
end

function cls:collectFreeRollEnd( ... )
    self:finshSpin()
    self.isInFreeGame = false
end

function cls:adjustWithTheCellSpriteUpdate( theCellNode, key, col ) -- 删除掉 tip 动画
	if theCellNode.symbolTipAnim then 
		if (not tolua.isnull(theCellNode.symbolTipAnim)) then 
			theCellNode.symbolTipAnim:removeFromParent()
		end
		theCellNode.symbolTipAnim = nil 
	end
end

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
	local theCellFile = self.pics[key]
	if not theCellFile then 
		print("whj: key, theCellFile",  key, theCellFile)
	end
	local theCellNode   = cc.Node:create()
	
	local theCellSprite = bole.createSpriteWithFile(theCellFile)
	theCellNode:addChild(theCellSprite)
	theCellNode.key 	  = key
	theCellNode.sprite 	  = theCellSprite
	theCellNode.curZOrder = 0
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

function cls:updateCellSprite(theCellNode, key, col, isShowResult, isReset)
	local theCellFile = self.pics[key]
	if not theCellFile then 
		print("whj: key, theCellFile", key, theCellFile)
	end

	local theCellSprite = theCellNode.sprite
	bole.updateSpriteWithFile(theCellSprite, theCellFile)
	theCellNode.key 	  = key
	theCellNode.curZOrder = 0

	------------------------------------------------------------
	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )	
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

function cls:adjustEnterThemeRet(data)
	data.theme_reels = {
		["main_reel"] = {
			[1] = {9,9,9,9,2,2,2,2,4,4,6,7,3,3,3,3,5,5,4,6,2,2,2,4,7,6,5,3,3,3,5,9,9,9,6,7,4,2,2,7,9,9,6,3,3,4,5,2,4,5,9,3,7,6,4,5,8,7,4,6,5},
			[2] = {9,9,9,9,2,2,2,2,4,4,6,7,3,3,3,3,5,5,4,6,2,2,2,4,7,6,5,3,3,3,5,9,9,9,6,7,4,2,2,7,9,9,6,3,3,4,5,2,4,5,9,3,7,6,4,5,8,7,4,6,5},
			[3] = {9,9,9,9,2,2,2,2,4,4,6,7,3,3,3,3,5,5,4,6,2,2,2,4,7,6,5,3,3,3,5,9,9,9,6,7,4,2,2,7,9,9,6,3,3,4,5,2,4,5,9,3,7,6,4,5,8,7,4,6,5},
			[4] = {9,9,9,9,2,2,2,2,4,4,6,7,3,3,3,3,5,5,4,6,2,2,2,4,7,6,5,3,3,3,5,9,9,9,6,7,4,2,2,7,9,9,6,3,3,4,5,2,4,5,9,3,7,6,4,5,8,7,4,6,5},
			[5] = {9,9,9,9,2,2,2,2,4,4,6,7,3,3,3,3,5,5,4,6,2,2,2,4,7,6,5,3,3,3,5,9,9,9,6,7,4,2,2,7,9,9,6,3,3,4,5,2,4,5,9,3,7,6,4,5,8,7,4,6,5},
		},
		["free_reel"] = {
			[1] = {9,9,9,9,4,4,4,4,5,5,5,5,2,2,2,2,7,7,7,7,6,6,6,6,3,3,3,3,5,5,5,4,4,4,2,2,2,7,7,7,3,3,3,6,6,6},
			[2] = {9,9,9,9,4,4,4,4,5,5,5,5,2,2,2,2,7,7,7,7,6,6,6,6,3,3,3,3,5,5,5,4,4,4,2,2,2,7,7,7,3,3,3,6,6,6},
			[3] = {9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9},
			[4] = {9,9,9,9,4,4,4,4,5,5,5,5,2,2,2,2,7,7,7,7,6,6,6,6,3,3,3,3,5,5,5,4,4,4,2,2,2,7,7,7,3,3,3,6,6,6},
			[5] = {9,9,9,9,4,4,4,4,5,5,5,5,2,2,2,2,7,7,7,7,6,6,6,6,3,3,3,3,5,5,5,4,4,4,2,2,2,7,7,7,3,3,3,6,6,6},
		},
	}
	self.tipBet = data.bonus_level

	if data["map_info"] then
	  	self.mapPoints = data["map_info"]["map_points"]
	    self.mapLevel = data["map_info"]["map_level"]
	end

	if data["bonus_game"] then
		self.isNotShowMasterDialog = true
	end

	if data["free_game"] then
		self.isNotShowMasterDialog = true

		if data.free_game and data.free_game.wild_pos then
	    	self.wildPosFeature = data.free_game.wild_pos
		end

		if data.free_game.fg_disk then 
        	self.diskDataF = data.free_game.fg_disk
	    end

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

function cls:getSpecialTryResume(realItemList)
    local specials = { [specialSymbol.scatter] = {} }
    for col, colItemList in ipairs(realItemList) do
        for row, theKey in ipairs(colItemList) do
            if theKey == specialSymbol.scatter then
                specials[theKey][col] = specials[theKey][col] or {}
                specials[theKey][col][row] = true
            end
        end
    end
    return specials

end

function cls:adjustTheme(data)
	self.isOverInitGame = true
	self:changeSpinBoard(SpinBoardType.Normal)

    self:initStickAnim()

	local allDiskData = data["theme_info"]
    self:refreshDiskData(allDiskData) -- 更新disk数据
end

--------------------------------------------------------------------------------
function cls:changeSpinBoard(pType) -- 更改背景控制 已修改
	self:stopDrawAnimate()
	
	self.randomWildNode:removeAllChildren()

	self.bgAnimNode:removeAllChildren()
	self.topAnimNode:removeAllChildren()
	self.topAnimNode:stopAllActions()
	if pType == SpinBoardType.Normal then -- normal情况下 需要更改棋盘底板
		self.showFreeSpinBoard = false
		self.showBaseSpinBoard = true
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

		if bole.isValidNode(self.logoSpine) then 
			self.logoSpine:stopAllActions()
			self.logoAnimName = "animation1"
			bole.spChangeAnimation(self.logoSpine, self.logoAnimName, true)
		end
		self.reelKuangBase:setVisible(true)
		self.reelKuangFree:setVisible(false)
	elseif pType == SpinBoardType.FreeSpin then
		self.showFreeSpinBoard = true
		self.showBaseSpinBoard = false
		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
		end

		-- self:addSpineAnimation(self.bgAnimNode, nil, self:getPic("spine/base/zhongjianjili"), self:getCellPos(3, 2.5), "animation", nil, nil, nil, true, true)
		-- self:addSpineAnimation(self.topAnimNode, nil, self:getPic("spine/base/zhongjianlizi"), self:getCellPos(3, 2.5), "animation", nil, nil, nil, true, true)
		self.topAnimNode:setOpacity(0)

		if self.curBg ~= self.freeBg then 
			self.curBg:setVisible(false)
			self.freeBg:setVisible(true)
			self.curBg = self.freeBg
		end

		if bole.isValidNode(self.logoSpine) then 
			self.logoSpine:stopAllActions()
			self.logoAnimName = "animation2"
			bole.spChangeAnimation(self.logoSpine, self.logoAnimName, true)
		end


		self.reelKuangBase:setVisible(false)
		self.reelKuangFree:setVisible(true)
	end
end

---------------------------------- spin 相关 ------------------------
function cls:onSpinStart()
	self.isFeatureClick = true
	self.DelayStopTime = 0
	
	self.hasBigZeusAnim = false
	self.newBlankPosList = nil
	self.winMeteorList = nil
	self.wildPosList = nil
	self.winMeteorByCol = nil
	self.winBigMeteorPosList = nil
	self.wildExpandList = nil

	if self.showBaseSpinBoard then
		if self.isDealBoardOpen then
			self:hideDealBonusSceneAnimation()
		end
	end

	if self.showFreeSpinBoard then 
		self.topAnimNode:stopAllActions()
		self.topAnimNode:runAction(cc.FadeIn:create(0.3))
	end

	self.randomWildNode:removeAllChildren()
	self.stickWildSpine = nil

	Theme.onSpinStart(self)
end

--------------------------Start--------------------------
-----------------------多棋盘 相关属性----------------------

function cls:stopControl( stopRet, stopCallFun )
	if stopRet["bonus_level"] then
		self.tipBet = stopRet["bonus_level"]
	end

    if stopRet.free_spins and (not self.ctl.freewin) then
        if stopRet.free_game then
        	if stopRet.free_game.fg_disk then 
            	self.diskDataF = stopRet.free_game.fg_disk
            end
        	if stopRet.free_game.wild_pos then 
            	self.wildPosFeature = stopRet.free_game.wild_pos
            end
        end
    end

    if stopRet.bonus_game and stopRet.bonus_game.wild_pos then
        self.wildPosFeature = stopRet.bonus_game.wild_pos
    end

    self.newBlankPosList = {}
    if stopRet.theme_info and stopRet.theme_info.new_disk then 
    	self.newBlankPosList = tool.tableClone(stopRet.theme_info.new_disk) or {}
    end

	-- if stopRet.item_list then
		-- local _curDiskDataSet = Set(self:getCurDiskData() or {})

		-- if stopRet.theme_info then 
  --      		self:refreshDiskData(stopRet.theme_info)
  --      	end
  --       local _newDiskDataSet = Set(self:getCurDiskData()) or {}

		-- for col, colItemList in pairs(stopRet.item_list) do
		-- 	for row, theItem in pairs(colItemList) do -- 落地动画
		-- 		if specialSymbol.blank == theItem then
		-- 			local id = col + (row-1)*5
		-- 			if not _curDiskDataSet[id] and not _curDiskDataSet[id + masterAddPos] then 
		-- 				self.newBlankPosList[col] = self.newBlankPosList[col] or {}
		-- 				if _newDiskDataSet[id+masterAddPos] then 
		-- 					self.newBlankPosList[col][row] = id+masterAddPos
		-- 				else
		-- 					self.newBlankPosList[col][row] = id
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- end
	-- end

    if stopRet.theme_info then
        self.changeDiskData = true
        self:refreshDiskData(stopRet.theme_info)
        self.curShowDiskData = tool.tableClone(self:getCurDiskData())

        self:checkWildDataByStopControl(stopRet)

        local stopThemeInfo = stopRet.theme_info
    	if stopThemeInfo.jp_win and stopThemeInfo.jp_win[1] then 
    		self.isWinJackpot = true
    		self.winJpData = tool.tableClone(stopThemeInfo.jp_win[1])
    	end

        if stopThemeInfo.map_info and stopThemeInfo.map_info.map_points and stopThemeInfo.map_info.map_points ~= self.mapPoints then
            self.winCollectPoints = true
        end
    end
    
    self:getZeusCnt(stopRet)

	stopCallFun()

end

function cls:checkWildDataByStopControl( stopRet )
	local stopThemeInfo = stopRet.theme_info
	if stopThemeInfo.meteor_list and stopThemeInfo.wild_pos then 
		self.winMeteorList = tool.tableClone(stopThemeInfo.meteor_list)
		self.wildPosList = tool.tableClone(stopThemeInfo.wild_pos)
		self.wildExpandList = tool.tableClone(stopThemeInfo.expand_list) -- expand_list = {1: {2,7,6}, 5:{4,9,10}}
		self.winMeteorByCol = {}

		local winMeteorSet = Set(self.winMeteorList)

		for col = 1, baseColCnt do 
			for _, id in pairs(singleColPosConfig[col]) do 
				if winMeteorSet[id] or winMeteorSet[id + masterAddPos] then 
					self.winMeteorByCol[col] = self.winMeteorByCol[col] or {}
					local addID = winMeteorSet[id] and id or id + masterAddPos
					table.insert(self.winMeteorByCol[col], addID)

					if col == baseColCnt then 
						self.lastColHasWild = true
					end
				end
			end
		end

		local _curDiskSet = Set(self.curShowDiskData)
		self.winBigMeteorPosList = {}
		for _, id in pairs(self.winMeteorList) do
			if _curDiskSet[id] then 
				self.winBigMeteor = true
				self.canFastStop = false
				local posData = self:getReelCellPos(id)
				local col = posData[1]
				self.winBigMeteorPosList[col] = self.winBigMeteorPosList[col] or {}
				table.insert(self.winBigMeteorPosList[col], id)
			end
		end
		

		if stopThemeInfo.post_wild_pos then 
			self.wildOverDiskData = tool.tableClone(stopThemeInfo.post_wild_pos)
			local wildOverDiskData = {}
			if self.showFreeSpinBoard then 
				wildOverDiskData["fg_disk"] = self.wildOverDiskData
			else
				local curBet = self.ctl:getCurBet()
				wildOverDiskData["disk_data"] = {[tostring(curBet)] = self.wildOverDiskData}
			end
			self:refreshDiskData(wildOverDiskData)
		end
	end
end

function cls:adjustRecData( rets )
	if not rets then return end
	if self.lastColHasWild then 
		self.lastColHasWild = false
		rets["control_add_delay"] 	= 0.5
	end
	if self.hasBigZeusAnim then
		self.hasBigZeusAnim = false
		rets["before_win_show"] = true
    end
end

function cls:getSpinColFastSpinAction(pCol)
	local speedScale = nil
	return Theme.getSpinColFastSpinAction(self, pCol, speedScale)
end

function cls:getSpinConfig( spinTag )
	local spinConfig = {}
	for col,_ in pairs(self.spinLayer.spins) do
		local theStartAction = self:getSpinColStartAction(col)
		local theReelConfig = {
			["col"]     = col,
			["action"]  = theStartAction,
		}
		table.insert(spinConfig, theReelConfig)
	end	
	return spinConfig
end

function cls:genSpecials( pWinPosList )
	local specials 	 = {[specialSymbol["scatter"]]={}}
	local itemList   = self.ctl:getRetMatrix()

	if itemList then
		for col,colItemList in pairs(itemList) do
			for row,theKey in pairs(colItemList) do
				if theKey==specialSymbol["scatter"] then
					specials[theKey][col] 	   	= specials[theKey][col] or {}
					specials[theKey][col][row] 	= true
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

		self.scatterBGState = {}
		self:genSpecialSymbolStateInNormal(rets) -- base 情况 配置 scatter
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
				if not isBreak and curColMaxCnt>0 and (itemCnt+curColMaxCnt)>=theItemConfig["min_cnt"] then
					willGetFeatureInCol = true
					self.speedUpState[col] = self.speedUpState[col] or {}-- 此情况下，会进行特殊操作，将其状态记到self.speedUpState中
					self.speedUpState[col][itemKey] = true
				end
				-- 判断当前列加上之后所有列是否有可能中feature
				local willGetFeatureInAfterCols = false
				if not isBreak then
					local sumCnt = 0
					for tempCol=col, #self.spinLayer.spins do
						sumCnt = sumCnt + (theItemConfig["col_set"][tempCol] or colRowCnt)
					end
					if sumCnt>0 and (itemCnt+sumCnt)>=theItemConfig["min_cnt"] then
						willGetFeatureInAfterCols = true				
					end
				end
				
				self.notifyState[col] = self.notifyState[col] or {}-- 当前列提示相关状态
				if not isBreak and curColMaxCnt>0 and willGetFeatureInAfterCols then
					for row, theItem in pairs(colItemList) do
						if theItem == itemKey then
							self.notifyState[col][itemKey] = self.notifyState[col][itemKey] or {}
							table.insert(self.notifyState[col][itemKey], {col, row})

							self.scatterBGState[col] = true
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
		local _curDiskDataSet = Set(self:getCurDiskData() or {})
		for col, colItemList in pairs(rets.item_list) do
			for row, theItem in pairs(colItemList) do -- 落地动画
				if specialSymbol.blank == theItem then
					self.notifyState[col] = self.notifyState[col] or {}
					self.notifyState[col][theItem] = self.notifyState[col][theItem] or {}
					table.insert(self.notifyState[col][theItem], {col, row})
				end
			end
		end
	end
end

function cls:getZeusCnt(ret)
	self.zeus_cnt = {}
	local winPosList = {}
	if ret.win_pos_list then 
		for k,v in pairs(ret.win_pos_list) do 
			winPosList[v[1]] = winPosList[v[1]] or {}
			winPosList[v[1]][v[2]] = true 
		end
	end
	local curWildPosList = {}
	if self.wildPosList then 
		for _, id in pairs(self.wildPosList) do 
			local posData = self:getReelCellPos(id)
			curWildPosList[posData[1]] = curWildPosList[posData[1]] or {} 
			curWildPosList[posData[1]][posData[2]] = true
		end
	end

	for col=1,5 do
		if winPosList[col] then
			local count = 0
			local topIndex = 1
			local canBig = false
			for row=1,4 do
				if ret.item_list[col][row] == specialSymbol.zeus and winPosList[col][row] and not (curWildPosList[col] and curWildPosList[col][row]) then --and winPosList[col][row]
					count = count + 1
					-- if winPosList[col][row] then 
						canBig =true
					-- end
				else
					if count >0 and canBig then 
						self.zeus_cnt[col] = self.zeus_cnt[col] or {}
						self.zeus_cnt[col][topIndex] = count

						if count > 1 then 
							self.hasBigZeusAnim = true
						end
					end
					canBig = false
					count = 0
					topIndex = row+1
				end
			end
			if count >0 and canBig then 
	            self.zeus_cnt[col] = self.zeus_cnt[col] or {}
	            self.zeus_cnt[col][topIndex] = count

	            if count > 1 then 
					self.hasBigZeusAnim = true
				end
	        end
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

function cls:checkPlaySymbolNotifyEffect( pCol ) 
	local isPlaySymbolNotify = false
	self:dealMusic_StopReelNotifyMusic(pCol) -- 停止滚轴加速的声音

	if not self.fastStopMusicTag then -- 判断是否播放特殊symbol的动画
		isPlaySymbolNotify = self:dealMusic_PlaySpecialSymbolStopMusic(pCol)-- 判断是否播放特殊symbol的动画
	else
		if pCol == #self.spinLayer.spins then
			local haveSymbolLevel = 3 -- 普通下落音的等级
			for k,v in pairs(self.notifyState) do -- 判断在剩下停止的滚轴中是否有特殊symbol
			 	if bole.getTableCount(v) > 0 then
					if v[specialSymbol["scatter"]] then -- scatter
						if haveSymbolLevel >1 then
							haveSymbolLevel = 1
						end
						self:playSymbolNotifyEffect(k) -- 播放特殊symbol 下落特效
					elseif v[specialSymbol["blank"]] then -- bonus
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
 	local pos = self:getCellPos(pCol,2.5)
	local _,s1 = self:addSpineAnimation(self.animateNode, 20, self:getPic("spine/base/scatter_jl_01"), pos, "animation",nil,nil,nil,true,true)
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

	-- 确定下一轴是否进行Notify
	if self:checkSpeedUp(pCol + 1) then
		self:onReelNotifyStopBeg(pCol +1)
	end

	self:checkAndShowRandomWildAnim(pCol, true)
end

function cls:onReelFastFallBottom( pCol )
	self:checkAndShowRandomWildByFastStop(pCol)
	Theme.onReelFastFallBottom(self, pCol)
end

function cls:onReelStop( col )
	self:checkAndShowLockAnim(col)
	Theme.onReelStop(self, col)
end

function cls:checkAndShowLockAnim( col )
	if self.newBlankPosList and self.newBlankPosList[col] and bole.getTableCount(self.newBlankPosList[col]) > 0 then 
		local colPosList = self.newBlankPosList[col]
		for _, id in pairs(colPosList) do 
			self:changeStickAnimState(id)
		end
	end
end

local showTipLogoAnimTime = 15/30
local singleFlyWildTime = 12/30
local showWildTime = 20/30
function cls:checkAndShowRandomWildAnim( col, needAnim )
	if self.winMeteorByCol and self.winMeteorByCol[col] and bole.getTableCount(self.winMeteorByCol[col]) > 0 then 
	
		if needAnim then
			if bole.isValidNode(self.logoSpine) then 
				self:playMusic(self.audio_list.lightning1)
				self.logoSpine:stopAllActions()
				self.logoSpine:setAnimation(0, "animation1_3", false)

				self.logoSpine:runAction(cc.Sequence:create(
					cc.DelayTime:create(30/30),
					cc.CallFunc:create(function ( ... )
						if bole.isValidNode(self.logoSpine) and self.logoAnimName then 
							self.logoSpine:setAnimation(0, self.logoAnimName, true)
						end
					end)))
			end

			self:runAction(cc.Sequence:create(
				cc.DelayTime:create(showTipLogoAnimTime),
				cc.CallFunc:create(function ( ... )
					self.addWildAnimDimmer:stopAllActions()
					self.addWildAnimDimmer:setVisible(true)
					self.addWildAnimDimmer:setOpacity(0)
					self.addWildAnimDimmer:runAction(cc.Sequence:create(
						cc.FadeTo:create(0.2, 100),
						cc.DelayTime:create(singleFlyWildTime),
						cc.CallFunc:create(function ( ... )
							self.addWildAnimDimmer:runAction(cc.FadeTo:create(0.2, 0))
						end)))

					if self.winBigMeteorPosList and self.winBigMeteorPosList[col] then -- 抖动
						self:playReelTremble()
					end
				end)))
		end

		for _, id in pairs(self.winMeteorByCol[col]) do 
			self:showWildAnim(id)

			if needAnim then -- 播放下落动画
				self:changeStickWildStateByCol(false, col)
				self:runAction(cc.Sequence:create(
					cc.DelayTime:create(showTipLogoAnimTime),
					cc.CallFunc:create(function ( ... )
						local posData = self:getReelCellPos(id)
						local pos = self:getCellPos(posData[1],posData[2])
						local scaleX = posData[1] < 3 and 1 or -1
						local _, s = self:addSpineAnimation(self.addWildAnimNode, 200, self:getPic("spine/base/psd_01"), pos, "animation")
						s:setScaleX(scaleX)
					end),
					cc.DelayTime:create(singleFlyWildTime),
					cc.CallFunc:create(function ( ... )
						self:changeStickWildStateByCol(true, col)
					end)))
			end
		end
	end
end

function cls:playReelTremble()
	self.footerTremble = ScreenShaker.new(self.ctl.footer, showWildTime + singleFlyWildTime, function() self.footerTremble = nil end)
	self.footerTremble:run()
	self.headerTremble = ScreenShaker.new(self.ctl.header, showWildTime + singleFlyWildTime, function() self.headerTremble = nil end)
	self.headerTremble:run()
	self.reelTremble = ScreenShaker.new(self.shakyNode, showWildTime + singleFlyWildTime, function() self.reelTremble = nil end)
	self.reelTremble:run()
end

function cls:checkAndShowRandomWildByFastStop( pCol )
	if not self.fastStopMusicTag then
		for col = pCol, #self.spinLayer.spins do
			self:checkAndShowRandomWildAnim(col)
		end
	end
end

function cls:showWildAnim(id)
	local isSuperPos = id and id > masterAddPos
	local id = id % masterAddPos
	local posData = self:getReelCellPos(id)
	if not posData then return end
	
	self.stickWildSpine = self.stickWildSpine or {}
	local spineFile = isSuperPos and self:getPic("spine/game_master/wild/spine") or self:getPic("spine/item/1/spine")
	if isSuperPos then 
		if self.stickWildSpine[posData[1]] 
			and bole.isValidNode(self.stickWildSpine[posData[1]][posData[2]]) 
			and self.stickWildSpine[posData[1]][posData[2]].id 
			and self.stickWildSpine[posData[1]][posData[2]].id < masterAddPos 
			then 
			
			self.stickWildSpine[posData[1]][posData[2]]:removeFromParent()
			self.stickWildSpine[posData[1]][posData[2]] = nil
		end
	end

	if not (self.stickWildSpine[posData[1]] and bole.isValidNode(self.stickWildSpine[posData[1]][posData[2]])) then -- wild 展示动画
		self.stickWildSpine[posData[1]] = self.stickWildSpine[posData[1]] or {}
		local pos = self:getCellPos(posData[1],posData[2])
		local _, s = self:addSpineAnimation(self.randomWildNode, id, spineFile, pos, "animation1", nil, nil, nil, true)
		self.stickWildSpine[posData[1]][posData[2]] = s
		self.stickWildSpine[posData[1]][posData[2]].id = isSuperPos and id + masterAddPos or id
		return s
	end
end

function cls:changeStickWildStateByCol( state, col, animName )
	animName = animName or "animation1"
	if col then
		if self.stickWildSpine and self.stickWildSpine[col] then 
			for _, node in pairs(self.stickWildSpine[col]) do 
				if state then 
					bole.spChangeAnimation(node, animName)
				end
				node:setVisible(state)
			end
		end
	end
end
------------------------------------------------------- handler --------------------------------------------------------
local showWildComTime = 20/30
function cls:beforeWinShow(ret, onEnd)
    if self.zeus_cnt then -- 播放wild倍数
    	for col = 1, baseColCnt do 
    		self:addZeusSpine(nil, col, 1, true)
    	end
        
        self:runAction(cc.Sequence:create(
            cc.DelayTime:create(showWildComTime), -- wild 显示的时间
            cc.CallFunc:create(function ( ... )
                if onEnd then 
                    onEnd()
                end
            end)))
    else
        if onEnd then 
            onEnd()
        end
    end
end

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
	elseif self.changeDiskData then 
		hasSpecialWin = true
		self.changeDiskData = false
		self:themeInfoChangeDiskData(ret) 
	elseif self.winBigMeteor then
		hasSpecialWin = true
		self.winBigMeteor = false
		self:showBigMeteorAnim(ret, self.wildPosList) 
	elseif self.isWinJackpot then 
		self.isWinJackpot = false
		hasSpecialWin = true
		self:themeInfoPlayWinJackpot(ret, self.winJpData)
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

	if not self.isLockFeature and _mapPoints ~= curMapPoints then
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
		self:checkHasWinInThemeInfo(rets)
	end
end

function cls:showCoinsFlyToUp(rets)
	self.bonusFlyNode:removeAllChildren()
	
	if not (self.ctl.rets and self.ctl.rets.item_list) then return end

	self:playMusic(self.audio_list.collect_fly)

	for col, colList in pairs(rets.item_list) do 
		for row, key in pairs(colList) do 
			
			if key == specialSymbol.blank then 
				local pos = self:getCellPos(col, row)
				local _,s = self:addSpineAnimation(self.bonusFlyNode, 20, self:getPic("spine/item/"..key.."/spine"), pos, "animation3")
				s:runAction(cc.Sequence:create(
					cc.DelayTime:create(15/30),
					cc.MoveTo:create(flyToUpTime - 15/30, collectFlyEndPos)))
			end
			-- local _particle = cc.ParticleSystemQuad:create(self:getPic("particles/159m1feixing_01_1.plist"))
			-- _particle:setPosition(pos)
			-- self.bonusFlyNode:addChild(_particle)

			-- _particle:runAction(cc.Sequence:create(
			-- 	cc.MoveTo:create(flyToUpTime, collectFlyEndPos),
			-- 	cc.CallFunc:create(function()
			-- 		_particle:setEmissionRate(0) -- 设置发射速度为不发射
			-- 	end),
			-- 	cc.DelayTime:create(0.5),
			-- 	cc.RemoveSelf:create()))
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
    self.collectProgressAni:setPositionX(self.baseProgressAniPosX + oldPosX) 
	self.collectProgressAni:runAction(cc.MoveTo:create(0.5,cc.p(self.baseProgressAniPosX + newPosX, self.collectProgressAni:getPositionY())))

	self:addSpineAnimation(self.collectProgressAni, 2, self:getPic("spine/collect_progress/sjt_sz_01"), cc.p(0,0), "animation")

	if bole.isValidNode(self.collectIconSpine) then 
		bole.spChangeAnimation(self.collectIconSpine, collectFeatureAnimName)
	end

	self:laterCallBack(0.5,function()
		if isFull then
			self:dealMusic_FadeLoopMusic(0.3, 1, 0.3)
			self:fullCollectAnimation()
		end
	end)
end

function cls:fullCollectAnimation( ... )
	self:playMusic(self.audio_list.collect_full)
	self:addSpineAnimation(self.collectFullSpine, nil, self:getPic("spine/collect_progress/sjt_jm_01"), cc.p(0, -41), "animation", nil, nil, nil, true, true)
end

function cls:stopCollectPartAnimation()
	self.collectFullSpine:removeAllChildren()
end

function cls:themeInfoChangeDiskData( ret )
	if self.curShowDiskData then 
    	self:changeFeaturePos(self.curShowDiskData, true)
    end
    self:checkHasWinInThemeInfo(ret)
end

function cls:checkIsWinSuperMeteor( wildPosList )
	local isWinSuper 
	for _, id in pairs(wildPosList) do 
		if id > masterAddPos then 
			isWinSuper = true
			return isWinSuper
		end
	end

	return isWinSuper
end

function cls:showBigMeteorAnim( ret, wildPosList )
	if wildPosList then
		self:playMusic(self.audio_list.expand)
		
		local isWinSuper = self:checkIsWinSuperMeteor(self.winMeteorList)
		local spineFile = isWinSuper and self:getPic("spine/game_master/win_meteor/qipanshandian_huang") or self:getPic("spine/base/qipanshandian")
		self:addSpineAnimation(self.bonusFlyNode, 50, spineFile, cc.p(360, 640), "animation")

		self:runAction(cc.Sequence:create(
			cc.DelayTime:create(3/30),
			cc.CallFunc:create(function ( ... )
				self:playWildExpandAnim()
			end),
			cc.DelayTime:create(15/30),
			cc.CallFunc:create(function ( ... )
				self:playMusic(self.audio_list.change_wild)
				
				for _, id in pairs(wildPosList) do 
					self:showWildAnim(id)
				end

				self:changeFeaturePos(self:getCurDiskData(), true)
			end),
			cc.DelayTime:create(30/30),
			cc.CallFunc:create(function ( ... )
				self:checkHasWinInThemeInfo(ret)
			end)))
	else
		self:checkHasWinInThemeInfo(ret)
	end
end

function cls:playWildExpandAnim()
	if self.wildExpandList then 
		for id, expandIDList in pairs(self.wildExpandList) do 
			local posDataS = self:getReelCellPos(id)
			local posS = self:getCellPos(posDataS[1],posDataS[2])

			for _, expandID in pairs(expandIDList) do
				
				local node = self:showWildAnim(expandID)
				if bole.isValidNode(node) then 
					local posDataE = self:getReelCellPos(expandID)
					local posE = self:getCellPos(posDataE[1],posDataE[2])
				
					node:setPosition(posS)
					node:runAction(cc.MoveTo:create(0.3, posE))
				end
			end
		end
	end
end

function cls:themeInfoPlayWinJackpot( ret, jpWinData )
	self:playWinJackpotAnim(jpWinData)
	-- self:runAction(cc.Sequence:create(
	-- 	cc.DelayTime:create(2.5),
	-- 	cc.CallFunc:create(function ( ... )
	-- 		self:showCollectGrandDialog(ret, jpWinData)
	-- 	end)))

	self.ctl.rets["setWinCoins"] = 1
	ret.base_win = self.ctl.rets.base_win + (jpWinData.jp_win or 0) -- 设置赢钱
end

local winJpAnimConfig = {
	[1] = {"animation_grand", cc.p(-2, 446)},
	[2] = {"animation_major", cc.p(-208.5, 351)},
	[3] = {"animation_major", cc.p(207, 350.5)},
}
function cls:playWinJackpotAnim( jpWinData )
	local winJpType = (jpWinData.jp_win_type or 0) + 1
	local jpValue = jpWinData.jp_win or 0

	local loopAnimC = winJpAnimConfig[winJpType]

	self:playMusic(self.audio_list.lightning2)
	if bole.isValidNode(self.logoSpine) then 
		self.logoSpine:stopAllActions()
		self.logoSpine:setAnimation(0, "animation1_1", false)

		self.logoSpine:runAction(cc.Sequence:create(
			cc.DelayTime:create(65/30),
			cc.CallFunc:create(function ( ... )
				if bole.isValidNode(self.logoSpine) and self.logoAnimName then 
					self.logoSpine:setAnimation(0, self.logoAnimName, true)
				end
			end)))
	end
	
	self.jpAnimNode:runAction(cc.Sequence:create(
		cc.DelayTime:create(58/30),
		cc.CallFunc:create(function ( ... )
			self:addSpineAnimation(self.mainThemeScene, nil, self:getPic("spine/win_jp/basezhousi_jp_psd_01"), cc.p(0,0), "animation2")
		end),
		cc.DelayTime:create(20/30),
		cc.CallFunc:create(function ( ... )
			self:addSpineAnimation(self.jpAnimNode, nil, self:getPic("spine/win_jp/basezhousi_jp_psd_01"), loopAnimC[2], "animation")
		end),
		cc.DelayTime:create(2/30),
		cc.CallFunc:create(function ( ... )
			-- self:playMusic(self.audio_list.jp)
			self:addSpineAnimation(self.jpAnimNode, nil, self:getPic("spine/win_jp/jp_k_xz_01"), loopAnimC[2], loopAnimC[1], nil, nil, nil, true, true)
		end),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function ( ... )
			self:showCollectGrandDialog(ret, jpWinData)
		end)))
	
    self:lockJackpotMeters(true, winJpType)  -- 锁住jackpot meter
    if self.jackpotLabels[winJpType] then
        self.jackpotLabels[winJpType]:setString(FONTS.format(jpValue, true))
        bole.shrinkLabel(self.jackpotLabels[winJpType], self:getJPLabelMaxWidth(winJpType), self.jackpotLabels[winJpType]:getScale())
    end
end

function cls:showCollectGrandDialog(ret, jpWinData)
    local path = self:getPic("csb/dialog_jp.csb")
    local grandDialog = cc.CSLoader:createNode(path)
    local showNode = grandDialog:getChildByName("root")

    local grandLabelNode = showNode:getChildByName("label_node")
    local grandLabel 	= grandLabelNode:getChildByName("label_win")
    local collectBtn 	= showNode:getChildByName("btn")
    local grandWin 		= jpWinData.jp_win or 0
    local winJpType 	= (jpWinData.jp_win_type or 0) + 1
    local animName 		= "animation".. winJpType
    -- 显示弹窗
    self.curScene:addToContentFooter(grandDialog)

    self:dealMusic_FadeLoopMusic(0.2, 1, 0.3)
    self:playMusic(self.audio_list.win_jp_show)
    local _ ,s = self:addSpineAnimation(showNode, -1, self:getPic("spine/dialog/win_jp/jptanchuang"), cc.p(0,0), animName, nil, nil, nil, true)
    s:runAction(cc.Sequence:create(
        cc.DelayTime:create(35/30),
        cc.CallFunc:create(function ( ... )
            bole.spChangeAnimation(s, animName.."_1", true)
        end)))

    grandLabelNode:setScale(0.62)
    grandLabelNode:setVisible(false)
    grandLabelNode:runAction(cc.Sequence:create(
        cc.DelayTime:create(9/30),
        cc.Show:create(),
        cc.ScaleTo:create(5/30, 1.1),
        cc.ScaleTo:create(2/30, 1)))

    if bole.isValidNode(collectBtn) then 
        collectBtn:setScale(0)
        collectBtn:runAction(cc.Sequence:create(
            cc.DelayTime:create(15/30),
            cc.ScaleTo:create(5/30, 1.1)))

        local btnSize = collectBtn:getContentSize()
        self:addSpineAnimation(collectBtn, nil, self:getPic("spine/dialog/fangxing"), cc.p(btnSize.width/2,btnSize.height/2), "animation", nil, nil, nil, true,true)-- 播放 结果动画
    end

    self:dialogPlayLineAnim("show", self.featureDialogDimmer)

    local function parseValue( num)
        return FONTS.format(num, true)
    end
    bole.setSpeicalLabelScale(grandLabel, grandWin, 540)
    inherit(grandLabel, LabelNumRoll)
    grandLabel:nrInit(0, 24, parseValue)


    local clickEndFunction = function ( obj, eventType )
        if eventType == ccui.TouchEventType.ended then 
            collectBtn:setTouchEnabled(false)
            collectBtn:removeAllChildren() -- 删除循环扫光特效
            self:playMusic(self.audio_list.common_click)
            
            grandDialog:runAction(cc.Sequence:create(
                cc.CallFunc:create(function ( ... )
                    self:dialogPlayLineAnim("hide", self.featureDialogDimmer, showNode) -- 关闭弹窗
                    self:playMusic(self.audio_list.popup_out)
                    -- self:dealMusic_FadeLoopMusic(0.2, 0.3, 1) -- 之后就庆祝赢钱了，不需要恢复了
                end),
                cc.DelayTime:create(dialogShowOrHideTime),
                cc.CallFunc:create(function ( ... )
                    self:checkHasWinInThemeInfo(ret)
                    self:lockJackpotMeters(false, winJpType)  -- 解锁 jackpot meter
                end),
                cc.RemoveSelf:create()
            ))
        end
    end

    grandDialog:runAction(cc.Sequence:create(
        cc.CallFunc:create(function ( ... )
            grandLabel:nrStartRoll(0, grandWin, 1.5)-- 播放numberRoll
        end),
        cc.DelayTime:create(35/30),
        cc.CallFunc:create(function ( ... )
            collectBtn:addTouchEventListener(clickEndFunction)
        end),
        cc.DelayTime:create(1.5),
        cc.CallFunc:create(function ( ... )
            grandLabel:nrOverRoll()-- 停止滚动
        end)))
end

--------------------- map 相关 ------------------------ 

function cls:setCollectProgressImagePos(map_points) -- 显示 进度的点数
	if map_points > maxMapPoints then
		map_points = maxMapPoints
	elseif map_points < 0 then
		map_points = 0
	end

	local cur_posX = movePerUnit * map_points + progressStartPosX

	self.collectProgress:setPosition(cc.p(cur_posX, progressPosY))
	self.collectProgressAni:setPositionX(self.baseProgressAniPosX + cur_posX)
end

function cls:setDealBonusGiftData(mapLevel,isLevelUp)
	local level = mapLevel 
	if not level then
		if isLevelUp then 
			level = self.mapLevel and (self.mapLevel - 1) or 0
		else
			level = self.mapLevel and self.mapLevel or 0
		end
	end

	self:resetGiftList()
	if level > 0 then
        for i = 1,level do
        	self.dealBonusGiftList[i].node:setVisible(true)
	    	self.dealBonusGiftList[i].label:setString(i)
	    end
	end	
end

local disableColor = cc.c3b(125,125,125)
local dimColor = cc.c3b(84,84,84)
local normalColor = cc.c3b(255,255,255)
function cls:setDisplayStarState(index,state)
	if multState.disable == state then -- 显示 为不可用(不在bonus 里面)
		self.dealBonusMultList[index].node:setColor(disableColor) -- self.dealBonusMultList[index].node:setOpacity(150)
		-- self.dealBonusMultList[index].sp:setColor(disableColor)
  --   	self.dealBonusMultList[index].label:setColor(disableColor) -- cc.c3b(255,255,255))
    elseif multState.normal == state then -- 显示 可用(在bonus 里面)
    	self.dealBonusMultList[index].node:setColor(normalColor) -- self.dealBonusMultList[index].node:setOpacity(255)
    	-- self.dealBonusMultList[index].sp:setColor(cc.c3b(255,255,255))
    	-- self.dealBonusMultList[index].label:setColor(cc.c3b(255,255,255))
    elseif multState.dim == state then -- 显示 不可用(在bonus 里面)
    	self.dealBonusMultList[index].node:setColor(dimColor) -- self.dealBonusMultList[index].node:setOpacity(255)
    	-- self.dealBonusMultList[index].sp:setColor(cc.c3b(84,84,84))
    	-- self.dealBonusMultList[index].label:setColor(cc.c3b(100,100,100))
    end
end

function cls:resetGiftList()
	for i = 1,maxMapLevel do
		self.dealBonusGiftList[i].node:setVisible(false)
		self.dealBonusGiftList[i].image:setColor(cc.c3b(255,255,255))
    	self.dealBonusGiftList[i].label:setString(i)
    end
end

function cls:resetAllStarState()
	for i = 1,maxMapLevel do
    	self.dealBonusMultList[i].label:setString(multiData[i].."X")
    end
end

function cls:showGiftCollectedAnimation(mapLevel)
	mapLevel = mapLevel or 1
	if mapLevel == 0 then mapLevel = 1 end
	local giftItem = self.dealBonusGiftList[mapLevel]
	
	self:addSpineAnimation(giftItem.node, nil, self:getPic("spine/map/jiangbeichuxian"), cc.p(0,0), "animation")
	giftItem.node:setScale(0)
	giftItem.node:setVisible(true)
	giftItem.label:setString(mapLevel)
	giftItem.node:runAction(cc.Sequence:create(
		cc.ScaleTo:create(0.3,1.5),
		cc.ScaleTo:create(0.15,1)
	))
	self:playMusic(self.audio_list.grail_out)
	
	return 0.45
end

function cls:setDealBonusScene(mapLevel,isLevelUp,isDeal)
	local level = mapLevel or self.mapLevel
	if isLevelUp and level > 0 then
		level = level - 1
	end
	self:setDealBonusGiftData(level,isLevelUp)
	self:resetAllStarState()
	
	if isDeal then 
		for i = 1,maxMapLevel do
			self:setDisplayStarState(i,multState.normal)
		end
	else
		for i = 1,maxMapLevel do
			self:setDisplayStarState(i,multState.disable)
		end
		if isLevelUp then
			self.dealBonusOpenGiftNode:setVisible(false)
		end
	end
end

function cls:showDealBonusSceneAnimation(mapLevel, isLevelUp, isDeal)
	-- if self.ctl.footer then 
	-- 	self.ctl.footer:hideActivitysNode()
	-- end
	self.isFeatureClick = true
	self.isOpenStoreNode = true

	-- self.ctl.footer:setSpinButtonState(true)  -- 禁用按钮
	-- self.ctl.footer:enableOtherBtns(false) -- 禁掉 其他按钮

	self:setDealBonusScene(mapLevel,isLevelUp,isDeal)
	self.dealBonusNode:setOpacity(0)
	self.dealBonusNode:setVisible(true)
	self.dealbonusOfferNode:setVisible(false)
	self.dealBonusLastOfferNode:setVisible(false)

	self:playMusic(self.audio_list.popup_out)

	if isDeal then
		-- self.btn_dealBonusCloseTip:setVisible(false)
		self.dealBonusTopNode:setVisible(true)
		self.dealBonusTopNode:setOpacity(255)
		self.dealBonusBaseExplain:setVisible(false)
		self.dealBonusYourBoxNode:setVisible(false)
	  	self.dealBonusNode:runAction(cc.FadeIn:create(0.3))
	else
		self.dealBonusTopNode:setVisible(false)
		self.dealBonusBaseExplain:setVisible(true)
		-- self.btn_dealBonusCloseTip:setVisible(true)
		self.dealBonusNode:runAction(cc.Sequence:create(
			cc.FadeIn:create(0.3),
			cc.CallFunc:create(function( ... )
				if not isLevelUp then 
					self.btn_dealBonusClose:setTouchEnabled(true)
					self.btn_dealBonusClose:setVisible(true)
					self:initDealBonusCloseEvent()
				end
			end)
		))
	end
	self.isDealBoardOpen = true
end

function cls:initDealBonusCloseEvent(isLevelUpBonus)
	self.isDealBonusClosePress = false
	-- 点击按钮
	local pressFunc = function(obj)
		self.isDealBonusClosePress = true
        self.btn_dealBonusClose:setTouchEnabled(false)
        self.btn_dealBonusClose:setVisible(false)
        self:playMusic(self.audio_list.common_click)
        self:hideDealBonusSceneAnimation(isLevelUpBonus)
	end

	local function onTouch(obj, eventType)
		if self.isDealBonusClosePress then return nil end
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end
	-- 设置按钮
	self.btn_dealBonusClose:addTouchEventListener(onTouch)
end

function cls:hideDealBonusSceneAnimation(isLevelUpBonus)
	self:playMusic(self.audio_list.popup_out)
	self.isOpenStoreNode = false

	-- if self.ctl:noFeatureLeft() then 
	-- 	self.ctl.footer:setSpinButtonState(false) -- 显示按钮
	-- 	self.ctl.footer:enableOtherBtns(true) -- 禁掉 其他按钮
	-- end

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.dealBonusNode:runAction(cc.FadeOut:create(0.3))
			self.btn_dealBonusClose:setTouchEnabled(false)
			self.btn_dealBonusClose:setVisible(false)
		end),
		cc.DelayTime:create(0.2),
		cc.CallFunc:create(function( ... )
			self.dealBonusNode:setVisible(false)
			-- if self.ctl.footer then
			-- 	self.ctl.footer:showActivitysNode()
			-- end
			self.isFeatureClick = false
		end)
	))
	self.isDealBoardOpen = false
end

function cls:checkInFeature() -- whj: 作用在 feature 结束重新打开商店,时候控制锁住bet控制
    local inFeature = false
    if self.isOpenStoreNode then 
        inFeature = true
    end
    return inFeature
end

function cls:clearNeedCollectCoinsBonus( ... )
	if self.bonus and self.bonus.bonusType == BonusGameType.deal then
		self.bonus:exitDealBonus()
	end
end

-------------------------------------------------- betFeature 相关 --------------------------------------------------
function cls:refreshDiskData(data)
    if data["all_disk_data"] then
        self.diskData = data["all_disk_data"]
    end
    if data["disk_data"] then
        local curBet = self.ctl:getCurBet() -- *self.ctl.maxLine
        if not self.diskData then self.diskData = {} end
        if data["disk_data"][tostring(curBet)] then
            self.diskData[tostring(curBet)] = data["disk_data"][tostring(curBet)]
        end
    end
    if data["fg_disk"] then 
        self.diskDataF = data["fg_disk"]
    end
end

function cls:getCurDiskData(Bet)
    if not self.diskData then return end
    local curDiskData = {}
    if self.showFreeSpinBoard then
        curDiskData = self.diskDataF
        return curDiskData
    end

    local curBet = ""
    if Bet then
        curBet = tostring(Bet)
    else
        curBet = tostring(self.ctl:getCurBet())
    end
    if self.diskData[curBet] then 
        curDiskData = self.diskData[curBet]
    end
    return curDiskData
end

function cls:getReelCellPos( value ) -- 横向排序
	local value = value % masterAddPos
    if value then 
        local col = (value-1)%baseColCnt + 1
        local row = math.floor((value-1)/baseColCnt) + 1
        return {col, row}
    end
end

function cls:topSetBet(list) -- 后续 需要确认 是否 快速点击的时候最后停下的位置 正确的
    if self.animateNode then -- 第一次 设置bet的时候 可能还没有 创建场景
        self:stopDrawAnimate()
    end

    self:changeFeaturePos(list, true)
end

function cls:changeFeaturePos(list, isReset)
    if not list then return end

    for k,v in pairs(self.stickySymbolNode:getChildren()) do 
        v:stopAllActions()
        v:setVisible(false)
    end

    for k, v in pairs(list) do 
        self:changeStickAnimState( v, isReset )
    end
end

function cls:changeStickAnimState( id, isReset )
	if bole.isValidNode(self.stickyAnimList[id]) then 
		local _curItem = self.stickyAnimList[id]
		_curItem:stopAllActions()
		_curItem:setVisible(true)

		if isReset then 
			bole.spChangeAnimation(_curItem,"animation2", true)
		else
			_curItem:runAction(cc.Sequence:create(
				cc.CallFunc:create(function ( ... )
					if bole.isValidNode(_curItem) then 
						bole.spChangeAnimation(_curItem,"animation1")
					end
				end),
				cc.DelayTime:create(20/30),
				cc.CallFunc:create(function ( ... )
					if bole.isValidNode(_curItem) then 
						bole.spChangeAnimation(_curItem,"animation2", true)
					end
				end)))
		end
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

		if bonusData and bonusData.wild_pos then
	    	self.wildPosFeature = bonusData.wild_pos
		end
	end	
end

function cls:outBonusStage()
	if self.bonusSpeical then 
		self.ctl.specials = self.bonusSpeical
	end

	self:resetWildPosByFeatureEnd()

	if self.ctl.bonusItem then
		self.ctl.rets.item_list = self.ctl.bonusItem
		self.ctl:resetBoardCellsSpriteOverBonus(self.ctl.bonusItem) -- 刷新牌面 + 动画播放
	end
	self.ctl.bonusItem    = nil	
	self.ctl.bonusRet     = nil
end

function cls:resetWildPosByFeatureEnd( ... )
	self.randomWildNode:removeAllChildren()
	self.stickWildSpine = nil

	if self.wildPosFeature and #self.wildPosFeature > 0 then 
		for _, id in pairs(self.wildPosFeature) do 
			self:showWildAnim(id)
		end
	end
	self.wildPosFeature = nil
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
        if not (self.ctl.freewin or self.showFreeSpinBoard) then 
            self:topSetBet(self:getCurDiskData(bet))
        end
        self:checkLockFeature()
    end
end

function cls:setBet()
    local set_Bet = self.tipBet
    local maxBet = self.ctl:getMaxBet()
    if maxBet >= set_Bet then
        self.ctl:setCurBet(set_Bet)
    end
end

function cls:onAllReelStop()
	Theme.onAllReelStop(self)


	if self.showFreeSpinBoard then 
		self.topAnimNode:stopAllActions()
		self.topAnimNode:runAction(cc.FadeOut:create(0.3))
	end

end

function cls:finshSpin()
    if (not self.ctl.freewin) and (not self.ctl.autoSpin) then
        self.isFeatureClick = false
    end
end

function cls:stopDrawAnimate() -- 可能存在 手动调用的可能
	Theme.stopDrawAnimate(self)

	self.jpAnimNode:stopAllActions()

	self.scatterAnimNode:removeAllChildren()
	self.jpAnimNode:removeAllChildren()

	self.animNodeList = nil
	self.scatterBGState = nil
	self.stickWildSpine = nil
end

function cls:cleanStatus( stillEffect )
	Theme.cleanStatus(self, stillEffect)
end


----------------------------------- 弹窗通用显示效果 -----------------------------
function cls:dialogPlayLineAnim( state, dimmer, root )
    if state == "show" then 
        if dimmer then
            dimmer:setVisible(true)
            dimmer:setOpacity(0)
            dimmer:runAction(cc.Sequence:create(cc.FadeTo:create(0.2, 200)))
        end
        if root then
            root:setVisible(true)
            root:setScale(0)
            root:runAction(cc.Sequence:create(cc.ScaleTo:create(0.4, 1.2),cc.ScaleTo:create(0.1, 1)))
        end
    else
        if dimmer then
            dimmer:setVisible(true)
            dimmer:setOpacity(200)
            dimmer:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.FadeTo:create(0.2, 0)))
        end
        if root then
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

local freeSpinDialogConfig = {
     ["csb"] = "csb/dialog_free.csb", ["spine"] = "spine/dialog/free/fgtanchuang", ["animName"] = {"animation2", nil, "animation1"}, ["showTime"] = {34/30, nil, 40/30}, ["maxW"] = 550 ,
}

function cls:playFeatureDialogAnim( showNode, sType, _dConfig )
    local animName =  _dConfig.animName[sType]

    local _ ,s = self:addSpineAnimation(showNode, -1, self:getPic(_dConfig.spine), cc.p(0,0), animName, nil, nil, nil, true)
        s:runAction(cc.Sequence:create(
            cc.DelayTime:create(_dConfig.showTime[sType] or 1),
            cc.CallFunc:create(function ( ... )
                bole.spChangeAnimation(s, animName.."_1", true)
            end)))
    if sType == fs_show_type.start then -- 出现   第13 - 27帧开始出现按钮 数字在10-23帧恢复到1倍大小
        if bole.isValidNode(showNode.btnStart) then 
            showNode.btnStart:setScale(0)
            showNode.btnStart:runAction(cc.Sequence:create(
                cc.DelayTime:create(15/30),
                cc.ScaleTo:create(5/30, 1)))
        
            local btnSize = showNode.btnStart:getContentSize()
            self:addSpineAnimation(showNode.btnStart, nil, self:getPic("spine/dialog/fangxing"), cc.p(btnSize.width/2,btnSize.height/2), "animation", nil, nil, nil, true,true)-- 播放 结果动画
        end
        if bole.isValidNode(showNode.labelCount) then 
            showNode.labelCount:setScale(0.62)
            showNode.labelCount:setVisible(false)
            showNode.labelCount:runAction(cc.Sequence:create(
                cc.DelayTime:create(17/30),
                cc.Show:create(),
                cc.ScaleTo:create(5/30, 1.02),
                cc.ScaleTo:create(2/30, 1)))
        end
    elseif sType == fs_show_type.collect then -- 出现   第13 - 27帧开始出现按钮 数字在7-34帧恢复到1倍大小 0.62(7)-1.02(14) - 0.9(23)- 1(34)       
        if bole.isValidNode(showNode.btnCollect) then 
            showNode.btnCollect:setScale(0)
            showNode.btnCollect:runAction(cc.Sequence:create(
                cc.DelayTime:create(15/30),
                cc.ScaleTo:create(5/30, 1.1)))

            local btnSize = showNode.btnCollect:getContentSize()
            self:addSpineAnimation(showNode.btnCollect, nil, self:getPic("spine/dialog/fangxing"), cc.p(btnSize.width/2,btnSize.height/2), "animation", nil, nil, nil, true,true)-- 播放 结果动画
        end
        if bole.isValidNode(showNode:getChildByName("label_node")) then 
            local labelNode = showNode:getChildByName("label_node")
            labelNode:setScale(0.62)
            labelNode:setVisible(false)
            labelNode:runAction(cc.Sequence:create(
                cc.DelayTime:create(17/30),
                cc.Show:create(),
                cc.ScaleTo:create(5/30, 1.02),
                cc.ScaleTo:create(2/30, 1)))
        end
    end
end

function cls:showFreeSpinDialog(theData, sType)
    local _dConfig = freeSpinDialogConfig

	local config = {}
	config["gen_path"] = self:getPic("csb/")
	config["csb_file"] = self:getPic(_dConfig.csb)
	config["frame_config"] = {
		-- start: 第二个参数 注册点击事件的方法; 第四个参数 .theme:onCollectFreeClick 回调(可以 理解为 点击事件立马就会被调用了,跟第四个参数没有关系); 第六个参数 回调endEvent方法(一般在 endEvent里面场景切换回调) 最后一个参数 是 延迟删除的时间
		["start"] 		 = {nil, 1, nil, 0, transitionDelay.free.onCover + dialogShowOrHideTime, (transitionDelay.free.onEnd - transitionDelay.free.onCover-dialogShowOrHideTime), 0.5},
		["collect"] 	 = {nil, 1, nil, 0, transitionDelay.free.onCover + dialogShowOrHideTime, (transitionDelay.free.onEnd - transitionDelay.free.onCover), 0},-- 最后一个参数 是延时删除的时间 -- 倒数第二个参数 回调 完成方法
	}
	self.freeSpinConfig = config 

	local theDialog = G_FREE_SPIN_DIALOGS["base"].new(self.ctl, self.freeSpinConfig)
	if sType == fs_show_type.start then
		theDialog:showStart(theData)
		self:playFeatureDialogAnim( theDialog.startRoot, sType, _dConfig )
	elseif sType == fs_show_type.more then
		theDialog:showMore(theData)
		-- addLizi(theDialog)
	elseif sType == fs_show_type.collect then
		theDialog:setCollectScaleByValue(theData.coins, _dConfig.maxW)
		theDialog:showCollect(theData)
		self:playFeatureDialogAnim( theDialog.collectRoot, sType, _dConfig)
	end
	self.freeDialogNode = theDialog
end

function cls:playStartFreeSpinDialog( theData )
	self.isInFreeGame = true


    local enter_event = theData.enter_event
    theData.enter_event = function()
        self:dialogPlayLineAnim("show", self.featureDialogDimmer)
        self:hideActivitysNode()
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

		self.ctl.footer:enableOtherBtns(false)
		self:runAction(cc.Sequence:create(
			cc.DelayTime:create(dialogShowOrHideTime),
			cc.CallFunc:create(function ( ... )

				self:playTransition(nil,"free")-- 转场动画
			end)))
	end

	local changeLayer_event = theData.changeLayer_event
	theData.changeLayer_event = function()
		if changeLayer_event then
			changeLayer_event()
		end
		self:changeSpinBoard(SpinBoardType.FreeSpin)
	end

	local endEvent = theData.end_event
	theData.end_event = function ( ... )
		self:dealMusic_PlayFreeSpinLoopMusic()
		self:showActivitysNode()
		if endEvent then 
			endEvent()
		end
	end

	self:showFreeSpinDialog(theData, fs_show_type.start)
end

function cls:playMoreFreeSpinDialog( theData )
	self:showFreeSpinDialog(theData, fs_show_type.more)
end

function cls:playCollectFreeSpinDialog( theData )
    local enter_event = theData.enter_event
    theData.enter_event = function()
        self:stopAllLoopMusic()
        self:dialogPlayLineAnim("show", self.featureDialogDimmer)
        self:hideActivitysNode()
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

	local endEvent = theData.end_event
	theData.end_event = function ( ... )
		self:showActivitysNode()
		if endEvent then 
			endEvent()
		end
	end

	self:showFreeSpinDialog(theData, fs_show_type.collect)
end

---------------------- symbol 动画相关 ----------------------
function cls:playBackBaseGameSpecialAnimation( theSpecials ,enterType)
	self:playFreeSpinItemAnimation(theSpecials ,enterType)

	self:resetWildPosByFeatureEnd()
end

function cls:playFreeSpinItemAnimation( theSpecials ,enterType)
	local delay = 2
	if not theSpecials or not theSpecials[specialSymbol["scatter"]] then return end
	
	if enterType then
		self:playMusic(self.audio_list.trigger_bell)
		self:laterCallBack(1,function ( ... )
			for col, rowTagList in pairs(theSpecials[specialSymbol["scatter"]]) do
				for row, tagValue in pairs(rowTagList) do
					self:addItemSpine(specialSymbol["scatter"], col, row)
				end
			end

		end)
	else
		for col, rowTagList in pairs(theSpecials[specialSymbol["scatter"]]) do
			for row, tagValue in pairs(rowTagList) do
				self:addItemSpine(specialSymbol["scatter"], col, row)
			end
		end
	end

	return delay
end

function cls:addItemSpine(item, col, row, animName)
	local layer			= self.scatterAnimNode
	local animName		= animName or "animation"
	local pos			= self:getCellPos(col, row)
	local spineFile		= self:getPic("spine/item/"..item.."/spine")

	local cell = self.spinLayer.spins[col]:getRetCell(row)
	cell:setVisible(false)
	local _, s1 = self:addSpineAnimation(layer, 100, spineFile, pos, animName, nil, nil, nil, true, true)
end

function cls:addZeusSpine(item, col, row, showCom)
	if self.zeus_cnt and self.zeus_cnt[col] then
		local cellHeight = self.spinLayer.spins[col].cellHeight

		if showCom then
			for k,v in pairs(self.zeus_cnt[col]) do 
				local pos			= self:getCellPos(col, k)
				local spineFile     = ""
				local animateName 	= ""
				if v>1 then 
					spineFile           = self:getPic("spine/item/"..specialSymbol.zeus.."/spine")
					animateName = "animation"..v
					local _, s1 = self:addSpineAnimation(self.animateNode, 10, spineFile, pos, animateName,nil,nil,nil,true)

					self.animNodeList = self.animNodeList or {}
					for i=k,k+v-1 do 
						self:laterCallBack(10/30,function ( ... )
							local cell = self.spinLayer.spins[col]:getRetCell(i)
							cell:setVisible(false)
						end)

						if not self.animNodeList[col.."_"..i] then 
							self.animNodeList[col.."_"..i] = {s1,animateName.."_1"}
						end
					end
				end
			end
		else
			for k,v in pairs(self.zeus_cnt[col]) do
				local pos			= self:getCellPos(col, k)
				local spineFile     = ""
				local animateName 	= "" 
				if v == 1 then 
					local cell = self.spinLayer.spins[col]:getRetCell(k)
					cell:setVisible(false)
					spineFile           = self:getPic("spine/item/"..specialSymbol.zeus.."/spine")
					animateName 	= "animation1_1"
					local _, s2 = self:addSpineAnimation(self.animateNode, 10, spineFile, pos, animateName,nil,nil,nil,true)
					self.animNodeList = self.animNodeList or {}
					self.animNodeList[col.."_"..k] = {s2, animateName}
				elseif v>1 then 
					self:playOldAnimation(col,k)
				end
			end
			self.zeus_cnt[col] = nil -- 防止多次进入
		end
	end
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
	local spineItemsSet = Set({specialSymbol.blank, specialSymbol.zeus, 1, 3, 4, 5, 6, 7})

	if self.stickWildSpine and self.stickWildSpine[col] and self.stickWildSpine[col][row] then 
		local item = self.stickWildSpine[col][row]
		bole.spChangeAnimation(item,"animation2",false)
	elseif spineItemsSet[item] then 
		if effectStatus == "all_first" then
			if item == specialSymbol.zeus then 
				self:addZeusSpine(item, col, row )
			else
				self:playItemAnimation(item, col, row, parent)
			end
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
		local node = self.animNodeList[col.."_"..row][1]
		local animationName = self.animNodeList[col.."_"..row][2]

		if bole.isValidNode(node) and animationName then 
			bole.spChangeAnimation(node,animationName,false)
		end
	end
end

function cls:drawLinesThemeAnimate( lines, layer, rets, specials)
	local timeList = {2,2}
	Theme.drawLinesThemeAnimate(self, lines, layer, rets, specials,timeList)
end

function cls:playSymbolNotifyEffect( pCol, reelSymbolState ) 
	for  key , list in pairs(self.notifyState[pCol]) do
		for _, crPos in pairs(list) do
			local cell = nil
			if self.fastStopMusicTag then 
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2])
			else
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2]+1)
			end
			if cell then 
				local animateName = "animation1"
				local fileName = key

				local spineFile		= self:getPic("spine/item/"..fileName.."/spine")
				local _,s = self:addSpineAnimation(cell, 22, spineFile, cc.p(0,0), animateName,nil,nil,nil,true)
				cell.sprite:setVisible(false)
				cell.symbolTipAnim = s
			end	
		end
	end
end

function cls:dealMusic_PlaySpecialSymbolStopMusic( pCol )
	self.notifyState = self.notifyState or {}
	if (not self.notifyState[pCol]) or bole.getTableCount(self.notifyState[pCol]) == 0 then 
		return false
	end
	local ColNotifyState = self.notifyState[pCol]
	local haveSymbolLevel = 3
 	if ColNotifyState[specialSymbol["scatter"]] then -- scatter
		if haveSymbolLevel >1 then
			haveSymbolLevel = 1
		end
		self:playSymbolNotifyEffect(pCol) -- 播放特殊symbol 下落特效
	elseif ColNotifyState[specialSymbol["blank"]] then -- bonus 落地
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
	self.audio_list.special_stop2 		= "audio/base/symbol_bonus.mp3"		-- bonus落地音
	self.audio_list.popup_out 			= "audio/base/popup_out.mp3"		-- 通用关闭
	self.audio_list.lightning1 			= "audio/base/lightning1.mp3"		-- 雷神劈闪电打到棋盘上
	self.audio_list.lightning2 			= "audio/base/lightning2.mp3"		-- 雷神劈闪电打到jp栏上
	-- self.audio_list.jp 					= "audio/base/jp.mp3"				-- jp栏框起来选中
	self.audio_list.expand 				= "audio/base/expand.mp3"			-- 棋盘劈闪电+wild扩展
	self.audio_list.change_wild 		= "audio/base/change_wild.mp3"		-- 框变成wild
	self.audio_list.collect_unlock 		= "audio/base/collect_unlock.mp3"	-- 收集条解锁
	self.audio_list.collect_lock 		= "audio/base/collect_lock.mp3"		-- 收集条上锁
	self.audio_list.collect_full 		= "audio/base/collect_full.mp3"		-- 集满收集条
	self.audio_list.collect_fly 		= "audio/base/collect_fly.mp3"		-- 收集bonus飞+接收
	self.audio_list.common_click 		= "audio/base/btn_click.mp3"		-- 收集bonus飞+接收
	
	-- free
	self.audio_list.retrigger_bell	 			= "audio/base/bell.mp3"
	self.audio_list.free_dialog_collect_click 	= "audio/base/btn_click.mp3"
	self.audio_list.free_dialog_start_close 	= "audio/base/btn_click.mp3"
	
	-- bonus
	self.audio_list.mul 					= "audio/bonus/mul.mp3" 		-- 倍数暗掉
	self.audio_list.grail_out 				= "audio/bonus/grail_out.mp3"	-- 圣杯出现
	self.audio_list.grail_open 				= "audio/bonus/grail_open.mp3" 	-- 圣杯移动到中间，展示结果
	self.audio_list.grail_fly 				= "audio/bonus/grail_fly.mp3" 	--圣杯飞
	self.audio_list.bonus_click 			= "audio/bonus/click.mp3" 		-- 点击选择按键
	self.audio_list.choose 					= "audio/bonus/choose.mp3" 		-- 点击圣杯
	self.audio_list.change3 				= "audio/bonus/change3.mp3" 	-- 雷神跟小孙之间切换
	self.audio_list.change2 				= "audio/bonus/change2.mp3" 	-- 雷神跟小孙之间切换
	self.audio_list.change1 				= "audio/bonus/change1.mp3" 	-- 切换界面出现
	self.audio_list.bonus_end 				= "audio/bonus/bonus_end.mp3" 	-- bonus结束旋律
	self.audio_list.num_change 				= "audio/bonus/1000x.mp3" 		-- 1000X被换掉
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

-- retrigger
function cls:dealMusic_PlayFSMoreMusic( )
	self:playMusic(self.audio_list.free_dialog_more_show)
end

-- 播放bonus game的背景音乐
function cls:dealMusic_EnterBonusGame()
	-- 播放背景音乐
	AudioControl:stopGroupAudio("music")
	self:playLoopMusic(self.audio_list.bonus_background)
	AudioControl:volumeGroupAudio(1)
end

-----------------------------Transition弹窗相关------------------------------
function cls:playTransition(endCallBack,tType)
	local function delayAction()
		local transition = ZeusTransition.new(self,endCallBack)
		transition:play(tType)
	end	
	delayAction()
end

ZeusTransition = class("ZeusTransition", CCSNode)
local GameTransition = ZeusTransition

function GameTransition:ctor(theme, endCallBack)
	self.spine = nil
	self.theme = theme
	self.endFunc = endCallBack
end

function GameTransition:play(tType)
	local spineFile = self.theme:getPic("spine/base/basezhousi_01") -- 默认显示 Free transition
	local pos = cc.p(0,0)
	local delay1 = transitionDelay[tType]["onEnd"] -- 切屏结束 的时间
	local animName = "animation1_2"
	local audioFile = self.theme.audio_list.transition_free
	
	if tType == "bonus" then 
		spineFile = self.theme:getPic("spine/base/shengbei01") -- 默认显示 Free transition
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

function cls:runStartAni()
	self.ctl.footer:setVisible(false)
	self.ctl.header:setVisible(false)
	
	local downY, downGap = self.down_child:getPositionY(), 500
	self.down_child:setPositionY(downY - downGap)

	local topY, topGap = self.topNode:getPositionY(), 500
	self.topNode:setPositionY(topY + topGap)

	local _, ani = self:addSpineAnimation(self.mainThemeScene, 100, self:getPic("spine/base/basezhousi_01"), cc.p(0, 0), "animation1_2", nil, nil, nil, false) 

	self.mainThemeScene:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function()
				local _, logos = self:addSpineAnimation(self.down_node, -1, self:getPic("spine/base/basezhousi_01"), cc.p(0, 440.00), "animation1", nil, nil, nil, true, true)
				self.logoSpine = logos
				self.logoAnimName = "animation1"
				self.ctl.footer:setVisible(true)
				self.ctl.header:setVisible(true)
				self.ctl.footer:enterAction()
				self.ctl.header:enterAction()
			end),
			cc.DelayTime:create(0.3),
			cc.CallFunc:create(function()
				self.down_child:runAction(cc.MoveBy:create(0.8, cc.p(0, downGap)))
				self.topNode:runAction(cc.MoveBy:create(0.8, cc.p(0, -topGap)))
			end)
		)
	)

end

--------------------------------- take it or leave it && Bonus ---------------------------------

ZeusBonus = class("ZeusBonus")
local bonusGame = ZeusBonus

local chooseOverColor = cc.c3b(200,200,200)

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

	self.bonusType 		= self.data.core_data.type -- type1对应repsin type2对应 deal game type3对应 level
	self.theme:stopDrawAnimate()
	self.theme.ctl.footer:setSpinButtonState(true)-- 禁掉spin按钮
	
	self.theme:saveBonusData(self.data.core_data)
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

	if self.bonusType == BonusGameType.deal then	
		self:enterPlayDealBonusGame(tryResume)
	elseif self.bonusType == BonusGameType.level then
		self:enterDealBonusLevelUp(tryResume)
	end
end

---------------------------- bonus -> deal  相关逻辑 start --------------------------------------
local roundBonusStateList =
{
	waiting = 1,
	choosing = 2,
	show_result = 3,
	get_result = 4,
	finish = 5
}

-- deal Bonus LevelUp
function bonusGame:enterDealBonusLevelUp()
	self.mapLevel = self.data.core_data["map_level"]
	-- 在此之后断电重连就不用恢复了
	self.data["end_game"] = true
	self:saveBonus()
	-- 收钱
	self.theme.ctl:collectCoins(1)
	self.theme.bonus = nil
	self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(2),
		cc.CallFunc:create(function()
			self.theme:stopCollectPartAnimation()
			self.theme:showDealBonusSceneAnimation(self.mapLevel,true)
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			self.theme:showGiftCollectedAnimation(self.mapLevel)
		end),
		cc.DelayTime:create(1+1),
		cc.CallFunc:create(function()
			
			self.theme:setCollectProgressImagePos(0)
			self.theme.mapPoints = 0

			-- self.theme.btn_dealBonusClose:setTouchEnabled(true)
			-- self.theme.btn_dealBonusClose:setVisible(true)
			-- self.theme:initDealBonusCloseEvent(true)
			self.ctl:addCoinsToHeader() -- 如果没有其他feature 手动控制一次 save金钱,因为bonus结束之后灭有收钱操作
			
			self.theme:hideDealBonusSceneAnimation()
		end),
		cc.DelayTime:create(0.3),
		cc.CallFunc:create(function ( ... )
			self.theme:dealMusic_FadeLoopMusic(0.3, 0.3, 1)
			if self.ctl:noFeatureLeft() then 
				self.ctl:removePointBet()
			end
			self.callback()
			self.theme.isInBonusGame = false
		end)
	))
end

-- deal bonus game 
function bonusGame:enterPlayDealBonusGame(tryResume)
	self:initDealBonusData()
	local function playIntro()
		LoginControl:getInstance():saveBonus(self.theme.themeid, nil)

		self.theme:runAction(cc.Sequence:create(
			cc.DelayTime:create(2),
			cc.CallFunc:create(function()
				self.theme:stopCollectPartAnimation()
				self.theme:showDealBonusSceneAnimation(self.mapLevel, true, true)
			end),
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function()
				self.theme:showGiftCollectedAnimation(self.mapLevel)
			end),
			cc.DelayTime:create(1),
			cc.CallFunc:create(function()
				self.theme:dealMusic_FadeLoopMusic(0.3, 1, 0) 
				self.theme:runAction(cc.Sequence:create(
					cc.DelayTime:create(0.3),
					cc.CallFunc:create(function ( ... )
						self.theme:stopAllLoopMusic()
					end)))

				self.theme:setCollectProgressImagePos(0)
				self.theme.mapPoints = 0
				self:showStartDealBonusGame()
			end)
		))
	end

	local function snapIntro()

		self:showPlayDealBonusGameScene()
		self:initGiftsBtnEvent()
		self:setPickBtnState(false)

		local function recoverDealBonusCollectState()
			self:setPickedGiftState(self.data.playRound)
			self:showYourGiftMessage(false,false)
			self.dealBonusWin = self.dealBonusWinList[self.data.playRound-1]
			self:showDealBonusCollectBoard(true, true)
		end
	
		if self.data.gameEnd then
			recoverDealBonusCollectState()
			self:showTipTitleState("tip")
		else
			self.theme:dealMusic_EnterBonusGame()
			if self.data.playRound == 7 then
				self:setPickedGiftState(self.data.playRound-1)
				self:showYourGiftMessage(false,false,true)
				self:showLastOfferBoard(false)
			elseif self.data.playRound == 1 then
				if self.data.roundState[self.data.playRound] == roundBonusStateList.waiting then
					self:setPickBtnState(true)
					self:showYourGiftMessage(true,false)
					self:showTipTitleState("start")
				else
					self:showYourGiftMessage(false,false,true)
					self.data.playRound = self.data.playRound + 1
					self:saveBonus()					
					self:playNextRound()
				end
			else
				self:setPickedGiftState(self.data.playRound-1)
				self:showYourGiftMessage(false,false,true)
				if self.data.roundState[self.data.playRound] == roundBonusStateList.waiting then
					self:playNextRound()
					self:showTipTitleState("choose")
				elseif self.data.roundState[self.data.playRound] == roundBonusStateList.choosing then
					self:recoverChoosedGiftState()
					self:setPickBtnState(true)
					self:showTipTitleState("choose")
				elseif self.data.roundState[self.data.playRound] == roundBonusStateList.show_result then
					self:recoverChoosedGiftState()
					self:displayThisRoundPickResult(true)
					self:showTipTitleState("tip")
				elseif self.data.roundState[self.data.playRound] == roundBonusStateList.get_result then
					self:setPickedGiftState(self.data.playRound)
					self:showNormalOfferAnimaton()
					self:showTipTitleState("tip")
				end
			end		
		end
	end

	if tryResume then
		snapIntro()
	else
		playIntro()
	end
end

function bonusGame:initDealBonusData( ... )
	self.mapLevel = self.data.core_data["map_level"]
	self.data.pickedCount = self.data.pickedCount or 0
	self.data.playRound = self.data.playRound or 1
	self.data.gameEnd = self.data.gameEnd or false
	self.data.eachRoundRemainingCount = self.data.eachRoundRemainingCount or tool.tableClone(roundPickCnt)

	self.data.mulStarList = self.data.mulstar or {true,true,true,true,true, true,true,true,true,true, true,true,true,true,true, true,true,true,true,true, true,true,true,true,true, true} -- 26
	self.data.giftList = self.data.giftList or {0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0} -- 26
	
	
	self.data.eachRoundPickedCount = self.data.eachRoundPickedCount or {0,0,0,0,0,0,0} -- 取做多的次数7
	self.data.recordList = self.data.recordList or {0,0,0,0,0} -- 选择次数一共是 5 次 ,存放可以 take的值
	self.data.choosedGiftIndex = self.data.choosedGiftIndex or {0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0} -- 26
	self.data.roundState = self.data.roundState or {1,1,1,1,1,1} -- round 次数 
	
	self:saveBonus()

	self.avg_bet = self.data.core_data["avg_bet"]
	self.roundPickCountList = roundPickCnt

	self.pickFromToList = {[1] = {26,26},[2] = {1,7},[3] = {8,13},[4] = {14,18},[5] = {19,22},[6] = {23,24},[7] = {25,25}}
	self.multiList = self.data.core_data["multi_list"]
	self.dealList = self.data.core_data["deal_list"]
	self.fakeList = {0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0} -- 26 个
	self.previousWin = self.ctl.totalWin or 0
	local fake_list = self.data.core_data["fake_list"]

	for i, index in pairs(fake_list) do 
		if i < 3 then
			self.fakeList[index] = fakeDataMax
		else
			self.fakeList[index] = fakeDataMini
		end
	end
	self.dealBonusWinList = self.data.core_data["win_list"]

	self:updatePerviousOffersLabels()
end

function bonusGame:updatePerviousOffersLabels()
	for i = 1, 5 do
		if self.data.recordList[i] > 0 then
			local mul = self.dealList[i]
			self.theme.dealbonusDealLabels[i]:setString(mul.."X")
		else
			self.theme.dealbonusDealLabels[i]:setString("")
		end
	end
end

function bonusGame:stopDealBoardAnimation( node )
	node:removeAllChildren()
end

function bonusGame:recoverChoosedGiftState()
	local file = self.theme:getPic("spine/map/shengbeixuanzhong")
	local pickIndexBegin = self.pickFromToList[self.data.playRound][1]
	local pickIndexEnd = self.pickFromToList[self.data.playRound][2]
	for i = pickIndexBegin,pickIndexEnd do
		local index = self.data.choosedGiftIndex[i]
		if index > 0 then
		   self.theme:addSpineAnimation(self.theme.dealBonusGiftAniNodeList[index],nil,file,cc.p(0,0),"animation",nil,nil,nil,true)
		   -- self.theme.dealBonusGiftList[index].node:setColor(chooseOverColor)
		end
	end	
end

function bonusGame:setPickedGiftState(playRound)
	if playRound >= 2 then
		for i = 1, maxMapLevel do
			if self.data.giftList[i] > 1 then
				if self.data.giftList[i] <= playRound then
					self.theme.dealBonusGiftList[i].node:setVisible(false)
					self.theme.dealBonusGiftList[i].label:setString(i)				
				end
			end
		end

		local mulEndIndex = self.pickFromToList[playRound][2]
		for i = 1,mulEndIndex do -- 设置选择完成的是 灰色的状态
			local mul = self.multiList[i]
			local labelIndex = multiValueIndexConfig[mul]
			local temp = self.theme.dealBonusMultList[labelIndex]
			
			temp.node:setColor(dimColor)
			-- temp.node:setOpacity(255)
	  --   	temp.sp:setColor(cc.c3b(84,84,84))
	  --   	temp.label:setColor(cc.c3b(100,100,100))
			temp.label:setString(mul.."X")
		end
	end
end

function bonusGame:showStartDealBonusGame()
	local csbPath = self.theme:getPic("csb/dialog_deal.csb")
	local dialog 		= cc.CSLoader:createNode(csbPath)
	local rootNode 		= dialog:getChildByName("root")
	local showNode 		= rootNode:getChildByName("node_start")
	rootNode:getChildByName("node_collect"):setVisible(false)
	local startBtn 		= showNode:getChildByName("start_btn")

	self.theme.curScene:addToContentFooter(dialog)
	self.theme:playMusic(self.theme.audio_list.popup_out)
	self.theme:dialogPlayLineAnim("show", self.theme.dealBonusDimmer)

	-- 播放spine 动画
	local _,s = self.theme:addSpineAnimation(showNode, -1, self.theme:getPic("spine/dialog/deal/jiesuan"), cc.p(1, 17), "animation2", nil, nil, nil, true)
	s:runAction(cc.Sequence:create(
		cc.DelayTime:create(20/30),
		cc.CallFunc:create(function ( ... )
			bole.spChangeAnimation(s, "animation2_1", true)
		end)))

    if bole.isValidNode(startBtn) then 
        startBtn:setScale(0)
        startBtn:runAction(cc.Sequence:create(
            cc.DelayTime:create(15/30),
            cc.ScaleTo:create(5/30, 1.1)))

        local size = startBtn:getContentSize()
        self.theme:addSpineAnimation(startBtn, nil, self.theme:getPic("spine/dialog/deal/startanniu"), cc.p(size.width/2,size.height/2), "animation", nil, nil, nil, true, true)-- 添加特效
    end
	
	local clickEndFunction = function ( obj, eventType )
		if eventType == ccui.TouchEventType.ended then
			startBtn:setTouchEnabled(false)
			startBtn:removeAllChildren() -- 删除循环扫光特效

			self.theme:dialogPlayLineAnim("hide", self.theme.dealBonusDimmer, rootNode)
			self.theme:playMusic(self.theme.audio_list.common_click)
			self.theme:playMusic(self.theme.audio_list.popup_out)
			dialog:runAction(cc.Sequence:create(
				cc.DelayTime:create(1), 
				cc.CallFunc:create(function ( ... )
					self:initGiftsBtnEvent()
					self:showTipTitleState("start")	    

					self:setPickBtnState(true)
					self.theme:dealMusic_EnterBonusGame()
				end), 
				cc.RemoveSelf:create()))
		end
	end

	dialog:runAction(cc.Sequence:create(
		cc.DelayTime:create(0.5), 
		cc.CallFunc:create(function ()
			startBtn:addTouchEventListener(clickEndFunction)
		end)))
end

function bonusGame:showPlayDealBonusGameScene()
	if self.theme.ctl.footer then
		self.theme.ctl.footer:hideActivitysNode()
	end
	self.theme.isOpenStoreNode = true
	for i = 1,maxMapLevel do
		local mul = multiData[i]
		self.theme.dealBonusMultList[i].label:setString(mul.."X")
		if self.data.mulStarList[i] then -- 设置 还没有获取的 mul 为正常颜色
    		local temp = self.theme.dealBonusMultList[i]

    		temp.node:setColor(normalColor)
    		-- temp.node:setOpacity(255)
	    	-- temp.sp:setColor(cc.c3b(255,255,255))
	    	-- temp.label:setColor(cc.c3b(255,255,255))
		else
			local temp = self.theme.dealBonusMultList[i]
			temp.node:setColor(dimColor)
			-- temp.node:setOpacity(255)
			-- temp.sp:setColor(cc.c3b(84,84,84))
			-- temp.label:setColor(cc.c3b(100,100,100))
		end

		if self.data.giftList[i] == 0 or self.data.giftList[i] > 1 then
			self.theme.dealBonusGiftList[i].node:setVisible(true)
			self.theme.dealBonusGiftList[i].label:setString(i)
			self.theme.dealBonusGiftList[i].image:setColor(cc.c3b(255,255,255))
		else
			self.theme.dealBonusGiftList[i].node:setVisible(false)
		end
	end

	self.theme.dealBonusNode:setOpacity(255)
	self.theme.dealBonusNode:setVisible(true)
	self.theme.dealBonusTopNode:setVisible(true)
	self.theme.dealBonusTopNode:setOpacity(255)
	self.theme.dealBonusBaseExplain:setVisible(false)
	self.theme.dealBonusYourBoxNode:setVisible(false)
	self.theme.dealbonusOfferNode:setVisible(false)
	self.theme.dealBonusLastOfferNode:setVisible(false)
	-- self.theme.btn_dealBonusCloseTip:setVisible(false)
end

function bonusGame:getRamdonTipPosList( ... )
    local totalTipCnt = bole.getTableCount(self.pickSpineList) 
    local showTipCnt = math.ceil(totalTipCnt/7)
    local posList = {}

    local totalPosList = {}
    for k, v in pairs(self.pickSpineList) do 
        table.insert(totalPosList, k)
    end
    while #posList < showTipCnt do
        local p = table.randomPop(totalPosList)
        table.insert(posList, p)
    end
    return posList
end

function bonusGame:setBtnTipAnimState( state )
    self.theme.pickItemsNode:stopAllActions()
    if state then -- 开启延迟显示提示动画
        self.theme.pickItemsNode:runAction(
            cc.RepeatForever:create(
                cc.Sequence:create(
                cc.DelayTime:create(2),
                cc.CallFunc:create(function ( ... )
                    local posList = self:getRamdonTipPosList()
                    for _, index in pairs(posList) do 
                        if bole.isValidNode(self.pickSpineList[index]) then 
                            self.pickSpineList[index]:setVisible(true)
                            bole.spChangeAnimation(self.pickSpineList[index], "animation")
                        end
                    end
                end))))
    end
end

function bonusGame:initGiftsBtnEvent()
	self.pickSpineList = {}

	for i = 1,maxMapLevel do
		if self.data.giftList[i] == 0 then
			self:initDealBonusGiftBtnEvent(i)

			if bole.isValidNode(self.theme.dealBonusGiftAniNodeList[i]) then 
				local _, s = self.theme:addSpineAnimation(self.theme.dealBonusGiftAniNodeList[i], 5, self.theme:getPic("spine/map/shengbeixunhuan"), cc.p(0,0), "animation", nil, nil, nil, true)
				self.pickSpineList[i] = s
				self.pickSpineList[i]:setVisible(false)
			end
		end
	end
end

function bonusGame:setPickBtnState( state )
	for i = 1,maxMapLevel do
		local _state = false
		if self.data.giftList[i] == 0 and state then 
			_state = true
		end
		self.theme.dealBonusGiftBtnList[i]:setTouchEnabled(_state)
		self.theme.dealBonusGiftBtnList[i]:setVisible(_state)
	end

	self:setBtnTipAnimState(state)
end

function bonusGame:showYourGiftMessage(isEmpty,isAnimate,isRecover) -- 显示选择的 礼物盒子
	if isEmpty then
	else
		local index = self.data.choosedGiftIndex[maxMapLevel]
		self.theme.dealBonusGiftList[index].node:setVisible(false)

		self.theme.dealBonusYourBoxNode:setVisible(true)
		self.theme.dealBonusYourBoxNode:setPosition(yourGiftEndPos)
		self.theme.dealBonusYourBoxLabel:setString(index)

		if isRecover then
			local _,s = self.theme:addSpineAnimation(self.theme.dealBonusTopNode,-1,self.theme:getPic("spine/map/dashengbeixunhuan"), yourGiftEndPos,"animation",nil,nil,nil,true,true)
			self.yourBoxBgSpine = s
			-- self.yourBoxBgSpine:setScale(0.8)
		end
	end
end

function bonusGame:initDealBonusGiftBtnEvent(index)
	local clickFunc = function(obj)-- 点击按钮
	    local file = self.theme:getPic("spine/map/shengbeixuanzhong")
		self.data.roundState[self.data.playRound] = roundBonusStateList["choosing"]
		self:saveBonus()
		self.theme.dealBonusGiftBtnList[index]:setTouchEnabled(false)
		self.theme.dealBonusGiftBtnList[index]:setVisible(false)

		if bole.isValidNode(self.pickSpineList[index]) then 
			self.pickSpineList[index]:removeFromParent()
		end

		self.theme:playMusic(self.theme.audio_list.choose)

        self.data.pickedCount = self.data.pickedCount + 1
        if self.data.pickedCount == 1 then
        	self.data.choosedGiftIndex[maxMapLevel] = index
        elseif self.data.pickedCount > 1 then
        	self.data.choosedGiftIndex[self.data.pickedCount - 1] = index

        	self.theme:addSpineAnimation(self.theme.dealBonusGiftAniNodeList[index],2,file,cc.p(0,0),"animation",nil,nil,nil,true)
        	-- self.theme.dealBonusGiftList[index].node:setColor(chooseOverColor)
        	-- self.theme:runAction(cc.Sequence:create(
        	-- 	cc.CallFunc:create(function()
        	-- 		self.theme:addSpineAnimation(self.theme.dealBonusGiftAniNodeList[index],2,file,cc.p(0,0),"animation",nil,nil,nil,true)
        	-- 	end),
        	-- 	cc.DelayTime:create(10/30),
        	-- 	cc.CallFunc:create(function( ... )
        	-- 		self.theme.dealBonusGiftList[index].node:setColor(chooseOverColor)
        	-- 	end)
        	-- ))
        	
        end

		self.data.giftList[index] = self.data.playRound
		self.data.eachRoundRemainingCount[self.data.playRound] = self.data.eachRoundRemainingCount[self.data.playRound] - 1
		self:showTipTitleState("choose")
		self.data.eachRoundPickedCount[self.data.playRound] = self.data.eachRoundPickedCount[self.data.playRound] + 1
		self:saveBonus()

		if self.data.eachRoundPickedCount[self.data.playRound] >= self.roundPickCountList[self.data.playRound] then
			self:showTipTitleState("tip")
			self:setPickBtnState(false)

			if self.data.playRound == 1 then
				self:saveYourGift(index)
				self.data.playRound = self.data.playRound + 1
				self:saveBonus()
			elseif self.data.playRound > 1 then
				self.data.roundState[self.data.playRound] = roundBonusStateList["show_result"]
				self:saveBonus()
				self.theme:laterCallBack(1,function()
					self:displayThisRoundPickResult(true)
				end)			    
			end
		end
		
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end
	self.theme.dealBonusGiftBtnList[index]:addTouchEventListener(onTouch)
end

function bonusGame:saveYourGift(index)
	self.data.roundState[self.data.playRound] = roundBonusStateList.get_result
	local giftPos = cc.p(self.theme.dealBonusGiftList[index].node:getPosition())

	self.theme.dealBonusYourBoxLabel:setString(index)
	self.theme.dealBonusYourBoxNode:setPosition(giftPos)
	-- self.theme.dealBonusYourBoxNode:setOpacity(0)
	self.theme.dealBonusYourBoxNode:setScale(0.89)
	
	-- local pFile = self.theme:getPic("particles/qiandaishouji.plist")
	-- local pPos = cc.p(0,0)
	-- local lizi1 = cc.ParticleSystemQuad:create(pFile)
	-- lizi1:setPosition(pPos)
	-- self.theme.dealBonusYourBoxNode:addChild(lizi1,-1)
	
	-- self.theme:addSpineAnimation(self.theme.theDealNodeRoot, nil, self.theme:getPic("spine/deal_bonus/qiandaichuxian"), giftPos, "animation")
	self.theme:addSpineAnimation(self.theme.dealBonusGiftAniNodeList[index],2,self.theme:getPic("spine/map/shengbeixuanzhong"),cc.p(0,0),"animation",nil,nil,nil,true)

	self.theme.theDealNodeRoot:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(function ( ... )-- 展示 消失和移动动画
			self.theme.dealBonusGiftList[index].node:setVisible(false)
			self.theme.dealBonusYourBoxNode:setVisible(true)

			self.theme.dealBonusGiftAniNodeList[index]:removeAllChildren()

			self.theme:addSpineAnimation(self.theme.dealBonusYourBoxNode, nil, self.theme:getPic("spine/map/shengbeifei"), cc.p(0,0), "animation")
			self.theme.dealBonusYourBoxNode:runAction(
				cc.Sequence:create(
					cc.Spawn:create(
						cc.Sequence:create(cc.ScaleTo:create(10/30, 1.3),cc.ScaleTo:create(5/30, 1)),
						-- cc.Sequence:create(cc.DelayTime:create(10/30),cc.FadeTo:create(10/30, 255)),
						cc.MoveTo:create(15/30,yourGiftEndPos))
					))
		end),
		cc.DelayTime:create(15/30),
		cc.CallFunc:create(function ( ... )
			-- if bole.isValidNode(lizi1) then 
			-- 	lizi1:removeFromParent()
			-- end
			local _,s = self.theme:addSpineAnimation(self.theme.dealBonusTopNode,-1,self.theme:getPic("spine/map/dashengbeixunhuan"), yourGiftEndPos,"animation",nil,nil,nil,true,true,nil)
			self.yourBoxBgSpine = s
			-- self.yourBoxBgSpine:setScale(0.8)
			self:playNextRound()
		end)
		))

	self.theme:playMusic(self.theme.audio_list.grail_fly)
end

function bonusGame:displayThisRoundPickResult(isFirst,all_count,record_list,showIndex)
	self.data.roundState[self.data.playRound] = roundBonusStateList["show_result"]
	self:saveBonus()
	self.theme.dealBonusOpenGiftNode:setVisible(true)
	self.theme.dealBonusDimmer:setOpacity(0)
	self.theme.dealBonusDimmer:setVisible(true)
	self.theme.dealBonusDimmer:runAction(cc.FadeTo:create(0.3,200))
	local allCounts = all_count or 0
	local recordList = record_list or {}

	beginIndex = self.pickFromToList[self.data.playRound][1]
	showIndex = showIndex or 0
	if isFirst then 
		allCounts = self.roundPickCountList[self.data.playRound]
        recordList = {true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true}
        self.theme.dealBonusOpenGiftBoxBgAniNode:setOpacity(0)
        -- self.theme:addSpineAnimation(self.theme.dealBonusOpenGiftBoxBgAniNode, 10, self.theme:getPic("spine/deal_bonus/qiandaibeijingguang"), cc.p(0,0), "animation", nil, nil, nil, true, true)
    end
    local isWait = false

	if allCounts > 0 then
		for i = 1,maxMapLevel do
			if not isWait then
			   if self.data.giftList[i] == self.data.playRound and recordList[i] then
			   	  isWait = true
			   	  allCounts = allCounts - 1
			   	  recordList[i] = false
			   	  mulIndex = beginIndex + showIndex
			   	  showIndex = showIndex + 1
			   	  self:displaySinglePickResult(i,allCounts,recordList,mulIndex,showIndex)
			   	end
			end
		end
	else
		if not isWait then
		   isWait = true
           self:showNormalOfferAnimaton()
           self.theme.dealBonusOpenGiftBoxBgAniNode:removeAllChildren()
        end
	end
end

function bonusGame:displaySinglePickResult(index,all_count,record_list,mulIndex,showIndex)
	local mul = self.multiList[mulIndex]
	local isFake = self.fakeList[mulIndex] > 0 and true or false
	local temp_mul = 0
	local fake_delay0 = 0
	local fake_delay1 = 0
	local fake_delay2 = 0
	if isFake then
		fake_delay0 = 1
		fake_delay1 = 24/30
		fake_delay2 = (50-24)/30
		temp_mul = self.fakeList[mulIndex]
	end

	self.theme.dealBonusOpenGiftBoxNode:setScale(0)
	self.theme.dealBonusOpenGiftBoxNode:setVisible(true)
	self.theme.label_dealBonusOpenGiftNum:setString(index)
	self.theme.dealBonusOpenGiftBoxNode:setOpacity(255)
	self.theme.label_dealBonusOpenMulti:setScale(0)
	self.theme.label_dealBonusOpenMulti:setVisible(true)
	-- bole.updateSpriteWithFile(self.theme.dealBonusOpenGiftBoxImage,"#theme159takeitbg7_2.png")

	if isFake then
	   self.theme.label_dealBonusOpenMulti:setString(temp_mul.."X")
	else
	   self.theme.label_dealBonusOpenMulti:setString(mul.."X")
	end

	self.theme:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.theme.dealBonusOpenGiftBoxNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.3,1.5,1.5),
				cc.ScaleTo:create(0.2,1,1)
			))
			self.theme:playMusic(self.theme.audio_list.grail_open)

			self.theme.dealBonusGiftList[index].node:setVisible(false)
			self.theme.dealBonusOpenGiftBoxBgAniNode:runAction(cc.FadeIn:create(0.2))
		end),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			self.theme:addSpineAnimation(self.theme.dealBonusOpenGiftBoxNode, nil, self.theme:getPic("spine/map/zhalizi"), cc.p(self.theme.label_dealBonusOpenMulti:getPosition()), "animation")
		end),
		cc.DelayTime:create(5/30),
		cc.CallFunc:create(function ( ... )
			-- bole.updateSpriteWithFile(self.theme.dealBonusOpenGiftBoxImage,"#theme159takeitbg7_3.png")
			-- self.theme.label_dealBonusOpenGiftNum:setVisible(false)

			self.theme.label_dealBonusOpenMulti:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.2,1.25),
				cc.ScaleTo:create(0.1,1)
			))	
		end),
		cc.DelayTime:create(0.3 + fake_delay0),
		cc.CallFunc:create(function()
			if isFake then				
				local file = self.theme:getPic("spine/map/tihuan1000X") 
				local _,s = self.theme:addSpineAnimation(self.theme.dealBonusOpenGiftBoxNode, nil, file, cc.p(0, 294), "animation")
				self.theme:playMusic(self.theme.audio_list.num_change)
			end
		end),
		cc.DelayTime:create(fake_delay1),
		cc.CallFunc:create(function()
			if isFake then
				self.theme.label_dealBonusOpenMulti:setString(mul.."X")
			end 
		end),
		cc.DelayTime:create(fake_delay2),
		cc.CallFunc:create(function()
			self.theme:playMusic(self.theme.audio_list.mul)
			local starIndex = multiValueIndexConfig[mul]
			self.data.mulStarList[starIndex] = false
			-- self.theme:addSpineAnimation(self.theme.dealBonusMultList[starIndex].node,10, self.theme:getPic("spine/deal_bonus/beishuqubianhui") ,cc.p(0,0),"animation")

			local temp = self.theme.dealBonusMultList[starIndex] -- 设置 结果显示之后控制 倍数置灰

			temp.node:setColor(dimColor)
			-- temp.node:setOpacity(255)
			-- temp.sp:setColor(cc.c3b(84,84,84))
			-- temp.label:setColor(cc.c3b(100,100,100))
		end),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			self.theme.dealBonusOpenGiftBoxNode:runAction(cc.FadeOut:create(0.6))
			self.theme.dealBonusOpenGiftBoxBgAniNode:runAction(cc.FadeOut:create(0.4))
		end),
		cc.DelayTime:create(0.8),
		cc.CallFunc:create(function()
			-- bole.updateSpriteWithFile(self.theme.dealBonusOpenGiftBoxImage,"#theme159takeitbg7_2.png")
			self.theme.label_dealBonusOpenGiftNum:setVisible(true)
			self:displayThisRoundPickResult(false,all_count,record_list,showIndex)
		end)
	))
end

function bonusGame:showNormalOfferAnimaton()
	self.theme.dealBonusOpenGiftBoxNode:setScale(0)
	self.theme.dealBonusOpenGiftNode:setVisible(true)

	self.data.roundState[self.data.playRound] = roundBonusStateList["get_result"]
	self:saveBonus()

	self:showTipTitleState("tip")
	local mul = self.dealList[self.data.playRound - 1]
	local win = mul*self.avg_bet
	self.dealBonusWin = win
	self.theme.label_offerMul:setString(mul.."X")
	self.theme.label_offerWin:setString(mul.." X "..FONTS.formatByCount4(self.avg_bet,4,true).." = "..FONTS.formatByCount4(win,4,true))

	self.theme.dealbonusOfferNode:setVisible(false)
	self.theme.dealBonusOfferCharacterNode:removeAllChildren()
    local file_character = self.theme:getPic("spine/base/basezhousi_01")
    self.theme:addSpineAnimation(self.theme.dealBonusOfferCharacterNode,nil,file_character,cc.p(0,0),"animation3",nil,nil,nil,true,true,nil)

	self.data.recordList[self.data.playRound-1] = mul

   	self.theme:playMusic(self.theme.audio_list.change1)
	self.theme.offerTipJumpNode:removeAllChildren()
   	self.theme.showOfferDialog:setVisible(true)

   	local _,s = self.theme:addSpineAnimation(self.theme.offerTipJumpNode, nil, self.theme:getPic("spine/map/tuitukuang"), cc.p(0,0), "animation1", nil, nil, nil, true)
   	self.offerJumpTipAnim = s

	self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(40/30),
		cc.CallFunc:create(function( ... )
			if bole.isValidNode(self.offerJumpTipAnim) then 
				bole.spChangeAnimation(self.offerJumpTipAnim, "animation2", true)
			end
			self.theme.dealBonusOpenGiftNode:setVisible(false)
			self.theme.dealBonusDimmer:setVisible(false)

			self.theme.showOfferBtn:setTouchEnabled(true)
            self:initDealBonusEnvelopeEvent()
		end)
	))
	
end

function bonusGame:initDealBonusEnvelopeEvent( ... )
	-- 点击按钮
	local clickFunc = function(obj)
	    self.theme.showOfferBtn:setTouchEnabled(false)
	    self.theme:playMusic(self.theme.audio_list.common_click)
	    
	    -- 关闭showOfferTipDialog 
	    if bole.isValidNode(self.offerJumpTipAnim) then 
			bole.spChangeAnimation(self.offerJumpTipAnim, "animation3")
		end

	    self:showEnvelopOpenAnimation()
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end
	self.theme.showOfferBtn:addTouchEventListener(onTouch)-- 设置按钮
end

function bonusGame:showEnvelopOpenAnimation()
    self.theme:playMusic(self.theme.audio_list.change2)
	self.theme.dealbonusOfferNode:setVisible(true)
	self.theme.dealbonusOfferNode:setOpacity(255)

	local file_btn = self.theme:getPic("spine/dialog/takeit/keepanniu")
	local btn_size = self.theme.btn_offerTakeIt:getContentSize()
	self.theme:addSpineAnimation(self.theme.btn_offerTakeIt,nil,file_btn,cc.p(btn_size.width/2,btn_size.height/2),"animation2",nil,nil,nil,true,true,nil)
	self.theme:addSpineAnimation(self.theme.btn_offerLeaveIt,nil,file_btn,cc.p(btn_size.width/2,btn_size.height/2),"animation2",nil,nil,nil,true,true,nil)

	self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			self.theme.btn_offerTakeIt:setTouchEnabled(true)
			self.theme.btn_offerLeaveIt:setTouchEnabled(true)

			self:initTakeBtnEvent()
			self:initLeaveBtnEvent()
		end)
	))
end

function bonusGame:initTakeBtnEvent()
	-- 点击按钮
	local clickFunc = function(obj)
	    self.theme.btn_offerTakeIt:setTouchEnabled(false)
	    self.theme.btn_offerLeaveIt:setTouchEnabled(false)
	    self.theme.btn_offerTakeIt:removeAllChildren() -- 删除循环扫光特效
	    self.theme.btn_offerLeaveIt:removeAllChildren() -- 删除循环扫光特效
	    
	    self.theme:playMusic(self.theme.audio_list.bonus_click)
        self:showDealBonusCollectBoard(true)
	    self.data.gameEnd = true
	    self:saveBonus()
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end
	-- 设置按钮
	self.theme.btn_offerTakeIt:addTouchEventListener(onTouch)
end

function bonusGame:initLeaveBtnEvent()
	-- 点击按钮
	local clickFunc = function(obj)
	    self.theme.btn_offerTakeIt:setTouchEnabled(false)
	    self.theme.btn_offerLeaveIt:setTouchEnabled(false)
	    self.theme:playMusic(self.theme.audio_list.bonus_click)
	    self.theme.btn_offerTakeIt:removeAllChildren()
	    self.theme.btn_offerLeaveIt:removeAllChildren()

	    self:updatePerviousOffersLabels()

	    if self.data.playRound < 6 then       
	        self.data.roundState[self.data.playRound] = roundBonusStateList["finish"]
	        self.data.playRound = self.data.playRound + 1
		    self:saveBonus()
		    self:playNextRound()
		elseif self.data.playRound == 6 then			
			self.data.roundState[self.data.playRound] = roundBonusStateList["finish"]
			self.data.playRound = self.data.playRound + 1
			self:saveBonus()
			self:showLastOfferBoard(true)
		end
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end
	-- 设置按钮
	self.theme.btn_offerLeaveIt:addTouchEventListener(onTouch)
end

function bonusGame:playNextRound()
	self.theme.dealbonusOfferNode:runAction(cc.Sequence:create(
		cc.FadeOut:create(0.5),
		cc.CallFunc:create(function ( ... )
			self.theme.dealbonusOfferNode:setVisible(false)
		end)))
	self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			self:showNextRoundTip()			
		end),
		cc.DelayTime:create(3),
		cc.CallFunc:create(function()			
			self:showTipTitleState("choose")

			self:setPickBtnState(true)

			-- todo
			-- for i = 1,maxMapLevel do
			-- 	if self.data.giftList[i] == 0 then
			-- 		self.theme.dealBonusGiftList[i].node:setVisible(true)
			-- 		self.theme.dealBonusGiftList[i].label:setString(i)
			-- 		self.theme.dealBonusGiftBtnList[i]:setVisible(true)
			-- 		self.theme.dealBonusGiftBtnList[i]:setTouchEnabled(true)
			-- 		-- self:initDealBonusGiftBtnEvent(i)
			-- 	end
			-- end
		end)
	))
end

function bonusGame:showNextRoundTip( ... )
	if self.data.playRound < 6 then
		self.theme.dealBonusRoundTipList[1].labelRoundCount:setString(self.data.playRound-1)
		self.theme.dealBonusRoundTipList[1].labelPickCount:setString(self.roundPickCountList[self.data.playRound])
		self.theme.dealBonusRoundTipList[1].node:setVisible(true)
		self.theme.dealBonusRoundTipList[2].node:setVisible(false)
	elseif self.data.playRound == 6 then
		self.theme.dealBonusRoundTipList[1].node:setVisible(false)
		self.theme.dealBonusRoundTipList[2].node:setVisible(true)
	end

	self.theme.dealBonusRoundTipNode:setScale(0)
	self.theme.dealBonusRoundTipNode:setVisible(true)
	
	
	self.theme:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			-- self.theme:playMusic(self.theme.audio_list.board_show)
			self.theme.dealBonusRoundTipNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.4,1.5,1.5),
				cc.ScaleTo:create(0.2,1,1)
			))
		end),
		cc.DelayTime:create(2),
		cc.CallFunc:create(function()
			-- self.theme:playMusic(self.theme.audio_list.board_end)
			self.theme.dealBonusRoundTipNode:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.15,1.5,1.5),
				cc.ScaleTo:create(0.2,0,0)
			))
		end)
	))
end

function bonusGame:showLastOfferBoard(isAnimate)
	local startPosLeft = cc.p(-146,-71)
	local startPosRight = cc.p(146,-71)
	local originScale = 0.62
	self.theme.dealBonusLastOfferBoxLeft:setPosition(startPosLeft)
	self.theme.dealBonusLastOfferBoxLeft:setScale(originScale)
	self.theme.dealBonusLastOfferBoxRight:setPosition(startPosRight)
	self.theme.dealBonusLastOfferBoxRight:setScale(originScale)

	self.data.roundState[self.data.playRound] = roundBonusStateList["get_result"]
	self:saveBonus()

	self.theme.label_dealBonusLastOfferMul:setScale(0)
	self.theme.label_dealBonusLastOfferMul:setVisible(true)

	local lastIndex = 0
	for i = 1,maxMapLevel do
		if self.data.giftList[i] == 0 then
			lastIndex = i
		end
	end
	self.data.choosedGiftIndex[maxMapLevel-1] = lastIndex
	self.theme.label_lastOfferNumLeft:setString(self.data.choosedGiftIndex[maxMapLevel])
	self.theme.label_lastOfferNumRight:setString(lastIndex)

	self.theme.dealBonusLastOfferCharacterNode:removeAllChildren()
    local file_character = self.theme:getPic("spine/map/xiaosun")
    self.theme:addSpineAnimation(self.theme.dealBonusLastOfferCharacterNode,nil,file_character,cc.p(0, 0),"animation",nil,nil,nil,true,true,nil)

	if isAnimate then
		self.theme:runAction(cc.Sequence:create(
			cc.CallFunc:create(function()
				self.theme:playMusic(self.theme.audio_list.change3)
				local file = self.theme:getPic("spine/map/bianshen")
				self.theme:addSpineAnimation(self.theme.theDealNodeRoot,nil,file,cc.p(0,0),"animation")
			end),
			cc.DelayTime:create(22/30),
			cc.CallFunc:create(function()
				self:showLastOffer(lastIndex, isAnimate)
			end)
		))
	else
		self:showLastOffer(lastIndex)
	end
end

function bonusGame:showLastOffer( lastIndex, isAnimate )
	self.theme.dealBonusLastOfferNode:setVisible(true)
	self.theme.dealbonusOfferNode:setVisible(false)

	self.theme.dealBonusGiftList[lastIndex].node:setVisible(false)
	self.theme.dealBonusGiftList[self.data.choosedGiftIndex[maxMapLevel]].node:setVisible(false)
	
	local file_btn = self.theme:getPic("spine/dialog/takeit/keepanniu")
	local btn_size = self.theme.btn_lastOfferKeepIt:getContentSize()
	self.theme:addSpineAnimation(self.theme.btn_lastOfferKeepIt,nil,file_btn,cc.p(btn_size.width/2,btn_size.height/2),"animation1",nil,nil,nil,true,true,nil)
	self.theme:addSpineAnimation(self.theme.btn_lastOfferTradeIt,nil,file_btn,cc.p(btn_size.width/2,btn_size.height/2),"animation1",nil,nil,nil,true,true,nil)

	local delay = isAnimate and 25/30 or 0
	self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(delay),
		cc.CallFunc:create(function()
			self.theme.btn_lastOfferKeepIt:setTouchEnabled(true)
			self.theme.btn_lastOfferTradeIt:setTouchEnabled(true)

			self:initLastKeepBtnEvent()
			self:initLastTradeBtnEvent()
		end)
	))

end
function bonusGame:initLastKeepBtnEvent()
	-- 点击按钮
	local clickFunc = function(obj)
	    self.theme.btn_lastOfferKeepIt:setTouchEnabled(false)
	    self.theme.btn_lastOfferTradeIt:setTouchEnabled(false)
	    self.theme.btn_lastOfferKeepIt:removeAllChildren()
	    self.theme.btn_lastOfferTradeIt:removeAllChildren()

        local lastIndex = 0
	    for i = 1,maxMapLevel do
			if self.data.giftList[i] == 0 then
				lastIndex = i
			end
		end

	    self.data.pickedCount = self.data.pickedCount + 1
	    self.data.choosedGiftIndex[self.data.pickedCount-1] = lastIndex
	    self.data.giftList[lastIndex] = self.data.playRound

	    self.theme:playMusic(self.theme.audio_list.bonus_click)
        local mul = self.multiList[maxMapLevel]
        self.theme.label_dealBonusLastOfferMul:setString(mul.."X")
        self:showLastOfferAnimation("keep")
	    self.data.gameEnd = true 
	    self:saveBonus()
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end
	-- 设置按钮
	self.theme.btn_lastOfferKeepIt:addTouchEventListener(onTouch)
end

function bonusGame:initLastTradeBtnEvent()
	-- 点击按钮
	local clickFunc = function(obj)
	    self.theme.btn_lastOfferKeepIt:setTouchEnabled(false)
	    self.theme.btn_lastOfferTradeIt:setTouchEnabled(false)
	    self.theme.btn_lastOfferKeepIt:removeAllChildren()
	    self.theme.btn_lastOfferTradeIt:removeAllChildren()

	    self.theme:playMusic(self.theme.audio_list.bonus_click)

	    local lastIndex = 0
	    for i = 1,maxMapLevel do
			if self.data.giftList[i] == 0 then
				lastIndex = i
			end
		end

	    self.data.pickedCount = self.data.pickedCount + 1
	    self.data.choosedGiftIndex[self.data.pickedCount-1] = lastIndex
	    self.data.giftList[lastIndex] = self.data.playRound
	    self.theme.dealBonusGiftList[lastIndex].node:setVisible(false)

        local mul = self.multiList[maxMapLevel]
        self.theme.label_dealBonusLastOfferMul:setString(mul.."X")
	    self:showLastOfferAnimation("trade")
	    self.data.gameEnd = true 
	    self:saveBonus()

	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			clickFunc(obj)
		end
	end
	-- 设置按钮
	self.theme.btn_lastOfferTradeIt:addTouchEventListener(onTouch)
end

function bonusGame:showLastOfferAnimation(boxType)
	self.theme.dealBonusLastDimmer:setOpacity(0)
	self.theme.dealBonusLastDimmer:setVisible(true)

	local moveBox 		= nil
	local moveBoxLabel 	= nil
	if boxType == "keep" then
		moveBox 		= self.theme.dealBonusLastOfferBoxLeft
		moveBoxLabel 	= self.theme.label_lastOfferNumLeft
	elseif boxType == "trade" then
		moveBox 		= self.theme.dealBonusLastOfferBoxRight
		moveBoxLabel 	= self.theme.label_lastOfferNumRight
	end

	bole.changeParent(moveBox,self.theme.dealBonusLastBoxAniNode)
	self.theme:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.theme:playMusic(self.theme.audio_list.grail_open)
			moveBox:runAction(cc.Spawn:create(
				cc.ScaleTo:create(0.5, 1.25),
				cc.MoveTo:create(0.5, cc.p(0,0))
			))
			self.theme.dealBonusLastDimmer:runAction(cc.FadeTo:create(0,200))
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
        	-- local _,s = self.theme:addSpineAnimation(self.theme.dealBonusLastBoxAniNode,-1,self.theme:getPic("spine/deal_bonus/qiandaibeijingguang"), cc.p(0,0),"animation",nil,nil,nil,true,true,nil)
        	-- s:setScale(0.5)
        	-- s:runAction(cc.ScaleTo:create(0.2,1))
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			self.theme:addSpineAnimation(self.theme.dealBonusLastBoxAniNode, 20, self.theme:getPic("spine/map/zhalizi"), cc.p(self.theme.label_dealBonusLastOfferMul:getPosition()), "animation")
		end),
		cc.DelayTime:create(5/30),
		cc.CallFunc:create(function ( ... )
			-- bole.updateSpriteWithFile(moveBox:getChildByName("box_image"),"#theme159takeitbg7_3.png")
			-- moveBoxLabel:setVisible(false)

			self.theme.label_dealBonusLastOfferMul:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.2,1.25),
				cc.ScaleTo:create(0.1,1)
			))
		end),
		cc.DelayTime:create(1.5),
		cc.CallFunc:create(function( ... )

			self.theme.dealBonusLastDimmer:runAction(cc.FadeOut:create(0.3))
			self.theme.dealBonusLastOfferNode:runAction(cc.FadeOut:create(0.3))

			self.dealBonusWin = self.dealBonusWinList[self.data.playRound - 1]
			self:showDealBonusCollectBoard()
		end),
		cc.DelayTime:create(0.3),
		cc.CallFunc:create(function()
			bole.changeParent(moveBox,self.theme.dealBonusLastOfferNode)
			-- bole.updateSpriteWithFile(moveBox:getChildByName("box_image"),"#theme159takeitbg7_2.png")
			moveBoxLabel:setVisible(true)
			self.theme.label_dealBonusLastOfferMul:setVisible(false)
			self.theme.dealBonusLastBoxAniNode:removeAllChildren()

			self.theme.dealBonusLastOfferNode:setVisible(false)
			self.theme.dealBonusLastOfferNode:setOpacity(255)
			self.theme.dealBonusLastDimmer:setVisible(false)
		end)
	))
end

function bonusGame:showTipTitleState(state)
	for k,v in pairs(self.theme.dealBonusGiftTextList) do
		v:setVisible(false)
	end
	self.theme.dealBonusGiftTextList["start"]:stopAllActions()
	if state == "start" then
		local tipNode = self.theme.dealBonusGiftTextList["start"]
		tipNode:setVisible(true)
		tipNode:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(1,0.9),cc.ScaleTo:create(1,1.1))))
	elseif state == "choose" then
		local remaingCount = self.data.eachRoundRemainingCount[self.data.playRound]
		local sumCount = roundPickCnt[self.data.playRound]
		self.theme.dealBonusGiftTextList["choose"].lb:setString((sumCount - remaingCount).."/"..sumCount)
		self.theme.dealBonusGiftTextList["choose"]:setVisible(true)
		self.theme.dealBonusGiftTextList["choose"]:setVisible(true)
	elseif state == "tip" then
		self.theme.dealBonusGiftTextList["tip"]:setVisible(true)
	end
end

function bonusGame:showDealBonusCollectBoard(isTake, tryResume)
	local delay = 1
	if not tryResume then 
		delay = 2
		self.theme:playMusic(self.theme.audio_list.bonus_end)
	end
	self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(delay),
		cc.CallFunc:create(function ( ... )
			self:showDealBonusCollectDialog(isTake)
		end)))
end

function bonusGame:showDealBonusCollectDialog(isTake)
	self.theme:dealMusic_FadeLoopMusic(0.3, 1, 0)

	local csbPath = self.theme:getPic("csb/dialog_deal.csb")
	local dialog 		= cc.CSLoader:createNode(csbPath)
	local rootNode 		= dialog:getChildByName("root")
	local showNode 		= rootNode:getChildByName("node_collect")
	rootNode:getChildByName("node_start"):setVisible(false)
	local collectBtn 	= showNode:getChildByName("collect_btn")
	local labelNode 	= showNode:getChildByName("label_node")
	local labelWin 		= labelNode:getChildByName("label_win")
	local labelMulti	= showNode:getChildByName("label_mul")

	self.theme.curScene:addToContentFooter(dialog)
	self.theme:playMusic(self.theme.audio_list.bonus_end_show)
	self.theme:dialogPlayLineAnim("show", self.theme.dealBonusDimmer) -- 关闭弹窗

	labelWin:setString(FONTS.format(self.dealBonusWin,true))
	bole.shrinkLabel(labelWin, 450, labelWin:getScale())
	local mul = self.dealList[self.data.playRound-1]
	labelMulti:setString(mul.." x "..FONTS.formatByCount4(self.avg_bet,5,true).." = ".. FONTS.formatByCount4(self.dealBonusWin,5,true))

	collectBtn:setTouchEnabled(false)

	local _, bgS = self.theme:addSpineAnimation(showNode, -1, self.theme:getPic("spine/dialog/deal/jiesuan"), cc.p(0, 0), "animation1", nil, nil, nil, true)
	bgS:runAction(cc.Sequence:create(
		cc.DelayTime:create(20/30),
		cc.CallFunc:create(function ( ... )
			bole.spChangeAnimation(bgS, "animation1_1", true)
		end)))
	labelNode:setVisible(false)
    labelNode:runAction(cc.Sequence:create(
        cc.DelayTime:create(9/30),
        cc.Show:create(),
        cc.ScaleTo:create(5/30, 1.1),
        cc.ScaleTo:create(2/30, 1)))

    if bole.isValidNode(collectBtn) then 
        collectBtn:setScale(0)
        collectBtn:runAction(cc.Sequence:create(
            cc.DelayTime:create(15/30),
            cc.ScaleTo:create(5/30, 1.1)))

        local size = collectBtn:getContentSize()
		self.theme:addSpineAnimation(collectBtn, nil, self.theme:getPic("spine/dialog/deal/collectanniu"), cc.p(size.width/2,size.height/2), "animation", nil, nil, nil, true, true)-- 添加特效
    end
	
	local clickEndFunction = function (obj, eventType )
		if eventType == ccui.TouchEventType.ended then
			collectBtn:setTouchEnabled(false)
			collectBtn:removeAllChildren() -- 删除循环扫光特效

			self.theme:playMusic(self.theme.audio_list.common_click)
			self.theme:playMusic(self.theme.audio_list.popup_out)

			self.theme:dialogPlayLineAnim("hide", self.featureDialogDimmer, rootNode) -- 关闭弹窗
			
			dialog:runAction(cc.Sequence:create(
				cc.DelayTime:create(1), 
				cc.CallFunc:create(function ( ... )
					local special_data = {}
			    	special_data.value = self.dealBonusWin
			    	self.ctl:collectCoins(2,special_data)	
				end), 
				cc.RemoveSelf:create()))
		end
	end

	dialog:runAction(cc.Sequence:create(
		cc.DelayTime:create(0.5), 
		cc.CallFunc:create(function ()
			collectBtn:addTouchEventListener(clickEndFunction)
			collectBtn:setTouchEnabled(true)
		end)))
end

function bonusGame:clearDealBonusSceneAssets( ... )
	if bole.isValidNode(self.yourBoxBgSpine) then 
		self.yourBoxBgSpine:removeFromParent()
	end
	self.yourBoxBgSpine = nil

	self.theme.offerTipJumpNode:removeAllChildren()
	self.offerJumpTipAnim = nil

	self.theme.pickItemsNode:stopAllActions()
	for _, node in pairs(self.theme.dealBonusGiftAniNodeList) do 
		node:removeAllChildren()
	end

	self.pickSpineList = nil
end

function bonusGame:exitDealBonus()

	local function dealBonusOver()
		if self.ctl:noFeatureLeft() then 
        	self.ctl:removePointBet()
        end
        -- 播放背景音乐
		self.theme:dealMusic_ExitBonusGame()
		self.callback()
		
		self.theme.isInBonusGame = false
	end

	-- 在此之后断电重连就不用恢复了
	-- self.data["end_game"] = true
	-- self:saveBonus()

    if self.ctl.freespin and self.ctl.freespin < 1 then
        self.ctl.spin_processing = true
    end

	self.theme:playTransition(nil,"bonus")-- 转场动画
	local curTransitionDelay = transitionDelay.bonus

	self.theme:runAction(cc.Sequence:create(
		cc.DelayTime:create(curTransitionDelay.onCover),
		cc.CallFunc:create(function()
			self.theme.mapPoints = 0
		    self.theme:setCollectProgressImagePos(0)
			self.theme.dealBonusNode:setOpacity(0)
			self:clearDealBonusSceneAssets()
			self.theme.isOpenStoreNode = false

			self.theme:outBonusStage() -- 恢复牌面 和 中奖两线
		end),
		cc.DelayTime:create(curTransitionDelay.onEnd),
		cc.CallFunc:create(function()
			if self.theme.ctl.footer then
				self.theme.ctl.footer:showActivitysNode()
			end

			self.ctl:startRollup(self.dealBonusWin, dealBonusOver)
		end)
	))
end

-- function cls:initCheatBtnEvent( )
-- 	local specialChectNode = cc.Node:create()
-- 	self.mainThemeScene:addChild(specialChectNode)
-- 	local function addChestEvent ( obj, eventType )
-- 		if eventType == ccui.TouchEventType.ended then
-- 			print("cheatEvent1 -- showFreeAddChestAnim")
-- 			self:smashChestIntoReel()
-- 		end
-- 	end
-- 	self.btnList[1]:addTouchEventListener(addChestEvent)

-- 	local function addBgEvent1 ( obj, eventType )
-- 		if eventType == ccui.TouchEventType.ended then
-- 			print("cheatEvent2 -- showBaseBG")
-- 			self.baseBg:setVisible(true)
-- 			self.freeBg:setVisible(false)
-- 		end
-- 	end
-- 	self.btnList[2]:addTouchEventListener(addBgEvent1)

-- 	local function addBgEvent2 ( obj, eventType )
-- 		if eventType == ccui.TouchEventType.ended then
-- 			print("cheatEvent3 -- showFreeBG")
-- 			self.baseBg:setVisible(false)
-- 			self.freeBg:setVisible(true)
-- 		end
-- 	end
-- 	self.btnList[3]:addTouchEventListener(addBgEvent2)

-- 	local function btnEvent4 ( obj, eventType )
-- 		if eventType == ccui.TouchEventType.ended then
-- 			print("cheatEvent4 -- addFreeBgSpinToMain")
-- 			self:playStartFreeSpinDialog({})
-- 		end
-- 	end
-- 	self.btnList[4]:addTouchEventListener(btnEvent4)

-- 	local function btnEvent5 ( obj, eventType )
-- 		if eventType == ccui.TouchEventType.ended then
-- 			self:fullCollectAnimation()
-- 		end
-- 	end
-- 	self.btnList[5]:addTouchEventListener(btnEvent5)

-- 	local function btnEvent6 ( obj, eventType )
-- 		if eventType == ccui.TouchEventType.ended then
-- 			self:stopCollectPartAnimation()
-- 		end
-- 	end
-- 	self.btnList[6]:addTouchEventListener(btnEvent6)

-- 	local function btnEvent7 ( obj, eventType )
-- 		if eventType == ccui.TouchEventType.ended then
-- 			local rets = {
-- 				["jp_win"] = {
-- 					{["jp_win_type"] = 0},
-- 					{["jp_win_type"] = 1},
-- 					{["jp_win_type"] = 2},
-- 					{["jp_win_type"] = 3},
-- 				},
-- 			}
-- 			self:playJPWinAnim(rets)
-- 		end
-- 	end
-- 	self.btnList[7]:addTouchEventListener(btnEvent7)
-- end

return ThemeZeus
