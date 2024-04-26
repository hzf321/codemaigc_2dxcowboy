-----------------------    2018.3.26    ------------------------
    ------------------ ChiefOfTheGods主题 108 ------------------
        ------------------   王红杰   ------------------

ThemeChiefOfTheGods = class("ThemeChiefOfTheGods", Theme)
local cls = ThemeChiefOfTheGods
cls.plistAnimate = {
	"image/plist/symbol",
}

cls.csbList = {
	"csb/base_game.csb",
}

local SpinBoardType = {
	Normal = 1,
	FreeSpin = 2,
	ReSpin = 3,
}

local ReSpinStep = {
	OFF = 1,
	Start = 2,
	Reset = 3,
	Over = 4,
	Playing = 5,	
}

local bgPath = {
	["base"] = "image/base/theme108_bg_background.png",
	["free"] = "image/base/theme108_fg_background.png",
	["respin"] = "image/base/theme108_feature_background.png",
}


local miniGameKey = {
	[0] = "grand",[1]="mega",[2]= "major",[3] = "minor",[4] = "mini"
}
-- local triger = 11
local specialSymbol = {
	["triger"] = 11 ,["zeus"] = 2 , ["kong"] = 0 ,["jackpot"] = 12 -- H 9  -> whj-> 21
}

local respinSpriteScale = {[0] = 0.95,[1]= 0.85,[2] = 0.8,[3] = 0.75,[4] = 0.7}

local respinLockKey = Set({2,12})
local respinSet = {0,2,12}
local FreshTime = 0.3

local Jsize = {
	["width"] = 171,
	["height"] = 145
}
local transitionType = {
-- 	["free"] = {"free","animation",cc.p(640,360)},
-- 	["respin"] = {"respin","animation1",cc.p(640,360)},
-- 	["respin2"] = {"respin","animation2",cc.p(728,360)}
	["free"] = {"free","animation",cc.p(0,0)},
	["respin"] = {"respin","animation1",cc.p(0,0)},
	["respin2"] = {"respin","animation2",cc.p(88,0)}
}
local respinCellCount = 20
local rowCnt = 5
cls.spinTimeConfig = { -- spin 时间控制
		-- [1] = 81/60,-- 欺骗 比基础spin多加的时间 --42/60 在基础spin时间为81帧的时候
		-- [2] = 181/60,-- 出现大象比基础spin多加的时间  -- 181/60,
		["base"] = 20/60, -- 数据返回前 进行滚动的时间
		-- [0] = 40/60, -- 数据返回之后，需要添加到自动stop 上面的时间
		["spinMinCD"] = 50/60,  -- 可以显示 stop按钮的时间，也就是可以通过quickstop停止的时间
}
local firstReelId = Set({1,6,11,16})

function cls:getBoardConfig()
	if self.boardConfigList then
		return self.boardConfigList
	end
	local borderConfig = self.ThemeConfig["boardConfig"]
	local reelConfig = borderConfig[2]["reelConfig"]
	local newConfig = {}
	for i=0, respinCellCount-1 do
		local oneConfig = {}
		oneConfig["base_pos"] = cc.p((i%5)*reelConfig["cellWidth"]+reelConfig["base_pos"].x,math.floor((respinCellCount-1-i)/5)*reelConfig["cellHeight"]+reelConfig["base_pos"].y)
 		oneConfig["cellWidth"] = reelConfig["cellWidth"]
		oneConfig["cellHeight"] = reelConfig["cellHeight"]
		oneConfig["symbolCount"] = reelConfig["symbolCount"]
		table.insert(newConfig,oneConfig)
	end
	borderConfig[2]["rowReelCnt"] = rowCnt
	borderConfig[2]["reelConfig"] = newConfig
	self.boardConfigList = borderConfig
	return borderConfig
end

