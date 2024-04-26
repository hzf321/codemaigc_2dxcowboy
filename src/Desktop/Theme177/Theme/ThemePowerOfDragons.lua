
--Author:wanghongjie
--Email:wanghongjie@bolegames.com
--2020年01月14日 16:00
--Using:主题 177  -- (小猪的转速)

ThemePowerOfDragons = class("ThemePowerOfDragons", Theme)
local cls = ThemePowerOfDragons

-- 资源异步加载相关
cls.plistAnimate = {
    "image/plist/symbol",
    "image/plist/base",
    "image/plist/coins_store",
}

cls.csbList = {
    "csb/base.csb",
}

local transitionDelay = {
    ["pick"] = { ["onCover"] = 60 / 30, ["onEnd"] = 85 / 30 },
    ["free"] = { ["onCover"] = 40 / 30, ["onEnd"] = 60 / 30 },
}

local SpinBoardType = {
    Normal = 1,
    FreeSpin = 2,
    Bonus = 3,
}

---------------------
local allCsbList = {
    ["base"] = "csb/base.csb",
    ["free_spin"] = "csb/free_spin.csb",
    ['store'] = "csb/coin_store.csb"
}

local addResultLiziTime = 0.5
local mapCollectParticlePath = "particle/shoujilizi.plist"

local normalShowDialogTime = 0.5
local closeFreeDialogAnimTime = 0.5
local baseColCnt = 5
local specialSymbol = { ["wild"] = 1, ["scatter"] = 11, ['bonus'] = 12, ["scatter2"] = 13, ["scatter3"] = 14 } -- scatter base 里面的中奖free symbol; scatter2 free中的reteriger symbol; scatter3 free的倍数symbol

----------------- bonus 相关
local PowerOfDragonsBonusType = {
    WHEEL = 1,
    PICK = 2,
    STOREBONUS = 3,
}
----------------- wheel 相关
local wheelReelConfig = {{0,1,0,0,1}, {0,2,0,0,2}, {0,3,0,0,3}}
local wheelMaskPosList = {[2] = cc.p(1, -27), [3] = cc.p(0, -35)}
local baseSceneMaxWidth = 1060
local dragonFlyTime = 2
local wheelBaseHeight = 178
local singleWheelStopDelay = 1
--------------------
cls.spinTimeConfig = { -- spin 时间控制
    ["base"] = 20 / 60, -- 数据返回前 进行滚动的时间
    ["spinMinCD"] = 50 / 60, -- 可以显示 stop按钮的时间，也就是可以通过quickstop停止的时间
}

------------------------------ 商店相关 ------------------------------
local lockFeatrueAnimName = "animation1" -- 收集解锁相关
local openFeatrueAnimName = "animation2"

local logoLoopAnimName = "animation1" -- logo 动画
local logoBonusAnimName = "animation2"
local clawPoins = cc.p(40, -30)

local inStoreCoinsMaxWidth = 160
local storeCoinsMaxCnt = 6
local storePagesCnt = 6
local onePageItemCnt = 9
local onePageBuffCnt = 5
local onePageLevelCnt = 5

local coinItemBasePos = cc.p(106, 388)
local coinItemSingleWidth = 198
local coinItemSingleHeight = 137

local coinItemConfig = {
    [0] = { -- 不可购买状态
        -- 1:namem,2:pos,3:scale,4:color/animationname/5:zorder
        ["spine"] = { "spine/store/can_touch/spine", cc.p(0, 0), "animation2", false, 2 }, --- animation1:循环，animation 打开 ，animation2 锁住静帧，
        ["sp"] = {
            { "#theme177_collect_moneybg1.png", cc.p(0, -45), 1, nil, 3 }, -- 文字框
        },
        ["label"] = { "font/font_4.fnt", cc.p(14, -50), 0.9, nil, 4 }, -- 购买 需要claw 数量
    },
    [1] = { -- 可购买状态
        ["spine"] = { "spine/store/can_touch/spine", cc.p(0, 0), "animation1", true, 2 }, --循环
        ["btn"] = { "commonpics/kong.png", cc.p(0, 0), 13, nil, 10 },
        ["sp"] = {
            { "#theme177_collect_moneybg1.png", cc.p(0, -45), 1, nil, 3 }, -- 文字框
        },
        ["label"] = { "font/font_4.fnt", cc.p(14, -50), 0.9, nil, 4 }, -- 购买 需要claw 数量
    },
    [2] = { -- 购买完成状态
        [1] = { -- free
            ["sp"] = {
                { "#theme177_collect_logo1.png", cc.p(0, 0), 1, nil, 10 }, },
        },
        [2] = { -- cash bonus
            ["sp"] = {
                { "#theme177_collect_logo2.png", cc.p(0, 0), 1, nil, 10 }
            },
        },
        [3] = {-- coin
            ["sp"] = {
                { "#theme177_collect_bg3.png", cc.p(0, 0), 1, nil, 1 }, -- bg框
            }, -- 齿轮
            ["label"] = { "font/font_2.fnt", cc.p(0, 10), 0.72, nil, 10 }, -- 购买 需要claw 数量
        }
    },
    [3] = { -- 点击的过程
        ["spine"] = { "spine/store/can_touch/spine", cc.p(0, 0), "animation", false, 1 },
    },
    [4] = { -- progressConfig
        ["base_pos"] = cc.p(-108, 63),
        ["cnt"] = 6,
        ["padding"] = 45,
        ["bg"] = "#theme177_collect_choose1.png",
        ["choose"] = "#theme177_collect_choose2.png"
    },
    [5] = { -- level show star
        ["base_pos"] = cc.p(2, 363),
        ["cnt"] = 5,
        ["padding"] = 28.5,
        ["star"] = "#theme177_collect_level2.png"
    },
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
        local colCnt = temp["colCnt"]
        local newReelConfig = {}
        for cnt, posList in pairs(temp.reelConfig) do
            for col = 1, colCnt do
                local oneConfig = {}
                local posx = (col - 1) * (temp["cellWidth"] + temp["padding"]) + posList["base_pos"].x
                local posy = posList["base_pos"].y
                oneConfig["base_pos"] = cc.p(posx, posy)
                oneConfig["cellWidth"] = temp.cellWidth
                oneConfig["cellHeight"] = temp.cellHeight
                oneConfig["symbolCount"] = temp["rowReelCnt"]
                table.insert(newReelConfig, oneConfig)
            end
        end
        borderConfig[idx]["reelConfig"] = newReelConfig
    end
    self.boardConfigList = self.ThemeConfig["boardConfig"]
    return self.boardConfigList
end

function cls:ctor(themeid)
    math.randomseed(os.time())
    self.spinActionConfig = {
        ["start_index"] = 1,
        ["spin_index"] = 1,
        ["stop_index"] = 1,
        ["fast_stop_index"] = 1,
        ["special_index"] = 1,
    }
    self.ThemeConfig = {
        ["theme_symbol_coinfig"] = {
            ["symbol_zorder_list"] = {
                [specialSymbol.bonus] = 800,
                [specialSymbol.scatter] = 700,
                [specialSymbol.scatter2] = 700,
                [specialSymbol.scatter3] = 700,
                [specialSymbol.wild] = 500,
            },
            ["normal_symbol_list"] = {
                specialSymbol.wild, 2, 3, 4, 5, 6, 7, 8, 9, 10
            },
            ["special_symbol_list"] = {
                specialSymbol.scatter
            },
            ["no_roll_symbol_list"] = {
                specialSymbol.scatter, specialSymbol.scatter2, specialSymbol.scatter3, specialSymbol.bonus
            },
            ["roll_symbol_inFree_list"] = {
            },
            ["special_symbol_config"] = {
                [specialSymbol.scatter] = {
                    ["min_cnt"] = 3,
                    ["type"] = G_THEME_SYMBOL_TYPE.NUMBER,
                    ["col_set"] = {
                        [1] = 1,
                        [2] = 0,
                        [3] = 1,
                        [4] = 0,
                        [5] = 1,
                    },
                },
            },
        },
        ["theme_round_light_index"] = 1,
        ["theme_type"] = "payLine",
        ["theme_type_config"] = {
            ["pay_lines"] = {
                {1, 1, 1, 1, 1}, {2, 2, 2, 2, 2}, {0, 0, 0, 0, 0}, {3, 3, 3, 3, 3}, {0, 1, 2, 1, 0}, {1, 2, 3, 2, 1}, {2, 1, 0, 1, 2}, {3, 2, 1, 2, 3}, {0, 1, 1, 1, 0}, {1, 2, 2, 2, 1},
                {2, 3, 3, 3, 2}, {1, 0, 0, 0, 1}, {2, 1, 1, 1, 2}, {3, 2, 2, 2, 3}, {0, 0, 1, 0, 0}, {1, 1, 2, 1, 1}, {2, 2, 3, 2, 2}, {1, 1, 0, 1, 1}, {2, 2, 1, 2, 2}, {3, 3, 2, 3, 3},
                {0, 1, 0, 1, 0}, {1, 2, 1, 2, 1}, {2, 3, 2, 3, 2}, {1, 0, 1, 0, 1}, {2, 1, 2, 1, 2}, {3, 2, 3, 2, 3}, {1, 0, 1, 2, 1}, {2, 1, 2, 3, 2}, {1, 2, 1, 0, 1}, {2, 3, 2, 1, 2},
                {0, 0, 1, 2, 2}, {1, 1, 2, 3, 3}, {2, 2, 1, 0, 0}, {3, 3, 2, 1, 1}, {0, 0, 2, 0, 0}, {1, 1, 3, 1, 1}, {2, 2, 0, 2, 2}, {3, 3, 1, 3, 3}, {0, 0, 0, 1, 2}, {3, 3, 3, 2, 1},
            },
            ["line_cnt"] = 40,
        },
        ["boardConfig"] = {
            { -- 3x5
                ["allow_over_range"] = true,
                ["reel_single"] = true,
                ["colCnt"] = 5,
                ["rowReelCnt"] = 4,
                ["cellWidth"] = 130,
                ["padding"] = 0,
                ["cellHeight"] = 100,
                ["reelConfig"] = {
                    {
                        ["base_pos"] = cc.p(37, 195.5),
                    }
                }

            },
        }
    }


    --- add by yt
    EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_SHOW, "theme177", self.touchShowCActivity, self)
    EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_HIDE, "theme177", self.touchHideCActivity, self)
    --- end by yt


    self.baseBet = 10000
    self.DelayStopTime = 0
    self.UnderPressure = 1 -- 下压上 控制
    local use_portrait_screen = true
    local ret = Theme.ctor(self, themeid, use_portrait_screen)
    return ret
end

local G_cellHeight = 115
local delay = 0

local upBounce = G_cellHeight * 2 / 3
local upBounceMaxSpeed = 6 * 60
local upBounceTime = 0
local speedUpTime = 12 / 60
local rotateTime = 5 / 60
local maxSpeed = -40 * 60
local normalSpeed = -40 * 60
local fastSpeed = -40 * 60 - 300

local stopDelay = 20 / 60
local speedDownTime = 30 / 60
local downBounce = G_cellHeight * 2 / 3
local downBounceMaxSpeed = 6 * 60
local downBounceTime = 15 / 60
local specialAniTime = 0
local extraReelTime = 120 / 60
local spinMinCD = 0.5

local extraReelTimeInFreeGame = 240/60

----------------------------------------------------------------------------------------------------
function cls:initScene(spinNode)
    local path = self:getPic("csb/base.csb")
    self.mainThemeScene = cc.CSLoader:createNode(path)
    self.down_node = self.mainThemeScene:getChildByName("down_node")
    bole.adaptScale(self.mainThemeScene, true)
    bole.adaptReelBoard(self.down_node) -- 竖屏 适配 棋盘的 横屏不需要
    self.down_child = self.down_node:getChildByName("down_node")

    self.bgRoot = self.mainThemeScene:getChildByName("theme_bg")
    self.baseBg = self.bgRoot:getChildByName("bg_base")
    self.freeBg = self.bgRoot:getChildByName("bg_free")
    self.bgLogoRoot = self.bgRoot:getChildByName("bg_logo")
    self.curBg = self.baseBg
    self.freeBg:setVisible(false)
    self:addSpineAnimation(self.bgLogoRoot, -1, self:getPic("spine/base/tk"), cc.p(0, 0), "animation", nil, nil, nil, true, true)

    self.reelRoot = self.down_child:getChildByName("reel_root_node")
    self.boardRoot = self.down_child:getChildByName("board_root")
    self.animateNode = self.down_child:getChildByName("animate")
    self.randomAnimNode = self.down_child:getChildByName("random_anim")

    self.bonusWheelNode = self.mainThemeScene:getChildByName("bonus_wheel_node")

    -- 初始化jackpot
    self.progressiveParent = self.mainThemeScene:getChildByName("progressive") -- 初始化jackpot
    self.jackpotLabels = {}
    for i = 1, 5 do
        self.jackpotLabels[i] = self.progressiveParent:getChildByName("label_jp" .. i)
        self.jackpotLabels[i].maxWidth = self:getJPLabelMaxWidth(i)
        self.jackpotLabels[i].baseScale = self.jackpotLabels[i]:getScale()
    end
    self:initialJackpotNode()

    -- free node 用来放置，倍数的节点
    self.freeMultiNode = self.down_child:getChildByName("free_multi_node")
    self.freeMultiSp = self.freeMultiNode:getChildByName("multi_sp")

    self.freeFeatureDimmer = self.down_child:getChildByName("feature_dimmer")
    self.freeFeatrueDialogN = self.down_child:getChildByName("featrue_dialog")

    -- 随机转盘相关
    self:initBaseWheelNode()

    ---Collect相关
    self:initGameStoreNode()

    self:initLogoNode()


    self.shakyNode:addChild(self.mainThemeScene)
end

function cls:initBaseWheelNode( ... )
    self.wheelWinNode = self.mainThemeScene:getChildByName("win_wheel_node")

    self.wheelNode = self.wheelWinNode:getChildByName("wheel_node")

    local wheelItems = self.wheelNode:getChildByName("panel"):getChildren()
    self.wheelRollItemList = {}
    self.wheelRollItemDList = {}
    for k, itemsParent in pairs(wheelItems) do
        self.wheelRollItemDList[k] = {}
        self.wheelRollItemList[k] = itemsParent:getChildren()
        for i, item in pairs(itemsParent:getChildren()) do
            local keyValue  = wheelReelConfig[k][i]
            table.insert(self.wheelRollItemDList[k],{keyValue, item}) -- key 和相应的 item 从0 开始
        end
    end

    local wheelAnimNode = self.wheelNode:getChildByName("anim_node")
    self.wheelAnimNodeList = {}
    self.wheelEndNodeList = {}
    self.wheelEndSpList = {}

    for k = 1, 3 do
        animParent = wheelAnimNode:getChildByName("node"..k)
        self.wheelAnimNodeList[k] = animParent:getChildByName("anim")
        if k > 1 then
            self.wheelEndNodeList[k] = animParent:getChildByName("end_item")
            self.wheelEndSpList[k] = self.wheelEndNodeList[k]:getChildByName("sp")
        end
    end

    self:setWheelBonusNodeState(false)
end

function cls:setWheelBonusNodeState( state )
    self.wheelNode:setVisible(state)
    for k, ndoe in pairs(self.wheelEndNodeList) do
        ndoe:setVisible(state)
    end

    for k, nodeList in pairs(self.wheelRollItemList) do
        for index, node in pairs(nodeList) do
            node:setPositionY((-index+1.5)*wheelBaseHeight)
        end
    end
end

function cls:initGameStoreNode()
    self.collectFeatureNode = self.down_child:getChildByName("game_store_node")

    local _, _lockS = self:addSpineAnimation(self.collectFeatureNode, nil, self:getPic("spine/collect_progress/collect_lock/spine"), cc.p(-219, 41), lockFeatrueAnimName, nil, nil, nil, true)
    self.lockSuperNode = _lockS
    self.isLockFeature = nil

    self.collectCntLb = self.collectFeatureNode:getChildByName("game_store_label")

    self.coinImg = self.collectFeatureNode:getChildByName("img_coin")
    self.openStoreBtn = self.collectFeatureNode:getChildByName("open_btn")
    self.bonusflyNode = self.down_child:getChildByName("fly_node")
    self.receiveAniNode = self.down_child:getChildByName("receive_ani")

    self.charParentNode = self.collectFeatureNode:getChildByName("char_node")
    self:resetBaseCharacter(self.shopInfo.index)
end

function cls:initLogoNode()
    bole.adaptTop(self.bonusWheelNode, -0.8)
    bole.adaptTopAll(self.progressiveParent, -0.8)
    bole.adaptTopAll(self.wheelWinNode, -0.8)

    if self:adaptationLongScreen() then
        local path = "spine/long_logo/spine"
        self:initLongLogoNode(path)
        if bole.isIphoneX() then
            self.longLogoNode:setPositionY(self.longLogoNode:getPositionY() + 30)
        end
        self:_adaptLogoNodeTip()
    end
end

-----------------------------------------------------------------------------------------------------------------------------------
-- @ 长屏logo 点击活动移动相关 add by yt
function cls:_adaptLogoNodeTip( ... )
    self.longLogoNode:setVisible(true)
    self.longLogoLableImg:setScale(1)
    self.longLogoNode.basePos = cc.p(self.longLogoNode:getPosition())
    self.longLogoLableImg.basePos = cc.p(self.longLogoLableImg:getPosition())
    self.longLogoLableImg.baseScale = 1
    if self:getHeaderStatus() == 1 then
        self:downThemeLogo(true)
    end
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
    if self.longLogoLableImg then
        local endscale = self.longLogoLableImg.baseScale * 0.9
        local endPosY = self.longLogoLableImg.basePos.y - 20
        self.longLogoLableImg:stopActionByTag(1003)
        if not noAni then
            local a1 = cc.ScaleTo:create(0.3, endscale)
            local a2 = cc.MoveTo:create(0.3, cc.p(0, endPosY))
            local a3 = cc.Spawn:create(a1, a2)
            a3:setTag(1003)
            self.longLogoLableImg:runAction(a3)
        else
            self.longLogoLableImg:setScale(endscale)
            self.longLogoLableImg:setPositionY(endPosY)
        end
    end
end

function cls:upThemeLogo(noAni)
    if self.longLogoLableImg then
        local endscale = self.longLogoLableImg.baseScale
        local endPosY = self.longLogoLableImg.basePos.y + 10
        self.longLogoLableImg:stopActionByTag(1003)
        if not noAni then
            local a1 = cc.ScaleTo:create(0.3, endscale)
            local a2 = cc.MoveTo:create(0.3, cc.p(0, endPosY))
            local a3 = cc.Spawn:create(a1, a2)
            a3:setTag(1003)
            self.longLogoLableImg:runAction(a3)
        else
            self.longLogoLableImg:setScale(endscale)
            self.longLogoLableImg:setPositionY(endPosY)
        end
    end
end

function cls:getHeaderStatus()
    return self.showHeaderdStatus or 2
end
-----------------------------------------------------------------------------------------------------------------------------------


function cls:resetBaseCharacter(index)
    self.bgLogoRoot:removeAllChildren()
    local _, s = self:addSpineAnimation(self.bgLogoRoot, nil, self:getPic("spine/base/bg_logo"..index.."/spine"), cc.p(0, 0), logoLoopAnimName, nil, nil, nil, true, true)
    self.bgLogoSpine = s
end

