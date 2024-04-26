--Author:zhouguangyue
--2020年6月1日 9:30
--Using:主题 194

ThemePowerSlot = class("ThemePowerSlot", Theme)
local cls = ThemePowerSlot

cls.plistAnimate = {
	"image/plist/symbol",
    "image/plist/base",
    "image/plist/map",
    "image/plist/dialog",
    "image/plist/respin",
    "image/plist/map_wheel"
}

cls.csbList = {
    "csb/base.csb"
}

local specialSymbol = {
    ["bonus"] = 13, ["kong"] = 0,["wild"] = 1
}

local SpinBoardType = {
	Normal 		= 1,
    Map_FreeSpin = 2,
    ReSpin = 3,
}

local ReSpinStep = {
    OFF = 1,
    Start = 2,
    Reset = 3,
    Over = 4,
    Playing = 5,    
}

local mapFreeSpinBoardCfg = {
    [4] = {
        [1] = 2,
        [2] = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0}
    },
    [9] = {
        [1] = 2,
        [2] = {0, 0, 1, 0, 1, 0, 0, 1, 0, 1}
    },
    [12] = {
        [1] = 3,
        [2] = {0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0}
    },
    [18] = {
        [1] = 4,
        [2] = {0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1}
    },
    [22] = {
        [1] = 2,
        [2] = {1, 0, 1, 0, 1, 1, 0, 1, 0, 1}
    },
    [25] = {
        [1] = 2,
        [2] = {1, 0, 0, 0, 1, 1, 0, 0, 0, 1}
    },
    [31] = {
        [1] = 4,
        [2] = {0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1}
    },
    [35] = {
        [1] = 3,
        [2] = {1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1}
    },
    [40] = {
        [1] = 3,
        [2] = {0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0}
    },
    [44] = {
        [1] = 3,
        [2] = {0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0}
    },
    [48] = {
        [1] = 4,
        [2] = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0}
    },
    [53] = {
        [1] = 4,
        [2] = {0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0}
    },
    [56] = {
        [1] = 2,
        [2] = {1, 1, 1, 0, 0, 1, 1, 1, 0, 0}
    },
    [62] = {
        [1] = 3,
        [2] = {0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0}
    },
    [66] = {
        [1] = 3,
        [2] = {1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0}
    },
    [69] = {
        [1] = 2,
        [2] = {0, 1, 0, 0, 1, 0, 1, 0, 0, 1}
    },
    [75] = {
        [1] = 3,
        [2] = {0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1}
    },
    [79] = {
        [1] = 3,
        [2] = {0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0}
    },
    [84] = {
        [1] = 4,
        [2] = {1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1}
    },
    [88] = {
        [1] = 3,
        [2] = {1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0}
    },
    [92] = {
        [1] = 4,
        [2] = {0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0}
    },
    [100] = {
        [1] = 4,
        [2] = {0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1}
    }
}

local mapFreeBoardPosCfg = {
    [2] = {
        [1] = 1,
        [2] = {42, -308}
    },
    [3] = {
        [1] = 1,
        [2] = {392, 42, -308}
    },
    [4] = {
        [1] = 0.75,
        [2] = {430, 170, -90, -350}
    }
}

local mapNodeTypeCfg = { -- 1 红  2 蓝  3 小  4 中  5 大 
    1, 2, 1, 3, 1, 1, 2, 1, 3, 1,
    1, 4, 1, 1, 2, 1, 1, 5, 1, 2,
    1, 3, 1, 1, 3, 1, 1, 2, 1, 1, 
    5, 1, 2, 1, 4, 1, 1, 2, 1, 4,
    1, 2, 1, 4, 1, 2, 1, 5, 1, 1,
    2, 1, 5, 1, 1, 3, 1, 1, 1, 2,
    1, 4, 1, 2, 1, 4, 1, 1, 3, 1,
    1, 2, 1, 1, 4, 1, 2, 1, 4, 1,
    1, 2, 1, 5, 1, 2, 1, 4, 1, 2,
    1, 5, 1, 1, 1, 2, 1, 1, 1, 5
}

local mapStepFreeCfg = {
    4,4,4,4,
    9,9,9,9,9,
    12,12,12,
    18,18,18,18,18,18,
    22,22,22,22,
    25,25,25,
    31,31,31,31,31,31,
    35,35,35,35,
    40,40,40,40,40,
    44,44,44,44,
    48,48,48,48,
    53,53,53,53,53,
    56,56,56,
    62,62,62,62,62,62,
    66,66,66,66,
    69,69,69,
    75,75,75,75,75,75,
    79,79,79,79,
    84,84,84,84,84,
    88,88,88,88,
    92,92,92,92,
    100,100,100,100,100,100,100,100
}

local map_free_real = {
    [1] = {11,10,11,2,2,2,2,7,8,9,3,3,3,3,10,11,7,4,4,4,4,8,9,10,5,5,5,5,11,7,8,6,6,6,6,9,10,11,2,7,3,8,2,7,4,9,2,7,5,10,2,7,6,11,3,8,4,9,3,8,5,10,3,8,6,11,4,9,5,10,4,9,6},
    [2] = {7,8,7,2,2,2,2,11,10,9,3,3,3,3,8,7,11,4,4,4,4,10,9,8,5,5,5,5,7,11,10,6,6,6,6,9,8,7,2,11,3,10,2,11,4,9,2,11,5,8,2,11,6,7,3,10,4,9,3,10,5,8,3,10,6,7,4,9,5,8,4,9,6},
    [3] = {11,10,11,2,2,2,2,7,8,9,3,3,3,3,10,11,7,4,4,4,4,8,9,10,5,5,5,5,11,7,8,6,6,6,6,9,10,11,2,7,3,8,2,7,4,9,2,7,5,10,2,7,6,11,3,8,4,9,3,8,5,10,3,8,6,11,4,9,5,10,4,9,6},
    [4] = {7,8,7,2,2,2,2,11,10,9,3,3,3,3,8,7,11,4,4,4,4,10,9,8,5,5,5,5,7,11,10,6,6,6,6,9,8,7,2,11,3,10,2,11,4,9,2,11,5,8,2,11,6,7,3,10,4,9,3,10,5,8,3,10,6,7,4,9,5,8,4,9,6},
    [5] = {11,10,11,2,2,2,2,7,8,9,3,3,3,3,10,11,7,4,4,4,4,8,9,10,5,5,5,5,11,7,8,6,6,6,6,9,10,11,2,7,3,8,2,7,4,9,2,7,5,10,2,7,6,11,3,8,4,9,3,8,5,10,3,8,6,11,4,9,5,10,4,9,6},
}

local freeColCnt = 5
local freeRowCnt = 4
local moveStartDelay = 6/30
local moveWildTime = 20/30
local changeToBaseTime = 21/30

local maxMapLevel = 100 -- 20
local maxMapPoint = 100
------------ free 相关 -------------
local transitionDelay = {
    ["respin"] 	= {["onCover"] = 72/30,["onEnd"] = 98/30},
    ["map"]     = {["onCover"] = 25/30,["onEnd"] = 85/30}
}
local closeFreeDialogAnimTime = 30/30

local baseColCnt = 5

local ScatterReelState = {
	nextWillGet = 1, -- 当前列不可能中，但后续列有可能中
	curGet 		= 2, -- 当前列中
	noChance 	= 3, -- 当前列和后续列没有可能中
}

cls.spinTimeConfig = { -- spin 时间控制
		["base"] = 20/60, -- 数据返回前 进行滚动的时间
		["spinMinCD"] = 50/60,  -- 可以显示 stop按钮的时间，也就是可以通过quickstop停止的时间
}

---------------------------------- respin 相关 ----------------------------------
local respinSymbolScale = 1
local multiCfg = {0.25, 0.5, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 25, 50, 0.1}
-- local boardEndColCfg = { [14] = 1, [9] = 2, [5] = 3, [2] = 4 }
local boardEndColCfg = {
    4, 4,
    3, 3, 3,
    2, 2, 2, 2,
    1, 1, 1, 1, 1
}
local respinBoardContentCfg = {
    5, 5,
    4, 4, 4,
    3, 3, 3, 3,
    2, 2, 2, 2, 2,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
}

local respinCollectRotation = {
    -5, 5,
    -12, 0, 12,
    -20, -8, 8, 20,
    -34, -18, 0, 18, 34,
    -43, -25, 0, 25, 43,
    -55, -35, 0, 35, 55,
    -68, -50, 0, 50, 68
}

local respinBoardIndex = {[1] = true, [3] = true, [6] = true, [10] = true, [15] = true, [20] = true, [25] = true}
local respinBoardStartIndex = {[1] = true, [3] = true, [6] = true, [10] = true, [15] = true}
local boardCellCountCfg = {15, 5, 4, 3, 2}
-- local moveReelTime = 0.8
-- local freeMaxBoardCnt = 3

-------------------------------
local rowReelCnt = 5
local respinCellCount = 29

