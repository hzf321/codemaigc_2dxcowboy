



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
	["1"] = {"5 - 25000", "4 - 5000", "3 - 1000"},
	["2"] = {"5 - 15000", "4 - 3000", "3 - 500"},
	["3"] = {"5 - 10000", "4 - 2000", "3 - 300"},
	["4"] = {"5 - 7500", "4 - 1500", "3 - 200"},
}
--------------------------------------------
-- 滚轴配置相关
local cell_height = 100
local cell_width = 169

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
	["downBounce"] = cell_height*1/5, -- cell_height*1/6, -- -- 对应 普通停止在symbol + 1 
	["downBounceTime"] = 10 / 60, -- 15 / 60,-- 20/60,
	["autoDownBounceTimeMult"] = 1,
	["checkStopColCnt"] = 5,
	-- end
	["stopDelay"] = 12 / 60, -- 10 / 60, -- 20/60,
	["stopDelayList"] = {
	    [1] = 12 / 60, -- 10 / 60,
	    [2] = 12 / 60, -- 10 / 60,
	    [3] = 12 / 60, -- 10 / 60,
	},
	["autoStopDelayMult"] = 1,
	["speicalSpeed"] = 100/30,
	["extraReelTimeInFreeGame"] = 240/30,
}

--------------------------------------------
-- symbol 相关
slot_config.special_symbol = {
	["scatter"] = 11, 
	["bonus"] = 12, -- ["bonus1"] = 12, ["bonus2"] = 13,
	["wild"] = 1,
}

slot_config.symbol_config = {
	["scatter_key_list"] = {slot_config.special_symbol.scatter},
	["not_init_symbol_set"] = Set(slot_config.special_symbol),
	["notify_symbol_list"] = Set({ -- -- @ 落地动画相关
		slot_config.special_symbol.scatter, -- scatter
	}),
	["loop_symbol_list"] = Set({
		slot_config.special_symbol.scatter, -- scatter
	}),
	["anim_suffix"] = {
		["loop"] = "2", ["notify"] = "", ["win"] = "3", ["antic"] = "4"
	},
}

slot_config.reel_stop_config = {
	["max_stop_level"] = 3,
	["symbol_stop_level"] = {
		[slot_config.special_symbol.scatter] = 1,
		[slot_config.special_symbol.bonus] = 2,
	}
}