function cls:getJPLabelMaxWidth(index)
    local jackpotLabelMaxWidth = { 310, 294, 274, 260, 242 }
    return jackpotLabelMaxWidth[index] or jackpotLabelMaxWidth[#jackpotLabelMaxWidth]
end

function cls:initSpinLayerBg()
    Theme.initSpinLayerBg(self)
    self:openFeatureEvent()
    self:updateBaseShowFeatureCnt()
    self.flyNumberLayer = cc.Node:create()
    self.flyNumberLayer:setPosition(0, 0)
    self.curScene:addToTop(self.flyNumberLayer, 10)
end
function cls:updateBaseShowFeatureCnt(value)
    value = value or self.featurePoints
    if value == nil then
        value = 0
    end
    self.collectCntLb:setString(FONTS.formatByCount4(value, storeCoinsMaxCnt, true))
end

--点击主题内商店按钮
function cls:openFeatureEvent()
    self.isFeatureClick = false
    local function onTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            if not self.showBaseSpinBoard then
                return
            end
            if self.isInBonusGame then
                return nil
            end
            if self.isFeatureClick then
                return nil
            end
            if not self.featureData then
                return
            end
            if self.isLockFeature then
                self:playMusic(self.audio_list.common_click)
                self:setBet()
                return
            end
            self:playMusic(self.audio_list.common_click)
            self:showFeatureNode()
        end

    end
    self.openStoreBtn:addTouchEventListener(onTouch)
end

function cls:setBet()
    local set_Bet = self.tipBet
    local maxBet = self.ctl:getMaxBet()
    if maxBet >= set_Bet then
        self.ctl:setCurBet(set_Bet)
    end
end

function cls:checkLockFeature(bet)

    local bet = bet or self.ctl:getCurTotalBet()
    -- 1是循环, 2是解锁, 3是锁上; 屏幕中心; 解锁26帧, 锁上10帧
    if not self.tipBet or not self.lockSuperNode then
        return
    end
    if self.isLockFeature == nil then
        if bet >= self.tipBet then
            self.isLockFeature = true
        else
            self.isLockFeature = false
        end
    end
    if bet >= self.tipBet and self.isLockFeature then
        -- 播放解锁动画
        self.isLockFeature = false
        self:playMusic(self.audio_list.unlock)
        self:showLockStatus(2)

    elseif bet < self.tipBet and not self.isLockFeature then
        -- 播放锁定动画
        self.isLockFeature = true
        self:playMusic(self.audio_list.lock)
        self:showLockStatus(1)

    end
end

function cls:showLockStatus(fType)
    if fType == 1 then
        -- lock
        bole.spChangeAnimation(self.lockSuperNode, lockFeatrueAnimName)
    else
        --  unlock
        bole.spChangeAnimation(self.lockSuperNode, openFeatrueAnimName)
    end
end

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

end

function cls:getThemeJackpotConfig()
    local jackpot_config_list = {
        link_config = { [1] = "grand", [2] = "maxi", [3] = "major", [4] = "minor", [5] = "mini" },
        allowK = { [177] = false, [677] = false, [1177] = false }
    }
    return jackpot_config_list
end

function cls:playCellRoundEffect(parent, ...)
    -- 播放中奖连线框
    self:addSpineAnimation(parent, 100, self:getPic("spine/kuang/spine"), cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
end

function cls:enterFreeSpin(isResume)
    -- 更改背景图片 和棋盘
    if isResume then
        -- 断线重连的逻辑
        self:dealMusic_PlayFreeSpinLoopMusic()-- 切换背景音乐
        self:changeSpinBoard(SpinBoardType.FreeSpin)--  更改棋盘显示 背景 和 free 显示类型
    end
    self:showAllItem()
    self.playNormalLoopMusic = false --commonMusic: freespin背景音乐
end

function cls:updateFreeSpinMulti()
	if self.freeMulti and self.freeMulti > 1 then
		if not self.isShowFreeMulti then
            self:playMusic(self.audio_list.multi_show)
			self.freeMultiNode:setOpacity(0)
			self.freeMultiNode:runAction(cc.FadeIn:create(0.4))
		end
		bole.updateSpriteWithFile(self.freeMultiSp, "#theme177_free_ui_num"..self.freeMulti..".png")
		self.isShowFreeMulti = true
	else
		self.freeMultiNode:setOpacity(0)
		self.isShowFreeMulti = false
	end
end

function cls:showFreeSpinNode(count, sumCount, first)
    if self.superAvgBet then
        self.ctl:setPointBet(self.superAvgBet)-- 更改 锁定的bet
    end
    Theme.showFreeSpinNode(self, count, sumCount, first)
end

function cls:hideFreeSpinNode(...)
    if self.superAvgBet then
        self.superAvgBet = nil
        self.ctl.footer:changeNormalLayout2()
    end

    self:changeSpinBoard(SpinBoardType.Normal)

    self.freeMulti = nil
    self.isShowFreeMulti = false
    self.freeAddSpinsBuff = nil
    self.freeAddWildsBuff = nil

    Theme.hideFreeSpinNode(self, ...)
end

function cls:adjustWithTheCellSpriteUpdate(theCellNode, key, col)
    -- 删除掉 tip 动画
    if theCellNode.symbolTipAnim then
        if (not tolua.isnull(theCellNode.symbolTipAnim)) then
            theCellNode.symbolTipAnim:removeFromParent()
        end
        theCellNode.symbolTipAnim = nilf
    end
end

function cls:createCellSprite(key, col, rowIndex)

    if key and type(key) == "number" then
        key = key % 100
    end

    local theCellFile = self.pics[key]
    local theCellNode = cc.Node:create()

    local theCellSprite = bole.createSpriteWithFile(theCellFile)
    theCellNode:addChild(theCellSprite)
    theCellNode.key = key
    theCellNode.sprite = theCellSprite
    theCellNode.curZOrder = 0
    ------------------------------------------------------------
    self:adjustWithTheCellSpriteUpdate(theCellNode, key, col)
    local theKey = theCellNode.key
    if self.symbolZOrderList[theKey] then
        theCellNode.curZOrder = self.symbolZOrderList[theKey]
    end
    if self.symbolPosAdjustList[theKey] then
        theCellSprite:setPosition(self.symbolPosAdjustList[theKey])
    end
    return theCellNode
end

local needChangeID = Set({3,4,5,6})
function cls:updateCellSprite(theCellNode, key, col, isShowResult, isReset)
    local haveCoin = false
    if key > 100 then
        haveCoin = true
        key = key % 100
    end

    -- whj可能需要改变颜色
    local _color
    if self.canTurnSymbol and self.turnSymbolID then
        if needChangeID[key] then
            key = self.turnSymbolID
            if self.canColorSymbol then
                _color = cc.c3b(255,255,255)
            end
        else
            if self.canColorSymbol then
                _color = cc.c3b(125,125,125)
            end
        end
    end
    local theCellFile = self.pics[key]
    if not theCellFile then
        --print("whj: key, theCellFile", key, theCellFile)
    end
    local theCellSprite = theCellNode.sprite
    bole.updateSpriteWithFile(theCellSprite, theCellFile)
    theCellNode.key = key
    theCellNode.curZOrder = 0

    if not isReset and not isShowResult and key == specialSymbol.bonus then
        local _ ,s = self:addSpineAnimation(self.animateNode, nil, self:getPic("spine/item/12/bouns_tw_01"), self:getCellPos(col, 2.5), "animation")
        if self.showWheelDimmer then
            s:setColor(cc.c3b(125,125,125))
        end
    end

    if _color then
        theCellNode.sprite:setColor(_color)
    end
    ------------------------------------------------------------
    self:adjustWithTheCellSpriteUpdate(theCellNode, key, col)
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

    if haveCoin and not isReset then
        local coinNode = bole.createSpriteWithFile("#theme177_base_ui_11.png")
        coinNode:setScale(0.9)
        theCellNode:addChild(coinNode, 100)
        coinNode:setPosition(clawPoins)
        theCellNode.coin = coinNode
    else
        if theCellNode.coin and bole.isValidNode(theCellNode.coin) then
            theCellNode.coin:removeFromParent()
            theCellNode.coin = nil
        end
    end
end

function cls:getFreeReel( )
    if self.freeAddWildsBuff then
        return self.ctl.theme_reels["free_reel2"]
    else
        return self.ctl.theme_reels["free_reel"]
    end
end

function cls:adjustEnterThemeRet(data)
    data.theme_reels = {
        ["main_reel"] = {
            [1] = {7,8,2,2,9,10,3,3,7,8,4,4,9,10,5,5,7,8,6,6,9,11,10,1,7,2,8,3,9,2,10,4,7,2,8,5,9,2,10,6,7,8,1,1,9,10,3,7,4,8,11,9,3,10,5,7,3,8,6,9,1,10,4,7,5,8,4,9,6,10,5,7,6,11},
            [2] = {10,9,2,2,8,7,3,3,10,9,4,4,8,7,5,5,10,9,6,6,8,1,7,2,10,3,9,2,8,4,7,2,10,5,9,2,8,6,7,10,1,1,9,8,3,7,4,10,3,9,5,8,3,7,6,10,1,9,4,8,5,7,4,10,6,9,5,8,6},
            [3] = {7,8,2,2,9,10,3,3,7,8,4,4,9,10,5,5,7,8,6,6,9,11,10,12,1,7,2,8,3,9,2,10,4,7,2,8,5,9,2,10,12,6,7,8,1,1,9,10,3,7,4,8,11,9,3,10,5,7,3,8,6,9,1,10,4,7,5,8,4,9,6,10,5,7,6,11,12},
            [4] = {10,9,2,2,8,7,3,3,10,9,4,4,8,7,5,5,10,9,6,6,8,1,7,2,10,3,9,2,8,4,7,2,10,5,9,2,8,6,7,10,1,1,9,8,3,7,4,10,3,9,5,8,3,7,6,10,1,9,4,8,5,7,4,10,6,9,5,8,6},
            [5] = {7,8,2,2,9,10,3,3,7,8,4,4,9,10,5,5,7,8,6,6,9,11,10,1,7,2,8,3,9,2,10,4,7,2,8,5,9,2,10,6,7,8,1,1,9,10,3,7,4,8,11,9,3,10,5,7,3,8,6,9,1,10,4,7,5,8,4,9,6,10,5,7,6,11},
        },
        ["free_reel"] = {
            [1] = {7,8,2,2,2,2,9,10,3,3,3,3,7,8,4,4,4,4,9,10,1,7,8,5,5,5,5,9,10,6,6,6,6,7,8,2,9,3,10,2,7,4,8,2,9,5,10,2,7,6,8,9,1,1,10,7,3,8,4,9,3,10,5,7,3,8,6,9,4,10,5,7,1,8,4,9,6,10,5,7,6},
            [2] = {10,9,2,2,2,2,8,7,3,3,3,3,10,9,4,4,4,4,8,7,1,10,9,5,5,5,5,8,7,6,6,6,6,10,9,2,8,3,7,2,10,4,9,2,8,5,7,2,10,6,9,8,1,1,7,10,3,9,4,8,3,7,5,10,3,9,6,8,4,7,5,10,1,9,4,8,6,7,5,10,6},
            [3] = {7,8,2,2,2,2,9,10,3,3,3,3,7,8,4,4,4,4,9,10,1,7,8,5,5,5,5,9,10,6,6,6,6,7,8,2,9,3,10,2,7,4,8,2,9,5,10,2,7,6,8,9,1,1,10,7,3,8,4,9,3,10,5,7,3,8,6,9,4,10,5,7,1,8,4,9,6,10,5,7,6},
            [4] = {10,9,2,2,2,2,8,7,3,3,3,3,10,9,4,4,4,4,8,7,1,10,9,5,5,5,5,8,7,6,6,6,6,10,9,2,8,3,7,2,10,4,9,2,8,5,7,2,10,6,9,8,1,1,7,10,3,9,4,8,3,7,5,10,3,9,6,8,4,7,5,10,1,9,4,8,6,7,5,10,6},
            [5] = {7,8,2,2,2,2,9,10,3,3,3,3,7,8,14,9,4,4,4,4,10,7,1,8,9,5,5,5,5,10,7,6,6,6,6,8,9,13,10,2,7,3,8,2,9,4,10,14,7,2,8,5,9,2,10,6,7,8,1,1,9,10,3,7,4,8,13,9,3,10,5,7,3,8,6,9,14,10,4,7,5,8,1,9,4,10,6,7,13,8,5,9,6,10},
        },
        ["free_reel2"] = {
            [1] = {7,8,2,2,2,2,9,10,3,3,3,3,7,8,4,4,4,4,9,10,1,1,7,8,5,5,5,5,9,10,6,6,6,6,7,8,2,9,3,10,1,2,7,4,8,2,9,5,10,2,7,6,8,9,1,1,1,10,7,3,8,4,9,3,10,5,7,3,8,6,9,4,10,5,7,1,1,8,4,9,6,10,5,7,6},
            [2] = {10,9,2,2,2,2,8,7,3,3,3,3,10,9,4,4,4,4,8,7,1,1,10,9,5,5,5,5,8,7,6,6,6,6,10,9,2,8,3,7,1,2,10,4,9,2,8,5,7,2,10,6,9,8,1,1,1,7,10,3,9,4,8,3,7,5,10,3,9,6,8,4,7,5,10,1,1,9,4,8,6,7,5,10,6},
            [3] = {7,8,2,2,2,2,9,10,3,3,3,3,7,8,4,4,4,4,9,10,1,1,7,8,5,5,5,5,9,10,6,6,6,6,7,8,2,9,3,10,1,2,7,4,8,2,9,5,10,2,7,6,8,9,1,1,1,10,7,3,8,4,9,3,10,5,7,3,8,6,9,4,10,5,7,1,1,8,4,9,6,10,5,7,6},
            [4] = {10,9,2,2,2,2,8,7,3,3,3,3,10,9,4,4,4,4,8,7,1,1,10,9,5,5,5,5,8,7,6,6,6,6,10,9,2,8,3,7,1,2,10,4,9,2,8,5,7,2,10,6,9,8,1,1,1,7,10,3,9,4,8,3,7,5,10,3,9,6,8,4,7,5,10,1,1,9,4,8,6,7,5,10,6},
            [5] = {7,8,2,2,2,2,9,10,3,3,3,3,7,8,14,9,4,4,4,4,10,7,1,1,8,9,5,5,5,5,10,7,6,6,6,6,8,9,13,10,2,7,3,8,1,2,9,4,10,14,7,2,8,5,9,2,10,6,7,8,1,1,1,9,10,3,7,4,8,13,9,3,10,5,7,3,8,6,9,14,10,4,7,5,8,1,1,9,4,10,6,7,13,8,5,9,6,10},
        },
    }
    self.tipBet = data.bonus_level

    if data["theme_map"] then
        self.featureData = data["theme_map"]
        if data["theme_map"]["shop_info"] then
            self.shopInfo = data["theme_map"]["shop_info"]
        end
        if data["theme_map"]["map_points"] then
            self.featurePoints = data["theme_map"]["map_points"]
        end
    end


    if not self.shopInfo then
        self.shopInfo = {
			["level"] = { 1, 1, 1, 1, 1, 1, 1, 1 },
			["stuff"] = { { 0, 0, 0, 0, 0 }, { 0, 0, 0, 0, 0 }, { 0, 0, 0, 0, 0 }, { 0, 0, 0, 0, 0 }, { 0, 0, 0, 0, 0 } , { 0, 0, 0, 0, 0 }},
			["complete"] = { 0, 0, 0, 0, 0, 0, 0, 0 },
			["index"] = 1
        }
    end

    if data["free_game"] then

		if data.theme_info and data.theme_info.free_multi then
			self.freeMulti = data.theme_info.free_multi or 1
		end
        if data["free_game"].super_bet then
            self.superAvgBet = data["free_game"].super_bet
        end

        if data["free_game"]["free_spins"] == data["free_game"]["free_spin_total"] then

            self.freeAddSpinsBuff = data.free_game.add_spins and data.free_game.add_spins > 0
            self.freeAddWildsBuff = data.free_game.add_wild and data.free_game.add_spins > 0

            data["first_free_game"] = {}
            data["first_free_game"]["free_spins"] = data["free_game"]["free_spins"]
            data["first_free_game"]["free_spin_total"] = data["free_game"]["free_spin_total"]
            data["first_free_game"]["base_win"] = data["free_game"]["base_win"]
            data["first_free_game"]["total_win"] = data["free_game"]["total_win"]
            data["first_free_game"]["bet"] = data["free_game"]["bet"]
            data["first_free_game"]["item_list"] = data["free_game"]["item_list"]
            -- self.recvItemList = data["free_game"]["item_list"]
            data["free_game"] = nil
        else
            self.ctl.freeSpeical = self:getSpecialTryResume(data["free_game"]["item_list"])
        end
    end

    if data["bonus_game"] then
        if data["bonus_game"].super_bet then
            self.superAvgBet = data["bonus_game"].super_bet
        end
    end
    return data
end
function cls:getSpecialTryResume(data)

    local specials = { [specialSymbol["scatter"]] = {} }
    for col, colItemList in ipairs(data) do
        for row, theKey in ipairs(colItemList) do
            if theKey == specialSymbol["scatter"] then
                specials[theKey][col] = specials[theKey][col] or {}
                specials[theKey][col][row] = true
            end
        end
    end
    return specials

end
function cls:adjustTheme(data)
    self:changeSpinBoard(SpinBoardType.Normal)

    -- if self.recvItemList then
    --     self.ctl:resetBoardCellsSprite(self.recvItemList)
    -- end
end

function cls:topSetBet(list)
    -- 后续 需要确认 是否 快速点击的时候最后停下的位置 正确的
    if self.animateNode then
        -- 第一次 设置bet的时候 可能还没有 创建场景
        self:stopDrawAnimate()
    end
end
--------------------------------------------------------------------------------

function cls:resetPointBet() -- 仅仅在断线的时候 被调用了
    if self.superAvgBet then
        self.ctl:setPointBet(self.superAvgBet)-- 更改 锁定的bet
        self.ctl.footer:changeFreeSpinLayout3()-- 隐藏掉  footer bet
    end
end

function cls:changeSpinBoard(pType)
    self:clearAnimate()
    if pType == SpinBoardType.Normal then
        -- normal情况下 需要更改棋盘底板
        self.showFreeSpinBoard = false
        self.showBaseSpinBoard = true
        self.showBonusSpinBoard = false

        self.freeMultiNode:setVisible(false)
        self.freeFeatureDimmer:setVisible(false)

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
        self.showBonusSpinBoard = false

        self.freeMultiNode:setVisible(true)
		self.freeFeatureDimmer:setVisible(true)
        self.freeFeatureDimmer:setOpacity(0)

		self:updateFreeSpinMulti()

        if self.spinLayer ~= self.spinLayerList[1] then
            self.spinLayer:DeActive()
            self.spinLayer = self.spinLayerList[1]
            self.spinLayer:Active()
        end

        if self.curBg ~= self.freeBg then
            self.curBg:setVisible(false)
            self.freeBg:setVisible(true)
            self.curBg = self.freeBg
        end

        if self.superAvgBet then
            self.ctl:setPointBet(self.superAvgBet)-- 更改 锁定的bet
            self.ctl.footer:changeFreeSpinLayout3()-- 隐藏掉  footer bet
        end
    end
end

---------------------------------- spin 相关 ------------------------
function cls:onSpinStart()
    self.isFeatureClick = true
    if self.winBonusWheelData then
        self:playShowWheelNodeAnim("hide")
    end
    self.winBonusWheelData = nil
    self.buffData = nil
    self.winCookie = nil
    self.canTurnSymbol = false
    self.canColorSymbol = false
    self.showWheelDimmer = false
    self.DelayStopTime = 0
    Theme.onSpinStart(self)
end

--------------------------Start--------------------------
-----------------------多棋盘 相关属性----------------------

function cls:stopControl(stopRet, stopCallFun)
	if stopRet["bonus_level"] then
		self.tipBet = stopRet["bonus_level"]
	end

	if stopRet.theme_info and stopRet.theme_info.free_multi  then
		self.freeMulti = stopRet.theme_info.free_multi
	end

	if stopRet.bonus_game and stopRet.bonus_game.type and stopRet.bonus_game.type == PowerOfDragonsBonusType.WHEEL then -- 更改bonus数据-三个转盘逻辑
		self.winBonusWheelData = tool.tableClone(stopRet.bonus_game.win_wheel)
		stopRet.bonus_game = nil
	end

    if stopRet["theme_info"] and stopRet["theme_info"]["theme_map"] then
        local themeMap = stopRet["theme_info"]["theme_map"]

        self.buffData = {}
        local remoteShopInfo = themeMap.shop_info
        for i = 1, storePagesCnt do
            for j = 1, 5 do
                if remoteShopInfo.stuff[i][j] ~= self.shopInfo.stuff[i][j] then
                    local info = {}
                    info.page = i
                    info.index = j
                    table.insert(self.buffData, info)
                end
            end
        end
        if themeMap.cookie_count and themeMap.cookie_count > 0 then
            self.winCookie = true
        end
        self.shopInfo = tool.tableClone(remoteShopInfo)
        self.featurePoints = themeMap.map_points
    end
	stopCallFun()
end

function cls:getSpinColFastSpinAction(pCol)
    local speedScale = nil
    return Theme.getSpinColFastSpinAction(self, pCol, speedScale)
end

function cls:getSpinConfig(spinTag)
    local spinConfig = {}
    for col, _ in pairs(self.spinLayer.spins) do
        local theStartAction = self:getSpinColStartAction(col)
        local theReelConfig = {
            ["col"] = col,
            ["action"] = theStartAction,
        }
        table.insert(spinConfig, theReelConfig)
    end
    return spinConfig
end

function cls:genSpecials(pWinPosList)
    local specials = { [specialSymbol.scatter] = {}, [specialSymbol.scatter2] = {} }
    local itemList = self.ctl:getRetMatrix()

    if itemList then
        for col, colItemList in pairs(itemList) do
            for row, _key in pairs(colItemList) do
                local theKey = _key%100
                if theKey == specialSymbol.scatter or theKey == specialSymbol.scatter2 then
                    specials[theKey][col] = specials[theKey][col] or {}
                    specials[theKey][col][row] = true
                end
            end
        end
    end
    self.ctl.specials = specials
end

function cls:genSpecialSymbolState(rets)
    rets = rets or self.ctl.rets -- 复制 通用逻辑
    if not self.checkItemsState then
        self.checkItemsState = {}  -- 都已列作为项， 各列各个sybmol相关状态，分为后面有可能，单列就有可能中，已经中了，后续没有可能中了
        self.speedUpState = {}  -- 加速的列控制
        self.notifyState = {}  -- 播放特殊symbol滚轴停止的时候的动画位置
        self.flyCoinList = {}

        self:genSpecialSymbolStateInNormal(rets) -- base 情况 配置 scatter、bonus
        self:genSpecialSymbolStateInOther(rets) -- base 情况 配置 scatter、bonus
    end
    -- 记录当前需要激励的项
end

function cls:genSpecialSymbolStateInNormal(rets)

    local cItemList = rets.item_list
    local checkConfig = self.specialItemConfig
    for itemKey, theItemConfig in pairs(checkConfig) do
        local itemType = theItemConfig["type"]
        local itemCnt = 0

        if itemType then
            for col = 1, #self.spinLayer.spins do
                local colItemList = cItemList[col]
                local colRowCnt = self.spinLayer.spins[col].row -- self.colRowList[col]
                local curColMaxCnt = theItemConfig["col_set"][col] or colRowCnt
                local curRowCnt = 0
                for row, theItem in pairs(colItemList) do
                    if (theItem) % 100 == itemKey then
                        curRowCnt = curRowCnt + 1
                    end
                    if theItem > 100 then
                        self.flyCoinList = self.flyCoinList or {}
                        table.insert(self.flyCoinList, { col, row })
                    end
                end

                -- 判断_当前列之前_是否已经中了feature(通过之前列itemKey个数判断)
                local isGetFeature = false
                if itemCnt >= theItemConfig["min_cnt"] then
                    isGetFeature = true
                end
                ---- 判断当前列加上之后所有列是否有可能中feature
                local willGetFeatureInAfterCols = false

                local sumCnt = 0
                for tempCol = col, #self.spinLayer.spins do
                    sumCnt = sumCnt + (theItemConfig["col_set"][tempCol] or colRowCnt)
                end
                if sumCnt > 0 and (itemCnt + sumCnt) >= theItemConfig["min_cnt"] then
                    willGetFeatureInAfterCols = true
                end
                ---- 判断是否可能中feature或者更大的feature   一般用于滚轴加速
                local willGetFeatureInCol = false
                if curColMaxCnt>0 and (itemCnt+curColMaxCnt)>=theItemConfig["min_cnt"] then
                    willGetFeatureInCol = true
                    self.speedUpState[col] = self.speedUpState[col] or {}-- 此情况下，会进行特殊操作，将其状态记到self.speedUpState中
                    self.speedUpState[col][itemKey] = true
                end
                --
                self.notifyState[col] = self.notifyState[col] or {}-- 当前列提示相关状态
                if curColMaxCnt > 0 and willGetFeatureInAfterCols then
                    for row, _key in pairs(colItemList) do
                        local theItem = _key%100
                        if theItem == itemKey then
                            self.notifyState[col][itemKey] = self.notifyState[col][itemKey] or {}
                            table.insert(self.notifyState[col][itemKey], { col, row })
                        end
                    end
                end

                itemCnt = itemCnt + curRowCnt

            end
        end
    end
end

function cls:genSpecialSymbolStateInOther( rets )
    for col=1, baseColCnt do -- 遍历每一列
        local colItemList = rets.item_list[col]
        if colItemList then
            -- bonus 和 scatter2 落地计算
            for row, _key in pairs(colItemList) do -- 落地动画
               local theItem = _key%100
                if theItem == specialSymbol.bonus or theItem == specialSymbol.scatter2 or theItem == specialSymbol.scatter3 then
                    self.notifyState[col] = self.notifyState[col] or {}
                    self.notifyState[col][theItem] = self.notifyState[col][theItem] or {}
                    table.insert(self.notifyState[col][theItem], {col, row})
                end
            end
        end
    end
end

function cls:checkSpeedUp(checkCol)
    -- 控制出现特殊的龙 虎 预示好事发生的动画的时候 取消单个轴的 加速操作
    local isNeedSpeedUp = false
    if not self.ctl.specialSpeed and self.speedUpState and self.speedUpState[checkCol] and bole.getTableCount(self.speedUpState[checkCol]) > 0 then
        isNeedSpeedUp = true
    end
    return isNeedSpeedUp
end

function cls:dealMusic_PlayReelNotifyMusic(pCol)
    self:playMusic(self.audio_list.reel_notify)
    self.playR1Col = pCol
end

function cls:dealMusic_StopReelNotifyMusic(pCol)
    if not self.playR1Col then return end
    self.playR1Col = nil

    self:stopMusic(self.audio_list.reel_notify,true)
    self.playNotifyName = nil
end

function cls:checkPlaySymbolNotifyEffect(pCol)
    local isPlaySymbolNotify = false
    self:dealMusic_StopReelNotifyMusic(pCol) -- 停止滚轴加速的声音
    if not self.fastStopMusicTag then
        -- 判断是否播放特殊symbol的动画
        isPlaySymbolNotify = self:dealMusic_PlaySpecialSymbolStopMusic(pCol)-- 判断是否播放特殊symbol的动画
    else
        if pCol == #self.spinLayer.spins then
            local haveSymbolLevel = 5 -- 普通下落音的等级
            for k,v in pairs(self.notifyState) do -- 判断在剩下停止的滚轴中是否有特殊symbol
                if bole.getTableCount(v) > 0 then
                    if v[specialSymbol["bonus"]] then
                        if haveSymbolLevel > 1 then
                            haveSymbolLevel = 1
                        end
                        self:playSymbolNotifyEffect(k, reelSymbolState) -- 播放特殊symbol 下落特效
                    elseif v[specialSymbol["scatter"]] then
                        if haveSymbolLevel > 2 then
                            haveSymbolLevel = 2
                        end
                        self:playSymbolNotifyEffect(k, reelSymbolState) -- 播放特殊symbol 下落特效
                    elseif v[specialSymbol["scatter2"]] then
                        if haveSymbolLevel > 3 then
                            haveSymbolLevel = 3
                        end
                        self:playSymbolNotifyEffect(k, reelSymbolState) -- 播放特殊symbol 下落特效
                    elseif v[specialSymbol["scatter3"]] then
                        if haveSymbolLevel > 4 then
                            haveSymbolLevel = 4
                        end
                        self:playSymbolNotifyEffect(k, reelSymbolState) -- 播放特殊symbol 下落特效
                    end
                    self.notifyState[k] = {}
                end
            end
            if haveSymbolLevel < 5 then
                self:playMusic(self.audio_list["special_stop"..haveSymbolLevel])
                isPlaySymbolNotify = true
            end
        end
    end
    return isPlaySymbolNotify
end

function cls:dealMusic_PlaySpecialSymbolStopMusic(pCol)
    self.notifyState = self.notifyState or {}
    if (not self.notifyState[pCol]) or bole.getTableCount(self.notifyState[pCol]) == 0 then
        return false
    end

    local ColNotifyState = self.notifyState[pCol]
    local haveSymbolLevel = 5
    if ColNotifyState[specialSymbol.bonus] then -- scatter
        if haveSymbolLevel >1 then
            haveSymbolLevel = 1
        end
        self:playSymbolNotifyEffect(pCol) -- 播放特殊symbol 下落特效
    elseif ColNotifyState[specialSymbol.scatter] then
        if haveSymbolLevel >2 then
            haveSymbolLevel = 2
        end
        self:playSymbolNotifyEffect(pCol)
    elseif ColNotifyState[specialSymbol.scatter2] then
        if haveSymbolLevel > 3 then
            haveSymbolLevel = 3
        end
        self:playSymbolNotifyEffect(pCol)
    elseif ColNotifyState[specialSymbol.scatter3] then
        if haveSymbolLevel > 4 then
            haveSymbolLevel = 4
        end
        self:playSymbolNotifyEffect(pCol)
    end

    if haveSymbolLevel < 5 then
        self:playMusic(self.audio_list["special_stop" .. haveSymbolLevel])
        self.notifyState[pCol] = {}
        return true
    end
end

function cls:playReelNotifyEffect(pCol)
    -- 播放特殊的 等待滚轴结果的
    self.reelNotifyEffectList = self.reelNotifyEffectList or {}
    local pos = self:getCellPos(pCol, 2.5)
    local _, s1 = self:addSpineAnimation(self.animateNode, 20, self:getPic("spine/base/jili/spine"), pos, "animation", nil, nil, nil, true, true)
    self.reelNotifyEffectList[pCol] = s1
end

function cls:stopReelNotifyEffect(pCol)
    if not pCol then
        self.reelNotifyEffectList = self.reelNotifyEffectList or {}
        for i = 1, 5 do
            if self.reelNotifyEffectList[i] and (not tolua.isnull(self.reelNotifyEffectList[i])) then
                self.reelNotifyEffectList[i]:removeFromParent()
                self.reelNotifyEffectList[i] = nil
            end
        end
        self.reelNotifyEffectList = nil
        return
    end
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
function cls:onReelFallBottom(pCol)
    -- 标志位
    self.reelStopMusicTagList[pCol] = true
    -- 列停音效，提示动画相关
    if not self:checkPlaySymbolNotifyEffect(pCol) then
        self:dealMusic_PlayReelStopMusic(pCol)
    end
    self:stopReelNotifyEffect(pCol)

    -- 确定下一轴是否进行Notify
    if self:checkSpeedUp(pCol + 1) then
        self:onReelNotifyStopBeg(pCol +1)
    end
end

function cls:onReelStop(col, tryResume, isOverRespin)
    self:asHintTime(col)
    Theme.onReelStop(self, col)
end

function cls:asHintTime(col)
    -- self.bonusflyNode:removeAllChildren()
    -- self.flyCoinSpines = nil
    if self.flyCoinList then
        for i = 1, #self.flyCoinList do
            if self.flyCoinList[i] and self.flyCoinList[i][1] == col then
                local row = self.flyCoinList[i][2]
                local index = col + 5 * (row - 1)
                self.flyCoinSpines = self.flyCoinSpines or {}
                -- 添加fly 动画的落地状态
                local pos = cc.pAdd(self:getCellPos(col, row), clawPoins)
                local cell = self.spinLayer.spins[col]:getRetCell(row)

                local _, s = self:addSpineAnimation(self.bonusflyNode, 20, self:getPic("spine/collect_progress/collect_fly/spine"), pos, "animation", nil, nil, nil, true)
                self.flyCoinSpines[index] = s
                s:setVisible(false)
            end
        end
    end
end

function cls:onThemeInfo(ret, callFunc)
    self.themeInfoCallFunc = callFunc

    self:checkHasWinInThemeInfo(ret)
end

function cls:checkHasWinInThemeInfo(ret)
	local hasSpecialWin = false
	if ret.theme_info then
		local retThemeInfo = ret.theme_info
        if self.buffData and #self.buffData > 0 then
            hasSpecialWin = true
            self:flyBuffAction(self.buffData, ret)
            self.buffData = nil
        elseif self.winCookie then
            hasSpecialWin = true
            self.winCookie = false
            self:flyCoinAction(ret)
		elseif retThemeInfo.fg_flag then -- 先计算 free
			self.ctl:updateFreeSpinCount(true, 1) -- 进行sum计数+1
			ret.free_spins = nil
			self:playShowAddFreeSpecial(ret, "cnt")
			hasSpecialWin = true
			retThemeInfo.fg_flag = nil
		elseif retThemeInfo.multi_flag then -- 后计算倍数
			self:playShowAddFreeSpecial(ret, "multi")
			hasSpecialWin = true
			retThemeInfo.multi_flag = nil
		end
        if hasSpecialWin then
            self:dealMusic_FadeLoopMusic(0.2, 1, 0.3)
        end
	end

	if not hasSpecialWin then
		if self.themeInfoCallFunc then
			self.themeInfoCallFunc()
		end
	end
end

local freeScatterAnimTime =2
local freeAddSpecialDialogTime = 1.5
function cls:playShowAddFreeSpecial( ret, stype )
	self:playScatterAnimInFree(ret, stype)

	self:runAction(cc.Sequence:create(
		cc.DelayTime:create(freeScatterAnimTime),
		cc.CallFunc:create(function ( ... ) -- 收集次数
			self:showAddFreeSpecialDialog(stype)
		end),
		cc.DelayTime:create(freeAddSpecialDialogTime),
		cc.CallFunc:create(function ( ... ) -- 播放收集特效
			self:showAddFreeSpecialParticle(stype)
		end),
		cc.DelayTime:create(addResultLiziTime),
		cc.CallFunc:create(function ( ... )
			if stype == "cnt" then
				self.ctl:adjustWithFreeSpin() -- 总计数+1 显示
			else
				self:updateFreeSpinMulti() -- 更新multi 显示
			end
			self:checkHasWinInThemeInfo(ret)
		end)
		))
end

function cls:playScatterAnimInFree( ret, stype )
	local sItem = stype == "cnt" and specialSymbol.scatter2 or specialSymbol.scatter3
	local itemList = ret.item_list or self.ctl:getRetMatrix()
	if itemList and itemList[baseColCnt] then
		for row, key in pairs(itemList[baseColCnt]) do
			if key%100 == sItem then
				self:addItemSpine(sItem, baseColCnt, row, nil, true)
			end
		end
	end
end

local multiSpineName = {
    [2] = "animation1", [3] = "animation2", [5] = "animation3", [10] = "animation4"
}
function cls:showAddFreeSpecialDialog(dtype)
	if dtype == "cnt" then
        self:addSpineAnimation(self.freeFeatrueDialogN, 20, self:getPic("spine/dialog/add_free_cnt/1fg_01"), cc.p(0,0), "animation")
    else
		self:addSpineAnimation(self.freeFeatrueDialogN, 20, self:getPic("spine/dialog/add_free_multi/fanbeitanchuang_01"), cc.p(0,0), multiSpineName[self.freeMulti])
	end
    self:playMusic(self.audio_list.free_dialog_more_show)
    self.freeFeatureDimmer:setOpacity(0)
    self.freeFeatureDimmer:setVisible(true)
	self.freeFeatureDimmer:runAction(cc.Sequence:create(
        cc.FadeTo:create(0.3, 200),
		cc.DelayTime:create(50/30),
		cc.FadeTo:create(0.3, 0)))
end

function cls:showAddFreeSpecialParticle(dtype)
	local endPos = cc.p(0,0)
    local startPos = cc.p(0,-240)
	if dtype ~= "cnt" then
		local endPosW = bole.getWorldPos(self.freeMultiSp)
		endPos = bole.getNodePos(self.ctl.footer.freegamesNode, endPosW)
	end

	local startPosW = bole.getWorldPosByPos(self.freeFeatrueDialogN, startPos)
	local startPosN = bole.getNodePos(self.ctl.footer.freegamesNode, startPosW)

	local particleFile = self:getPic(mapCollectParticlePath)
	local s1 = cc.ParticleSystemQuad:create(particleFile)
	self.ctl.footer.freegamesNode:addChild(s1, 1000)
	s1:setPosition(startPosN)

    self:playMusic(self.audio_list.num_fly)
	s1:runAction(cc.Sequence:create(
		cc.MoveTo:create(addResultLiziTime, endPos),
		cc.DelayTime:create(0.5),
		cc.RemoveSelf:create()
	))
end

function cls:flyBuffAction(buffData, ret)
    self.receiveAniNode:removeAllChildren()
    local wEndPos = cc.p(-220, 35)

    for i = 1, #buffData do
        local flyBuffNode = cc.CSLoader:createNode(self:getPic("csb/buff_node.csb"))
        flyBuffNode:setPosition(cc.p(0, -215))
        self.receiveAniNode:addChild(flyBuffNode)
        flyBuffNode:setScale(0)
        local buffname = flyBuffNode:getChildByName("buff_name")
        local buffdesc = flyBuffNode:getChildByName("buff_desc")

        local buffFileName = "#theme177_collect_material" .. buffData[i].page .. "_" .. buffData[i].index .. ".png"
        local buffFileDesc = "#theme177_collect_prompt_"..buffData[i].index..".png"
        bole.updateSpriteWithFile(buffname, buffFileName)
        bole.updateSpriteWithFile(buffdesc, buffFileDesc)

        self:playMusic(self.audio_list.collect_show)

        flyBuffNode:runAction(cc.Sequence:create(
            cc.ScaleTo:create(0.5, 1.2),
            cc.ScaleTo:create(0.2, 1),
            cc.DelayTime:create(2),
            cc.CallFunc:create(function()
                self:playMusic(self.audio_list.collect_fly)
            end),
            cc.Spawn:create(cc.MoveTo:create(0.5, wEndPos), cc.ScaleTo:create(0.5, 0)),
            cc.CallFunc:create(function() -- 播放爆炸特效
                if i == #buffData then
                    self:checkHasWinInThemeInfo(ret)
                end
            end),
            cc.RemoveSelf:create()))
    end
end

function cls:flyCoinAction(ret)
    if self.flyCoinList and bole.getTableCount(self.flyCoinList) > 0 then
        local _flyCoinList = tool.tableClone(self.flyCoinList)
        self.flyCoinList = nil
        local _flyCoinSpines = tool.tableClone(self.flyCoinSpines)
        self.flyCoinSpines = nil

        local wEndPos = bole.getWorldPos(self.coinImg)
        wEndPos = cc.pAdd(wEndPos, cc.p(-10, 0))
        local endNPos = bole.getNodePos(self.bonusflyNode, wEndPos)

        for i = 1, #_flyCoinList do
            local col = _flyCoinList[i][1]
            local row = _flyCoinList[i][2]
            local cell = self.spinLayer.spins[col]:getRetCell(row)
            if bole.isValidNode(cell.coin) then
                cell.coin:removeFromParent()
                cell.coin = nil
            end

        end

        self:playMusic(self.audio_list.collect)
        self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function ( ... )
                for col, item in pairs(_flyCoinSpines) do
                    item:setVisible(true)
                    item:runAction(cc.Sequence:create(
                        cc.CallFunc:create(function ( ... )
                            bole.spChangeAnimation(item, "animation")
                        end),
                        cc.MoveTo:create(0.5, endNPos),
                        cc.RemoveSelf:create()))
                end
            end),
            cc.DelayTime:create(0.5),
            cc.CallFunc:create(function(...)-- 同时更新计数
                self.collectCntLb:setString(FONTS.formatByCount4(self.featurePoints, storeCoinsMaxCnt, true))
                self:checkHasWinInThemeInfo(ret)
                self:addSpineAnimation(self.bonusflyNode, 20, self:getPic("spine/collect_progress/collect/spine"), endNPos, "animation")
            end)
        ))
    else
        self:checkHasWinInThemeInfo(ret)
    end
