---@program src
---@description:  theme230 config
---@author: rwb
---@create: : 2020/12/29 21:16:16
local config = {}

local G_CELL_HEIGHT = 90
local G_CELL_WIDTH = 129
local SCATTER = 11
local BONUS_SYMBOL = 12
local MULTI_WILD = 14
local GOLD_WILD = 15
local WILD = 1
local B_ZERO_POS_X = 360 - G_CELL_WIDTH * 2.5
local B_ZERO_POS_Y = 194
local M1 = 2
local dialog_type = {
    free      = "free",
    jp        = "jp",
    map       = "map",
    map_multi = "map_multi",
    wheel     = "wheel",

}
local fs_show_type = {
    start   = 1,
    more    = 2,
    collect = 3,
}

config.SpinBoardType = {
    Normal    = 1,
    FreeSpin  = 2,
    SuperFree = 3,
    SmallSlot = 4,
    Wheel     = 5,
}

config.SpinLayerType = {
    Normal    = 1,
    FreeSpin  = 2,
    SuperFree = 2,
    SmallSlot = 3,
}
local ReSpinStep = {
    OFF     = 1,
    Start   = 2,
    Reset   = 3,
    Over    = 4,
    Playing = 5,
}

local freeTypeList = {
    stickWild   = 1,
    stickRandom = 2,
    mapMulti    = 3,
    mapRandom   = 4,
    mapSticky   = 5,
    mapMoving   = 6,

}
config.freeTypeList = freeTypeList
config.ReSpinStep = ReSpinStep
config.fs_show_type = fs_show_type

config.dialog_type = dialog_type

config.baseColCnt = 5
config.symbol_size = { G_CELL_WIDTH, G_CELL_HEIGHT }
config.special_symbol = {
    wild          = WILD,
    collectSymbol = WILD,
    scatter       = SCATTER,
    multiWild     = MULTI_WILD,
    bonusSymbol   = BONUS_SYMBOL
}
config.unlockBetList = {
    Jackpot3 = 1, --minor
    Collect  = 2,
    Jackpot2 = 3, --major
    Jackpot1 = 4, --grand
}
config.symbol_config = {
    ["scatter_key_list"]    = { SCATTER },
    ["not_init_symbol_set"] = Set({
        WILD, SCATTER, BONUS_SYMBOL, MULTI_WILD, GOLD_WILD
    }),
    ["notify_symbol_list"]  = Set({
        SCATTER, -- scatter
    }),
    ["loop_symbol_list"]    = Set({
        SCATTER, -- scatter
    }),
    ["low_symbol_list"]     = Set({
        7, 8, 9, 10
    }),
    ["anim_suffix"]         = {
        ["loop"] = "_2", ["notify"] = "_1", ["win"] = "_3", ["static"] = "_4"
    }
}

config.init_config = {
    plistAnimate       = {
        "image/plist/symbol",
        "image/plist/base",
        --"image/plist/slot_machine_symbol",
    },
    preSlotPngs        = {
        "image/plist/slot_machine_symbol",
    },
    csbList            = {
        "csb/main_game.csb",
    },
    spinTimeConfig     = { -- spin 时间控制
        [1]           = 81 / 60, -- 欺骗 比基础spin多加的时间 --42/60 在基础spin时间为81帧的时候
        [2]           = 181 / 60, -- 出现大象比基础spin多加的时间  -- 181/60,
        ["base"]      = 21 / 60,
        [0]           = 39 / 60,
        ["spinMinCD"] = 0 / 60,
    },
    spinActionConfig   = {
        ["start_index"]     = 1,
        ["spin_index"]      = 1,
        ["stop_index"]      = 1,
        ["fast_stop_index"] = 1,
        ["special_index"]   = 1,
    },
    baseBet            = 10000,
    isPortrait         = true,
    UnderPressure      = 1,
    game_store_version = 4,
}

config.reel_spin_config = {
    ["delay"]                   = 0,
    ["upBounce"]                = 0,
    ["upBounceMaxSpeed"]        = 6 * 60,
    ["upBounceTime"]            = 0,
    ["speedUpTime"]             = 5 / 60,
    ["rotateTime"]              = 5 / 60,
    ["fastSpeed"]               = -30 * 60 ,
    ["maxSpeed"]                = -30 * 60, -- -30 * 60,
    ["downBounceMaxSpeed"]      = 10 * 60, -- 6 * 60,
    ["extraReelTime"]           = 120 / 60,
    ["spinMinCD"]               = 0,
    ["speedDownTime"]           = 30 / 60, -- 40 / 60,
    ["downBounce"]              = G_CELL_HEIGHT * 1 / 5, -- 对应 普通停止在symbol + 1
    ["downBounceTime"]          = 10 / 60, -- 20/60,
    ["autoDownBounceTimeMult"]  = 1,
    ["checkStopColCnt"]         = 5,
    -- end
    ["stopDelay"]               = 10 / 60, -- 20/60,
    ["stopDelayList"]           = {
        [1] = 10 / 60,
        [2] = 10 / 60,
        [3] = 10 / 60,
    },
    ["autoStopDelayMult"]       = 1,
    ["speicalSpeed"]            = 100 / 30,
    ["extraReelTimeInFreeGame"] = 240 / 30,
}

