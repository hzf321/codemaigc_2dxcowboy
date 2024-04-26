--[[
Author: xiongmeng
Date: 2020-12-09 14:47:44
LastEditors: wanghongjie
Description: 325
--]]
local config = {}
local G_CELL_HEIGHT = 105
local G_CELL_WIDTH = 153

config.G_CELL_HEIGHT = G_CELL_HEIGHT
config.G_CELL_WIDTH  = G_CELL_WIDTH

config.SpinBoardType = {
    Normal      = 1,
    FreeSpin    = 2,
    MapFreeSpin = 3,
}
config.SpinLayerType = {
    Normal      = 1,
    FreeSpin    = 1,
    MapFreeSpin = 1,
}
config.ReSpinStep = {
    OFF = 1,
    Start = 2,
    Reset = 3,
    Over = 4,
    Playing = 5, 
}
config.MapFreeWildType = {
    RandomWild = "random",
    MoveWild   = "moving",
    StickyWild = "sticky",
    MultiWild  = 5,
}
config.fs_show_type = {
    start = 1,
    more = 2,
    collect = 3,
}
config.gameMasterStatus = {
    hide = 0, 
    show = 1
}
config.baseColCnt = 6
config.special_symbol = {
    wild = 1,
    collectSymbol = 2,
    double_rapid = 10,
    moon_wild = 11,
    sun_wild = 12,
    moon = 13,
    sun  = 14,
    scatter = 15,
}

config.symbol_config = {
    ["scatter_key_list"] = {config.special_symbol.scatter},
    ["not_init_symbol_set"] = Set({
        config.special_symbol.scatter, -- scatter
        config.special_symbol.double_rapid,
        config.special_symbol.moon_wild,
        config.special_symbol.sun_wild,
        config.special_symbol.moon,
        config.special_symbol.sun,
    }),
    ["notify_symbol_list"] = Set({
        config.special_symbol.scatter,
    }),
    ["loop_symbol_list"] = Set({
        config.special_symbol.scatter, -- scatter
        config.special_symbol.double_rapid,
        config.special_symbol.moon_wild,
        config.special_symbol.sun_wild,
        config.special_symbol.moon,
        config.special_symbol.sun,
    }),
    ["low_symbol_list"] = Set({
        6,7,8,9,
    }),
    ["major_symbol_list"] = {2,3,4,5},
    ["anim_suffix"] = {
        ["loop"] = "_2", ["notify"] = "_1", ["win"] = "_3", ["static"] = "_4"
    }
}

