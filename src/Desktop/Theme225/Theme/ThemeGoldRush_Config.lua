


local slot_config = {}

------------------------------------------------------------------------------------------------
--@ basic configuration
slot_config.init_config = {
	plistAnimate     = {
        "image/plist/symbol",
		"image/plist/base",
    },
    csbList          = {
        "csb/base_game.csb",
    },
	spinActionConfig = {
		["start_index"] = 1,
		["spin_index"] = 1,
		["stop_index"] = 1,
		["fast_stop_index"] = 1,
		["special_index"]=1,
	},
	baseBet        = 10000,
	underPressure  = 1,
	isPortrait     = false,
}

--------------------------------------------
slot_config.pay_muti = {
	["1"] = {"3 - 50000", "3 - 20000", "3 - 10000", "3 - 5000", "3 - 3000", "3 - 2000", "3 - 1000"},

	["14"] = { "7X", "6X", "3X", "5X", "4X", "2X", "1X", },
	["15"] = { "7X", "6X", "3X", "5X", "4X", "2X", "1X", },
	["16"] = { "7X", "6X", "3X", "5X", "4X", "2X", "1X", },
	["18"] = { "500", "100", "25", },
}
--------------------------------------------
-- 滚轴配置相关
local cell_height = 128
local cell_width = 261

slot_config.reel_spin_config = {
	["delay"] = 0,
	["upBounce"] = cell_height * 2 / 3,
	["upBounceMaxSpeed"] = 6 * 60,
	["upBounceTime"] = 0,
	["speedUpTime"] = 20 / 60,
	["rotateTime"] = 5 / 60,
	["maxSpeed"] = -26.5 * 60, -- -30 * 60,
	["downBounceMaxSpeed"] = 10 * 60,-- 6 * 60,
	["extraReelTime"] = 120 / 60,
	["spinMinCD"] = 0.5,
	-- whj 修改速度
	["speedDownTime"] =  45 / 60, -- 40 / 60,
	["downBounce"] = cell_height*2/5, -- 对应 普通停止在symbol + 1 
	["downBounceTime"] = 15 / 60,-- 20/60,
	["autoDownBounceTimeMult"] = 1,
	["checkStopColCnt"] = 5,
	-- end
	["stopDelay"] =15 / 60, -- 20/60,
	["stopDelayList"] = {
	    [1] = 15 / 60,
	    [2] = 15 / 60,
	    [3] = 15 / 60,
	},
	["autoStopDelayMult"] = 1,
	["speicalSpeed"] = 100/30,
	["extraReelTimeInFreeGame"] = 240/30,
}

--------------------------------------------
-- symbol 相关
slot_config.special_symbol = {
	["scatter"] = 8, 
	["bonus"] = 9, ["bonus1"] = 10, ["bonus2"] = 11, ["bonus3"] = 12,
	["kong"] = 20
}

slot_config.symbol_config = {
	["scatter_key_list"] = {slot_config.special_symbol.scatter},
	["not_init_symbol_set"] = Set(slot_config.special_symbol),
	["notify_symbol_list"] = Set({ -- -- @ 落地动画相关
		slot_config.special_symbol.scatter, -- scatter
		slot_config.special_symbol.bonus1, slot_config.special_symbol.bonus2, slot_config.special_symbol.bonus3, 
	}),
	["loop_symbol_list"] = Set({
		slot_config.special_symbol.scatter, -- scatter
		slot_config.special_symbol.bonus1, slot_config.special_symbol.bonus2, slot_config.special_symbol.bonus3, 
	}),
	["anim_suffix"] = {
		["loop"] = "2", ["notify"] = "", ["win"] = "3"
	},
	scatter_config = {
		scatter_key = slot_config.special_symbol.scatter,
		scatter_add = 100, 
		scatter_pos = cc.p(75, -13),
		name = "scatter"
	},
	win_feature_config = {
		min_cnt = 3,
		check_min_cnt = 2,
		col_set = 3
	},
	bonus_config = {
		bonus_set = Set({slot_config.special_symbol.bonus1, slot_config.special_symbol.bonus2, slot_config.special_symbol.bonus3}),
		name = "bonus"
	}
}

slot_config.reel_stop_config = {
	["max_stop_level"] = 3,
	["symbol_stop_level"] = {
		[slot_config.special_symbol.scatter] = 1,
		[slot_config.special_symbol.bonus1] = 2, [slot_config.special_symbol.bonus2] = 2, [slot_config.special_symbol.bonus3] = 2,
	}
}