function cls:getBoardConfig()
    if self.boardConfigList then
		return self.boardConfigList
    end
    local borderConfig = self.ThemeConfig["boardConfig"]
	self.boardConfigList = borderConfig
    return borderConfig

    -- if self.boardConfigList then
    --     return self.boardConfigList
    -- end
    -- local borderConfig = self.ThemeConfig["boardConfig"]
    -- local reelConfig = borderConfig[4]["reelConfig"]
    -- local newConfig = {}
    -- for i=0, respinCellCount-1 do
    --     local oneConfig = {}
    --     oneConfig["base_pos"] = cc.p((i%5)*reelConfig["cellWidth"]+reelConfig["base_pos"].x,math.floor((respinCellCount-1-i)/5)*reelConfig["cellHeight"]+reelConfig["base_pos"].y)
    --     oneConfig["cellWidth"] = reelConfig["cellWidth"]
    --     oneConfig["cellHeight"] = reelConfig["cellHeight"]
    --     oneConfig["symbolCount"] = reelConfig["symbolCount"]
    --     table.insert(newConfig,oneConfig)
    -- end
    -- borderConfig[4]["rowReelCnt"] = rowReelCnt
    -- borderConfig[4]["reelConfig"] = newConfig
    -- self.boardConfigList = borderConfig
    -- return borderConfig
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
	            [19] = 2100,
				[1] = 900,
			},
			["normal_symbol_list"]  = {
				2, 3, 4, 5, 6, 7, 8, 9, 10, 11
			},
			["special_symbol_list"] = {
			},
			["no_roll_symbol_list"] = {
                1, 13, 14, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,
				specialSymbol.kong
			},
			["roll_symbol_inFree_list"] = {

			},
			["special_symbol_config"] = {
				[13] = {
					["min_cnt"] = 3,
					["type"]	= G_THEME_SYMBOL_TYPE.NUMBER,
					["col_set"] = {
						[1] = 4,
						[2] = 4,
						[3] = 4,
						[4] = 4,
						[5] = 4,
					},
				},
			},
		},
		["theme_round_light_index"] = 1,
		["theme_type"] = "payLine",
		["theme_type_config"] = {
            ["pay_lines"] = {
                { 1, 1, 1, 1, 1 }, { 2, 2, 2, 2, 2 }, { 0, 0, 0, 0, 0 }, { 3, 3, 3, 3, 3 }, { 0, 1, 2, 1, 0 }, { 1, 2, 3, 2, 1 }, { 2, 1, 0, 1, 2 }, { 3, 2, 1, 2, 3 }, { 0, 1, 1, 1, 0 }, { 1, 2, 2, 2, 1 },
                { 2, 3, 3, 3, 2 }, { 1, 0, 0, 0, 1 }, { 2, 1, 1, 1, 2 }, { 3, 2, 2, 2, 3 }, { 0, 0, 1, 0, 0 }, { 1, 1, 2, 1, 1 }, { 2, 2, 3, 2, 2 }, { 1, 1, 0, 1, 1 }, { 2, 2, 1, 2, 2 }, { 3, 3, 2, 3, 3 },
                { 0, 1, 0, 1, 0 }, { 1, 2, 1, 2, 1 }, { 2, 3, 2, 3, 2 }, { 1, 0, 1, 0, 1 }, { 2, 1, 2, 1, 2 }, { 3, 2, 3, 2, 3 }, { 1, 0, 1, 2, 1 }, { 2, 1, 2, 3, 2 }, { 1, 2, 1, 0, 1 }, { 2, 3, 2, 1, 2 },
                { 0, 0, 1, 2, 2 }, { 1, 1, 2, 3, 3 }, { 2, 2, 1, 0, 0 }, { 3, 3, 2, 1, 1 }, { 0, 0, 2, 0, 0 }, { 1, 1, 3, 1, 1 }, { 2, 2, 0, 2, 2 }, { 3, 3, 1, 3, 3 }, { 0, 0, 0, 1, 2 }, { 3, 3, 3, 2, 1 },
            },
            ["line_cnt"] = 40,
		},
		["boardConfig"] = {
            { -- base 棋盘
                ["allow_over_range"] = false,
                ["colCnt"] = 5,
                ["reelConfig"] = {
                    {
                        ["base_pos"] = cc.p(44,176),
                        ["cellWidth"] = 127,
                        ["cellHeight"] = 80,
                        ["symbolCount"] = 4
                    },
                    {
                        ["base_pos"] = cc.p(171,176),
                        ["cellWidth"] = 127,
                        ["cellHeight"] = 80,
                        ["symbolCount"] = 4
                    },
                    {
                        ["base_pos"] = cc.p(298,176),
                        ["cellWidth"] = 127,
                        ["cellHeight"] = 80,
                        ["symbolCount"] = 4
                    },
                    {
                        ["base_pos"] = cc.p(425,176),
                        ["cellWidth"] = 127,
                        ["cellHeight"] = 80,
                        ["symbolCount"] = 4
                    },
                    {
                        ["base_pos"] = cc.p(552,176),
                        ["cellWidth"] = 127,
                        ["cellHeight"] = 80,
                        ["symbolCount"] = 4
                    },
                }
			},
            { -- free 棋盘
                ["reel_single"] = true,
                ["allow_over_range"] = true,
                ["colCnt"] = 5,
                ["reelConfig"] = {
                    {
                        ["base_pos"] = cc.p(44,176),
                        ["cellWidth"] = 127,
                        ["cellHeight"] = 80,
                        ["symbolCount"] = 4
                    },
                    {
                        ["base_pos"] = cc.p(171,176),
                        ["cellWidth"] = 127,
                        ["cellHeight"] = 80,
                        ["symbolCount"] = 4
                    },
                    {
                        ["base_pos"] = cc.p(298,176),
                        ["cellWidth"] = 127,
                        ["cellHeight"] = 80,
                        ["symbolCount"] = 4
                    },
                    {
                        ["base_pos"] = cc.p(425,176),
                        ["cellWidth"] = 127,
                        ["cellHeight"] = 80,
                        ["symbolCount"] = 4
                    },
                    {
                        ["base_pos"] = cc.p(552,176),
                        ["cellWidth"] = 127,
                        ["cellHeight"] = 80,
                        ["symbolCount"] = 4
                    },
                }
            },
			{ -- free 2个棋盘 3*5
				["reel_single"] = true,
				["allow_over_range"] = false,
				["colCnt"] = 5,
				["rowCnt"] = 4,
				["cellWidth"] = 124,
				["cellHeight"] = 78,
				["reelConfig"] = {
                    {["base_pos"] = cc.p(42, 536), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(170,536), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(297,536), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(424,536), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(552,536), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},

                    {["base_pos"] = cc.p(42, 186), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(170,186), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(297,186), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(424,186), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(552,186), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
				},
			},
			{ -- free 3个棋盘 3*5
				["reel_single"] = true,
				["allow_over_range"] = false,
				["colCnt"] = 5,
				["rowCnt"] = 4,
				["cellWidth"] = 124,
				["cellHeight"] = 78,
				["reelConfig"] = { 
                    {["base_pos"] = cc.p(42, 886), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(170,886), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(297,886), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(424,886), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(552,886), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},

                    {["base_pos"] = cc.p(42, 536), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(170,536), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(297,536), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(424,536), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(552,536), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},

                    {["base_pos"] = cc.p(42, 186), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(170,186), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(297,186), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(424,186), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(552,186), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
				},
			},
			{ -- free 4个棋盘 3*5
				["reel_single"] = true,
				["allow_over_range"] = false,
				["colCnt"] = 5,
				["rowCnt"] = 4,
				["cellWidth"] = 124,
				["cellHeight"] = 78,
				["reelConfig"] = {
                    {["base_pos"] = cc.p(162,  1281), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(289.5,1281), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(417,  1281), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(544.5,  1281), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(672,  1281), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},  -- 1320
                    
                    {["base_pos"] = cc.p(162,  934), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4}, -- 973
                    {["base_pos"] = cc.p(289.5,934), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(417,  934), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(544.5,  934), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(672,  934), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},

                    {["base_pos"] = cc.p(162,  587), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4}, -- 626
                    {["base_pos"] = cc.p(289.5,587), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(417,  587), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(544.5,  587), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(672,  587), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},

                    {["base_pos"] = cc.p(162,  240), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4}, -- 279
                    {["base_pos"] = cc.p(289.5,240), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(417,  240), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(544.5,  240), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
                    {["base_pos"] = cc.p(672,  240), ["cellWidth"] = 127, ["cellHeight"] = 78, ["symbolCount"] = 4},
				},
            },
            { -- respin
                ["allow_over_range"] = false,
                ["row_single"] = true,
                ["rowReelCnt"] = 5,
                ["reelConfig"] = {
                    -- b5
                    {["base_pos"] = cc.p(233,709.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(362,709.5),  ["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},

                    -- b4
                    {["base_pos"] = cc.p(169,611.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(296,611.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(423,611.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},

                    -- b3
                    {["base_pos"] = cc.p(108,511.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(235,511.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(362,511.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(489,511.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},

                    -- b2
                    {["base_pos"] = cc.p(45,409.5), ["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(171,409.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(296,409.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(421,409.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(548,409.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},

                    -- b1
                    {["base_pos"] = cc.p(45,308.5), ["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(171,308.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(296,308.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(421,308.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(548,308.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},

                    {["base_pos"] = cc.p(45,225.5), ["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(171,225.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(296,225.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(421,225.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(548,225.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},

                    {["base_pos"] = cc.p(45,143.5), ["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(171,143.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(296,143.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(421,143.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                    {["base_pos"] = cc.p(548,143.5),["cellWidth"] = 127,["cellHeight"] = 76,["symbolCount"] = 1},
                },
            }
		}
	}

    --- add by yt
    EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_SHOW, "theme194", self.touchShowCActivity, self)
    EventCenter:registerEvent(EVENTNAMES.ACTIVITY_THEME.C_MOVE_HIDE, "theme194", self.touchHideCActivity, self)
    --- end by yt

	self.baseBet = 10000
	self.DelayStopTime = 0
	self.UnderPressure = 1 -- 下压上 控制

	local use_portrait_screen = true
	local ret = Theme.ctor(self, themeid, use_portrait_screen)

	self.game_store_version = 2
	-- self.ctl.game_store_version = 2
    return ret
end

local G_cellHeight = 80
local G_cellWidth = 127

local delay = 0
-- local upBounce = G_cellHeight * 2 / 3 --G_cellHeight*2/3
-- local upBounceMaxSpeed = 6 * 60
-- local upBounceTime = 0
-- local speedUpTime = 20 / 60
-- local rotateTime = 5 / 60
-- local maxSpeed = -30 * 60
-- local normalSpeed = -30 * 60
-- local fastSpeed = -30 * 60 - 300
local specialAniTime = 130/30

-- local stopDelay = 10 / 60
-- local speedDownTime = 30 / 60
-- local downBounce = G_cellHeight * 2 / 3
-- local downBounceMaxSpeed = 6 * 60
-- local downBounceTime = 15 / 60
-- local extraReelTime = 120 / 60
-- local spinMinCD = 0.5

-- -- old 1
local upBounce = G_cellHeight*2/3
local upBounceMaxSpeed = 6*60
local upBounceTime = 0
local speedUpTime = 12/60
local rotateTime = 5/60
local maxSpeed = -35*60
local normalSpeed = -35*60
local fastSpeed = -40*60 - 300

local stopDelay = 20/60
local speedDownTime = 35/60
local downBounce = G_cellHeight*1/3
local downBounceMaxSpeed = 6*60
local downBounceTime = 20/60
-- local specialAniTime = 0
local extraReelTime = 150/60
-- local extraReelTimeInFreeGame = 480/60
local spinMinCD = 0.5
-- local eachPiggyDelay = 1.5

-- whj 修改速度
-- local stopDelay = 25/60    -- auto  -10
local speedDownTime = 40 / 60
local downBounce = G_cellHeight*1/3  -- auto  不变
local downBounceTime = 20/60  -- auto  -5
local stopDelayList = {
    [1] = 30/60,
    [2] = 25/60,
    [3] = 20/60,
}
local autoStopDelayMult = 2/3
local autoDownBounceTimeMult = 1
local checkStopColCnt = 5
-- end

-- new
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
local extraReelTime = 120 / 60
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
--

-- base界面节点位置
local reelRootPos = cc.p(0, 0)
local boardPos = cc.p(-360, -640)

local respinBoardEndPos = {{0, 0}, {0, 184}, {0, 286}, {0, 380}, {0, 478}}
local respinBoardStartPos = {{0, 0}, {0, 168}, {0, -34}, {0, 60}, {0, 158}}
local miniReelHeight = 50
local stopPosCfg = {
    [1] = {
        [1] = 250,
        [7] = 200,
        [2] = 150,
        [3] = 100,
        [8] = 50,
        [4] = 0,
        [9] = -50,
        [5] = -100,
        [6] = -150,
        [10] = -200
    },
    [2] = {
        [1] = 300,
        [7] = 250,
        [2] = 200,
        [3] = 150,
        [8] = 100,
        [4] = 50,
        [9] = 0,
        [5] = -50,
        [6] = -100,
        [10] = -150
    }
}

-- respin转轴速度 
local resspin = {
    ["speedDownTime"] = 30/60
}
local BlackUint = {
    width = 54,
    height = 54
}

function cls:getSpinConfig( spinTag )
	local spinConfig = {}
    
    if self.showReSpinBoard then
        for i = 0, respinCellCount - 1 do
            local col = i + 1
            -- local tempCol = i%baseColCnt+1
            local theStartAction = self:getSpinColStartAction(col, col)
            local theReelConfig = {
                ["col"]     = col,
                ["action"]  = theStartAction,
            }
            table.insert(spinConfig, theReelConfig)
        end     
        return spinConfig
    else    
        for col,_ in pairs(self.spinLayer.spins) do
            local theStartAction = self:getSpinColStartAction(col, col)
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
        for i = 0, respinCellCount - 1 do
            local col = i + 1
            -- local tempCol = i%5+1
            local theAction = self:getSpinColStopAction(ret["theme_info"], col, interval)
            table.insert(stopConfig, {col, theAction})
        end
    else
        local stopColOrderList = {}
        for i=1, #self.spinLayer.spins do
            table.insert(stopColOrderList, i)
        end
        for index,col in pairs(stopColOrderList) do
            local theAction = self:getSpinColStopAction(ret["theme_info"], col, interval)
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
    end
    if self.isFreeGameRecoverState and self.freeType and self.freeType == 2 then
        local level = self.freeMapLevel
        if level == 0 then
            level = maxMapLevel
        end
        if level and mapFreeSpinBoardCfg[level] and mapFreeSpinBoardCfg[level][2][pCol] == 1 then
            spinAction.locked = true
        else
            spinAction.locked = false
        end
    end
	return spinAction
end

function cls:getSpinColStopAction(themeInfo, pCol, interval)
    local _stopDelay, _downBonusT = self:getCurSpinLayerSpinActionTime(stopDelayList, downBounceTime, checkStopColCnt, autoStopDelayMult, autoDownBounceTimeMult )

    local rotateTime = rotateTime

    local stopDelay = _stopDelay
    local downBounce = downBounce
    local downBounceTime = downBounceTime
    if self.showReSpinBoard then
        rotateTime = 1/60
        stopDelay = 10 / 60
        downBounce = G_cellHeight*1/2
        downBounceTime = 15/60
    end
    local specialType = nil
    local checkNotifyTag   = self:checkNeedNotify(pCol)
    if checkNotifyTag then
        self.DelayStopTime = self.DelayStopTime + extraReelTime
    end

    local function onSpecialBegain( pcol)
        if pcol == 2 and specialType then 
            self.ctl.specialSpeed = true
        end
    end
    
	local spinAction = {}
	spinAction.actions = {}

    local temp = interval - speedUpTime - upBounceTime
    if specialType then
        local addRandomTime = specialAniTime
        local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0
        table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = addRandomTime,["accelerationTime"] = 10/60,["beginFun"] = onSpecialBegain})
        table.insert(spinAction.actions, {["endSpeed"] = maxSpeed,["totalTime"] = 1000,["accelerationTime"] = 1000})
        
        spinAction.stopDelay = timeleft+(pCol-1)*stopDelay + addRandomTime -- 增加的 delay 时间 -- specialAniTime + 

        self.ExtraStopCD = spinAction.stopDelay+speedDownTime
        self.canFastStop = false
        spinAction.ClearAction = true
    else
        local timeleft = rotateTime - temp > 0 and rotateTime - temp or 0
        spinAction.stopDelay = timeleft+(pCol-1)*stopDelay + self.DelayStopTime
        self.ExtraStopCD = spinMinCD - temp > 0 and spinMinCD - temp or 0
    end

    -- if self.showReSpinBoard then
    --     spinAction.speedDownTime = 3
    -- else
        spinAction.speedDownTime = speedDownTime
    -- end
	spinAction.maxSpeed = maxSpeed
	if self.isTurbo then
        spinAction.speedDownTime = spinAction.speedDownTime * 3/4
        _downBonusT = _downBonusT * 5/6
	end
	spinAction.downBounce = downBounce
	spinAction.downBounceMaxSpeed = downBounceMaxSpeed
	spinAction.downBounceTime = _downBonusT
	spinAction.stopType = 1
	return spinAction
end

function cls:getFreeReel()
    return self.freeType == 2 and map_free_real or nil
end

function cls:getBonusReel()
    local bReel = {
        [1] = {11,10,3,11,3,5,5,6,5,7,8,9,6,3,3,3,3,24,10,11,7,7,4,4,4,4,5,8, 9,10,8,5,5,5,5,9,11,10,7,8,14,6,6,6,6,6,9,10,11,5,6,7,9,3,8,7,4,7,4,9,6,7,4,5,10,9,8,7,6,5,11,3,8,24,8,9,3,8,5,7,10,3,8,4,6,11,4,9,9,5,10,5,4,9,6,3},
        [2] = {7, 8, 7, 14,4,4,6,7,5,11,10,9,6,23,3,3,3,7,8, 7, 11,8,4,4,24,4,20,10,9,8, 3,5,5,5,5,8,7, 11,6,10,8,6,6,6,6,8,9,8, 7,6, 8,11,14, 8,10,8,3,11,4,9,8,11,7,5,8, 3,8,14,6,5,7, 3,10,4,5,9,3,10,23,5, 8, 3,10,6,6,7, 4,9,3,5,8, 9,4,9,6,14},
        [3] = {11,10,2,11,4,4,6,7,5,7,8,9,6,3,3,3,3,24,10,11,7,7,4,4,4,4,14,8, 9,10,8,25,5,5,5,9,11,10,7,8,5,6,6,6,6,25,9,10,11,8,8,7,9,3,8,8,4,7,4,9,8,7,14,5,10,5,8,7,6,5,11,3,8,4,8,9,3,8,5,7,10,3,8,5,6,11,4,9,14,5,10,5,4,9,6,23},
        [4] = {7, 8, 2, 14,4,4,6,7,5,11,10,9,6,3,3,23,3,7,8, 7, 11,8,4,4,4,4,20,10,9,8, 3,5,5,5,5,8,7, 11,6,10,8,6,6,6,6,8,9,8, 7,6, 8,11,4, 8,10,8,23,11,4,9,8,11,7,5,8, 3,8,14,6,5,7, 3,10,4,5,9,3,10,23,5, 8, 3,10,6,6,7, 4,9,3,5,8, 9,4,9,6,14},
        [5] = {11,10,21,11,4,4,6,7,5,7,8,9,6,3,3,3,3,24,10,11,7,27,4,4,4,4,5,8, 9,10,8,5,5,5,5,9,11,10,7,8,14,6,6,26,6,26,9,10,11,8,8,7,9,3,8,8,4,7,4,9,8,7,9,5,10,14,8,7,6,5,11,3,8,4,8,9,3,8,5,7,10,3,8,14,6,11,4,9,5,5,10,5,4,9,6,23},
    }
    local respinReel = {}
    for i = 1, 29 do
        -- respinReel[i] = bReel[i%4 + 1]
        respinReel[i] = bReel[1]
    end
    local manyRespinSymbolReel = {21, 22, 23, 25, 22, 27, 25, 26, 27, 27, 24, 25, 27, 28, 25, 27, 8}
    self.nextCol = self.nextCol or 1
    -- if not self.resetRespinReel then
    --     respinReel[self.nextCol] = manyRespinSymbolReel
    -- end
    return respinReel
end

function cls:getMainReel()
    local real = {
        [1] = {11,10,14,11,2,2,2,2,7,8,9,3,3,3,3,10,11,14,7,4,4,4,4,8,9,10,5,5,5,5,11,14,7,8,6,6,6,6,9,10,11,2,7,14,3,8,2,7,4,9,2,7,5,10,14,2,7,6,11,3,8,4,9,3,8,5,14,10,3,8,6,11,4,9,5,10,14,4,9,6},
        [2] = {7,8,7,14,2,2,2,2,11,10,9,3,3,3,3,8,7,11,14,4,4,4,4,10,9,8,5,5,5,5,7,11,14,10,6,6,6,6,9,8,7,2,11,3,14,10,2,11,4,9,2,11,5,8,14,2,11,6,7,3,10,4,9,3,10,14,5,8,3,10,6,7,4,9,5,8,14,4,9,6},
        [3] = {11,10,14,11,2,2,2,2,7,8,9,3,3,3,3,10,11,14,7,4,4,4,4,8,9,10,5,5,5,5,11,14,7,8,6,6,6,6,9,10,11,2,7,14,3,8,2,7,4,9,2,7,5,10,14,2,7,6,11,3,8,4,9,3,8,5,14,10,3,8,6,11,4,9,5,10,14,4,9,6},
        [4] = {7,8,7,14,2,2,2,2,11,10,9,3,3,3,3,8,7,11,14,4,4,4,4,10,9,8,5,5,5,5,7,11,14,10,6,6,6,6,9,8,7,2,11,3,14,10,2,11,4,9,2,11,5,8,14,2,11,6,7,3,10,4,9,3,10,14,5,8,3,10,6,7,4,9,5,8,14,4,9,6},
        [5] = {11,10,14,11,2,2,2,2,7,8,9,3,3,3,3,10,11,14,7,4,4,4,4,8,9,10,5,5,5,5,11,14,7,8,6,6,6,6,9,10,11,2,7,14,3,8,2,7,4,9,2,7,5,10,14,2,7,6,11,3,8,4,9,3,8,5,14,10,3,8,6,11,4,9,5,10,14,4,9,6},
    }
    self.stackWild = self.stackWild or {}
    for i = 1, 5 do
        if self.stackWild[i] and self.stackWild[i] == 1 then
            real[i] = {1,1,1,1,6,1,1,1,1,5,1,1,1,1,7,1,1,1,1,4,1,1,1,1,5,1,1,1,1,11,1,1,1,1,9,1,1,1,1,8,1,1,1,1,2,1,1,1,1,5,1,1,1,1,10,1,1,1,1,11}
        end
    end
    return real
end

local showSWTime = 45/30 -- 移动到指定位置的时间
local getSWDelay = 0.2 -- 150/30 -- 出现wild 之前的操作 时间

------------------------------------ 初始化 start -------------------------------
function cls:initScene(spinNode)
    local path = self:getPic("csb/base.csb")
	self.mainThemeScene = cc.CSLoader:createNode(path)
    bole.adaptScale(self.mainThemeScene,true)
	self.down_node 	= self.mainThemeScene:getChildByName("down_child")
	bole.adaptReelBoard(self.down_node) -- 竖屏 适配 棋盘的 横屏不需要
	self.shakyNode:addChild(self.mainThemeScene)
    self:adaptLongScreen()
	self.down_child = self.down_node:getChildByName("down_child")

	self.bgRoot = self.mainThemeScene:getChildByName("theme_bg")
    self.baseBg = self.bgRoot:getChildByName("base")
    self.respinGameBg = self.bgRoot:getChildByName("respin")
    self.mapFreeBg = self.bgRoot:getChildByName("map_free")
    self.bgAnim = self.bgRoot:getChildByName("anim_node")
    self.logoSpineNode = self.down_child:getChildByName("logo_spine_node")
    self.baseLogo = self.logoSpineNode:getChildByName("base")
    self.freeLogo = self.logoSpineNode:getChildByName("free")
    local _, s1 = self:addSpineAnimation(self.bgAnim, nil, self:getPic("spine/base/bg_respin/spine"), cc.p(0,0), "animation", nil, nil, nil, true, true)
    local _, s2 = self:addSpineAnimation(self.bgAnim, nil, self:getPic("spine/base/bg/spine"), cc.p(0,0), "animation_1", nil, nil, nil, true, true)
    self.respinBgLoopSpine = s1
    self.bgLoopSpine = s2
    self:addSpineAnimation(self.baseLogo, nil, self:getPic("spine/transition_respin/spine"), cc.p(0,0), "animation", nil, nil, nil, true, true)
    self.baseBg:setVisible(true)
    self.baseLogo:setVisible(true)
    self.freeLogo:setVisible(false)
    self.respinGameBg:setVisible(false)
    self.mapFreeBg:setVisible(false)
    self.curBg = self.baseBg
    self.dialogNode = self.down_child:getChildByName("dialog")
    self.themeAnimateKuang = self.down_child:getChildByName("animate_kuang")

    -- 棋盘
	self.reelRoot = self.down_child:getChildByName("reel_root_node")
	self.reelList = {}
    self.reelList[1] = self.reelRoot:getChildByName("reel_1")
    self.reelList[2] = self.reelRoot:getChildByName("reel_2")
    self.respinBoardList = {}
    self.respinBoardJpLabelList = {}
    self.jpWinLabelSpineListInboard = {}
    for i = 1, 5 do
        self.respinBoardList[i] = self.reelList[2]:getChildByName("board_"..i)
        self.respinBoardJpLabelList[i] = {}
        local kuang = self.respinBoardList[i]:getChildByName("reel_kuang")
        self.respinBoardJpLabelList[i][1] = kuang:getChildByName("jp_label_left")
        self.respinBoardJpLabelList[i][2] = kuang:getChildByName("jp_label_right")

        self.jpWinLabelSpineListInboard[i] = {}
        local _, si1 = self:addSpineAnimation(self.respinBoardJpLabelList[i][1], nil, self:getPic("spine/respin/jp_win_label/spine"), cc.p(0, 0), "animation"..i.."_1", nil, nil, nil, true, false)
        local _, si2 = self:addSpineAnimation(self.respinBoardJpLabelList[i][2], nil, self:getPic("spine/respin/jp_win_label/spine"), cc.p(0, 0), "animation"..i.."_1", nil, nil, nil, true, false)
        self.jpWinLabelSpineListInboard[i][1] = si1
        self.jpWinLabelSpineListInboard[i][2] = si2
    end
    self.reelList[2]:setVisible(false)
    self.earNode = self.reelList[1]:getChildByName("ear_node")
    self.excitationAnimNode = self.reelList[1]:getChildByName("excitation_anim_node")
    
    -- symbol
    self.boardAnimParent  = self.down_child:getChildByName("board_anim_parent")
	self.boardRoot 		  = self.boardAnimParent:getChildByName("board_root")
    self.animateNode      = self.down_child:getChildByName("animate_node")
    self.anticipationNode = self.down_child:getChildByName("anticipation_node")

    -- respin
    self.fakeRespinBoardNodeList = {}
    local symbolIndex = 0
    for index = 2, 5 do
        for i = 1, index do
            symbolIndex = symbolIndex + 1
            local symbolNode = self.respinBoardList[7 - index]:getChildByName("fake_symbol_node")
            self.fakeRespinBoardNodeList[symbolIndex] = symbolNode:getChildByName("symbol_"..i)
        end
    end
    self.respinExcitationNode = self.down_child:getChildByName("respin_excitation_node")
    self.respinSymbolNode = self.down_child:getChildByName("respin_symbol_node")
    self.respinToWinJpAnimNode = self.down_child:getChildByName("to_win_jp_anim_node")
    self.progressiveRoot = self.mainThemeScene:getChildByName("progressive")
    self.respinToWinJpLoopAnimNode = self.progressiveRoot:getChildByName("anim_node")
    self.respinStartDialogNode = self.down_child:getChildByName("respin_start_dialog")

    -- map
    self.mapCollectRoot = self.down_child:getChildByName("map_node")
    self.mapIconNode = self.mapCollectRoot:getChildByName("icons_node")
    -- self.popupNode = self.mapCollectRoot:getChildByName("popup_node")
    -- self.popupNode:setOpacity(0)
    self.rabbitNode = self.mapIconNode:getChildByName("1")
    self.rabbitAnimNode = self.rabbitNode:getChildByName("anim_node")
    self.mapHeadIcon = self.rabbitNode:getChildByName("icon")
    self.mapBuildingNode = self.mapIconNode:getChildByName("2")
    self.mapCollectIconNode = self.mapBuildingNode:getChildByName("icon_node")
    self.mapCollectIconAnimNode = self.mapBuildingNode:getChildByName("anim_node")
    self.progressStartPosX = -233
    self.progressPosY = 0
    self.movePerUnit = 424/maxMapPoint
    self.nextLevelImageList = {}
    self.nextLevelImageSpineList = {}
    for i = 1,5 do
        self.nextLevelImageList[i] = self.mapCollectIconNode:getChildByName("icon"..i)
        local _, ss = self:addSpineAnimation(self.nextLevelImageList[i], 2, self:getPic("spine/map/collect_end/spine"), cc.p(0, 0), "animation"..i, nil, nil, nil, true, true, nil)
        self.nextLevelImageSpineList[i] = ss
    	self.nextLevelImageList[i]:setVisible(false)
    end
    self.collectProgressBg = self.mapCollectRoot:getChildByName("collect_bg_node")
    self.collectProgressNode = self.mapCollectRoot:getChildByName("collect_panel")
    local progress = self.collectProgressNode:getChildByName("progress")
    self.collectCoinProgressImage = progress:getChildByName("coinProgressImage")
    self.collectCoinAniNode = progress:getChildByName("loop_anim_node") -- 进度条循环动画的节点
    self.winCoinAniNode = self.mapCollectRoot:getChildByName("collect_anim_node") -- 收集动画的节点
    self.reelCoinFlyLayer = self.down_child:getChildByName("collectCoin_flyNode")
    self.btn_mapInfo = self.mapCollectRoot:getChildByName("map_info_btn")
    self.btn_unLock = self.mapCollectRoot:getChildByName("btn_unlock")
    self.lockAniNode = self.mapCollectRoot:getChildByName("lock_ani_node")
    local _, s3 = self:addSpineAnimation(self.collectCoinAniNode, 2, self:getPic("spine/map/progress/spine"), cc.p(0, 0), "animation1", nil, nil, nil, true, true, nil)
    self.mapProgressSpine = s3
    -- map free
    self.mapFreeNode = self.down_child:getChildByName("map_free_node")
    self.mapFreeWildNode = self.down_child:getChildByName("map_free_wild_node")

	-- 初始化jackpot
    self.jpList = {}
    self.jackpotLabels = {}
    self.jpAnimNodeList = {}
    self.jpBtnList = {}
    self.jpColorNodeList = {}
    self.jpAnimNodeListDown = {}
    for i = 1, 5 do
        self.jpList[i] = self.progressiveRoot:getChildByName("jp_" .. i)
        local colorNode = self.jpList[i]:getChildByName("color_node")
        self.jpColorNodeList[i] = colorNode
		self.jackpotLabels[i] = colorNode:getChildByName("label_jp" .. i)
		self.jackpotLabels[i].maxWidth = self:getJPLabelMaxWidth(i)
        self.jackpotLabels[i].baseScale = self.jackpotLabels[i]:getScale()
        self.jpAnimNodeList[i] = self.jpList[i]:getChildByName("anim")
        self.jpAnimNodeListDown[i] = colorNode:getChildByName("anim_down")
        self.jpBtnList[i] = self.jpList[i]:getChildByName("btn")
    end
    self:initJpBtn()
    self.baseBgSmall = self.mainThemeScene:getChildByName("base_bg_small")
    self.baseBgSmall:setScale(0.98)
	self:initialJackpotNode()
	self:_initLogoNameNode()
    self:setAdapterPhone()
end

-----------------------------------------------------------------------------------------------------------------------------------
-- @ 长屏logo 点击活动移动相关 add by yt
function cls:_initLogoNameNode(...)
    self.longLogoNode = self.baseBgSmall:getChildByName("anim_node")
    if self:adaptationLongScreen() then
        self.longLogoNode:setVisible(true)

        --self.baseBgSmallAnim = self.baseBgSmall:getChildByName("anim_node")
        local _, s =self:addSpineAnimation(self.longLogoNode, nil, self:getPic("spine/base/long_screen_logo/spine"), cc.p(0,0), "animation", nil, nil, nil, true, true)

        --local _, s = bole.addSpineAnimationInTheme(self.longLogoNode, nil, self._mainViewCtl:getSpineFile("long_logo_name"), cc.p(0, 550), "animation", nil, nil, nil, true, true)
        --bole.adaptTop(self.longLogoNode, -0.2)
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
        if bole.isIphoneX() then
            endscale = self.logoLabelImg.baseScale * 0.82
            endPosY = self.logoLabelImg.basePos.y - 23
        end
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

-- spinLayer
function cls:initSpinLayerBg( )
    if self.mapPoints then
		self:setCollectProgressImagePos(self.mapPoints)
	end
    if self.mapLevel then
		self:setNextCollectTargetImage(self.mapLevel)
    end
    self:enableMapInfoBtn(true)
  --   if self.mapCollectRoot:isVisible() then
		-- self:enableMapInfoBtn(true)
  --   end
    
    self.currentBet = self.ctl:getCurTotalBet()
    if self.currentBet < self.collectUnlockBet then
		self:setCollectPartState(false,false)
		self.isLocked = true
    else
        self:setCollectPartState(true, false)
		self.isLocked = false
	end
	Theme.initSpinLayerBg(self)
end

function cls:initBoardNodes(pBoardConfigList) --gai
    local rowReelCntCfg = {[1] = 2, [3] = 3, [6] = 4, [10] = 5, [15] = 5, [20] = 5, [25] = 5}
    local boardRoot       = self.boardRoot
    local boardConfigList = pBoardConfigList or self.boardConfigList or {}
    local reelZorder      = 100
    self.clipData = {}
    local pBoardNodeList = {}
    -- 棋盘初始化
    for boardIndex, theConfig in ipairs(boardConfigList) do
        local theBoardNode  = nil
        local reelNodes = {}
        if theConfig["row_single"] then -- 一行使用一个裁剪区域 等距才可以
            theBoardNode = cc.Node:create()
            boardRoot:addChild(theBoardNode)
            local rowReelCnt = theConfig["rowReelCnt"]
            local index = 0
            local clipNode = nil
            local reelNode = nil
            for reelIndex,config in ipairs(theConfig["reelConfig"]) do
                 
                if respinBoardIndex[reelIndex] then 
                    rowReelCnt = rowReelCntCfg[reelIndex]
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

        elseif theConfig["reel_single"] then
            local colReelCnt = theConfig["colCnt"]
            self.clipData["reel_single"] = {}
            local reelNode = cc.Node:create()
            reelNode:setLocalZOrder(reelZorder)
            theBoardNode = cc.Node:create()
            boardRoot:addChild(theBoardNode)

            local clipNode = nil
            local reelNode = nil
            for reelIndex,config in ipairs(theConfig["reelConfig"]) do
                if (reelIndex-1)%colReelCnt == 0 then 
                    reelNode = cc.Node:create()
                    reelNode:setLocalZOrder(reelZorder)
                    
                    local vex = {
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
                    local stencil = cc.DrawNode:create()
                    stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))

                    local clipAreaNode = cc.Node:create()
                    clipAreaNode:addChild(stencil)
                    clipNode = cc.ClippingNode:create(clipAreaNode)
                    
                    theBoardNode:addChild(clipNode)	
                    clipNode:addChild(reelNode)
                end
                reelNodes[reelIndex] = reelNode
                -- self.clipData["reel_single"][reelIndex] = {}
                -- self.clipData["reel_single"][reelIndex]["vex"] = vex
                -- self.clipData["reel_single"][reelIndex]["stencil"] = stencil
            end
        else
            self.clipData["normal"] = {}
            local colReelCnt = theConfig["colCnt"]
            local reelNode = cc.Node:create()
            reelNode:setLocalZOrder(reelZorder)
            theBoardNode = cc.Node:create()
            boardRoot:addChild(theBoardNode)
            local clipAreaNode = cc.Node:create()
            for reelIndex,config in ipairs(theConfig["reelConfig"]) do
                local vex = {
                    config["base_pos"], -- 第一个轴的左下角  下左边界
                    cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], 0)),  -- 下右边界
                    cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], config["cellHeight"]*config["symbolCount"])),-- 上右边界
                    cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"]*config["symbolCount"])),-- 上左边界
                }
                if theConfig["allow_over_range"] then
                    vex[1] = cc.pAdd(vex[1], cc.p(-config["cellWidth"], 0))
                    vex[4] = cc.pAdd(vex[4], cc.p(-config["cellWidth"], 0))

                    vex[2] = cc.pAdd(vex[2], cc.p(config["cellWidth"], 0))
                    vex[3] = cc.pAdd(vex[3], cc.p(config["cellWidth"], 0))
                end
                local stencil = cc.DrawNode:create()
                stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))
                clipAreaNode:addChild(stencil)
                reelNodes[reelIndex] = reelNode

                self.clipData["normal"][reelIndex] = {}
                self.clipData["normal"][reelIndex]["vex"] = vex
                self.clipData["normal"][reelIndex]["stencil"] = stencil

                if (reelIndex - 1) % colReelCnt == 0 then
                    -- self:addBoardMaskNode(reelNode, config["base_pos"], reelIndex)
                end
            end
            local clipNode = cc.ClippingNode:create(clipAreaNode)

            theBoardNode:addChild(clipNode) 
            clipNode:addChild(reelNode)
        end 

        theBoardNode.reelNodes     = reelNodes
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
            local colReelCnt = table.nums(theConfig["reelConfig"])
            local boardBasePos, boardW, boardH
            for reelIndex, config in pairs(theConfig["reelConfig"]) do
                if reelIndex == 1 then
                    boardBasePos = config["base_pos"]
                    boardW = config["cellWidth"]*colReelCnt
                    boardH = config["cellHeight"]*config["symbolCount"]
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

    self.featureCanTouch = true
end

function cls:featureBtnCheckCanTouch( ... )
    local canTouch = true
    if not self.featureCanTouch then 
        canTouch = false
    end
    if self.ctl.autoSpin then 
        canTouch = false
    end

    if not self.showBaseSpinBoard then
        return
    end
    if self.isInBonusGame then
        return 
    end
    if self.isFeatureClick then
        return 
    end
    if self.isShowMap then
        return
    end

    return canTouch
end

--------------------------------------------------------
function cls:addBoardMaskNode(parentNode, base_pos, reelIndex)
    -- local boardIndex = math.floor((reelIndex - 1) / 5) + 1
    local startCol = reelIndex
    local endCol = reelIndex + 4

    local index = 0
    for col = startCol, endCol do
        local clipSp = bole.createSpriteWithFile("commonpics/common_black.png")
        clipSp:setAnchorPoint(0, 0)
        clipSp:setScaleX(G_cellWidth / BlackUint.width)
        clipSp:setScaleY(G_cellHeight * 4 / BlackUint.height)
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
    for col = 1, 5 do
        local maskNode = self.baseBoardMaskList[col]
        -- maskNode:stopAllActions()
        maskNode:setVisible(true)
        maskNode:setOpacity(0)
        maskNode:runAction(cc.FadeTo:create(0.2, 150))
    end
end

function cls:hideBoardMaskNodeByCol(pCol)
    if not pCol or not self.baseBoardMaskList then return end

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
    if not self.baseBoardMaskList then return end
    for col = 1, 5 do
        local maskNode = self.baseBoardMaskList[col]
        maskNode:stopAllActions()
        maskNode:setVisible(false)
        maskNode:setOpacity(0)
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

-- 适配机型
function cls:setAdapterPhone( ... )
    -- bole.adaptTop(self.down_child, 0.9)
    -- bole.adaptTop(self.progressiveRoot, 0)

    -- if bole.isWidescreen() then 
        -- self.mainThemeScene:setPositionY(self.mainThemeScene:getPositionY() + 10)
    -- end
end

function cls:adaptLongScreen()
    self.mainThemeSceneBaseY = self.mainThemeScene:getPositionY()
    self.mainThemeSceneRespinY = self.mainThemeSceneBaseY + 10 

    if self:adaptationLongScreen() then
        self.isLongScreen = true
        self.jpBasePos = cc.p(0, 10) -- cc.p(0, -40)
        self.logoBasePos = cc.p(0, 550)

        self.jpRespinPos = cc.p(0, -5)
        self.logoRespinPos = cc.p(0, 520)

        if bole.isIphoneX() then 
            self.jpBasePos = cc.p(0, 20) -- cc.p(0, -40)
            self.logoBasePos = cc.p(0, 520)

            self.jpRespinPos = cc.p(0, -5)
            self.logoRespinPos = cc.p(0, 520)
        end

    else
        self.isLongScreen = false
        self.jpBasePos = cc.p(0, 80)
        self.logoBasePos = cc.p(0, 620)

        self.jpRespinPos = cc.p(0, 120)
        self.logoRespinPos = cc.p(0, 610)

        if bole.isWidescreen() then 
            self.jpBasePos = cc.p(0, 120)
        end

    end
end

-- jp
function cls:getJPLabelMaxWidth(index)
	local jackpotLabelMaxWidth = {450, 270, 270, 270, 270}
	return jackpotLabelMaxWidth[index] or jackpotLabelMaxWidth[#jackpotLabelMaxWidth]
end

function cls:getThemeJackpotConfig()
	local jackpot_config_list =
	{
		link_config = {"grand", "mega", "major", "minor", "mini"},
		allowK = {[194] = false, [694] = false, [1194] = false},
	}
	return jackpot_config_list
end

-- map
function cls:checkLockFeature( bet ) -- 1是循环, 2是解锁, 3是锁上; 屏幕中心; 解锁26帧, 锁上10帧
end

function cls:enableFeatureBtn(enable)
    for k, v in pairs(self.jpBtnList) do
        if bole.isValidNode(v) then
            v:setTouchEnabled(enable)
        end
    end
    self.btn_unLock:setTouchEnabled(enable)
    self.btn_unLock:setVisible(enable)

    self.featureCanTouch = enable
end

-- 数据
function cls:adjustEnterThemeRet(data)
	data.theme_reels = {
        ["main_reel"] = { -- base的假轴 
			[1] = {11,10,14,11,2,2,2,2,7,8,9,3,3,3,3,10,11,14,7,4,4,4,4,8,9,10,5,5,5,5,11,14,7,8,6,6,6,6,9,10,11,2,7,14,3,8,2,7,4,9,2,7,5,10,14,2,7,6,11,3,8,4,9,3,8,5,14,10,3,8,6,11,4,9,5,10,14,4,9,6},
			[2] = {7,8,7,14,2,2,2,2,11,10,9,3,3,3,3,8,7,11,14,4,4,4,4,10,9,8,5,5,5,5,7,11,14,10,6,6,6,6,9,8,7,2,11,3,14,10,2,11,4,9,2,11,5,8,14,2,11,6,7,3,10,4,9,3,10,14,5,8,3,10,6,7,4,9,5,8,14,4,9,6},
			[3] = {11,10,14,11,2,2,2,2,7,8,9,3,3,3,3,10,11,14,7,4,4,4,4,8,9,10,5,5,5,5,11,14,7,8,6,6,6,6,9,10,11,2,7,14,3,8,2,7,4,9,2,7,5,10,14,2,7,6,11,3,8,4,9,3,8,5,14,10,3,8,6,11,4,9,5,10,14,4,9,6},
			[4] = {7,8,7,14,2,2,2,2,11,10,9,3,3,3,3,8,7,11,14,4,4,4,4,10,9,8,5,5,5,5,7,11,14,10,6,6,6,6,9,8,7,2,11,3,14,10,2,11,4,9,2,11,5,8,14,2,11,6,7,3,10,4,9,3,10,14,5,8,3,10,6,7,4,9,5,8,14,4,9,6},
			[5] = {11,10,14,11,2,2,2,2,7,8,9,3,3,3,3,10,11,14,7,4,4,4,4,8,9,10,5,5,5,5,11,14,7,8,6,6,6,6,9,10,11,2,7,14,3,8,2,7,4,9,2,7,5,10,14,2,7,6,11,3,8,4,9,3,8,5,14,10,3,8,6,11,4,9,5,10,14,4,9,6},
		},
        ["free_reel"] = { -- free game的假轴
            [1] = {11,10,11,2,2,2,2,7,8,9,3,3,3,3,10,11,7,4,4,4,4,8,9,10,5,5,5,5,11,7,8,6,6,6,6,9,10,11,2,7,3,8,2,7,4,9,2,7,5,10,2,7,6,11,3,8,4,9,3,8,5,10,3,8,6,11,4,9,5,10,4,9,6},
            [2] = {7,8,7,2,2,2,2,11,10,9,3,3,3,3,8,7,11,4,4,4,4,10,9,8,5,5,5,5,7,11,10,6,6,6,6,9,8,7,2,11,3,10,2,11,4,9,2,11,5,8,2,11,6,7,3,10,4,9,3,10,5,8,3,10,6,7,4,9,5,8,4,9,6},
            [3] = {11,10,11,2,2,2,2,7,8,9,3,3,3,3,10,11,7,4,4,4,4,8,9,10,5,5,5,5,11,7,8,6,6,6,6,9,10,11,2,7,3,8,2,7,4,9,2,7,5,10,2,7,6,11,3,8,4,9,3,8,5,10,3,8,6,11,4,9,5,10,4,9,6},
            [4] = {7,8,7,2,2,2,2,11,10,9,3,3,3,3,8,7,11,4,4,4,4,10,9,8,5,5,5,5,7,11,10,6,6,6,6,9,8,7,2,11,3,10,2,11,4,9,2,11,5,8,2,11,6,7,3,10,4,9,3,10,5,8,3,10,6,7,4,9,5,8,4,9,6},
            [5] = {11,10,11,2,2,2,2,7,8,9,3,3,3,3,10,11,7,4,4,4,4,8,9,10,5,5,5,5,11,7,8,6,6,6,6,9,10,11,2,7,3,8,2,7,4,9,2,7,5,10,2,7,6,11,3,8,4,9,3,8,5,10,3,8,6,11,4,9,5,10,4,9,6},
		},
    }
	self.tipBet = data.bonus_level[3]

    if data["free_game"] then
        self.freeType = data["free_game"]["type"]
        if data["map_info"] and data["map_info"]["avg_bet"] then
            self.superAvgBet = data["map_info"].avg_bet
        end

        self.mapFreeAllWin = data["free_game"]["total_win"]
        if data["free_game"]["free_spins"] and data["free_game"]["free_spins"] >= 0 then
            self.freeSavedCoinState = data["free_game"]["saved_coin_state"]
            if data["free_game"]["free_spins"] ~= data["free_game"]["free_spin_total"] and data["bonus_game"] and data["bonus_game"]["wheel_bonus"] and data["bonus_game"]["wheel_bonus"]["win_free"] and data["bonus_game"]["wheel_bonus"]["win_free"]["free_spins"] then 
                self.isfreeRetrigerResume = true
            end

			if data["bonus_game"] and data["free_game"]["free_spins"] == data["free_game"]["free_spin_total"] then
                data["first_free_game"] = {}
				data["first_free_game"]["free_spins"] 		= data["free_game"]["free_spins"]
 				data["first_free_game"]["free_spin_total"] 	= data["free_game"]["free_spin_total"]
 				data["first_free_game"]["base_win"] 		= data["free_game"]["base_win"]
 				data["first_free_game"]["total_win"] 		= data["free_game"]["total_win"]
 				data["first_free_game"]["bet"] 				= data["free_game"]["bet"]
 				data["first_free_game"]["item_list"] 		= data["free_game"]["item_list"]
 				data["first_free_game"]["spin_type"] 		= data["free_game"]["spin_type"]
                data["free_game"] = nil 
            elseif self.freeType == 1 then
                local realItemList = data["free_game"]["item_list"]
                data["free_game"]["item_list"] = tool.tableClone(realItemList)
                self.ctl.freeSpeical = self:getSpecialTryResume(realItemList)
            end
        end
        self.enterThemeSWPos = data.sticky_wild and tool.tableClone(data.sticky_wild) or {}
    end

    if data["map_info"] then
        self.mapPoints = data["map_info"]["map_points"]
      
        self.mapLevel = data["map_info"]["map_level"]
        -- if self.mapPoints and self.mapPoints >= maxMapPoint and self.mapLevel and self.mapLevel == 0 then
        --     self.mapLevel = maxMapLevel
        -- end
        if data["map_info"] then
            self.mapFreeExtraSpins = data["map_info"]["extra_fg"] or 0
        end
    end

    if data.bonus_game and data.bonus_game.map_wheel_spin and data.bonus_game.map_wheel_spin.extra_fg and data.bonus_game.map_wheel_spin.extra_fg > 0 then
        self.mapFreeExtraSpins = self.mapFreeExtraSpins > 0 and self.mapFreeExtraSpins - 1 or 0
    end

    self.collectUnlockBet = data["bonus_level"][3]
	return data
end

function cls:getSpecialTryResume(realItemList)
    local specials = { [specialSymbol.bonus] = {} }
    for col, colItemList in ipairs(realItemList) do
        for row, theKey in ipairs(colItemList) do
            if theKey == specialSymbol.bonus then
                specials[theKey][col] = specials[theKey][col] or {}
                specials[theKey][col][row] = true
            end
        end
    end
    return specials

end
function cls:onExit( )
	if self.shaker then
		self.shaker:stop()
    end
	if self.bonus then
		self.bonus:onExit()
    end
    
    if self.miniReel then 
		if self.miniReel.scheduler then 
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.miniReel.scheduler)
			self.miniReel.scheduler = nil
		end
    end
    
	Theme.onExit(self)
end

function cls:adjustTheme(data)
    if data and data.free_game then -- 断线重连数据
		self.sBonusCount = data.free_game.sbonus_count
	end
    self.isOverInitGame = true
    self.unlockRow = 4
	self:checkLockFeature()
	self:changeSpinBoard(SpinBoardType.Normal)
	if not self.ctl:noFeatureLeft() then
		self:enableFeatureBtn(false)
		self:enableStoreBtn(false)
    end
    self:getJpUnlockData(data["bonus_level"])
    self:updateJpLockState(false, 1)
end

function cls:hideBonusNode(free,bonus)
    self.ctl:resetCurrentReels(free,bonus) -- 更改 bonus 的棋盘
end

function cls:changeSpinBoard(pType)
	self:clearAnimate()

    self.mainThemeScene:setPositionY(self.mainThemeSceneBaseY)
    if pType == SpinBoardType.Normal then
        self:setScaleInSuperFree4(1)
        self.progressiveRoot:setPositionY(self.jpBasePos.y)
        self.reelList[1]:setVisible(true)
        self.reelList[2]:setVisible(false)
        self.mapCollectRoot:setVisible(true)
		self.showFreeSpinBoard = false
		self.showBaseSpinBoard = true
        self.showMapFreeSpinBoard = false
        self.showReSpinBoard = false
        self.isInbase = true
		if self.spinLayer ~= self.spinLayerList[1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[1]
			self.spinLayer:Active()
        end
        
        if bole.isValidNode(self.bgLoopSpine) then
            bole.spChangeAnimation(self.bgLoopSpine, "animation_1", true)
        else
            local _, s = self:addSpineAnimation(self.bgAnim, nil, self:getPic("spine/base/bg/spine"), cc.p(0,0), "animation_1", nil, nil, nil, true, true)
            self.bgLoopSpine = s
        end
        if bole.isValidNode(self.respinBgLoopSpine) then
            self.respinBgLoopSpine:setVisible(false)
        end

        self.initBoardIndex = 1
        self.respinGameBg:setVisible(false)
        self.baseBg:setVisible(true)
        self.mapFreeBg:setVisible(false)

        self.reelRoot:setVisible(true)
        self.boardRoot:setVisible(true)
        self.baseLogo:setVisible(true)
        self.freeLogo:setVisible(false)
        self.progressiveRoot:setVisible(true)
        self.mapFreeNode:removeAllChildren()
        self.mapFreeWildNode:removeAllChildren()
        if bole.isValidNode(self.wheelMaskSpine) then
            self.wheelMaskSpine:removeFromParent()
            self.wheelMaskSpine = nil
        end

        self.baseBgSmall:setPositionY(self.logoBasePos.y)
        if self.isLongScreen then
            self.baseBgSmall:setVisible(true)
        else
            self.baseBgSmall:setVisible(false)
        end
        self.jpWinSpineList = self.jpWinSpineList or {}
        for k, v in pairs(self.jpWinSpineList) do
            if bole.isValidNode(v) then
                v:removeFromParent()
            end
        end
        for k, v in pairs(self.jpAnimNodeListDown) do
            if bole.isValidNode(v) then
                v:removeAllChildren()
            end
        end
        self.respinToWinJpLoopAnimNode:removeAllChildren()
        self.jpWinSpineList = {}
    elseif pType == SpinBoardType.ReSpin then
        self:setScaleInSuperFree4(1)
        self.reelList[1]:setVisible(false)
        self.reelList[2]:setVisible(true)
        self.mapCollectRoot:setVisible(false)
        self.baseBgSmall:setPositionY(self.logoRespinPos.y)
        if self.isLongScreen then
            self.baseBgSmall:setVisible(true)
        else
            self.baseBgSmall:setVisible(false)
        end
        self.baseLogo:setVisible(false)
        self.progressiveRoot:setPositionY(self.jpRespinPos.y)
        for i = 1, 5 do
            self.respinBoardList[i]:setVisible(i == 1 or i == 2)
            for k, v in pairs(self.respinBoardJpLabelList[i]) do
                v:setVisible(false)
            end
        end
        self.mainThemeScene:setPositionY(self.mainThemeSceneRespinY)

		self.showReSpinBoard = true
        self.showMapFreeSpinBoard = false
        self.showBaseSpinBoard = false
        self.isInbase = false
        if self.spinLayer ~= self.spinLayerList[6] then
            self.spinLayer:DeActive()
            self.spinLayer = self.spinLayerList[6]
            self.spinLayer:Active()
        end

        if bole.isValidNode(self.bgLoopSpine) then
            bole.spChangeAnimation(self.bgLoopSpine, "animation_2", true)
        else
            _, self.bgLoopSpine = self:addSpineAnimation(self.bgAnim, nil, self:getPic("spine/base/bg/spine"), cc.p(0,0), "animation_2", nil, nil, nil, true, true)
        end
        if bole.isValidNode(self.respinBgLoopSpine) then
            self.respinBgLoopSpine:setVisible(true)
        end

        self.lockedReels = {}
        self.initBoardIndex = 6
        
        self.respinGameBg:setVisible(true)
        self.baseBg:setVisible(false)
        self.mapFreeBg:setVisible(false)
        self.ctl:resetCurrentReels(false, true)
    elseif pType == SpinBoardType.Map_FreeSpin then
        self.progressiveRoot:setPositionY(self.jpBasePos.y)
		self.showMapFreeSpinBoard = true
        self.showReSpinBoard = false
        self.showBaseSpinBoard = false
        self.mapCollectRoot:setVisible(false)
        self.baseBgSmall:setPositionY(self.logoBasePos.y)
        if self.isLongScreen then
            self.baseBgSmall:setVisible(true)
        else
            self.baseBgSmall:setVisible(false)
        end

        self.isInbase = false
        local mapLevel = self.mapLevel
        if mapLevel == 0 then
            mapLevel = 100
        end

		if self.spinLayer ~= self.spinLayerList[mapFreeSpinBoardCfg[mapLevel][1] + 1] then
			self.spinLayer:DeActive()
			self.spinLayer = self.spinLayerList[mapFreeSpinBoardCfg[mapLevel][1] + 1]
            self.spinLayer:Active()
            self.initBoardIndex = mapFreeSpinBoardCfg[mapLevel][1] + 1
        end
        if bole.isIphoneX() and self.initBoardIndex and self.initBoardIndex > 3 then 
            self.baseBgSmall:setVisible(false)
        end

        if bole.isValidNode(self.bgLoopSpine) then
            bole.spChangeAnimation(self.bgLoopSpine, "animation_3", true)
        else
            _, self.bgLoopSpine = self:addSpineAnimation(self.bgAnim, nil, self:getPic("spine/base/bg/spine"), cc.p(0,0), "animation_3", nil, nil, nil, true, true)
        end
        if bole.isValidNode(self.respinBgLoopSpine) then
            self.respinBgLoopSpine:setVisible(false)
        end

        -- if self.superAvgBet then
        --     self.ctl:setPointBet(self.superAvgBet)-- 更改 锁定的bet
        --     self.ctl.footer:changeFreeSpinLayout3()-- 隐藏掉  footer bet
        -- end

        self.baseLogo:setVisible(false)
        self.freeLogo:setVisible(false)

        self.respinGameBg:setVisible(false)
        self.baseBg:setVisible(false)
        self.mapFreeBg:setVisible(true)

        if bole.isValidNode(self.wheelMaskSpine) then
            self.wheelMaskSpine:removeFromParent()
            self.wheelMaskSpine = nil
        end
        self:setScaleInSuperFree4(0.75)
        self:initMapFreeSpinScene()
	end
end

function cls:initMapFreeSpinScene()
    self.reelRoot:setVisible(false)
    self.progressiveRoot:setVisible(false)
    local mapLevel = self.mapLevel
    if mapLevel == 0 then
        mapLevel = 100
    end
    local boardCount = mapFreeSpinBoardCfg[mapLevel][1] -- 棋盘数
    local boardScale = mapFreeBoardPosCfg[boardCount][1] -- 缩放
    local boardPosList = mapFreeBoardPosCfg[boardCount][2] -- 位置
    local wildCfg = mapFreeSpinBoardCfg[mapLevel][2] -- 显示wild的位置
    self.stickyWildList = {}
    for k, v in pairs(boardPosList) do
        local path = self:getPic("csb/map_free_board.csb")
        local boardNode = cc.CSLoader:createNode(path)
        boardNode:setPosition(cc.p(0, v))
        boardNode:setScale(boardScale)
        self.mapFreeWildNode:setScale(boardScale)
        self.mapFreeNode:addChild(boardNode)

        for col, tag in pairs(wildCfg) do
            if tag == 1 then
                for i = 1, freeRowCnt do
                    local wild = bole.createSpriteWithFile("#theme194_s_1.png")
                    local pos = self:getCellPos(col, i)
                    wild:setPosition(pos)
                    self.mapFreeWildNode:addChild(wild)
                end
            end
        end
    end
end

function cls:resetPointBet()
    if self.freeType and self.freeType == 1 then return end
    if self.superAvgBet then 
        self.ctl:setPointBet(self.superAvgBet)
        self.ctl.footer:changeFreeSpinLayout3()
    end
end

------------------------------------ 初始化 end -------------------------------

----------------------------- jp锁 start --------------------------
function cls:getReverseOrder(arr)
    arr = arr or {}
    local list = tool.tableClone(arr)
    local midleIndex = math.floor(#list/2)
    for i = 1, midleIndex do
        local data = list[i]
        list[i] = list[#list + 1 - i]
        list[#list + 1 - i] = data
    end
    return list
end

local jpLockDataCfg = {
    6, 5, 4, 2, 1
}

function cls:getJpUnlockData(bonus_level)
    -- local list = tool.tableClone(bonus_level)
    -- table.remove(list, 1)
    -- local fixList = self:getReverseOrder(list)
    -- self.jpUnlockData = {}
    -- for k, v in pairs(fixList) do
    --     local data = {v, 1}
    --     table.insert(self.jpUnlockData, data)
    -- end

    local list = tool.tableClone(bonus_level)
    self.jpUnlockData = self.jpUnlockData or {}
    local fixList = {}
    for i = 1, 5 do
        fixList[i] = list[jpLockDataCfg[i]]
    end
    for k, v in pairs(fixList) do
        local data = {v, 1}
        table.insert(self.jpUnlockData, data)
    end
end

function cls:updateJpLockData(bonus_level)
    local list = tool.tableClone(bonus_level)
    -- local list = self:getReverseOrder(bonus_level)
    for i = 1, 5 do
        self.jpUnlockData[i][1] = list[jpLockDataCfg[i]]
    end
end

function cls:updateJpLockState(isAnimate, delay)
    self.jpLockSpine = self.jpLockSpine or {}
    if not self.jpUnlockData then return end
    local curBet = self.ctl:getCurBet()
    local popupLock = 0
    local popupUnlock = 0
    local playMusic = false
    for i = 1, 5 do
        if curBet >= self.jpUnlockData[i][1] then -- 解锁
            if self.jpUnlockData[i][2] == 0 then -- 0 未解锁  1 -- 已解锁
                self.jpUnlockData[i][2] = 1
                if popupUnlock == 0 then
                    popupUnlock = i
                end
                local spineFile = self:getPic("spine/base/jp_lock/spine")
                if isAnimate then -- 解锁动画
                    if not playMusic then
                        self:playMusic(self.audio_list.jp_unlock)
                        playMusic = true
                    end
                    local delay = 20/30
                    self:runAction(cc.Sequence:create(
                        cc.CallFunc:create(function( ... )
                            local jpIndex = i <= 1 and 1 or 2
                            local animateName = "animation3_"..jpIndex
                            -- local jpIndex = i 
                            -- local animateName = "animation"..jpIndex.."_1"
                            if bole.isValidNode(self.jpLockSpine[i]) then
                                bole.spChangeAnimation(self.jpLockSpine[i], animateName, false)
                            else
                                local _, s = self:addSpineAnimation(self.jpAnimNodeList[i], nil, spineFile, cc.p(0, 10), animateName, nil, nil, nil, false, false)
                                self.jpLockSpine[i] = s
                            end
                        end),
                        cc.DelayTime:create(delay),
                        cc.CallFunc:create(function( ... )
                            self.jpColorNodeList[i]:setColor(cc.c3b(255, 255, 255))
                        end)
                    ))
                else
                    self.jpColorNodeList[i]:setColor(cc.c3b(255, 255, 255))
                end
            end
        else
            if self.jpUnlockData[i][2] == 1 then -- 0 未解锁  1 -- 已解锁
                self.jpUnlockData[i][2] = 0
                popupLock = i
                local spineFile = self:getPic("spine/base/jp_lock/spine")
                if isAnimate then -- 上锁动画
                    if not playMusic then
                        self:playMusic(self.audio_list.jp_lock)
                        playMusic = true
                    end
                    local delay = 10/30
                    self:runAction(cc.Sequence:create(
                        cc.CallFunc:create(function( ... )
                            local jpIndex = i <= 1 and 1 or 2
                            local animateName = "animation4_"..jpIndex
                            -- local jpIndex = i 
                            -- local animateName = "animation"..jpIndex.."_2"
                            if bole.isValidNode(self.jpLockSpine[i]) then
                                bole.spChangeAnimation(self.jpLockSpine[i], animateName, false)
                            else
                                local _, s = self:addSpineAnimation(self.jpAnimNodeList[i], nil, spineFile,  cc.p(0, 10), animateName, nil, nil, nil, true, false)
                                self.jpLockSpine[i] = s
                            end
                        end),
                        cc.DelayTime:create(delay),
                        cc.CallFunc:create(function( ... )
                            self.jpColorNodeList[i]:setColor(cc.c3b(130, 130, 130))
                        end)
                    ))
                else
                    if bole.isValidNode(self.jpLockSpine[i]) then
                        bole.spChangeAnimation(self.jpLockSpine[i], "animation1", false)
                    else
                       local _, ssss = self:addSpineAnimation(self.jpAnimNodeList[i], nil, spineFile,  cc.p(0, 10), "animation1", nil, nil, nil, true, false)
                        self.jpLockSpine[i] = ssss
                    end
                    self.jpColorNodeList[i]:setColor(cc.c3b(130, 130, 130))
                end
            end
        end
    end
    self:jpLockPopup(popupLock, 1, delay)
    self:jpLockPopup(popupUnlock, 2, delay)
end

function cls:initJpBtn()
    for i = 1, 5 do
        local btn = self.jpBtnList[i]
        local function onTouch()
            if not self:featureBtnCheckCanTouch() then return end

            if self.jpUnlockData[i][2] == 0 then -- 未解锁
                self.ctl:setCurBet(self.jpUnlockData[i][1])
            elseif self.jpUnlockData[i][2] == 1 then -- 已解锁
                return
            end
        end
        btn:addTouchEventListener(onTouch)
    end
end

local jpPopupScaleCfg = {
    [1] = {0.65, 0.75, 0.7, 0.9, 1, cc.p(50, -64)}, -- lock   1-5:scale   6:position
    [2] = {0.65, 0.75, 0.7, 0.9, 1, cc.p(-15, -44)} -- unlock
}

local jpImageNameCfg = {
    [1] = "#theme194_j_grand.png",
    [2] = "#theme194_j_maxi.png",
    [3] = "#theme194_j_major.png",
    [4] = "#theme194_j_minor.png",
    [5] = "#theme194_j_mini.png"
}

function cls:jpLockPopup(index, lock, delay) -- lock 1-上锁  2-解锁
    if index == 0 then return end
    self.showJpTipsList = self.showJpTipsList or {}
    if self.showJpTipsList and #self.showJpTipsList > 0 then
        for k, v in pairs(self.showJpTipsList) do
            if bole.isValidNode(v) then
                v:stopAllActions()
                v:removeFromParent()
            end
        end
        self.showJpTipsList = {}
    end
    local rootNode = cc.Node:create()
    local x = self.jpList[index]:getPositionX()
    local y = self.jpList[index]:getPositionY()
    rootNode:setPosition(cc.p(x, y))
    local fileName = lock == 1 and "#theme194_jackpot_p01.png" or "#theme194_jackpot_p02.png"
    local bg = bole.createSpriteWithFile(fileName)
    local jpImage = bole.createSpriteWithFile(jpImageNameCfg[index])
    bg:setAnchorPoint(0.5, 1)
    jpImage:setScale(jpPopupScaleCfg[lock][index])
    jpImage:setPosition(jpPopupScaleCfg[lock][6])
    rootNode:addChild(bg)
    rootNode:addChild(jpImage)
    rootNode:setScale(0.0001, 0.0001)
    self.progressiveRoot:addChild(rootNode)
    rootNode:runAction(cc.Sequence:create(
        cc.DelayTime:create(delay),
        cc.CallFunc:create(function( ... )
            if lock == 2 then return end
            local spineFile = self:getPic("spine/base/jp_lock/spine")
            if bole.isValidNode(self.jpLockSpine[index]) then
                bole.spChangeAnimation(self.jpLockSpine[index], "animation2", false)
                -- bole.spChangeAnimation(self.jpLockSpine[index], "animation"..index.."_3", false)
            else
                local _, s = self:addSpineAnimation(self.jpAnimNodeList[index], nil, spineFile,  cc.p(0, 0), "animation2", nil, nil, nil, true, false)
                self.jpLockSpine[index] = s
                -- _, self.jpLockSpine[index] = self:addSpineAnimation(self.jpAnimNodeList[index], nil, spineFile,  cc.p(0, 0), "animation"..index.."_3", nil, nil, nil, true, false)
            end
        end),
        -- cc.EaseBackIn:create(cc.ScaleTo:create(0.2, 1, 1)),
        cc.ScaleTo:create(0.2, 1.2),
        cc.ScaleTo:create(0.1, 1),
        cc.DelayTime:create(2),
        cc.EaseBackOut:create(cc.ScaleTo:create(0.2, 0.0001, 0.0001)),
        cc.DelayTime:create(0.3),
        cc.RemoveSelf:create()
    ))
    table.insert(self.showJpTipsList, rootNode)
end

-- node需要置灰色的节点
-- recover 恢复原本的颜色
-- all 该节点下的所有节点
function cls:setSpriteGrayOrRemoveGray( node, recover, all )
	if not node then return end

    local vertShaderByteArray = "\n"..
        "attribute vec4 a_position; \n" ..
        "attribute vec2 a_texCoord; \n" ..
        "attribute vec4 a_color; \n"..
        "#ifdef GL_ES  \n"..
        "varying lowp vec4 v_fragmentColor;\n"..
        "varying mediump vec2 v_texCoord;\n"..
        "#else                      \n" ..
        "varying vec4 v_fragmentColor; \n" ..
        "varying vec2 v_texCoord;  \n"..
        "#endif    \n"..
        "void main() \n"..
        "{\n" ..
        "gl_Position = CC_PMatrix * a_position; \n"..
        "v_fragmentColor = a_color;\n"..
        "v_texCoord = a_texCoord;\n"..
        "}"

    -- 置灰色
    local flagShaderByteArray = "#ifdef GL_ES \n" ..
        "precision mediump float; \n" ..
        "#endif \n" ..
        "varying vec4 v_fragmentColor; \n" ..
        "varying vec2 v_texCoord; \n" ..
        "void main(void) \n" ..
        "{ \n" ..
        "vec4 c = texture2D(CC_Texture0, v_texCoord); \n" ..
        "gl_FragColor.xyz = vec3(0.4 * c.r + 0.4 * c.g + 0.4 * c.b); \n"..
        "gl_FragColor.w = c.w; \n"..
        "}"

    -- 移除置灰frag  
    local pszRemoveGrayShader = "#ifdef GL_ES \n" ..  
        "precision mediump float; \n" ..  
        "#endif \n" ..  
        "varying vec4 v_fragmentColor; \n" ..  
        "varying vec2 v_texCoord; \n" ..  
        "void main(void) \n" ..  
        "{ \n" ..  
        "gl_FragColor = texture2D(CC_Texture0, v_texCoord); \n" ..  
        "}"     

    local glProgram = nil

    if recover then
    	glProgram = cc.GLProgram:createWithByteArrays(vertShaderByteArray,pszRemoveGrayShader)
    else
    	glProgram = cc.GLProgram:createWithByteArrays(vertShaderByteArray,flagShaderByteArray)	
    end

    glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
    glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR,cc.VERTEX_ATTRIB_COLOR)
    glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD,cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
    glProgram:link()
    glProgram:updateUniforms()
    node:setGLProgram( glProgram )

    if all then
    	local children = node:getChildren()
    	for key, value in ipairs(children) do
    		self:setSpriteGrayOrRemoveGray(value, recover, all)
    	end
    end
end

----------------------------- jp锁 end --------------------------

------------------------------------ bonus symbol atsrt -------------------------------

function cls:showBigScalePrize(respinSymbolMiniReel, winIndex, index)
    local root = respinSymbolMiniReel:getChildByName("root")
    local slip = root:getChildByName("panel")
    local prizeNode = slip:getChildByName("prize_node")

    prizeNode:setVisible(false)
    if winIndex == 1 then
        local bg = bole.createSpriteWithFile("#theme194_s_19_1.png")
        root:addChild(bg)
        local label = libUI.createFont(root, self:getPic("font/imagestheme194_bonus_z.fnt"), cc.p(0, 0), 1, 1000)
        local coinsMulti = multiCfg[index - 19] or 0
        local coinCount = coinsMulti * self.ctl:getCurBet()
        local numString = FONTS.formatByCount4(coinCount, 4, true)
        label:setString(numString)
    elseif winIndex == 2 then
        local bg = bole.createSpriteWithFile("#theme194_s_19_1.png")
        root:addChild(bg)
        local imageFile = self.showReSpinBoard and "#theme194_s_0.png" or "#theme194_s_15.png"
        local sprite = bole.createSpriteWithFile(imageFile)
        root:addChild(sprite)
    end

    root:setScale(0.7)
    root:runAction(cc.Sequence:create(
        cc.ScaleTo:create(0.2, 1.3),
        cc.ScaleTo:create(0.3, 0.88)
    ))
end

function cls:speedUpRollBonus(respinSymbol, index, col, row, scale)
    if self.hadStopBonusRoll then return end

    local scaleSpineDelay = 40/30
    local scaleSpine
    local delay = 0
    if index == 13 then
        delay = scaleSpineDelay/2
    end
    self:runAction(cc.Sequence:create(
        cc.CallFunc:create(function( ... )
            local spineFile = self:getPic("spine/item/19/spine")
            local _, ss = self:addSpineAnimation(respinSymbol, nil, spineFile, cc.p(0, 0), "animation1", nil, nil, nil, true, false)
            scaleSpine = ss
            local delay1 = 10/30
            local delay2 = 13/30
            if bole.isValidNode(respinSymbol) then
                respinSymbol:runAction(cc.Sequence:create(
                    cc.ScaleTo:create(delay1, 1.3),
                    cc.ScaleTo:create(delay2, 1)
                ))
            end
        end),
        cc.DelayTime:create(scaleSpineDelay),
        cc.CallFunc:create(function( ... )
            if bole.isValidNode(scaleSpine) then
                bole.spChangeAnimation(scaleSpine, "animation2", false)
            end
        end),
        cc.DelayTime:create(delay),
        cc.CallFunc:create(function( ... )
            if index == 13 then
                if bole.isValidNode(scaleSpine) then
                    bole.spChangeAnimation(scaleSpine, "animation3", false)
                end
            end
        end),
        cc.DelayTime:create(scaleSpineDelay/2),
        cc.CallFunc:create(function( ... )
            if bole.isValidNode(scaleSpine) then
                scaleSpine:removeFromParent()
            end
        end)
    ))

    self.bonusSymbolDelay = 2 + col * 0.15
    self.respinSymbolData = {}
    for i = 1, 10 do
        self.respinSymbolData[i] = i
    end

    local respinSymbolMiniReel = self:createBonusSymbol(respinSymbol, index, scale)
    local root = respinSymbolMiniReel:getChildByName("root")
    local slip = root:getChildByName("panel")
    local prizeNode = slip:getChildByName("prize_node")

    self.respinSymbolItemList = {}
    for k, node in pairs(prizeNode:getChildren()) do 
		local keyValue = self.respinSymbolData[k]
        table.insert(self.respinSymbolItemList,{keyValue, node}) -- key 和相应的 item 从0 开始
    end

    local winIndex = 2
    if index >= 20 then
        winIndex = 1
    end

    local data = {
		["itemCount"]           = 12, -- 上下加一个 cell 之后的个数
		["key"]                 = winIndex,
		["finshRollSumLength"]  = 1, -- 结束阶段会滚过几遍总共的Count
		["cellSize"]            = cc.p(miniReelHeight,miniReelHeight),
		["delayBeforeSpin"]     = 0.0,   --开始旋转前的时间延迟
		["upBounce"]            = 0,    --开始滚动前，向上滚动距离
		["upBounceTime"]        = 0,   --开始滚动前，向上滚动时间
		["speedUpTime"]         = 0.5,   --加速时间
		["rotateTime"]          = 0.5,   -- 匀速转动的时间之和
		["maxSpeed"]            = 6/6*miniReelHeight*60,    --每一秒滚动的距离
		["downBounce"]          = 0,  --滚动结束前，向下反弹距离  都为正数值
		["speedDownTime"]       = 1, -- 4
		["downBounceTime"]      = 0,
		["direction"]           = 2,
		["startIndex"]          = 1,
    }

    local finishSpin = function()
        self:showBigScalePrize(respinSymbolMiniReel, winIndex, index)
        return
    end

    self.miniReel = BaseReel.new(self, self.respinSymbolItemList, data, finishSpin)
    -- self.miniReel:resetCurData(nil, )
    self.miniReel:startSpin()
    respinSymbol.miniReel = self.miniReel

    self:playMusic(self.audio_list.symbol_bonus)
    self.baseBonusSymbolList = self.baseBonusSymbolList or {}
    table.insert(self.baseBonusSymbolList, respinSymbol)
end

function cls:stopBonusRoll()
    self.hadStopBonusRoll = true
    local scale = 1
    if self.showReSpinBoard then
        scale = respinSymbolScale
    end

    local itemList = tool.tableClone(self.bonusItemList)
    if self.showReSpinBoard then
        itemList = tool.tableClone(self.bonusItemListInrespin)
    end

    for col, colList in pairs(itemList) do
        for row, key in pairs(colList) do
            if key >= 13 then
                local winIndex = 2
                if key >= 20 then
                    winIndex = 1
                end
                local cell = self.spinLayer.spins[col]:getRetCell(row)

                local respinSymbolMiniReel
                if  bole.isValidNode(cell.bonus) and cell.miniReel then
                    cell.miniReel:stopIdleAnim()
                    respinSymbolMiniReel = cell.bonus
                else
                    respinSymbolMiniReel = self:createBonusSymbol(cell, key, scale)
                end

                local root = respinSymbolMiniReel:getChildByName("root")
                local slip = root:getChildByName("panel")
                local prizeNode = slip:getChildByName("prize_node")
                local prizeList = {}
                for i = 1, 10 do
                    prizeList[i] = prizeNode:getChildByName("prize_"..i)
                end
                for k, v in pairs(stopPosCfg[winIndex]) do
                    prizeList[k]:setPosition(cc.p(0, v))
                end

                self:showBigScalePrize(respinSymbolMiniReel, winIndex, key)
            end
        end
    end
end

function cls:createBonusSymbol(cell, key, scale, fake, pos)
    local path = self:getPic("csb/respin_symbol.csb")
    local respinSymbolMiniReel = cc.CSLoader:createNode(path)
    local root = respinSymbolMiniReel:getChildByName("root")
    local slip = root:getChildByName("panel")
    local prizeNode = slip:getChildByName("prize_node")

    self.respinSymbolCoinsList = {}
    self.respinSymbolImageList = {}
    self.fnt = {}
    self.image = {}

    for i = 1, 6 do
        local fakeIndex = math.random(20, 36)
        local coinsMulti = multiCfg[fakeIndex - 19] or 0
        local coinCount = coinsMulti * self.ctl:getCurBet()
        local numString = FONTS.formatByCount4(coinCount, 4, true)
        self.respinSymbolCoinsList[i] = prizeNode:getChildByName("prize_"..i)
        self.fnt[i] = self.respinSymbolCoinsList[i]:getChildByName("prize_"..i)
        self.fnt[i]:setString(numString)
    end

    local imageFile = self.showReSpinBoard and "#theme194_s_0.png" or "#theme194_s_15.png"
    for i = 7, 10 do
        self.respinSymbolImageList[i] = prizeNode:getChildByName("prize_"..i)
        self.image[i] = self.respinSymbolImageList[i]:getChildByName("prize_"..i)
        bole.updateSpriteWithFile(self.image[i], imageFile)
    end

    if key >= 20 then -- 设置赢钱fnt
        local coinsMulti = multiCfg[key - 19] or 0
        local coinCount = coinsMulti * self.ctl:getCurBet()
        local numString = FONTS.formatByCount4(coinCount, 4, true)
        self.fnt[1]:setString(numString)
        self.fnt[4]:setString(numString)
    end

    respinSymbolMiniReel:setScale(scale)
    cell:addChild(respinSymbolMiniReel)
    cell.bonus = respinSymbolMiniReel

    if pos then
        respinSymbolMiniReel:setPosition(pos)
    end
    if not fake then
        self.baseBonusSymbolList = self.baseBonusSymbolList or {}
        table.insert(self.baseBonusSymbolList, cell)
    end
    return respinSymbolMiniReel
end

function cls:createRespinSymbol(cell, data, respinSymbolScale, fake, pos)
    local respinSymbolMiniReel = self:createBonusSymbol(cell, data, respinSymbolScale)
    local winIndex = 2
    if data >= 20 then
        winIndex = 1
    end
    local root = respinSymbolMiniReel:getChildByName("root")
    local slip = root:getChildByName("panel")
    local prizeNode = slip:getChildByName("prize_node")
    local prizeList = {}
    for i = 1, 10 do
        prizeList[i] = prizeNode:getChildByName("prize_"..i)
    end
    for k, v in pairs(stopPosCfg[winIndex]) do
        prizeList[k]:setPosition(cc.p(0, v))
    end
    self:showBigScalePrize(respinSymbolMiniReel, winIndex, data)
    if pos then
        respinSymbolMiniReel:setPosition(pos)
    end
    if not fake then
        bole.updateSpriteWithFile(cell.sprite, "#theme194_s_0.png")
        self.respinSymbolListInRespinCell = self.respinSymbolListInRespinCell or {}
        table.insert(self.respinSymbolListInRespinCell, respinSymbolMiniReel)
    else
        self.fakeRespinSymbol = self.fakeRespinSymbol or {}
        table.insert(self.fakeRespinSymbol, respinSymbolMiniReel)
    end
end

function cls:setBonusSymbolWin()
--     local bonusSymbolWin = 0
    for col, rowList in pairs(self.bonusItemList) do
        for row, key in pairs(rowList) do
            if key >= 20 then
                local spineFile = self:getPic("spine/item/19/spine")
                local pos = self:getCellPos(col, row)
                self:addSpineAnimation(self.animateNode, nil, spineFile, pos, "animation4", nil, nil, nil, true, true)
            end
        end
    end

--     self.ctl.footer:setWinCoins(0, bonusSymbolWin, 0) -- 添加金额到 footer
--     self.ctl.rets.base_win = (self.ctl.rets.base_win or 0) + bonusSymbolWin
end
------------------------------------ bonus symbol end -------------------------------

------------------------------------ spin过程相关 start ------------------------------

function cls:getPlayInRespinKey()
    local keyList = {23, 24, 25, 26, 27, 28, 29, 21, 21, 14, 21, 22, 23}
    return keyList[math.random(1,#keyList)]
end

function cls:createCellSprite(key, col, rowIndex)
    local theCellNode   = cc.Node:create()

    local theKey = key
    if theKey >= 13 then -- bonus
        -- key = math.random(1, 11)
        key = self:getNormalKey()
    end

    if theKey == 2 then
        key = math.random(7, 11)
    end
    local theCellFile = self.pics[key] -- symbol图片
    local theCellSprite = bole.createSpriteWithFile(theCellFile)
    theCellNode:addChild(theCellSprite)
    theCellNode.sprite 	  = theCellSprite
    theCellNode.key 	  = key
    theCellNode.curZOrder = 0

    self:adjustWithTheCellSpriteUpdate( theCellNode, key, col ) -- 删除cell上的动画
    local theKey = theCellNode.key
    if self.symbolZOrderList[theKey] then -- 对triger和blank的层级单独处理
        theCellNode.curZOrder = self.symbolZOrderList[theKey]
    end
    if self.symbolPosAdjustList[theKey] then -- 没有配置 symbolPosAdjustList 所需要的cfg
        theCellSprite:setPosition(self.symbolPosAdjustList[theKey])
    end

    local _color = cc.c3b(255, 255, 255)
    if theKey >= 13 then -- bonus
        if self.showReSpinBoard then
            theCellNode.sprite:setScale(respinSymbolScale)
        else
            theCellNode.sprite:setScale(1)
        end
    else
        if self.showReSpinBoard then
            _color = cc.c3b(60, 60, 60)
        end
    end
    theCellNode.sprite:setColor(_color)

	return theCellNode
end

-- 刷新牌面
function cls:updateCellSprite(theCellNode, key, col, isShowResult, isReset)
    if bole.isValidNode(theCellNode.bonus) then
        theCellNode.bonus:removeFromParent()
        theCellNode.bonus = nil
    end

    if bole.isValidNode(theCellNode.bonusLabel) then
        theCellNode.bonusLabel:removeFromParent()
        theCellNode.bonusLabel = nil
    end

    local _color = cc.c3b(255, 255, 255)
    local scale = 1
    if self.showReSpinBoard then
        scale = respinSymbolScale
    end

    if key >= 13 then -- bonus
        key = 19
    else
        if self.showReSpinBoard then
            _color = cc.c3b(60, 60, 60)
        end
    end

    theCellNode.sprite:setScale(scale)
    theCellNode.sprite:setColor(_color)

    local theCellFile = self.pics[key]
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

function cls:onSpinStart()
    self.isFeatureClick = true
    self.isFastStopMusic = false
    self.DelayStopTime = 0
    self.isCollectPoint = nil

    self.hadStopBonusRoll = false
    self.bonusSymbolDelay = nil

    self.lastCol = nil
    self.addNewRespinCell = nil
    self.isWinRespin = nil
	-- 添加移动动画
	if self.showFreeSpinBoard then
		if self.isMapOpen then
			if self.theMapDialog then
				self.theMapDialog:exitMapScene()
				self.isMapOpen = false
			end
		end
	end
	self:enableStoreBtn(false)
    self:enableFeatureBtn(false)

    if self.showBaseSpinBoard then
        -- self:showBoardMaskNode()
    end
    self.respinExcitationNode:removeAllChildren()
    Theme.onSpinStart(self)
end

function cls:onSpinStop(ret)
    if ret.free_spins and (not self.ctl.freewin) then
		if ret.free_game then 
            self.freeType = ret.free_game.type

            if ret["theme_info"] and ret["theme_info"]["map_info"] and ret["theme_info"]["map_info"]["avg_bet"] then
                self.superAvgBet = ret["theme_info"]["map_info"]["avg_bet"]
            end

		end
    end

    if self.freeType and self.freeType == 2 and self.isFreeGameRecoverState then
        self:fixRet(ret)
    end
    self:checkWildAnimType(ret)
    self.multiWildItemList = ret.item_list
    Theme.onSpinStop(self, ret)
end

function cls:onRespinStart()
    self.lastCol = nil
    self.addNewRespinCell = nil
    self.hadStopBonusRoll = false
    self.resetRespinReel = true
    -- self.ctl:resetCurrentReels(false, true)
    -- self.hadRemoveJpExcitation = false
    self.DelayStopTime = 0
    self.bonusItemListInrespin = {}
    if self.bonus then
        self.bonus:onRespinStart_normal()
    end
    self:cleanSpecialSymbolState()
    self.respinExcitationNode:removeAllChildren()

    Theme.onRespinStart(self)
end

function cls:onRespinStop(ret)
    if self.showReSpinBoard then
        self:fixRet(ret, 1)
    end
    
    if #ret["theme_respin"] == 0 then
        self.respinStep = ReSpinStep.Over
        ret.theme_deal_show = true
    end
end

function cls:fixRet(ret,spinLayerType) -- 查看逻辑控制原因 拆分服务器返回的滚轴数据,分成15个结果 --gai
    if spinLayerType == 1 then
        self.ctl.resultCache = {}   -- ret["reelItem_list"] = {} -- 添加
        local itemsList = table.copy(ret.item_list)
        local symbolIndex = 1
        for i = 1, 7 do
            local max = i + 1
            max = max > 5 and 5 or max
            for j = 1, max do
                ret.item_list[symbolIndex] = {itemsList[i][j]}
                self.ctl.resultCache[symbolIndex] = {self:getPlayInRespinKey(), itemsList[i][j]}
                local extraCount = 6
                if self.isTurbo then
                    extraCount = 3
                end
                for k = 1, extraCount do -- 向下插入 六个 值
                    itemKey = self:getPlayInRespinKey() -- key = 1 + (key + k - 1)%#symbols
                    table.insert(self.ctl.resultCache[symbolIndex], itemKey)-- symbols[key])
                end
                symbolIndex = symbolIndex + 1
            end
        end
    else
        if self.freeType and self.freeType == 2 then 
            local new_pos_List = {} -- 更新新的 pos list
            for i = 1, #ret["win_pos_list"] do
                for k, v in ipairs(ret["win_pos_list"][i]) do
                    table.insert(new_pos_List, {v[1] + (i-1) * 5, v[2]})
                end
            end
            ret["win_pos_list"] = new_pos_List
    
            local new_win_List = {} -- 更新新的 winLisne
            for i = 1, #ret["win_lines"] do
                -- local play_idx = 1
                for k, v in ipairs(ret["win_lines"][i]) do
                    v.col_ck = 5 * (i-1)
                    -- v.play_idx = play_idx
                    -- play_idx = play_idx + 1
                    table.insert(new_win_List, v)
                end
            end
            ret["win_lines"] = new_win_List
        end
    end
    self.recvItemList = ret.item_list
end

function cls:stopControl( stopRet, stopCallFun )
    self.isCollectPoint = false
    self.stackWild = nil

    self.bonusItemList = stopRet["item_list"]
    self:getBonusCell()

    if not self.showMapFreeSpinBoard then
        if stopRet["bonus_level"] and stopRet["bonus_level"][3] then
            self.collectUnlockBet = stopRet["bonus_level"][3]
            self.tipBet = stopRet["bonus_level"][3]
            self:updateJpLockData(stopRet["bonus_level"])
            -- self:updateJpLockState(true, 4)
            self.bonusLevelChange = true
        end
        self.item_list = nil
        self.item_list = stopRet["item_list"]
    end

    if stopRet.bonus_game and stopRet.bonus_game.theme_respin then
        self.isWinRespin = true
    end

    if stopRet.bonus_game and stopRet.bonus_game.type == 5 then
        stopRet.bonus_game = nil
    end

    local themeInfo = stopRet.theme_info
    if themeInfo then
        self.stackWild = themeInfo.stack_wild
        if self.isInbase and not self.isFreeGameRecoverState then
            self.isCollectPoint = true
        end
    end
    if self.stackWild then
        self.ctl:resetCurrentReels() -- free和base用的是同一套假轴，所以不用传参
    end
    self.tarzanBonusWin = 0
    stopCallFun()
end

function cls:getBonusCell()
    self.bonusSymbolList = {}
    self.winBonusSymbol = false
    for col, colList in pairs(self.bonusItemList) do
        for row, key in pairs(colList) do
            if key >= 13 then
                self.winBonusSymbol = true
                local cell = self.spinLayer.spins[col]:getRetCell(row)
                table.insert(self.bonusSymbolList, {cell, key})
            end
        end
    end
end

function cls:noFeatureLeft() 
    local isNoFeatrueLeft = true
    if self.ctl.rets then
        if self.ctl.rets["theme_respin"] or self.ctl.rets["bonus_game"] then
            isNoFeatrueLeft = false
        end
    end
    
    return isNoFeatrueLeft  
end

-- theme_info数据处理
function cls:onThemeInfo(ret,callFunc)
    local themeInfo = ret["theme_info"]
    if ret["free_game"] then
        self.mapFreeAllWin = ret["free_game"]["total_win"]
    end
    self.isNeedFadeMusic = false

    self.themeInfoCallFunc = callFunc
    self:checkHasWinInThemeInfo(ret)
end

function cls:checkHasWinInThemeInfo( ret )
    local hasSpecialWin = false

    if self.isCollectPoint then 
        hasSpecialWin = true
        self.isCollectPoint = false
        self:collectMapPoints(ret)
    end

    if not hasSpecialWin then 
        local delay = self.bonusSymbolDelay or 0
        if self.fastStopMusicTag and self.bonusSymbolDelay then
            delay = 0
        end
        self:laterCallBack(delay, function( ... )
            if self.themeInfoCallFunc then
                -- if not (ret.bonus_game and ret.bonus_game.type and ret.bonus_game.type == 4) then
                --     self:setBonusSymbolWin()
                -- end
                if self.showBaseSpinBoard then
                    self:setBonusSymbolWin()
                end
                self.themeInfoCallFunc()
            end
        end)
    end
end

function cls:collectMapPoints( ret )
    if ret and ret.theme_info and ret.theme_info.map_info then 
        local _mapPoints = ret.theme_info["map_info"]["map_points"]
        local _mapLevel = ret.theme_info["map_info"]["map_level"]
        local curMapPoints = self.mapPoints

        if not self.isLocked and _mapPoints ~= curMapPoints then
            self:showCoinsFlyToUp()
            self:checkHasWinInThemeInfo(ret)
                    
            self:runAction(cc.Sequence:create(
                cc.DelayTime:create(0.7),
                cc.CallFunc:create(function()
                   self:showProgressAnimation(_mapPoints)  
                end)
            ))
        else
            if self.mapPoints then
                self:setCollectProgressImagePos(self.mapPoints)
            end
            if self.mapLevel then
                self:setNextCollectTargetImage(self.mapLevel)
            end
            self:checkHasWinInThemeInfo(ret)
            if _mapPoints > maxMapPoint then
                self.mapPoints = maxMapPoint
            elseif _mapPoints < 0 then
                self.mapPoints = 0
            else
                self.mapPoints = _mapPoints
            end
        end

        self.mapLevel = _mapLevel
        -- if _mapPoints > maxMapPoint then
        --     self.mapPoints = maxMapPoint
        -- elseif _mapPoints < 0 then
        --     self.mapPoints = 0
        -- else
        --     self.mapPoints = _mapPoints
        -- end
    else
        if self.mapPoints then
            self:setCollectProgressImagePos(self.mapPoints)
        end
        if self.mapLevel then
            self:setNextCollectTargetImage(self.mapLevel)
        end

        self:checkHasWinInThemeInfo(ret)   
    end
end

function cls:getItemAnimate(item, col, row, effectStatus, parent) -- 重新给 parent  节点 不在使用draw
	local spineItemsSet = Set({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11})
    if spineItemsSet[item] then
		if effectStatus == "all_first" then
			self:playItemAnimation(item, col, row)
		else
			self:playOldAnimation(col,row)
		end
		return nil
	end
end

function cls:checkWildAnimType(ret)
    local item_list = ret.item_list
    local tag = false
    if self.isFreeGameRecoverState and self.freeType and self.freeType == 2 then
        tag = true
    end
    local wildTypeList = {}
    for col, reel in pairs(item_list) do
        wildTypeList[col] = {}
        for row, key in pairs(reel) do
            if  key == 1 and (tag or self:cellIsWinPos(ret, col, row)) then
                wildTypeList[col][row] = 1
                if row >= 2 and wildTypeList[col][row - 1] > 0 then
                    wildTypeList[col][row] = wildTypeList[col][row] + wildTypeList[col][row - 1]
                    wildTypeList[col][row - 1] = 0
                end
            else
                wildTypeList[col][row] = 0
            end
        end
    end
    if self.isFreeGameRecoverState then
        self.basewildTypeList = tool.tableClone(wildTypeList)
    else
        self.freeWildTypeList = tool.tableClone(wildTypeList)
    end
end

function cls:cellIsWinPos(ret, col, row)
    local win_pos = ret.win_pos_list
    for k, v in pairs(win_pos) do
        if v[1] == col and v[2] == row then
            return true
        end
    end
    return false
end

function cls:setScaleInSuperFree4(scale)
    local scale = scale or 0.75
    if self.initBoardIndex == 5 then
        self.animateNode:setScale(scale)
        self.themeAnimateKuang:setScale(scale)
        self.boardRoot:setScale(scale)
    end
end

function cls:playItemAnimation(item, col, row) -- 修改这个方法，让有动画的symbol 在animationNode上面播放动画
    local animateName = "animation"
	local fileName = item
	------------------------------------------------------------------
	local cell = self.spinLayer.spins[col]:getRetCell(row)
	local pos		= self:getCellPos(col,row)
    local spineFile = self:getPic("spine/item/" .. fileName .. "/spine")
    local _, s1 = self:addSpineAnimation(self.animateNode, row, spineFile, pos, animateName, nil, nil, nil, true) -- 中奖动画
    self.animNodeList = self.animNodeList or {}
    self.animNodeList[col.."_"..row] = {}
    self.animNodeList[col.."_"..row][1] = s1
    self.animNodeList[col.."_"..row][2] = animateName
	cell.sprite:setVisible(false)
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

function cls:removeItemAnim(cell)
	if cell.itemAnim then
		cell.itemAnim:removeFromParent()
		cell.itemAnim = nil
	end
end

function cls:drawLinesThemeAnimate( lines, layer, rets, specials)
    local timeList = {2,2}
    Theme.drawLinesThemeAnimate(self, lines, layer, rets, specials,timeList)
end

function cls:genSpecials( pWinPosList )
	local specials 	 = {[specialSymbol["bonus"]]={}}
	local itemList   = self.ctl:getRetMatrix()
	if itemList then
		for col,colItemList in pairs(itemList) do
			if col > baseColCnt then break end
			for row,theKey in pairs(colItemList) do
				if theKey==specialSymbol["bonus"] then
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
        self.scatterPosList  = {}
        self.respinSymbolList = {}
        self.wildPosList = {}
        if self.showReSpinBoard then 
            self:genSpecialSymbolStateInRespin(rets)
        else
            self:genSpecialSymbolStateInNormal(rets) -- base 情况 配置 scatter、bonus
        end
	end
end

function cls:checkIsNeedRespinAntic(isShow)
    if isShow then 
        if self.respinAnticCol then return end
        if self.lockedReels and bole.getTableCount(self.lockedReels) == respinCellCount - 1 then 
            for col = 1, respinCellCount do 
                if not self.lockedReels[col] then
                    self.respinAnticCol = col
                end
            end
        end
    end
end

function cls:genSpecialSymbolStateInRespin( rets )
    for col = 1, respinCellCount do -- 遍历每一列
        local colItemList = rets.item_list[col]
        if (self.lockedReels and not self.lockedReels[col]) and (colItemList) then
            for row, theItem in pairs(colItemList) do -- 落地动画
                if theItem >= 13 then
                    self.respinSymbolList[col] = self.respinSymbolList[col] or {}
                    self.respinSymbolList[col][theItem] = self.respinSymbolList[col][theItem] or {}
                    table.insert(self.respinSymbolList[col][theItem], {col, row})
                end
            end
        end
    end
end

function cls:genSpecialSymbolStateInNormal(rets)
    local cItemList   = rets.item_list
	local checkConfig = self.specialItemConfig -- 特殊symbol的id list
	for itemKey,theItemConfig in pairs(checkConfig) do
		local itemType     = theItemConfig["type"]
		local itemCnt  	   = 0
		local isBreak 	   = false
		if itemType then
			for col=1, baseColCnt do
				local colItemList  = cItemList[col]
                local colRowCnt    = self.spinLayer.spins[col].row -- self.colRowList[col]
				local curColMaxCnt = theItemConfig["col_set"][col] or colRowCnt
				local itemMiniCnt  = self.isFreeGameRecoverState and theItemConfig["min_cnt"]-1 or theItemConfig["min_cnt"]
				-- 判断_当前列之前_是否已经中了feature(通过之前列itemKey个数判断)
				local isGetFeature = false
				if itemCnt >= theItemConfig["min_cnt"] then
					isGetFeature = true
				end
				-- 判断是否可能中feature或者更大的feature   一般用于滚轴加速
                local willGetFeatureInCol = false
                local minCount = theItemConfig["min_cnt"] - 1
                -- if self.isFreeGameRecoverState then
                --     minCount = 32 -- free game 去掉激励
                -- end
				if not isBreak and curColMaxCnt > 0 and itemCnt >= minCount then
					willGetFeatureInCol = true
					self.speedUpState[col] = self.speedUpState[col] or {} -- 此情况下，会进行特殊操作，将其状态记到self.speedUpState中
					self.speedUpState[col][itemKey] = true
				end
				-- 判断当前列加上之后所有列是否有可能中feature
                -- local willGetFeatureInAfterCols = false
                local willGetFeatureInAfterCols = true
				local willGetFeatureInNextCol = false
				if not isBreak then
					local sumCnt = 0
					local sumCnt2 = 0
					for tempCol=col, baseColCnt do
						if tempCol~=col then 
							sumCnt2 = sumCnt2 + (theItemConfig["col_set"][tempCol] or colRowCnt) 
						end
						sumCnt = sumCnt + (theItemConfig["col_set"][tempCol] or colRowCnt)
					end
					if sumCnt > 0 and (itemCnt+sumCnt) >= itemMiniCnt then -- theItemConfig["min_cnt"] then
						willGetFeatureInAfterCols = true
					end

					if sumCnt2 > 0 and (itemCnt+sumCnt2) >= itemMiniCnt then -- theItemConfig["min_cnt"] then
						willGetFeatureInNextCol = true
					end
				end

                self.notifyState[col] = self.notifyState[col] or {} -- 当前列提示相关状态
                self.respinSymbolList[col] = self.respinSymbolList[col] or {}
                
				if not isBreak and curColMaxCnt > 0 and willGetFeatureInAfterCols then
                    for row, theItem in pairs(colItemList) do
                        local newItem = theItem
                        -- if theItem >= 13 then
                        --     newItem = 13
                        -- end
                        if newItem == itemKey then
                            self.notifyState[col][newItem] = self.notifyState[col][newItem] or {}
                            table.insert(self.notifyState[col][newItem], {col, row}) -- 增加播放落地动画的特殊symbol的数据(id, col, row)
                        end
                        if theItem == 13 then
                            table.insert(self.scatterPosList, {col, row})
                        end
					end
                end

                for row, theItem in pairs(colItemList) do
                    if theItem >= 13 then
                        self.respinSymbolList[col][theItem] = self.respinSymbolList[col][theItem] or {}
                        table.insert(self.respinSymbolList[col][theItem], {col, row}) 
                    end
                    local theItemIsUnlock = true
                    if theItem == itemKey then
                        itemCnt = itemCnt + 1 
                    end
				end
			end
		end
    end
	self:checkOtherFeatureSymbol(rets)
end

function cls:checkPlaySymbolAnim(item_list)
    local bonus3 = 0
    for i = 1, 3 do
        local col = item_list[i]
        for row, key in pairs(col) do
            if key >= 13 then
                bonus3 = bonus3 + 1
            end
        end
    end
    local bonus = 0
    for k, v in pairs(item_list[4]) do
        if v >= 13 then
            bonus = bonus + 1
        end
    end
    local bonus4 = bonus3 + bonus
    self.playScatterLandAnim4 = bonus3 > 0
    self.playScatterLandAnim5 = bonus4 > 1
end

function cls:checkOtherFeatureSymbol(rets)
	-- for col=1, baseColCnt do -- 遍历每一列
	-- 	local colItemList = rets.item_list[col]
	-- 	if (colItemList) then
	-- 		for row, theItem in pairs(colItemList) do -- 落地动画
    --             if specialSymbol.wild and specialSymbol.wild == theItem then
    --                 self.notifyState[col] = self.notifyState[col] or {}
    --                 self.notifyState[col][theItem] = self.notifyState[col][theItem] or {}
    --                 table.insert(self.notifyState[col][theItem], {col, row})
    --             end
	-- 			if theItem >= 13 and theItem <= 39 then 
	-- 				self.notifyState[col] = self.notifyState[col] or {}
	-- 				self.notifyState[col][specialSymbol.bonus] = self.notifyState[col][specialSymbol.bonus] or {}
	-- 				table.insert(self.notifyState[col][specialSymbol.bonus], {col, row})
	-- 			end
	-- 		end
	-- 	end
	-- end
end

function cls:checkSpeedUp(checkCol) -- 控制出现特殊的龙 虎 预示好事发生的动画的时候 取消单个轴的 加速操作
    local isNeedSpeedUp = false
    if self.showReSpinBoard then
        if not self.ctl.specialSpeed and self.respinSpeedUpState and self.respinSpeedUpState[checkCol] and bole.getTableCount(self.respinSpeedUpState[checkCol]) > 0 then
            isNeedSpeedUp = true
        end
    else
        if not self.ctl.specialSpeed and self.speedUpState and self.speedUpState[checkCol] and bole.getTableCount(self.speedUpState[checkCol]) > 0 then
            isNeedSpeedUp = true
        end
    end
	return isNeedSpeedUp
end

function cls:playCellRoundEffect(parent, ...) -- 播放中奖连线框
    local _, s = self:addSpineAnimation(parent, nil, self:getPic("spine/kuang/spine"), cc.p(0,0), "animation", nil, nil, nil, true, true, nil)
end

function cls:adjustWithTheCellSpriteUpdate( theCellNode, key, col ) -- 删除掉 tip 动画
    if theCellNode.symbolTipAnim then
        if (not tolua.isnull(theCellNode.symbolTipAnim)) then
            theCellNode.symbolTipAnim:removeFromParent()
		end
		theCellNode.symbolTipAnim = nil
	end
end
------------------------------------ spin过程相关 end ------------------------------

-------------------------------- 轮轴相关 start ------------------------------
function cls:playBonusCollectAnim()
    -- self:addSpineAnimation(self.bonusAnimNode, nil, self:getPic("spine/base/coins_collect/spine"), cc.p(0,0), "animation", nil, nil, nil, true, true)
end

function cls:playSymbolNotifyEffect(pCol, reelSymbolState)
    self.collectCoinsSpine  = self.collectCoinsSpine or {}
    ------------ 去掉 落地动画 ------------
    -- for key , list in pairs(self.respinSymbolList[pCol]) do -- list为特殊symbol的表，key为symbol id
    --     for _, crPos in pairs(list) do -- crPos 特殊symbol的位置
    --         local col = crPos[1]
    --         local row = self.fastStopMusicTag and crPos[2] or (crPos[2] + 2)
    --         local cell = self.spinLayer.spins[col]:getRetCell(row)

    --         if cell then
    --             local animateName = "animation"
    --             local fileName = key
    --             local spineFile		= self:getPic("spine/item/19/spine")
    --             if not spineFile then return end
    --             -- self:playMusic(self.audio_list.bonus_land)
    --             local _,s = self:addSpineAnimation(cell, 22, spineFile, cc.p(0,0), animateName, nil, nil, nil, false, false)
    --             -- cell.sprite:setVisible(false)
    --             if bole.isValidNode(s) then
    --                 if self.showReSpinBoard then
    --                     s:setScale(respinSymbolScale)
    --                 else
    --                     s:setScale(1)
    --                 end
    --             end
    --             cell.symbolTipAnim = s
    --         end
    --     end
	-- end
end

function cls:playReelNotifyEffect(pCol)  -- 播放特殊的 等待滚轴结果的   scatter激励闪光
    self.reelNotifyEffectListBg = self.reelNotifyEffectListBg or {}
    local pos = self:getCellPos(pCol, 2)
    pos = cc.p(pos.x, pos.y - 40)
    local spineFile = self:getPic("spine/base/excitation/spine")
    local _,s2 = self:addSpineAnimation(self.animateNode, 20, spineFile, pos, "animation",nil,nil,nil,true,true)
    self.reelNotifyEffectListBg[pCol] = s2
    self:playMusic(self.audio_list.anticipation)
end

function cls:stopReelNotifyEffect(pCol)    
    self.reelNotifyEffectListBg = self.reelNotifyEffectListBg or {}
	if self.reelNotifyEffectListBg[pCol] and (not tolua.isnull(self.reelNotifyEffectListBg[pCol])) then
		self.reelNotifyEffectListBg[pCol]:removeFromParent()
	end
	self.reelNotifyEffectListBg[pCol] = nil
end

-- 滚轴滚到底部
function cls:onReelFallBottom( pCol ) -- 滚轴停止滚动
	-- 标志位
	self.reelStopMusicTagList[pCol] = true
	-- 列停音效，提示动画相关
	if not self:checkPlaySymbolNotifyEffect(pCol) then
		self:dealMusic_PlayReelStopMusic(pCol)
	end
    -- 确定下一轴是否进行Notify
    if not self.showReSpinBoard then
        if self:checkSpeedUp(pCol + 1) then
            self:onReelNotifyStopBeg(pCol +1)
        end
    end
    if self.showBaseSpinBoard then
        self.bonusItemList = self.bonusItemList or {}
        for k, v in pairs(self.bonusItemList[pCol]) do
            if v >= 13 then
                k = self.fastStopMusicTag and k or k + 1
                local cell = self.spinLayer.spins[pCol]:getRetCell(k)
                self:speedUpRollBonus(cell, v, pCol, k, 1)
            end
        end
    elseif self.showReSpinBoard then
        local item_List = self.ctl.rets.item_list
        local colList = item_List[pCol]
        for row, key in pairs(colList) do
            if key >= 13 and (self.lockedReels and not self.lockedReels[pCol]) then -- self.data.respinBoardData[col][row] == 0 then
                -- self.lockedReels = self.lockedReels or {}
                -- self.lockedReels[pCol] = true
                -- self.addNewRespinCell = true
                -- row = self.fastStopMusicTag and row or row
                local cell = self.spinLayer.spins[pCol]:getRetCell(row)
                local parent = cc.Node:create()
                local pos = self:getCellPos(pCol, row)
                self.respinSymbolNode:addChild(parent)
                parent:setPosition(pos)
                -- self:createRespinSymbol(cell, key, respinSymbolScale)
                self:speedUpRollBonus(parent, key, pCol, row, respinSymbolScale)
            end
        end
        -- self:hideBoardMaskNodeByCol(pCol)
    end
end

-- 快停
function cls:onReelFastFallBottom( pCol )
    self.fastStop = true
    if self.showBaseSpinBoard then
        -- self:hideBoardMaskNode()
    end
    if self.showReSpinBoard then
        for i = 1, 5 do
            self.respinBoardList[i]:stopAllActions()
            self.respinBoardList[i]:setScale(1)
        end
    end
    -- self:stopMusic(self.audio_list.respin_anticipation,true)
    Theme.onReelFastFallBottom(self, pCol)
end

-- 在 onReelFallBottom 之后调用
function cls:onReelStop( col, isReset )
    if not isReset then
        if self.showReSpinBoard and self.bonus then
            if self.respinExcitationCol and col == self.respinExcitationCol then
                self:stopRespinExcitation()
            end
            local item_List = self.ctl.rets.item_list
            local colList = item_List[col]
            for row, key in pairs(colList) do
                if key >= 13 and (self.lockedReels and not self.lockedReels[col]) then -- self.data.respinBoardData[col][row] == 0 then
                    self.lockedReels = self.lockedReels or {}
                    self.lockedReels[col] = true
                    self.addNewRespinCell = true
                    local cell = self.spinLayer.spins[col]:getRetCell(row)
                    self:createRespinSymbol(cell, key, respinSymbolScale)
                end
            end

            local pCol = col
            while true do
                pCol = pCol + 1
                if not self.lockedReels[pCol] then
                    break
                end
            end
            for k, v in pairs(self.respinExcitationData) do
                if v[2] and pCol == v[2] and v[1] and v[1] == boardCellCountCfg[k] - 1 then
                    self:checkRespinExcitation(nil, pCol, k)
                end
            end

            self.nextCol = pCol
            self.resetRespinReel = false
            -- self.ctl:resetCurrentReels(false, true)

            self:getRespinExcitationData()

            if respinBoardContentCfg[pCol] ~= respinBoardContentCfg[col] then
                -- self:showBigBoard(respinBoardContentCfg[pCol])
            end

            local boardIndex = respinBoardContentCfg[col]
            if self.respinExcitationData[boardIndex] and self.respinExcitationData[boardIndex][1] and self.respinExcitationData[boardIndex][1] == boardCellCountCfg[boardIndex] then
                self:playMusic(self.audio_list.jp_win)
                self.jpWinSpineList = self.jpWinSpineList or {}
                local animationIndex = boardIndex > 1 and 1 or 2
                local animation = "animation"..animationIndex
                local _, s1 = self:addSpineAnimation(self.jpAnimNodeListDown[boardIndex], nil, self:getPic("spine/respin/jp_win/spine"), cc.p(0, 0), animation, nil, nil, nil, true, true)
                self.jpWinSpineList[boardIndex] = s1

                self.jpWinLabelSpineListInboard = self.jpWinLabelSpineListInboard or {}
                self.jpWinLabelSpineListInboard[boardIndex] = self.jpWinLabelSpineListInboard[boardIndex] or {}
                if bole.isValidNode(self.jpWinLabelSpineListInboard[boardIndex][1]) then
                    bole.spChangeAnimation(self.jpWinLabelSpineListInboard[boardIndex][1], "animation"..boardIndex, true)
                else
                   local _, s2 = self:addSpineAnimation(self.respinBoardJpLabelList[boardIndex][1], nil, self:getPic("spine/respin/jp_win_label/spine"), cc.p(0, 10), "animation"..boardIndex, nil, nil, nil, true, true)
                   self.jpWinLabelSpineListInboard[boardIndex][1] = s2
                end
                if bole.isValidNode(self.jpWinLabelSpineListInboard[boardIndex][2]) then
                    bole.spChangeAnimation(self.jpWinLabelSpineListInboard[boardIndex][2], "animation"..boardIndex, true)
                else
                   local _, s4 = self:addSpineAnimation(self.respinBoardJpLabelList[boardIndex][2], nil, self:getPic("spine/respin/jp_win_label/spine"), cc.p(0, 10), "animation"..boardIndex, nil, nil, nil, true, true)
                   self.jpWinLabelSpineListInboard[boardIndex][2] = s4
                end

                local parent = self.down_child:getChildByName("respin_win_jp_anim")
                local _, s3 = self:addSpineAnimation(parent, nil, self:getPic("spine/respin/jp_win_board/spine"), cc.p(0, -30), "animation"..boardIndex, nil, nil, nil, true, true)
                self.jpWinSpineListInboard[boardIndex] = s3
                self:addSpineAnimation(parent, nil, self:getPic("spine/respin/jp_win_board_lizi/spine"), cc.p(0, -30), "animation"..boardIndex, nil, nil, nil, false, false)
            end
        end
    end
    Theme.onReelStop(self, col)
end

function cls:onAllReelStop()
    if self.showReSpinBoard and self.bonus then 
        if self.addNewRespinCell then --  self.addNewRespinCell = true
            self.addNewRespinCell = nil
            self.bonus:updateSpinsRe(true)
        end
        self.bonus:onRespinAllStop() -- self.bonus:updateRespinBoard()
        self:checkIsNeedRespinAntic(true)
    end

    if self.fastStop then
        self.fastStop = false
        if self.showBaseSpinBoard then
            if self.winBonusSymbol then
                self:stopBonusRoll()
            end
        end
    end

    Theme.onAllReelStop(self)
end

function cls:getRespinExcitationData()
    self.respinExcitationData = {} -- [1] lock的symbol数  [2] 没有lock的最后一个cell
    for i = 1, 29 do
        if self.lockedReels[i] then
            self.respinExcitationData[respinBoardContentCfg[i]] = self.respinExcitationData[respinBoardContentCfg[i]] or {}
            self.respinExcitationData[respinBoardContentCfg[i]][1] = self.respinExcitationData[respinBoardContentCfg[i]][1] or 0
            self.respinExcitationData[respinBoardContentCfg[i]][1] = self.respinExcitationData[respinBoardContentCfg[i]][1] + 1
        else
            self.respinExcitationData[respinBoardContentCfg[i]] = self.respinExcitationData[respinBoardContentCfg[i]] or {}
            self.respinExcitationData[respinBoardContentCfg[i]][2] = i
        end
    end
end

local colPosXCfg = {
    -8, 0, -15, -2, 5, -8, 0, 0, 10, -15, -5, -1, -2, 0,
    -5, -5, -1, -2, 0, -5, -5, -1, -2, 0, -5, -5, -1, -2, 0
}

local colPosYCfg = {
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    2, 2, 2, 2, 2, 0, 0, 0, 0, 0, -2, -2, -2, -2, -2
}
function cls:checkRespinExcitation(boardIndex, pCol, k)
    if boardIndex then
        if self.respinExcitationData[boardIndex] and self.respinExcitationData[boardIndex][1] and self.respinExcitationData[boardIndex][1] == boardCellCountCfg[boardIndex] - 1 then
            local col = self.respinExcitationData[boardIndex][2]
            self.respinExcitationCol = col
            self:playToWinJpSpines(boardIndex, 1, col)
            self:playToWinJpSpines(boardIndex, -1, col)
        end
    else
        local col = pCol
        self.respinExcitationCol = col
        local pos = self:getCellPos(col, 1)
        self:playToWinJpSpines(k, 1, col)
        self:playToWinJpSpines(k, -1, col)
    end
end

function cls:playToWinJpSpines(boardIndex, tag, col)
    local endPosCfgX = {350, 350, 295, 230, 180}
    local endPosCfgY = {0, 0, 0, 0, -40}
    local rotationCfg = {-3, 5, 15, 34, 50}
    local delay = 15/30
    local pos = self:getCellPos(col, 1)
    self:runAction(cc.Sequence:create(
        cc.CallFunc:create(function( ... )
            -- if not self.hadRespinWToWinJpFlash then 
                -- self.hadRespinWToWinJpFlash = true
                local _, s = self:addSpineAnimation(self.respinToWinJpLoopAnimNode, nil, self:getPic("spine/respin/to_win_jp_loop/spine"), cc.p(0, -15), "animation", nil, nil, nil, false, false)
                -- s:setScale(1.05)
            -- end

            -- local size_s = self.respinBoardList[boardIndex]:getContentSize()
            local endPosW = bole.getWorldPos(self.respinBoardList[boardIndex])
            local x_move_e = endPosCfgX[boardIndex] * tag
            -- local x_move_e = size.width/2 * tag
            local y_move_e = endPosCfgY[boardIndex]
            endPosW = cc.p(endPosW.x + x_move_e, endPosW.y + y_move_e)
            local endPosN = bole.getNodePos(self.respinToWinJpAnimNode, endPosW)
            local jp_index = tag == 1 and 5 or 4
            local startPosW = bole.getWorldPos(self.jpAnimNodeListDown[jp_index])
            local x_move_s = 165 * tag
            startPosW = cc.p(startPosW.x + x_move_s, startPosW.y)
            local startPosN = bole.getNodePos(self.respinToWinJpAnimNode, startPosW)
            local _, s = self:addSpineAnimation(self.respinToWinJpAnimNode, nil, self:getPic("spine/respin/to_win_jp_hit/spine"), startPosN, "animation", nil, nil, nil, false, false)
            local sRotation = rotationCfg[boardIndex]
            sRotation = sRotation * tag
            local endLength = math.sqrt(math.pow((endPosN.y-startPosN.y),2)+math.pow((endPosN.x-startPosN.x),2))
            local baseLength = 450
            if SHRINKSCALE_H < 1 then
                local scale2 = bole.getAdaptScale(false)
                baseLength = baseLength * scale2
            end
            local sScale = endLength / baseLength
            s:setRotation(sRotation)
            s:setScaleY(sScale)

            self.jpColorNodeList[boardIndex]:runAction(cc.Sequence:create(
                cc.ScaleTo:create(0.3, 1.2),
                cc.ScaleTo:create(0.15, 1),
                cc.ScaleTo:create(0.15, 1)
            ))
        end),
        cc.DelayTime:create(delay),
        cc.CallFunc:create(function( ... )
            local animation = "animation"..boardIndex
            self:addSpineAnimation(self.respinToWinJpAnimNode, nil, self:getPic("spine/respin/to_win_jp_flash/spine"), cc.p(0, -60), animation, nil, nil, nil, false, false)
        end),
        cc.DelayTime:create(0.1),
        cc.CallFunc:create(function( ... )
            local _, s = self:addSpineAnimation(self.respinExcitationNode, nil, self:getPic("spine/respin/to_win_jp/spine"), pos, "animation1", nil, nil, nil, true, true)
            s:setScale(1.05)
        end)
    ))
end

function cls:stopRespinExcitation()
    self.respinExcitationNode:removeAllChildren()
end

function cls:showBigBoard(boardIndex)
    local cfg = {
        {-3,0}, {3,0},
        {-6,0}, {0,0}, {6,0},
        {-9,0}, {-3,0}, {3,0}, {9,0},
        {-12,0}, {-6,0}, {0,0}, {6,0}, {12,0},
        {-15,2}, {-6,2}, {0,2}, {6,2}, {15,2},
        {-15,0}, {-6,0}, {0,0}, {6,0}, {15,0},
        {-15,-2}, {-6,-2}, {0,-2}, {6,-2}, {15,-2},
    }
    local boardUp
    if not boardIndex then 
        boardIndex = 1
        boardUp = 1
    else
        boardUp = boardIndex + 1
        local cellList = {}
        for i = 1, 29 do
            if respinBoardContentCfg[i] == boardIndex then
                local cell = self.spinLayer.spins[i]:getRetCell(1)
                cell:runAction(cc.Sequence:create(
                    cc.ScaleTo:create(0.1, 1.1),
                    cc.ScaleTo:create(0.05, 1.05)
                    -- cc.MoveBy:create(0.15, cc.p(cfg[i][1], cfg[i][2]))
                ))
            end
        end
        self.respinBoardList[boardIndex]:runAction(cc.Sequence:create(
            cc.ScaleTo:create(0.1, 1.1),
            cc.ScaleTo:create(0.05, 1.05)
        ))
    end
    if boardUp <= 5 then
        for i = 1, 29 do
            if respinBoardContentCfg[i] == boardUp then
                local cell = self.spinLayer.spins[i]:getRetCell(1)
                cell:runAction(cc.Sequence:create(
                    cc.ScaleTo:create(0.3, 1)
                    -- cc.MoveBy:create(0.15, cc.p(-cfg[i][1], -cfg[i][2]))
                ))
            end
        end
        self.respinBoardList[boardUp]:runAction(cc.Sequence:create(
            cc.ScaleTo:create(0.3, 1)
        ))
    end
end

function cls:fixAnimCanPlay(item_list)
    local item_list = item_list or {}
    local respinSymbolCount4 = 0
    self.playRespinSymbolSpine4 = false
    self.playRespinSymbolSpine5 = false
    for col, data in pairs(item_list) do
        if col == 5 then break end
        for row, key in pairs(data) do
            if key >= 13 and key <= 39 then
                respinSymbolCount4 = respinSymbolCount4 + 1
            end
        end
    end
    if respinSymbolCount4 >= 3 then
        self.playRespinSymbolSpine4 = true
    end
    local data5 = item_list[5]
    local respinSymbolCount5 = 0
    for k, v in pairs(data5) do
        if v >= 13 and v<= 39 then
            respinSymbolCount5 = respinSymbolCount5 + 1
        end
    end
    if respinSymbolCount5 + respinSymbolCount4 >= 6 then
        self.playRespinSymbolSpine5 = true
    end
end

function cls:playFixAnim( col )
    -- if self.ctl.rets and self.ctl.rets.item_list and self.ctl.rets.item_list[col] then 
    --     for row, key in pairs(self.ctl.rets.item_list[col]) do
    --         if key >= 13 and key <= 39 then 
    --             local cell = self.spinLayer.spins[col]:getRetCell(row)
    --             if cell then
    --                 if col <= 3 or (col == 4 and self.playRespinSymbolSpine4) or (col == 5 and self.playRespinSymbolSpine5) then
    --                     local spineFile     = self:getPic("spine/item/"..specialSymbol.bonus.."/spine")
    --                     local _,s = self:addSpineAnimation(cell, 22, spineFile, cc.p(0,0), "animation1", nil, nil, nil, true, false)
    --                     cell.symbolTipAnim = s
    --                 end
    --             end
    --         end
    --     end
    -- end
end

function cls:updateRespinLockCnt( ... )
    if bole.isValidNode(self.respinCollectCntLb) and self.lockedReels then
        local cnt = bole.getTableCount(self.lockedReels)
        if cnt > 0 then 
            self.respinCollectCntLb:setString(cnt)
        else
            self.respinCollectCntLb:setString("")
        end
    else
        self.respinCollectCntLb:setString("")
    end
end

-------------------------------- 轮轴相关 end ------------------------------

-------------------------- 断线重连 start ----------------------------
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

function cls:setFreeGameRecoverState(data)
	if data["free_spins"] and data["free_spins"] >= 0 then -- 断线重连如果是最后一次freespin 的时候就不在进行这个操作
		self.isFreeGameRecoverState = true
    else
		self.isFreeGameRecoverState = false
	end
end

function cls:setDealFreeCollectState()
    self.ctl.spin_processing = true
end

function cls:enterThemeByFirstFreeSpin(ret, theFreeSpinData, endCallFunc)
	ret["free_spins"]		= theFreeSpinData.free_spins
	ret["item_list"]		= theFreeSpinData.item_list
    self.ctl:free_spins(ret)
    -- self.freeType 			= theFreeSpinData.type
end

function cls:dealAboutBetChange(theBet,isPointBet)
	if self.isOverInitGame then
	    self:checkLockFeature()
    end
    if self.currentBet then
		local recordBet = self.currentBet
		self.currentBet = theBet
		local currentState = self.currentBet >= self.collectUnlockBet 
		if (recordBet >= self.collectUnlockBet) ~= currentState then
			if currentState then
				self:setCollectPartState(true,true)
			else
				self:setCollectPartState(false,true)
			end
		end
    end
    self:updateJpLockState(true, 0)
end

function cls:setBet()
    local openLock = false
	local maxBet = self.ctl:getMaxBet()
	if self.tipBet and maxBet >= self.tipBet and self.ctl:noFeatureLeft() then
		self:playMusic(self.audio_list.common_click)
		self.ctl:setCurBet(self.tipBet)
        openLock = true
	end
    return openLock
end

function cls:finshSpin()
	if not self.isFreeGameRecoverState and not self.ctl.freewin and self.ctl:noFeatureLeft()  then
		self:enableFeatureBtn(true)
		self:enableStoreBtn(true)
	end

    if (not self.ctl.freewin) and (not self.ctl.autoSpin) then
        self.isFeatureClick = false
    end
end

function cls:clearAnimate( ... )
    self.themeAnimateKuang:removeAllChildren()
	self.animateNode:removeAllChildren()
	self:cleanAnimateList()
	self:cleanCellState()
	self.animNodeList = nil
	self.anticipationNode:removeAllChildren()
end

function cls:stopDrawAnimate( )

	Theme.stopDrawAnimate(self)
	-- self.scatterBGState = nil

    -- self.randAnimate:removeAllChildren()
    self.randWildSList = nil

    self.stickWildSpine = nil
end

local fs_show_type = {
	start = 1,
	more = 2,
	collect = 3,
}
-------------------------- 断线重连 end ----------------------------

---------------------------------- free spin start ----------------------------------
function cls:showFreeSpinDialog(theData, sType)
	-- 降低背景音乐
	self:dealMusic_FadeLoopMusic(0.3, 1, 0.3)
	local config = {}
	config["gen_path"] = self:getPic("csb/")
	config["csb_file"] = config["gen_path"].."free_spin.csb"
	config["frame_config"] = {
		-- start: 第二个参数 注册点击事件的方法; 第四个参数 .theme:onCollectFreeClick 回调(可以 理解为 点击事件立马就会被调用了,跟第四个参数没有关系); 第六个参数 回调endEvent方法(一般在 endEvent里面场景切换回调) 最后一个参数 是 延迟删除的时间
		["start"] 		 = {{0, 64}, 0.7, {65, 95}, 0, transitionDelay.respin.onCover + closeFreeDialogAnimTime, (transitionDelay.respin.onEnd - transitionDelay.respin.onCover), 0.5},
		["more"] 		 = {{0, 64}, 2.7,  {65, 95},0.3,0.5,0},
		["collect"] 	 = {{0, 64}, 0.7, {65, 95}, 0, transitionDelay.respin.onCover + closeFreeDialogAnimTime, (transitionDelay.respin.onEnd - transitionDelay.respin.onCover), 0},-- 最后一个参数 是延时删除的时间 -- 倒数第二个参数 回调 完成方法
	}
	self.freeSpinConfig = config

	local addLizi = function (node) -- 添加粒子特效 和 spine 动画的入口
	end

    local theDialog = G_FREE_SPIN_DIALOGS["base"].new(self.ctl, self.freeSpinConfig)
    if sType == fs_show_type.start then
        theDialog:showStart(theData)
		-- addLizi(theDialog.startRoot)
        local dialogAnim = theDialog.startRoot:getChildByName("anim")
        self.freeNum = theDialog.startRoot:getChildByName("label_node")
        self.freeStartBtn = theDialog.startRoot:getChildByName("btn_start")
        self.freeStartBtn:setTouchEnabled(false)
        self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function( ... )
                self:playMusic(self.audio_list.dialog_fg_start)
                self.freeNum:setVisible(true)
                self.freeNum:setScale(0.0001)
                self.freeNum:setOpacity(0)
                self.freeStartBtn:setVisible(true)
                self.freeStartBtn:setScale(0.0001)
                local _, s = self:addSpineAnimation(dialogAnim, nil, self:getPic("spine/dialog/free/spine"), cc.p(0, 0), "animation1", nil, nil, nil, true, false, nil)
                self.freeStartSpine = s
            end),
            cc.DelayTime:create(0.23),
            cc.CallFunc:create(function( ... )
                self.freeNum:runAction(cc.Sequence:create(
                    cc.Spawn:create(cc.FadeIn:create(0.3), cc.ScaleTo:create(0.3, 1.14)),
                    cc.ScaleTo:create(0.16, 0.85),
                    cc.ScaleTo:create(0.2, 1)
                ))
            end),
            cc.DelayTime:create(0.1),
            cc.CallFunc:create(function( ... )
                self.freeStartBtn:setScale(0.001)
                self.freeStartBtn:setOpacity(0)
                self.freeStartBtn:runAction(cc.Sequence:create(
                    cc.Spawn:create(cc.FadeIn:create(0.3), cc.ScaleTo:create(0.3, 1.14)),
                    cc.ScaleTo:create(0.16, 0.85),
                    cc.ScaleTo:create(0.2, 1)
                ))
            end),
            cc.DelayTime:create(0.67),
            cc.CallFunc:create(function( ... )
                self.freeStartBtn:setTouchEnabled(true)
                local btn = theDialog.startRoot:getChildByName("btn_start")
                btn:setTouchEnabled(true)
                if bole.isValidNode(self.freeStartSpine) then
                    bole.spChangeAnimation(self.freeStartSpine, "animation1_1", true)
                end
            end)
        ))
    elseif sType == fs_show_type.collect then
        theDialog:setCollectScaleByValue(theData.coins, 470)
        theDialog:showCollect(theData)
        local dialogAnim = theDialog.collectRoot:getChildByName("anim")
        self.freeWinLabel = theDialog.collectRoot:getChildByName("label_node")
        self.freeCollectBtn = theDialog.collectRoot:getChildByName("btn_collect")
        self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function( ... )
                self:playMusic(self.audio_list.dialog_fg_collect)
                self.freeWinLabel:setVisible(false)
                self.freeCollectBtn:setVisible(true)
                self.freeCollectBtn:setScale(0.001)
                local _, s = self:addSpineAnimation(dialogAnim, nil, self:getPic("spine/dialog/free/spine"), cc.p(0, 0), "animation2", nil, nil, nil, true, false, nil)
                self.freeCollectSpine = s
            end),
            cc.DelayTime:create(0.23),
            cc.CallFunc:create(function( ... )
                self.freeWinLabel:setVisible(true)
                self.freeWinLabel:setOpacity(0)
                self.freeWinLabel:runAction(cc.Sequence:create(
                    cc.FadeIn:create(0.3)
                ))
            end),
            cc.DelayTime:create(0.1),
            cc.CallFunc:create(function( ... )
                self.freeCollectBtn:setScale(0.001)
                self.freeCollectBtn:setOpacity(0)
                self.freeCollectBtn:runAction(cc.Sequence:create(
                    cc.Spawn:create(cc.FadeIn:create(0.3), cc.ScaleTo:create(0.3, 1.14)),
                    cc.ScaleTo:create(0.16, 0.85),
                    cc.ScaleTo:create(0.2, 1)
                ))
            end),
            cc.DelayTime:create(0.67),
            cc.CallFunc:create(function( ... )
                local btn = theDialog.collectRoot:getChildByName("btn_collect")
                btn:setTouchEnabled(true)
                if bole.isValidNode(self.freeCollectSpine) then
                    bole.spChangeAnimation(self.freeCollectSpine, "animation2_1", true)
                end
            end)
        ))
	end
end

function cls:playStartFreeSpinDialog( theData )
    self:playMusic(self.audio_list.trigger_bell)
    self.isFreeGameRecoverState = true
    self.isBaseTofree = true
	local enterEvent = theData.enter_event
	theData.enter_event = function ( ... )
		enterEvent()
		self:playMusic(self.audio_list.free_dialog_start_show)
	end

	local changeLayer_event = theData.changeLayer_event
	theData.changeLayer_event = function()
		local index = tostring(self.ctl:getCurTotalBet())

		if changeLayer_event then
			changeLayer_event()
        end
        if self.freeType == 1 then
            self:changeSpinBoard(SpinBoardType.FreeSpin) -- 更改棋盘显示 背景 和 free 显示类型
        else
            self:changeSpinBoard(SpinBoardType.Map_FreeSpin)
        end
	end

	local click_event = theData.click_event
	theData.click_event = function()
		self:playMusic(self.audio_list.common_click)
        self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function( ... )
                self.freeNum:runAction(cc.Sequence:create(
                    cc.ScaleTo:create(0.3, 1.2),
                    cc.ScaleTo:create(0.15, 0.0001)
                ))
            end),
            cc.DelayTime:create(0.2),
            cc.CallFunc:create(function( ... )
                if bole.isValidNode(self.freeStartSpine) then
                    bole.spChangeAnimation(self.freeStartSpine, "animation2_2", false)
                end
                self.freeStartBtn:runAction(cc.Sequence:create(
                    cc.ScaleTo:create(0.3, 1.2),
                    cc.ScaleTo:create(0.15, 0.0001)
                ))
            end),
            cc.DelayTime:create(0.4),
            cc.CallFunc:create(function( ... )
                local function func()
                    -- self:resetBaseUI()
                    self:changeSpinBoard(SpinBoardType.Map_FreeSpin)
                    self.mapCollectRoot:setVisible(false)
                    -- self.bonusLevel = 1
                end
                self:playTransition(func, nil, "map", true)
            end)
        ))
		if click_event then
			click_event()
		end
		self.ctl.footer:enableOtherBtns(false)
	end
	
	local endEvent = theData.end_event
	theData.end_event = function ( ... )
        endEvent()
		self:dealMusic_PlayFreeSpinLoopMusic()
		self:dealMusic_FadeLoopMusic(0.3, 0.3, 1) -- 恢复背景音乐
    end
    self:showFreeSpinDialog(theData, fs_show_type.start)
end

function cls:playCollectFreeSpinDialog( theData )
    self.isFreeGameRecoverState = false
	local click_event = theData.click_event
	theData.click_event = function()
        self:playMusic(self.audio_list.common_click)
        if self.freeType == 2 then
            if self.mapLevel >= maxMapLevel then
                self.mapLevel = 0
            end
            self:setNextCollectTargetImage(self.mapLevel)
            self.mapPoints = 0
            self:setCollectProgressImagePos(0)
            self.mapFreeExtraSpins = 0
        end
        self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function( ... )
                self.freeWinLabel:runAction(cc.Sequence:create(
                    cc.ScaleTo:create(0.3, 1.2),
                    cc.ScaleTo:create(0.15, 0.0001)
                ))
            end),
            cc.DelayTime:create(0.1),
            cc.CallFunc:create(function( ... )
                if bole.isValidNode(self.freeCollectSpine) then
                    bole.spChangeAnimation(self.freeCollectSpine, "animation1_2", false)
                end
                if bole.isValidNode(self.freeCollectBtn) then
                    self.freeCollectBtn:runAction(cc.Sequence:create(
                        cc.ScaleTo:create(0.3, 1.2),
                        cc.ScaleTo:create(0.15, 0.0001)
                    ))
                end
            end),
            cc.DelayTime:create(1),
            cc.CallFunc:create(function( ... )
                local function func()
                    self.mapCollectRoot:setVisible(true)
                end
                self:playTransition(func, nil, "map", true)
            end)
        ))
        if click_event then
			click_event()
        end
	end

	local endEvent = theData.end_event
	theData.end_event = function( ... )
		endEvent()
		self:dealMusic_FadeLoopMusic(0.3, 0.3, 1)-- 恢复背景音乐
	end

	self:showFreeSpinDialog(theData, fs_show_type.collect)
