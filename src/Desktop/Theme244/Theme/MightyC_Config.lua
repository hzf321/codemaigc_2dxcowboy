-- @Author: xiongmeng
-- @Date:   2020-11-10 11:28:10
-- @Last Modified by:   xiongmeng
-- @Last Modified time: 2020-12-03 11:45:57
local config = {}
local G_CELL_HEIGHT = 139
local G_CELL_WIDTH = 176
config.G_CELL_HEIGHT = G_CELL_HEIGHT
config.G_CELL_WIDTH  = G_CELL_WIDTH

config.SpinBoardType = {
    Normal = 1,
    FreeSpin = 2,
    Respin = 3,
    SuperRespin = 4,
}
config.SpinLayerType = {
    Normal   = 1,
    FreeSpin = 1,
    Respin = 2,
    SuperRespin = 2,
}
config.ReSpinStep = {
    OFF = 1,
    Start = 2,
    Reset = 3,
    Over = 4,
    Playing = 5, 
}
config.fs_show_type = {
    start = 1,
    more = 2,
    collect = 3,
}
config.baseColCnt = 5
config.special_symbol = {
    scatter = 14,
    bonus1 = 12,
    bonus2 = 13,
    wild = 1,
}
config.bonus_coin = {
    [120]=0.1,
    [121]=0.2,
    [122]=0.5,
    [123]=1,
    [124]=1.5,
    [125]=2,
    [126]=2.5,
    [127]=3,
    [128]=5,
    [129]=10,

    [130]=10, 
    [131]=25,
    [132]=100,
    [133]=500,
    [134]=1000,

    [220]=0.1,
    [221]=0.2,
    [222]=0.5,
    [223]=1,
    [224]=1.5,
    [225]=2,
    [226]=2.5,
    [227]=3,
    [228]=5,
    [229]=10,

    [230]=10, -- mini
    [231]=25, -- minor
    [232]=100, -- 
    [233]=500,
    [234]=1000,
}
config.enterGameList = {
    {{2, 2, 2}, {1, 1, 1}, {130, 134, 131}, {1, 1, 1}, {2, 2, 2}},
    {{2, 2, 2}, {2, 14, 2}, {129, 234, 129}, {2, 14, 2}, {2, 2, 2}},
    {{3, 3, 3}, {2, 2, 2}, {2, 2, 2}, {2, 2, 2}, {3, 3, 3}},
    {{4, 4, 4}, {2, 2, 2}, {2, 2, 2}, {2, 2, 2}, {4, 4, 4}},
    {{1, 1, 1}, {130, 14, 130}, {2, 2, 2}, {130, 14, 130}, {1, 1, 1}}
}

config.symbol_config = {
    ["scatter_key_list"] = {config.special_symbol.scatter},
    ["not_init_symbol_set"] = Set({
        config.special_symbol.scatter}),
    ["notify_symbol_list"] = Set({
        config.special_symbol.scatter, -- scatter
    }),
    ["loop_symbol_list"] = Set({
        config.special_symbol.scatter, -- scatter
    }),
    ["low_symbol_list"] = Set({
        7,8,9,10,11
    }),
    ["major_symbol_list"] = {2,3,4,5,6},
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
    underPressure = true,
}

