---@program src
---@description:  theme 186 埃及艳后
---@author: rwb  art:wushuping,math:dingyifeng,other:wangjinying+shanjingru
---@create: 2020/03/26 16:14
local ThemeCleopatra = class("ThemeCleopatra", Theme)
local cls = ThemeCleopatra
-- 资源异步加载相关
cls.plistAnimate = {
    "image/plist/symbol",
    "image/plist/map",
    "image/plist/dialog",
}
cls.csbList = {
    "csb/base_game.csb",
}
local allCsbList = {
    ["base"] = "csb/base_game.csb",
    ["map"] = "csb/map.csb",
    ["wheel"] = "csb/wheel.csb",
    ["free_node"] = "csb/free_node_%s.csb",
    ["free_dialog"] = "csb/dialog_free_%s.csb"
}
local transitionDelay = {
    ["free"] = { ["onCover"] = 40 / 30, ["onEnd"] = 60 / 30 },
    ["bonus"] = { ["onCover"] = 40 / 30, ["onEnd"] = 60 / 30 },
    ["bonus1"] = { ["onCover"] = 34 / 30, ["onEnd"] = 66 / 30 },
    ["map"] = { ["onCover"] = 38 / 30, ["onEnd"] = 45 / 30 },

}
local wildMulti = {
    [21] = 2, [22] = 3, [23] = 4, [24] = 5, [25] = 7, [26] = 10
}
local SpinBoardType = {
    Normal = 1,
    FreeSpin = 2,
    MapFree = 3, -- superBonus
    Bonus = 4,
}
local FreeBoardType = {
    Prize = 1,
    Wilds = 2,
    Spins = 3,
    Wins = 4, -- superBonus

}
local WheelBoardType = {
    JackPot = 1,
    FreeSpin = 2
}
local MapFreeType = {
    FreeSpin = 0,
    NoFeature = 1,
    StickyWilds = 2,
    MultiplerWilds = 3,
    RandomWilds = 4,
    RemoveSymbol = 5,
    ExpandingWild = 6,
    MultiAndRemove = 7,
    MultiAndRandom = 8,
    StickyAndExpand = 9
    --[3+5] = 7,
    --[3+4] = 8,
    --[2+6] = 9,

}
local specialSymbol = {
    ["trigger"] = 13, -- 触发free game
    ["bonus"] = 12, --触发feature
    ["wild"] = 1, --触发feature animation1 出现 animation2 循环 animation3 idle
    ["wild2"] = 14, --触发feature
}
local fs_show_type = {
    start = 1,
    more = 2,
    collect = 3,
    nocollect = 4
}
local BlackUint = {
    width = 54,
    height = 54
}
local FreeSpinType = {
    NormalFree = 1,
    MapFree = 2
}
local miniGameReel = {
    { 7, 4, 2, 1, 6, 5, 3 }, -- jackpot ,6是MINOR带五倍,7是MINI带2倍
    { 1, 2, 3, 4, 2 }, -- free
}

local SpineConfig = {
    ----------------------------base-------------------------------
    jili_free = "spine/base/jili/lzjl_01", -- 触发free激励
    jili_appear = "spine/free/yshsfs_01",

    kuang = "spine/base/kuang/spine",
    trans_free = "spine/base/transition1/qieping",
    trans_bonus = "spine/base/transition2/sajinbi",
    trans_bonus1 = "spine/base/transition2/bouns_qp_01",
    trans_map = "spine/base/transition3/jzt_01",
    base_logo = "spine/base/logo/renwu",
    logo_label = "spine/base/logo/logo_lg_01",
    ----------------------------collect----------------------------
    collect_tower = "spine/base/collection/sdrk_jzt_01", -- 进度条上锁
    collect_lock = "spine/base/collection/sdrk_jzt_02", -- 进度条上锁
    collect_fly = "spine/base/collection/jzt_fx_01",
    collect_item = "spine/base/collection/jinzitajieshou",
    collect_touch = "spine/base/collection/sdrk_jzt_03",
    collect_idle = "spine/base/collection/sdrk_jzt_04",
    ----------------------------top----------------------------
    fly_coins = "spine/bonus/wild_01_1",
    fly_coins_receive = "spine/bonus/wild_01_2",
    coins_idle = "spine/bonus/jinbidui_01",
    coins_receive = "spine/bonus/jinbidui_02",
    coins_full = "spine/bonus/jinbidui_03",
    ---------------------------jackpot--------------------------------
    jackpot_1 = "spine/base/jackpot/huang_01",
    jackpot_2 = "spine/base/jackpot/hong_01",
    jackpot_3 = "spine/base/jackpot/zi_01",
    jackpot_4 = "spine/base/jackpot/lanse_01",
    jackpot_5 = "spine/base/jackpot/lvse_01",
    ---------------------------free--------------------------------------
    --free_kuang = "spine/free/kuang",
    free_beetle = "spine/free/jiachong", -- animation1 循环 animation2 点击 animation3 消失
    free_index_muti = "spine/free/beishuxunhuan",
    free_wilds_add = "spine/free/7wilds/wild_xl_01",
    free_item = "spine/free/gezixuanzhong",
    free_wild_fly = "spine/free/7wilds/wildfei",
    ---------------------------map--------------------------------------
    map_title = "spine/map/biaoti",
    map_tip = "spine/map/lvkuang",
    ---------------------------map free----------------------------------
    map_wild_copy = "spine/item/1_wild/wild_01_3",
    --------------------------- wheel------------------------------------
    wheel_start = "spine/wheel/press_01",
    wheel_stop = "spine/wheel/zjh_xz_01",
    wheel_start_light = "spine/wheel/zzq_01",

    -----------------------------dialog----------------------------
    ---@ dialog2 free game
    dialog1_btn = "spine/dialog/pop_free/anniu",
    dialog1_title = "spine/dialog/pop_map/superbiaoti",
    dialog1_winner = "spine/dialog/pop_free/wintterjieshou",
    dialog1_start_frame = "spine/dialog/pop_free/waikuang", -- new add
    ---@ dialog2 jackpot
    dialog2_title = "spine/dialog/pop_jackpot/5jpbiaoti",
    ---@ dialog3
    dialog1_label = "spine/dialog/pop_map/supershuzikuang",
    ---@ dialog4
    dialog5_add_wild = "spine/dialog/add_wild/kuosanlizi",
    ---------------------------lizi--------------------------

    --normal_lizi_1 = "particles/186hong.plist",
    --normal_lizi_2 = "particles/186zi.plist",
    --normal_lizi_3 = "particles/186lan.plist",
    --normal_lizi_4 = "particles/186lv.plist",
    multi_fly_footer = "particles/186lizi_1.plist",

    collect_lizi = "particles/gz_tw_01_1.plist",
    collect_free_1 = "particles/186jinhuang.plist",

}

local SpineDialogConfig = {
    --[1] = "free_games",
    [1] = {--start
        [3] = { --collect
            node_1 = { name = SpineConfig.dialog1_title, showimg = true, parent = true },
            spine = { name = SpineConfig.dialog1_label, showimg = true, parent = true },
            btn = { name = SpineConfig.dialog1_btn },
            maxWidth = 544,
        }
    },
    --[2] = "jackpot",
    [2] = {--start
        [0] = {
            bg1 = { isImg = true, name = "#theme186_d_bg1_%s.png", parent = true, showimg = true },
            bg2 = { isImg = true, name = "#theme186_d_bg1_%s.png", parent = true, showimg = true },
        },
        [3] = {
            title = { isImg = true, name = "#theme186_d_text_jp%s.png", parent = true, showimg = true },
            label_1 = { isImg = true, name = "#theme186_d_bg3_%s.png", parent = true, showimg = true },
            label_2 = { isImg = true, name = "#theme186_d_bg3_%s.png", parent = true, showimg = true },
            btn = { name = SpineConfig.dialog1_btn },
            maxWidth = 500,
        },
    },
    [3] = {--winner
        [0] = {
        },
        [3] = {
            spine = { name = SpineConfig.dialog1_winner, showimg = true, parent = true },
            btn = { name = SpineConfig.dialog1_btn },
            bg = { isImg = true, name = "#theme186_d_bg2_%s.png", parent = true, showimg = true },
            title = { isImg = true, name = "#theme186_d_text_win%s.png", parent = true, showimg = true },
            maxWidth = 470,
        },
    },
    [4] = {-- last spin
        [0] = {
        },
        [1] = {
            bg = { isImg = true, name = "#theme186_d_bg4_%s.png", parent = true, showimg = true },
        },
    },

}
local NormalFreeConfig = {
    [1] = {
        --prize
        img_spin_index = { type = "img", res = "#theme186_th_spin%s.png" },
        img_mask = { type = "img" },
        font_1 = { type = "fnt", maxWidth = 211, maxCount = 4, baseScale = 1 },
        color = 4 -- green

    },
    [2] = {
        --wild
        img_spin_index = { type = "img", res = "#theme186_th_spin%s.png" },
        img_mask = { type = "img" },
        color = 2 --pupple
    },
    [3] = {
        --spins
        index = { type = "img", res = "#theme186_free_text_muti_%s.png", maxShow = 3 },
        index1 = { type = "spine", res = SpineConfig.free_index_muti, maxShow = 3, pos = cc.p(0, 10) },
        img_spin_index = { type = "img", res = "#theme186_th_spin%s.png" },
        img_mask = { type = "img" },
        color = 3, --blue

    },
    [4] = {
        --wins
        index = { type = "img", res = "#theme186_free_text_muti_%s.png", maxShow = 6 },
        index1 = { type = "spine", res = SpineConfig.free_index_muti, maxShow = 6, pos = cc.p(0, 10) },
        img_spin_index = { type = "img", res = "#theme186_th_win%s.png" },
        img_mask = { type = "img" },
        color = 1, --red


    }
}
local LineMutliConfig = {
    [1] = { 1, 2, 3, 4, 5, 6, 7 },
    [2] = { 7, 14, 21, 28, 35, 42, 49 },

}
local mapFreeConfig = {
    [0] = {
        --[1] = { name = "#theme186_map_text_1_1.png" }, -- 没有点击
        [2] = {
            min = 3,
            max = 50,
            fontMaxWidth = 120,
            fontBaseScale = 0.6,
            chosenMaxWidth = 150,
            chosenScale = 1
        }, -- 点击之后
    },
    [1] = {
        -- no feature
        [1] = { name = "#theme186_map_text_1.png" }, -- 没有点击
        [2] = {
            name = "#theme186_map_text_1_1.png",
            chooseList = nil,
            tip = "#theme186_map_desc_1.png",
            min = nil,
            max = nil,
            fontMaxWidth = 120,
            fontBaseScale = 0.5,
            chosenMaxWidth = 150,
            chosenScale = 0.6,
            mapFreeFnt = "font/186_font3.fnt",
            mapFreeRes = "#theme186_mapfree_1.png",
            mapKey = "free_spin_total",
        }, -- 点击之后
    },
    [2] = {
        -- sticky wilds
        [1] = { name = "#theme186_map_text_2.png" }, -- 没有点击
        [2] = {
            name = "#theme186_map_text_2_1.png",
            chooseList = {
                1, 2, 3, 4, 5
            },
            tip = "#theme186_map_desc_2.png",
            min = 1,
            max = 5,
            fontMaxWidth = 120,
            fontBaseScale = 0.5,
            chosenMaxWidth = 150,
            chosenScale = 0.6,
            mapFreeRes = "#theme186_mapfree_2.png",
            mapKey = "wild_pos_list",
        }, -- 点击之后
    },
    [3] = {
        --multipler wilds
        [1] = { name = "#theme186_map_text_3.png" }, -- 没有点击
        [2] = {
            name = "#theme186_map_text_3_1.png",
            chooseList = {
                "2X-5X", "3X-7X", "4X-10X",
            },
            tip = "#theme186_map_desc_3.png",
            min = 1,
            max = 3,
            fontMaxWidth = 120,
            fontBaseScale = 0.5,
            chosenMaxWidth = 150,
            chosenScale = 0.6,
            mapFreeRes = "#theme186_mapfree_3.png",
            mapFreeFnt = "font/186_font1.fnt",
            mapKey = "wild_multi_list",
        }, -- 点击之后
    },
    [4] = {
        --random wilds
        [1] = { name = "#theme186_map_text_4.png" }, -- 没有点击
        [2] = {
            name = "#theme186_map_text_4_1.png",
            chooseList = {
                1, 2, 3, 4, 5
            },
            tip = "#theme186_map_desc_4.png",
            min = 1,
            max = 5,
            fontMaxWidth = 120,
            fontBaseScale = 0.5,
            chosenMaxWidth = 150,
            chosenScale = 0.6,
            mapFreeRes = "#theme186_mapfree_4.png",
            mapKey = "random_wild_count",
        }, -- 点击之后
    },
    -- remove symbol
    [5] = {
        [1] = { name = "#theme186_map_text_5.png" }, -- 没有点击
        [2] = {
            name = "#theme186_map_text_5_1.png",
            chooseList = {
                { 11 }, { 10, 11 }, { 9, 10, 11 }, { 8, 9, 10, 11 }, { 7, 8, 9, 10, 11 }
            },
            chooseType = "img",
            chooseRes = "#theme_s_%s.png",
            tip = "#theme186_map_desc_5.png",
            min = 1,
            max = 5,
            fontMaxWidth = 120,
            fontBaseScale = 0.5,
            chosenMaxWidth = 150,
            chosenScale = 0.6,
            mapFreeRes = "#theme186_mapfree_5.png",
            mapKey = "disappear_symbol_list",
        }, -- 点击之后
    },
    [6] = {
        --expanding wild
        [1] = { name = "#theme186_map_text_6.png" }, -- 没有点击
        [2] = {
            name = "#theme186_map_text_6_1.png",
            chooseList = {
                "5", "4,5", "3,4,5",
            },
            --chooseType = "fnt",
            --chooseRes = "font/186_font1.fnt",
            chooseDesc = { "#theme186_map_desc_reel.png", "#theme186_map_desc_reels.png" },
            tip = "#theme186_map_desc_6.png",
            min = 1,
            max = 3,
            fontMaxWidth = 120,
            fontBaseScale = 0.5,
            chosenMaxWidth = 150,
            chosenScale = 0.6,
            mapFreeRes = "#theme186_mapfree_6.png",
            mapKey = "expanding_wild"
        }, -- 点击之后
    },
    [7] = { 3, 5 },
    [8] = { 3, 4 },
    [9] = { 2, 6 }

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
        borderConfig[idx]["colReelCnt"] = self.commonConfig.colCnt
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

local G_cellHeight = 81
local G_cellWidth = 123
local G_cellRow = 4
local G_cellCol = 5

-- local delay = 0
-- local upBounce = 0
-- local upBounceMaxSpeed = 6 * 60
-- local upBounceTime = 0
-- local speedUpTime = 12 / 60
-- local rotateTime = 5 / 60
-- local maxSpeed = -40 * 60
-- local normalSpeed = -40 * 60
-- local fastSpeed = -40 * 60 - 300

-- local stopDelay = 20 / 60
-- local speedDownTime = 30 / 60
-- local downBounce = G_cellHeight * 2 / 3
-- local downBounceMaxSpeed = 6 * 60
-- local downBounceTime = 15 / 60
-- --local specialAniTime = 160 / 60
-- local extraReelTime = 120 / 60
-- local spinMinCD = 0.5
-- --local shakeDistance = 30

local delay = 0
local upBounce = G_cellHeight * 2 / 3 --G_cellHeight*2/3
local upBounceMaxSpeed = 6 * 60
local upBounceTime = 0
local speedUpTime = 5 / 60
local rotateTime = 5 / 60
local maxSpeed = -30 * 60
local normalSpeed = -30 * 60
local fastSpeed = -30 * 60

local stopDelay = 10 / 60
local speedDownTime = 30 / 60
local downBounce = G_cellHeight * 2 / 3
local downBounceMaxSpeed = 6 * 60
local downBounceTime = 15 / 60
local extraReelTime = 120 / 60
local spinMinCD = 0

-- whj 修改速度
-- local stopDelay = 25/60    -- auto  -10
local speedDownTime = 45 / 60
local downBounce = G_cellHeight*1/5  -- auto  不变
local downBounceTime = 15/60  -- auto  -5
local stopDelayList = {
    [1] = 15/60,
    [2] = 15/60,
    [3] = 15/60,
}
local autoStopDelayMult = 2/3
local autoDownBounceTimeMult = 1
local checkStopColCnt = 5
-- end

local bonusFlyTm = 0.4

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
        ["rowReelCnt"] = 4,
        ["cellWidth"] = G_cellWidth,
        ["cellHeight"] = G_cellHeight,
    }
    self.ThemeConfig = {
        ["theme_symbol_coinfig"] = {
            ["symbol_zorder_list"] = {
                [specialSymbol.trigger] = 300,
                [specialSymbol.bonus] = 300,
            },
            ["normal_symbol_list"] = {
                1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
            },
            ["no_roll_symbol_list"] = {
                --LongSymbol.l1, LongSymbol.l2, LongSymbol.l3
            },
            ["special_symbol_list"] = {
                specialSymbol.trigger,
                specialSymbol.bonus,
                specialSymbol.wild2,

            },
            ["special_symbol_config"] = {
                [specialSymbol.trigger] = {
                    ["min_cnt"] = 3,
                    ["type"] = G_THEME_SYMBOL_TYPE.NUMBER,
                    ["col_set"] = {
                        [1] = 1,
                        [2] = 0, -- 1代表限制最多同时出现1个
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
                { 0, 0, 0, 0, 0 }, { 0, 1, 1, 1, 0 }, { 0, 1, 1, 1, 2 }, { 0, 1, 2, 1, 0 }, { 0, 1, 0, 1, 0 }, { 0, 0, 1, 0, 0 }, { 0, 0, 1, 2, 2 }, { 1, 1, 1, 1, 1 }, { 1, 0, 0, 0, 1 }, { 1, 0, 1, 0, 1 },
                { 1, 1, 0, 1, 1 }, { 1, 1, 2, 1, 1 }, { 1, 2, 1, 2, 1 }, { 1, 2, 2, 2, 1 }, { 1, 2, 3, 2, 1 }, { 1, 1, 2, 3, 3 }, { 1, 2, 1, 0, 1 }, { 1, 2, 2, 2, 3 }, { 1, 0, 1, 2, 1 }, { 1, 0, 1, 2, 3 },
                { 2, 2, 2, 2, 2 }, { 2, 3, 3, 3, 2 }, { 2, 3, 2, 3, 2 }, { 2, 2, 3, 2, 2 }, { 2, 2, 1, 2, 2 }, { 2, 1, 2, 1, 2 }, { 2, 1, 1, 1, 2 }, { 2, 1, 0, 1, 2 }, { 2, 2, 1, 0, 0 }, { 2, 1, 2, 3, 2 },
                { 2, 1, 1, 1, 0 }, { 2, 3, 2, 1, 2 }, { 3, 3, 3, 3, 3 }, { 3, 2, 2, 2, 3 }, { 3, 2, 2, 2, 1 }, { 3, 2, 1, 2, 3 }, { 3, 2, 3, 2, 3 }, { 3, 3, 2, 3, 3 }, { 3, 3, 2, 1, 1 }, { 3, 2, 1, 1, 1 },
            },
            ["line_cnt"] = 40,
        },
        ["boardConfig"] = {
            { -- 3x5 -- free2 1个棋盘
                ["allow_over_range"] = true,
                ["colCnt"] = 5,
                ["symbolCount"] = 4,
                ["reel_single"] = true,
                ["cellWidth"] = G_cellWidth,
                ["cellHeight"] = G_cellHeight,
                ["reelConfig"] = {
                    {
                        ["base_pos"] = cc.p(52, 193)
                    }
                }
            },
            { -- 3x5 -- free2 1个棋盘
                ["allow_over_range"] = true,
                ["colCnt"] = 5,
                ["symbolCount"] = 4,
                ["reel_single"] = true,
                ["cellWidth"] = G_cellWidth,
                ["cellHeight"] = G_cellHeight,
                ["reelConfig"] = {
                    {
                        ["base_pos"] = cc.p(52, 193),
                    }
                }
            },
            { -- 3x5 -- free2 1个棋盘
                ["allow_over_range"] = true,
                ["colCnt"] = 5,
                ["symbolCount"] = 4,
                ["reel_single"] = true,
                ["cellWidth"] = G_cellWidth,
                ["cellHeight"] = G_cellHeight,
                ["reelConfig"] = {
                    {
                        ["base_pos"] = cc.p(52, 193)
                    }
                }
            },

        }
    }
    --- add by yt
    EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_SHOW, "theme221", self.touchShowCActivity, self)
    EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_HIDE, "theme221", self.touchHideCActivity, self)
    --- end by yt

    self.baseBet = 10000
    self.DelayStopTime = 0
    self.UnderPressure = 1 -- 下压上 控制
    self.addTop = 2
    local use_portrait_screen = true -- true 代表竖屏
    local ret = Theme.ctor(self, themeid, use_portrait_screen)
    return ret
end
----------------------------------------- 滚轴相关 -----------------------------------
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

function cls:getStopConfig(ret, spinTag, interval)
    -- gai
    local stopConfig = {}

    for col = 1, #self.spinLayer.spins do
        local theAction = self:getSpinColStopAction(ret["theme_info"], col, interval)
        table.insert(stopConfig, { col, theAction })
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
function cls:getSpinColStopAction(themeInfo, pCol, interval)
    if pCol == 1 then
        -- 同时下落的时候 进行的 延迟 重置
        self.DelayStopTime = 0
    end

    local checkNotifyTag = self:checkNeedNotify(pCol)
    if checkNotifyTag then
        self.DelayStopTime = self.DelayStopTime + extraReelTime
    end

    local _stopDelay, _downBonusT = self:getCurSpinLayerSpinActionTime(stopDelayList, downBounceTime, checkStopColCnt, autoStopDelayMult, autoDownBounceTimeMult )

    local spinAction = {}
    spinAction.actions = {}

    local temp = interval - speedUpTime - upBounceTime
    local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0
    if self.haveSpecialdelay then
        spinAction.stopDelay = timeleft + (pCol - 1) * _stopDelay + self.DelayStopTime + self.speicalDelay
        self.ExtraStopCD = self.speicalDelay
    else
        self.ExtraStopCD = spinMinCD - temp > 0 and spinMinCD - temp or 0
        spinAction.stopDelay = timeleft + (pCol - 1) * _stopDelay + self.DelayStopTime
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
function cls:onSpinStart()
    self.DelayStopTime = 0
    self:enableMapInfoBtn(false)
    --self:resetDiskData()

    if self.showSpinBoard == SpinBoardType.FreeSpin then
        local endIndex = self.ctl.sumFreeSpinCnt - self.ctl.freespin
        self:onNormalNextStart(endIndex)
    end
    self.flyMapPointSpines = nil
    --if self.showSpinBoard == SpinBoardType.FreeSpin then
    --self.ctl.totalWin = 0
    --self.ctl.footer:checkCleanCoinsAdd()
    --self.ctl.footer:changeLabelDescription("notFS_notWin")
    --end

    Theme.onSpinStart(self)
end

function cls:onSpinStop(ret)
    Theme.onSpinStop(self, ret)
end
function cls:onReelFallBottom(pCol)
    -- 标志位
    self:dealMusic_StopReelNotifyMusic(pCol)
    self.reelStopMusicTagList[pCol] = true
    -- 列停音效，提示动画相关
    self:checkPlaySymbolNotifyEffect(pCol)
    self:playSymbolNotifyEffect(pCol)
    self:playBonusSymbolNotifyEffect(pCol)

    self:onReelFallBottomJiLi(pCol)
    --end
    self:checkJiLiStatus(pCol)
end
function cls:onReelFallBottomJiLi(pCol)
    self:stopReelNotifyEffect(pCol, specialSymbol.trigger)
    local checkConfig = self.specialItemConfig
    self:stopReelNotifyEffect(pCol, specialSymbol.trigger, false)
    for itemKey, theItemConfig in pairs(checkConfig) do
        if pCol == 4 then
            if self:checkSpeedUp(pCol + 1) then
                self:onReelNotifyStopBeg(pCol + 1, itemKey, true)
            end
        end
    end
end
function cls:onReelNotifyStopBeg(pCol, itemKey, isNext)

    if not isNext and itemKey == specialSymbol.trigger then
        return
    end
    if not self.reelNotifyEffectList or not self.reelNotifyEffectList[itemKey] or not self.reelNotifyEffectList[itemKey][pCol] then
        self:playReelNotifyEffect(pCol, itemKey)
        if self.speedUpState and self.speedUpState[pCol] and self.speedUpState[pCol][itemKey] and self.speedUpState[pCol][itemKey]["cnt"] then
            local min = 3
            if self.speedUpState[pCol][itemKey]["cnt"] >= min then
                self:dealMusic_PlayReelNotifyMusic(pCol, itemKey)
            else
                self:dealMusic_PlayShortNotifyMusic(pCol, itemKey)
            end
        end
    end
end

function cls:onReelFastFallBottom(pCol)
    self.reelStopMusicTagList[pCol] = true
    if not self.fastStopMusicTag then
        self.startFastDownCol = pCol
    end
    self:checkPlaySymbolNotifyEffect(pCol, true)
    --self:dealMusic_PlayReelStopMusic(pCol)
    self.fastStopMusicTag = self.fastStopMusicTag or "allow_music"
    self:playSymbolNotifyEffect(pCol)
    self:playBonusSymbolNotifyEffect(pCol)
    for itemKey, theItemConfig in pairs(self.specialItemConfig) do
        if self:checkSpeedUpStop(pCol, itemKey) then
            self:onReelNotifyStopBeg(pCol, itemKey, false)
        end
    end
    self:dealMusic_StopReelNotifyMusic(pCol)
    self:checkJiLiStatus(pCol)

end
function cls:onReelStop(col)
    self:asHintTime(col)
end
function cls:setImgMaskStatus(show, isAni)

    self.imgMask:stopAllActions()
    if isAni then
        local startOpacity = 150
        local endOpacity = 0
        if show then
            startOpacity = 0
            endOpacity = 150
        end
        self.imgMask:setVisible(true)
        self.imgMask:setOpacity(startOpacity)
        self.imgMask:runAction(
                cc.Sequence:create(cc.FadeTo:create(0.5, endOpacity),
                        cc.CallFunc:create(
                                function()
                                    self.imgMask:setVisible(show)
                                end)
                )

        )
    else
        self.imgMask:setVisible(show)
        self.imgMask:setOpacity(150)

    end

end
function cls:asHintTime(col)
    if self.showSpinBoard == SpinBoardType.MapFree then
        return
    end
    self.flyMapPointSpines = self.flyMapPointSpines or {}
    self.flyMapPointSpines[col] = self.flyMapPointSpines[col] or {}
    local colItemList = self.item_list[col]

    local findWild = false
    for row = 1, G_cellRow do

        local itemKey = colItemList[row]

        if self.showSpinBoard == SpinBoardType.Normal then
            if itemKey % 100 == specialSymbol.wild then
                findWild = true
                self:flyCoinStack(col, row)
            end
        end
        local cell = self.spinLayer.spins[col]:getRetCell(row)
        if cell.aniSpine and bole.isValidNode(cell.aniSpine) then
            local aniSpine = cell.aniSpine
            bole.changeParent(aniSpine, self.bonusflyNode, 200)
            bole.spChangeAnimation(aniSpine, "animation" .. aniSpine.point, false)
            local pos = self:getCellPos(col, row)
            pos = cc.pAdd(pos, cc.p(0, 0))
            aniSpine:setPosition(pos)
            table.insert(self.flyMapPointSpines[col], aniSpine)
        end
        cell.aniNode = nil
    end
    if findWild then
        self:playMusic(self.audio_list.bonus_wild_fly)
    end


end
function cls:checkJiLiStatus(col)
    local sum = 0
    local checkConfig = self.specialItemConfig
    for itemKey, theItemConfig in pairs(checkConfig) do
        for pcol = 1, col do
            if self.speedUpState and self.speedUpState[pcol] and self.speedUpState[pcol][itemKey] then
                if self.speedUpState[pcol][itemKey]["is_get"] then
                    sum = self.speedUpState[pcol][itemKey]["cnt"] or sum
                end
            end
        end
        if col <= 5 then
            if sum + (5 - col) < theItemConfig.min_cnt then
                self:stopReelNotifyEffect(nil, itemKey)
            end
        end
    end
end
function cls:stopReelNotifyEffect(pCol, itemKey)
    self.reelNotifyEffectList = self.reelNotifyEffectList or {}
    self.reelNotifyEffectList[itemKey] = self.reelNotifyEffectList[itemKey] or {}
    if not pCol then
        local myReelNotifyEffectList = self.reelNotifyEffectList[itemKey]
        for i = 1, 5 do
            if myReelNotifyEffectList[i] and (not tolua.isnull(myReelNotifyEffectList[i])) then
                if myReelNotifyEffectList[i] and (not tolua.isnull(myReelNotifyEffectList[i])) then
                    myReelNotifyEffectList[i]:removeFromParent()
                    myReelNotifyEffectList[i] = nil
                end
            end
        end
        self.reelNotifyEffectList[itemKey] = nil
        if itemKey == specialSymbol.trigger then
            --self:stopAllTriggerCycle()
        end
        return
    end
    if self.reelNotifyEffectList[itemKey][pCol] and (not tolua.isnull(self.reelNotifyEffectList[itemKey][pCol])) then
        self.reelNotifyEffectList[itemKey][pCol]:removeFromParent()
    end
    self.reelNotifyEffectList[itemKey][pCol] = nil