slot_config.theme_config = {
	-- base
	["theme_symbol_coinfig"]    = {
		["symbol_zorder_list"]  = {
            [slot_config.special_symbol.scatter] = 3200,
            [slot_config.special_symbol.bonus]	= 3000,
		},
		["normal_symbol_list"]  = {
			1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 
		},
		["special_symbol_list"] = {
			slot_config.special_symbol.scatter, 
		},
		["no_roll_symbol_list"] = { 
			slot_config.special_symbol.bonus-- , slot_config.special_symbol.bonus2, 
		},
		["roll_symbol_inFree_list"] = {
		},
		["special_symbol_config"] = {
			[slot_config.special_symbol.scatter] = {
				["min_cnt"] = 3,
				["check_min_cnt"] = 2,
				["type"]	= G_THEME_SYMBOL_TYPE.NUMBER,
				["col_set"] = {
					[1] 	= 1, 
					[2] 	= 0,  
					[3] 	= 1,
					[4] 	= 0,
					[5] 	= 1,
				},
			},
		},
	},
	["theme_round_light_index"] = 1,
	["theme_type"] = "payLine",
	["theme_type_config"] = {
		["pay_lines"] = { 
			{0, 0, 0, 0, 0}, {1, 1, 1, 1, 1}, {2, 2, 2, 2, 2}, {3, 3, 3, 3, 3}, {4, 4, 4, 4, 4}, 
			{0, 0, 1, 0, 0}, {1, 1, 0, 1, 1}, {1, 1, 2, 1, 1}, {2, 2, 1, 2, 2}, {2, 2, 3, 2, 2}, 
			{3, 3, 2, 3, 3}, {3, 3, 4, 3, 3}, {4, 4, 3, 4, 4}, {0, 1, 1, 1, 0}, {1, 0, 0, 0, 1}, 
			{1, 2, 2, 2, 1}, {2, 1, 1, 1, 2}, {2, 3, 3, 3, 2}, {3, 2, 2, 2, 3}, {3, 4, 4, 4, 3}, 
			{4, 3, 3, 3, 4}, {0, 1, 0, 1, 0}, {1, 0, 1, 0, 1}, {1, 2, 1, 2, 1}, {2, 1, 2, 1, 2}, 
			{2, 3, 2, 3, 2}, {3, 2, 3, 2, 3}, {3, 4, 3, 4, 3}, {4, 3, 4, 3, 4}, {2, 1, 0, 1, 2}, 
			{0, 1, 2, 1, 0}, {3, 2, 1, 2, 3}, {1, 2, 3, 2, 1}, {4, 3, 2, 3, 4}, {2, 3, 4, 3, 2}, 
			{2, 2, 0, 2, 2}, {0, 0, 2, 0, 0}, {1, 1, 3, 1, 1}, {3, 3, 1, 3, 3}, {4, 4, 2, 4, 4}, 
			{2, 2, 4, 2, 2}, {0, 0, 1, 2, 2}, {2, 2, 1, 0, 0}, {1, 1, 2, 3, 3}, {3, 3, 2, 1, 1}, 
			{2, 2, 3, 4, 4}, {4, 4, 3, 2, 2}, {4, 2, 0, 2, 4}, {0, 2, 4, 2, 0}, {3, 1, 0, 1, 3}, 
		},
		["line_cnt"] = 50,
	},
	["boardConfig"] = {
		{ -- 1个棋盘 5*5
			["reel_single"] = true,
			["allow_over_range"] = true,
			["colCnt"] = 5,
			["rowCnt"] = 5,
			["cellWidth"] = cell_width,
			["cellHeight"] = cell_height,
			["reelConfig"] = {
				{["base_pos"] = cc.p(184.5, 101)},
			},
		},
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
	["base_col_cnt"] = 5,
	["base_row_cnt"] = 5,
	["g_cell_width"] = cell_height,
	["g_cell_height"] = cell_width,

	-- extend
	["base_board_cnt"] = 1,

	["dialog_show_or_hide_time"] = 0.5,
	["dimmer_show_or_hide_time"] = 0.2,

}

--------------------------------------------
-- transition
slot_config.transitionConfig = { 
	["free_in"] = {
		["path"] = "spine/bonus/wheel/nvren", 
		["animName"] = "animation4", 
		["audio"] = "transition_free", 
		["coverTime"] = 60/30,
		["endTime"] = 90/30
	},
	["free_out"] = {
		["path"] = "spine/transition/qieping1", 
		["animName"] = "animation", 
		["audio"] = "transition_free", 
		["coverTime"] = 55/30,
		["endTime"] = 70/30
	},
}

slot_config.audioList = {

	-- person 
	welcome_theme 		= "audio/base/game_welcome.mp3", -- 进入主题的欢迎音效
	
	-- base
	scatter_reel_notify = "audio/base/anticipation1.mp3", -- scatter轮轴激励
	anticipation2 		= "audio/base/anticipation2.mp3", -- 中大奖前半屏激励
	big_win 			= "audio/base/big_win.mp3", -- 中大奖背景效果音效
	bonus_disappear 	= "audio/base/bonus_change.mp3", -- 绿色宝石落地变色
	bonus_up 			= "audio/base/bonus_up.mp3", -- 宝石移动到symbol上方锁住
	bonus_down 			= "audio/base/bonus_down.mp3", -- 宝石图标移动到框内
	bonus_explode 		= "audio/base/bonus_explode.mp3", -- 红色宝石爆炸
	bonus_wild 			= "audio/base/bonus_wild.mp3", -- 所有相邻绿框内的symbol变成wild（做单个的）
	d_jp1_show 			= "audio/base/grand_popup.mp3", -- grand jp结算弹窗
	d_jp2_show 			= "audio/base/major_popup.mp3", -- major jp结算弹窗
	d_jp3_show 			= "audio/base/minor_popup.mp3", -- minor_jp结算弹窗
	collect_full 		= "audio/base/meter_congrat.mp3", -- 收集条集满庆祝
	symbol_collect 		= "audio/base/symbol_collect.mp3", -- 蝴蝶角标向收集条飞+收集条接收上涨
	jp_lock 			= "audio/base/jp_lock.mp3",
	jp_unlock 			= "audio/base/jp_unlock.mp3",
	collect_lock 		= "audio/base/lock.mp3", -- 上锁音
	collect_unlock 		= "audio/base/unlock.mp3", -- 解锁音
	game_popup 			= "audio/base/game_popup.mp3", -- 游戏进入伊始弹窗提示
	special_stop1 		= "audio/base/scatter_landing1.mp3", -- 第1个scatter落地音
	special_stop3 		= "audio/base/scatter_landing2.mp3", -- 第2个scatter落地音
	special_stop5 		= "audio/base/scatter_landing3.mp3", -- 第3个scatter落地音
	common_click 		= "audio/base/click.mp3", -- 点击音效，所有按钮
	bell 				= "audio/base/bell.mp3", -- 打铃
	-- ["popup_out"] 				= "audio/base/popup_out.mp3", -- 弹窗收回，所有
	
	-- bonus
	bonus_background 	= "audio/wheel/wheel_bgm.mp3", -- 地图pick和wheel的背景音乐

	-- map
	reveal_upgrade 		= "audio/map/reveal_upgrade.mp3", -- 开出升级图标
	reveal_jp 			= "audio/map/reveal_jp.mp3", -- 开出JP奖励
	decrease_pick 		= "audio/map/decrease_pick.mp3", -- 开出骷髅减少-1pick
	card_reveal 		= "audio/map/card_reveal.mp3", -- 玩家点击卡牌翻开普通coin奖励
	add_pick 			= "audio/map/add_pick.mp3", -- 开出金色精灵添加+1pick
	add_multiple 		= "audio/map/add_multiple.mp3", -- 开出倍乘+倍乘加成到footer+footer滚钱
	book_appear 		= "audio/map/book_appear.mp3", -- 收集图册卷轴打开+卡牌出现
	map_start_show 		= "audio/map/map_start_show.mp3",
	map_end_show 		= "audio/map/map_end_show.mp3",
	-- pick
	pick_appear 		= "audio/pick/pick_appear.mp3", -- PICK界面出现
	reward_reveal 		= "audio/pick/reward_reveal.mp3", -- 玩家点击精灵球开出奖励
	reward_congrat1 	= "audio/pick/reward_congrat1.mp3", --  pick奖励结束停止音 
	reward_congrat2 	= "audio/pick/reward_congrat2.mp3", --  pick奖励结束停止音 
	reward_congrat3 	= "audio/pick/reward_congrat3.mp3", --  pick奖励结束停止音 
	reward_congrat4 	= "audio/pick/reward_congrat4.mp3", --  pick奖励结束停止音 
	reward_congrat5 	= "audio/pick/reward_congrat5.mp3", --  pick奖励结束停止音 
	reward_congrat6 	= "audio/pick/reward_congrat6.mp3", --  pick奖励结束停止音 
	reward_congrat7 	= "audio/pick/reward_congrat7.mp3", --  pick奖励结束停止音 
	reward_congrat8 	= "audio/pick/reward_congrat8.mp3", --  pick奖励结束停止音 
	reward_congrat9 	= "audio/pick/reward_congrat9.mp3", --  pick奖励结束停止音 
	reward_congrat10 	= "audio/pick/reward_congrat10.mp3", --  pick奖励结束停止音 
	-- wheel
	wheel_stop 			= "audio/wheel/wheel_stop.mp3", -- 转盘转停叶片选中
	wheel_stop6 		= "audio/wheel/wheel_stop6.mp3", -- 转盘转停叶片选中
	wheel_stop8 		= "audio/wheel/wheel_stop8.mp3", -- 转盘转停叶片选中
	wheel_stop10 		= "audio/wheel/wheel_stop10.mp3", -- 转盘转停叶片选中
	wheel_stop12 		= "audio/wheel/wheel_stop12.mp3", -- 转盘转停叶片选中
	wheel_spin 			= "audio/wheel/wheel_spin.mp3", -- 转盘点击旋转
	wheel_appear 		= "audio/wheel/wheel_appear.mp3", -- 转盘界面出现

	-- free
	fg_retrigger 		= "audio/free/fg_retrigger.mp3", -- fg retrigger触发弹窗
	retrigger_bell	 	= "audio/base/bell.mp3",
	-- transition_free 	= "audio/free/transition.mp3", -- 转盘界面进FREE切屏

}

slot_config.theme_reels = {
	["main_reel"] = {
		[1] = {8,8,5,2,12,12,12,2,2,2,2,2,2,8,6,6,2,5,5,8,3,9,9,9,12,12,10,11,6,6,2,2,5,5,5,5,5,5,9,9,8,8,3,3,9,11,6,2,12,10,10,10,10,10,3,3,9,5,5,5,9,9,2,6,6,6,11,3,3,8,8,6,2,8,12,12,12,12,12,12,10,10,10,2,6,6,11,8,3,3,6,8,8,10,2,10,10,3,12,12,12,8,9,9,9,9,9,9,4,4,7,7,7,9,3,3,3,3,3,3,4,9,9,4,4,7,8,8,11,8,3,3,9,7,7,7,7,7,7,8,8,3,8,6,6,6,12,12,12,9,9,8,4,9,8,4,6,6,6,6,6,6,3,3,8,7,7,11,9,8,8,6,6,8,8,8,8,8,8,7,8,6,6,7,7,3,3,4,4,4,4,4,4,9,12,12,4,4,7,6,6,8,8,12,12,12,12,9,8,3,3,9,11,10,10,2},
		[2] = {3,9,9,8,5,5,5,5,5,5,12,12,12,2,5,8,8,8,7,7,2,2,2,2,2,2,5,5,3,8,3,9,9,9,5,2,5,2,2,9,2,8,8,8,8,8,8,2,12,3,3,10,10,10,2,8,8,9,7,7,7,7,7,7,6,6,2,2,6,6,4,8,8,7,7,7,4,9,9,12,12,12,9,6,4,7,7,7,8,4,6,8,4,4,4,4,4,4,6,6,9,8,3,3,12,12,9,9,3,6,6,6,7,9,3,9,9,5,5,9,9,7,7,12,12,12,12,12,12,9,7,8,8,4,9,4,8,3,3,9,8,8,9,4,6,6,6,6,6,6,8,3,3,3,3,3,3,9,12,12,12,12,12,6,6,8,8,9,3,2,8,7,7,7,8,9,9,9,9,9,9,7,6,6,12,12,3,3,8,8,5,5,2,6,6,10,5,8,2,2,10,10,10,10,10,10,6,6,8,12,12,12,4,10,10,10},
		[3] = {12,12,5,10,10,10,10,10,10,5,5,8,2,2,2,2,2,2,5,2,7,7,3,9,9,2,8,5,5,5,5,5,5,11,9,9,6,3,3,3,3,3,3,12,12,10,10,3,9,2,2,2,12,3,3,2,8,8,8,5,8,5,5,2,5,11,7,7,3,3,12,12,10,10,10,2,5,5,5,5,11,8,8,6,7,7,11,9,9,9,9,9,9,3,3,6,12,12,12,8,7,7,6,6,6,9,9,11,9,4,8,8,8,8,6,6,6,6,6,6,9,4,4,7,6,6,6,9,6,12,12,12,12,9,4,4,4,4,4,4,7,7,9,8,9,9,6,6,8,12,12,12,12,12,12,4,8,8,8,8,8,8,8,12,12,7,8,3,3,9,4,6,6,8,7,7,7,7,7,7,9,12,12,3,4,7,6,6,3,3,10,5,5,2,2,2,2,2,8,9,11,5,12,12,12,5,5,8,8,8,2,2,7,7,11,9},
		[4] = {7,7,8,9,9,2,6,6,2,2,2,2,2,2,9,9,2,5,8,8,8,5,2,6,6,10,10,10,10,10,10,12,12,5,5,3,6,7,7,8,10,10,10,2,5,5,5,5,5,5,8,2,2,9,12,9,9,9,9,9,9,8,7,7,3,6,5,5,5,7,7,12,12,12,8,8,9,9,3,6,6,6,6,6,6,3,12,12,12,12,12,12,10,10,10,2,5,2,9,6,6,3,8,8,8,8,8,8,6,6,12,12,12,9,6,4,7,7,7,8,4,6,4,4,4,4,4,4,8,3,3,6,6,6,12,12,12,9,7,7,4,7,8,3,3,4,4,4,6,12,12,8,7,7,7,7,7,7,9,9,9,4,4,7,6,6,12,12,12,2,4,4,2,5,5,5,10,7,7,7,12,12,6,6,8,8,2,2,10,10,6,9,6,3,3,3,3,3,3,9,12,12,12,8,8,8,3,3,7,7,12,12,12,3,10,10},
		[5] = {7,7,8,8,2,5,5,10,11,10,5,5,5,5,5,5,9,9,6,3,3,3,6,12,12,12,5,6,6,2,10,10,10,10,10,10,2,5,5,7,11,9,9,12,12,10,10,2,2,2,2,2,2,3,9,5,11,5,12,3,3,6,6,4,4,4,4,5,12,12,12,12,6,6,4,8,8,8,11,9,5,10,3,3,6,3,6,7,7,7,7,7,7,10,10,10,2,6,11,9,9,6,3,3,6,4,4,8,12,12,12,12,4,4,7,7,7,12,12,12,12,12,12,9,4,9,9,9,11,5,5,3,3,8,4,4,12,12,9,7,7,3,5,6,6,6,6,6,6,3,8,4,4,4,4,4,4,3,3,9,6,6,12,12,12,9,7,8,8,8,8,8,8,7,7,7,2,2,2,6,5,8,8,9,12,12,4,4,7,11,6,3,3,3,3,3,3,9,9,7,7,7,12,8,8,12,12,12,9,9,9,9,9,11,9,10},
	},
	["free_reel"] = {
		[1] = {8,8,5,2,12,12,12,2,2,2,2,2,2,8,6,6,2,5,5,8,11,9,9,12,12,12,12,2,6,6,2,2,5,5,5,5,5,5,9,9,8,8,3,3,9,6,6,2,2,10,10,10,10,10,3,3,9,5,5,5,9,9,2,6,6,6,12,3,3,8,8,6,11,8,12,12,12,12,12,12,10,10,10,2,6,6,9,8,3,3,6,8,8,10,2,10,10,3,12,12,12,8,9,9,9,9,9,9,4,4,12,7,7,9,3,3,3,3,3,3,4,9,9,4,4,7,8,8,9,8,3,3,9,7,7,7,7,7,7,8,8,9,11,6,6,6,12,12,12,9,9,8,4,12,12,4,6,6,6,6,6,6,3,3,8,7,7,4,9,12,12,6,6,8,8,8,8,8,8,7,8,6,6,7,7,3,3,4,4,4,4,4,4,9,12,12,4,4,7,6,11,8,8,8,12,12,12,9,8,3,3,9,5,10,10,2},
		[2] = {3,9,9,8,5,5,5,5,5,5,12,12,12,2,5,12,12,12,7,7,2,2,2,2,2,2,5,5,3,8,3,9,9,9,5,2,5,2,2,9,12,8,8,8,8,8,8,2,12,12,3,10,10,10,2,8,8,9,7,7,7,7,7,7,6,6,12,12,6,6,4,8,8,7,7,7,4,9,9,12,12,12,9,6,4,7,7,7,8,4,12,12,4,4,4,4,4,4,6,6,9,8,12,12,12,12,9,9,3,6,6,6,7,9,3,9,9,12,12,12,9,7,7,12,12,12,12,12,12,9,7,8,8,4,9,4,8,3,3,9,12,12,9,4,6,6,6,6,6,6,8,3,3,3,3,3,3,9,12,12,4,4,3,6,6,8,8,9,3,12,12,7,7,7,8,9,9,9,9,9,9,7,6,6,12,3,3,3,8,8,5,5,12,12,12,12,12,8,2,2,10,10,10,10,10,10,6,6,8,8,8,12,4,10,10,10},
		[3] = {12,12,5,10,10,10,10,10,10,12,12,8,2,2,2,2,2,2,5,2,7,7,3,9,9,2,8,5,5,5,5,5,5,11,9,9,6,3,3,3,3,3,3,12,12,12,10,3,9,2,2,2,12,3,3,2,8,8,12,12,12,12,12,2,5,11,7,7,3,3,12,12,10,10,10,2,12,12,5,5,3,8,8,6,12,12,12,9,9,9,9,9,9,3,3,6,12,12,12,8,7,7,6,6,6,9,9,11,9,4,8,12,8,8,6,6,6,6,6,6,9,4,4,7,6,6,6,9,6,12,12,12,12,9,4,4,4,4,4,4,7,7,9,8,12,12,6,6,8,12,12,12,12,12,12,4,8,8,8,8,8,8,8,12,12,7,8,12,12,9,4,6,6,8,7,7,7,7,7,7,9,12,12,3,4,11,6,6,3,3,10,5,5,2,2,2,2,2,8,9,9,5,12,12,12,5,5,8,8,8,12,12,7,7,8,9},
		[4] = {7,7,8,9,9,12,6,6,2,2,2,2,2,2,9,9,2,5,12,12,12,5,2,6,6,10,10,10,10,10,10,12,12,5,5,3,6,7,7,8,10,10,10,2,5,5,5,5,5,5,8,2,2,12,12,12,9,9,9,9,9,8,7,7,3,6,12,12,12,7,7,12,12,12,8,8,9,9,3,6,6,6,6,6,6,3,12,12,12,12,12,12,10,10,10,2,5,2,9,6,6,3,8,8,8,8,12,12,6,6,12,12,12,9,6,4,7,7,7,8,4,6,4,4,4,4,4,4,8,3,3,6,6,6,12,12,12,9,7,7,4,7,8,3,3,4,4,4,6,12,12,8,7,7,7,7,7,7,9,12,12,4,4,7,6,6,12,12,2,2,4,4,2,5,5,5,10,7,7,12,12,12,6,6,8,8,2,2,10,10,6,9,6,3,3,3,3,3,3,9,12,12,12,8,8,8,12,4,7,7,7,12,12,3,10,10},
		[5] = {7,7,8,8,11,5,12,12,2,10,5,5,5,5,5,5,9,9,6,3,3,3,6,12,12,12,5,6,6,2,10,10,10,10,10,10,2,5,5,7,7,9,9,12,12,10,10,2,2,2,2,2,2,3,9,5,12,12,12,3,3,6,6,4,12,12,12,5,12,12,12,12,6,6,4,8,8,8,5,9,5,10,3,3,12,12,6,7,7,7,7,7,7,10,12,12,2,6,6,9,9,6,3,3,6,4,4,8,12,12,12,12,4,4,7,7,7,12,12,12,12,12,12,9,4,12,12,12,8,5,5,3,3,8,4,4,12,12,9,7,7,3,5,6,6,6,6,6,6,9,8,4,4,4,4,4,4,3,3,9,6,6,12,12,12,9,7,8,8,8,8,8,8,7,4,12,12,3,3,12,12,8,8,9,12,12,4,4,7,6,6,3,3,3,3,3,3,9,9,7,7,7,12,12,12,12,12,9,9,9,9,9,9,4,12,12},
	},
}

slot_config.all_img_path = {
	{1, "font/231theme_font_1.png" },
	{1, "font/231theme_font_2.png" },
	{1, "font/231theme_font_3.png" },
	{1, "font/231theme_font_4.png" },
	{1, "image/bg/theme231_bg_base.png" },
	{1, "image/bg/theme231_bg_big.png" },
	{1, "image/bg/theme231_bg_free.png" },
	{1, "image/paytable/paytable_theme231.png" },
	{1, "image/plist/base.png" },
	{1, "image/plist/pick.png" },
	{1, "image/plist/symbol.png" },
	{1, "image/plist/wheel.png" },
	{1, "spine/base/bg_loop/base_bj.png" },
	{1, "spine/base/bg_loop/base_bj2.png" },
	{1, "spine/base/bg_loop/base_bj3.png" },
	{1, "spine/base/bg_loop/base_bjhua01.png" },
	{1, "spine/base/bigwin.png" },
	{1, "spine/base/bigwin_02.png" },
	{1, "spine/base/collect/base_pai.png" },
	{1, "spine/base/collect/jiaobiao1.png" },
	{1, "spine/base/collect/jiaobiao2.png" },
	{1, "spine/base/collect/jiaobiao3.png" },
	{1, "spine/base/collect/sjt.png" },
	{1, "spine/base/collect/sjt_suo.png" },
	{1, "spine/base/collect/sjt_zj.png" },
	{1, "spine/base/logo_cp.png" },
	{1, "spine/base/lzjl.png" },
	{1, "spine/base/reel_loop/kuang.png" },
	{1, "spine/base/shu_jl.png" },
	{1, "spine/bet_feature/baoshi.png" },
	{1, "spine/bet_feature/lx_01.png" },
	{1, "spine/bet_feature/shuzi.png" },
	{1, "spine/bet_feature/wildbaozha.png" },
	{1, "spine/bonus/pick/jieshou.png" },
	{1, "spine/bonus/pick/jieshou2.png" },
	{1, "spine/bonus/pick/juanzhoudakai.png" },
	{1, "spine/bonus/pick/kapai_fan.png" },
	{1, "spine/bonus/pick/kapai_wupin.png" },
	{1, "spine/bonus/pick1/lianghangzi.png" },
	{1, "spine/bonus/pick1/pick.png" },
	{1, "spine/bonus/pick1/wawa01_1.png" },
	{1, "spine/bonus/pick1/wawa02_1.png" },
	{1, "spine/bonus/pick1/wawa03_1.png" },
	{1, "spine/bonus/pick1/wawazk01.png" },
	{1, "spine/bonus/wheel/changjing.png" },
	{1, "spine/bonus/wheel/nvren.png" },
	{1, "spine/bonus/wheel/tengman.png" },
	{1, "spine/bonus/wheel/zhuanpan.png" },
	{1, "spine/bonus/wheel/zhuanpan_loop.png" },
	{1, "spine/dialog/bonus/maptanchuang.png" },
	{1, "spine/dialog/com_btn/naniu_01.png" },
	{1, "spine/dialog/free/freetanchuang.png" },
	{1, "spine/dialog/jp/jptanchuang1.png" },
	{1, "spine/dialog/jp/jptanchuang2.png" },
	{1, "spine/free/fg_cao.png" },
	{1, "spine/free/fg_cao2.png" },
	{1, "spine/free/fg_kshua.png" },
	{1, "spine/free/fg_kuang.png" },
	{1, "spine/free/fg_kuangjs.png" },
	{1, "spine/free/shuzi.png" },
	{1, "spine/free/spin_js.png" },
	{1, "spine/item/1/wild.png" },
	{1, "spine/item/10/l1.png" },
	{1, "spine/item/11/scatter.png" },
	{1, "spine/item/11/scatter_guang.png" },
	{1, "spine/item/2/m1.png" },
	{1, "spine/item/3/m3.png" },
	{1, "spine/item/4/m2.png" },
	{1, "spine/item/5/d2.png" },
	{1, "spine/item/6/d1.png" },
	{1, "spine/item/7/d3.png" },
	{1, "spine/item/8/l2.png" },
	{1, "spine/item/9/l3.png" },
	{1, "spine/jackpot/jp_suo.png" },
	{1, "spine/jackpot/jp_xh.png" },
	{1, "spine/jackpot/jp_zj.png" },
	{1, "spine/kuang/zjlx_01.png" },
	{1, "spine/paytable/dantu/CX_saoguang01.png" },
	{1, "spine/paytable/dantu/elephant_gl01.png" },
	{1, "spine/paytable/spine/back_to_game01.png" },
	{1, "spine/transition/qieping1.png" },
}

slot_config.csb_list = {
    ["base"]          	= "csb/base_game.csb",
    ["pick_num"]        = "csb/pick_num.csb",
    ["map_pick"]    	= "csb/pick.csb",
    ["fg_wheel"]    	= "csb/wheel.csb",

    ["d_pick"]    		= "csb/dialog_pick.csb",
    ["d_jp"]    		= "csb/dialog_jp.csb",
    ["d_free"] 			= "csb/dialog_free.csb",
}

slot_config.dimmer_config = {
	d_free = {
		[1] = "scene",
		[2] = "scene",
		[3] = "scene",
	},
	d_pick = {
		[1] = "scene",
		[3] = "scene",
	},
	d_jp = {
		[3] = "scene",
	},
}

slot_config.dialog_config = {
    ["d_free"]     = {
    	["frame_config"]= {
	        ["start"]    = { nil, (30/30), nil, (27/30) },
	        ["more"]    = { nil, (30/30), nil, (90/30 + 27/30) },
	        ["collect"]    = { nil, (30/30), nil, (27/30) },
	    },
        [1] = {--start
            bg         = {
                name        = "dialog_free",
                startAction = { "animation3", false },
                loopAction  = { "animation3_1", true },
                endAction   = { "animation3_2", false },
            },
            num_sp  = {
                isImg      = true,
                name       = "#theme231_d_num%s.png",
                formatname = true,
            },
            label_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 8 / 30, 0.48 }, { 7 / 30, 1.08 }, { 8 / 30, 1 } },
                stepEndScale = { { 1 }, { 9 / 30, 1 }, { 7 / 30, 1.08 }, { 11 / 30, 0.48 } },

				stepFade	 = { { 0 }, { 8 / 30, 0 }, { 2 / 30, 255 } },
				stepEndFade  = { { 255 }, { 19 / 30, 255 }, { 8 / 30, 0 } },
            },
            btn_start   = {
                isAction     = true,
                stepScale    = { { 0 }, { 15 / 30, 0 }, { 6 / 30, 1.08 }, { 6 / 30, 1 } },
                stepEndScale = { { 1 }, { 0 / 30, 1 }, { 6 / 30, 1.2 }, { 6 / 30, 0 } },
            },
            btn        = {
                name    = "d_btn",
                aniName = "animation",
            },
        },
        [2] = {--more
            bg         = {
                name        = "dialog_free",
                startAction = { "animation2", false },
                loopAction  = { "animation2_1", true },
                endAction   = { "animation2_2", false },
            },
            num_sp  = {
                isImg      = true,
                name       = "#theme231_d_num%s.png",
                formatname = true,
            },
	        label_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 7 / 30, 0.48 }, { 8 / 30, 1.08 }, { 8 / 30, 1 } },
                stepEndScale = { { 1 }, { 9 / 30, 1 }, { 7 / 30, 1.08 }, { 11 / 30, 0.48 } },

				stepFade	 = { { 0 }, { 7 / 30, 0 }, { 3 / 30, 255 } },
				stepEndFade  = { { 255 }, { 19 / 30, 255 }, { 8 / 30, 0 } },
            },
        },
        [3] = { --collect
            bg         = {
                name        = "dialog_free",
                startAction = { "animation1", false },
                loopAction  = { "animation1_1", true },
                endAction   = { "animation1_2", false },
            },
            label_node = {
                isAction     = true,
                stepScale    = { { 0 }, { 7 / 30, 0.48 }, { 8 / 30, 1.08 }, { 8 / 30, 1 } },
                stepEndScale = { { 1 }, { 9 / 30, 1 }, { 7 / 30, 1.08 }, { 11 / 30, 0.48 } },

				stepFade	 = { { 0 }, { 7 / 30, 0 }, { 3 / 30, 255 } },
				stepEndFade  = { { 255 }, { 19 / 30, 255 }, { 8 / 30, 0 } },
            },
            btn_collect   = {
                isAction     = true,
                stepScale    = { { 0 }, { 15 / 30, 0 }, { 6 / 30, 1.08 }, { 6 / 30, 1 } },
                stepEndScale = { { 1 }, { 0 / 30, 1 }, { 6 / 30, 1.2 }, { 6 / 30, 0 } },
                stepEndScale = { { 1 }, { 4 / 30, 0.95 }, { 5 / 30, 1.2 }, { 5 / 30, 0 } },
            },
            btn        = {
                name    = "d_btn",
                aniName = "animation",
            },

            maxWidth   = 910,
        }
    },
    ["d_pick"]     = {
    	["frame_config"]= {
	        ["start"]    = { nil, (38/30), nil, (30/30) },
	        ["collect"]    = { nil, (38/30), nil, (30/30) },
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
                stepScale    = { { 0 }, { 21 / 30, 0 }, { 7 / 30, 1.2 }, { 10 / 30, 1 } },
                stepEndScale = { { 1 }, { 0 / 30, 1 }, { 5 / 30, 1.25 }, { 5 / 30, 0 } },
            },
            btn        = {
                name    = "d_btn",
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
                stepScale    = { { 0 }, { 18 / 30, 0.63 }, { 7 / 30, 1.2 }, { 10 / 30, 1 } },
                stepEndScale = { { 1 }, { 0 / 30, 1 }, { 7 / 30, 1.2 }, { 7 / 30, 0.63 } },

                stepFade	 = { { 0 }, { 18 / 30, 0 }, { 7 / 30, 255 } },
				stepEndFade  = { { 255 }, { 7 / 30, 255 }, { 7 / 30, 0 } },
            },
            btn_collect   = {
                isAction     = true,
                stepScale    = { { 0 }, { 21 / 30, 0 }, { 7 / 30, 1.2 }, { 10 / 30, 1 } },
                stepEndScale = { { 1 }, { 0 / 30, 0.95 }, { 5 / 30, 1.25 }, { 5 / 30, 0 } },
            },
            btn        = {
                name    = "d_btn",
                aniName = "animation",
            },

            maxWidth   = 900,
        }
    },
	["d_jp"] 		= {--jackpot
		["frame_config"]= {
	        ["collect"]    = { nil, (37/30), nil, (35/30) },
	    },
	    [3] = {
	        bg1        = {
	            name        = "jp_collect_bg",
	            startAction = { "animation1", false },
	            loopAction  = { "animation1_1", true },
	            endAction   = { "animation1_2", false },
	        },
	        bg         = {
	            name        = "jp_collect",
	            startAction = { "animation%s", false },
	            loopAction  = { "animation%s_1", true },
	            endAction   = { "animation%s_2", false },
	            formatname  = true,
	        },
	        label_node = {
	            isAction     = true,
	            stepScale    = { { 0 }, { 4 / 30, 0.34 }, { 20 / 30, 1.2 }, { 8 / 30, 1 } },
                stepEndScale = { { 1 }, { 15 / 30, 1 }, { 8 / 30, 1.2 }, { 9 / 30, 0.34 } },
				
				stepFade	 = { { 0 }, { 4 / 30, 0 }, { 10 / 30, 255 } },
				stepEndFade  = { { 255 }, { 23 / 30, 255 }, { 9 / 30, 0 } },
	        },
	        btn_node   = {
	            isAction     = true,
	            stepScale    = { { 0 }, { 15 / 30, 0 }, { 10 / 30, 1.2 }, { 5 / 30, 1 } },
	            stepEndScale = { { 1 }, { 8 / 30, 1.2 }, { 7 / 30, 0 } },
	        },
	        btn        = {
	            name    = "d_btn",
	            aniName = "animation",
	        },
	        maxWidth   = 700,
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
	bg_loop1 		= "base/bg_loop/base_bj",
	bg_loop2 		= "base/bg_loop/base_bj2",
	bg_loop3 		= "base/bg_loop/base_bj3",
	reel_loop 		= "base/bg_loop/base_bjhua01",
	big_win 		= "base/bigwin",
	big_win2 		= "base/bigwin_02",
	reel_notify 	= "base/lzjl",
	special_speed 	= "base/shu_jl",

    item11			= "item/11/spine",
    item11bg		= "item/11/scatter_guang",
    logo_name		= "base/logo_cp",
    
    --bet_feature
	stick_item		= "bet_feature/baoshi",	
	stick_num		= "bet_feature/shuzi",	
	wild_expand     = "bet_feature/lx_01",
	wild_first    	= "bet_feature/wildbaozha",

    -- stick_loop      = "2/frame_sao",
    -- stick_appear    = "2/lankuang",
    -- wild_receive    = "2/wild_js",
    --jackpot
    jp_loop   		= "jackpot/jp_xh",
    jp_win      	= "jackpot/jp_zj",
    jp_lock     	= "jackpot/jp_suo",
    --collect
    tip_icon    	= "base/collect/jiaobiao1",
    collect_icon    = "base/collect/jiaobiao2",
    sub_icon 		= "base/collect/jiaobiao3",
    tip_loop 		= "base/collect/base_pai",
    collect_lock    = "base/collect/sjt_suo",
    collect_full    = "base/collect/sjt_zj",
    b_collect_move 	= "base/collect/sjt",
    
    ---bonus
    --pick_num
    pick_num_bg			= "bonus/pick1/pick",
    pick_num_item1		= "bonus/pick1/wawa01_1",
    pick_num_item2		= "bonus/pick1/wawa02_1",
    pick_num_item3		= "bonus/pick1/wawa03_1",
    pick_num_open		= "bonus/pick1/wawazk01",
    pick_num_lb			= "bonus/pick1/lianghangzi",
    --map_pick
    map_pick_bg			= "bonus/pick/juanzhoudakai",
    map_pick_item		= "bonus/pick/kapai_fan",
    map_pick_value		= "bonus/pick/kapai_wupin",
    map_pick_collect	= "bonus/pick/jieshou",
    map_multi_footer 	= "bonus/pick/jieshou2",
    --wheel
    wheel_logo		= "bonus/wheel/nvren",
    wheel_loop 		= "bonus/wheel/tengman",
    wheel_bg 		= "bonus/wheel/changjing",
    wheel_win 		= "bonus/wheel/zhuanpan",
    wheel_tip 		= "bonus/wheel/zhuanpan_loop",

    --- dialog
    dialog_welcome  = "dialog/bonus/maptanchuang",
    dialog_free     = "dialog/free/freetanchuang",
    dialog_bonus 	= "dialog/bonus/maptanchuang",
    jp_collect_bg 	= "dialog/jp/jptanchuang1",
    jp_collect 		= "dialog/jp/jptanchuang2",

    d_btn 			= "dialog/com_btn/naniu_01",
}

slot_config.particle_path = {
    sub_icon 		= "231_fhd_01_1.plist", -- 1 的层级高
    -- jump_tail 		= "shouji2.plist",
	bg_click		= "danji.plist",
	map_pick_collect= "kuangshilizi.plist",
}

------------------------------------------------------------------------------------------------
slot_config.FeatureName = { -- unlock相关, feature 状态控制
	Bonus = 1,
	Free = 2,
	OpenMap = 3,
}

slot_config.SpinBoardType = { -- board type
	Normal 		= 1,
	FreeSpin 	= 2,
}


slot_config.BGType = {
    BetFeature = 1,
}

slot_config.specialSTriggerAnimTime = 2

------------------------------------ base 通用相关 ----------------------------------------
slot_config.normalColor = cc.c3b(255, 255, 255)
slot_config.lockJackpotColor = cc.c3b(90,90,90)

---------------------------- 	feature 解锁 相关 	----------------------------
slot_config.unlockInfoTypeList = { 1, 2, 3, 4, 5, 6 }

slot_config.unlockInfoConfig = {
	Minor = 1,
	Map = 2,
	Major = 3,
	Grand = 4,
}

slot_config.unlockJpInfoConfig = {
	Minor = 1,
	Major = 3,
	Grand = 4,
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
		link_config = {"grand", "major", "minor"},
		allowK = {[231] = false, [731] = false, [1231] = false}
	},
	-- extend
	["jp_cnt"] = 3,
	["jp_max_width"] = {284, 184, 184},

	["jp_level"] = {
		[0] = slot_config.unlockInfoConfig.Grand,
		[1] = slot_config.unlockInfoConfig.Major,
		[2] = slot_config.unlockInfoConfig.Minor,
	},
	["unlock_sp_name"] = "#theme231_j_name%s.png"
}