config.reel_spin_config = {
	["delay"] = 0,
    ["upBounce"] = G_CELL_HEIGHT * 2 / 3,
    ["upBounceFree"] = G_CELL_HEIGHT * 5 / 6,
	["upBounceMaxSpeed"] = 6 * 60,
	["upBounceTime"] = 0,
	["speedUpTime"] = 5 / 60,
	["rotateTime"] = 5 / 60,
	["maxSpeed"] = -30 * 60, -- -30 * 60,
    ["maxFreeSpeed"] = -20 * 60, -- -30 * 60,
	["downBounceMaxSpeed"] = 10 * 60,-- 6 * 60,
	["extraReelTime"] = 120 / 60,
	["spinMinCD"] = 0.5,
	["speedDownTime"] =  50 / 60, -- 45 / 60,
	["downBounce"] = G_CELL_HEIGHT*1/5, -- 对应 普通停止在symbol + 1 
	["downBounceTime"] = 10 / 60,-- 20/60,
	["autoDownBounceTimeMult"] = 1,
	["checkStopColCnt"] = 5,
	["stopDelay"] = 10 / 60, -- 20/60,
	["stopDelayList"] = {
	    [1] = 30 / 60,
	    [2] = 25 / 60,
	    [3] = 20 / 60,
    },
	["autoStopDelayMult"] = 1,
	["speicalSpeed"] = 100/30,
    ["extraReelTimeInFreeGame"] = 240/30,
    ["extraJiliTime"] = 80/30,
}
config.symbolLabel = {
    file = "font/theme244_2.fnt",
    pos  = cc.p(0,0),
    scale = 1
}
config.theme_config = {
	reel_symbol  = {
        ["theme_symbol_coinfig"]    = {
            ["symbol_zorder_list"]    = {
                [12] = 2000,
                [13] = 2000,
                [14] = 3000
            },
            ["normal_symbol_list"]    = {
                2,3,4,5,6,7,8,9,10,11
            },
            ["special_symbol_list"]   = {
                1,12,13,14
            },
            ["no_roll_symbol_list"]   = {
                
            },
            ["special_symbol_config"] = {
                [config.special_symbol.scatter] = {
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
                [config.special_symbol.bonus1] = {
                    ["min_cnt"] = 6,
                    ["type"]    = G_THEME_SYMBOL_TYPE.NUMBER,
                    ["col_set"] = {
                        [1] = 2,
                        [2] = 2, 
                        [3] = 2,
                        [4] = 2,
                        [5] = 2,
                    },
                },
                [config.special_symbol.bonus2] = {
                    ["min_cnt"] = 3,
                    ["type"]    = G_THEME_SYMBOL_TYPE.NUMBER,
                    ["col_set"] = {
                        [1] = 0,
                        [2] = 0, 
                        [3] = 0,
                        [4] = 0,
                        [5] = 0,
                    },
                },
            },
        },
        ["theme_round_light_index"] = 1,
        ["theme_type"]              = "payLine",
        ["theme_type_config"]       = {
            pay_lines = {
                {1, 1, 1, 1, 1},{0, 0, 0, 0, 0},{2, 2, 2, 2, 2},{0, 1, 2, 1, 0},{2, 1, 0, 1, 2},
                {1, 0, 1, 0, 1},{1, 2, 1, 2, 1},{0, 1, 0, 1, 0},{2, 1, 2, 1, 2},{1, 0, 0, 0, 1},
                {1, 2, 2, 2, 1},{2, 2, 1, 2, 2},{0, 0, 1, 0, 0},{2, 1, 1, 1, 2},{0, 1, 1, 1, 0},
                {0, 2, 0, 2, 0},{2, 0, 2, 0, 2},{1, 1, 0, 1, 1},{1, 1, 2, 1, 1},{2, 2, 0, 2, 2},
                {0, 0, 2, 0, 0},{0, 0, 1, 2, 2},{2, 2, 1, 0, 0},{1, 0, 2, 0, 1},{1, 2, 0, 2, 1},
                {1, 2, 1, 0, 0},{1, 0, 1, 2, 2},{0, 1, 2, 2, 2},{2, 1, 0, 0, 0},{0, 0, 0, 1, 2},
                {2, 2, 2, 1, 0},{1, 0, 1, 2, 1},{1, 2, 1, 0, 1},{0, 1, 1, 1, 1},{2, 1, 1, 1, 1},
                {0, 0, 1, 1, 1},{2, 2, 1, 1, 1},{2, 1, 2, 1, 0},{0, 1, 0, 1, 2},{1, 0, 0, 0, 0},
                {1, 2, 2, 2, 2},{0, 0, 0, 1, 0},{2, 2, 2, 1, 2},{0, 1, 0, 0, 0},{2, 1, 2, 2, 2},
                {1, 0, 1, 1, 1},{1, 2, 1, 1, 1},{0, 0, 0, 0, 2},{2, 2, 2, 2, 0},{1, 1, 1, 0, 1}  
            },
            line_cnt = 50
        },
        ["boardConfig"]             = {
            { -- base
                ["allow_over_range"] = true,
                ["colCnt"]           = 5,
                ["cellWidth"]        = G_CELL_WIDTH,
                ["cellHeight"]       = G_CELL_HEIGHT,
                ["symbolCount"]      = 3,
                ["lineWidth"]        = 4,
                ["reelConfig"]       = {
                    { ["base_pos"] = cc.p(172, 114) },
                }
            },
            {
                ["row_single"]  = true,
                ["rowReelCnt"]  = 5, 
                ["colCnt"]      = 15,
                ["cellWidth"]   = G_CELL_WIDTH,
                ["cellHeight"]  = G_CELL_HEIGHT-4,
                ["lineWidth"]   = 4,
                ["lineHeight"]   = 5.5,
                ["symbolCount"] = 1,
                ["reelConfig"]  = {
                    {
                        ["base_pos"] = cc.p(192, 114),
                        symbolCount  = 1
                    },
                }
            },
        }
    },
    base_col_cnt = 5,
}
config.theme_reels = {
	["main_reel"] = {
        [1] = {2,2,228,1,1,10,3,3,131,8,8,1,1,128,123,123,4,4,4,9,4,228,2,2,2,7,11,5,5,128,124,3,3,5,5,228,4,4,4,14,2,2,9,7,10,123,2,133,3,3,3,1,1,1,9,4,4,4,123,1,121},
        [2] = {2,2,223,1,1,10,3,3,133,8,8,1,1,123,124,124,4,4,4,9,4,223,2,2,2,7,11,5,5,123,121,3,3,1,1,228,4,4,4,14,2,2,9,7,10,128,2,132,3,3,3,1,1,1,9,4,4,4,128,1,123},
        [3] = {2,2,227,1,1,10,3,3,132,8,8,1,1,127,121,121,4,4,4,9,4,226,2,2,2,7,11,5,5,126,125,3,3,1,1,228,4,4,4,14,2,2,9,7,10,123,1,134,3,3,3,1,1,1,9,4,4,4,123,1,124},
        [4] = {2,2,224,1,1,10,3,3,130,8,8,1,1,124,123,123,4,4,4,9,4,224,2,2,2,7,11,5,5,124,121,3,3,1,1,228,4,4,4,14,2,2,9,7,10,127,7,130,3,3,3,1,1,1,9,4,4,4,127,1,121},
        [5] = {2,2,228,1,1,10,3,3,134,8,8,1,1,128,124,124,4,4,4,9,4,222,2,2,2,7,11,5,5,122,123,3,3,5,5,223,4,4,4,14,2,2,9,7,10,124,5,131,3,3,3,1,1,1,9,4,4,4,124,1,123}
    },
    ["respin_reel"] = {
        [1] = {2,2,128,5,5,3,3,3,134,3,3,5,5,129,5,127,4,4,4,130,2,2,2,5,5,3,3,5,5,127,4,4,4,2,2,4,5,131,3,3,3,6,6,6,4,4,4,4,124,2}
    },
    ["respin_reel1"] = {
        [1] = {2,2,228,5,5,3,3,3,234,3,3,5,5,229,5,227,4,4,4,230,2,2,2,5,5,3,3,5,5,227,4,4,4,2,2,4,5,231,3,3,3,6,6,6,4,4,4,4,224,2}
    },
}
config.userSpine = {
    loop1 = "animation1",
    loop2 = "animation2",
    click = "animation3",
    moneygrab = "animation4",
    board_jili = "animation5",
    bigwin = "animation6",
    wild_fg_up = "animation7",
    wild_fg_loop = "animation8",
    wild_fg_no = "animation9",
    wild_fg_hand = "animation10",
    leave = "animation11",
    show = "animation12",
    static = "animation13",
    scatter_jili = "animation14",
}

config.unlockBetList = {
    Jackpot5 = 1, --mini
    Jackpot4 = 2, --minor
    Collect  = 3, 
    Jackpot3 = 4, --major 
    Jackpot2 = 5, --maxi 
    Jackpot1 = 6, --grand
}
config.collectAnimation = {
    lock         = "animation",
    lockLoop     = "animation2",
    unlock       = "animation3",
}
config.collectData = {
    maxMapLevel = 10
}
-- jp start
config.jackpotViewConfig = {
    betMul       = {1000, 500, 100, 25, 10},
	width        = { 429, 254, 254, 254, 254},
    scale        = { 1, 0.9, 0.9, 0.9, 0.9},
    count        = 5,
    name         = {"grand","maxi","major","minor","mini"},
    unlock_fnt   = {"theme244_1.fnt"},
    lock_fnt     = {"theme244_6.fnt"},
    light_tip_img = "#theme244_jp_name%s.png",
    light_bg_img  = "#theme244_jp_bg%s.png",
    grayScaleX   = {1,1,-1,1,-1},
    lightScaleX   = {1,1,1,1,1},
}
config.jackpotCtlConfig = {
    link_config = {"grand","maxi","major","minor","mini"},
    allowK = {[244] = false, [744] = false, [1244] = false},
}
-- jp end
config.transition_config = {
    free   = { ["onCover"] = 55 / 30, ["onEnd"] = 110 / 30,  ["spine"] = "free_tansition",["animName"] = "qiepin", ["music"] = "transition_free"},
    respin = { ["onCover"] = 55 / 30, ["onEnd"] = 110 / 30,  ["spine"] = "respin_tansition",["animName"] = "animation1", ["music"] = "transition_bonus"},
    super_respin = { ["onCover"] = 55 / 30, ["onEnd"] = 110 / 30,  ["spine"] = "respin_tansition",["animName"] = "animation2", ["music"] = "transition_bonus"},
}
config.map_config = {
    -- collect_image = "#theme239_map_icon%s.png",
    collect_level = {3,7,12,18,25,33},
    map_building_config = {
        [3]  = 1,
        [7]  = 2,
        [12] = 3,
        [18] = 4,
        [25] = 5,
        [33] = 6
    },
    map_pos_config = {
        userStartPos  = cc.p(172, 358),
        panelStartPos = cc.p(0, -460),
        panelHidePos  = cc.p(0, 1700),
    },
    buildingLevel = 33,
    -- bigBuildImage = "#theme219_map_build%s.png",
    buildTipImage = "#theme219_map_booster%s.png",
    smallBuildImage = {
        light = "#theme239_map_dizuo%s.png",
        grey  = "#theme239_map_dizuo.png",
    },
    -- smallBuildImage = "theme219_map_build%s",
    map_stype = {
        feature = 1, --未来
        current_start = 2, --开始播放当前的动画
        current_finish = 3, --播放循环的动画
        finish  = 4, -- 完成的状态
    }
}
config.music_volume = {
    max_volume = 1,
    min_volume = 0,
    time_volume = 0.2
}
config.csb_list = {
    base = "csb/base_game.csb",
    dialog_free = "csb/dialog_free.csb",
    dialog_jp = "csb/dialog_jp.csb",
    dialog_pick = "csb/dialog_respin_pick.csb",
    dialog_welcome = "csb/dialog_welcom.csb",
    addLabel = "csb/add_con.csb",
}

config.dialog_config = {
    ["welcome_start"] = {
        bg         = {
            name        = "dialog_welcome",
            startAction = { "animation1", false },
            loopAction  = { "animation2", true },
            endAction   = { "animation3", false },
        },
    },
    ["free_start"] = {
        bg         = {
            name        = "dialog_free",
            startAction = { "kaishi1", false },
            loopAction  = { "kaishi2", true },
            endAction   = { "kaishi3", false },
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 3 / 30, 0 }, { 8 / 30, 1.2 }, { 10 / 30, 0.9 }, { 14 / 30, 1 } },
            stepEndScale = { { 1 }, { 4 / 30, 1.12 }, { 7 / 30, 0 }},
            startPos = cc.p(0, -5)
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 18 / 30, 0 }, { 10 / 30, 0.92 }, { 15 / 30, 1 } },
            stepEndScale = { { 1 }, { 8 / 30, 1.1 }, { 8 / 30, 0 }},
            startPos = cc.p(0, -205)
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation",
        },
    },
    ["free_more"] = {
        bg         = {
            name        = "dialog_free",
            startAction = { "retrigger1", false },
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 3 / 30, 0 }, { 8 / 30, 1.2 }, { 10 / 30, 0.9 }, { 14 / 30, 1 } },
            stepEndScale = { { 1 }, { 4 / 30, 1.15 }, { 7 / 30, 0 }},
            startPos = cc.p(0, -5)
        },

    },
    ["free_collect"] = {
        bg         = {
            name        = "dialog_free",
            startAction = { "jiesuan1", false },
            loopAction  = { "jiesuan2", true },
            endAction   = { "jiesuan3", false },
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 3 / 30, 0.48 }, { 7 / 30, 1.2 }, { 10 / 30, 0.9 }, { 14 / 30, 1 } },
            stepEndScale = { { 1 }, { 4 / 30, 1.15 }, { 8 / 30, 0 }},
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 13 / 30, 0 }, { 10 / 30, 1.1 }, { 10 / 30, 0.9 }, { 10 / 30, 1 } },
            stepEndScale = { { 1 }, { 7 / 30, 1.23 }, { 10 / 30, 0 }},
            startPos = cc.p(0, -175)
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation",
        },
        maxWidth   = 863,
    },
    ["respin_start"] = {
        bg         = {
            name        = "dialog_respin_start",
            startAction = { "animation%s_1", false },
            loopAction  = { "animation%s_2", true },
            endAction   = { "animation%s_3", false },
            formatname  = true,
        },
        bg1         = {
            name        = "dialog_respin_start1",
            startAction = { "animation%s_1", false },
            loopAction  = { "animation%s_2", true },
            endAction   = { "animation%s_3", false },
            formatname  = true,
        }
    },
    ["respin_pick"] = {
        bg         = {
            name        = "dialog_pick",
            startAction = { "animation1", false },
            loopAction  = { "animation2", true },
            endAction   = { "animation3", false },
        },
    },
    ["jp_collect"] = {
        bg         = {
            name        = "dialog_jackpot%s",
            startAction = { "animation1", false },
            loopAction  = { "animation2", true },
            endAction   = { "animation3", false },
            formatname  = true,
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 13 / 30, 0 }, { 5 / 30, 1.1 }, { 10 / 30, 0.92 }, { 7 / 30, 1 } },
            -- stepEndScale = { { 1 }, { 12 / 30, 1 }, { 6 / 30, 1.05 }, { 8 / 30, 0 } },
            stepEndScale = { { 1 }, { 8 / 30, 1 }, { 6 / 30, 1.05 }, { 8 / 30, 0 } },
            startPos = cc.p(0, -55)
        },
        add_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 13 / 30, 0 }, { 5 / 30, 1.1 }, { 10 / 30, 0.92 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 12 / 30, 1 }, { 6 / 30, 1.05 }, { 8 / 30, 0 } },
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 14 / 30, 0 }, { 1 / 30, 0.9 } },
            stepPos = {{cc.p(0, -84)}, {14/30, cc.p(0, -87)}, { 10 / 30, cc.p(0, -237)}, { 8 / 30, cc.p(0, -205)}, { 8 / 30, cc.p(0, -214)}},
            stepEndScale = { { 0.9 }, { 6 / 30, 1.3 }, { 8 / 30, 0 }},
        },
        btn        = {
            name    = "dialog_jp_btn",
            aniName = "animation",
        },
        maxWidth   = 836,
    },
    ["black_common"] = {
        stepFade     = { { 0 },  { 8 / 30, 200 } },
        stepEndFade  = { { 200 }, { 10 / 30, 200 }, { 8 / 30, 0 } },
    }
}