-- local cell_height = 128
-- local cell_width = 261
slot_config.board_config = {
	[0] = {
		board_pos 	= { cc.p(580, 302) },
		reel_pos 	= { cc.p(188.5, 107) },
		tip_pos 	= cc.p(0, 253),
		scale 		= 1
	},
	[1] = { -- 1
		board_pos 	= { cc.p(549, 298) },
		reel_pos 	= { cc.p(157.5,103) },
		tip_pos 	= cc.p(0, 253),
		scale 		= 1.16
	},
	[2] = { -- 2
		board_pos 	= { cc.p(700, 566), cc.p(1510, 566) },
		reel_pos 	= { cc.p(308.5,371), cc.p(1118.5,371) },
		tip_pos 	= cc.p(0, 121),
		scale 		= 0.58
	},
	[3] = { -- 3
		board_pos 	= { cc.p(700, 383), 	cc.p(1510, 383), 	cc.p(1103, 795) },
		reel_pos 	= { cc.p(308.5,188),	cc.p(1118.5,188),	cc.p(711.5,600), },
		tip_pos 	= cc.p(0, 252),
		scale 		= 0.58
	},
	[4] = { -- 4
		board_pos 	= { cc.p(700, 383), 	cc.p(1510, 383), 	cc.p(700, 795), 	cc.p(1510, 795) },
		reel_pos 	= { cc.p(308.5,188), 	cc.p(1118.5,188), 	cc.p(308.5,600), 	cc.p(1118.5,600)},
		tip_pos 	= cc.p(0, 252),
		scale 		= 0.58
	},
	[6] = { -- 6	
		board_pos 	= { cc.p(642, 610), 	cc.p(1456, 610), 	cc.p(2270, 610),  	cc.p(642, 1026), 	cc.p(1456, 1026), 	cc.p(2270, 1026),  },
		reel_pos 	= { cc.p(250.5,415), 	cc.p(1064.5,415), 	cc.p(1878.5,415), 	cc.p(250.5,831), 	cc.p(1064.5,831), 	cc.p(1878.5,831)},
		tip_pos 	= cc.p(0, 216),
		scale 		= 0.44
	},
	[9] = { -- 6	
		board_pos 	= { 
			cc.p(866, 482), 	cc.p(1685.5, 482), 	cc.p(2505, 482),
			cc.p(866, 900), 	cc.p(1685.5, 900), 	cc.p(2505, 900),
			cc.p(866, 1318), 	cc.p(1685.5, 1318), cc.p(2505, 1318),
		},
		reel_pos 	= { 
			cc.p(474.5,287), 	cc.p(1294.0,287), 	cc.p(2113.5,287), 	
			cc.p(474.5,705), 	cc.p(1294.0,705), 	cc.p(2113.5,705), 	
			cc.p(474.5,1123), 	cc.p(1294.0,1123), 	cc.p(2113.5,1123)
		},
		tip_pos 	= cc.p(0, 252),
		scale 		= 0.38
	},
	[10] = { -- 展示区域是106*3， symbol 高度 128, 棋盘裁剪边界是118
		["show_parts"] = true, --gai
		["_board_id_list"] = {10, 11, 12},
		["mask_bottom"] = 118,
		["mask_top"] = 106*3 + 118,
		["reelConfig"] = {
			{
				["base_pos"] = cc.p(198.5, 85), -- base.y + cellHeight/2
				["cellWidth"] = 191,
				["cellHeight"] = 128,
				["symbolCount"] = 3
			},
			{
				["base_pos"] = cc.p(415, 85),
				["cellWidth"] = 191,
				["cellHeight"] = 128,
				["symbolCount"] = 3
			},
			{
				["base_pos"] = cc.p(631.5, 85),
				["cellWidth"] = 191,
				["cellHeight"] = 128,
				["symbolCount"] = 3
			},
		}
	},
}

slot_config.theme_config = {
	-- base
	["theme_symbol_coinfig"]    = {
		["symbol_zorder_list"]  = {
            [slot_config.special_symbol.scatter]	= 3200,
            [slot_config.special_symbol.bonus1]	= 3000,
            [slot_config.special_symbol.bonus2]	= 3000,
            [slot_config.special_symbol.bonus3]	= 3000,
		},
		["normal_symbol_list"]  = {
			7, 6, 5, 4, 3, 2, 1, 
		},
		["special_symbol_list"] = {
			slot_config.special_symbol.scatter, 
		},
		["no_roll_symbol_list"] = { 
			28, 26, 27, 25, 23, 24, 21, 22, 20,
			10, 12, 11, 8,
		},

		["roll_symbol_inFree_list"] = {
		},
		["special_symbol_config"] = {
			[slot_config.special_symbol.scatter] = {
				["min_cnt"] = 3,
				["check_min_cnt"] = 2,
				["type"]	= G_THEME_SYMBOL_TYPE.NUMBER,
				["col_set"] = {
					[1] 	= 3, 
					[2] 	= 3,  
					[3] 	= 3,
				},
			},
		},
	},
	["theme_round_light_index"] = 1,
	["theme_type"] = "ways",
	["theme_type_config"] = {
		["ways_cnt"]   = 27
	},
	["board_temp"] = {
		["reel_single"] = true,
		["allow_over_range"] = true,
		["colCnt"] = 3,
		["rowCnt"] = 3,
		["cellWidth"] = cell_width,
		["cellHeight"] = cell_height,
	},

	["spin_action_config"] = {
		["start_index"] = 1,
		["spin_index"] = 1,
		["stop_index"] = 1,
		["fast_stop_index"] = 1,
		["special_index"]=1,
	},

	["base_bet"]         = 10000,
	["under_pressure"]   = 1,
	["is_portrait"]    	= false,
	["base_col_cnt"] = 3,
	["base_row_cnt"] = 3,
	["g_cell_width"] = cell_height,
	["g_cell_height"] = cell_width,

	-- extend
	["max_row_cnt"] = 3,
	["base_board_cnt"] = 1,

	["dialog_show_or_hide_time"] = 0.5,
	["dimmer_show_or_hide_time"] = 0.2,

}