end

-------------------------- 断线重连 ----------------------------
function cls:setFreeGameRecoverState(data)
    if data["free_spins"] and data["free_spins"] >= 0 then
        -- 断线重连如果是最后一次freespin 的时候就不在进行这个操作
        self.isFreeGameRecoverState = true
    end
end

function cls:enterThemeByBonus(theBonusGameData, endCallFunc)
    self.ctl.isProcessing = true
    self.ctl:open_old_bonus_game(theBonusGameData, endCallFunc)
end

function cls:overBonusByEndGame(data)
    -- bonus 有end_game 字段 直接把 Bonus 钱加到 footer上面 如果 之后 没有 特殊feature 则直接加钱到header上面
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

function cls:saveBonusData()
    if self.ctl.rets then
        self.ctl.bonusItem = tool.tableClone(self.ctl.rets.item_list)
        self.ctl.bonusRet = self.ctl.rets
        self.bonusSpeical = self.ctl.specials
    end
end

function cls:outBonusStage()
    if self.bonusSpeical then
        self.ctl.specials = self.bonusSpeical
    end
    if self.ctl.bonusItem then
        self.ctl:resetBoardCellsSpriteOverBonus(self.ctl.bonusItem) -- 刷新牌面 + 动画播放
    end
    self.ctl.bonusItem = nil
    self.ctl.bonusRet = nil
end

function cls:saveBonusCheckData(bonusData)
    -- 没有断线的情况下进入bonus时候, 判断存在bonus_id校验字段, 直接赋值存储,同时覆盖掉原来的数据(每个主题里面单独控制是否需要清空数据)
    local data = {}
    data["bonus_id"] = bonusData.bonus_id
    LoginControl:getInstance():saveBonus(self.themeid, data)
end

function cls:cleanBonusSaveData(data)
    -- 断线的情况下进入bonus时候, 判断bonus_id校验字段本地与服务器不一致, 清除原来的数据(每个主题里面单独控制是否需要清空数据)
    LoginControl:getInstance():saveBonus(self.themeid, nil)
end

function cls:enterThemeByFirstFreeSpin(ret, theFreeSpinData, endCallFunc)
    ret["free_spins"] = theFreeSpinData.free_spins
    ret["free_spin_total"] = theFreeSpinData.free_spin_total

    -- self.ctl.isProcessing  	= false
    self.ctl.specials = self:getSpecialTryResume(theFreeSpinData["item_list"])
    self.ctl.footer:setSpinButtonState(true)
    self.ctl:free_spins(ret)
end

function cls:dealAboutBetChange(bet)
    self:checkLockFeature()
end

function cls:onAllReelStop()
    Theme.onAllReelStop(self)
end

function cls:finshSpin()
    if (not self.ctl.freewin) and (not self.buyBackData) and (not self.ctl.autoSpin) then
        self.isFeatureClick = false
    end

end

function cls:stopDrawAnimate()
    -- 可能存在 手动调用的可能
    self.haveSpecialdelay = false
    Theme.stopDrawAnimate(self)
    self:stopReelNotifyEffect()
    self.animNodeList = nil
    self.randomAnimNode:removeAllChildren()
    self.stickyWildList = nil
    self.turnSymbolID = nil
end
---------------------------------- freeSpin --------------------------------------------
local fs_show_type = {
    start = 1,
    more = 2,
    collect = 3,
}

local addFreeCntDelay = 0.5
function cls:playFeatureDialogAnim( root, showNode, sType, dType )
    if dType and dType == "store" then
        local _ ,s = self:addSpineAnimation(showNode, -1, self:getPic("spine/dialog/store_collect/sd_ljlct_01"), cc.p(0,0), "animation1", nil, nil, nil, true)
        s:runAction(cc.Sequence:create(
            cc.DelayTime:create(24/30),
            cc.CallFunc:create(function ( ... )
                bole.spChangeAnimation(s, "animation2", true)
            end)))
        local btn = bole.deepFind(showNode, "btn_collect")
        local size = btn:getContentSize()
        self:addSpineAnimation(btn, nil, self:getPic("spine/dialog/store_collect/sd_ljlct_02"), cc.p(size.width/2, size.height/2), "animation", nil, nil, nil, true, true)
    else
        if sType == fs_show_type.start then
            local _ ,s = self:addSpineAnimation(showNode, -1, self:getPic("spine/dialog/free/fgkaishi_01"), cc.p(0,0), "animation1_1", nil, nil, nil, true)
            s:runAction(cc.Sequence:create(
                cc.DelayTime:create(1),
                cc.CallFunc:create(function ( ... )
                    if self.freeAddSpinsBuff then
                        self:playMusic(self.audio_list.add3)
                        self:addSpineAnimation(showNode, nil, self:getPic("spine/dialog/free/fgkaishi_01_1"), cc.p(0,0), "animation")
                    end
                    bole.spChangeAnimation(s, "animation1_2", true)
                end),
                cc.DelayTime:create(43/30),
                cc.CallFunc:create(function ( ... )
                    if self.freeAddSpinsBuff then
                        self:addSpineAnimation(showNode, nil, self:getPic("spine/dialog/free/fgkaishi_01_2"), cc.p(0,0), "animation")
                        local labelCount   = bole.deepFind(showNode, "label_count")
                        labelCount:setString("11")
                    end
                end)))
        elseif sType == fs_show_type.collect then
            local _ ,s = self:addSpineAnimation(showNode, -1, self:getPic("spine/dialog/free/fgkaishi_01"), cc.p(0,0), "animation2_1", nil, nil, nil, true)
            s:runAction(cc.Sequence:create(
                cc.DelayTime:create(1),
                cc.CallFunc:create(function ( ... )
                    bole.spChangeAnimation(s, "animation2_2", true)
                end)))
        end
    end
end

function cls:showFreeSpinDialog(theData, sType, dType)
	local config = {}
	-- todo delay 控制
	local _transitionDelay = transitionDelay["free"]
	config["csb_file"] =  self:getPic("csb/dialog_free.csb")

    local otherDelay = 0
    if self.freeAddSpinsBuff then
        otherDelay = addFreeCntDelay
    end
	config["frame_config"] = {
		["start"] 		 = {{0, 90}, otherDelay + 0.5, {120, 150}, 0, _transitionDelay.onCover + closeFreeDialogAnimTime, (_transitionDelay.onEnd - _transitionDelay.onCover), 0.5},
		["collect"] 	 = {{0, 90}, 1, {120, 150}, 0, _transitionDelay.onCover, (_transitionDelay.onEnd - _transitionDelay.onCover), 0},-- 最后一个参数 是延时删除的时间 -- 倒数第二个参数 回调 完成方法
	}

    local collectMaxWidth = 480
    if dType and dType == "store" then
        config["csb_file"] =  self:getPic("csb/dialog_store_c.csb")
        collectMaxWidth = 625
    end
	self.freeSpinConfig = config

	local theDialog = G_FREE_SPIN_DIALOGS["base"].new(self.ctl, self.freeSpinConfig)

	if sType == fs_show_type.start then
		self:playFeatureDialogAnim( theDialog.root, theDialog.startRoot, sType, dType )
		theDialog:showStart(theData)
        if self.freeAddSpinsBuff then
            theDialog.startRoot.labelCount:setString("8")
        end
	elseif sType == fs_show_type.collect then
		self:playFeatureDialogAnim( theDialog.root, theDialog.collectRoot, sType, dType)
		theDialog:setCollectScaleByValue(theData.coins, collectMaxWidth)
		theDialog:showCollect(theData)
	end