config.audioList = {
    common_click = "audio/base/click.mp3",
    trigger_bell = "audio/base/bell.mp3",
    popup_out    = "audio/base/popup_out.mp3",

    peopelrollup01 = "audio/bigwin/big_win.mp3",
    peopelrollup02 = "audio/bigwin/huge_win.mp3",
    peopelrollup03 = "audio/bigwin/massive_win.mp3",
    peopelrollup04 = "audio/bigwin/apocalyptic_win.mp3",

    -- 背景音效
    base_background = "audio/bgm/base_bgm.mp3",
    free_background = "audio/bgm/free_bgm.mp3",
    bonus_background = "audio/bgm/bonus_bgm.mp3",
    superBonus_background = "audio/bgm/ultimatebonus_bgm.mp3",

    -- rollup
    rollup01      = "audio/base/win1.mp3",
    rollup01_end  = "audio/base/win1end.mp3",
    rollup02      = "audio/base/win2.mp3",
    rollup02_end  = "audio/base/win2end.mp3",

    -- base
    reel_stop   = "audio/base/reel_stop.mp3",
    base_shake   = "audio/base/shake.mp3",

    -- collect
    jp_lock   = "audio/base/jp_lock.mp3",
    jp_unlock = "audio/base/jp_unlock.mp3",

    -- collect_fly = "audio/base/collect_fly.mp3",
    collect_win = "audio/base/superbonus_win.mp3", -- 推图中奖的动画
    collect_lock = "audio/base/superbonus_lock.mp3",
    collect_unlock = "audio/base/superbonus_unlock.mp3",
    tip_board = "audio/base/tipboard.mp3",


    -- land
    bonus_land1 = "audio/base/white_land.mp3",
    bonus_land2 = "audio/base/yellow_land.mp3",
    scatter_land = "audio/base/scatter_land.mp3",

    yellow_collcet1 = "audio/base/yellow_collect1.mp3",
    yellow_collcet2 = "audio/base/yellow_collect2.mp3",
    white_collect1 = "audio/base/white_collect1.mp3",
    white_collect2 = "audio/base/white_collect2.mp3",
    gem_change = "audio/base/gem_change.mp3",


    reel_notify_scatter1 = "audio/base/free_anticipation1.mp3",
    reel_notify_scatter2 = "audio/base/free_anticipation2.mp3",
    reel_notify_scatter3 = "audio/base/free_anticipation3.mp3",
    reel_notify_bonus = "audio/base/bonus_anticipation1.mp3",
    reel_notify_board = "audio/base/bonus_anticipation2.mp3",
    

    -- respin 
    respin_jili = "audio/base/rihno_anticipation.mp3",
    respin_jili1 = "audio/base/bonus_anticipation3.mp3",
    respin_collect = "audio/base/bonus_collect.mp3",
    respin_click = "audio/base/bonus_pick.mp3",
    respin_add = "audio/base/spin_add.mp3",
    respin_coin_rise = "audio/base/coin_rise.mp3",
    respin_finish = "audio/base/light.mp3",
    respin_congrats = "audio/base/bonus_congrats.mp3",


    -- dialog
    jackpot_fly = "audio/base/fly.mp3",
    dialog_extra = "audio/base/popup_out.mp3",
    dialog_extra_pick = "audio/oa/extra_spins.mp3",

    dialog_bonus1 = "audio/dialog/bonus_start_show.mp3",
    dialog_bonus2 = "audio/dialog/superbonus_start_show.mp3",
    dialog_bonus_oa1 = "audio/oa/blue_gems.mp3",
    dialog_bonus_oa2 = "audio/oa/rush_on_winnings.mp3",
    base_welcome = "audio/dialog/dialog_start.mp3",

    free_dialog_start_show  = "audio/dialog/dialog_fg_start.mp3",
    free_dialog_start_close = "audio/dialog/popup_out.mp3",
    free_dialog_more_show = "audio/dialog/dialog_fg_retrigger.mp3",
    free_dialog_collect_show  = "audio/dialog/dialog_fg_collect.mp3",
    free_dialog_collect_close = "audio/base/popup_out.mp3",
    free_dialog_more_close = "audio/dialog/popup_out.mp3",
    dialog_jp1 = "audio/dialog/dialog_grand.mp3",
    dialog_jp2 = "audio/dialog/dialog_maxi.mp3",
    dialog_jp3 = "audio/dialog/dialog_major.mp3",
    dialog_jp4 = "audio/dialog/dialog_minor.mp3",
    dialog_jp5 = "audio/dialog/dialog_mini.mp3",

    -- --transition
    transition_free = "audio/base/transition_fg.mp3", 
    transition_bonus = "audio/base/transition_bonus.mp3",  
}
config.particle_path = {
    flyCoins = "kuangshilizi.plist",
}
config.spine_path = {
    --collect
    collect_unlock = "base/collect/tt_ss",
    collect_loop = "base/collect/tt_xh1",
    collect_loop1 = "base/collect/tt_xh",
    collect_award = "base/collect/tt_zj",
    collect_jieshou = "respin/blue_diamond/xiaolan",
    collect_super_jili = "base/collect/ts",

    --jp
    jackpot_lock = "base/jackpot/jp_ss",
    jackpot_unlock = "base/jackpot/jp_js",
    jackpot_loop = "base/jackpot/jp_xh",
    jackpot_award = "base/jackpot/jp_zj",

    --base
    zhongjiang   = "base/kuang/spine",
    logo_label = "long_logo/spine",
    respin_board = "base/tip_board/244_base_tsb",
    jili_board = "base/jili_board/244_xnjl",
    jili_scatter = "base/jili/244_base_fg_jili01",
    jili_bonus = "base/jili_bonus/244_base_bonuejili",
    jili_halfboard = "base/jili_halfboard/banping_jili",

    base_board = "base/board/244_base_qpxh",
    
    --respin
    collect_top = "item/13/spine",
    collect_top1 = "respin/yellow_diamond/ptjieshou", --收集不中奖 
    collect_top2 = "respin/yellow_diamond/zjjieshou", --收集且中奖
    symbol_change = "respin/yellow_diamond/bianlan",
    symbol_change1 = "respin/yellow_diamond/bianhuang",
    symbol_blue = "item/12/spine",
    blue_add = "respin/blue_diamond/lanzha",
    yellow_add = "respin/yellow_diamond/huangzha",
    respin_collect = "respin/244_bonus_lizi",
    respin_times_add = "respin/244_bonus_spin",
    respin_times_board = "respin/244_bonus_qz",
    label_add = "respin/yellow_diamond/shuzibianhua",
    respin_yellow_label = "respin/huangsefangda",
    respin_blue_label = "respin/lansefangda",
    respin_footer1 = "respin/244_bonus_footer01",
    respin_footer2 = "respin/244_bonus_footer02",
    
    
    base_bg = "base/bg/244_base_bgxh",
    free_bg = "base/bg/244_bonus_bgxh",
    bonus_bg = "base/bg/244_super_bgxh",
    superbonus_bg = "base/bg/244_free_bgxh",

    ---- dialog
    dialog_welcome = "dialog/entertheme/jinruzhuti_tc",
    dialog_btn = "dialog/btn_fg/anniu_saoguang",
    dialog_free     = "dialog/fg/fg_tanchuang",
    dialog_jp_btn = "dialog/btn_jp/anniu_saoguang",
    -- bonus_tc
    dialog_respin_start = "dialog/bonus/bonus_tc_xiamian",
    dialog_respin_start1 = "dialog/bonus/bonus_tc_shangmian",

    dialog_jackpot1 = "dialog/jp/jp_grand_tc",
    dialog_jackpot2 = "dialog/jp/jp_maxi_tc",
    dialog_jackpot3 = "dialog/jp/jp_major_tc",
    dialog_jackpot4 = "dialog/jp/jp_minor_tc",
    dialog_jackpot5 = "dialog/jp/jp_mini_tc",
    dialog_jackpot_double = "dialog/jp/jp_shuzikuang",
    dialog_pick = "dialog/pick/244_bonus_extra01",
    dialog_pick1 = "dialog/pick/244_bonus_extra02",

    -- --trasition
    free_tansition = "transition/244scatter_qiepin",
    respin_tansition = "transition/244_qieping",

}
config.pay_muti = {
    ["1"] = {"5 - 100000", "4 - 50000", "3 - 10000"},
	["2"] = {"5 - 20000", "4 - 5000", "3 - 1500"},
	["3"] = {"5 - 15000", "4 - 4000", "3 - 1000"},
	["4"] = {"5 - 10000", "4 - 3000", "3 - 1000"},
    ["5"] = {"5 - 5000", "4 - 1000", "3 - 500"},
    ["6"] = {"1000X"},
	["7"] = {"500X"},
	["8"] = {"100X"},
	["9"] = {"25X"},
	["10"] = {"10X"},
}
config.all_img_path = {
    {1, "font/theme244_1.png" },
    {1, "font/theme244_2.png" },
    {1, "font/theme244_3.png" },
    {1, "font/theme244_4.png" },
    {1, "font/theme244_5.png" },
    {1, "font/theme244_6.png" },
    {1, "image/bg/theme244_bg_base.png" },
    {1, "image/bg/theme244_bg_bonus.png" },
    {1, "image/bg/theme244_bg_bonus1.png" },
    {1, "image/bg/theme244_bg_free.png" },
    {1, "image/paytable/paytable.png" },
    {1, "image/plist/base.png" },
    {1, "image/plist/popup.png" },
    {1, "image/plist/symbol.png" },
    {1, "spine/base/bg/244_base_bgxh.png" },
    {1, "spine/base/bg/244_bonus_bgxh.png" },
    {1, "spine/base/bg/244_free_bgxh.png" },
    {1, "spine/base/bg/244_super_bgxh.png" },
    {1, "spine/base/board/244_base_qpxh.png" },
    {1, "spine/base/collect/ts.png" },
    {1, "spine/base/collect/tt_ss.png" },
    {1, "spine/base/collect/tt_xh.png" },
    {1, "spine/base/collect/tt_xh1.png" },
    {1, "spine/base/collect/tt_zj.png" },
    {1, "spine/base/jackpot/jp_js.png" },
    {1, "spine/base/jackpot/jp_ss.png" },
    {1, "spine/base/jackpot/jp_xh.png" },
    {1, "spine/base/jackpot/jp_zj.png" },
    {1, "spine/base/jili/244_base_fg_jili01.png" },
    {1, "spine/base/jili_board/244_xnjl.png" },
    {1, "spine/base/jili_bonus/244_base_bonuejili.png" },
    {1, "spine/base/jili_halfboard/banping_jili.png" },
    {1, "spine/base/kuang/244_base_zjlx.png" },
    {1, "spine/base/tip_board/244_base_tsb.png" },
    {1, "spine/dialog/bonus/bonus_tc_shangmian.png" },
    {1, "spine/dialog/bonus/bonus_tc_xiamian.png" },
    {1, "spine/dialog/btn_fg/anniu_saoguang.png" },
    {1, "spine/dialog/btn_jp/anniu_saoguang.png" },
    {1, "spine/dialog/entertheme/jinruzhuti_tc.png" },
    {1, "spine/dialog/fg/fg_tanchuang.png" },
    {1, "spine/dialog/jp/jp_grand_tc.png" },
    {1, "spine/dialog/jp/jp_major_tc.png" },
    {1, "spine/dialog/jp/jp_maxi_tc.png" },
    {1, "spine/dialog/jp/jp_mini_tc.png" },
    {1, "spine/dialog/jp/jp_minor_tc.png" },
    {1, "spine/dialog/jp/jp_shuzikuang.png" },
    {1, "spine/dialog/pick/244_bonus_extra01.png" },
    {1, "spine/dialog/pick/244_bonus_extra02.png" },
    {1, "spine/item/1/wild.png" },
    {1, "spine/item/10/244_symbol_l4.png" },
    {1, "spine/item/11/244_symbol_l5.png" },
    {1, "spine/item/12/lanbonus.png" },
    {1, "spine/item/13/huangbonus.png" },
    {1, "spine/item/14/scatter.png" },
    {1, "spine/item/2/m1_01.png" },
    {1, "spine/item/3/m2.png" },
    {1, "spine/item/4/m3.png" },
    {1, "spine/item/5/244_m4.png" },
    {1, "spine/item/6/244_symbol_m5.png" },
    {1, "spine/item/7/244_symbol_l1.png" },
    {1, "spine/item/8/244_symbol_l2.png" },
    {1, "spine/item/9/244_symbol_l3.png" },
    {1, "spine/long_logo/244_logo.png" },
    {1, "spine/paytable/spine/back_to_game01.png" },
    {1, "spine/respin/244_bonus_footer01.png" },
    {1, "spine/respin/244_bonus_footer02.png" },
    {1, "spine/respin/244_bonus_lizi.png" },
    {1, "spine/respin/244_bonus_qz.png" },
    {1, "spine/respin/244_bonus_spin.png" },
    {1, "spine/respin/blue_diamond/lanzha.png" },
    {1, "spine/respin/blue_diamond/xiaolan.png" },
    {1, "spine/respin/huangsefangda.png" },
    {1, "spine/respin/lansefangda.png" },
    {1, "spine/respin/yellow_diamond/bianhuang.png" },
    {1, "spine/respin/yellow_diamond/bianlan.png" },
    {1, "spine/respin/yellow_diamond/huangzha.png" },
    {1, "spine/respin/yellow_diamond/ptjieshou.png" },
    {1, "spine/respin/yellow_diamond/shuzibianhua.png" },
    {1, "spine/respin/yellow_diamond/zjjieshou.png" },
    {1, "spine/transition/244_qieping.png" },
    {1, "spine/transition/244scatter_qiepin.png" },
}
return config