end
function cls:finshSpin()
    if (not self.ctl.freewin) and (not self.ctl.autoSpin) and not self.bonus then
        self:enableMapInfoBtn(true)
    end
end
function cls:playReelNotifyEffect(pCol, itemKey)
    -- 播放特殊的 等待滚轴结果的
    self.reelNotifyEffectList = self.reelNotifyEffectList or {}
    if itemKey == specialSymbol.trigger then
        local pos = self:getCellPos(pCol, 2)
        pos = cc.pAdd(pos, cc.p(0, -G_cellHeight / 2))
        local _, s1 = bole.addSpineAnimation(self.animateNode, -1, self:getPic(SpineConfig.jili_free), pos, "animation", nil, nil, nil, true, true)-- 出现
        self.reelNotifyEffectList[itemKey] = self.reelNotifyEffectList[itemKey] or {}
        self.reelNotifyEffectList[itemKey][pCol] = s1
    end
end
function cls:getCellPosByAddSpinLayer(col, row)
    local retPos = self.spinLayer:getCellPos(col, row)
    local retPos2 = cc.pAdd(cc.p(-360, -640), retPos)
    return retPos2
end
function cls:checkNeedNotify(pCol)
    local isSpeedUp = false
    if self:checkSpeedUp(pCol) then

        if self.speedUpState[pCol][specialSymbol.trigger] and self.speedUpState[pCol][specialSymbol.trigger]["cnt"] > 2 then
            isSpeedUp = true
        end
        return isSpeedUp
    end
    return isSpeedUp

end
function cls:checkSpeedUp(checkCol)
    local isNeedSpeedUp = false
    if self.speedUpState and self.speedUpState[checkCol] and self.speedUpState[checkCol] then
        if self.speedUpState[checkCol][specialSymbol.trigger] then
            isNeedSpeedUp = true
        end
    end
    return isNeedSpeedUp
end
function cls:checkSpeedUpStop(checkCol)
    local isNeedSpeedUp = false
    if self.speedUpState and self.speedUpState[checkCol] and self.speedUpState[checkCol] then
        --local info = self.speedUpState[checkCol]
        if self.speedUpState[checkCol][specialSymbol.trigger] and self.speedUpState[checkCol][specialSymbol.trigger].is_get then
            isNeedSpeedUp = true
        end
    end
    return isNeedSpeedUp
end
function cls:checkPlaySymbolNotifyEffect(pCol, isFastStop)
    -- 是否播放特殊symbol 的 下落音效

    local isPlaySymbolNotify = false

    if not isFastStop then
        -- 不是快停状态 判断是否播放特殊symbol的动画
        isPlaySymbolNotify = self:dealMusic_PlaySpecialSymbolStopMusic(pCol)
        self:playReelStopMusic(isPlaySymbolNotify)
    else
        if isFastStop and not self.fastStopMusicTag then
            local mini = 0
            for col = pCol, #self.spinLayer.spins do
                local colStop = self:dealMusic_PlaySpecialSymbolStopMusic(col)
                if colStop > 0 and mini > 0 then
                    mini = math.min(colStop, mini)
                elseif mini == 0 then
                    mini = colStop
                end
                if mini == 1 then
                    break
                end
            end
            self:playReelStopMusic(mini)
        end
    end
    return isPlaySymbolNotify
end
function cls:playReelStopMusic(mini)
    local stopmusic = "reel_stop"
    if mini == 1 then
        stopmusic = "scatter_landing"
    elseif mini == 2 then
        stopmusic = "bonus_landing"
    end
    self:playEffectWithInterval(self.audio_list[stopmusic])
end
function cls:dealMusic_PlaySpecialSymbolStopMusic(pCol)

    local colItem = self.item_list[pCol]

    local specialList = { specialSymbol.trigger, specialSymbol.bonus }
    local find = 0
    for spcialIndex = 1, #specialList do
        for row = 1, G_cellRow do
            if find > 0 and find <= spcialIndex then
                break
            elseif specialList[spcialIndex] == colItem[row] then
                if spcialIndex == 1 then

                    if self.notifyState and self.notifyState[pCol] and bole.getTableCount(self.notifyState[pCol]) > 0 then
                        find = spcialIndex
                        break
                    end
                else
                    find = spcialIndex
                    break
                end
            end
        end
        if find > 0 then
            break
        end
    end
    return find

end

function cls:initSpinLayerBg()
 
    self.flyNumberLayer = cc.Node:create()
    self.flyNumberLayer:setPosition(0, 0)
    self.curScene:addToTop(self.flyNumberLayer, 10)

    self.flyTranslatesLayer = cc.Node:create()
    self.flyTranslatesLayer:setPosition(0, 0)
    self.curScene:addToTop(self.flyTranslatesLayer, 11)
    self:updateBaseShowPointsCnt()

    --入场动画
    local _,spine =  self:addSpineAnimation(self.flyTranslatesLayer, nil, self:getPic(SpineConfig.trans_free), cc.p(0, 0), "animation", nil, nil, nil, false, true)
    local nodeList = self.down_child:getChildren()  
    -- 循环遍历节点列表  
    for i, node in ipairs(nodeList) do  
        -- 在这里处理每个节点  
        node:setOpacity(0)
    end
 
    nodeList[1]:setOpacity(255)

    for i, node in ipairs(nodeList) do  
        -- 在这里处理每个节点  
        if i ~= 1 then
            node:runAction(
                cc.Sequence:create(
                    cc.DelayTime:create(2),
                    cc.FadeIn:create(0.5) 
                )
            )
        end
        
    end
 

    if self.haveBonus then
        self:updateBaseCoinsStack(3, true)
    else
        self:updateBaseCoinsStack()
    end
end
function cls:updateBaseShowPointsCnt(value)
    value = value or self.themeMapPoints
    value = value or 0
    self.collectPoints:setString(FONTS.formatByCount4(value, 6, true))
    bole.shrinkLabel(self.collectPoints, self.collectPoints.maxWidth, self.collectPoints.baseScale)

end
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
function cls:changeSpinBoard(pType)
    -- 更改背景控制 已修改
    self:clearAnimate()
    self.showSpinBoard = pType
    if pType == SpinBoardType.Normal then
        -- normal情况下 需要更改棋盘底板
        if self.spinLayer ~= self.spinLayerList[1] then
            self.spinLayer:DeActive()
            self.spinLayer = self.spinLayerList[1]
            self.spinLayer:Active()
        end
        self.initBoardIndex = 1
        local isBase = true
        local isFree = false
        local isMapFree = false
        self.baseNodeRoot:setVisible(isBase)
        self.freeNodeRoot:setVisible(isFree)
        self.mapFreeNode:setVisible(isMapFree)
        self.progressiveNode:setVisible(isBase)
        self.logoCharNodeRoot:setVisible(isBase)
        self:setLogoStatus()

    elseif pType == SpinBoardType.FreeSpin then

        if self.spinLayer ~= self.spinLayerList[2] then
            self.spinLayer:DeActive()
            self.spinLayer = self.spinLayerList[2]
            self.spinLayer:Active()
        end
        self.initBoardIndex = 2

        local isBase = false
        local isFree = true
        local isMapFree = false
        self.baseNodeRoot:setVisible(isBase)
        self.freeNodeRoot:setVisible(isFree)
        self.mapFreeNode:setVisible(isMapFree)
        self.progressiveNode:setVisible(isBase)
        self.logoCharNodeRoot:setVisible(isBase)

    elseif pType == SpinBoardType.MapFree then
        if self.spinLayer ~= self.spinLayerList[3] then
            self.spinLayer:DeActive()
            self.spinLayer = self.spinLayerList[3]
            self.spinLayer:Active()
        end
        self:resetMapFreeBoard()
        self.initBoardIndex = 3
        local isBase = false
        local isFree = false
        local isMapFree = true
        self.baseNodeRoot:setVisible(isBase)
        self.freeNodeRoot:setVisible(isFree)
        self.mapFreeNode:setVisible(isMapFree)
        self.progressiveNode:setVisible(isBase)
        self.logoCharNodeRoot:setVisible(isMapFree)

        self:setLogoStatus()
    end
    self:changeBg(pType)
end

function cls:setLogoStatus()


    if self.showSpinBoard == SpinBoardType.MapFree then
        self.logoCharNodeRoot:setPosition(cc.p(0, 170))
        bole.spChangeAnimation(self.logoCharSpineNode, "animation2", true)
    else
        self.logoCharNodeRoot:setPosition(self.logoCharPos)
        bole.spChangeAnimation(self.logoCharSpineNode, "animation1", true)
    end

end
function cls:setLogoTrans()
    self.logoCharNodeRoot:stopAllActions()
    bole.spChangeAnimation(self.logoCharSpineNode, "animation", false)
    self.logoCharSpineNode:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(2),
                    cc.CallFunc:create(
                            function()
                                self:setLogoStatus()
                            end)
            )
    )
end
function cls:setBonusTrigger()
    self.logoCharNodeRoot:stopAllActions()
    bole.spChangeAnimation(self.logoCharSpineNode, "animation3", true)
end
function cls:changeBg(pType)
    local imgBG = { self.baseBg, self.freeBg, self.mapFreeBg }
    local imgReelBG = { "image/bg/theme186_bg_free4.png", "image/bg/theme186_bg_free2.png", "image/bg/theme186_bg_free3.png", "image/bg/theme186_bg_free1.png" }

    local showBg = imgBG[pType]
    if not showBg then
        return
    end
    if pType == SpinBoardType.FreeSpin then
        local img = imgReelBG[self.freeType]
        bole.updateSpriteWithFile(self.freeBg, self:getPic(img))
    end
    if self.curBg ~= showBg then
        local _curBg = self.curBg
        _curBg:runAction(cc.Sequence:create(cc.FadeTo:create(0.5, 0), cc.DelayTime:create(0.5), cc.CallFunc:create(function(...)
            _curBg:setVisible(false)
        end)))
        showBg:setOpacity(0)
        showBg:setVisible(true)
        showBg:runAction(cc.FadeTo:create(0.5, 255))
        self.curBg = showBg
    end
end
function cls:clearAnimate()

    self.animateNode:removeAllChildren()
    self.themeAnimateKuang:removeAllChildren()
    self:cleanAnimateList()
    self:cleanCellState()
end
function cls:stopDrawAnimate()
    self.speicalDelay = 0
    self.haveSpecialdelay = false
    local delay = 0

    self:stopReelNotifyEffect(nil, specialSymbol.trigger)
    Theme.stopDrawAnimate(self)
end
function cls:cleanStatus()
    self.animNodeList = nil
    self.animNodeBgList = nil
    self.triggerLandList = nil
    self.itemList = nil
    Theme.cleanStatus(self)
end
--------------------------------------xr---------------------------------------------------------------------
-- 主题布局相关
------------------------------------------------------------------------------------------------------------
function cls:initScene(spinNode)
    local path = self:getPic(allCsbList.base)
    self.mainThemeScene = cc.CSLoader:createNode(path)
    bole.adaptScale(self.mainThemeScene, true) -- 第二个参数 是否是 竖版

    self.down_node = self.mainThemeScene:getChildByName("down_node")
    bole.adaptReelBoard(self.down_node) -- 竖屏 适配 棋盘的 横屏不需要

    ---@see  bg node
    self.bgRoot = self.mainThemeScene:getChildByName("theme_bg")

    self.baseBg = self.bgRoot:getChildByName("bg_base")
    self.freeBg = self.bgRoot:getChildByName("bg_free")
    self.mapFreeBg = self.bgRoot:getChildByName("bg_mapfree")
    self.wheelBg = self.bgRoot:getChildByName("bg_wheel")
    self.baseBg:setVisible(true)
    self.curBg = self.baseBg
    self.freeBg:setVisible(false)
    self.mapFreeBg:setVisible(false)
    self.wheelBg:setVisible(false)
    ---@see jackpot node
    self.progressiveNode = self.mainThemeScene:getChildByName("progressive")
    self:initialJackpotNode()
    self.myDialogNode = cc.Node:create()
    self.mainThemeScene:addChild(self.myDialogNode)
    self.down_child = self.down_node:getChildByName("down_node")

    self.logoCharNodeRoot = self.down_child:getChildByName("logo_node")
    self:initLogoNode()
    ---@see base
    self.baseNodeRoot = self.down_child:getChildByName("base_node")
    ------@see collect
    self.baseCollectRoot = self.baseNodeRoot:getChildByName("collect_base")
    self.baseCollectRoot:setVisible(false)
    self.mapCollectRoot = self.baseCollectRoot
    self:initCollectNode()
    ------@see base top
    self.baseTopNode = self.baseNodeRoot:getChildByName("top_base")
    self:initBaseTopNode()

    ---@see normal free
    self.freeNodeRoot = self.down_child:getChildByName("free_node")
    ------@see collect
    self.freeCollectRoot = self.freeNodeRoot:getChildByName("collect_free")
    self.freeTopRoot = self.freeNodeRoot:getChildByName("top_free")
    self:initFreeCollectNode()
    ---@see mapfree
    self.mapFreeNode = self.down_child:getChildByName("mapfree_node")

    self:initMapFreeNode()
    ---@see 棋盘
    self.reelRootNode = self.down_child:getChildByName("reel_root_node")
    ---@see reelRoot child
    self.reelRoot = self.down_child:getChildByName("node_board_root")
    self.boardRoot = self.reelRoot:getChildByName("board_root") --1
    self.imgMask = self.reelRoot:getChildByName("img_mask") --1
    self.imgMask:setLocalZOrder(1)
    self.imgMask:setVisible(false)
    self.scatterLayer = self.reelRoot:getChildByName("scatter_layer") --1
    self.scatterLayer:setLocalZOrder(2)

    self.animateNode = self.reelRoot:getChildByName("animate_node")
    self.animateNode:setLocalZOrder(4)
    self.themeAnimateKuang = cc.Node:create()
    self.reelRoot:addChild(self.themeAnimateKuang)
    self.themeAnimateKuang:setLocalZOrder(7)

    self.dialogNode = self.down_child:getChildByName("dialog_node")
    self.dialogNode:setLocalZOrder(1)

    self.bonusflyNode = self.down_child:getChildByName("fly_node")
    self.bonusflyNode:setLocalZOrder(2)

    self.wheel_node = self.mainThemeScene:getChildByName("wheel_node")

    bole.adaptReelBoard(self.wheel_node) -- 竖屏 适配 棋盘的 横屏不需要

    self.shakyNode:addChild(self.mainThemeScene)
end
function cls:setDownNodeScale(scale)
    self.downNodeScale = scale
end
-------------------------- logo start ------------------------------------------------
function cls:initLogoNode()
    --ss
    if SHRINKSCALE_H == 1 then
        local scale = THEME_LIST[self.themeid]["questScale"]
        if scale then
            self.downNodeScale = scale
        end
    end
    self:initLogoCharPos()
    self:_initLogoNameNode()
    --self.logoLabelNode = self.mainThemeScene:getChildByName("logo_node")
    --if self:adaptationLongScreen() then
    --    self.logoLabelNode:setVisible(true)
    --    self:initLogoLabelPos()
    --    self:initProgressivePos()
    --else
    --    self.logoLabelNode:setVisible(false)
    --end

end
function cls:initLogoLabelPos()
    local winSize = cc.Director:getInstance():getWinSize()
    local Height = math.max(winSize.width, winSize.height)
    local addY = bole.getAdaptWidth() / 2

    local headerHeight = 90
    local activityHeight = 80
    local sticky = (headerHeight + activityHeight)

    local posY = Height / 2 - sticky - addY / 2
    if bole.isIphoneX() then
        posY = posY - 50
    end
    local addScale = 1
    --if addY * 2 > 180 then
    if bole.isIphoneX() then
        addY = addY - 30
    end
    addScale = (addY * 2) / 180
    if addScale > 1.2 then
        addScale = 1.2
    end
    --end
    posY = posY + 20 -- 用于移动logo 留存位置
    self.logoLabelImg = self.logoLabelNode:getChildByName("logo_img")
    self.logoLabelImg:setPosition(cc.p(0, posY))
    self.logoLabelImg:setScale(addScale)
    local _, s = self:addSpineAnimation(self.logoLabelNode, nil, self:getPic(SpineConfig.logo_label), cc.p(0, posY), "animation", nil, nil, nil, true, true)
    s:setScale(addScale)
end

-----------------------------------------------------------------------------------------------------------------------------------
-- @ 长屏logo 点击活动移动相关 add by yt
function cls:_initLogoNameNode(...)
    self.longLogoNode = self.mainThemeScene:getChildByName("logo_node")
    if self:adaptationLongScreen() then
        self:initProgressivePos()
        local winSize = cc.Director:getInstance():getWinSize()
        local Height = math.max(winSize.width, winSize.height)
        local addY = bole.getAdaptWidth() / 2
        local headerHeight = 90
        local activityHeight = 80
        local sticky = (headerHeight + activityHeight)
        local posY = Height / 2 - sticky - addY / 2
        if bole.isIphoneX() then
            posY = posY - 50
            addY = addY - 30
        end
        local addScale = 1
        addScale = (addY * 2) / 180
        if addScale > 1.2 then
            addScale = 1.2
        end
        self.logoLabelImg = self.longLogoNode:getChildByName("logo_img")
        self.logoLabelImg:setPosition(cc.p(0, posY))
        self.logoLabelImg:setScale(addScale)
        self.logoLabelImg.basePos = cc.p(self.logoLabelImg:getPosition())
        self.logoLabelImg.baseScale = addScale

        local _, s = self:addSpineAnimation(self.longLogoNode, nil, self:getPic(SpineConfig.logo_label), cc.p(0, posY), "animation", nil, nil, nil, true, true)
        s:setScale(addScale)
        self.logoLabelImg2 = s
        self.logoLabelImg2.basePos = cc.p(self.logoLabelImg2:getPosition())
        self.logoLabelImg2.baseScale = addScale
        if self:getHeaderStatus() == 1 then
            self:downThemeLogo(true)
        end
        self.longLogoNode:setVisible(true)
    else
        self.longLogoNode:setVisible(false)
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
    if self.longLogoNode and self:adaptationLongScreen() then
        local endscale = self.logoLabelImg.baseScale * 0.9
        local endPosY = self.logoLabelImg.basePos.y - 30
        self.logoLabelImg2:stopActionByTag(1003)
        self.logoLabelImg:stopActionByTag(1003)
        if not noAni then
            local a1 = cc.ScaleTo:create(0.3, endscale)
            local a2 = cc.MoveTo:create(0.3, cc.p(0, endPosY))
            local a5 = cc.Spawn:create(a1, a2)
            a5:setTag(1003)
            local a3 = cc.ScaleTo:create(0.3, endscale)
            local a4 = cc.MoveTo:create(0.3, cc.p(0, endPosY))
            local a6 = cc.Spawn:create(a3, a4)
            a6:setTag(1003)
            self.logoLabelImg:runAction(a5)
            self.logoLabelImg2:runAction(a6)
        else
            self.logoLabelImg:setScale(endscale)
            self.logoLabelImg2:setScale(endscale)
            self.logoLabelImg:setPositionY(endPosY)
            self.logoLabelImg2:setPositionY(endPosY)
        end
    end
end

function cls:upThemeLogo(noAni)
    if self.logoLabelImg and self:adaptationLongScreen() then
        local endscale = self.logoLabelImg.baseScale
        local endPosY = self.logoLabelImg.basePos.y
        self.logoLabelImg:stopActionByTag(1003)
        self.logoLabelImg2:stopActionByTag(1003)
        if not noAni then
            local a1 = cc.ScaleTo:create(0.3, endscale)
            local a2 = cc.MoveTo:create(0.3, cc.p(0, endPosY))
            local a5 = cc.Spawn:create(a1, a2)
            a5:setTag(1003)
            local a3 = cc.ScaleTo:create(0.3, endscale)
            local a4 = cc.MoveTo:create(0.3, cc.p(0, endPosY))
            local a6 = cc.Spawn:create(a3, a4)
            a6:setTag(1003)
            self.logoLabelImg:runAction(a5)
            self.logoLabelImg2:runAction(a6)
        else
            self.logoLabelImg:setScale(endscale)
            self.logoLabelImg2:setScale(endscale)
            self.logoLabelImg:setPositionY(endPosY)
            self.logoLabelImg2:setPositionY(endPosY)
        end
    end
end

function cls:getHeaderStatus()
    return self.showHeaderdStatus or 2
end
-----------------------------------------------------------------------------------------------------------------------------------


function cls:initLogoCharPos()
    local file = self:getPic(SpineConfig.base_logo)
    local _, s = bole.addSpineAnimation(self.logoCharNodeRoot, 2, file, cc.p(0, 0), "animation1", nil, nil, nil, true, true)
    self.logoCharSpineNode = s
    local base_pos = cc.p(0, 0)
    local addY = 0
    local endScale = self.downNodeScale or 1

    addY = 170 * (1 - endScale) / endScale
    if addY > 170 then
        addY = 170
    end
    base_pos = cc.pAdd(base_pos, cc.p(0, addY))
    self.logoCharPos = base_pos
    self.logoCharNodeRoot:setPosition(self.logoCharPos)
end
function cls:initProgressivePos()
    bole.adaptReelBoard(self.progressiveNode)
end


-------------------------- logo end ------------------------------------------------
-------------------------- collect start ------------------------------------------------


function cls:initCollectNode()
    self.isCanFeatureClick = true
    local posX = self.mapCollectRoot:getPositionX()
    posX = posX + 5
    self.mapCollectRoot:setPositionX(posX)
    self.btnTouch = self.mapCollectRoot:getChildByName("btn_touch")
    self.btnTip = self.mapCollectRoot:getChildByName("img_tip")
    --self.openStoreBtn = self.mapCollectRoot:getChildByName("btn_store")
    self.mapItemNode = self.mapCollectRoot:getChildByName("node_collect")
    self.mapItemNode2 = self.mapCollectRoot:getChildByName("node_collect2")

    self.baseLockNode1 = self.mapCollectRoot:getChildByName("lock_node1")
    self.baseLockNode2 = self.mapCollectRoot:getChildByName("lock_node2")

    self.collectPoints = self.mapCollectRoot:getChildByName("font")
    self.collectPoints.maxWidth = 120
    self.collectPoints.baseScale = 0.4
    inherit(self.collectPoints, LabelNumRoll)
    local function parseValue1(num)
        local value_str = FONTS.formatByCount4(num, 6, true)
        return value_str
    end
    self.collectPoints:nrInit(0, 24, parseValue1)
    local _, s = bole.addSpineAnimation(self.mapCollectRoot, 2, self:getPic(SpineConfig.collect_idle), cc.p(19, 43), "animation", nil, nil, nil, true, true)
    self.collectIdle = s

    local function onTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            if not self.isCanFeatureClick then
                return
            end
            --self.btnTip:setBright(true)
            self:setTouchCollectColor(true)
            self:playMusic(self.audio_list.btn_click)
            if self.isFeatureClick then
                return nil
            end
            if self.isLockFeature then
                self:setBet()
                return
            end
            if not self.themeMapInfo then
                return
            end
            self:showStoreNode()

        end
        if eventType == ccui.TouchEventType.began then
            if self.isCanFeatureClick and not self.isLockFeature then
                --self.btnTip:setBright(false)

                self:setTouchCollectColor(false)
            end
        end
        if eventType == ccui.TouchEventType.canceled then
            if self.isCanFeatureClick and not self.isLockFeature then
                --self.btnTip:setBright(true)
                self:setTouchCollectColor(true)
            end

        end

    end
    self.btnTouch:addTouchEventListener(onTouch)
end
function cls:setTouchCollectColor(enable)

    local color = cc.c3b(255, 255, 255)
    if not enable then
        color = cc.c3b(150, 150, 150)
        if not self.baseMapTouchSpine or not bole.isValidNode(self.baseMapTouchSpine) then
            local _, s = bole.addSpineAnimation(self.mapItemNode2, 1, self:getPic(SpineConfig.collect_touch), cc.p(13, 43), "animation2", nil, nil, nil, true, false)
            self.baseMapTouchSpine = s
        end
    else
        if self.baseMapTouchSpine and bole.isValidNode(self.baseMapTouchSpine) then
            self.baseMapTouchSpine:removeFromParent()
        end
        self.baseMapTouchSpine = nil
    end

    self.btnTip:setColor(color)
end
----------------------------- collect end ------------------------------------------------
----------------------------- top start ------------------------------------------------

function cls:initBaseTopNode()

    self.baseTopNode:removeAllChildren()
    local _, s = self:addSpineAnimation(self.baseTopNode, nil, self:getPic(SpineConfig.coins_idle), cc.p(0, 0), "animation1", nil, nil, nil, true, true)
    self.coinsStackSpine = s
end
function cls:initFreeCollectNode()

    self.freeCollectFont = self.freeCollectRoot:getChildByName("font")
    self.freeCollectFont.baseScale = 0.7
    self.freeCollectFont.maxWidth = 332
    inherit(self.freeCollectFont, LabelNumRoll)
    local function parseValue1(num)
        local value_str = FONTS.formatByCount4(num, 10, true)
        return value_str
    end

    self.freeCollectFont:nrInit(0, 24, parseValue1)
    local _, s = self:addSpineAnimation(self.freeCollectRoot, nil, self:getPic(SpineConfig.collect_item), cc.p(0, 0), "animation", nil, nil, nil, true, false)
    self.freeMapItemSpine = s
    --s:setScale(0.7)

    self.freeLockNode1 = self.freeCollectRoot:getChildByName("lock_node1")
    self.freeLockNode2 = self.freeCollectRoot:getChildByName("lock_node2")
end
function cls:refreshFreeCollectNode()
    local value = self.themeMapPoints or 0
    local freeCollectFont = self.freeCollectRoot:getChildByName("font")
    local value_str = FONTS.formatByCount4(value, 10, true)
    freeCollectFont:setString(value_str)
    bole.shrinkLabel(freeCollectFont, freeCollectFont.maxWidth, freeCollectFont.baseScale)
    if self.isLockFeature then
        self.freeLockNode1:setVisible(true)
        self.freeLockNode2:setVisible(true)
    else
        self.freeLockNode1:setVisible(false)
        self.freeLockNode2:setVisible(false)
    end

end
----------------------------- top end ------------------------------------------------
function cls:initMapFreeNode()

    self.descMapFree1 = self.mapFreeNode:getChildByName("desc1")
    self.descMapFree2 = self.mapFreeNode:getChildByName("desc2")
end
function cls:resetMapFreeBoard()
    for col = 1, 5 do
        for row = 1, 4 do
            local key = math.random(2, 6)
            local cell = self.spinLayer.spins[col]:getRetCell(row)
            self:updateCellSprite(cell, key, row, 1, true)
        end
    end
end
--------------------------------------jackpot ---------------------------------------


function cls:initialJackpotNode()
    local progressive_nodes = self.progressiveNode:getChildByName("jackpots_labels")-- 初始化jackpot
    self.jackpotLabels = {}
    self.jackpotSpine = self.progressiveNode:getChildByName("spine")
    for i = 1, 5 do
        self.jackpotLabels[i] = progressive_nodes:getChildByName("label_jp" .. i)
        self.jackpotLabels[i].maxWidth = self:getJPLabelMaxWidth(i)
        self.jackpotLabels[i].baseScale = self:getJPLabelMaxScale(i)
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

    local parent = self.basebaseLockNode1
    if not self.lockSuperSpine then
        local file = self:getPic(SpineConfig.collect_lock)
        local file2 = self:getPic(SpineConfig.collect_tower)
        local _, s = bole.addSpineAnimation(self.baseLockNode2, 2, file, cc.p(10, 0), "animation1", nil, nil, nil, true, false, nil)
        local _, s2 = bole.addSpineAnimation(self.baseLockNode1, 2, file2, cc.p(0, 0), "animation1", nil, nil, nil, true, false, nil)
        self.lockSuperSpine = {}
        self.lockSuperSpine[1] = s
        self.lockSuperSpine[2] = s2
    end

    if active then
        -- 播放解锁动画
        self.isLockFeature = false

        local aniName = "animation1"

        self.lockSuperSpine[1]:setAnimation(0, aniName, false)
        self.lockSuperSpine[2]:setAnimation(0, aniName, false)

        if isAnimate then
            self:playMusic(self.audio_list.unlock)
        end
    else
        -- 播放锁定动画
        local aniName = ""
        aniName = "animation2"
        if isAnimate then
            self:playMusic(self.audio_list.lock)
            --aniName = "animation2"
        end
        self.isLockFeature = true
        self.lockSuperSpine[1]:setAnimation(0, aniName, false)
        self.lockSuperSpine[2]:setAnimation(0, aniName, false)


    end
end