end

function cls:freeStartClicked( callFunc,isMore) -- 点击之后 切换界面
	if isMore then -- retriger
		if self.curBoardCnt and self.nextBoardCnt and self.nextBoardCnt > self.curBoardCnt then -- 特殊处理
			self.curBoardCnt = self.nextBoardCnt
		else
            if callFunc then
				callFunc()
			end
		end
	else
		if callFunc then
			callFunc()
		end
	end
end

function cls:enterFreeSpin( isResume ) -- 更改背景图片 和棋盘
	self:enableFeatureBtn(false)
    self:enableStoreBtn(false)
    if isResume then  -- 断线重连的逻辑
        if self.freeType == 1 then
            self:changeSpinBoard(SpinBoardType.FreeSpin)
            self.freeLogo:setVisible(true)
        else
            self:changeSpinBoard(SpinBoardType.Map_FreeSpin)
        end
		--  更改棋盘显示 背景 和 free 显示类型		
		self:dealMusic_PlayFreeSpinLoopMusic()-- 切换背景音乐
        self.enterThemeSWPos = nil
	end
	self:showAllItem()
	self.playNormalLoopMusic = false --commonMusic: freespin背景音乐
end

function cls:showFreeSpinNode( count, sumCount, first)
    Theme.showFreeSpinNode(self,count, sumCount, first)
    if self.superAvgBet then
        self.ctl:setPointBet(self.superAvgBet)-- 更改 锁定的bet
        self.ctl.footer:changeFreeSpinLayout3()-- 隐藏掉  footer bet
    end
    self.freeMapLevel = self.mapLevel
    if self.mapPoints and self.mapPoints >= maxMapPoint and self.mapLevel and self.mapLevel == 0 then
        self.freeMapLevel = maxMapLevel
    end
	self:dealMusic_PlayFreeSpinLoopMusic()
