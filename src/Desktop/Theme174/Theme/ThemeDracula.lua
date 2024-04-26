-- 
-- @program src
-- @description: theme174  dracula
-- @author: rwb  art:zhouhuipeng+guoce,math:liuruoyu,other:shenjingya,
-- @create: 2019/12/10 12:18
--
local ThemeDracula = class("ThemeDracula", Theme)
local cls = ThemeDracula

-- 资源异步加载相关
cls.plistAnimate = {
    "image/plist/symbol",
    "image/plist/base",
}
cls.csbList = {
    "csb/base_game.csb",
}
local allCsbList = {
    ["base"] = "csb/base_game.csb",
    ["store"] = "csb/base_store.csb",
}
local transitionDelay = {
    ["free"] = { ["onCover"] = 20 / 30, ["onEnd"] = 62 / 30 },
}
local SpinBoardType = {
    Normal = 1,
    FreeSpin = 2,
    Pick = 3,
}
local specialSymbol = {
    ["trigger"] = 13, -- 触发free game
    ["trigger_2"] = 14,
    ["empty"] = 19,
    ["wild"] = 1,
}

local freeConfig = {
    [1] = {
        pos = { [1] = cc.p(-361.35, 128), [2] = cc.p(363, 128),
                [3] = cc.p(-361.35, -116), [4] = cc.p(363, -116) },
        scale = 0.8,


    }, -- 选择界面
    [2] = {

        pos = { [1] = cc.p(-212, 130), [2] = cc.p(212, 130),
                [3] = cc.p(-212, -130), [4] = cc.p(212, -130) },
        scale = 1,

    }, -- 选择完界面
    width = 376,
    height = 252,
    choosePos = cc.p(-249, 67)
}

local jackpotPoolKey = Set({ 26, 27, 28, 29 })

local buildLevel = { 2, 1, 1, --3
                     2, 1, 1, --6
                     2, 1, 1, --9
                     2, 1, 1, 1, --13
                     2, 1, 1, 1, --17
                     2, 1, 1, 1, --21
                     2, 1, 1, 1, --25
                     2, 1, 1, 1, 1, --30
                     3
}

local fs_show_type = {
    start = 1,
    more = 2,
    collect = 3,
    nocollect = 4
}
local moveWildTime = 60 / 30
local changeToWildTime = 20 / 30
local moveStartDelay = 30 / 30
local SpineConfig = {

    ----------------------------base-------------------------------
    base_bg = "spine/base/logo/bjxh",
    jili_bonus = "spine/base/jili/lzjl",
    jackpot_jili = "spine/jp/jp",

    transition_free = "spine/base/transition1/qp",
    ----------------------------collect----------------------------
    collect_top2 = "spine/collect/sjt_bianfu",
    collect_full = "spine/collect/sjt_jm",
    collect_lock = "spine/collect/sjt_sd",
    collect_receive = "spine/collect/scsj",
    collect_castle = "spine/collect/chengbao",
    ----------------------------store----------------------------
    store_item = "spine/store/yuanniu", --
    store_big_item = "spine/store/mubei", --
    store_bg = "spine/store/ditu_chj",
    store_castle = "spine/store/chengbao",
    ----------------------------dialog----------------------------
    dialog1_bg = "spine/dialog/pop1/fg_tch", --
    dialog1_btn = "spine/dialog/pop1/anniu_01", --

    dialog2_bg = "spine/dialog/pop2/jp_tch", --

    dialog4_bg = "spine/dialog/pop4/bf_tch",

    ----------------------------free----------------------------
    free_bg = "spine/free/hongxh",
    free_kuang = "spine/free/kuang_xh",
    free_chosen = "spine/free/kuanxuan",
    free_change = "spine/free/qpqiehuan",
    free_lean_out = "spine/free/banshend",
    free_hit = "spine/free/jk_tsh",
    free_move = "spine/item/move_1/spine",

    --move_lizi = "particle/bflizi.plist"
    ---------------------------lizi--------------------------
}

local SpineDialogConfig = {
    --[1] = "free_games",
    [1] = {--start
        [0] = {
            bg = { name = SpineConfig.dialog1_bg, showimg = true, parent = true, aniname = "animation" },
            --title = { name = SpineConfig.dialog1_title, showimg = true },
        },
        --[1] = {
        --    bg2 = { name = SpineConfig.dialog1_label, showimg = true, aniname = "animation1" },
        --    btn = { name = SpineConfig.dialog1_btn },
        --
        --},
        --[2] = { -- more
        --    bg2 = { name = SpineConfig.dialog1_label, showimg = true, aniname = "animation1" },
        --},
        [3] = { --collect
            --bg2 = { name = SpineConfig.dialog1_label, showimg = true, aniname = "animation2" },
            btn = { name = SpineConfig.dialog1_btn },
            maxWidth = 450,
        }
    },
    --[2] = "jackpot",
    [2] = {--
        [0] = {
            moon = { name = SpineConfig.dialog2_bg, showimg = true, parent = true, aniname = "animation5" },
            jackpot = { name = SpineConfig.dialog2_bg, showimg = true, parent = true },
        },

        [3] = { -- collect
            jackpot = { isImg = true, name = "#theme174_dialog2_jtext%s.png", parent = true, showimg = true, playCycle = true },
            btn = { name = SpineConfig.dialog1_btn },
            maxWidth = 450,
        },
    },
    --[2] = free_start
    [3] = {--
        [0] = {
            moon = { name = SpineConfig.dialog2_bg, showimg = true, patent = true, aniname = "animation5" },
            bat = { name = SpineConfig.dialog2_bg, showimg = true, patent = true, aniname = "animation" },
        },
        [1] = { -- collect
            desc_2 = { isImg = true, parent = true, showimg = true, playCycle = true },
        },
    },
    [4] = {--
        [0] = {
            bg = { name = SpineConfig.dialog4_bg, showimg = true, patent = true, aniname = "animation", notcycle = true },
        },

        [3] = { -- collect
            btn = { name = SpineConfig.dialog1_btn },
            maxWidth = 240,
        },
    },
}
function cls:getBoardConfig()
    if self.boardConfigList then
        return self.boardConfigList
    end

    local borderConfig = self.ThemeConfig["boardConfig"]

    local newConfig = {}
    for idx = 1, #borderConfig do
        local temp = borderConfig[idx]
        if not temp then
            return
        end
        local newReelConfig = {}
        if not temp.isFormat then
            for cnt, posList in pairs(temp.reelConfig) do
                local colCnt = temp.colCnt
                for col = 1, colCnt do
                    local oneConfig = {}
                    local posx = (col - 1) * (temp["cellWidth"]) + posList["base_pos"].x
                    local posy = posList["base_pos"].y
                    oneConfig["base_pos"] = cc.p(posx, posy)
                    oneConfig["symbolCount"] = temp["symbolCount"]
                    oneConfig["cellWidth"] = temp["cellWidth"]
                    oneConfig["cellHeight"] = temp["cellHeight"]
                    table.insert(newReelConfig, oneConfig)
                end

            end
        else
            newReelConfig = temp.reelConfig
        end
        borderConfig[idx]["colReelCnt"] = self.commonConfig.rowReelCnt
        borderConfig[idx]["colCnt"] = temp.colCnt
        borderConfig[idx]["reelConfig"] = newReelConfig
    end
    self.boardConfigList = self.ThemeConfig["boardConfig"]
    return self.boardConfigList
end
cls.spinTimeConfig = { -- spin 时间控制
    [1] = 81 / 60, -- 欺骗 比基础spin多加的时间 --42/60 在基础spin时间为81帧的时候
    [2] = 181 / 60, -- 出现大象比基础spin多加的时间  -- 181/60,
    ["base"] = 21 / 60,
    [0] = 39 / 60,
    ["spinMinCD"] = 50 / 60,
}
local G_cellHeight = 132
local G_cellWidth = 149

local delay = 0
local upBounce = G_cellHeight * 2 / 3
local upBounceMaxSpeed = 6 * 60
local upBounceTime = 0
local speedUpTime = 12 / 60
local rotateTime = 5 / 60
local maxSpeed = -30 * 60
local normalSpeed = -30 * 60
local fastSpeed = -30 * 60

local stopDelay = 20 / 60
local speedDownTime = 45 / 60
local downBounce = G_cellHeight * 1 / 5
local downBounceMaxSpeed = 10 * 60
local downBounceTime = 10 / 60
local specialAniTime = 0
local extraReelTime = 120 / 60
local specialExtraReelTime = 180 / 60
--local extraReelTimeInFreeGame = 480 / 60
local spinMinCD = 0.5
--local eachPiggyDelay = 1.5
-- 初始化
function cls:ctor(themeid)
    self.spinActionConfig = {
        ["start_index"] = 1,
        ["spin_index"] = 1,
        ["stop_index"] = 1,
        ["fast_stop_index"] = 1,
        ["special_index"] = 1
    }
    self.commonConfig = {

        ["colCnt"] = 5,
        ["rowReelCnt"] = 3,
        ["cellWidth"] = G_cellWidth,
        ["cellHeight"] = G_cellHeight,
        ["base_pos"] = cc.p(171, 119),

    }
    self.ThemeConfig = {
        ["theme_symbol_coinfig"] = {
            ["symbol_zorder_list"] = {
                [specialSymbol.wild] = 200,
                [specialSymbol.trigger] = 400,
                [specialSymbol.trigger_2] = 400,
                --[specialSymbol.bonus] = 300,

            },
            ["normal_symbol_list"] = {
                1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
            },
            ["no_roll_symbol_list"] = {
                0
            },
            ["special_symbol_list"] = {
                specialSymbol.trigger,
            },
            ["special_symbol_config"] = {
                [specialSymbol.trigger] = {
                    ["min_cnt"] = 6,
                    ["type"] = G_THEME_SYMBOL_TYPE.NUMBER,
                    ["col_set"] = {
                        [1] = 3,
                        [2] = 3, -- 1代表限制最多同时出现1个
                        [3] = 3,
                        [4] = 3,
                        [5] = 3,
                    },
                },
            },
        },
        ["theme_round_light_index"] = 1,
        ["theme_type"] = "payLine",
        ["theme_type_config"] = {
            ["pay_lines"] = {
                { 1, 1, 1, 1, 1 }, { 0, 0, 0, 0, 0 }, { 2, 2, 2, 2, 2 }, { 0, 1, 2, 1, 0 }, { 2, 1, 0, 1, 2 }, { 1, 0, 1, 0, 1 }, { 1, 2, 1, 2, 1 }, { 0, 1, 0, 1, 0 }, { 2, 1, 2, 1, 2 }, { 1, 0, 0, 0, 1 },
                { 1, 2, 2, 2, 1 }, { 2, 2, 1, 2, 2 }, { 0, 0, 1, 0, 0 }, { 2, 1, 1, 1, 2 }, { 0, 1, 1, 1, 0 }, { 0, 2, 0, 2, 0 }, { 2, 0, 2, 0, 2 }, { 1, 1, 0, 1, 1 }, { 1, 1, 2, 1, 1 }, { 2, 2, 0, 2, 2 },
                { 0, 0, 2, 0, 0 }, { 0, 0, 1, 2, 2 }, { 2, 2, 1, 0, 0 }, { 1, 0, 2, 0, 1 }, { 1, 2, 0, 2, 1 }, { 1, 2, 1, 0, 0 }, { 1, 0, 1, 2, 2 }, { 0, 1, 2, 2, 2 }, { 2, 1, 0, 0, 0 }, { 0, 0, 0, 1, 2 },
                { 2, 2, 2, 1, 0 }, { 1, 0, 1, 2, 1 }, { 1, 2, 1, 0, 1 }, { 0, 1, 1, 1, 1 }, { 2, 1, 1, 1, 1 }, { 0, 0, 1, 1, 1 }, { 2, 2, 1, 1, 1 }, { 2, 1, 2, 1, 0 }, { 0, 1, 0, 1, 2 }, { 1, 0, 0, 0, 0 },
                { 1, 2, 2, 2, 2 }, { 0, 0, 0, 1, 0 }, { 2, 2, 2, 1, 2 }, { 0, 1, 0, 0, 0 }, { 2, 1, 2, 2, 2 }, { 1, 0, 1, 1, 1 }, { 1, 2, 1, 1, 1 }, { 0, 0, 0, 0, 2 }, { 2, 2, 2, 2, 0 }, { 1, 1, 1, 0, 1 },

            },
            ["line_cnt"] = 50,
        },
        ["boardConfig"] = {
            { -- 3x6 base 1 个棋盘
                ["allow_over_range"] = true,
                ["colCnt"] = 6,
                ["symbolCount"] = 3,
                ["cellWidth"] = self.commonConfig.cellWidth,
                ["cellHeight"] = self.commonConfig.cellHeight,
                ["isFormat"] = true,
                ["reelConfig"] = {
                    {
                        ["base_pos"] = self.commonConfig.base_pos,
                        ["cellWidth"] = self.commonConfig.cellWidth,
                        ["cellHeight"] = self.commonConfig.cellHeight,
                        ["symbolCount"] = 3
                    },
                    {
                        ["base_pos"] = cc.pAdd(self.commonConfig.base_pos, cc.p(G_cellWidth, 0)),
                        ["cellWidth"] = G_cellWidth,
                        ["cellHeight"] = G_cellHeight,
                        ["symbolCount"] = 3
                    },
                    {
                        ["base_pos"] = cc.pAdd(self.commonConfig.base_pos, cc.p(G_cellWidth * 2, 0)),
                        ["cellWidth"] = G_cellWidth,
                        ["cellHeight"] = G_cellHeight,
                        ["symbolCount"] = 3
                    },
                    {
                        ["base_pos"] = cc.pAdd(self.commonConfig.base_pos, cc.p(G_cellWidth * 3, 0)),
                        ["cellWidth"] = G_cellWidth,
                        ["cellHeight"] = G_cellHeight,
                        ["symbolCount"] = 3
                    },
                    {
                        ["base_pos"] = cc.pAdd(self.commonConfig.base_pos, cc.p(G_cellWidth * 4, 0)),
                        ["cellWidth"] = G_cellWidth,
                        ["cellHeight"] = G_cellHeight,
                        ["symbolCount"] = 3
                    },
                    {
                        ["base_pos"] = cc.pAdd(self.commonConfig.base_pos, cc.p(G_cellWidth * 5 + 28, 0)),
                        ["cellWidth"] = 196,
                        ["cellHeight"] = G_cellHeight,
                        ["symbolCount"] = 3,
                    },

                },

            },
            { -- 3x5 -- free 4个棋盘
                ["allow_over_range"] = true,
                ["reel_single"] = true,
                ["colCnt"] = 5,
                ["symbolCount"] = 3,
                ["cellWidth"] = self.commonConfig.cellWidth,
                ["cellHeight"] = self.commonConfig.cellHeight,
                ["reelConfig"] = {

                    { ["base_pos"] = cc.p(519, 860) },
                    { ["base_pos"] = cc.p(1404, 860) },
                    { ["base_pos"] = cc.p(519, 322) },
                    { ["base_pos"] = cc.p(1404, 322) },

                }
            },

        }
    }

    self.baseBet = 10000
    self.DelayStopTime = 0
    self.UnderPressure = 1 -- 下压上 控制

    local use_portrait_screen = false -- true 代表竖屏
    local ret = Theme.ctor(self, themeid, use_portrait_screen)
    return ret