function cls:getJPLabelMaxWidth(index)
    local jackpotLabelMaxWidth = { 406, 278, 278, 220, 220 }
    return jackpotLabelMaxWidth[index] or jackpotLabelMaxWidth[#jackpotLabelMaxWidth]
end
function cls:getJPLabelMaxScale(index)
    local jackpotLabelMaxScale = { 0.8, 0.7, 0.7, 0.6, 0.6 }
    return jackpotLabelMaxScale[index] or jackpotLabelMaxScale[#jackpotLabelMaxScale]
end
function cls:getThemeJackpotConfig()
    local jackpot_config_list = {
        link_config = { "grand", "mega", "major", "minor", "mini" },
        allowK = { [186] = false, [686] = false, [1186] = false }
    }
    return jackpot_config_list
end
function cls:getJackpotWorldPos(jackpot_type)

    local progress_node = self.progressiveNode:getChildByName("floor" .. jackpot_type)
    local endWPos = bole.getWorldPos(progress_node)
    local endNPos = bole.getNodePos(self.bonusflyNode, endWPos)
    return endNPos
end
function cls:getJackpotPos(index)
    local progress_node = self.progressiveNode:getChildByName("floor" .. index)
    local progress_spine = self.jackpotSpine
    local endWPos = bole.getWorldPos(progress_node)
    local endNPos = bole.getNodePos(progress_spine, endWPos)
    return endNPos
end
function cls:jackpotTriggerBoom(index)
    local spineFile = SpineConfig["jackpot_" .. index]
    local endPos = self:getJackpotPos(index)
    local _, s = bole.addSpineAnimation(self.jackpotSpine, 1, self:getPic(spineFile), endPos, "animation1", nil, nil, nil, true, false)
    s:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(30 / 30),
                    cc.CallFunc:create(
                            function()
                                bole.spChangeAnimation(s, "animation2", true)
                            end
                    )
            )
    )
end
--------------------------------------jackpot end  ---------------------------------------

function cls:initBoardNodes(pBoardConfigList)
    local boardRoot = self.boardRoot
    local boardConfigList = pBoardConfigList or self.boardConfigList or {}
    local reelZorder = 100
    self.clipData = {}
    local pBoardNodeList = {}
    -- 棋盘初始化
    for boardIndex, theConfig in ipairs(boardConfigList) do
        local theBoardNode = nil
        local reelNodes = {}
        if theConfig["reel_single"] then
            -- 一个棋盘用一个裁剪区域
            local rowReelCnt = 4
            local colCnt = 5
            self.clipData["reel_single"] = {}
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
            self.clipData["normal"] = {}
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

                self.clipData["normal"][reelIndex] = {}
                self.clipData["normal"][reelIndex]["vex"] = vex
                self.clipData["normal"][reelIndex]["stencil"] = stencil
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
    self:initBoardTouchBtn(boardConfigList, pBoardNodeList)
    return pBoardNodeList
end
function cls:initBoardTouchBtn(boardConfigList, pBoardNodeList)

    for key = 1,#boardConfigList do
        local reelConfig = boardConfigList[key].reelConfig
        local base_pos = reelConfig[1].base_pos
        local boardW = reelConfig[1].cellWidth * 5
        local boardH = reelConfig[1].cellHeight * reelConfig[1].symbolCount
        self:initTouchSpinBtn(base_pos, boardW, boardH, pBoardNodeList[key])
    end
end
function cls:initTouchSpinBtn(base_pos, boardW, boardH, parent)

    --local unitSize = 54
    local unitSize = 10
    local img = "commonpics/kong.png"
    --local img = "commonpics/common_black.png"
    local touchSpin = function(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            self:footerCopySpinBtnEvent()
        end
    end
    local touchBtn = Widget.newButton(touchSpin, img, img, img, false) --10
    touchBtn:setPosition(base_pos)
    touchBtn:setAnchorPoint(cc.p(0, 0))
    touchBtn:setScaleX(boardW / unitSize)
    touchBtn:setScaleY(boardH / unitSize)
    parent:addChild(touchBtn)
end
------------------------------------------------------------------------------------------------------------
-- Cell相关
------------------------------------------------------------------------------------------------------------
function cls:adjustWithTheCellSpriteUpdate(theCellNode)
    -- 删除掉 tip 动画
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

function cls:createCellSprite(key, col, rowIndex)
    self.initialPics = self.initialPics or {}
    ------------------------------------------------------------
    local theCellNode = cc.Node:create()
    if rowIndex then
        key = math.random(2, 6)
    end
    local beforeNum = key
    key = beforeNum % 100
    local muti = 1
    if key > 20 then
        muti = wildMulti[key]
    end
    if muti > 1 then
        key = specialSymbol.wild2
        local mutiNode = bole.createSpriteWithFile("#theme186_s_X" .. muti .. ".png")
        mutiNode:setPosition(cc.p(0, -20))
        theCellNode:addChild(mutiNode, 1)
        theCellNode.muti = mutiNode
    end
    if key == specialSymbol.wild2 then

    end
    local theCellFile = self.pics[key]

    local theCellSprite = bole.createSpriteWithFile(theCellFile)
    theCellNode:addChild(theCellSprite)
    theCellNode.key = key
    theCellNode.sprite = theCellSprite
    theCellNode.curZOrder = 0

    ------------------------------------------------------------
    if self.symbolZOrderList[key] then
        theCellNode.curZOrder = self.symbolZOrderList[key]
    end
    theCellNode:setLocalZOrder(theCellNode.curZOrder)

    self:adjustWithTheCellSpriteUpdate(theCellNode)
    local theKey = theCellNode.key

    return theCellNode
end

function cls:updateCellSprite(theCellNode, key, col, isShowResult, isReset)
    local beforeNum = key

    if theCellNode.aniNode and bole.isValidNode(theCellNode.aniNode) then
        theCellNode.aniNode:removeAllChildren()
    end
    if theCellNode.muti and bole.isValidNode(theCellNode.muti) then
        theCellNode.muti:removeFromParent()
        theCellNode.muti = nil
    end
    if theCellNode.font and bole.isValidNode(theCellNode.font) then
        theCellNode.font:removeFromParent()
        theCellNode.font = nil
    end

    --theCellNode.aniNode L
    local showKey = key % 100
    theCellNode:setVisible(true)
    theCellNode.sprite:setVisible(true)

    if self.showSpinBoard == SpinBoardType.MapFree then
        local muti = 1

        if self.mapFreeList[MapFreeType.MultiplerWilds] > 0 then
            if showKey == 1 and not isShowResult then
                showKey = 20 + math.random(1, 6)
            end
        end
        if showKey > 20 then
            muti = wildMulti[showKey]
        end
        if muti > 1 then
            showKey = specialSymbol.wild2
            local mutiNode = bole.createSpriteWithFile("#theme186_s_X" .. muti .. ".png")
            mutiNode:setPosition(cc.p(0, -20))
            theCellNode:addChild(mutiNode, 1)
            theCellNode.muti = mutiNode
        end
        if self:checkKeyinRemoveSymbol(key) then
            showKey = math.random(2, 6)
        end
    end
    local theCellFile = self.pics[showKey]
    if not theCellFile then
    else
        local theCellSprite = theCellNode.sprite
        bole.updateSpriteWithFile(theCellSprite, theCellFile)
        theCellNode.key = showKey
        theCellNode.curZOrder = 0
    end
    if self.symbolZOrderList[showKey] then
        theCellNode.curZOrder = self.symbolZOrderList[showKey]
        theCellNode:setLocalZOrder(self.symbolZOrderList[showKey])
    end
    self:adjustWithTheCellSpriteUpdate(theCellNode, showKey, col)
    self:adjustWithTheMapPoints(theCellNode, beforeNum, isShowResult, isReset)
    ------------------------------------------------------------
end

function cls:adjustWithTheMapPoints(theCellNode, beforeNum, isShowResult, isReset)
    if not isShowResult then
        return
    end
    if isShowResult == 1 then
        return
    end
    local pos = cc.p(0, 0)
    local index = math.round(beforeNum / 100)

    if index > 0 then
        if not theCellNode.aniNode then
            theCellNode.aniNode = cc.Node:create()
            theCellNode:addChild(theCellNode.aniNode, 20)
        end
        local _, s = self:addSpineAnimation(theCellNode.aniNode, nil, self:getPic(SpineConfig.collect_fly), pos, "animation" .. index, nil, nil, nil, true)
        theCellNode.aniSpine = s
        s.point = index
        s:setVisible(false)
    end
end
function cls:adjustScatterTailAni(col, key, theCellNode, isShowResult)

    if self.fastStopMusicTag then
        return
    end
    if isShowResult then
        return
    end
    if self.fastStopMusicTag then
        return
    end
    local aniName = "animation"
    local _, s2 = bole.addSpineAnimation(theCellNode, -1, self:getPic(SpineConfig["bonus_" .. key .. "_tail"]), cc.p(0, 0), aniName, nil, nil, nil, true, false)
    theCellNode.symbolTipAnim2 = s2

end
function cls:playSymbolNotifyEffect(col)
    if (not self.notifyState) or (not self.notifyState[col]) then
        return
    end
    for key, list in pairs(self.notifyState[col]) do
        if key == specialSymbol.trigger or key == specialSymbol.bonus then
            for _, crPos in pairs(list) do
                local cell = nil
                if self.fastStopMusicTag then
                    cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2])
                else
                    cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2] + 1)
                end
                if cell then
                    local animateName = "animation2"
                    local spineFile = self:getPic("spine/item/" .. key .. "/spine")
                    local _, s = bole.addSpineAnimation(cell, 10, spineFile, cc.p(0, 0), animateName, nil, nil, nil, true, false)
                    cell.symbolTipAnim = s

                    if key == specialSymbol.trigger then
                        self.animNodeBgList = self.animNodeBgList or {}
                        self.animNodeBgList[crPos[1] .. "_" .. crPos[2]] = self.animNodeBgList[crPos[1] .. "_" .. crPos[2]] or {}
                        self.animNodeBgList[crPos[1] .. "_" .. crPos[2]][1] = s
                        cell:runAction(
                                cc.Sequence:create(
                                        cc.DelayTime:create(5 / 30),
                                        cc.CallFunc:create(
                                                function()
                                                    bole.changeParent(cell.symbolTipAnim, self.animateNode, -2)
                                                    local pos = self:getCellPos(crPos[1], crPos[2])
                                                    cell.symbolTipAnim:setPosition(pos)
                                                end)

                                )
                        )
                    end
                end
            end

        end
    end
end

function cls:playBonusSymbolNotifyEffect(col)
    local crPos = {}
    for row = 1, 3 do

        if self.item_list[col][row] % 100 == specialSymbol.bonus then
            crPos = { col, row }
        end
    end
    local cell = nil
    if #crPos > 0 then

        if self.fastStopMusicTag then
            cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2])
        else
            cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2] + 2)
        end
    end
    if cell then
        local animateName = "animation1"
        local spineFile = self:getPic("spine/item/" .. specialSymbol.bonus .. "/spine")
        local _, s = bole.addSpineAnimation(cell, 10, spineFile, cc.p(0, 0), animateName, nil, nil, nil, true, false)
        cell.symbolTipAnim = s
        self.animNodeBgList = self.animNodeBgList or {}
        self.animNodeBgList[crPos[1] .. "_" .. crPos[2]] = self.animNodeBgList[crPos[1] .. "_" .. crPos[2]] or {}
        self.animNodeBgList[crPos[1] .. "_" .. crPos[2]][1] = s
        cell:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(5 / 30),
                        cc.CallFunc:create(
                                function()
                                    bole.changeParent(cell.symbolTipAnim, self.animateNode, -1)
                                    local pos = self:getCellPos(crPos[1], crPos[2])
                                    cell.symbolTipAnim:setPosition(pos)
                                end)

                )
        )
    end

end

function cls:addItemSpine(item, col, row, animateName, layerNode)
    local layer = layerNode or self.animateNode
    local animateName = animateName or "animation2"
    local pos = self:getCellPos(col, row)
    local spineFile = self:getPic("spine/item/" .. item .. "/spine")

    local cell = self.spinLayer.spins[col]:getRetCell(row)
    --cell:setVisible(false)
    local _, s1 = self:addSpineAnimation(layer, 22, spineFile, pos, animateName, nil, nil, nil, true, true)
end

function cls:getItemAnimate(item, col, row, effectStatus, parent)
    local spineItemsSet = Set({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 })

    if type(item) == "number" then
        item = (item) % 100
    end
    if item > 20 then
        self:playMultierWildAnimation(item, col, row)
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
        local cell = self.spinLayer.spins[col]:getRetCell(row)
        local realItem = cell.key
        local animateName = "animation"
        --local realItem = item
        if realItem == specialSymbol.wild or realItem == specialSymbol.bonus then
            animateName = "animation2"
        end

        local pos = self:getCellPos(col, row)
        local spineFile = self:getPic("spine/item/" .. realItem .. "/spine")
        local zorder = 100 + row

        local _, s1 = self:addSpineAnimation(self.animateNode, zorder, spineFile, pos, animateName, nil, nil, nil, true)

        self.animNodeList[col .. "_" .. row] = {}
        self.animNodeList[col .. "_" .. row][1] = s1
        self.animNodeList[col .. "_" .. row][2] = animateName

        local cell = self.spinLayer.spins[col]:getRetCell(row)
        cell:setVisible(false)
    else
        --local cell = self.spinLayer.spins[col]:getRetCell(row)
        --local realItem = cell.key
        --if realItem == specialSymbol.wild or realItem%100>=20 then
        --end
        self:playOldAnimation(col, row)

    end
end
function cls:playWildAppearAnimation(item, col, row)
    self.animNodeList = self.animNodeList or {}
    if not self.animNodeList[col .. "_" .. row] then
        local wildKey = specialSymbol.wild
        local aniName = "animation1"
        local aniName2 = "animation2"
        local aniName3 = "animation3"
        if item > 20 and wildMulti[item] then
            wildKey = specialSymbol.wild2
            local muti = wildMulti[item]
            aniName = "animation" .. muti .. "_2"
            aniName2 = "animation" .. muti
            aniName3 = "animation" .. muti .. "_3"
        end
        local pos = self:getCellPos(col, row)
        local spineFile = self:getPic("spine/item/" .. wildKey .. "/spine")
        local zorder = 100 + row
        local _, s1 = self:addSpineAnimation(self.animateNode, zorder, spineFile, pos, aniName, nil, nil, nil, true)
        self.animNodeList[col .. "_" .. row] = {}
        self.animNodeList[col .. "_" .. row][1] = s1
        self.animNodeList[col .. "_" .. row][2] = aniName2
        s1:runAction(cc.Sequence:create(
                cc.DelayTime:create(15 / 30),
                cc.CallFunc:create(
                        function()
                            bole.spChangeAnimation(s1, aniName3, true)
                        end
                )
        ))
    end