function cls:ctor(themeid)
	math.randomseed(os.time())
  	self.spinActionConfig = {
		["start_index"] = 10,
		["spin_index"] = 1,
		["stop_index"] = 1,
		["fast_stop_index"] = 1,
		["special_index"]=1,
	}
	self.ThemeConfig = {
	["theme_symbol_coinfig"]    = {
		["symbol_zorder_list"]  = {
            [specialSymbol["triger"]] = 300,
            [specialSymbol["zeus"]]   = 200,
   --          ["j"] = 50,
   --          [21]=50, [22]=50, [23]=50, [24]=50, [25]=50, [26]=50, [27]=50, [28]=50, [29]=50, [30]=50, [31]=50, [32]=50, [33]=50, [34]=50, [35]=50,
			-- [36]=50, [37]=50, [38]=50
		},
		["normal_symbol_list"]  = {
			1,2,3,4,5,6,7,8,9,10,11
		},
		["special_symbol_list"] = {
			specialSymbol["triger"] 
		},
		["no_roll_symbol_list"] = {
			0,12,"2_2",30,20,21,22,23,24
		},
		["roll_symbol_inFree_list"] = {
		},
		["special_symbol_config"] = {
			[specialSymbol["triger"]] = {
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
	["theme_type"] = "payLine",
	["theme_type_config"] = {
		["pay_lines"] = {
			{1,1,1,1,1},{2,2,2,2,2},{0,0,0,0,0},{3,3,3,3,3},{0,1,2,1,0},{1,2,3,2,1},{2,1,0,1,2},{3,2,1,2,3},
			{0,1,1,1,0},{1,2,2,2,1},{2,3,3,3,2},{1,0,0,0,1},{2,1,1,1,2},{3,2,2,2,3},{0,0,1,0,0},{1,1,2,1,1},
			{2,2,3,2,2},{1,1,0,1,1},{2,2,1,2,2},{3,3,2,3,3},{0,1,0,1,0},{1,2,1,2,1},{2,3,2,3,2},{1,0,1,0,1},
			{2,1,2,1,2},{3,2,3,2,3},{1,0,1,2,1},{2,1,2,3,2},{1,2,1,0,1},{2,3,2,1,2},{0,0,1,2,2},{1,1,2,3,3},
			{2,2,1,0,0},{3,3,2,1,1},{0,0,2,0,0},{1,1,3,1,1},{2,2,0,2,2},{3,3,1,3,3},{0,0,0,1,2},{3,3,3,2,1}
		},
		["line_cnt"] = 40,
	},
	["theme_round_light_index"] = 1,
	["boardConfig"] = {
		{
			["reelConfig"] = {
				{
					["base_pos"] = cc.p(195.5,106),
					["cellWidth"] = 178,
					["cellHeight"] = 116.5,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(373.5,106),
					["cellWidth"] = 178,
					["cellHeight"] = 116.5,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(551.5,106),
					["cellWidth"] = 178,
					["cellHeight"] = 116.5,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(729.5,106),
					["cellWidth"] = 178,
					["cellHeight"] = 116.5,
					["symbolCount"] = 4
				},
				{
					["base_pos"] = cc.p(907.5,106),
					["cellWidth"] = 178,
					["cellHeight"] = 116.5,
					["symbolCount"] = 4
				},
			}
		},
		{
			["row_single"] = true, -- 每个reel单独一个空间，不共用一个clipnode。例如用于lockrespin
			["reelConfig"] = {
				["base_pos"] = cc.p(195.5,106),
				["cellWidth"] = 178,
				["cellHeight"] = 116.5,
				["symbolCount"] = 1
			}
		}
	}
}
	self.baseBet = 7500
	self.DelayStopTime = 0
	self.UnderPressure = 1
    
    local ret = Theme.ctor(self, themeid)
    return ret
end

local G_cellHeight = 116.5
local delay = 0
local upBounce = G_cellHeight*2/3
local upBounceMaxSpeed = 6*60
local upBounceTime = 0
local speedUpTime = 12/60
local rotateTime = 5/60
local maxSpeed = -30*60
local normalSpeed = -30*60
local fastSpeed = -30*60 - 300

local stopDelay = 20/60
local speedDownTime = 50/60
local downBounce = G_cellHeight*2/3
local downBounceMaxSpeed = 6*60
local downBounceTime = 21/60
local specialAniTime = 160/60 -- 特殊动画的时间
local extraReelTime = 120/60
local spinMinCD = 0.5

function cls:initScene(spinNode)
	local path = self:getPic("csb/base_game.csb")
	self.mainThemeScene = cc.CSLoader:createNode(path)
	bole.adaptScale(self.mainThemeScene,false)
	self.bgRoot = self.mainThemeScene:getChildByName("theme_bg")
	self.boardRoot = self.mainThemeScene:getChildByName("board_root")
	self.animateNode = self.mainThemeScene:getChildByName("animate")
	
	self.shakyNode:addChild(self.mainThemeScene)

	self.bgList = self.bgRoot:getChildByName("bg_node"):getChildren()-- 背景图节点
	self.baseKuang = self.bgRoot:getChildByName("reel_kuang1") -- base kuang
	self.respinKuang = self.bgRoot:getChildByName("reel_kuang2") -- respin kuang

	self.respinCntNode 	= self.mainThemeScene:getChildByName("respin_node") -- respin 计数节点
	self.respinCntNode:setLocalZOrder(100)
	self.respinCntLabel = self.respinCntNode:getChildByName("cnt_label")
	self.respinCntNode:setVisible(false)

	self.tipNode = self.mainThemeScene:getChildByName("tip_root")
	self.tipNode_3 = self.tipNode:getChildByName("tip_3")
	self.tipNode_4 = self.tipNode:getChildByName("tip_4")
	self.tipSpine = self.tipNode:getChildByName("spine_node")

	if self.ctl.footer.activityNode then
		local wP = self.ctl.footer.activityNode:convertToWorldSpace(cc.p(0,0))
		local cP = self.tipNode:convertToNodeSpace(wP)
		self.tipNode_3:setPositionX(cP.x+135)
		self.tipNode_4:setPositionX(cP.x+135)
	end

	self.anticipationBGList = {}
	for k ,v in pairs(self.mainThemeScene:getChildByName("anticipation"):getChildren()) do
		self.anticipationBGList[k+2] = v
	end

	self.black_BG = self.mainThemeScene:getChildByName("black_bg")

	-- 初始化jackpot
	local progressive_node = self.bgRoot:getChildByName("progressive")
	local progressiveLabels = progressive_node:getChildByName("jackpots_labels")
	self.jackpotLabels = {}
	for i=1,5 do	
		self.jackpotLabels[i] = progressiveLabels:getChildByName("label_jp" .. i)
		self.jackpotLabels[i].maxWidth = self:getJPLabelMaxWidth(i)
		self.jackpotLabels[i].baseScale = self.jackpotLabels[i]:getScale()
	end

	self:initialJackpotNode()

	self.speed = 1280/(4000*2)
    self.moveClodsScheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function (ft)
	self:moveCloudsUpdate(ft)
	end,0,false)

    self.spineBg = self.bgRoot:getChildByName("spine_bg")

	self:addSpineAnimation(self.spineBg, nil, self:getPic("spine/bg/dian/spine"), cc.p(0,0), "animation", nil, nil, nil, true, true, nil)
	self.Tip3 = false
end

-- cys 棋盘点击按钮
function cls:initBoardNodes( pBoardConfigList )
	local baseReelCfg = pBoardConfigList[1]["reelConfig"][1]
	local basePos     = baseReelCfg["base_pos"]
	local boardW      = baseReelCfg["cellWidth"]*5
    local boardH      = baseReelCfg["cellHeight"]*baseReelCfg["symbolCount"]
    self.boardSpinBtn = self:initTouchSpinBtn(basePos, boardW, boardH)

	return Theme.initBoardNodes(self, pBoardConfigList)
end

function cls:initTouchSpinBtn(base_pos, boardW, boardH, parentNode)
    local unitSize = 10
    local parent = parentNode or self.boardRoot
    local img = "commonpics/kong.png"
    local touchSpin = function()
        self:footerCopySpinBtnEvent()
    end
    local touchBtn = Widget.newButton(touchSpin, img, img, img, false) --10
    touchBtn:setPosition(base_pos)
    touchBtn:setAnchorPoint(cc.p(0, 0))
    touchBtn:setScaleX(boardW / unitSize)
    touchBtn:setScaleY(boardH / unitSize)
    parent:addChild(touchBtn)
    return touchBtn
end
-- cys

function cls:moveCloudsUpdate( ... )
	for k,v in pairs(self.bgList) do 
		v:setPositionX(v:getPositionX()-self.speed)
	end
	if self.bgList[1]:getPositionX()< -810 then
		local item = table.remove(self.bgList,1)
		item:setPositionX(self.bgList[#self.bgList]:getPositionX()+ 1555)
		table.insert(self.bgList,item)
	end
end

function cls:getJPLabelMaxWidth(index)
	if index == 1 then
		return 218
	else
		return 150
	end
end

function cls:initSpinLayerBg( )

	Theme.initSpinLayerBg(self)

	self.HoldLayer = cc.Node:create()
	self.HoldLayer:setPosition(-640,-360)
	self.mainThemeScene:addChild(self.HoldLayer, 21)
	self:laterCallBack(3,function ()
		self:setTip()
	end)
	-- self:setTip()
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

function cls:setTip(bet) -- 1 
	if not self.tipNode_3 or not self.tipNode_4 then return end
	local bet = self.ctl:getCurTotalBet() or bet
	if bet>=self.tipBet and (not self.Tip3) then -- and (not self.tipNode_3:isVisible() or self.tipNode_4:isVisible())

		local _, s2 =Theme:addSpineAnimation(self.tipNode_3,nil, self:getPic("spine/special/transition/respin/spine"),cc.p(50,-50),"animation3")

		self:runAction(cc.Sequence:create(cc.DelayTime:create(6/30) ,cc.CallFunc:create(function ( ... )
			self.tipNode_3:setVisible(true)
			self.tipNode_4:setVisible(false)
		end)))
		self.Tip3 = true
		-- self.tipNode_3:setVisible(true)
		-- self.tipNode_4:setVisible(false)
		-- self.tipNode_3:runAction(cc.Sequence:create(
  --   			cc.ScaleTo:create(0.2, 1.6),
  --   			cc.ScaleTo:create(0.2, 1)))
		self:playMusic(self.audio_list.transition)
	elseif bet<self.tipBet and self.Tip3 then -- and (self.tipNode_3:isVisible() or not self.tipNode_4:isVisible()) 

		local _, s2 =Theme:addSpineAnimation(self.tipNode_3,nil, self:getPic("spine/special/transition/respin/spine"),cc.p(50,-50),"animation3")

		self:runAction(cc.Sequence:create(cc.DelayTime:create(6/30) ,cc.CallFunc:create(function ( ... )
			self.tipNode_4:setVisible(true)
			self.tipNode_3:setVisible(false)
		end)))
		self.Tip3 = false
		-- self.tipNode_3:setVisible(false)
		-- self.tipNode_4:setVisible(true)
		-- self.tipNode_4:runAction(cc.Sequence:create(
  --   			cc.ScaleTo:create(0.2, 1.6),
  --   			cc.ScaleTo:create(0.2, 1)))
		self:playMusic(self.audio_list.transition)
	end
end

function cls:getThemeJackpotConfig()
	local jackpot_config_list = 
	{
		link_config = {"zeus", "mega", "major","minor","mini"},
		allowK = {[108] = false, [608] = false,[1108] = false},
	}
	return jackpot_config_list
end

function cls:playCellRoundEffect(parent, ...) -- 播放中奖连线框
end

function cls:freeStartClicked( callFunc,isMore) -- 点击之后 切换界面
	if isMore then
		if callFunc then
			callFunc()
		end
		return
	end
	-- 播放转场声音
	self:playMusic(self.audio_list.transition)
	-- 转场动画
	self:playTransition(transitionType.free,callFunc) -- 转场动画 播放完成之后进行 庆祝

	if not self.isEnteredFree then
		self.isEnteredFree = true
		self:laterCallBack(11/30,function ( ... )
			self:changeSpinBoard(SpinBoardType.FreeSpin) 
		end)
	end
	self:laterCallBack(0.2,function(  )
		self:dealMusic_PlayFreeSpinLoopMusic()
	end)
end

function cls:enterFreeSpin(isResume)
	if isResume then  -- 断线重连的逻辑
		-- 切换背景音乐
		self:dealMusic_PlayFreeSpinLoopMusic()
		-- 切换背景
		self:changeSpinBoard(SpinBoardType.FreeSpin)
	else
		self:showAllItem()
		--commonMusic: freespin背景音乐
		self.playNormalLoopMusic = false
		self:playMusic(self.audio_list.free_dialog_bgm)
	end
end

function cls:hideFreeSpinNode( ... ) -- 逻辑是个啥

	if self.ctl.freeItem then 
		self.recvItemList = table.copy(self.ctl.freeItem)
	end
	self.isEnteredFree 	  = false
	self:changeSpinBoard(SpinBoardType.Normal) 
	return Theme.hideFreeSpinNode(self, ...)
end

function cls:showBonusNode( )
	self.ctl:resetCurrentReels(false,true) -- 更改 bonus 的棋盘
end

function cls:hideBonusNode(free,bonus)
	self.ctl:resetCurrentReels(free,bonus) -- 更改 bonus 的棋盘
end

function cls:adjustEnterThemeRet(data)
	data.theme_reels = {
		["main_reel"] = {
			[1]={2,2,10,9,5,8,9,11,7,5,9,8,11,10,4,4,9,10,5,5,9,3,3,10,9,4,4,7,5,9,3,3,9,7,6,6,7,4,8,8,3,3,8,4,9,5,5,10,4,9,8,3,3,9,7,5,5,8,9,5,10,4,4,9,5,10,3,3,8,5,9,7,2,2,2,2,2,10,9,5,5,9,4,4,9,5,10,4,4,7,4,4,7,7,6,6,9,3,3,10,6,6,9,10,6,6,9,8,6,6,7,4,8,3,3,7,2,2,2},
			[2]={3,3,7,4,7,10,4,4,8,10,1,1,1,10,8,3,3,10,7,5,9,10,6,2,2,2,2,2,2,7,10,5,6,10,8,6,6,10,8,3,3,9,10,4,7,3,3,7,9,6,6,8,1,1,1,10,4,4,8,10,5,5,7,10,5,7,6,2,2,2,2,2,2,10,9,4,4,10,11,8,6,6,10,8,3,3,7,6,10},
			[3]={2,2,2,2,2,2,8,10,11,9,6,7,10,5,7,11,4,4,7,1,1,1,3,3,3,10,7,11,3,8,4,4,10,7,5,10,11,6,6,8,3,3,10,4,4,4,7,6,6,11,8,5,9,1,1,1,5,10,6,7,5,11,8,6,6,8,3,3,10,4,4,8,9,6,6,7,11,3,3,7,8,1,1,9,4,4,10,8,5,9},
			[4]={1,1,1,4,7,7,3,3,10,11,3,3,3,8,6,6,6,10,5,9,2,2,2,2,2,2,4,10,3,3,11,5,9,8,4,4,9,11,5,7,1,1,1,7,3,3,10,5,9,7,11,10,9,5,10,4,4,8,1,1,10,6,11,4,8,5,5,8,10},
			[5]={9,11,10,6,6,9,4,4,4,10,11,10,3,3,8,7,2,2,2,2,2,10,7,5,3,3,6,10,11,8,5,5,9,11,7,3,3,8,7,6,6,9,5,8,4,4,7,11,10,6,6,9,6,10,11,7,8,4,4,7,6,6,9,3,3,6,7,9,5,11,6,9,4,4,4,10,11,3,3,8,4,4,9,2,2,2,2,2,10,7,5,3,3,6,10,11,8,5,5,9,11,7,3,3,8,7,6,6,9,5,8,4,4,7,11,10,3,3,9,6,10,11,7,3,3,8,4,4,7,6,6,9,3,3,6,7,5,5,10,4,4}
		},
		["free_reel"] = {
			[1]={6,6,10,9,9,5,5,10,4,9,3,3,10,5,6,6,9,7,2,2,2,2,2,9,3,3,10,5,9,4,8,11,10,5,7,8,6,4,4,10,6,8,2,2,2,2,2,10,4,4,7,6,4,4,10,3,3,5,7,4,8,5,5,2,2,2,2,2,8,3,3,8,3,3,8,6,9,5,5,10,4,2,2,2,2,2,9,7,6,10,8,9,6},
			[2]={2,2,2,2,2,2,7,4,7,4,10,7,1,1,8,6,9,11,6,8,3,3,9,6,4,3,3,7,1,1,1,1,7,5,5,10,6,8,4,4,10,1,1,1,1,9,8,3,9,8,1,1,9,10,5,7},
			[3]={1,1,1,1,9,10,10,11,5,9,2,2,2,2,10,5,10,11,9,5,7,6,10,5,7,11,4,4,1,1,1,1,8,6,7,3,3,10,6,11,3,3,8,4,4,8,7,2,2,2,2,7,10,5,5,11,8,1,1,10,6,8,3,3,8,4,4,10,3,9,9},
			[4]={2,2,2,2,10,8,1,1,1,8,4,4,8,1,1,1,1,9,8,4,8,5,5,11,10,1,1,1,7,8,4,6,7,3,3,10,11,8,3,3,9,8,6,5,5,11,6,9,2,2,2,2,8,4,10,3,3,11,10,6,9,8,4,4,9,5,5,7,11,6,7,3,3,9,10,5,5,7},
			[5]={7,11,10,7,3,3,8,4,4,7,6,6,9,3,3,6,7,5,5,10,4,4,9,11,10,6,6,9,4,10,3,8,7,2,2,2,2,2,10,6,6,7,5,7,3,3,6,10,8,5,5,9,7,6,7,3,3,8,7,6,6,9,5,8,4,7,2,2,2,2,10,6,6,9}
		},
		["bonus_reel"] = {
			[1]={0,0,2,0,2,0,0,0,2,0,2,0,2,0,0,2,0,2,0,0,0,2,0,12,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,2,0,2,0,2,0,0},--{0,2,0,2,0,0,2,0,2,0,0,0,2,0,12,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,2,0,2,0,2,0,0}
			[2]={0,0,2,0,2,0,0,0,2,0,2,0,2,0,0,2,0,2,0,0,0,2,0,12,0,2,0,0,2,0,2,0,0,2,0,0,2,0,2,0,0,2,2,0,2,0,2,0,0},
			[3]={0,0,2,0,2,0,0,0,2,2,0,0,2,0,12,0,2,0,0,2,0,2,0,0,2,0,2,0,2,0,0,2,0,0,0,0,2,0,2,0,0,2,2,0,2,0,2,0,0},
			[4]={0,0,2,0,2,0,0,0,2,0,2,0,2,0,2,0,2,0,0,12,0,0,2,0,2,0,2,0,0,2,0,2,0,0,0,0,2,0,2,0,2,0,2,0,2,0,2,0,0},
			[5]={0,0,2,0,2,0,0,0,2,0,0,2,0,2,0,0,0,2,0,2,0,0,2,0,0,2,0,0,12,0,2,0,0,2,0,2,0,2,0,0,0,2,2,0,2,0,2,0,0},
		},
	}
	self.tipBet = data.bonus_level
	return data
end

function cls:adjustTheme(data)

	if data.free_spins then 
		self:changeSpinBoard(SpinBoardType.FreeSpin) 
		-- self.ctl.freeItem = table.copy(self.recvItemList)
	-- elseif data.bonus_game then
		-- self.dontR0 = true
		-- self:changeSpinBoard(SpinBoardType.ReSpin)
	
	else
		self:changeSpinBoard(SpinBoardType.Normal)
	end

end

function cls:changeSpinBoard(pType) -- 更改背景控制 已修改

	if pType == SpinBoardType.Normal then -- normal情况下 需要更改棋盘底板
		
		-- if self.spinLayer then
		-- 	self.spinLayer:DeActive()
		-- end
		-- self.spinLayer = self.spinLayerList[1]
		-- self.spinLayer:Active()

		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
		end
		self.showFreeSpinBoard = false
		self.showReSpinBoard = false

		self.baseKuang:setVisible(true)-- 控制框 显示
		self.respinKuang:setVisible(false)
		-- 更改棋盘
		for k,v in pairs(self.bgList) do
			v:setTexture(self:getPic(bgPath["base"])) -- 换背景
 		end
	elseif pType == SpinBoardType.FreeSpin then


		-- if self.spinLayer then
		-- 	self.spinLayer:DeActive()
		-- end
		-- self.spinLayer = self.spinLayerList[1]
		-- self.spinLayer:Active()
		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
		end
		self.showFreeSpinBoard = true
		self.showReSpinBoard = false

		self.baseKuang:setVisible(true)-- 控制框 显示
		self.respinKuang:setVisible(false)
		-- 更改棋盘
		for k,v in pairs(self.bgList) do
			v:setTexture(self:getPic(bgPath["free"])) -- 换背景
		end
	elseif pType == SpinBoardType.ReSpin then
		if self.showReSpinBoard then return end
		self.lockedReels = {}
		self.HoldLayer._added = {}
		

		if self.spinLayer then
			self.spinLayer:DeActive()
		end
		self.spinLayer = self.spinLayerList[2]
		self.spinLayer:Active()
		self.showReSpinBoard = true
		-- local previous = nil
		-- if self.spinLayer then
		-- 	previous = self.spinLayer
		-- end
		-- self.spinLayer = self.spinLayerList[2]
		-- self.spinLayer:setOpacity(0)
		-- self.spinLayer:Active()
		
		-- self:laterCallBack(specialAniTime+0.1,function( ... )
		-- 	previous:runAction(cc.Sequence:create(cc.FadeOut:create(1),cc.CallFunc:create(function ( ... )
		-- 		previous:DeActive()
		-- 		previous:setOpacity(255)
		-- 	end)))
		-- 	self.spinLayer:runAction(cc.FadeIn:create(1))--self.spinLayer:setVisible(true)
		-- end)

		self.baseKuang:setVisible(false)-- 控制框 显示
		self.respinKuang:setVisible(true)
		-- 更改棋盘
		for k,v in pairs(self.bgList) do
			v:setTexture(self:getPic(bgPath["respin"])) -- 换背景
			-- v:removeAllChildren()
			-- local _,s = self:addSpineAnimation(v, nil, self:getPic("spine/bg/yun_respin/spine"), cc.p(320,180), "animation", nil, nil, nil, true, true, nil)
		end
	end
end

local notNeedSet = Set({1,3,4,5,6,7,8,9,10,11})

-- function cls:adjustWithTheCellSpriteUpdate( theCellNode, key, col )
-- 	if key == 12 then 
-- 		local theCellFile = theCellNode.jackpotKey and "#theme_jackpot_"..theCellNode.jackpotKey..".png" or "#theme_jackpot_base.png"
-- 		if theCellNode.jackpot then
-- 			bole.updateSpriteWithFile(theCellNode.jackpot, theCellFile)
-- 		else 
-- 			local theCellSprite = bole.createSpriteWithFile(theCellFile)
-- 			theCellNode:addChild(theCellSprite)
-- 			theCellNode.jackpot = theCellSprite
-- 		end
-- 	elseif theCellNode.jackpot then
-- 		theCellNode.jackpot:removeFromParent()
-- 		theCellNode.jackpot = nil
-- 	end
-- end

function cls:createCellSprite(key, col, rowIndex)
	self.recvItemList = self.recvItemList or {}
	self.recvItemList[col] = self.recvItemList[col] or {}
	self.recvItemList[col][rowIndex] = key
------------
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
	theCellFile = self.pics[key]
	if self.initBoardIndex == 2 then
		if notNeedSet[key] then
			key = respinSet[math.random(1,#respinSet)]
		end
		theCellFile   = self.pics[key]
		if key == specialSymbol["zeus"] then 
			theCellFile = self.pics[key.."_2"]
		end
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
	local ret = theCellNode

	function ret.sprite:runHintAction() -- 干嘛用的？ 
		
	end
	function ret.sprite:reset() -- 重置symbol 上面的特殊控制(不需要了, 因为J的spine 动画 在开始的时候被自动删除了)
		-- self:setScale(scale)
	end	

	return ret
end

function cls:updateCellSprite(theCellNode, key, col)
	if self.lockedReels and self.lockedReels[col] then key = 0 end
	------------------------------------------------------------
	local theCellFile = self.pics[key]
	if self.showReSpinBoard then 
		if notNeedSet[key] then
			key = respinSet[math.random(1,#respinSet)]
		end
		theCellFile 	= self.pics[key]-- theCellNode.sprite:setOpacity(100)
		if key == specialSymbol["zeus"] then 
			theCellFile = self.pics[key.."_2"]
		end
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
	theCellSprite:setPosition(cc.p(0,0))
	if self.changeOpacity then
		if theCellNode.key~=specialSymbol["triger"] then
			theCellNode.sprite:setColor(cc.c3b(94,94,94))
		else
			theCellNode.sprite:setColor(cc.c3b(255,255,255))
		end
	end

	if self.showReSpinBoard then 
		theCellNode.sprite:setColor(cc.c3b(94,94,94))
		-- if theCellNode.jackpot then 
		-- 	theCellNode.sprite:setOpacity(100)
		-- end
	end
	
end

function cls:onSpinStart()

	self.DelayStopTime = 0
	Theme.onSpinStart(self)
end

function cls:onSpinStop(ret)
	
	self.respinStep = ReSpinStep.OFF
	if ret.bonus_game then --ret.theme_respin
		---- whj 添加数据 在进入respin 之前 对数据 
		self.respinStep = ReSpinStep.Start
	end
	self:fixRet(ret)
	Theme.onSpinStop(self, ret)

end

function cls:onRespinStart()
	self.DelayStopTime = 0
	self.bonus:onRespinStart()
	
	Theme.onRespinStart(self)
	self:cleanSpecialSymbolState()
	
	self.tipAnim = {} -- repsin 里面每一列的提示 动画是否播放的 check表

	-- 添加 提示动画4*4
	local cellHeight = self.spinLayer.spins[3].cellHeight
	local cellWidth = self.spinLayer.spins[3].cellWidth
	local pos = cc.pAdd(self.spinLayer:getCellPos(3,1),cc.p(cellWidth/2,cellHeight/2))
	self:addSpineAnimation(self.HoldLayer, 200, self:getPic("spine/special/dian/4_4/spine"), pos, "animation")
	self:playMusic(self.audio_list.bonus_dian4_4) 
	-- local newCount = bole.getTableCount(self.HoldLayer._added)
	-- if self.curReelLevel <5 then
	-- 	if not self.holdCount then 
	-- 		self.holdCount = newCount
	-- 		self.curReelLevel = (self.curReelLevel or 0) + 1
	-- 	elseif self.holdCount < newCount then 
	-- 		self.holdCount = newCount
	-- 		self.curReelLevel = (self.curReelLevel or 0) + 1
	-- 	end
	-- end
	-- -- 播放 声音
	-- self:playMusic(self.audio_list["bonus_reel_roll"..self.curReelLevel],true,true)
end

function cls:onRespinStop(ret)

	self.dontR0 = false
	self:fixRet(ret)
	if #ret["theme_respin"] == 0 then
		self.respinStep = ReSpinStep.Over
		ret.theme_deal_show = true
	end
	Theme.onRespinStop(self, ret)

end

function cls:fixRet(ret) -- 查看逻辑控制原因 拆分服务器返回的滚轴数据,分成15个结果

	if self.respinStep == ReSpinStep.Playing then 
		self.ctl.resultCache = {}	-- ret["reelItem_list"] = {} -- 添加

		local itemsList = table.copy(ret.item_list)

		for i=0,respinCellCount-1 do -- 横向拆分 和 棋盘一致
			ret.item_list[1+i] = {itemsList[1+(i%5)][1+math.floor(i/5)]}
			-- 在每一轴 拼接结果数据
			self.ctl.resultCache[1+i] = {math.random(1,10),itemsList[1+(i%5)][1+math.floor(i/5)]} --向上插入一个值 {math.random(1,10) , itemsList[1+(i%5)][1+math.floor(i/5)]}-- ret["reelItem_list"][1+i] = {math.random(1,10) , itemsList[1+(i%5)][1+math.floor(i/5)]}
			local col = 1+ (i-1)%5
			local symbols = self.ctl.currentReels[col] -- 获得 1-5 轴的 滚轴数据
			
			local key = math.random(2,#symbols)
			local extraCount = 6
			if self.isTurbo then
				extraCount = 3
			end
			for k = 1,extraCount do -- 向下插入 六个 值
				key = 1 + (key + k - 1)%#symbols
				table.insert(self.ctl.resultCache[1+i],symbols[key])
				--print("wy_0?",key,symbols[key])
			end
		end
	end

	self.recvItemList = ret.item_list

	if not self.showReSpinBoard then  -- 只在没有respin 的时候 才出现 合图  进行宙斯 和图 的分析
		self:getZeusCnt(ret)
	end

	self.JHint = {}
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

	for col=1,5 do
		if winPosList[col] then
			local count = 0
			local topIndex = 1
			local canBig = false
			for row=1,4 do
				if ret.item_list[col][row] == specialSymbol["zeus"] then --and winPosList[col][row]
					count = count + 1
					if winPosList[col][row] then 
						canBig =true
					end
				else
					if count >0 and canBig then 
						self.zeus_cnt[col] = self.zeus_cnt[col] or {}
						self.zeus_cnt[col][topIndex] = count
					end
					canBig = false
					count = 0
					topIndex = row+1
				end
			end
			if count >0 and canBig then 
	            self.zeus_cnt[col] = self.zeus_cnt[col] or {}
	            self.zeus_cnt[col][topIndex] = count
	        end
		end
    end
end

--------------------------Start--------------------------
-----------------------多棋盘 相关属性----------------------

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
	if self.showReSpinBoard and self.HoldLayer._added[reelCol] then
		spinAction.locked = true
	end
	return spinAction
end
 
function cls:getSpinColStopAction(ret, pCol, interval)
	local specialType = nil
	local themeInfo = ret["theme_info"]

	-- if not self.haveFirstBonus and not self.showReSpinBoard then 
	-- 	specialType= themeInfo and themeInfo["special_type"]
	-- end

	local checkNotifyTag   = self:checkNeedNotify(pCol)

	if checkNotifyTag then
		self.DelayStopTime = self.DelayStopTime + extraReelTime
	end

	local function onSpecialBegain( pcol)

	end

	local function onSpecialEnd( )

	end
	local spinAction = {}
	spinAction.actions = {}

	if self.haveFirstBonus then
		self.canFastStop = false
	end
	-- if specialType then
	-- 	table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = 1000,["accelerationTime"] = 10/60,["beginFun"] = onSpecialBegain})
	-- 	local temp = interval - speedUpTime - upBounceTime - (pCol-1)*delay
	-- 	local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0
	-- 	spinAction.stopDelay = timeleft+(pCol-1)*stopDelay + specialAniTime

	-- 	self.ExtraStopCD = spinAction.stopDelay+speedDownTime
	-- 	self.canFastStop = false
	-- 	spinAction.ClearAction = true
	-- else

	local temp = interval - speedUpTime - upBounceTime
	local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0
		-- if self.haveFirstBonus and pCol~=1 then 
		-- 	spinAction.stopDelay = specialAniTime
		-- else
	spinAction.stopDelay = timeleft+(pCol-1)*stopDelay + self.DelayStopTime
	self.ExtraStopCD = spinMinCD - temp > 0 and spinMinCD - temp or 0
		-- end
		
	-- end
	spinAction.maxSpeed = maxSpeed
	spinAction.speedDownTime = speedDownTime
	if self.isTurbo then
		spinAction.speedDownTime = speedDownTime - 20/60
	end
	spinAction.downBounce = downBounce
	spinAction.downBounceMaxSpeed = downBounceMaxSpeed
	spinAction.downBounceTime = downBounceTime
	spinAction.stopType = 1
	return spinAction
end


function cls:stopControl( stopRet, stopCallFun )
	if stopRet["special_type"] then 
		self.ctl.specialSpeed = true
	elseif stopRet["bonus_level"] then
		self.tipBet = stopRet["bonus_level"]
	end
	stopCallFun()
end

function cls:getSpinColFastSpinAction(pCol)
	local speedScale = nil
	return Theme.getSpinColFastSpinAction(self, pCol, speedScale)
end

function cls:getSpinConfig( spinTag )
	local spinConfig = {}
	if self.showReSpinBoard then -- TODO 需要修改
		for i=0, respinCellCount-1 do
			local col = i+1
			local tempCol = i%5+1
			local theStartAction = self:getSpinColStartAction(tempCol,col)
			local theReelConfig = {
				["col"]     = col,
				["action"]  = theStartAction,
			}
			table.insert(spinConfig, theReelConfig)
		end		
		return spinConfig
	else
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
end

function cls:getStopConfig( ret, spinTag ,interval )
	local stopConfig  = {}
	if self.showReSpinBoard then
		self.haveFirstBonus = false
		for i=0, respinCellCount-1 do
			local col = i+1
			local tempCol = i%5+1
			local theAction = self:getSpinColStopAction(ret, tempCol,interval)
			table.insert(stopConfig, {col, theAction})
		end	
	else 

		local stopColOrderList = {}
		if ret["bonus_game"] then 
			table.insert(stopColOrderList, 1)
			self.haveFirstBonus = true
			self.RetBonusGameData = table.copy(ret["bonus_game"])
		else 
			self.haveFirstBonus = false
			for i=1, 5 do
				table.insert(stopColOrderList, i)
			end	
		end


		for index,col in pairs(stopColOrderList) do
			local theAction = self:getSpinColStopAction(ret, col,interval)
			table.insert(stopConfig, {col, theAction})
		end	
	end
	return stopConfig
end

-- 滚轮音效相关
function cls:dealMusic_PlayReelStopMusic( pCol )
	if self.showReSpinBoard then return end
	-- 转轮停止声音
	Theme.dealMusic_PlayReelStopMusic(self,pCol)
end

function cls:checkPlaySymbolNotifyEffect( pCol )
	self:dealMusic_StopReelNotifyMusic(pCol)
	local pCol2 = 1 + (pCol-1)%5

	local reelSymbolState = self.notifyState and self.notifyState[pCol2] or false
	if not self.fastStopMusicTag and reelSymbolState and bole.getTableCount(reelSymbolState)>0 then -- 判断是否播放特殊symbol的动画
		self:dealMusic_PlaySpecialSymbolStopMusic(pCol)
		  -- 不需要这个逻辑
		-- self.notifyState[pCol] = {} -- whj 修改切换放置位置
		return true
	else
		self:dealMusic_PlaySpecialSymbolStopMusic(pCol)
		-- if pCol == #self.spinLayer.spins then
		-- 	local tmp = self.hintMusicCnt
		-- 	for k,v in ipairs(self.notifyState) do
		-- 	 	if bole.getTableCount(v) > 0 then
		-- 			self.hintMusicCnt = self.hintMusicCnt + 1
		-- 			self:playSymbolNotifyEffect(k, v)
		-- 			self.notifyState[k] = {}
		-- 		end
		-- 	end
			
		-- 	self:dealMusic_StopReelNotifyMusic()
		-- 	if self.hintMusicCnt > tmp then
		-- 		self.hintMusicCnt = self.hintMusicCnt - 1 
		-- 		self:dealMusic_PlaySpecialSymbolStopMusic(pCol)
		-- 		return true
		-- 	end
		-- end
		return false
	end
end

-----------------------多棋盘 相关属性---------------------
-------------------------Re Spin-------------------------
function cls:showAllItem(showState)
	if self.showReSpinBoard then return end
	Theme.showAllItem(self, showState)
end

-- 滚轴滚到底部
function cls:onReelFallBottom( pCol )

	-- 添加 respin 的提示动画
	if self.showReSpinBoard then 
		-- 恢复所有symbol 的 正常状态
		for k ,v in pairs(self.spinLayer.spins[pCol].cells) do 
			v.sprite:setColor(cc.c3b(255,255,255))
		end

		local pCol2 = 1 + (pCol-1)%5
		self.tipAnim = self.tipAnim or {}
		-- if pCol2 >2 and self.tipAnim[pCol2-1]["anim"] then 
		-- 	self.tipAnim[pCol2-1]["anim"]:removeFromParent()
		-- 	self.tipAnim[pCol2-1]["anim"] = nil
		-- end
		if not (self.tipAnim[pCol2] and self.tipAnim[pCol2]["haveAnim"]) then 

			local cellHeight = self.spinLayer.spins[pCol2].cellHeight
			local pos = cc.pAdd(self.spinLayer:getCellPos(pCol2,1),cc.p(0,cellHeight/2))
			local _,s = self:addSpineAnimation(self.HoldLayer, 200, self:getPic("spine/special/dian/1_4/spine"), pos, "animation",nil,nil,nil,false,false)
			self.tipAnim[pCol2] = {}
			self.tipAnim[pCol2]["haveAnim"] = true
			-- self.tipAnim[pCol2]["anim"] = s
		end
	end

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
end

function cls:onReelFastFallBottom( pCol )
		-- 添加 respin 的提示动画
	if self.showReSpinBoard then 
		-- 恢复所有symbol 的 正常状态
		for k ,v in pairs(self.spinLayer.spins[pCol].cells) do 
			v.sprite:setColor(cc.c3b(255,255,255))
		end
	end
	self.notifyState = self.notifyState or {}
	Theme.onReelFastFallBottom(self,pCol)
end

function cls:playReelNotifyEffect(pCol)  -- 播放特殊的 等待滚轴结果的	
 	self.reelNotifyEffectList = self.reelNotifyEffectList or {}
 	-- self.reelNotifyEffectList[pCol] = self.reelNotifyEffectList[pCol] or {}

 	local reelCellHeight = self.spinLayer.spins[pCol].cellHeight
 	local pos 	= cc.pAdd(self:getCellPos(pCol,2),cc.p(0,reelCellHeight/2))
 	local _,s1 = self:addSpineAnimation(self.animateNode, 20, self:getPic("spine/special/reelnotify/jili_01"), pos, "animation",nil,nil,nil,true,true)
 	self.reelNotifyEffectList[pCol] = s1
 	if SHRINKSCALE_H < 1 then
		local scale = bole.getAdaptScale(false)
		s1:setScaleY(1/scale)
	end

	--  增大滚轴 clip 显示区域
	if self.clipData and self.clipData["normal"] then

		local vex = self.clipData["normal"][pCol]["vex"]
		local stencil = self.clipData["normal"][pCol]["stencil"]
		vex[1] = cc.pAdd(vex[1],cc.p(0,-360))
		vex[2] = cc.pAdd(vex[2],cc.p(0,-360))
		vex[3] = cc.pAdd(vex[3],cc.p(0,360))
		vex[4] = cc.pAdd(vex[4],cc.p(0,360))

		stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))
		
	end

	self.anticipationBGList[pCol]:runAction(cc.FadeTo:create(10/30,255))
	self.anticipationBGList[pCol]:setVisible(true)
	
end

function cls:stopReelNotifyEffect(pCol)
	self.reelNotifyEffectList = self.reelNotifyEffectList or {}
	if self.reelNotifyEffectList[pCol] and (not tolua.isnull(self.reelNotifyEffectList[pCol])) then
		self.reelNotifyEffectList[pCol]:removeFromParent()
		self.reelNotifyEffectList[pCol] = nil

		--  恢复滚轴 clip 显示区域
		if self.clipData and self.clipData["normal"] then
			local vex = self.clipData["normal"][pCol]["vex"]
			local stencil = self.clipData["normal"][pCol]["stencil"]
			vex[1] = cc.pAdd(vex[1],cc.p(0,360))
			vex[2] = cc.pAdd(vex[2],cc.p(0,360))
			vex[3] = cc.pAdd(vex[3],cc.p(0,-360))
			vex[4] = cc.pAdd(vex[4],cc.p(0,-360))
			stencil:clear()
			stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))
		end

		-- 清除黑色蒙版
		self.anticipationBGList[pCol]:setVisible(false)
	end
end

function cls:theme_deal_show(ret)
	ret.theme_deal_show = nil
	if self.respinStep == ReSpinStep.Reset then	
		self.ctl.footer:setSpinButtonState(true) -- 关闭 footer spin 按钮
		self.bonus:freshRespinTotalNum()	
		self:laterCallBack(1, function ()
			self.ctl.footer.spinNode:changeBtnState("ingore", false, false)-- 显示 footer spin 按钮
			self.ctl:handleResult()
		end)		
	elseif self.respinStep == ReSpinStep.Over then
		self.bonus:onRespinStop(ret)
	end
end

function cls:enterThemeByBonus(theBonusGameData, endCallFunc)
	self.ctl:open_old_bonus_game(theBonusGameData, endCallFunc)
end

function cls:theme_respin( rets )
	if self.enterRespinFirst then
		self.enterRespinFirst = false
		local respinList = rets["theme_respin"]
		if respinList and #respinList>0 then
			rets["item_list"] = table.remove(respinList, 1)

			local respinStopDelay = 1
			local endCallFunc 	  = self:getTheRespinEndDealFunc(rets)
			self:stopDrawAnimate()
			self.ctl:respin(respinStopDelay, endCallFunc)
		else
			rets["theme_respin"] = nil
		end
	else
		local delay = 0.5
		self:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(function()
			local respinList = rets["theme_respin"]
			if respinList and #respinList>0 then
				rets["item_list"] = table.remove(respinList, 1)

				local respinStopDelay = 1
				local endCallFunc 	  = self:getTheRespinEndDealFunc(rets)
				self:stopDrawAnimate()
				self.ctl:respin(respinStopDelay, endCallFunc)
			else
				rets["theme_respin"] = nil
			end	
		end)))
	end
end

-------------------------Re Spin-------------------------
--------------------------Ended--------------------------

function cls:dealAboutBetChange(bet,isPointBet)
	self:setTip(bet)
end

function cls:genSpecialSymbolState( rets )
	if self.showReSpinBoard then 
	 	rets = rets or self.ctl.rets
		if not self.checkItemsState then
			local cItemList   = rets.item_list
			self.checkItemsState = {}  -- 都已列作为项， 各列各个sybmol相关状态，分为后面有可能，单列就有可能中，已经中了，后续没有可能中了
			self.speedUpState 	 = {}  -- 加速的列控制
			self.notifyState 	 = {}  -- 播放特殊symbol滚轴停止的时候的动画位置
			for col=1, #self.spinLayer.spins do -- 遍历每一列
				local colItemList = cItemList[col]
				if(colItemList) then
					for row, theItem in pairs(colItemList) do
						-- 添加 jackpot 加速处理 计算当前列中有几个 jackpot symbol
						if respinLockKey[theItem] and (not self.lockedReels[col]) then
							local realCol = 1 + (col-1) % 5
							self.notifyState[realCol] = self.notifyState[realCol] or {}
							self.notifyState[realCol][theItem] = self.notifyState[realCol][theItem] or {}
							table.insert(self.notifyState[realCol][theItem], {col, row})
						end
					end
				end
			end
		end
	else
		Theme.genSpecialSymbolState(self,rets)
	end	

end

local bigScale = 1.5
function cls:playSymbolNotifyEffect(col,isBig)
	for k,cell in pairs(self.spinLayer.spins[col].cells) do
		if cell.key == specialSymbol["triger"] then
			if isBig then 
				cell:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1,bigScale),cc.ScaleTo:create(0.2,1)))
				-- cell:setScale(bigScale)
			end
		end
	end
	-- local item_List = self.recvItemList
	-- for k,v in pairs(item_List[col]) do 
	-- 	if v == specialSymbol["triger"] then
	-- 		local cell = self.spinLayer.spins[col]:getRetCell(k) 
	-- 		if isBig then 
	-- 			cell:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1,bigScale),cc.ScaleTo:create(0.3,1)))
	-- 			-- cell:setScale(bigScale)
	-- 		else
	-- 			-- cell:runAction(cc.ScaleTo:create(0.5,1))
	-- 			-- cell:setScale(1)
	-- 		end
			
	-- 	end
	-- end