------------------------------------ free 通用相关 ----------------------------------------
slot_config.fs_show_type = {
	start = 1,
	more = 2,
	collect = 3,
}

slot_config.FreeGameType = {
    Normal = 1,
}

slot_config.bg_type = {
    win_wild = 1,
}

slot_config.collect_config = {
	max_level = 5,
	max_points = 300,

	bar_move_time = 0.5,
	fly_up_time = 10/30,
	fly_delay = 20/30,
	full_time = 0, -- 0.5
	coin_pos = cc.p(70, -10),
	end_pos = cc.p(420.5, -235.5),
	progress_s_posy = 2,
	progress_s_posx = 25,
	move_per_unit = (395-2)/300,

	lock_anim = {
		lock = "animation1",
		lock_loop = "animation2",
		unlock = "animation3",
		-- unlock_loop = "animation4",
	}
}
----------- free
slot_config.sticky_config = {
	jump_delay = 15/30,
	jump_single = 1,
	change_wild = 29/30,
	to_down_time = 30/30,

    sticky_dir = {
		left_up   	= 1,
		left_down 	= 2,
		right_up  	= 3,
		right_down	= 4,
		up 		= 5,
		down	= 6,
		left	= 7,
		right	= 8,
	},
	last_num = 0,
	up_super = 1,
	up_normal = 0,

	item_state = {
		reset = 0,
		disappear = 1,
		new_spin = 2,
		win_bonus = 3,
	},
	wild_anim = {
		appear = "animation",
		win = "animation2",
	},
           
	bonus_anim = {
		n_to_green = "animation_1",
		gree_to_up = "animation2_1",
		gree_up_loop = "animation2_2",
		green_to_down = "animation4_1",

		n_to_red = "animation",
		red_loop = "animation1",
		red_to_up = "animation2",
		red_up_loop = "animation3",
		red_to_down = "animation4",
		red_will_win = "animation5",
	},
	num_anim = {
		num_loop = "animation%s_1",
		num_to_up = "animation%s_2",
		num_up_loop = "animation%s_3",
	}
}