end
function cls:playMultierWildAnimation(item, col, row)
    self.animNodeList = self.animNodeList or {}
    if not self.animNodeList[col .. "_" .. row] then
        local wildKey = wildMulti[item]
        local animateName = "animation" .. wildKey

        local realItem = specialSymbol.wild2
        local pos = self:getCellPos(col, row)
        local spineFile = self:getPic("spine/item/" .. realItem .. "/spine")
        local zorder = 100 + row

        local _, s1 = self:addSpineAnimation(self.animateNode, zorder, spineFile, pos, animateName, nil, nil, nil, true)

        self.animNodeList[col .. "_" .. row] = {}
        self.animNodeList[col .. "_" .. row][1] = s1
        self.animNodeList[col .. "_" .. row][2] = animateName

        local cell = self.spinLayer.spins[col]:getRetCell(row)
        cell:setVisible(false)
    else
        self:playOldAnimation(col, row)
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
    local spineFile = SpineConfig["kuang"]
    self:addSpineAnimation(parent, nil, self:getPic(spineFile), cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
end
function cls:drawLinesThemeAnimate(lines, layer, rets, specials)
    local timeList = { 2, 2 }
    if self.showSpinBoard == SpinBoardType.MapFree then
        if self.mapFreeList[MapFreeType.RandomWilds] > 0 then
            self:stopAllRadomAction()
        end
    end
    Theme.drawLinesThemeAnimate(self, lines, layer, rets, specials, timeList)
end

function cls:playBonusItemAnimate(itemList)
    self:stopDrawAnimate()

end
function cls:playBonusAnimate(bonusData, finish)
    if not bonusData then
        return 0
    end
    -- 播放 bonus symbol 动画  同时 播放 开始弹窗
    self.ctl.footer:setSpinButtonState(true)
    AudioControl:stopGroupAudio("music")
    if not finish then
        self:playMusic(self.audio_list.bonus_trigger)
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
-------------------------------free spin -----------------------------------------------
function cls:enterThemeByFirstFreeSpin(ret, theFreeSpinData, endCallFunc)
    self.isCanFeatureClick = false
    ret["free_spins"] = theFreeSpinData.free_spins
    ret["free_spin_total"] = theFreeSpinData.free_spin_total
    ret["free_game"] = theFreeSpinData.free_game
    if not self.superAvgBet then
        self.ctl.specials = self:getSpecialTryResume(theFreeSpinData["item_list"])
    end
    self:lockLobbyBtn()
    self.ctl.spin_processing = true
    self.ctl.footer:setSpinButtonState(true)

    self.ctl.specials = self.ctl.freeSpeical

    local item_list = theFreeSpinData.item_list
    self.ctl:resetBoardCellsSprite(item_list)
    self.ctl:free_spins(ret)


end

function cls:enterFreeSpin(isResume)
    if isResume then
        self:dealMusic_PlayFreeSpinLoopMusic()
        if self.ctl.footer then
            self.ctl.footer:showActivitysNode()
        end
        if not self.superAvgBet then
            self:initNormalFreeBoard(true)
            self:isResumeFreeSpin()
        end
    elseif self.freeType <= 4 then
        if not self.superAvgBet then
            self:isResumeFreeSpin()
        end

    end
    self:showAllItem()
    self.playNormalLoopMusic = false
end

function cls:showFreeSpinNode(count, sumCount, first)
    local endScale = self.downNodeScale or 1
    self:enableMapInfoBtn(false)
    if not self.superAvgBet then
        self:changeSpinBoard(SpinBoardType.FreeSpin)--  更改棋盘显示 背景 和 free 显示类
        if self.ctl.footer then
            self.ctl.footer:showActivitysNode()
        end
        if self.normalFreeInfo and self.normalFreeInfo.freeBet then
            self.ctl:setPointBet(self.normalFreeInfo.freeBet)
        end
    else
        if endScale < 1 then
            endScale = 0.88
        end
        self:changeSpinBoard(SpinBoardType.MapFree)--  更改棋盘显示 背景 和 free 显示类
        self:initMapFreeBoard()
        self.down_node:setScale(endScale)
        self.ctl.footer:changeFreeSpinLayout3(false)
        self.ctl:setPointBet(self.superAvgBet)
    end
    Theme.showFreeSpinNode(self, count, sumCount, first)
end

function cls:hideFreeSpinNode(...)
    -- 进行出去freespin棋盘控制
    --------------------

    self.ctl.spin_processing = true
    self:changeSpinBoard(SpinBoardType.Normal)
    self.down_node:setScale(self.downNodeScale or 1)

    self.scatterLayer:removeAllChildren()
    self.themeBaseWin = nil
    if self.superAvgBet then
        self.superAvgBet = nil
        self.ctl.footer:changeNormalLayout2()
    else
    end
    self:updateBaseShowPointsCnt()
    Theme.hideFreeSpinNode(self, ...)
end

function cls:playBackBaseGameSpecialAnimation(theSpecials, enterType)
    if not enterType then
        if self.showSpinBoard == SpinBoardType.Normal then
            self:playFreeSpinItemAnimation(theSpecials) -- 返回base game的 时候不播放音乐

        end
    end
end
function cls:playFreeSpinItemAnimation(theSpecials, enterType)
    self:stopDrawAnimate()
    local delay = 2
    if not theSpecials or (not theSpecials[specialSymbol.trigger]) or bole.getTableCount(theSpecials[specialSymbol.trigger]) == 0 then
        return 0
    end --  更改 逻辑
    local freeWheel = self:getWheelData()
    if freeWheel and freeWheel[1] == 1 and freeWheel[2] == 0 then
        return 0
    end
    if enterType then
        self:playMusic(self.audio_list.trigger_bell)
    end
    if bole.getTableCount(theSpecials[specialSymbol.trigger]) == 3 then
        for col, rowTagList in pairs(theSpecials[specialSymbol.trigger]) do
            for row, tagValue in pairs(rowTagList) do
                self:addItemSpine(specialSymbol.trigger, col, row, "animation", self.animateNode)
            end
        end
    end
    return delay
end

function cls:resetPointBet()
    -- 仅仅在断线的时候 被调用了
    if self.superAvgBet then
        self.ctl:setPointBet(self.superAvgBet)-- 更改 锁定的bet
    end
end
--function cls:actionBeforeRollUp(rets)
--local winline = 0
--local delay = 0
--if self.showSpinBoard == SpinBoardType.FreeSpin then
--    if rets.win_pos_list then
--        winline = #rets.win_pos_list
--    end
--    if winline > 0 then
--        --delay = 2
--        local freeB/aseWin = self.freeBaseWin + self.freePrizeWin
--        self:updateNormalFreeCoins(freeBaseWin, self.freePrizeWin)
--    end
--end
--return delay
--end
------------------------------------- on theminfo  part start------------------------------

function cls:after_win_show()
    self.ctl.rets = self.ctl.rets or {}
    self.ctl.rets.after_win_show = nil
    if self.showSpinBoard == SpinBoardType.FreeSpin then
        local endIndex = self.ctl.sumFreeSpinCnt - self.ctl.freespin
        local endCallBack = function()
            self:onNormalFreeGray(endIndex, true)
            self.ctl:handleResult()
        end
        if self.freeType <= 2 then
            endCallBack()
        else
            local endIndex = self.ctl.sumFreeSpinCnt - self.ctl.freespin
            local muti = self.normalFreeInfo.line_multi_list[endIndex]
            if muti > 1 and self.freeBaseWin > 0 then
                local addWin = self.freeBaseWin * (muti - 1)
                local winCoins = self.ctl.totalWin + addWin
                local beforeCoins = self.ctl.totalWin
                self:winCoinsMultiAction(endIndex)
                self:changeKuangState(endIndex, 1)
                self:laterCallBack(0.5, function()
                    self:footerNormalFreeWinCoins(beforeCoins, addWin, endCallBack)
                end)
            else
                endCallBack()
            end

        end
    else
        self.ctl:handleResult()
    end


end

function cls:onThemeInfo(ret, callFunc)
    local themeInfo = ret["theme_info"]
    local themeInfoAnimList = {}
    if self.showSpinBoard < SpinBoardType.MapFree then
        if themeInfo.theme_map and themeInfo.theme_map.credits and themeInfo.theme_map.credits ~= self.themeMapPoints then
            self.cookieCount = themeInfo.theme_map.credits - self.themeMapPoints
            self.themeMapPoints = themeInfo.theme_map.credits
            self:flyMapPointsAction(themeInfoAnimList)
        end
    end
    if self.showSpinBoard == SpinBoardType.Normal then
        if ret.free_game and ret.free_game then
            self.freeType = ret.free_game.fg_type
            self.normalFreeInfo = {}
            self.normalFreeInfo.line_multi_list = ret["free_game"].line_multi_list
            if not self.normalFreeInfo.line_multi_list then
                self.normalFreeInfo.line_multi_list = LineMutliConfig[self.freeType]
            end
            self.normalFreeInfo.per_spin_win = ret["free_game"].per_spin_win
        end
    end
    if self.showSpinBoard == SpinBoardType.FreeSpin then
        --self:updateFreeWinInfo(ret, themeInfoAnimList)
        self.freeBaseWin = ret.base_win or 0
        self.freePrizeWin = 0
        self.normalFreeInfo.per_spin_win = themeInfo.per_spin_win
        if self.freeType == FreeBoardType.Prize then
            self:showCoinSymbol(ret, themeInfoAnimList)
        end
        ret.base_win = ret.base_win + self.freePrizeWin
        --if ret.base_win > 0 then
        --self.ctl.rets.setWinCoins = nil
        --end
        --self:winLineDrawAnimation(ret, themeInfoAnimList)
        self.ctl.rets.after_win_show = 1
    end
    if self.showSpinBoard == SpinBoardType.MapFree then
        self:mapFreeStopAnimation(ret, themeInfoAnimList)
    end
    if #themeInfoAnimList > 0 then
        self.ctl.footer:setSpinButtonState(true)
        local l3 = cc.CallFunc:create(function(...)
            self:dealMusic_FadeLoopMusic(0.3, 0.3, 1)-- 恢复背景音乐
        end)
        table.insert(themeInfoAnimList, l3)
        local l4 = cc.DelayTime:create(0.1)
        table.insert(themeInfoAnimList, l4)
        local l5 = cc.CallFunc:create(function(...)
            callFunc()
        end)
        table.insert(themeInfoAnimList, l5)
        -- 降低背景音乐
        self:dealMusic_FadeLoopMusic(0.3, 1, 0.3)
        self:runAction(cc.Sequence:create(bole.unpack(themeInfoAnimList)))
    else
        callFunc()
    end
end
------------------------------------- on theminfo  part end------------------------------
function cls:saveBonusData(tryResume)
    if self.ctl.rets then
        self.ctl.bonusItem = tool.tableClone(self.ctl.rets.item_list)
        self.ctl.bonusRet = self.ctl.rets
        self.bonusSpeical = self.ctl.specials
    end
end
function cls:outBonusStage()

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


---------------------------------------------------------------------------------------------------
-- 进入不同 freature 相关
------------------------------------------------------------------------------------------------------------


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
            local ani_name = item.aniname or "animation"
            local size = btnNode:getContentSize()
            local _, s = bole.addSpineAnimation(btnNode, nil, self:getPic(item.name), cc.p(size.width / 2, size.height / 2), ani_name, nil, nil, nil, true, true)
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
                    local img_name = string.format(item.name, theData[key])
                    bole.updateSpriteWithFile(myParent, img_name)
                else
                    local ani_name = item.aniname or "animation"

                    if item.formatname then
                        ani_name = string.format(ani_name, theData[key])
                    end
                    if item.startAction then
                        local _, s = self:addSpineAnimation(myParent, item.zorder, self:getPic(item.name), cc.p(x, y), item.startAction[1], nil, nil, nil, true, item.startAction[2])
                        if item.startAction[3] then
                            local delayItem = item
                            myParent:runAction(cc.Sequence:create(
                                    cc.DelayTime:create(delayItem.startAction[3]),
                                    cc.CallFunc:create(function()
                                        bole.spChangeAnimation(s, delayItem.delayAction[1], delayItem.delayAction[2])
                                    end)
                            ))
                        end

                    else
                        local _, s = self:addSpineAnimation(myParent, item.zorder, self:getPic(item.name), cc.p(x, y), ani_name, nil, nil, nil, true, not item.notcycle)

                    end
                end
            end
        end
    end

end
function cls:addDialogSpine(node, theData, sType)

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
function cls:freeLastSpinDialog()
    self:dealMusic_FadeLoopMusic(0.3, 1, 0.5)
    self:playMusic(self.audio_list.dialog_lastspin)
    local lastSpinCsbPath = self:getPic("csb/dialog_4.csb")
    local lastSpinNode = cc.CSLoader:createNode(lastSpinCsbPath)

    local node_root = lastSpinNode:getChildByName("root")
    local node_start = node_root:getChildByName("node_start")
    local bg = node_start:getChildByName("bg")
    local spinConfig = SpineDialogConfig[4][1]

    local colorIndex = NormalFreeConfig[self.freeType].color
    local img = string.format(spinConfig.bg.name, colorIndex)
    self.dialogNode:addChild(lastSpinNode)
    bole.updateSpriteWithFile(bg, img)
    lastSpinNode:setPosition(cc.p(0, -600))
    local a1 = cc.MoveTo:create(0.4, cc.p(0, -270))
    local a2 = cc.MoveTo:create(0.4, cc.p(0, -320))

    local a3 = cc.DelayTime:create(0.1)

    lastSpinNode:runAction(
            cc.Sequence:create(
                    cc.Repeat:create(cc.Sequence:create(a1, a2, a3), 2),
                    cc.CallFunc:create(
                            function()
                                self:dealMusic_FadeLoopMusic(0.3, 1, 1)
                                self:setImgMaskStatus(false, true)
                            end
                    ),
                    cc.MoveTo:create(0.3, cc.p(0, -600)),
                    cc.RemoveSelf:create()
            )
    )

    self:setImgMaskStatus(true, true)
end

function cls:showFreeSpinDialog(theData, sType, gType)
    self.collectFreeStatus = sType
    gType = gType or "free"
    local config = {}
    config["gen_path"] = self:getPic("csb/")
    config["csb_file"] = config["gen_path"] .. "dialog_" .. theData.type .. ".csb"
    config["frame_config"] = {
        --["start"] = { { 0, 60 }, 1, { 90, 120 }, 0.5, transitionDelay[gType].onCover, (transitionDelay[gType].onEnd - transitionDelay[gType].onCover), 0.5 },
        --["more"] = { { 0, 60 }, 3, { 90, 120 }, 0.3, 0, 0, 0.5 },
        ["collect"] = { { 0, 15 }, 1, { 90, 120 }, 0.6, transitionDelay[gType].onCover, (transitionDelay[gType].onEnd - transitionDelay[gType].onCover), 0 } -- 最后一个参数 是延时删除的时间 -- 倒数第二个参数 回调 完成方法

    }
    --theData.coins = 0
    self.freeSpinConfig = config
    local theDialog = CleopatraDialog.new(self.ctl, self.freeSpinConfig)
    if sType == fs_show_type.collect then
        if SpineDialogConfig[theData.type] and SpineDialogConfig[theData.type][sType] then
            local width = SpineDialogConfig[theData.type][sType].maxWidth
            theDialog:setCollectScaleByValue(theData.coins, width)
        end
        theDialog:showCollect(theData, nil, self.dialogNode)
        theDialog:setPosition(cc.p(0, -800.00))
        theDialog:runAction(
                cc.Sequence:create(
                        cc.MoveTo:create(0.3, cc.p(0, -291.00)),
                        cc.CallFunc:create(function()
                            theDialog:updateWinCoinList()
                        end)
                )
        )

        self:addDialogSpine(theDialog, theData, sType, gType)
        self:setImgMaskStatus(true, true)
    end
    self.freeDialogNode = theDialog
end
function cls:showMapFreeSpinDialog(theData, sType, gType)
    self.collectFreeStatus = sType
    gType = gType or "free"
    local config = {}
    config["gen_path"] = self:getPic("csb/")
    config["csb_file"] = config["gen_path"] .. "dialog_" .. theData.type .. ".csb"
    config["frame_config"] = {
        --["start"] = { { 0, 60 }, 1, { 90, 120 }, 0.5, transitionDelay[gType].onCover, (transitionDelay[gType].onEnd - transitionDelay[gType].onCover), 0.5 },
        --["more"] = { { 0, 60 }, 3, { 90, 120 }, 0.3, 0, 0, 0.5 },
        ["collect"] = { { 0, 45 }, 1, { 90, 135 }, 45 / 60, transitionDelay[gType].onCover, (transitionDelay[gType].onEnd - transitionDelay[gType].onCover), 0 } -- 最后一个参数 是延时删除的时间 -- 倒数第二个参数 回调 完成方法

    }
    self.freeSpinConfig = config
    local theDialog = G_FREE_SPIN_DIALOGS["base"].new(self.ctl, self.freeSpinConfig)
    if sType == fs_show_type.start then
        theDialog:showStart(theData)
        self:addDialogSpine(theDialog, theData, sType, gType)
    elseif sType == fs_show_type.more then
        theDialog:showMore(theData)
        self:stopMusic(self.audio_list.trigger_bell, true)
        self:addDialogSpine(theDialog, theData, sType, gType)
    elseif sType == fs_show_type.collect then
        if SpineDialogConfig[theData.type] and SpineDialogConfig[theData.type][sType] then
            local width = SpineDialogConfig[theData.type][sType].maxWidth
            theDialog:setCollectScaleByValue(theData.coins, width)
        end
        theDialog:showCollect(theData)
        self:addDialogSpine(theDialog, theData, sType, gType)
    end
    self.collectFreeStatus = true
    self.mapFreeSpinDialog = theDialog
end
function cls:playStartFreeSpinDialog(theData)


    if self.superAvgBet then
        self:enterMapFreeGameDialog(theData)
    else
        self:enterNormalFreeGameDialog(theData)
    end
end
function cls:enterNormalFreeGameDialog(theData)
    local wheelinfo = self:getWheelFreeData()
    if self.ctl.footer then
        self.ctl.footer:hideActivitysNode()
        self.ctl.footer:hideBoosterDimmer()
    end
    --self.themeBaseWin = self.themeBaseWin or self.ctl.totalWin
    --self.themeBaseWin = self.themeBaseWin or 0

    self.normalFreeData = theData
    if not wheelinfo or wheelinfo[1] == 0 then
        self:enterWheelGame()
    else
        if wheelinfo[2] == 0 then
            --self:dealMusic_PlayFreeSpinLoopMusic()
            self:playNormalFreeGame(false)
        else
            self:playNormalFreeGame(true)
            self:playStartNormalFreeGame()
        end

    end
end
function cls:playStartNormalFreeGame(theData)
    theData = theData or self.normalFreeData
    self.normalFreeData = nil
    if theData then
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
    if not self.superAvgBet then
        self.ctl.footer:showActivitysNode()
    end
    self:dealMusic_PlayFreeSpinLoopMusic()
end
function cls:getWheelFreeData()
    local data = self:getWheelData(2)
    return data

end
function cls:setWheelFreeData(data)
    self:saveWheelData(2, data)

end
function cls:playNormalFreeGame(showOther)


    self:changeSpinBoard(SpinBoardType.FreeSpin)

    self:initNormalFreeBoard(showOther)

    self:initNormalFreeType()
    local sum = self.ctl.sumFreeSpinCnt
    local cur = self.ctl.freespin

    if not showOther then
        Theme.showFreeSpinNode(self, cur, sum, true)
    end

end
function cls:enterMapFreeGameDialog(theData)

    self:playStartNormalFreeGame(theData)
end
function cls:enterWheelGame()

    local data = {}
    data.win_index = self.freeType
    local callback = function()
        self:playNormalFreeGame()
    end
    self.ctl.footer:setSpinButtonState(true) -- 开启 footer按钮
    self.ctl.footer:enableOtherBtns(false)
    self.PickDialog = CleopatraPick.new(self, self:getPic("csb/"), data, callback, 2, false)
    self.PickDialog:enterPickGame(false)

end
function cls:onCollectFreeClick(theData)
    if not self.collectFreeStatus then
        return
    end
    self.collectFreeStatus = false
    local transName = "free"
    if self.superAvgBet then
        transName = "map"
    end

    if self.mapFreeSpinDialog and bole.isValidNode(self.mapFreeSpinDialog) then
        self.collectFreeStatus = nil
        self:playTransition(nil, transName)
    end

end
function cls:freeStartClicked(callFunc, isMore)

    local free_type = "free"
    local action = cc.Sequence:create(
            cc.DelayTime:create(transitionDelay[free_type].onEnd - transitionDelay[free_type].onCover),
            cc.CallFunc:create(function(...)
                if callFunc then
                    callFunc()
                end
            end))
    libUI.runAction(self, action)
end

function cls:playMoreFreeSpinDialog(theData)

    local enter_event = theData.enter_event
    local end_event = theData.end_event
    local click_event = theData.click_event
    --enter_event()
    end_event()
    click_event()
end

function cls:playCollectFreeSpinDialog(theData)
    if self.ctl.footer then
        self.ctl.footer:hideActivitysNode()
    end
    local free_type = "free"
    if self.superAvgBet then
        free_type = "map"
    end
    local click_event = theData.click_event
    local end_event = theData.end_event
    theData.end_event = function()
        if end_event then
            end_event()
        end
        if self.ctl.footer then
            self.ctl.footer:showActivitysNode()
        end
    end

    if self.superAvgBet then
        theData.type = 1
        theData.click_event = function()
            self:playMusic(self.audio_list.btn_click)
            if click_event then
                click_event()
            end
        end
        self:showMapFreeSpinDialog(theData, fs_show_type.collect, free_type)
    else
        --self.ctl.freewin = self:getFreeSpinWin() + self.themeBaseWin
        theData.type = 3
        local showColor = self.freeType or 1
        if self.freeType == FreeBoardType.Prize then
            showColor = 4
        elseif self.freeType == FreeBoardType.Wins then
            showColor = 1
        end
        theData.title = showColor
        theData.bg = showColor
        theData.click_event = function()
            self.ctl.rets = self.ctl.rets or {}
            if click_event then
                click_event()
            end
            self:setWheelFreeData(nil)
            if self.freeDialogNode and bole.isValidNode(self.freeDialogNode) then
                self.freeDialogNode:runAction(
                        cc.Sequence:create(
                                cc.DelayTime:create(0.2),
                                cc.CallFunc:create(function()
                                    self:setImgMaskStatus(false, true)
                                    self:playTransition(nil, free_type)
                                end),
                                cc.MoveTo:create(0.3, cc.p(0, -800))
                        )
                )
            end
        end

        self:playMusic(self.audio_list.free_finish)
        --self:laterCallBack(2, function()
        self:showFreeSpinDialog(theData, fs_show_type.collect, free_type)
        --end)

    end
end
function cls:getFreeSpinWin()
    local winList = self.normalFreeInfo.per_spin_win

    local winCoin = 0
    for key = 1, 7 do
        if winList[key] and winList[key] > 0 then
            winCoin = winCoin + winList[key]
        end
    end
    return winCoin
end

----------------------------------- normal free start-----------------------------------
function cls:initNormalFree()
    local mapFreeNode = self.mapFreeNode
end
---
function cls:normalFreeSpinStart(stopCallFun)

    local delayStop = 0
    if self.ctl.freespin == 0 then
        delayStop = 2
    end

    if self.freeType == FreeBoardType.Wilds then
        local spend = 3
        self:normalFreeFallWild(spend)

        if delayStop > 0 then
            local delay2 = spend + delayStop
            self:laterCallBack(spend, function()
                self:freeLastSpinDialog()
            end)
            self:laterCallBack(delay2, function()
                stopCallFun()
            end)
        else
            self:laterCallBack(2, function()
                stopCallFun()
            end)
        end

    else
        if delayStop > 0 then
            self:freeLastSpinDialog()
            self:laterCallBack(delayStop, function()
                stopCallFun()
            end)
        else
            stopCallFun()
        end

    end
end
function cls:showCoinSymbol(ret, themeInfoAnimList)

    local item_list = ret.item_list
    local bonus_list = {}
    for col = 1, 5 do
        for row = 1, G_cellRow do

            if item_list[col][row] % 100 == specialSymbol.bonus then
                table.insert(bonus_list, { col, row })
            end
        end
    end
    if #bonus_list > 0 then

        local endIndex = self.ctl.sumFreeSpinCnt - self.ctl.freespin
        local singleCoin = self.ctl:getCurBet() * endIndex
        self.freePrizeWin = #bonus_list * singleCoin
        local delayTm = #bonus_list * 1.5
        self:changeKuangState(endIndex, 2)
        local _7prizeAction = function()
            for key = 1, #bonus_list do
                local item = bonus_list[key]

                self:flyCoinsToTopHeader(item, key, singleCoin)
            end
        end
        local a1 = cc.CallFunc:create(_7prizeAction)
        table.insert(themeInfoAnimList, a1)
        local a2 = cc.DelayTime:create(delayTm)

        table.insert(themeInfoAnimList, a2)
        local a3 = cc.CallFunc:create(function()
            self:changeKuangState(endIndex, 1)
        end)

        table.insert(themeInfoAnimList, a3)
    end
end
function cls:create7PrizeLabel(parentNode, singleCoin)
    local file = "font/186_font2.fnt"
    local str = FONTS.formatByCount4(singleCoin, 4, true)
    local fntNode = cc.Label:createWithBMFont(self:getPic(file), str)
    bole.shrinkLabel(fntNode, G_cellWidth, 0.8)
    parentNode:addChild(fntNode)
    return fntNode

end
function cls:updatePrizeBoardCell(flyItem, singleCoin)

    local cell = self.spinLayer.spins[flyItem[1]]:getRetCell(flyItem[2])
    local font = self:create7PrizeLabel(cell, singleCoin)
    font:setPosition(cc.p(0, -10))
    cell.font = font
end

function cls:flyCoinsToTopHeader(flyItem, index, singleCoin)


    local endIndex = self.ctl.sumFreeSpinCnt - self.ctl.freespin

    local delatTm = (index - 1) * 1.5
    local delay1 = cc.DelayTime:create(delatTm)

    local beforeCoins = (index - 1) * self.ctl:getCurBet() * endIndex
    local winCoins = index * self.ctl:getCurBet() * endIndex

    --local a2 = cc.CallFunc:create(
    local show7Prize = function()
        --self:playMusic(self.audio_list.bonus_num1)
        local fntNode = self:create7PrizeLabel(self.animateNode, singleCoin)
        fntNode:setLocalZOrder(200)
        local pos = self:getCellPos(flyItem[1], flyItem[2])
        pos = cc.pAdd(pos, cc.p(0, -10))
        fntNode:setPosition(pos)
        local endScale = fntNode:getScale()
        fntNode:setScale(0)
        fntNode:runAction(
                cc.Sequence:create(
                        cc.ScaleTo:create(0.3, endScale * 1.2),
                        cc.ScaleTo:create(0.1, endScale)
                )
        )
        self:updatePrizeBoardCell(flyItem, singleCoin)
        self:playItemAnimation(specialSymbol.bonus, flyItem[1], flyItem[2])
    end
    --)
    local a3 = cc.DelayTime:create(0.5)
    local a4 = cc.CallFunc:create(
            function()
                self:playMusic(self.audio_list.bonus_num)
                local splist = cc.ParticleSystemQuad:create(self:getPic(SpineConfig["collect_free_1"]))
                self.bonusflyNode:addChild(splist)
                local startPos = self:getCellPos(flyItem[1], flyItem[2])
                local endNPos = self:getNormalFreeFont1Pos(endIndex)
                splist:setPosition(endNPos)
                splist:runAction(
                        cc.Sequence:create(
                                cc.MoveTo:create(0.3, startPos),
                                cc.CallFunc:create(
                                        function()
                                            show7Prize()
                                            --self:updateNormalFreeCoins2(winCoins, beforeCoins, endIndex)
                                        end
                                ),
                                cc.DelayTime:create(5 / 30),
                                cc.RemoveSelf:create()
                        )
                )
            end
    )
    self:runAction(cc.Sequence:create(delay1, a3, a4))


end
function cls:getNormalFreeItemPos(endIndex)
    local item_list = self.normalFreeTop:getChildByName("node_base")
    local itemCell = item_list:getChildByName("item_" .. endIndex)
    local endWPos = bole.getWorldPos(itemCell)
    local endNPos = bole.getNodePos(self.bonusflyNode, endWPos)
    return endNPos
end
function cls:getNormalFreeFont1Pos(endIndex)
    local item_list = self.normalFreeTop:getChildByName("node_base")
    local itemCell = item_list:getChildByName("item_" .. endIndex)
    local font_1 = itemCell.font_1
    local endWPos = bole.getWorldPos(font_1)
    local endNPos = bole.getNodePos(self.bonusflyNode, endWPos)
    return endNPos
end

function cls:initNormalFreeBoard(showLast3)

    --sss   self.freeTopRoot
    local endScale = self.downNodeScale or 1
    if endScale < 1 then
        endScale = 0.88
    end

    self.down_node:setScale(endScale)
    --self.ctl.footer:reSetWinCoinsString(0)
    self.freeTopRoot:removeAllChildren()
    local csb = string.format(allCsbList.free_node, self.freeType)
    self.normalFreeTop = cc.CSLoader:createNode(self:getPic(csb))--  加载 商店显示
    self.freeTopRoot:addChild(self.normalFreeTop)
    --self.freeTopRoot:setPosition(cc.p(0, 0))
    local item_list = self.normalFreeTop:getChildByName("node_base")
    for key = 1, 7 do
        local itemCell = item_list:getChildByName("item_" .. key)
        local child_node = itemCell:getChildByName("root")
        itemCell.root = child_node

        for childIndex, childItem in pairs(NormalFreeConfig[self.freeType]) do

            if type(childItem) == "number" then

            elseif childItem.type == "spine" then

            else
                local item_key = childIndex
                local cell_key = child_node:getChildByName(item_key)
                itemCell[item_key] = cell_key
                if childItem.type == "img" then
                    local key2
                    if item_key == "index" then
                        key2 = string.format(childItem.res, self.normalFreeInfo.line_multi_list[key])
                        if self.freeType >= 3 and key > childItem.maxShow then
                            cell_key:setVisible(showLast3)
                        end
                        bole.updateSpriteWithFile(cell_key, key2)
                    end
                    if item_key == "img_spin_index" then
                        local key2 = string.format(childItem.res, key)
                        bole.updateSpriteWithFile(cell_key, key2)
                    end
                    if item_key == "img_mask" then
                        cell_key:setVisible(false)
                    end

                elseif childItem.type == "fnt" then
                    cell_key:setString("")
                    cell_key.maxCount = childItem.maxCount
                    cell_key.baseScale = childItem.baseScale
                    cell_key.maxWidth = childItem.maxWidth
                    if item_key == "font_1" then
                        local win = self.ctl:getCurBet() * key
                        local value_str = FONTS.formatByCount4(win, cell_key.maxCount, true)
                        cell_key:setString(value_str)
                        bole.shrinkLabel(cell_key, cell_key.maxWidth, cell_key.baseScale)
                    end
                end
            end
        end
    end
    self:refreshFreeCollectNode()
end
--- 从弹窗上飞上去的symbol
function cls:refreshNormalTopList(fg_type)
    local maxShow = NormalFreeConfig[fg_type].index.maxShow
    --self:freeItemAppear(7)
    local index = 1
    for key = maxShow + 1, 7 do
        self:freeItemAppear(key, true, index)
        index = index + 1
    end
end
function cls:freeItemAppear(fg_index, isAni, delayTm)
    local item_list = self.normalFreeTop:getChildByName("node_base")
    local itemCell = item_list:getChildByName("item_" .. fg_index)
    local indexNode = itemCell.index
    indexNode:setVisible(true)
    if isAni then
        indexNode:setScale(0)
        indexNode:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(delayTm * 0.2),
                --cc.CallFunc:create(function()
                --    --self:playMusic(self.audio_list.fg_mul)
                --end),
                        cc.ScaleTo:create(0.2, 1.2),
                        cc.ScaleTo:create(0.1, 1)
                )
        )
    else
        indexNode:setScale(1)
    end
end
function cls:initNormalFreeType()
    --local csb = string.format(allCsbList.free_dialog, self.freeType)
    self.dialogNode:removeAllChildren()
    local theData = {}
    theData.type = self.freeType

    theData.fg_muti = self.normalFreeInfo.line_multi_list[7]

    local config = {}
    config["gen_path"] = self:getPic("csb/")
    config["csb_file"] = config["gen_path"] .. "dialog_free_" .. theData.type .. ".csb"
    config["frame_config"] = {
        ["start"] = { { 0, 45 }, 1, { 90, 120 }, 0, 0.5, 1, 0.5 },
    }
    theData.click_event = function()

    end
    theData.changeLayer_event = function()

        if self.freeType >= 3 then
            self:refreshNormalTopList(self.freeType)
        end

    end
    theData.end_event = function()
        self:playStartNormalFreeGame()
    end
    local theDialog = CleopatraDialog.new(self.ctl, config)
    theDialog:showStart(theData, nil, self.dialogNode)
    self.freeDialog = theDialog
end

function cls:isResumeFreeSpin()
    local endIndex = self.ctl.sumFreeSpinCnt - self.ctl.freespin
    for key = 1, 7 do
        self:onNormalFreeGray(key, endIndex >= key)

    end

end
function cls:footerNormalFreeWinCoins(before, addCoin, endCallFunc)
    local winCoins = addCoin
    local totalBet = self.ctl:getCurBet()
    self.ctl:startRollup(winCoins, endCallFunc, totalBet)
end
function cls:winCoinsMultiAction(endIndex)
    self:clearAnimate()
    self:changeKuangState(endIndex, 2)
    self:playMusic(self.audio_list.fg_mul_fly)
    local spineMulti = self.bonusflyNode:getChildByName("ani" .. endIndex)
    if spineMulti and bole.isValidNode(spineMulti) then
        local endWPos = bole.getWorldPos(self.ctl.footer.coinNode)
        local endNPos = bole.getNodePos(self.flyTranslatesLayer, endWPos)

        local startWStart = bole.getWorldPos(spineMulti)
        local startNStart = bole.getNodePos(self.flyTranslatesLayer, startWStart)

        bole.changeParent(spineMulti, self.flyTranslatesLayer)
        local liifile = self:getPic(SpineConfig.multi_fly_footer)
        local lizi = cc.ParticleSystemQuad:create(liifile)

        spineMulti:addChild(lizi, -1)
        spineMulti:setPosition(startNStart)
        spineMulti:runAction(
                cc.Sequence:create(
                        cc.MoveTo:create(0.5, endNPos),
                        cc.ScaleTo:create(0.2, 0),
                        cc.RemoveSelf:create()
                )
        )

    end

    local item_list = self.normalFreeTop:getChildByName("node_base")
    local itemCell = item_list:getChildByName("item_" .. endIndex)
    if itemCell.index then
        itemCell.index:setVisible(true)
    end

end
---@param status 1 normal 2 strong
function cls:changeKuangState(endIndex, status)
    local spineKuang = self.bonusflyNode:getChildByName("ani_kuang" .. endIndex)
    if spineKuang and bole.isValidNode(spineKuang) then
        local aniName = "animation2"
        if status == 2 then
            aniName = "animation1"
        end
        bole.spChangeAnimation(spineKuang, aniName, true)
    end
end
function cls:onNormalNextStart(endIndex)
    local item_list = self.normalFreeTop:getChildByName("node_base")
    local itemCell = item_list:getChildByName("item_" .. endIndex)
    --local itemCellRoot = itemCell:getChildByName("root")
    --local spineBg = itemCellRoot:getChildByName("spine")


    self:laterCallBack(0.2, function()
        if itemCell.index then
            itemCell.index:setVisible(false)
        end

    end
    )
    local config = NormalFreeConfig[self.freeType].index1
    local ends = self.normalFreeInfo.line_multi_list[endIndex]
    local aniName = "animation" .. ends

    local aniNode = self.bonusflyNode:getChildByName("ani" .. endIndex)
    if aniNode and bole.isValidNode(aniNode) then
        bole.spChangeAnimation(aniNode, aniName, true)
        return
    end
    if config then
        local pos = config.pos or cc.p(0, 0)
        local endPos = self:getNormalFreeItemPos(endIndex)
        local endPos = cc.pAdd(endPos, pos)
        local _, s1 = bole.addSpineAnimation(self.bonusflyNode, 1, self:getPic(config.res), endPos, aniName, nil, nil, nil, true, true)
        s1:setName("ani" .. endIndex)
    end
    local aniName2 = "animation1"
    local endPos1 = self:getNormalFreeItemPos(endIndex)
    local _, s1 = bole.addSpineAnimation(self.bonusflyNode, 1, self:getPic(SpineConfig.free_item), endPos1, aniName2, nil, nil, nil, true, true)
    s1:setName("ani_kuang" .. endIndex)
    self:playMusic(self.audio_list.free_kuang)
end

function cls:onNormalFreeGray(endIndex, isShow)
    --
    local item_list = self.normalFreeTop:getChildByName("node_base")
    local itemCell = item_list:getChildByName("item_" .. endIndex)
    --local itemCellRoot = itemCell:getChildByName("root")
    --if self.freeType == FreeBoardType.Prize or self.freeType == FreeBoardType.Wilds then
    --
    --    local static_img = itemCellRoot:getChildByName("img_spin")
    --    bole.setGray(static_img)
    --end
    ----local spine = itemCellRoot:getChildByName("spine")
    ----spine:removeAllChildren()
    local spineNode = self.bonusflyNode:getChildByName("ani" .. endIndex)
    if spineNode and bole.isValidNode(spineNode) then
        spineNode:removeFromParent()
    end
    local spineKuang = self.bonusflyNode:getChildByName("ani_kuang" .. endIndex)
    if spineKuang and bole.isValidNode(spineKuang) then
        spineKuang:removeFromParent()
    end
    if itemCell.index then
        itemCell.index:setVisible(true)
    end
    --
    --bole.setGray(itemCell.index)
    --if self.freeType == FreeBoardType.Prize then
    --    bole.setGray(itemCell.font_1:getVirtualRenderer(), false, true)
    --end
    itemCell.img_mask:setVisible(isShow)

end
function cls:normalFreeFallWild(totalTm)

    self:setImgMaskStatus(true, true)

    self:fallAddedWilds()
    self:laterCallBack(totalTm, function()
        self:setImgMaskStatus(false, true)

    end)
end
function cls:fallAddedWilds()
    self:playMusic(self.audio_list.wild_out)

    local endIndex = self.ctl.sumFreeSpinCnt - self.ctl.freespin
    local startPos = self:getNormalFreeItemPos(endIndex)
    self:changeKuangState(endIndex, 2)
    for key = 1, 7 do
        local myindex = key
        local endCol = math.random(1, 4)
        local endRow = math.random(1, 4)
        self:fallAddWildAction(myindex, startPos, endCol, endRow)
    end
    self:laterCallBack(2, function()
        self:changeKuangState(endIndex, 1)
    end)
end
function cls:fallAddWildAction(myindex, startPos, endCol, endRow)

    local endPos = self:getCellPos(endCol, endRow)
    --local endRow1 = 4
    endPos.x = endPos.x + G_cellWidth / 2
    --local endPos1 = self:getCellPos(endCol, endRow1)
    local receiveWild = function()
        local _, s1 = bole.addSpineAnimation(self.bonusflyNode, 100, self:getPic(SpineConfig.free_wilds_add), endPos, "animation")-- 出现
    end
    local function myBezier(from, to, duration)
        --local sy = math.abs(to.y - from.y)
        --local sx = to.x - from.x
        --local bezier = {
        --    cc.p(to.x - (sx * math.random(7, 8) / 10), (from.y + 80)),
        --    cc.p(to.x - (sx * math.random(3, 4) / 10), from.y * math.random(7, 11) / 10),
        --    to
        --}
        --local bezier = cc.BezierTo:create(duration, bezier)


        local sx = to.x - from.x
        local sy = to.y - from.y

        local degreen = 90 / 180.0 * math.pi;
        local Height = 0
        -- 第一个控制点为抛物线左半弧的中点
        local q1x = from.x + sx / 4.0;
        local q1 = cc.p(q1x, Height + from.y + math.cos(degreen) * q1x);
        -- 第二个控制点为整个抛物线的中点
        local q2x = from.x + sx / 2
        local q2 = cc.p(q2x, Height + from.y + math.cos(degreen) * q2x);

        local dd = 0.5
        local bezierpos = { q1, q2, to }
        local bezier = cc.BezierTo:create(duration, bezierpos)
        return bezier
    end
    local fallWild = function()
        --local img = bole.createSpriteWithFile("#theme186_s_1.png")
        local zorder = 100 + myindex
        local _, s1 = bole.addSpineAnimation(self.bonusflyNode, zorder, self:getPic(SpineConfig.free_wild_fly), endPos, "animation", nil, nil, nil, true, false)-- 出现

        --self.animateNode:addChild(img)
        s1:setPosition(startPos)
        --img:setScale(0)
        local bezier = myBezier(startPos, endPos, 30 / 30)
        s1:runAction(cc.EaseInOut:create(bezier, 30 / 30))
        --cc.Sequence:create(

        --cc.DelayTime:create(15 / 30),
        --cc.CallFunc:create(
        --        function()
        --            bole.spChangeAnimation(s1, "animation_1", false)
        --        end),
        --       ,


        --cc.DelayTime:create(15 / 30),
        --,
        --        cc.RemoveSelf:create()
        --)

        --s1:setScale(0.5)
        s1:runAction(
                cc.Sequence:create(
                --cc.ScaleTo:create(0.3, 1.2),
                --cc.ScaleTo:create(0.2, 1),
                --cc.Spawn:create(
                --cc.ScaleTo:create(0.5, 0),
                --        cc.MoveTo:create(0.4, endPos1),
                --),
                        cc.DelayTime:create(15 / 30),
                        cc.CallFunc:create(
                                function()
                                    bole.spChangeAnimation(s1, "animation_1", false)
                                end),
                        cc.DelayTime:create(15 / 30),
                        cc.CallFunc:create(receiveWild),
                        cc.RemoveSelf:create()
                )
        )
    end
    self:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(myindex * 0.3),
                    cc.CallFunc:create(fallWild)
            --cc.DelayTime:create(0.8),
            --cc.CallFunc:create(receiveWild)
            )
    )

end
----------------------------------- normal free end-----------------------------------
----------------------------------- map free start -----------------------------------
function cls:initMapFree()
    local mapFreeNode = self.mapFreeNode
end

function cls:initMapFreeBoard()
    local fg_index = self.mapFreeIndex
    if fg_index < 7 then
        self.descMapFree1:setVisible(true)
        self.descMapFree2:setVisible(false)
        local showCont = self.mapFreeList[fg_index]
        self:updateDescMap(self.descMapFree1, fg_index, showCont, fg_index)

    else
        self.descMapFree1:setVisible(false)
        self.descMapFree2:setVisible(true)
        local fg1 = mapFreeConfig[fg_index][1]
        local fg2 = mapFreeConfig[fg_index][2]
        local chosen1 = self.descMapFree2:getChildByName("chosen1")
        local chosen2 = self.descMapFree2:getChildByName("chosen2")
        self:updateDescMap(chosen1, fg1, self.mapFreeList[fg1], fg_index)
        self:updateDescMap(chosen2, fg2, self.mapFreeList[fg2], fg_index)
    end
    if self.mapFreeList[MapFreeType.StickyWilds] > 0 then
        self:playStickWilds()
    end

end
function cls:mapFreeSpinStart(stopRet, stopCallFun)
    if self.mapFreeList and self.mapFreeList[MapFreeType.RandomWilds] > 0 then
        local movePos = stopRet.theme_info.random_wild_pos_list
        self:setImgMaskStatus(true, true)
        self:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(0.5),
                        cc.CallFunc:create(
                                function()
                                    self:playRandomWilds(movePos)
                                end
                        ),
                        cc.DelayTime:create(2),
                        cc.CallFunc:create(
                                function()
                                    self:setImgMaskStatus(false, true)
                                end
                        ),
                        cc.DelayTime:create(0.5),
                        cc.CallFunc:create(stopCallFun)
                )
        )
    else
        if stopCallFun then
            stopCallFun()
        end
    end