end

function cls:onReelStop( col )

	self:checkRunRespin(col)

	if self.showReSpinBoard then
		if self.lockedReels and self.lockedReels[col] then return end 
		local item_List = self.recvItemList
		local key = item_List[col][1]
		if respinLockKey[key] then

			self.lockedReels[col] = true
			if key == 12 then 
				self.haveJackpotList = (self.haveJackpotList or {})
				if self.ctl.rets.jp_win then 
					local jpItem = table.remove(self.ctl.rets.jp_win)
					table.insert(self.haveJackpotList,{jpItem,col})
					self.ctl.rets.jackpot_sync_data = true
				end
			end
			if self.respinStep == ReSpinStep.Playing then
				self.respinStep = ReSpinStep.Reset
				self.ctl.rets.theme_deal_show = true
			end

			self:laterCallBack(0, function ()
				local pos = self:getCellPos(col, 1)
				-- 宙斯动画
				local holdSp = nil
				local t =nil
				if key == specialSymbol["zeus"] then
					if (1+(col-1)%5)~=1 then
						local spineFile = self:getPic("spine/item/"..key.."/spine")
						t, holdSp 	  = self:addSpineAnimation(self.HoldLayer, 50+col, spineFile,pos, "animation",nil,nil,nil,true,true)
						-- whj 添加特效光圈
						local spineFile   = self:getPic("spine/special/dian/1_1/spine")
						self:playEffectWithInterval(self.audio_list.bonus_dian1_1,0.1,false)
						local _, s1 	  = bole.addSpineAnimation(self.HoldLayer, 100, spineFile,pos, "animation")	-- -1
					else
						local pic = self.pics[0] 
						holdSp = bole.createSpriteWithFile(pic)
						holdSp:setPosition(pos)
						self.HoldLayer:addChild(holdSp, 50+col)

					end
				elseif key == 12 then 
					local pic = self.pics[12]
					holdSp = bole.createSpriteWithFile(pic)
					holdSp:setPosition(pos)
					-- holdSp:setVisible(false)
					self.HoldLayer:addChild(holdSp, 50+col)
				end
				self.HoldLayer._added[col] = holdSp

				local cell = self.spinLayer.spins[col]:getRetCell(1)
				self:updateCellSprite(cell, 0, col, 1)

			end)
		end
	end

	Theme.onReelStop(self, col)