end
function cls:initBoardNodes(pBoardConfigList)
    local boardRoot = self.boardRoot
    local boardConfigList = pBoardConfigList or self.boardConfigList or {}
    local reelZorder = 100
    --self.clipData = {}
    local pBoardNodeList = {}
    -- 棋盘初始化
    for boardIndex, theConfig in ipairs(boardConfigList) do
        local theBoardNode = nil
        local reelNodes = {}
        if theConfig["reel_single"] then
            -- 一个棋盘用一个裁剪区域
            local rowReelCnt = 3
            local colCnt = 5
            --self.clipData["reel_single"] = {}
            local reelNode = cc.Node:create()
            reelNode:setLocalZOrder(reelZorder)
            theBoardNode = cc.Node:create()
            boardRoot:addChild(theBoardNode)

            local clipNode = nil
            local reelNode = nil
            local boardH = G_cellHeight * rowReelCnt
            local down_rx = G_cellWidth * colCnt

            for reelIndex, config in ipairs(theConfig["reelConfig"]) do
                if (reelIndex - 1) % colCnt == 0 then
                    reelNode = cc.Node:create()
                    reelNode:setLocalZOrder(reelZorder)
                    local vex = {
                        config["base_pos"], -- 第一个轴的左下角  下左边界
                        cc.pAdd(config["base_pos"], cc.p(down_rx, 0)), -- 下右边界
                        cc.pAdd(config["base_pos"], cc.p(down_rx, boardH)), -- 上右边界
                        cc.pAdd(config["base_pos"], cc.p(0, boardH)), -- 上左边界
                    }

                    if theConfig["allow_over_range"] then
                        vex[1] = cc.pAdd(vex[1], cc.p(-config["cellWidth"], 0))
                        vex[4] = cc.pAdd(vex[4], cc.p(-config["cellWidth"], 0))

                        vex[2] = cc.pAdd(vex[2], cc.p(config["cellWidth"], 0))
                        vex[3] = cc.pAdd(vex[3], cc.p(config["cellWidth"], 0))
                    end
                    local stencil = cc.DrawNode:create()
                    stencil:drawPolygon(vex, #vex, cc.c4f(1, 1, 1, 1), 0, cc.c4f(1, 1, 1, 1))

                    local clipAreaNode = cc.Node:create()
                    clipAreaNode:addChild(stencil)
                    clipNode = cc.ClippingNode:create(clipAreaNode)

                    theBoardNode:addChild(clipNode)
                    clipNode:addChild(reelNode)
                end
                reelNodes[reelIndex] = reelNode
                --self.clipData["reel_single"][reelIndex] = {}
                --self.clipData["reel_single"][reelIndex]["vex"] = vex
                --self.clipData["reel_single"][reelIndex]["stencil"] = stencil
            end
        else
            --self.clipData["normal"] = {}
            local reelNode = cc.Node:create()
            reelNode:setLocalZOrder(reelZorder)
            theBoardNode = cc.Node:create()
            -- theBoardNode:setPosition(theConfig["base_pos"])
            boardRoot:addChild(theBoardNode)
            local clipAreaNode = cc.Node:create()
            for reelIndex, config in ipairs(theConfig["reelConfig"]) do
                local vex = {
                    config["base_pos"], -- 第一个轴的左下角  下左边界
                    cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], 0)), -- 下右边界
                    cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], config["cellHeight"] * config["symbolCount"])), -- 上右边界
                    cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"] * config["symbolCount"])), -- 上左边界
                }
                if theConfig["allow_over_range"] then
                    vex[1] = cc.pAdd(vex[1], cc.p(-config["cellWidth"], 0))
                    vex[4] = cc.pAdd(vex[4], cc.p(-config["cellWidth"], 0))

                    vex[2] = cc.pAdd(vex[2], cc.p(config["cellWidth"], 0))
                    vex[3] = cc.pAdd(vex[3], cc.p(config["cellWidth"], 0))
                end
                local stencil = cc.DrawNode:create()
                stencil:drawPolygon(vex, #vex, cc.c4f(1, 1, 1, 1), 0, cc.c4f(1, 1, 1, 1))
                clipAreaNode:addChild(stencil)
                reelNodes[reelIndex] = reelNode

                --self.clipData["normal"][reelIndex] = {}
                --self.clipData["normal"][reelIndex]["vex"] = vex
                --self.clipData["normal"][reelIndex]["stencil"] = stencil
            end
            local clipNode = cc.ClippingNode:create(clipAreaNode)

            theBoardNode:addChild(clipNode)
            clipNode:addChild(reelNode)
        end

        theBoardNode.reelNodes = reelNodes
        theBoardNode.reelConfig = theConfig["reelConfig"]
        theBoardNode.boardIndex = boardIndex
        theBoardNode.getReelNode = function(theSelf, index)
            return theSelf.reelNodes[index]
        end
        pBoardNodeList[boardIndex] = theBoardNode
    end
    return pBoardNodeList
end
----------------------------------------- 滚轴相关 -----------------------------------
function cls:getSpinConfig(spinTag)
    local spinConfig = {}

    if self.showSpinBoard == SpinBoardType.FreeSpin then
        for i = 1, 20 do
            local col = i
            local tempCol = (i - 1) % 5 + 1
            local theStartAction = self:getSpinColStartAction(tempCol, col)
            local theReelConfig = {
                ["col"] = col,
                ["action"] = theStartAction,
            }
            table.insert(spinConfig, theReelConfig)
        end
    else
        for col, _ in pairs(self.spinLayer.spins) do
            local theStartAction = self:getSpinColStartAction(col)
            local theReelConfig = {
                ["col"] = col,
                ["action"] = theStartAction,
            }
            table.insert(spinConfig, theReelConfig)
        end
    end
    return spinConfig
end

function cls:getStopConfig(ret, spinTag, interval)
    local stopConfig = {}

    if self.showSpinBoard == SpinBoardType.FreeSpin then
        for col = 1, 20 do
            local tempCol = (col - 1) % 5 + 1
            local theAction = self:getSpinColStopAction(ret["theme_info"], tempCol, interval)
            table.insert(stopConfig, { col, theAction })
        end
    else
        for col = 1, #self.spinLayer.spins do
            local theAction = self:getSpinColStopAction(ret["theme_info"], col, interval)
            table.insert(stopConfig, { col, theAction })
        end
    end

    return stopConfig
end

function cls:getSpinColStartAction(pCol, reelCol)
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
function cls:getSpinColStopAction(themeInfoData, pCol, interval)
    if pCol == 1 then
        -- 同时下落的时候 进行的 延迟 重置
        self.DelayStopTime = 0
    end
    if self.showSpinBoard ~= SpinBoardType.FreeSpin then
        local checkNotifyTag = self:checkNeedNotify(pCol, themeInfoData)
        if checkNotifyTag then
            if pCol == 6 then
                self.DelayStopTime = self.DelayStopTime + specialExtraReelTime
            else
                self.DelayStopTime = self.DelayStopTime + extraReelTime
            end
        end
    end

    local spinAction = {}
    spinAction.actions = {}

    local temp = interval - speedUpTime - upBounceTime
    local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0
    if self.haveSpecialdelay then
        spinAction.stopDelay = timeleft + (pCol - 1) * stopDelay + self.DelayStopTime + self.speicalDelay
        self.ExtraStopCD = self.speicalDelay
    else
        self.ExtraStopCD = spinMinCD - temp > 0 and spinMinCD - temp or 0
        spinAction.stopDelay = timeleft + (pCol - 1) * stopDelay + self.DelayStopTime
    end
    spinAction.maxSpeed = maxSpeed
    spinAction.speedDownTime = speedDownTime
    if self.isTurbo then
        spinAction.speedDownTime = speedDownTime
    end
    spinAction.downBounce = downBounce
    spinAction.downBounceMaxSpeed = downBounceMaxSpeed
    spinAction.downBounceTime = downBounceTime
    spinAction.stopType = 1
    return spinAction
end
function cls:onSpinStart()
    self.DelayStopTime = 0
    self.isGetJackPot = false
    self:enableMapInfoBtn(false)
    self.isJpAnticipation = false

    self.haveMoveWildAnim = false

    Theme.onSpinStart(self)


end

function cls:onSpinStop(ret)
    self:fixRet(ret)

    Theme.onSpinStop(self, ret)
end

function cls:onReelFallBottom(pCol)
    -- 标志位


    self.reelStopMusicTagList[pCol] = true

    -- 列停音效，提示动画相关
    if not self:checkPlaySymbolNotifyEffect(pCol) then
        self:dealMusic_PlayShortNotifyMusic(pCol)
    end
    self:dealMusic_StopReelNotifyMusic(pCol)
    self:onReelFallBottomJiLi(pCol)

    self:playWildNotifyEffect(pCol)


end
function cls:onReelFallBottomJiLi(pCol, isFastFall)

    self:stopReelNotifyEffect(pCol)
    if pCol <= 5 then
        if self.speedUpState[pCol] and self.speedUpState[pCol][specialSymbol.trigger] then
            local posInfo = self.speedUpState[pCol][specialSymbol.trigger]

            if pCol < 5 and posInfo.real_cnt >= 3 and not isFastFall then
                self:onReelNotifyStopBeg(pCol + 1, specialSymbol.trigger, true)
            end
            local max = posInfo["real_cnt"] + posInfo["max_left"]
            if posInfo["is_get"] then

                if max >= 6 then
                    self:playReelNotifyEffect(pCol)
                else
                    self:stopReelNotifyEffect()
                end
            else
                if max < 6 then
                    self:stopReelNotifyEffect()

                end
            end
        else
            self:stopReelNotifyEffect()
        end
    end

    if self.showSpinBoard == SpinBoardType.Normal then
        if pCol == 5 and self.isJpAnticipation and not self.fastStopMusicTag then
            self:playReelNotifyEffect(6)
            self:dealMusic_PlayReelNotifyMusic(6)
        end
    end

end

function cls:onReelNotifyStopBeg(pCol, itemKey, isNext)

    if not self.reelNotifyEffectList or not self.reelNotifyEffectList[itemKey] or not self.reelNotifyEffectList[itemKey][pCol] then
        if isNext and itemKey == specialSymbol.trigger then
            self:playReelNotifyEffect(pCol, isNext)
        end
        if isNext then
            local min = self.specialItemConfig[itemKey].min_cnt
            if self.speedUpState[pCol][itemKey]["cnt"] >= min then
                self:dealMusic_PlayReelNotifyMusic(pCol)
            end
        end
    end
end
function cls:onReelFastFallBottom(pCol)

    self.reelStopMusicTagList[pCol] = true
    self:dealMusic_StopReelNotifyMusic(pCol)
    if not self.fastStopMusicTag then
        local hasNotify = false
        for a = pCol, #self.spinLayer.spins do
            local reelSymbolState = self.notifyState[a]
            if reelSymbolState and bole.getTableCount(reelSymbolState) > 0 then
                hasNotify = true
                break
            end
        end
        if not hasNotify then
            self:dealMusic_PlayReelStopMusic()
        end
    end
    self:checkPlaySymbolNotifyEffect(pCol, true)
    self.fastStopMusicTag = self.fastStopMusicTag or "allow_music"
    self:playWildNotifyEffect(pCol)
    self:onReelFallBottomJiLi(pCol, true)
    for itemKey, theItemConfig in pairs(self.specialItemConfig) do
        if self:checkSpeedUpStop(pCol, itemKey) then
            self:onReelNotifyStopBeg(pCol, itemKey, false)
        end
    end


end
function cls:onReelStop(col)

end
function cls:stopReelNotifyEffect(pCol)
    self.reelNotifyEffectList = self.reelNotifyEffectList or {}
    if not pCol then
        for col = 1, 5 do
            self:stopSingleReelNotifyEffect(col)
        end
        self.reelNotifyEffectList = nil
        return
    else
        self:stopSingleReelNotifyEffect(pCol)
    end
end
function cls:stopSingleReelNotifyEffect(pCol)
    if self.reelNotifyEffectList and self.reelNotifyEffectList[pCol] then

        for key, item in pairs(self.reelNotifyEffectList[pCol]) do

            if not tolua.isnull(item) then
                item:removeFromParent()
            end
        end
    end
    self.reelNotifyEffectList[pCol] = nil
    if pCol == 6 then
        self:stopJackPotReelNotify()
    end
end
function cls:stopJackPotReelNotify()
    self.fastReelBg:stopAllActions()
    if self.fastRoot.jiliSpine and bole.isValidNode(self.fastRoot.jiliSpine) then

        local node = self.fastRoot.jiliSpine
        node:stopAllActions()
        local a1 = cc.Sequence:create(
                cc.FadeOut:create(0.5),
                cc.RemoveSelf:create()
        )
        node:runAction(a1)
    end
    self.fastRoot.jiliSpine = nil
    local type = 4
    if self.isGetJackPot then
        type = 3
    end
    if self.fastRoot.spinType == type then
        return
    end
    self.fastRoot.spinType = type
    bole.spChangeAnimation(self.fastRoot.spine, "animation" .. type, true)

end
function cls:finshSpin()
    if (not self.ctl.freewin) and (not self.ctl.autoSpin) and not self.bonus then
        self:enableMapInfoBtn(true)
    end
end
function cls:onAllReelStop()
    Theme.onAllReelStop(self)
end
function cls:playReelNotifyEffect(pCol, isNext)
    -- 播放特殊的 等待滚轴结果的
    local pos = self:getCellPos(pCol, 2)
    self.reelNotifyEffectList = self.reelNotifyEffectList or {}
    self.reelNotifyEffectList[pCol] = {}
    if pCol <= 5 then
        local pos = self:getCellPos(pCol, 2)
        local p1 = cc.pAdd(pos, cc.p(-2, 0))
        if isNext then
            local _, s1 = bole.addSpineAnimation(self.animateNode, nil, self:getPic(SpineConfig.jili_bonus), p1, "animation2", nil, nil, nil, true, true)-- 出现
            table.insert(self.reelNotifyEffectList[pCol], s1)
        else
            local _, s1 = bole.addSpineAnimation(self.jiliBgNode, nil, self:getPic(SpineConfig.jili_bonus), p1, "animation1", nil, nil, nil, true, true)-- 出现
            table.insert(self.reelNotifyEffectList[pCol], s1)
        end

    else

        self.fastRoot.spinType = 1
        bole.spChangeAnimation(self.fastRoot.spine, "animation1", true)
        local a1 = cc.Sequence:create(
                cc.DelayTime:create(30 / 30),
                cc.CallFunc:create(
                        function()
                            self.fastRoot.spinType = 2
                            bole.spChangeAnimation(self.fastRoot.spine, "animation2", false)
                        end
                ),
                cc.DelayTime:create(15 / 30),
                cc.CallFunc:create(
                        function()
                            self.fastRoot.spinType = 3
                            bole.spChangeAnimation(self.fastRoot.spine, "animation3", true)

                        end)

        )
        libUI.runAction(self.fastReelBg, a1)
        local pos = cc.p(397, -57)
        local parent = self.fastRoot
        local file = self:getPic(SpineConfig.jackpot_jili)
        local parent = cc.Node:create()
        self.fastRoot:addChild(parent, 1)
        local _, s = self:addSpineAnimation(parent, nil, file, pos, "animation5", nil, nil, nil, true, true)
        self.fastRoot.jiliSpine = parent
        bole.setEnableRecursiveCascading(parent, true)

        parent:setOpacity(0)
        parent:runAction(cc.FadeIn:create(0.5))


    end

end
function cls:checkNeedNotify(pCol, themeInfoData)
    local isSpeedUp = false
    if self.showSpinBoard == SpinBoardType.FreeSpin then
        return false
    end
    if pCol == 6 then
        if self.isJpAnticipation then
            isSpeedUp = true
        end
    else
        if self:checkSpeedUp(pCol) then

            if self.speedUpState[pCol][specialSymbol.trigger] and self.speedUpState[pCol][specialSymbol.trigger]["cnt"] >= 6 then
                isSpeedUp = true
            end
        end
    end
    return isSpeedUp

end
function cls:checkSpeedUp(checkCol)
    local isNeedSpeedUp = false
    if self.speedUpState and self.speedUpState[checkCol] then
        isNeedSpeedUp = true

    end
    return isNeedSpeedUp
end
function cls:checkSpeedUpStop(checkCol, itemKey)
    local isNeedSpeedUp = false
    if self.speedUpState and self.speedUpState[checkCol] and self.speedUpState[checkCol][itemKey] then
        local info = self.speedUpState[checkCol]
        if info.is_get then
            isNeedSpeedUp = true
        end
    end
    return isNeedSpeedUp
end
function cls:checkPlaySymbolNotifyEffect(pCol, fastStopMusicTag)
    -- 是否播放特殊symbol 的 下落音效
    local isPlaySymbolNotify = false
    if not fastStopMusicTag then
        -- 不是快停状态 判断是否播放特殊symbol的动画
        isPlaySymbolNotify = self:dealMusic_PlaySpecialSymbolStopMusic(pCol)-- 判断是否播放特殊symbol的动画
    elseif fastStopMusicTag and not self.fastStopMusicTag then
        --快停情况下 播放滚轴音效
        --if pCol == #self.spinLayer.spins then
        local key1 = nil
        if self.notifyState then
            for col = pCol, 5 do
                local item = self.notifyState[col]
                -- 判断在剩下停止的滚轴中是否有特殊symbol
                if item and bole.getTableCount(item) > 0 then
                    self:playSymbolNotifyEffect(col, fastStopMusicTag)

                    if item[specialSymbol.trigger] then
                        -- 播放free symbol 下落特效
                        key1 = "symbol_scatter" .. col
                    end
                    self.notifyState[col] = {}
                end
            end
        end
        if self.isGetJackPot then
            self:playEffectWithInterval(self.audio_list.symbol_jackpot)
        end
        if key1 then
            self:playEffectWithInterval(self.audio_list[key1])
            isPlaySymbolNotify = true
            --end
        end
    end
    return isPlaySymbolNotify
end

function cls:dealMusic_PlaySpecialSymbolStopMusic(pCol)
    self.notifyState = self.notifyState or {}
    if pCol == 6 and self.isGetJackPot then
        self:playMusic(self.audio_list["symbol_jackpot"])
        return true
    end
    if (not self.notifyState[pCol]) or bole.getTableCount(self.notifyState[pCol]) == 0 then
        return false
    end

    local ColNotifyState = self.notifyState[pCol]
    local haveSymbolLevel = 0
    if ColNotifyState[specialSymbol.trigger] then
        -- scatter
        haveSymbolLevel = 1

    end
    if ColNotifyState[specialSymbol.bonus] then
        -- scatter
        haveSymbolLevel = haveSymbolLevel + 10
    end
    if haveSymbolLevel > 0 then
        self:playSymbolNotifyEffect(pCol)-- 播放特殊symbol 下落特效
    end
    if haveSymbolLevel % 10 == 1 then
        self.notifyState[pCol] = {}
        local getReel = 1
        if self.speedUpState and self.speedUpState[pCol] and self.speedUpState[pCol][specialSymbol.trigger] and self.speedUpState[pCol][specialSymbol.trigger]["get_reel"] then
            getReel = self.speedUpState[pCol][specialSymbol.trigger]["get_reel"]
        end
        self:playMusic(self.audio_list["symbol_scatter" .. getReel])
    end
    if math.floor(haveSymbolLevel / 10) == 1 then
        self.notifyState[pCol] = {}
        --self:playMusic(self.audio_list.respin_landing)

    end
    return haveSymbolLevel > 0
end
function cls:initSpinLayerBg()

    self:setCollectProgressImagePos()

    self:enableMapInfoBtn(true)

    self:addFastJackPot()
    Theme.initSpinLayerBg(self)
end

-- 初始化spinNode
function cls:initSpinLayer()
    self.spinLayerList = {}
    for index, cofig in pairs(self.boardNodeList) do
        self.initBoardIndex = index
        local boardNode = self.boardNodeList[index]
        local layer = SpinLayer.new(self, self.ctl, boardNode.reelConfig, boardNode)
        layer:DeActive()
        self.shakyNode:addChild(layer, -1)
        table.insert(self.spinLayerList, layer)
    end
end
function cls:addFastJackPot()
    ---animation1  激励开始
    ---animation2 石像解锁
    ---animation3 循环
    ---animation4 idle

    local pos = cc.p(397, -57)
    local parent = self.fastRoot
    local file = self:getPic(SpineConfig.jackpot_jili)
    --local aniName = "animation4"
    self.fastRoot.spinType = 4
    if self.isGetJackPot then
        --aniName = "animation3"
        self.fastRoot.spinType = 3
    end
    local _, s = self:addSpineAnimation(parent, 2, file, pos, "animation" .. self.fastRoot.spinType, nil, nil, nil, true, true, nil)
    self.fastRoot.spine = s


end
function cls:changeSpinBoard(pType)
    -- 更改背景控制 已修改
    self:clearAnimate()
    if pType == SpinBoardType.Normal then
        -- normal情况下 需要更改棋盘底板
        if self.spinLayer ~= self.spinLayerList[1] then
            self.spinLayer:DeActive()
            self.spinLayer = self.spinLayerList[1]
            self.spinLayer:Active()
        end
        self.initBoardIndex = 1
        local isBase = true
        self.mapCollectRoot:setVisible(isBase)
        self.reelRoot:setVisible(isBase)
        self.reelRoot:setScale(1)

        self.reelRoot2:setVisible(isBase)
        self.reelRoot2:setScale(1)

        self.reelRootNode:setVisible(isBase)

        self.reelFreeNode:setVisible(not isBase)
        self.reelFreeBGNode:setVisible(not isBase)
        self.fastRoot:setVisible(isBase)
        self.wildMaskNode:setVisible(not isBase)
        --self.reelNode50:setVisible(isBase)
        self.progressiveNode:setVisible(isBase)
        self.freeEarsNode:setVisible(not isBase)
        --for key, item in ipairs(self.reelBgList) do
        --    local color = cc.c3b(255, 255, 255)
        --    item:setColor(color)
        --end
    elseif pType == SpinBoardType.FreeSpin then


        if self.spinLayer ~= self.spinLayerList[2] then
            self.spinLayer:DeActive()
            self.spinLayer = self.spinLayerList[2]
            self.spinLayer:Active()
        end
        self.initBoardIndex = 2

        local isBase = true
        self.progressiveNode:setVisible(not isBase)
        self.reelRoot:setVisible(isBase)
        self.reelRoot:setScale(0.48)

        self.reelRoot2:setVisible(isBase)
        self.reelRoot2:setScale(0.48)

        self.reelRootNode:setVisible(not isBase)
        self.reelFreeNode:setVisible(isBase)
        self.reelFreeBGNode:setVisible(isBase)
        self.mapCollectRoot:setVisible(not isBase)
        self.fastRoot:setVisible(not isBase)
        self.wildMaskNode:setVisible(isBase)
        self.wildMaskNode:setOpacity(0)
        self.freeEarsNode:setVisible(true)

    elseif pType == SpinBoardType.Pick then
        local isBase = false
        self.progressiveNode:setVisible(isBase)
        self.reelRoot:setVisible(isBase)
        self.reelRoot2:setVisible(isBase)
        self.reelRootNode:setVisible(isBase)
        self.reelFreeNode:setVisible(not isBase)
        self.reelFreeBGNode:setVisible(isBase)
        self.mapCollectRoot:setVisible(isBase)
        self.fastRoot:setVisible(isBase)
        self.wildMaskNode:setVisible(isBase)
        self.wildMaskNode:setOpacity(0)
        self.freeEarsNode:setVisible(isBase)
    end
    self.showSpinBoard = pType
    self:changeBg(pType)
end
function cls:changeBg(pType)

    local imgBG = { self.baseBg, self.freeBg, self.freeBg }
    local showBg = imgBG[pType]
    if not self.curBg or self.curBg ~= showBg then
        local _curBg = self.curBg
        _curBg:runAction(cc.Sequence:create(cc.FadeTo:create(0.5, 0), cc.DelayTime:create(0.5), cc.CallFunc:create(function(...)
            _curBg:setVisible(false)
        end)))
        showBg:setOpacity(0)
        showBg:setVisible(true)
        showBg:runAction(cc.FadeTo:create(0.5, 255))
        self.curBg = showBg
    end
    self:initBaseSpine()

end
function cls:initBaseSpine()


    local bg_window = self.baseBg:getChildByName("bg_window")
    bg_window:stopAllActions()
    if self.baseBg == self.curBg then
        self.baseBg.weather = self.baseBg.weather or 1
        bg_window:runAction(
                cc.RepeatForever:create(
                        cc.Sequence:create(
                                cc.CallFunc:create(function()
                                    self:randomWeather()
                                end),
                                cc.DelayTime:create(6)
                        )
                )
        )
    end
end
function cls:randomWeather()
    local spine = self.baseBg:getChildByName("spine")
    local bg_dark = self.baseBg:getChildByName("bg_dark")

    local weather = (self.baseBg.weather % 2) + 1
    self.baseBg.weather = weather
    local ani = "animation" .. weather
    if not spine.base_bg then
        local _, s1 = bole.addSpineAnimation(spine, nil, self:getPic(SpineConfig.base_bg), cc.p(0, 0), ani, nil, nil, nil, true, false)--  闪电
        spine.base_bg = s1
        if weather == 2 then
            bg_dark:setOpacity(255)
        else
            bg_dark:setOpacity(0)
        end
    else
        bg_dark:stopAllActions()
        local startOpcity = 0
        local endOpcity = 255

        if weather == 1 then
            startOpcity = 255
            endOpcity = 0

        end
        bg_dark:runAction(
                cc.Sequence:create(
                        cc.FadeTo:create(0.5, endOpcity),
                        cc.DelayTime:create(1),
                        cc.CallFunc:create(
                                function()
                                    bole.spChangeAnimation(spine.base_bg, ani, false)
                                end
                        ),
                        cc.DelayTime:create(2),
                        cc.CallFunc:create(
                                function()
                                    bole.spChangeAnimation(spine.base_bg, ani, false)
                                end
                        )
                )
        )
    end
end


-----------------------------------------------------------------------------------------------------------
-- 主题布局相关
------------------------------------------------------------------------------------------------------------
function cls:initScene(spinNode)
    local path = self:getPic(allCsbList.base)
    self.mainThemeScene = cc.CSLoader:createNode(path)
    ---@see  bg node
    self.bgRoot = self.mainThemeScene:getChildByName("theme_bg")
    self.baseBg = self.bgRoot:getChildByName("bg_base")
    self.freeBg = self.bgRoot:getChildByName("bg_free")
    --self.respinBg = self.bgRoot:getChildByName("bg_respin")
    self.baseBg:setVisible(true)
    self.curBg = self.baseBg
    self.freeBg:setVisible(false)

    self.down_node = self.mainThemeScene:getChildByName("down_child")
    bole.adaptScale(self.mainThemeScene, false)
    self.down_child = self.down_node:getChildByName("down_child")

    self.reelRoot = self.down_child:getChildByName("node_board_root")
    self.reelRoot2 = self.down_child:getChildByName("node_board_root2")

    ---@see reelRoot child


    self.jiliBgNode = self.reelRoot:getChildByName("jili_bg")
    self.jiliBgNode:setLocalZOrder(1)
    self.boardRoot = self.reelRoot:getChildByName("board_root") --1
    self.boardRoot:setLocalZOrder(2)
    self.fastRoot = self.reelRoot2:getChildByName("fast_node") --1
    self.fastRoot:setLocalZOrder(3)
    self.animateNode = self.reelRoot2:getChildByName("animate_node") -- 动画
    self.animateNode:setLocalZOrder(4)
    self.themeAnimateKuang = self.reelRoot2:getChildByName("scatter_node")
    self.themeAnimateKuang:setLocalZOrder(5)
    self.bonusflyNode = self.reelRoot2:getChildByName("fly_node")
    self.bonusflyNode:setLocalZOrder(6)

    self.wildMaskNode = self.down_child:getChildByName("mask_node")
    --self.wildMaskNode:setLocalZOrder(7)
    bole.setEnableRecursiveCascading(self.wildMaskNode, true)
    self.wildMaskNode:setOpacity(0)
    self.moveWildNode = cc.Node:create()
    self.reelRoot2:addChild(self.moveWildNode, 8)

    self.scatterCountNode = cc.Node:create()
    self.reelRoot2:addChild(self.scatterCountNode, 10)
    --self.wildMaskNode = self.reelRoot:getChildByName("wild_mask")
    --self.wildMaskNode:setLocalZOrder(7)
    ---@see collect
    self.mapCollectRoot = self.down_child:getChildByName("collect_node")
    self:initCollectNode()
    local storeNode = self.down_child:getChildByName("store_node")
    self.storeChildNode = storeNode:getChildByName("store_child")
    ---@see jackpot node
    self.progressiveNode = self.down_child:getChildByName("progressive")
    self:initialJackpotNode()
    ---@see 棋盘
    self.reelRootNode = self.down_child:getChildByName("reel_base_node")
    self.fastReelBg = self.reelRootNode:getChildByName("fast_node_bg")
    self.reelFreeBGNode = self.down_child:getChildByName("reel_free_node")
    self.reelFreeNode = self.down_child:getChildByName("free_out_node")
    self.freeEarsNode = self.reelFreeNode:getChildByName("free_ears")
    self:initFreeWinNode()
    --self.reelNode50 = self.reelRootNode:getChildByName("reel_50")
    --self.reelBgList = self.reelRootNode:getChildByName("theme_floor_5"):getChildren()

    ---@see pickNode
    --self.pickNode = self.down_child:getChildByName("pick_node")
    self.baseStoreNode = self.down_child:getChildByName("store_node")

    self.shakyNode:addChild(self.mainThemeScene)
end
function cls:initFreeWinNode()

    self.freeDialogNode = self.reelFreeNode:getChildByName("free_dailog")
    self.freeBoardNode = self.reelFreeNode:getChildByName("free_root")
    self.freeBoardBgNode = self.reelFreeNode:getChildByName("free_bg")

    self.freeWinNodeList = {}
    local function parseValue1(num)
        return FONTS.formatByCount4(num, 12, false)
    end
    for boardIndex = 1, 4 do
        local parent = self.freeBoardNode:getChildByName("free_board_" .. boardIndex)
        local winNode = parent:getChildByName("collect_node")
        self.freeWinNodeList[boardIndex] = {}
        self.freeWinNodeList[boardIndex][1] = winNode:getChildByName("win_coins")
        self.freeWinNodeList[boardIndex][1].maxWidth = 166
        self.freeWinNodeList[boardIndex][1].baseScale = 0.7
        inherit(self.freeWinNodeList[boardIndex][1], LabelNumRoll)
        self.freeWinNodeList[boardIndex][1]:nrInit(0, 24, parseValue1)

        self.freeWinNodeList[boardIndex][2] = winNode:getChildByName("win_item")
        self.freeWinNodeList[boardIndex][2].maxWidth = 70
        self.freeWinNodeList[boardIndex][2].baseScale = 0.7
        --local parent2 = parent:getChildByName("reel_root_node")
        self.freeWinNodeList[boardIndex][3] = parent

    end
end
function cls:refreshFreeWinInfo()
    for boardIndex = 1, 4 do
        local winNode = self.freeWinNodeList[boardIndex]
        if self.freeWinCoinsList and self.freeWinCoinsList[boardIndex] > 0 then
            local showStr = FONTS.formatByCount4(self.freeWinCoinsList[boardIndex], 12, false)
            winNode[1]:setString(showStr)
            bole.shrinkLabel(winNode[1], winNode[1].maxWidth, winNode[1].baseScale)
        else
            winNode[1]:setString("")
        end
        if self.freeWinSymbolsList and self.freeWinSymbolsList[boardIndex] > 0 then
            local showStr2 = FONTS.formatByCount4(self.freeWinSymbolsList[boardIndex], 12, false)
            winNode[2]:setString(showStr2)
            bole.shrinkLabel(winNode[2], winNode[2].maxWidth, winNode[2].baseScale)
        else
            winNode[2]:setString("0")
            bole.shrinkLabel(winNode[2], winNode[2].maxWidth, winNode[2].baseScale)
        end

    end
    --self:initFreeFrames()
end

function cls:updateFreeWinInfo(ret, themeInfoAnimList)

    local old_freeWinSymbolsList = self.freeWinSymbolsList
    local new_freeWinSymbolsList = ret.theme_info.scatter_list
    local delay = 0
    local runAction = {}
    for boardIndex = 1, 4 do
        local myBoardImdex = boardIndex
        local newCoins = new_freeWinSymbolsList[boardIndex]
        local oldCoins = old_freeWinSymbolsList[boardIndex]
        if not old_freeWinSymbolsList or (oldCoins < newCoins) then
            local a1 = cc.CallFunc:create(
                    function()
                        self:showAddBoardScatter(myBoardImdex)
                    end
            )
            local delay2 = (newCoins - oldCoins)
            delay = delay + delay2
            local a2 = cc.DelayTime:create(delay2 * 0.5 + 0.1)
            table.insert(themeInfoAnimList, a1)
            table.insert(themeInfoAnimList, a2)
        end
    end
end

function cls:showAddBoardScatter(myBoardIndex)

    local runAction = {}
    local item_list = self.realItem_list
    for col = (myBoardIndex - 1) * 5 + 1, (myBoardIndex) * 5 do
        for row = 1, 3 do

            local pCol = col
            local pRow = row
            if item_list[col][row] == specialSymbol.trigger or item_list[col][row] == specialSymbol.trigger_2 then

                local a1 = cc.CallFunc:create(
                        function()
                            local pos = self:getCellPos(col, row)
                            local spineFile = self:getPic("spine/item/scatter_count/spine")
                            local _, s1 = self:addSpineAnimation(self.scatterCountNode, 22, spineFile, pos, "animation")
                            self:playMusic(self.audio_list.moon_num)
                            self.freeWinSymbolsList[myBoardIndex] = self.freeWinSymbolsList[myBoardIndex] + 1
                            local showStr = FONTS.formatByCount4(self.freeWinSymbolsList[myBoardIndex], 12, false)
                            local winNode = self.freeWinNodeList[myBoardIndex]
                            winNode[2]:setString(showStr)
                            bole.shrinkLabel(winNode[2], winNode[2].maxWidth, winNode[2].baseScale)
                        end
                )
                local a2 = cc.DelayTime:create(0.5)
                table.insert(runAction, a1)
                table.insert(runAction, a2)
            end
        end
    end
    if #runAction > 0 then
        local a1 = cc.Sequence:create(bole.unpack(runAction))
        libUI.runAction(self, a1)
    end

end
function cls:updateFreeCoins(ret)
    local old_freeWinCoinsList = self.freeWinCoinsList

    local new_freeWinCoinsList = ret.theme_info.total_win_list

    if not new_freeWinCoinsList then
        return
    end
    for boardIndex = 1, 4 do
        local winNode = self.freeWinNodeList[boardIndex]
        if not old_freeWinCoinsList then
            local showStr = FONTS.formatByCount4(new_freeWinCoinsList[boardIndex], 12, false)
            winNode[1]:setString(showStr)
            bole.shrinkLabel(winNode[1], winNode[1].maxWidth, winNode[1].baseScale)

        elseif (old_freeWinCoinsList[boardIndex] < new_freeWinCoinsList[boardIndex]) then
            local showStr = FONTS.formatByCount4(new_freeWinCoinsList[boardIndex], 12, false)
            winNode[1]:setString(showStr)
            bole.shrinkLabel(winNode[1], winNode[1].maxWidth, winNode[1].baseScale)
            local oldshowStr = FONTS.formatByCount4(old_freeWinCoinsList[boardIndex], 12, false)

            winNode[1]:setString(oldshowStr)
            winNode[1]:nrStartRoll(old_freeWinCoinsList[boardIndex], new_freeWinCoinsList[boardIndex], 1)
        end
    end
    self.freeWinCoinsList = new_freeWinCoinsList

end
function cls:initFreeFrames()


    local maxIndex = self:getMaxFreeScatterIndex()

    for boardIndex = 1, 4 do
        self:showChooseBoard(boardIndex, maxIndex)
    end


end
function cls:getMaxFreeScatterIndex()

    local maxIndex = 1
    if not self.freeWinSymbolsList then
        return nil
    end
    for boardIndex = 2, 4 do
        if self.freeWinSymbolsList[boardIndex] > self.freeWinSymbolsList[maxIndex] then
            maxIndex = boardIndex
        elseif self.freeWinSymbolsList[boardIndex] == self.freeWinSymbolsList[maxIndex] then
            if boardIndex == self.boardType then
                maxIndex = boardIndex
            end
        end
    end
    if self.freeWinSymbolsList[maxIndex] == 0 then
        return nil
    end
    return maxIndex
end
--------------------------------------------------------------------------------------------------------------------

function cls:initialJackpotNode()
    local progressive_nodes = self.progressiveNode:getChildByName("jackpots_labels")-- 初始化jackpot
    self.jackpotLabels = {}
    for i = 1, 4 do
        self.jackpotLabels[i] = progressive_nodes:getChildByName("label_jp" .. i)
        self.jackpotLabels[i].maxWidth = self:getJPLabelMaxWidth(i)
        self.jackpotLabels[i].baseScale = 1
    end
    Theme.initialJackpotNode(self)
end
function cls:setBet()
    local set_Bet = self.tipBet
    local maxBet = self.ctl:getMaxBet()
    if maxBet >= set_Bet then
        self.ctl:setCurBet(set_Bet)
    end
end
function cls:setCollectPartState(active, isAnimate)
    local file = self:getPic(SpineConfig.collect_lock)
    local parent = self.mapLockNode
    if not self.lockSuperSpine then
        local _, s = self:addSpineAnimation(parent, 2, file, cc.p(0, 0), "animation1", nil, nil, nil, true, false, nil)
        self.lockSuperSpine = s
    end
    if active then
        -- 播放解锁动画
        self.isLockFeature = false

        local aniName = "animation2"

        self.lockSuperSpine:setAnimation(0, aniName, false)
        self:setProgressAni(true, isAnimate)
    else
        -- 播放锁定动画
        local aniName = ""
        aniName = "animation3"
        if isAnimate then
            self:playMusic(self.audio_list.lock)
            aniName = "animation1"
        end
        self.isLockFeature = true
        self.lockSuperSpine:setAnimation(0, aniName, false)
        self:setProgressAni(false, isAnimate)


    end
    self.btnUnlockCollect:setVisible(self.isLockFeature)
end

function cls:setProgressAni(show, isAnimate)
    local opacity = 0
    if show then
        opacity = 255
    end
    --self.collectProgressAniSpine:stopAllActions()
    if isAnimate then
        self.collectProgressAniSpine:runAction(cc.FadeTo:create(0.5, opacity))
    else
        self.collectProgressAniSpine:setOpacity(opacity)
    end
    --self.collectAniTop:stopAllActions()
    if isAnimate then
        self.collectAniTop:runAction(cc.FadeTo:create(0.5, opacity))
    else
        self.collectAniTop:setOpacity(opacity)
    end

end
function cls:getJPLabelMaxWidth(index)
    local jackpotLabelMaxWidth = { 159, 141, 129, 135 }
    return jackpotLabelMaxWidth[index] or jackpotLabelMaxWidth[#jackpotLabelMaxWidth]
end

function cls:getThemeJackpotConfig()
    local jackpot_config_list = {
        link_config = { "grand", "major", "minor", "mini" },
        allowK = { [174] = false, [674] = false, [1174] = false }
    }
    return jackpot_config_list
end

------------------------------------------------------------------------------------------------------------
-- Cell相关
------------------------------------------------------------------------------------------------------------
function cls:adjustWithTheCellSpriteUpdate(theCellNode, key, col)
    -- 删除掉 tip 动画
    if theCellNode.symbolTipAnim then
        if (not tolua.isnull(theCellNode.symbolTipAnim)) then
            theCellNode.symbolTipAnim:removeFromParent()
        end
        theCellNode.symbolTipAnim = nil
    end

end

function cls:createCellSprite(key, col, rowIndex)
    self.initialPics = self.initialPics or {}

    if self.recvItemList and self.recvItemList[col] and self.recvItemList[col][rowIndex] then
        key = self.recvItemList[col][rowIndex]
        self.initialPics[col] = true
    else
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
    end

    ------------------------------------------------------------
    if self.initBoardIndex == 1 then
        if col == 6 then
            if key <= 14 then
                key = specialSymbol.empty
            elseif key < specialSymbol.empty then
                key = math.random(17, 18)
            end
        end
    else
        if key > 14 then
            key = math.random(1, 8)
        end
    end
    local theCellNode = cc.Node:create()
    local theCellFile = self.pics[key]
    if not theCellFile then
        key = math.random(1, 8)
        theCellFile = self.pics[key]

    end
    local theCellSprite = bole.createSpriteWithFile(theCellFile)

    theCellNode:addChild(theCellSprite)
    theCellNode.key = key
    theCellNode.sprite = theCellSprite
    theCellNode.curZOrder = 0
    ------------------------------------------------------------
    if self.symbolZOrderList[key] then
        theCellNode.curZOrder = self.symbolZOrderList[key]
    end
    self:adjustWithTheCellSpriteUpdate(theCellNode, key, col)
    local theKey = theCellNode.key
    return theCellNode
end
function cls:updateCellSprite(theCellNode, key, col, isShowResult, isReset)

    if self.initBoardIndex == 1 then
        if col == 6 then
            if key <= 14 then
                key = specialSymbol.empty
            end
        end
    else
        if key > 14 then
            key = math.random(2, 12)
        end
    end
    if col == 6 then
    end
    theCellNode:setVisible(true)
    theCellNode.sprite:setVisible(true)

    local theCellFile = self.pics[key]
    if not theCellFile then
        key = math.random(2, 12)
        theCellFile = self.pics[key]
    else
        local theCellSprite = theCellNode.sprite
        bole.updateSpriteWithFile(theCellSprite, theCellFile)
        theCellNode.key = key
        theCellNode.curZOrder = 0
    end
    --theCellNode.sprite:setColor(color)
    if self.symbolZOrderList[key] then
        theCellNode.curZOrder = self.symbolZOrderList[key]
    end
    ------------------------------------------------------------
    self:adjustWithTheCellSpriteUpdate(theCellNode, key, col)
end

function cls:playSymbolNotifyEffect(col, fastStopMusicTag)
    if (not self.notifyState) or (not self.notifyState[col]) then
        return
    end
    for key, list in pairs(self.notifyState[col]) do
        if key == specialSymbol.trigger then
            for _, crPos in pairs(list) do
                local cell = nil
                if fastStopMusicTag then
                    cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2])
                else
                    cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2] + 1)
                end
                if cell then
                    local animateName = "animation1"
                    local spineFile = self:getPic("spine/item/" .. key .. "/spine")
                    cell.sprite:setVisible(false)

                    local _, s = self:addSpineAnimation(cell, 5, spineFile, cc.p(0, 0), animateName, nil, nil, nil, true, false)
                    cell.symbolTipAnim = s
                end
            end

        end

    end