end

function cls:hideFreeSpinNode( ... )
	if self.freeSavedCoinState then
		local index = tostring(self.ctl:getCurTotalBet())
	end
	self:changeSpinBoard(SpinBoardType.Normal)

    self:cleanCellState()
        
	if self.ctl:noFeatureLeft() then
		self:enableFeatureBtn(true)
		self:enableStoreBtn(true)
	end

    if self.superAvgBet then
        self.superAvgBet = nil
        self.ctl.footer:changeNormalLayout2()
    end

    -- self.lockedReels = nil
    
    self.freeType = nil

    self.freeMapLevel = nil
	Theme.hideFreeSpinNode(self, ...)
end

function cls:updatedFreeSpinCount(remainingCount, totalCount)-- 更新上部RemainingCount和PlayedCount的Label
	self:refershFreeLabelsCount(remainingCount,totalCount) -- 主题内自己 进行计数统计的逻辑
	Theme.updatedFreeSpinCount(self,remainingCount, totalCount)
end

function cls:refershFreeLabelsCount(leftCnt, sumCnt)
	if self.freeCur and self.freeSum then
		self.freeCur:setString(sumCnt-leftCnt)
		self.freeSum:setString(sumCnt)
	end
end

---------------------------------- free spin end ----------------------------------

function cls:playTransition(endCallBack1, endCallBack2, tType, showActivityB)
	local function delayAction()
		local transition = PowerSlotTransition.new(self, endCallBack1, endCallBack2)
		transition:play(tType,showActivityB)
	end
	delayAction()