end

function cls:checkRunRespin(pCol)
	if pCol == 1 and self.haveFirstBonus then 
		self.haveFirstBonus = false
		local rets = self.ctl.rets
		local delay = 0.1
		local colList = self.ctl.rets["item_list"][1]
		local count  = 0
		for k,v in pairs(colList) do 
			if v == specialSymbol.zeus then
				count = count +1
			end
		end
		
		local reelCellHeight = self.spinLayer.spins[pCol].cellHeight
		if count == 3 then 
			-- 播放动画
			delay = 1.5 + 30/60
			local moveUp = 0 
			local pos = cc.p(0,0)
			
			if colList[1] == specialSymbol.zeus then 
				moveUp = 1
				pos = cc.pAdd(self.spinLayer:getCellPos(1,1),cc.p(0,reelCellHeight/2))
			elseif colList[#colList] == specialSymbol.zeus then
				moveUp = -1
				pos = cc.pAdd(self.spinLayer:getCellPos(1,2),cc.p(0,reelCellHeight/2))
			end	
			local _,s = self:addSpineAnimation(self.HoldLayer, 200, self:getPic("spine/special/dian/1_3r/spine"), pos, "animation")
			self:laterCallBack(1,function ()
				self.spinLayer:setIconAtIndex(1,moveUp,specialSymbol.zeus)
		        self.spinLayer:moveReel(1,moveUp,30/60)
				-- 播放移动声音
		        self:playMusic(self.audio_list.bonus_nudge)
				self.ctl.rets["item_list"][1] = {specialSymbol.zeus,specialSymbol.zeus,specialSymbol.zeus,specialSymbol.zeus}
			end)	
		end 

        self:laterCallBack(delay,function ( ... )
        	-- 进行宙斯 大图动画播放
        	local pos = self.spinLayer:getCellPos(1,1)-- cc.pAdd(self.spinLayer:getCellPos(1,2),cc.p(0,-reelCellHeight/2))
			local _,s = self:addSpineAnimation(self.HoldLayer, 200, self:getPic("spine/item/2_big/spine"), pos, "animation1_41",nil,nil,nil,true)
			self:playMusic(self.audio_list.bonus_hint)	
			self.bigZeusSpine = s

			local pos2 = cc.pAdd(self.spinLayer:getCellPos(1,1),cc.p(0,reelCellHeight/2))
			self:laterCallBack(0.5,function ( ... )
				local _,s2 = self:addSpineAnimation(self.HoldLayer, 200, self:getPic("spine/special/dian/1_4/spine"), pos2, "animation",nil,nil,nil,true,true)
				self:laterCallBack(20/30,function ( ... )
					s2:removeFromParent()
				end)
				-- 播放转场声音
				self:playMusic(self.audio_list.transition)
				-- 转场动画
				self:playTransition(transitionType.respin2) -- 转场动画 
			end)

			self:laterCallBack(0.5+ 10/30,function ( ... )
				if self.RetBonusGameData then 
					rets.bonus_game = rets.bonus_game or self.RetBonusGameData
				end
				self.ctl:bonus_game(rets)
				self.RetBonusGameData = nil
			end)

        	self:laterCallBack(1,function ()
        		bole.spChangeAnimation(s,"animation1_42",true)
        	end)
        end)
	end
end

function cls:onAllReelStop()

	Theme.onAllReelStop(self)
end

local fs_show_type = {
	start = 1,
	more = 2,
	collect = 3,
}
function cls:showFreeSpinDialog(theData, sType)
	if not self.freeSpinConfig then
		local config = {}
		config["gen_path"] = self:getPic("csb/")
		config["csb_file"] = config["gen_path"].."free_dialog.csb"
		config["frame_config"] = {
			["start"] 		 = {{0,30}, 1.2, {60, 90}, 0.4,0,0,["jump"] = {{60/60,1.05,1.05},{60/60,0.95,0.95},["startScale"] = {0.95,0.95}}},
			["more"] 		 = {{0,30},2.7,  {60, 90},0.3,0.5,0},
		}
		self.freeSpinConfig = config 
	end
	local addLizi = function (node) -- 添加粒子特效 和 spine 动画的入口
		if sType == fs_show_type.start or fs_show_type.more then
			local spineFile1  = self:getPic("spine/freespin/zhousi_02")		-- 背景
			local _, s1 	  = Theme:addSpineAnimation(node:getChildByName("spine_node"), 1, spineFile1, cc.p(0,0), "animation", nil, nil, nil, true, true)

			local spineFile2  = self:getPic("spine/freespin/zhousi_03") 	-- 宙斯
			local _, s2 	  = Theme:addSpineAnimation(node:getChildByName("spine_node"), 1, spineFile2, cc.p(0,0), "animation1", nil, nil, nil, true, true)

			self:laterCallBack(160/60,function ()
				if self.ctl.isDealFSBegEnd then return end
				bole.spChangeAnimation(s2,"animation2",true)
			end) 	
		-- elseif sType == fs_show_type.more then
		 	-- local spineFile1  = self:getPic("spine/freespin/FG_limian")	-- 扫光
			-- local _, s1 	  = Theme:addSpineAnimation(node:getChildByName("spine"), 1, spineFile1, cc.p(0,0), "animation", nil, nil, nil, true, true)
		end
	end
	local theDialog = G_FREE_SPIN_DIALOGS["base"].new(self.ctl, self.freeSpinConfig)
	if sType == fs_show_type.start then
		theDialog:showStart(theData)
		-- self:stopMusic(self.audio_list.retrigger_bell, true)
		addLizi(theDialog.baseRoot)
	elseif sType == fs_show_type.more then
		theDialog:showMore(theData)
		-- self:stopMusic(self.audio_list.retrigger_bell, true)
		addLizi(theDialog.baseRoot)
	-- elseif sType == fs_show_type.collect then
	-- 	theDialog:showCollect(theData)
	-- 	addLizi(theDialog.root)
	end
end

function cls:playStartFreeSpinDialog( theData )
	self:showFreeSpinDialog(theData, fs_show_type.start)
end

function cls:playMoreFreeSpinDialog( theData )
	
	self:showFreeSpinDialog(theData, fs_show_type.more)
end

function cls:playCollectFreeSpinDialog( theData )
	if theData.enter_event then
		theData.enter_event()
	end

	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(1), -- 延迟时间 
		cc.CallFunc:create(function ( ... )
			-- 播放转场声音
			self:playMusic(self.audio_list.transition)
			-- 转场动画
			self:playTransition(transitionType.free) -- 转场动画 播放完成之后进行 庆祝
			if theData.click_event then
				theData.click_event() -- 进行场景切换
			end
		end),
		cc.DelayTime:create(11/30), -- 转场动画 覆盖全屏的时间
		cc.CallFunc:create(function ()
			if theData.changeLayer_event then
				theData.changeLayer_event() -- 进行场景切换
			end
		end),
		cc.DelayTime:create(5/30),
		cc.CallFunc:create(function ()
			if theData.end_event then
				theData.end_event() -- 进行场景切换
			end
		end)
	))