end
function cls:playWildNotifyEffect(pcol)

    if self.showSpinBoard == SpinBoardType.Normal then
        self:playWildNotifyBySingle(pcol)
    end


end
function cls:playWildNotifyBySingle(col)
    for row, key in ipairs(self.item_list[col]) do
        if key == specialSymbol.wild then
            local cell = nil
            if self.fastStopMusicTag then
                cell = self.spinLayer.spins[col]:getRetCell(row)
            else
                cell = self.spinLayer.spins[col]:getRetCell(row + 1)
            end
            if cell and not cell.symbolTipAnim then
                local animateName = "animation1"
                local spineFile = self:getPic("spine/item/" .. key .. "/spine")
                cell.sprite:setVisible(false)
                local _, s = self:addSpineAnimation(cell, 5, spineFile, cc.p(0, 0), animateName, nil, nil, nil, true, false)
                cell.symbolTipAnim = s
            end
        end
    end
    if self.isGetJackPot and col == 6 then
        --for row, key in ipairs(self.item_list[col]) do
        --    if key ~= specialSymbol.\ then
        local cell = nil
        if self.fastStopMusicTag then
            cell = self.spinLayer.spins[col]:getRetCell(2)
        else
            cell = self.spinLayer.spins[col]:getRetCell(2 + 1)
        end
        if cell and not cell.symbolTipAnim then
            local key = self.item_list[6][2] - 14
            local aniName = "animation" .. key .. "_1"
            local spineFile = self:getPic("spine/item/jp/spine")
            cell.sprite:setVisible(false)
            local _, s = self:addSpineAnimation(cell, 5, spineFile, cc.p(0, 0), aniName, nil, nil, nil, true, false)
            cell.symbolTipAnim = s
        end
        --end
    end
end
function cls:playBackBaseGameSpecialAnimation(theSpecials, enterType)
    if not enterType then
        if self.showSpinBoard == SpinBoardType.Normal then
            self:playFreeSpinItemAnimation_1(theSpecials) -- 返回base game的 时候不播放音乐

        end
    end
end
function cls:playFreeSpinItemAnimation(theSpecials, enterType)
    return 0
end
function cls:playFreeSpinItemAnimation_1(theSpecials, enterType)
    self:stopDrawAnimate()
    local delay = 0
    if not theSpecials or (not theSpecials[specialSymbol.trigger]) or bole.getTableCount(theSpecials[specialSymbol.trigger]) == 0 then
        return 0
    end --  更改 逻辑
    if enterType then
        self:playMusic(self.audio_list.trigger_bell)
        self.ctl.footer:setSpinButtonState(true)
    end

    for col, rowTagList in pairs(theSpecials[specialSymbol.trigger]) do
        for row, tagValue in pairs(rowTagList) do
            self:addItemSpine(specialSymbol.trigger, col, row, "animation", self.freeLayerNode)
            if self.animNodeBgList and self.animNodeBgList[col .. "_" .. row] and self.animNodeBgList[col .. "_" .. row][3] then
                if bole.isValidNode(self.animNodeBgList[col .. "_" .. row][1]) then
                    self.animNodeBgList[col .. "_" .. row][1]:removeFromParent()
                    self.animNodeBgList[col .. "_" .. row] = nil
                end
            end
        end
    end
    return delay