config.theme_config = {
    reel_symbol  = {
        ["theme_symbol_coinfig"]    = {
            ["symbol_zorder_list"]       = {
                [SCATTER]      = 2000,
                --[GOLD_WILD]    = 1500,
                [BONUS_SYMBOL] = 1500,

            },
            ["normal_symbol_list"]       = {
                2, 3, 4, 5, 6, 7, 8, 9, 10
            },
            ["special_symbol_list"]      = {
                WILD, SCATTER, BONUS_SYMBOL, GOLD_WILD
            },
            ["no_roll_symbol_list"]      = {
                BONUS_SYMBOL, MULTI_WILD
            },
            ["slot_machine_symbol_list"] = {
                102, 103, 104, 105, 106, 107, 108, 109
            },
            ["special_symbol_config"]    = {
                [SCATTER] = {
                    ["min_cnt"] = 3,
                    ["type"]    = G_THEME_SYMBOL_TYPE.NUMBER,
                    ["col_set"] = {
                        [1] = 0,
                        [2] = 1,
                        [3] = 1,
                        [4] = 1,
                        [5] = 0,
                    },
                },
            },
        },
        ["theme_round_light_index"] = 1,
        ["theme_type"]              = "payLine",
        ["theme_type_config"]       = {
            pay_lines      = {
                { 0, 0, 0, 0, 0 }, { 1, 1, 1, 1, 1 }, { 2, 2, 2, 2, 2 }, { 3, 3, 3, 3, 3 }, { 0, 0, 1, 0, 0 },
                { 1, 1, 2, 1, 1 }, { 2, 2, 3, 2, 2 }, { 3, 3, 2, 3, 3 }, { 2, 2, 1, 2, 2 }, { 1, 1, 0, 1, 1 },
                { 0, 1, 1, 1, 0 }, { 1, 2, 2, 2, 1 }, { 2, 3, 3, 3, 2 }, { 3, 2, 2, 2, 3 }, { 2, 1, 1, 1, 2 },
                { 1, 0, 0, 0, 1 }, { 0, 1, 0, 1, 0 }, { 1, 2, 1, 2, 1 }, { 2, 3, 2, 3, 2 }, { 3, 2, 3, 2, 3 },
                { 2, 1, 2, 1, 2 }, { 1, 0, 1, 0, 1 }, { 0, 1, 2, 1, 0 }, { 1, 2, 3, 2, 1 }, { 3, 2, 1, 2, 3 },
                { 2, 1, 0, 1, 2 }, { 0, 1, 2, 3, 3 }, { 3, 2, 1, 0, 0 }, { 0, 0, 0, 1, 1 }, { 1, 1, 1, 2, 2 },
                { 2, 2, 2, 3, 3 }, { 3, 3, 3, 2, 2 }, { 2, 2, 2, 1, 1 }, { 1, 1, 1, 0, 0 }, { 1, 2, 0, 2, 1 },
                { 2, 3, 1, 3, 2 }, { 2, 1, 3, 1, 2 }, { 1, 0, 2, 0, 1 }, { 0, 1, 2, 2, 2 }, { 3, 2, 1, 1, 1 },
            },
            pay_lines_free = {
                { 0, 0, 0, 0, 0 }, { 1, 1, 1, 1, 1 }, { 2, 2, 2, 2, 2 }, { 3, 3, 3, 3, 3 }, { 4, 4, 4, 4, 4 },
                { 5, 5, 5, 5, 5 }, { 6, 6, 6, 6, 6 }, { 7, 7, 7, 7, 7 }, { 0, 0, 1, 0, 0 }, { 1, 1, 2, 1, 1 },
                { 2, 2, 3, 2, 2 }, { 3, 3, 4, 3, 3 }, { 4, 4, 5, 4, 4 }, { 5, 5, 6, 5, 5 }, { 6, 6, 7, 6, 6 },
                { 7, 7, 6, 7, 7 }, { 6, 6, 5, 6, 6 }, { 5, 5, 4, 5, 5 }, { 4, 4, 3, 4, 4 }, { 3, 3, 2, 3, 3 },
                { 2, 2, 1, 2, 2 }, { 1, 1, 0, 1, 1 }, { 0, 1, 1, 1, 0 }, { 1, 2, 2, 2, 1 }, { 2, 3, 3, 3, 2 },
                { 3, 4, 4, 4, 3 }, { 4, 5, 5, 5, 4 }, { 5, 6, 6, 6, 5 }, { 6, 7, 7, 7, 6 }, { 7, 6, 6, 6, 7 },
                { 6, 5, 5, 5, 6 }, { 5, 4, 4, 4, 5 }, { 4, 3, 3, 3, 4 }, { 3, 2, 2, 2, 3 }, { 2, 1, 1, 1, 2 },
                { 1, 0, 0, 0, 1 }, { 0, 1, 0, 1, 0 }, { 1, 2, 1, 2, 1 }, { 2, 3, 2, 3, 2 }, { 3, 4, 3, 4, 3 },
                { 4, 5, 4, 5, 4 }, { 5, 6, 5, 6, 5 }, { 6, 7, 6, 7, 6 }, { 7, 6, 7, 6, 7 }, { 6, 5, 6, 5, 6 },
                { 5, 4, 5, 4, 5 }, { 4, 3, 4, 3, 4 }, { 3, 2, 3, 2, 3 }, { 2, 1, 2, 1, 2 }, { 1, 0, 1, 0, 1 },
                { 0, 1, 2, 1, 0 }, { 1, 2, 3, 2, 1 }, { 2, 3, 4, 3, 2 }, { 3, 4, 5, 4, 3 }, { 4, 5, 6, 5, 4 },
                { 5, 6, 7, 6, 5 }, { 7, 6, 5, 6, 7 }, { 6, 5, 4, 5, 6 }, { 5, 4, 3, 4, 5 }, { 4, 3, 2, 3, 4 },
                { 3, 2, 1, 2, 3 }, { 2, 1, 0, 1, 2 }, { 0, 1, 2, 3, 4 }, { 1, 2, 3, 4, 5 }, { 2, 3, 4, 5, 6 },
                { 3, 4, 5, 6, 7 }, { 7, 6, 5, 4, 3 }, { 6, 5, 4, 3, 2 }, { 5, 4, 3, 2, 1 }, { 4, 3, 2, 1, 0 },
                { 0, 1, 2, 3, 3 }, { 1, 2, 3, 4, 4 }, { 2, 3, 4, 5, 5 }, { 3, 4, 5, 6, 6 }, { 4, 5, 6, 7, 7 },
                { 7, 6, 5, 4, 4 }, { 6, 5, 4, 3, 3 }, { 5, 4, 3, 2, 2 }, { 4, 3, 2, 1, 1 }, { 3, 2, 1, 0, 0 },

            },
            line_cnt       = 100,

        },
        ["boardConfig"]             = {
            { -- base
                ["reel_single"] = true,
                ["colReelCnt"]  = 5,
                ["colCnt"]      = 5,
                ["symbolCount"] = 4,
                ["cellWidth"]   = G_CELL_WIDTH,
                ["cellHeight"]  = G_CELL_HEIGHT,
                ["reelConfig"]  = {
                    {
                        ["base_pos"] = cc.p(B_ZERO_POS_X, B_ZERO_POS_Y),
                    },
                }
            },
            {
                ["reel_single"] = true,
                ["colReelCnt"]  = 5, --be used at themebaseview
                ["colCnt"]      = 5,
                ["cellWidth"]   = G_CELL_WIDTH,
                ["cellHeight"]  = G_CELL_HEIGHT,
                ["symbolCount"] = 8,
                ["reelConfig"]  = {
                    {
                        ["base_pos"] = cc.p(B_ZERO_POS_X, B_ZERO_POS_Y),
                    },
                }
            },
            {
                ["show_parts"]  = true,
                ["colCnt"]      = 3,
                ["cellWidth"]   = 194,
                ["cellHeight"]  = 138,
                ["symbolCount"] = 1,
                ["reelConfig"]  = {
                    {
                        ["base_pos"] = cc.p(70, 369),
                    },
                }
            },

        }
    },
    base_col_cnt = 5,
}
config.theme_reels = {
    main_reel      = {
        { 12, 12, 12, 12, 12, 12, 12, 12, 8, 8, 8, 8, 9, 9, 9, 9, 2, 2, 10, 10, 10, 1, 9, 9, 9, 9, 4, 4, 4, 4, 12, 12, 12, 12, 12, 12, 12, 12, 4, 3, 3, 3, 8, 8, 8, 6, 6, 6, 6, 5, 6, 6, 1, 1, 8, 8, 8, 8, 4, 7, 4, 4, 4, 10, 10, 10, 10, 3, 4, 3, 3, 3, 7, 7, 5, 5, 4, 5, 5, 6, 4, 1, 1, 1, 1, 4, 4, 2, 7, 2, 2, 8, 8, 8, 8, 3, 3, 3, 9, 9, 9, 9, 5, 5, 3, 12, 12, 12, 12, 12, 12, 12, 12, 5, 5, 6, 6, 7, 6, 7, 7, 4, 4, 4, 5, 5 },
        { 12, 12, 12, 12, 12, 12, 12, 12, 9, 9, 9, 9, 8, 11, 8, 8, 8, 2, 2, 7, 7, 7, 1, 4, 4, 4, 4, 9, 9, 11, 9, 9, 12, 12, 12, 12, 12, 12, 12, 12, 4, 4, 4, 4, 8, 8, 8, 5, 5, 5, 11, 6, 5, 5, 5, 1, 1, 10, 10, 10, 10, 4, 7, 4, 4, 4, 10, 10, 10, 10, 3, 4, 3, 11, 3, 3, 7, 7, 6, 6, 4, 6, 6, 6, 4, 1, 1, 1, 1, 4, 4, 2, 7, 2, 2, 8, 8, 8, 8, 3, 3, 11, 3, 9, 9, 9, 9, 5, 5, 3, 12, 12, 12, 12, 12, 12, 12, 12, 5, 5, 6, 6, 7, 6, 7, 7, 4, 11, 4, 4, 5, 5 },
        { 12, 12, 12, 12, 12, 12, 12, 12, 8, 8, 8, 8, 8, 11, 8, 8, 2, 2, 2, 6, 5, 6, 6, 9, 9, 9, 9, 6, 6, 11, 10, 10, 10, 1, 8, 8, 8, 8, 2, 2, 2, 2, 12, 12, 12, 12, 12, 12, 12, 12, 11, 6, 6, 6, 6, 1, 1, 7, 7, 7, 7, 4, 7, 4, 4, 4, 10, 10, 10, 10, 3, 4, 3, 3, 11, 3, 7, 7, 5, 5, 4, 5, 5, 6, 4, 1, 1, 1, 1, 4, 4, 2, 7, 2, 2, 8, 8, 8, 8, 3, 3, 3, 11, 9, 9, 9, 9, 5, 5, 3, 12, 12, 12, 12, 12, 12, 12, 12, 5, 5, 6, 6, 7, 6, 7, 7, 4, 4, 11, 4, 6, 6 },
        { 12, 12, 12, 12, 12, 12, 12, 12, 8, 8, 8, 8, 9, 11, 9, 9, 9, 2, 2, 9, 9, 9, 1, 7, 7, 7, 7, 3, 3, 11, 3, 3, 12, 12, 12, 12, 12, 12, 12, 12, 4, 3, 3, 3, 8, 8, 8, 5, 5, 5, 11, 6, 5, 6, 6, 1, 1, 7, 7, 7, 7, 4, 7, 4, 4, 4, 10, 10, 10, 10, 3, 4, 3, 3, 11, 3, 7, 7, 5, 5, 4, 5, 5, 6, 4, 6, 1, 1, 1, 4, 4, 2, 7, 2, 2, 7, 7, 7, 7, 3, 3, 3, 11, 9, 9, 9, 9, 5, 5, 3, 12, 12, 12, 12, 12, 12, 12, 12, 5, 5, 6, 6, 7, 6, 7, 7, 3, 3, 11, 3, 5, 5 },
        { 12, 12, 12, 12, 12, 12, 12, 12, 8, 8, 8, 8, 1, 1, 7, 7, 7, 7, 4, 7, 9, 9, 9, 9, 2, 2, 8, 8, 8, 1, 10, 10, 10, 10, 2, 2, 2, 2, 12, 12, 12, 12, 12, 12, 12, 12, 4, 3, 3, 3, 8, 8, 8, 5, 5, 5, 6, 5, 6, 6, 4, 4, 4, 10, 10, 10, 10, 3, 4, 3, 3, 3, 7, 7, 5, 5, 4, 5, 5, 6, 4, 1, 1, 1, 1, 4, 4, 2, 7, 2, 2, 7, 7, 7, 7, 3, 3, 3, 9, 9, 9, 9, 5, 5, 3, 12, 12, 12, 12, 12, 12, 12, 12, 5, 5, 6, 6, 7, 6, 7, 7, 4, 4, 4, 5, 5 }
    },
    jili_reel      = {
        { 12, 12, 12, 12, 12, 12, 12, 12, 8, 8, 8, 8, 9, 9, 9, 9, 2, 2, 10, 10, 10, 1, 9, 9, 9, 9, 4, 4, 4, 4, 12, 12, 12, 12, 12, 12, 12, 12, 4, 3, 3, 3, 6, 6, 6, 6, 5, 6, 6, 1, 1, 8, 8, 8, 8, 4, 7, 4, 4, 4, 3, 4, 3, 3, 3, 7, 7, 5, 5, 4, 5, 5, 6, 4, 1, 1, 1, 1, 4, 4, 2, 7, 2, 2, 8, 8, 8, 8, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 3, 3, 3, 9, 9, 9, 9, 5, 5, 3, 12, 12, 12, 12, 12, 12, 12, 12, 5, 5, 6, 6, 7, 6, 7, 7, 4, 4, 4, 5, 5 },
        { 12, 12, 12, 12, 12, 12, 12, 12, 11, 8, 8, 8, 2, 2, 7, 7, 7, 11, 1, 4, 4, 4, 4, 9, 9, 11, 9, 9, 12, 12, 12, 12, 12, 12, 12, 12, 4, 4, 4, 4, 8, 8, 8, 5, 5, 5, 11, 6, 5, 5, 5, 1, 1, 10, 10, 10, 10, 4, 7, 4, 4, 4, 3, 4, 3, 11, 3, 3, 7, 7, 6, 6, 4, 6, 6, 6, 4, 1, 1, 1, 1, 4, 4, 2, 7, 2, 2, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 8, 8, 8, 8, 3, 3, 11, 3, 9, 9, 9, 9, 5, 5, 3, 12, 12, 12, 12, 12, 12, 12, 12, 5, 5, 6, 6, 7, 6, 7, 7, 4, 11, 4, 4, 5, 5 },
        { 12, 12, 12, 12, 12, 12, 12, 12, 11, 8, 8, 2, 2, 2, 6, 5, 11, 6, 6, 9, 9, 9, 9, 6, 6, 11, 10, 10, 10, 1, 8, 8, 8, 8, 2, 2, 2, 2, 12, 12, 12, 12, 12, 12, 12, 12, 11, 6, 6, 6, 6, 1, 1, 7, 7, 7, 7, 4, 7, 4, 4, 4, 13, 4, 3, 3, 11, 3, 7, 7, 5, 5, 4, 5, 5, 6, 4, 1, 1, 1, 1, 4, 4, 2, 7, 2, 2, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 8, 8, 8, 8, 3, 3, 3, 11, 9, 9, 9, 9, 5, 5, 3, 12, 12, 12, 12, 12, 12, 12, 12, 5, 5, 6, 6, 7, 6, 7, 7, 4, 4, 11, 4, 6, 6 },
        { 12, 12, 12, 12, 12, 12, 12, 12, 11, 9, 9, 9, 2, 2, 9, 9, 9, 11, 1, 7, 7, 7, 7, 3, 3, 11, 3, 3, 12, 12, 12, 12, 12, 12, 12, 12, 4, 3, 3, 3, 8, 8, 8, 5, 5, 5, 11, 6, 5, 6, 6, 1, 1, 7, 7, 7, 7, 4, 7, 4, 4, 4, 3, 4, 3, 3, 11, 3, 7, 7, 5, 5, 4, 5, 5, 6, 4, 6, 1, 1, 1, 4, 4, 2, 7, 2, 2, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 7, 7, 7, 7, 3, 3, 3, 11, 9, 9, 9, 9, 5, 5, 3, 12, 12, 12, 12, 12, 12, 12, 12, 5, 5, 6, 6, 7, 6, 7, 7, 3, 3, 11, 3, 5, 5 },
        { 12, 12, 12, 12, 12, 12, 12, 12, 1, 1, 7, 7, 7, 7, 4, 7, 9, 9, 9, 9, 2, 2, 8, 8, 8, 1, 10, 10, 10, 10, 2, 2, 2, 2, 12, 12, 12, 12, 12, 12, 12, 12, 4, 3, 3, 3, 8, 8, 8, 5, 5, 5, 6, 5, 6, 6, 4, 4, 4, 3, 4, 3, 3, 3, 7, 7, 5, 5, 4, 5, 5, 6, 4, 1, 1, 1, 1, 4, 4, 2, 7, 2, 2, 7, 7, 7, 7, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 3, 3, 3, 9, 9, 9, 9, 5, 5, 3, 12, 12, 12, 12, 12, 12, 12, 12, 5, 5, 6, 6, 7, 6, 7, 7, 4, 4, 4, 5, 5 }

    },
    free_reel      = {
        { 1, 8, 8, 8, 8, 9, 9, 9, 9, 2, 2, 10, 10, 10, 1, 9, 9, 9, 9, 4, 4, 4, 1, 4, 8, 8, 8, 8, 8, 8, 8, 8, 4, 3, 3, 3, 8, 8, 8, 6, 6, 6, 6, 5, 6, 6, 1, 8, 8, 8, 8, 4, 7, 4, 4, 4, 10, 10, 10, 10, 3, 4, 3, 3, 3, 7, 7, 5, 5, 4, 5, 5, 6, 4, 1, 6, 9, 9, 9, 9, 1, 6, 6, 6, 6, 1, 4, 4, 2, 7, 2, 2, 8, 8, 8, 1, 8, 3, 1, 3, 3, 9, 9, 9, 9, 5, 5, 3, 1, 10, 10, 10, 10, 10, 1, 10, 10, 10, 5, 5, 6, 6, 7, 6, 7, 7, 4, 4, 4, 5, 5 },
        { 1, 8, 8, 8, 8, 9, 9, 9, 9, 2, 2, 7, 7, 7, 1, 4, 4, 4, 4, 9, 9, 9, 9, 1, 10, 10, 10, 10, 10, 10, 10, 10, 4, 4, 4, 4, 8, 8, 8, 5, 5, 5, 6, 5, 5, 5, 1, 10, 10, 10, 10, 4, 7, 4, 4, 4, 10, 10, 10, 10, 3, 4, 3, 3, 3, 7, 7, 6, 6, 4, 6, 1, 6, 6, 4, 6, 9, 1, 9, 9, 9, 6, 6, 6, 6, 1, 4, 4, 2, 7, 2, 2, 1, 8, 8, 1, 8, 8, 3, 3, 3, 9, 9, 9, 9, 5, 5, 3, 1, 8, 8, 8, 8, 8, 1, 8, 8, 8, 5, 5, 6, 6, 7, 6, 7, 7, 4, 4, 4, 5, 5 },
        { 1, 8, 8, 8, 8, 9, 9, 9, 9, 6, 6, 10, 10, 10, 1, 8, 8, 8, 8, 2, 2, 2, 1, 2, 7, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6, 6, 8, 8, 8, 2, 2, 2, 6, 5, 6, 6, 1, 7, 7, 7, 7, 4, 7, 4, 4, 4, 10, 10, 10, 10, 3, 4, 3, 3, 3, 7, 7, 5, 5, 4, 5, 5, 6, 4, 1, 6, 9, 9, 9, 9, 1, 6, 6, 6, 6, 1, 4, 4, 2, 7, 2, 2, 8, 8, 8, 1, 8, 3, 1, 3, 3, 9, 9, 9, 9, 5, 5, 3, 1, 10, 10, 10, 10, 10, 1, 10, 10, 10, 5, 5, 6, 6, 7, 6, 7, 7, 4, 4, 4, 6, 6 },
        { 1, 8, 8, 8, 8, 9, 9, 9, 9, 2, 2, 9, 9, 9, 1, 7, 7, 7, 7, 3, 3, 3, 3, 1, 9, 9, 9, 9, 9, 9, 9, 9, 4, 3, 3, 3, 8, 8, 8, 5, 5, 5, 6, 5, 6, 6, 1, 7, 7, 7, 7, 4, 7, 4, 4, 4, 10, 10, 10, 10, 3, 4, 3, 3, 3, 7, 7, 5, 5, 4, 5, 5, 6, 4, 6, 1, 9, 9, 9, 9, 6, 1, 6, 6, 6, 1, 4, 4, 2, 7, 2, 2, 7, 7, 7, 7, 1, 3, 3, 1, 3, 9, 9, 9, 9, 5, 5, 3, 1, 7, 7, 7, 7, 7, 1, 7, 7, 7, 5, 5, 6, 6, 7, 6, 7, 7, 3, 3, 3, 5, 5 },
        { 1, 8, 8, 8, 8, 9, 9, 9, 9, 2, 2, 8, 8, 8, 1, 10, 10, 10, 10, 2, 2, 2, 1, 2, 9, 9, 9, 9, 9, 9, 9, 9, 4, 3, 3, 3, 8, 8, 8, 5, 5, 5, 6, 5, 6, 6, 1, 7, 7, 7, 7, 4, 7, 4, 4, 4, 10, 10, 10, 10, 3, 4, 3, 3, 3, 7, 7, 5, 5, 4, 5, 5, 6, 4, 1, 6, 9, 9, 9, 9, 1, 6, 6, 6, 6, 1, 4, 4, 2, 7, 2, 2, 7, 7, 7, 1, 7, 3, 1, 3, 3, 9, 9, 9, 9, 5, 5, 3, 1, 9, 9, 9, 9, 9, 1, 9, 9, 9, 5, 5, 6, 6, 7, 6, 7, 7, 4, 4, 4, 5, 5 }
    },

    free2          = {
        { 8, 8, 8, 8, 9, 9, 9, 9, 2, 2, 10, 10, 10, 9, 9, 9, 9, 4, 4, 4, 4, 8, 8, 8, 8, 8, 8, 8, 8, 4, 3, 3, 3, 8, 8, 8, 6, 6, 6, 6, 5, 6, 6, 8, 8, 8, 8, 4, 7, 4, 4, 4, 10, 10, 10, 10, 3, 4, 3, 3, 3, 7, 7, 5, 5, 4, 5, 5, 6, 4, 6, 9, 9, 9, 9, 6, 6, 6, 6, 4, 4, 2, 7, 2, 2, 8, 8, 8, 8, 3, 3, 3, 9, 9, 9, 9, 5, 5, 3, 10, 10, 10, 10, 10, 10, 10, 10, 5, 5, 6, 6, 7, 6, 7, 7, 4, 4, 4, 5, 5 },
        { 8, 8, 8, 8, 9, 9, 9, 9, 2, 2, 7, 7, 7, 4, 4, 4, 4, 9, 9, 9, 9, 10, 10, 10, 10, 10, 10, 10, 10, 4, 4, 4, 4, 8, 8, 8, 5, 5, 5, 6, 5, 5, 5, 10, 10, 10, 10, 4, 7, 4, 4, 4, 10, 10, 10, 10, 3, 4, 3, 3, 3, 7, 7, 6, 6, 4, 6, 6, 6, 4, 6, 9, 9, 9, 9, 6, 6, 6, 6, 4, 4, 2, 7, 2, 2, 8, 8, 8, 8, 3, 3, 3, 9, 9, 9, 9, 5, 5, 3, 8, 8, 8, 8, 8, 8, 8, 8, 5, 5, 6, 6, 7, 6, 7, 7, 4, 4, 4, 5, 5 },
        { 8, 8, 8, 8, 9, 9, 9, 9, 6, 6, 10, 10, 10, 8, 8, 8, 8, 2, 2, 2, 2, 7, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6, 6, 8, 8, 8, 2, 2, 2, 6, 5, 6, 6, 7, 7, 7, 7, 4, 7, 4, 4, 4, 10, 10, 10, 10, 3, 4, 3, 3, 3, 7, 7, 5, 5, 4, 5, 5, 6, 4, 6, 9, 9, 9, 9, 6, 6, 6, 6, 4, 4, 2, 7, 2, 2, 8, 8, 8, 8, 3, 3, 3, 9, 9, 9, 9, 5, 5, 3, 10, 10, 10, 10, 10, 10, 10, 10, 5, 5, 6, 6, 7, 6, 7, 7, 4, 4, 4, 6, 6 },
        { 8, 8, 8, 8, 9, 9, 9, 9, 2, 2, 9, 9, 9, 7, 7, 7, 7, 3, 3, 3, 3, 9, 9, 9, 9, 9, 9, 9, 9, 4, 3, 3, 3, 8, 8, 8, 5, 5, 5, 6, 5, 6, 6, 7, 7, 7, 7, 4, 7, 4, 4, 4, 10, 10, 10, 10, 3, 4, 3, 3, 3, 7, 7, 5, 5, 4, 5, 5, 6, 4, 6, 9, 9, 9, 9, 6, 6, 6, 6, 4, 4, 2, 7, 2, 2, 7, 7, 7, 7, 3, 3, 3, 9, 9, 9, 9, 5, 5, 3, 7, 7, 7, 7, 7, 7, 7, 7, 5, 5, 6, 6, 7, 6, 7, 7, 3, 3, 3, 5, 5 },
        { 8, 8, 8, 8, 9, 9, 9, 9, 2, 2, 8, 8, 8, 10, 10, 10, 10, 2, 2, 2, 2, 9, 9, 9, 9, 9, 9, 9, 9, 4, 3, 3, 3, 8, 8, 8, 5, 5, 5, 6, 5, 6, 6, 7, 7, 7, 7, 4, 7, 4, 4, 4, 10, 10, 10, 10, 3, 4, 3, 3, 3, 7, 7, 5, 5, 4, 5, 5, 6, 4, 6, 9, 9, 9, 9, 6, 6, 6, 6, 4, 4, 2, 7, 2, 2, 7, 7, 7, 7, 3, 3, 3, 9, 9, 9, 9, 5, 5, 3, 9, 9, 9, 9, 9, 9, 9, 9, 5, 5, 6, 6, 7, 6, 7, 7, 4, 4, 4, 5, 5 }
    },
    ["bonus_reel"] = {
        { 102, 105, 106, 103, 107, 108, 109, 107, 108, 104, 106, 105, 109 },
        { 102, 106, 105, 103, 106, 109, 108, 107, 109, 104, 107, 105, 108 },
        { 102, 108, 109, 103, 107, 105, 106, 107, 108, 104, 106, 109, 105 },
    }
}