--------------------------------------------
-- transition
slot_config.transitionConfig = { 
	["free"] = {
		["path"] = "spine/transition/free/qieping", 
		["animName"] = "animation", 
		["audio"] = "transition_free", 
		["coverTime"] = 18/30,
		["endTime"] = 41/30
	},
	["sfree"] = {
		["path"] = "spine/transition/sfree/siyecaoqieping", 
		["animName"] = "animation", 
		["audio"] = "transition_sfree", 
		["coverTime"] = 25/30,
		["endTime"] = 55/30
	},
	["bonus"] = {
		["path"] = "spine/transition/bonus/jibiqieping", 
		["animName"] = "animation", 
		["audio"] = "transition_bonus", 
		["coverTime"] = 43/30,
		["endTime"] = 70/30
	},
}

slot_config.audioList = {
	-- base
	["special_stop1"] 			= "audio/base/scatter_land.mp3",
	["special_stop2"] 			= "audio/base/slot_land.mp3", -- slot落地
	["sfg_lock"] 				= "audio/base/sfg_lock.mp3", -- 推图上锁
	["sfg_unlock"] 				= "audio/base/sfg_unlock.mp3", -- 推图解锁
	["slot_fly"] 				= "audio/base/slot_fly.mp3", -- slot粒子飞+接收
	["slot_spin"] 				= "audio/base/slot_spin.mp3", -- slot中奖spin音
	["jp_lock"] 				= "audio/base/jp_lock.mp3", -- jp上锁
	["jp_unlock"] 				= "audio/base/jp_unlock.mp3", -- jp解锁
	["scatter_collect"] 		= "audio/base/scatter_collect.mp3", -- scatter飞粒子+接收点亮
	["bonus_reel_notify1"] 		= "audio/base/bonus_anticipation1.mp3", -- FG轮轴激励，3种，依次增强
	["bonus_reel_notify2"] 		= "audio/base/bonus_anticipation2.mp3", -- FG轮轴激励，3种，依次增强
	["scatter_reel_notify1"] 	= "audio/base/free_anticipation1.mp3", -- FG轮轴激励，3种，依次增强
	["scatter_reel_notify2"] 	= "audio/base/free_anticipation2.mp3", -- FG轮轴激励，3种，依次增强
	["transition_sfree"] 		= "audio/base/sfg_transition.mp3", -- SFG切屏
	["bell"] 					= "audio/base/bell.mp3", -- 打铃
	["common_click"] 			= "audio/base/click.mp3", -- 点击音效，所有按钮
	["popup_out"] 				= "audio/base/popup_out.mp3", -- 弹窗收回，所有
	
	-- bonus
	["win_jp"]				= "audio/bonus/win_jp.mp3", -- JPsymbol激活
	["slot_change"]			= "audio/bonus/slot_change.mp3", -- 牌面转换
	["roll_up"]				= "audio/bonus/roll_up.mp3", -- 拉动遥杆
	["win_jp_show"]			= "audio/bonus/dialog_jp.mp3", -- JP弹窗
	["jp_active"]			= "audio/bonus/jp_active.mp3", -- JP弹窗
	["slot_spin_roll"]		= "audio/bonus/slot_spin.mp3",

	-- free
	["spin_fly"] 			= "audio/free/spin_fly.mp3", -- 加1spin出现，飞粒子到footer+接受
	["scatter_fly"] 		= "audio/free/scatter_fly.mp3", -- scatter飞粒子+接受
	["fg_count"] 			= "audio/free/fg_count.mp3", -- 牌面上方小框刷新特效出现
	["sfg_bgm"] 			= "audio/free/sfg_bgm.mp3",
	["dialog_sfg_start"] 	= "audio/free/dialog_sfg_start.mp3",
	["dialog_sfg_collect"] 	= "audio/free/dialog_sfg_collect.mp3",
	["dialog_fg_start"] 	= "audio/free/dialog_fg_start.mp3",
	["dialog_fg_collect"] 	= "audio/free/dialog_fg_collect.mp3",
	["retrigger_bell"]	 	= "audio/base/bell.mp3",
	
	-- person 
	["super_bonus"] 			= "audio/person/super_bonus.mp3",
	["mega_bonus"] 				= "audio/person/mega_bonus.mp3",
	["lucky_clover_free_games"] = "audio/person/lucky_clover_free_games.mp3",
	["welcome_theme"] 			= "audio/person/gold_rush_with_roisin.mp3",
	["person_jp0"] 				= "audio/person/gold_pot_jackpot.mp3",
	["person_jp1"] 				= "audio/person/blue_pot_jackpot.mp3",
	["person_jp2"] 				= "audio/person/red_pot_jackpot.mp3",
	["fortune_pot_jackpot"] 	= "audio/person/fortune_pot_jackpot.mp3",
	["reset_board2"] 			= "audio/person/2_reel_sets_unlock.mp3",
	["reset_board3"] 			= "audio/person/3_reel_sets_unlock.mp3",
	["reset_board4"] 			= "audio/person/4_reel_sets_unlock.mp3",
	["reset_board6"] 			= "audio/person/6_reel_sets_unlock.mp3",
	["reset_board9"] 			= "audio/person/9_reel_sets_unlock.mp3",
}