end
function cls:updateDescMap(parent, fg_type, fg_count, fg_index)

    parent:removeAllChildren()
    if fg_index >= 7 then
        parent:setScale(0.9)
    else
        parent:setScale(1)
    end

    local mapFreeRes = mapFreeConfig[fg_type][2].mapFreeRes
    local img = bole.createSpriteWithFile(mapFreeRes)
    parent:addChild(img)
    if fg_type == MapFreeType.NoFeature then
        local font_file = self:getPic(mapFreeConfig[fg_type][2].mapFreeFnt)
        local value_str = tostring(self.mapFreeList[1])
        local fnt = cc.Label:createWithBMFont(font_file, value_str)
        parent:addChild(fnt)
        --img:setPosition(cc.p(66, 0))
        --fnt:setPosition(cc.p(-148, 0))+
        local width_img = img:getContentSize().width + 10
        local width_font = fnt:getContentSize().width
        local allWidth = width_img + width_font
        local start_img_pos = allWidth / 2 - width_img / 2
        img:setPosition(cc.p(start_img_pos, 0))
        local start_font_pos = -allWidth / 2 + width_font / 2
        fnt:setPosition(cc.p(start_font_pos, 0))
        if allWidth > 400 then
            parent:setScale(400 / allWidth)
        end
    elseif fg_type == MapFreeType.RemoveSymbol then
        local width1 = img:getContentSize().width
        local removeSymbolNode = cc.Node:create()
        parent:addChild(removeSymbolNode)
        self:addRemoveSymbols(removeSymbolNode, fg_count)

        local baseScale = (fg_index >= 7 and 0.8) or 1
        local orialWidth = 400

        local totalWidth = removeSymbolNode.showWidth + width1

        local scale = orialWidth / totalWidth
        if scale > baseScale then
            scale = baseScale
        end
        if totalWidth + 20 < orialWidth then
            local startPos = -totalWidth / 2 + width1 / 2 - 10
            img:setPosition(cc.p(startPos, 0))
            local startPos2 = totalWidth / 2 - removeSymbolNode.showWidth / 2 + 10
            removeSymbolNode:setPosition(cc.p(startPos2, 0))
        else
            local startPos = -totalWidth / 2 + width1 / 2
            img:setPosition(cc.p(startPos, 0))
            local startPos2 = totalWidth / 2 - removeSymbolNode.showWidth / 2
            removeSymbolNode:setPosition(cc.p(startPos2, 0))
        end
        parent:setScale(scale)
    elseif fg_type == MapFreeType.MultiplerWilds then
        local baseScale = (fg_index >= 7 and 0.8) or 1
        local orialWidth = 400
        local font_file = self:getPic(mapFreeConfig[fg_type][2].mapFreeFnt)
        local value_str = mapFreeConfig[fg_type][2].chooseList[fg_count]
        local fnt = cc.Label:createWithBMFont(font_file, value_str)
        parent:addChild(fnt)
        --img:setPosition(cc.p(66, 0))
        --fnt:setPosition(cc.p(-148, 0))+
        local width_img = img:getContentSize().width + 10
        local width_font = fnt:getContentSize().width
        local allWidth = width_img + width_font
        local start_img_pos = allWidth / 2 - width_img / 2
        img:setPosition(cc.p(start_img_pos, 0))
        local start_font_pos = -allWidth / 2 + width_font / 2
        fnt:setPosition(cc.p(start_font_pos, 0))
        local scale = orialWidth / allWidth
        if scale > baseScale then
            scale = baseScale
        end
        parent:setScale(400 / allWidth)
    end

end
function cls:mapFreeStopAnimation(ret, themeInfoAnimList)
    if self.mapFreeList[MapFreeType.StickyWilds] > 0 then
        self:updateStickyWildsBoard()
    end
    if self.mapFreeList[MapFreeType.ExpandingWild] > 0 then
        self:fullReelWilds(ret, themeInfoAnimList)
    end

end
function cls:updateStickyWildsBoard()
    local key = mapFreeConfig[MapFreeType.StickyWilds][2].mapKey
    if self.mapChosenInfo[key] and #self.mapChosenInfo[key] > 0 then
        --
        for index = 1, #self.mapChosenInfo[key] do

            local item = self.mapChosenInfo[key][index]
            local stickCol = (item - 1) % 5 + 1
            local stickRow = math.floor((item - 1) / 5) + 1
            local cell = self.spinLayer.spins[stickCol]:getRetCell(stickRow)
            self:updateCellSprite(cell, specialSymbol.wild, stickCol, 1, true)
        end
    end
end
---@desc 固定排面的wild type 2
function cls:playStickWilds()

    local key = mapFreeConfig[MapFreeType.StickyWilds][2].mapKey
    local stickPos = self.mapChosenInfo[key]--stick
    if self.scatterLayer then
        self.scatterLayer:removeAllChildren()
        for key, item in ipairs(stickPos) do
            local col = (item - 1) % 5 + 1
            local row = math.floor((item - 1) / 5) + 1
            local wildNode = bole.createSpriteWithFile("#theme186_s_1.png")
            wildNode:setScale(1.013)
            local wildPos = self:getCellPos(col, row)
            self.scatterLayer:addChild(wildNode)
            wildNode:setPosition(wildPos)
        end
    end
end
---@desc 固定wild+倍乘号 type3
function cls:playWinMultiers()


end

---@desc 随机wild type 4
function cls:playRandomWilds(randomPos)
    --randomPos = randomPos or { { 1, 1 }, { 2, 2 }, { 3, 3 }, { 4, 4 } }--stick
    --if self.scatterLayer then
    --    self.scatterLayer:removeAllChildren()
    for key, item in ipairs(randomPos) do
        local col = (item - 1) % 5 + 1
        local row = math.floor((item - 1) / 5) + 1
        local bonus = 1
        if self.mapFreeList[MapFreeType.MultiplerWilds] then
            bonus = self.item_list[col][row]
        end

        --local wildNode = self:createCellSprite(bonus, col)
        --local wildNode = bole.createSpriteWithFile("#theme186_s_1.png")

        --local wildPos = self:getCellPos(col, row)
        --self.animateNode:addChild(wildNode)
        local myKey = key
        self:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(myKey * 0.1),
                        cc.CallFunc:create(
                                function()
                                    self:playWildAppearAnimation(bonus, col, row)
                                    self:playMusic(self.audio_list.mapfree_wild_out2)
                                end
                        )
                )
        )
    end
    --end

end
function cls:stopAllRadomAction()
    if self.animNodeList and bole.getTableCount(self.animNodeList) > 0 then
        for key, item in pairs(self.animNodeList) do
            if item[1] and bole.isValidNode(item[1]) then
                item[1]:removeFromParent()
            end
        end
    end
    self.animNodeList = nil
end
---@desc low symbol 减去 type 5
function cls:removeLowSymbol()

end
---@desc wild  扩展一列 type 6
function cls:fullReelWilds(ret, themeInfoAnimList)

    local wildPos = {}
    local startCol = 5
    if self.mapFreeList[MapFreeType.ExpandingWild] == 0 then
        return
    else
        local key = mapFreeConfig[MapFreeType.ExpandingWild][2].mapKey
        startCol = 6 - #self.mapChosenInfo[key]
    end
    for col = startCol, G_cellCol do
        for row = 1, G_cellRow do
            if self.item_list[col][row] % 100 == specialSymbol.wild then
                local result = false
                --local key2 = mapFreeConfig[MapFreeType.StickyWilds][2].mapKey
                if self.mapFreeList[MapFreeType.StickyWilds] > 0 then
                    result = self:checkPosInStickWild(col, row)
                end
                if not result then
                    table.insert(wildPos, { col, row })
                    break
                end
            end
        end
    end
    if wildPos and #wildPos > 0 then
        local delayTm = 1
        table.insert(themeInfoAnimList, cc.DelayTime:create(delayTm))
        local needExpandList = {}
        self:playMusic(self.audio_list.mapfree_wild_expand)
        for key = 1, #wildPos do
            local item = wildPos[key]
            local col = item[1]
            needExpandList[item[1]] = {}
            needExpandList[item[1]].col = item[1]
            needExpandList[item[1]].rowList = {}
            for row = 1, 4 do
                if not self:checkPosInStickWild(col, row) then
                    local dis = row - item[2]
                    local symbolId = self.item_list[col][row]
                    if dis ~= 0 and symbolId ~= specialSymbol.wild then
                        self:copyWildAction(col, row, dis)
                    end
                end
            end
        end
    end
end
function cls:showSymbolWild(col, row)
    local cell = self.spinLayer.spins[col]:getRetCell(row)
    self:updateCellSprite(cell, specialSymbol.wild, col, false, true)

end
function cls:copyWildAction(col, row, dir)

    local startRow = row - dir

    local action = function()
        local startPos = self.spinLayer:getCellPos(col, startRow)
        local endPos = self.spinLayer:getCellPos(col, row)
        local _, s1 = bole.addSpineAnimation(self.animateNode, 1, self:getPic(SpineConfig.map_wild_copy), startPos, "animation")
        s1:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(10 / 30),
                        cc.MoveTo:create(10 / 30, endPos),
                        cc.CallFunc:create(
                                function()
                                    self:showSymbolWild(col, row)
                                end
                        )
                )
        )

    end
    self:runAction(
            cc.Sequence:create(
                    cc.CallFunc:create(action)
            )
    )

end
function cls:checkPosInStickWild(col, row)

    local find = false
    local key = mapFreeConfig[MapFreeType.StickyWilds][2].mapKey
    if self.mapChosenInfo[key] and #self.mapChosenInfo[key] > 0 then
        --
        for index = 1, #self.mapChosenInfo[key] do

            local item = self.mapChosenInfo[key][index]
            local stickCol = (item - 1) % 5 + 1
            local stickRow = math.floor((item - 1) / 5) + 1
            if stickCol == col and row == stickRow then
                find = true
                break
            end
        end
    end
    return find
end
function cls:checkKeyinRemoveSymbol(symbolKey)

    ----
    if self.mapFreeList and self.mapFreeList[MapFreeType.RemoveSymbol] > 0 then

        local mapKey = mapFreeConfig[MapFreeType.RemoveSymbol][2].mapKey
        local removeList = self.mapChosenInfo[mapKey]
        if removeList and #removeList > 0 then
            for key, item in ipairs(removeList) do
                if item == symbolKey then
                    return true
                end
            end
        end

    end

end
----------------------------------- map free end -----------------------------------

---------------------------场景恢复处理-------------------------------------

function cls:getFreeReel()
    local data = self.ctl.theme_reels["free_reel"]
    if self.superAvgBet then
        data = self.ctl.theme_reels["free_reel"]
    end
    if self.freeType == FreeBoardType.Wilds then
        data = self.ctl.theme_reels["wild_reel"]
    end
    if self.freeType == FreeBoardType.Prize then
        data = self.ctl.theme_reels["prize_reel"]
    end
    return data
end
-- 处理场景恢复的数据
function cls:adjustEnterThemeRet(retData)
    retData["theme_reels"] = {
        ["main_reel"] = {

            [1] = { 6, 9, 11, 13, 3, 2, 7, 1, 7, 11, 5, 3, 11, 11, 9, 1, 6, 7, 4, 13, 8, 10, 2, 6, 10, 1, 9, 8, 6, 5, 8, 9, 8, 4, 10, 1 },
            [2] = { 6, 10, 8, 8, 6, 3, 10, 1, 2, 11, 2, 5, 7, 11, 10, 1, 6, 9, 3, 9, 7, 9, 4, 4, 10, 1, 11, 11, 6, 2, 8, 9, 7, 5, 8, 1 },
            [3] = { 5, 11, 8, 11, 6, 6, 7, 1, 13, 11, 2, 4, 8, 10, 10, 1, 13, 9, 4, 9, 7, 11, 3, 3, 8, 1, 9, 10, 5, 2, 10, 7, 7, 6, 9, 1 },
            [4] = { 3, 11, 9, 9, 2, 3, 10, 1, 8, 7, 6, 5, 10, 10, 8, 1, 6, 8, 2, 7, 9, 11, 5, 6, 8, 1, 9, 7, 4, 4, 10, 11, 7, 6, 11, 1 },
            [5] = { 2, 10, 9, 10, 3, 5, 8, 1, 7, 7, 2, 5, 7, 13, 10, 1, 6, 8, 4, 8, 9, 10, 3, 6, 11, 1, 11, 11, 4, 13, 9, 11, 9, 6, 7, 1 },

        },
        ["free_reel"] = {
            [1] = { 6, 9, 11, 7, 3, 2, 7, 1, 7, 11, 5, 3, 11, 11, 9, 1, 6, 7, 4, 10, 8, 10, 2, 6, 10, 1, 9, 8, 6, 5, 8, 9, 8, 4, 10, 1 },
            [2] = { 6, 10, 8, 8, 6, 3, 10, 1, 7, 11, 2, 5, 7, 11, 10, 1, 6, 9, 3, 9, 7, 9, 4, 4, 10, 1, 11, 11, 6, 2, 8, 9, 7, 5, 8, 1 },
            [3] = { 5, 11, 8, 11, 6, 6, 7, 1, 8, 11, 2, 4, 8, 10, 10, 1, 6, 9, 4, 9, 7, 11, 3, 3, 8, 1, 9, 10, 5, 2, 10, 7, 7, 6, 9, 1 },
            [4] = { 3, 11, 9, 9, 2, 3, 10, 1, 8, 7, 6, 5, 10, 10, 8, 1, 6, 8, 2, 7, 9, 11, 5, 6, 8, 1, 9, 7, 4, 4, 10, 11, 7, 6, 11, 1 },
            [5] = { 2, 10, 9, 10, 3, 5, 8, 1, 7, 7, 2, 5, 7, 8, 10, 1, 6, 8, 4, 8, 9, 10, 3, 6, 11, 1, 11, 11, 4, 6, 9, 11, 9, 6, 7, 1 },
        },
        ["prize_reel"] = {
            [1] = { 6, 9, 11, 12, 3, 2, 7, 1, 7, 12, 5, 3, 11, 11, 9, 1, 12, 7, 4, 10, 8, 10, 2, 6, 10, 1, 9, 8, 6, 5, 8, 9, 8, 4, 10, 1 },
            [2] = { 6, 10, 8, 8, 6, 3, 10, 1, 7, 11, 2, 5, 7, 11, 10, 1, 6, 9, 3, 9, 12, 9, 4, 4, 10, 1, 11, 12, 6, 2, 8, 9, 7, 5, 8, 1 },
            [3] = { 5, 11, 12, 11, 6, 6, 7, 1, 8, 11, 2, 4, 8, 12, 10, 1, 6, 9, 4, 9, 7, 12, 3, 3, 8, 1, 9, 10, 5, 2, 10, 7, 7, 6, 9, 1 },
            [4] = { 3, 11, 9, 9, 12, 3, 10, 1, 8, 7, 6, 5, 10, 10, 8, 1, 6, 8, 2, 7, 9, 11, 5, 6, 8, 1, 9, 7, 12, 4, 10, 11, 7, 6, 11, 1 },
            [5] = { 2, 10, 9, 10, 3, 5, 12, 1, 7, 7, 12, 5, 7, 8, 10, 1, 6, 8, 4, 8, 9, 10, 3, 6, 11, 1, 11, 11, 4, 6, 9, 11, 9, 6, 7, 1 },
        },
        ["wild_reel"] = {
            [1] = { 1, 1, 1, 1, 1, 5, 5, 9, 9, 2, 2, 2, 2, 7, 7, 7, 6, 6, 1, 1, 1, 1, 1, 1, 1, 6, 8, 8, 9, 9, 2, 2, 1, 1, 1, 1, 1, 1, 7, 9, 9, 1, 1, 9, 9, 9, 9 },
            [2] = { 2, 2, 2, 2, 6, 1, 1, 1, 1, 1, 1, 2, 2, 2, 4, 4, 4, 1, 1, 1, 9, 9, 9, 1, 5, 5, 5, 5, 8, 8, 8, 1, 1, 1, 1, 1, 5, 5, 9, 9, 4, 1, 4, 7, 7 },
            [3] = { 3, 3, 2, 3, 3, 7, 7, 7, 7, 2, 1, 2, 1, 1, 1, 1, 1, 1, 5, 5, 1, 1, 8, 8, 8, 9, 9, 9, 6, 6, 6, 1, 1, 9, 1, 7, 7, 1, 1, 1, 1, 1, 1, 1, 8, 8, 8 },
            [4] = { 5, 5, 5, 5, 7, 7, 7, 9, 9, 1, 1, 1, 1, 2, 4, 4, 4, 6, 1, 1, 1, 1, 1, 4, 2, 2, 2, 2, 6, 6, 8, 8, 9, 2, 2, 1, 1, 1, 1, 1, 3, 5, 5, 5, 5 },
            [5] = { 3, 1, 1, 1, 1, 1, 9, 1, 2, 2, 7, 7, 2, 5, 1, 1, 4, 4, 3, 1, 1, 1, 1, 5, 5, 1, 7, 7, 7, 9, 8, 8, 8, 9, 9, 6, 6, 7, 7, 9, 2, 2, 2, 6, 6 }
        },
    }

    if retData["free_game"] then
        self.freeType = retData["free_game"].fg_type or 1

        if self.freeType == 5 then
            self.superAvgBet = retData.free_game.bet
            self.mapChosenInfo = retData["free_game"]
            self:initMapFreeIndex(retData["free_game"])
        end
        if self.freeType < 5 then

            self.ctl.freeSpeical = self:getSpecialTryResume(retData["free_game"]["item_list"])
            self.normalFreeInfo = {}
            self.normalFreeInfo.line_multi_list = retData["free_game"].line_multi_list
            self.normalFreeInfo.freeBet = retData["free_game"].bet
            if not retData["free_game"].line_multi_list then
                self.normalFreeInfo.line_multi_list = LineMutliConfig[self.freeType]
            end
            self.normalFreeInfo.per_spin_win = retData["free_game"].per_spin_win
            --self.themeBaseWin = retData["free_game"].base_win or 0
            --retData["free_game"].total_win  = self.themeBaseWin
            --retData["free_game"].total_win =  0  ---@desc 每次roll钱
            if retData["free_game"]["free_spins"] == retData["free_game"]["free_spin_total"] then
                local data = self:getWheelFreeData()
                if data and data[1] == 1 and data[2] == 1 then

                else
                    retData["first_free_game"] = {}
                    retData["first_free_game"]["base_win"] = retData["free_game"]["base_win"]
                    retData["first_free_game"]["total_win"] = retData["free_game"]["total_win"]
                    retData["first_free_game"]["bet"] = retData["free_game"]["bet"]
                    retData["first_free_game"]["item_list"] = retData["free_game"]["item_list"]
                    retData["first_free_game"]["free_spins"] = retData["free_game"]["free_spins"]
                    retData["first_free_game"]["free_spin_total"] = retData["free_game"]["free_spin_total"]
                    retData["first_free_game"]["free_game"] = retData["free_game"]
                    retData["free_game"] = nil
                end
            end
        end
    end
    if retData["bonus_game"] then
        self.haveBonus = true
        self.recvItemList = retData["bonus_game"]["item_list"]
        self.ctl.bonusSpeical = self:getSpecialTryResume(retData["bonus_game"]["item_list"])
        if retData["bonus_game"].avg_bet then
            self.superAvgBet = retData["bonus_game"].avg_bet
        end
    end

    if retData.theme_info then
        if retData.theme_info.theme_map then
            self.themeMapInfo = retData.theme_info.theme_map
            self.themeMapPoints = self.themeMapInfo.credits
        else
            self.themeMapPoints = 0
        end
        if retData.theme_info.bonus_info then
            self.coinsStackCount = retData.theme_info.bonus_info.wild_count
        else
            self.coinsStackCount = 0
        end

    end
    self.tipBet = retData.bonus_level or 1

    return retData
end

function cls:adjustTheme(data)
    -- 进入主题调用的函数 解析 jackpot 数据在这里
    self:changeSpinBoard(SpinBoardType.Normal)


end
function cls:onEnterTheme(endCallBack)
    if endCallBack then
        endCallBack()
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
function cls:flyCoinStack(col, row)
    local from = self.spinLayer:getCellPos(col, row)
    local to = self:getCoinsStackPos()
    local duration = 40

    local count = 8
    local path_list = {
        { 256, -128, 90 },
        { -128, -128, 135 },
        { -256, -256, 180 },
        { -256, -0, 270 },
        { 256, 0, 0 },
        { 256, -64, 45 },
        { 200, -128, 90 },
        { -200, -0, 270 }
    }
    local myBezier = function(p0, p1, p2, duration, frame)
        local t = frame / duration
        if t > 1 then
            t = 1
        end
        local x = math.pow(1 - t, 2) * p0.x + 2 * t * (1 - t) * p1.x + math.pow(t, 2) * p2.x
        local y = math.pow(1 - t, 2) * p0.y + 2 * t * (1 - t) * p1.y + math.pow(t, 2) * p2.y

        return cc.p(x, y)
    end
    local myAngle = function(p0, p1)
        local dx = p1.x - p0.x
        local dy = p1.y - p0.y
        local angle = math.deg(math.atan(dy / dx))
        angle = angle - 45

        return angle
    end
    for i = 1, count do
        local _, s = self:addSpineAnimation(self.bonusflyNode, 300, self:getPic(SpineConfig.fly_coins), cc.p(from.x, from.y), "animation", nil, nil, nil, true, false, nil)
        --s:setScale(0.7)
        -- s.dest = cc.p(to.x - math.random(-20,100) + 30, to.y - math.random(0,20) + 150) -- 调整福字往聚宝盆飞金币的位置
        s.dest = cc.p(to.x - math.random(-20, 100) + 30, to.y - math.random(0, 20) + 125) -- 调整福字往聚宝盆飞金币的位置

        s.config = path_list[i] or { 384, -128, 90 }
        s:setRotation(s.config[3])
        s.cp = cc.p(from.x + s.config[1], from.y + s.config[2])
        s.pos = s.pos or from
        s.frame = 1
        s.index = i

        local myindex = i
        s:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(19 / 30),
                        cc.CallFunc:create(function()
                            self:playCoinFall(s.dest, s.index)
                            s:removeFromParent()
                        end),
                        cc.DelayTime:create(1 / 30),
                        cc.RemoveSelf:create()
                )
        )
        s:runAction(cc.Repeat:create(cc.Sequence:create(
                cc.CallFunc:create(function()
                    s.frame = s.frame or 1
                    local pos = myBezier(from, s.cp, s.dest, duration, s.frame)
                    s:setPosition(pos)
                    s.pos = pos
                    s.frame = s.frame + 1
                end),
                cc.DelayTime:create(1 / 60)
        ), duration))
    end

end
function cls:playCoinFall(from, index)

    local _, s = self:addSpineAnimation(self.bonusflyNode, 300, self:getPic(SpineConfig.fly_coins_receive), cc.p(from.x, from.y), "animation")
    if index > 1 then
        return
    end
    local showIndex = 1
    if self.haveBonus then
        showIndex = 3
    else
        if self.coinsStackCount < 5 then
            showIndex = 1
        else
            showIndex = 2
        end
    end
    local _, s = self:addSpineAnimation(self.baseTopNode, 300, self:getPic(SpineConfig.coins_receive), cc.p(0, 0), "animation" .. showIndex)
    self:updateBaseCoinsStack(showIndex)
end

function cls:getCoinsStackPos()
    local startWPos = bole.getWorldPos(self.baseTopNode)
    local startNPos = bole.getNodePos(self.bonusflyNode, startWPos)
    return startNPos
end
-----------------------------------------------------------------------------------
-- 滚轴相关
-----------------------------------------------------------------------------------
function cls:genSpecials(pWinPosList)
    if self.showSpinBoard == SpinBoardType.Normal then
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
                    if type(theKey) == "number" and (theKey) % 100 == specialSymbol.trigger then
                        specials[specialSymbol.trigger][col] = specials[specialSymbol.trigger][col] or {}
                        specials[specialSymbol.trigger][col][row] = true
                    end
                end
            end
        end
        self.ctl.specials = specials

    end
end

function cls:genSpecialSymbolState(rets)

end

function cls:genSpecialSymbolStateInNormal(rets)
    local cItemList = rets.item_list
    local checkConfig = self.specialItemConfig

    for itemKey, theItemConfig in pairs(checkConfig) do
        local itemType = theItemConfig["type"]
        local itemCnt = 0
        local min_cnt = theItemConfig["min_cnt"]

        for col = 1, #self.spinLayer.spins do

            local colItemList = cItemList[col]
            local colRowCnt = self.spinLayer.spins[col].row -- self.colRowList[col]
            local curColMaxCnt = theItemConfig["col_set"][col] or colRowCnt
            -- 判断_当前列之前_是否已经中了feature(通过之前列itemKey个数判断)
            local colItemCnt = 0
            local isGetFeature = false
            local rowItem = 1
            for row, theItem in pairs(colItemList) do
                if theItem % 100 == itemKey then
                    colItemCnt = colItemCnt + 1
                    rowItem = row
                end
            end
            if colItemCnt > 0 then
                isGetFeature = true
            end
            -- 判断当前列加上之后所有列是否有可能中feature
            local willGetFeatureInAfterCols = false
            local sumCnt = 0
            for tempCol = col, #self.spinLayer.spins do
                sumCnt = sumCnt + (theItemConfig["col_set"][tempCol] or colRowCnt)
            end

            if curColMaxCnt > 0 and sumCnt > 0 and (itemCnt + sumCnt) >= min_cnt then
                willGetFeatureInAfterCols = true
            end
            if willGetFeatureInAfterCols then

                self.speedUpState[col] = self.speedUpState[col] or {}-- 此情况下，会进行特殊操作，将其状态记到self.speedUpState中
                self.speedUpState[col][itemKey] = self.speedUpState[col][itemKey] or {}

                self.speedUpState[col][itemKey]["cnt"] = itemCnt + 1
                self.speedUpState[col][itemKey]["is_get"] = isGetFeature
                self.speedUpState[col][itemKey]["row"] = rowItem
            end
            self.notifyState[col] = self.notifyState[col] or {}-- 当前列提示相关状态
            if willGetFeatureInAfterCols then
                for row, theItem in pairs(colItemList) do
                    if theItem % 100 == itemKey then
                        self.notifyState[col][itemKey] = self.notifyState[col][itemKey] or {}
                        table.insert(self.notifyState[col][itemKey], { col, row })
                    end
                end
            end
            if isGetFeature then
                itemCnt = itemCnt + 1
            end

        end
    end

end
function cls:playBigjili()
    local spineFile = self:getPic(SpineConfig.jili_appear)
    self:playMusic(self.audio_list.anticipation_all)
    local pos = cc.p(360, 660)
    local aniName = "animation"
    local _, s = bole.addSpineAnimation(self.bonusflyNode, nil, spineFile, pos, aniName)
    self:setImgMaskStatus(true, true)
    self:laterCallBack(2,
            function()
                self:setImgMaskStatus(false, true)
            end
    )

end
function cls:stopControl(stopRet, stopCallFun)
    if stopRet["bonus_level"] then
        self.tipBet = stopRet["bonus_level"]
    end
    if stopRet.bonus_game then
        self.haveBonus = true
    else
        self.haveBonus = false
    end
    if stopRet and stopRet.item_list then
        self.item_list = stopRet.item_list
    end
    if stopRet.bonus_info and self.coinsStackCount < stopRet.bonus_info.wild_count then
        self.coinsStackCount = stopRet.bonus_info.wild_count
    end

    if not self.checkItemsState then
        self.checkItemsState = {}  -- 都已列作为项， 各列各个sybmol相关状态，分为后面有可能，单列就有可能中，已经中了，后续没有可能中了
        self.speedUpState = {}  -- 加速的列控制
        self.notifyState = {}  -- 播放特殊symbol滚轴停止的时候的动画位置
        self:genSpecialSymbolStateInNormal(stopRet) -- jackpot symbol 落地动画配置
    end
    if self.showSpinBoard == SpinBoardType.Normal then

        local isGet = self:checkSpeedUpStop(5)
        local random = 0
        if isGet then
            random = math.random(1, 10)
            if random > 5 then
                isGet = false
            end
        end
        if isGet then
            self:playBigjili()
            self:laterCallBack(2, function()
                stopCallFun()
            end)
        else
            stopCallFun()
        end
    elseif self.showSpinBoard == SpinBoardType.FreeSpin then
        self:normalFreeSpinStart(stopCallFun)
    elseif self.showSpinBoard == SpinBoardType.MapFree then
        self:mapFreeSpinStart(stopRet, stopCallFun)
    else
        stopCallFun()
    end

end
--------------------------------- collect map point  start--------------------------------------

function cls:getCollectEndPos ()
    local wEndPos
    if self.showSpinBoard == SpinBoardType.Normal then
        wEndPos = bole.getWorldPos(self.mapCollectRoot)
    else
        wEndPos = bole.getWorldPos(self.freeCollectRoot)
    end
    local endNPos = bole.getNodePos(self.bonusflyNode, wEndPos)
    endNPos = cc.pAdd(endNPos, cc.p(-29, 15))
    return endNPos