end
function cls:addItemSpine(item, col, row, animateName, layerNode)
    local layer = layerNode or self.animateNode
    local animateName = animateName or "animation2"
    local pos = self:getCellPos(col, row)
    local spineFile = self:getPic("spine/item/" .. item .. "/spine")

    local cell = self.spinLayer.spins[col]:getRetCell(row)
    cell:setVisible(false)
    local _, s1 = self:addSpineAnimation(layer, 200, spineFile, pos, animateName, nil, nil, nil, true, true)
end
function cls:getItemAnimate(item, col, row, effectStatus, parent)
    local spineItemsSet = Set({ 1, 2, 3, 4, 5, 6, 13, 14, 15, 16, 17, 18 })
    if type(item) == "number" then
        item = (item) % 100
    end

    local realKey = item
    if self.realItem_list and self.realItem_list[col] and self.realItem_list[col][row] then
        realKey = self.realItem_list[col][row]
    end
    if spineItemsSet[realKey] then
        if effectStatus == "all_first" then
            self:playItemAnimation(realKey, col, row)
        else
            self:playOldAnimation(col, row)
        end
        return nil
    else
        return self:playSAllAnimation(item, col)
    end
end
function cls:playSAllAnimation(item, col)
    local fs = 60
    local objOp = 0
    local animate = cc.Sequence:create(
            cc.DelayTime:create(2 / fs),
            cc.ScaleTo:create(26 / fs, 1.15),
            cc.DelayTime:create(2 / fs),
            cc.ScaleTo:create(26 / fs, 1),
            cc.DelayTime:create(2 / fs))
    return cc.Sequence:create(animate, animate:clone())
end

function cls:playItemAnimation(item, col, row)
    self.animNodeList = self.animNodeList or {}
    if not self.animNodeList[col .. "_" .. row] then
        local animateName = "animation"

        local pos = self:getCellPos(col, row)
        local spineFile = self:getPic("spine/item/" .. item .. "/spine")
        local zorder = 100 + row

        local _, s1 = self:addSpineAnimation(self.animateNode, zorder, spineFile, pos, animateName, nil, nil, nil, true)

        self.animNodeList[col .. "_" .. row] = {}
        self.animNodeList[col .. "_" .. row][1] = s1
        self.animNodeList[col .. "_" .. row][2] = animateName

        if item == specialSymbol.trigger_2 then
            local img = bole.createSpriteWithFile(self.pics[specialSymbol.trigger])
            self.animateNode:addChild(img, zorder - 1)
            self.animNodeList[col .. "_" .. row][3] = img
            img:setPosition(pos)
        end
        local cell = self.spinLayer.spins[col]:getRetCell(row)
        cell:setVisible(false)

    end
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