config.collect_config = {
    collectAnimation = {
        unlockLoop = "animation",
        lock       = "animation1",
        lockLoop   = "animation2",
        unlock     = "animation3",
    },
    max_point        = 80,
    collect_id       = WILD,
    progress_start_x = 0,
    progress_end_x   = 528,
    progress_y       = 30,
}
config.jackpot_config = {
    width        = { 400, 220, 220 },
    scale        = { 1, 1, 1 },
    --scale_lock       = { 1, 0.8, 0.7, 0.7 },
    --lock_tip_scale   = { 0.6, 0.65, 0.8, 0.8 },
    --unlock_tip_scale = { 0.6, 0.65, 0.8, 0.8 },
    count        = 3,
    name         = { "grand", "major", "minor" },
    unlock_fnt   = "theme230_jp_1.fnt",
    lock_fnt     = "theme230_jp_2.fnt",
    light_jp_img = "#theme230_b_jp_tip%s.png",
    allowK       = { [230] = false, [730] = false, [1230] = false },
    jp_tip_pos   = { cc.p(0, 425), cc.p(-200, 345), cc.p(200, 345) },
    jp_win_ani   = "animation%s_2",
    jp_loop_ani  = "animation%s_1"
}
config.map_config = {
    max_level       = 33,
    user_start_pos  = cc.p(-284.00, 249),
    build_level     = Set({ 3, 7, 12, 18, 25, 33 }),
    big_node_config = {
        { random = 1, level = 3 },
        { multi_1 = 2, multi_2 = 10, level = 7 },
        { stick = 1, level = 12 },
        { multi_1 = 3, multi_2 = 50, level = 18 },
        { move = 1, level = 25 },
        { multi_1 = 50, multi_2 = 100, level = 33 },
    },
    all_node_type   = {
        7, 7, 1, --3
        7, 7, 7, 2, --7
        7, 7, 7, 7, 3, --12
        7, 7, 7, 7, 7, 4, --18
        7, 7, 7, 7, 7, 7, 5, --25
        7, 7, 7, 7, 7, 7, 7, 6--33
    },
    map_type_list   = {
        "#theme230_map_s1.png", -- unlight
        "#theme230_map_s2.png", -- light,

    },
    map_free_type   = {
        random = 1,
        multi1 = 2,
        sticky = 3,
        multi2 = 4,
        move   = 5,
        multi3 = 6,
    },
    dialog_spine    = {
        sticky = 1,
        random = 2,
        move   = 3,
        --multi   = 4,
        --collect = 5,
    },
    dir_list        = {
        1, 1, 1, 1,
        2, 2, 2, 2,
        1, 1, 1, 1, 1,
        2, 2, 2, 2, 2, 2, 2,
        1, 1, 1, 1, 1, 1,
        2, 2, 2, 2, 2
    },
    pos_list        = {
        cc.p(-47, -64),
        cc.p(14, -84),
        cc.p(-61, -90),
        cc.p(48, -112),
        cc.p(-25, -115),
        cc.p(33, -150),

    }

}
config.transition_config = {
    free    = { ["onCover"] = 45 / 30, ["onEnd"] = 65 / 30, spine_file = "transition_free", audio = "transition_freein", audio2 = "transition_freeout" },
    wheel_1 = { ["onCover"] = 115 / 30, ["onEnd"] = 135 / 30, spine_file = "transition_wheel", audio = "transition_wheelin" },
    wheel   = { ["onCover"] = 55 / 30, ["onEnd"] = 75 / 30, spine_file = "transition_wheel", audio = "transition_wheelout" },
    map     = { ["onCover"] = 53 / 30, ["onEnd"] = 90 / 30, spine_file = "transition_map", audio = "transition_map" },
}