end

function cls:playTransition(type,endFunc)
	
	-- if self.node_Transition then return end
	-- self.node_Transition = cc.Node:create()
	-- self.curScene:addToContentFooter(self.node_Transition)

	self:showTransitionAnimation(type,endFunc)

	self:laterCallBack(1,function ( ... )
		-- if self.node_Transition then
	 --   	    self.node_Transition:removeFromParent()
	 --   	    self.node_Transition = nil
	 --   	    self.transitionSkeleton=nil
	 --   	end
	 	if self.transitionSkeleton then
	   	    -- self.node_Transition:removeFromParent()
	   	    -- self.node_Transition = nil
	   	    self.transitionSkeleton=nil
	   	end
	end)
end

function cls:showTransitionAnimation(type,endFunc)
	if self.transitionSkeleton == nil then
	    -- local _, s2 =Theme:addSpineAnimation(self.node_Transition,nil, self:getPic("spine/special/transition/"..type[1].."/spine"),type[3],type[2],endFunc,nil,nil,true)
	    local _, s2 =Theme:addSpineAnimation(self.tipSpine,nil, self:getPic("spine/special/transition/"..type[1].."/spine"),type[3],type[2],endFunc,nil,nil,true)
	    self.transitionSkeleton = s
	end
end

function cls:playBackBaseGameSpecialAnimation( theSpecials ,enterType)
	self:playFreeSpinItemAnimation(theSpecials ,enterType)
end

function cls:playFreeSpinItemAnimation( theSpecials ,enterType)
	local delay = 3
	if not theSpecials[specialSymbol["triger"]] then return end
	if enterType then
		self:playMusic(self.audio_list.retrigger_bell, false)
		self:laterCallBack(1,function ( ... )
			for col, rowTagList in pairs(theSpecials[specialSymbol["triger"]]) do
				for row, tagValue in pairs(rowTagList) do
					self:addItemSpine(specialSymbol["triger"], col, row,true)
					-- self:playScatterEffect() -- 目前没有声音
				end
			end

		end)
	else
		for col, rowTagList in pairs(theSpecials[specialSymbol["triger"]]) do
			for row, tagValue in pairs(rowTagList) do
				self:addItemSpine(specialSymbol["triger"], col, row,true)
			end
		end
	end

	return delay
end

function cls:addZeusSpine(item, col, row,isFirst)
	if self.showReSpinBoard then 
		return
	end
	if self.zeus_cnt and self.zeus_cnt[col] then
		local cellHeight = self.spinLayer.spins[col].cellHeight

		if isFirst then
			for k,v in pairs(self.zeus_cnt[col]) do 
				local pos			= self:getCellPos(col, k)
				local spineFile     = ""
				local animateName 	= ""
				if v>1 then 
					-- pos.y 				= pos.y - (cellHeight/2)*(v-1)
					spineFile           = self:getPic("spine/item/2_big/spine")
					animateName = "animation1_"..v
					local _, s1 = self:addSpineAnimation(self.animateNode, 10, spineFile, pos, animateName.."1",nil,nil,nil,true)

					self.animNodeList = self.animNodeList or {}
					for i=k,k+v-1 do 
						self:laterCallBack(10/30,function ( ... )
							local cell = self.spinLayer.spins[col]:getRetCell(i)
							cell:setVisible(false)
						end)

						if not self.animNodeList[col.."_"..i] then 
							self.animNodeList[col.."_"..i] = {s1,animateName.."2",k}
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
					spineFile           = self:getPic("spine/item/2/spine")
					animateName 	= "animation"
					local _, s2 = self:addSpineAnimation(self.animateNode, 10, spineFile, pos, animateName,nil,nil,nil,true)
					self:playAllSAnimation(s2,col,k,animateName,isFirst)
				elseif v>1 then 
					self:playAllSAnimation(nil,col,row,animateName,isFirst,k)
				end
			end
			self.zeus_cnt[col] = nil -- 防止多次进入
		end
	end
end

function cls:addItemSpine(item, col, row,isLoop)

	local layer			= self.animateNode
	local animateName	= "animation"
	local pos			= self:getCellPos(col, row)
	local spineFile		= self:getPic("spine/item/"..item.."/spine")

	local cell = self.spinLayer.spins[col]:getRetCell(row)
	cell:setVisible(false)
	if isLoop then  -- freespin
		local _, s1 = self:addSpineAnimation(self.animateNode, 50, spineFile, pos, animateName, nil, nil, nil, true,true)--true
	else
		local _, s1 = self:addSpineAnimation(self.animateNode, nil, spineFile, pos, animateName, nil, nil, nil, true)--true
		self:playAllSAnimation(s1,col,row,animateName)
	end
end

function cls:playSAnimation(item, col, row,isLoop) -- 没有 spine 动画 的symbol 

	local layer			= self.animateNode
	local pos			= self:getCellPos(col, row)

	local actionCellNode = cc.Node:create()
	layer:addChild(actionCellNode)
	actionCellNode:setPosition(pos)

	local theCellSprite = bole.createSpriteWithFile(self.pics[item])
	actionCellNode:addChild(theCellSprite)

	local cell = self.spinLayer.spins[col]:getRetCell(row)
	cell:setVisible(false)

	self:playAllSAnimation(actionCellNode,col,row)

end

-- local moveY = 13
-- local moveX = 25
local moveScale = 1.05