slot_config.theme_reels = {
	["main_reel"] = {
		[1] = {2, 2, 102, 102, 2, 2, 2, 2, 10, 4, 3, 103, 3, 10, 10, 5, 5, 105, 6, 5, 106, 6, 1, 10, 10, 110, 10, 1, 7, 7, 7, 107, 4, 107, 4,  10, 4, 4, 103, 4, 10, 10, 10, 3, 3, 103, 7, 7, 1, 105, 5, 4, 5, 5, 110, 110, 10, 10, 10, 10, 6, 4, 6, 101, 1, 1, 1, 1, 101, 1, 4, 4, 102, 7, 2, 102, 3, 3, 103, 5, 5, 10, 3, 5, 5, 6, 106, 7, 6, 7, 7, 110, 4, 104, 4, 5, 105},
		[2] = {2, 2, 102, 102, 2, 2, 2, 2, 4, 3, 11, 103, 3, 11, 111, 5, 5, 105, 6, 5, 106, 6, 1, 1, 7, 111, 1, 11, 11, 7, 107, 7, 4, 107, 4, 11, 4, 4, 3, 104, 11, 11, 11, 3, 3, 103, 7, 7, 1, 105, 5, 4, 5, 5, 11, 11, 11, 111, 111, 11, 6, 4, 6, 101, 1, 1, 1, 1, 1, 101, 4, 4, 102, 7, 2, 102, 3, 3, 103, 5, 5, 3, 5, 11, 5, 6, 106, 7, 6, 7, 7, 4, 111, 104, 4, 5, 105},
		[3] = {2, 2, 102, 102, 2, 2, 2, 2, 4, 3, 103, 12, 3, 12, 112, 5, 105, 6, 5, 6, 106, 1, 1, 7, 107, 7, 7, 4, 107, 12, 12, 12, 12, 4, 4, 12, 4, 3, 4, 103, 12, 12, 12, 3, 103, 7, 7, 1, 105, 5, 4, 5, 5, 6, 12, 12, 112, 112, 12, 12, 4, 6, 101, 1, 1, 1, 1, 1, 101, 4, 4, 102, 7, 2, 102, 3, 3, 103, 5, 5, 3, 5, 5, 6, 106, 7, 12, 6, 7, 7, 4, 104, 4, 112, 5, 105},
	},
	["free_reel"] = {
		[1] = {2, 102, 102, 2, 2, 2, 102, 2, 4, 3, 103, 3, 5, 5, 5, 6, 5, 106, 6, 1, 1, 107, 7, 7, 7, 104, 107, 4,  4, 4, 103, 4, 3, 3, 3, 7, 7, 1, 105, 5, 4, 5, 105, 6, 4, 6, 1, 101, 1, 1, 1, 101, 1, 4, 4, 102, 7, 2, 2, 3, 3, 103, 5, 5, 3, 105, 5, 6, 106, 7, 6, 7, 7, 4, 4, 4, 105, 105},
		[2] = {2, 2, 102, 102, 2, 2, 2, 102, 4, 3, 103, 3, 5, 5, 5, 6, 5, 106, 6, 1, 1, 107, 7, 7, 7, 104, 107, 4, 4, 4, 3, 104, 3, 3, 3, 7, 7, 1, 105, 5, 4, 5, 105, 6, 4, 6, 1, 101, 1, 1, 1, 1, 101, 4, 4, 102, 7, 2, 2, 3, 3, 103, 5, 5, 3, 105, 5, 6, 106, 7, 6, 7, 7, 4, 4, 4, 105, 105},
		[3] = {2, 2, 2, 102, 102, 2, 102, 2, 4, 3, 103, 3, 5, 5, 6, 5, 106, 6, 1, 1, 7, 107, 7, 7, 104, 107, 4, 4, 4, 3, 4, 103, 3, 3, 7, 7, 1, 105, 5, 4, 5, 105, 6, 4, 6, 1, 101, 1, 1, 1, 1, 101, 4, 4, 102, 7, 2, 2, 3, 3, 103, 5, 5, 3, 105, 5, 6, 106, 7, 6, 7, 7, 4, 4, 4, 105, 105},
	},
	["bonus_reel"] = {
		[1] = {20, 25, 20, 26, 20, 21, 20, 24, 20, 28, 20, 21, 20, 24, 20, 28, 20, 25, 20, 21, 20, 26, 20, 26, 20, 28, 20, 27, 20, 27, 20, 24, 20, 21, 20, 25, 20, 27, 20, 21, 20, 24, 20, 21, 20, 24, 20, 21, 20, 25, 20, 21, 20, 25, 20, 21, 20, 26, 20, 21, 20, 26, 20, 21, 20, 27, 20, 21, 20, 27, 20, 21, 20, 28, 20, 21, 20, 28},
		[2] = {20, 26, 20, 27, 20, 21, 20, 27, 20, 28, 20, 21, 20, 25, 20, 28, 20, 24, 20, 21, 20, 24, 20, 26, 20, 28, 20, 25, 20, 27, 20, 25, 20, 21, 20, 24, 20, 26, 20, 21, 20, 24, 20, 21, 20, 24, 20, 21, 20, 25, 20, 21, 20, 25, 20, 21, 20, 26, 20, 21, 20, 26, 20, 21, 20, 27, 20, 21, 20, 27, 20, 21, 20, 28, 20, 21, 20, 28},
		[3] = {20, 28, 20, 24, 20, 21, 20, 24, 20, 25, 20, 21, 20, 28, 20, 26, 20, 27, 20, 21, 20, 27, 20, 25, 20, 28, 20, 24, 20, 27, 20, 26, 20, 21, 20, 25, 20, 26, 20, 21, 20, 24, 20, 21, 20, 24, 20, 21, 20, 25, 20, 21, 20, 25, 20, 21, 20, 26, 20, 21, 20, 26, 20, 21, 20, 27, 20, 21, 20, 27, 20, 21, 20, 28, 20, 21, 20, 28},
	},
}

