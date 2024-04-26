-- @Author: rwb
-- @Date:   2020-11-23 10:02:10
local config = {}

local G_CELL_HEIGHT = 75
local G_CELL_WIDTH = 106
local SCATTER = 14
local JACKPOTID = 13
local GOLD_WILD = 15
local NORMAL_WILD = 16
local M1 = 2
config.SpinBoardType = {
    Normal      = 1,
    FreeSpin    = 2,
    MapFreeSpin = 3,
    JPWheel     = 4
}
config.MapFreeBoardType = {

    Multi      = 2,
    ExtraWild1 = 3,
    MovingWild = 4,
    StickyWild = 5,
    ExtraWild2 = 6,
}

config.SpinLayerType = {
    Normal      = 1,
    FreeSpin    = 1,
    MapFreeSpin = 2,
}
local fs_show_type = {
    start   = 1,
    more    = 2,
    collect = 3,
}
config.fs_show_type = fs_show_type
local dialog_type = {
    free  = "free",
    jp    = "jp",
    map   = "map",
    super = "super",
    wheel = "wheel",
    reel  = "reel"
}
config.dialog_type = dialog_type

config.baseColCnt = 5
config.symbol_size = { G_CELL_WIDTH, G_CELL_HEIGHT }
config.special_symbol = {
    wild          = 1,
    collectSymbol = M1,
    scatter       = SCATTER,
    goldWild      = GOLD_WILD,
    normalWild    = NORMAL_WILD,
    jpWheel       = JACKPOTID
}
config.unlockBetList = {
    Jackpot4 = 1, --mini
    Collect  = 2,
    Jackpot3 = 3, --minor
    Jackpot2 = 4, --major
    Jackpot1 = 5, --grand
}
config.symbol_config = {
    ["scatter_key_list"]    = { SCATTER },
    ["not_init_symbol_set"] = Set({
        SCATTER, JACKPOTID, NORMAL_WILD, GOLD_WILD }),

    ["notify_symbol_list"]  = Set({
        SCATTER, JACKPOTID, -- scatter
    }),
    ["loop_symbol_list"]    = Set({
        SCATTER, JACKPOTID, -- scatter
    }),
    ["low_symbol_list"]     = Set({
        8, 9, 10, 11
    }),
    ["anim_suffix"]         = {
        ["loop"] = "_2", ["notify"] = "_1", ["win"] = "_3", ["static"] = "_4"
    }
}

config.init_config = {
    plistAnimate     = {
        "image/plist/symbol",
        "image/plist/base",
    },
    csbList          = {
        "csb/main_game.csb",
    },
    spinTimeConfig   = { -- spin 时间控制
        [1]           = 81 / 60, -- 欺骗 比基础spin多加的时间 --42/60 在基础spin时间为81帧的时候
        [2]           = 181 / 60, -- 出现大象比基础spin多加的时间  -- 181/60,
        ["base"]      = 21 / 60,
        [0]           = 39 / 60,
        ["spinMinCD"] = 50 / 60,
    },
    spinActionConfig = {
        ["start_index"]     = 1,
        ["spin_index"]      = 1,
        ["stop_index"]      = 1,
        ["fast_stop_index"] = 1,
        ["special_index"]   = 1,
    },
    baseBet          = 10000,
    isPortrait       = true,
    UnderPressure    = 1
}