function cls:playCellRoundEffect(parent, ...)
    self:addSpineAnimation(parent, nil, self:getPic("spine/base/kuang/spine"), cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
end

function cls:drawLinesThemeAnimate(lines, layer, rets, specials)
    local timeList = { 2, 2 }
    Theme.drawLinesThemeAnimate(self, lines, layer, rets, specials, timeList)
    return 0
end
function cls:actionBeforeRollUp(rets)
    local winline = 0
    local delay = 0
    if self.showSpinBoard == SpinBoardType.FreeSpin then

        if rets.win_pos_list then
            winline = #rets.win_pos_list
        end
        if winline > 0 then
            delay = 2
            self:updateFreeCoins(rets)
        end
        self:initFreeFrames()
    end

    return delay

end
function cls:playBonusItemAnimate(itemList)
    self:stopDrawAnimate()
    local itemList = itemList or (self.ctl.rets.item_list or {})

    local key = itemList[6][2] - 14
    self:playJpWSymbolAnimation(key)
end
function cls:playJpWSymbolAnimation(winIndex)
    local file = self:getPic("spine/item/jp/spine")
    local pos = self.spinLayer:getCellPos(6, 2)
    local cell = self.spinLayer.spins[6]:getRetCell(2)
    local aniName = "animation" .. winIndex
    self:addSpineAnimation(self.animateNode, nil, file, pos, aniName, nil, nil, nil, true, true, nil)

end
function cls:playBonusAnimate(bonusData, finish)
    if not bonusData then
        return 0
    end
    if not self.isGetJackPot then
        return 0
    end
    self.ctl.footer:setSpinButtonState(true)
    AudioControl:stopGroupAudio("music")

    local bonusCount = 0
    local itemList = {}
    if self.ctl.rets and self.ctl.rets.item_list then
        itemList = self.ctl.rets.item_list
    end
    if not finish then
        self:playMusic(self.audio_list.trigger_bell)
    end
    self:playBonusItemAnimate()
    return 2
end
function cls:dealAboutBetChange(theBet, isPointBet, notAni)

    if not self.tipBet or not self.mapCollectRoot then
        return
    end
    theBet = theBet or self.ctl:getCurTotalBet()
    if self.isLockFeature == nil then
        if theBet >= self.tipBet then
            self.isLockFeature = true
        else
            self.isLockFeature = false
        end
    end
    local isLock = theBet < self.tipBet

    if self.isLockFeature ~= isLock then
        if isLock then
            self:setCollectPartState(false, not notAni)
        else
            self:setCollectPartState(true, not notAni)

        end
    end
end

function cls:enterFreeSpin(isResume)

    if isResume then
        --self:playMoveWildAction(isResume)
        self:initFreeFrames()
        self:updateMoveWildBoard()
        self:initFreeBoardBgs()
        self:after_win_show()
    end
    self:dealMusic_PlayFreeSpinLoopMusic()
    self:showAllItem()
    self.playNormalLoopMusic = false
end

------------------------------------- on move wild   part start------------------------------

function cls:getWildTotalCount()

    local count = 0
    if not self.wildCount then
        return count
    end
    for i = 1, 4 do
        count = count + self.wildCount[i]
    end
    return count
end
---@param animName 1:出现，2:循环，3消失
function cls:playMoveWildAction()
    if not self.exWildFinalPos then
        return
    end
    self.noUseWildSpine = self.moveWildNode:getChildren() -- self.noUseWildSpine or
    self.moveWildSpine = {}
    self.mapData = self.mapData or {}
    local animName = "animation1"

    local spineName = specialSymbol.wild
    for boardIndex = 1, #self.exWildFinalPos do
        for k, posData in pairs(self.exWildFinalPos[boardIndex]) do
            local temp
            local pos = self:getCellPos(posData[1] + (boardIndex - 1) * 5, posData[2])
            pos.y = pos.y - 30
            if #self.noUseWildSpine == 0 or not bole.isValidNode(self.noUseWildSpine[1]) then
                local _, s = self:addSpineAnimation(self.moveWildNode, 100, self:getPic(SpineConfig.free_move), pos, animName, nil, nil, nil, true)
                self.moveWildSpine[boardIndex] = self.moveWildSpine[boardIndex] or {}
                table.insert(self.moveWildSpine[boardIndex], s)
                s.posData = tool.tableClone(posData)
                temp = s
            else
                temp = table.remove(self.noUseWildSpine, 1)
                self.moveWildSpine[boardIndex] = self.moveWildSpine[boardIndex] or {}
                table.insert(self.moveWildSpine[boardIndex], temp)
                temp:setVisible(true)
                temp:setPosition(pos)
                bole.changeSpineNormal(temp, animName, false) -- 显示可移动状态
                temp.posData = tool.tableClone(posData)
            end
        end
    end

    --if not isResume then
    --self:playMusic(self.audio_list.free_wild_land)
    local a1 = cc.Sequence:create(
            cc.DelayTime:create(moveStartDelay),
            cc.CallFunc:create(function()
                self:changeMoveAnimaiton()


            end))
    libUI.runAction(self, a1)
    --end
end
function cls:changeMoveAnimaiton()
    for boardIndex = 1, 4 do
        if self.moveWildSpine and self.moveWildSpine[boardIndex] then
            for index, temp in pairs(self.moveWildSpine[boardIndex]) do
                bole.changeSpineNormal(temp, "animation2", true)
            end
        end

    end
end
function cls:moveNextPos(...)
    local overPos = {} -- 已经有 cell 的位置
    self.freeColCnt = self.freeColCnt or 5
    self.freeRowCnt = self.freeRowCnt or 3
    if self.curWildMoveEndPos then
        self.wildMaskNode:runAction(cc.FadeTo:create(0.5, 70))
        for boardIndex = 1, #self.curWildMoveEndPos do
            overPos[boardIndex] = {}

            local startCol = (boardIndex - 1) * self.freeColCnt + 1
            local endCol = boardIndex * self.freeColCnt
            self.moveWildSpine[boardIndex] = self.moveWildSpine[boardIndex] or {}
            for k, temp in pairs(self.moveWildSpine[boardIndex]) do
                local endPos
                if self.curWildMoveEndPos[boardIndex][k] then
                    local back = self.curWildMoveEndPos[boardIndex][k]
                    endPos = { startCol - 1 + back[1], back[2] }
                end
                local pos2 = self:getCellPos(endPos[1], endPos[2]) -- 结果位置
                pos2.y = pos2.y - 30
                local a1 = cc.Sequence:create(
                --cc.CallFunc:create(function(...)
                --    bole.changeSpineNormal(temp, "animation2", true)
                --end),
                        cc.MoveTo:create(moveWildTime, pos2),
                        cc.CallFunc:create(function(...)
                            if temp.lizi and bole.isValidNode(temp.lizi) then
                                temp.lizi:removeFromParent()
                                temp.lizi = nil
                            end
                            self.wildMaskNode:runAction(cc.FadeTo:create(changeToWildTime, 0))

                        end),
                        cc.DelayTime:create(changeToWildTime),
                        cc.CallFunc:create(function(...)
                            if self.nextStopCallFun then
                                self.nextStopCallFun()
                            end
                            self.curWildMoveEndPos = nil
                            self.nextStopCallFun = nil
                        end))
                libUI.runAction(temp, a1)
            end
        end

    end
end
---@param final_wild_pos : 所有wild的最终位置
---@param begin_wild_pos : 会动的wild的最终位置
function cls:playStopControlMoveWildAction(stopRet)
    if stopRet["theme_info"] then
        local _theme_info = stopRet["theme_info"]
        self.wildCount = _theme_info.wild_count
        self.wildTotalCount = self:getWildTotalCount()
        --self.exWildFinalPos = self.wildNextBeginPos
        self.realItem_list = self:changeRealBoard(stopRet.item_list, _theme_info["final_wild_pos"])

        if _theme_info["final_wild_pos"] and #_theme_info["final_wild_pos"] ~= 0 then
            self.wildNextBeginPos = tool.tableClone(_theme_info["final_wild_pos"])
        end
        if _theme_info["begin_wild_pos"] then

            local count = 0
            for i = 1, 4 do
                count = #_theme_info["begin_wild_pos"][i] + count
            end
            if count > 0 then
                self.haveSpecialdelay = true

                self.curWildMoveEndPos = tool.tableClone(_theme_info["begin_wild_pos"])
                self.beginWildPos = _theme_info["begin_wild_pos"]
            end

        end
    end
end

---@desc 排面结束，重置排面
function cls:updateMoveWildBoard(ret, themeInfoAnimList)
    local item_list
    if ret then
        item_list = ret.item_list
    end

    self.freeColCnt = self.freeColCnt or 5
    self.freeRowCnt = self.freeRowCnt or 3
    local find = false
    if self.beginWildPos and #self.beginWildPos > 0 then
        for boardIndex = 1, #self.beginWildPos do
            local startCol = (boardIndex - 1) * self.freeColCnt
            if self.moveWildSpine and #self.moveWildSpine > 0 and self.moveWildSpine[boardIndex] then
                for k, temp in pairs(self.moveWildSpine[boardIndex]) do
                    if temp and bole.isValidNode(temp) then
                        bole.changeSpineNormal(temp, "animation3")
                    end
                end
            end

            local boardData = self.beginWildPos[boardIndex]
            if boardData and #boardData > 0 then
                find = true
                for key, item in ipairs(boardData) do
                    local realCol = startCol + item[1]
                    local realRow = item[2]
                    local symbolID = 2
                    if item_list then
                        symbolID = item_list[realCol][realRow]
                    end

                    if symbolID == specialSymbol.trigger or symbolID == specialSymbol.trigger_2 then
                        local cell = self.spinLayer.spins[realCol]:getRetCell(realRow)
                        self:updateCellSprite(cell, specialSymbol.trigger_2, realCol, true)
                    elseif symbolID ~= specialSymbol.wild then
                        local cell = self.spinLayer.spins[realCol]:getRetCell(realRow)
                        self:updateCellSprite(cell, specialSymbol.wild, realCol, true)
                    end
                end

            end
        end
    end
    if find and themeInfoAnimList then
        local a1 = cc.DelayTime:create(20 / 30)
        table.insert(themeInfoAnimList, a1)
    end


end
--------------------------------------- on  move wild  part   end ------------------------------
--------------------------------------- on  fast jackpot part  start ---------------------------

function cls:grayFastJackPot(isGray)

    bole.setGray(self.fastRoot, not isGray, true)
    bole.setGray(self.fastReelBg, not isGray, true)
    for row = 1, 4 do
        local cell = self.spinLayer.spins[6]:getRetCell(row)
        bole.setGray(cell.sprite, not isGray, true)
    end


end

--------------------------------------- on  fast jackpot part  end ------------------------------
------------------------------------- on theminfo  part start------------------------------

function cls:onThemeInfo(ret, callFunc)
    local themeInfo = ret["theme_info"]
    local themeInfoAnimList = {}

    if self.showSpinBoard == SpinBoardType.Normal and not self.isLockFeature then
        self:resetCollectInfo(ret, themeInfoAnimList)
    end

    if self.showSpinBoard == SpinBoardType.FreeSpin then
        self:updateMoveWildBoard(ret, themeInfoAnimList)
        self:updateFreeWinInfo(ret, themeInfoAnimList)
        local winline = 0
        if ret.win_pos_list then
            winline = #ret.win_pos_list
        end
        self.ctl.rets = self.ctl.rets or {}

        if winline > 0 then
            self:winLineDrawAnimation(ret, themeInfoAnimList)
        end
    end
    if self.showSpinBoard == SpinBoardType.FreeSpin then

        self.ctl.rets.after_win_show = 1
    end
    if #themeInfoAnimList > 0 then
        self.ctl.footer:setSpinButtonState(true)

        local l3 = cc.CallFunc:create(function(...)
            --self:dealMusic_FadeLoopMusic(0.3, 0.3, 1)-- 恢复背景音乐
        end)
        table.insert(themeInfoAnimList, l3)
        local l4 = cc.DelayTime:create(0.1)
        table.insert(themeInfoAnimList, l4)
        local l5 = cc.CallFunc:create(function(...)
            callFunc()
        end)
        table.insert(themeInfoAnimList, l5)
        -- 降低背景音乐
        --self:dealMusic_FadeLoopMusic(0.3, 1, 0.3)
        self:runAction(cc.Sequence:create(bole.unpack(themeInfoAnimList)))
    else
        callFunc()

    end


end

function cls:winLineDrawAnimation(rets, themeInfoAnimList)

    if self.ctl.rets.setWinCoins then
        self.ctl.rets.setWinCoins = nil
        local winCoins = rets["total_win"] == rets["base_win"] and rets["total_win"] or rets["base_win"]
        self.ctl:setWinCoins_noHandle(winCoins)

    end

    local a1 = cc.CallFunc:create(
            function()
                self.ctl:drawAnimate(rets)
                self:actionBeforeRollUp(rets)

            end)

    local a2 = cc.DelayTime:create(2)
    table.insert(themeInfoAnimList, a1)
    table.insert(themeInfoAnimList, a2)


end
-------------------------------------------- collect start --------------------------------------------

function cls:initCollectNode()

    self.btnUnlockCollect = self.mapCollectRoot:getChildByName("btn_unlock")
    self.mapLockNode = self.mapCollectRoot:getChildByName("node_lock")
    self.btnStore = self.mapCollectRoot:getChildByName("btn_store")
    self.collectTargetImage = self.mapCollectRoot:getChildByName("img_collection")

    self.collectPanel = self.mapCollectRoot:getChildByName("collect_panel")
    self.collectProgressImage = self.collectPanel:getChildByName("progress_img")
    self.collectProgressAni = self.collectPanel:getChildByName("progress")
    self.castleNode = self.mapCollectRoot:getChildByName("castle_node")
    local _, s1 = bole.addSpineAnimation(self.castleNode, 1, self:getPic(SpineConfig.collect_castle), cc.p(-10, 0), "animation", nil, nil, nil, true, true)-- 出现


    self.collectAniNode = self.mapCollectRoot:getChildByName("progress_ani")
    self.SpineFullNode = self.mapCollectRoot:getChildByName("spine_full")
    self.progressStartPosX = 100.00
    self.baseProgressAniPosX = -410
    self.baseProgressTopAniPosX = 20

    --self.baseProgressAniPosX = -410
    self.progressPosY = 30
    self.progressEndPosX = 670
    self.moveAllDistance = 670 - self.progressStartPosX
    --self.collectAniNode:setLocalZOrder(-1)
    local _, s2 = bole.addSpineAnimation(self.collectAniNode, 2, self:getPic(SpineConfig.collect_top2), cc.p(346, 22), "animation", nil, nil, nil, true, true)-- 出现
    self.collectProgressAniSpine = s2

    local _, s3 = bole.addSpineAnimation(self.collectAniNode, -1, self:getPic(SpineConfig.collect_full), cc.p(346, 0), "animation1", nil, nil, nil, true, true)-- 出现
    self.collectAniTop = s3

    local function onTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            if self.showSpinBoard ~= SpinBoardType.Normal then
                return
            end
            if not self.isCanFeatureClick then
                return nil
            end
            if self.isLockFeature then
                self:playMusic(self.audio_list.btn_click) -- 播放点击音乐
                self:setBet()
                return
            end
        end
    end
    self.btnUnlockCollect:addTouchEventListener(onTouch)

    local function onTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            if self.showSpinBoard ~= SpinBoardType.Normal then
                return
            end
            if not self.isCanFeatureClick then
                return nil
            end

            --if self.isFeatureClickIng then
            --    return
            --end
            self:playMusic(self.audio_list.btn_click)
            if self.isFeatureClick then
                self:closeStoreNode()
            else
                self:showStoreNode()
            end
        end
    end
    self.btnStore:addTouchEventListener(onTouch)

end

local flyToUpTime = 1
function cls:resetCollectInfo(ret, themeInfoAnimList)
    self.themeMapInfo = ret.theme_info.map_info
    if self.collectMajorId == 0 then
        return
    end
    local animList = {}
    local themeInfo = ret['theme_info']

    local collectInfo = themeInfo["map_info"]

    local collectedCounts = collectInfo["map_points"]

    local isFull = collectedCounts >= self.collectTargetCounts
    local nextDelay = 0
    if self.collectSymbolCounts ~= collectedCounts then
        self:showSymbolsFlyToUp(ret)
        local a1 = cc.DelayTime:create(flyToUpTime)
        local a2 = cc.CallFunc:create(function(...)

            self:showProgressAnimation(collectedCounts, isFull)
            self.bonusflyNode:removeAllChildren()
        end)
        table.insert(animList, a1)
        table.insert(animList, a2)

        if isFull or self.collectSpinLeftCounts == 0 then
            -- 积满或者未完成
            nextDelay = 2
            self.mapLevel = self.themeMapInfo["map_level"]
            local a4 = cc.DelayTime:create(0.8)

            table.insert(animList, a4)
        end
    end
    if #animList > 0 then
        local a1 = cc.Sequence:create(bole.unpack(animList))
        libUI.runAction(self, a1)
    end
    if nextDelay > 0 then
        local a1 = cc.DelayTime:create(nextDelay)
        table.insert(themeInfoAnimList, a1)

    end
end

---@desc 进度条
function cls:setCollectProgressImagePos(collectNum, isAni, isFull)
    if isFull then
    end

    local moveUnit = self.moveAllDistance / self.collectTargetCounts
    collectNum = collectNum or self.collectSymbolCounts

    if collectNum > self.collectTargetCounts then
        collectNum = self.collectTargetCounts
    elseif collectNum < 0 then
        collectNum = 0
    end
    if collectNum == 0 or collectNum >= self.collectTargetCounts then
        if not isAni then

            self.collectProgressAniSpine:setVisible(false)
            self.collectAniTop:setVisible(false)
        end
    else
        self.collectProgressAniSpine:setVisible(true)
        self.collectAniTop:setVisible(true)
    end

    local cur_posX = moveUnit * self.collectSymbolCounts + self.progressStartPosX
    local curAni_posX = self.baseProgressAniPosX + cur_posX

    self.collectSymbolCounts = collectNum

    local next_posX = moveUnit * collectNum + self.progressStartPosX

    if collectNum == self.collectTargetCounts then
        next_posX = self.progressEndPosX
    end
    if collectNum == 0 then
        next_posX = 0
    end
    local nextAni_posX = self.baseProgressAniPosX + next_posX
    local nextTop_posX = nextAni_posX + self.baseProgressTopAniPosX
    if not isAni then
        self.collectProgressImage:setPosition(cc.p(next_posX, self.progressPosY))
        self.collectProgressAniSpine:setPosition(cc.p(nextAni_posX, 0))
        self.collectAniTop:setPosition(cc.p(nextTop_posX, 0))
    else
        local a1 = cc.MoveTo:create(0.5, cc.p(next_posX, self.progressPosY))
        libUI.runAction(self.collectProgressImage, a1)

        local a2 = cc.MoveTo:create(0.5, cc.p(nextAni_posX, 0))
        self.collectProgressAniSpine:runAction(a2)
        local a3 = cc.MoveTo:create(0.5, cc.p(nextTop_posX, 0))
        self.collectAniTop:runAction(a3)

    end
end
---@desc 进度条动画
function cls:showProgressAnimation(collectNum, isFull)

    self:setCollectProgressImagePos(collectNum, true, isFull)
    local function fullCollectAnimation()
        self.collectProgressAniSpine:setVisible(false)
        --self.collectAniTop:setVisible(false)
        self:addSpineAnimation(self.collectAniNode, 1, self:getPic(SpineConfig.collect_full), cc.p(0, 0), "animation") -- -progressStartPosX/2
    end
    self:laterCallBack(0.5, function()
        if isFull then
            self:dealMusic_FadeLoopMusic(0.3, 1, 0.3)
            fullCollectAnimation()
            self:playMusic(self.audio_list.meter)
        end
    end)
end

---@desc symbol 向上飞
function cls:showSymbolsFlyToUp(ret)
    local currentId = self.collectMajorId
    local item_list = ret.item_list
    local endPos = cc.p(190, 552)
    local isFly = false

    local flyItemList = {}

    for col = 1, 5 do
        for row = 1, 3 do
            if item_list[col][row] == currentId then

                table.insert(flyItemList, { col, row })
            end
        end
    end
    if #flyItemList > 0 then
        self:playMusic(self.audio_list.collect)
        local spine_file = self:getPic("spine/item/" .. specialSymbol.trigger .. "/spine")
        for i = 1, #flyItemList do
            local item = flyItemList[i]
            local col = item[1]
            local row = item[2]
            local node = cc.Node:create()
            local pos = self:getCellPos(col, row)
            node:setPosition(pos)
            self.bonusflyNode:addChild(node)

            local aniName1 = "animation2"
            local _, s = self:addSpineAnimation(node, nil, spine_file, cc.p(0, 0), aniName1, nil, nil, nil, false, false, nil)
            local function callFunc(...)
                local file = self:getPic(SpineConfig.collect_receive)
                self:addSpineAnimation(self.mapCollectRoot, 2, file, bole.getPos(self.collectTargetImage), "animation")

            end
            if node then
                local a1 = cc.DelayTime:create(7 / 30)
                local a2 = cc.CallFunc:create(
                        function()
                            self:parabolaToAnimation(node, col, row, pos, endPos, 8 / 30)
                        end)
                local a3 = cc.DelayTime:create(8 / 30)
                local a4 = cc.CallFunc:create(callFunc)
                local b = cc.Sequence:create(a1, a2, a3, a4)
                libUI.runAction(node, b)
            end
        end
    end
end
function cls:parabolaToAnimation(obj, col, row, from, to, duration)
    local radian_config = {
        { { -50, 50 }, { -50, 60 }, { -50, 75 } }, { { -60, 30 }, { -60, 40 }, { -60, 55 } },
        { { -70, -30 }, { -70, -40 }, { -70, -55 } }, { { -80, -50 }, { -80, -60 }, { -80, -75 } },
        { { -90, -50 }, { -90, -60 }, { -90, -75 } },
    }

    local from = from or self:getCellPos(col, row)
    local to = to or cc.p(0, 0)
    local config = radian_config[col][row]

    local myBezier = function(p0, p1, p2, duration, frame)
        local t = frame / duration
        if t > 1 then
            t = 1
        end
        local x = math.pow(1 - t, 2) * p0.x + 2 * t * (1 - t) * p1.x + math.pow(t, 2) * p2.x
        local y = math.pow(1 - t, 2) * p0.y + 2 * t * (1 - t) * p1.y + math.pow(t, 2) * p2.y

        return cc.p(x, y)
    end

    local cp = cc.p(from.x + config[1], from.y + config[2])
    local frame = 1

    obj:runAction(cc.Repeat:create(cc.Sequence:create(
            cc.CallFunc:create(function()
                frame = frame or 1
                local pos = myBezier(from, cp, to, duration * 60, frame)
                obj:setPosition(pos)
                frame = frame + 1
            end),
            cc.DelayTime:create(1 / 60)
    ), duration * 60))

end
----------------------------------------------- collect   end --------------------------------------------
-------------------------------------------- bonus start --------------------------------------------
function cls:saveBonusData(tryResume)
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
        if self.ctl.bonusItem and #self.ctl.bonusItem <= 5 then
            self.ctl:resetBoardCellsSpriteOverBonus(self.ctl.bonusItem) -- 刷新牌面 + 动画播放l
        else
            self.ctl.bonusItem = nil
        end

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

    -- 解锁 按钮
    self.ctl.isProcessing = false
    if self.showSpinBoard == SpinBoardType.FreeSpin or self.ctl.freewin then
        self.ctl.totalWin = self.ctl.freewin + self.ctl.totalWin
        self.ctl.freewin = self.ctl.totalWin
        self.ctl:updateFooterCoin()
    else
        self:unlockLobbyBtn()
        self.ctl:removePointBet()
        self.ctl:updateFooterCoin()
        self.ctl:addCoinsToHeader()
    end
    if self.superAvgBet then
        self.superAvgBet = nil
    end
end

---------------------------------------------bonus end------------------------------------------------------
function cls:enterThemeByFirstFreeSpin(ret, theFreeSpinData, endCallFunc)
    self:enableMapInfoBtn(false)
    ret["free_random_pick"] = theFreeSpinData.data

    ret["total_win"] = self.ctl.total_win
    self.ctl.specials = self:getSpecialTryResume(theFreeSpinData["item_list"])
    self:lockLobbyBtn()
    self.ctl:free_random_pick(ret)
end
function cls:getSpecialTryResume(data)
    if not data then
        return nil
    end
    local specials = { [specialSymbol["trigger"]] = {} }
    for col, colItemList in ipairs(data) do
        for row, theKey in ipairs(colItemList) do
            if theKey % 100 == specialSymbol["trigger"] then
                specials[specialSymbol["trigger"]][col] = specials[specialSymbol["trigger"]][col] or {}
                specials[specialSymbol["trigger"]][col][row] = true
            end
        end
    end
    return specials

end
function cls:clearFreeData()
    LoginControl:getInstance():savePick(self.themeid, nil) -- 清除数据 Pick 数据
end

function cls:showFreeSpinNode(count, sumCount, first)

    self:changeSpinBoard(SpinBoardType.FreeSpin)--  更改棋盘显示 背景 和 free 显示类

    if not self.freeWinCoinsList then
        self.freeWinCoinsList = { 0, 0, 0, 0 }
    end
    if not self.freeWinSymbolsList then
        self.freeWinSymbolsList = { 0, 0, 0, 0 }
    end

    self:refreshFreeWinInfo()
    Theme.showFreeSpinNode(self, count, sumCount, first)
    if self.superAvgBet then

        self.ctl:setPointBet(self.superAvgBet)-- 更改 锁定的bet
        self:setCollectPartState()
        self.ctl.footer:changeFreeSpinLayout3()-- 隐藏掉  footer bet
        if self.ctl.footer then
            self.ctl.footer:hideActivitysNode()
        end
    end

end

function cls:hideFreeSpinNode(...)
    -- 进行出去freespin棋盘控制
    self:changeSpinBoard(SpinBoardType.Normal)
    self.freeWinCoinsList = nil
    self.freeWinSymbolsList = nil
    self.curWildMoveEndPos = nil
    self.wildNextBeginPos = nil
    self.exWildFinalPos = nil
    self.beginWildPos = nil
    self.moveWildNode:removeAllChildren()
    if self.superAvgBet then
        self.superAvgBet = nil
        self.ctl.footer:changeNormalLayout2()
    end
    Theme.hideFreeSpinNode(self, ...)

end
function cls:resetPointBet()
    -- 仅仅在断线的时候 被调用了
    if self.superAvgBet then
        self.ctl:setPointBet(self.superAvgBet)-- 更改 锁定的bet
        self.ctl.footer:changeFreeSpinLayout3()-- 隐藏掉  footer bet
    end
end
function cls:addSpineAction(parentNode, theData, config, sType)

    for key, item in pairs(config) do
        if key == "btn" then
            local btnNode
            if sType == fs_show_type.start then
                btnNode = parentNode.btnStart
            elseif sType == fs_show_type.more then

            else
                btnNode = parentNode.btnCollect
            end
            local size = btnNode:getContentSize()
            local _, s = self:addSpineAnimation(btnNode, nil, self:getPic(item.name), cc.p(size.width / 2, size.height / 2), "animation", nil, nil, nil, true, true)
        elseif key == "fnt" then
            -- 不用管
        else
            local img_key = bole.deepFind(parentNode, key)
            if img_key then
                local x, y = img_key:getPosition()
                img_key:setVisible(item.showimg)
                local myParent = parentNode
                if item.parent then
                    myParent = img_key
                    x = 0
                    y = 0
                end
                if item.pos then
                    x = item.pos.x
                    y = item.pos.y
                end
                if item.isImg then
                    if key == "jackpot" then
                        local img_name = string.format(item.name, theData[key])
                        bole.updateSpriteWithFile(myParent, img_name)
                    end
                else
                    local ani_name = item.aniname or "animation"
                    if key == "jackpot" then
                        ani_name = "animation" .. theData[key]

                    end
                    local _, s = self:addSpineAnimation(myParent, item.zorder, self:getPic(item.name), cc.p(x, y), ani_name, nil, nil, nil, true, not item.notcycle)
                end
                if item.playCycle then
                    local a4 = self:playSAllAnimation()
                    local action = cc.RepeatForever:create(a4)
                    libUI.runAction(myParent, action)
                end
            end
        end
    end

end
function cls:addDialogSpine(node, theData, sType, gType)

    -- 添加粒子特效 和 spine 动画的入口
    local parent = node.startRoot
    if sType == fs_show_type.start then
    elseif sType == fs_show_type.more then
        parent = node.moreRoot
    elseif sType == fs_show_type.collect then
        parent = node.collectRoot
    end
    if SpineDialogConfig[theData.type] and SpineDialogConfig[theData.type][0] then
        self:addSpineAction(node.baseRoot, theData, SpineDialogConfig[theData.type][0], sType)
    end
    if SpineDialogConfig[theData.type] and SpineDialogConfig[theData.type][sType] then
        self:addSpineAction(parent, theData, SpineDialogConfig[theData.type][sType], sType)
    end
end

function cls:showFreeSpinDialog(theData, sType, gType)
    gType = gType or "free"
    local config = {}
    config["gen_path"] = self:getPic("csb/")
    config["csb_file"] = config["gen_path"] .. "dialog_" .. theData.type .. ".csb"
    config["frame_config"] = {
        --["start"] = { { 0, 0 }, 0.5, { 60, 90 }, 0, 0, 0, 0.5 },
        ["collect"] = { { 0, 60 }, 1, { 90, 150 }, 1, transitionDelay[gType].onCover, (transitionDelay[gType].onEnd - transitionDelay[gType].onCover), 0 } -- 最后一个参数 是延时删除的时间 -- 倒数第二个参数 回调 完成方法

    }
    self.freeSpinConfig = config
    local theDialog = G_FREE_SPIN_DIALOGS["base"].new(self.ctl, self.freeSpinConfig)
    self:addDialogSpine(theDialog, theData, sType, gType)
    if sType == fs_show_type.start then
        theDialog:showStart(theData)
    elseif sType == fs_show_type.more then
        theDialog:showMore(theData)
        self:stopMusic(self.audio_list.trigger_bell, true)
    elseif sType == fs_show_type.collect then
        if SpineDialogConfig[theData.type] and SpineDialogConfig[theData.type][sType] then
            local width = SpineDialogConfig[theData.type][sType].maxWidth
            theDialog:setCollectScaleByValue(theData.coins, width)
        end
        theDialog:showCollect(theData)
    end
end
function cls:showJackPotDialog(theData, sType, gType)
    gType = gType or "free"
    local config = {}
    config["gen_path"] = self:getPic("csb/")
    config["csb_file"] = config["gen_path"] .. "dialog_" .. theData.type .. ".csb"
    config["frame_config"] = {
        --["start"] = { { 0, 50 }, 0.5, { 60, 90 }, 0, 0, 0, 0.5 },
        --["more"] = { { 0, 50 }, 2, { 60, 90 }, 0.3, 0, 0, 0.5 },
        ["collect"] = { { 0, 75 }, 1.2, { 120, 200 }, 0, 1.2, 0, 0, 0.5 } -- 最后一个参数 是延时删除的时间 -- 倒数第二个参数 回调 完成方法
    }
    self.freeSpinConfig = config
    local theDialog = G_FREE_SPIN_DIALOGS["base"].new(self.ctl, self.freeSpinConfig)
    self:addDialogSpine(theDialog, theData, sType, gType)
    local width = SpineDialogConfig[theData.type][sType].maxWidth
    theDialog:setCollectScaleByValue(theData.coins, width)
    theDialog:showCollect(theData)
end
---@选择弹窗
function cls:showChooseDialog(theData)
    local config = {}
    config["gen_path"] = self:getPic("csb/")
    config["csb_file"] = config["gen_path"] .. "dialog_3.csb"
    config["frame_config"] = {
        ["start"] = { { 0, 30 }, 0.5, { 60, 90 }, 0, 0, 0, 0.5 },

    }
    local theDialog = DraculaDialog.new(self.ctl, config)
    theDialog:showStart(theData, nil, self.freeDialogNode)
    self:addDialogSpine(theDialog, theData, fs_show_type.start)
end
function cls:dealSpinSendData(data)
    if self.boardType then
        data.free_type = self.boardType
    end
end
function cls:playStartFreeSpinDialog(theData)
    if theData.enter_event then
        theData.enter_event()
    end

    if theData.click_event then
        theData.click_event()
    end

    if theData.end_event then
        theData.end_event()
    end
    if self.ctl.footer then
        self.ctl.footer:showActivitysNode()
    end
end

function cls:playCollectFreeSpinDialog(theData)
    local delayTm = 0
    self.ctl.footer:setSpinButtonState(true) -- 禁用spin 按钮
    self.ctl.footer:enableOtherBtns(false) -- 禁用spin 按钮
    if self.boardType == self:getMaxFreeScatterIndex() then
        delayTm = 2

        self:showChooseDracula(self.boardType, true)
        self:laterCallBack(delayTm, function()
            self:openCollectFreeSpinDialog(theData)
        end)
    else
        self:openCollectFreeSpinDialog(theData)
    end


end
function cls:openCollectFreeSpinDialog(theData)
    if self.ctl.footer then
        self.ctl.footer:hideActivitysNode()
    end
    local click_event = theData.click_event
    theData.click_event = function()
        self:playMusic(self.audio_list.btn_click)
        if click_event then
            click_event()
        end
        self.collectFreeStatus = true

    end
    theData.type = 1
    self:showFreeSpinDialog(theData, fs_show_type.collect, "free")
end
function cls:onCollectFreeClick()
    if not self.collectFreeStatus then
        return
    end
    self.collectFreeStatus = false
    self:runAction(cc.Sequence:create(
    --cc.DelayTime:create(0.2),
            cc.CallFunc:create(function(...)
                self:playTransition(nil, "free")
            end),
            cc.DelayTime:create(transitionDelay.free.onCover),
            cc.CallFunc:create(function(...)
                --if end_event then
                --    end_event()
                --end
            end),
            cc.DelayTime:create(transitionDelay.free.onEnd - transitionDelay.free.onCover),
            cc.CallFunc:create(function(...)
                if self.ctl.footer then
                    self.ctl.footer:showActivitysNode()
                end
            end)
    ))
end
function cls:showBonusNode()
    self.ctl:resetCurrentReels(false, true) -- 更改 bonus 的棋盘
end
function cls:hideBonusNode(free, bonus)
    self.ctl:resetCurrentReels(free, bonus) -- 更改 bonus 的棋盘
end

---------------------------场景恢复处理-------------------------------------

function cls:getFreeReel()
    local data = self.ctl.theme_reels["free_reel"]
    return data
end
-- 处理场景恢复的数据
function cls:adjustEnterThemeRet(retData)
    retData["theme_reels"] = {
        ["main_reel"] = {
            [1] = { 7, 8, 2, 2, 2, 9, 13, 10, 3, 3, 3, 11, 12, 4, 4, 4, 7, 13, 8, 1, 9, 2, 10, 3, 11, 2, 12, 4, 7, 2, 8, 5, 9, 2, 10, 13, 13, 13, 6, 11, 3, 12, 4, 7, 3, 8, 5, 9, 3, 10, 6, 13, 11, 4, 12, 5, 7, 4, 8, 6, 9, 5, 10, 6, 13, 13, 11, 1, 12, 2, 2, 7, 8, 3, 3, 9, 10, 4, 4, 11, 13, 12, 5, 5, 7, 8, 6, 6, 9, 10, 1, 1 },
            [2] = { 9, 10, 2, 2, 2, 11, 13, 12, 3, 3, 3, 7, 8, 4, 4, 4, 9, 13, 10, 1, 11, 2, 12, 3, 7, 2, 8, 4, 9, 2, 10, 5, 11, 2, 12, 13, 13, 13, 6, 7, 3, 8, 4, 9, 3, 10, 5, 11, 3, 12, 6, 13, 7, 4, 8, 5, 9, 4, 10, 6, 11, 5, 12, 6, 13, 13, 7, 1, 8, 2, 2, 9, 10, 3, 3, 11, 12, 4, 4, 7, 13, 8, 5, 5, 9, 10, 6, 6, 11, 12, 1, 1 },
            [3] = { 11, 12, 2, 2, 2, 7, 13, 8, 3, 3, 3, 9, 10, 4, 4, 4, 11, 13, 12, 1, 7, 2, 8, 3, 9, 2, 10, 4, 11, 2, 12, 5, 7, 2, 8, 13, 13, 13, 6, 9, 3, 10, 4, 11, 3, 12, 5, 7, 3, 8, 6, 13, 9, 4, 10, 5, 11, 4, 12, 6, 7, 5, 8, 6, 13, 13, 9, 1, 10, 2, 2, 11, 12, 3, 3, 7, 8, 4, 4, 9, 13, 10, 5, 5, 11, 12, 6, 6, 7, 8, 1, 1 },
            [4] = { 7, 8, 2, 2, 2, 9, 13, 10, 3, 3, 3, 11, 12, 4, 4, 4, 7, 13, 8, 1, 9, 2, 10, 3, 11, 2, 12, 4, 7, 2, 8, 5, 9, 2, 10, 13, 13, 13, 6, 11, 3, 12, 4, 7, 3, 8, 5, 9, 3, 10, 6, 13, 11, 4, 12, 5, 7, 4, 8, 6, 9, 5, 10, 6, 13, 13, 11, 1, 12, 2, 2, 7, 8, 3, 3, 9, 10, 4, 4, 11, 13, 12, 5, 5, 7, 8, 6, 6, 9, 10, 1, 1 },
            [5] = { 9, 10, 2, 2, 2, 11, 13, 12, 3, 3, 3, 7, 8, 4, 4, 4, 9, 13, 10, 1, 11, 2, 12, 3, 7, 2, 8, 4, 9, 2, 10, 5, 11, 2, 12, 13, 13, 13, 6, 7, 3, 8, 4, 9, 3, 10, 5, 11, 3, 12, 6, 13, 7, 4, 8, 5, 9, 4, 10, 6, 11, 5, 12, 6, 13, 13, 7, 1, 8, 2, 2, 9, 10, 3, 3, 11, 12, 4, 4, 7, 13, 8, 5, 5, 9, 10, 6, 6, 11, 12, 1, 1 },
            [6] = { 15, 19, 18, 19, 16, 19, 17, 19, 18, 19 }
        },
        ["free_reel"] = {
            [1] = { 7, 8, 2, 2, 2, 9, 13, 10, 3, 3, 3, 11, 12, 4, 4, 4, 7, 13, 8, 1, 9, 2, 10, 3, 11, 2, 12, 4, 7, 2, 8, 5, 9, 2, 10, 13, 13, 13, 6, 11, 3, 12, 4, 7, 3, 8, 5, 9, 3, 10, 6, 13, 11, 4, 12, 5, 7, 4, 8, 6, 9, 5, 10, 6, 13, 13, 11, 1, 12, 2, 2, 7, 8, 3, 3, 9, 10, 4, 4, 11, 13, 12, 5, 5, 7, 8, 6, 6, 9, 10, 1, 1 },
            [2] = { 9, 10, 2, 2, 2, 11, 13, 12, 3, 3, 3, 7, 8, 4, 4, 4, 9, 13, 10, 1, 11, 2, 12, 3, 7, 2, 8, 4, 9, 2, 10, 5, 11, 2, 12, 13, 13, 13, 6, 7, 3, 8, 4, 9, 3, 10, 5, 11, 3, 12, 6, 13, 7, 4, 8, 5, 9, 4, 10, 6, 11, 5, 12, 6, 13, 13, 7, 1, 8, 2, 2, 9, 10, 3, 3, 11, 12, 4, 4, 7, 13, 8, 5, 5, 9, 10, 6, 6, 11, 12, 1, 1 },
            [3] = { 11, 12, 2, 2, 2, 7, 13, 8, 3, 3, 3, 9, 10, 4, 4, 4, 11, 13, 12, 1, 7, 2, 8, 3, 9, 2, 10, 4, 11, 2, 12, 5, 7, 2, 8, 13, 13, 13, 6, 9, 3, 10, 4, 11, 3, 12, 5, 7, 3, 8, 6, 13, 9, 4, 10, 5, 11, 4, 12, 6, 7, 5, 8, 6, 13, 13, 9, 1, 10, 2, 2, 11, 12, 3, 3, 7, 8, 4, 4, 9, 13, 10, 5, 5, 11, 12, 6, 6, 7, 8, 1, 1 },
            [4] = { 7, 8, 2, 2, 2, 9, 13, 10, 3, 3, 3, 11, 12, 4, 4, 4, 7, 13, 8, 1, 9, 2, 10, 3, 11, 2, 12, 4, 7, 2, 8, 5, 9, 2, 10, 13, 13, 13, 6, 11, 3, 12, 4, 7, 3, 8, 5, 9, 3, 10, 6, 13, 11, 4, 12, 5, 7, 4, 8, 6, 9, 5, 10, 6, 13, 13, 11, 1, 12, 2, 2, 7, 8, 3, 3, 9, 10, 4, 4, 11, 13, 12, 5, 5, 7, 8, 6, 6, 9, 10, 1, 1 },
            [5] = { 9, 10, 2, 2, 2, 11, 13, 12, 3, 3, 3, 7, 8, 4, 4, 4, 9, 13, 10, 1, 11, 2, 12, 3, 7, 2, 8, 4, 9, 2, 10, 5, 11, 2, 12, 13, 13, 13, 6, 7, 3, 8, 4, 9, 3, 10, 5, 11, 3, 12, 6, 13, 7, 4, 8, 5, 9, 4, 10, 6, 11, 5, 12, 6, 13, 13, 7, 1, 8, 2, 2, 9, 10, 3, 3, 11, 12, 4, 4, 7, 13, 8, 5, 5, 9, 10, 6, 6, 11, 12, 1, 1 },
        },
    }
    self.collectTargetCounts = 100
    self.collectMapLevel = 31-- 总共需要收集的数量

    if retData["map_info"] then
        self.themeMapInfo = retData["map_info"]
        self.mapLevel = self.themeMapInfo["map_level"]
        self.collectMajorId = self.themeMapInfo["collect_symbol"] or specialSymbol.trigger -- 收集的symbol id
        self.collectSymbolCounts = self.themeMapInfo["map_points"]-- 当前收集的count
    end
    if retData["free_game"] then
        if retData.final_wild_pos then
            -- free 断线重连数据 控制
            self.wildNextBeginPos = tool.tableClone(retData.final_wild_pos) -- "final_wild_pos": [ [ 4, 2 ], [ 3, 3 ], [ 5, 3 ] ]
            self.exWildFinalPos = tool.tableClone(retData.final_wild_pos) -- "final_wild_pos": [ [ 4, 2 ], [ 3, 3 ], [ 5, 3 ] ]
            self.wildCount = retData.wild_count
            self.wildTotalCount = self:getWildTotalCount()
        end
        if retData.begin_wild_pos then
            self.beginWildPos = retData.begin_wild_pos
        end

        if retData["free_game"].super_bet then
            self.superAvgBet = retData["free_game"].super_bet
        end
        self.ctl.freeSpeical = self:getSpecialTryResume(retData["free_game"]["item_list"])

        if retData["free_game"]["free_random_pick"] then

            self.recvItemList = retData["free_game"]["item_list"]
            self.trigger_item_list = retData["free_game"]["item_list"]
            self.freeCount = self:getFreeCount()
            retData["first_free_game"] = {}
            retData["first_free_game"]["data"] = retData["free_game"]["free_random_pick"]
            retData["first_free_game"]["base_win"] = retData["free_game"]["base_win"]
            retData["first_free_game"]["total_win"] = retData["free_game"]["total_win"]
            retData["first_free_game"]["bet"] = retData["free_game"]["bet"]
            retData["first_free_game"]["item_list"] = retData["free_game"]["item_list"]
            retData["first_free_game"]["free_spins"] = retData["free_game"]["free_spins"]
            retData["first_free_game"]["free_spin_total"] = retData["free_game"]["free_spin_total"]
            retData["free_game"] = nil

        else
            self:setBoardType(retData["free_game"]["free_spin_type"])
            self.freeWinCoinsList = retData.total_win_list
            self.freeWinSymbolsList = retData.scatter_list
        end

    end

    if retData["bonus_game"] then
        self.recvItemList = retData["bonus_game"]["item_list"]
        self.ctl.bonusSpeical = self:getSpecialTryResume(retData["bonus_game"]["item_list"])
        if retData["bonus_game"].super_bet then
            self.superAvgBet = retData["bonus_game"].super_bet
        end
        if retData["bonus_game"].jp_win and #retData["bonus_game"].jp_win > 0 then
            self.isGetJackPot = true
        end
    end

    self.tipBet = retData.bonus_level or 1

    return retData
end
function cls:setBoardType(index)
    self.boardType = index or 1
end
function cls:adjustTheme(data)
    -- 进入主题调用的函数 解析 jackpot 数据在这里


    self:changeSpinBoard(SpinBoardType.Normal)
    if self.recvItemList then
        self.ctl:resetBoardCellsSprite(self.recvItemList)
    end
end

function cls:setFreeGameRecoverState(data)
    if data["free_spins"] and data["free_spins"] >= 0 then
        -- 断线重连如果是最后一次freespin 的时候就不在进行这个操作
        self.isFreeGameRecoverState = true
    end
end
function cls:getBonusTriggerItemList()
    local item_list = self.ctl:getRetMatrix()
    return item_list
end

-----------------------------------------------------------------------------------
-- 滚轴相关
-----------------------------------------------------------------------------------
function cls:genSpecials(pWinPosList)
    if self.showSpinBoard ~= SpinBoardType.Normal then
        return
    end
    local specials = { [specialSymbol.trigger] = {} }
    local itemList = self.ctl:getRetMatrix()
    local winPosList = pWinPosList or self.ctl:getWinPosList()
    local winTagList = {}
    for _, crPos in pairs(winPosList) do
        winTagList[crPos[1]] = winTagList[crPos[1]] or {}
        winTagList[crPos[1]][crPos[2]] = true
    end
    if itemList and winPosList then
        for col, colItemList in pairs(itemList) do
            for row, theKey in pairs(colItemList) do
                if type(theKey) == "number" and (theKey) == specialSymbol.trigger then
                    specials[specialSymbol.trigger][col] = specials[specialSymbol.trigger][col] or {}
                    specials[specialSymbol.trigger][col][row] = true
                end
            end
        end
    end
    self.ctl.specials = specials
end

function cls:genSpecialSymbolState(rets)
    self.item_list = rets.item_list
    rets = rets or self.ctl.rets
    if not self.checkItemsState then
        self.checkItemsState = {}  -- 都已列作为项， 各列各个sybmol相关状态，分为后面有可能，单列就有可能中，已经中了，后续没有可能中了
        self.speedUpState = {}  -- 加速的列控制
        self.notifyState = {}  -- 播放特殊symbol滚轴停止的时候的动画位置
        self:genSpecialSymbolStateInNormal(rets) -- jackpot symbol 落地动画配置
    end
end

function cls:genSpecialSymbolStateInNormal(rets)


    local cItemList = rets.item_list
    local checkConfig = self.specialItemConfig

    if self.showSpinBoard ~= SpinBoardType.Normal then

        return
    end
    for itemKey, theItemConfig in pairs(checkConfig) do
        local itemType = theItemConfig["type"]
        local itemCnt = 0
        local get_reel = 0
        if itemType then
            for col = 1, 5 do
                local colItemList = cItemList[col]
                local colRowCnt = self.spinLayer.spins[col].row -- self.colRowList[col]
                local curColMaxCnt = theItemConfig["col_set"][col] or colRowCnt
                -- 判断_当前列之前_是否已经中了feature(通过之前列itemKey个数判断)
                local colItemCnt = 0
                local isGetFeature = false
                for row, theItem in pairs(colItemList) do
                    if theItem == itemKey then
                        colItemCnt = colItemCnt + 1
                    end
                end
                if colItemCnt > 0 then
                    isGetFeature = true
                    get_reel = get_reel + 1
                end
                -- 判断当前列加上之后所有列是否有可能中feature
                local willGetFeatureInAfterCols = false

                local sumCnt = 0
                for tempCol = col, #self.spinLayer.spins do
                    sumCnt = sumCnt + (theItemConfig["col_set"][tempCol] or 0)
                end
                if curColMaxCnt > 0 and sumCnt > 0 and (itemCnt + sumCnt) >= theItemConfig["min_cnt"] then
                    willGetFeatureInAfterCols = true
                end
                local mini = theItemConfig["col_set"][col]
                if willGetFeatureInAfterCols then
                    self.speedUpState[col] = self.speedUpState[col] or {}-- 此情况下，会进行特殊操作，将其状态记到self.speedUpState中
                    self.speedUpState[col][itemKey] = self.speedUpState[col][itemKey] or {}
                    self.speedUpState[col][itemKey]["cnt"] = itemCnt + mini
                    self.speedUpState[col][itemKey]["real_cnt"] = itemCnt + colItemCnt
                    self.speedUpState[col][itemKey]["is_get"] = isGetFeature
                    self.speedUpState[col][itemKey]["max_left"] = sumCnt - mini
                    self.speedUpState[col][itemKey]["get_reel"] = get_reel
                    --end
                end
                self.notifyState[col] = self.notifyState[col] or {}-- 当前列提示相关状态
                if willGetFeatureInAfterCols then
                    for row, theItem in pairs(colItemList) do
                        if theItem == itemKey then
                            self.notifyState[col][itemKey] = self.notifyState[col][itemKey] or {}
                            table.insert(self.notifyState[col][itemKey], { col, row })
                        end
                    end
                end
                if isGetFeature then
                    itemCnt = itemCnt + colItemCnt
                end

            end
        end
    end
end

function cls:stopControl(stopRet, stopCallFun)
    if stopRet["bonus_level"] then
        self.tipBet = stopRet["bonus_level"]
    end
    self.freeCount = nil
    self.item_list = stopRet.item_list
    self.realItem_list = {}
    if stopRet["free_game"] then
        self.freeCount = stopRet["free_game"].free_spins
    end
    if self.showSpinBoard == SpinBoardType.FreeSpin then

        self:playStopControlMoveWildAction(stopRet)
    else
        -- if stopRet.theme_info["anticipation"] and stopRet.theme_info["anticipation"] == 1 then
            self.isJpAnticipation = false
        -- end
    end

    local jp_win = stopRet["jp_win"]

    if #jp_win > 0 then
        self.isJpWin = true
        self.jpWinValue = jp_win[1]["jp_win"]
        self.jpWinType = jp_win[1]["jp_win_type"]
        self.isGetJackPot = true
    end
    --self.haveMoveWildAnim = false
    if self.showSpinBoard == SpinBoardType.FreeSpin and self.exWildFinalPos and #self.exWildFinalPos > 0 then
        --self.haveMoveWildAnim = true
        --self:playMoveWildAction()
        --if self.dataBackStatus == 1 then
        --
        --    self.dataBackStatus = 2
        --end
        self:moveNextPos()
    end
    if self.haveSpecialdelay then
        self.nextStopCallFun = stopCallFun
    else
        stopCallFun()
    end
end

function cls:after_win_show()
    self.ctl.rets = self.ctl.rets or {}
    self.ctl.rets.after_win_show = false
    local have = false
    if self.ctl.freespin > 0 then
        if self.showSpinBoard == SpinBoardType.FreeSpin and self.wildNextBeginPos and #self.wildNextBeginPos > 0 then
            self.haveMoveWildAnim = true
            self.exWildFinalPos = self.wildNextBeginPos

            self:playMoveWildAction()
            have = true
        end
    end
    if have then
        self:laterCallBack(1, function()
            self.ctl:handleResult()
        end)
    else
        self.ctl:handleResult()
    end

end
function cls:changeRealBoard(item_list, final_wild_pos)
    local realItem_list = tool.tableClone(item_list)
    if final_wild_pos and #final_wild_pos > 0 then
        for boardIndex = 1, #final_wild_pos do
            local myBoardList = final_wild_pos[boardIndex]
            for key, myItem in ipairs(myBoardList) do
                local realCol = myItem[1] + (boardIndex - 1) * 5
                local realrow = myItem[2]
                local oldKey = realItem_list[realCol][realrow]
                if oldKey == specialSymbol.trigger or oldKey == specialSymbol.trigger_2 then
                    realItem_list[realCol][realrow] = specialSymbol.trigger_2
                else
                    realItem_list[realCol][realrow] = specialSymbol.wild
                end
            end

        end
    end

    return realItem_list
end

function cls:stopDrawAnimate()
    self.speicalDelay = 0
    self.haveSpecialdelay = false
    local delay = 0

    self:stopReelNotifyEffect(nil)
    self:stopReelNotifyEffect(6)
    --self:stopReelNotifyEffect(nil, specialSymbol.bonus)

    Theme.stopDrawAnimate(self)

end

function cls:cleanStatus()
    self.animNodeList = nil
    self.itemList = nil

    Theme.cleanStatus(self)
end
function cls:clearAnimate()
    self.animateNode:removeAllChildren()
    self.themeAnimateKuang:removeAllChildren()
    self.jiliBgNode:removeAllChildren()

    self:cleanAnimateList()
    self:cleanCellState()
end


------------------------------- store start -----------------------------------
---


function cls:showStoreNode(isMapLevel)
    if self.isFeatureClick then
        return
    end
    self:playMusic(self.audio_list.popup_out)
    self:grayFastJackPot(true)
    self.animateNode:setVisible(false)
    self.themeAnimateKuang:setVisible(false)
    --self.isFeatureClickIng = true
    self.isFeatureClick = true
    if not self.storeNode then
        self:createStoreNode()
    end
    self.storeSpineNode:removeAllChildren()
    self.storeSpineList = {}
    --self.storeCallBack = callback
    self.btnStore:setTouchEnabled(false)
    self.btnStore:setBright(false)
    if isMapLevel then
        self.ctl.footer:enableOtherBtns(false)
        self.ctl.footer:setSpinButtonState(true)
    end

    self.ctl.footer.isFreeSpin = true
    self.storeNode:setVisible(true)

    local action = cc.CSLoader:createTimeline(self:getPic(allCsbList.store))
    self.storeNode:runAction(action)
    action:gotoFrameAndPlay(0, 30, false)

    if self.bonus then
        self:initStoreCollect()
    else
    end
    local delay = 0.5
    self.storeRootNode:stopAllActions()
    self.storeRootNode:setPosition(cc.p(0, 1160))
    self.storeRootNode:runAction(
            cc.Sequence:create(
                    cc.MoveTo:create(delay, cc.p(0, 0)),
                    cc.CallFunc:create(
                            function()
                                --self.isFeatureClickIng = false
                                if self.isCanFeatureClick then
                                    self.btnStore:setTouchEnabled(true)
                                    self.btnStore:setBright(true)
                                end


                            end)
            )
    )
    self:showCurStoreNode(isMapLevel)
end
function cls:initStoreCollect()

    local theData = {}
    theData.type = 4
    if self.bonus then
        theData.coins = self.bonus.bonusWin
    else
        theData.coins = 100000
    end
    theData.enter_event = function()
        self:playMusic(self.audio_list.map_dialog_collect_show)
    end
    theData.click_event = function()

        self:closeStoreNode(true)
        self.ctl:collectCoins(2)
        if self.bonus then
            self.bonus:finishBonusGame()
        end
        self:showProgressAnimation(0, false)
    end

    local sType = fs_show_type.collect
    local config = {}
    config["gen_path"] = self:getPic("csb/")
    config["csb_file"] = config["gen_path"] .. "dialog_" .. theData.type .. ".csb"
    config["frame_config"] = {
        ["collect"] = { { 0, 135 }, 2, { 150, 180 }, 0, 0.5, 0, 0, 0.5 } -- 最后一个参数 是延时删除的时间 -- 倒数第二个参数 回调 完成方法
    }
    self.freeSpinConfig = config
    local theDialog = G_FREE_SPIN_DIALOGS["base"].new(self.ctl, self.freeSpinConfig)
    self:addDialogSpine(theDialog, theData, sType)
    local width = SpineDialogConfig[theData.type][sType].maxWidth
    theDialog:setCollectScaleByValue(theData.coins, width)
    theDialog:showCollect(theData)


end
function cls:createStoreNode()
    self.storeNode = cc.CSLoader:createNode(self:getPic(allCsbList.store))--  加载 商店显示
    self.storeChildNode:addChild(self.storeNode)
    self.storeRootNode = self.storeNode:getChildByName("root")
    ---center
    self.storeBgNode = self.storeRootNode:getChildByName("node_bg")
    self.storeBgList = self.storeBgNode:getChildren()
    ---close
    self.storeSpineNode = self.storeRootNode:getChildByName("spine")

    ---tipode
    self.storeItemTipList = {}
end
function cls:lightStoreNode(node, maplevel, newLight)
    local aniName = "animation1"
    local iscycle = false
    if newLight then
        -- new
        if buildLevel[maplevel] == 3 then
            aniName = "animation"
            iscycle = true
        else
            aniName = "animation1"
            iscycle = false
        end
    else
        iscycle = true
        if buildLevel[maplevel] == 3 then
            aniName = "animation1"
        else
            aniName = "animation2"
        end
    end
    local spineFile = SpineConfig.store_item
    if buildLevel[maplevel] == 2 then
        spineFile = SpineConfig.store_big_item
    elseif buildLevel[maplevel] == 3 then
        spineFile = SpineConfig.store_castle
    end
    if node.spine and bole.isValidNode(node.spine) then
        if buildLevel[maplevel] < 3 then
            bole.spChangeAnimation(node.spine, aniName, not newLight)
        else
            bole.spChangeAnimation(node.spine, "animation", true)
        end
    else
        local _, ispine = bole.addSpineAnimation(self.storeSpineNode, 1, self:getPic(spineFile), bole.getPos(node), aniName, nil, nil, nil, true, iscycle)
        node.spine = ispine
    end


end
---@desc 刷新界面
function cls:showCurStoreNode(isMapLevel)

    local mapImg = {
        open = {
            [1] = "#theme174_map_13.png", -- small
            [2] = "#theme174_map_12.png", -- big
        },
        unopen = {

            [1] = "#theme174_map_14.png", -- small
            [2] = "#theme174_map_11.png", -- big
        }
    }
    local maplevel = self.mapLevel
    if isMapLevel then
        if maplevel == 0 then
            maplevel = 31
        end
    end
    self.storeSpineNode:removeAllChildren()
    local _, ispine = bole.addSpineAnimation(self.storeSpineNode, 1, self:getPic(SpineConfig.store_bg), cc.p(0, 0), "animation", nil, nil, nil, true, true)

    for i = 1, #self.storeBgList do
        local node = self.storeBgList[i]
        if i < 31 then
            local item_type = buildLevel[i]
            local item_png

            if maplevel >= i then
                if isMapLevel then
                    if maplevel == i then
                        item_png = mapImg.unopen[item_type]
                    else
                        item_png = mapImg.open[item_type]
                    end
                else
                    item_png = mapImg.open[item_type]
                end


            else
                item_png = mapImg.unopen[item_type]
            end

            if not isMapLevel and i == maplevel then
                self:lightStoreNode(node, i, false)
            elseif isMapLevel and i == maplevel - 1 then
                self:lightStoreNode(node, i, false)
            end
            bole.updateSpriteWithFile(node, item_png)
        else
            self:lightStoreNode(node, i, false)
        end

    end
    if isMapLevel then

        local chooseNode = self.storeBgList[maplevel]
        local lastNode = nil
        if maplevel > 1 then
            lastNode = self.storeBgList[maplevel - 1]
        end

        chooseNode:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(45 / 30),
                        cc.CallFunc:create(function()

                            if buildLevel[maplevel] < 3 then
                                self:playMusic(self.audio_list.button)
                            else
                                self:playMusic(self.audio_list.castle)
                            end
                            self:lightStoreNode(chooseNode, maplevel, true)
                            if lastNode then
                                if lastNode.spine and bole.isValidNode(lastNode.spine) then
                                    lastNode.spine:removeFromParent()
                                    lastNode.spine = nil
                                end
                            end
                        end),
                        cc.DelayTime:create(10 / 30),
                        cc.CallFunc:create(
                                function()
                                    local item_type = buildLevel[maplevel]
                                    if item_type < 3 then
                                        local item_png = mapImg.open[item_type]
                                        bole.updateSpriteWithFile(chooseNode, item_png)
                                        self:lightStoreNode(chooseNode, maplevel, false)


                                    end
                                end)
                )
        )

    end