config.init_config = {
	plistAnimate     = {
        "image/plist/symbol",
        "image/plist/base",
    },
    csbList          = {
        "csb/base_game.csb",
        "csb/progress_jp.csb",
        "csb/base_board.csb",
        --"csb/gameMaster.csb"
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
    baseBet = 10000,
    isPortrait = false,
    underPressure = 1,

}
config.reel_spin_config = {
	["delay"] = 0,
    ["upBounce"] = G_CELL_HEIGHT * 2 / 3,
    ["upBounceFree"] = G_CELL_HEIGHT * 5 / 6,
	["upBounceMaxSpeed"] = 6 * 60,
	["upBounceTime"] = 0,
	["speedUpTime"] = 5/60, --20 / 60,
	["rotateTime"] = 5 / 60,
	["maxSpeed"] =  -30.3 * 60, -- -26.5 * 60,
	["downBounceMaxSpeed"] = 10 * 60,
	["extraReelTime"] = 120 / 60,
	["spinMinCD"] = 0, -- 0.5,
	["speedDownTime"] =  45 / 60,
	["downBounce"] = G_CELL_HEIGHT*1/5, -- 对应 普通停止在symbol + 1 
	["downBounceTime"] = 10 / 60,
	["autoDownBounceTimeMult"] = 1,
	["checkStopColCnt"] = 5,
	-- end
	["stopDelay"] =10 / 60,
	["stopDelayList"] = {
	    [1] = 10 / 60,
	    [2] = 10 / 60,
	    [3] = 10 / 60,
    },
    ["stopDelayFree"] = 10 / 60, -- 15/60,
	["stopDelayListFree"] = {
	    [1] = 10 / 60,
	    [2] = 10 / 60,
	    [3] = 10 / 60,
	},
	["autoStopDelayMult"] = 1,
	["speicalSpeed"] = 100/30,
    ["extraReelTimeInFreeGame"] = 240/30,
    ["extraJiliTime"] = 40/30,
    ["extraAddWildTime"] = 70/30,
}
config.music_volume = {
    max_volume = 1,
    min_volume = 0,
    time_volume = 0.3
}
config.csb_list = {
    map = "csb/map/map.csb",
    dialog_free = "csb/dialog/dialog_free.csb",
    dialog_wheel = "csb/dialog/dialog_wheel.csb",
    dialog_booster = "csb/dialog/dialog_booster.csb",
    dialog_mapfree = "csb/dialog/dialog_mapfree.csb",
    dialog_gameMaster_bottom = "csb/dialog/gamemas_tips.csb",
    d_gm_start = "csb/dialog/dialog_game_master.csb",
    d_welcome = "csb/dialog/dialog_welcom.csb",
    choose = "csb/dialog/choose.csb",    --选择界面
    
    footer_tip = "csb/jackpot/footer_jp_tip.csb",

    wheel = "csb/bonus/wheel.csb",      --转轮界面
    pick = "csb/bonus/pick.csb", -- pick 界面
    pick_result = "csb/bonus/pick_result.csb",    
    pick_node = "csb/bonus/pick_node.csb",
}
-- config.label_fnt = {
--     wild = "font/theme325_wheel_multi.fnt",
-- }
config.theme_config = {
	reel_symbol  = {
        ["theme_symbol_coinfig"]    = {
            ["symbol_zorder_list"]    = {
                [1]  = 700,
                [10]  = 700,
                [11]  = 700,
                [12]  = 700,
                [13]  = 700,
                [14]  = 700,
                [15] = 1000,
            },
            ["normal_symbol_list"]    = {
                1,2,3,4,5,6,7,8,9
            },
            ["special_symbol_list"]   = {
                10,11,12,13,14,15
            },
            ["no_roll_symbol_list"]   = {
                
            },
            ["special_symbol_config"] = {
                [config.special_symbol.scatter] = {
                    ["min_cnt"] = 3,
                    ["type"]    = G_THEME_SYMBOL_TYPE.NUMBER,
                    ["symbol_contain"] = Set({config.special_symbol.scatter}),
                    ["col_set"] = {
                        [1] = 1,
                        [2] = 1, 
                        [3] = 1,
                        [4] = 1,
                        [5] = 1,
                        [6] = 1,
                    },
                },
                [config.special_symbol.moon] = {
                    ["min_cnt"] = 5,
                    ["type"]    = G_THEME_SYMBOL_TYPE.NUMBER,
                    ["symbol_contain"]  = Set({
                        config.special_symbol.moon, 
                        config.special_symbol.moon_wild,
                        config.special_symbol.double_rapid,
                    }),
                    ["col_set"] = {
                        [1] = 1,
                        [2] = 1, 
                        [3] = 1,
                        [4] = 1,
                        [5] = 1,
                        [6] = 1,
                    },
                },
                [config.special_symbol.sun] = {
                    ["min_cnt"] = 5,
                    ["type"]    = G_THEME_SYMBOL_TYPE.NUMBER,
                    ["symbol_contain"]  = Set({
                        config.special_symbol.sun, 
                        config.special_symbol.sun_wild,
                        config.special_symbol.double_rapid,
                    }),
                    ["col_set"] = {
                        [1] = 1,
                        [2] = 1, 
                        [3] = 1,
                        [4] = 1,
                        [5] = 1,
                        [6] = 1,
                    },
                },
            },
        },
        ["theme_round_light_index"] = 1,
        ["theme_type"]              = "payLine",
        ["theme_type_config"]       = {
            pay_lines = {
                {1, 1, 1, 1, 1, 1},{0, 0, 0, 0, 0, 0},{2, 2, 2, 2, 2, 2},{0, 1, 2, 2, 1, 0},{2, 1, 0, 0, 1, 2},
                {1, 0, 0, 0, 0, 1},{1, 2, 2, 2, 2, 1},{0, 0, 1, 1, 2, 2},{2, 2, 1, 1, 0, 0},{1, 2, 1, 1, 0, 1},
                {1, 0, 1, 1, 2, 1},{0, 1, 1, 1, 1, 0},{2, 1, 1, 1, 1, 2},{0, 1, 0, 0, 1, 0},{2, 1, 2, 2, 1, 2},
                {1, 1, 0, 0, 1, 1},{1, 1, 2, 2, 1, 1},{0, 0, 2, 2, 0, 0},{2, 2, 0, 0, 2, 2},{0, 2, 2, 2, 2, 0},
                {2, 0, 0, 0, 0, 2},{1, 2, 0, 0, 2, 1},{1, 0, 2, 2, 0, 1},{0, 2, 0, 0, 2, 0},{2, 0, 2, 2, 0, 2},
            },
            line_cnt = 25
        },
        ["boardConfig"]             = {
            { -- base
                ["allow_over_range"] = true,
                ["colCnt"]           = 6,
                ["cellWidth"]        = G_CELL_WIDTH,
                ["cellHeight"]       = G_CELL_HEIGHT,
                ["symbolCount"]      = 3,
                ["lineWidth"]        = 0,
                ["reelConfig"]       = {
                    { ["base_pos"] = cc.p(181, 104.5) },
                }
            },
        }
    },
    base_col_cnt = 6,
}
config.theme_reels = {
	["main_reel"] = {
        [1] = { 2, 2, 2, 10, 9, 8, 8, 12, 12, 1, 8, 4, 15, 4, 3, 14, 14, 3, 6, 6, 7, 14, 8, 2, 1, 7, 6, 5, 14, 5, 14, 3, 5, 2, 2, 7, 12, 9, 6, 4, 1, 1, 3, 3, 5, 5, 9, 9},
        [2] = { 2, 2, 2, 10, 6, 6, 7, 12, 12, 1, 7, 5, 15, 4, 3, 14, 14, 3, 6, 6, 8, 14, 8, 2, 1, 9, 7, 3, 14, 3, 14, 3, 5, 2, 2, 8, 12, 9, 7, 5, 1, 1, 4, 4, 4, 4, 9, 9},
        [3] = { 2, 2, 2, 10, 6, 8, 7, 12, 12, 1, 7, 5, 15, 3, 5, 14, 14, 5, 9, 9, 8, 14, 9, 2, 1, 9, 7, 4, 14, 4, 14, 3, 4, 2, 2, 6, 12, 8, 7, 4, 1, 1, 5, 5, 3, 3, 6, 6},
        [4] = { 2, 2, 2, 10, 6, 8, 9, 11, 11, 1, 9, 3, 15, 5, 4, 13, 13, 4, 8, 8, 7, 13, 9, 2, 1, 9, 8, 5, 13, 5, 13, 3, 4, 2, 2, 7, 11, 6, 7, 3, 1, 1, 5, 5, 4, 4, 6, 6},
        [5] = { 2, 2, 2, 10, 8, 7, 7, 11, 11, 1, 7, 3, 15, 5, 4, 13, 13, 4, 9, 9, 8, 13, 8, 2, 1, 6, 6, 3, 13, 3, 13, 4, 5, 2, 2, 9, 11, 7, 9, 4, 1, 1, 3, 3, 5, 5, 6, 6},
        [6] = { 2, 2, 2, 10, 9, 9, 7, 11, 11, 1, 7, 5, 15, 4, 5, 13, 13, 5, 7, 7, 7, 13, 6, 2, 1, 8, 6, 4, 13, 4, 13, 3, 5, 2, 2, 6, 11, 9, 8, 4, 1, 1, 3, 3, 3, 3, 8, 8},
    },
    ["free_reel"] = {
        [1] = { 2, 2, 2, 10, 9, 8, 8, 12, 12, 1, 8, 4, 15, 4, 3, 14, 14, 3, 6, 6, 7, 14, 8, 2, 1, 7, 6, 5, 14, 5, 14, 3, 5, 2, 2, 7, 12, 9, 6, 4, 1, 1, 3, 3, 5, 5, 9, 9},
        [2] = { 2, 2, 2, 10, 6, 6, 7, 12, 12, 1, 7, 5, 15, 4, 3, 14, 14, 3, 6, 6, 8, 14, 8, 2, 1, 9, 7, 3, 14, 3, 14, 3, 5, 2, 2, 8, 12, 9, 7, 5, 1, 1, 4, 4, 4, 4, 9, 9},
        [3] = { 2, 2, 2, 10, 6, 8, 7, 12, 12, 1, 7, 5, 15, 3, 5, 14, 14, 5, 9, 9, 8, 14, 9, 2, 1, 9, 7, 4, 14, 4, 14, 3, 4, 2, 2, 6, 12, 8, 7, 4, 1, 1, 5, 5, 3, 3, 6, 6},
        [4] = { 2, 2, 2, 10, 6, 8, 9, 11, 11, 1, 9, 3, 15, 5, 4, 13, 13, 4, 8, 8, 7, 13, 9, 2, 1, 9, 8, 5, 13, 5, 13, 3, 4, 2, 2, 7, 11, 6, 7, 3, 1, 1, 5, 5, 4, 4, 6, 6},
        [5] = { 2, 2, 2, 10, 8, 7, 7, 11, 11, 1, 7, 3, 15, 5, 4, 13, 13, 4, 9, 9, 8, 13, 8, 2, 1, 6, 6, 3, 13, 3, 13, 4, 5, 2, 2, 9, 11, 7, 9, 4, 1, 1, 3, 3, 5, 5, 6, 6},
        [6] = { 2, 2, 2, 10, 9, 9, 7, 11, 11, 1, 7, 5, 15, 4, 5, 13, 13, 5, 7, 7, 7, 13, 6, 2, 1, 8, 6, 4, 13, 4, 13, 3, 5, 2, 2, 6, 11, 9, 8, 4, 1, 1, 3, 3, 3, 3, 8, 8},
    },
    ["map_free_reel"] = {
        [1] = { 2, 2, 2, 10, 9, 8, 8, 12, 12, 1, 8, 4, 4, 3, 14, 14, 3, 6, 6, 7, 14, 8, 2, 1, 7, 6, 5, 14, 5, 14, 3, 5, 2, 2, 7, 12, 9, 6, 4, 1, 1, 3, 3, 5, 5, 9, 9},
        [2] = { 2, 2, 2, 10, 6, 6, 7, 12, 12, 1, 7, 5, 4, 3, 14, 14, 3, 6, 6, 8, 14, 8, 2, 1, 9, 7, 3, 14, 3, 14, 3, 5, 2, 2, 8, 12, 9, 7, 5, 1, 1, 4, 4, 4, 4, 9, 9},
        [3] = { 2, 2, 2, 10, 6, 8, 7, 12, 12, 1, 7, 5, 3, 5, 14, 14, 5, 9, 9, 8, 14, 9, 2, 1, 9, 7, 4, 14, 4, 14, 3, 4, 2, 2, 6, 12, 8, 7, 4, 1, 1, 5, 5, 3, 3, 6, 6},
        [4] = { 2, 2, 2, 10, 6, 8, 9, 11, 11, 1, 9, 3, 5, 4, 13, 13, 4, 8, 8, 7, 13, 9, 2, 1, 9, 8, 5, 13, 5, 13, 3, 4, 2, 2, 7, 11, 6, 7, 3, 1, 1, 5, 5, 4, 4, 6, 6},
        [5] = { 2, 2, 2, 10, 8, 7, 7, 11, 11, 1, 7, 3, 5, 4, 13, 13, 4, 9, 9, 8, 13, 8, 2, 1, 6, 6, 3, 13, 3, 13, 4, 5, 2, 2, 9, 11, 7, 9, 4, 1, 1, 3, 3, 5, 5, 6, 6},
        [6] = { 2, 2, 2, 10, 9, 9, 7, 11, 11, 1, 7, 5, 4, 5, 13, 13, 5, 7, 7, 7, 13, 6, 2, 1, 8, 6, 4, 13, 4, 13, 3, 5, 2, 2, 6, 11, 9, 8, 4, 1, 1, 3, 3, 3, 3, 8, 8},
    },
    ["map_free_yang_reel"] = {
        [1] = { 2, 2, 2, 10, 9, 8, 8, 12, 12, 1, 8, 4, 4, 3, 12, 12, 3, 6, 6, 7, 12, 8, 2, 1, 7, 6, 5, 12, 5, 12, 3, 5, 2, 2, 7, 12, 9, 6, 4, 1, 1, 3, 3, 5, 5, 9, 9},
        [2] = { 2, 2, 2, 10, 6, 6, 7, 12, 12, 1, 7, 5, 4, 3, 12, 12, 3, 6, 6, 8, 12, 8, 2, 1, 9, 7, 3, 12, 3, 12, 3, 5, 2, 2, 8, 12, 9, 7, 5, 1, 1, 4, 4, 4, 4, 9, 9},
        [3] = { 2, 2, 2, 10, 6, 8, 7, 12, 12, 1, 7, 5, 3, 5, 12, 12, 5, 9, 9, 8, 12, 9, 2, 1, 9, 7, 4, 12, 4, 12, 3, 4, 2, 2, 6, 12, 8, 7, 4, 1, 1, 5, 5, 3, 3, 6, 6},
        [4] = { 2, 2, 2, 10, 6, 8, 9, 11, 11, 1, 9, 3, 5, 4, 13, 13, 4, 8, 8, 7, 13, 9, 2, 1, 9, 8, 5, 13, 5, 13, 3, 4, 2, 2, 7, 11, 6, 7, 3, 1, 1, 5, 5, 4, 4, 6, 6},
        [5] = { 2, 2, 2, 10, 8, 7, 7, 11, 11, 1, 7, 3, 5, 4, 13, 13, 4, 9, 9, 8, 13, 8, 2, 1, 6, 6, 3, 13, 3, 13, 4, 5, 2, 2, 9, 11, 7, 9, 4, 1, 1, 3, 3, 5, 5, 6, 6},
        [6] = { 2, 2, 2, 10, 9, 9, 7, 11, 11, 1, 7, 5, 4, 5, 13, 13, 5, 7, 7, 7, 13, 6, 2, 1, 8, 6, 4, 13, 4, 13, 3, 5, 2, 2, 6, 11, 9, 8, 4, 1, 1, 3, 3, 3, 3, 8, 8},
    },
    ["map_free_yin_reel"] = {
        [1] = { 2, 2, 2, 10, 9, 8, 8, 12, 12, 1, 8, 4, 4, 3, 14, 14, 3, 6, 6, 7, 14, 8, 2, 1, 7, 6, 5, 14, 5, 14, 3, 5, 2, 2, 7, 12, 9, 6, 4, 1, 1, 3, 3, 5, 5, 9, 9},
        [2] = { 2, 2, 2, 10, 6, 6, 7, 12, 12, 1, 7, 5, 4, 3, 14, 14, 3, 6, 6, 8, 14, 8, 2, 1, 9, 7, 3, 14, 3, 14, 3, 5, 2, 2, 8, 12, 9, 7, 5, 1, 1, 4, 4, 4, 4, 9, 9},
        [3] = { 2, 2, 2, 10, 6, 8, 7, 12, 12, 1, 7, 5, 3, 5, 14, 14, 5, 9, 9, 8, 14, 9, 2, 1, 9, 7, 4, 14, 4, 14, 3, 4, 2, 2, 6, 12, 8, 7, 4, 1, 1, 5, 5, 3, 3, 6, 6},
        [4] = { 2, 2, 2, 10, 6, 8, 9, 11, 11, 1, 9, 3, 5, 4, 11, 11, 4, 8, 8, 7, 11, 9, 2, 1, 9, 8, 5, 11, 5, 11, 3, 4, 2, 2, 7, 11, 6, 7, 3, 1, 1, 5, 5, 4, 4, 6, 6},
        [5] = { 2, 2, 2, 10, 8, 7, 7, 11, 11, 1, 7, 3, 5, 4, 11, 11, 4, 9, 9, 8, 11, 8, 2, 1, 6, 6, 3, 11, 3, 11, 4, 5, 2, 2, 9, 11, 7, 9, 4, 1, 1, 3, 3, 5, 5, 6, 6},
        [6] = { 2, 2, 2, 10, 9, 9, 7, 11, 11, 1, 7, 5, 4, 5, 11, 11, 5, 7, 7, 7, 11, 6, 2, 1, 8, 6, 4, 11, 4, 11, 3, 5, 2, 2, 6, 11, 9, 8, 4, 1, 1, 3, 3, 3, 3, 8, 8},
    },
    ["map_free_yin_yang_reel"] = {
        [1] = { 2, 2, 2, 10, 9, 8, 8, 12, 12, 1, 8, 4, 4, 3, 12, 12, 3, 6, 6, 7, 12, 8, 2, 1, 7, 6, 5, 12, 5, 12, 3, 5, 2, 2, 7, 12, 9, 6, 4, 1, 1, 3, 3, 5, 5, 9, 9},
        [2] = { 2, 2, 2, 10, 6, 6, 7, 12, 12, 1, 7, 5, 4, 3, 12, 12, 3, 6, 6, 8, 12, 8, 2, 1, 9, 7, 3, 12, 3, 12, 3, 5, 2, 2, 8, 12, 9, 7, 5, 1, 1, 4, 4, 4, 4, 9, 9},
        [3] = { 2, 2, 2, 10, 6, 8, 7, 12, 12, 1, 7, 5, 3, 5, 12, 12, 5, 9, 9, 8, 12, 9, 2, 1, 9, 7, 4, 12, 4, 12, 3, 4, 2, 2, 6, 12, 8, 7, 4, 1, 1, 5, 5, 3, 3, 6, 6},
        [4] = { 2, 2, 2, 10, 6, 8, 9, 11, 11, 1, 9, 3, 5, 4, 11, 11, 4, 8, 8, 7, 11, 9, 2, 1, 9, 8, 5, 11, 5, 11, 3, 4, 2, 2, 7, 11, 6, 7, 3, 1, 1, 5, 5, 4, 4, 6, 6},
        [5] = { 2, 2, 2, 10, 8, 7, 7, 11, 11, 1, 7, 3, 5, 4, 11, 11, 4, 9, 9, 8, 11, 8, 2, 1, 6, 6, 3, 11, 3, 11, 4, 5, 2, 2, 9, 11, 7, 9, 4, 1, 1, 3, 3, 5, 5, 6, 6},
        [6] = { 2, 2, 2, 10, 9, 9, 7, 11, 11, 1, 7, 5, 4, 5, 11, 11, 5, 7, 7, 7, 11, 6, 2, 1, 8, 6, 4, 11, 4, 11, 3, 5, 2, 2, 6, 11, 9, 8, 4, 1, 1, 3, 3, 3, 3, 8, 8},
    },
    ["scatter_reel"] = {
        [1] = { 2, 2, 2, 15, 10, 9, 8, 8, 12, 12, 1, 8, 4, 15, 4, 3, 14, 14, 3, 6, 6, 7, 14, 8, 2, 1, 7, 6, 5, 15, 5, 14, 3, 5, 2, 2, 7, 12, 9, 6, 4, 1, 1, 15, 3, 3, 5, 5, 9, 9},
        [2] = { 2, 2, 2, 15, 10, 6, 6, 7, 12, 12, 1, 7, 5, 15, 4, 3, 14, 14, 3, 6, 6, 8, 14, 8, 2, 1, 9, 7, 3, 15, 3, 14, 3, 5, 2, 2, 8, 12, 9, 7, 5, 1, 1, 15, 4, 4, 4, 4, 9, 9},
        [3] = { 2, 2, 2, 15, 10, 6, 8, 7, 12, 12, 1, 7, 5, 15, 3, 5, 14, 14, 5, 9, 9, 8, 14, 9, 2, 1, 9, 7, 4, 15, 4, 14, 3, 4, 2, 2, 6, 12, 8, 7, 4, 1, 1, 15, 5, 5, 3, 3, 6, 6},
        [4] = { 2, 2, 2, 15, 10, 6, 8, 9, 11, 11, 1, 9, 3, 15, 5, 4, 13, 13, 4, 8, 8, 7, 13, 9, 2, 1, 9, 8, 5, 15, 5, 13, 3, 4, 2, 2, 7, 11, 6, 7, 3, 1, 1, 15, 5, 5, 4, 4, 6, 6},
        [5] = { 2, 2, 2, 15, 10, 8, 7, 7, 11, 11, 1, 7, 3, 15, 5, 4, 13, 13, 4, 9, 9, 8, 13, 8, 2, 1, 6, 6, 3, 15, 3, 13, 4, 5, 2, 2, 9, 11, 7, 9, 4, 1, 1, 15, 3, 3, 5, 5, 6, 6},
        [6] = { 2, 2, 2, 15, 10, 9, 9, 7, 11, 11, 1, 7, 5, 15, 4, 5, 13, 13, 5, 7, 7, 7, 13, 6, 2, 1, 8, 6, 4, 15, 4, 13, 3, 5, 2, 2, 6, 11, 9, 8, 4, 1, 1, 15, 3, 3, 3, 3, 8, 8},
    },
}
config.pay_line = {
	pay_line_normal = {
        pay_lines = {
            {1, 1, 1, 1, 1, 1},{0, 0, 0, 0, 0, 0},{2, 2, 2, 2, 2, 2},{0, 1, 2, 2, 1, 0},{2, 1, 0, 0, 1, 2},
            {1, 0, 0, 0, 0, 1},{1, 2, 2, 2, 2, 1},{0, 0, 1, 1, 2, 2},{2, 2, 1, 1, 0, 0},{1, 2, 1, 1, 0, 1},
            {1, 0, 1, 1, 2, 1},{0, 1, 1, 1, 1, 0},{2, 1, 1, 1, 1, 2},{0, 1, 0, 0, 1, 0},{2, 1, 2, 2, 1, 2},
            {1, 1, 0, 0, 1, 1},{1, 1, 2, 2, 1, 1},{0, 0, 2, 2, 0, 0},{2, 2, 0, 0, 2, 2},{0, 2, 2, 2, 2, 0},
            {2, 0, 0, 0, 0, 2},{1, 2, 0, 0, 2, 1},{1, 0, 2, 2, 0, 1},{0, 2, 0, 0, 2, 0},{2, 0, 2, 2, 0, 2},
        },
        line_cnt = 25
    },
}
config.spinBoardType = {
    Normal    = 1,
    FreeSpin  = 2,
    BonusFree = 3,
}
config.unlockBetList = {
    Jackpot5 = 1, --mini
    Jackpot4 = 2, --minor
    Collect  = 3, --收集条
    Jackpot3 = 4, --major 
    Jackpot2 = 5, --major 
    Jackpot1 = 6, --grand
}
config.collectAnimation = {
    -- unlockLoop   = "animation1",
    unlock       = "animation3",
    lock         = "animation2",
    lockLoop     = "animation4",
}
config.collectData = {
    maxMapPoints = 400,
    progressStartPosX = 0,
    progressEndPosX = 938,
    progressPosY = 14,
    maxMapLevel = 100
}

config.jackpotViewConfig = {
	width        = { 256, 266, 276, 286, 298, 410},
    scale        = { 1, 1, 1, 1, 1, 1},
    count        = 5,
    -- name         = { "grand", "mega", "major", "minor", "mini"},
    jackpot_set = {0, 0, 1, 5, 10, 20, 50, 200, 1000}, -- rapidpay 的控制
    progressConfig = {
        normal = {
            scale = 1,
            pos = cc.p(0, 219.5),
        },
        gameMaster = {
            scale = 0.78,
            pos = cc.p(0, 192.5),
        }
    }
}
config.jackpotCtlConfig = {
    link_config = {"rapid9_yang", "rapid8_yang", "rapid7_yang", "rapid6_yang", "rapid5_yang", 
    "rapid9_yin", "rapid8_yin", "rapid7_yin", "rapid6_yin", "rapid5_yin", "rapid10"},--
    allowK = {[325] = false, [825] = false, [1325] = false},
}
config.transition_config = {
    free   = { ["onCover"] = 30 / 30, ["onEnd"] = 64 / 30,  ["spine"] = "free_tansition", ["animName"] = "animation" },
    wheel   = { ["onCover"] = 63 / 30, ["onEnd"] = 90 / 30,  ["spine"] = "wheel_tansition", ["animName"] = "animation" },
}
config.map_config = {
    map_booster_config = {4,9,12,18,22,25,32,36,41,45,49,54,57,63,67,70,77,81,86,90,94,100},
    map_building_config = {
        [4]  = {1,5,2},
        [9]  = {3,7,4,8},
        [12] = {6,5},
        [18] = {2,7,4,1,8},
        [22] = {3,6,2},
        [25] = {5,3},
        [32] = {6,7,4,1,8,3},
        [36] = {7,4,6},
        [41] = {5,2,1,8},
        [45] = {2,6,1},
        [49] = {7,3,8},
        [54] = {3,5,1,4},
        [57] = {5,8},
        [63] = {7,3,2,6,1},
        [67] = {5,2,3},
        [70] = {8,7},
        [77] = {6,4,8,2,3,7},
        [81] = {4,6,5},
        [86] = {1,3,2,5},
        [90] = {6,1,8},
        [94] = {4,7,1},
        [100] = {4,2,3,6,7},
    },
    map_building_user_pos = {
        [2] = 104,
        [3] = 118,
        [4] = 131,
        [5] = 136,
        [6] = 144,
    },
    map_wild_up = Set({9}), -- 两行向上偏移
    map_wild_down0 = Set({4,22,45,49,67,81,90,94}), -- 一行在中间位置
    map_wild_down = Set({18}), -- 两行向下偏移
    map_wild_down1 = Set({36}), -- 一行向下一整格
    map_wild_pos = { -- 额外增加的位置偏移
        up =  13,
        down0 =  0,
        down =  -13,
        down1 =  -26,
    },
    map_pos_config = {
        userStartPos  = cc.p(-392, -65),
        panelStartPos = cc.p(545, 275),
        panelHidePos  = cc.p(545, 640),
        contentSize = cc.size(924, 324),
        panelDisX = 924/2,
    },
    buildingLevel = 100,
    map_stype = {
        feature = 1, --未来
        current_start = 2, --开始播放当前的动画
        current_finish = 3, --播放循环的动画
        finish  = 4, -- 完成的状态
    },
    map_image = {
        small_image = {
            feature = "#theme325_map_sp3.png",
            finish  = "#theme325_map_sp1.png"
        },
        user_image  = "#theme325_map_sp2.png",
        booster_get_image = "#theme325_map_yes.png",
    },
    map_big_arr_anim = { -- booster_count : anim_name
        [2] = "animation5",
        [3] = "animation4",
        [4] = "animation3",
        [5] = "animation2",
        [6] = "animation1",
    }
}
config.map_pick_config = {
    pick_pos = {
        cc.p(-234, 59), cc.p(224, 59), 
        cc.p(-460, -108), cc.p(-5, -108), cc.p(450, -108)
    },

    -- pick_image = "#theme325_pick_%s.png",
    -- pick_ani
    
    pick_stick = "#theme325_pick_get2.png",
    pick_stick_num = "#theme325_pick_stick%s.png",
    pick_allwin_num = "#theme325_pick_allwin%s.png",
    pick_font = "font/theme325_pop_coins.fnt",
    pick_font_sca = 0.87,
    pick_pop_stick = "#theme325_popup_get2.png",
    pick_pop_stick_num = "#theme325_popup_stick%s.png",
    pick_pop_allwin_num = "#theme325_popup_allwin%s.png",
}

config.wheel_config = {
    w_multi_pos = {
        start_pos = cc.p(0, -375),
        end_pos   = cc.p(0, -26)
    },
    w_multi_info = {
        10, 2, 3, 4, 5, 6, 7, 8 
    },
    multi_speed_config = {
        itemCount = 8, -- 上下加一个 cell 之后的个数
        delayBeforeSpin = 0.0,   --开始旋转前的时间延迟
        upBounce = 0,    --开始滚动前，向上滚动距离
        upBounceTime = 0,   --开始滚动前，向上滚动时间
        speedUpTime = 1,   --加速时间
        rotateTime = 0.5,   -- 匀速转动的时间之和
        maxSpeed = 60*10,    --每一秒滚动的距离
        downBounce = 0,  --滚动结束前，向下反弹距离  都为正数值
        speedDownTime = 3, -- 4
        downBounceTime = 0,
        bounceSpeed = 0,
        direction = 1,
        endAngle = 0
    },
    w_multi_len = 8,
    w_super = Set({4, 7, 11, 14}),
    speed_config = {
        itemCount = 14, -- 上下加一个 cell 之后的个数
        delayBeforeSpin = 0.0,   --开始旋转前的时间延迟
        upBounce = 0,    --开始滚动前，向上滚动距离
        upBounceTime = 0,   --开始滚动前，向上滚动时间
        speedUpTime = 1,   --加速时间
        rotateTime = 0.5,   -- 匀速转动的时间之和
        maxSpeed = 60*10,    --每一秒滚动的距离
        downBounce = 0,  --滚动结束前，向下反弹距离  都为正数值
        speedDownTime = 3, -- 4
        downBounceTime = 0,
        bounceSpeed = 0,
        direction = 1,
        endAngle = 0
    },
    w_sun_info = {
        10020, 18000, 10016, 14100, 16000, 10012, 16100, 10015, 17000, 10010, 13100, 19000, 10015, 15100
    },
    w_moon_info = {
        10015, 18000, 10012, 17100, 14000, 10008, 16100, 10010, 14000, 10008, 18100, 19000, 10010, 15100
    },
    result_status = {
        free_game = 1,
        rapid_game = 2,
        rapid_super = 3,
    },
    -- %100 得到的数是fg次数
    -- %1000 得到的是否是super wheel
    -- %10000 得到的是n rapid
    fire_anim = {
        small_show = "animation3",
        small_loop = "animation4",
        small_to_big = "animation5",
        big_show = "animation1",
        big_loop = "animation2",
    }
}

config.dialog_config = {
    ["d_gm_start"] = {
        bg         = {
            name        = "gamem_dialog",
            startAction = { "animation1", false },
            loopAction  = { "animation2", true },
            endAction   = { "animation3", false },
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 19 / 30, 0 }, { 10 / 30, 1.35 }, { 5 / 30, 0.95 }, { 10 / 30, 1 } },
            stepEndScale = { { 1 }, { 3 / 30, 1 }, { 10 / 30, 0.93 }, { 5 / 30, 1.28}, { 5 / 30, 0} },
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation1",
        },
    },
    ["d_welcome"]     = {
        bg   = {
            name        = "gamem_dialog",
            startAction = { "animation4", false },
            loopAction  = { "animation5", true },
            endAction   = { "animation6", false },
        },
	},
    ["free_start"] = {
        bg         = {
            name        = "dialog_free",
            startAction = { "animation1_1", false },
            loopAction  = { "animation1_2", true },
            endAction   = { "animation1_3", false },
        },
        top         = {
            name        = "dialog_free_up",
            startAction = { "animation1_1", false },
        },
        gamemaster_icon = {
            name        = "gamem_icon",
            startAction = { "animation1", false },
            loopAction  = { "animation2", true },
            endAction   = { "animation3", false },
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 9 / 30, 0 }, { 8 / 30, 1.2 }, { 5 / 30, 1 } },
            stepEndScale = { { 1 }, { 6 / 30, 1 }, { 8 / 30, 1.2 }, { 7 / 30, 0 }},
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 15 / 30, 0 }, { 8 / 30, 1.2 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 0 / 30, 1 }, { 8 / 30, 1.2}, { 7 / 30, 0} },
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation1",
        },
    },
    ["free_more"] = {
        bg         = {
            name        = "dialog_free",
            startAction = { "animation2_1", false },
            loopAction  = { "animation2_2", true },
            endAction   = { "animation2_3", false },
        },
        top         = {
            name        = "dialog_free_up",
            startAction = { "animation1_1", false },
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 9 / 30, 0 }, { 8 / 30, 1.2 }, { 5 / 30, 1 } },
            stepEndScale = { { 1 }, { 6 / 30, 1 }, { 8 / 30, 1.2 }, { 7 / 30, 0 }},
        },
    },
    ["free_collect"] = {
        bg         = {
            name        = "dialog_free",
            startAction = { "animation3_1", false },
            loopAction  = { "animation3_2", true },
            endAction   = { "animation3_3", false },
        },
        top         = {
            name        = "dialog_free_up",
            startAction = { "animation1_1", false },
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 9 / 30, 0 }, { 8 / 30, 1.2 }, { 5 / 30, 1 } },
            stepEndScale = { { 1 }, { 3 / 30, 1 }, { 8 / 30, 1.2 }, { 7 / 30, 0 }},
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 12 / 30, 0 }, { 8 / 30, 1.2 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 0 / 30, 1 }, { 8 / 30, 1.2 }, { 7 / 30, 0} },
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation2",
        },
        maxWidth   = 640,
    },
    ["map_free_start"] = {
        bg         = {
            name        = "dialog_booster",
            startAction = { "animation3_1", false },
            loopAction  = { "animation3_2", true },
            endAction   = { "animation3_3", false },
        },
        top         = {
            name        = "dialog_booster_up",
            startAction = { "animation3_1", false },
        },
        gamemaster_icon = {
            name        = "gamem_icon",
            startAction = { "animation1", false },
            loopAction  = { "animation2", true },
            endAction   = { "animation3", false },
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 9 / 30, 0 }, { 8 / 30, 1.15 }, { 5 / 30, 1 } },

            stepEndFade  = { { 255 }, { 13 / 30, 255 }, { 3 / 30, 0 } },
            stepEndPos = { { cc.p(11, -46) }, { 3 / 30, cc.p(11, -46) }, { 5 / 30, cc.p(-1, -46) }, { 8 / 30, cc.p(760+11, -46) } }
        },
        booster_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 9 / 30, 0 }, { 8 / 30, 1.15 }, { 5 / 30, 1 } },

            stepEndFade  = { { 255 }, { 13 / 30, 255 }, { 3 / 30, 0 } },
            stepEndPos = { { cc.p(11, -46) }, { 3 / 30, cc.p(11, -46) }, { 5 / 30, cc.p(-1, -46) }, { 8 / 30, cc.p(760+11, -46) } }
        },
        btn_node   = {
            isAction     = true,
            stepFade     = { { 0 }, { 9 / 30, 0 }, { 3 / 30, 255 } },
            stepEndFade  = { { 255 }, { 10 / 30, 255 }, { 3 / 30, 0 } },

            stepPos 	 = { { cc.p(-800, -226) }, { 9 / 30 , cc.p(-800, -226) }, { 9 / 30, cc.p(20, -226) }, { 5 / 30, cc.p( 0, -226 ) } },
			stepEndPos   = { { cc.p(0, -226) }, { 5 / 30 , cc.p(-12, -226) }, { 8 / 30, cc.p(790, -226) } },
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation1",
        },
    },
    ["map_free_collect"] = {
        bg         = {
            name        = "dialog_booster",
            startAction = { "animation1_1", false },
            loopAction  = { "animation1_2", true },
            endAction   = { "animation1_3", false },
        },
        top         = {
            name        = "dialog_booster_up",
            startAction = { "animation1_1", false },
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 9 / 30, 0 }, { 8 / 30, 1.15 }, { 5 / 30, 1 } },

            stepEndFade  = { { 255 }, { 13 / 30, 255 }, { 3 / 30, 0 } },
            stepEndPos = { { cc.p(0.5, -19) }, { 3 / 30, cc.p(0.5, -19) }, { 5 / 30, cc.p(0.5-15, -19) }, { 8 / 30, cc.p(0.5+835, -19) } }
        },
        btn_node   = {
            isAction     = true,
            stepFade     = { { 0 }, { 12 / 30, 0 }, { 3 / 30, 255 } },
            stepEndFade  = { { 255 }, { 10 / 30, 255 }, { 3 / 30, 0 } },

            stepPos 	 = { { cc.p(-907, -181) }, { 12 / 30 , cc.p(-907, -181) }, { 9 / 30, cc.p(35, -181) }, { 5 / 30, cc.p( 0, -181 ) } },
			stepEndPos   = { { cc.p(0, -181) }, { 5 / 30 , cc.p(-15, -181) }, { 8 / 30, cc.p(835, -181) } },
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation2",
        },
        maxWidth   = 660,
    },
    ["wheel_collect"] = {
        bg         = {
            name        = "dialog_jackpot",
            startAction = { "animation%s_1", false },
            loopAction  = { "animation%s_2", true },
            endAction   = { "animation%s_3", false },
            formatname  = true,
        },
        top         = {
            name        = "dialog_jackpot_up",
            startAction = { "animation%s_1", false },
            formatname  = true,
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 0 / 30, 0 }, { 8 / 30, 1.2 }, { 5 / 30, 0.9 }, { 5 / 30, 1 } },
            stepEndScale = { { 1 }, { 6 / 30, 1 }, { 5 / 30, 0.9 }, { 5 / 30, 1.2 }, { 5 / 30, 0 }},
        },
        multi_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 6 / 30, 0 }, { 8 / 30, 1.2 }, { 5 / 30, 0.9 }, { 5 / 30, 1 } },
        },
        rapid_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 6 / 30, 0 }, { 8 / 30, 1.2 }, { 5 / 30, 0.9 }, { 5 / 30, 1 } },
            stepEndScale = { { 1 }, { 0 / 30, 1 }, { 5 / 30, 0.9 }, { 5 / 30, 1.2 }, { 8 / 30, 0 }},
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 19 / 30, 0 }, { 10 / 30, 1.35 }, { 5 / 30, 0.95 }, { 10 / 30, 1 } },
            stepEndScale = { { 1 }, { 3 / 30, 1 }, { 10 / 30, 0.93 }, { 5 / 30, 1.28}, { 5 / 30, 0} },
        },
        btn        = {
            name = "dialog_btn",
            aniName = "animation2",
        },
        maxWidth   = 660,
    },
    ["pick_booster"] = {
        bg         = {
            name        = "dialog_booster",
            startAction = { "animation2_1", false },
            loopAction  = { "animation2_2", true },
            endAction   = { "animation2_3", false },
        },
        top         = {
            name        = "dialog_booster_up",
            startAction  = { "animation2_1", false },
        },
        booster_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 9 / 30, 0 }, { 8 / 30, 1.15 }, { 5 / 30, 1 } },

            stepEndFade  = { { 255 }, { 16 / 30, 255 }, { 3 / 30, 0 } },
            stepEndPos = { { cc.p(0, 5) }, { 6 / 30, cc.p(0, 5) }, { 5 / 30, cc.p(15, 5) }, { 8 / 30, cc.p(835, 5) } }
        },
        btn_node   = {
            isAction     = true,
            stepFade     = { { 0 }, { 12 / 30, 0 }, { 3 / 30, 255 } },
            stepEndFade  = { { 255 }, { 10 / 30, 255 }, { 3 / 30, 0 } },
            
            stepPos 	 = { { cc.p(-849, -232.5) }, { 12 / 30 , cc.p(-849, -232.5) }, { 9 / 30, cc.p(13.6, -232.5) }, { 5 / 30, cc.p( 0, -232.5 ) } },
			stepEndPos   = { { cc.p(0, -232.5) }, { 5 / 30 , cc.p(-15, -232.5) }, { 8 / 30, cc.p(790, -232.5) } },
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation2",
        },
    },
    ["pick_collect"] = {
        bg         = {
            name        = "dialog_booster",
            startAction = { "animation1_1", false },
            loopAction  = { "animation1_2", true },
            endAction   = { "animation1_3", false },
        },
        top         = {
            name        = "dialog_booster_up",
            startAction  = { "animation1_1", false },
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 9 / 30, 0 }, { 8 / 30, 1.15 }, { 5 / 30, 1 } },

            stepEndFade  = { { 255 }, { 13 / 30, 255 }, { 3 / 30, 0 } },
            stepEndPos = { { cc.p(0.5, -19) }, { 3 / 30, cc.p(0.5, -19) }, { 5 / 30, cc.p(0.5-15, -19) }, { 8 / 30, cc.p(0.5+835, -19) } }
        },
        btn_node   = {
            isAction     = true,
            stepFade     = { { 0 }, { 9 / 30, 0 }, { 3 / 30, 255 } },
            stepEndFade  = { { 255 }, { 10 / 30, 255 }, { 3 / 30, 0 } },

            stepPos 	 = { { cc.p(-907, -181) }, { 9 / 30 , cc.p(-907, -181) }, { 9 / 30, cc.p(35, -181) }, { 5 / 30, cc.p( 0, -181 ) } },
			stepEndPos   = { { cc.p(0, -181) }, { 5 / 30 , cc.p(-15, -181) }, { 8 / 30, cc.p(835, -181) } },
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation2",
        },
        maxWidth   = 660,
    },
    ["wheel_quick_collect"] = { -- count < 5
        bg         = {
            name        = "dialog_jackpot",
            startAction = { "animation%s_4", false },
            loopAction  = { "animation%s_5", true },
            endAction   = { "animation%s_6", false },
            formatname  = true,
        },
        top         = {
            name        = "dialog_jackpot_up",
            startAction = { "animation%s_1", false },
            formatname  = true,
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 0 / 30, 0 }, { 8 / 30, 1.2 }, { 5 / 30, 0.9 }, { 5 / 30, 1 } },
            stepEndScale = { { 1 }, { 6 / 30, 1 }, { 5 / 30, 0.9 }, { 5 / 30, 1.2 }, { 5 / 30, 0 }},
        },
        multi_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 6 / 30, 0 }, { 8 / 30, 1.2 }, { 5 / 30, 0.9 }, { 5 / 30, 1 } },
        },
        rapid_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 6 / 30, 0 }, { 8 / 30, 1.2 }, { 5 / 30, 0.9 }, { 5 / 30, 1 } },
            stepEndScale = { { 1 }, { 0 / 30, 1 }, { 5 / 30, 0.9 }, { 5 / 30, 1.2 }, { 8 / 30, 0 }},
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 19 / 30, 0 }, { 10 / 30, 1.35 }, { 5 / 30, 0.95 }, { 10 / 30, 1 } },
            stepEndScale = { { 1 }, { 3 / 30, 1 }, { 10 / 30, 0.93 }, { 5 / 30, 1.28}, { 5 / 30, 0} },
        },
        btn        = {
            name = "dialog_btn",
            aniName = "animation2",
        },
        maxWidth   = 660,
    },
    ["lock_jp_collect"] = {
        bg         = {
            name        = "dialog_lock_jackpot",
            startAction = { "animation1", false },
            loopAction  = { "animation2", true },
            endAction   = { "animation3", false },
        },
        top         = {
            name        = "dialog_jackpot_up",
            startAction = { "animation1_1", false },
            formatname  = true,
        },
        label_node = {
            isAction     = true,
            startPos = cc.p(0, -22),
            stepScale    = { { 0 }, { 0 / 30, 0 }, { 8 / 30, 1.2 }, { 5 / 30, 0.9 }, { 5 / 30, 1 } },
            stepEndScale = { { 1 }, { 6 / 30, 1 }, { 5 / 30, 0.9 }, { 5 / 30, 1.2 }, { 5 / 30, 0 }},
        },
        multi_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 6 / 30, 0 }, { 8 / 30, 1.2 }, { 5 / 30, 0.9 }, { 5 / 30, 1 } },
        },
        rapid_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 6 / 30, 0 }, { 8 / 30, 1.2 }, { 5 / 30, 0.9 }, { 5 / 30, 1 } },
            stepEndScale = { { 1 }, { 0 / 30, 1 }, { 5 / 30, 0.9 }, { 5 / 30, 1.2 }, { 8 / 30, 0 }},
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 19 / 30, 0 }, { 10 / 30, 1.35 }, { 5 / 30, 0.95 }, { 10 / 30, 1 } },
            stepEndScale = { { 1 }, { 3 / 30, 1 }, { 10 / 30, 0.93 }, { 5 / 30, 1.28}, { 5 / 30, 0} },
        },
        btn        = {
            name = "dialog_btn",
            aniName = "animation2",
        },
        maxWidth   = 660,
    },
    ["black_common"] = {
        stepFade     = { { 0 },  { 8 / 30, 200 } },
        stepEndFade  = { { 200 }, { 15 / 30, 200 }, { 8 / 30, 0 } },
    },
}
config.dialog_jp_pos = {
    small = {rapid_node = cc.p(46, 71), label_node = cc.p(0, -31)},
    jp = {rapid_node = cc.p(-117, 71), label_node = cc.p(0, -31)},
    jp_lock = {
        rapid_node = cc.p(-110, 79), 
        label_node = cc.p(0, -23),
        multi = {
            [9] = 1000,
            [8] = 200,
            [7] = 50,
            [6] = 20,
            [5] = 10,
            [10] = 2000,
        }
    },
}