end

-- 切屏
PowerSlotTransition = class("PowerSlotTransition", CCSNode)
local GameTransition = PowerSlotTransition

function GameTransition:ctor(theme, endCallBack1, endCallBack2)
	self.spine = nil
	self.theme = theme
    self.endFunc1 = endCallBack1
    self.endFunc2 = endCallBack2
end

function GameTransition:play(tType,showActivityB)
    local spineFile = self.theme:getPic("spine/transition_respin/spine") -- 默认显示 Free transition
    local musicFile = self.theme.audio_list.bonus1
    if tType == "map" then
        spineFile = self.theme:getPic("spine/transition_map/spine")
        musicFile = self.theme.audio_list.map1
    end
	local pos = cc.p(0,0)
    local delay1 = transitionDelay[tType]["onCover"] -- 切屏结束 的时间
	local delay2 = transitionDelay[tType]["onEnd"] -- 切屏结束 的时间
	self.theme.curScene:addToContentFooter(self,1000)
	bole.adaptTransition(self,true,true)
    self:setVisible(false)
    self:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.1),
        cc.CallFunc:create(function()
            if self.theme.ctl.footer then
                self.theme.ctl.footer:hideActivitysNode()
            end
            self:setVisible(true)
            self.theme:dealMusic_FadeLoopMusic(0.3, 1, 0)
			self.theme:playMusic(musicFile)
            if not spineFile then return end
            self.theme:addSpineAnimation(self, nil, spineFile, pos, "animation1")
        end),
        cc.DelayTime:create(delay1), -- 切屏动画完成时间
		cc.CallFunc:create(function ( ... )
            if self.endFunc1 then
                self.endFunc1()
            end
		end),
		cc.DelayTime:create(delay2 - delay1), -- 切屏动画完成时间
        cc.CallFunc:create(function ( ... )
            if self.endFunc2 then
                self.theme:dealMusic_FadeLoopMusic(0.3, 0, 1)
                self.endFunc2()
            end
            if showActivityB and self.theme.ctl.footer then
                self.theme.ctl.footer:showActivitysNode()
            end
        end),
        cc.RemoveSelf:create()
    ))
end

--------------------------------------- bonus game start -------------------------------------

function cls:playBonusAnimate(theGameData)
    local delay = 0
    if theGameData.type == 3 then -- mapfree
        -- 播放respin中奖动画
        delay = 0
    elseif theGameData.type == 1 or theGameData.type == 2 then -- amap wheel
        delay = 0
    elseif theGameData.type == 4 then 
        self:playWinRespinAnim()
        delay = 2
    end
    return delay
end

function cls:playWinRespinAnim()
    -- self.animateNode:removeAllChildren()
    -- for col = 1, 5 do
    --     for row = 1, 4 do
    --         local cell = self.spinLayer.spins[col]:getRetCell(row)
    --         if bole.isValidNode(cell) and bole.isValidNode(cell.sprite) then
    --             cell.sprite:setVisible(true)
    --         end
    --     end
    -- end
    -- self.scatterPosList = self.scatterPosList or {}
    self:playMusic(self.audio_list.bell)
    for k, pos in pairs(self.scatterPosList) do
        local position = self:getCellPos(pos[1], pos[2])
        local cell = self.spinLayer.spins[pos[1]]:getRetCell(pos[2])
        local _, s1 = self:addSpineAnimation(self.themeAnimateKuang, 1000, self:getPic("spine/respin/win_respin/spine"), position, "animation", nil, nil, nil, true, true)
        local _, s2 = self:addSpineAnimation(self.themeAnimateKuang, 1000, self:getPic("spine/item/19/spine"), position, "animation4", nil, nil, nil, true, true)
        cell:setVisible(false)
    end
end

function cls:removeScatterWinAnim()
    for i = 1, 5 do
        for j = 1, 4 do
            local cell = self.spinLayer.spins[i]:getRetCell(j)
            cell:setVisible(true)
        end
    end
    self.scatterPosList = {}
end

--断线重连
function cls:enterThemeByBonus(theBonusGameData, endCallFunc)
	self.ctl:open_old_bonus_game(theBonusGameData, endCallFunc)
end

function cls:theme_deal_show(ret)
	ret.theme_deal_show = nil
	if self.respinStep == ReSpinStep.Over then
        if self.showReSpinBoard and self.bonus then 
            self.bonus:onRespinFinish_normal()
            self:checkIsNeedRespinAntic()
		end
	end
end

function cls:checkCanSetStopBtn()
    if self.showReSpinBoard then
        return false
    end
    return true
end

function cls:theme_respin( rets )
	self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(function()
		local respinList = rets["theme_respin"]
		
		if respinList and #respinList>0 then
			rets["item_list"] = table.remove(respinList, 1)			
			local respinStopDelay = 0.5
			local endCallFunc 	  = self:getTheRespinEndDealFunc(rets)
            self:stopDrawAnimate()
            -- self.ctl.autoSpin = true
            -- self.ctl.autoSpinCount = 0
			self.ctl:respin(respinStopDelay, endCallFunc)
		else
			rets["theme_respin"] = nil
		end	
	end)))
end

---------------------------------Collect相关-----------------------------------------------
local mapLevelConfig = {
    1,2,1,3,
    1,1,2,1,3,
    1,1,4,
    1,1,2,1,1,5,
    1,2,1,3,
    1,1,3,
    1,1,2,1,1,5,
    1,2,1,4,
    1,1,2,1,4,
    1,2,1,4,
    1,2,1,5,
    1,1,2,1,5,
    1,1,3,
    1,1,1,2,1,4,
    1,2,1,4,
    1,1,3,
    1,1,2,1,1,4,
    1,2,1,4,
    1,1,2,1,5,
    1,2,1,4,
    1,2,1,5,
    1,1,1,2,1,1,1,5
} -- 1:红 / 2:蓝 / 3:小 / 4:中 / 5: 大

function cls:setNextCollectTargetImage(level)
	level = level + 1
	if level > maxMapLevel then
	   level = 1
	end
	
	for i = 1,5 do
		self.nextLevelImageList[i]:setVisible(i == mapLevelConfig[level])
	end
end

function cls:setCollectProgressImagePos(map_points)
	if map_points > maxMapPoint then
		map_points = maxMapPoint
	elseif map_points < 0 then
		map_points = 0
	end

	self.mapPoints = map_points
	local cur_posX = self.movePerUnit * map_points + self.progressStartPosX

	self.collectCoinProgressImage:setPosition(cc.p(cur_posX,self.progressPosY))
    self.collectCoinAniNode:setPosition(cc.p(cur_posX,self.progressPosY))
end

function cls:showProgressAnimation(map_points)
	if map_points > maxMapPoint then
		map_points = maxMapPoint
	elseif map_points < 0 then
		map_points = 0
	end

	local oldPosX = self.movePerUnit * self.mapPoints + self.progressStartPosX
	local startPos = cc.p(oldPosX,self.progressPosY)

	local newPosX = self.movePerUnit * map_points + self.progressStartPosX
	local endPos = cc.p(newPosX,self.progressPosY)

	self.mapPoints = map_points

    self.collectCoinProgressImage:setPosition(startPos)
    self.collectCoinProgressImage:runAction(cc.MoveTo:create(0.5,endPos))
    self.collectCoinAniNode:setPosition(startPos)
    self.collectCoinAniNode:runAction(cc.MoveTo:create(0.5,endPos))

    if bole.isValidNode(self.mapProgressSpine) then
        bole.spChangeAnimation(self.mapProgressSpine, "animation2", false)
        self:laterCallBack(0.5, function( ... )
            bole.spChangeAnimation(self.mapProgressSpine, "animation1", true)
        end)
    else
        self:addSpineAnimation(self.collectCoinAniNode, 2, self:getPic("spine/map/progress/spine"), cc.p(0, 0), "animation2")
    end
    self:playMusic(self.audio_list.progress_collect)

	self:laterCallBack(0.5,function( ... )
        if self.mapPoints >= maxMapPoint then
            self:playMusic(self.audio_list.map_full)
            self:addSpineAnimation(self.winCoinAniNode, 2, self:getPic("spine/map/progress/spine"), cc.p(0, 0), "animation3")
            if bole.isValidNode(self.nextLevelImageSpineList[mapLevelConfig[self.mapLevel]]) then
                bole.spChangeAnimation(self.nextLevelImageSpineList[mapLevelConfig[self.mapLevel]], "animtion"..mapLevelConfig[self.mapLevel].."_1", false)
            end
            self:laterCallBack(3, function( ... )
                if bole.isValidNode(self.nextLevelImageSpineList[mapLevelConfig[self.mapLevel]]) then
                    bole.spChangeAnimation(self.nextLevelImageSpineList[mapLevelConfig[self.mapLevel]], "animtion"..mapLevelConfig[self.mapLevel], true)
                end
            end)
		end
	end)
end

function cls:setCollectProgress(map_points)
	posX = self.movePerUnit * map_points + self.progressStartPosX
	self.collectCoinProgressImage:setPosition(cc.p(posX,self.progressPosY))
	self.collectCoinAniNode:setPosition(cc.p(posX,self.progressPosY))
end

function cls:showCoinsFlyToUp()
    local item_list = self.item_list

	local endPos = cc.p(85, 536)
	local isPlay = false
	local isFly = false
	for i = 1,5 do
		for j = 1,4 do
            if item_list[i][j] >= 13 then -- bonus会收集
				local node = cc.Node:create()
				local pos = self:getCellPos(i,j)
				node:setPosition(pos)
				self.reelCoinFlyLayer:addChild(node,j)

				local spine_file = self:getPic("spine/map/map_symbol/spine")
				local spine_pos = cc.p(0,0)

				-- self:runAction(cc.Sequence:create(
                --     cc.CallFunc:create(function()
                --         if bole.isValidNode(node) then
                --             local particleFile = self:getPic("particles/map_collect/bouns_lizi_tuowei_1.plist")
                --             local s1 = cc.ParticleSystemQuad:create(particleFile)
                --             node:addChild(s1)
                --             s1:setPosition(cc.p(0, 0))
                --         end

                --         -- if bole.isValidNode(node) then
    			-- 		-- 	_,spine = self:addSpineAnimation(node,nil,spine_file,spine_pos,"animation",nil,nil,nil,true,false,nil)
                --         -- end
				-- 	end),
				-- 	-- cc.DelayTime:create(0.3),
				-- 	cc.CallFunc:create(function()
                --         if bole.isValidNode(node) then
                --             node:runAction(cc.Sequence:create(
                --                 cc.MoveTo:create(0.5, endPos),
                --                 cc.DelayTime:create(1),
                --                 cc.RemoveSelf:create()
                --             ))
                --             self:runAction(cc.Sequence:create(
                --                 cc.DelayTime:create(0.4),
                --                 cc.CallFunc:create(function( ... )
                --                     self:addSpineAnimation(self.rabbitAnimNode, nil, self:getPic("spine/map/collect_head/spine"), cc.p(0,0), "animation", nil, nil, nil, false, false, nil)
                --                 end)
                --             ))
    			-- 			if not isFly then
    			-- 				isFly = true
    			-- 			    self:playMusic(self.audio_list.map_collect)
    			-- 			end
                --         end
				-- 	end)
                -- ))
                
                if bole.isValidNode(node) then
                    local particleFile = self:getPic("particles/map_collect/bouns_lizi_tuowei_1.plist")
                    local s1 = cc.ParticleSystemQuad:create(particleFile)
                    node:addChild(s1)
                    s1:setPosition(cc.p(0, 0))
                end

                if bole.isValidNode(node) then
                    node:runAction(cc.Sequence:create(
                        cc.MoveTo:create(0.5, endPos),
                        cc.DelayTime:create(1),
                        cc.RemoveSelf:create()
                    ))
                    self:runAction(cc.Sequence:create(
                        cc.DelayTime:create(0.4),
                        cc.CallFunc:create(function( ... )
                            self:addSpineAnimation(self.rabbitAnimNode, nil, self:getPic("spine/map/collect_head/spine"), cc.p(0,0), "animation", nil, nil, nil, false, false, nil)
                        end)
                    ))
                    if not isFly then
                        isFly = true
                        self:playMusic(self.audio_list.map_collect)
                    end
                end
			end
		end
	end	