end

function cls:playStartFreeSpinDialog(theData)

	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end
		self.ctl.footer:enableOtherBtns(false)
		self:runAction(cc.Sequence:create(
			cc.DelayTime:create(0.5),
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
		if endEvent then
			endEvent()
		end
        self:runAction(cc.Sequence:create(
            cc.DelayTime:create(0.5),
            cc.CallFunc:create(function()
                if self.freeAddWildsBuff then
                    self.firstFreeGameTrigger = true
                    self:smashDiamondsIntoReel()
                end
            end)))
	end

	self:showFreeSpinDialog(theData, fs_show_type.start)
end

function cls:playMoreFreeSpinDialog(theData)
    if theData.enter_event then
        theData.enter_event()
    end
    if theData.click_event then
        theData.click_event()
    end

    if theData.end_event then
        theData.end_event()
    end
end

function cls:playCollectFreeSpinDialog(theData)

	local enter_event = theData.enter_event
	theData.enter_event = function()
		if enter_event then
			enter_event()
		end
		self:stopAllLoopMusic()
	end
	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end
		self:playTransition(nil,"free")-- 转场动画
	end
	self:showFreeSpinDialog(theData, fs_show_type.collect)
end


local smashMaxZOrder = 100
local nextDiamondsDelay = 0.1
local onDiamondsTime = 14/30
local addDiamondsCnt = 25
function cls:smashDiamondsIntoReel()
    self:dealMusic_FadeLoopMusic(0.2, 1, 0.3)
    local laterDelay = addDiamondsCnt* nextDiamondsDelay + onDiamondsTime

    local endCol = 5
    local maxRow = 4
    local file = self:getPic("spine/base/baoxianxiangjinchang")

    self:playMusic(self.audio_list.add100wild)
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
            self:addSpineAnimation(self.animateNode, zOrder, file, pos, "animation")
        end),
        cc.DelayTime:create(nextDiamondsDelay)
    ),addDiamondsCnt))

    self:laterCallBack(laterDelay,function ()
        self:showSmashDiamondTip()
        self.animateNode:removeAllChildren()
        self.firstFreeGameTrigger = nil
    end)
end

function cls:showSmashDiamondTip()
    local dialog = cc.CSLoader:createNode(self:getPic("csb/add_100_wild.csb"))--  加载 进入respin 的弹板
    local rootNode  = dialog:getChildByName("root")

    self.freeFeatrueDialogN:addChild(dialog)

    self:playMusic(self.audio_list.wild_tip)

    self.freeFeatureDimmer:setVisible(true)
    self.freeFeatureDimmer:setOpacity(0)
    self:dialogPlayLineAnim("show", self.freeFeatureDimmer, rootNode)

    dialog:runAction(cc.Sequence:create(
        cc.DelayTime:create(2),
        cc.CallFunc:create(function ()
            self:dialogPlayLineAnim("hide", self.freeFeatureDimmer, rootNode) -- 关闭弹窗
        end),
        cc.DelayTime:create(1),
        cc.RemoveSelf:create()
    ))
end


---------------------- symbol 动画相setCollectScaleByValue关 ----------------------
function cls:playBackBaseGameSpecialAnimation(theSpecials, enterType)
    self:playFreeSpinItemAnimation(theSpecials, enterType)
end

function cls:playFreeSpinItemAnimation(theSpecials, enterType)
	local delay = 2

	if enterType and enterType == "more_free_spin" then return 0 end
	if not theSpecials or (not theSpecials[specialSymbol.scatter]) then return 0 end
	if enterType then
		self:playMusic(self.audio_list.trigger_bell)
	end
	for col, rowTagList in pairs(theSpecials[specialSymbol.scatter]) do
		for row, tagValue in pairs(rowTagList) do
			self:addItemSpine(specialSymbol.scatter, col, row)
		end
	end
    return delay
end

function cls:addItemSpine(item, col, row, animName, isNotLoop)
    local layer = self.animateNode
    local animName = animName or "animation"
    local isLoop = not isNotLoop
    local pos = self:getCellPos(col, row)
    local key = item % 100
    local spineFile = self:getPic("spine/item/" .. key .. "/spine")
    local cell = self.spinLayer.spins[col]:getRetCell(row)
    cell:setVisible(false)
    local _, s1 = self:addSpineAnimation(layer, 100, spineFile, pos, animName, nil, nil, nil, true, isLoop)
end

function cls:playBonusItemAnimate(itemList)
    local itemList = itemList or (self.ctl.rets.item_list or {})
    for col, list in pairs(itemList) do
        if col == 3 then
            for row, key in pairs(list) do
                if key % 100 == specialSymbol.bonus then
                    self:addItemSpine(specialSymbol.bonus, col, row, "animation")-- 播放symbol 动画
                end
            end
        end
    end
end

function cls:playBonusAnimate(theGameData) -- 播放 bonus symbol 动画  同时 播放 开始弹窗
    if theGameData.type == PowerOfDragonsBonusType.WHEEL then
        return 0
    end
    if self.buyBackData then return 0 end
    local delay = 2
    self.ctl.footer:setSpinButtonState(true)
    self:playMusic(self.audio_list.trigger_bell)
    self:stopAllLoopMusic()

    if theGameData.type == PowerOfDragonsBonusType.PICK then
        self:playBonusItemAnimate()
    end

    return delay
end

function cls:playSAllAnimation(item, col)
    local fs = 60
    local objOp = 0
    local animate = cc.Sequence:create(
        cc.DelayTime:create(2/fs),
        cc.ScaleTo:create(26/fs,1.15),
        cc.DelayTime:create(2/fs),
        cc.ScaleTo:create(26/fs,1),
        cc.DelayTime:create(2/fs))
    return cc.Sequence:create(animate, animate:clone())
end

function cls:getItemAnimate(item, col, row, effectStatus, parent)
    -- 重新给 parent  节点 不在使用draw
    local spineItemsSet = Set({ 1, 2, 3, 4, 5, 6})
    item = item % 100
    if self.stickyWildList and self.stickyWildList[col] and bole.isValidNode(self.stickyWildList[col][row]) then
        bole.spChangeAnimation(self.stickyWildList[col][row], "animation")
    elseif spineItemsSet[item] then
        if effectStatus == "all_first" then
            self:playItemAnimation(item, col, row)
        else
            self:playOldAnimation(col, row)
        end
        return nil
    else
        return self:playSAllAnimation(item, col)
    end
end

function cls:playItemAnimation(item, col, row)
    -- 修改这个方法，让有动画的symbol 在animationNode上面播放动画
    local animateName = "animation"
    local fileName = item % 100
    if fileName == specialSymbol.wild then
        fileName = specialSymbol.wild
    end
    ------------------------------------------------------------------
    local cell = self.spinLayer.spins[col]:getRetCell(row)
    local pos = self:getCellPos(col, row)
    local spineFile = self:getPic("spine/item/" .. fileName .. "/spine")
    local _, s1 = self:addSpineAnimation(self.animateNode, 1, spineFile, pos, animateName, nil, nil, nil, true)

    self.animNodeList = self.animNodeList or {}

    self.animNodeList[col .. "_" .. row] = {}
    self.animNodeList[col .. "_" .. row][1] = s1
    self.animNodeList[col .. "_" .. row][2] = animateName
    cell:setVisible(false)
end

function cls:playOldAnimation(col, row)
    self.animNodeList = self.animNodeList or {}
    if self.animNodeList[col .. "_" .. row] then
        local node = self.animNodeList[col .. "_" .. row][1]
        local animationName = self.animNodeList[col .. "_" .. row][2]

        if bole.isValidNode(node) and animationName then
            bole.spChangeAnimation(node, animationName, false)
        end
    end
end

function cls:drawLinesThemeAnimate( lines, layer, rets, specials)
    local timeList = {2,2}
    Theme.drawLinesThemeAnimate(self, lines, layer, rets, specials,timeList)
end

function cls:playSymbolNotifyEffect(pCol, reelSymbolState)
    for key, list in pairs(self.notifyState[pCol]) do
        for _, crPos in pairs(list) do
            local cell = nil
            if self.fastStopMusicTag then
                cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2])
            else
                cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2] + 2)
            end
            if cell then
                local animateName = "animation1"
                local fileName = key % 100

                local spineFile = self:getPic("spine/item/" .. fileName .. "/spine")
                local _, s = self:addSpineAnimation(cell, 22, spineFile, cc.p(0, 0), animateName, nil, nil, nil, true)
                cell.sprite:setVisible(false)
                cell.symbolTipAnim = s
            end
        end
    end
end

------------------------------------ store start --------------------------------------------
-- 初始化商店点击事件
function cls:initStoreEvents()
    -- 左移动按钮
    local function leftEvent(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            self.storeLeftBtn:setTouchEnabled(false)
            self:playMovePages(1)
        end
    end
    self.storeLeftBtn:addTouchEventListener(leftEvent)
    -- 右移动按钮 整体往左移动
    local function rightEvent(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            self.storeRightBtn:setTouchEnabled(false)
            self:playMovePages(-1)
        end
    end
    self.storeRightBtn:addTouchEventListener(rightEvent)

    -- 关闭按钮
    local function closeEvent(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            self.storeCloseBtn:setTouchEnabled(false)
            self:closeCurPageBtnEvent()
            self:closeOtherPageBtnEvent()

            self:playMusic(self.audio_list.common_click)	-- 播放点击音乐

            self:closeFeatureNode()
            self.ctl.footer:setSpinButtonState(false) -- 开启 footer按钮
            self.ctl.footer:enableOtherBtns(true)

        end
    end
    self.storeCloseBtn:addTouchEventListener(closeEvent)

    self:closeOtherPageBtnEvent()
end
-- 商店翻页动画
local featureMoveTM = 0.3
local featureMoveDis = 20
function cls:playMovePages(moveType)
    -- moveType (1 代表向左) (-1 代表向右)
    self:playMusic(self.audio_list.shop_click)    -- 播放点击音乐
    self.storeRightBtn:setTouchEnabled(false)
    self.storeRightBtn:setTouchEnabled(false)

    local curID = self.storeCurPagesID
    local nextID = self.storeCurPagesID + (-moveType)
    if nextID == storePagesCnt + 1 then
        nextID = 1
    end
    if nextID == 0 then
        nextID = storePagesCnt
    end

    local pageCurNode = self.storePages[curID].node
    local pageCurDesc = self.storeCharacterNode[curID]
    local pageNextNode = self.storePages[nextID].node
    local pageNextDesc = self.storeCharacterNode[nextID]
    self.storeCurPagesID = nextID
    self:closeCurPageBtnEvent(curID)
    bole.setEnableRecursiveCascading(pageCurNode, true)
    bole.setEnableRecursiveCascading(pageCurDesc, true)
    bole.setEnableRecursiveCascading(pageNextNode, true)
    bole.setEnableRecursiveCascading(pageNextDesc, true)

    local lockStatus = function()
        local showLevel = self.shopInfo.level[nextID]
        local playUnlockAnim = false
        if showLevel < 4 then
            if not self.storeLock4Status then
                self.storeLock4:setVisible(true)
                bole.spChangeAnimation(self.storeLock4, "animation2", false)
                self.storeLock4Status = true
            end
            if showLevel < 2 then
                if not self.storeLock2Status then
                    self.storeLock2:setVisible(true)
                    bole.spChangeAnimation(self.storeLock2, "animation1", false)
                    self.storeLock2Status = true
                end

            else
                if self.storeLock2Status then
                    bole.spChangeAnimation(self.storeLock2, "animation1_1", false) -- 解锁
                    self.storeLock2Status = false
                    playUnlockAnim = true
                end
            end
        else
            if self.storeLock4Status then
                bole.spChangeAnimation(self.storeLock4, "animation2_1", false)
                self.storeLock4Status = false
                playUnlockAnim = true
            end
            if self.storeLock2Status then
                self.storeLock2:stopAllActions()
                bole.spChangeAnimation(self.storeLock2, "animation1_1", false)
                self.storeLock2Status = false
                playUnlockAnim = true
            end
        end
        if playUnlockAnim then
            self:playMusic(self.audio_list.shop_unlock)
        end
    end

    lockStatus()
    -- curhide
    local f1 = cc.CallFunc:create(function()
        local a1 = cc.MoveTo:create(featureMoveTM, cc.p(moveType * featureMoveDis, 0))
        local a2 = cc.FadeOut:create(featureMoveTM)
        pageCurNode:runAction(cc.Spawn:create(a1, a2))
        local b1 = cc.MoveTo:create(featureMoveTM, cc.p(moveType * featureMoveDis, 0))
        local b2 = cc.FadeOut:create(featureMoveTM)

        pageCurDesc:runAction(cc.Spawn:create(b1, b2))

        self.storeProgressNodes[curID]:setVisible(false)

    end)
    pageNextDesc:setOpacity(0)
    pageNextNode:setOpacity(0)
    pageNextNode:setVisible(true)
    pageNextDesc:setVisible(true)

    local f2 = cc.CallFunc:create(function()
        self.storeProgressNodes[nextID]:setVisible(true)
        pageNextNode:setPosition((-moveType) * featureMoveDis, 0)
        pageNextDesc:setPosition((-moveType) * featureMoveDis, 0)
        local c1 = cc.MoveTo:create(featureMoveTM, cc.p(moveType * featureMoveDis / 2, 0))
        local c2 = cc.FadeIn:create(featureMoveTM)
        local c3 = cc.MoveTo:create(featureMoveTM / 2, cc.p(0, 0))

        local d1 = cc.MoveTo:create(featureMoveTM, cc.p(moveType * featureMoveDis / 2, 0))

        local d2 = cc.FadeIn:create(featureMoveTM)
        local d3 = cc.MoveTo:create(featureMoveTM / 2, cc.p(0, 0))
        pageNextNode:runAction(cc.Sequence:create(cc.Spawn:create(c1, c2), c3, cc.CallFunc:create(function(...)
            pageCurNode:setVisible(false)
            pageCurDesc:setVisible(false)
            self:showCurPage()
        end)))
        pageNextDesc:runAction(cc.Sequence:create(cc.Spawn:create(d1, d2), d3))
    end)
    self:runAction(cc.Sequence:create(f1, cc.DelayTime:create(0.1), f2))


end
--更新商店数据
function cls:updatePagesDate()
    for id, list in pairs(self.storePages) do
        list.node:setVisible(false)
        local person_level = self.shopInfo.level[id]
        for i, item in pairs(list.items) do
            local itemData
            if self.featureData.map.price then
                itemData = {}
                itemData.price = self.featureData.map.price[id][person_level][i]
                itemData.value = self.featureData.map.value[id][person_level][i]
                itemData.type = self.featureData.map.type[id][person_level][i]
            else
                itemData = self.featureData.map[id][person_level][i]
            end
            if itemData.type ~= item.itemData.type then
                self:updatePageItem(id, i, item, itemData)
            end
        end
    end
    for _, v in pairs(self.storeProgressNodes) do
        v:setVisible(false)
    end
    for _, v in pairs(self.levelStarNodeList) do
        v:setVisible(false)
    end
    self.levelLabel:setString("")

end

--商店当前页面
function cls:showCurPage(firstopen)
    self:updateMoveBtnState()
    self:openCurPageBtnEvent()
    if firstopen then
        for i = 1, #self.storePages do
            local page = self.storePages[i]
            page.node:setVisible(false)
            page.node:setOpacity(255)
        end
        for i = 1, #self.storeCharacterNode do
            self.storeCharacterNode[i]:setVisible(false)
            self.storeCharacterNode[i]:setOpacity(255)
        end
    end
    self.storeProgressNodes[self.storeCurPagesID]:setVisible(true)
    self.storeCharacterNode[self.storeCurPagesID]:setVisible(true)
    local showLevel = 0
    if self.shopInfo and self.shopInfo.level and self.shopInfo.level[self.storeCurPagesID] then
        showLevel = self.shopInfo.level[self.storeCurPagesID]
    end
    for i = 1, onePageLevelCnt do
        if showLevel >= i then
            self.levelStarNodeList[i]:setVisible(true)
        else
            self.levelStarNodeList[i]:setVisible(false)
        end
    end

    if showLevel > 0 then
        self.levelLabel:setString(showLevel)
    end
    if showLevel < 4 then
        if not self.storeLock4Status then
            self.storeLock4:setVisible(true)
            self.storeLock4:stopAllActions()
            bole.spChangeAnimation(self.storeLock4, "animation2", false) -- 静帧
            self.storeLock4Status = true
        end
        if showLevel < 2 then
            if not self.storeLock2Status then
                self.storeLock2:setVisible(true)
                self.storeLock2:stopAllActions()
                bole.spChangeAnimation(self.storeLock2, "animation1", false) -- 静帧
                self.storeLock2Status = true
            end

        else
            if self.storeLock2Status then
                self.storeLock2:setVisible(false)
                self.storeLock2Status = false
            end
        end
    else
        if self.storeLock4Status then
            self.storeLock4:setVisible(false)

            self.storeLock4Status = false
        end
        if self.storeLock2Status then
            self.storeLock2:setVisible(false)
            self.storeLock2Status = false
        end

    end

    local page = self.storePages[self.storeCurPagesID]
    page.node:setVisible(true)
    page.node:setPosition(0, 0)
    local stuff = self.shopInfo.stuff[self.storeCurPagesID]
    for i = 1, onePageBuffCnt do
        local buffItem = self.buffListNode[i]:getChildByName("item")
        local buffBg = self.buffListNode[i]:getChildByName("bg")
        local buffName = "#theme177_collect_material" .. self.storeCurPagesID .. "_" .. i .. ".png"
        bole.updateSpriteWithFile(buffItem, buffName)
        if stuff[i] == 1 then
            self.buffListNode[i]:setColor(cc.c3b(255, 255, 255))
            bole.updateSpriteWithFile(buffBg, "#theme177_collect_itemb_"..self.storeCurPagesID..".png")
            buffItem:setVisible(true)
        else
            buffItem:setVisible(false)
            bole.updateSpriteWithFile(buffBg, "#theme177_collect_itemb_"..self.storeCurPagesID..".png")
            self.buffListNode[i]:setColor(cc.c3b(95, 95, 95))
        end
    end
    page.node:setOpacity(255)
end

function cls:createFeatureNode()
    local storenode = self:getPic(allCsbList.store);
    self.coinStore = cc.CSLoader:createNode(storenode)--  加载 商店显示
    bole.scene:addToContentFooter(self.coinStore)
    self.clawStoreBG = self.coinStore:getChildByName("bg")
    self.clawStoreRootNode = self.coinStore:getChildByName("root")

    self.storeRightBtn = self.clawStoreRootNode:getChildByName("btn_right")
    self.storeLeftBtn = self.clawStoreRootNode:getChildByName("btn_left")
    self.storeCloseBtn = self.clawStoreRootNode:getChildByName("btn_close")
    self.storeClawCoins = self.clawStoreRootNode:getChildByName("claw_coins")
    self.itemTipNode = self.clawStoreRootNode:getChildByName("tipNode")
    self.itemTipCloseBtn = self.itemTipNode:getChildByName("tip_close_btn")
    self.itemTipSp = self.itemTipNode:getChildByName("tip")
    self:initItemTipEvent()
    self.itemTipNode:setVisible(false)
    self.itemTipCloseBtn:setVisible(false)
    -- progress_floor
    self.progressFloor = self.clawStoreRootNode:getChildByName("progress_floor")
    self.progressNode = self.clawStoreRootNode:getChildByName("progress_node")
    self:createProgressChild(self.progressFloor, self.progressNode)
    self.storeProgressNodes = self.progressNode:getChildren()

    --level
    self.levelStarNode = self.clawStoreRootNode:getChildByName("level_star")

    self:createStarList(self.levelStarNode)
    self.levelStarNodeList = self.levelStarNode:getChildren()

    self.levelLabel = self.clawStoreRootNode:getChildByName("label_level")
    self.storeAniNode = self.clawStoreRootNode:getChildByName("ani_node")

    --item list
    local pageRoot = self.clawStoreRootNode:getChildByName("clip"):getChildByName("page_root")
    self.storePages = {}
    self.storePagesBtn = {}
    for id, v in pairs(pageRoot:getChildren()) do
        self.storePages[id] = {}
        self.storePages[id]["node"] = v
        local pagesItemsRoot = v:getChildByName("claw_Items")
        self.storePages[id]["items"] = {}
        self.storePagesBtn[id] = {}
        local person_level = 1
        if self.shopInfo and self.shopInfo.level and self.shopInfo.level[id] then
            person_level = self.shopInfo.level[id]
        end
        for i = 1, onePageItemCnt do
            local itemData
            if self.featureData.map.price then
                itemData = {}
                itemData.price = self.featureData.map.price[id][person_level][i]
                itemData.value = self.featureData.map.value[id][person_level][i]
                itemData.type = self.featureData.map.type[id][person_level][i]
            else
                itemData = self.featureData.map[id][person_level][i]
            end

            if itemData then
                local item = cc.Node:create()
                self:updatePageItem(id, i, item, itemData)
                pagesItemsRoot:addChild(item)
                table.insert(self.storePages[id]["items"], item)
            end
        end
    end
    local pageRoot1 = self.clawStoreRootNode:getChildByName("page_root_1")

    --lock
    local _, s1 = self:addSpineAnimation(pageRoot1, nil, self:getPic("spine/store/lock_tip/spine"), cc.p(-1, -175), "animation1", nil, nil, nil, true)
    self.storeLock2 = s1
    local _, s2 = self:addSpineAnimation(pageRoot1, nil, self:getPic("spine/store/lock_tip/spine"), cc.p(-1, -310), "animation2", nil, nil, nil, true)
    self.storeLock4 = s2
    self.storeLock2:setVisible(false)
    self.storeLock4:setVisible(false)
    self.storeLock2Status = false
    self.storeLock4Status = false

    self.buffListNode = pageRoot1:getChildByName("tools"):getChildren()

    self.storeParentChar = pageRoot1:getChildByName("character")
    self.storeCharacterNode = self.storeParentChar:getChildren()
    for page, item in pairs(self.storeCharacterNode) do
        local level = self.shopInfo.level[page] or 1
        self:updateStoreChar(item, page, level)
        --local
        local unlock = bole.createSpriteWithFile("#theme177_collect_unlocktext.png")
        item:addChild(unlock, 20)
        unlock:setVisible(false)
        unlock:setPositionY(223)
        unlock:setName("unlock")
        item.unlock = unlock
        local nameNode = item:getChildByName("name")
        local name_index = page
        local name_img = "#theme177_collect_name" .. name_index .. ".png"
        bole.updateSpriteWithFile(nameNode,name_img)

    end

    self:initStoreEvents()
end

function cls:getShowCurStage()

    if not self.storeCurPagesID then
        return self.shopInfo.index
    else
        return self.storeCurPagesID
    end
end

function cls:checkInFeature() -- whj: 作用在 feature 结束重新打开商店,时候控制锁住bet控制
    local inFeature = false
    if self.isOpenStoreNode then 
        inFeature = true
    end
    return inFeature
end

function cls:showFeatureNode()
    -- 隐藏B级活动栏
    if self.ctl.footer then
        self.ctl.footer:hideActivitysNode()
    end

    self.isOpenStoreNode = true
    self.isFeatureClick = true
    self.ctl.footer:setSpinButtonState(true) -- 禁用 footer按钮
    self.ctl.footer:enableOtherBtns(false) -- 禁掉 其他按钮
    self:playMusic(self.audio_list.shop_show)
    if not self.coinStore then
        self:createFeatureNode()
    end
    self.storeCurPagesID = self:getShowCurStage()

    self:updatePagesDate()

    self.coinStore:setVisible(true)
    self.clawStoreBG:setOpacity(0)
    self.clawStoreBG:runAction(cc.FadeTo:create(0.3, 180))
    self.clawStoreRootNode:setScale(0)
    self.clawStoreRootNode:runAction(cc.ScaleTo:create(0.3, 1))

    self.showClawTip = false

    self:updateCurPageState()
    self:openOtherPageBtnEvent()
    self:showCurPage(true)
    if self.featurePoints == nil then
        self.featurePoints = 0

    end

    self.storeClawCoins:setString(FONTS.format(self.featurePoints, true))
    bole.shrinkLabel(self.storeClawCoins, inStoreCoinsMaxWidth, self.storeClawCoins:getScale())
end

function cls:changeTipState()
    if self.showTip then
        self.showTip = false
        self.storeTipNode:stopAllActions()
        self.storeTipNode:runAction(cc.FadeTo:create(0.3, 0))
    else
        self.showTip = true
        self.storeTipNode:stopAllActions()
        self.storeTipNode:runAction(cc.FadeTo:create(0.3, 255))
    end
end
function cls:updateMoveBtnState()
    self.storeLeftBtn:setBright(true)
    self.storeLeftBtn:setTouchEnabled(true)
    self.storeRightBtn:setBright(true)
    self.storeRightBtn:setTouchEnabled(true)
end

function cls:createProgressChild(floor, parent)
    local progressConfig = coinItemConfig[4]
    for i = 1, progressConfig.cnt do
        local s1 = cc.Sprite:create()
        bole.updateSpriteWithFile(s1, progressConfig.bg) -- todo 改成正确的动画
        s1.name = "bg" .. i
        floor:addChild(s1)
        s1:setPosition(cc.pAdd(progressConfig.base_pos, cc.p(progressConfig.padding * (i - 1), 0)))

        local s2 = cc.Sprite:create()
        bole.updateSpriteWithFile(s2, progressConfig.choose) -- todo 改成正确的动画
        s2.name = "page" .. i
        parent:addChild(s2)
        s2:setPosition(cc.pAdd(progressConfig.base_pos, cc.p(progressConfig.padding * (i - 1), 0)))
    end
end

function cls:createStarList(parent)
    local starConfig = coinItemConfig[5]
    for i = 1, starConfig.cnt do
        local s2 = cc.Sprite:create()
        bole.updateSpriteWithFile(s2, starConfig.star) -- todo 改成正确的动画
        s2.name = "star" .. i
        parent:addChild(s2)
        s2:setPosition(cc.pAdd(starConfig.base_pos, cc.p(starConfig.padding * (i - 1), 0)))
    end
end

-- type: 0代表不可购买，1代表可以购买，2代表已经购买
-- value: 代表的是当前页商品的状态，0代表还未被购买, 100是fg, 200是pick, 其他是钱
-- value_list: 代表本页商品的所有购买项, 第一级只能购买3个商品，所以value_list长度只有3
local levelLockConfig = { [1] = 3, [2] = 6, [3] = 6, [4] = 9, [5] = 9 }
function cls:updatePageItem(id, i, node, itemData)
    itemData["pageID"] = id
    itemData["pos"] = i
    local itemConfig = coinItemConfig[itemData.type]
    if itemData.type == 2 then
        local valueType = 3
        if itemData.value == 100 then
            valueType = 1
        elseif itemData.value == 200 then
            valueType = 2
        end
        itemConfig = itemConfig[valueType]
    end

    if itemConfig.bg then
        local sp = node.bg
        if not sp then
            sp = bole.createSpriteWithFile(itemConfig.bg[1])
            sp:setPosition(itemConfig.bg[2])
            node.bg = sp
            node:addChild(sp, itemConfig.bg[5])
            node:setName("bg")
        end
        if itemConfig.bg[4] then
            sp:setColor(itemConfig.bg[4])
        end
    end

    if itemConfig.spine then
        if node.spine then
            node.spine:removeFromParent()
            node.spine = nil
        end
        local _, s = self:addSpineAnimation(node, itemConfig.spine[5], self:getPic(itemConfig.spine[1]), itemConfig.spine[2], (itemConfig.spine[3] or "animation1"), nil, nil, nil, true, itemConfig.spine[4])
        node.spine = s
        node:setName("spine")

        if itemData.type == 1 then
            local needprice = itemData.price
            if self.shopInfo.stuff[id][5] == 1 then
                needprice = needprice - 200
            end
            if needprice > self.featurePoints and bole.isValidNode(node.spine) then
                bole.spChangeAnimation(node.spine, "animation2", false)
            end
        end
    end

    if itemConfig.sp then
        local sp
        if node.sp then
            node.sp:removeFromParent(true)
            node.sp = true
        end
        for k, v in pairs(itemConfig.sp) do
            if k == 1 then
                sp = bole.createSpriteWithFile(v[1])
                sp:setPosition(v[2])
                node:addChild(sp, v[5])
                node:setName("sp")
                node.sp = sp
                if v[3] then
                    sp:setScale(v[3])
                end
                if v[4] then
                    node:setColor(v[4])
                end
            else
                local sp2 = bole.createSpriteWithFile(v[1])
                sp:addChild(sp2)
                sp2:setPosition(v[2])
            end
        end
    end

    if itemConfig.label then
        if node.lb then
            node.lb:removeFromParent()
            node.lb = nil
        end
        local str = itemData.price
        if itemData.type == 2 then
            str = FONTS.formatByCount4(itemData.value, 4, true)
        else
            str = FONTS.format(itemData.price, true)
        end

        local lb = cc.Label:createWithBMFont(self:getPic(itemConfig.label[1]), str)
        if itemConfig.label[3] then
            lb:setScale(itemConfig.label[3])
        end
        lb:setPosition(itemConfig.label[2])
        lb:setName("label")
        node.lb = lb
        node:addChild(lb, itemConfig.label[5])
    end

    if itemConfig.btn then
        local touchFunc = function(...)
            if self.itemBtnTouchOver then
                return
            end
            local needprice = itemData.price
            if self.shopInfo.stuff[id][5] == 1 then
                needprice = needprice - 200
            end
            if needprice > self.featurePoints then
                self:showNotEnoughPoints(node)
            else
                self.itemBtnTouchOver = true
                self:playMusic(self.audio_list.common_click) -- 播放点击音效
                self:clickItemOver(node, itemData)-- 更新显示的进度
            end
        end

        local touchBtn = Widget.newButton(touchFunc, itemConfig.btn[1], itemConfig.btn[1], itemConfig.btn[1], false)
        touchBtn:setTouchEnabled(false)
        touchBtn:setPosition(itemConfig.btn[2])
        touchBtn:setScale(itemConfig.btn[3])
        node:addChild(touchBtn, itemConfig.btn[5])
        node.btn = touchBtn
        self.storePagesBtn[id][i] = touchBtn
        touchBtn:setName("btn")
    end
    local col = 1 + (i - 1) % 3
    local row = 1 + math.floor((i - 1) / 3)
    local pos = cc.pAdd(coinItemBasePos, cc.p((col - 1) * coinItemSingleWidth, (row - 1) * (-coinItemSingleHeight)))
    node:setPosition(pos)
    node.itemData = itemData
end

-- 关于商店的需要给你说一下，如果只是单纯打开商店切换切换人物但是不购买商品的话，我给你返回的special_type是5
-- 购买到fg的special_type是1
-- 购买到pick的special_type是2
-- 购买的金币的special_type是3
-- 当前页商品全部购买完的special_type是4

--关闭商店界面
function cls:closeFeatureNode()
    self.isOpenStoreNode = false
    if not self.coinStore or not self.coinStore:isVisible() then
        return
    end
    local showlevel = self.storeCurPagesID
    if showlevel > 3 and showlevel > self.featureData.unlock_type then

        if self.featureData.unlock_type >= 3 then
            showlevel = self.featureData.unlock_type
        else
            showlevel = 3
        end

    end
    self.curClickData = {
        ["page"] = showlevel,
        ["pos"] = -1,
    }
    self.storeCurPagesID = showlevel
    self:resetBaseCharacter(showlevel)
    self.curItem = nil
    self.ctl:themeBuySpecial(self.curClickData)
    self:playMusic(self.audio_list.shop_close)
    if not self.buyBackData then
        self.isFeatureClick = false
    end
    self.clawStoreBG:stopAllActions()
    self.coinStore:setVisible(true)
    self.clawStoreRootNode:stopAllActions()
    self.clawStoreBG:runAction(cc.FadeTo:create(0.3, 0))
    self.clawStoreRootNode:runAction(cc.Sequence:create(cc.ScaleTo:create(0.3, 0), cc.CallFunc:create(function(...)
        self.coinStore:setVisible(false)
    end)))

    -- 显示B级活动栏
    if self.ctl.footer then
        self.ctl.footer:showActivitysNode()
    end
end

function cls:clickItemOver(item, itemData)
    -- 发送协议 向服务器
    self:closeCurPageBtnEvent()
    self:closeOtherPageBtnEvent()
    self.curClickData = {
        ["page"] = itemData["pageID"],
        ["pos"] = itemData["pos"],
    }
    self.curItem = item
    self.ctl:themeBuySpecial(self.curClickData)
end
--商店点击购买
function cls:collectFreeRollEnd()
    if self.buyBackData then
        self:playJackpotGame(self.buyBackData)
        self.buyBackData = nil
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),
            cc.CallFunc:create(
                function()
                    self.ctl.footer:setSpinButtonState(true) -- 禁用 footer按钮
                    self.ctl.footer:enableOtherBtns(false) -- 禁掉 其他按钮
                end)))
    end