end
function cls:closeStoreNode(isCollect)
    if not self.storeNode or not self.storeNode:isVisible() then
        return
    end
    if not self.isFeatureClick then
        return
    end
    self:playMusic(self.audio_list.popup_out)
    self:grayFastJackPot(false)
    self.animateNode:setVisible(true)
    self.themeAnimateKuang:setVisible(true)
    --self:enableMapInfoBtn(false)
    self.isFeatureClick = false
    --self.isFeatureClickIng = true

    self.btnStore:setTouchEnabled(false)
    self.btnStore:setBright(false)

    self:playMusic(self.audio_list.map_close)
    local delay = 0.5
    self.storeRootNode:setPosition(cc.p(0, 0))
    self.storeRootNode:runAction(
            cc.Sequence:create(
                    cc.MoveTo:create(delay, cc.p(0, 1160)),
                    cc.CallFunc:create(
                            function()
                                self.storeNode:setVisible(false)
                                --self.isFeatureClickIng = false
                                --self:enableMapInfoBtn(true)
                                if self.isCanFeatureClick then
                                    self.btnStore:setTouchEnabled(true)
                                    self.btnStore:setBright(true)
                                end
                            end
                    )
            )
    )
    local action = cc.CSLoader:createTimeline(self:getPic(allCsbList.store))
    self.storeNode:runAction(action)
    action:gotoFrameAndPlay(60, 90, false)

    self.ctl.footer.isFreeSpin = false
    if isCollect then
        self.ctl.footer:enableOtherBtns(true)
        self.ctl.footer:setSpinButtonState(false) --
    end