function cls:getAllSAnimMovePos(col,row)
	local _cellH = self.spinLayer.spins[col].cellHeight -- 当且列的 cellHeight
	local _cellW = self.spinLayer.spins[col].cellWidth -- 当且列的 cellWidth
	local _cellS = self.spinLayer.spins[col].row -- 当前列的cell 个数
	local _w = _cellW * (moveScale - 1)
	local _h = _cellH * (moveScale - 1)

	local moveX = (col-((#self.spinLayer.spins +1)/2)) * _w
	local moveY = (1-row) * _h
	return cc.p(moveX,moveY)
end

function cls:playAllSAnimation(node,col,row,animationName,isFirst,baseRow)
	self.animNodeList = self.animNodeList or {}
	if self.animNodeList[col.."_"..row] then 
		node = self.animNodeList[col.."_"..row][1]
		animationName = self.animNodeList[col.."_"..row][2]
		baseRow = self.animNodeList[col.."_"..row][3]
	else 
		self.animNodeList[col.."_"..row] = {}
		self.animNodeList[col.."_"..row][1] = node 
		self.animNodeList[col.."_"..row][2] = animationName
		if baseRow then 
			self.animNodeList[col.."_"..row][3]=baseRow
		end
	end
	if not node then 
		return end
	if node.hasAnimate then return end	

	local fs = 30-- 60
	local pos = cc.p(node:getPosition())
	local baseZOrder = node:getLocalZOrder()
	node.hasAnimate = true

	local addPos = nil
	if baseRow then 
		addPos = self:getAllSAnimMovePos(col,baseRow)
	else
		addPos = self:getAllSAnimMovePos(col,row)
	end

	local animate = cc.Sequence:create(	
		cc.DelayTime:create(2/fs),
		-- cc.MoveTo:create(15/fs,cc.p(pos.x-moveX,pos.y-moveY)),
		cc.Spawn:create(cc.ScaleTo:create(18/fs,moveScale),cc.MoveTo:create(18/fs,cc.pAdd(pos,addPos))),
		cc.DelayTime:create(6/fs),		
		-- cc.MoveTo:create(10/fs,pos),
		cc.Spawn:create(cc.ScaleTo:create(18/fs,1),cc.MoveTo:create(18/fs,pos)),
		cc.CallFunc:create(function ()
			node.hasAnimate = false
			node:setLocalZOrder(baseZOrder)
		end),
		cc.DelayTime:create(2/fs)
		)


	if not isFirst and animationName then 
		bole.spChangeAnimation(node,animationName,false)
	end
	node:setLocalZOrder(20)
	node:runAction(animate)
	
end

-- local hasAnimate = Set{"w"}
function cls:getItemAnimate(item, col, row, effectStatus)
	if col > 5 then return end

	
	local spineItemsSet = Set({1,2,11})
	local animationItem = Set({3,4,5,6,7,8,9,10,12,20,21,22,23,24})
	if effectStatus=="all_first" then 
		if item == specialSymbol["zeus"] then 
			self:addZeusSpine(item, col, row )
		elseif spineItemsSet[item] then
			self:addItemSpine(item, col, row)
		end
	
		if animationItem[item] then 
			return self:playSAnimation(item,col,row,true)
		end	
		return nil
	else
		self:playAllSAnimation(nil,col,row,nil,false)
	end  
end

function cls:addFirstZeusSpine( )
	for k=1,5 do
		self:addZeusSpine(2, k, row,true)
	end
end

function cls:drawLinesThemeAnimate( lines, layer, rets, specials)
	-- 先播放合图出现的动画
	self:addFirstZeusSpine()

	self.animNodeList = self.animNodeList or {}
	local delay = bole.getTableCount(self.animNodeList)>0 and 1 or 0.2
	if delay>0.2 then 
		-- 播放宙斯中奖合图的音效
		self:playMusic(self.audio_list.symbol_zeus)
	end
	self:laterCallBack(delay,function ( )
		local timeList = {2,2}
		Theme.drawLinesThemeAnimate(self, lines, layer, rets, specials,timeList)
	end)	
	return delay 
end

function cls:stopDrawAnimate()
	self.animNodeList = nil
	Theme.stopDrawAnimate(self)
end

function cls:checkNeedNotify(pCol)
	if self.haveFirstBonus or self.showReSpinBoard then -- self.showFreeSpinBoard or  whj 修改
		return false
	end
	return Theme.checkNeedNotify(self, pCol)
end


function cls:syncJackpotData(data,endFunc)
	doNext = function ()
		if #self.haveJackpotList ~= 0 then
			local jpItem = table.remove(self.haveJackpotList, 1)
			self.bonus:showJackPotMiniGame(jpItem,doNext)
		else
			if endFunc then 
				endFunc()
			end
		end
	end
	doNext()
end

function cls:onExit()
	if self.moveClodsScheduler then 
		local scheduler = cc.Director:getInstance():getScheduler()
		scheduler:unscheduleScriptEntry(self.moveClodsScheduler)
		self.moveClodsScheduler = nil
	end
	if self.bonus then
		self.bonus:onExit()
	end
	Theme.onExit(self)
end

---------------------------------- 声音相关 ---------------------------------------------

function cls:configAudioList( )
	Theme.configAudioList(self)

	self.audio_list = self.audio_list or {}
	-- base
	self.audio_list.reel_notify			= "audio/base/reel_speedup.mp3"
	self.audio_list.anticipation 	 	= "audio/base/symbol_scatter.mp3" -- scatter 特殊下砸声音
	self.audio_list.symbol_zeus         = "audio/base/symbol_zeus.mp3"    -- 中间合图声音
	self.audio_list.transition          = "audio/base/change.mp3"
	-- free
	self.audio_list.retrigger_bell	 	= "audio/free/fg_ling1.mp3"
	self.audio_list.free_dialog_start_show 		= "audio/free/frame_out.mp3" -- dialog 弹板 出现 和收回的音效
	self.audio_list.free_dialog_start_close 	= "audio/free/frame_back.mp3"
	self.audio_list.free_dialog_more_show 		= "audio/free/frame_out.mp3"
	self.audio_list.free_dialog_more_close  	= "audio/free/frame_back.mp3"
	self.audio_list.free_dialog_bgm             = "audio/free/frame_bgm.mp3"
	-- bonus
	self.audio_list.bonus_dian1_1             	= "audio/bonus/electricity1_1.mp3"
	self.audio_list.bonus_dian4_4             	= "audio/bonus/electricity4_4.mp3"
	self.audio_list.bonus_wheel_bgm		  		= "audio/bonus/wheel_bgm.mp3"
	self.audio_list.bonus_wheel_close		  	= "audio/bonus/wheel_back.mp3"
	self.audio_list.bonus_wheel_show1 		  	= "audio/bonus/wheel_out1.mp3"
	self.audio_list.bonus_wheel_show2 		  	= "audio/bonus/wheel_out2.mp3"
	self.audio_list.bonus_wheel_stop  		  	= "audio/bonus/wheel_stop.mp3"
	self.audio_list.bonus_wheel_digital			= "audio/bonus/wheel_digital.mp3" -- jackpot 飞到嵌入symbol 中的声音
	self.audio_list.bonus_wheel_spinzhuanlun	= "audio/bonus/wheel_spinzhuanlun.mp3" -- jackpot 滚轴转动的声音
	self.audio_list.bonus_wheel_spindianliu		= "audio/bonus/wheel_spindianliu.mp3" -- 选中电流 完全显示出来之后 循环播放的声音
	self.audio_list.bonus_nudge					= "audio/bonus/nudge.mp3"
	self.audio_list.bonus_hint					= "audio/bonus/hint.mp3"  		-- bonus 第一列 合成时候的声音
	self.audio_list.bonus_symbol_2				= "audio/bonus/bonus_symbolzeus.mp3" -- bonus Zeus 停下来的声音 
	self.audio_list.bonus_symbol_12				= "audio/bonus/bonus_symboljackpot1.mp3" -- bonus jackpot 停下来的声音
	self.audio_list.bonus_symbol_dian			= "audio/bonus/bonus_symboljackpot2.mp3"-- bonus 闪电劈 symbol 的声音
	self.audio_list.bonus_jackpot_win			= "audio/bonus/jackpot_win.mp3"

end

function cls:playScatterEffect()
	-- self:playMusic(self.audio_list.symbol_scatter,true,true)
end

function cls:stopScatterEffect( )
	-- self:stopMusic(self.audio_list.symbol_scatter)
end		

-- 滚轮音效相关
function cls:dealMusic_PlayReelNotifyMusic( pCol ) -- 最后一列激励音效

	if self.playR1Col == nil then
		-- self:playMusic(self.audio_list.reel_notify, true, true)
		-- 添加 显示黑色蒙版的逻辑
		self.black_BG:setVisible(true)

	 	if not self.changeOpacity then 
	 		self.changeOpacity = true
		 	for k=1,5 do 
				for k,v in pairs(self.spinLayer.spins[k].cells) do 
					if v.key~=specialSymbol["triger"] then
						v.sprite:setColor(cc.c3b(94,94,94))
					end
				end
		 	end
		end
	end
	self:playMusic(self.audio_list.reel_notify,true)
	self.playR1Col = pCol
end
function cls:dealMusic_StopReelNotifyMusic( pCol )
	if not self.playR1Col then return end
	
	self:stopMusic(self.audio_list.reel_notify,true)
	if self.playR1Col == pCol and pCol < #self.spinLayer.spins and self:checkNeedNotify(pCol+1) then
		return
	end
	self.playR1Col = nil
	-- self:stopMusic(self.audio_list.reel_notify)
	-- 添加 关闭黑色蒙版的逻辑
	self.black_BG:setVisible(false)


 	if self.changeOpacity then 
 		self.changeOpacity = false
	 	for k=1,5 do 
			for k,v in pairs(self.spinLayer.spins[k].cells) do 
				v.sprite:setColor(cc.c3b(255,255,255))
			end
	 	end
	end
end

function cls:dealMusic_PlaySpecialSymbolStopMusic( pCol )

	local basepCol = pCol
	local pCol = 1 + (pCol-1)%5
	if not self.notifyState or not self.notifyState[pCol] then
		return
	end
	self.hintMusicCnt = self.hintMusicCnt + 1
	local ColNotifyState = self.notifyState[pCol]
	
	if self.showReSpinBoard then  --respinLockKey
		local key = nil
		local playStopEffect = false
		if ColNotifyState[specialSymbol["jackpot"]] then 
			key = specialSymbol["jackpot"]
			
		elseif ColNotifyState[specialSymbol["zeus"]] then 
		 	key = specialSymbol["zeus"]
		end
		if key then 
			self:playMusic(self.audio_list["bonus_symbol_" .. key])
			self.notifyState[pCol] = {}
			playStopEffect = true
		end

		if not playStopEffect then 
			self:dealMusic_PlayReelStopMusic(pCol)
		end
	elseif ColNotifyState[specialSymbol["triger"]] then 
		self:playMusic(self.audio_list.anticipation)
		self:playSymbolNotifyEffect(pCol, true)
		self.notifyState[pCol] = {}
	end
end

-- retrigger
function cls:dealMusic_PlayFSMoreMusic( )
	self:playMusic(self.audio_list.free_dialog_more_show)
end

function cls:dealMusic_PlayFSEnterMusic( ) -- 进入freespin 弹窗显示的音效
	self:playMusic(self.audio_list.free_dialog_start_show)
end

function cls:getLoadMusicList()
	local loadMuscList = 
	{
		self.audio_list.reel_notify,
		self.audio_list.anticipation,
		self.audio_list.transition,
		self.audio_list.free_dialog_bgm,
		self.audio_list.bonus_wheel_bgm,
		self.audio_list.bonus_wheel_spinzhuanlun,
		self.audio_list.bonus_wheel_spindianliu,
		self.audio_list.bonus_wheel_digital,
		self.audio_list.bonus_hint,
		self.audio_list.bonus_dian1_1,
		self.audio_list.bonus_dian4_4
	}
	return loadMuscList
end
--------------------------------- LockRespin && Bonus ---------------------------------

ChiefOfTheGodsBonus = class("ChiefOfTheGodsBonus")

-- zeus-mini-minor-mega-major
local miniGameReel = {2,4,3,2,4,0,3,4,1,2,3,1,4,3,4}

function ChiefOfTheGodsBonus:ctor(bonusControl, theme, csbPath, data, callback)
	self.bonusControl 	= bonusControl
	self.theme 			= theme
	self.csbPath 		= csbPath
	self.callback 	    = callback
	self.endCallBack    = callback
	-- self.csb 		    = csbPath..".csb"
	self.data           = data
	self.theme.bonus 	= self 
	self.ctl 			= bonusControl.themeCtl
	-- self.data.core_data = nil
	-- CCSNode.ctor(self, self.csb)

	self:saveBonus()
end

function ChiefOfTheGodsBonus:addData(key,value)
	self.data[key] = value
	self:saveBonus()
end
function ChiefOfTheGodsBonus:saveBonus()
	LoginControl:getInstance():saveBonus(self.theme.themeid, self.data)
end

function ChiefOfTheGodsBonus:enterBonusGame(tryResume)
	self.theme:changeSpinBoard(SpinBoardType.ReSpin) 
	self.ctl.footer.isRespinLayer = true
	-- self.ctl.footer.spinNode:changeBtnState("ingore", false, false)

	-- 更改棋盘
	self.theme:showBonusNode()
	-- 锁住jackpot meter
	self.theme:lockJackpotMeters(true)
	-- 获取jackpot
	self.progressive_list = self.theme:getJackpotValue(self.data.core_data["progressive_list"])

	-- 设置jackpot label值
	local jpLabels = self.theme.jackpotLabels
	for i=1, #self.progressive_list do
		if jpLabels[i] then
			jpLabels[i]:setString(self.theme:formatJackpotMeter(self.progressive_list[i]))
		end
	end

	-- 加钱操作
	self.respinWin 	= 0
	self.jpwin = 0

	if self.ctl.rets.jp_win then
		for k,v in pairs(self.ctl.rets.jp_win) do 
			if v and v.jp_win then
				self.jpwin = self.jpwin +v.jp_win
			end
		end
	end


	local function playIntro() -- 第一次进入
		self:addData("have_respin_index", 0)
		self.respinSum	 	= 3
		self:addData("respin_total", 3)

		self.ctl.rets["theme_respin"] 		= tool.tableClone(self.data.core_data["theme_respin"])
    	self.ctl.rets["progressive_list"] 	= tool.tableClone(self.data.core_data["progressive_list"])
    	self.ctl.rets["win_lines"]			= tool.tableClone(self.data.core_data["win_lines"])
    	self.ctl.rets["win_pos_list"]		= tool.tableClone(self.data.core_data["win_pos_list"])

    	self.ctl.spinning = false -- 
    	-- 播放背景音效
		self.theme:dealMusic_EnterBonusGame()
		self.theme.enterRespinFirst = true
		self.ctl:handleResult()
	end

	local function snapIntro() -- 重连进入
		-- 断线重连的 回调方法
		-- 暂时的方式
		local function startSpin()
			-- 通过判断来进行操作是继续respin 还是进行收集操作
			if #self.ctl.rets.theme_respin >0 then 
				self.theme:theme_respin(self.ctl.rets)
			else -- 是否有小游戏的相关逻辑在 主题里面自行判断
				self.theme.respinStep = 4 -- ReSpinStep.Over 

				self:onRespinStop(self.ctl.rets)
				self.ctl:handleResult()
			end
		end

		self.ctl.rets["win_lines"]			= tool.tableClone(self.data.core_data["win_lines"])
    	self.ctl.rets["win_pos_list"]		= tool.tableClone(self.data.core_data["win_pos_list"])
    	
		local endCallFunc = function ()
			self.ctl.rets["jackpot_sync_data"] = nil
        	startSpin()
        end

        self.callback = function ( ... )
        	local endCallFunc2 = function ( ... )
        		self.ctl.rets.setWinCoins = nil
        		self.ctl.isProcessing = true -- whj 1.2 添加控制之后 锁住 isProcessing 控制不能进行 spin
				if (self.ctl.enterThemeDealList and bole.getTableCount(self.ctl.enterThemeDealList)>0) then -- whj 1.2 添加控制之后还有feature的时候控制 按钮不可以点击
	   				self.ctl.footer:setSpinButtonState(true)
	   			end
        		if self.endCallBack then 
        			self.endCallBack()
        		end
        		self.ctl.isProcessing = false -- whj 1.3 添加控制之后 解除 isProcessing 
        	end
        	if self.ctl.rets["win_pos_list"] then
	        	self.ctl:drawAnimate(self.ctl.rets)
	        	self.ctl:startRollup(self.ctl.rets["total_win"],endCallFunc2)
	        else
	        	endCallFunc2()
	        end
        end

		local _jackpotCnt = self.jackpotIndex
		local _overJackpotList = tool.tableClone(self.over_jackpotList)
		local JackpotList= {}
		
		local haveJpWin = 0
		if self.theme.haveJackpotList then 
			while _jackpotCnt>0 do 
				_jackpotCnt = _jackpotCnt - 1
				if #_overJackpotList > 0 then 
					JackpotList = table.remove(_overJackpotList)
					for k,v in pairs(self.theme.haveJackpotList) do 
						if JackpotList[1]== v[2] then 
							self.theme.overJackpotValue = self.theme.overJackpotValue or {}
							self.theme.overJackpotValue[JackpotList[1]] = JackpotList[2]
							table.remove(self.theme.haveJackpotList,k)
							break
						end
					end
				else
					break
				end
			end
			-- 重新添加symbol 的值
			
			if self.theme.overJackpotValue then
				-- 向symbol 上面添加中奖的显示图片
				for k,v in pairs(self.theme.overJackpotValue) do 
					haveJpWin = haveJpWin + v.jp_win
					self.theme:laterCallBack(0.45,function ( ... )
						local jackpotCell = self.theme.HoldLayer._added[k]
						jackpotCell:setVisible(true)
						bole.updateSpriteWithFile(jackpotCell, self.theme.pics[20+v.jp_win_type])
					end)
				end
			end

			if #self.theme.haveJackpotList >0 then 
				self.theme:syncJackpotData(true,endCallFunc)
			else 
				self.theme:laterCallBack(0.5,endCallFunc)
			end
		else 
			self.theme:laterCallBack(0.5,endCallFunc)
		end
		
    	
		
		self.respinSum	 	= self.data["respin_total"] or 3
		-- 断线重连回来默认显示 最大的声音
		self.theme:dealMusic_EnterBonusGame()
		self.ctl.totalWin = (self.ctl.totalWin or 0)  + self.respinBaseWin+haveJpWin
		if self.ctl.freewin then 
			self.ctl.freewin = (self.ctl.freewin or 0) + haveJpWin
		end
		self.ctl.footer:setWinCoins(self.ctl.totalWin, 0, 0)

	end

	local respinIndex = self.data["have_respin_index"]
	self.respinTimes 	= respinIndex or 0--self.ctl.rets["theme_respin_count"] -- H -> 3
	if respinIndex and respinIndex>0 then
		for i=1,respinIndex do
			if #self.ctl.rets.theme_respin <= 0 then
				break
			end
			self.ctl.rets.item_list = table.remove(self.ctl.rets.theme_respin,1)
		end 
	end

	self:fixData(self.ctl.rets,tryResume)
	
	self.theme.JHint = {}
	self.theme.hintMusicCnt = 0

	self.dontR0 = true
	for k,reel in pairs(self.theme.spinLayer.spins) do
		local key = self.theme.recvItemList[k][1]
		local cell = reel:currentCell()
		self.theme:updateCellSprite(cell, key, k, 1)
	end
	-- -- jackpot 显示 list
	self.jackpotIndex = self.data["over_jackpot"] or 0 
	self.over_jackpotList = self.data["over_jackpotList"] or {}

	-- 音效播放标志位 
	self.theme.reelStopMusicTagList = self.theme.reelStopMusicTagList or {}
	-- spin 结果数据和 显示stop 按钮有关
	self.ctl.cacheSpinRet				= self.ctl.cacheSpinRet or self.ctl.rets
	
	if  respinIndex or tryResume then 
		for i= 1,respinCellCount do
			self.theme:onReelStop(i)
		end
	else
		for i= 1,respinCellCount do -- 只需要 lock 第一列
			if firstReelId[i] then 
				self.theme:onReelStop(i)
			end
		end
		
	end
	
	self.respinBaseWin = self.ctl.rets["base_win"] or 0
	self.ctl.rets["total_win"] = self.ctl.rets["total_win"] -- + self.jpwin
	self.ctl.rets["base_win"] = self.ctl.rets["total_win"]
	if self.ctl.rets["total_win"] > 0 then
		self.ctl.rets["setWinCoins"] = 1
	end

	if not self.theme.bigZeusSpine then 
		-- 进行宙斯 大图动画播放
		local reelCellHeight = self.theme.spinLayer.spins[1].cellHeight
		local pos = self.theme.spinLayer:getCellPos(1,1)-- cc.pAdd(self.theme.spinLayer:getCellPos(1,2),cc.p(0,-reelCellHeight/2))
		local _,s = self.theme:addSpineAnimation(self.theme.HoldLayer, 200, self.theme:getPic("spine/item/2_big/spine"), pos, "animation1_42",nil,nil,nil,true,true)
		self.theme.bigZeusSpine = s
		self.theme:playMusic(self.theme.audio_list.bonus_hint)
	end	

	self.theme:dealMusic_EnterBonusGame()
    if  respinIndex or tryResume then 
    	snapIntro()
    else
		playIntro()
    end
end

function ChiefOfTheGodsBonus:fixData(ret,tryResume) -- 在这个时候 进行 数据重置 第一个 进入 respin 牌面数据
	self.ctl.resultCache = {}	-- ret["reelItem_list"] = {} -- 添加

	local itemsList = table.copy(ret.item_list)
	local haveRespinIndex = self.data["have_respin_index"] or 0 

	for i=0,respinCellCount-1 do -- 横向拆分 和 棋盘一致
		if haveRespinIndex>0 then 
			ret.item_list[1+i] = {itemsList[1+(i%5)][1+math.floor(i/5)]}
		else
			if firstReelId[i+1] then
				ret.item_list[1+i] = {specialSymbol["zeus"]}
			elseif tryResume then 
				ret.item_list[1+i] = {specialSymbol.kong}
			else
				ret.item_list[1+i] = {respinSet[math.random(1,2)]}
			end
		end
		-- 在每一轴 拼接结果数据
		self.ctl.resultCache[1+i] = {respinSet[math.random(1,3)],itemsList[1+(i%5)][1+math.floor(i/5)]} --向上插入一个值 {math.random(1,10) , itemsList[1+(i%5)][1+math.floor(i/5)]}-- ret["reelItem_list"][1+i] = {math.random(1,10) , itemsList[1+(i%5)][1+math.floor(i/5)]}
		local col = 1+ (i-1)%5
		local symbols = self.ctl.currentReels[col] -- 获得 1-5 轴的 滚轴数据
		local key = math.random(1,#symbols) -- self.ctl.currentReelsIndex[1+i]%#symbols + 1
		-- local nextIndex = self.ctl.currentReelsIndex[col]
		for k = 1,6 do -- 向下插入 六个 值
			key = 1 + (key + k - 1)%#symbols
			table.insert(self.ctl.resultCache[1+i],symbols[key])
		end
	end
	self.theme.recvItemList = ret.item_list
end

function ChiefOfTheGodsBonus:setRespinLabel( cur,sum )
	local string = cur .. "       " .. sum
	if string.len(string)==10 then 
		self.theme.respinCntLabel:setScale(0.88)
	elseif string.len(string)==11 then
		self.theme.respinCntLabel:setScale(0.75)
	else
		self.theme.respinCntLabel:setScale(1)
	end
	self.theme.respinCntLabel:setString(string)
end

function ChiefOfTheGodsBonus:freshRespinNum(cur,sum)
	if cur <= 0 then
		self.theme.respinCntNode:runAction(cc.FadeTo:create(1,0))
		self.theme.respinCntNode:setVisible(false)
		self.respinSum = nil
		if self.respinCntSpine then 
			self.respinCntSpine:removeFromParent()
			self.respinCntSpine = nil
		end
	else
		if not self.respinCntSpine then 
			local _,s1 = self.theme:addSpineAnimation(self.theme.respinCntNode:getChildByName("spine_Node"), 2, self.theme:getPic("spine/special/respin/spine"), cc.p(0,0), "animation", nil, nil, nil, true, true)
			self.respinCntSpine = s1
			self.theme.respinCntNode:setOpacity(0)
			self.theme.respinCntNode:setVisible(true)
			self.theme.respinCntNode:runAction(cc.FadeTo:create(1,255))
		end
		self:setRespinLabel(cur,sum or self.respinSum)
	end
end


function ChiefOfTheGodsBonus:freshRespinTotalNum()
	self.respinSum = self.respinSum + 1
	self:freshRespinNum(self.respinTimes,self.respinSum)

	-- 同时更新保存 spin 次数和 总次数
	self:freshRespinCnt()
end
function ChiefOfTheGodsBonus:onRespinStart( )

	self.theme.respinStep = ReSpinStep.Playing  -- 用来更改 不在 Start 状态
	self.respinTimes = self.respinTimes + 1

	self:freshRespinNum(self.respinTimes,self.respinSum) -- 更新计数

end

function ChiefOfTheGodsBonus:freshRespinCnt()
	self:addData("respin_total", self.respinSum)
	self:addData("have_respin_index", self.respinTimes)
end

function ChiefOfTheGodsBonus:onRespinStop(ret)
	if self.theme.respinStep == ReSpinStep.Over then
		--respin 收集
		-- self.ctl.footer:setSpinButtonState(false) -- 解除禁用 spin 按钮

		self.theme.lockedReels = nil
		
		self:freshRespinNum(-1)
		self.theme:laterCallBack(1, function()
			-- if not self.theme.showFreeSpinBoard then
			-- 	self.ctl.footer.isFreeSpin = true
			-- 	self.theme.saveWin = true
			-- end

			local collectFunc = function ()

				self.ctl.footer.isRespinLayer = false
				
				if self.theme.showFreeSpinBoard or ret["free_spins"] then
					self.ctl.footer:changeLabelDescription("FS_Win")
				else
					-- 直接收集钱的操作 给用户加钱 播放动画 主要原因是因为 self.saveWin 设置的原因
					self.ctl.footer.isFreeSpin = false
					self.ctl.footer:changeLabelDescription("notFS_Win")
					self.saveWin = false
					-- 不是 在 freespin 里面进入 lockrespin 的时候 清掉 对bet的 限制
					self.ctl:removePointBet()
				end
				-- 在此之后断电重连就不用恢复了
				self.data["end_game"] = true
				self:saveBonus()
				-- 服务器 收钱
				self.theme.ctl:collectCoins(1)

				local respinOver = function ()
					self.jpwin = 0
					if self.theme and self.theme.HoldLayer then self.theme.HoldLayer:removeAllChildren() end
					self.theme.bigZeusSpine = nil

					if self.theme.showFreeSpinBoard then
						self.theme:changeSpinBoard(SpinBoardType.FreeSpin) 
						-- 切换滚轴回 free
						self.theme:hideBonusNode(true,false)
					else
						self.theme:changeSpinBoard(SpinBoardType.Normal) 
						-- 切换滚轴回 base 
						self.theme:hideBonusNode(false,false)
					end

					local _itemList = table.copy(self.theme.recvItemList)
					self.theme.recvItemList = {}
					for col=1, 5 do -- for col=1, 5 do
						self.theme.recvItemList[col] = {}
						-- 设置上下的symbol 均为 0 symbol
						local up = self.theme.spinLayer.spins[col]:getRetCell(0)
						self.theme:updateCellSprite(up, 0, col, 0)
						local down = self.theme.spinLayer.spins[col]:getRetCell(5)
						self.theme:updateCellSprite(down, 0, col, 5)

						for row=1,4 do
							local cell 	= self.theme.spinLayer.spins[col]:getRetCell(row)
							col2 = (row-1)*5+col
							local key 	= _itemList[col2][1]
							-- 获得jackpot 的值
							if self.theme.overJackpotValue and self.theme.overJackpotValue[col2] then 
								key = 20+self.theme.overJackpotValue[col2].jp_win_type --cell.jackpotKey = self.theme.overJackpotValue[col2]
							end
							self.theme.recvItemList[col][row] = key
							self.theme:updateCellSprite(cell, key, col, row)
						end
					end 


					-- 解锁jackpot meter
					self.theme:lockJackpotMeters(false)

					self.theme:showAllItem()

					if self.theme.showFreeSpinBoard then
						self.theme:dealMusic_PlayFreeSpinLoopMusic()
					else
						self.theme:dealMusic_PlayNormalLoopMusic()
					end
					self.theme:dealMusic_MuteLoopMusic()

					-- 重置当前中奖连线中奖数据
					self.ctl:resetWinListFromRespin(self.ctl.rets)
					self.ctl.rets.item_list = tool.tableClone(self.theme.recvItemList)
					self.theme:getZeusCnt(self.ctl.rets)

					-- 激活spin按钮
					self.ctl:onRespinOver()
					self.ctl.rets["theme_respin"] = nil
					self.theme.overJackpotValue = nil

					self.callback()
					
				end
				respinOver()
			end

			collectFunc()
		end)
	end
end

function ChiefOfTheGodsBonus:showJackPotMiniGame(jackpot_list, doNext)

	local jackpotCellPos = self.theme:getCellPos(jackpot_list[2],1)
	local jackpotMiniGameNode = cc.Node:create()
	jackpotMiniGameNode:setPosition(cc.p(-640,-360))
	bole.scene:addToTop(jackpotMiniGameNode)
	-- symbol 上面劈闪电
	local _, tanban   = Theme:addSpineAnimation(jackpotMiniGameNode, 2, self.theme:getPic("spine/special/jackpot/symbol_jackpot_2"), jackpotCellPos, "animation4", nil, nil, nil, true, true)
	local _, dian 	  = Theme:addSpineAnimation(jackpotMiniGameNode, 1, self.theme:getPic("spine/special/jackpot/symbol_jackpot_1"), jackpotCellPos, "animation1", nil, nil, nil, true)
	self.theme:playMusic(self.theme.audio_list.bonus_symbol_dian)

	self.theme:laterCallBack(28/30,function ( ... )
		bole.spChangeAnimation(dian,"animation2",true)	
	end)

	-- 添加蒙版
	local mask = cc.Sprite:create("commonpics/common_black.png")
	mask:setOpacity(0)
	mask:setLocalZOrder(1)
	mask:setPosition(cc.p(640,360))
	mask:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.FadeTo:create(1, 200)))

	mask:setScale(30)
	jackpotMiniGameNode:addChild(mask)

	--	添加 miniGame
	local miniGame   = cc.CSLoader:createNode(self.theme:getPic("csb/jackpot_miniGame.csb"))
	local rootNode   = miniGame:getChildByName("root")
	local startLayer = rootNode:getChildByName("startLayer")
	local spineNode  = rootNode:getChildByName("node_spine")
	local playLine = function (startFrame, endFrame)
		local action = cc.CSLoader:createTimeline(self.theme:getPic("csb/jackpot_miniGame.csb"))
		miniGame:runAction(action)
		action:gotoFrameAndPlay(startFrame, endFrame, false)
	end
	jackpotMiniGameNode:addChild(miniGame,2)
	miniGame:setPosition(cc.p(640,360))
	miniGame:setVisible(false)

	-- 添加 miniGame 上面的选中提示动画
	local _, tishi   = Theme:addSpineAnimation(spineNode, 2, self.theme:getPic("spine/special/jackpot/symbol_jackpot_3"), cc.p(0,0), "animation1", nil, nil, nil, true, true)
	tishi:setOpacity(0)
	-- 移动弹板
	tanban:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(function ( ... )
		local jackpotCell = self.theme.HoldLayer._added[jackpot_list[2]]
		if jackpotCell then 
			jackpotCell:setVisible(false)
		end
	end),cc.MoveTo:create(0.5,cc.p(640,360)),
		cc.CallFunc:create(function ()
			-- 播放弹板显示动画
			bole.spChangeAnimation(tanban,"animation1",false)
			-- 声音
			self.theme:playMusic(self.theme.audio_list.bonus_wheel_show1) 
		end),
		cc.DelayTime:create(37/30),
		cc.CallFunc:create(function ( ... )
			-- 播放弹板的循环动画
			bole.spChangeAnimation(tanban,"animation2",true)		
			-- 播放jackpot item 的显示动画
			miniGame:setVisible(true)
			playLine(0,60)
			-- 播放声音2 
			self.theme:playMusic(self.theme.audio_list.bonus_wheel_show2)
			tishi:runAction(cc.FadeTo:create(1, 255))
		end),cc.DelayTime:create(1),cc.CallFunc:create(function ( ... )
			-- 播放声音 提示中间框 
			self.theme:playMusic(self.theme.audio_list.bonus_wheel_spindianliu,true,true)
			-- 播放wheel bgm
			self.theme:playMusic(self.theme.audio_list.bonus_wheel_bgm,true)
			self.theme:dealMusic_FadeLoopMusic(0.5, 1, 0.3)
		end)))