end

function cls:playJackpotGame(theGameData, endCallfunc)
    self.isFeatureClick = true
    local delay = 0
    local nextFunc = function(...)
        self.featureData.map = tool.tableClone(theGameData["map"])
        self:showFeatureNode()
    end
    if endCallfunc then
        endCallfunc()
    end

    if theGameData["unlock_type"] > self.featureData.unlock_type then
        self.featureData.unlock_type = theGameData["unlock_type"]
        self.storeCurPagesID = self.featureData.unlock_type
        nextFunc()
    else
        nextFunc()
    end

end

-- todo
function cls:overBuySpecialItem(data)
    if type(data) == "number" then
        return
    end
    if not self.curItem then
        return
    end
    local nextFunc = nil
    self.buyBackData = nil
    local nextDelay = 0
    local overFunc = function(...)
        self:updateCurPageState()
        self:openCurPageBtnEvent()
        self:openOtherPageBtnEvent()
    end
    if data.special_type == 1 then -- fg
        self.ctl.specials = nil
        nextDelay = 1
        self.buyBackData = {
            ["unlock_type"] = data["unlock_type"],
            ["map"] = data["map"]
        }
        self.superAvgBet = data["free_game"].super_bet
        self.freeAddSpinsBuff = data.free_game.add_spins and data.free_game.add_spins > 0
        self.freeAddWildsBuff = data.free_game.add_wild and data.free_game.add_wild > 0

        nextFunc = function()
            self.ctl.rets = {}
            self.ctl.rets.free_spins = data.free_game.free_spins
            self.ctl.rets.free_game = data.free_game
            self.ctl.totalWin = 0
            self.ctl.footer:reSetWinCoinsString(0)-- footer 进行加钱

            overFunc()
            self:closeFeatureNode()
            self.ctl:handleResult()
            self:stopAllLoopMusic()
        end
    elseif data.special_type == 2 then  -- pick
        nextDelay = 1
        self.ctl.specials = nil
        self.buyBackData = {
            ["unlock_type"] = data["unlock_type"],
            ["map"] = data["map"]
        }
        self.superAvgBet = data["bonus_game"].super_bet

        nextFunc = function()
            self.ctl.rets = {}
            self.ctl.totalWin = 0
            self.ctl.rets["win_type"] = nil
            self.ctl.rets["total_win"] = 0
            self.ctl.rets.bonus_game = data.bonus_game

            overFunc()
            self:closeFeatureNode()
            self.ctl:handleResult()
            self:stopAllLoopMusic()
        end
    elseif data.special_type == 3 then -- coins
        nextDelay = 0.5
        nextFunc = function()
            self.ctl.footer:setWinCoins(data.item_data["value"], 0, 0)-- footer 进行加钱
            User:getInstance():addCoins(data.item_data["value"])
            self.featureData.map = tool.tableClone(data["map"])
            self.featureData.unlock_type = data["unlock_type"]
            overFunc()
        end
    elseif data.special_type == 4 then -- 当前页商品全部购买完的special_type是4
        nextDelay = 1.5
        self.ctl.specials = nil
        self.buyBackData = {
            ["unlock_type"] = data["unlock_type"],
            ["map"] = data["map"],
        }
        if data.item_data.type == 2 then
            self.ctl.footer:setWinCoins(data.item_data["value"], 0, 0)-- footer 进行加钱
            User:getInstance():addCoins(data.item_data["value"])
            self.featureData.map = tool.tableClone(data["map"])
            self.featureData.unlock_type = data["unlock_type"]
            self.buyBackData = nil
        end

        nextFunc = function()
            self.ctl.rets = {}
            self.ctl.totalWin = 0
            self.shopInfo = data["shop_info"]
            self.featureData.map = tool.tableClone(data["map"])
            self.featureData.unlock_type = data["unlock_type"]
            local function enterCallFunc()
                self.ctl.footer:setSpinButtonState(true) -- 禁用spin 按钮
                self.ctl.footer:enableOtherBtns(false)
                --commonMusic
                self:dealMusic_FadeLoopMusic(0.3, 1, 0.1)
                self:playLevelUpWinShopMusic()
            end
            local collectClick = function(...)
                self.ctl.footer:setWinCoins(data.total_win, 0, 0) -- 添加金额到 footer
                User:getInstance():addCoins(data.total_win)
                if self.coinStore then
                    overFunc()
                end
                self:laterCallBack(1, function()
                    self:dealMusic_FadeLoopMusic(0.3, 0.3, 1)-- 恢复背景音乐
                end)

            end
            local theData = { ["coins"] = data.total_win, ["enter_event"] = enterCallFunc, ["click_event"] = collectClick }

            --3 界面刷新
            self:playMusic(self.audio_list.refresh)
            self:updatePagesDate()
            self:updateCurPageState()
            self:showCurPage(false)
            self:levelUpStoreCha()
            --4 弹出弹出窗
            self:runAction(cc.Sequence:create(
                    cc.DelayTime:create(1),
                    cc.CallFunc:create(function()
                        self:showFreeSpinDialog(theData, fs_show_type.collect, "store")
                    end)
            ))
        end
    end
    if data.special_type and data.item_data then
        self.curItem.itemData["type"] = data.item_data["type"]
        self.curItem.itemData["value"] = data.item_data["value"]
        -- 显示当前的item 数据
        self:updatePageItemByBuy(data, nextFunc, nextDelay)
    else
        overFunc()
    end

end

function cls:levelUpStoreCha()
    if self.shopInfo.complete[self.storeCurPagesID] < 1 then

        -- 1 人物升级动画
        local nextlevel = self.shopInfo.level[self.storeCurPagesID]

        self:addSpineAnimation(self.storeAniNode, 1, self:getPic("spine/store/level_up/spine"), cc.p(self.storeParentChar:getPosition()), "animation")
        self:playMusic(self.audio_list.level_up)

        -- 1 点亮星星
        local starx, stary = self.levelStarNodeList[nextlevel]:getPosition()
        local x, y = self.levelStarNodeList[nextlevel]:getPosition()
        self:addSpineAnimation(self.storeAniNode, 1, self:getPic("spine/store/star_light/spine"), cc.p(x, y), "animation2")
        self:runAction(cc.Sequence:create(
            cc.DelayTime:create(1),
            cc.CallFunc:create(function()
                self.levelStarNodeList[nextlevel]:setVisible(true)
            end)
        ))

    end
end

function cls:updateStoreChar(parent, page, level, scale)
    local level = self.shopInfo.level[page] or 1
    local getChild = parent:getChildByName("char_name")
    scale = scale or 1
    local spineFile = self:getPic("spine/character/" .. page .. "/spine")
    local _, s = self:addSpineAnimation(parent, 10, spineFile, cc.p(0,0), "animation", nil, nil, nil, true, true)
    s:setName("char_name")
    s.type = "spine"
end

local clipItemBasePos = cc.p(-305, -425)
function cls:updatePageItemByBuy(data, nextFunc, nextDelay)
    self.storePagesBtn[self.storeCurPagesID][self.curItem.itemData.pos] = nil
    self.curItem.btn = nil
    self.featurePoints = data.map_points

    self.collectCntLb:setString(FONTS.formatByCount4(self.featurePoints, storeCoinsMaxCnt, true))
    self.storeClawCoins:setString(FONTS.format(self.featurePoints, true))
    bole.shrinkLabel(self.storeClawCoins, inStoreCoinsMaxWidth, self.storeClawCoins:getScale())

    local itemConfig = coinItemConfig[self.curItem.itemData["type"]]
    local valueType = 3
    if self.curItem.itemData.value == 100 then
        valueType = 1
    elseif self.curItem.itemData.value == 200 then
        valueType = 2
    end
    itemConfig = itemConfig[valueType]

    if self.shopInfo.stuff[self.storeCurPagesID][5] == 1 then -- -200特效
        local realPrice = self.curItem.itemData.price - 200
        self.curItem.lb:setString(FONTS.format(realPrice, true))
        local x, y = self.curItem:getPosition()
        x = x + clipItemBasePos.x
        y = y - 45 + clipItemBasePos.y
        self:addSpineAnimation(self.storeAniNode, 1, self:getPic("spine/store/_200/spine"), cc.p(x, y), "animation", nil, nil, nil, true, false)
        self:playMusic(self.audio_list.reduce200)
    end
    local winMultiTime = 0
    if self.shopInfo.stuff[self.storeCurPagesID][1] == 1 and valueType == 3 then -- 赢钱翻倍
        winMultiTime = 0.5
        -- local pos = cc.pAdd(cc.p(self.curItem:getPosition()), clipItemBasePos)
        -- self:addSpineAnimation(self.storeAniNode, 1, self:getPic("spine/store/star_light/spine"), pos, "animation1")
        -- self:playMusic(self.audio_list.double)
    end

    if self.curItem.spine then
        bole.spChangeAnimation(self.curItem.spine, "animation", false)
    end
    self:playMusic(self.audio_list.open)

    self.curItem:runAction(cc.Sequence:create(
        cc.DelayTime:create(45/30),
        cc.CallFunc:create(function(...)
            if self.curItem.sp then
                self.curItem.sp:removeFromParent()
                self.curItem.sp = nil
            end
            if self.curItem.lb then
                self.curItem.lb:removeFromParent()
                self.curItem.lb = nil
            end
            if itemConfig.sp then
                local sp
                for k, v in pairs(itemConfig.sp) do
                    if k == 1 then
                        sp = bole.createSpriteWithFile(itemConfig.sp[1][1])
                        sp:setPosition(itemConfig.sp[1][2])
                        self.curItem:addChild(sp, itemConfig.sp[1][5])
                        self.curItem.sp = sp
                    else
                        local p2 = bole.createSpriteWithFile(itemConfig.sp[k][1])
                        sp:addChild(p2)
                        p2:setPosition(itemConfig.sp[k][2])
                    end
                end
            end
            if itemConfig.label then
                local winValue = (winMultiTime and winMultiTime > 0) and self.curItem.itemData.value/2 or self.curItem.itemData.value
                local lb = cc.Label:createWithBMFont(self:getPic(itemConfig.label[1]), FONTS.formatByCount4(winValue, 4, true))
                lb:setPosition(itemConfig.label[2])
                if itemConfig.label[3] then
                    lb:setScale(itemConfig.label[3])
                end
                self.curItem.lb = lb
                self.curItem:addChild(lb, itemConfig.label[5])

                if winMultiTime and winMultiTime > 0 then

                    lb:runAction(cc.Sequence:create(
                        cc.DelayTime:create(0.3),
                        cc.CallFunc:create(function ( ... )
                            local pos = cc.pAdd(cc.p(self.curItem:getPosition()), clipItemBasePos)
                            self:addSpineAnimation(self.storeAniNode, 1, self:getPic("spine/store/star_light/spine"), pos, "animation1")
                            self:playMusic(self.audio_list.double)
                        end),
                        cc.DelayTime:create(winMultiTime),
                        cc.CallFunc:create(function ( ... )
                            lb:setString(FONTS.formatByCount4(self.curItem.itemData.value, 4, true))
                        end)))
                end

            end
        end),
        cc.DelayTime:create((winMultiTime or 0) + nextDelay), -- 如果有翻倍的话是翻倍时间 +
        cc.CallFunc:create(function(...)

            if itemConfig.spine then
                if self.curItem.spine then
                    self.curItem.spine:removeFromParent()
                    self.curItem.spine = nil
                end
                local _, s = self:addSpineAnimation(self.curItem, itemConfig.spine[5], self:getPic(itemConfig.spine[1]), itemConfig.spine[2], (itemConfig.spine[3] or "animation"), nil, nil, nil, true, itemConfig.spine[4])
                self.curItem.spine = s
                self.curItem:setName("spine")
            end
            nextFunc()
        end)
    ))
end