slot_config.pick_config = {
	footer_roll_delay = 1,
	page_count = 5, 
	item_max = 21,
	dimmer_end = 200,
	item_config = {
		base_pos = cc.p(-374, 109),
		c_width = 136,
		c_height = 149,
		col_count = 7,
		row_count = 3,
		btn_scale = {11.3, 14},
		value_pos = cc.p(0, 61)
	},
	item_show_delay = 0.2,
	item_show_time = 0.2,
	item_state = {
		can_open = 0,
		new_open = 1,
		old_open = 2,
	},
	open_state = {
		coins = Set({1,2,3,4,5,6,7,8,9,10}),
		jp = Set({11,12,13}),
		multi = Set({14}),
		pick_up = Set({15}),
		pick_down = Set({16}),
		next = Set({17}),
	},
	unopen      = {
        isSpine = true,
        name    = "map_pick_item",
        aniName = {"animation1", "animation2", "animation3"}, -- 静帧，循环提示，打开

    },
    opened      = { -- "animation4" 出现，  "animation4_1" 循环，  "animation4_2" 静帧
	    coins = {
			{
			    isSpine = true,
			    name    = "map_pick_value",
			    zOrder  = -1,
			    aniName = "animation9",
			},
			{
			    isFnt	= true,
			    name 	= "231theme_font_3.fnt",
			    scale 	= 0.9,
			},
			music	= "card_reveal"
		},
	    jp = {
	        {
	            isSpine = true,
	            name    = "map_pick_value",
	            zOrder  = -1,
	            aniName = "animation%s",
	        },
	        music	= "reveal_jp"
	    },
	    multi = {
	        {
	            isSpine = true,
	            name    = "map_pick_value",
	            zOrder  = -1,
	            aniName = "animation8",
	        },
	        music	= "add_multiple"
	    },
	    pick_up = {
	        {
	            isSpine = true,
	            name    = "map_pick_value",
	            zOrder  = -1,
	            aniName = "animation11",
	        },
	        music	= "add_pick"
	    },
	    pick_down = {
	        {
	            isSpine = true,
	            name    = "map_pick_value",
	            zOrder  = -1,
	            aniName = "animation10",
	        },
	        music	= "decrease_pick"
	    },
	    next = {
	        {
	            isSpine = true,
	            name    = "map_pick_value",
	            zOrder  = -1,
	            aniName = "animation4",
	        },
	        music	= "reveal_upgrade"
	    },
	}
}