slot_config.all_img_path = {
	{1, "font/font_2.png" },
	{1, "font/font_3.png" },
	{1, "font/theme225_font_1.png" },
	{1, "font/theme225_font_j0.png" },
	{1, "image/bg/theme225_bg_base.png" },
	{1, "image/bg/theme225_bg_free.png" },
	{1, "image/bg/theme225_bg_sfree.png" },
	{1, "image/paytable/paytable_theme225.png" },
	{1, "image/plist/base.png" },
	{1, "image/plist/bonus.png" },
	{1, "image/plist/symbol.png" },
	{1, "spine/base/anticipation/jili1.png" },
	{1, "spine/base/anticipation/jili2.png" },
	{1, "spine/base/bg_loop/bgxunhuan.png" },
	{1, "spine/base/bg_loop/bj.png" },
	{1, "spine/base/collect/dl.png" },
	{1, "spine/base/collect/tuitushangsuo.png" },
	{1, "spine/base/cp_logo.png" },
	{1, "spine/base/reel_loop/qipanxunhuan.png" },
	{1, "spine/bonus/collect/hong.png" },
	{1, "spine/bonus/collect/huang.png" },
	{1, "spine/bonus/collect/lan.png" },
	{1, "spine/bonus/slot/bonus_gan.png" },
	{1, "spine/bonus/slot/bonus_kuang.png" },
	{1, "spine/bonus/slot/bonus_kuangqz.png" },
	{1, "spine/bonus/slot/bonus_zhongjiang.png" },
	{1, "spine/dialog/bonus/bousn_k_js_01.png" },
	{1, "spine/dialog/com_btn/anniu_sg_01.png" },
	{1, "spine/dialog/com_btn/anniu_sg_02.png" },
	{1, "spine/dialog/free/1spine.png" },
	{1, "spine/dialog/free/fg_tc_01.png" },
	{1, "spine/dialog/free/sfg_ks_js_01.png" },
	{1, "spine/dialog/jp/blue_pot_01.png" },
	{1, "spine/free/fg_cao.png" },
	{1, "spine/free/fg_cao2.png" },
	{1, "spine/free/fg_kshua.png" },
	{1, "spine/free/fg_kuang.png" },
	{1, "spine/free/fg_kuangjs.png" },
	{1, "spine/free/shuzi.png" },
	{1, "spine/free/spin_js.png" },
	{1, "spine/item/1/wild.png" },
	{1, "spine/item/2/m1.png" },
	{1, "spine/item/21/m2.png" },
	{1, "spine/item/22/m2.png" },
	{1, "spine/item/23/m2.png" },
	{1, "spine/item/24/m2.png" },
	{1, "spine/item/25/m2.png" },
	{1, "spine/item/26/m2.png" },
	{1, "spine/item/27/m2.png" },
	{1, "spine/item/28/m2.png" },
	{1, "spine/item/3/m2.png" },
	{1, "spine/item/4/m3.png" },
	{1, "spine/item/5/m4.png" },
	{1, "spine/item/6/m5.png" },
	{1, "spine/item/7/m6.png" },
	{1, "spine/item/bonus/2x.png" },
	{1, "spine/item/bonus/3x.png" },
	{1, "spine/item/bonus/5x.png" },
	{1, "spine/item/bonus_active/jh.png" },
	{1, "spine/item/item_low/l1_5.png" },
	{1, "spine/item/item_slot/zj.png" },
	{1, "spine/item/scatter/scatter.png" },
	{1, "spine/jackpot/jpsuo.png" },
	{1, "spine/jackpot/jpxunhuan.png" },
	{1, "spine/jackpot/jpzhongjiang.png" },
	{1, "spine/kuang/zjlx.png" },
	{1, "spine/paytable/dantu/CX_saoguang01.png" },
	{1, "spine/paytable/dantu/elephant_gl01.png" },
	{1, "spine/paytable/spine/back_to_game01.png" },
	{1, "spine/transition/bonus/jibiqieping.png" },
	{1, "spine/transition/free/qieping.png" },
	{1, "spine/transition/sfree/siyecaoqieping.png" },
}

slot_config.csb_list = {
    ["base"]          	= "csb/base_game.csb",
    ["board"]          	= "csb/base_reel.csb",
    ["slot_machine"]    = "csb/classic_machine.csb",
    ["classic"]    		= "csb/classic_dialog.csb",
    ["jp"]    			= "csb/classic_jp_dialog.csb",
    ["free"] 			= "csb/free_dialog.csb",
    ["sfree"] 			= "csb/sfree_dialog.csb",
}

slot_config.dimmer_config = {
	free = {
		[1] = "scene",
		-- [2] = "scene",
		[3] = "scene",
	},
	sfree = {
		[1] = "scene",
		-- [2] = "scene",
		[3] = "scene",
	},
	classic = {
		[1] = "scene",
		[3] = "scene",
	},
	jp = {
		[3] = "scene",
	},
}