config.spine_path = {
    logo_label = "base/logo/325_logo",
    -- collect
    collect_lock = "collect/collect_lock/jdt",
    collect_full = "collect/collect_lock/jdt_qz",
    collect_left = "collect/collect_left/tubiao",
    collect_right = "collect/collect_right/jdt_juan",
    collect_add  = "collect/collect_add/jdt_z",
    collect_m1   = "collect/collect_add/m1_shouji",

    -- jp
    jackpot_lock = "collect/jackpot_lock/jp_js",
    -- jackpot_loop = "collect/jackpot_lock/jp_js",
    jackpot_award = "collect/jackpot_award/jp_zj",
    -- jackpot_loop = "collect/",

    -- base
    zhongjiang  = "base/kuang/spine",
    bg_touch = "base/bg/dj",
    -- bg 循环
    bg_loop1 = "base/bg/bj_xh",
    bg_loop2 = "base/bg/bj_xh02",
    -- bg 装饰
    bg_dec_loop1 = "base/bg/zhiwu_base",
    bg_dec_loop2 = "base/bg/zhiwu_freemoon",
    bg_dec_loop3 = "base/bg/zhiwu_freesun",
    bg_jp_loop = "base/bg/jp_xh",
    -- reel
    reel_loop1 = "base/reel/qp_basexh",
    reel_loop2 = "base/reel/qp_freexh",
    reel_anti = "base/reel/qp_qz",
    -- payout
    payout_footer_win = "payout/jieshou",
    payout_footer_loop = "payout/xunhuan",
    payout_footer_open = "payout/jihuo",

    -- symbol 
    scatter_tail = "item/15/scatter_tuowei_01",

    -- map
    map_user = "map/user/map_ui",
    map_small = "map/build_small/map_xiao",
    map_big = "map/build_big/map_da",
    map_loop = "map/loop/map_xunhuan",
    map_small_loop = "map/loop/map_xiaojiedian",
    
    wild_anticipate = "item/1/spine",
    wild_expend = "item/1/spine",

    -- pick 
    pick_board = "pick/pick_lv_01",
    

    -- wheel 
    wheel_choose = "wheel/choose/pick_xz_01",
    wheel_bg = "wheel/bg/tz_01",
    wheel_bg2 = "wheel/bg/325_tz_fire",
    wheel_point = "wheel/point/zp_ze_01",
    wheel_spin_idle = "wheel/spin_idle/zp_ddj_01",
    wheel_spin_click = "wheel/spin_click/zp_dj_01",
    wheel_idle = "wheel/loop/zp_lg_01",
    wheel_mul_award = "wheel/multi_award/zp_zj_01",
    wheel_mul_spin_idle = "wheel/multi_idle/325_super_zhuan",


    --激励
    jili_15 = "base/jili/jl1",
    jili_14 = "base/jili/jl2",
    jili_13 = "base/jili/jl2",
    jili_board = "transition/banpingjili",

    -- dialog
    dialog_btn = "dialog/common/325_popup_anniu",
    dialog_free = "dialog/free/free",
    dialog_free_up = "dialog/free/free01",
    dialog_jackpot = "dialog/jackpot/bonus",
    dialog_lock_jackpot = "dialog/jackpot/jpsszj",
    dialog_jackpot_up = "dialog/jackpot/bonus01",
    dialog_jackpot_multi = "dialog/jackpot/325_popup_bx",
    dialog_booster = "dialog/map_free/jiedian",
    dialog_booster_up = "dialog/map_free/jiedian01",

    -- gameMaster
    gamem_dialog = "gamemaster/dialog/325_popup_gm",
    gamem_icon = "gamemaster/dialog/free_gm",
    gamem_jp_loop = "gamemaster/jp/jp_k_02",
    gamem_jackpot_award = "gamemaster/jp/jp_k_01",
    -- gamem_star_loop = "gamemaster/jp/jp_k_03",

    --trasition
    free_tansition = "transition/qiziqieping",
    wheel_tansition = "transition/325_qieping",
}