end
function cls:flyMapPointsAction(themeInfoAnimList)

    if self.showSpinBoard == SpinBoardType.FreeSpin and self.freeType == FreeBoardType.Prize then
        local a1 = cc.DelayTime:create(1)
        table.insert(themeInfoAnimList, a1)
    end

    local delayTime = 0.2
    local endNPos = self:getCollectEndPos()
    local _flyMapPointSpines = self.flyMapPointSpines
    self.flyMapPointSpines = nil

    local flyAction = function(...)
        -- self:playMusic(self.audio_list.collect_fly)
        for col, id in pairs(_flyMapPointSpines) do
            if _flyMapPointSpines[col] then
                -- 更改动画
                for key, item in ipairs(_flyMapPointSpines[col]) do


                    if item and item.point then
                        bole.spChangeAnimation(item, "animation" .. item.point .. "_1")
                        local splist = cc.ParticleSystemQuad:create(self:getPic(SpineConfig["collect_lizi"]))

                        item:addChild(splist, -1)
                        splist:setPosition(cc.p(29, -15))
                        item:runAction(cc.Sequence:create(
                        --cc.DelayTime:create(delayTime),
                                cc.MoveTo:create(15 / 30, endNPos),
                                cc.DelayTime:create(10 / 30),
                                cc.RemoveSelf:create()))
                    end
                end
            end
        end
    end

    self:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(delayTime),
                    cc.CallFunc:create(flyAction),
                    cc.DelayTime:create(15 / 30),
                    cc.CallFunc:create(function()
                        if self.showSpinBoard == SpinBoardType.Normal then
                            --bole.spChangeAnimation(self.mapItemSpine, "animation", false)
                            local _, s = bole.addSpineAnimation(self.mapCollectRoot, 2, self:getPic(SpineConfig.collect_touch), cc.p(13, 43), "animation")

                        else
                            bole.spChangeAnimation(self.freeMapItemSpine, "animation", false)
                        end
                        local startCount = self.themeMapPoints - self.cookieCount
                        self.cookieCount = 0
                        if self.showSpinBoard == SpinBoardType.Normal then
                            self.collectPoints:setString(FONTS.formatByCount4(self.themeMapPoints, 6, true))
                            bole.shrinkLabel(self.collectPoints, self.collectPoints.maxWidth, self.collectPoints.baseScale)
                            self.collectPoints:nrStartRoll(startCount, self.themeMapPoints, 0.5)

                        else
                            self.freeCollectFont:setString(FONTS.formatByCount4(self.themeMapPoints, 6, true))
                            bole.shrinkLabel(self.collectPoints, self.collectPoints.maxWidth, self.collectPoints.baseScale)
                            self.freeCollectFont:nrStartRoll(startCount, self.themeMapPoints, 0.5)
                        end

                    end)
            )
    )
end
--------------------------------- collect map point  end-------------------------
--------------------------------- map start--------------------------------------
function cls:showStoreNode()
    if self.isFeatureClick then
        return
    end
    self.isFeatureClick = true
    if not self.storeNode then
        self:createStoreNode()
    else
        self.storeNode:setVisible(true)
    end
    local delay = 0.5
    self.ctl.footer:enableOtherBtns(false)
    self.ctl.footer:setSpinButtonState(true)-- 禁掉spin按钮
    self.storeRootNode:stopAllActions()

    self.storeBg:setOpacity(0)
    self.storeBg:runAction(cc.FadeIn:create(0.5))
    self.storeRootNode:setScale(0)
    self.storeBackBtn:setScale(0)
    self.storeRootNode:runAction(
            cc.Sequence:create(

                    cc.ScaleTo:create(0.3, 1.2),
                    cc.ScaleTo:create(0.1, 1),
                    cc.CallFunc:create(
                            function()
                                self.storeBackBtn:runAction(
                                        cc.Sequence:create(
                                                cc.ScaleTo:create(0.2, 1.1),
                                                cc.ScaleTo:create(0.1, 1)
                                        )
                                )
                            end)
            )
    )
    self:showCurStoreNode()
    if self.ctl.footer then
        self.ctl.footer:hideActivitysNode()
        -- self.ctl.footer:hideBoosterDimmer()
    end
end
function cls:createStoreNode()
    self.storeNode = cc.CSLoader:createNode(self:getPic(allCsbList.map))--  加载 商店显示
    self.myDialogNode:addChild(self.storeNode, 1)
    self.storeRootNode = self.storeNode:getChildByName("root")

    if SHRINKSCALE_H < 1 then
        self.storeRootNode:setPosition(cc.p(0, 15))
    end
    self.storeBg = self.storeNode:getChildByName("bg")

    self.storeCollectNode = self.storeRootNode:getChildByName("collect")
    self.storeMapPointLabel = self.storeCollectNode:getChildByName("font_1")

    self.storeStartBtn = self.storeRootNode:getChildByName("btn_start")
    self.storeMapPointLabel.maxWidth = 400
    self.storeMapPointLabel.baseScale = 0.7

    self.spendCoinsLabel = self.storeRootNode:getChildByName("label_coins")
    self.spendCoinsLabel:setString("")
    self.spendCoinsLabel.maxWidth = 200
    self.spendCoinsLabel.baseScale = 0.8
    self.storeTitle = self.storeRootNode:getChildByName("title")
    local _, s = self:addSpineAnimation(self.storeTitle, 300, self:getPic(SpineConfig.map_title), cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
    self.storeTitleSpine = s
    local touchStoreStart = function(sender, eventType)

        if eventType == ccui.TouchEventType.ended then

            self:playMusic(self.audio_list.store_choose2)
            self:clickStoreStartOver()
        end
    end

    self.storeStartBtn:addTouchEventListener(touchStoreStart)
    self:initStoreItemList()

    self.storeBackBtn = self.storeRootNode:getChildByName("btn_close")
    self:initStoreOtherBtn()


end
function cls:clickStoreStartOver()

    local buyItem = { 0, 0, 0, 0, 0, 0 }
    buyItem[1] = self.storeChooseItem.free.count
    local index = self.storeChooseItem.storeIndex or 1
    for key = 2, 6 do

        if index < 7 then
            if key == index then
                buyItem[index] = self.storeChooseItem.item1.count
            end
        else
            local key1 = mapFreeConfig[index][1]
            local key2 = mapFreeConfig[index][2]
            if key1 == key then
                buyItem[key1] = self.storeChooseItem.item1.count
            elseif key2 == key then
                buyItem[key2] = self.storeChooseItem.item2.count
            end
        end
    end

    self:closeCurPageBtnEvent()
    self:closeOtherPageBtnEvent()

    self.curItem = { page = 0, pos = buyItem }
    self.mapFreeList = buyItem
    self.ctl:themeBuySpecial(self.curItem)
end
function cls:overBuySpecialItem(data)
    local nextFunc = nil
    self.buyBackData = nil
    local nextDelay = 0
    local overFunc = function(...)
        self:openCurPageBtnEvent()
        self:openOtherPageBtnEvent()
    end
    nextDelay = 0.1
    self.ctl.specials = nil
    if data.free_game then
        self:updateCurPageState(true)
        self.superAvgBet = data["free_game"].bet
        self.freeType = data["free_game"].fg_type
        self.mapChosenInfo = data["free_game"]
        self:initMapFreeIndex(data["free_game"])
        nextFunc = function()
            self.ctl.rets = {}
            self.ctl.rets.free_spins = data.free_game.free_spins
            self.ctl.rets.item_list = data.free_game.item_list
            self.ctl.rets.free_game = data.free_game
            self.ctl.totalWin = 0
            self.ctl.footer:reSetWinCoinsString(0)-- footer 进行加钱
            self:runAction(
                    cc.Sequence:create(
                            cc.CallFunc:create(
                                    function()
                                        self:playTransition(nil, "map")
                                    end
                            ),
                            cc.DelayTime:create(transitionDelay["map"].onCover),
                            cc.CallFunc:create(
                                    function()
                                        overFunc()
                                        if self.ctl.footer then
                                            self.ctl.footer:showActivitysNode()
                                        end
                                        self.ctl:handleResult()
                                    end)
                    )
            )
            self:closeStoreNode(true)
        end
        self:updatePageItemByBuy(data, nextFunc, nextDelay)
    else
        overFunc()
    end
end
function cls:getCurMapType(data)

    local curType = 0

    for key = 7, 9 do
        local key1 = mapFreeConfig[key][1]
        local key2 = mapFreeConfig[key][2]
        if data[key1] > 0 and data[key2] > 0 then
            curType = key
            break
        end
    end
    if curType > 0 then
        return curType
    end
    for key = 2, 6 do
        if data[key] > 0 then
            curType = key
        end
    end
    if curType > 0 then
        return curType
    end
    return MapFreeType.NoFeature

end
function cls:initMapFreeIndex(free_game)
    local showIndex = 1
    local valueList = { 0, 0, 0, 0, 0, 0 }
    valueList[1] = free_game.free_spin_total
    local count = 0
    local moreThan1 = 0
    for key = 2, 6 do
        local keyName = mapFreeConfig[key][2].mapKey
        if free_game[keyName] then
            local default = 1
            if key == MapFreeType.ExpandingWild or key == MapFreeType.RemoveSymbol then
                default = #free_game[keyName]
            elseif key == MapFreeType.MultiplerWilds then
                local lastKey = free_game[keyName][4]
                if lastKey == 10 then
                    default = 3
                elseif lastKey == 7 then
                    default = 2
                else
                    default = 1
                end
            end
            valueList[key] = default
            count = count + 1
            moreThan1 = key
        end
    end
    self.mapFreeList = valueList
    if count == 0 then
        showIndex = 1
    elseif count == 1 then
        showIndex = moreThan1
    else
        for index = 7, 9 do
            local key1 = mapFreeConfig[index][1]
            local key2 = mapFreeConfig[index][2]
            if valueList[key1] > 0 and valueList[key2] > 0 then
                showIndex = index
                break
            end
        end
    end
    self.mapFreeIndex = showIndex


end
function cls:updatePageItemByBuy(data, nextFunc, nextDelay)

    self:laterCallBack(nextDelay, nextFunc)
end

function cls:initStoreItemList()
    self.storeRollList = self.storeRootNode:getChildByName("roll_list"):getChildren()
    for key = 1, 9 do

        local item = self.storeRollList[key]
        local bg1 = item:getChildByName("bg1")
        local bg2 = item:getChildByName("bg2")
        local bg3 = bg2:getChildByName("bg3")
        local tip = item:getChildByName("tip")
        local btn = bg1:getChildByName("btn")

        item.bg1 = bg1
        item.bg2 = bg2
        item.bg3 = bg3
        item.tip = tip
        item.btn = btn

        bg1:setVisible(true)
        bg2:setVisible(false)
        btn.storeIndex = key
        self:initStoreChosenItem(btn)
        if key < 7 then
            local text_dark = bg1:getChildByName("text")
            bole.updateSpriteWithFile(text_dark, mapFreeConfig[key][1].name)
            local text_light = bg2:getChildByName("text")
            bole.updateSpriteWithFile(text_light, mapFreeConfig[key][2].name)

            local tip_desc = tip:getChildByName("desc_1")
            bole.updateSpriteWithFile(tip_desc, mapFreeConfig[key][2].tip)

            if mapFreeConfig[key][2].chooseList then
                bg3:setVisible(true)
            else
                bg3:setVisible(false)
            end
            local btn_sub = bg3:getChildByName("btn_sub")
            local btn_add = bg3:getChildByName("btn_add")
            btn_sub.storeIndex = key
            btn_add.storeIndex = key
            btn_sub.subIndex = 1
            btn_add.addIndex = 1
            item.btn_sub1 = btn_sub
            item.btn_add1 = btn_add
            self:initStoreAddandSub(btn_add, btn_sub)
            item.chosen_1 = bg3:getChildByName("chosen_1")
            item.font_1 = bg3:getChildByName("font_1")
            item.font_1:setString("")
            item.chosen_font_1 = bg3:getChildByName("chosen_font_1")

        else
            for key1 = 1, 2 do
                local text_dark1 = bg1:getChildByName("text" .. key1)
                local config1 = mapFreeConfig[key][key1]
                bole.updateSpriteWithFile(text_dark1, mapFreeConfig[config1][1].name)
                local text_light1 = bg2:getChildByName("text" .. key1)
                bole.updateSpriteWithFile(text_light1, mapFreeConfig[config1][2].name)

                local tip_desc1 = tip:getChildByName("desc_" .. key1)
                bole.updateSpriteWithFile(tip_desc1, mapFreeConfig[config1][2].tip)

                local btn_sub1 = bg3:getChildByName("btn_sub" .. key1)
                local btn_add1 = bg3:getChildByName("btn_add" .. key1)
                btn_sub1.storeIndex = key
                btn_add1.storeIndex = key
                btn_sub1.subIndex = key1
                btn_add1.addIndex = key1
                self:initStoreAddandSub(btn_add1, btn_sub1)
                item["btn_sub" .. key1] = btn_sub1
                item["btn_add" .. key1] = btn_add1
                item["chosen_" .. key1] = bg3:getChildByName("chosen_" .. key1)
                if key1 == 1 then
                    item["font_" .. key1] = bg3:getChildByName("font_" .. key1)
                    item["font_" .. key1]:setString("")
                end
                item["chosen_font_" .. key1] = bg3:getChildByName("chosen_font_" .. key1)
                item["chosen_font_" .. key1]:setString("")
            end
        end
        tip:setVisible(false)
        local btn_tip = bg2:getChildByName("btn_tip")
        btn_tip.tip_node = tip
        btn_tip.tip_node.store_index = key
        self:initStoreTip(btn_tip)

    end
    self.storefreeItem = self.storeRootNode:getChildByName("node3"):getChildByName("node_0")
    local bg2 = self.storefreeItem:getChildByName("bg2")
    local bg3 = bg2:getChildByName("bg3")
    local btn_sub = bg3:getChildByName("btn_sub")
    local btn_add = bg3:getChildByName("btn_add")
    local chosen = bg3:getChildByName("chosen_1")
    btn_sub.storeIndex = 0
    btn_add.storeIndex = 0
    self.storefreeItem.btn_sub = btn_sub
    self.storefreeItem.btn_add = btn_add
    self.storefreeItem.chosen_1 = chosen
    self.storefreeItem.font_1 = bg3:getChildByName("font_1")

    self.storefreeItem["chosen_font_1"] = bg3:getChildByName("chosen_font_1")
    self:initStoreAddandSub(btn_add, btn_sub)


end
function cls:initStoreTip(btn_tip)
    local touchTipFunc = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if sender.tip_node then
                self:playMusic(self.audio_list.btn_click)
                sender.tip_node.isShow = sender.tip_node.isShow or 0
                self:changeStoreTipState(sender.tip_node)

            end
        end

    end
    btn_tip:addTouchEventListener(touchTipFunc)
end

function cls:initStoreChosenItem(btn)
    local touchFunc = function(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            if self.clickStoreStart then
                return
            end
            self:playMusic(self.audio_list.store_choose1)
            self:refreshStoreList(obj.storeIndex)
        end
    end
    btn:addTouchEventListener(touchFunc)
end

function cls:initStoreAddandSub(addBtn, subBtn)
    local touchAddFunc = function(sender, eventType)

        if eventType == ccui.TouchEventType.ended then

            if self.clickStoreStart then
                return
            end
            self:playMusic(self.audio_list.btn_click)
            self:updateAddStoreBtn(addBtn, addBtn.addIndex)
        end
    end
    addBtn:addTouchEventListener(touchAddFunc)
    local touchSubFunc = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if self.clickStoreStart then
                return
            end
            self:playMusic(self.audio_list.btn_click)
            self:updateSubStoreBtn(subBtn, subBtn.subIndex)
        end
    end
    subBtn:addTouchEventListener(touchSubFunc)
end
function cls:updateAddStoreBtn(addBtn)

    if addBtn.storeIndex == 0 then
        -- free
        local count = self.storeChooseItem.free.count + 1
        local spend = self:getStoreSpend(addBtn.storeIndex, count, count)
        self.storeChooseItem.free.count = count
        self.storeChooseItem.free.spend = spend
        self:refreshFreeSpinItem()

    elseif addBtn.storeIndex < 7 then
        -- 1-6
        local freeCount = self.storeChooseItem.free.count
        local count = self.storeChooseItem.item1.count + 1
        local spend = self:getStoreSpend(addBtn.storeIndex, count, freeCount)
        self.storeChooseItem.item1.count = count
        self.storeChooseItem.item1.spend = spend
        self:refreshStoreItem(addBtn.storeIndex, 1)
        self:refreshStoreItemMoney(addBtn.storeIndex)
    else
        local storeIndex = addBtn.storeIndex
        local freeCount = self.storeChooseItem.free.count

        local touchIndex = 1
        if addBtn.addIndex == 1 then
            local count1 = self.storeChooseItem.item1.count + 1
            self.storeChooseItem.item1.count = count1
        else
            touchIndex = 2
            local count2 = self.storeChooseItem.item2.count + 1
            self.storeChooseItem.item2.count = count2
        end
        local count1 = self.storeChooseItem.item1.count
        local count2 = self.storeChooseItem.item2.count
        local spend = self:storeSpendDouble(storeIndex, count1, count2, freeCount)
        self.storeChooseItem.item1.spend = spend
        self:refreshStoreItem(addBtn.storeIndex, touchIndex)
        self:refreshStoreItemMoney(addBtn.storeIndex)
    end
    self:initTotTalSpend()
    self:refreshStoreSpend()

end
function cls:getStoreSpend(storeType, count, spinCount)
    local spend = 0
    if MapFreeType.FreeSpin == storeType then
        spend = 40 * count
    elseif MapFreeType.NoFeature == storeType then
        spend = 0
    elseif storeType == MapFreeType.StickyWilds then
        local price = { 35, 85, 160, 285, 460 }
        spend = price[count] * spinCount
    elseif storeType == MapFreeType.MultiplerWilds then
        local price = { 285, 710, 1460 }
        spend = price[count] * spinCount
    elseif storeType == MapFreeType.RandomWilds then
        local price = { 35, 85, 160, 285, 440 }
        spend = price[count] * spinCount
    elseif storeType == MapFreeType.RemoveSymbol then
        local price = { 35, 50, 65, 80, 140 }
        spend = price[count] * spinCount
    elseif storeType == MapFreeType.ExpandingWild then
        local price = { 5, 20, 75 }
        spend = price[count] * spinCount
    end
    return spend
end
function cls:storeSpendDouble(storeType, count1, count2, spinCount)

    local spend = 0
    if MapFreeType.MultiAndRemove == storeType then
        local price = {
            { 385, 460, 570, 710, 910, },
            { 810, 960, 1210, 1360, 1685 },
            { 2110, 2210, 2710, 3035, 3560 }
        }
        spend = price[count1][count2] * spinCount
    elseif MapFreeType.MultiAndRandom == storeType then
        local price = {
            { 1050, 2550, 6625, 15350, 34500 },
            { 2300, 7650, 20500, 52500, 115000 },
            { 7075, 27750, 62250, 218500, 517500 }
        }
        spend = price[count1][count2] * spinCount
    elseif MapFreeType.StickyAndExpand == storeType then
        local price = {
            { 40, 100, 185, 315, 545 },
            { 70, 140, 255, 395, 600 },
            { 145, 245, 370, 540, 775 }
        }
        spend = price[count2][count1] * spinCount
    end

    return spend
end
function cls:updateSubStoreBtn(subBtn)

    if subBtn.storeIndex == 0 then
        -- free
        local freeCount = self.storeChooseItem.free.count
        local count = self.storeChooseItem.free.count - 1
        local spend = self:getStoreSpend(subBtn.storeIndex, count, freeCount)
        self.storeChooseItem.free.count = count
        self.storeChooseItem.free.spend = spend

        self:refreshFreeSpinItem()

    elseif subBtn.storeIndex < 7 then
        -- 1-6
        local freeCount = self.storeChooseItem.free.count
        local count = self.storeChooseItem.item1.count - 1
        local spend = self:getStoreSpend(subBtn.storeIndex, count, freeCount)
        self.storeChooseItem.item1.count = count
        self.storeChooseItem.item1.spend = spend

        self:refreshStoreItem(subBtn.storeIndex, 1)
        self:refreshStoreItemMoney(subBtn.storeIndex)
    else
        local freeCount = self.storeChooseItem.free.count
        local storeIndex = subBtn.storeIndex
        local touchIndex = 1
        if subBtn.subIndex == 1 then
            local count = self.storeChooseItem.item1.count - 1
            self.storeChooseItem.item1.count = count
        else
            local count = self.storeChooseItem.item2.count - 1
            self.storeChooseItem.item2.count = count
            touchIndex = 2
        end

        local count1 = self.storeChooseItem.item1.count
        local count2 = self.storeChooseItem.item2.count

        local spend = self:storeSpendDouble(storeIndex, count1, count2, freeCount)
        self.storeChooseItem.item1.spend = spend

        self:refreshStoreItem(subBtn.storeIndex, touchIndex)
        self:refreshStoreItemMoney(subBtn.storeIndex)
    end
    self:initTotTalSpend()
    self:refreshStoreSpend()
end

function cls:refreshStoreList(storeIndex)
    self.storeChooseItem = self.storeChooseItem or {}
    self.storeChooseItem.storeIndex = storeIndex
    self.storeChooseItem.item1 = nil
    self.storeChooseItem.item2 = nil
    local freecount = self.storeChooseItem.free.count
    local config = mapFreeConfig[storeIndex]
    if storeIndex == 1 then

    elseif storeIndex < 7 then

        local count = 1
        local spend = self:getStoreSpend(storeIndex, count, freecount)
        self.storeChooseItem.item1 = {}
        self.storeChooseItem.item1.count = count
        self.storeChooseItem.item1.spend = spend
        --{ count = 1, spend = 1000 }
        self:refreshStoreItem(storeIndex, 1)
        self:refreshStoreItemMoney(storeIndex)
    else
        local storeIndex1 = mapFreeConfig[storeIndex][1]
        local count1 = 1

        --local storeIndex2 = mapFreeConfig[storeIndex][2]
        local count2 = 1
        local spend = self:storeSpendDouble(storeIndex, count1, count2, freecount)

        self.storeChooseItem.item1 = {}
        self.storeChooseItem.item1.count = count1
        self.storeChooseItem.item1.spend = spend

        self.storeChooseItem.item2 = {}
        self.storeChooseItem.item2.count = count2
        --self.storeChooseItem.item2.spend = spend2

        self:refreshStoreItem(storeIndex, 1)
        self:refreshStoreItem(storeIndex, 2)
        self:refreshStoreItemMoney(storeIndex)
    end
    for key = 1, 9 do
        local item = self.storeRollList[key]
        if storeIndex == key then
            item.bg1:setVisible(false)
            item.bg2:setVisible(true)
            item.tip:setVisible(false)
        else
            item.bg1:setVisible(true)
            item.bg2:setVisible(false)
            item.tip:setVisible(false)
        end
    end

    self:initTotTalSpend()
    self:refreshStoreSpend()
end
function cls:changeStoreTipState(myNode)

    if myNode.isShow == 1 then
        -- show
        myNode.isShow = 0
        myNode:stopAllActions()
        local a1 = cc.ScaleTo:create(0.1, 1.2)
        local a2 = cc.ScaleTo:create(0.2, 0)
        local a3 = cc.CallFunc:create(
                function()
                    if myNode.spine and bole.isValidNode(myNode.spine) then
                        myNode.spine:removeFromParent()
                    end
                    myNode:setVisible(false)
                end)

        myNode:runAction(
                cc.Sequence:create(a1, a2)
        )

    else
        local store_index = myNode.store_index
        if not myNode.spine or not bole.isValidNode(myNode.spine) then
            if store_index <= 6 then
                local _, s1 = bole.addSpineAnimation(myNode, 1, self:getPic(SpineConfig.map_tip), cc.p(228, 0), "animation1", nil, nil, nil, true, true)
                myNode.spine = s1
            else
                local _, s1 = bole.addSpineAnimation(myNode, 1, self:getPic(SpineConfig.map_tip), cc.p(232, 0), "animation2", nil, nil, nil, true, true)
                s1:setScaleY(0.9)
                s1:setScaleX(1.02)
                myNode.spine = s1
            end
        end

        myNode.isShow = 1
        myNode:setVisible(true)
        myNode:stopAllActions()
        myNode:setScale(0)
        local a1 = cc.ScaleTo:create(0.2, 1.2)
        local a2 = cc.ScaleTo:create(0.1, 1)
        local a3 = cc.DelayTime:create(3)
        local a4 = cc.CallFunc:create(
                function()
                    self:changeStoreTipState(myNode)
                end)
        myNode:runAction(
                cc.Sequence:create(a1, a2, a3, a4)
        )

    end

end
function cls:initStoreOtherBtn()
    local function onTouchStoreBackBtn(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            if self.clickStoreStart then
                return
            end
            self:playMusic(self.audio_list.btn_click)
            self.storeBackBtn:setTouchEnabled(false)
            self:closeStoreNode(true)
        end
    end

    self.storeBackBtn:addTouchEventListener(onTouchStoreBackBtn)
end
function cls:showCurStoreNode()
    self.storeChooseItem = {}
    self.storeChooseItem.free = {}
    local count = 3
    local spend = self:getStoreSpend(0, count, count)
    self.storeChooseItem.free.count = count
    self.storeChooseItem.free.spend = spend
    self.storeChooseItem.storeIndex = 1
    self:initTotTalSpend()
    self:refreshFreeSpinItem()
    self:refreshAllItemList()
    self:refreshStoreSpend()
    self:refreshStorePoints()
    self:openOtherPageBtnEvent()
end
function cls:refreshStorePoints()
    local str = FONTS.formatByCount4(self.themeMapPoints, 8, true)
    self.storeMapPointLabel:setString(str)
    bole.shrinkLabel(self.storeMapPointLabel, self.storeMapPointLabel.maxWidth, self.storeMapPointLabel.baseScale)

end
function cls:initTotTalSpend()
    local spend = 0
    for key, item in pairs(self.storeChooseItem) do

        if item and type(item) == "table" then
            if item.spend then
                spend = spend + item.spend
            end

        end
    end
    self.storeChooseItem.allSpend = spend
end
function cls:refreshStoreSpend()


    local spend = self.storeChooseItem.allSpend
    local leftCoin = self.themeMapPoints - spend
    if spend > 0 then
        local str = FONTS.formatByCount4(spend, 8, true)
        self.spendCoinsLabel:setString(str)
        bole.shrinkLabel(self.spendCoinsLabel, self.spendCoinsLabel.maxWidth, self.spendCoinsLabel.baseScale)
    else
        self.spendCoinsLabel:setString("")
    end
    if spend <= self.themeMapPoints then
        self:setTouchEnabled(self.storeStartBtn, true)

    else
        self:setTouchEnabled(self.storeStartBtn, false)

    end
    local maxCount = mapFreeConfig[0][2].max
    if leftCoin > 0 and maxCount > self.storeChooseItem.free.count then
        self:setTouchEnabled(self.storefreeItem.btn_add, true)
    else
        self:setTouchEnabled(self.storefreeItem.btn_add, false)
    end

end
function cls:refreshAllItemList()
    for key = 1, 9 do
        local item = self.storeRollList[key]
        item.bg1:setVisible(true)
        item.bg2:setVisible(false)
        item.tip:setVisible(false)
    end
end
function cls:refreshFreeSpinItem()
    local chosen_font_1 = self.storefreeItem.chosen_font_1
    local freeCount = self.storeChooseItem.free.count

    local countStr = tostring(freeCount)
    chosen_font_1:setString(countStr)
    local condfig = mapFreeConfig[0]
    local chosenMaxWidth = condfig[2].chosenMaxWidth
    local chosenBaseScale = condfig[2].chosenScale

    bole.shrinkLabel(self.storefreeItem.chosen_font_1, chosenMaxWidth, chosenBaseScale)

    local str = FONTS.formatByCount4(self.storeChooseItem.free.spend, 8, true)
    self.storefreeItem.font_1:setString(str)

    local maxWidth = condfig[2].fontMaxWidth
    local baseScale = condfig[2].fontBaseScale
    bole.shrinkLabel(self.storefreeItem.font_1, maxWidth, baseScale)

    if self.storeChooseItem.free.count <= condfig[2].min then
        self:setTouchEnabled(self.storefreeItem.btn_sub, false)
    else
        self:setTouchEnabled(self.storefreeItem.btn_sub, true)
    end
    self:refreshChangesBySpinCount()

end
function cls:refreshChangesBySpinCount()
    local needrefresh = false
    local storeIndex = self.storeChooseItem.storeIndex
    if storeIndex == 0 or storeIndex == 1 then
        return
    end
    local freeCount = self.storeChooseItem.free.count
    if self.storeChooseItem.item1 and self.storeChooseItem.item2 then
        local storeIndex = self.storeChooseItem.storeIndex
        local count1 = self.storeChooseItem.item1.count
        local count2 = self.storeChooseItem.item2.count
        local spend = self:storeSpendDouble(storeIndex, count1, count2, freeCount)
        self.storeChooseItem.item1.spend = spend
        needrefresh = true

    elseif self.storeChooseItem.item1 then
        local storeIndex = self.storeChooseItem.storeIndex
        local count1 = self.storeChooseItem.item1.count
        local spend = self:getStoreSpend(storeIndex, count1, freeCount)
        self.storeChooseItem.item1.spend = spend
        needrefresh = true
    end
    if needrefresh then
        self:refreshStoreItemMoney(storeIndex)
    end
end
function cls:refreshStoreItem(storeIndex, index)
    local showItem = self.storeRollList[storeIndex]
    local itemType = storeIndex
    if storeIndex >= 7 then
        itemType = mapFreeConfig[storeIndex][index]
    end
    local condfig = mapFreeConfig[itemType]

    local showCount = self.storeChooseItem["item" .. index].count

    if itemType == MapFreeType.RemoveSymbol then
        self:refreshRemoveSymbolItem(showItem, showCount, index)
    elseif itemType == MapFreeType.ExpandingWild then
        self:refreshExpandingWildItem(showItem, showCount, index)
    else
        local chooseStr = condfig[2].chooseList[showCount]
        local fntNode = showItem["chosen_font_" .. index]
        fntNode:setString(chooseStr)
        local chosenMaxWidth = condfig[2].chosenMaxWidth
        local chosenBaseScale = condfig[2].chosenScale
        bole.shrinkLabel(showItem["chosen_font_" .. index], chosenMaxWidth, chosenBaseScale)
    end

    if showCount <= condfig[2].min then
        self:setTouchEnabled(showItem["btn_sub" .. index], false)
        self:setTouchEnabled(showItem["btn_add" .. index], true)
    elseif showCount >= condfig[2].max then
        self:setTouchEnabled(showItem["btn_sub" .. index], true)
        self:setTouchEnabled(showItem["btn_add" .. index], false)
    else
        self:setTouchEnabled(showItem["btn_sub" .. index], true)
        self:setTouchEnabled(showItem["btn_add" .. index], true)
    end
end
function cls:refreshStoreItemMoney(storeIndex)
    local showItem = self.storeRollList[storeIndex]
    local showSpend = self.storeChooseItem["item1"].spend
    local str = FONTS.formatByCount4(showSpend, 8, true)
    showItem["font_1"]:setString(str)
    local maxWidth = 120
    local baseScale = 0.5
    bole.shrinkLabel(showItem["font_1"], maxWidth, baseScale)
end
function cls:setTouchEnabled(btnNode, status)
    if btnNode and bole.isValidNode(btnNode) then
        btnNode:setTouchEnabled(status)
        btnNode:setBright(status)
    end

end
function cls:refreshRemoveSymbolItem(showItem, showCount, index)


    local str1 = ""
    showItem["chosen_font_" .. index]:setString("")
    showItem["chosen_" .. index]:removeAllChildren()
    local orialWidth = 160
    local baseScale = 0.5
    local parent = showItem["chosen_" .. index]
    self:addRemoveSymbols(parent, showCount)
    local scale = orialWidth / parent.showWidth
    if scale > baseScale then
        scale = baseScale
    end
    parent:setScale(scale)

end
function cls:addRemoveSymbols(parent, showCount)
    local unitWidth = 80

    local totoalWidth = unitWidth * showCount
    local startPos = -totoalWidth / 2 + unitWidth / 2
    local config = mapFreeConfig[5][2].chooseList[showCount]
    for key = 1, showCount do
        local symbolKey = config[key]
        local img_symbol = string.format("#theme186_s_%s.png", symbolKey)

        local img = bole.createSpriteWithFile(img_symbol)
        parent:addChild(img)
        img:setPosition(cc.p(startPos, 0))
        startPos = startPos + unitWidth

    end
    parent.showWidth = totoalWidth
end
function cls:refreshExpandingWildItem(showItem, showCount, index)
    local fontNode = showItem["chosen_font_" .. index]
    showItem["chosen_" .. index]:removeAllChildren()
    local parent = showItem["chosen_" .. index]

    local reel_img = "#theme186_map_desc_reel.png"
    if showCount > 1 then
        reel_img = "#theme186_map_desc_reels.png"
    end
    local zeroPosY = parent:getPositionY()
    local zeroPosX = 60
    local config = mapFreeConfig[MapFreeType.ExpandingWild][2]
    local showStr = config.chooseList[showCount]
    fontNode:setString(showStr)
    fontNode:setScale(config.fontBaseScale)

    local img = bole.createSpriteWithFile(reel_img)
    parent:addChild(img)
    parent:setScale(1)

    local width_reel = img:getContentSize().width + 10
    local width_font = fontNode:getContentSize().width * config.fontBaseScale
    local allWidth = width_reel + width_font
    local start_reel_pos = -allWidth / 2 + width_reel / 2
    parent:setPosition(cc.p(start_reel_pos + zeroPosX, zeroPosY))

    local start_font_pos = allWidth / 2 - width_font / 2
    fontNode:setPosition(cc.p(start_font_pos + zeroPosX, zeroPosY))
    parent.showWidth = allWidth
    local baseScale = 1
    local scale = 160 / parent.showWidth
    if scale > baseScale then
        scale = baseScale
    end
    if scale < 1 then

        parent:setPosition(cc.p(start_reel_pos * scale + zeroPosX, zeroPosY))
        parent:setScale(scale)
        fontNode:setScale(config.fontBaseScale * scale)
        fontNode:setPosition(cc.p(start_font_pos * scale + zeroPosX, zeroPosY))
    end

    --parent:setScale(scale)

end
function cls:closeStoreNode(isAni)
    if not self.storeNode or not self.storeNode:isVisible() then
        return
    end
    if not self.isFeatureClick then
        return
    end
    self.isFeatureClick = false
    if isAni then
        local delay = 0.5
        self.storeRootNode:stopAllActions()
        self.storeBg:setOpacity(255)
        self.storeBg:runAction(cc.FadeOut:create(0.5))
        --self.storeRootNode:setPosition(cc.p(0, 0))
        self.storeRootNode:runAction(
                cc.Sequence:create(

                        cc.ScaleTo:create(0.1, 1.1),
                        cc.ScaleTo:create(0.3, 0),
                        cc.CallFunc:create(
                                function()
                                    self.storeNode:setVisible(false)
                                end
                        )
                )
        )
    else
        self.storeNode:setVisible(false)
        self.isFeatureClick = false
    end
    if self.ctl:noFeatureLeft() then
        self.ctl.footer:enableOtherBtns(true)
        self.ctl.footer:setSpinButtonState(false) --
        self.ctl.footer:showActivitysNode()
    end
    self:dealMusic_FadeLoopMusic(0.3, 0.3, 1)-- 恢复背景音乐

end
function cls:updateCurPageState()

    self.themeMapPoints = self.themeMapPoints - self.storeChooseItem.allSpend
    --local str = FONTS.formatByCount4(self.themeMapPoints, 8, true)
    --self.storeMapPointLabel:setString(str)
    --bole.shrinkLabel(self.storeMapPointLabel, self.storeMapPointLabel.maxWidth, self.storeMapPointLabel.baseScale)
    self:refreshStorePoints()
    self:updateBaseShowPointsCnt()
end
function cls:openCurPageBtnEvent()

    self.clickStoreStart = false
end
function cls:openOtherPageBtnEvent()
    self.storeBackBtn:setTouchEnabled(true)
    self.storeBackBtn:setBright(true)
end
function cls:closeCurPageBtnEvent()

    self.clickStoreStart = true
    self.storeStartBtn:setTouchEnabled(false)
    self.storeStartBtn:setBright(false)
    self.storeRollList = self.storeRootNode:getChildByName("roll_list"):getChildren()
    for key = 1, 9 do
        local item = self.storeRollList[key]
        if key <= 6 then
            self:setTouchEnabled(item.btn_sub1, false)
            self:setTouchEnabled(item.btn_add1, false)
        else
            self:setTouchEnabled(item.btn_sub1, false)
            self:setTouchEnabled(item.btn_add1, false)

            self:setTouchEnabled(item.btn_sub2, false)
            self:setTouchEnabled(item.btn_add2, false)
        end
    end
    self:setTouchEnabled(self.storefreeItem.btn_sub, false)
    self:setTouchEnabled(self.storefreeItem.btn_add, false)

end
function cls:closeOtherPageBtnEvent()
    self.storeBackBtn:setTouchEnabled(false)
    self.storeBackBtn:setBright(false)

end
--------------------------------- map end--------------------------------------
--------------------------------- baseTop start---------------------------------

function cls:updateBaseCoinsStack(index, notAni)

    if not index then
        if self.coinsStackCount < 10 then
            index = 1
        else
            index = 2
        end
    end
    self.coinsStackCount = self.coinsStackCount or 0

    local aniName = "animation" .. index

    if not self.coinsStackSpine.showIndex or self.coinsStackSpine.showIndex ~= index then
        self.coinsStackSpine.showIndex = index
        bole.spChangeAnimation(self.coinsStackSpine, aniName, true)
        if index == 3 and not notAni then
            if not self.coinFullStack or not bole.isValidNode(self.coinFullStack) then
                local _, s2 = self:addSpineAnimation(self.baseTopNode, 200, self:getPic(SpineConfig.coins_full), cc.p(0, 0), "animation", nil, nil, nil, true, true)
                self.coinFullStack = s2
            end
            self:setBonusTrigger()
            self:playMusic(self.audio_list.bonus_full)
        end
    end
end
function cls:resetCoinStack()
    self.coinsStackCount = 0
    self:updateBaseCoinsStack()
    if self.coinFullStack and bole.isValidNode(self.coinFullStack) then
        self.coinFullStack:removeFromParent()
        self.coinFullStack = nil
    end
end
--------------------------------- baseTop end-----------------------------------

function cls:saveWheelData(type, data)
    if type == 1 then
        LoginControl:getInstance():saveDBWithKey("jackpot_" .. self.themeid, data)
    else
        LoginControl:getInstance():saveDBWithKey("free_" .. self.themeid, data)
    end

end
function cls:getWheelData(type)
    local backdata
    if type == 1 then
        backdata = LoginControl:getInstance():getDBWithKey("jackpot_" .. self.themeid)
    else
        backdata = LoginControl:getInstance():getDBWithKey("free_" .. self.themeid)
    end
    return backdata
end
-----------------------------Transition弹窗相关------------------------------
function cls:playTransition(endCallBack, tType)
    local function delayAction()
        local transition = CleopatraTransition.new(self, endCallBack)
        transition:play(tType)
    end
    delayAction()
end

CleopatraTransition = class("CleopatraTransition", CCSNode)
local GameTransition = CleopatraTransition
function GameTransition:ctor(theme, endCallBack)
    self.spine = nil
    self.theme = theme
    self.endFunc = endCallBack
end
function GameTransition:play(tType)
    local spineFile = self.theme:getPic(SpineConfig.trans_free) -- 默认显示 Free transition
    local pos = cc.p(0, 0)
    local delay1 = transitionDelay[tType]["onEnd"]
    if tType == "free" then
        -- translate1
        self.theme:laterCallBack(0.1, function()
            self.theme:playMusic(self.theme.audio_list.transition_free)
        end)
    elseif tType == "bonus" then
        -- translate2
        self.theme:laterCallBack(0.1, function()
            self.theme:playMusic(self.theme.audio_list.transition_bonus)
        end)
        spineFile = self.theme:getPic(SpineConfig.trans_bonus)
        self.theme:setLogoTrans()
    elseif tType == "bonus1" then
        self.theme:laterCallBack(0.1, function()
            self.theme:playMusic(self.theme.audio_list.transition_bonus1)
        end)

        spineFile = self.theme:getPic(SpineConfig.trans_bonus1)
    elseif tType == "map" then
        self.theme:laterCallBack(0.1, function()
            self.theme:playMusic(self.theme.audio_list.transition_map)
        end)
        spineFile = self.theme:getPic(SpineConfig.trans_map)

    end
    self.theme.curScene:addToContentFooter(self)
    bole.adaptTransition(self, true, true)
    self:setVisible(false)
    self:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(0.1),
                    cc.CallFunc:create(function()
                        local _, s = self.theme:addSpineAnimation(self.theme.flyTranslatesLayer, nil, spineFile, pos, "animation")
                        self:setVisible(true)
                        if tType == "bonus" then
                            bole.adaptReelBoard(s)
                        end
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
    if self.miniWheel then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.miniWheel.scheduler)
    end
    Theme.onExit(self)
end

function cls:enableMapInfoBtn(enable)
    self.isCanFeatureClick = enable

end
function cls:dealMusic_EnterWheelGame()

end
--商店点击购买
function cls:collectFreeRollEnd()
    self:finshSpin()
end
function cls:checkInFeature()
    local inFeature = false
    if self.isFeatureClick then
        inFeature = true
    end
    return inFeature
end
---------------------------------jackpot--------------------------------
function cls:showJackPotDialog(theData, sType, gType)
    theData.bg1 = theData.jackpot
    theData.bg2 = theData.jackpot
    theData.title = theData.jackpot
    theData.label_1 = theData.jackpot
    theData.label_2 = theData.jackpot

    gType = gType or "free"
    local config = {}
    config["gen_path"] = self:getPic("csb/")
    config["csb_file"] = config["gen_path"] .. "dialog_2" .. ".csb"
    config["frame_config"] = {
        ["collect"] = { { 0, 45 }, 1, { 90, 130 }, 0.5, 0.5, 0, 0, 0.5 } -- 最后一个参数 是延时删除的时间 -- 倒数第二个参数 回调 完成方法
    }
    self.freeSpinConfig = config
    local theDialog = G_FREE_SPIN_DIALOGS["base"].new(self.ctl, self.freeSpinConfig, self.featureNode)

    self:addDialogSpine(theDialog, theData, sType, gType)
    local node1 = bole.deepFind(theDialog.collectRoot, "node1")

    local fileName = self:getPic(SpineConfig.dialog2_title)
    local ani1 = "animation" .. theData.jackpot
    local _, s1 = bole.addSpineAnimation(node1, 1, fileName, cc.p(0, 0), ani1, nil, nil, nil, true, true)

    local width = SpineDialogConfig[theData.type][sType].maxWidth
    theDialog:setCollectScaleByValue(theData.coins, width)
    theDialog:showCollect(theData)

end
function cls:getJackpotNum(win_type)

    local base = {
        grand = 5000,
        mega = 1000,
        major = 200,
        minor = 20,
        mini = 10,
    }

    local saveChangeBet = base[win_type]
    if self.superAvgBet then
        return self.superAvgBet * saveChangeBet
    else
        return self.ctl:getCurTotalBet() * saveChangeBet
    end
end

--------------------------------- Bonus start -------------------------------------

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
    if self.ctl.freewin then
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

CleopatraBonus = class("CleopatraBonus")
local bonusGame = CleopatraBonus
function bonusGame:ctor(bonusControl, theme, csbPath, data, callback)
    self.bonusControl = bonusControl
    self.theme = theme
    self.csbPath = csbPath
    self.callback = callback
    self.oldCallBack = callback
    self.data = data
    self.theme.bonus = self
    self.ctl = bonusControl.themeCtl

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

    if self.data.core_data.avg_bet then
        self.theme.superAvgBet = self.data.core_data.avg_bet
    end
    self:initProgressBonusGame()
    -- 隐藏B级活动栏
    if self.ctl.footer then
        self.ctl.footer:hideActivitysNode()
    end
    self.ctl.footer:setSpinButtonState(true)-- 禁掉spin按钮
    self.ctl.footer:enableOtherBtns(false)
    self.theme:enableMapInfoBtn(false)
    self.theme:saveBonusData()

    if tryResume then
        self.isTryResume = true
        local item_list = self.data.core_data.item_list
        if item_list then
            self.ctl:resetBoardCellsSpriteOverBonus(item_list)
        end

        self.callback = function(...)
            -- 断线重连回调方法
            local endCallFunc2 = function(...)
                if self.ctl:noFeatureLeft() then
                    self.ctl.footer:setSpinButtonState(false) -- 开启 footer按钮
                    self.ctl.footer:enableOtherBtns(true)
                    self.theme:enableMapInfoBtn(true)
                else
                    self.ctl.footer:setSpinButtonState(true) -- 开启 footer按钮
                    self.ctl.footer:enableOtherBtns(false)
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
    self:enterBonusGame2(tryResume)
end

function bonusGame:enterBonusGame2(tryResume)
    local wheelData = self.theme:getWheelData(1)
    if not wheelData or wheelData[1] == 0 or wheelData[2] == 0 then
        self:playWheelBonus(tryResume, wheelData)
    else
        self:finishBonusGame()
    end
end

function bonusGame:recoverBaseGame()
    --self.theme.themeAnimateKuang:removeAllChildren()
    self.theme:showAllItem()
    self.ctl.spinning = false

    self.theme:outBonusStage()
    if self.ctl.freewin then
        self.ctl.footer:changeLabelDescription("FS_Win")
        if not self.theme.superAvgBet then
            if self.ctl.footer then
                self.ctl.footer:showActivitysNode()
            end
        end
    else
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
    self.theme.playNormalLoopMusic = false
    self.theme:dealMusic_ExitBonusGame()
    --self.theme.superAvgBet = nil
    if self.ctl:noFeatureLeft() then
        self.ctl.spin_processing = false
    else
        self.theme.remainPointBet = true
    end

    self.theme.bonus = nil
end

function bonusGame:finishBonusGame()
    self.bonusWin = self.bonusWin or self:getProgressList()
    local extraWin = self.data.core_data.extra_win or 0
    local totalWin = self.bonusWin + extraWin
    self.data["end_game"] = true
    self.theme.bonus = nil

    local bonusOver2 = function()
        self:recoverBaseGame()
        if self.callback then
            self.callback()
        end
    end

    local transition = function()
        if self.bonusWin and self.bonusWin > 0 then
            --if self.ctl.freespin and self.ctl.freespin < 1 then
            --    self.ctl.spin_processing = true
            --end

            self.ctl:startRollup(totalWin, bonusOver2)
            self.bonusWin = 0
        else
            bonusOver2()
        end
    end
    if self.ctl:noFeatureLeft() then
        -- 切换滚轴回 free
        self.ctl.footer.isFreeSpin = false
    else
        self.ctl.footer.isFreeSpin = true
    end
    self.PickDialog:finishPickGame()
    self.theme:setLogoStatus()
    --bole.spChangeAnimation(self.theme.logoCharSpineNode, "animation1", true)
    self.theme:laterCallBack(transitionDelay["bonus"].onCover, function()
        self.theme.superAvgBet = nil
        self.ctl:removePointBet()
        self.ctl.footer:changeNormalLayout2()
    end)
    self.theme:laterCallBack(transitionDelay["bonus"].onEnd, transition)

end
function bonusGame:rollupJackWin()
    if self.ctl:noFeatureLeft() then
        -- 切换滚轴回 free
        self.ctl.footer.isFreeSpin = false
    else
        self.ctl.footer.isFreeSpin = true
    end
    local extraWin = self.data.core_data.extra_win or 0
    local totalWin = self.bonusWin + extraWin
    self.ctl.spin_processing = true
    local changeLayer = function()
        self.theme.superAvgBet = nil
        self.ctl:removePointBet()
        self.ctl.footer:changeNormalLayout2()
        self.theme:setLogoStatus()
    end
    local transFinish = function()
        self:recoverBaseGame()
        if self.callback then
            self.callback()
        end
    end
    local rollupOver = function()
        self.PickDialog:finishPickGame()
        self.theme:laterCallBack(transitionDelay["bonus"].onCover, changeLayer)
        self.theme:laterCallBack(transitionDelay["bonus"].onEnd, transFinish)
        self.ctl.footer:enableOtherBtns(false)
        self.ctl.footer:setSpinButtonState(true) --
    end
    if totalWin > 0 then
        self.ctl:startRollup(totalWin, rollupOver)
    else
        rollupOver()
    end
end
--------------------------------- jackpot start -------------------------------------

function bonusGame:getProgressList()


    local type_jack = self.data.core_data.win_jp[1].jp_win_type + 1
    local base_jack = self.data.core_data.win_jp[1].jp_win
    local tail_jack = self.data.core_data.progressive_list[type_jack]
    local win = base_jack + tail_jack
    return win
end
function bonusGame:initJackPotDialog()

    local theData = {}
    self.bonusWin = self:getProgressList()

    theData.coins = self.bonusWin
    theData.type = 2
    theData.jackpot = self.data.core_data.win_jp[1].jp_win_type + 1

    theData.enter_event = function()
        self.ctl.footer:onEnterFreeSpinDialog() -- 控制 footer 的 按钮不可点击
        self.theme:dealMusic_FadeLoopMusic(0.3, 1, 0.1)
        --AudioControl:stopGroupAudio("music")
        --self.theme:dealMusic_PlayBonusCollectMusic()
        self.theme:playMusic(self.theme.audio_list["jp_dialog_collect_show"])

    end
    theData.click_event = function()
        self.theme:playMusic(self.theme.audio_list.btn_click)
        self.theme:saveWheelData(1, { 1, 1 })
        self.ctl:collectCoins(1)
        self.theme:saveWheelData(1, nil)
        self.theme:resetCoinStack()
        self:saveBonus()
    end
    theData.end_event = function()
        --self:finishBonusGame()
        self:rollupJackWin()
        --
        local progress_spine = self.theme.jackpotSpine
        progress_spine:removeAllChildren()

    end

    self.theme:showJackPotDialog(theData, fs_show_type.collect)
end
--
function bonusGame:playWheelBonus(tryResume, wheelData)
    --local data = {}
    --data["mapLevel"] = self.mapLevel
    local endCallFunc = function()
        local jpType = self.data.core_data.win_jp[1].jp_win_type + 1
        self.theme:jackpotTriggerBoom(jpType)

        self.theme:laterCallBack(1, function()
            self:initJackPotDialog()
        end)

    end
    local win_index = self.data.core_data.index

    self.PickDialog = CleopatraPick.new(self.theme, self.theme:getPic("csb/"), { win_index = win_index }, endCallFunc, 1, tryResume)
    self.PickDialog:enterPickGame(tryResume)


end

--------------------------------- pickGame ---------------------------------
CleopatraPick = class("CleopatraPick", CCSNode)
local pickGame = CleopatraPick

function pickGame:ctor(theme, csbPath, data, callback, status, tryResume)
    self.theme = theme
    self.csbPath = csbPath
    self.csb = csbPath .. "wheel.csb"
    self.data = data
    self.ctl = theme.ctl
    self.status = status
    CCSNode.ctor(self, self.csb)
    self:initLayout(tryResume)

    self.callback = function()
        if callback then
            callback()
        end

    end
end

function pickGame:initLayout(tryResume)
    self.ctl.footer:setSpinButtonState(true) -- 禁用footer 按钮
    self.ctl.footer:enableOtherBtns(false) -- 禁用footer 按钮

    self.theme.wheel_node:addChild(self)

    self.root = self.node:getChildByName("root")
    self.startRoot = self.root:getChildByName("node_start")
    self.wheelBg = self.node:getChildByName("bg_wheel")
    self.pickWin = self.ctl.totalWin or 0
    if self.startRoot then

        self.clipNode = self.startRoot:getChildByName("clip")
        self.pickStartBtn = self.startRoot:getChildByName("btn_start")
        self.spineParent = self.startRoot:getChildByName("spine")
        self.spineParent1 = self.startRoot:getChildByName("spine1")
        self.chosenKuang1 = self.startRoot:getChildByName("chosen_1")
        self.chosenKuang2 = self.startRoot:getChildByName("chosen_2")

        if self.status == WheelBoardType.JackPot then
            self.chosenKuang1:setVisible(true)
            self.chosenKuang2:setVisible(false)
            self.chosenKuang = self.chosenKuang1
        else
            self.chosenKuang1:setVisible(false)
            self.chosenKuang2:setVisible(true)
            self.chosenKuang = self.chosenKuang2
        end
        self.chosenPointLeft = self.chosenKuang:getChildByName("point_left")
        self.chosenPointRight = self.chosenKuang:getChildByName("point_right")

        self:initWheelItemList()
    end
    self:setVisible(false)
end
function pickGame:initWheelItemList()
    local curMiniGameReel = miniGameReel[self.status]
    self.curItems = {}
    local itemListNode = self.clipNode:getChildByName("item_list")
    itemListNode:removeAllChildren()

    if self.status == 1 then

        self:initJackpotLayout(itemListNode, curMiniGameReel)
    else
        self:initFreeGameLayout(itemListNode, curMiniGameReel)
    end
    self.itemsList = itemListNode:getChildren()
    local finshKey = miniGameReel[self.status][self.data.win_index] -- resultKeyList[self.data.bonus_level + 1][self.data.fg_index]
    local finshPos = 0
    local callBack = function()
        self:finishWheel()

    end
    self:createMiniReel(finshKey, finshPos, callBack)
end
function pickGame:startWheelAni()
    local spine = self.theme:getPic(SpineConfig.wheel_start_light)
    local _, s1 = bole.addSpineAnimation(self.spineParent1, -1, spine, cc.p(0, 78), "animation")


end
function pickGame:finishAni2()
    self.theme:dealMusic_exitWheelLoopMusic()
    self.theme:playMusic(self.theme.audio_list.wheel_finish)
    local spine1 = self.theme:getPic(SpineConfig.wheel_stop)
    local _, s2 = bole.addSpineAnimation(self.spineParent1, -1, spine1, cc.p(0, 78), "animation", nil, nil, nil, true, false)-- 出现
    s2:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(35 / 30),
                    cc.CallFunc:create(
                            function()
                                bole.spChangeAnimation(s2, "animation", false)
                            end
                    ),
                    cc.DelayTime:create(35 / 30),
                    cc.RemoveSelf:create()
            )
    )
end
function pickGame:finishWheel()


    local data = { 1, 0 }

    self.theme:saveWheelData(self.status, data)
    --self:finishAni1()
    if self.status == 1 then
        self.theme:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(1), -- 复位时间
                        cc.CallFunc:create(
                                function()
                                    self:finishAni2()
                                end
                        ),
                        cc.DelayTime:create(1),
                        cc.CallFunc:create(function(...)
                            if self.callback then
                                self.callback()
                                self.callback = nil
                            end
                        end)
                )
        )
    else
        self.theme:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(1), -- 复位时间
                        cc.CallFunc:create(
                                function()
                                    self:finishAni2()
                                end
                        ),
                        cc.DelayTime:create(1),
                        cc.CallFunc:create(
                                function(...)
                                    self:finishPickGame()
                                end)
                )
        )
    end