end
------------------------------- store  paytable end -------------------------------------

-----------------------------Transition弹窗相关------------------------------
function cls:playTransition(endCallBack, tType)
    local function delayAction()
        local transition = DraculaTransition.new(self, endCallBack)
        transition:play(tType)
    end
    delayAction()
end

DraculaTransition = class("DraculaTransition", CCSNode)
local GameTransition = DraculaTransition
function GameTransition:ctor(theme, endCallBack)
    self.spine = nil
    self.theme = theme
    self.endFunc = endCallBack
end
function GameTransition:play(tType)
    local spineFile = self.theme:getPic(SpineConfig.transition_free) -- 默认显示 Free transition
    local pos = cc.p(0, 0)
    local delay1 = transitionDelay[tType]["onEnd"]
    if tType == "free" then
        -- translate1
        self.theme:laterCallBack(0.1, function()
            self.theme:playMusic(self.theme.audio_list.transition_free)
        end)
    end
    self.theme.curScene:addToContentFooter(self)
    bole.adaptTransition(self, true, true)
    self:setVisible(false)
    self:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(0.1),
                    cc.CallFunc:create(function()
                        local _, s = bole.addSpineAnimation(self, nil, spineFile, pos, "animation")
                        self:setVisible(true)
                    end),
                    cc.DelayTime:create(delay1), -- 切屏动画完成时间
                    cc.CallFunc:create(function(...)
                        if self.endFunc then
                            self.endFunc()
                        end
                    end),
                    cc.RemoveSelf:create()))
end
function cls:onExit()
    if self.shaker then
        self.shaker:stop()
    end
    Theme.onExit(self)
end

function cls:configAudioList()
    Theme.configAudioList(self)
    self.audio_list = self.audio_list or {}
    -- common
    self.audio_list.trigger_bell = "audio/base/bell.mp3"
    self.audio_list.btn_click = "audio/base/common_click.mp3"
    self.audio_list.popup_out = "audio/base/popup_out.mp3"

    --base
    self.audio_list.base_background = "audio/base/base_bgm.mp3"
    self.audio_list.reel_notify = "audio/base/reel_notify.mp3"
    self.audio_list.symbol_scatter1 = "audio/base/symbol_scatter1.mp3"
    self.audio_list.symbol_scatter2 = "audio/base/symbol_scatter2.mp3"
    self.audio_list.symbol_scatter3 = "audio/base/symbol_scatter3.mp3"
    self.audio_list.symbol_scatter4 = "audio/base/symbol_scatter4.mp3"
    self.audio_list.symbol_scatter5 = "audio/base/symbol_scatter5.mp3"
    self.audio_list.symbol_jackpot = "audio/base/jackpot.mp3"
    self.audio_list.transition_free = "audio/base/transition_free.mp3"
    --collect
    self.audio_list.lock = "audio/base/lock.mp3"
    self.audio_list.unlock = "audio/base/unlock.mp3"

    self.audio_list.collect = "audio/base/collect.mp3"--收集月亮+接收
    self.audio_list.castle = "audio/map/castle.mp3"--城堡中奖
    self.audio_list.button = "audio/map/button.mp3"--小关卡点亮
    self.audio_list.meter = "audio/base/meter.mp3"--收集条集满
    self.audio_list.map_dialog_collect_show = "audio/map/map_dialog_collect_show.mp3"
    --free
    self.audio_list.free_background = "audio/free/free_bgm.mp3"
    self.audio_list.choose_right = "audio/free/choose_right.mp3"
    self.audio_list.moon_num = "audio/free/num.mp3"
    self.audio_list.free_dialog_collect_show = "audio/free/free_dialog_collect_show.mp3"
    self.audio_list.free_dialog_start_show = "audio/free/free_dialog_start_show.mp3"
    --jackpot
    self.audio_list.jackpot_1 = "audio/base/grand.mp3"
    self.audio_list.jackpot_2 = "audio/base/major.mp3"
    self.audio_list.jackpot_4 = "audio/base/mini.mp3"
    self.audio_list.jackpot_3 = "audio/base/minor.mp3"
    self.audio_list.jp_notify = "audio/base/jp_notify.mp3"
    self.audio_list.jp_show = "audio/base/jp_show.mp3"

    self.audio_win_list = self.audio_win_list or {}
    self.audio_win_list.commonrollup03 = "audio/base/win3.mp3"
    self.audio_win_list.commonrollup03_end = "audio/base/win3end.mp3"

end
function cls:getLoadMusicList()
    local loadMuscList = {
        self.audio_list.trigger_bell, --
        self.audio_list.btn_click, --
        self.audio_list.popup_out, --
        --base
        self.audio_list.base_background, --
        self.audio_list.reel_notify, --
        self.audio_list.symbol_scatter1, --
        self.audio_list.symbol_scatter2, --
        self.audio_list.symbol_scatter3, --
        self.audio_list.symbol_scatter4, --
        self.audio_list.symbol_scatter5, --
        self.audio_list.symbol_jackpot,
        self.audio_list.transition_free, --
        --collect
        self.audio_list.collect, --
        self.audio_list.lock, --
        self.audio_list.unlock, --
        self.audio_list.castle, --
        self.audio_list.button, --
        self.audio_list.meter, --
        self.audio_list.map_dialog_collect_show, --
        --free
        self.audio_list.free_background, --
        self.audio_list.choose_right,
        self.audio_list.free_dialog_collect_show, --
        self.audio_list.free_dialog_start_show, --
        self.audio_list.moon_num, --
        --jackpot
        self.audio_list.jackpot_1, --
        self.audio_list.jackpot_2, --
        self.audio_list.jackpot_3, --
        self.audio_list.jackpot_4, --
        self.audio_list.jp_notify, --
        self.audio_list.jp_show, --

        self.audio_win_list.commonrollup03,
        self.audio_win_list.commonrollup03_end


    }
    return loadMuscList
end
--------------------------- 音效控制 ---------------------------


function cls:dealMusic_PlayShortNotifyMusic(pCol)

    --if self.playR1Col == 1 + (pCol - 1) % 6 then
    --    return
    --end

    if self.showSpinBoard == SpinBoardType.FreeSpin then
        if pCol <= 5 then
            self:dealMusic_PlayReelStopMusic(pCol)
        end
    else
        self:dealMusic_PlayReelStopMusic(pCol)
    end

end
function cls:dealMusic_PlayReelNotifyMusic(pCol)
    -- 最后一列激励音效
    -- 最后一列激励音效
    if pCol <= 5 then
        if self.playR1Col == 1 + (pCol - 1) % 6 then
            return
        end
        self:playMusic(self.audio_list.reel_notify, true, true)
        self.playR1Col = 1 + (pCol - 1) % 6

    else
        if self.playR1Col == 1 + (pCol - 1) % 6 then
            return
        end
        self:playMusic(self.audio_list.jp_notify, true, true)
        self.play6Col = 1 + (pCol - 1) % 6
    end


end -- 滚轮音效相关
function cls:dealMusic_StopReelNotifyMusic(pCol)

    if not pCol then
        if self.playR1Col then
            self:stopMusic(self.audio_list.reel_notify, true)
            self.playR1Col = nil
        end

        if self.play6Col then
            self:stopMusic(self.audio_list.jp_notify, true)
            self.play6Col = nil
        end
    else
        if self.playR1Col and self.playR1Col == pCol then
            self:stopMusic(self.audio_list.reel_notify, true)
            self.playR1Col = nil
        end

        if self.play6Col and self.play6Col == pCol then
            self:stopMusic(self.audio_list.jp_notify, true)
            self.play6Col = nil
        end
    end


end

function cls:dealMusic_PlayBonusLoopMusic()

    AudioControl:volumeGroupAudio(1)
end
function cls:dealMusic_ExitBonusGame()
    AudioControl:stopGroupAudio("music")
    local name = self.audio_list.base_background
    local stageType = 1
    if self.ctl.freewin then
        name = self.audio_list.free_background
        stageType = 2
    end
    self:playLoopMusic(name)
end
-- 播放free games的背景音乐
function cls:dealMusic_PlayFreeSpinLoopMusic()
    -- 播放背景音乐
    AudioControl:stopGroupAudio("music")
    self:playLoopMusic(self.audio_list.free_background)
    AudioControl:volumeGroupAudio(1)
end
function cls:dealMusic_PlayFSEnterMusic()
end

function cls:dealMusic_PlayFSEnterMusic2()
    self:playMusic(self.audio_list.free_dialog_start_show)
end

function cls:dealMusic_StopBonusLoopMusic()
    AudioControl:stopGroupAudio("music")
    --self:stopMusic(self.audio_list.respin_background)
end
function cls:dealMusic_StopPickLoopMusic()
    AudioControl:stopGroupAudio("music")
    self:stopMusic(self.audio_list.pick_background)
end

function cls:dealMusic_StopFSEnterMusic()
end
function cls:dealMusic_PlayBonusCollectMusic()
    self:playMusic(self.audio_list.jp_show)
end

function cls:enableMapInfoBtn(enable)
    self.isCanFeatureClick = enable
    --local color = cc.c3b(95, 95, 95)
    --if enable then
    --    color = cc.c3b(255, 255, 255)
    --end
    --self.btnStore:setColor(color)
    self.btnStore:setTouchEnabled(enable)
    self.btnStore:setBright(enable)
    if not enable and self.isFeatureClick then
        self:closeStoreNode()
    end

end

--商店点击购买
function cls:collectFreeRollEnd()

    if self.showSpinBoard == SpinBoardType.FreeSpin then
        return
    end
    self:finshSpin()
    if self.ctl.footer then
        self.ctl.footer:showActivitysNode()
    end
end

function cls:getJackpotNum(bet)

    local base = {
        grand = 5000,
        major = 500,
        minor = 20,
        mini = 10
    }
    local baseBet = bet
    if type(bet) == "string" then
        baseBet = base[bet]
    end
    if self.superAvgBet then
        return self.superAvgBet * baseBet
    else
        return self.ctl:getCurTotalBet() * baseBet
    end