slot_config.dialog_config = {
    ["free"]     = {
    	["frame_config"]= {
	        ["start"]    = { nil, (25/30), nil, (40/30) },
	        ["more"]    = { nil, (55/30), nil, (45/30) },
	        ["collect"]    = { nil, (25/30), nil, (40/30) },
	    },
        [1] = {--start
            bg         = {
                name        = "dialog_free",
                startAction = { "animation1_1", false },
                loopAction  = { "animation1_2", true },
                endAction   = { "animation1_3", false },
            },
            num_sp  = {
                isImg      = true,
                name       = "#theme225_fg_2_popopup_num%s.png",
                formatname = true,
            },
            label_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 16 / 30, 0 }, { 5 / 30, 1.2 }, { 5 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 6 / 30, 1 }, { 5 / 30, 0.95 }, { 4 / 30, 1.2 }, { 6 / 30, 0 } },
            },
            btn_start   = {
                isAction     = true,
                stepScale    = { { 0 }, { 26 / 30, 0 }, { 5 / 30, 1.2 }, { 5 / 30, 0.95 }, { 4 / 30, 1 } },
                stepEndScale = { { 1 }, { 4 / 30, 0.95 }, { 4 / 30, 1.2 }, { 4 / 30, 0 } },
            },
            btn        = {
                name    = "btn_start",
                aniName = "animation",
            },
        },
        [2] = {--more
            bg         = {
                name        = "dialog_more",
                startAction = { "animation", false },
            },
        },
        [3] = { --collect
            bg         = {
                name        = "dialog_free",
                startAction = { "animation2_1", false },
                loopAction  = { "animation2_2", true },
                endAction   = { "animation2_3", false }
            },
            label_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 16 / 30, 0 }, { 5 / 30, 1.2 }, { 5 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 4 / 30, 1 }, { 4 / 30, 0.95 }, { 6 / 30, 1.2 }, { 5 / 30, 0 } },
            },
            btn_collect   = {
                isAction     = true,
                stepScale    = { { 0 }, { 22 / 30, 0 }, { 5 / 30, 1.2 }, { 5 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 4 / 30, 0.95 }, { 5 / 30, 1.2 }, { 5 / 30, 0 } },
            },
            btn        = {
                name    = "btn_collect",
                aniName = "animation",
            },

            maxWidth   = 680,
        }
    },
    ["sfree"]     = {
    	["frame_config"]= {
	        ["start"]    = { nil, (25/30), nil, 40/30 },
	        ["more"]    = { nil, (55/30), nil, (45/30) },
	        ["collect"]    = { nil, (25/30), nil, (40/30) },
	    },
        [1] = {--start
            bg         = {
                name        = "dialog_sfree",
                startAction = { "animation%s_1", false },
                loopAction  = { "animation%s_2", true },
                endAction   = { "animation%s_3", false },
                formatname  = true,
            },
            num_sp  = {
                isImg      = true,
                name       = "#theme225_fg_2_popopup_num%s.png",-- "#theme225_fg_popopup_%s.png",
                formatname = true,
            },
            label_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 12 / 30, 0 }, { 7 / 30, 1.2 }, { 5 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 6 / 30, 1 }, { 3 / 30, 0.95 }, { 4 / 30, 1.2 }, { 4 / 30, 0 } },
            },
            btn_start   = {
                isAction     = true,
                stepScale    = { { 0 }, { 21 / 30, 0 }, { 7 / 30, 1.2 }, { 5 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 3 / 30, 0.95 }, { 4 / 30, 1.2 }, { 4 / 30, 0 } },
            },
            btn        = {
                name    = "btn_start",
                aniName = "animation",
            },
        },
        [2] = {--more
            bg         = {
                name        = "dialog_more",
                startAction = { "animation", false },
            },
        },
        [3] = { --collect
            bg         = {
                name        = "dialog_sfree",
                startAction = { "animation3_1", false },
                loopAction  = { "animation3_2", true },
                endAction   = { "animation3_3", false }
            },
            label_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 15 / 30, 0 }, { 7 / 30, 1.2 }, { 5 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 6 / 30, 1 }, { 5 / 30, 0.95 }, { 5 / 30, 1.2 }, { 7 / 30, 0 } },
            },
            btn_collect   = {
                isAction     = true,
                stepScale    = { { 0 }, { 21 / 30, 0 }, { 7 / 30, 1.2 }, { 5 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 5 / 30, 0.95 }, { 5 / 30, 1.2 }, { 7 / 30, 0 } },
            },
            btn        = {
                name    = "btn_collect",
                aniName = "animation",
            },

            maxWidth   = 700,
        }
    },
	["jp"] 		= {--jackpot
		["frame_config"]= {
	        ["collect"]    = { nil, (45/30), nil, (35/30) },
	    },
	    [3] = {
	        bg         = {
	            name        = "jp_collect",
	            startAction = { "animation%s_1", false },
	            loopAction  = { "animation%s_2", true },
	            endAction   = { "animation%s_3", false },
	            formatname  = true,
	        },
	        label_node = {
	            isAction     = true,
	            stepScale    = { { 0 }, { 15 / 30, 0 }, { 7 / 30, 1.2 }, { 6 / 30, 0.95 }, { 7 / 30, 1 } },
                stepEndScale = { { 1 }, { 5 / 30, 1 }, { 5 / 30, 0.95 }, { 6 / 30, 1.2 }, { 6 / 30, 0 } },

	        },
	        btn_node   = {
	            isAction     = true,
	            stepScale    = { { 0 }, { 20 / 30, 0 }, { 7 / 30, 1.2 }, { 5 / 30, 0.95 }, { 6 / 30, 1 } },
	            stepEndScale = { { 1 }, { 6 / 30, 0.95 }, { 5 / 30, 1.2 }, { 12 / 30, 0 } },
	        },
	        btn        = {
	            name    = "btn_collect",
	            aniName = "animation",
	        },
	        maxWidth   = 700,
	    }

	},
    ["classic"]     = {
    	["frame_config"]= {
	        ["start"]    = { nil, (35/30), nil, (30/30) },
	        ["collect"]    = { nil, (35/30), nil, (30/30) },
	    },
        [1] = {--start
            bg         = {
                name        = "dialog_bonus",
                startAction = { "animation1_1", false },
                loopAction  = { "animation1_2", true },
                endAction   = { "animation1_3", false },
            },
            btn_start   = {
                isAction     = true,
                stepScale    = { { 0 }, { 20 / 30, 0 }, { 5 / 30, 1.2 }, { 5 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 4 / 30, 0.95 }, { 5 / 30, 1.2 }, { 4 / 30, 0 } },
            },
            btn        = {
                name    = "btn_start",
                aniName = "animation",
            },
        },
        [3] = { --collect
            bg         = {
                name        = "dialog_bonus",
                startAction = { "animation2_1", false },
                loopAction  = { "animation2_2", true },
                endAction   = { "animation2_3", false }
            },
            label_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 15 / 30, 0 }, { 5 / 30, 1.2 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 3 / 30, 1 }, { 5 / 30, 0.95 }, { 4 / 30, 1.2 }, { 5 / 30, 0 } },
            },
            btn_collect   = {
                isAction     = true,
                stepScale    = { { 0 }, { 20 / 30, 0 }, { 5 / 30, 1.2 }, { 5 / 30, 0.95 }, { 5 / 30, 1 } },
                stepEndScale = { { 1 }, { 4 / 30, 0.95 }, { 5 / 30, 1.2 }, { 4 / 30, 0 } },
            },
            btn        = {
                name    = "btn_collect",
                aniName = "animation",
            },

            maxWidth   = 790,
        }
    },
    ["black_common"] = {
        stepFade     = { { 0 },  { 8 / 30, 200 } },
        stepEndFade  = { { 200 }, { 8 / 30, 0 } },
    }
}