end
function pickGame:initJackpotLayout(itemListNode, curMiniGameReel)

    for i = 1, 7 do

        self.wheelCsbPath = self.theme:getPic("csb/wheel_item.csb")
        local item = cc.CSLoader:createNode(self.wheelCsbPath)
        itemListNode:addChild(item)
        local keyValue = curMiniGameReel[i]
        self:updateCellReelSprite(item, keyValue, 1)

        table.insert(self.curItems, { curMiniGameReel[i], item }) -- key 和相应的 item 从0
    end
end
function pickGame:updateCellReelSprite(theCellNode, keyValue, status)

    local desc_1 = theCellNode:getChildByName("desc_1")
    local desc_2 = theCellNode:getChildByName("desc_2")
    local desc_3 = theCellNode:getChildByName("desc_3")
    local curdesc
    local img_bg
    local index = keyValue % 10
    if status == 1 then
        if keyValue <= 5 then
            desc_1:setVisible(true)
            desc_2:setVisible(false)
            desc_3:setVisible(false)
            curdesc = desc_1
        else
            desc_1:setVisible(false)
            desc_2:setVisible(true)
            desc_3:setVisible(false)
            curdesc = desc_2
        end
        if keyValue > 5 then
            local fnt = curdesc:getChildByName("fnt")
            local detail = self.theme.superAvgBet
            if keyValue == 6 then
                detail = detail * 5
                index = 4
            else
                detail = detail * 2
                index = 5
            end

            fnt.baseScale = 1
            fnt.maxWidth = 152
            fnt.maxCount = 4
            local value_str = FONTS.formatByCount4(detail, fnt.maxCount, true)
            fnt:setString(value_str)
            bole.shrinkLabel(fnt, fnt.maxWidth, fnt.baseScale)


        end
        img_bg = "#theme186_wheel_bg" .. index .. ".png"
        local jp_text = curdesc:getChildByName("text")
        local jp_img = "#theme186_text_jp" .. index .. ".png"
        bole.updateSpriteWithFile(jp_text, jp_img)
    else
        desc_1:setVisible(false)
        desc_2:setVisible(false)
        desc_3:setVisible(true)
        local bgIndex = index + 1
        if index == 1 then
            bgIndex = 5
        elseif index == 4 then
            bgIndex = 2
        end
        img_bg = "#theme186_wheel_bg" .. bgIndex .. ".png"
        curdesc = desc_3
        local free_text = curdesc:getChildByName("text")
        local free_img = "#theme186_text_win" .. index .. ".png"
        bole.updateSpriteWithFile(free_text, free_img)

        local _7_text = curdesc:getChildByName("index")
        local _7_img = "#theme186_text_7_" .. index .. ".png"
        bole.updateSpriteWithFile(_7_text, _7_img)
    end

    local bg_node = theCellNode:getChildByName("bg")
    bole.updateSpriteWithFile(bg_node, img_bg)


end
function pickGame:initFreeGameLayout(itemListNode, curMiniGameReel)

    for i = 1, 5 do
        self.wheelCsbPath = self.theme:getPic("csb/wheel_item.csb")
        local item = cc.CSLoader:createNode(self.wheelCsbPath)
        itemListNode:addChild(item)
        local keyValue = curMiniGameReel[i]
        self:updateCellReelSprite(item, keyValue, 2)
        table.insert(self.curItems, { curMiniGameReel[i], item }) -- key 和相应的 item 从0 开始
    end