end
function cls:getFrames(colid)
    if self.showSpinBoard == SpinBoardType.FreeSpin then
        local symbols = self.ctl.currentReels[((colid - 1) % 5 + 1)]
        local n = math.random(10, 20)
        local ret = {}
        for i = 1, n do
            local t = math.random(1, #symbols)
            ret[i] = symbols[t]
        end

        return ret
    else
        return Theme.getFrames(self, colid)
    end
end

function cls:fixRet(ret, spinLayerType)
    if self.showSpinBoard == SpinBoardType.FreeSpin then
        local new_pos_List = {} -- 更新新的 pos list
        for i = 1, #ret["win_pos_list"] do
            for k, v in ipairs(ret["win_pos_list"][i]) do
                table.insert(new_pos_List, { v[1] + (i - 1) * 5, v[2] })
            end
        end
        ret["win_pos_list"] = new_pos_List

        local new_win_List = {} -- 更新新的 winLisne
        for i = 1, #ret["win_lines"] do
            -- local play_idx = 1
            for k, v in ipairs(ret["win_lines"][i]) do
                v.col_ck = 5 * (i - 1)
                -- v.play_idx = play_idx
                -- play_idx = play_idx + 1
                table.insert(new_win_List, v)
            end
        end
        ret["win_lines"] = new_win_List
    end

    --self.recvItemList = ret.item_list
end
--function cls:getFakeData()
--
--    local data = {
--        theme_info = {
--            bonus_level = 1,
--            final_wild_pos = { { { 5, 2 } }, { { 2, 2 } }, { { 3, 3 } }, { { 5, 1 } } },
--            disk_data = {},
--            total_win_list = { 0, 1650000000, 0, 0 },
--            prize_id = 0, wild_count = { 1, 1, 1, 1 },
--            scatter_list = { 0, 0, 0, 0 },
--            map_info = { map_level = 14, wager_count = 435, map_points = 31, wager = 283235000000 },
--            begin_wild_pos = { {}, {}, {}, {} },
--        },
--        base_win = 0,
--        total_win = 0,
--        daily_bonus_multiplier = 1.32,
--        item_list = { { 12, 2, 3 }, { 5, 6, 7 }, { 3, 4, 5 }, { 2, 3, 4 }, { 9, 1, 11 }, { 12, 2, 3 }, { 5, 1, 7 }, { 8, 9, 10 }, { 7, 8, 9 }, { 12, 2, 3 }, { 2, 3, 4 }, { 10, 11, 12 }, { 5, 6, 1 }, { 3, 4, 5 }, { 6, 7, 8 }, { 10, 11, 12 }, { 11, 12, 2 }, { 8, 9, 10 }, { 6, 7, 8 }, { 1, 10, 11 } },
--        item_list_down = { { 4, 5, 6, 7, 8, 9 }, { 8, 9, 10, 11, 12, 2 }, { 6, 7, 8, 9, 10, 11 }, { 5, 6, 7, 8, 9, 10 }, { 12, 2, 3, 4, 5, 6 }, { 4, 5, 6, 7, 8, 9 }, { 8, 9, 10, 11, 12, 2 }, { 11, 12, 2, 3, 4, 5 }, { 10, 11, 12, 2, 3, 4 }, { 4, 5, 6, 7, 8, 9 }, { 5, 6, 7, 8, 9, 10 }, { 2, 3, 4, 5, 6, 7 }, { 8, 9, 10, 11, 12, 2 }, { 6, 7, 8, 9, 10, 11 }, { 9, 10, 11, 12, 2, 3 }, { 2, 3, 4, 5, 6, 7 }, { 3, 4, 5, 6, 7, 8 }, { 11, 12, 2, 3, 4, 5 }, { 9, 10, 11, 12, 2, 3 }, { 12, 2, 3, 4, 5, 6 } },
--        coins = 447252016810550,
--        experience = 14722543560000,
--        win_lines = { {}, { { count = 2, line = 1, symbol = 2 }, { count = 2, line = 5, symbol = 3 }, { count = 2, line = 9, symbol = 3 }, { count = 2, line = 14, symbol = 3 }, { count = 2, line = 18, symbol = 2 }, { count = 2, line = 19, symbol = 2 }, { count = 2, line = 29, symbol = 3 }, { count = 2, line = 35, symbol = 3 }, { count = 2, line = 38, symbol = 3 }, { count = 2, line = 45, symbol = 3 }, { count = 2, line = 50, symbol = 2 } }, {}, {} },
--        dashboard = { session_left_time = 1576818000, daily_left_time = 1576731600, mission_points = 0, wheel_collected = 0, mission = { count = 0, index = 1, target = 1, current = 1, tid = 0, type = 3 } },
--        win_pos_list = { {}, { { 1, 2 }, { 2, 2 }, { 1, 3 } }, {}, {} },
--        item_list_up = { { 11 }, { 4 }, { 2 }, { 12 }, { 8 }, { 11 }, { 4 }, { 7 }, { 6 }, { 11 }, { 12 }, { 9 }, { 4 }, { 2 }, { 5 }, { 9 }, { 10 }, { 7 }, { 5 }, { 8 } }, bonus_base_win = 0 }
--
--    return data
--end
----------------------------------respin show end-----------------------------------
----------------------------------bonus show start-----------------------------------



----------------------------------bonus show end ------------------------------------
--------------------------------- Bonus start ---------------------------------
DraculaBonus = class("DraculaBonus")
local bonusGame = DraculaBonus
function bonusGame:ctor(bonusControl, theme, csbPath, data, callback)
    self.bonusControl = bonusControl
    self.theme = theme
    self.csbPath = csbPath
    self.callback = callback
    self.oldCallBack = callback
    self.data = data
    self.theme.bonus = self
    self.ctl = bonusControl.themeCtl
    self.jackpotUsedList = {}
    self.data.spinCount = self.data.spinCount or 0
    self.data.sumCount = 20
    self.ctl.rets = self.ctl.rets or {}
    self.jpWinList = self.ctl.rets["jp_win"]
    self:saveBonus()
    self.bonusWin = 0
    self.bonusWinType = 1

    if self.data.core_data.map_win then
        self.bonusWin = self.data.core_data.map_win
        self.bonusWinType = 2

    else
        self.bonusWin = self:getJackpotWin()
    end
    self.theme:saveBonusData()
end
function bonusGame:getJackpotWin()
    local total = 0
    if self.rets and self.rets.jp_win and self.rets.jp_win[1] then
        total = self.rets.jp_win[1].jp_win
    else
        total = self.data.core_data.jp_win[1].jp_win

    end
    return total
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

function bonusGame:initProgressBonusGame()
    self.theme:lockJackpotMeters(true)
    self.progressive_list = self.data.core_data["progressive_list"]
    local link_config = self.theme:getThemeJackpotConfig().link_config
    local jpLabels = self.theme.jackpotLabels
    if self.progressive_list then
        for i = 1, #self.progressive_list do
            if jpLabels[i] then
                local jackpotNum = self.theme:getJackpotNum(link_config[i])
                if self.progressive_list then
                    jackpotNum = jackpotNum + self.progressive_list[i]
                end
                jpLabels[i]:setString(self.theme:formatJackpotMeter(jackpotNum))
                bole.shrinkLabel(jpLabels[i], jpLabels[i].maxWidth, jpLabels[i].baseScale)
            end
        end
    end
end
function bonusGame:enterBonusGame(tryResume)

    self.theme:saveBonusData()
    self.theme:enableMapInfoBtn(false)
    self.ctl.footer:setSpinButtonState(true)-- 禁掉spin按钮
    self.ctl.footer:enableOtherBtns(false)
    if tryResume then
        self.callback = function(...)
            -- 断线重连回调方法
            local endCallFunc2 = function(...)
                if self.ctl:noFeatureLeft() then
                    self.ctl.footer:setSpinButtonState(false)
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
    if self.data.core_data.map_win then
        self.theme:showStoreNode(true)
    else
        self:initProgressBonusGame()
        if self.ctl.footer then
            self.ctl.footer:hideActivitysNode()
        end
        self:showJackPotDialog(tryResume)
    end
end

function bonusGame:showJackPotDialog()

    local theData = {}

    theData.coins = self.bonusWin
    theData.type = 2
    theData.jackpot = self.data.core_data.jp_win[1].jp_win_type + 1

    theData.enter_event = function()
        self.ctl.footer:onEnterFreeSpinDialog() -- 控制 footer 的 按钮不可点击
        self.theme:dealMusic_FadeLoopMusic(0.3, 1, 0.1)
        --AudioControl:stopGroupAudio("music")
        self.theme:dealMusic_PlayBonusCollectMusic()
        self.theme:playMusic(self.theme.audio_list["jackpot_" .. theData.jackpot])

    end
    theData.click_event = function()
        self.theme:playMusic(self.theme.audio_list.btn_click)
        self.theme.isGetJackPot = false
        self.ctl:collectCoins(1)
        self.theme:stopJackPotReelNotify()
    end
    theData.end_event = function()
        self:finishBonusGame()
    end

    self.theme:showJackPotDialog(theData, fs_show_type.collect)
end
function bonusGame:finishBonusGame()
    self:recoverBaseGame()
    self.theme.reelRoot:runAction(cc.ScaleTo:create(0.5, 1))
    self.data["end_game"] = true
    self.theme.bonus = nil
    local bonusOver2 = function()
        if self.callback then
            self.callback()
        end
        if self.ctl:noFeatureLeft() then
            self.theme:enableMapInfoBtn(true)
        end
    end

    self.ctl:startRollup(self.bonusWin, bonusOver2)

end
function bonusGame:recoverBaseGame()
    self.theme.themeAnimateKuang:removeAllChildren()
    self.theme:showAllItem()
    self.ctl.spinning = false
    if self.ctl.freewin then
        -- 切换滚轴回 free
        --self.theme:hideBonusNode(true, false)
        self.theme:stopDrawAnimate()
        --self.theme:changeSpinBoard(SpinBoardType.FreeSpin)
        self.ctl:adjustWithFreeSpin()
        self.ctl.footer.isFreeSpin = true
    else
        if self.theme.superAvgBet then
            self.ctl.footer:changeNormalLayout2()
        else
            self.ctl.footer:changeNormalLayout()
        end
        --self.theme:changeSpinBoard(SpinBoardType.Normal)
        -- 切换滚轴回 base
        --self.theme:hideBonusNode(false, false)
        self.ctl.footer.isFreeSpin = false
    end
    self.theme:outBonusStage()
    if self.theme.showSpinBoard == SpinBoardType.FreeSpin or self.ctl.freewin then
        self.ctl.footer:changeLabelDescription("FS_Win")
        if not self.theme.superAvgBet then
            if self.ctl.footer then
                self.ctl.footer:showActivitysNode()
            end
        end
    else
        self.ctl.footer.isFreeSpin = false
        self.ctl.footer:changeLabelDescription("notFS_Win")
        self.saveWin = false
        if self.ctl.footer then
            self.ctl.footer:showActivitysNode()
        end

    end

    self.theme.bonusflyNode:removeAllChildren()
    self.theme:lockJackpotMeters(false)

    self.theme.lockedReels = nil
    -- 播放背景音乐
    self.theme:dealMusic_ExitBonusGame()
    self.theme.bonus = nil

    if self.ctl:noFeatureLeft() then
        self.theme.superAvgBet = nil
        self.ctl:removePointBet()
    else
        self.theme.remainPointBet = true
    end
end

function cls:enterPickGame(ret, theGameData, endCallfunc, tryResume)

    if self.ctl.footer then
        self.ctl.footer:hideActivitysNode()
    end
    local endCallfunc_old = endCallfunc
    endCallfunc = function()
        -- 添加字段，用来进入free spins
        ret["free_spins"] = self.freeCount
        -- 激活spin按钮
        if endCallfunc_old then
            endCallfunc_old()

        end

    end
    if tryResume then
        self:changeSpinBoard(SpinBoardType.Pick)
        self:showFreeBoardAction()
        self:enterChoosePage(ret, theGameData, endCallfunc)
    else
        self:playFreeSpinItemAnimation_1(self.ctl.specials, "free_game")
        self:runAction(cc.Sequence:create(
                cc.DelayTime:create(2.2),
                cc.CallFunc:create(function(...)
                    self:playTransition(nil, "free")
                end),
                cc.DelayTime:create(transitionDelay.free.onCover),
                cc.CallFunc:create(function(...)
                    self:changeSpinBoard(SpinBoardType.Pick)
                    self:showFreeBoardAction()
                end),
                cc.DelayTime:create(transitionDelay.free.onEnd - transitionDelay.free.onCover),
                cc.CallFunc:create(function(...)
                    self:enterChoosePage(ret, theGameData, endCallfunc)
                end)
        ))
    end

end
function cls:showFreeBoardAction()
    local freespins = self.freeCount or 10
    self.ctl.footer:setFreeSpinLabel(freespins, freespins)
    if self.superAvgBet then
        self:changeBg(SpinBoardType.SuperFree)
        self.ctl:setPointBet(self.superAvgBet)
        self.ctl.footer:changeFreeSpinLayout3()
    else
        self:changeBg(SpinBoardType.FreeSpin)
        self.ctl:setPointBet(self.ctl:getCurBet())
        self.ctl.footer:changeFreeSpinLayout()


    end
end
function cls:enterChoosePage(ret, theGameData, endCallfunc)
    local data = {}
    local endCallfunc_old = endCallfunc
    data.click_event = function()
        ret["free_spins"] = self.freeCount
        -- 激活spin按钮
        --self.ctl.footer:setSpinButtonState(false)
        self:updateChooseBoard()
        self:laterCallBack(2.3, function()
            if endCallfunc_old then
                endCallfunc_old()
            end

        end)
    end

    data.enter_event = function()
        self.ctl.footer:onEnterFreeSpinDialog() -- footer 显示 freespin 按钮
        self:dealMusic_PlayFSEnterMusic2()
    end
    data.count = self.freeCount or ret["free_game"].free_spins
    data.type = 3
    self.ctl.footer:setSpinButtonState(true)
    self:showChooseDialog(data)

    self:initChooseBoard(1)
end
function cls:getFreeCount()
    local count = 0
    if self.trigger_item_list then
        for i = 1, 5 do
            for j = 1, 3 do
                if self.trigger_item_list[i][j] == specialSymbol.trigger then
                    count = count + 1
                end
            end
        end
    end
    local freeList = { [6] = 10, [7] = 11, [8] = 12, [9] = 15, [10] = 20, [11] = 30, [12] = 40 }
    if freeList[count] then
        return freeList[count]
    else
        return freeList[12]
    end

end
---@desc 初始化free界面
function cls:initFreeBoardBgs()


    local boardBgs = self.freeBoardNode:getChildren()
    for boardIndex, temp in pairs(boardBgs) do
        local endPos = freeConfig[2].pos[boardIndex]
        temp:setPosition(endPos)
        temp:setScale(freeConfig[2].scale)

    end
end
---@desc 初始化选择界面
function cls:initChooseBoard()
    local boardBgs = self.freeBoardNode:getChildren()
    local cmConfig = freeConfig[1]
    for boardIndex, temp in pairs(boardBgs) do
        temp:setPosition(cmConfig.pos[boardIndex])
        temp:setScale(cmConfig.scale)

        local bg = temp:getChildByName("bg")
        bg:setVisible(true)
        bole.updateSpriteWithFile(bg, "#theme174_free_room" .. boardIndex .. ".png")

        local kuang_normal = temp:getChildByName("kuang_normal")
        local normal_free_1 = kuang_normal:getChildByName("free_1")
        local normal_free_2 = kuang_normal:getChildByName("free_2")
        kuang_normal:setVisible(true)
        normal_free_1:setVisible(true)
        normal_free_2:setVisible(false)

        local img_name = normal_free_1:getChildByName("img_name")
        img_name:setVisible(true)
        bole.updateSpriteWithFile(img_name, "#theme174_name_" .. boardIndex .. ".png")

        local kuang_chosen = temp:getChildByName("kuang_chosen")
        local collect_node = temp:getChildByName("collect_node")
        local chosen = temp:getChildByName("chosen")

        kuang_chosen:setVisible(false)
        chosen:setVisible(false)
        collect_node:setVisible(false)
        local spine_behind = temp:getChildByName("spine_behind")
        spine_behind:removeAllChildren()
        local _, s1 = bole.addSpineAnimation(self.freeBoardBgNode, nil, self:getPic(SpineConfig.free_bg), bole.getPos(temp), "animation", nil, nil, nil, true, true)-- 出现
        s1:setScale(cmConfig.scale)
        local spine_forward = temp:getChildByName("spine_forward")

        spine_forward:removeAllChildren()
        local _, s1 = bole.addSpineAnimation(spine_forward, nil, self:getPic(SpineConfig.free_kuang), cc.p(0, 0), "animation", nil, nil, nil, true, true)-- 出现

    end

    local a1 = cc.RepeatForever:create(
            cc.Sequence:create(
                    cc.DelayTime:create(2),
                    cc.CallFunc:create(
                            function()
                                self:showChooseDracula(0)
                            end
                    )

            )
    )
    self.freeBoardNode:runAction(a1)

end
function cls:showChooseDracula(boardIndex, isFinish)

    if boardIndex == 0 then
        boardIndex = math.random(1, 4)
        if self.lastAppearDracula and self.lastAppearDracula == boardIndex then
            boardIndex = (self.lastAppearDracula + 1) % 4 + 1
        end
        self.lastAppearDracula = boardIndex
    end
    local side = math.random(1, 2)
    local dir = 1
    if side % 2 == 0 then
        dir = -1
    end
    local boardBgs = self.freeBoardNode:getChildren()
    local myBoard = boardBgs[boardIndex]
    local freeLeanOut = myBoard:getChildByName("free_lean_out")
    local freeLeanHand = myBoard:getChildByName("free_lean_hand")
    local _, s1 = bole.addSpineAnimation(freeLeanHand, nil, self:getPic(SpineConfig.free_lean_out), cc.p(0, 0), "animation1")
    local _, s2 = bole.addSpineAnimation(freeLeanOut, nil, self:getPic(SpineConfig.free_lean_out), cc.p(0, 0), "animation2")
    s2:setScale(1.25)
    s1:setScale(1.25)
    freeLeanOut:setScaleX(dir)
    freeLeanHand:setScaleX(dir)
    if isFinish then
        self:playMusic(self.audio_list.choose_right)
    end

end
---@desc 已选完界面
function cls:updateChooseBoard()

    self.freeBoardNode:stopAllActions()
    local boardBgs = self.freeBoardNode:getChildren()
    self.lastAppearDracula = nil
    for boardIndex, temp in pairs(boardBgs) do

        local bg = temp:getChildByName("bg")
        local kuang_normal = temp:getChildByName("kuang_normal")

        local normal_free_1 = kuang_normal:getChildByName("free_1")
        local normal_free_2 = kuang_normal:getChildByName("free_2")
        local img_name = normal_free_1:getChildByName("img_name")
        img_name:setVisible(false)

        local kuang_chosen = temp:getChildByName("kuang_chosen")
        local chosen_free_1 = kuang_chosen:getChildByName("free_1")
        local chosen_free_2 = kuang_chosen:getChildByName("free_2")

        local chosen = temp:getChildByName("chosen")
        local spine_forward = temp:getChildByName("spine_forward")
        --local spine_behind = temp:getChildByName("spine_behind")
        --spine_behind:removeAllChildren()
        self.freeBoardBgNode:removeAllChildren()
        if self.boardType == boardIndex then
            local _, s1 = bole.addSpineAnimation(spine_forward, nil, self:getPic(SpineConfig.free_chosen), cc.p(0, 0), "animation")
            self:laterCallBack(2 / 30, function()
                kuang_normal:setVisible(false)
                kuang_chosen:setVisible(true)
                chosen_free_1:setVisible(true)
                chosen_free_2:setVisible(false)
                chosen:setVisible(true)
                if boardIndex % 2 == 0 then
                    chosen:setScaleX(-1)
                    local choose_img = chosen:getChildByName("choose_img")
                    choose_img:setScaleX(-1)
                end
            end)
        else
            spine_forward:removeAllChildren()
        end

        local endPos = freeConfig[2].pos[boardIndex]
        local a1 = cc.MoveTo:create(0.5, endPos)
        local a2 = cc.ScaleTo:create(0.5, 1)
        local b1 = cc.Spawn:create(a1, a2)
        temp:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(1),
                        b1,
                        cc.DelayTime:create(0.5),
                        cc.CallFunc:create(
                                function()
                                    self:showChooseBoard(boardIndex, nil, true)
                                    self:refreshFreeWinInfo()
                                end
                        )
                --cc.DelayTime:create()
                )
        )

    end
end

---@desc 选择完的界面移动到屏幕中间
function cls:showChooseBoard(boardIndex, maxIndex, bgAni)

    local temp = self.freeWinNodeList[boardIndex][3]
    local spine_forward = temp:getChildByName("spine_forward")
    spine_forward:removeAllChildren()
    local kuang_chosen = temp:getChildByName("kuang_chosen")
    local chosen_free_1 = kuang_chosen:getChildByName("free_1")
    local chosen_free_2 = kuang_chosen:getChildByName("free_2")

    local kuang_normal = temp:getChildByName("kuang_normal")
    local normal_free_1 = kuang_normal:getChildByName("free_1")
    local normal_free_2 = kuang_normal:getChildByName("free_2")
    local collect_node = temp:getChildByName("collect_node")
    collect_node:setVisible(true)

    self.reelFreeBGNode:setVisible(true)
    local chosen = temp:getChildByName("chosen")
    local bg = temp:getChildByName("bg")
    if bgAni then
        local _, s1 = bole.addSpineAnimation(spine_forward, nil, self:getPic(SpineConfig.free_change), cc.p(0, 0), "animation")
        bg:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(5 / 30),
                        cc.FadeOut:create(0.5),
                        cc.CallFunc:create(
                                function()
                                    bg:setOpacity(255)
                                    bg:setVisible(false)
                                end)
                )
        )
    else
        bg:setVisible(false)
    end

    if self.boardType == boardIndex or (maxIndex and self.boardType == maxIndex) then
        kuang_chosen:setVisible(true)
        chosen_free_1:setVisible(false)
        chosen_free_2:setVisible(true)
        kuang_normal:setVisible(false)
        local choose_spine = kuang_chosen:getChildByName("choose_spine")
        if not choose_spine.spine then
            local _, s1 = bole.addSpineAnimation(choose_spine, nil, self:getPic(SpineConfig.free_hit), cc.p(0, 0), "animation", nil, nil, nil, true, true)
            choose_spine.spine = s1
        end


    else
        kuang_normal:setVisible(true)
        kuang_chosen:setVisible(false)
        normal_free_1:setVisible(false)
        normal_free_2:setVisible(true)
        chosen:setVisible(false)
    end
    if self.boardType == boardIndex then
        chosen:setVisible(true)

        if boardIndex % 2 == 0 then
            chosen:setScaleX(-1)
            local choose_img = chosen:getChildByName("choose_img")
            choose_img:setScaleX(-1)
        end
    else
        chosen:setVisible(false)
    end

end

DraculaDialog = class("DraculaDialog", CCSNode)
local MDialog = DraculaDialog
--local pageImgConfig = {
--    build = "#theme166_store_p1_jianzhu%s.png",
--    woman = "#theme166_store_p1_nv%s.png",
--    product = "#theme166_store_p1_wu%s.png"
--}
function MDialog:ctor(pThemeCtr, pConfig)
    self.themeCtr = pThemeCtr
    self.theme = pThemeCtr.theme
    self.genPath = pConfig["gen_path"]
    self.csb = pConfig["csb_file"]
    self.frameConfig = pConfig["frame_config"]
    self.sharePos = pConfig["share_pos"]
    self.sceneSize = bole.getSceneSize()
    self.centerPos = cc.p(self.sceneSize.width / 2, self.sceneSize.height / 2)
    CCSNode.ctor(self, self.csb)
end
function MDialog:loadControls()
    self.root = self.node:getChildByName("root")
    self.baseRoot = self.root:getChildByName("node_base")
    self.startRoot = self.root:getChildByName("node_start")
    if self.startRoot then
        self.startRoot.btnBoard1 = self.startRoot:getChildByName("btn_1")
        self.startRoot.btnBoard2 = self.startRoot:getChildByName("btn_2")
        self.startRoot.btnBoard3 = self.startRoot:getChildByName("btn_3")
        self.startRoot.btnBoard4 = self.startRoot:getChildByName("btn_4")
        self.startRoot.labelCount = bole.deepFind(self.startRoot, "label_count")
    end
    --for key, keyname in ipairs(self.childNameList) do
    --    local valueNode = self.startRoot:getChildByName(keyname)
    --    valueNode:setVisible(false)
    --end

end
function MDialog:showStart(pFsData, pEndCallFunc, parent)

    self.fsData = pFsData
    self.endCallFunc = pEndCallFunc
    self.curFrameConfig = self.frameConfig["start"]
    local initEventFunc = function()
        self:initStartEvent()
    end
    local intLayoutFunc = function()
        self:initStartLayout()
    end

    self:show(initEventFunc, intLayoutFunc, parent)
end
function MDialog:initStartEvent()
    self.isClick = false

    for i = 1, 4 do
        if self.startRoot["btnBoard" .. i] then
            local function btnEvent(sender, eventType)
                if eventType == ccui.TouchEventType.ended then
                    self:clickBoard(sender)
                end
            end
            self.startRoot["btnBoard" .. i].boardIndex = i
            self.startRoot["btnBoard" .. i]:addTouchEventListener(btnEvent)
        end
    end
end
function MDialog:clickBoard(sender)
    if self.isClick then
        return
    end

    self.isClick = true
    self.theme:playMusic(self.theme.audio_list.btn_click)
    self.theme:setBoardType(sender.boardIndex)
    if self.fsData["click_event"] then
        self.fsData["click_event"]()
    end
    self:hide()
end
function MDialog:initStartLayout()
    self.startRoot:setVisible(true)
    if self.baseRoot then
        self.baseRoot:setVisible(true)
    end
    if self.startRoot.labelCount then
        self.startRoot.labelCount:setString(self.fsData["count"])
    end

end
function MDialog:show(initEventFunc, intLayoutFunc, parent)

    if parent then
        parent:addChild(self, -1)
    else
        self.themeCtr.curScene:addToContentFooter(self)
    end
    self.node:setVisible(false)
    self:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(0.1),
                    cc.CallFunc:create(function()
                        self.node:setVisible(true)
                        if self.fsData["enter_event"] then
                            self.fsData["enter_event"]()
                        end
                        local action = cc.CSLoader:createTimeline(self.csb)
                        self.node:runAction(action)
                        action:gotoFrameAndPlay(self.curFrameConfig[1][1], self.curFrameConfig[1][2], false)
                    end
                    ),
                    cc.DelayTime:create(self.curFrameConfig[2]),
                    cc.CallFunc:create(function()
                        if initEventFunc then
                            initEventFunc()
                        end
                    end)
            )
    )
    if intLayoutFunc then
        intLayoutFunc()
    end
end
function MDialog:hide()
    local action = cc.CSLoader:createTimeline(self.csb)
    self.node:runAction(action)
    self:runAction(cc.Sequence:create(
            cc.DelayTime:create(0.1),
            cc.CallFunc:create(function()
                action:gotoFrameAndPlay(self.curFrameConfig[3][1], self.curFrameConfig[3][2], false)
            end),
            cc.DelayTime:create(self.curFrameConfig[4] or 0),
            cc.CallFunc:create(function()
                --self.theme:onCollectFreeClick()
            end),
            cc.DelayTime:create(self.curFrameConfig[5] or 0),
            cc.CallFunc:create(function()
                if self.fsData["changeLayer_event"] then
                    self.fsData["changeLayer_event"]()
                end
            end),
            cc.DelayTime:create(self.curFrameConfig[6] or 0),
            cc.CallFunc:create(function()
                if self.endCallFunc then
                    self.endCallFunc()
                end
                if self.fsData["end_event"] then
                    self.fsData["end_event"]()
                end
            end),
            cc.DelayTime:create(self.curFrameConfig[7] or 0),
            cc.RemoveSelf:create()))
end
return ThemeDracula