config.csb_list = {
    base                                 = "csb/main_game.csb",
    wheel                                = "csb/wheel.csb",
    map                                  = "csb/map/map.csb",
    map_item1                            = "csb/map/map_node_b1.csb",
    map_item2                            = "csb/map/map_node_b2.csb",
    map_item3                            = "csb/map/map_node_b3.csb",
    map_item4                            = "csb/map/map_node_b4.csb",
    map_item5                            = "csb/map/map_node_b5.csb",
    map_item6                            = "csb/map/map_node_b6.csb",
    map_small                            = "csb/map/map_node_s.csb",
    ["dialog_" .. dialog_type.free]      = "csb/dialog_1.csb",
    ["dialog_" .. dialog_type.jp]        = "csb/dialog_2.csb",
    ["dialog_" .. dialog_type.map]       = "csb/dialog_3.csb",
    ["dialog_" .. dialog_type.map_multi] = "csb/dialog_4.csb",
    ["dialog_" .. dialog_type.wheel]     = "csb/dialog_5.csb",
    jp_tip                               = "csb/jp_tip_node.csb",
    collect_tip                          = "csb/collect_tip_node.csb",


}

config.wheel_config = {
    count             = 12,
    speed_config      = {
        ["itemCount"]       = 12, -- 上下加一个 cell 之后的个数
        ["delayBeforeSpin"] = 0.0, --开始旋转前的时间延迟
        ["upBounce"]        = 0, --开始滚动前，向上滚动距离
        ["upBounceTime"]    = 0, --开始滚动前，向上滚动时间
        ["speedUpTime"]     = 1, --加速时间
        ["rotateTime"]      = 1, -- 匀速转动的时间之和
        ["maxSpeed"]        = 11 * 60, --每一秒滚动的距离
        ["downBounce"]      = 0, --滚动结束前，向下反弹距离  都为正数值
        ["speedDownTime"]   = 4.5, -- 4
        ["downBounceTime"]  = 0,
        ["bounceSpeed"]     = 0,
        ["direction"]       = 1,
    },
    speed_mini_config = {
        ["itemCount"]       = 12, -- 上下加一个 cell 之后的个数
        ["delayBeforeSpin"] = 0.0, --开始旋转前的时间延迟
        ["upBounce"]        = 0, --开始滚动前，向上滚动距离
        ["upBounceTime"]    = 0, --开始滚动前，向上滚动时间
        ["speedUpTime"]     = 1, --加速时间
        ["rotateTime"]      = 2, -- 匀速转动的时间之和
        ["maxSpeed"]        = 10 * 60, --每一秒滚动的距离
        ["downBounce"]      = 0, --滚动结束前，向下反弹距离  都为正数值
        ["speedDownTime"]   = 6.5, -- 4
        ["downBounceTime"]  = 0,
        ["bounceSpeed"]     = 0,
        ["direction"]       = 1,
    },

    big_wheel         = {
        { 1000, 1, 100, 4, 2000, 0.5, 100, 2, 3000, 3, 200, 5 },
        { 1000, 5, 100, 3, 2000, 2, 100, 0.5, 3000, 1, 200, 4 },
        { 1000, 2, 100, 0.5, 2000, 5, 100, 1, 3000, 4, 200, 3 },
        { 1000, 0.5, 100, 1, 2000, 2, 100, 3, 3000, 4, 200, 3 },

    },
    mini_multi        = {
        { 1, 6, 3, 10, 2, 8, 4, 12, 7, 11, 5, 9 },
        { 12, 2, 11, 3, 10, 4, 9, 5, 8, 7, 6, 1 },
        { 1, 8, 3, 12, 6, 2, 9, 7, 4, 11, 5, 10 },
        { 4, 2, 3, 1, 5, 9, 8, 12, 6, 10, 7, 11 },

    }

}
config.dialog_config = {
    [dialog_type.free]      = {
        [fs_show_type.start]   = {--start
            bg         = {
                name        = "dialog_free",
                startAction = { "animation%s_1", false },
                loopAction  = { "animation%s_2", true },
                endAction   = { "animation%s_3", false },
                formatname  = true
            },
            label_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 6 / 30, 0 }, { 7 / 30, 1.2 }, { 4 / 30, 0.95 }, { 4 / 30, 1 } },
                stepEndScale = { { 1 }, { 6 / 30, 1 }, { 4 / 30, 1.25 }, { 11 / 30, 0 } },
            },
            btn_node   = {
                isAction     = true,
                stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.2 }, { 4 / 30, 0.95 }, { 4 / 30, 1 } },
                stepEndScale = { { 1 }, { 4 / 30, 1 }, { 4 / 30, 1.25 }, { 11 / 30, 0 } },
            },
            btn        = {
                name = "dialog_free_btn",
            },
        },
        [fs_show_type.collect] = {
            bg         = {
                name        = "dialog_free",
                startAction = { "animation3_1", false },
                loopAction  = { "animation3_2", true },
                endAction   = { "animation3_3", false },
            },
            label_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.12 }, { 7 / 30, 1 } },
                stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.24 }, { 7 / 30, 0 } },
            },
            btn_node   = {
                isAction     = true,
                stepScale    = { { 0 }, { 18 / 30, 0 }, { 12 / 30, 1.2 }, { 10 / 30, 0.95 } },
                stepEndScale = { { 1 }, { 13 / 30, 1.12 }, { 6 / 30, 0 } },
            },
            btn        = {
                name = "dialog_free_btn",
            },
            maxWidth   = 550,
        }

    },
    [dialog_type.jp]        = {
        [fs_show_type.collect] = {
            bg2         = {
                name        = "dialog_car",
                startAction = { "animation1", false },
                loopAction  = { "animation2", true },
                endAction   = { "animation3", false },
            },
            bg          = {
                name        = "dialog_jackpot",
                startAction = { "animation%s_1", false },
                loopAction  = { "animation%s_2", true },
                endAction   = { "animation%s_3", false },
                formatname  = true,
            },

            label_node  = {
                isAction     = true,
                stepScale    = { { 0 }, { 7 / 30, 0 }, { 6 / 30, 1.2 }, { 10 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 7 / 30, 1.25 }, { 7 / 30, 0 } },
            },
            label_multi = {
                isAction  = true,
                stepScale = { { 0 }, { 12 / 30, 0 }, { 4 / 30, 1.2 }, { 4 / 30, 0.95 }, { 4 / 30, 1 } },
            },
            multi_bg    = {
                name = "dialog_tip",
            },
            btn_node    = {
                isAction     = true,
                stepScale    = { { 0 }, { 5 / 30, 0 }, { 7 / 30, 1.2 }, { 4 / 30, 0.95 }, { 4 / 30, 1.05 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 4 / 30, 1 }, { 6 / 30, 1.25 }, { 10 / 30, 0 } },
            },
            btn         = {
                name = "dialog_free_btn",
            },
            maxWidth    = 511,
        }

    },
    [dialog_type.map]       = {
        [fs_show_type.start]   = {
            bg         = {
                name        = "dialog_map",
                startAction = { "animation1_1", false },
                loopAction  = { "animation1_2", true },
                endAction   = { "animation1_3", false },
                formatname  = true,
            },
            label_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 6 / 30, 1.2 }, { 4 / 30, 0.95 }, { 4 / 30, 1.05 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 6 / 30, 1.25 }, { 10 / 30, 0 } },
            },
            img_node   = {
                name       = "#theme230_d_map_text%s.png",
                formatname = true,
                isImg      = true
            },
            btn_node   = {
                isAction     = true,
                stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.2 }, { 4 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 4 / 30, 1 }, { 6 / 30, 1.2 }, { 10 / 30, 0 } },
            },
            btn        = {
                name = "dialog_free_btn",
            }
        },
        [fs_show_type.collect] = {
            bg         = {
                name        = "dialog_map",
                startAction = { "animation2_1", false },
                loopAction  = { "animation2_2", true },
                endAction   = { "animation2_3", false },
            },
            label_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 6 / 30, 0 }, { 6 / 30, 1.2 }, { 10 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 6 / 30, 1 }, { 7 / 30, 1.2 }, { 4 / 30, 0 } },

            },
            btn_node   = {
                isAction     = true,
                stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.2 }, { 4 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 4 / 30, 1 }, { 6 / 30, 1.2 }, { 10 / 30, 0 } },
            },
            btn        = {
                name = "dialog_free_btn",
            },
            maxWidth   = 550,
        },
    },
    [dialog_type.map_multi] = {
        [fs_show_type.start] = {
            bg          = {
                name        = "dialog_map",
                startAction = { "animation1_1", false },
                loopAction  = { "animation1_2", true },
                endAction   = { "animation1_3", false },
                formatname  = true,
            },

            label_node2 = {
                isAction     = true,
                stepScale    = { { 0 }, { 12 / 30, 0 }, { 7 / 30, 1.24 }, { 7 / 30, 1 } },
                stepEndScale = { { 1 }, { 4 / 30, 1 }, { 7 / 30, 1.24 }, { 7 / 30, 0 } },
            },
            btn_node    = {
                isAction     = true,
                stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.2 }, { 4 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 4 / 30, 1 }, { 6 / 30, 1.2 }, { 10 / 30, 0 } },
            },
            btn         = {
                name = "dialog_free_btn",
            }
        },
    },
    [dialog_type.wheel]     = {

        [fs_show_type.collect] = {
            bg2         = {
                name        = "dialog_car",
                startAction = { "animation1", false },
                loopAction  = { "animation2", true },
                endAction   = { "animation3", false },
            },
            bg          = {
                name        = "dialog_jackpot",
                startAction = { "animation4_1", false },
                loopAction  = { "animation4_2", true },
                endAction   = { "animation4_3", false },
            },

            label_node  = {
                isAction     = true,
                stepScale    = { { 0 }, { 7 / 30, 0 }, { 6 / 30, 1.2 }, { 10 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 7 / 30, 1.25 }, { 7 / 30, 0 } },
            },
            label_multi = {
                isAction  = true,
                stepScale = { { 0 }, { 10 / 30, 0 }, { 6 / 30, 1.2 }, { 10 / 30, 0.95 }, { 5 / 30, 1 } },
            },
            multi_bg    = {
                name        = "dialog_tip",
                startAction = { "animation", true },
            },
            btn_node    = {
                isAction     = true,
                stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.2 }, { 4 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 4 / 30, 1 }, { 6 / 30, 1.2 }, { 10 / 30, 0 } },
            },
            btn         = {
                name = "dialog_free_btn",
            },
            maxWidth    = 550,
        },
    },
}