config.reel_spin_config = {
    ["delay"]                   = 0,
    ["upBounce"]                = 0,
    ["upBounceMaxSpeed"]        = 6 * 60,
    ["upBounceTime"]            = 0,
    ["speedUpTime"]             = 5 / 60,
    ["rotateTime"]              = 5 / 60,
    ["fastSpeed"]               = -30 * 60 - 400,
    ["maxSpeed"]                = -26.5 * 60, -- -30 * 60,
    ["downBounceMaxSpeed"]      = 10 * 60, -- 6 * 60,
    ["extraReelTime"]           = 120 / 60,
    ["spinMinCD"]               = 0,
    ["speedDownTime"]           = 45 / 60, -- 40 / 60,
    ["downBounce"]              = G_CELL_HEIGHT * 1 / 6, -- 对应 普通停止在symbol + 1
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
            ["symbol_zorder_list"]    = {
                [SCATTER]     = 700,
                [GOLD_WILD]   = 300,
                [NORMAL_WILD] = 100,
                [JACKPOTID]   = 200,
            },
            ["normal_symbol_list"]    = {
                2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
            },
            ["special_symbol_list"]   = {
                1, JACKPOTID, SCATTER, GOLD_WILD, NORMAL_WILD
            },
            ["no_roll_symbol_list"]   = {

            },
            ["special_symbol_config"] = {
                [SCATTER] = {
                    ["min_cnt"] = 3,
                    ["type"]    = G_THEME_SYMBOL_TYPE.NUMBER,
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
        ["theme_type"]              = "payLine",
        ["theme_type_config"]       = {
            pay_lines = {
                { 0, 0, 0, 0, 0 }, { 0, 0, 1, 0, 0 }, { 0, 1, 1, 1, 0 }, { 0, 1, 0, 1, 0 }, { 0, 1, 2, 1, 0 },
                { 0, 0, 2, 0, 0 }, { 0, 2, 0, 2, 0 }, { 0, 2, 2, 2, 0 }, { 1, 0, 1, 0, 1 }, { 1, 0, 0, 0, 1 },
                { 2, 0, 2, 0, 2 }, { 2, 0, 0, 0, 2 }, { 2, 2, 0, 2, 2 }, { 1, 1, 1, 1, 1 }, { 1, 1, 2, 1, 1 },
                { 1, 2, 2, 2, 1 }, { 1, 2, 1, 2, 1 }, { 1, 2, 3, 2, 1 }, { 1, 3, 1, 3, 1 }, { 1, 3, 3, 3, 1 },
                { 2, 1, 2, 1, 2 }, { 2, 1, 1, 1, 2 }, { 3, 1, 3, 1, 3 }, { 3, 1, 1, 1, 3 }, { 3, 3, 1, 3, 3 },
                { 2, 2, 2, 2, 2 }, { 2, 2, 3, 2, 2 }, { 2, 3, 3, 3, 2 }, { 2, 3, 2, 3, 2 }, { 2, 3, 4, 3, 2 },
                { 2, 2, 4, 2, 2 }, { 2, 4, 2, 4, 2 }, { 2, 4, 4, 4, 2 }, { 3, 2, 3, 2, 3 }, { 3, 2, 2, 2, 3 },
                { 3, 4, 2, 4, 3 }, { 4, 2, 4, 2, 4 }, { 4, 2, 2, 2, 4 }, { 4, 4, 2, 4, 4 }, { 3, 3, 3, 3, 3 },
                { 3, 3, 4, 3, 3 }, { 3, 4, 4, 4, 3 }, { 3, 4, 3, 4, 3 }, { 3, 4, 5, 4, 3 }, { 3, 3, 5, 3, 3 },
                { 3, 5, 3, 5, 3 }, { 3, 5, 5, 5, 3 }, { 4, 3, 4, 3, 4 }, { 4, 3, 3, 3, 4 }, { 5, 3, 5, 3, 5 },
                { 5, 3, 3, 3, 5 }, { 5, 5, 3, 5, 5 }, { 4, 4, 4, 4, 4 }, { 4, 4, 5, 4, 4 }, { 4, 5, 5, 5, 4 },
                { 4, 5, 4, 5, 4 }, { 4, 5, 6, 5, 4 }, { 4, 4, 6, 4, 4 }, { 4, 6, 4, 6, 4 }, { 4, 6, 6, 6, 4 },
                { 4, 6, 5, 6, 4 }, { 5, 4, 5, 4, 5 }, { 5, 4, 4, 4, 5 }, { 6, 4, 6, 4, 6 }, { 6, 4, 4, 4, 6 },
                { 6, 6, 4, 6, 6 }, { 5, 5, 5, 5, 5 }, { 5, 5, 6, 5, 5 }, { 5, 6, 6, 6, 5 }, { 5, 6, 5, 6, 5 },
                { 5, 6, 7, 6, 5 }, { 5, 5, 7, 5, 5 }, { 5, 7, 5, 7, 5 }, { 5, 7, 7, 7, 5 }, { 6, 5, 6, 5, 6 },
                { 6, 5, 5, 5, 6 }, { 6, 7, 5, 7, 6 }, { 7, 5, 7, 5, 7 }, { 7, 5, 5, 5, 7 }, { 7, 7, 5, 7, 7 },
                { 6, 6, 6, 6, 6 }, { 6, 6, 7, 6, 6 }, { 6, 7, 7, 7, 6 }, { 6, 7, 6, 7, 6 }, { 6, 7, 8, 7, 6 },
                { 6, 6, 8, 6, 6 }, { 6, 8, 6, 8, 6 }, { 6, 8, 8, 8, 6 }, { 6, 8, 7, 8, 6 }, { 7, 6, 7, 6, 7 },
                { 7, 6, 6, 6, 7 }, { 8, 6, 8, 6, 8 }, { 8, 6, 6, 6, 8 }, { 8, 8, 6, 8, 8 }, { 7, 7, 7, 7, 7 },
                { 7, 7, 8, 7, 7 }, { 7, 8, 8, 8, 7 }, { 7, 8, 7, 8, 7 }, { 8, 8, 8, 8, 8 },
            },
            line_cnt  = 99
        },
        ["boardConfig"]             = {
            { -- base
                ["allow_over_range"] = true,
                ["reel_single"]      = true,
                ["colCnt"]           = 5,
                ["cellWidth"]        = G_CELL_WIDTH,
                ["cellHeight"]       = G_CELL_HEIGHT,
                ["symbolCount"]      = 9,
                ["reelConfig"]       = {
                    { ["base_pos"] = cc.p(94, 200) },
                }
            },
            { -- fg
                ["allow_over_range"] = true,
                ["reel_single"]      = true,
                ["colCnt"]           = 5,
                ["cellWidth"]        = G_CELL_WIDTH,
                ["cellHeight"]       = G_CELL_HEIGHT,
                ["symbolCount"]      = 9,
                ["reelConfig"]       = {
                    { ["base_pos"] = cc.p(94, 200) },
                }
            },
        }
    },
    base_col_cnt = 5,
}
config.theme_reels = {
    ["main_reel"] = {
        [1] = { 12, 12, 12, 12, 12, 12, 12, 12, 16, 16, 9, 9, 9, 9, 8, 8, 8, 8, 11, 11, 11, 11, 16, 7, 7, 7, 7, 9, 9, 9, 9, 8, 8, 8, 8, 2, 2, 2, 2, 16, 7, 7, 7, 7, 11, 11, 11, 11, 13, 6, 6, 6, 6, 4, 4, 4, 4, 10, 10, 10, 10, 16, 5, 5, 5, 5, 10, 10, 10, 10, 14, 3, 3, 3, 3 },
        [2] = { 7, 7, 7, 7, 9, 9, 9, 9, 15, 15, 7, 7, 7, 7, 10, 10, 10, 10, 11, 11, 11, 11, 16, 8, 8, 8, 8, 3, 3, 3, 3, 8, 8, 8, 8, 4, 4, 4, 4, 15, 6, 6, 6, 6, 12, 12, 12, 12, 2, 2, 2, 2, 10, 10, 10, 10, 12, 12, 12, 12, 16, 11, 11, 11, 11, 9, 9, 9, 9, 14, 5, 5, 5, 5 },
        [3] = { 9, 9, 9, 9, 7, 7, 7, 7, 15, 15, 11, 11, 11, 11, 8, 8, 8, 8, 12, 12, 12, 12, 16, 11, 11, 11, 11, 6, 6, 6, 6, 9, 9, 9, 9, 2, 2, 2, 2, 15, 8, 8, 8, 8, 10, 10, 10, 10, 10, 10, 10, 10, 4, 4, 4, 4, 12, 12, 12, 12, 16, 3, 3, 3, 3, 7, 7, 7, 7, 14, 5, 5, 5, 5 },
        [4] = { 8, 8, 8, 8, 7, 7, 7, 7, 15, 15, 7, 7, 7, 7, 11, 11, 11, 11, 10, 10, 10, 10, 16, 9, 9, 9, 9, 3, 3, 3, 3, 12, 12, 12, 12, 5, 5, 5, 5, 15, 11, 11, 11, 11, 6, 6, 6, 6, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, 16, 4, 4, 4, 4, 12, 12, 12, 12, 14, 2, 2, 2, 2 },
        [5] = { 10, 10, 10, 10, 8, 8, 8, 8, 16, 16, 7, 7, 7, 7, 12, 12, 12, 12, 3, 3, 3, 3, 16, 10, 10, 10, 10, 4, 4, 4, 4, 7, 7, 7, 7, 2, 2, 2, 2, 16, 5, 5, 5, 5, 8, 8, 8, 8, 13, 9, 9, 9, 9, 6, 6, 6, 6, 11, 11, 11, 11, 16, 9, 9, 9, 9, 11, 11, 11, 11, 14, 12, 12, 12, 12 }
    },
    ["free_reel"] = {
        [1] = { 12, 12, 12, 12, 12, 12, 12, 12, 16, 16, 9, 9, 9, 9, 8, 8, 8, 8, 11, 11, 11, 11, 16, 7, 7, 7, 7, 9, 9, 9, 9, 8, 8, 8, 8, 2, 2, 2, 2, 16, 7, 7, 7, 7, 11, 11, 11, 11, 6, 6, 6, 6, 16, 4, 4, 4, 4, 10, 10, 10, 10, 16, 5, 5, 5, 5, 16, 10, 10, 10, 10, 3, 3, 3, 3 },
        [2] = { 7, 7, 7, 7, 9, 9, 9, 9, 15, 15, 7, 7, 7, 7, 10, 10, 10, 15, 11, 11, 11, 11, 16, 8, 8, 8, 8, 3, 3, 3, 3, 8, 8, 8, 8, 4, 4, 4, 4, 15, 6, 6, 6, 6, 16, 12, 12, 12, 12, 2, 2, 2, 2, 15, 10, 10, 10, 12, 12, 12, 12, 16, 11, 11, 11, 11, 9, 9, 9, 9, 5, 5, 5, 5, 16 },
        [3] = { 9, 9, 9, 9, 15, 7, 7, 7, 15, 15, 11, 11, 11, 11, 8, 8, 8, 8, 12, 12, 12, 12, 16, 11, 11, 11, 11, 6, 6, 6, 6, 16, 9, 9, 9, 9, 2, 2, 2, 2, 15, 8, 8, 8, 8, 10, 10, 10, 10, 10, 10, 10, 15, 4, 4, 4, 4, 12, 12, 12, 12, 16, 3, 3, 3, 3, 7, 7, 7, 7, 5, 5, 5, 5, 16 },
        [4] = { 8, 8, 8, 8, 7, 7, 7, 7, 15, 15, 7, 7, 7, 7, 11, 11, 11, 11, 10, 15, 10, 10, 16, 9, 9, 9, 9, 3, 3, 3, 3, 12, 12, 12, 12, 15, 5, 5, 5, 16, 15, 11, 11, 11, 11, 15, 6, 6, 6, 16, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, 16, 4, 4, 4, 4, 12, 12, 12, 12, 2, 2, 2, 2 },
        [5] = { 10, 10, 10, 10, 8, 8, 8, 8, 16, 16, 7, 7, 7, 7, 12, 12, 12, 12, 3, 3, 3, 3, 16, 10, 10, 10, 10, 4, 4, 4, 4, 7, 7, 7, 7, 2, 2, 2, 2, 16, 5, 5, 5, 16, 5, 8, 8, 8, 8, 9, 9, 9, 9, 6, 6, 6, 6, 16, 11, 11, 11, 11, 16, 9, 9, 9, 9, 11, 11, 11, 11, 12, 12, 12, 12 }
    },
    ["map_reel"]  = {
        [1] = { 12, 12, 12, 12, 12, 12, 12, 12, 16, 16, 9, 9, 9, 9, 8, 8, 8, 8, 11, 11, 11, 11, 16, 7, 7, 7, 7, 9, 9, 9, 9, 8, 8, 8, 8, 2, 2, 2, 2, 16, 7, 7, 7, 7, 11, 11, 11, 11, 6, 6, 6, 6, 4, 4, 4, 4, 10, 10, 10, 10, 16, 5, 5, 5, 5, 10, 10, 10, 10, 3, 3, 3, 3 },
        [2] = { 7, 7, 7, 7, 9, 9, 9, 9, 15, 15, 7, 7, 7, 7, 10, 10, 10, 10, 11, 11, 11, 11, 16, 8, 8, 8, 8, 3, 3, 3, 3, 8, 8, 8, 8, 4, 4, 4, 4, 15, 6, 6, 6, 6, 12, 12, 12, 12, 2, 2, 2, 2, 10, 10, 10, 10, 12, 12, 12, 12, 16, 11, 11, 11, 11, 9, 9, 9, 9, 5, 5, 5, 5 },
        [3] = { 9, 9, 9, 9, 7, 7, 7, 7, 15, 15, 11, 11, 11, 11, 8, 8, 8, 8, 12, 12, 12, 12, 16, 11, 11, 11, 11, 6, 6, 6, 6, 9, 9, 9, 9, 2, 2, 2, 2, 15, 8, 8, 8, 8, 10, 10, 10, 10, 10, 10, 10, 10, 4, 4, 4, 4, 12, 12, 12, 12, 16, 3, 3, 3, 3, 7, 7, 7, 7, 5, 5, 5, 5 },
        [4] = { 8, 8, 8, 8, 7, 7, 7, 7, 15, 15, 7, 7, 7, 7, 11, 11, 11, 11, 10, 10, 10, 10, 16, 9, 9, 9, 9, 3, 3, 3, 3, 12, 12, 12, 12, 5, 5, 5, 5, 15, 11, 11, 11, 11, 6, 6, 6, 6, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, 16, 4, 4, 4, 4, 12, 12, 12, 12, 2, 2, 2, 2 },
        [5] = { 10, 10, 10, 10, 8, 8, 8, 8, 16, 16, 7, 7, 7, 7, 12, 12, 12, 12, 3, 3, 3, 3, 16, 10, 10, 10, 10, 4, 4, 4, 4, 7, 7, 7, 7, 2, 2, 2, 2, 16, 5, 5, 5, 5, 8, 8, 8, 8, 9, 9, 9, 9, 6, 6, 6, 6, 11, 11, 11, 11, 16, 9, 9, 9, 9, 11, 11, 11, 11, 12, 12, 12, 12 }
    }
}

config.collect_config = {
    collectAnimation  = {
        unlockLoop = "animation",
        lock       = "animation1",
        lockLoop   = "animation2",
        unlock     = "animation3",
    },
    max_point         = 200,
    progressStartPosX = 19,
    progressEndPosX   = 550,
    progressPosY      = 0,
    maxMapLevel       = 100,
    collect_id        = M1
}
config.jackpot_config = {
    width            = { 331, 248, 200, 200 },
    scale            = { 1, 1, 1, 1 },
    scale_lock       = { 1, 0.8, 0.7, 0.7 },
    lock_tip_scale   = { 0.6, 0.65, 0.8, 0.8 },
    unlock_tip_scale = { 0.6, 0.65, 0.8, 0.8 },
    count            = 4,
    name             = { "grand", "major", "minor", "mini" },
    unlock_fnt       = "theme220_jp_font%s.fnt",
    lock_fnt         = "theme220_jp_font5.fnt",
    light_jp_img     = "#theme220_b_jp_name%s.png",
    allowK           = { [220] = false, [720] = false, [1220] = false },
    jp_tip_pos       = { cc.p(0, 457), cc.p(0, 385), cc.p(-205, 336), cc.p(205, 336) },
    --light_bg_img     = "#theme219_base_jp_bg%s.png",
}

config.transition_config = {
    free  = { ["onCover"] = 62 / 30, ["onEnd"] = 90 / 30, },
    bonus = { ["onCover"] = 55 / 30, ["onEnd"] = 75 / 30, },
    super = { ["onCover"] = 45 / 30, ["onEnd"] = 80 / 30, },
}
config.stick_wild_config = {
    num_config = {
        num_offset = cc.p(G_CELL_WIDTH / 2 - 10, G_CELL_HEIGHT / 2),
        num_file   = "stick_num"
    },

    boom_path  = {
        [1]   = { { { 0, 1 } } }, -- Y:1= row+1,
        [2]   = { { { 0, -1 } } },

        [3]   = { { { 0, 1 } }, { { 0, 2 } } },
        [4]   = { { { 0, -1 } }, { { 0, -2 } } },
        [5]   = { { { -1, 0 }, { 1, 0 } } },
        [6]   = { { { 0, 1 }, { 0, -1 } } },

        [7]   = { { { 0, -1 }, { 0, 1 } }, { { 0, 2 } } },
        [8]   = { { { 0, -1 }, { 0, 1 } }, { { 0, -2 } } },
        [9]   = { { { 1, 0 } }, { { 1, 1 } }, { { 0, 1 } } },
        [10]  = { { { -1, 0 } }, { { -1, 1 } }, { { 0, 1 } } },
        [11]  = { { { 1, 0 } }, { { 1, -1 } }, { { 0, -1 } } },
        [12]  = { { { -1, 0 } }, { { -1, -1 } }, { { 0, -1 } } },

        [13]  = { { { 0, -1 }, { 0, 1 } }, { { 0, -2 }, { 0, 2 } } },
        [14]  = { { { 0, -1 }, { 1, 0 } }, { { 0, -2 }, { 2, 0 } } },
        [15]  = { { { 0, 1 }, { 1, 0 } }, { { 0, 2 }, { 2, 0 } } },
        [16]  = { { { -1, 0 }, { 1, 0 }, { 0, -1 } }, { { 0, -2 } } },
        [17]  = { { { -1, 0 }, { 1, 0 }, { 0, 1 } }, { { 0, 2 } } },
        [18]  = { { { -1, 0 }, { 1, 0 }, { 0, 1 }, { 0, -1 } } },

        [19]  = { { { -1, 0 }, { 1, 0 }, { 0, 1 }, { 0, -1 } }, { { 0, 2 }, { 0, -2 } } },

        [20]  = { { { -1, 0 } }, { { -1, -1 } }, { { 0, -1 } }, { { 1, -1 } },
                  { { 1, 0 } }, { { 1, 1 } }, { { 0, 1 } }, { { -1, 1 } } },
        [21]  = {
            { { 0, -1 }, { 0, 1 } }, { { 0, -2 }, { 0, 2 } },
            { { 0, -3 }, { 0, 3 } }, { { 0, -4 }, { 0, 4 } },
            { { 0, -5 }, { 0, 5 } }, { { 0, -6 }, { 0, 6 } },
            { { 0, -7 }, { 0, 7 } }, { { 0, -8 }, { 0, 8 } },
        },
        [200] = { { { -1, 0 } }, { { -1, 1 } }, { { 0, 1 } }, { { 1, 1 } },
                  { { 1, 0 } } },
        [201] = { { { -1, 0 } }, { { -1, -1 } }, { { 0, -1 } }, { { 1, -1 } },
                  { { 1, 0 } } },
    }
}
config.map_config = {
    map_fg             = {
        mini_cnt = 5,
        max_cnt  = 9
    },
    max_level          = 100,
    user_start_pos     = cc.p(-76, -582),

    build_level        = Set({ 4, 9, 12, 18, 22, 25, 31, 35, 40, 44,
                               48, 53, 56, 62, 66, 69, 75, 79, 84,
                               88, 92, 100 }
    ),
    big_node_config    = {
        [4]   = { multi = 2, scale = 1.05 },
        [9]   = { extra = 6, wild = 2, scale = 1.05 },
        [12]  = { multi = 2, wild = 1, scale = 1.05 },
        [18]  = { extra = 6, wild = 1, scale = 1.05 },
        [22]  = { extra = 8, wild = 2, scale = 1.05 },
        [25]  = { multi = 2, wild = 1, scale = 1.05 },
        [31]  = { multi = 3, wild = 1, scale = 1.05 },
        [35]  = { extra = 8, wild = 1, scale = 1.05 },
        [40]  = { multi = 3, wild = 1, scale = 1.05 },
        [44]  = { multi = 3, wild = 1, scale = 1.05 },
        [48]  = { extra = 12, wild = 2, scale = 1.05 },
        [53]  = { extra = 12, wild = 1, scale = 1.05 },
        [56]  = { multi = 5, wild = 1, scale = 1.05 },
        [62]  = { multi = 5, wild = 1, scale = 1.05 },
        [66]  = { multi = 5, wild = 1, scale = 1.1 },
        [69]  = { extra = 16, wild = 2, scale = 1.05 },
        [75]  = { multi = 8, wild = 1, scale = 1.05 },
        [79]  = { multi = 8, wild = 1, scale = 1.1 },
        [84]  = { extra = 16, wild = 1, scale = 1.1 },
        [88]  = { extra = 20, wild = 2, scale = 1.1 },
        [92]  = { multi = 10, wild = 1, scale = 1.1 },
        [100] = { multi = 10, wild = 1, scale = 1.5 },
    },
    big_node_type_list = {
        [1] = {}, --  [wild1] activeed every spin
        [2] = { key = "multi" }, --all wins are [multi]
        [3] = { key = "extra" }, --extra [wild2]
        [4] = {}, --[wild1] moving on the reels
        [5] = {}, --[wild1] STICK ON THE REELS
        [6] = { key = "extra" }, --extra [wild1]
    },
    map_type_list      = {
        [1] = {-- small and blue
            [1] = {
                "#theme220_map_map24.png" -- unlight
            },
            [2] = {
                "#theme220_map_map23.png" -- light
            }
        },
        [2] = {-- small and red
            [1] = {
                "#theme220_map_map26.png" -- unlight
            },
            [2] = {
                "#theme220_map_map25.png" -- light
            }
        },
        [3] = { 1, 2 }, -- big line {1,2}
        [4] = { 1, 3 }, -- big line {1, 3}
        [5] = { 1, 4, 2 }, -- big line {1, 4, 2 }
        [6] = { 1, 6 }, -- big line {1, 6}
        [7] = { 1, 5, 2 }, -- big line {1, 5, 2}
    },
    all_node_type      = {
        2, 1, 2, 3, --4
        2, 2, 1, 2, 4, --9
        2, 2, 5, --12
        2, 2, 1, 2, 2, 6, --18
        2, 1, 2, 4, --22
        2, 2, 7, --25
        2, 2, 1, 2, 2, 3, --31
        2, 1, 2, 6, --35
        2, 2, 1, 2, 5, --40
        2, 1, 2, 7, --44
        2, 1, 2, 4, --48
        2, 2, 1, 2, 6, --53
        2, 2, 3, --56
        2, 2, 2, 1, 2, 7, --62
        2, 1, 2, 5, --66
        2, 2, 4, --69
        2, 2, 1, 2, 2, 5, --75
        2, 1, 2, 7, --79
        2, 2, 1, 2, 6, --84
        2, 1, 2, 4, -- 88
        2, 1, 2, 5, --92
        2, 2, 2, 1, 2, 2, 2, 7 --100
    },
}

config.csb_list = {
    base                             = "csb/main_game.csb",
    map                              = "csb/map.csb",
    ["dialog_" .. dialog_type.free]  = "csb/dialog_1.csb",
    ["dialog_" .. dialog_type.jp]    = "csb/dialog_2.csb",
    ["dialog_" .. dialog_type.super] = "csb/dialog_3.csb",
    ["dialog_" .. dialog_type.wheel] = "csb/dialog_4.csb",
    ["dialog_" .. dialog_type.reel]  = "csb/dialog_5.csb",
    wheel                            = "csb/wheel.csb",
    jp_tip                           = "csb/jp_tip_node.csb",
    wheel_reels                      = "csb/reel_node.csb",

    reel_item                        = "csb/reel_item.csb",

}

local JP_WHEEL_HEIGHT = 166
local JP_WHEEL_WIDHT = 630
config.reel_wheel_config = {
    count        = 10,
    height       = JP_WHEEL_HEIGHT,
    width        = JP_WHEEL_WIDHT,
    bonus_wheel  = { 100, 2, 5, 103, 102, 20, 2, 3, 101, 10 },
    speed_config = {
        ["itemCount"]          = 10, -- 上下加一个 cell 之后的个数
        ["finshRollSumLength"] = 2, -- 结束阶段会滚过几遍总共的Count
        ["cellSize"]           = cc.p(0, JP_WHEEL_HEIGHT),
        ["delayBeforeSpin"]    = 0.0, --开始旋转前的时间延迟
        ["upBounce"]           = 0, --开始滚动前，向上滚动距离
        ["upBounceTime"]       = 0, --开始滚动前，向上滚动时间
        ["speedUpTime"]        = 1, --加速时间
        ["rotateTime"]         = 2, -- 匀速转动的时间之和
        ["maxSpeed"]           = JP_WHEEL_HEIGHT * 60 * 1 / 4, --每一秒滚动的距离
        ["downBounce"]         = 0, --滚动结束前，向下反弹距离  都为正数值
        ["speedDownTime"]      = 3.3, -- 4
        ["downBounceTime"]     = 0,
        ["addStartPos"]        = JP_WHEEL_HEIGHT / 2,
        ["direction"]          = 2,
        --["addEndPos"]          = 6.5 * JP_WHEEL_HEIGHT,
        ["startIndex"]         = JP_WHEEL_HEIGHT / 2, -- 随机的是 index 格子的 而不是 key
        ["deltaType"]          = 2,
    },
    wheel_style  = {
        [1] = { -- jackpot
            bg  = "#theme220_reel_bg%s.png",
            img = "#theme220_reel_item%s.png"
        },
        [2] = {--  count
            bg = "#theme220_reel_bg5.png"
        }
    }
}

config.wheel_config = {
    count        = 6,
    --bet_list     = { "all", 1, 2, 3, 4, 5, 6, 7 },
    speed_config = {
        ["itemCount"]       = 6, -- 上下加一个 cell 之后的个数
        ["delayBeforeSpin"] = 0.0, --开始旋转前的时间延迟
        ["upBounce"]        = 0, --开始滚动前，向上滚动距离
        ["upBounceTime"]    = 0, --开始滚动前，向上滚动时间
        ["speedUpTime"]     = 2, --加速时间
        ["rotateTime"]      = 1, -- 匀速转动的时间之和
        ["maxSpeed"]        = 60 * 10, --每一秒滚动的距离
        ["downBounce"]      = 0, --滚动结束前，向下反弹距离  都为正数值
        ["speedDownTime"]   = 3, -- 4
        ["downBounceTime"]  = 0,
        ["bounceSpeed"]     = 0,
        ["direction"]       = 1,
    }

}
config.dialog_config = {
    [dialog_type.free]  = {
        [fs_show_type.start]   = {--start
            bg       = {
                name        = "dialog_free",
                startAction = { "animation1_1", false },
                loopAction  = { "animation1_2", true },
                endAction   = { "animation1_3", false },
            },
            btn_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 3 / 30, 0.05 }, { 7 / 30, 1.2 }, { 4 / 30, 0.95 }, { 4 / 30, 1 } },
                stepEndScale = { { 1 }, { 7 / 30, 1 }, { 4 / 30, 1.25 }, { 11 / 30, 0 } },
            },
            btn      = {
                name = "dialog_free_btn",
            },
        },
        [fs_show_type.more]    = {
            bg = {
                name        = "dialog_free",
                startAction = { "animation2_%s", false },
                formatname  = true,
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
                --
                --stepFade     = { { 0 }, { 5 / 30, 0 }, { 7 / 30, 255 } },
                --stepEndFade  = { { 255 }, { 18 / 30, 255 }, { 7 / 30, 0 } },

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
    [dialog_type.jp]    = {
        [fs_show_type.collect] = {
            bg         = {
                name        = "dialog_jackpot",
                startAction = { "animation%s_1", false },
                loopAction  = { "animation%s_2", true },
                endAction   = { "animation%s_3", false },
                formatname  = true,
            },
            label_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 8 / 30, 1.2 }, { 4 / 30, 0.95 }, { 4 / 30, 1.05 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 6 / 30, 1.25 }, { 10 / 30, 0 } },
            },
            btn_node   = {
                isAction     = true,
                stepScale    = { { 0 }, { 5 / 30, 0 }, { 7 / 30, 1.2 }, { 4 / 30, 0.95 }, { 4 / 30, 1.05 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 9 / 30, 1 }, { 6 / 30, 1.25 }, { 10 / 30, 0 } },
            },
            btn        = {
                name = "dialog_free_btn",
            },
            maxWidth   = 511,
        }

    },
    [dialog_type.super] = {
        [fs_show_type.start]   = {
            bg          = {
                name        = "dialog_map",
                startAction = { "animation1_1", false },
                loopAction  = { "animation1_2", true },
                endAction   = { "animation1_3", false },
            },
            count       = {
                isImg      = true,
                name       = "#theme220_map_level_%s.png",
                formatname = true
            },
            label_node  = {
                isAction     = true,
                stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.12 }, { 7 / 30, 1 } },
                stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.24 }, { 7 / 30, 0 } },

                --stepFade     = { { 0 }, { 5 / 30, 0 }, { 7 / 30, 255 } },
                --stepEndFade  = { { 255 }, { 18 / 30, 255 }, { 7 / 30, 0 } },

            },
            label_node2 = {
                isAction     = true,
                stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.24 }, { 7 / 30, 1 } },
                stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.24 }, { 7 / 30, 0 } },

                --stepFade     = { { 0 }, { 5 / 30, 0 }, { 7 / 30, 255 } },
                --stepEndFade  = { { 255 }, { 18 / 30, 255 }, { 7 / 30, 0 } },

            },
            btn_node    = {
                isAction     = true,
                stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.2 }, { 4 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 6 / 30, 1 }, { 6 / 30, 1.2 }, { 10 / 30, 0 } },
            },
            btn         = {
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
                stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.2 }, { 4 / 30, 0 } },

            },
            btn_node   = {
                isAction     = true,
                stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.2 }, { 4 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 6 / 30, 1 }, { 6 / 30, 1.2 }, { 10 / 30, 0 } },
            },
            btn        = {
                name = "dialog_free_btn",
            },
            maxWidth   = 550,
        },
    },
    [dialog_type.wheel] = {
        [fs_show_type.start]   = {
            bg       = {
                name        = "dialog_map",
                startAction = { "animation4_1", false },
                loopAction  = { "animation4_2", true },
                endAction   = { "animation4_3", false },
            },
            btn_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 26 / 30, 0 }, { 8 / 30, 1.2 }, { 5 / 30, 0.95 }, { 6 / 30, 1 } },
                stepEndScale = { { 1 }, { 5 / 30, 0.95 }, { 4 / 30, 1.2 }, { 6 / 30, 0 } },
            },
            btn      = {
                name = "dialog_free_btn",
            }
        },
        [fs_show_type.collect] = {
            bg         = {
                name        = "dialog_map",
                startAction = { "animation3_1", false },
                loopAction  = { "animation3_2", true },
                endAction   = { "animation3_3", false },
            },
            label_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 12 / 30, 0 }, { 7 / 30, 1.2 }, { 6 / 30, 0.95 }, { 6 / 30, 1 } },
                stepEndScale = { { 1 }, { 7 / 30, 1 }, { 6 / 30, 1.2 }, { 12 / 30, 0 } },

            },
            btn_node   = {
                isAction     = true,
                stepScale    = { { 0 }, { 12 / 30, 0 }, { 7 / 30, 1.2 }, { 6 / 30, 0.95 }, { 6 / 30, 1 } },
                stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.2 }, { 10 / 30, 0 } },
            },
            btn        = {
                name = "dialog_free_btn",
            },
            maxWidth   = 550,
        },
    },
    [dialog_type.reel]  = {
        [fs_show_type.start]   = {
            bg = {
                name        = "dialog_jp_start",
                startAction = { "animation1", true },
                --loopAction  = { "animation2", true },
                endAction   = { "animation2", false },
            },
        },
        [fs_show_type.more]    = {
            bg = {
                name        = "dialog_jpwheel",
                startAction = { "animation1_1", false },
                loopAction  = { "animation1_2", true },
                endAction   = { "animation1_3", false },
            },
        },
        [fs_show_type.collect] = {
            bg         = {
                name        = "dialog_jpwheel",
                startAction = { "animation2_1", false },
                loopAction  = { "animation2_2", true },
                endAction   = { "animation2_3", false },
            },
            label_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 12 / 30, 0 }, { 7 / 30, 1.2 }, { 6 / 30, 0.95 }, { 6 / 30, 1 } },
                stepEndScale = { { 1 }, { 7 / 30, 1 }, { 6 / 30, 1.2 }, { 12 / 30, 0 } },

            },
            btn_node   = {
                isAction     = true,
                stepScale    = { { 0 }, { 12 / 30, 0 }, { 7 / 30, 1.2 }, { 6 / 30, 0.95 }, { 6 / 30, 1 } },
                stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.2 }, { 10 / 30, 0 } },
            },
            btn        = {
                name = "dialog_free_btn",
            },
            maxWidth   = 550,
        },
    }
}