function cls:updateCurPageState()
    -- 判断不能购买的时候显示为暗颜色
    local id = self.storeCurPagesID
    local items = self.storePages[id]["items"]--
    for page = 1, storePagesCnt do
        local items = self.storePages[page]["items"]
        local lock_status = 0
        for k, v in pairs(items) do
            if v.itemData["type"] == 1 then  -- 可购买状态
                if not v.btn and tolua.isnull(v.btn) then
                    v.btn = nil
                    self.storePagesBtn[id][k] = nil
                else
                    local realPrice = v.itemData.price
                    if self.shopInfo.stuff[page][5] and self.shopInfo.stuff[page][5] == 1 then
                        realPrice = realPrice - 200
                    end
                    if realPrice > self.featurePoints then
                        -- 锁上
                        local itemConfig = coinItemConfig[0]

                        if bole.isValidNode(v.spine) then
                            bole.spChangeAnimation(v.spine, "animation1_1", itemConfig.spine[4])
                            lock_status = 1
                        end
                    else
                        local itemConfig = coinItemConfig[1]
                        if bole.isValidNode(v.spine) then
                            bole.spChangeAnimation(v.spine, itemConfig.spine[3], itemConfig.spine[4])
                            lock_status = 2
                        end
                    end
                end

            end
        end

        if page == self.storeCurPagesID and lock_status > 0 then
            self:playMusic(self.audio_list.shop_lock) -- 播放 item 锁住音效
        end

        local showLock = true
        if page <= 3 then
            showLock = false
        else
            if self.featureData.unlock_type >= page then
                showLock = false
            end
        end
        self.storeCharacterNode[page].unlock:setVisible(showLock)
        if showLock then
            self.storeCharacterNode[page]:getChildByName("char_name"):setColor(cc.c3b(95, 95, 95))
        else
            self.storeCharacterNode[page]:getChildByName("char_name"):setColor(cc.c3b(255, 255, 255))
        end
    end

end

function cls:closeCurPageBtnEvent(ID)
    self.itemBtnTouchOver = true
    local ID = ID or self.storeCurPagesID
    local btnList = self.storePagesBtn[ID]
    for k = 1, onePageItemCnt do
        if btnList[k] then
            btnList[k]:setTouchEnabled(false)
        end
    end
end

function cls:openCurPageBtnEvent(ID)
    self.itemBtnTouchOver = false
    local ID = ID or self.storeCurPagesID
    local btnList = self.storePagesBtn[ID]
    for k = 1, onePageItemCnt do
        if btnList[k] then
            btnList[k]:setTouchEnabled(true)
        end
    end
end

function cls:openOtherPageBtnEvent(...)
    self:updateMoveBtnState()
    --self.storeTipBtn:setTouchEnabled(true)
    self.storeCloseBtn:setTouchEnabled(true)
end

function cls:closeOtherPageBtnEvent(...)
    self.storeRightBtn:setTouchEnabled(false)
    self.storeLeftBtn:setTouchEnabled(false)
    --self.storeTipBtn:setTouchEnabled(false)
    self.storeCloseBtn:setTouchEnabled(false)
end

function cls:itemTipBtnOnTouch(toClose)
    if toClose and self.curItemTipShow then
        self.itemTipCloseBtn:setVisible(false)
        self.curItemTipShow = false
        self.itemTipSp:stopAllActions()
        self.itemTipSp:runAction(cc.Sequence:create(
                cc.ScaleTo:create(0.5, 0),
                cc.CallFunc:create(function(...)
                    self.itemTipNode:setVisible(false)
                end)))
    elseif not self.curItemTipShow then
        -- 开启
        self.curItemTipShow = true
        self.itemTipSp:stopAllActions()
        self.itemTipNode:setVisible(true)
        self.itemTipSp:setScale(0)
        self.itemTipSp:runAction(cc.Sequence:create(
                cc.ScaleTo:create(0.5, 1),
                cc.CallFunc:create(function(...)
                    self.itemTipCloseBtn:setVisible(true)
                end),
                cc.DelayTime:create(2),
                cc.CallFunc:create(function(...)
                    self.curItemTipShow = false
                end),
                cc.ScaleTo:create(0.5, 0),
                cc.CallFunc:create(function(...)
                    self.itemTipNode:setVisible(false)
                end)))
    end
end
function cls:initItemTipEvent()
    local function onTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            self:itemTipBtnOnTouch(true)
            self:playMusic(self.audio_list.common_click)
        end
    end
    self.itemTipCloseBtn:addTouchEventListener(onTouch)-- 设置按钮
end
function cls:showNotEnoughPoints(parent)
    self.itemTipSp:setPosition(cc.pAdd(cc.p(parent:getPosition()), cc.p(0, 20)))
    self:itemTipBtnOnTouch(false)
end


----------------------------------- 弹窗通用显示效果 -----------------------------
function cls:dialogPlayLineAnim( state, dimmer, root )
    if state == "show" then
        dimmer:setOpacity(0)
        root:setScale(0)
        dimmer:runAction(cc.Sequence:create(cc.FadeTo:create(0.2, 200)))
        root:runAction(cc.Sequence:create(cc.ScaleTo:create(0.4, 1.2),cc.ScaleTo:create(0.1, 1)))
    else
        dimmer:setOpacity(200)
        root:setScale(1)
        dimmer:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.FadeTo:create(0.2, 0)))
        root:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1, 1.2),cc.ScaleTo:create(0.4, 0)))
    end
end
----------------------------------- 转轮相关 -----------------------------

function cls:getSpinColStartAction(pCol)
    if self.isTurbo then
        maxSpeed = fastSpeed
    else
        maxSpeed = normalSpeed
    end
    local spinAction = {}
    spinAction.delay = delay * (pCol - 1)
    spinAction.upBounce = upBounce
    spinAction.upBounceMaxSpeed = upBounceMaxSpeed
    spinAction.upBounceTime = upBounceTime
    spinAction.speedUpTime = speedUpTime
    spinAction.maxSpeed = maxSpeed

    return spinAction
end

local specialFeatureDelayStop = 0.5
function cls:getSpinColStopAction(themeInfo, pCol, interval)
    local checkNotifyTag   = self:checkNeedNotify(pCol)
    if checkNotifyTag then
        self.DelayStopTime = self.DelayStopTime + extraReelTime
    end

    local specialType
    if self.showBaseSpinBoard and self.winBonusWheelData then
        specialType = true
    end

    local function onSpecialTip( pcol) -- 展示弹窗
        if pcol == 1 then
            self.ctl.specialSpeed = true
            self:showWinWheelBonusDialog( "show" )
        end
    end

    local function onSpecialBegain( pcol) -- 显示转盘
        if pcol == 1 then
            self:playShowWheelNodeAnim( "show" )
        end
    end

    local function onSpecialFeatrue( pcol) -- 玩转盘 + 结算
        if pcol == 1 then
            self:playWheelBonusGame( specialType )
        end
    end

    local spinAction = {}
    spinAction.actions = {}

    local temp = interval - speedUpTime - upBounceTime
    local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0

    if self.firstFreeGameTrigger then
        table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = 1000,["accelerationTime"] = 10/60})

        spinAction.stopDelay = timeleft+(pCol-1)*stopDelay + self.DelayStopTime + extraReelTimeInFreeGame
        self.ExtraStopCD = spinAction.stopDelay+speedDownTime
        spinAction.ClearAction = true
    elseif specialType then
        local addSpecislTipTime = self:getPlayFeatrueTipAnimTime() or 0
        local addSpecislFeatrueTime = self:getPlayWheelFeatrueAnimTime() or 0

        table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = addSpecislTipTime,["accelerationTime"] = 10/60,["beginFun"] = onSpecialTip})
        table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = dragonFlyTime-0.5, ["accelerationTime"] = 10/60,["beginFun"] = onSpecialBegain})
        table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = addSpecislFeatrueTime,["accelerationTime"] = 10/60,["beginFun"] = onSpecialFeatrue})
        table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = 1000,["accelerationTime"] = 1000})

        local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0
        spinAction.stopDelay = timeleft+(pCol-1)*stopDelay + self.DelayStopTime + addSpecislTipTime + dragonFlyTime  + addSpecislFeatrueTime + specialFeatureDelayStop
        self.ExtraStopCD = spinAction.stopDelay
        spinAction.ClearAction = true
        self.canFastStop = false
    else
        -------------------------------  普通计算开始  --------------------------
        self.ExtraStopCD = spinMinCD - temp > 0 and spinMinCD - temp or 0
        spinAction.stopDelay = timeleft+(pCol-1)*stopDelay + self.DelayStopTime
        -------------------------------  普通计算结束  --------------------------
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

-------------------------------------------------- wheelBonus 相关 --------------------------------------------------
function cls:getPlayFeatrueTipAnimTime( ... )
    return normalShowDialogTime + 2 -- 1.5龙的动画 + 震屏时间
end

function cls:getPlayWheelFeatrueAnimTime( ... )
    -- 计算转轮转动 + 三种结果中奖显示时间
    local reelRollTime = 0.5 + 1.5 + 3*singleWheelStopDelay
    local showResultTime = 0
    for k, v in pairs(self.winBonusWheelData.wheel_list) do
        if v > 0 then
            if k == 1 then
                showResultTime = showResultTime + 3
            elseif k == 2 then
                showResultTime = showResultTime + 1 + 3
            elseif k == 3 then
                showResultTime = showResultTime + 1 + 3
            end
        end
    end
    return reelRollTime + showResultTime
end

-- todo 添加震屏动画（20-45帧），延迟之后出现痰喘
function cls:showWinWheelBonusDialog( dType, specialType )
    if dType == "show" then
        if bole.isValidNode(self.bgLogoSpine) then
            self.bgLogoSpine:stopAllActions()

            self.bgLogoSpine:setAnimation(0,logoBonusAnimName,false)
            self:playMusic(self.audio_list.bonus_notify)

            self.bgLogoSpine:runAction(cc.Sequence:create(
                cc.DelayTime:create(2),
                cc.CallFunc:create(function ( ... )
                    bole.spChangeAnimation(self.bgLogoSpine, logoLoopAnimName, true)
                end)))
        end
        self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function ( ... )-- 播放震动动画 时间 0.5s
                self:playReelTremble()
            end),
            cc.DelayTime:create(2),
            cc.CallFunc:create(function ( ... ) -- 展示玩法开始弹窗
                self:playMusic(self.audio_list.bonus_start_show)
                self:addSpineAnimation(self.down_child, 50, self:getPic("spine/dialog/wheel_start/bouns_ks_01"), cc.p(0,0), "animation")
                self.freeFeatureDimmer:setVisible(true)
                self.freeFeatureDimmer:setOpacity(0)
                self.freeFeatureDimmer:runAction(cc.FadeTo:create(0.3, 200))
            end)))

    else
        self.freeFeatureDimmer:runAction(cc.FadeTo:create(0.3, 0))
    end

end

function cls:playReelTremble()
    self.footerTremble = ScreenShaker.new(self.ctl.footer, 1, function() self.footerTremble = nil end)
    self.footerTremble:run()
    self.headerTremble = ScreenShaker.new(self.ctl.header, 1.5, function() self.headerTremble = nil end)
    self.headerTremble:run()
    self.reelTremble = ScreenShaker.new(self.shakyNode, 1.5, function() self.reelTremble = nil end)
    self.reelTremble:run()
end

function cls:playShowWheelNodeAnim( sType , tryResume)
    local needFlip = -1
    local progressiveStartPosX = 0
    local progressiveEndPosX = -baseSceneMaxWidth
    local wheelStartPosX = baseSceneMaxWidth
    local wheelEndPosX = 0
    local delayTime = 6/30 -- 右往左到达jackpot的位置时间
    if sType ~= "show" then
        needFlip = 1
        progressiveStartPosX = -baseSceneMaxWidth
        progressiveEndPosX = 0
        wheelStartPosX = 0
        wheelEndPosX = baseSceneMaxWidth

        delayTime = 0/30 -- 左往右到达jackpot的位置时间
    else
        self:setWheelBonusNodeState(false)
    end

    if tryResume then -- 直接恢复
        self.progressiveParent:stopAllActions()
        self.progressiveParent:setPositionX(progressiveEndPosX)

        self.wheelNode:setVisible(true)
        self.wheelNode:stopAllActions()
        self.wheelNode:setPositionX(wheelEndPosX)
    else
        self:playMusic(self.audio_list.dragon_fly)
        local _, s = self:addSpineAnimation(self.mainThemeScene, 20, self:getPic("spine/wheel/xiaojinlong"), cc.p(0,0), "animation1")-- 播放动画
        s:setScaleX(needFlip)

        self:runAction(cc.Sequence:create(
            cc.DelayTime:create(delayTime),
            cc.CallFunc:create(function ( ... )
                self:playMusic(self.audio_list.jp_move)
                self.progressiveParent:stopAllActions()
                self.progressiveParent:setPositionX(progressiveStartPosX)
                self.progressiveParent:runAction(cc.MoveTo:create(dragonFlyTime/2, cc.p(progressiveEndPosX,  self.progressiveParent:getPositionY())))

                self.wheelNode:setVisible(true)
                self.wheelNode:stopAllActions()
                self.wheelNode:setPositionX(wheelStartPosX)
                self.wheelNode:runAction(cc.MoveTo:create(dragonFlyTime/2, cc.p(wheelEndPosX,  self.wheelNode:getPositionY())))
            end)))
    end
end

function cls:playWheelBonusGame()
    local finshKeyList = self.winBonusWheelData.wheel_list

    local height = wheelBaseHeight
    local width  = wheelBaseHeight
    self.miniReelList = {}

    self:playMusic(self.audio_list.wheel)
    for k = 1, 3 do
        local data= {
            ["itemCount"]           = 3, -- 上下加一个 cell 之后的个数
            ["key"]                 = finshKeyList[k],
            ["finshRollSumLength"]  = 1, -- 结束阶段会滚过几遍总共的Count
            ["cellSize"]            = cc.p(width,height),
            ["delayBeforeSpin"]     = 0.0,   --开始旋转前的时间延迟
            ["upBounce"]            = 0,    --开始滚动前，向上滚动距离
            ["upBounceTime"]        = 0,   --开始滚动前，向上滚动时间
            ["speedUpTime"]         = 0.5,   --加速时间
            ["rotateTime"]          = 1.5 + (k-1)*singleWheelStopDelay,   -- 匀速转动的时间之和
            ["maxSpeed"]            = 1/6*width*60,    --每一秒滚动的距离
            ["downBounce"]          = 0,  --滚动结束前，向下反弹距离  都为正数值
            ["speedDownTime"]       = 1, -- 4
            ["downBounceTime"]      = 0,

            ["direction"]           = 2,
            ["startIndex"]          = 1,
        }

        local callFunc = function ()
            self:showWheelWinAnim(k)
            if k == 3 then
                self:onWheelOnStop()
            end
        end
        self.miniReelList[k] = BaseReel.new(self, self.wheelRollItemDList[k], data, callFunc)
        self.miniReelList[k]:startSpin()
    end
end

function cls:showWheelWinAnim( index )
    local wheelFinshKey = self.winBonusWheelData.wheel_list
    if wheelFinshKey[index] > 0 then -- 播放特效
        self:addSpineAnimation(self.wheelAnimNodeList[index], 50, self:getPic("spine/wheel/dakuang"), cc.p(0,0), "animation", nil, nil, nil, true, true)-- 播放展示结果覆盖动画
        self:addSpineAnimation(self.wheelAnimNodeList[index], 50, self:getPic("spine/wheel/xiaokuang"), cc.p(1,143), "animation", nil, nil, nil, true, true)-- 播放展示结果覆盖动画
        self:playMusic(self.audio_list.wheel_win)
    else
        self:playMusic(self.audio_list.wheel_stop)
    end
end

function cls:onWheelOnStop( ... )
    self._wheelFinshKey = tool.tableClone(self.winBonusWheelData.wheel_list)
    self:runAction(cc.Sequence:create(
        cc.DelayTime:create(1),
        cc.CallFunc:create(function ( ... )
            self:showWinWheelBonusDialog("hide")
            self:setCellColorState(false)
        end),
        cc.DelayTime:create(normalShowDialogTime),
        cc.CallFunc:create(function ( ... )
            self:showWheelWinBufferOneByOne()
        end)))
end

function cls:setCellColorState( toBright )
    local color = cc.c3b(125,125,125)
    self.showWheelDimmer = true
    if toBright then
        self.showWheelDimmer = false
        color = cc.c3b(255,255,255)
    end

    for col,item in pairs(self.spinLayer.spins) do
        for row,cell in pairs(item.cells) do
            cell.sprite:setColor(color)
            if cell.symbolTipAnim then
                cell.symbolTipAnim:setColor(color)
            end
        end
    end
    for _, node in pairs(self.animateNode:getChildren()) do
        if bole.isValidNode(node) then
            node:setColor(color)
        end
    end
end

function cls:showWheelWinBufferOneByOne()
    local isOver = true
    for k,v in pairs(self._wheelFinshKey) do
        if v > 0 then
            self:playWheelBufferAnim(k)
            isOver = false
            self._wheelFinshKey[k] = 0
            return
        else
            self.wheelAnimNodeList[k]:removeAllChildren()
        end
    end
    if isOver then
        self.ctl:collectCoins(1)
        self.canColorSymbol = false
        self.showWheelDimmer = false
        self:setCellColorState(true)
    end
end

function cls:playWheelBufferAnim( winType )
    if winType == 1 then
        self:playWheelBufferAnimByWild()
    elseif winType == 2 then
        self:playWheelBufferAnimByMSymbol(winType)
    elseif winType == 3 then
        self:playWheelBufferAnimByMulti(winType)
    end
end

function cls:playWheelBufferAnimByWild()
    self:playMusic(self.audio_list.dragon_fly)
    self:addSpineAnimation(self.down_child, 20, self:getPic("spine/wheel/xiaojinlong"), cc.p(0,0), "animation2")-- 播放动画

    self.stickyWildList = {}
    local wildPosList = self.winBonusWheelData.wild_pos
    self.randomAnimNode:setVisible(false)
    for _, posData in pairs(wildPosList) do
        local pos = self:getCellPos(posData[1], posData[2])
        local _, s = self:addSpineAnimation(self.randomAnimNode, nil, self:getPic("spine/item/1/spine"), pos, "animation", nil, nil, nil, true, true)
        self.stickyWildList[posData[1]] = self.stickyWildList[posData[1]] or {}
        self.stickyWildList[posData[1]][posData[2]] = s
    end
    self:runAction(cc.Sequence:create(
        cc.DelayTime:create(dragonFlyTime/2),
        cc.CallFunc:create(function ( ... )
            self:playMusic(self.audio_list.wheel_wild)
            self.randomAnimNode:setVisible(true)
        end),
        cc.DelayTime:create(dragonFlyTime/2), -- 龙飞过动画时间
        cc.CallFunc:create(function ( ... )
            self:showWheelWinBufferOneByOne()
        end)))
end

function cls:playWheelBufferAnimByMSymbol(winType)
    self.turnSymbolID = self.winBonusWheelData.turn_symbol
    self:runAction(cc.Sequence:create(
        cc.CallFunc:create(function ( ... )
            self:playMusic(self.audio_list.wheel_change)
            self:addSpineAnimation(self.wheelAnimNodeList[winType], 50, self:getPic("spine/wheel/beishu"), wheelMaskPosList[winType], "animation")-- 播放展示结果覆盖动画
            self.wheelEndNodeList[winType]:setVisible(true)
            bole.updateSpriteWithFile(self.wheelEndSpList[winType], "#theme177_wheel_ui_s"..self.turnSymbolID..".png")
        end),
        cc.DelayTime:create(1), -- 爆炸时间
        cc.CallFunc:create(function ( ... )
            self:playMusic(self.audio_list.dragon_fly)
            local _ ,s = self:addSpineAnimation(self.down_child, 20, self:getPic("spine/wheel/xiaojinlong"), cc.p(0,0), "animation2")-- 播放动画
            s:setScaleX(-1)
        end),
        cc.DelayTime:create(dragonFlyTime/2), -- 龙飞过动画时间
        cc.CallFunc:create(function ( ... )
            self:playMusic(self.audio_list.wheel_wild)
            self.canTurnSymbol = true
            self.canColorSymbol = true
        end),
        cc.DelayTime:create(dragonFlyTime/2), -- 龙飞过动画时间
        cc.CallFunc:create(function ( ... )
            self:showWheelWinBufferOneByOne()
        end)))
end

function cls:playWheelBufferAnimByMulti(winType)
    local bgMulti = self.winBonusWheelData.bg_multi
    self:runAction(cc.Sequence:create(
        cc.CallFunc:create(function ( ... )
            self:playMusic(self.audio_list.wheel_change)
            self:addSpineAnimation(self.wheelAnimNodeList[winType], 50, self:getPic("spine/wheel/beishu"), wheelMaskPosList[winType], "animation")-- 播放展示结果覆盖动画
            self.wheelEndNodeList[winType]:setVisible(true)
            self.wheelEndSpList[winType]:setString(bgMulti.."X")
        end),
        cc.DelayTime:create(1), -- 爆炸时间
        cc.CallFunc:create(function ( ... )
            self:playMusic(self.audio_list.dragon_fly)
            self:addSpineAnimation(self.down_child, 20, self:getPic("spine/wheel/xiaojinlong"), cc.p(0,0), "animation3")-- 播放动画
        end),
        cc.DelayTime:create(dragonFlyTime/2), -- 龙飞过动画时间
        cc.CallFunc:create(function ( ... )
            self:playMusic(self.audio_list.wheel_wild)
        end),
        cc.DelayTime:create(dragonFlyTime/2), -- 龙飞过动画时间
        cc.CallFunc:create(function ( ... )
            self:showWheelWinBufferOneByOne()
        end)))
end

---------------------------------- 声音相关 ---------------------------------------------