slot_config.wheel_config = {
	item_total = 12,
	jp_max_id = 3, -- 结果1-3 jp, 剩下是 free 次数
	wheel = {
		itemCount       = 12, -- 上下加一个 cell 之后的个数
		delayBeforeSpin = 0.0,   --开始旋转前的时间延迟
		upBounce     	= 0,    --开始滚动前，向上滚动距离
		upBounceTime    = 0,   --开始滚动前，向上滚动时间
		speedUpTime     = 1,   --加速时间
		rotateTime    	= 3,   -- 匀速转动的时间之和
		maxSpeed     	= 60*10,    --每一秒滚动的距离
		speedDownTime   = 2, -- 4
		downBounceTime  = 1.0,
		bounceSpeed     = 10,
		downBounce      = 360/12,  --滚动结束前，向下反弹距离  都为正数值

		direction      	= 1,	
	}

}
-- slot_config.free_config = {
-- 	board_count = {1, 2, 3, 4, 6, 9},
-- 	collect_count = {
-- 		[1] = 0, 
-- 		[2] = 4, 
-- 		[3] = 12, 
-- 		[4] = 22, 
-- 		[6] = 35, 
-- 		[9] = 50,
-- 	},
-- 	max_board_count = 9,
-- 	fly_up_time = 0.5,
-- 	full_time = 0.5,
-- }

return slot_config