config.spine_path = {
    main_char        = "character/kuanggong",
    logo_label       = "character/logo_cp",
    ---collect
    collect_fly      = "item/1/spine",

    collect_lock     = "base/collect/sjt_suo",
    collect_loop     = "base/collect/sjt",
    collect_item     = "base/collect/sjt_wild",
    collect_uping    = "base/collect/sjt_tou",
    collect_receive  = "base/collect/sjt_js",
    collect_map      = "base/collect/sjt_you",
    ---jackpot
    jackpot_lock     = "base/jackpot/jp_suo",
    jackpot_win      = "base/jackpot/jp",
    jackpot_loop     = "base/jackpot/jp",
    ---jili
    jili_free        = "base/jili/lzjl",
    jili_good_luck   = "base/jili/jili",
    ---transition
    transition_free  = "base/transition1/kcqp_01",
    transition_wheel = "base/transition2/qp_zhadan",
    transition_map   = "base/transition3/qp_jinkuai",
    ---base
    item_1           = "item/1/spine",
    base_bg          = "bg/bg",
    fg_bg            = "bg/bgxunhuan",
    base_board       = "bg/qpkuang",
    win_kuang        = "item/kuang/spine",
    ---reveal
    wild_move_mask   = "free/wild/wildxishou",
    wild_stick_mask  = "free/wild/wildguding",
    item_reveal      = "item/12/spine",
    super_reveal     = "item/13/spine",
    -----map
    map_back_btn     = "map/btn/xdt_anniu_01",
    map_head         = "map/head/xdt_ren_01",
    map_big_item     = "map/big/djd_01",
    map_small_item   = "map/small/xjd_01",

    ---wheel
    wheel_btn        = "wheel/wheel_anniu_01",
    wheel_loop       = "wheel/wheel_k_lg_01",
    --wheel_loop       = "wheel/wheel_k_lg_01",
    wheel_roll       = "wheel/wheel_k_huhua_01",
    wheel_stop_win   = "wheel/wheel_xuanzhong_01",
    --- dialog
    dialog_free      = "dialog/fg/freetanchuang",
    dialog_free_btn  = "dialog/fg/anniusaoguang",
    dialog_jackpot   = "dialog/jp/wheeltanchuang",
    dialog_map       = "dialog/map/dajiediantanchuang",
    dialog_car       = "dialog/jp/wheelche",
    dialog_jump      = "dialog/jp/bd_01",
    dialog_tip       = "dialog/jp/jiaobiao",


    --- slot_machine
    popup_window     = "slot_machine/popup_window/spine",
    btn_start        = "slot_machine/btn_start/spine",
    btn_collect      = "slot_machine/btn_collect/spine",
    bg_light         = "slot_machine/bg_light/spine",
    line_kuang       = "slot_machine/win_kuang/mini_lhj",
}
config.particle_path = {
    wheel_tail = "huohua01_1.plist",
}
config.music_volume = {
    max_volume  = 1,
    min_volume  = 0,
    time_volume = 0.2
}
config.audioList = {
    base_background             = "audio/base/base_bgm.mp3",
    dialog_close                = "audio/base/dialog_close.mp3",
    bell                        = "audio/base/bell.mp3",
    common_click                = "audio/base/click.mp3",
    enter_game                  = "audio/base/welcome.mp3",
    win_rollup                  = "audio/base/win_rollup.mp3",
    bomb                        = "audio/base/bomb.mp3",
    char_touch                  = "audio/base/coin.mp3",
    ---collect
    collect_fly                 = "audio/base/collect_fly.mp3",
    collect_full                = "audio/base/collect_full.mp3",
    collect_lock                = "audio/base/collect_lock.mp3",
    collect_unlock              = "audio/base/collect_unlock.mp3",
    ---jp
    dialog_collect_show_1       = "audio/base/grand_dialog_collect_show.mp3",
    jp_dialog_collect_show      = "audio/base/jp_dialog_collect_show.mp3",
    dialog_collect_show_2       = "audio/base/major_dialog_collect_show.mp3",
    dialog_collect_show_3       = "audio/base/minor_dialog_collect_show.mp3",
    jp_lock                     = "audio/base/jp_lock.mp3",
    jp_unlock                   = "audio/base/jp_unlock.mp3",
    ---map
    map_close                   = "audio/base/map_close.mp3",
    map_open                    = "audio/base/map_open.mp3",
    popup_out                   = "audio/base/popup_out.mp3",
    --- borad
    good_luck                   = "audio/base/notify.mp3",
    reel_notify                 = "audio/base/reel_notify.mp3",
    reel_stop                   = "audio/base/reel_stop.mp3",
    symbol_scatter              = "audio/base/symbol_scatter.mp3",
    symbol_bonus                = "audio/base/symbol_bonus.mp3",
    --- transition
    transition_freein           = "audio/base/transition_freein.mp3",
    transition_freeout          = "audio/base/transition_freeout.mp3",
    transition_map              = "audio/base/transition_map.mp3",
    transition_wheelin          = "audio/base/transition_wheelin.mp3",
    transition_wheelout         = "audio/base/transition_wheelout.mp3",
    --- free
    free_background             = "audio/free/free_bgm.mp3",
    free_dialog_collect_show    = "audio/free/free_dialog_collect_show.mp3",
    free_dialog_start_show      = "audio/free/free_dialog_start_show.mp3",
    groupwild                   = "audio/free/groupwild.mp3",
    randomwild                  = "audio/free/randomwild.mp3",
    stickywild                  = "audio/free/stickywild.mp3",
    move                        = "audio/free/move.mp3",
    ---map free
    mapfree_background          = "audio/map/mapfree_bgm.mp3",
    mapfree_dialog_collect_show = "audio/map/mapfree_dialog_collect_show.mp3",
    mapfree_dialog_start_show   = "audio/map/mapfree_dialog_start_show.mp3",
    dooropen                    = "audio/map/dooropen.mp3",
    doorclose                   = "audio/map/doorclose.mp3",
    pass1                       = "audio/map/pass1.mp3",
    pass2                       = "audio/map/pass2.mp3",
    --- wheel
    wheel_background            = "audio/wheel/wheel_bgm.mp3",
    wheel_click                 = "audio/wheel/wheel_click.mp3",
    wheel_multiply              = "audio/wheel/multiply.mp3",
    wheel_dialog_collect_show   = "audio/wheel/wheel_dialog_collect_show.mp3",
    wheel_roll                  = "audio/wheel/wheel_roll.mp3",
    wheel_roll2                 = "audio/wheel/wheel_roll2.mp3",
    wheel_notify                = "audio/wheel/wheel_notify.mp3",

}
config.all_img_path = {
    { 1, "font/theme230_dialog_1.png" },
    { 1, "font/theme230_jp_1.png" },
    { 1, "font/theme230_jp_2.png" },
    { 1, "font/theme230_multi.png" },
    { 1, "font/theme230_wheel.png" },
    { 1, "font/theme230_wild_num.png" },
    { 1, "image/bg/theme230_bg_base.png" },
    { 1, "image/bg/theme230_bg_fg.png" },
    { 1, "image/bg/theme230_bg_map.png" },
    { 1, "image/bg/theme230_map_bg.png" },
    { 1, "image/paytable/paytable.png" },
    { 1, "image/plist/base.png" },
    { 1, "image/plist/dialog.png" },
    { 1, "image/plist/map.png" },
    { 1, "image/plist/symbol.png" },
    { 1, "image/plist/wheel.png" },
    { 1, "spine/base/collect/sjt.png" },
    { 1, "spine/base/collect/sjt_js.png" },
    { 1, "spine/base/collect/sjt_suo.png" },
    { 1, "spine/base/collect/sjt_tou.png" },
    { 1, "spine/base/collect/sjt_wild.png" },
    { 1, "spine/base/collect/sjt_you.png" },
    { 1, "spine/base/jackpot/jp.png" },
    { 1, "spine/base/jackpot/jp_suo.png" },
    { 1, "spine/base/jili/jili.png" },
    { 1, "spine/base/jili/lzjl.png" },
    { 1, "spine/base/transition1/kcqp_01.png" },
    { 1, "spine/base/transition2/qp_zhadan.png" },
    { 1, "spine/base/transition3/qp_jinkuai.png" },
    { 1, "spine/bg/bg.png" },
    { 1, "spine/bg/bgxunhuan.png" },
    { 1, "spine/bg/qpkuang.png" },
    { 1, "spine/character/kuanggong.png" },
    { 1, "spine/character/logo_cp.png" },
    { 1, "spine/dialog/fg/anniusaoguang.png" },
    { 1, "spine/dialog/fg/freetanchuang.png" },
    { 1, "spine/dialog/jp/bd_01.png" },
    { 1, "spine/dialog/jp/jiaobiao.png" },
    { 1, "spine/dialog/jp/wheelche.png" },
    { 1, "spine/dialog/jp/wheeltanchuang.png" },
    { 1, "spine/dialog/map/dajiediantanchuang.png" },
    { 1, "spine/free/wild/wildguding.png" },
    { 1, "spine/free/wild/wildxishou.png" },
    { 1, "spine/item/1/wild.png" },
    { 1, "spine/item/10/j.png" },
    { 1, "spine/item/11/scatter.png" },
    { 1, "spine/item/12/hongmen.png" },
    { 1, "spine/item/13/lanmen.png" },
    { 1, "spine/item/2/m1.png" },
    { 1, "spine/item/3/m2.png" },
    { 1, "spine/item/4/m3.png" },
    { 1, "spine/item/5/m4.png" },
    { 1, "spine/item/6/m5.png" },
    { 1, "spine/item/7/a.png" },
    { 1, "spine/item/8/k.png" },
    { 1, "spine/item/9/q.png" },
    { 1, "spine/item/kuang/zjlx.png" },
    { 1, "spine/map/big/djd_01.png" },
    { 1, "spine/map/btn/xdt_anniu_01.png" },
    { 1, "spine/map/head/xdt_ren_01.png" },
    { 1, "spine/map/small/xjd_01.png" },
    { 1, "spine/paytable/spine/back_to_game01.png" },
    { 1, "spine/wheel/wheel_anniu_01.png" },
    { 1, "spine/wheel/wheel_k_huhua_01.png" },
    { 1, "spine/wheel/wheel_k_lg_01.png" },
    { 1, "spine/wheel/wheel_xuanzhong_01.png" },
}
return config