------------------------------------------------------------------------------------------------
--@ special configuration
slot_config.spine_path = {
	-- base
	reel_loop 			= "base/reel_loop/qipanxunhuan",
	bonus_reel_notify 	= "base/anticipation/jili1",
	scatter_reel_notify = "base/anticipation/jili2",
	base_bg 		= "base/bg_loop/bgxunhuan",
	free_bg 		= "base/bg_loop/bj",
    item_low       	= "item/item_low/l1_5",
    scatter			= "item/scatter/spine",
    bonus10			= "item/bonus/2x",
    bonus11			= "item/bonus/3x",
    bonus12			= "item/bonus/5x",
    item_slot		= "item/item_slot/zj",
    logo_name		= "base/cp_logo",
    
    ---jackpot
    jp_loop   		= "jackpot/jpxunhuan",
    jp_win      	= "jackpot/jpzhongjiang",
    jp_lock     	= "jackpot/jpsuo",
    
    ---collect
    collect_lock    = "base/collect/tuitushangsuo",
    -- collect_full    = "kuang/spine", -- 暂时没有需求
    b_collect_arr 	= "base/collect/dl",

    ---free
    f_collect_loop  = "free/fg_kuang",
    f_collect_full  = "free/fg_kshua",
    f_collect_arr   = "free/fg_kuangjs",
    f_collect_arr_num   = "free/shuzi",
    f_collect_arr_leaf  = "free/fg_cao2",
    f_icon  	 	= "free/fg_cao",
    f_footer_arr  	= "free/spin_js",

    ---bonus
    -- slot
    -- jp_arr  		= "kuang/spine", -- 暂时没有需求
    bonus_active  	= "item/bonus_active/jh",
    slot_kuang  	= "bonus/slot/bonus_kuang",
    slot_win_kuang  = "bonus/slot/bonus_kuangqz",
    slot_spin		= "bonus/slot/bonus_gan",
    slot_win_pay	= "bonus/slot/bonus_zhongjiang",
    -- collect
    slot_c1			= "bonus/collect/hong",
    slot_c2			= "bonus/collect/lan",
    slot_c3			= "bonus/collect/huang",

    --- dialog
    dialog_free     = "dialog/free/fg_tc_01",
    dialog_sfree    = "dialog/free/sfg_ks_js_01",
    dialog_more     = "dialog/free/1spine",
    dialog_bonus 	= "dialog/bonus/bousn_k_js_01",
    jp_collect 		= "dialog/jp/blue_pot_01",

    btn_collect   	= "dialog/com_btn/anniu_sg_01",
    btn_start   	= "dialog/com_btn/anniu_sg_02",
}

slot_config.particle_path = {
    free_c1 	= "shouji1.plist", -- 1 的层级高
    free_c2 	= "shouji2.plist",
    base_sc1 	= "scatter1_1.plist", -- 1 的层级高
    base_sc2 	= "scatter_1.plist",
}

------------------------------------------------------------------------------------------------
slot_config.FeatureName = { -- unlock相关, feature 状态控制
	Bonus = 1,
	Free = 2,
	OpenMap = 3,
}

slot_config.SpinBoardType = { -- board type
	Normal 		= 0,
	FreeSpin 	= 1,
	SFree1 		= 2,
	SFree2 		= 2,
	Bonus 		= 10,
}

slot_config.spin_baord_cnt = { -- spin layer type
	Normal 	= 1,
	-- FreeSpin = 1,
	-- SFree1 	= 2,
	-- SFree2 	= 2,
	Bonus 	= 1,
}

slot_config.ReSpinStep = {
	OFF = 1,
	Start = 2,
	Reset = 3,
	Over = 4,
	Playing = 5,	
	-- Check = 6,
}
-- slot_config.SpinLayerType = { -- spin layer type
-- 	Normal 	= 0,
-- 	FreeSpin = 1,
-- 	SFree1 	= 2,
-- 	SFree2 	= 2,
-- 	Bonus 	= 3,
-- }