config.spine_path = {
    ---collect
    collect_item      = "base/collect/jdt_shouji",
    collect_lock      = "base/collect/jdt_js",
    collect_map       = "base/collect/jdt_miao",
    collect_full      = "base/collect/jdt_qz",
    collect_loop      = "base/collect/jdt_xh1",
    collect_uping     = "base/collect/jdt_zhang",
    collect_fly       = "base/collect/m1_shouji",
    ---jackpot
    jackpot_lock      = "base/jackpot/jp_js",
    jackpot_win       = "base/jackpot/jp_zj",
    jackpot_loop      = "base/jackpot/jp_xh",
    ---jili
    jili_free         = "base/jili/jl",
    jili_good_luck    = "base/jili/aboluo_1",
    ---transition
    transition_free   = "base/transition1/qieping_jp",
    transition_bonus  = "base/transition2/aboluo",
    transition_super  = "base/transition3/qieping_map",
    ---base
    logo_label        = "long_logo/changpinglogo",
    base_bg           = "bg/bj",
    fg_bg             = "bg/fg_bg",
    base_board        = "bg/qipan",
    win_kuang         = "item/kuang/spine",
    --- stick_wild
    stick_num         = "base/wild/wildjiaobiao",
    gold_wild_center  = "base/wild/jinwild_kuosanquan",
    wild_boom         = "base/wild/jinwild_xiaobaozha",
    --stick_apppear     = "base/wild/wildchuxian",
    ---free
    free_wild_fall    = "free/wild_fall/wild_za",
    free_wild_fall2   = "free/wild_fall/wild_za2",
    ---map
    map_back_btn      = "map/back_btn/btg",
    map_head          = "map/head/map_ui",
    map_num_change    = "map/big/shuzishx",
    map_small_light   = "map/small/mapfire",
    map_big_light     = "map/big/shendianfire",

    ---wheel
    wheel_roll        = "wheel/map_zhuanpan",
    wheel_stop_win    = "wheel/map_yepian",
    -----jp_wheel
    jp_wheel_stop_win = "jp_wheel/jp_kuang",
    jp_wheel_bg       = "jp_wheel/jp_lz",
    jp_wheel_pointer  = "jp_wheel/zhizhen",
    jp_wheel_win      = "jp_wheel/jpzhongjiang",
    --- dialog
    dialog_free       = "dialog/fg/fgtanchuang",
    dialog_free_btn   = "dialog/fg/anniusaoguang",
    dialog_jackpot    = "dialog/jp/jptanchuang",
    dialog_jpwheel    = "dialog/jp/jpwheel",
    dialog_jp_start   = "dialog/jp/jp_spin",
    dialog_map        = "dialog/map/maptanchuang",
    dialog_store      = "dialog/tip/sd_tsct_01",
}
config.particle_path = {
    progress_tail = "shangzhanglizi.plist",
}
config.music_volume = {
    max_volume  = 1,
    min_volume  = 0,
    time_volume = 0.2
}
config.audioList = {
    common_click           = "audio/base/click.mp3",
    trigger_bell           = "audio/base/bell.mp3",
    enter_game             = "audio/base/theme_open.mp3",
    ---transition
    transition_free        = "audio/base/transition1.mp3",
    transition_bonus       = "audio/base/transition2.mp3",
    transition_super       = "audio/base/transition3.mp3",
    good_luck              = "audio/base/active_apollo.mp3",
    ---scatter
    symbol_scatter1        = "audio/land/scatter_land1.mp3",
    symbol_scatter2        = "audio/land/scatter_land2.mp3",
    symbol_scatter3        = "audio/land/scatter_land3.mp3",
    symbol_scatter4        = "audio/land/scatter_land5.mp3",
    symbol_scatter5        = "audio/land/scatter_land5.mp3",
    symbol_bonus1          = "audio/land/jp_land1.mp3",
    symbol_bonus2          = "audio/land/jp_land1.mp3",
    reel_notify_free1      = "audio/land/reel_active1.mp3",
    reel_notify_free2      = "audio/land/reel_active2.mp3",
    reel_notify_free3      = "audio/land/reel_active3.mp3",
    wild_land              = "audio/land/wild_land.mp3",
    ---wild
    wild_red               = "audio/base/wild_red.mp3",
    wild_stick_1           = "audio/base/wild_stick1.mp3",
    wild_success1          = "audio/base/wild_success1.mp3",
    wild_success2          = "audio/base/wild_success2.mp3",

    --- collect
    collect_fly            = "audio/collect/map_collect.mp3",
    collect_lock           = "audio/collect/map_lock.mp3",
    collect_unlock         = "audio/collect/map_unlock.mp3",
    collect_full           = "audio/collect/map_full.mp3",
    --collect_up          = "audio/collect/map_up.mp3",
    map_close              = "audio/collect/map_close.mp3",
    map_open               = "audio/collect/map_open.mp3",
    --- jackpot
    jp_unlock              = "audio/jp/jp_unlock.mp3",
    jp_lock                = "audio/jp/jp_lock.mp3",
    jp_trigger             = "audio/jp/jp_trigger.mp3",
    jp_dialog_1            = "audio/dialog/dialog_grand.mp3",
    jp_dialog_2            = "audio/dialog/dialog_major.mp3",
    jp_dialog_3            = "audio/dialog/dialog_minor.mp3",
    jp_dialog_4            = "audio/dialog/dialog_mini.mp3",
    ---map
    map_voice              = "audio/map/map_voice.mp3",
    super_background       = "audio/map/mapfg_bgm.mp3",
    mapfg_add              = "audio/map/mapfg_add.mp3",
    mapfg_trigger          = "audio/map/mapfg_trigger.mp3",
    ui_move                = "audio/map/ui_move.mp3",
    --- wheel
    wheel_appear           = "audio/map/wheel_appear.mp3",
    wheel_disappear        = "audio/map/wheel_disappear.mp3",
    wheel_spin             = "audio/map/wheel_spin.mp3",
    wheel_trigger          = "audio/map/wheel_trigger.mp3",
    wheel_win              = "audio/map/wheel_win.mp3",
    wild_appear            = "audio/map/wild_appear.mp3", --??
    wheel_bgm              = "audio/map/wheel_bgm.mp3",
    ---jp_wheel
    jp_wheel_bgm           = "audio/jp_wheel/jp_bgm.mp3",
    jp_wheel_click         = "audio/jp_wheel/jp_click.mp3",
    jp_wheel_spin          = "audio/jp_wheel/jp_spin.mp3",
    jp_wheel_win           = "audio/jp_wheel/jp_win.mp3",
    --- free
    wild_stick_2           = "audio/free/wild_stick2.mp3",
    free_background        = "audio/free/fg_bgm.mp3",
    free_open              = "audio/free/free_open.mp3",
    wild_fill              = "audio/free/wild_fill.mp3",
    --- dialog
    free_dialog_start      = "audio/dialog/fg_start.mp3",
    free_dialog_more       = "audio/dialog/fg_extra.mp3",
    free_dialog_collect    = "audio/dialog/fg_collect.mp3",

    jackpot_dialog_collect = "audio/dialog/jp_collect.mp3",
    jackpot_dialog_start   = "audio/dialog/jp_start.mp3",

    super_dialog_start     = "audio/dialog/mapfg_start.mp3",
    super_dialog_collect   = "audio/dialog/mapfg_collect.mp3",
    wheel_dialog_collect   = "audio/dialog/wheel_collect.mp3",


}
config.all_img_path = {
    { 1, "font/theme220_font5.png" },
    { 1, "font/theme220_jp_font1.png" },
    { 1, "font/theme220_jp_font2.png" },
    { 1, "font/theme220_jp_font3.png" },
    { 1, "font/theme220_jp_font4.png" },
    { 1, "font/theme220_jp_font5.png" },
    { 1, "font/theme220_map_font1.png" },
    { 1, "font/theme220_pop_font1.png" },
    { 1, "font/theme220_pop_font2.png" },
    { 1, "font/theme220_reel_font.png" },
    { 1, "font/theme220_wheel_font.png" },
    { 1, "font/theme_font2.png" },
    { 1, "image/bg/theme220_bg_base.png" },
    { 1, "image/bg/theme220_bg_fg.png" },
    { 1, "image/bg/theme220_bg_map1.png" },
    { 1, "image/bg/theme220_bg_map2.png" },
    { 1, "image/bg/theme220_bg_super.png" },
    { 1, "image/bg/theme220_map_fg2.png" },
    { 1, "image/bg/theme220_map_fg3.png" },
    { 1, "image/bg/theme220_map_fg4.png" },
    { 1, "image/paytable/paytable.png" },
    { 1, "image/plist/base.png" },
    { 1, "image/plist/dialog.png" },
    { 1, "image/plist/map.png" },
    { 1, "image/plist/reel_game.png" },
    { 1, "image/plist/symbol.png" },
    { 1, "image/plist/wheel.png" },
    { 1, "spine/base/collect/jdt_js.png" },
    { 1, "spine/base/collect/jdt_miao.png" },
    { 1, "spine/base/collect/jdt_qz.png" },
    { 1, "spine/base/collect/jdt_shouji.png" },
    { 1, "spine/base/collect/jdt_xh.png" },
    { 1, "spine/base/collect/jdt_xh1.png" },
    { 1, "spine/base/collect/jdt_zhang.png" },
    { 1, "spine/base/collect/m1_shouji.png" },
    { 1, "spine/base/jackpot/jp_js.png" },
    { 1, "spine/base/jackpot/jp_xh.png" },
    { 1, "spine/base/jackpot/jp_zj.png" },
    { 1, "spine/base/jili/aboluo_1.png" },
    { 1, "spine/base/jili/jl.png" },
    { 1, "spine/base/transition1/qieping_jp.png" },
    { 1, "spine/base/transition2/aboluo.png" },
    { 1, "spine/base/transition3/qieping_map.png" },
    { 1, "spine/base/wild/jinwild_kuosanquan.png" },
    { 1, "spine/base/wild/jinwild_xiaobaozha.png" },
    { 1, "spine/base/wild/wildjiaobiao.png" },
    { 1, "spine/bg/bj.png" },
    { 1, "spine/bg/fg_bg.png" },
    { 1, "spine/bg/qipan.png" },
    { 1, "spine/dialog/fg/anniusaoguang.png" },
    { 1, "spine/dialog/fg/fgtanchuang.png" },
    { 1, "spine/dialog/jp/bonus_tanchuang.png" },
    { 1, "spine/dialog/jp/jp_spin.png" },
    { 1, "spine/dialog/jp/jptanchuang.png" },
    { 1, "spine/dialog/jp/jpwheel.png" },
    { 1, "spine/dialog/map/maptanchuang.png" },
    { 1, "spine/free/wild_fall/wild_za.png" },
    { 1, "spine/free/wild_fall/wild_za2.png" },
    { 1, "spine/item/1/hongwild.png" },
    { 1, "spine/item/10/j.png" },
    { 1, "spine/item/11/10.png" },
    { 1, "spine/item/12/9.png" },
    { 1, "spine/item/13/jpwheel.png" },
    { 1, "spine/item/14/scatter.png" },
    { 1, "spine/item/15/jinwild.png" },
    { 1, "spine/item/16/wild2.png" },
    { 1, "spine/item/2/m1.png" },
    { 1, "spine/item/3/m2_1.png" },
    { 1, "spine/item/4/m3.png" },
    { 1, "spine/item/5/m4.png" },
    { 1, "spine/item/6/m5_1.png" },
    { 1, "spine/item/7/a.png" },
    { 1, "spine/item/8/k_1.png" },
    { 1, "spine/item/9/q.png" },
    { 1, "spine/item/kuang/zhongjline.png" },
    { 1, "spine/jp_wheel/jp_bg.png" },
    { 1, "spine/jp_wheel/jp_kuang.png" },
    { 1, "spine/jp_wheel/jp_lz.png" },
    { 1, "spine/jp_wheel/jpzhongjiang.png" },
    { 1, "spine/jp_wheel/zhizhen.png" },
    { 1, "spine/long_logo/changpinglogo.png" },
    { 1, "spine/map/back_btn/btg.png" },
    { 1, "spine/map/big/shendianfire.png" },
    { 1, "spine/map/big/shuzishx.png" },
    { 1, "spine/map/head/map_ui.png" },
    { 1, "spine/map/small/mapfire.png" },
    { 1, "spine/paytable/spine/back_to_game01.png" },
    { 1, "spine/wheel/map_yepian.png" },
    { 1, "spine/wheel/map_zhuanpan.png" },
}
return config