function cls:configAudioList()
    Theme.configAudioList(self)

    self.audio_list = self.audio_list or {}
    -- base
    self.audio_list.common_click     = "audio/base/common_click.mp3"    -- 通用点击
    self.audio_list.popup_out        = "audio/base/popup_out.mp3"       -- 通用关闭
    self.audio_list.collect_show     = "audio/base/collect_show.mp3"    -- 收集物出现
    self.audio_list.collect_fly      = "audio/base/collect_fly.mp3"     -- 收集物飞到宝箱
    self.audio_list.collect          = "audio/base/collect.mp3"         -- 元宝收集
    self.audio_list.lock             = "audio/base/lock.mp3"            -- 商店上锁
    self.audio_list.unlock           = "audio/base/unlock.mp3"          -- 商店解锁
    self.audio_list.dragon_fly       = "audio/base/dragon_fly.mp3"      -- 小金龙飞过
    self.audio_list.jp_move          = "audio/base/jp_move.mp3"         -- jp区域出现和收起
    self.audio_list.wheel_change     = "audio/base/wheel_change.mp3"    -- 转轮上倍数/龙图标变化
    self.audio_list.wheel_stop       = "audio/base/wheel_stop.mp3"      -- 转轮停下
    self.audio_list.wheel_wild       = "audio/base/wheel_wild.mp3"      -- 配合龙飞过棋盘wild/龙symbol出现/翻倍点亮声音
    self.audio_list.wheel_win        = "audio/base/wheel_win.mp3"       -- 转轮中奖
    self.audio_list.wheel            = "audio/base/wheel.mp3"           -- 转轮转动
    self.audio_list.bonus_notify     = "audio/base/bonus_notify.mp3"    -- 轮轴bonus之前激励
    self.audio_list.special_stop1    = "audio/base/symbol_bonus.mp3"    -- bonus落地音
    self.audio_list.special_stop2    = "audio/base/symbol_scatter.mp3"  -- scatter落地音
    self.audio_list.special_stop3    = "audio/base/symbol_scatter.mp3"  -- scatter2落地音
    self.audio_list.special_stop4    = "audio/base/symbol_scatter.mp3"  -- scatter3落地音
    self.audio_list.bonus_start_show = "audio/base/bonus_start_show.mp3" -- bonus转轮弹窗

    -- free
    self.audio_list.wild_tip    = "audio/free/wild_tip.mp3"     -- 100个wild和去掉mini提示板
    self.audio_list.multi_show  = "audio/free/multi_show.mp3"   -- 倍数板子升起
    self.audio_list.add3        = "audio/free/add3.mp3"         -- 弹版上砸+3
    self.audio_list.add100wild  = "audio/free/100wild.mp3"      -- 砸100个wild
    self.audio_list.num_fly     = "audio/free/num_fly.mp3"      -- 飞粒子声音

    --pick
    self.audio_list.pick_background = "audio/pick/pick_bgm.mp3"     --bgm
    self.audio_list.jackpot_music4  = "audio/pick/mini.mp3"         -- pick结算弹窗 mini 人声
    self.audio_list.jackpot_music3  = "audio/pick/minor.mp3"        -- pick结算弹窗 minor 人声
    self.audio_list.jackpot_music1  = "audio/pick/maxi.mp3"         -- pick结算弹窗 maxi 人声
    self.audio_list.jackpot_music2  = "audio/pick/major.mp3"        -- pick结算弹窗 major 人声
    self.audio_list.jackpot_music0  = "audio/pick/grand.mp3"        -- pick结算弹窗 grand 人声
    self.audio_list.lock_mini       = "audio/pick/lock_mini.mp3"    -- 锁定 mini 的音效
    self.audio_list.jackpot_show    = "audio/pick/jackpot_show.mp3" -- pick结算弹窗
    self.audio_list.card            = "audio/pick/card.mp3"         --翻牌
    self.audio_list.card_win        = "audio/pick/card_win.mp3"     --龙柱中奖
    self.audio_list.card_fly        = "audio/pick/card_fly.mp3"     --翻出的牌飞到相应龙柱点亮+上涨

    --store
    self.audio_list.shop_win_show   = "audio/shop/shop_win_show.mp3"    -- 商店升级弹窗
    self.audio_list.shop_unlock     = "audio/shop/shop_unlock.mp3"      -- 级别解锁
    self.audio_list.shop_lock       = "audio/shop/shop_lock.mp3"        -- 宝箱上锁
    self.audio_list.shop_show       = "audio/shop/shop_show.mp3"        -- 商店界面打开
    self.audio_list.shop_close      = "audio/shop/shop_close.mp3"       -- 商店界面关闭
    self.audio_list.shop_click      = "audio/shop/shop_click.mp3"       -- 翻页点击音
    self.audio_list.refresh         = "audio/shop/refresh.mp3"          -- 页面宝物和宝箱刷新声音
    self.audio_list.reduce200       = "audio/shop/reduce200.mp3"        -- -200提示音
    self.audio_list.open            = "audio/shop/open.mp3"             -- 宝箱打开+宝物出现
    self.audio_list.level_up        = "audio/shop/level_up.mp3"         -- 龙升级+点亮星星
    self.audio_list.double          = "audio/shop/double.mp3"           -- 宝箱钱数x2

end

function cls:getLoadMusicList()
    local loadMuscList = {
        -- base
        self.audio_list.common_click,
        self.audio_list.popup_out,
        self.audio_list.collect_show,
        self.audio_list.collect_fly,
        self.audio_list.collect,
        self.audio_list.lock,
        self.audio_list.unlock,
        self.audio_list.dragon_fly,
        self.audio_list.jp_move,
        self.audio_list.wheel_change,
        self.audio_list.wheel_stop,
        self.audio_list.wheel_wild,
        self.audio_list.wheel_win,
        self.audio_list.wheel,
        self.audio_list.bonus_notify,
        self.audio_list.special_stop1,
        self.audio_list.special_stop2,
        self.audio_list.special_stop3,
        self.audio_list.special_stop4,
        self.audio_list.bonus_start_show,

        -- free
        self.audio_list.wild_tip,
        self.audio_list.multi_show,
        self.audio_list.add3,
        self.audio_list.add100wild,
        self.audio_list.num_fly,

        --pick
        self.audio_list.jackpot_music4,
        self.audio_list.jackpot_music3,
        self.audio_list.jackpot_music1,
        self.audio_list.jackpot_music2,
        self.audio_list.jackpot_music0,
        self.audio_list.lock_mini,
        self.audio_list.jackpot_show,
        self.audio_list.card,
        self.audio_list.card_win,
        self.audio_list.card_fly,

        --store
        self.audio_list.shop_win_show,
        self.audio_list.shop_unlock,
        self.audio_list.shop_lock,
        self.audio_list.shop_show,
        self.audio_list.shop_close,
        self.audio_list.shop_click,
        self.audio_list.refresh,
        self.audio_list.reduce200,
        self.audio_list.open,
        self.audio_list.level_up,
        self.audio_list.double,
    }
    return loadMuscList
end

function cls:playLevelUpWinShopMusic()
    self:playMusic(self.audio_list.shop_win_show)
end

-- 播放bonus wheel game的背景音乐
function cls:dealMusic_EnterPickGame()
    AudioControl:stopGroupAudio("music")
    self:playLoopMusic(self.audio_list.pick_background)
    AudioControl:volumeGroupAudio(1)
end

-----------------------------Transition弹窗相关------------------------------
function cls:playTransition(endCallBack, tType)
    local function delayAction()
        local transition = PowerOfDragonsTransition.new(self, endCallBack)
        transition:play(tType)
    end
    delayAction()
end

PowerOfDragonsTransition = class("PowerOfDragonsTransition", CCSNode)
local GameTransition = PowerOfDragonsTransition

function GameTransition:ctor(theme, endCallBack)
    self.spine = nil
    self.theme = theme
    self.endFunc = endCallBack
end

function GameTransition:play(tType)
    local spineFile = self.theme:getPic("spine/base/qieping2") -- free
    local musicName = self.theme.audio_list.transition_free

    if tType == "pick" then
        spineFile = self.theme:getPic("spine/base/qieping1") -- pick1
        musicName = self.theme.audio_list.transition_bonus
    end

    local pos = cc.p(0,0)
    local delay1 = transitionDelay[tType]["onEnd"] -- 切屏结束 的时间
    self.theme.curScene:addToContentFooter(self, 1000)
    bole.adaptTransition(self,true,true)
    self:setVisible(false)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function()
        self.theme:playMusic(musicName)-- 播放转场声音
        self:setVisible(true)
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

function cls:onExit()
    if self.shaker then
        self.shaker:stop()
    end

    if self.reelTremble then
        self.reelTremble:stop()
    end
    if self.footerTremble then
        self.footerTremble:stop()
    end
    if self.headerTremble then
        self.headerTremble:stop()
    end

    if self.miniReelList then
        for k, reel in pairs(self.miniReelList) do
            if reel.scheduler then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(reel.scheduler)
                reel.scheduler = nil
            end
        end
    end

    Theme.onExit(self)
end

--------------------------------- LockRespin && Bonus ---------------------------------

PowerOfDragonsBonusGame = class("PowerOfDragonsBonusGame")
local bonusGame = PowerOfDragonsBonusGame

function bonusGame:ctor(bonusControl, theme, csbPath, data, callback)
    self.bonusControl = bonusControl
    self.theme = theme
    self.csbPath = csbPath
    self.callback = callback
    self.oldCallBack = callback
    self.data = data
    self.theme.bonus = self
    self.ctl = bonusControl.themeCtl

    if self.data.core_data["wheel"] and self.ctl.rets and self.ctl.rets["free_game"] then
        self.isFeatureLeft = true
    else
        if self.theme.buyBackData then
            self.isFeatureLeft = true
        end
        self:saveBonus()
    end

end

function bonusGame:addData(key, value)
    self.data[key] = value
    self:saveBonus()
end
function bonusGame:saveBonus()
    if not self.data.bonus_id then
        self.data.bonus_id = self.data.core_data.bonus_id
    end
    LoginControl:getInstance():saveBonus(self.theme.themeid, self.data)

end
-- whj 添加
function bonusGame:saveBonusCheckData(bonusData)
    -- 没有断线的情况下进入bonus时候, 判断存在bonus_id校验字段, 直接赋值存储,同时覆盖掉原来的数据(每个主题里面单独控制是否需要清空数据)
    local data = {}
    data.bonus_id = bonusData.bonus_id
    LoginControl:getInstance():saveBonus(self.themeid, data)
end

function bonusGame:cleanBonusSaveData(data)
    -- 断线的情况下进入bonus时候, 判断bonus_id校验字段本地与服务器不一致, 清除原来的数据(每个主题里面单独控制是否需要清空数据)
    cacheData = nil
    LoginControl:getInstance():saveBonus(self.themeid, nil)
end
-- whj 添加 end
function bonusGame:enterBonusGame(tryResume)
    self.theme.isInBonusGame = true
    self.theme.ctl.footer:setSpinButtonState(true)-- 禁掉spin按钮
    self.theme.ctl.footer:enableOtherBtns(false)
    self.theme:stopDrawAnimate()

    self.bonusType = self.data.core_data.type -- type1对应repsin type2对应 deal game type3对应 level

    if tryResume then
        self.callback = function(...)
            -- 断线重连回调方法
            local endCallFunc2 = function(...)
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
    -- 隐藏B级活动栏
    if self.ctl.footer then
        self.ctl.footer:hideActivitysNode()
    end

    if self.bonusType == PowerOfDragonsBonusType.PICK then
        self:enterPickBonus(tryResume)
    elseif self.bonusType == PowerOfDragonsBonusType.WHEEL then
        self:enterWheelBonus(tryResume)
    end
end

-------------------------------------- PickGame ---------------------------------
local pickSingleShowResultTime = 23/30
local columnAddSingleCntTime = 0.5
local circleRemoveTime = 0.5
local pearlWinTime = 1
local columnPointHConfig = {
    [0] = {[0] = -3, 73, 123, 174.5, 225.5, 277.5, 374},
    [1] = {[0] = -4.5, 55, 122, 187, 273},
    [2] = {[0] = -4.5, 54, 121, 185, 270},
    [3] = {[0] = -1, 80,167,267},
    [4] = {[0] = -1, 80, 166, 268},
}
local endPosConfig = {
    [3] = cc.p(-283, 12), [1] = cc.p(-142, 12), [0] = cc.p(0, 12), [2] = cc.p(139, 12), [4] = cc.p(286, 12),
}
local columnMaxCntConfig = {
	[0] = 6, [1] = 4, [2] = 4, [3] = 3, [4] = 3
}

local lockColor = cc.c3b(150,150,150)
local noWinColor = cc.c3b(150,150,150)
local noClickColor = cc.c3b(75,75,75)

function bonusGame:enterPickBonus( tryResume )
    self.pick1Data          = tool.tableClone(self.data.core_data.pick_result)
    self.progressiveData    = tool.tableClone(self.data.core_data.progressive_list)
    self.pick1PickList      = self.pick1Data.pick_list -- picks
    self.pick1RestList      = self.pick1Data.no_pick_list
    self.pickWin            = self.pick1Data.jp_win
    self.winJpType          = self.pick1Data.jp_win_type
    self.lockMiniType       = self.pick1Data.no_mini
    self.lockMiniIndexList  = self.pick1Data.mini_index or {}

    self.pick1PickIndex     = self.data.pick1_pick_index or 0
    self.pick1PickOverList  = self.data.pick1_pick_over_list or {}
    self.pick1OverData      = {[0] = 0, [1] = 0, [2] = 0, [3] = 0, [4] = 0}
    self.pickWinIndexList   = {}

    if tryResume then
        self:pick1ShowPick1Scene(tryResume)
    else
        self:showStartPickBonusDialog()
    end
end