config.audioList = {
    common_click = "audio/base/click.mp3",
    trigger_bell = "audio/base/bell.mp3",
    popup_out    = "audio/base/popup_out.mp3",
    
    --bgm
    base_background = "audio/bgm/base_bgm.mp3",
    wheel_background = "audio/bgm/wheel_bgm.mp3",
    free_background = "audio/bgm/free_bgm.mp3",
    mapfree_background = "audio/bgm/mapfree_bgm.mp3",

    -- rollup
    rollup01      = "audio/base/win1.mp3",
    rollup01_end  = "audio/base/win1end.mp3",
    rollup02      = "audio/base/win2.mp3",
    rollup02_end  = "audio/base/win2end.mp3",
    rollup03      = "audio/base/win3.mp3",
    rollup03_end  = "audio/base/win3end.mp3",
    rollup04      = "audio/base/win4.mp3",
    rollup04_end  = "audio/base/win4end.mp3",

    -- collect
    jp_lock   = "audio/base/jp_lock.mp3",
    jp_unlock = "audio/base/jp_unlock.mp3",
    collect_fly = "audio/base/collect_fly.mp3",
    collect_full = "audio/base/collect_full.mp3",
    collect_lock = "audio/base/collect_lock.mp3",
    collect_unlock = "audio/base/collect_unlock.mp3",
    
    -- base
    bg_click = "audio/base/bg_click.mp3",
    reel_stop = "audio/base/reel_stop.mp3",
    board_notify = "audio/base/notify.mp3",
    reel_notify = "audio/base/reel_notify.mp3",
    reel_notify1 = "audio/base/reel_notify2.mp3",
    base_welcome = "audio/base/welcome.mp3",
    symbol_scatter = "audio/base/symbol_scatter.mp3",
    symbol_bonus = "audio/base/symbol_bonus.mp3",
    sharke_jili = "audio/base/shake.mp3",
    -- scatter_tail = "audio/base/scattertail.mp3",
    -- free_pick  = "audio/base/pick.mp3", -- freePick的点击，选择日还是月的情况

    -- map 
    map_open     = "audio/base/map_open.mp3",
    map_close    = "audio/base/map_close.mp3",
    map_user     = "audio/map/pass1.mp3",
    map_small    = "audio/map/pass2.mp3",
    map_big      = "audio/map/pass3.mp3",
    map_wild_add = "audio/map/wild_add.mp3",
    map_pick     = "audio/map/pick.mp3",
    map_pick_flip= "audio/map/option3.mp3",
    map_pick_wildmoving= "audio/map/wildmoving.mp3",

    -- wheel 
    wheel_up      = "audio/wheel/wheel_up.mp3",
    wheel_roll      = "audio/wheel/wheel_roll.mp3",
    wheel_mul_roll  = "audio/wheel/wheel_roll2.mp3",
    wheel_click     = "audio/wheel/wheel_click.mp3",
    wheel_option    = "audio/wheel/option.mp3",
    wheel_mul_option = "audio/wheel/option2.mp3",
    wheel_dialog_double = "audio/wheel/allwins_X.mp3",
    wheel_feature_choose = "audio/wheel/feature_choose.mp3",

    -- dialog
    dialog_pick_collect = "audio/dialog/mapfree_dialog_collect_show.mp3",
    dialog_pick_booster = "audio/dialog/mapfree_dialog_collect_show.mp3",

    dialog_wheel_collect = "audio/dialog/bonus_collect_show.mp3",
    dialog_wheel_start   = "audio/dialog/wheel_start_show.mp3",
    mapfree_dialog_start_show = "audio/dialog/mapfree_dialog_start_show.mp3",
    mapfree_dialog_collect_show = "audio/dialog/mapfree_dialog_collect_show.mp3",
    
    free_dialog_start_show  = "audio/dialog/free_dialog_start_show.mp3",
    free_dialog_start_close = "audio/base/popup_out.mp3",
    free_dialog_more_show   = "audio/dialog/free_dialog_more_show.mp3",
    free_dialog_more_close  = "audio/base/popup_out.mp3",
    free_dialog_collect_show  = "audio/dialog/free_dialog_collect_show.mp3",
    free_dialog_collect_click = "audio/base/click.mp3",
    free_dialog_collect_close = "audio/base/popup_out.mp3",   

    -- transition
    transition_free = "audio/base/transition_free.mp3", 
    transition_wheel = "audio/base/transition_map.mp3", 
    transition_wheel1 = "audio/base/transition_wheel.mp3", 

    d_gm_start_in = "audio/base/popup_out.mp3",
	d_gm_start_out = "audio/base/popup_out.mp3",

    reel_stop        		= "audio/base/reel_stop.mp3",
    trigger_bell	 		= "audio/base/bell.mp3",
    symbol_scatter   		= "audio/base/symbol_scatter.mp3",
    reel_notify		 		= "audio/base/reel_notify.mp3",
    transition_free 		= "audio/base/transition_free.mp3",
    rollup01		 		= "audio/base/win1.mp3",
    rollup01_end	 		= "audio/base/win1end.mp3",
    rollup02		 		= "audio/base/win2.mp3",
    rollup02_end	 		= "audio/base/win2end.mp3",
    rollup03		 		= "audio/base/win3.mp3",
    rollup03_end	 		= "audio/base/win3end.mp3",
    rollup04		 		= "audio/base/win4.mp3",
    rollup04_end	 		= "audio/base/win4end.mp3",
    common_click 			= "audio/base/click.mp3",

}