end

function cls:parabolaToAnimation(obj,col,row,from,to,duration)
	local radian_config = 
	{
       {{-50,50},{-50,60},{-50,75}},{{-60,30},{-60,40},{-60,55}},{{-70,-30},{-70,-40},{-70,-55}},{{-80,-50},{-80,-60},{-80,-75}},{{-90,-50},{-90,-60},{-90,-75}},
    }
	local from = from or self:getCellPos(i,j)
	local to = to or cc.p(0,0)
	local config = radian_config[col][row]

	local myBezier = function (p0, p1, p2, duration, frame)
		local t = frame / duration
		if t > 1 then t = 1 end
		local x = math.pow(1-t,2)*p0.x + 2*t*(1-t)*p1.x + math.pow(t,2)*p2.x
		local y = math.pow(1-t,2)*p0.y + 2*t*(1-t)*p1.y + math.pow(t,2)*p2.y

		return cc.p(x,y)
	end

	local cp = cc.p(from.x + config[1], from.y + config[2])
	local frame = 1
    obj:runAction(cc.Repeat:create(cc.Sequence:create(
    cc.CallFunc:create(function () 
        frame = frame or 1
        local pos = myBezier(from, cp, to, duration*60, frame)
        obj:setPosition(pos)
        frame = frame + 1
    end),
    cc.DelayTime:create(1/60)
    ), duration*60))
end

function cls:enableMapInfoBtn(enable) -- 直接开启按钮，通过其他的判断控制是否可以点击
    -- 点击按钮
    local pressFunc = function(obj)  
        self:playMusic(self.audio_list.common_click)
        local theGameData = {}

        local data = {}
        data["mapLevel"] = self.mapLevel

        local theDialog = ThemePowerSlotMapGame.new(self, self:getPic("csb/"), data)
        theDialog:showMapScene(false, false, true)
    end

    local function onTouch(obj, eventType)
        if not self.showBaseSpinBoard then
            return
        end
        if self.isInBonusGame then
            return 
        end
        if self.isFeatureClick then
            return 
        end
        if self.isShowMap then
            return
        end
        if eventType == ccui.TouchEventType.began then
            self:changeMapInfoSpineColor(cc.c3b(125,125,125))
        elseif eventType == ccui.TouchEventType.moved then
            self:changeMapInfoSpineColor(cc.c3b(125,125,125))
        elseif eventType == ccui.TouchEventType.ended then
            self:changeMapInfoSpineColor(cc.c3b(255,255,255))
            self:playMusic(self.audio_list.common_click)
            pressFunc(obj)
        elseif eventType == ccui.TouchEventType.canceled then
            self:changeMapInfoSpineColor(cc.c3b(255,255,255))
        end
    end

    -- 设置按钮
    self.btn_mapInfo:addTouchEventListener(onTouch)
end

function cls:changeMapInfoSpineColor(color)
    for i = 1, 5 do
        if bole.isValidNode(self.nextLevelImageList[i]) then
            self.nextLevelImageList[i]:setColor(color)
        end
    end
end

function cls:playlittleScrollAnimation( ... )
	local parent = self.l_scroll_aniNode
	local file = self:getPic("spine/little_scroll/spine")
	local aniName = ""
	local function callback( ... )
		if aniName == "animation1" then
			aniName = "animation2"
		else
			aniName = "animation1"
		end

		self:runAction(cc.Sequence:create(
			cc.DelayTime:create(2),
			cc.CallFunc:create(function()
				s:setAnimation(0,aniName,false)
			end)
		))

	end
	local _, s = self:addSpineAnimation(parent,nil,file,cc.p(0,0),"animation1",callback,nil,nil,true,false,nil)
end

function cls:lockJp()
end

function cls:unlockJp()
end

function cls:setCollectPartState(active,isAnimate)
    self.btn_mapInfo:setTouchEnabled(active)
    self.btn_mapInfo:setVisible(active)
    local function initCollectBtnEvent()
	    -- 点击按钮
        local pressFunc = function(obj)
            -- if not self.showBaseSpinBoard then
            --     return
            -- end
            -- if self.isInBonusGame then
            --     return 
            -- end
            -- if self.isFeatureClick then
            --     return 
            -- end
            -- if self.isShowMap then
            --     return
            -- end
            if not self.isLocked then -- 解锁状态点击出气泡
                -- if not self.isShowPopUp then
                --     self.popupNode:runAction(cc.Sequence:create(
                --         cc.CallFunc:create(function( ... )
                --             self.isShowPopUp = true
                --         end),
                --         cc.FadeTo:create(1, 255),
                --         cc.DelayTime:create(1.5),
                --         cc.FadeTo:create(1, 0),
                --         cc.CallFunc:create(function( ... )
                --             self.isShowPopUp = false
                --         end)
                --     ))
                -- end
                return
            end

            local openLock = self:setBet()
            if openLock then 
                -- self.btn_unLock:setVisible(false)
                -- self.btn_unLock:setTouchEnabled(false)
	            self:setCollectPartState(true,true)
            end
		end

		local function onTouch(obj, eventType)
			if eventType == ccui.TouchEventType.ended then
				pressFunc(obj)
			end
		end

		-- 设置按钮
		self.btn_unLock:addTouchEventListener(onTouch)
    end

	local file = self:getPic("spine/map/progress_suo/spine")
	local parent = self.lockAniNode
    if active then
        if self.isShowLockAnim then 
            self:unlockJp()
            -- self.btn_unLock:setTouchEnabled(false)
            -- self.btn_unLock:setVisible(false)
            self.isLocked = false
            
            local aniName = "animation2" -- 解锁
            self:playMusic(self.audio_list.collect_unlock)
            if self.collectLockSkeleton then
               self.collectLockSkeleton:setAnimation(0,aniName,false)
            else
                local _,s = self:addSpineAnimation(parent,nil,file,cc.p(0,0),aniName,nil,nil,nil,true,false,nil)
                self.collectLockSkeleton = s 
            end
            self.isShowLockAnim = false
        end
    else
        if not self.isShowLockAnim then 
            self:lockJp()
            local aniName = "animation1" -- 上锁
            self.isLocked = true
    
            if isAnimate then
                self:playMusic(self.audio_list.collect_lock)
            end
            if self.collectLockSkeleton then
               self.collectLockSkeleton:setAnimation(0,aniName,false)
            else
                local _,s = self:addSpineAnimation(parent,nil,file,cc.p(0,0),aniName,nil,nil,nil,true,false,nil)
                self.collectLockSkeleton = s 
            end
            
            local maxBet = self.ctl:getMaxBet()
            
            -- if maxBet >= self.collectUnlockBet then
            -- end
            self.isShowLockAnim = true
        end
    end
    
    self.btn_unLock:setVisible(true)
    self.btn_unLock:setTouchEnabled(true)
    initCollectBtnEvent()
end

function cls:getBonusTriggerItemList()

	local item_list = self.ctl:getRetMatrix()

	return item_list
end

PowerSlotBonus = class("PowerSlotBonus")
local bonusGame = PowerSlotBonus

function bonusGame:ctor(bonusCtl, theme, csbPath, data, callback)
    self.bonusCtl = bonusCtl
    self.theme    = theme
    self.ctl      = self.theme.ctl
    self.csbPath  = csbPath
    self.data     = data
    self.callback = callback
    self.endCallBack = callback
    self.theme.bonus = self


    if self.data.core_data["theme_respin"] then
        self.allSpinCount = self.data.core_data["theme_respin_count"]
        
		self.data.bonusItem = self.data.bonusItem or self.theme:getBonusTriggerItemList()
        self.data.currentBet = self.data.currentBet or self.ctl:getCurTotalBet() -- 当前bet
        self.data.respinData = self.data.respinData or tool.tableClone(self.data.core_data["theme_respin"])
        self:fixRespinData()
        self.reSpinData = tool.tableClone(self.data.respinData)
        self:saveBonus()

        -- self.theme.normalRespin = true
        self.ctl.rets.theme_respin = tool.tableClone()
	elseif self.data.core_data["map_ls_spin"] then
		self.data.recoverItem = self.data.recoverItem or self.theme:getBonusTriggerItemList()
		
		self.data.isMapShow = self.data.isMapShow or false
		self.data.lsSpinCount = self.data.lsSpinCount or 0
		self.data.mapLevel = self.theme.mapLevel or 1
		self.data.slotBet = self.data.core_data["map_ls_spin"]["avg_bet"]
		
		self:saveBonus()
		-- self.bonusType = BonusType.MapReSpin
		self.theme.mapSlot = true
		
	elseif self.data.core_data["map_fg_spin"] then
		-- self.data.mapLevel = self.theme.mapLevel or 1 
		-- if self.data.mapLevel == 0 then
		-- 	self.data.mapLevel = maxMapLevel -- 32
		-- end
		-- self.data.fgSpinCount = self.data.fgSpinCount or 0
		-- self.data.recoverMapFreeItem = self.data.recoverMapFreeItem or self.theme:getBonusTriggerItemList()
		
		-- self:saveBonus()
		-- self.sumFreeSpinCount = 10
		-- self.mapFreeItemListData = tool.tableClone(self.data.core_data["map_fg_spin"]["item_list"])
		-- self.mapFreeUpListData = tool.tableClone(self.data.core_data["map_fg_spin"]["up"])
		-- self.mapFreeDownListData = tool.tableClone(self.data.core_data["map_fg_spin"]["down"])
		-- self.mapFreeTotalWinListData = self.data.core_data["map_fg_spin"]["total_win_list"]
		-- self.mapFreeWinPosListData = self.data.core_data["map_fg_spin"]["win_pos"]
		-- self.mapFreeAllWin = self.data.core_data["map_fg_spin"]["map_total_win"]
		-- self.mapFreeBet = self.data.core_data["map_fg_spin"]["avg_bet"]
		-- -- self.bonusType = BonusType.MapFreeGame

		-- self.theme.mapFree = true
	end
end

function bonusGame:onExit( ... )
	if self.theme.miniWheel then 
		if self.theme.miniWheel.scheduler then 
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.theme.miniWheel.scheduler)
			self.theme.miniWheel.scheduler = nil
		end
    end
    self.theme.bonus = nil
end

function bonusGame:enterBonusGame(isResume)
    self.theme.isInBonusGame = true
    self.bonusType = self.data.core_data["type"]
    self.ctl.footer:setSpinButtonState(true)
    if self.data.core_data["map_fg_spin"] then
        self.bonusType = 3
    end
    if self.bonusType == 1 or self.bonusType == 2 then
        self:enterMapWheelGame(isResume)
    elseif self.bonusType == 3 then
        self:enterMapFreeGameBonus(isResume)
    elseif self.bonusType == 4 then
        self:enterRespinGame(isResume)
    end
end

function bonusGame:saveBonus()
	LoginControl:getInstance():saveBonus(self.theme.themeid, self.data)
end

------------------------------------- respin start --------------------------------
function bonusGame:enterRespinGame(isResume)
    self.ctl.footer.isRespinLayer = true
    -- self.theme:enableFeatureBtn(false)
    if isResume then
        self.callback = function ( ... )
            -- 断线重连回调方法
            local endCallFunc2 = function ( ... )
                if self.ctl:noFeatureLeft() then -- whj 1.2 添加控制之后还有feature的时候控制 按钮不可以点击
                    self.theme.ctl.footer:setSpinButtonState(false)
                end
                
                if self.endCallBack then 
                    self.endCallBack()
                end 

                self.ctl.isProcessing = false           
            end         
            endCallFunc2()
        end
        self.ctl.isProcessing = true
    end 

    self:initRespinData(isResume)
    if self.data.respinProgress == 0 then
        self:playRespinStartDialog()
    else
        self:initRespinScene(2, true)
    end
end

function bonusGame:initRespinData(isResume)
    if self.data and self.data.core_data then
        self.respinBonusData = self.data.core_data
    end
    self.winPos = self:getWinPosList()
    self.respinBaseItem = self.data.core_data.item_list
    self.jpWin = self.respinBonusData.jackpot_win or 0
    self.jpWinList = tool.tableClone(self.respinBonusData.jackpot_list)
    self.bonusWin = self.respinBonusData.normal_win or 0
    self.respinWin = self.jpWin + self.bonusWin
    self.curRespinTotalWin = self.respinBonusData.base_win or 0

    self.data.respinProgress = self.data.respinProgress or 0
    self.data.respinSpins = self.data.respinSpins or 3
    self.data.respinCount = self.data.respinCount or 1
    self:saveBonus()
    self:updateRespinData()
end

function bonusGame:fixRespinData()
    for boardIndex, boardList in pairs(self.data.respinData) do
        for row, cowList in pairs(boardList) do
            for col, key in pairs(cowList) do
                if key == 0 then
                    self.data.respinData[boardIndex][row][col] = math.random(3, 11)
                end  
            end
        end
    end
end

function bonusGame:getWinPosList()
    local list = {}
    local respinResult = tool.tableClone(self.reSpinData[#self.reSpinData])
    local pos = 0
    for row, cowList in pairs(respinResult) do
        for col, key in pairs(cowList) do
            pos = pos + 1
            table.insert(list, {pos, key}) 
        end
    end
    return list
end

function bonusGame:updateRespinData()
    for i = 1, self.data.respinCount do
        self.data.respinBoardData = table.remove(self.reSpinData, 1)
    end
    self:getFakeBoardData()
end

function bonusGame:getFakeBoardData()
    self.fakeSymbolList = {}
    for col, reel in pairs(self.data.respinBoardData) do
        for row, item in pairs(reel) do
            if col <= 4 then
                table.insert(self.fakeSymbolList, item)
            end
        end
    end
end

function bonusGame:playRespinStartDialog()
    self:resetBaseBoard()
    local path = self.theme:getPic("csb/respin_start_dialog.csb")
    local dialog = cc.CSLoader:createNode(path)
    -- self.theme.respinStartDialogNode:addChild(dialog)
    self.theme.mainThemeScene:addChild(dialog)
    dialog:setScale(0.9)
    local dimmer = dialog:getChildByName("dimmer")
    dimmer:setOpacity(0)
    local root = dialog:getChildByName("root")
    local animNode = root:getChildByName("anim_node")
    self.respinStartBtn = root:getChildByName("btn")
    self.respinStartBtn:setTouchEnabled(false)
    local function onTouch()
        self.respinStartBtn:setTouchEnabled(false)
        dialog:runAction(cc.Sequence:create(
            cc.CallFunc:create(function( ... )
                self:initRespinScene(1)
                if bole.isValidNode(root) then
                    root:runAction(cc.Sequence:create(cc.ScaleTo:create(0.3, 1.2), cc.ScaleTo:create(0.15, 0.0001)))
                end
                if bole.isValidNode(dimmer) then
                    dimmer:runAction(cc.FadeTo:create(0.4, 0))
                end
            end),
            cc.DelayTime:create(1),
            cc.CallFunc:create(function( ... )
                self:respinBoardUp()
                if not self.data.respinProgress or self.data.respinProgress == 0 then
                    self.data.respinProgress = 1
                    self:saveBonus()
                end
            end),
            cc.RemoveSelf:create()
        ))
    end
    self.respinStartBtn:addTouchEventListener(onTouch)

    local spinDelay = 70/30
    self.theme:runAction(cc.Sequence:create(
        cc.CallFunc:create(function( ... )
            if self.theme.ctl.footer then 
                self.theme.ctl.footer:hideActivitysNode()
            end
            if bole.isValidNode(dimmer) then
                dimmer:runAction(cc.FadeTo:create(0.4, 180))
            end
            local _, s = self.theme:addSpineAnimation(root, nil, self.theme:getPic("spine/dialog/respin_start/spine"), cc.p(0, 0), "animation1", nil, nil, nil, true, false)
            self.respinStartSpine = s
        end),
        cc.DelayTime:create(spinDelay),
        cc.CallFunc:create(function( ... )
            if bole.isValidNode(self.respinStartSpine) then
                bole.spChangeAnimation(self.respinStartSpine, "animation2", true)
            end
            self.respinStartBtn:setTouchEnabled(true)
        end)
    ))
end

function bonusGame:setBoardFirstThreeVisible(respinCol, visible)
    local cell = self.theme.spinLayer.spins[respinCol]:getRetCell(1)
    local cellUp = self.theme.spinLayer.spins[respinCol]:getRetCell(0)
    local cellDown = self.theme.spinLayer.spins[respinCol]:getRetCell(2)
    cell:setVisible(visible)
    cellUp:setVisible(visible)
    cellDown:setVisible(visible)
    self.theme.fakeRespinBoardNodeList[respinCol]:setVisible(not visible)
end

function bonusGame:respinBoardUp()
    self.theme:runAction(cc.Sequence:create(
        cc.CallFunc:create(function( ... )
            local delay = 0.4
            for i = 3, 5 do
                self.theme.respinBoardList[i]:runAction(cc.Sequence:create(
                    cc.MoveTo:create(delay, cc.p(respinBoardEndPos[i][1], respinBoardEndPos[i][2]))
                ))
            end
        end),
        cc.DelayTime:create(0.35),
        cc.CallFunc:create(function( ... )
            self.theme:playMusic(self.theme.audio_list.reel_raise)
            self.theme.respinBoardList[2]:runAction(cc.Sequence:create(
                cc.MoveTo:create(0.05, cc.p(respinBoardEndPos[2][1], respinBoardEndPos[2][2]))
            ))
        end),
        cc.DelayTime:create(0.2),
        cc.CallFunc:create(function( ... )
            local delay = 0
            for i = 1, 5 do
                for k, v in pairs(self.theme.respinBoardJpLabelList[6 - i]) do
                    if bole.isValidNode(v) then
                        v:setScale(0.0001)
                        v:setVisible(true)
                        v:runAction(cc.Sequence:create(
                            cc.DelayTime:create(delay),
                            cc.CallFunc:create(function( ... )
                                self.theme:playMusic(self.theme.audio_list.jp_shows)
                            end),
                            cc.ScaleTo:create(0.2, 1.2),
                            cc.ScaleTo:create(0.1, 1)
                        ))
                    end
                    self.theme.respinBoardList[6 - i]:runAction(cc.Sequence:create(
                        cc.DelayTime:create(delay),
                        cc.ScaleTo:create(0.2, 1.1),
                        cc.ScaleTo:create(0.1, 1)
                    ))
                end
                delay = delay + 0.2
            end
        end),
        cc.DelayTime:create(0.5),
        cc.CallFunc:create(function( ... )
            self:initSpinsRe()
        end)
    ))
end

function bonusGame:initRespinScene(progress, isResume)
    if self.theme.ctl.footer then 
        self.theme.ctl.footer:hideActivitysNode()
    end
    self.theme.fakeRespinSymbol = self.theme.fakeRespinSymbol or {}
    for k, v in pairs(self.theme.fakeRespinSymbol) do
        if bole.isValidNode(v) then
            v:removeFromParent()
            self.theme.fakeRespinSymbol[k] = nil
        end
    end
    -- self.theme.baseBgSmall:setVisible(false)
    self.theme:removeScatterWinAnim()
    self.theme:dealMusic_EnterRespinBonusGame()
    self.theme:changeSpinBoard(SpinBoardType.ReSpin)
    self:initRespinBoard()
    self.theme.respinSymbolNode:removeAllChildren()
    self.theme:stopRespinExcitation()

    self.respinSymbolFlyNode = cc.Node:create()
    self.theme.ctl.curScene:addToTop(self.respinSymbolFlyNode, 1000)
    self.respinSymbolFlyNode:setPosition(cc.p(-360, -640))

    self.respinSpinsNode = self.theme.reelList[2]:getChildByName("spins_node")
    self.respinSpinsNode:setVisible(false)
    self.respinSpinsLabelNode = self.respinSpinsNode:getChildByName("label_node")
    self.spins = self.respinSpinsLabelNode:getChildByName("spins")
    self.spinsImage = self.respinSpinsNode:getChildByName("image")

    if progress == 2 then
        for i = 1, 5 do
            for k, v in pairs(self.theme.respinBoardJpLabelList[i]) do
                if bole.isValidNode(v) then
                    v:setScale(0.0001)
                    v:setVisible(true)
                    v:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2, 1.2), cc.ScaleTo:create(0.1, 1)))
                end
            end
        end
        for i = 1, 5 do
            self.theme.respinBoardList[i]:setPosition(cc.p(respinBoardEndPos[i][1], respinBoardEndPos[i][2]))
            self.theme.respinBoardList[i]:setVisible(true)
        end
        self:initSpinsRe()
    else
        for i = 1, 5 do
            self.theme.respinBoardList[i]:setPosition(cc.p(respinBoardStartPos[i][1], respinBoardStartPos[i][2]))
            self.theme.respinBoardList[i]:setVisible(true)
        end
        for respinCol = 1, 14 do
            self:setBoardFirstThreeVisible(respinCol, false)
            self.theme.fakeRespinBoardNodeList[respinCol]:setScale(respinSymbolScale)
            local key = self.fakeSymbolList[respinCol]
            if key >= 13 and respinCol <= 9 then
                key = math.random(3, 7)
            end

            if key >= 13 then
                if key == 13 then
                    key = 14
                end
                local parent = self.theme.respinBoardList[respinBoardContentCfg[respinCol]]:getChildByName("fake_symbol_node")
                local posX = self.theme.fakeRespinBoardNodeList[respinCol]:getPositionX()
                local posY = self.theme.fakeRespinBoardNodeList[respinCol]:getPositionY()
                local pos = cc.p(posX, posY)
                -- local pos = cc.p(4, 5)
                self.theme:createRespinSymbol(parent, key, respinSymbolScale, true, pos)
                bole.updateSpriteWithFile(self.theme.fakeRespinBoardNodeList[respinCol], "#theme194_s_0.png")
                self.theme.fakeRespinBoardNodeList[respinCol]:setColor(cc.c3b(255, 255, 255))
            else
                bole.updateSpriteWithFile(self.theme.fakeRespinBoardNodeList[respinCol], "#theme194_s_"..key..".png")
                self.theme.fakeRespinBoardNodeList[respinCol]:setColor(cc.c3b(60, 60, 60))
            end
        end
    end
end 

function bonusGame:initSpinsRe()
    self:setRespinsNode()
    self.respinSpinsNode:setVisible(true)
    self.theme:laterCallBack(1, function( ... )
        for respinCol = 1, 14 do
            self:setBoardFirstThreeVisible(respinCol, true)
        end
        self:startRespin()
    end)
end

function bonusGame:updateSpinsRe(isFlesh)
    if isFlesh then
        local animNode = self.respinSpinsNode:getChildByName("anim")
        self.theme:addSpineAnimation(animNode, nil, self.theme:getPic("spine/respin/spins_change/spine"), cc.p(-207, 0), "animation", nil, nil, nil, false, false)
        self.data.respinSpins = 3
    end
    self:setRespinsNode()
end

function bonusGame:setRespinsNode()
    local imageFile = "#theme194_bonus_5.png"
    local spinsLabelNodeVisible = true
    local pos = cc.p(21, -2)
    if self.data.respinSpins == 1 then
        imageFile = "#theme194_bonus_6.png"
    elseif self.data.respinSpins <= 0 then
        self.data.respinSpins = 0
        imageFile = "#theme194_bonus_12.png"
        spinsLabelNodeVisible = false
        pos = cc.p(-14, -2)
    end

    self.respinSpinsLabelNode:setVisible(spinsLabelNodeVisible)
    self.spinsImage:setPosition(pos)
    bole.updateSpriteWithFile(self.spinsImage, imageFile)
    bole.updateSpriteWithFile(self.spins, "#theme194_bonus_"..self.data.respinSpins..".png")
end

function bonusGame:initRespinBoard()
    for respinCol = 1, 14 do
        self.theme.fakeRespinBoardNodeList[respinCol]:setVisible(false)
    end

    local _respinCol = 1
    for col, v in pairs(self.data.respinBoardData) do
        for row, data in pairs(v) do
            local cell = self.theme.spinLayer.spins[_respinCol]:getRetCell(1)
            local cellUp = self.theme.spinLayer.spins[_respinCol]:getRetCell(0)
            local cellDown = self.theme.spinLayer.spins[_respinCol]:getRetCell(2)
            if bole.isValidNode(cell.bonus) then
                cell.bonus:removeFromParent()
            end
            cell.sprite:setScale(respinSymbolScale)
            cellUp.sprite:setScale(respinSymbolScale)
            cellDown.sprite:setScale(respinSymbolScale)
            if data >= 13 then
                self.theme.lockedReels = self.theme.lockedReels or {}
                self.theme.lockedReels[_respinCol] = true

                self.theme:createRespinSymbol(cell, data, respinSymbolScale)
                cell.sprite:setColor(cc.c3b(255, 255, 255))
                cellUp.sprite:setColor(cc.c3b(60, 60, 60))
                cellDown.sprite:setColor(cc.c3b(60, 60, 60))
            else
                bole.updateSpriteWithFile(cell.sprite, "#theme194_s_"..data..".png")
                cell.sprite:setColor(cc.c3b(60, 60, 60))
                cellUp.sprite:setColor(cc.c3b(60, 60, 60))
                cellDown.sprite:setColor(cc.c3b(60, 60, 60))
            end
            _respinCol = _respinCol + 1
        end
    end
end

function bonusGame:startRespin()
    self.theme:getRespinExcitationData()
    local jpSpineHadAdd = {0, 0, 0, 0, 0}
    local isPlay = false
    for boardIndex = 1, 5 do
        -- local boardIndex = respinBoardContentCfg[col]
        if jpSpineHadAdd[boardIndex] == 0 and self.theme.respinExcitationData[boardIndex] and self.theme.respinExcitationData[boardIndex][1] and self.theme.respinExcitationData[boardIndex][1] == boardCellCountCfg[boardIndex] then
            jpSpineHadAdd[boardIndex] = 1
            if not isPlay then
                isPlay = true
                self.theme:playMusic(self.theme.audio_list.jp_win)
            end

            self.theme.jpWinLabelSpineListInboard = self.theme.jpWinLabelSpineListInboard or {}
            self.theme.jpWinLabelSpineListInboard[boardIndex] = self.theme.jpWinLabelSpineListInboard[boardIndex] or {}
            if bole.isValidNode(self.theme.jpWinLabelSpineListInboard[boardIndex][1]) then
                bole.spChangeAnimation(self.theme.jpWinLabelSpineListInboard[boardIndex][1], "animation"..boardIndex, true)
            else
                local _, s = self.theme:addSpineAnimation(self.theme.respinBoardJpLabelList[boardIndex][1], nil, self.theme:getPic("spine/respin/jp_win_label/spine"), cc.p(0, 10), "animation"..boardIndex, nil, nil, nil, true, true)
                self.theme.jpWinLabelSpineListInboard[boardIndex][1] = s
            end
            if bole.isValidNode(self.theme.jpWinLabelSpineListInboard[boardIndex][2]) then
                bole.spChangeAnimation(self.theme.jpWinLabelSpineListInboard[boardIndex][2], "animation"..boardIndex, true)
            else
                local _, ss = self.theme:addSpineAnimation(self.theme.respinBoardJpLabelList[boardIndex][2], nil, self.theme:getPic("spine/respin/jp_win_label/spine"), cc.p(0, 10), "animation"..boardIndex, nil, nil, nil, true, true)
                self.theme.jpWinLabelSpineListInboard[boardIndex][2] = ss
            end

            self.theme.jpWinSpineListInboard = self.theme.jpWinSpineListInboard or {}
            self.theme.jpWinSpineList = self.theme.jpWinSpineList or {}
            local animationIndex = boardIndex > 1 and 1 or 2
            local animation = "animation"..animationIndex
            local parent = self.theme.down_child:getChildByName("respin_win_jp_anim")
            local _, ss1 = self.theme:addSpineAnimation(parent, nil, self.theme:getPic("spine/respin/jp_win_board/spine"), cc.p(0, -30), "animation"..boardIndex, nil, nil, nil, true, true)
            self.theme.jpWinSpineListInboard[boardIndex] = ss1
            local _, ss2 = self.theme:addSpineAnimation(self.theme.jpAnimNodeListDown[boardIndex], nil, self.theme:getPic("spine/respin/jp_win/spine"), cc.p(0, 0), animation, nil, nil, nil, true, true)
            self.theme.jpWinSpineList[boardIndex] = ss2
        end
    end
    self.ctl.rets.theme_respin = tool.tableClone(self.reSpinData)

    if #self.ctl.rets.theme_respin > 0 then 
        self.theme:theme_respin(self.ctl.rets)
    else -- 是否有小游戏的相关逻辑在 主题里面自行判断
        self.theme.respinStep = ReSpinStep.Over 
        self:onRespinFinish_normal()
    end
end

function bonusGame:onRespinStart_normal()
    local delay = 0.5

    -- self.data.respinBoardOldData = self.data.respinBoardNewData or {}
    -- -- self.theme.oldLockedReels = self.theme.oldLockedReels or self.theme.oldLockedReels
    -- local col = 0
    -- for index, v in pairs(self.data.respinBoardOldData) do
    --     for row, key in pairs(v) do
    --         col = col + 1
    --         if key >= 13 and self.theme.oldOldLockedReels and (not self.theme.oldOldLockedReels[col]) then
    --             local pCol = col
    --             while true do
    --                 pCol = pCol + 1
    --                 if pCol >= 30 then -- 最后一个格子中了respin symbol
    --                     self.theme.lastPosWinBonusThisSpin = true
    --                 end
    --                 if not self.theme.oldOldLockedReels[pCol] then
    --                     break
    --                 end
    --             end
    --             -- if self.theme.lastPosWinBonus then
    --             --     self.theme.respinSpeedUpState[col] = self.theme.respinSpeedUpState[col] or {}
    --             --     self.theme.respinSpeedUpState[col][specialSymbol.bonus] = true
    --             -- end
    --         end
    --     end
    -- end

    if self.theme.lastPosWinBonus then
        -- self.theme.lastPosWinBonus = false
        delay = 2
    end
    self.theme:laterCallBack(delay, function( ... )
        self.theme.respinSymbolNode:removeAllChildren()
        self.theme:stopRespinExcitation()
        self:checkRespinNeedNotify()
        self.data.respinBoardNewData = table.remove(self.reSpinData, 1)
        self.theme.bonusItemListInrespin = self:getRespinItemList(self.data.respinBoardNewData)
        self:checkRespinSymbolNotify()
        self.data.respinCount = self.data.respinCount + 1
        self.data.respinSpins = self.data.respinSpins - 1
        self:updateSpinsRe(false)
        local index = 5
        self.theme.jpWinSpineListInboard = self.theme.jpWinSpineListInboard or {}
        for i = 1, 5 do
            if not self.theme.jpWinSpineListInboard[i] then
                index = i
            end
        end
        self.theme:checkRespinExcitation(index)
        -- self.theme:showBigBoard(index)
    end)
end

function bonusGame:onRespinFinish_normal( )
    self.theme.respinSymbolNode:removeAllChildren()
    self.theme:stopRespinExcitation()
    self.theme.respinToWinJpLoopAnimNode:removeAllChildren()
    self:doRespinWinAction()
end

function bonusGame:onRespinAllStop( ... ) -- 保存数据
    self.data.respinBoardData = tool.tableClone(self.data.respinBoardNewData)
    self:saveBonus()
end

function bonusGame:checkRespinNeedNotify()
    self.theme.respinSpeedUpState = {}
    for col = 1, respinCellCount do
        for k, v in pairs(self.theme.respinExcitationData) do
            if v[2] and col == v[2] and v[1] and v[1] == boardCellCountCfg[k] - 1 then
                self.theme.respinSpeedUpState[col] = self.theme.respinSpeedUpState[col] or {}
                self.theme.respinSpeedUpState[col][specialSymbol.bonus] = true
            end
        end
    end