function bonusGame:showStartPickBonusDialog( ... )
    local path      = self.theme:getPic("csb/dialog_respin_s.csb")
    local dialog    = cc.CSLoader:createNode(path)
    self.theme.curScene:addToContentFooter(dialog)

    local dimmer    = dialog:getChildByName("common_black")
    local show_root = dialog:getChildByName("root")

    local labelCoins = show_root:getChildByName("label_coins")
    local btnStart = show_root:getChildByName("btn_start")

    local _, s = self.theme:addSpineAnimation(show_root, -1, self.theme:getPic("spine/dialog/pick_start/pick_ks_01"), cc.p(0,0), "animation1", nil, nil, nil, true)
    s:runAction(cc.Sequence:create(
        cc.DelayTime:create(20/30),
        cc.CallFunc:create(function ( ... )
            bole.spChangeAnimation(s, "animation2", true)
        end)))
    dimmer:setOpacity(0)
    dimmer:runAction(cc.FadeTo:create(0.3, 200))
    btnStart:setScale(0)
    btnStart:runAction(cc.Sequence:create(
        cc.DelayTime:create(11/30),
        cc.ScaleTo:create(0.25, 1.1),
        cc.ScaleTo:create(0.05, 1)))

    self.theme:playMusic(self.theme.audio_list.pick_start_show)

    local clickEndFunction = function ( obj, eventType )
        if eventType == ccui.TouchEventType.ended then
            btnStart:setTouchEnabled(false)
            self.theme:playMusic(self.theme.audio_list.common_click)

            local endDelay = self.lockMiniType == 1 and 2 or 0
            dialog:runAction(cc.Sequence:create(
                cc.DelayTime:create(0.2),
                cc.CallFunc:create(function ( ... )
                    self.theme:dialogPlayLineAnim("hide", dimmer, show_root) -- 关闭弹窗
                    self.theme:playMusic(self.theme.audio_list.popup_out)
                end),
                cc.DelayTime:create(0.5),
                cc.CallFunc:create(function ( ... )
                    self.theme:playTransition(nil, "pick")
                end),
                cc.DelayTime:create(transitionDelay.pick.onCover), -- 切屏覆盖全屏时间
                cc.CallFunc:create(function ( ... )
                    self:pick1ShowPick1Scene()
                end),
                cc.DelayTime:create(transitionDelay.pick.onEnd),
                cc.CallFunc:create(function ( ... )
                    self:checkLockMiniJackpot()
                    self.theme:dealMusic_EnterPickGame()
                end),
                cc.DelayTime:create(endDelay),
                cc.CallFunc:create(function ( ... )
                    self:pick1CheckPick1IsOver(nil,true)
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

function bonusGame:pick1ShowPick1Scene(tryResume)
    if self.ctl.footer then
        self.ctl.footer:hideActivitysNode()
    end
    if self.theme.superAvgBet then
        self.ctl:setPointBet(self.theme.superAvgBet)-- 更改 锁定的bet
        self.ctl.footer:isShowTotalBetLayout(false)-- 隐藏掉  footer bet
    end

    self:pick1InitPick1Node()

    if tryResume then
        self:checkLockMiniJackpot(tryResume)
        self.theme:dealMusic_EnterPickGame()
        self.theme:runAction(cc.Sequence:create(
            cc.DelayTime:create(0.5),
            cc.CallFunc:create(function()
                self:pick1CheckPick1IsOver(tryResume)
            end)
        ))
    end
end

function bonusGame:getJPLabelMaxWidthByBonus( index )
    local a = { 300, 254, 254, 190, 190}
    return a[index] or a[#a]
end

function bonusGame:checkLockMiniJackpot( tryResume )
    if self.lockMiniType == 1 then
        if tryResume then
            self:showLockMiniJackpotAnim()
        else
            self.pick1LockDialog:setVisible(true)
            local dimmer = self.pick1LockDialog:getChildByName("common_black")
            local sp = self.pick1LockDialog:getChildByName("theme177_pick_c2")

            self.pick1LockDialog:runAction(cc.Sequence:create(
                cc.CallFunc:create(function ( ... )
                    self.theme:playMusic(self.theme.audio_list.wild_tip)
                    self.theme:dialogPlayLineAnim("show", dimmer, sp)
                end),
                cc.DelayTime:create(0.5),
                cc.CallFunc:create(function ()
                    self.theme:playMusic(self.theme.audio_list.lock_mini)
                    self:showLockMiniJackpotAnim()
                end),
                cc.DelayTime:create(0.5),
                cc.CallFunc:create(function ( ... )
                    self.theme:dialogPlayLineAnim("hide", dimmer, sp)
                end)))
        end
    end
end

function bonusGame:showLockMiniJackpotAnim()
    local miniJpIndex = 4
    self.pick1LockSp:setVisible(true)
    for k, index in pairs(self.lockMiniIndexList) do
        if bole.isValidNode(self.pick1PickBtnList[index]) then -- 控制mini 位置的按钮不可点击
            self.pick1PickBtnList[index]:setTouchEnabled(false)
        end
        if bole.isValidNode(self.pick1PickResultList[index]) then  -- 置灰mini 位置的图片
            bole.updateSpriteWithFile(self.pick1PickResultList[index], "#theme177_pick_r_"..miniJpIndex..".png")
            self.pick1PickResultList[index]:setColor(lockColor)
        end
        if bole.isValidNode(self.pick1pickSpineList[index]) then -- 删除mini 位置的特效不展示
            self.pick1pickSpineList[index]:stopAllActions()
            self.pick1pickSpineList[index]:removeFromParent()
            self.pick1pickSpineList[index] = nil
        end
    end

    -- 锁住mini的收集柱子
    if bole.isValidNode(self.jpColumnList[miniJpIndex]) then
        self.jpColumnList[miniJpIndex]:setColor(lockColor)
    end

    if bole.isValidNode(self.jpPearlList[miniJpIndex]) then
        self.jpPearlList[miniJpIndex]:setColor(lockColor)
    end

    if self.jpColumnCircleList[miniJpIndex] then
        for k, ndoe in pairs(self.jpColumnCircleList[miniJpIndex]) do
            if bole.isValidNode(ndoe) then
                ndoe:setColor(lockColor)
            end
        end
    end

    if bole.isValidNode(self.jpColumnHeadSList[miniJpIndex]) then
        self.jpColumnHeadSList[miniJpIndex]:setColor(lockColor)
    end
end

function bonusGame:pick1InitPick1Node()
    self.pick1CsbPath   = self.theme:getPic("csb/game_pick.csb")
    self.pick1GameNode  = cc.CSLoader:createNode(self.pick1CsbPath)

    self.pick1GameRoot  = self.pick1GameNode:getChildByName("root")

    self.pick1TipNode = self.pick1GameRoot:getChildByName("pick_tip")
    self.pick1TipNode:setOpacity(0)
    self.pick1LockNode = self.pick1GameRoot:getChildByName("lock_node")
    self.pick1LockSp = self.pick1LockNode:getChildByName("lock_sp")
    self.pick1LockDialog = self.pick1LockNode:getChildByName("lock_dialog")
    self.pick1LockSp:setVisible(false)
    self.pick1LockDialog:setVisible(false)

    self:initBonusShowJackpotLabels()
    self:initCollectResultNode()
    self:initPickItemsNode()
    self:pick1InitPick1Btns()

    self.theme.curScene:addToContentFooter(self.pick1GameNode)
end

function bonusGame:initBonusShowJackpotLabels()
    local pick1JackpotLabels  = self.pick1GameRoot:getChildByName("jp_node"):getChildByName("labels"):getChildren()
    local _progressive_list = self.theme:getJackpotValue(self.progressiveData)
    -- 设置jackpot label值
    for i=1, #_progressive_list do
        if pick1JackpotLabels[i] then
            pick1JackpotLabels[i]:setString(self.theme:formatJackpotMeter(_progressive_list[i]))
            bole.shrinkLabel(pick1JackpotLabels[i], self:getJPLabelMaxWidthByBonus(i), pick1JackpotLabels[i]:getScale())
        end
    end
end

function bonusGame:initCollectResultNode( ... )
    local progressNode = self.pick1GameRoot:getChildByName("progress_node")

    self.jpPearlList = {}
    self.jpColumnList = {}
    self.jpColumnHeadSList = {}
    self.jpColumnCircleList = {}
    for index = 0, 4 do -- node in pairs(progressNode:getChildren()) do
        local _, _column = self.theme:addSpineAnimation(progressNode, 5, self.theme:getPic("spine/pick1/column"..index.."/spine"), cc.p(0,0), "animation0", nil, nil, nil, true)
        self.jpColumnList[index] = _column

        local _, _pearl = self.theme:addSpineAnimation(progressNode, 5, self.theme:getPic("spine/pick1/qiu"), cc.p(0,0), "animation"..index, nil, nil, nil, true, true)
        self.jpPearlList[index] = _pearl

        self.jpColumnCircleList[index] = {}
        for k = 1 , columnMaxCntConfig[index] - 1 do
            local posY = columnPointHConfig[index][k]
            local _, s = self.theme:addSpineAnimation(progressNode, 5, self.theme:getPic("spine/pick1/circle"..index.."/spine"), cc.p(0,posY), "animation", nil, nil, nil, true, true) -- 小光圈
            self.jpColumnCircleList[index][k] = s
        end

        local _, _circle = self.theme:addSpineAnimation(progressNode, 5, self.theme:getPic("spine/pick1/big_circle"..index.."/spine"), cc.p(0,0), "animation", nil, nil, nil, true, true)
        self.jpColumnHeadSList[index] = _circle
    end
end

function bonusGame:initPickItemsNode( ... )
    local pickParent = self.pick1GameRoot:getChildByName("items")
    self.pick1PickBtnList   = {}
    self.pick1pickSpineList = {}
    self.pick1PickResultList= {}
    self.pick1PickParent    = {}
    for i, item in pairs(pickParent:getChildren()) do
        self.pick1PickResultList[i] = item:getChildren()[1]

        self.pick1PickParent[i] = item

        local _, s = self.theme:addSpineAnimation(item, 5, self.theme:getPic("spine/pick1/longpai"), cc.p(0,0), "animation2", nil, nil, nil, true)
        self.pick1pickSpineList[i] = s
        self.pick1pickSpineList[i]:setVisible(false)
    end

    for k, v in pairs(self.pick1PickOverList) do
        local value = table.remove(self.pick1PickList,1)
        if bole.isValidNode(self.pick1pickSpineList[v]) then
            self.pick1pickSpineList[v]:stopAllActions()
            self.pick1pickSpineList[v]:removeFromParent()
            self.pick1pickSpineList[v] = nil
        end

        if bole.isValidNode(self.pick1PickResultList[v]) then
            self:pick1ShowPickResultByReset(value, v)
        end
        self.pick1OverData[value] = self.pick1OverData[value] + 1
        if self.winJpType == value then
            table.insert(self.pickWinIndexList, v)
        end
    end

    for jpIndex, value in pairs(self.pick1OverData) do
        if self.jpColumnCircleList[jpIndex] then
            for k = 1 , value do
                if bole.isValidNode(self.jpColumnCircleList[jpIndex][k]) then
                    self.jpColumnCircleList[jpIndex][k]:removeFromParent()
                    self.jpColumnCircleList[jpIndex][k] = nil
                end
            end
        end

    	self:showJpCollectProgressAnim(jpIndex)
    end
end

function bonusGame:pick1InitPick1Btns()
    local function onTouch( obj , eventType)
        if eventType == ccui.TouchEventType.ended then
            self:pick1SetPick1BtnEnabled(false)
            self:setBtnTipAnimState(false)
            self:setPickTipAnimState(false)

            local resultValue = table.remove(self.pick1PickList,1)
            self.pick1OverData[resultValue] = self.pick1OverData[resultValue] + 1
            if self.winJpType == resultValue then
                table.insert(self.pickWinIndexList, obj.index)
            end
            self.pick1PickIndex = self.pick1PickIndex + 1
            table.insert(self.pick1PickOverList, obj.index)

            self.data.pick1_pick_index = self.pick1PickIndex
            self.data.pick1_pick_over_list = self.pick1PickOverList
            self:saveBonus()

            self:pick1ShowPick1Result(obj.index, resultValue)
        end
    end


    local file = "commonpics/kong.png"
    for k, _pickParent in pairs(self.pick1PickParent) do
        local pickBtn = Widget.newButton(onTouch, file, file, file)
        pickBtn:setScale(13,10)
        pickBtn.index = k
        pickBtn:setTouchEnabled(false)
        _pickParent:addChild(pickBtn)
        self.pick1PickBtnList[k] = pickBtn
    end
end

function bonusGame:pick1SetPick1BtnEnabled( state )
    local _pickOverIndexList = Set((self.pick1PickOverList or {}))
    local _lockMiniIndexList = Set((self.lockMiniIndexList or {}))
    for k,v in pairs(self.pick1PickBtnList) do
        if (not _pickOverIndexList[k]) and (not _lockMiniIndexList[k]) then
            v:setTouchEnabled(state)-- 设置按钮
        end
    end
end

function bonusGame:getRamdonTipPosList( ... )
    local totalTipCnt = bole.getTableCount(self.pick1pickSpineList)
    local showTipCnt = math.ceil(totalTipCnt/7)
    local posList = {}

    local totalPosList = {}
    for k, v in pairs(self.pick1pickSpineList) do
        table.insert(totalPosList, k)
    end
    while #posList < showTipCnt do
        local p = table.randomPop(totalPosList)
        table.insert(posList, p)
    end
    return posList
end

function bonusGame:setBtnTipAnimState( state )
    self.pick1GameRoot:stopAllActions()
    if state then -- 开启延迟显示提示动画
        self.pick1GameRoot:runAction(
            cc.RepeatForever:create(
                cc.Sequence:create(
                cc.DelayTime:create(2),
                cc.CallFunc:create(function ( ... )
                    local posList = self:getRamdonTipPosList()
                    for _, index in pairs(posList) do
                        if bole.isValidNode(self.pick1pickSpineList[index]) then
                            self.pick1pickSpineList[index]:setVisible(true)
                            bole.spChangeAnimation(self.pick1pickSpineList[index], "animation")
                        end
                    end
                end))))
    end
end

function bonusGame:setPickTipAnimState( state, isFirst )
    self.pick1TipNode:stopAllActions()
    if state then -- 开启延迟显示提示动画
        local delay = 2
        if isFirst then
            delay = 0
        end

        self.pick1TipNode:runAction(cc.Sequence:create(
            cc.DelayTime:create(delay),
            cc.CallFunc:create(function ( ... )
                self.pick1TipNode:setScale(0.6)

                self.pick1TipNode:runAction(
                    cc.RepeatForever:create(cc.Sequence:create(
                        cc.ScaleTo:create(1,0.65),
                        cc.ScaleTo:create(1,0.6))))
            end),
            cc.FadeTo:create(0.2, 255)
        ))
    else
        self.pick1TipNode:runAction(cc.FadeTo:create(0.3, 0))
    end
end

function bonusGame:pick1ShowPick1Result(touchIndex, resultValue)
    local pickParentNode = self.pick1PickParent[touchIndex]
    self.theme:playMusic(self.theme.audio_list.card)

    self.theme:addSpineAnimation(pickParentNode, 20, self.theme:getPic("spine/pick1/fanpai"), cc.p(0,0), "animation")-- 播放展示结果覆盖动画
    self.pick1pickSpineList[touchIndex]:stopAllActions()-- 删除提示动画
    self.pick1pickSpineList[touchIndex]:removeFromParent()
    self.pick1pickSpineList[touchIndex] = nil

    local resultSp = self.pick1PickResultList[touchIndex]
    bole.updateSpriteWithFile(resultSp, "#theme177_pick_r_"..resultValue..".png")
    resultSp:setVisible(false)

    local isFinsh = (self.pick1OverData[resultValue] and self.pick1OverData[resultValue] == columnMaxCntConfig[resultValue])
	local collectOverOnDelay = isFinsh and (circleRemoveTime + pearlWinTime) or 0
    resultSp:runAction(cc.Sequence:create(
        cc.DelayTime:create(pickSingleShowResultTime),
        cc.Show:create(),
        cc.CallFunc:create(function ( ... )-- 播放飞行粒子 收集次数的逻辑
            local _, ls = self.theme:addSpineAnimation(pickParentNode, 10, self.theme:getPic("spine/pick1/jackpotpai"), cc.p(0,0), "animation"..resultValue, nil, nil, nil, true, true)
            pickParentNode.resultLoopSpine = ls
            local particleFile = self.theme:getPic(mapCollectParticlePath)

            local s1 = cc.ParticleSystemQuad:create(particleFile)
            self.pick1GameRoot:addChild(s1)
            s1:setPosition(cc.p(self.pick1PickParent[touchIndex]:getPosition()))

            self.theme:playMusic(self.theme.audio_list.card_fly)
            s1:runAction(cc.Sequence:create(
                cc.MoveTo:create(addResultLiziTime, endPosConfig[resultValue]),
                cc.CallFunc:create(function()
                    s1:setEmissionRate(0) -- 设置发射速度为不发射
                end),
                cc.DelayTime:create(0.5),
                cc.RemoveSelf:create()))
        end),
        cc.DelayTime:create(addResultLiziTime),
        cc.CallFunc:create(function ( ... ) -- 播放底座上升特效 + 光圈上升
        	self:showJpCollectProgressAnim(resultValue)
        end),
        cc.DelayTime:create(columnAddSingleCntTime),
        cc.CallFunc:create(function ( ... )
            if self.jpColumnCircleList[resultValue] and bole.isValidNode(self.jpColumnCircleList[resultValue][self.pick1OverData[resultValue]]) then
                self.jpColumnCircleList[resultValue][self.pick1OverData[resultValue]]:removeFromParent()
                self.jpColumnCircleList[resultValue][self.pick1OverData[resultValue]] = nil
            end

        	if isFinsh then  -- 播放到达光圈消失特效
        		self:collectOverOnJackpot(resultValue)
        	end
        end),
        cc.DelayTime:create(collectOverOnDelay),
        cc.CallFunc:create(function ( ... )
        	self:pick1CheckPick1IsOver()
        end)
    ))
end

function bonusGame:showJpCollectProgressAnim(value)
	if self.pick1OverData[value] then
		local _cnt = self.pick1OverData[value]

		if bole.isValidNode(self.jpColumnList[value]) then -- 播放柱子进度上升动画
			bole.spChangeAnimation(self.jpColumnList[value], "animation".._cnt)
		end

		if bole.isValidNode(self.jpColumnHeadSList[value]) then -- 播放柱子进度上升动画
			self.jpColumnHeadSList[value]:runAction(cc.MoveTo:create(0.5, cc.p(0, columnPointHConfig[value][_cnt] or columnPointHConfig[value][#columnPointHConfig[value]])))
		end
	end
end

function bonusGame:collectOverOnJackpot(value, tryResume)
	if tryResume then
		local value = self.winJpType
		if bole.isValidNode(self.jpPearlList[value]) then -- 珍珠中奖动画
			bole.spChangeAnimation(self.jpPearlList[value], "animation"..value.."_1")
		end
		if bole.isValidNode(self.jpColumnHeadSList[value]) then
			self.jpColumnHeadSList[value]:setVisible(false)
		end
	else
        self.theme:stopAllLoopMusic()
        self.theme:playMusic(self.theme.audio_list.card_win)
		-- 播放大光圈消失特效 和 珠子点亮特效
		self.theme:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			self.jpColumnHeadSList[value]:setPositionY(columnPointHConfig[value][columnMaxCntConfig[value]])
			if bole.isValidNode(self.jpColumnHeadSList[value]) then -- 播放光圈消失动画
                self.jpColumnHeadSList[value]:runAction(cc.FadeOut:create(0.5))
			end
		end),
		cc.DelayTime:create(circleRemoveTime),
		cc.CallFunc:create(function ( ... )
			if bole.isValidNode(self.jpPearlList[value]) then -- 珍珠中奖动画
				bole.spChangeAnimation(self.jpPearlList[value], "animation"..value.."_1")
			end
		end)))
	end
end

function bonusGame:pick1CheckPick1IsOver( tryResume, isFirst )
    if #self.pick1PickList >0 then
        self:pick1SetPick1BtnEnabled(true)
        self:setBtnTipAnimState(true)
        self:setPickTipAnimState(true)
    else

        self:pick1SetPick1BtnEnabled(false)
        self:setBtnTipAnimState(false)
        self:setPickTipAnimState(false, isFirst)
        self.theme:stopAllLoopMusic()
        self:pick1ShowWinAnim(tryResume)
        self.theme:runAction(cc.Sequence:create(
            cc.DelayTime:create(1),
            cc.CallFunc:create(function ( ... )
                self:pick1ShowOtherPickValue()
            end),
            cc.DelayTime:create(pickSingleShowResultTime + 1),
            cc.CallFunc:create(function ( ... )
                self:pick1PlayPick1GameCollect()
            end)))
    end
end

function bonusGame:pick1ShowWinAnim( tryResume )
    if tryResume then
    	self:collectOverOnJackpot(nil, tryResume)
    end

    local _pickWinIndexListSet = Set((self.pickWinIndexList or {}))
    for _, index in pairs(self.pick1PickOverList) do
        local pickParentNode = self.pick1PickParent[index]

        if _pickWinIndexListSet[index] then -- 所有中奖格子的选中动画
            if bole.isValidNode(pickParentNode) then
                self.theme:addSpineAnimation(pickParentNode, 50, self.theme:getPic("spine/pick1/paizhongjiang"), cc.p(0,0), "animation", nil, nil, nil, true, true)-- 播放展示结果覆盖动画
            end
        else -- 其他点击格子去掉循环动画
            if pickParentNode and bole.isValidNode(pickParentNode.resultLoopSpine) then
                pickParentNode.resultLoopSpine:removeFromParent()
                pickParentNode.resultLoopSpine = nil
            end
        end
    end

end

function bonusGame:pick1ShowOtherPickValue()
    local _pickOverIndexList = Set(self.pick1PickOverList or {})
    local _lockMiniIndexList = Set(self.lockMiniIndexList or {})
    local _pickWinIndexList = Set((self.pickWinIndexList or {}))

    for k = 1, #self.pick1PickResultList do
        if (not _pickOverIndexList[k]) and (not _lockMiniIndexList[k]) then
            local value = table.remove(self.pick1RestList,1)

            if value and bole.isValidNode(self.pick1PickResultList[k]) then
                self:pick1ShowPickResultByReset(value, k, true)
            end
        end
        if _pickOverIndexList[k] and (not _pickWinIndexList[k]) then
            if bole.isValidNode(self.pick1PickResultList[k]) then
                self.pick1PickResultList[k]:setColor(noWinColor)
            end
        end
    end
end

function bonusGame:pick1ShowPickResultByReset( value, index, isOther )
    local pickParentNode = self.pick1PickParent[index]
    local color = isOther and noClickColor or cc.c3b(255,255,255)

    if bole.isValidNode(self.pick1pickSpineList[index]) then
        self.pick1pickSpineList[index]:stopAllActions()
        self.pick1pickSpineList[index]:removeFromParent()
        self.pick1pickSpineList[index] = nil
    end

    local resultSp = self.pick1PickResultList[index]
    bole.updateSpriteWithFile(resultSp, "#theme177_pick_r_"..value..".png")
    resultSp:setColor(color)

    if isOther then
        resultSp:setScale(0)
        resultSp:runAction(cc.ScaleTo:create(0.3,1))
        -- resultSp:setVisible(false)
        -- self.theme:addSpineAnimation(pickParentNode, 20, self.theme:getPic("spine/pick1/fanpai"), cc.p(0,0), "animation")-- 播放展示结果覆盖动画
        -- resultSp:runAction(cc.Sequence:create(
        --     cc.DelayTime:create(pickSingleShowResultTime),
        --     cc.Show:create()
        -- ))
    else
        local _, ls = self.theme:addSpineAnimation(pickParentNode, 10, self.theme:getPic("spine/pick1/jackpotpai"), cc.p(0,0), "animation"..value, nil, nil, nil, true, true)
        pickParentNode.resultLoopSpine = ls
    end
end

function bonusGame:addShowPickDialogAnim(dimmer, show_root, btn, winNode)
    local showName = "animation"..self.winJpType
    local loopName = "animation"..self.winJpType.."_"..self.winJpType
    local _, s = self.theme:addSpineAnimation(show_root, -1, self.theme:getPic("spine/dialog/collect_jp/jsckpot_01"), cc.p(0,0), showName, nil, nil, nil, true)
    s:runAction(cc.Sequence:create(
        cc.DelayTime:create(17/30),
        cc.CallFunc:create(function ( ... )
            bole.spChangeAnimation(s, loopName, true)
        end)))
    dimmer:setOpacity(0)
    dimmer:runAction(cc.FadeTo:create(0.3, 200))

    winNode:setScale(0)
    winNode:runAction(cc.Sequence:create(
        cc.DelayTime:create(12/30),
        cc.ScaleTo:create(0.25, 1.1),
        cc.ScaleTo:create(0.05, 1)))

    btn:setScale(0)
    btn:runAction(cc.Sequence:create(
        cc.DelayTime:create(18/30),
        cc.ScaleTo:create(0.25, 1.1),
        cc.ScaleTo:create(0.05, 1)))
end

function bonusGame:pick1PlayPick1GameCollect( ... )
    local path      = self.theme:getPic("csb/dialog_jp.csb")
    local dialog    = cc.CSLoader:createNode(path)
    self.theme.curScene:addToContentFooter(dialog)

    local dimmer    = dialog:getChildByName("common_black")
    local show_root = dialog:getChildByName("root")

    local winNode  = show_root:getChildByName("win_node")
    local labelCoins    = winNode:getChildByName("label_coins")
    local btnCollect    = show_root:getChildByName("btn_collect")

    self:addShowPickDialogAnim(dimmer, show_root, btnCollect, winNode)

    self.theme:playMusic(self.theme.audio_list["jackpot_music"..self.winJpType])
    self.theme:playMusic(self.theme.audio_list.jackpot_show)

    local function parseValue( num)
        return FONTS.format(num, true)
    end
    bole.setSpeicalLabelScale(labelCoins, self.pickWin, 620)
    inherit(labelCoins, LabelNumRoll)
    labelCoins:nrInit(0, 24, parseValue)
    labelCoins:nrStartRoll(0, self.pickWin, 2)-- 播放numberRoll

    local clickEndFunction = function ( obj, eventType )
        if eventType == ccui.TouchEventType.ended then
            btnCollect:setTouchEnabled(false)
            self.theme:playMusic(self.theme.audio_list.common_click)

            labelCoins:nrOverRoll()-- 停止滚动

            self.data.end_game = true
            self:saveBonus()
            self.ctl:collectCoins(1)

            dialog:runAction(cc.Sequence:create(
                cc.DelayTime:create(0.2),
                cc.CallFunc:create(function ( ... )
                    self.theme:dialogPlayLineAnim("hide", dimmer, show_root) -- 关闭弹窗
                    self.theme:playMusic(self.theme.audio_list.popup_out)
                end),
                cc.DelayTime:create(0.5),
                cc.CallFunc:create(function ( ... )
                    self.theme:playTransition(nil, "pick")
                end),
                cc.DelayTime:create(transitionDelay.pick.onCover), -- 切屏覆盖全屏时间
                cc.CallFunc:create(function ( ... )
                    self.theme:changeSpinBoard(SpinBoardType.Normal)
                    if self.ctl.footer then
                        self.ctl.footer:showActivitysNode()
                    end
                    self.pick1GameNode:removeFromParent()
                end),
                cc.DelayTime:create(transitionDelay.pick.onEnd),
                cc.CallFunc:create(function ( ... )
                    self:pick1OnPick1GameEnd()
                end),
                cc.RemoveSelf:create()
            ))
        end
    end

    dialog:runAction(cc.Sequence:create(
        cc.DelayTime:create(1.5),
        cc.CallFunc:create(function()
            btnCollect:addTouchEventListener(clickEndFunction)
        end),
        cc.DelayTime:create(1),
        cc.CallFunc:create(function ( ... )
            labelCoins:nrOverRoll()-- 停止滚动
        end)))
end

function bonusGame:pick1OnPick1GameEnd()
    self.theme:dealMusic_PlayNormalLoopMusic()
    local rollEndFunc = function ( ... )
        self:onBonusOver()
    end
    self.ctl:startRollup(self.pickWin, rollEndFunc)
end

function bonusGame:onBonusOver()
    self.ctl.footer.isFreeSpin = false
    self.theme.isInBonusGame = false
    self.ctl.footer:changeLabelDescription("notFS_Win")
    self.saveWin = false
    -- 不是 在 freespin 里面进入 lockrespin 的时候 清掉 对bet的 限制

    if self.theme.superAvgBet then
        self.theme.superAvgBet = nil
        self.ctl.footer:isShowTotalBetLayout(true)-- 隐藏掉  footer bet
    end

    if self.isFeatureLeft then
        self.theme.remainPointBet = true
        self.ctl:removePointBet()
        self.theme:lockLobbyBtn()
        self.ctl.footer:enableOtherBtns(false)
    end

    if self.callback then
        self.callback()
    end
    if self.theme.buyBackData then
        self.theme:collectFreeRollEnd()
    end
    self.theme.bonus = nil
    self.theme.remainPointBet = nil
end
---------------------------- bonus -> map_wheel  相关逻辑  start --------------------------------------
function bonusGame:enterWheelBonus(tryResume)
    self:initWheelBonusData()
    self:showWheelScene()
    self:exitWheelBonus()
end

function bonusGame:initWheelBonusData()
    self.winValue = self.data.core_data.total_win or 0
    self.bonusWinData = self.data.core_data.win_wheel
    self.bonusWheelWinList = self.bonusWinData.wheel_list
    self.bonusItemList = self.data.core_data.item_list

    self.theme.winBonusWheelData = tool.tableClone(self.data.core_data.win_wheel)
end

function bonusGame:showWheelScene()
    self.theme:playShowWheelNodeAnim("show", true) -- 显示转轮

    if self.theme.wheelRollItemDList then -- 显示转轮结果
        for k, nodeList in pairs(self.theme.wheelRollItemDList) do
            local winFeature = self.bonusWheelWinList[k] > 0
            local featurePosY = winFeature and -wheelBaseHeight/2 or wheelBaseHeight/2
            local normalPosY = winFeature and wheelBaseHeight/2 or -wheelBaseHeight/2

            for index, nodeData in pairs(nodeList) do
                if nodeData[1] > 0 then
                    nodeData[2]:setPositionY(featurePosY)
                else
                    nodeData[2]:setPositionY(normalPosY)
                end
            end
        end
    end

    if self.bonusWinData.turn_symbol then -- 显示中奖置换symbol
        self.theme.wheelEndNodeList[2]:setVisible(true)
        bole.updateSpriteWithFile(self.theme.wheelEndSpList[2], "#theme177_wheel_ui_s"..self.bonusWinData.turn_symbol..".png")
    end

    if self.bonusWinData.bg_multi then -- 显示中奖转轮倍数
        self.theme.wheelEndNodeList[3]:setVisible(true)
        self.theme.wheelEndSpList[3]:setString(self.bonusWinData.bg_multi.."X")
    end

    if self.bonusWinData.wild_pos then -- 显示中奖random wild
        self.theme.stickyWildList = {}
        for _, posData in pairs(self.bonusWinData.wild_pos) do
            local pos = self.theme:getCellPos(posData[1], posData[2])
            local _, s = self.theme:addSpineAnimation(self.theme.randomAnimNode, nil, self.theme:getPic("spine/item/1/spine"), pos, "animation", nil, nil, nil, true)
            self.theme.stickyWildList[posData[1]] = self.theme.stickyWildList[posData[1]] or {}
            self.theme.stickyWildList[posData[1]][posData[2]] = s
        end
    end

    if self.bonusItemList then -- 展示棋盘
        for col, colList in pairs(self.bonusItemList) do
            for row, key in pairs(colList) do
                local cell = self.theme.spinLayer.spins[col]:getRetCell(row)
                self.theme:updateCellSprite(cell, key%100, col, row)
            end
        end
    end
end

function bonusGame:exitWheelBonus()
    self.theme:dealMusic_PlayNormalLoopMusic()
    self.ctl:collectCoins(1)
    local rollEndFunc = function ( ... )
        self:onBonusOver()
    end
    self.ctl.totalWin = 0
    self.ctl:startRollup(self.winValue, rollEndFunc)
end


return ThemePowerOfDragons