config.peopel_rollup_list = {
	peopelrollup01 = "theme_resource/theme325/audio/win/big_win.mp3",
	peopelrollup02 = "theme_resource/theme325/audio/win/huge_win.mp3",
	peopelrollup03 = "theme_resource/theme325/audio/win/massive_win.mp3",
	peopelrollup04 = "theme_resource/theme325/audio/win/apocalyptic_win.mp3",
}

config.pay_muti = {
    ["1"] = {"6 - 50000", "5 - 25000", "4 - 10000", "3 - 2500"},
	["2"] = {"6 - 30000", "5 - 15000", "4 - 5000",  "3 - 1500"},
	["3"] = {"6 - 25000", "5 - 12000", "4 - 4000",  "3 - 1000"},
    ["4"] = {"6 - 20000", "5 - 10000", "4 - 3000",  "3 - 1000"},
    ["5"] = {"6 - 5000",  "5 - 3000",  "4 - 800",  "3 - 200"},
	["6"] = {"6 - 10000",  "5 - 5000", "4 - 1200",  "3 - 200"},
	["7"] = {"6 - 10000",  "5 - 5000", "4 - 1200",  "3 - 200"},
	["8"] = {"6 - 10000",  "5 - 5000", "4 - 1200",  "3 - 200"},
	["9"] = {"6 - 10000",  "5 - 5000", "4 - 1200",  "3 - 200"},
}