end

function bonusGame:checkRespinSymbolNotify()
    self.theme.respinSymbolList = {}
    local col = 0
    for index, v in pairs(self.data.respinBoardNewData) do
        for row, key in pairs(v) do
            col = col + 1
            if key >= 13 and (not self.theme.lockedReels[col]) then

                self.theme.respinSymbolList[col] = self.theme.respinSymbolList[col] or {}
                self.theme.respinSymbolList[col][key] = self.theme.respinSymbolList[col][key] or {}
                table.insert(self.theme.respinSymbolList[col][key], {col, 1})

                local pCol = col
                while true do
                    pCol = pCol + 1
                    if pCol >= 30 then -- 最后一个格子中了respin symbol
                        self.theme.lastPosWinBonus = true
                    end
                    if not self.theme.lockedReels[pCol] then
                        break
                    end
                end
                self.theme.respinSpeedUpState[pCol] = self.theme.respinSpeedUpState[pCol] or {}
                self.theme.respinSpeedUpState[pCol][specialSymbol.bonus] = true
                -- if self.theme.lastPosWinBonus then
                --     self.theme.respinSpeedUpState[col] = self.theme.respinSpeedUpState[col] or {}
                --     self.theme.respinSpeedUpState[col][specialSymbol.bonus] = true
                -- end
            end
        end
    end
end

function bonusGame:getRespinItemList(respinData)
    local itemList = {}
    local col = 1
    for col, colList in pairs(respinData) do
        for row, item in pairs(colList) do
            itemList[col] = {item}
            col = col + 1
        end
    end
    return itemList
end

function bonusGame:doRespinWinAction()
    self.theme:laterCallBack(1, function( ... )
        self:bonusCoinsCollect()
    end)
    -- self:bonusCoinsCollect()
end

function bonusGame:iniJpDialog(type)
    -- local scale = self.theme.down_node:getScale()
    local path = self.theme:getPic("csb/win_jp.csb")
    self.dialog_jp = cc.CSLoader:createNode(path)
    local root = self.dialog_jp:getChildByName("root")
    self.jpDialog = root:getChildByName("dialog")
    self.jpDialog:setVisible(true)
    self.winJpLabel = self.jpDialog:getChildByName("coins")
    self.winJpLabel:setVisible(false)
    -- self.dialog_jp:setScale(scale)

    local animation = "animation"..type
    self.winJpCollectBtn = self.jpDialog:getChildByName("btn_collect")
    self.winJpCollectBtn:setTouchEnabled(false)
    self.winJpCollectBtn:setVisible(false)
    local function collectOnTouch()
        self.theme:playMusic(self.theme.audio_list.common_click)
        self.winJpCollectBtn:setTouchEnabled(false)
        self.jpDialog:runAction(cc.Sequence:create(
            cc.CallFunc:create(function( ... )
                self.theme:dealMusic_FadeLoopMusic(0.3, 0.2, 1)
                if libUI.isValidNode(self.winJpLabel) then
					self.winJpLabel:nrOverRoll() -- 停止滚动
				end
            end),
            cc.DelayTime:create(0.3),
            cc.ScaleTo:create(0.3, 1.2),
            cc.ScaleTo:create(0.15, 0.0001),
            cc.DelayTime:create(0.2),
            cc.CallFunc:create(function( ... )
                self.curRespinWin = self.jpWinList[type]
                self:setFooterWin()
            end),
            cc.DelayTime:create(0.2),
            cc.CallFunc:create(function( ... )
                self.theme.jackpotLabels[type]:lockJackpotMeter(false) -- 解锁jp的值
                self:bonusCoinsCollect(true)
                if bole.isValidNode(self.theme.jpWinSpineListInboard[type]) then
                    self.theme.jpWinSpineListInboard[type]:removeFromParent()
                    self.theme.jpWinSpineListInboard[type] = nil
                    for k, v in pairs(self.theme.jpWinLabelSpineListInboard[type]) do
                        if bole.isValidNode(v) then
                            bole.spChangeAnimation(v, "animation"..type.."_1", false)
                        end
                    end
                end
                if bole.isValidNode(self.dialog_jp) then
                    self.dialog_jp:removeFromParent()
                end
            end)
        ))
    end
    self.winJpCollectBtn:addTouchEventListener(collectOnTouch)

	self.theme:addChild(self.dialog_jp)
end

function bonusGame:popupWinJpDialog(type)
    self:iniJpDialog(type)
    self.wheelCollectShow = false
    self.wheelFreeShow = false
    self.theme.jackpotLabels[type]:lockJackpotMeter(true) -- 锁定 Jackpot 值
    local animation = "animation"..type
    local dialogAnim = self.jpDialog:getChildByName("anim")
    self.winJpCollectBtn:setVisible(true)
    self.winJpCollectBtn:setScale(0.001)
    local delay = 60/30
    local delay1 = 10/30
    self.theme:runAction(cc.Sequence:create(
        cc.CallFunc:create(function( ... )
            self.theme:playMusic(self.theme.audio_list.dialog_trigger_JP)
            self.theme:dealMusic_FadeLoopMusic(0.2, 1, 0.2)
            local _, s = self.theme:addSpineAnimation(dialogAnim, nil, self.theme:getPic("spine/dialog/jp/spine"), cc.p(0, 0), animation, nil, nil, nil, true, false, nil)
            self.jpCollectSpine = s
        end),
        cc.DelayTime:create(delay1),
        cc.CallFunc:create(function( ...)
            self.winJpLabel:setVisible(true)
            self.winJpLabel:setOpacity(0)
            self.winJpLabel:runAction(cc.Sequence:create(
                cc.FadeIn:create(0.16)
            ))
            local function parseValue(num)
                return FONTS.format(num, true)
            end
            bole.setSpeicalLabelScale(self.winJpLabel, self.jpWinList[type], 470)
            inherit(self.winJpLabel, LabelNumRoll)
            self.winJpLabel:nrInit(0, 24, parseValue)
            self.winJpLabel:nrStartRoll(0, self.jpWinList[type], 2)
        end),
        cc.DelayTime:create(0.1),
        cc.CallFunc:create(function( ...)
            self.winJpCollectBtn:setOpacity(0)
            self.winJpCollectBtn:setScale(0.0001)
            self.winJpCollectBtn:runAction(cc.Sequence:create(
                cc.Spawn:create(cc.FadeIn:create(0.23), cc.ScaleTo:create(0.23, 1.14)),
                cc.ScaleTo:create(0.16, 0.85),
                cc.ScaleTo:create(0.16, 1)
            ))
        end),
        cc.DelayTime:create(1 - 0.1 - delay1),
        cc.CallFunc:create(function( ... )
            self.winJpCollectBtn:setTouchEnabled(true)
            if bole.isValidNode(self.jpCollectSpine) then
                bole.spChangeAnimation(self.jpCollectSpine, animation.."_1", true)
            end
        end)
    ))

end

function bonusGame:bonusCoinsCollect(isPopupBack)
    if not self.winPos or #self.winPos == 0 then
        self:showRespinCollectDialog()
        return
    end
    
    if not isPopupBack then
        self.coinsData = table.remove(self.winPos, 1)
    end
    local boardIndex = respinBoardContentCfg[self.coinsData[1]]

    local cell = self.theme.spinLayer.spins[self.coinsData[1]]:getRetCell(1)
    local endPosW = cc.p(360, 140)
    if bole.isValidNode(self.ctl.footer.labelWin) then
        endPosW = bole.getWorldPos(self.ctl.footer.labelWin)
    end
    local endPosN = bole.getNodePos(self.respinSymbolFlyNode, endPosW)
    local startPosW = bole.getWorldPos(cell)
    local startPosN = bole.getNodePos(self.respinSymbolFlyNode, startPosW)

    self.collectActions = cc.Sequence:create(
        cc.CallFunc:create(function( ... )
            if bole.isValidNode(cell) then
                cell:runAction(cc.Sequence:create(
                    cc.ScaleTo:create(0.2, 1.1),
                    cc.ScaleTo:create(0.1, 1)
                ))
            end
            local pos = self.theme:getCellPos(self.coinsData[1], 1)
            self.theme:addSpineAnimation(self.theme.respinExcitationNode, nil, self.theme:getPic("spine/respin/collect_flash/spine"), pos, "animation", nil, nil, nil, false, false)
        end),
        cc.DelayTime:create(0.3),
        cc.CallFunc:create(function( ... )
            -- local startPos = self.theme:getCellPos(self.coinsData[1], 1)
            -- local endPos = cc.p(360, 155)
            -- local  _, s = self.theme:addSpineAnimation(self.theme.respinExcitationNode, nil, self.theme:getPic("spine/respin/collect_fly/spine"), startPos, "animation", nil, nil, nil, false, false)
            -- local sRotation = respinCollectRotation[self.coinsData[1]]
            -- local endLength = math.sqrt(math.pow((endPos.y-startPos.y),2)+math.pow((endPos.x-startPos.x),2))
            -- local baseLength = 380
            -- if SHRINKSCALE_H < 1 then
            --     local scale2 = bole.getAdaptScale(false)
            --     baseLength = baseLength * scale2
            -- end
            -- local sScale = endLength / baseLength
            -- s:setRotation(sRotation)
            -- s:setScaleY(sScale)
            -- self.theme:playMusic(self.theme.audio_list.respinCollectFly)
            local startPos = self.theme:getCellPos(self.coinsData[1], 1)
            -- startPos = cc.p(startPos.x, startPos.y - 5)
            -- local endPos = cc.p(360, 140)
            local  _, s = self.theme:addSpineAnimation(self.respinSymbolFlyNode, nil, self.theme:getPic("spine/respin/collect_fly/spine"), startPosN, "animation", nil, nil, nil, false, false)
            local sRotation = respinCollectRotation[self.coinsData[1]]
            local endLength = math.sqrt(math.pow((endPosN.y-startPosN.y),2)+math.pow((endPosN.x-startPosN.x),2))
            local baseLength = 380
            if SHRINKSCALE_H < 1 then
                local scale2 = bole.getAdaptScale(false)
                baseLength = baseLength * scale2
            end
            local sScale = endLength / baseLength
            s:setRotation(sRotation)
            s:setScaleY(sScale)
            self.theme:playMusic(self.theme.audio_list.respinCollectFly)
        end),
        cc.DelayTime:create(0.4),
        cc.CallFunc:create(function( ... )
            self.theme:addSpineAnimation(self.respinSymbolFlyNode, nil, self.theme:getPic("spine/respin/collect_footer/spine"), endPosN, "animation", nil, nil, nil, false, false)
            local coinsMulti = multiCfg[self.coinsData[2] - 19] or 0
            self.curRespinWin = coinsMulti * self.ctl:getCurBet()
            self:setFooterWin()
        end),
        cc.DelayTime:create(0.3),
        cc.CallFunc:create(function( ... )
            self:bonusCoinsCollect()
        end)
    )
    if self.coinsData[2] < 20 then
        self.collectActions = cc.Sequence:create(cc.CallFunc:create(function( ... )self:bonusCoinsCollect()end))
    end

    if respinBoardStartIndex[self.coinsData[1]] and self.theme.respinExcitationData[boardIndex][1] == boardCellCountCfg[boardIndex] and not isPopupBack then -- 赢jp
        self:popupWinJpDialog(boardIndex)
    else
        self.theme:runAction(self.collectActions)
    end
end

function bonusGame:setFooterWin()
	self.ctl.footer:setWinCoins(self.curRespinWin, self.curRespinTotalWin, 0) -- coins start
	self.curRespinTotalWin = self.curRespinTotalWin + self.curRespinWin
end

function bonusGame:showRespinCollectDialog()
    local scale = self.theme.down_node:getScale()
    local path = self.theme:getPic("csb/respin_collect_dialog.csb")
    self.respinCollectDialog = cc.CSLoader:createNode(path)
    local root = self.respinCollectDialog:getChildByName("root")
    local dimmer = self.respinCollectDialog:getChildByName("dimmer")
    local swoBtn = root:getChildByName("swo")
    local animNode = root:getChildByName("anim")
    self.respinCollectLabel = root:getChildByName("coins")
    self.respincollectBtn = root:getChildByName("btn_collect")
    scale = 0.8
    self.respinCollectDialog:setScale(scale)

    local swoOnTouch = function()
        return
    end
    swoBtn:addTouchEventListener(swoOnTouch)

    dimmer:setOpacity(0)
    self.respinCollectLabel:setOpacity(0)
    self.respincollectBtn:setScale(0.0001)
    self.theme:addChild(self.respinCollectDialog)
    
    self.respincollectBtn:setTouchEnabled(false)
    self.respincollectBtn:setVisible(false)
    local function collectOnTouch()
        self.theme:playMusic(self.theme.audio_list.common_click)
        self:playRespinBonusCollect()
        self.respincollectBtn:setTouchEnabled(false)
        root:runAction(cc.Sequence:create(
            cc.CallFunc:create(function( ... )
                if libUI.isValidNode(self.respinCollectLabel) then
					self.respinCollectLabel:nrOverRoll() -- 停止滚动
				end
            end),
            cc.DelayTime:create(0.3),
            cc.CallFunc:create(function( ... )
                if bole.isValidNode(dimmer) then
                    dimmer:runAction(cc.Sequence:create(
                        cc.FadeTo:create(0.5, 0)
                    ))
                end
            end),
            cc.ScaleTo:create(0.3, 1.2),
            cc.ScaleTo:create(0.15, 0.0001),
            cc.DelayTime:create(0.2),
            cc.CallFunc:create(function( ... )
                if bole.isValidNode(self.respinCollectDialog) then
                    self.respinCollectDialog:removeFromParent()
                end
                self:exitRespinGame()
            end)
        ))
    end
    self.respincollectBtn:addTouchEventListener(collectOnTouch)

    local delay1 = 7/30
    self.theme:runAction(cc.Sequence:create(
        cc.CallFunc:create(function( ... )
            dimmer:runAction(cc.Sequence:create(
                cc.FadeTo:create(0.5, 180)
            ))
            self.theme:playMusic(self.theme.audio_list.dialog_respin_end)
            self.theme:dealMusic_FadeLoopMusic(0.2, 1, 0.2)
            local _, s = self.theme:addSpineAnimation(animNode, nil, self.theme:getPic("spine/dialog/respin_collect/spine"), cc.p(0, 0), "animation1", nil, nil, nil, true, false, nil)
            self.respinCollectSpine = s
        end),
        cc.DelayTime:create(delay1),
        cc.CallFunc:create(function( ...)
            self.respinCollectLabel:setVisible(true)
            self.respinCollectLabel:setOpacity(0)
            self.respinCollectLabel:runAction(cc.Sequence:create(
                cc.FadeIn:create(0.5)
            ))
            local function parseValue(num)
                return FONTS.format(num, true)
            end
            bole.setSpeicalLabelScale(self.respinCollectLabel, self.respinWin, 470)
            inherit(self.respinCollectLabel, LabelNumRoll)
            self.respinCollectLabel:nrInit(0, 24, parseValue)
            self.respinCollectLabel:nrStartRoll(0, self.respinWin, 2)
        end),
        cc.DelayTime:create(0.1),
        cc.CallFunc:create(function( ...)
            self.respincollectBtn:setOpacity(0)
            self.respincollectBtn:setScale(0.0001)
            self.respincollectBtn:setVisible(true)
            self.respincollectBtn:runAction(cc.Sequence:create(
                cc.Spawn:create(cc.FadeIn:create(delay1), cc.ScaleTo:create(delay1, 1.11)),
                cc.ScaleTo:create(0.13, 0.82),
                cc.ScaleTo:create(0.13, 1)
            ))
        end),
        cc.DelayTime:create(1 - 0.1 - delay1),
        cc.CallFunc:create(function( ... )
            self.respincollectBtn:setTouchEnabled(true)
            if bole.isValidNode(self.respinCollectSpine) then
                bole.spChangeAnimation(self.respinCollectSpine, "animation1_1", true)
            end
        end)
    ))
end

function bonusGame:exitRespinGame()
    self.theme:stopRespinExcitation()
    -- self.theme.hadRespinWToWinJpFlash = false
    -- self.ctl.autoSpin = false
    local function func()
        self.theme.respinSymbolListInRespin = self.theme.respinSymbolListInRespin or {}
        for k, v in pairs(self.theme.respinSymbolListInRespin) do
            if bole.isValidNode(v) then
                v:removeFromParent()
            end
        end

        self.theme.respinSymbolListInRespinCell = self.theme.respinSymbolListInRespinCell or {}
        for k, v in pairs(self.theme.respinSymbolListInRespinCell) do
            if bole.isValidNode(v) then
                v:removeFromParent()
            end
        end
        self.theme.respinSymbolListInRespin = {}
        self.theme.respinSymbolListInRespinCell = {}
        -- self:playRespinBonusCollect()
        self.theme:changeSpinBoard(SpinBoardType.Normal)
        self:resetBaseBoard()
    end
    local function func2()
        self.theme:dealMusic_FadeLoopMusic(0.3, 0.2, 1)
        self.theme:dealMusic_EnterBaseGame()
        self:onRespinBonusOver()
    end
    self.theme:playTransition(func, func2, "respin", true)
end

function bonusGame:playRespinBonusCollect()
    self.bonusCtl.themeCtl:collectCoins(1)
end

function bonusGame:onRespinBonusOver()
    local func = function()
        if self.ctl.freespin and self.ctl.freespin < 1 then
            self.ctl.spin_processing = true 
        end
        self.ctl.footer.isRespinLayer = false
        self.ctl:onRespinOver()
        self.theme.bonus = nil
        self.theme.lockedReels = nil
        if self.callback then
            self.callback()
        end
        self.theme.isInBonusGame = false
        -- self.theme:enableFeatureBtn(true)
        -- self.theme.ctl.footer:setSpinButtonState(false)
    end

    self.ctl.rets["theme_respin"] = nil
    self.ctl.rets.totalWin = self.ctl.rets.base_win
    self.ctl:startRollup(self.respinWin, func)
end

function bonusGame:resetBaseBoard()
    for col, colList in pairs(self.respinBaseItem) do
        for row, item in pairs(colList) do
            local cell = self.theme.spinLayer.spins[col]:getRetCell(row)
            if bole.isValidNode(cell.bonus) then
                cell.bonus:removeFromParent()
            end
            if bole.isValidNode(cell) then
                if item >= 13 then
                    self.theme:createRespinSymbol(cell, item, 1)
                else
                    bole.updateSpriteWithFile(cell.sprite, self.theme.pics[item])
                end
            end
        end
    end
end
-------------------------------------- respin end ---------------------------------

------------------------------------- map wheel start --------------------------------
function bonusGame:enterMapWheelGame(tryResume) 
    self:initMapWheelData(tryResume)

    if tryResume then
    	delay = 0
    	self.callback = function ( ... )
        	-- 断线重连回调方法
        	local endCallFunc2 = function ( ... )
        	
        		self.ctl.rets.setWinCoins = nil

        		if (self.ctl.enterThemeDealList and bole.getTableCount(self.ctl.enterThemeDealList) > 0) then -- whj 1.2 添加控制之后还有feature的时候控制 按钮不可以点击
                    self.ctl.footer:setSpinButtonState(true)
	   			end

                if self.ctl:noFeatureLeft() and self.mapWheelFgExtra and self.mapWheelFgExtra > 0 then -- 仅对 增加Free 次数进行操作
                    self.theme.ctl.footer:setSpinButtonState(false)
                end
        		
        		if self.endCallBack then 
        			self.endCallBack()
        		end 

        		self.ctl.isProcessing = false      		
        	end       	
	        endCallFunc2()
        end

		self.theme.hintMusicCnt = 0
		self.ctl.isProcessing = true
		-- spin 结果数据和 显示stop 按钮有关
        self.ctl.cacheSpinRet = self.ctl.cacheSpinRet or self.ctl.rets      
    else 
    	self.theme:stopAllLoopMusic()
	end

	local function playIntro()
		local delay = tryResume and 0 or 1
		self.theme:runAction(cc.Sequence:create(
			cc.DelayTime:create(delay),
			cc.CallFunc:create(function()
				self.mapBonusDialog = ThemePowerSlotMapGame.new(self.theme, self.theme:getPic("csb/"), self.data)
                self.mapBonusDialog:showMapScene(true, true, false)
			end),
			cc.DelayTime:create(1),
			cc.CallFunc:create(function()
				self.theme:dealMusic_PlayFreeSpinLoopMusic()
                self.data.isMapShow = true
				self:saveBonus()
            end),
            cc.DelayTime:create(1),
            cc.CallFunc:create(function( ... )
                -- self:initMapWheelData()
                self:initMapWheelScene()
            end)
		))
		
	end

	local function snapIntro()
        -- self.theme.mapFreeLogoNode:setVisible(true)
		self.theme.mapCollectRoot:setVisible(false)
		self.theme:dealMusic_PlayFreeSpinLoopMusic()
	end

	playIntro()
end

function bonusGame:initMapWheelData(tryResume)
    if self.data and self.data.core_data then
        self.mapWheelData = self.data.core_data.map_wheel_spin
        self.mapWheelType = self.data.core_data.type
    end
    -- if tryResume then
    --     self.bonusTatolWin = self.data.core_data.total_win
    -- else
        self.bonusTatolWin = self.mapWheelData.total_win
    -- end
    self.mapWheelType = self.mapWheelType or 1
    self.mapWheelWin = self.mapWheelData.total_win
    self.mapWheelBet = self.mapWheelData.avg_bet
    self.mapWheelWin = self.mapWheelData.total_win
    self.mapWheelWinIndex = self.mapWheelData.index
    self.mapWheelFgExtra = self.mapWheelData.extra_fg
    self.mapEndAngel = self:getMapEndAngel(self.mapWheelWinIndex)
    self.data.mapWheelProgress = self.data.mapWheelProgress or 0
    self:saveBonus()
end

function bonusGame:getMapEndAngel(index)
    local endAngelCfg = {0, 300, 240, 180, 120, 60}
    return endAngelCfg[index]
end