-----------------------------------------------------------------
	
	local children   = startLayer:getChildByName("clip"):getChildren()
	local items= {}
	for i=1,#children do 
		local item 		= children[i]
		item.sp = item:getChildByName("sp")
		item.bg = item:getChildByName("bg")
		table.insert(items,item) -- key 和相应的 item 从0 开始
	end
	local pathList = {}
	for i=0,4 do
		pathList[i] = "#theme_jackpot_"..i..".png"
		if i==0 then 
			pathList[i.."bg"] = "#theme_jackpot_specialbg.png"
		else
			pathList[i.."bg"] = "#theme_jackpot_basebg.png"
		end
	end

	local height = 82
	local width  = 300
	local data= {

		["reelIcons"]      = {items},

    	["colCount"]  	   = 1,-- 列
	
		["keylist"]        = {jackpot_list[1].jp_win_type},
		["cellSize"]       = {cc.p(width,height)},
    	["startIndex"]     = {1}, -- math.random(1,6), -- 随机的是 index 格子的 而不是 key

    	["rowCountList"]   = {7},-- 行的 itemCount 上下加一个 cell 之后的个数

		["itemCount"]           = 5, -- 上下加一个 cell 之后的个数

		["delayBeforeSpin"]     = 0.0,   --开始旋转前的时间延迟
	    ["upBounce"]     		= 0,    --开始滚动前，向上滚动距离
	    ["upBounceTime"]     	= 0,   --开始滚动前，向上滚动时间
	    ["speedUpTime"]     	= 0.5,   --加速时间
	    ["rotateTime"]    	 	= 2.0,   -- 匀速转动的时间之和
	    ["maxSpeed"]     	 	= 3/6*width*60,    --每一秒滚动的距离
	    ["downBounce"]      	= 0,  --滚动结束前，向下反弹距离  都为正数值
	    ["speedDownTime"]      	= 5, -- 4
	    ["downBounceTime"]      = 0,
		
		["direction"]      		= 2,
		["rollReelList"]        = {miniGameReel},
		["spritePath"]			= pathList,
		["reelBasePos"] 		= {cc.p(0,0)},
		["rollCount"]			= 1,  -- 结束的时候转动的圈数
		["spriteScale"]			= respinSpriteScale,
	}

	local callFunc = function ()
		-- 滚轴停止音效
		self.theme:laterCallBack(22/60,function ( )
			self:playWheelStopSound()
		end) 
		-- 保存数据
		self.jackpotIndex = self.jackpotIndex +1
		self:addData("over_jackpot", self.jackpotIndex)
		self.overJackpotList = self.overJackpotList or {}
		table.insert(self.overJackpotList,{jackpot_list[2],jackpot_list[1]})
		self:addData("over_jackpotList",self.overJackpotList)
		-- 保存 jackpot 值
		self.theme.overJackpotValue = self.theme.overJackpotValue or {}
		self.theme.overJackpotValue[jackpot_list[2]] = jackpot_list[1]
		-- table.insert(self.theme.overJackpotValue,{jackpot_list[1].jp_win_type,jackpot_list[2]})

		local overFunc = function ()
			
			self.theme:dealMusic_FadeLoopMusic(0.5, 0.3, 1)	
			self._movetheCellSprite:runAction(cc.Sequence:create(cc.DelayTime:create(1.5),cc.ScaleTo:create(0.5,1.2),cc.ScaleTo:create(0.5,1)))
			miniGame:runAction(cc.Sequence:create(cc.DelayTime:create(1.5),cc.CallFunc:create(function ()
				-- 隐藏提示动画
				tishi:setVisible(false)
				-- 停止选中电流声音音效
				self.theme:stopMusic(self.theme.audio_list.bonus_wheel_spindianliu,true) 
				-- 播放飞行声音
				self.theme:playMusic(self.theme.audio_list.bonus_wheel_digital)
			end),cc.MoveTo:create(1,cc.pAdd(jackpotCellPos,cc.p(2.5,-5.5))),cc.CallFunc:create(function ( ... )
				-- 停止symbol 的 闪电动画
				dian:removeFromParent()
				
				-- 向symbol 上面添加中奖的显示图片
				local jackpotCell = self.theme.HoldLayer._added[jackpot_list[2]]
				jackpotCell:setVisible(true)
				bole.updateSpriteWithFile(jackpotCell, self.theme.pics[20+jackpot_list[1].jp_win_type])
				
			end),cc.DelayTime:create(1),cc.RemoveSelf:create()))

			mask:runAction(cc.Sequence:create(cc.DelayTime:create(2.5),cc.FadeOut:create(1)))

			-- 1 弹窗收起的时间 + 1 延迟收集的时间
			self.theme:laterCallBack(2+1,function ( ... )
				jackpotMiniGameNode:removeFromParent()
				doNext()
			end)
		end

		-- 添加弹窗显示庆祝逻辑
		self.theme:laterCallBack(2,function ( ... )
			-- 播放选中动画
			bole.spChangeAnimation(tishi,"animation2",true)

			playLine(100,130)
			bole.spChangeAnimation(tanban,"animation3",false)
			-- 播放音效弹窗音效
			self.theme:playMusic(self.theme.audio_list.bonus_wheel_close) 

			local theCellFile = pathList[jackpot_list[1].jp_win_type]
			self._movetheCellSprite = bole.createSpriteWithFile(theCellFile)
			self._movetheCellSprite :setScale(respinSpriteScale[jackpot_list[1].jp_win_type])
			spineNode:addChild(self._movetheCellSprite ,1)

		end) 
		self.theme:laterCallBack(2 + 1.5,function ( ... )
			-- 播放音效
			self.theme:playMusic(self.theme.audio_list.transition)
			-- 停止wheel bgm
			self.theme:stopMusic(self.theme.audio_list.bonus_wheel_bgm, true)

			self.theme:playMusic(self.theme.audio_list.bonus_jackpot_win)
			-- self.theme:laterCallBack(1,function ( ... )
			-- 	self.theme:playMusic(self.theme.audio_list.bonus_jackpot_win)
			-- end) 

			local jackpotEndRoot = cc.Node:create()
			jackpotMiniGameNode:addChild(jackpotEndRoot,3)
			jackpotEndRoot:setPosition(640,360)
			-- 播放庆祝弹窗动画
			local jackpotEnd   = cc.CSLoader:createNode(self.theme:getPic("csb/jackpot_end.csb"))
			local root         = jackpotEnd:getChildByName("root")
			local jackpotSp    = root:getChildByName("sp")
			local coinsLabel   = root:getChildByName("coins")

			local playLine2 = function (startFrame, endFrame)
				local action = cc.CSLoader:createTimeline(self.theme:getPic("csb/jackpot_end.csb"))
				jackpotEnd:runAction(action)
				action:gotoFrameAndPlay(startFrame, endFrame, false)
			end

			bole.updateSpriteWithFile(jackpotSp, pathList[jackpot_list[1].jp_win_type])
			local _, jackpotEndTanban   = Theme:addSpineAnimation(jackpotEndRoot, 1, self.theme:getPic("spine/special/jackpot/erjizhongjiang_01"), cc.p(0,0), "animation1", nil, nil, nil, true)
			jackpotEndRoot:addChild(jackpotEnd,2)
			jackpotEnd:setPosition(cc.p(0,0))
			playLine2(0,60)
			
			self.theme:laterCallBack(74/30,function ( ... )
				bole.spChangeAnimation(jackpotEndTanban,"animation2",true)
			end)

			local function parseValue( num)
				return FONTS.format(num, true)
			end
			bole.setSpeicalLabelScale(coinsLabel,jackpot_list[1].jp_win,404)
			inherit(coinsLabel, LabelNumRoll)
			coinsLabel:nrInit(0, 24, parseValue)
			coinsLabel:nrStartRoll(0, jackpot_list[1].jp_win, 3)

			self.theme:laterCallBack(5,function ( ... )
				jackpotEndRoot:runAction(cc.Sequence:create(cc.ScaleTo:create(0.5,0),cc.CallFunc:create(function ( ... )
					-- 飞中的jackpot 相关操作
					overFunc()
				end),cc.RemoveSelf:create()))
				-- footer 进行加钱操作
				self.ctl.footer:setWinCoins(jackpot_list[1].jp_win,self.ctl.totalWin , 0)
				self.ctl.totalWin = self.ctl.totalWin + jackpot_list[1].jp_win
				if self.ctl.freewin then 
					self.ctl.freewin = self.ctl.freewin + jackpot_list[1].jp_win
				end
			end)
		end)
	end
	self.miniReel = BaseReelWithSprite.new(self, data,callFunc)

	self.theme:laterCallBack(2.5+36/30+1,function ( ... )
		-- 开始调用滚动
		self.miniReel:startSpin()
		-- 播放滚动音效 bonus_wheel_spinzhuanlun
		self.theme:playMusic(self.theme.audio_list.bonus_wheel_spinzhuanlun)
	end)

end

function ChiefOfTheGodsBonus:playWheelStopSound( )
	self.theme:playMusic(self.theme.audio_list.bonus_wheel_stop)
end

function ChiefOfTheGodsBonus:onExit( ... )
	if self.miniReel then 
		if self.miniReel.scheduler then 
			local scheduler = cc.Director:getInstance():getScheduler()
			scheduler:unscheduleScriptEntry(self.miniReel.scheduler)
			self.miniReel.scheduler = nil
		end
	end
end

return ThemeChiefOfTheGods