config.all_img_path = {
    {1, "font/theme325_booster_count.png" },
	{1, "font/theme325_fg_count.png" },
	{1, "font/theme325_jp_left.png" },
	{1, "font/theme325_jp_middle.png" },
	{1, "font/theme325_jp_right.png" },
	{1, "font/theme325_jp_tip_count.png" },
	{1, "font/theme325_map_room.png" },
	{1, "font/theme325_moon_count.png" },
	{1, "font/theme325_pop_coins.png" },
	{1, "font/theme325_sum_count.png" },
	{1, "font/theme325_sun_new.png" },
	{1, "font/theme325_wheel_multi.png" },
	{1, "image/bg/theme325_bg_base.png" },
	{1, "image/bg/theme325_bg_free.png" },
	{1, "image/bg/theme325_bg_map1.png" },
	{1, "image/bg/theme325_bg_map2.png" },
	{1, "image/bg/theme325_bg_map3.png" },
	{1, "image/bg/theme325_bg_map4.png" },
	{1, "image/bg/theme325_bg_map5.png" },
	{1, "image/bg/theme325_bg_map6.png" },
	{1, "image/bg/theme325_bg_mapfree.png" },
	{1, "image/bg/theme325_bg_pick.png" },
	{1, "image/paytable/paytable.png" },
	{1, "image/plist/base.png" },
	{1, "image/plist/game_master.png" },
	{1, "image/plist/map.png" },
	{1, "image/plist/map_pop.png" },
	{1, "image/plist/pick.png" },
	{1, "image/plist/symbol.png" },
	{1, "image/plist/wheel.png" },
	{1, "spine/base/bg/bj_xh.png" },
	{1, "spine/base/bg/bj_xh02.png" },
	{1, "spine/base/bg/dj.png" },
	{1, "spine/base/bg/jp_xh.png" },
	{1, "spine/base/bg/zhiwu_base.png" },
	{1, "spine/base/bg/zhiwu_freemoon.png" },
	{1, "spine/base/bg/zhiwu_freesun.png" },
	{1, "spine/base/jili/jl1.png" },
	{1, "spine/base/jili/jl2.png" },
	{1, "spine/base/kuang/lx.png" },
	{1, "spine/base/logo/325_logo.png" },
	{1, "spine/base/reel/qp_basexh.png" },
	{1, "spine/base/reel/qp_freexh.png" },
	{1, "spine/base/reel/qp_qz.png" },
	{1, "spine/collect/collect_add/jdt_z.png" },
	{1, "spine/collect/collect_add/m1_shouji.png" },
	{1, "spine/collect/collect_left/tubiao.png" },
	{1, "spine/collect/collect_lock/jdt.png" },
	{1, "spine/collect/collect_lock/jdt_qz.png" },
	{1, "spine/collect/collect_right/jdt_juan.png" },
	{1, "spine/collect/jackpot_award/jp_xh1.png" },
	{1, "spine/collect/jackpot_award/jp_zj.png" },
	{1, "spine/collect/jackpot_lock/jp_js.png" },
	{1, "spine/dialog/common/325_popup_anniu.png" },
	{1, "spine/dialog/free/free.png" },
	{1, "spine/dialog/free/free01.png" },
	{1, "spine/dialog/jackpot/325_popup_bx.png" },
	{1, "spine/dialog/jackpot/bonus.png" },
	{1, "spine/dialog/jackpot/bonus01.png" },
	{1, "spine/dialog/jackpot/jpsszj.png" },
	{1, "spine/dialog/map_free/jiedian.png" },
	{1, "spine/dialog/map_free/jiedian01.png" },
	{1, "spine/dialog/paytable/dantu/CX_saoguang01.png" },
	{1, "spine/dialog/paytable/dantu/elephant_gl01.png" },
	{1, "spine/dialog/paytable/spine/back_to_game01.png" },
	{1, "spine/dialog/welcome/325_popup_gm.png" },
	{1, "spine/gamemaster/dialog/325_popup_gm.png" },
	{1, "spine/gamemaster/dialog/free_gm.png" },
	{1, "spine/gamemaster/jp/jp_k_01.png" },
	{1, "spine/gamemaster/jp/jp_k_02.png" },
	{1, "spine/item/1/wild.png" },
	{1, "spine/item/10/bonus3.png" },
	{1, "spine/item/11/bonus5.png" },
	{1, "spine/item/12/bonus4.png" },
	{1, "spine/item/13/bonus2.png" },
	{1, "spine/item/14/bonus1.png" },
	{1, "spine/item/15/scatter_01.png" },
	{1, "spine/item/15/scatter_tuowei_01.png" },
	{1, "spine/item/2/m1.png" },
	{1, "spine/item/3/m2.png" },
	{1, "spine/item/6/l1.png" },
	{1, "spine/item/7/l2.png" },
	{1, "spine/item/8/l3.png" },
	{1, "spine/item/9/l4.png" },
	{1, "spine/map/build_big/map_da.png" },
	{1, "spine/map/build_small/map_xiao.png" },
	{1, "spine/map/loop/map_xiaojiedian.png" },
	{1, "spine/map/loop/map_xunhuan.png" },
	{1, "spine/map/user/map_ui.png" },
	{1, "spine/paytable/spine/back_to_game01.png" },
	{1, "spine/pick/pick_lv_01.png" },
	{1, "spine/transition/325_qieping.png" },
	{1, "spine/transition/banpingjili.png" },
	{1, "spine/transition/qiziqieping.png" },
	{1, "spine/wheel/bg/325_tz_fire.png" },
	{1, "spine/wheel/bg/tz_01.png" },
	{1, "spine/wheel/choose/pick_xz_01.png" },
	{1, "spine/wheel/loop/zp_lg_01.png" },
	{1, "spine/wheel/multi_award/zp_zj_01.png" },
	{1, "spine/wheel/multi_idle/325_super_zhuan.png" },
	{1, "spine/wheel/point/zp_ze_01.png" },
	{1, "spine/wheel/spin_click/zp_dj_01.png" },
	{1, "spine/wheel/spin_idle/zp_ddj_01.png" },
}