function bonusGame:initMapWheelScene()
    local path = self.theme:getPic("csb/map_wheel.csb")
    self.theme:dealMusic_EnterMapWheelBonusGame()
    self.mapWheelScene = cc.CSLoader:createNode(path)
    self.theme.ctl.curScene:addToContentFooter(self.mapWheelScene, 999)

    local root = self.mapWheelScene:getChildByName("root")
    self.mapWheelDimmer = root:getChildByName("dimmer")
    self.dimmerBtn = root:getChildByName("swo_btn")
    self.wheelNode = root:getChildByName("wheel_node")
    self.mapWheelWinAnimNode = self.wheelNode:getChildByName("anim_node")
    self.bgNode = self.wheelNode:getChildByName("bg_node")
    self.mapWheelBgAnimNode = self.bgNode:getChildByName("anim_node")
    self.theme:addSpineAnimation(self.mapWheelBgAnimNode, nil, self.theme:getPic("spine/map/map_wheel/wheel_down/spine"), cc.p(0, 0), "animation"..self.mapWheelType, nil, nil, nil, true, true, nil)
    self.wheelNode1 = self.wheelNode:getChildByName("wheel_1")
    self.wheelNode2 = self.wheelNode:getChildByName("wheel_2")
    if self.mapWheelType == 1 then
        self.wheelNode1:setVisible(true)
        self.wheelNode2:setVisible(false)
        self.curWheelNode = self.wheelNode1
    else
        self.wheelNode1:setVisible(false)
        self.wheelNode2:setVisible(true)
        self.curWheelNode = self.wheelNode2
    end

    self.mapWheelActionNode = self.curWheelNode:getChildByName("action_node")
    local titleNode = self.curWheelNode:getChildByName("title_node")
    self.mapWheelBetLabel = titleNode:getChildByName("coins")
    local pointNode = titleNode:getChildByName("point_node")
    self.pointAnimNode = pointNode:getChildByName("anim")
    local numString = FONTS.format(self.mapWheelBet, true)
    self.mapWheelBetLabel:setString(numString)
    bole.shrinkLabel(self.mapWheelBetLabel, 300, self.mapWheelBetLabel:getScale())
    self.mapWheelSpinBtn = self.curWheelNode:getChildByName("spin_btn")
    self.mapWheelBtnAnimNode = self.curWheelNode:getChildByName("spin_btn_anim")
    local _, s = self.theme:addSpineAnimation(self.mapWheelBtnAnimNode, nil, self.theme:getPic("spine/map/map_wheel/spin_btn/spine"), cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
    self.mapWheelBtnSpine = s

    self.mapFireAnimNode = self.curWheelNode:getChildByName("fire_anim")

    local function swo()
        return
    end
    self.dimmerBtn:addTouchEventListener(swo)

    self.mapWheelDimmer:setOpacity(0)
    self.wheelNode:setPosition(cc.p(0, 1500))
    self.wheelNode:runAction(cc.Sequence:create(
        cc.CallFunc:create(function( ...)
            self.mapWheelDimmer:runAction(cc.FadeTo:create(0.3, 200))
            self.wheelNode:setPosition(cc.p(0, 1200))
            self.theme:playMusic(self.theme.audio_list.wheel_show)
        end),
        cc.EaseBackIn:create(cc.MoveTo:create(1, cc.p(0, 0))),
        cc.CallFunc:create(function( ... )
            if self.data.mapWheelProgress == 0 then
                self:initMapWheelSpinBtn()
            else
                self.theme:runAction(cc.Sequence:create(
                    cc.CallFunc:create(function( ... )
                        self.mapWheelActionNode:setRotation(self.mapEndAngel)
                    end),
                    cc.DelayTime:create(1),
                    cc.CallFunc:create(function( ... )
                        self:showWinMapWheelResult()
                    end)
                ))
            end
        end),
        cc.DelayTime:create(0.2),
        cc.CallFunc:create(function( ... )
            self.mapWheelBgAnimNode:removeAllChildren()
        end)
    ))
end

function bonusGame:initMapWheelSpinBtn()
    local function onTouch()
        self.mapWheelSpinBtn:setTouchEnabled(false)
        self.theme:playMusic(self.theme.audio_list.spin_button)
        local _, s1 = self.theme:addSpineAnimation(self.mapFireAnimNode, nil, self.theme:getPic("spine/map/map_wheel/fire/spine"), cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
        self.mapWheelFireSpin = s1
        local _, s2 = self.theme:addSpineAnimation(self.mapWheelBgAnimNode, nil, self.theme:getPic("spine/map/map_wheel/wheel_bg/spine"), cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
        self.mapWheelBgSpine = s2
        if bole.isValidNode(self.mapWheelBtnSpine) then
            self.mapWheelBtnSpine:removeFromParent()
            self.mapWheelBtnSpine = nil
        end
        local function finishSpin()
            self.data.mapWheelProgress = 1
            self:saveBonus()
            if bole.isValidNode(self.mapWheelFireSpin) then
                self.mapWheelFireSpin:removeFromParent()
                self.mapWheelFireSpin = nil
            end
            if bole.isValidNode(self.mapWheelBgSpine) then
                self.mapWheelBgSpine:removeFromParent()
                self.mapWheelBgSpine = nil
            end
            local animation = "animation"..self.mapWheelType
            self.theme:playMusic(self.theme.audio_list.wheel_display)
            self.theme:addSpineAnimation(self.mapFireAnimNode, nil, self.theme:getPic("spine/map/map_wheel/win/spine"), cc.p(0, -19), "animation", nil, nil, nil, true, true, nil)
            self.theme:addSpineAnimation(self.pointAnimNode, nil, self.theme:getPic("spine/map/map_wheel/point/spine"), cc.p(0, 0), "animation", nil, nil, nil, true, true, nil)
            self.theme:runAction(cc.Sequence:create(
                cc.DelayTime:create(2),
                cc.CallFunc:create(function( ... )
                    self:showWinMapWheelResult()
                end)
            ))
        end

        local wheelData= {
            ["itemCount"]           = 6,
            ["delayBeforeSpin"]     = 0.0,   -- 开始旋转前的时间延迟
            ["upBounce"]     		= 0,     -- 开始滚动前，向上滚动距离
            ["upBounceTime"]     	= 0,     -- 开始滚动前，向上滚动时间
            ["speedUpTime"]     	= 0.5,     -- 加速时间
            ["rotateTime"]    	 	= 1,     -- 匀速转动的时间之和
            ["maxSpeed"]     	 	= 30*25, --每一秒滚动的距离
            ["downBounce"]      	= 0,     --滚动结束前，向下反弹距离  都为正数值
            ["speedDownTime"]      	= 3,     -- 4
            ["downBounceTime"]      = 0.5,
            ["bounceSpeed"]         = nil,
            ["direction"]      		= 1,
            ["endAngle"]            = self.mapEndAngel
        }
        
        self.miniWheel = BaseWheelExtend.new(self, self.mapWheelActionNode, nil, wheelData, finishSpin)
        self.miniWheel:start()
        self.theme:playMusic(self.theme.audio_list.wheel_act)
    end

    self.mapWheelSpinBtn:addTouchEventListener(onTouch)
end

function bonusGame:showWinMapWheelResult() 
    if not self.mapWheelFgExtra or self.mapWheelFgExtra == 0 then
        self:showMapWheelCollectDialog()
    else
        if bole.isValidNode(self.wheelNode) then
            self.wheelNode:runAction(cc.Sequence:create(
                cc.CallFunc:create(function( ... )
                    if bole.isValidNode(self.mapWheelDimmer) then
                        self.mapWheelDimmer:runAction(cc.FadeTo:create(0.3, 0))
                    end
                    self.theme:playMusic(self.theme.audio_list.wheel_disappear)
                end),
                cc.EaseInOut:create(cc.MoveTo:create(1, cc.p(0, 1200)), 2),
                cc.CallFunc:create(function( ... )
                    self.mapBonusDialog:setMapPosBeforeAddFg()
                end),
                cc.DelayTime:create(0.8),
                cc.CallFunc:create(function( ... )
                    self.theme:dealMusic_FadeLoopMusic(0.3, 0.3, 1)
                    self.theme:dealMusic_EnterBaseGame()
                    self.theme.mapFreeExtraSpins = self.theme.mapFreeExtraSpins + 1
                    self.mapBonusDialog:updateBigStepFreeSpins()
                end),
                cc.DelayTime:create(1),
                cc.CallFunc:create(function( ... )
                    local function callBack()
                        self:exitMapWheel()
                    end
                    self.dimmerBtn:setTouchEnabled(false)
                    if bole.isValidNode(self.mapWheelScene) then
                        self.mapWheelScene:removeFromParent()
                        self.mapWheelScene = nil
                    end
                    self.mapBonusDialog:showBackBtn(callBack)
                    -- self.mapBonusDialog:exitMapScene()
                end)
                -- cc.DelayTime:create(1),
                -- cc.CallFunc:create(function( ... )
                --     self:exitMapWheel()
                -- end)
            ))
        end
    end
end

function bonusGame:showMapWheelCollectDialog()
    self.theme:dealMusic_FadeLoopMusic(0.3, 1, 0.3)
    local function onTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            self.mapWheelollectBtn:setTouchEnabled(false)
            self.theme:playMusic(self.theme.audio_list.common_click)
            self.theme:runAction(cc.Sequence:create(
                cc.CallFunc:create(function( ... )
                    if libUI.isValidNode(self.mapWheelWinLabel) then
                        self.mapWheelWinLabel:nrOverRoll() -- 停止滚动
                    end
                end),
                cc.DelayTime:create(0.1),
                cc.CallFunc:create(function( ... )
                    self.theme:dealMusic_FadeLoopMusic(0.3, 0.3, 1)
                    self.theme:dealMusic_EnterBaseGame()
                    local root = self.mapWheelDialog:getChildByName("root")
                    if bole.isValidNode(root) then
                        root:runAction(cc.Sequence:create(
                            cc.ScaleTo:create(0.3, 1.2),
                            cc.ScaleTo:create(0.15, 0.0001)
                        ))
                    end
                    self.mapWheelCollectDimmer:runAction(cc.FadeTo:create(0.5, 0))
                end),
                cc.DelayTime:create(0.6),
                cc.CallFunc:create(function( ... )
                    -- self.mapBonusDialog:exitMapScene()
                    local function callBack()
                        self:exitMapWheel()
                    end
                    if bole.isValidNode(self.dimmerBtn) then
                        self.dimmerBtn:setTouchEnabled(false)
                    end
                    if bole.isValidNode(self.mapWheelScene) then
                        self.mapWheelScene:removeFromParent()
                        self.mapWheelScene = nil
                    end
                    self.mapBonusDialog:showBackBtn(callBack)
                    -- self:exitMapWheel()
                    -- self.theme.mapCollectRoot:setVisible(true)
                end)
            ))
        end
    end

    local path = self.theme:getPic("csb/map_wheel_dialog.csb")
    self.mapWheelDialog = cc.CSLoader:createNode(path)
    self.mapWheelScene:addChild(self.mapWheelDialog)
    self.mapWheelCollectDimmer = self.mapWheelDialog:getChildByName("dimmer")
    self.mapWheelCollectDimmer:setOpacity(0)
    local root = self.mapWheelDialog:getChildByName("root")
    local dialogAnim = root:getChildByName("anim")
    self.mapWheelWinLabel = root:getChildByName("coins")
    self.mapWheelollectBtn = root:getChildByName("btn_collect")
    self.theme:runAction(cc.Sequence:create(
        cc.CallFunc:create(function( ... )
            self.mapWheelWinLabel:setVisible(false)
            self.mapWheelollectBtn:setVisible(true)
            self.mapWheelollectBtn:setScale(0.001)

            self.mapWheelCollectDimmer:runAction(cc.FadeTo:create(0.8, 180))
            self.theme:playMusic(self.theme.audio_list.wheel_collect)
            local _, s = self.theme:addSpineAnimation(dialogAnim, nil, self.theme:getPic("spine/dialog/map_wheel/spine"), cc.p(0, 0), "animation"..self.mapWheelType, nil, nil, nil, true, false, nil)
            self.mapWheelCollectSpine = s
        end),
        cc.DelayTime:create(0.23),
        cc.CallFunc:create(function( ... )
            self.mapWheelWinLabel:setVisible(true)
            self.mapWheelWinLabel:setOpacity(0)
            self.mapWheelWinLabel:runAction(cc.Sequence:create(
                cc.FadeIn:create(0.23)
            ))
            local function parseValue(num)
                return FONTS.format(num, true)
            end
            bole.setSpeicalLabelScale(self.mapWheelWinLabel, self.mapWheelWin, 470)
            inherit(self.mapWheelWinLabel, LabelNumRoll)
            self.mapWheelWinLabel:nrInit(0, 24, parseValue)
            self.mapWheelWinLabel:nrStartRoll(0, self.mapWheelWin, 2)
        end),
        cc.DelayTime:create(0.1),
        cc.CallFunc:create(function( ... )
            self.mapWheelollectBtn:setVisible(true)
            self.mapWheelollectBtn:setScale(0.0001)
            self.mapWheelollectBtn:setOpacity(0)
            self.mapWheelollectBtn:runAction(cc.Sequence:create(
                cc.Spawn:create(cc.FadeIn:create(0.23), cc.ScaleTo:create(0.23, 1.11)),
                cc.ScaleTo:create(0.13, 0.82),
                cc.ScaleTo:create(0.13, 1)
            ))
        end),
        cc.DelayTime:create(0.67),
        cc.CallFunc:create(function( ... )
            self.mapWheelollectBtn:setTouchEnabled(true)
            if bole.isValidNode(self.mapWheelCollectSpine) then
                bole.spChangeAnimation(self.mapWheelCollectSpine, "animation"..self.mapWheelType.."_1", true)
            end
        end)
    ))
    self.mapWheelollectBtn:addTouchEventListener(onTouch)
end

function bonusGame:exitMapWheel()
    self.theme:setNextCollectTargetImage(self.theme.mapLevel)
    self.theme.mapPoints = 0
    self.theme:setCollectProgressImagePos(0)
    self.ctl:collectCoins(1)
    local func = function()
        self.theme.bonus = nil
        self.theme.isInBonusGame = false

        if self.callback then
            self.callback()
        end
    end

    self.ctl.rets.totalWin = self.ctl.rets.base_win
    self.ctl:startRollup(self.bonusTatolWin, func)
end
-------------------------------------- map wheel end ---------------------------------
--- Map FreeSpin
function bonusGame:enterMapFreeGameBonus(tryResume)
	if tryResume then
    	delay = 0
    	self.callback = function ( ... )
        	-- 断线重连回调方法
        	local endCallFunc2 = function ( ... )
        	
        		self.ctl.rets.setWinCoins = nil

        		if (self.ctl.enterThemeDealList and bole.getTableCount(self.ctl.enterThemeDealList) > 0) then -- whj 1.2 添加控制之后还有feature的时候控制 按钮不可以点击
                    self.ctl.footer:setSpinButtonState(true)
	   			end
        		
        		if self.endCallBack then 
        			self.endCallBack()
        		end 

        		self.ctl.isProcessing = false      		
        	end       	
	        endCallFunc2()
        end

		self.theme.hintMusicCnt = 0
		self.ctl.isProcessing = true
		-- spin 结果数据和 显示stop 按钮有关
        self.ctl.cacheSpinRet = self.ctl.cacheSpinRet or self.ctl.rets      
    else 
    	self.theme:stopAllLoopMusic()
	end

	local function playIntro()
		
		self.theme:runAction(cc.Sequence:create(
			cc.DelayTime:create(1),
			cc.CallFunc:create(function()
				local theDialog = ThemePowerSlotMapGame.new(self.theme, self.theme:getPic("csb/"), self.data)
	            theDialog:showMapScene(true, false, false)
			end),
			cc.DelayTime:create(1),
			cc.CallFunc:create(function()
				self.theme.mapCollectRoot:setVisible(false)
                self.data.isMapShow = true
				self:saveBonus()
			end)
		))
		
	end

	local function snapIntro()
		self.theme.mapCollectRoot:setVisible(false)
        self:onMapExitByMapFree()
	end

	if tryResume and self.data.isMapShow then
		snapIntro()
	else
		playIntro()
	end
				
end

function bonusGame:onMapExitByMapFree( )
    self.bonusCtl.themeCtl:collectCoins(1)

    self.theme.bonus = nil
    self.theme.isInBonusGame = false
    if self.callback then
        self.callback()
    end
end

function bonusGame:startFinialRollUpCelebration()
	local function respinOver( ... )
		-- 激活spin按钮
		self.ctl:onRespinOver()
		self.ctl.rets["theme_respin"] = nil
	    self.callback()
        self.theme.isInBonusGame = false
	end
	self.theme.mapFree = nil
	self.ctl.rets["theme_respin"] = nil
	
	self.ctl.totalWin = self.ctl.totalWin - self.mapFreeAllWin
	if self.theme.showFreeSpinBoard then
		self.ctl.freewin = self.ctl.freewin - self.mapFreeAllWin
	end
	self.ctl:startRollup(self.mapFreeAllWin, respinOver,self.mapFreeBet)
end

------------------------------------ Map start -----------------------------------------

ThemePowerSlotMapGame = class("ThemePowerSlotMapGame", CCSNode)
local MapGame = ThemePowerSlotMapGame

local buildingLevel = Set({4,9,12,18,22,25,31,35,40,44,48,53,56,62,66,69,75,79,84,88,92,100})
local mapHidePos = cc.p(0, 1900)
local userDirectionCfg = {
    -1, -1, 1, 1, 1, 1, 1, -1, -1, -1,
    -1, 1, 1, 1, -1, -1, -1, 1, 1, 1,
    -1, -1, -1, -1, 1, 1, 1, -1, -1, -1,
    1, 1, 1, -1, -1, -1, -1, -1, 1, 1,
    1, 1, -1, -1, -1, -1, 1, 1, 1, 1,
    -1, -1, -1, -1, 1, 1, 1, 1, -1, -1,
    -1, 1, 1, 1, -1, -1, -1, -1, 1, 1,
    1, -1, -1, -1, 1, 1, 1, -1, -1, -1,
    -1, -1, 1, 1, 1, 1, -1, -1, -1, -1,
    1, 1, 1 , 1, -1, -1, -1, -1, 1, 1
}
function MapGame:ctor( theme, csbPath, data)
	self.theme 	   	   = theme
	self.csbPath       = csbPath
	self.csb 		   = csbPath .. "map.csb"
	self.data          = data
    CCSNode.ctor(self, self.csb)
    if self.data.core_data then
        self.bonusType = self.data.core_data["type"]
    end
    self.mapLevel = self.theme.mapLevel

	if self.theme.mapPoints >= maxMapPoint and self.mapLevel == 0 then
		self.mapLevel = maxMapLevel
    end
end

function MapGame:loadControls()
	self.dimmer = self.node:getChildByName("dimmer_node")
	self.dimmer:setVisible(false)

    self.root = self.node:getChildByName("root")
    self.root_child = self.root:getChildByName("root_child")
    local map_node = self.root_child:getChildByName("bg_panel")
    map_node:setScrollBarEnabled(false)
    self.mapContainerNode = map_node
    local tempNumber = 1000*(1-HEADER_FOOTER_SCALE_H)
    self.mapContainerNode:setContentSize(cc.size(self.mapContainerNode:getContentSize().width, self.mapContainerNode:getContentSize().height-tempNumber))
    
	self.map_bg_node = map_node:getChildByName("step_node")

    self.buttonNode = self.root_child:getChildByName("btn_node")
    _, self.mapBtnLoopSpine = self.theme:addSpineAnimation(self.buttonNode, nil, self.theme:getPic("spine/map/back_btn_loop/spine"), cc.p(0,0),"animation",nil,nil,nil,true,true)
	
	self.btn_back = self.buttonNode:getChildByName("btn")
	self.buttonNode:setVisible(false)
	self.buttonNode:setScale(0)

    self.bg_aniNode = map_node:getChildByName("anim_node")

    self.userBasePos = cc.p(-115, -250)
    local _userSp = self.map_bg_node:getChildByName("user_sp")
    _userSp:removeFromParent()
    local _, s = self.theme:addSpineAnimation(self.map_bg_node, 100, self.theme:getPic("spine/map/user_sp/spine"), self.userBasePos,"animation",nil,nil,nil,true, true)
    s:setScale(0.5)
    self.userSp = s
    self.userSp:setScale(1)

	self.stepList = {} 
    for i = 1, maxMapLevel do
		self.stepList[i] = {}
        if buildingLevel[i] then
			self.stepList[i].node = self.map_bg_node:getChildByName("step"..i.."_big")
			self.stepList[i].aniNode = self.stepList[i].node:getChildByName("anim_node")
        else
			self.stepList[i].node = self.map_bg_node:getChildByName("step_"..i)
			self.stepList[i].aniNode = self.stepList[i].node:getChildByName("anim_node")
		end
        local fnt = self.stepList[i].node:getChildByName("fnt")
        fnt:setLocalZOrder(10)
    end
    self.mapSwaBtn = self.root:getChildByName("swa_btn")
    local function swa()
        return
    end 
    self.mapSwaBtn:addTouchEventListener(swa)
end

local baseStepPosY = 624
local baseStepScale = 0.8
function MapGame:getContainerPosY(step_index)
    local step_index = step_index or 1
    local offset = 0
    if self.stepList[step_index] and bole.isValidNode(self.stepList[step_index].node) then 
        local sizex = self.mapContainerNode:getContentSize().height - self.mapContainerNode:getInnerContainerSize().height
        offset = self.mapContainerNode:getContentSize().height/2 - (self.stepList[step_index].node:getPositionY()*baseStepScale + baseStepPosY)
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
    container_node:setPosition(cc.p(posx,posy))
end

function MapGame:setMapPosBeforeAddFg()
    local step_index = self.mapLevel
    while true do
        step_index = step_index + 1
        if step_index >= 100 then
            step_index = 100
        end
        if buildingLevel[step_index] then
            break
        end
    end
    step_index = step_index > 0 and step_index or 1
    local posy = self:getContainerPosY(step_index)
    local container_node = self.mapContainerNode:getInnerContainer()
    local posx = container_node:getPositionX()
    -- container_node:setPosition(cc.p(posx,posy))
    container_node:runAction(cc.MoveTo:create(0.3, cc.p(posx,posy)))
end

function MapGame:showMapForwardPosition(next_index)
    if next_index == 0 or next_index - 1 == 0 then return end
    local container_node = self.mapContainerNode:getInnerContainer()
    self:setMapPosition(next_index - 1)
    local posY = self:getContainerPosY(next_index)
    local posX = container_node:getPositionX()

    container_node:runAction(cc.MoveTo:create(0.2, cc.p(posX, posY)))
end


function MapGame:showMapScene(isAnimate, notPause, canMove)
    self.theme.ctl.footer:setSpinButtonState(true)
    self.theme.ctl.footer:enableOtherBtns(false) 
    local mapShowPos = cc.p(0, -580)
    self.theme.isShowMap = true
    -- 隐藏B级活动栏
    EventCenter:pushEvent(EVENTNAMES.ACTIVITY_THEME.ALL_HIDE_QUIET)
  
    self:showIdleAnimation(isAnimate)
    local duration1 = 0.15
    local duration2 = 0.35
    local showBtnDelay = 0.35

    self.mapSwaBtn:setVisible(not canMove)
    self.mapSwaBtn:setTouchEnabled(not canMove)

	if isAnimate then
		showBtnDelay = 0
        self:setMapPosition(self.mapLevel-1)
	else
       -- 暂停主题
        if not notPause then
            bole.pauseTheme()
        end
       self:setMapPosition(self.mapLevel)   
	end
    self.theme.ctl.curScene:addToContentFooter(self, 999)
    bole.adaptBackground(self.root)
    bole.adaptReelBoard(self.root)
    self.mapContainerNode:setPosition(mapHidePos)
	self:setData(self.mapLevel,isAnimate)

	local function initBackBtnEvent( ... )
		-- 点击按钮
        local pressFunc = function(obj)
            self.theme:playMusic(self.theme.audio_list.map_button)
            if bole.isValidNode(self.mapBtnLoopSpine) then
                self.mapBtnLoopSpine:removeFromParent()
                self.mapBtnLoopSpine = nil
            end
	        self.btn_back:setTouchEnabled(false)
	        self.btn_back:setBright(false)
	    	-- 播放点击音乐
	    	self.theme:playMusic(self.theme.audio_list.common_click)
            if self.theme.ctl:noFeatureLeft() then 
                self.theme.ctl.footer:setSpinButtonState(false)
                self.theme.ctl.footer:enableOtherBtns(true) 
            end
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
			cc.ScaleTo:create(0.2,1.5,1.5),
			cc.ScaleTo:create(0.15,1,1)
		))
	end

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.dimmer:setOpacity(0)
			self.dimmer:setVisible(true)
            self.dimmer:runAction(cc.FadeIn:create(0.3))
			self.theme:playMusic(self.theme.audio_list.map_show) 
		end),
		cc.DelayTime:create(duration1+0.1),
		cc.CallFunc:create(function( ... )
             self.mapContainerNode:runAction(cc.MoveTo:create(duration2, mapShowPos))
		end),
		cc.DelayTime:create(duration2+0.1),
		cc.CallFunc:create(function( ... )
			self.mapContainerNode:setPosition(mapShowPos)
			if not isAnimate then
			   showBackGameBtn()
			end
		end),
		cc.DelayTime:create(showBtnDelay),
		cc.CallFunc:create(function()
			if isAnimate then
			   self:showIncreaseAnimation(notPause)			   
			else
			   self.btn_back:setTouchEnabled(true)
			   initBackBtnEvent()
            end
		end)
	))
end

function MapGame:showBackBtn(callback)
    self.mapSwaBtn:setTouchEnabled(false)
    self.buttonNode:setScale(0)
    self.buttonNode:setVisible(true)
    self.btn_back:setBright(true)
    self.btn_back:setTouchEnabled(true)
    self.buttonNode:runAction(cc.Sequence:create(
        cc.ScaleTo:create(0.2,1.5,1.5),
        cc.ScaleTo:create(0.15,1,1),
        cc.CallFunc:create(function(...)
            self.btn_back:setTouchEnabled(true)
        end)
    ))

    local function onTouch()
        self.theme:playMusic(self.theme.audio_list.map_button)
        if bole.isValidNode(self.mapBtnLoopSpine) then
            self.mapBtnLoopSpine:removeFromParent()
            self.mapBtnLoopSpine = nil
        end
        self.btn_back:setTouchEnabled(false)
        self.btn_back:setBright(false)
        -- 播放点击音乐
        self.theme:playMusic(self.theme.audio_list.common_click)
        if self.theme.ctl:noFeatureLeft() then 
            self.theme.ctl.footer:setSpinButtonState(false)
            self.theme.ctl.footer:enableOtherBtns(true) 
        end
        self:exitMapScene()
        if callback then
            callback()
        end
    end

    self.btn_back:addTouchEventListener(onTouch)
end

function MapGame:showIncreaseAnimation( notPause )
	local bgAniDelay = 0.2
    if self.mapLevel >= 1 then 
        bgAniDelay = 20/30

        local startPos = self.mapLevel > 1 and cc.pAdd(cc.p(self.stepList[self.mapLevel -1 ].node:getPosition()), cc.p(self.stepList[self.mapLevel- 1].aniNode:getPosition())) or self.userBasePos
        local endPos = cc.pAdd(cc.p(self.stepList[self.mapLevel].node:getPosition()), cc.p(self.stepList[self.mapLevel].aniNode:getPosition()))
        local end_x = endPos.x
        local end_y = endPos.y + 130
        local start_x = startPos.x
        local start_y = startPos.y + 130
        endPos = cc.p(end_x, end_y)
        startPos = cc.p(start_x, start_y)
        self.userSp:setPosition(startPos)
        self.userSp:setScale(userDirectionCfg[self.mapLevel], 1)
        if bole.isValidNode(self.userSp) then
            bole.spChangeAnimation(self.userSp, "animation") 
        end
        local musicFile = self.theme.audio_list.move
        if buildingLevel[self.mapLevel] then
            musicFile = self.theme.audio_list.move2
        end
        self.theme:playMusic(musicFile)
        self.userSp:runAction(cc.MoveTo:create(0.5, endPos))
	end

    local mapLevel = self.mapLevel
    if mapLevel == 0 then
        mapLevel = 1
    end
	self:runAction(cc.Sequence:create(
        cc.CallFunc:create(function ( ... )
            self:showMapForwardPosition(mapLevel)
        end),
		cc.DelayTime:create(bgAniDelay),
        cc.CallFunc:create(function()
			local file = self.theme:getPic("spine/map/yuanbaoEffect/spine")
			local aniName = "animation"..mapNodeTypeCfg[mapLevel]
            local parent = self.stepList[mapLevel].aniNode
            local musicFile =  self.theme.audio_list.pass1
			if buildingLevel[mapLevel] then -- 大节点
                file = self.theme:getPic("spine/map/buildingEffect/spine")
                local animIndex = mapNodeTypeCfg[mapLevel] - 2
                aniName = "animation"..animIndex
                musicFile = self.theme.audio_list.pass2
            else
                local hat = self.stepList[mapLevel].node:getChildByName("bg")
                if bole.isValidNode(hat) then
                    hat:setVisible(false)
                end
            end
            self.theme:playMusic(musicFile)
            local _,s = self.theme:addSpineAnimation(parent,nil,file,cc.p(0,0),aniName,nil,nil,nil,true,false,nil)
		end),
		cc.DelayTime:create(1.5),
        cc.CallFunc:create(function()
            if not notPause then
                self:exitMapScene(true)
            end
		end)
	))
end

function MapGame:showIdleAnimation( isAnimate )
	
    if self.mapLevel == 0 then return end
    local index = self.mapLevel
    if isAnimate then
        index = index - 1
    end
    for i = 1, index do
        local parent = self.stepList[i].aniNode
        local aniName = "animation"..mapNodeTypeCfg[i].."_2"
        local file = self.theme:getPic("spine/map/yuanbaoEffect/spine")
        self.stepList[i].node:setColor(cc.c3b(153, 153, 153))
        if not buildingLevel[i] then
            local _,s = self.theme:addSpineAnimation(parent,nil,file,cc.p(0,0),aniName,nil,nil,nil,true,true,nil)
        else
            local labelSprite = self.stepList[i].node:getChildByName("spins")
            if bole.isValidNode(labelSprite) then
                labelSprite:setVisible(false)
            end
        end
    end
    local parent = self.stepList[mapStepFreeCfg[self.mapLevel]].node
    local spinCount = self.theme.mapFreeExtraSpins + 5
    if spinCount > 9 then
        spinCount = 9
    end
    local labelSprite = parent:getChildByName("spins")
    local file = "#theme194_map_"..spinCount..".png"
    bole.updateSpriteWithFile(labelSprite, file)
end

function MapGame:updateBigStepFreeSpins()
    local spinCount = self.theme.mapFreeExtraSpins + 5
    if spinCount > 9 then
        spinCount = 9
    end
    local parent = self.stepList[mapStepFreeCfg[self.mapLevel]].node
    local labelSprite = parent:getChildByName("spins")

    local spineFile = self.theme:getPic("spine/map/free_spins_change/spine")
    self.theme:playMusic(self.theme.audio_list.add)
    self.theme:addSpineAnimation(labelSprite,nil,spineFile,cc.p(40,40),"animation",nil,nil,nil,false,false,nil)
    local file = "#theme194_map_"..spinCount..".png"
    bole.updateSpriteWithFile(labelSprite, file)
end

function MapGame:setData(level,isAnimate)
	if isAnimate then
		level = level - 1
	end

	if level < 0 then
		level = 0
	end

    if level == 0 then 
        self.userSp:setPosition(self.userBasePos)
        self.userSp:setScale(-1, 1)
	elseif level >= 1 then
        local endPos = cc.pAdd(cc.p(self.stepList[level].node:getPosition()), cc.p(self.stepList[level].aniNode:getPosition()))
        local end_x = endPos.x
        local end_y = endPos.y + 130
        endPos = cc.p(end_x, end_y)
        self.userSp:setPosition(endPos)
        self.userSp:setScale(userDirectionCfg[level], 1)
	end
end

function MapGame:exitMapScene(isAnimate)
    self.theme.isShowMap = false
	-- 恢复主题
	bole.resumeTheme()
	local duration1 = 0.15
	local duration2 = 0.35
	local hideBtnDelay = 0.3

	if isAnimate then
		hideBtnDelay = 0
        self.mapContainerNode:stopAutoScroll()
    else
        if self.theme.ctl.footer then
            self.theme.ctl.footer:showActivitysNode()
        end
	end

	local function hideBackGameBtn()
		self.buttonNode:setScale(1)
		self.buttonNode:setVisible(true)
		self.buttonNode:runAction(cc.Sequence:create(
			cc.ScaleTo:create(0.15,1.5,1.5),
			cc.ScaleTo:create(0.2,0,0)
		))
	end

	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function( ... )
			if not isAnimate then
			   hideBackGameBtn()
			end
		end),
		cc.DelayTime:create(hideBtnDelay),
		cc.CallFunc:create(function( ... )
			self.theme:playMusic(self.theme.audio_list.map_close)
			self.mapContainerNode:runAction(cc.MoveTo:create(duration2, mapHidePos))
		end),
		cc.CallFunc:create(function( ... )
			self.dimmer:setOpacity(255)
			self.dimmer:setVisible(true)
			self.dimmer:runAction(cc.FadeOut:create(duration1))
		end),
		cc.DelayTime:create(duration2),
		cc.CallFunc:create(function( ... )
			if isAnimate then
				if buildingLevel[self.mapLevel] then
                    if self.theme.bonus then 
                        self.theme.bonus:onMapExitByMapFree()
                    end
				end
	        end
		end),
		cc.RemoveSelf:create()
	))
end
--------------------------------------- map end ------------------------------------
--------------------------------------- bonus game end ------------------------------------

---------------------------------------- 音效相关 start ----------------------------------------

function cls:dealMusic_EnterBaseGame()
	-- 播放背景音乐
	AudioControl:stopGroupAudio("music")
	self:playLoopMusic(self.audio_list.base_background)
end

function cls:dealMusic_EnterRespinBonusGame()
	-- 播放背景音乐
	AudioControl:stopGroupAudio("music")
	self:playLoopMusic(self.audio_list.respin_bgm)
end

function cls:dealMusic_EnterMapWheelBonusGame()
	-- 播放背景音乐
	AudioControl:stopGroupAudio("music")
	self:playMusic(self.audio_list.wheel_bgm)
end

-- 滚轮音效相关
function cls:dealMusic_PlayReelStopMusic( pCol )
	-- 转轮停止声音
	Theme.dealMusic_PlayReelStopMusic(self,pCol)
end

function cls:dealMusic_PlayReelNotifyMusic( pCol ) -- 最后一列激励音效
	self:playMusic(self.audio_list.reel_notify, true, false)
	self.playR1Col = pCol
end

function cls:dealMusic_StopReelNotifyMusic( pCol )
	if not self.playR1Col then return end
	self.playR1Col = nil
	self:stopMusic(self.audio_list.anticipation,true)
end

local baseReelStopLevel = 3
function cls:checkPlaySymbolNotifyEffect( pCol )
    local _pCol = pCol
    if self.showReSpinBoard then 
        pCol = (pCol - 1)%baseColCnt + 1
    end

	local isPlaySymbolNotify = false
	self:dealMusic_StopReelNotifyMusic(pCol) -- 停止滚轴加速的声音

    if not self.fastStopMusicTag then -- 判断是否播放特殊symbol的动画
		isPlaySymbolNotify = self:dealMusic_PlaySpecialSymbolStopMusic(pCol)-- 判断是否播放特殊symbol的动画
    else
        local endCol = self.showReSpinBoard and self.lastCol or #self.spinLayer.spins

        if _pCol == endCol then
            local haveSymbolLevel = baseReelStopLevel -- 普通下落音的等级
			for k,v in pairs(self.respinSymbolList) do -- 判断在剩下停止的滚轴中是否有特殊symbol
			 	if bole.getTableCount(v) > 0 then
					-- if v[specialSymbol.bonus] then
						if haveSymbolLevel >1 then
							haveSymbolLevel = 1
                        end
						self:playSymbolNotifyEffect(k) -- 播放特殊symbol 下落特效
					-- end
					self.respinSymbolList[k] = {}
				end
			end
			if haveSymbolLevel< baseReelStopLevel then
				self:playEffectWithInterval(self.audio_list.bonus_land)
				isPlaySymbolNotify = true
			end
		end
	end
	return isPlaySymbolNotify
end

function cls:dealMusic_PlaySpecialSymbolStopMusic( pCol )
	self.respinSymbolList = self.respinSymbolList or {}

	if (not self.respinSymbolList[pCol]) or bole.getTableCount(self.respinSymbolList[pCol]) == 0 then
		return false
	end
	local ColNotifyState = self.respinSymbolList[pCol]
	local haveSymbolLevel = baseReelStopLevel
 	-- if ColNotifyState[specialSymbol.bonus] then
		if haveSymbolLevel >1 then
			haveSymbolLevel = 1
        end
        self:playSymbolNotifyEffect(pCol)
        self:playEffectWithInterval(self.audio_list.bonus_land)
	-- end

	if haveSymbolLevel< baseReelStopLevel then
		self:playMusic(self.audio_list["special_reelStop" .. haveSymbolLevel])
		self.respinSymbolList[pCol] = {}
		return true
	end
end

function cls:configAudioList()
	Theme.configAudioList(self)
    self.audio_list = self.audio_list or {}
    -- base
    self.audio_list.base_background = "audio/base/bg_bgm.mp3"
    self.audio_list.reel_stop = "audio/base/stop.mp3"
    self.audio_list.symbol_bonus = "audio/base/symbol_bonus.mp3"
    self.audio_list.bonus_land = "audio/base/bonus_land.mp3"
    self.audio_list.anticipation = "audio/base/anticipation.mp3"
    self.audio_list.map_collect = "audio/base/map_collect.mp3"
    self.audio_list.map_full = "audio/base/map_full.mp3"
    self.audio_list.collect_lock = "audio/base/collect_lock.mp3"
    self.audio_list.collect_unlock = "audio/base/collect_unlock.mp3"
    self.audio_list.jp_lock = "audio/base/jp_lock.mp3"
    self.audio_list.jp_unlock = "audio/base/jp_unlock.mp3"

    -- respin
    self.audio_list.respin_bgm = "audio/respin/respin_bgm.mp3"
    self.audio_list.respin_anticipation = "audio/respin/respin_anticipation.mp3"
    self.audio_list.jp_win = "audio/respin/jp_win.mp3"
    self.audio_list.respinCollectFly = "audio/respin/fly.mp3"
    self.audio_list.bonus1 = "audio/respin/bonus1.mp3"
    self.audio_list.dialog_trigger_respin = "audio/respin/dialog_trigger_respin.mp3"
    self.audio_list.dialog_trigger_JP = "audio/respin/dialog_trigger_JP.mp3"
    self.audio_list.dialog_respin_end = "audio/respin/dialog_respin_end.mp3"
    self.audio_list.bell = "audio/respin/bell.mp3"
    self.audio_list.jp_shows = "audio/respin/jp_shows.mp3"
    self.audio_list.reel_raise = "audio/respin/reel_raise.mp3"

    -- map
    self.audio_list.free_background = "audio/map/free_bgm.mp3"
    self.audio_list.wheel_bgm = "audio/map/wheel_bgm.mp3"
    self.audio_list.map_show = "audio/map/map_show.mp3"
    self.audio_list.map_close = "audio/map/map_close.mp3"
    self.audio_list.spin_button = "audio/map/spin_button.mp3"
    self.audio_list.wheel_show = "audio/map/wheel_show.mp3"
    self.audio_list.wheel_act = "audio/map/wheel_act.mp3"
    self.audio_list.wheel_disappear = "audio/map/wheel_disappear.mp3"
    self.audio_list.move = "audio/map/move.mp3"
    self.audio_list.move2 = "audio/map/move2.mp3"
    self.audio_list.add = "audio/map/add.mp3"
    self.audio_list.map1 = "audio/map/map1.mp3"
    self.audio_list.dialog_fg_collect = "audio/map/dialog_fg_collect.mp3"
    self.audio_list.dialog_fg_start = "audio/map/dialog_fg_start.mp3"
    self.audio_list.wheel_collect = "audio/map/wheel_collect.mp3"
end

function cls:getLoadMusicList()
    local loadMuscList = {
        -- base
        self.audio_list.base_background,
        self.audio_list.reel_stop,
        self.audio_list.symbol_bonus,
        self.audio_list.bonus_land,
        self.audio_list.anticipation,
        self.audio_list.map_collect,
        self.audio_list.map_full,
        self.audio_list.collect_lock,
        self.audio_list.collect_unlock,
        self.audio_list.jp_lock,
        self.audio_list.jp_unlock,

        -- respin
        self.audio_list.respin_bgm,
        self.audio_list.respin_anticipation,
        self.audio_list.jp_win,
        self.audio_list.respinCollectFly,
        self.audio_list.bonus1,
        self.audio_list.dialog_trigger_respin,
        self.audio_list.dialog_trigger_JP,
        self.audio_list.dialog_respin_end,
        self.audio_list.jp_shows,
        self.audio_list.reel_raise,

        -- map
        self.audio_list.free_background,
        self.audio_list.wheel_bgm,
        self.audio_list.map_show,
        self.audio_list.map_close,
        self.audio_list.spin_button,
        self.audio_list.wheel_show,
        self.audio_list.wheel_act,
        self.audio_list.wheel_disappear,
        self.audio_list.move,
        self.audio_list.move2,
        self.audio_list.add,
        self.audio_list.map1,
        self.audio_list.dialog_fg_collect,
        self.audio_list.dialog_fg_start,
        self.audio_list.wheel_collect,
    }
	return loadMuscList
end
---------------------------------------- 音效相关 end ----------------------------------------

return ThemePowerSlot