end
local endSpinePos = cc.p(0, 0)
function pickGame:createMiniReel(finshKey, finshPos, callFunc)
    local height = 0
    local width = 195
    local startPos = math.random(1, #self.itemsList)

    local tryResume = false
    if self.status == 1 then
        local wheelinfo = self.theme:getWheelData(1)
        if wheelinfo and wheelinfo[1] == 1 then
            tryResume = true
        end
    end
    if tryResume then
        startPos = self.data.win_index - 1
        startPos = (startPos + 7 - 1) % 7 + 1
    end
    local itemCount = 7
    if self.status == 2 then
        itemCount = 5
    end
    local startDis = 0
    local data = {
        ["itemCount"] = 5, -- 3, -- 上下加一个 cell 之后的个数
        ["key"] = finshKey,
        ["finshRollSumLength"] = 1, -- 结束阶段会滚过几遍总共的Count
        ["cellSize"] = cc.p(width, height),
        ["delayBeforeSpin"] = 0.0, --开始旋转前的时间延迟
        ["upBounce"] = 0, --开始滚动前，向上滚动距离
        ["upBounceTime"] = 0, --开始滚动前，向上滚动时间
        ["speedUpTime"] = 0.5, --加速时间
        ["rotateTime"] = 2.0, -- 匀速转动的时间之和
        ["maxSpeed"] = 1 / 6 * width * 60, --每一秒滚动的距离
        ["downBounce"] = 0, --滚动结束前，向下反弹距离  都为正数值
        ["speedDownTime"] = 3.3, -- 4
        ["downBounceTime"] = 0,

        ["deltaType"] = 2,
        ["addEndPos"] = -width,
        ["addStartPos"] = 0,
        ["direction"] = 1, --横向
        ["specailHorizontal"] = 1,
        ["startIndex"] = startPos, -- 随机的是 index 格子的 而不是 key
    }
    self.miniReel = BaseReel.new(self, self.curItems, data, callFunc)

    if self.status == 1 then
        for k, icon in ipairs(self.curItems) do
            icon[2]:setPositionX(icon[2]:getPositionX() + width)
        end
        while self.miniReel:_firstIcon():getPositionX() > self.miniReel._firstP.x do
            self.miniReel:moveToHead()
        end
    end

end
function pickGame:enterPickGame(tryResume)
    local function playIntro()
        -- 第一次进入
        self:showStartTransition()
    end

    local function snapIntro()
        -- 重连进入
        -- 断线重连的 回调方法

        local wheelinfo = self.theme:getWheelData(1)
        if wheelinfo and wheelinfo[1] == 1 then

            self:showPickNode(false)
            --self.pickStartBtn:setVisible(false)
            if wheelinfo[2] == 0 then
                self.callback()
                self.callback = nil
            end
        else
            self:showPickNode(true)
            self.theme:runAction(
                    cc.Sequence:create(
                            cc.DelayTime:create(1),
                            cc.CallFunc:create(
                                    function(...)
                                        self.theme:dealMusic_PlayWheelLoopMusic()
                                        self:openReel()
                                    end
                            )
                    )
            )

        end
    end
    if tryResume then
        snapIntro()
    else
        playIntro()
    end
end

function pickGame:finishPickGame(tryResume, delay)
    -- local endFunc = nil
    local free_type = "free"
    if self.status == 1 then
        free_type = "bonus1"
    end
    self:runAction(cc.Sequence:create(-- 显示弹窗 FREE 次数
    --cc.DelayTime:create(delay),
            cc.CallFunc:create(function(...)
                self.theme:playTransition(nil, free_type)
            end),
            cc.DelayTime:create(transitionDelay[free_type].onCover), -- 切屏覆盖全屏时间
            cc.CallFunc:create(function(...)
                if self.callback then
                    self.callback()
                    self.callback = nil
                end
                self:showWheelBg(false)
            end),
            cc.RemoveSelf:create()
    ))
end

function pickGame:showWheelBg(isshow, status)
    if isshow then
        local imgWheelBG = { "image/bg/theme186_bg_wheeljp.png", "image/bg/theme186_bg_wheel1.png" }
        local img = imgWheelBG[status]
        bole.updateSpriteWithFile(self.wheelBg, self.theme:getPic(img))
        self.wheelBg:setVisible(true)
        self.wheelBg:setOpacity(0)
        self.wheelBg:runAction(
                cc.FadeIn:create(0.5)
        )
    else
        self.wheelBg:runAction(
                cc.Sequence:create(
                        cc.FadeOut:create(0.5),
                        cc.CallFunc:create(
                                function()
                                    self.wheelBg:setVisible(false)
                                end)
                )

        )
    end
end

function pickGame:openReel()
    self.isClick = false
    local function onTouch(obj, eventType)
        if self.isClick then
            return nil
        end

        if eventType == ccui.TouchEventType.ended then
            self.isClick = true

            if self.pickStartSpine and bole.isValidNode(self.pickStartSpine) then
                bole.spChangeAnimation(self.pickStartSpine, "animation2", false)
            end

            self.theme:playMusic(self.theme.audio_list.wheel_press)
            -- 开始调用滚动
            self:startWheelAni()
            self.theme:laterCallBack(1, function()

                self.pickStartSpine:removeFromParent()
                self.pickStartSpine = nil
                self.theme:playMusic(self.theme.audio_list.bonus_wheel_spin)

                self.miniReel:startSpin()
            end)
        end
    end
    -- 设置按钮的点击事件
    self.pickStartBtn:addTouchEventListener(onTouch)
end

function pickGame:transitionOverFunc(...)
    self:openReel()
    self.theme:dealMusic_PlayWheelLoopMusic()
end

function pickGame:showStartTransition(endFunc)

    local free_type = "free"
    if self.status == 1 then
        free_type = "bonus"
    end
    self.theme:playTransition(endFunc, free_type)
    self:runAction(cc.Sequence:create(
            cc.DelayTime:create(transitionDelay[free_type].onCover), -- 切屏覆盖全屏时间
            cc.CallFunc:create(function(...)
                self:showPickNode(true)
            end),
            cc.DelayTime:create(transitionDelay[free_type].onEnd - transitionDelay[free_type].onCover),
            cc.CallFunc:create(
                    function()
                        self:transitionOverFunc()
                    end
            )
    ))
end
function pickGame:showPickNode(showStartBtn)
    self:setVisible(true)
    self.node:setVisible(true)
    self:showWheelBg(true, self.status)
    if self.theme.superAvgBet then
        self.ctl:setPointBet(self.theme.superAvgBet)
        self.ctl.footer:isShowTotalBetLayout2(false)
    end
    if showStartBtn then
        self.startRoot:setOpacity(0)
        self.startRoot:runAction(cc.FadeIn:create(0.5))
        local spine = self.theme:getPic(SpineConfig.wheel_start)
        local _, s1 = bole.addSpineAnimation(self.spineParent1, -1, spine, cc.p(0, 150), "animation1", nil, nil, nil, true, true)-- 出现
        self.pickStartSpine = s1
        self.pickStartBtn:setVisible(true)
    else
        self.pickStartBtn:setVisible(false)
    end

end
function pickGame:onExit(...)
    if self.theme.superAvgBet then
        self.ctl:removePointBet()
        self.theme.superAvgBet = nil
        self.ctl.footer:changeNormalLayout2()
    end

    if self.miniReel then
        if self.miniReel.scheduler then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.miniReel.scheduler)
            self.miniReel.scheduler = nil
        end
    end
end

---@desc 打乱一个数组的顺序
---@param t :原始数组
---@return :打乱后的顺序


local CDialogConfig = {
    [1] = {
        spine = SpineConfig.free_beetle, --
        pos = { cc.p(-134, -143), cc.p(0, -29), cc.p(134, -143) }
    },
    [2] = {
        img = "#theme186_free_text_muti_%s.png",
        pos = { cc.p(-134, -143), cc.p(0, -29), cc.p(134, -143) }
    },
}
CleopatraDialog = class("CleopatraDialog", CCSNode)
local CDialog = CleopatraDialog
function CDialog:ctor(pThemeCtr, pConfig)
    self.themeCtr = pThemeCtr
    self.theme = pThemeCtr.theme
    self.genPath = pConfig["gen_path"]
    self.csb = pConfig["csb_file"]
    self.frameConfig = pConfig["frame_config"]
    self.sceneSize = bole.getSceneSize()
    self.centerPos = cc.p(self.sceneSize.width / 2, self.sceneSize.height / 2)
    CCSNode.ctor(self, self.csb)
end
function CDialog:loadControls()
    self.root = self.node:getChildByName("root")
    self.baseRoot = self.root:getChildByName("node_base") -- whj 添加 用来执行 操作 start more 或者 collect 共同存在的背景
    self.startRoot = self.root:getChildByName("node_start")
    self.collectRoot = self.root:getChildByName("node_collect")
    if self.collectRoot then
        self.collectRoot.btnCollect = bole.deepFind(self.collectRoot, "btn_collect")
        self.collectRoot.labelWin = bole.deepFind(self.collectRoot, "label_coins")
        self.collectRoot.spineNode = bole.deepFind(self.collectRoot, "spine")
    end


end
function CDialog:showStart(pFsData, pEndCallFunc, parent)
    self.fsData = pFsData
    self.endCallFunc = pEndCallFunc
    self.curFrameConfig = self.frameConfig["start"]

    if self.fsData.type <= 2 then
        self.startRoot.btnStart = bole.deepFind(self.startRoot, "btn_start")
        local size = self.startRoot.btnStart:getContentSize()
        local ani_name = "animation2"
        local ani_File = SpineConfig.dialog1_btn
        local _, s = bole.addSpineAnimation(self.startRoot.btnStart, nil, self.theme:getPic(ani_File), cc.p(size.width / 2, size.height / 2), ani_name, nil, nil, nil, true, true)
        self.root:setPosition(cc.p(0, 161))
    else
        self.root:setPosition(cc.p(0, 205))
        self:initBtnMoreStart()
    end
    local initEventFunc = function()
        self:initStartEvent()
    end
    local intLayoutFunc = function()
        self:initStartLayout()
    end
    self:show(initEventFunc, intLayoutFunc, parent)
end
-- 多个按钮的start
function CDialog:initBtnMoreStart()
    self.desc1 = self.startRoot:getChildByName("desc1")
    self.desc2 = self.startRoot:getChildByName("desc2")
    self.desc2:removeAllChildren()
    self.desc1:removeAllChildren()
    self.desc_btn = self.startRoot:getChildByName("desc_btn")
    self.title1 = self.startRoot:getChildByName("title1")
    self.title2 = self.startRoot:getChildByName("title2")
    self.title1:setVisible(true)
    self.title2:setVisible(false)
    for key = 1, 3 do
        self.startRoot["btnStart_" .. key] = self.desc_btn:getChildByName("btn_" .. key)

        local spine = CDialogConfig[1].spine
        local _, s1 = bole.addSpineAnimation(self.desc1, -1, self.theme:getPic(spine), CDialogConfig[1].pos[key], "animation1", nil, nil, nil, true, true)-- 出现
        s1:setName("spine_" .. key)
    end
end
function CDialog:initClickOver(touchIndex, showMulti, isChoose)
    local beetle_node = self.desc1:getChildByName("spine_" .. touchIndex)
    if isChoose then
        bole.spChangeAnimation(beetle_node, "animation3", false)
    else
        local colorDark = cc.c3b(150, 150, 150)
        beetle_node:setColor(colorDark)
    end
    local muti_img = CDialogConfig[2].img
    local muti_node = bole.createSpriteWithFile(string.format(muti_img, showMulti))
    self.desc2:addChild(muti_node)
    muti_node:setName("muti_" .. touchIndex)
    muti_node:setPosition(CDialogConfig[2].pos[touchIndex])
    muti_node:setScale(0.5)
    muti_node:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(25 / 30),
                    cc.CallFunc:create(
                            function()
                                if not isChoose then
                                    beetle_node:runAction(cc.FadeOut:create(10 / 30))
                                end
                            end
                    ),
                    cc.ScaleTo:create(0.2, 1.8),
                    cc.ScaleTo:create(0.1, 1.45)

            )
    )
    if not isChoose then
        local colorDark = cc.c3b(95, 95, 95)
        muti_node:setColor(colorDark)
    end

end
function CDialog:initStartEvent()
    self.isClick = false
    local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            sender:setEnabled(false)

            self:startFreespin(sender)
        end
    end
    if self.fsData.type <= 2 then
        self.startRoot.btnStart:addTouchEventListener(btnEvent)
    else
        self.startRoot.btnStart_1.touchIndex = 1
        self.startRoot.btnStart_1:addTouchEventListener(btnEvent)

        self.startRoot.btnStart_2.touchIndex = 2
        self.startRoot.btnStart_2:addTouchEventListener(btnEvent)

        self.startRoot.btnStart_3.touchIndex = 3
        self.startRoot.btnStart_3:addTouchEventListener(btnEvent)
    end
end
function CDialog:initStartLayout()
    self.startRoot:setVisible(true)
    if self.baseRoot then
        self.baseRoot:setVisible(true)
    end
    if self.fsData.type >= 3 then
        local spine = self.startRoot:getChildByName("spine")
        local _, s1 = bole.addSpineAnimation(spine, 1, self.theme:getPic(SpineConfig.dialog1_start_frame), cc.p(0, -56), "animation", nil, nil, nil, true, true)
        s1:setScale(1.25)
    end
end
function CDialog:show(initEventFunc, intLayoutFunc, parent)

    if parent then
        parent:addChild(self)
        --self:setPosition(cc.p(0, 291.00))
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
function CDialog:startFreespin(sender)
    if self.isClick then
        return
    end
    self.theme:setWheelFreeData({ 1, 1 })
    self.isClick = true
    local endCallBack = function()
        if self.fsData["click_event"] then
            self.fsData["click_event"]()
        end
        self:hide()
    end

    if self.fsData.type <= 2 then
        self.theme:playMusic(self.theme.audio_list.btn_click)
        self.startRoot.btnStart:setTouchEnabled(false)
        endCallBack()
    else
        self.theme:playMusic(self.theme.audio_list.beetle_pick)
        self.startRoot.btnStart_1:setTouchEnabled(false)
        self.startRoot.btnStart_2:setTouchEnabled(false)
        self.startRoot.btnStart_3:setTouchEnabled(false)
        self:updateChooseItem(sender.touchIndex, endCallBack)
    end
end
function CDialog:updateChooseItem(touchIndex, endCallBack)

    local chooseList = { 6, 8, 10 }
    local chooseItem = { }
    for key = 1, 3 do
        local choseItem = chooseList[key]
        if choseItem == self.fsData.fg_muti then
        else
            table.insert(chooseItem, choseItem)
        end
    end
    local b = self:chosenListShuffle(chooseItem)

    local show_node = self.desc1:getChildByName("spine_" .. touchIndex)
    bole.spChangeAnimation(show_node, "animation2", false)

    local titleChange = function()
        self.title1:runAction(cc.FadeOut:create(0.5))
        self.title2:setVisible(true)
        self.title2:setOpacity(0)
        self.title2:runAction(cc.FadeIn:create(0.5))
    end
    local a1_delay = cc.DelayTime:create(25 / 30)
    local a1_action = cc.CallFunc:create(
            function()
                local index = 1

                for key = 1, 3 do
                    if key == touchIndex then
                        self:initClickOver(touchIndex, self.fsData.fg_muti, true)
                    else
                        self:initClickOver(key, b[index])
                        index = index + 1
                    end
                end
            end
    )
    local a2_delay = cc.DelayTime:create(25 / 30)
    local a4_action = cc.CallFunc:create(titleChange)
    local a4_delay = cc.DelayTime:create(15 / 30)
    --local a2_action = cc.CallFunc:create(
    --        function()
    --            self:flyMutiAction(touchIndex)
    --        end
    --)
    --local delayTm = 1
    --if self.fsData.type >= 3 then
    --    delayTm = 2
    --end
    --local a3_delay = cc.DelayTime:create(delayTm)
    local a3_action = cc.CallFunc:create(endCallBack)
    self:runAction(
            cc.Sequence:create(
                    a1_delay, a1_action,
                    a2_delay, a4_action,
                    a4_delay, a4_delay,
                    a3_action
            )
    )

end
function CDialog:hide()
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
function CDialog:chosenListShuffle(t)
    if type(t) ~= "table" then
        return
    end
    local tab = {}
    local index = 1
    while #t ~= 0 do
        local n = math.random(0, #t)
        if t[n] ~= nil then
            tab[index] = t[n]
            table.remove(t, n)
            index = index + 1
        end
    end
    return tab
end
function CDialog:showCollect(pFsData, pEndCallFunc, parent)
    self.fsData = pFsData
    self.endCallFunc = pEndCallFunc
    self.curFrameConfig = self.frameConfig["collect"]
    self.isCollect = false
    if not self.collectRoot then
        self:directOut()
        return nil
    end
    local initEventFunc = function()
        self:initCollectEvent()
    end
    local intLayoutFunc = function()
        self:initCollectLayout()
    end
    self:show(initEventFunc, intLayoutFunc, parent)
end
function CDialog:initCollectLayout()
    if self.baseRoot then
        self.baseRoot:setVisible(true)
    end

    self.collectRoot:setVisible(true)

    -- 收集弹窗控制都不显示
    if self.collectRoot.noCollectNode then
        self.collectRoot.noCollectNode:setVisible(false)
    end
    if self.collectRoot.collectNode then
        self.collectRoot.collectNode:setVisible(false)
    end

    self.isRollEnd = false

    -- 控制 如果没有赢钱 直接显示没有的

    if self.collectRoot.collectNode then
        self.collectRoot.collectNode:setVisible(true)
    end

    if self.collectRoot.labelWin then
        local function parseValue(num)
            return FONTS.format(num, true)
        end
        inherit(self.collectRoot.labelWin, LabelNumRoll)
        self.collectRoot.labelWin:nrInit(0, 24, parseValue)
        if self.fsData["coins"] > 0 then
            self.collectRoot.labelWin:nrStartRoll(0, self.fsData["coins"], 3)
        end
    end

    if self.collectRoot.labelDesc then
        self.collectRoot.labelDesc:setString("IN " .. self.fsData["sum_count"] .. " FREE GAMES")
    end
    if self.collectRoot.labelCount then
        self.collectRoot.labelCount:setString(self.fsData["sum_count"])
    end
end

function CDialog:updateCollectWin(addCoins)
    local curCoins = self.fsData.coins
    local nextCoins = curCoins + addCoins
    self.fsData.coins = nextCoins

    if nextCoins > 0 then
        self.collectRoot.labelWin:setString(FONTS.format(nextCoins, true))
        bole.shrinkLabel(self.collectRoot.labelWin, self.collectRoot.labelWin.maxWidth, self.collectRoot.labelWin.baseScale)
        self.collectRoot.labelWin:nrStartRoll(curCoins, nextCoins, 0.3)
    end
end
function CDialog:updateWinCoinList()

    self:collectflyFinish()
end
function CDialog:collectflyFinish()
    local action = cc.CSLoader:createTimeline(self.csb)
    self.node:runAction(action)
    self.theme:playMusic(self.theme.audio_list.fg_btn_out)
    action:gotoFrameAndPlay(25, 45, false)
end
function CDialog:initCollectEvent()
    self.isClick = false
    local function btnEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            sender:setEnabled(false)

            if not self.isCollect then
                self.isCollect = true
                self.theme:playMusic(self.theme.audio_list.btn_click)
                self:collectFreespin()
                self:hide()
            end
        end
    end
    if self.collectRoot.btnCollect then
        self.collectRoot.btnCollect:addTouchEventListener(btnEvent)
    end
    if self.collectRoot.noCollectBtn then
        self.collectRoot.noCollectBtn:addTouchEventListener(btnEvent)
    end
end
function CDialog:collectFreespin()
    if self.isClick then
        return
    end
    self.isClick = true
    if self.collectRoot.btnCollect then
        self.collectRoot.btnCollect:setTouchEnabled(false)
    end
    if self.collectRoot.noCollectBtn then
        self.collectRoot.noCollectBtn:setTouchEnabled(false)
    end
    if self.collectRoot.labelWin and self.fsData.coins > 0 then
        if self.collectRoot.labelWin.nrOverRoll then
            self.collectRoot.labelWin:nrOverRoll()
        end
        self.collectRoot.labelWin:setString(FONTS.format(self.fsData["coins"], true))
    end
    if self.fsData["click_event"] then
        self.fsData["click_event"]()
    end
end
function CDialog:setCollectScaleByValue(Value, maxWidth)

    if self.collectRoot.labelWin and maxWidth then
        self.collectRoot.labelWin.maxWidth = maxWidth
        self.collectRoot.labelWin.baseScale = self.collectRoot.labelWin:getScale()
        if Value and Value > 0 then
            self.collectRoot.labelWin:setString(FONTS.format(Value, true))
            bole.shrinkLabel(self.collectRoot.labelWin, maxWidth, self.collectRoot.labelWin.baseScale)
        else
            self.collectRoot.labelWin:setString("")
        end

    end
end
function cls:configAudioList()
    Theme.configAudioList(self)
    self.audio_list = self.audio_list or {}
    --base
    self.audio_list.btn_click = "audio/base/btn_click.mp3"
    self.audio_list.transition_free = "audio/base/transition3.mp3" --艳后切屏
    self.audio_list.transition_bonus = "audio/base/transition2.mp3" --艳后扬起金币切屏
    self.audio_list.transition_bonus1 = "audio/base/transition1.mp3" --金币上扬切屏
    self.audio_list.transition_map = "audio/base/transition4.mp3" --金字塔切屏
    self.audio_list.trigger_bell = "audio/base/bell.mp3"
    self.audio_list.anticipation1_2 = "audio/base/anticipation1.mp3" --轮轴加速音效，一段旋律
    self.audio_list.anticipation_all = "audio/base/anticipation2.mp3"--棋盘撒金币，配合特效
    self.audio_list.reel_down = "audio/base/reel_down.mp3"

    self.audio_list.scatter_landing = "audio/base/symbol_scatter.mp3"
    self.audio_list.bonus_landing = "audio/base/symbol_bonus.mp3"

    --bonus
    self.audio_list.bonus_full = "audio/bonus/full.mp3"
    self.audio_list.bonus_wild_fly = "audio/bonus/wild_fly.mp3"
    self.audio_list.bonus_trigger = "audio/bonus/bonus_trigger.mp3"
    --collect
    self.audio_list.unlock = "audio/collect/collect_unlock.mp3"
    self.audio_list.lock = "audio/collect/collect_lock.mp3"
    self.audio_list.collect_fly = "audio/collect/collect_fly.mp3"
    -- free
    self.audio_list.free_background = "audio/free/free_bgm.mp3"
    self.audio_list.free_dialog_collect_show = "audio/free/popup_out.mp3"
    self.audio_list.free_finish = "audio/free/fg_end.mp3"
    self.audio_list.dialog_lastspin = "audio/free/dialog_lastspin.mp3"
    self.audio_list.free_kuang = "audio/free/kuang.mp3"

    --self.audio_list.free_dialog_start_show = "audio/free/free_dialog_start_show.mp3"

    self.audio_list.beetle_pick = "audio/free/pick.mp3"
    --self.audio_list.fg_collect = "audio/free/collect.mp3" --结算时向winner框飞粒子+接收
    self.audio_list.fg_btn_out = "audio/free/btn_out.mp3" --collect 按钮弹出
    --7prize
    self.audio_list.bonus_num = "audio/free/bonus_num.mp3"

    self.audio_list.wild_out = "audio/free/wild_out.mp3"
    --7spins
    self.audio_list.fg_mul = "audio/free/mul.mp3"
    self.audio_list.fg_mul_fly = "audio/free/mul_fly.mp3"
    --7wins
    -- map
    self.audio_list.store_choose1 = "audio/store/choose1.mp3"
    self.audio_list.store_choose2 = "audio/store/choose2.mp3"
    -- mapfree
    self.audio_list.mapfree_background = "audio/mapfree/superfg_bgm.mp3"
    self.audio_list.mapfree_dialog_collect_show = "audio/mapfree/dialog_sfg_collect.mp3"
    self.audio_list.mapfree_wild_out2 = "audio/mapfree/wild_out2.mp3" --wild出现在棋盘上
    self.audio_list.mapfree_wild_expand = "audio/mapfree/wild_expand.mp3" --wild扩展
    --wheel
    self.audio_list.wheel_press = "audio/wheel/press.mp3" -- 大轮轴上的Symbol被激活时的声音 -- 结束
    self.audio_list.wheel_finish = "audio/wheel/wheel_win.mp3" -- 大轮轴上的Symbol被激活时的声音 -- 结束
    self.audio_list.bonus_wheel_spin = "audio/wheel/wheel_spin.mp3" -- 大轮轴旋转的音效（从启动到停）
    --self.audio_list.wheel_background = "audio/wheel/bonus_bgm.mp3" -- 大轮轴旋转的音效（从启动到停）
    -- jackpot
    self.audio_list.jp_dialog_collect_show = "audio/jackpot/dialog_jackpot_collect.mp3"

    self.audio_win_list = self.audio_win_list or {}
    self.audio_win_list.commonrollup03 = nil
    self.audio_win_list.commonrollup03_end = nil

end
function cls:getLoadMusicList()
    local loadMuscList = {
        --common
        self.audio_list.trigger_bell, --
        self.audio_list.reel_stop, --
        self.audio_list.btn_click, --
        --base
        self.audio_list.transition_free, --
        self.audio_list.transition_bonus, --
        self.audio_list.transition_bonus1, --
        self.audio_list.transition_map, --
        self.audio_list.bonus_landing, --
        self.audio_list.scatter_landing, --
        self.audio_list.anticipation1_2,
        self.audio_list.anticipation_all,
        self.audio_list.reel_down,
        --bonus
        self.audio_list.bonus_full,
        self.audio_list.bonus_wild_fly,
        self.audio_list.bonus_trigger,
        --collect
        self.audio_list.unlock, --
        self.audio_list.lock, --
        self.audio_list.collect_fly, --
        -- free
        self.audio_list.free_dialog_collect_show, --
        self.audio_list.free_finish, --
        self.audio_list.free_background, --
        self.audio_list.dialog_lastspin, --
        self.audio_list.beetle_pick, --
        self.audio_list.free_kuang, --
        --self.audio_list.fg_collect, --
        self.audio_list.fg_btn_out, --
        --self.audio_list.bonus_num1, --
        self.audio_list.bonus_num, --
        --self.audio_list.dialog_fg_wild, --
        self.audio_list.wild_out, --
        self.audio_list.fg_mul, --
        self.audio_list.fg_mul_fly, --
        self.audio_list.store_choose1, --
        self.audio_list.store_choose2, --
        -- mapfree
        self.audio_list.mapfree_dialog_collect_show, --
        self.audio_list.mapfree_background, --
        self.audio_list.mapfree_wild_out2, --
        self.audio_list.mapfree_wild_expand, --
        --wheel
        self.audio_list.wheel_press, --
        self.audio_list.wheel_finish, --
        self.audio_list.bonus_wheel_spin, --
        --self.audio_list.wheel_background, --
        -- jackpot
        self.audio_list.jp_dialog_collect_show, --



    }
    return loadMuscList
end
--------------------------- 音效控制 ---------------------------

function cls:dealMusic_PlayReelNotifyMusic(pCol, itemKey)
    -- 最后一列激励音效
    if itemKey == specialSymbol.trigger then
        if self.playR1Col == 1 + (pCol - 1) % 5 then
            return
        end
        self:playMusic(self.audio_list.anticipation1_2, true, true)
        self.playR1Col = 1 + (pCol - 1) % 5
    end

end -- 滚轮音效相关
function cls:dealMusic_PlayShortNotifyMusic(pCol, itemKey)
    -- 最后一列激励音效
    if itemKey == specialSymbol.trigger then
        if self.playR1Col == 1 + (pCol - 1) % 5 then
            return
        end
    end

end

function cls:dealMusic_StopReelNotifyMusic(pCol)
    if (self.playR1Col) and (self.playR1Col == pCol) then
        self:stopMusic(self.audio_list.anticipation1_2, true)
        self.playR1Col = nil
    end
end

function cls:dealMusic_PlayWheelLoopMusic()
    AudioControl:stopGroupAudio("music")
    self:dealMusic_FadeLoopMusic(0.3, 1, 0.8)
    self:playLoopMusic(self.audio_list.mapfree_background)
    AudioControl:volumeGroupAudio(1)
end
function cls:dealMusic_exitWheelLoopMusic()
    AudioControl:stopGroupAudio("music")
end

-- 播放free games的背景音乐
function cls:dealMusic_PlayFreeSpinLoopMusic()
    -- 播放背景音乐
    AudioControl:stopGroupAudio("music")
    if self.superAvgBet then
        self:playLoopMusic(self.audio_list.mapfree_background)
    else
        self:playLoopMusic(self.audio_list.free_background)

    end
    AudioControl:volumeGroupAudio(1)
end
-- freespin音效相关
function cls:dealMusic_PlayFSEnterMusic()
    -- 进入freespin 弹窗显示的音效
    if self.superAvgBet then
        --self:playMusic(self.audio_list.mapfree_dialog_start_show)
    else
        self:playMusic(self.audio_list.free_dialog_start_show)
    end
end -- freespin音效相关
function cls:dealMusic_StopFSEnterMusic()
    if self.superAvgBet then
        self:stopMusic(self.audio_list.mapfree_dialog_start_show)
    else
        self:stopMusic(self.audio_list.free_dialog_start_show)
    end
end

function cls:dealMusic_PlayFSCollectMusic()
    -- 进入freespin 弹窗显示的音效
    if self.superAvgBet then
        self:playMusic(self.audio_list.mapfree_dialog_collect_show)
    else
        self:playMusic(self.audio_list.free_dialog_collect_show)
    end
end

function cls:dealMusic_PlayFSEnterClickMusic()

end
return ThemeCleopatra