config.badge_config =
{
    [1] =
    {
        name1      = "ADVENTUROUS",
        name2      = "DAWN",
        icon_path  = "#theme325_s_9",
        icon_scale = 0.5 * 1.5,
        des_func   = function (target) -- Play all 4 kinds of Free Games
            local text1
            local text2
            if target then
                text1 = "WIN A RAPID PAY JACKPOT"
            end
            return text1, text2
        end,
    },
    [2] =
    {
        name1      = "BRIGHTEST",
        name2      = "STAR",
        icon_path  = "#theme325_s_8",
        icon_scale = 0.5 * 1.25,
        des_func   = function (target) -- Trigger LEMUR'S GIFT 100 times
            local text1
            local text2
            if target then
                text1 = "WIN A RAPID PAY JACKPOT WITH"
                text2 = "DOUBLE RAPID PAY SYMBOL "..target.." TIMES"
            end
            return text1, text2
        end,
    },
    [3] =
    {
        name1      = "ANCIENT",
        name2      = "RITUAL",
        icon_path  = "#theme325_s_7",
        icon_scale = 0.5 * 0.9,
        des_func   = function (target)
            local text1
            local text2
            if target then
                text1 = "WIN 6 OF A KIND "..target.." TIMES"
            end
            return text1, text2
        end,
    },
    [4] =
    {
        name1      = "RAPID",
        name2      = "FRENZY",
        icon_path  = "#theme325_s_6",
        icon_scale =  0.5 * 0.9,
        des_func   = function (target) -- Gain 25000 * bet coins
            local text1
            local text2
            if target then
                text1 = "GET 5 DIFFERENT RAPID SYMBOLS"
                text2 = "IN A SPIN "..target.." TIMES"
            end
            return text1, text2
        end,
    },
    [5] =
    {
        name1      = "WIN-WIN",
        -- name2      = "",
        icon_path  = "#theme325_s_2",
        icon_scale = 0.5 * 0.67,
        des_func   = function (target)
            local text1
            local text2
            if target then
                text1 = "WIN RAPID SUN JACKPOT AND"
                text2 = "RAPID MOON JACKPOT TOGETHER IN A SPIN "..target.." TIMES"
            end
            return text1, text2
        end,
    },
    [6] =
    {
        name1      = "EGYPTIAN",
        name2      = "TREASURES",
        icon_path  = "#theme325_s_15",
        icon_scale = 0.5 * 0.7,
        des_func   = function (target)
            local text1
            local text2
            if target then
                text1 = "WIN A 10X IN SUPER WHEEL"
            end
            return text1, text2
        end,
    },
}

-- config.share_link                 = {
--     ["grand"] = { "1234909977301038" },
--     ["other"] = { "1234909977301038", "1234909977301038" }
-- }

config.FeatureName = { -- unlock相关, feature 状态控制
	Bonus = 1,
	Free = 2,
    OpenMap = 3,
}

config.payout_footer_img = {
    [325] = "#theme325_payout_img02.png",
    [825] = "#theme325_payout_img01.png",
}

return config