slot_config.BlackUint = { -- 黑色通用图片大小
    width = 54,
    height = 54
}

slot_config.specialSTriggerAnimTime = 2

------------------------------------ base 通用相关 ----------------------------------------
slot_config.normalColor = cc.c3b(255, 255, 255)
slot_config.lockJackpotColor = cc.c3b(90,90,90)

---------------------------- 	feature 解锁 相关 	----------------------------
slot_config.unlockInfoTypeList = { 1, 2, 3, 4, 5, 6 }

slot_config.unlockInfoConfig = {
	RedJackpot = 1,
	Map = 2,
	BlueJackpot = 3,
	GoldJackpot = 4,
}

slot_config.unlockJpInfoConfig = {
	RedJackpot = 1,
	BlueJackpot = 3,
	GoldJackpot = 4,
}
-------------------------------------------------------------------------------------------
-- @ jackpot 相关
-- slot_config.jackpotTipNodeConfig = {
-- 	["lock"] = {
-- 		["node1"] = "text",
-- 		["node2"] = "name",
-- 		["extra_width"] = 10,
-- 	},

-- 	["unlock"] = {
-- 		["node1"] = "name",
-- 		["node2"] = "text",
-- 		["extra_width"] = 6,

-- 	}
-- }

slot_config.jp_config = {
	-- base
	["jp_config_list"] = {
		link_config = {"gold_jackpot", "blue_jackpot", "red_jackpot"},
		allowK = {[225] = false, [725] = false, [1225] = false}
	},
	-- extend
	["jp_cnt"] = 3,
	["jp_max_width"] = {233, 233, 233},

	["jp_level"] = {
		[0] = slot_config.unlockInfoConfig.GoldJackpot,
		[1] = slot_config.unlockInfoConfig.BlueJackpot,
		[2] = slot_config.unlockInfoConfig.RedJackpot,
	},
	["unlock_sp_name"] = "#theme225_baes_jp_name%s.png"
}

------------------------------------ free 通用相关 ----------------------------------------
slot_config.fs_show_type = {
	start = 1,
	more = 2,
	collect = 3,
}

slot_config.FreeGameType = {
    Normal = 0,
    SFree1 = 1,
    SFree2 = 2,
}

slot_config.collect_config = {
	max_level = 20,
	mega_level_set = Set({5, 10}),
	fly_up_time = 0.5,
	full_time = 0, -- 0.5
	collect_key = 100,

	item_sp_path = {
		small = {
			light 	= "#theme225_baes_11.png",
			dark 	= "#theme225_baes_12.png",
		},
		mega = {
			light 	= "#theme225_baes_map_light_1.png",
			dark 	= "#theme225_baes_map_dark_1.png",
		},
		super = {
			light 	= "#theme225_baes_map_light_2.png",
			dark 	= "#theme225_baes_map_dark_2.png",
		},
	},
	item_sp_type = {
		[5] = "mega",
		[10] = "mega",
		[20] = "super",
	},
	item_normal_type = "small",
	lock_anim = {
		lock = "animation1",
		lock_loop = "animation2",
		unlock = "animation3",
		unlock_loop = "animation4",
	}
}
----------- free
slot_config.free_config = {
	board_count = {1, 2, 3, 4, 6, 9},
	collect_count = {
		[1] = 0, 
		[2] = 4, 
		[3] = 12, 
		[4] = 22, 
		[6] = 35, 
		[9] = 50,
	},
	max_board_count = 9,
	fly_up_time = 0.5,
	full_time = 0.5,
	collect_key = 100,
}

----------- slot
slot_config.classic_config = {
	pay_list = {
	    [1] = 7,
	    [2] = 6,
	    [3] = 3,
	    [4] = 5,
	    [5] = 4,
	    [6] = 2,
	    [7] = 1,
	},
	random_reel = {28, 26, 27, 25, 23, 24, 21, 22}, -- , 20
	jp_s_list = {21, 22, 23},
	anim_list = {
	    [1] = { 0, 60 },
	    [2] = { 75, 135 },
	    [3] = { 150, 210 },
	    [4] = { 225, 285 },
	    [5] = { 285 },
	},
	slot_move_time = 1,
	slot_move_dis = 1020,
	start_idx = 9,
	count_pos = {
		base_pos 	= 	{ cc.p(-319.5, 60), 	cc.p(-57.5, 60), 		cc.p(203, 60)},
		end_pos 	= 	{ cc.p(-319.5, 3), 		cc.p(-57.5, 3), 		cc.p(203, 3)},
		move_pos 	= 	{ cc.p(-319.5, -2), 	cc.p(-57.5, -2), 		cc.p(203, -2)},
	},
	win_pos = {
		[1] = {
			{ {1,2}, {2, 2}, {3, 2} },
		},
		[2] = {
			{ {1,1}, {2, 1}, {3, 1} },
			{ {1,2}, {2, 2}, {3, 2} },
			{ {1,3}, {2, 3}, {3, 3} },
		},
		[3] = {
			{ {1,1}, {2, 2}, {3, 3} },
			{ {1,1}, {2, 1}, {3, 1} },
			{ {1,2}, {2, 2}, {3, 2} },
			{ {1,3}, {2, 3}, {3, 3} },
			{ {1,3}, {2, 2}, {3, 1} },
		},
	},
	c_move_delay = 10/30,
	c_move_time = 10/30,
}

return slot_config


