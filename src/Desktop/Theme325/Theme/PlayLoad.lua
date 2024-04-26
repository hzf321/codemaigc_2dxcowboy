local loadData = {}

loadData.img_data = {
    "theme_desktop/theme325/lobby/textures/bg1.png",
    "theme_desktop/theme325/lobby/textures/bg2.png",
    "theme_desktop/theme325/lobby/textures/bg3.png",
}

loadData.enterGame = {
    bonus_level = {10000, 10000, 10000, 10000, 10000, 10000},
    first_fg = 0,
    coins = 6423200,
    experience = "1056896",
    vouchers_mini_bet_idx = 0,
    jp_bet = 20000,
    theme_reels = {
        map_free_yang_reel={
           {2, 2, 2, 10, 9, 8, 8, 12, 12, 1, 8, 4, 4, 3, 12, 12, 3, 6, 6, 7, 12, 8, 2, 1, 7, 6, 5, 12, 5, 12, 3, 5, 2, 2, 7, 12, 9, 6, 4, 1, 1, 3, 3, 5, 5, 9, 9},
           {2, 2, 2, 10, 6, 6, 7, 12, 12, 1, 7, 5, 4, 3, 12, 12, 3, 6, 6, 8, 12, 8, 2, 1, 9, 7, 3, 12, 3, 12, 3, 5, 2, 2, 8, 12, 9, 7, 5, 1, 1, 4, 4, 4, 4, 9, 9},
           {2, 2, 2, 10, 6, 8, 7, 12, 12, 1, 7, 5, 3, 5, 12, 12, 5, 9, 9, 8, 12, 9, 2, 1, 9, 7, 4, 12, 4, 12, 3, 4, 2, 2, 6, 12, 8, 7, 4, 1, 1, 5, 5, 3, 3, 6, 6},
           {2, 2, 2, 10, 6, 8, 9, 11, 11, 1, 9, 3, 5, 4, 13, 13, 4, 8, 8, 7, 13, 9, 2, 1, 9, 8, 5, 13, 5, 13, 3, 4, 2, 2, 7, 11, 6, 7, 3, 1, 1, 5, 5, 4, 4, 6, 6},
           {2, 2, 2, 10, 8, 7, 7, 11, 11, 1, 7, 3, 5, 4, 13, 13, 4, 9, 9, 8, 13, 8, 2, 1, 6, 6, 3, 13, 3, 13, 4, 5, 2, 2, 9, 11, 7, 9, 4, 1, 1, 3, 3, 5, 5, 6, 6},
           {2, 2, 2, 10, 9, 9, 7, 11, 11, 1, 7, 5, 4, 5, 13, 13, 5, 7, 7, 7, 13, 6, 2, 1, 8, 6, 4, 13, 4, 13, 3, 5, 2, 2, 6, 11, 9, 8, 4, 1, 1, 3, 3, 3, 3, 8, 8}
       },
        scatter_reel={
           {2, 2, 2, 15, 10, 9, 8, 8, 12, 12, 1, 8, 4, 15, 4, 3, 14, 14, 3, 6, 6, 7, 14, 8, 2, 1, 7, 6, 5, 15, 5, 14, 3, 5, 2, 2, 7, 12, 9, 6, 4, 1, 1, 15, 3, 3, 5, 5, 9, 9},
           {2, 2, 2, 15, 10, 6, 6, 7, 12, 12, 1, 7, 5, 15, 4, 3, 14, 14, 3, 6, 6, 8, 14, 8, 2, 1, 9, 7, 3, 15, 3, 14, 3, 5, 2, 2, 8, 12, 9, 7, 5, 1, 1, 15, 4, 4, 4, 4, 9, 9},
           {2, 2, 2, 15, 10, 6, 8, 7, 12, 12, 1, 7, 5, 15, 3, 5, 14, 14, 5, 9, 9, 8, 14, 9, 2, 1, 9, 7, 4, 15, 4, 14, 3, 4, 2, 2, 6, 12, 8, 7, 4, 1, 1, 15, 5, 5, 3, 3, 6, 6},
           {2, 2, 2, 15, 10, 6, 8, 9, 11, 11, 1, 9, 3, 15, 5, 4, 13, 13, 4, 8, 8, 7, 13, 9, 2, 1, 9, 8, 5, 15, 5, 13, 3, 4, 2, 2, 7, 11, 6, 7, 3, 1, 1, 15, 5, 5, 4, 4, 6, 6},
           {2, 2, 2, 15, 10, 8, 7, 7, 11, 11, 1, 7, 3, 15, 5, 4, 13, 13, 4, 9, 9, 8, 13, 8, 2, 1, 6, 6, 3, 15, 3, 13, 4, 5, 2, 2, 9, 11, 7, 9, 4, 1, 1, 15, 3, 3, 5, 5, 6, 6},
           {2, 2, 2, 15, 10, 9, 9, 7, 11, 11, 1, 7, 5, 15, 4, 5, 13, 13, 5, 7, 7, 7, 13, 6, 2, 1, 8, 6, 4, 15, 4, 13, 3, 5, 2, 2, 6, 11, 9, 8, 4, 1, 1, 15, 3, 3, 3, 3, 8, 8}
       },
        map_free_yin_yang_reel={
           {2, 2, 2, 10, 9, 8, 8, 12, 12, 1, 8, 4, 4, 3, 12, 12, 3, 6, 6, 7, 12, 8, 2, 1, 7, 6, 5, 12, 5, 12, 3, 5, 2, 2, 7, 12, 9, 6, 4, 1, 1, 3, 3, 5, 5, 9, 9},
           {2, 2, 2, 10, 6, 6, 7, 12, 12, 1, 7, 5, 4, 3, 12, 12, 3, 6, 6, 8, 12, 8, 2, 1, 9, 7, 3, 12, 3, 12, 3, 5, 2, 2, 8, 12, 9, 7, 5, 1, 1, 4, 4, 4, 4, 9, 9},
           {2, 2, 2, 10, 6, 8, 7, 12, 12, 1, 7, 5, 3, 5, 12, 12, 5, 9, 9, 8, 12, 9, 2, 1, 9, 7, 4, 12, 4, 12, 3, 4, 2, 2, 6, 12, 8, 7, 4, 1, 1, 5, 5, 3, 3, 6, 6},
           {2, 2, 2, 10, 6, 8, 9, 11, 11, 1, 9, 3, 5, 4, 11, 11, 4, 8, 8, 7, 11, 9, 2, 1, 9, 8, 5, 11, 5, 11, 3, 4, 2, 2, 7, 11, 6, 7, 3, 1, 1, 5, 5, 4, 4, 6, 6},
           {2, 2, 2, 10, 8, 7, 7, 11, 11, 1, 7, 3, 5, 4, 11, 11, 4, 9, 9, 8, 11, 8, 2, 1, 6, 6, 3, 11, 3, 11, 4, 5, 2, 2, 9, 11, 7, 9, 4, 1, 1, 3, 3, 5, 5, 6, 6},
           {2, 2, 2, 10, 9, 9, 7, 11, 11, 1, 7, 5, 4, 5, 11, 11, 5, 7, 7, 7, 11, 6, 2, 1, 8, 6, 4, 11, 4, 11, 3, 5, 2, 2, 6, 11, 9, 8, 4, 1, 1, 3, 3, 3, 3, 8, 8}
       },
        map_free_reel={
           {2, 2, 2, 10, 9, 8, 8, 12, 12, 1, 8, 4, 4, 3, 14, 14, 3, 6, 6, 7, 14, 8, 2, 1, 7, 6, 5, 14, 5, 14, 3, 5, 2, 2, 7, 12, 9, 6, 4, 1, 1, 3, 3, 5, 5, 9, 9},
           {2, 2, 2, 10, 6, 6, 7, 12, 12, 1, 7, 5, 4, 3, 14, 14, 3, 6, 6, 8, 14, 8, 2, 1, 9, 7, 3, 14, 3, 14, 3, 5, 2, 2, 8, 12, 9, 7, 5, 1, 1, 4, 4, 4, 4, 9, 9},
           {2, 2, 2, 10, 6, 8, 7, 12, 12, 1, 7, 5, 3, 5, 14, 14, 5, 9, 9, 8, 14, 9, 2, 1, 9, 7, 4, 14, 4, 14, 3, 4, 2, 2, 6, 12, 8, 7, 4, 1, 1, 5, 5, 3, 3, 6, 6},
           {2, 2, 2, 10, 6, 8, 9, 11, 11, 1, 9, 3, 5, 4, 13, 13, 4, 8, 8, 7, 13, 9, 2, 1, 9, 8, 5, 13, 5, 13, 3, 4, 2, 2, 7, 11, 6, 7, 3, 1, 1, 5, 5, 4, 4, 6, 6},
           {2, 2, 2, 10, 8, 7, 7, 11, 11, 1, 7, 3, 5, 4, 13, 13, 4, 9, 9, 8, 13, 8, 2, 1, 6, 6, 3, 13, 3, 13, 4, 5, 2, 2, 9, 11, 7, 9, 4, 1, 1, 3, 3, 5, 5, 6, 6},
           {2, 2, 2, 10, 9, 9, 7, 11, 11, 1, 7, 5, 4, 5, 13, 13, 5, 7, 7, 7, 13, 6, 2, 1, 8, 6, 4, 13, 4, 13, 3, 5, 2, 2, 6, 11, 9, 8, 4, 1, 1, 3, 3, 3, 3, 8, 8}
       },
        free_reel={
           {2, 2, 2, 10, 9, 8, 8, 12, 12, 1, 8, 4, 15, 4, 3, 14, 14, 3, 6, 6, 7, 14, 8, 2, 1, 7, 6, 5, 14, 5, 14, 3, 5, 2, 2, 7, 12, 9, 6, 4, 1, 1, 3, 3, 5, 5, 9, 9},
           {2, 2, 2, 10, 6, 6, 7, 12, 12, 1, 7, 5, 15, 4, 3, 14, 14, 3, 6, 6, 8, 14, 8, 2, 1, 9, 7, 3, 14, 3, 14, 3, 5, 2, 2, 8, 12, 9, 7, 5, 1, 1, 4, 4, 4, 4, 9, 9},
           {2, 2, 2, 10, 6, 8, 7, 12, 12, 1, 7, 5, 15, 3, 5, 14, 14, 5, 9, 9, 8, 14, 9, 2, 1, 9, 7, 4, 14, 4, 14, 3, 4, 2, 2, 6, 12, 8, 7, 4, 1, 1, 5, 5, 3, 3, 6, 6},
           {2, 2, 2, 10, 6, 8, 9, 11, 11, 1, 9, 3, 15, 5, 4, 13, 13, 4, 8, 8, 7, 13, 9, 2, 1, 9, 8, 5, 13, 5, 13, 3, 4, 2, 2, 7, 11, 6, 7, 3, 1, 1, 5, 5, 4, 4, 6, 6},
           {2, 2, 2, 10, 8, 7, 7, 11, 11, 1, 7, 3, 15, 5, 4, 13, 13, 4, 9, 9, 8, 13, 8, 2, 1, 6, 6, 3, 13, 3, 13, 4, 5, 2, 2, 9, 11, 7, 9, 4, 1, 1, 3, 3, 5, 5, 6, 6},
           {2, 2, 2, 10, 9, 9, 7, 11, 11, 1, 7, 5, 15, 4, 5, 13, 13, 5, 7, 7, 7, 13, 6, 2, 1, 8, 6, 4, 13, 4, 13, 3, 5, 2, 2, 6, 11, 9, 8, 4, 1, 1, 3, 3, 3, 3, 8, 8}
       },
        main_reel={
           {2, 2, 2, 10, 9, 8, 8, 12, 12, 1, 8, 4, 15, 4, 3, 14, 14, 3, 6, 6, 7, 14, 8, 2, 1, 7, 6, 5, 14, 5, 14, 3, 5, 2, 2, 7, 12, 9, 6, 4, 1, 1, 3, 3, 5, 5, 9, 9},
           {2, 2, 2, 10, 6, 6, 7, 12, 12, 1, 7, 5, 15, 4, 3, 14, 14, 3, 6, 6, 8, 14, 8, 2, 1, 9, 7, 3, 14, 3, 14, 3, 5, 2, 2, 8, 12, 9, 7, 5, 1, 1, 4, 4, 4, 4, 9, 9},
           {2, 2, 2, 10, 6, 8, 7, 12, 12, 1, 7, 5, 15, 3, 5, 14, 14, 5, 9, 9, 8, 14, 9, 2, 1, 9, 7, 4, 14, 4, 14, 3, 4, 2, 2, 6, 12, 8, 7, 4, 1, 1, 5, 5, 3, 3, 6, 6},
           {2, 2, 2, 10, 6, 8, 9, 11, 11, 1, 9, 3, 15, 5, 4, 13, 13, 4, 8, 8, 7, 13, 9, 2, 1, 9, 8, 5, 13, 5, 13, 3, 4, 2, 2, 7, 11, 6, 7, 3, 1, 1, 5, 5, 4, 4, 6, 6},
           {2, 2, 2, 10, 8, 7, 7, 11, 11, 1, 7, 3, 15, 5, 4, 13, 13, 4, 9, 9, 8, 13, 8, 2, 1, 6, 6, 3, 13, 3, 13, 4, 5, 2, 2, 9, 11, 7, 9, 4, 1, 1, 3, 3, 5, 5, 6, 6},
           {2, 2, 2, 10, 9, 9, 7, 11, 11, 1, 7, 5, 15, 4, 5, 13, 13, 5, 7, 7, 7, 13, 6, 2, 1, 8, 6, 4, 13, 4, 13, 3, 5, 2, 2, 6, 11, 9, 8, 4, 1, 1, 3, 3, 3, 3, 8, 8}
       },
        map_free_yin_reel={
           {2, 2, 2, 10, 9, 8, 8, 12, 12, 1, 8, 4, 4, 3, 14, 14, 3, 6, 6, 7, 14, 8, 2, 1, 7, 6, 5, 14, 5, 14, 3, 5, 2, 2, 7, 12, 9, 6, 4, 1, 1, 3, 3, 5, 5, 9, 9},
           {2, 2, 2, 10, 6, 6, 7, 12, 12, 1, 7, 5, 4, 3, 14, 14, 3, 6, 6, 8, 14, 8, 2, 1, 9, 7, 3, 14, 3, 14, 3, 5, 2, 2, 8, 12, 9, 7, 5, 1, 1, 4, 4, 4, 4, 9, 9},
           {2, 2, 2, 10, 6, 8, 7, 12, 12, 1, 7, 5, 3, 5, 14, 14, 5, 9, 9, 8, 14, 9, 2, 1, 9, 7, 4, 14, 4, 14, 3, 4, 2, 2, 6, 12, 8, 7, 4, 1, 1, 5, 5, 3, 3, 6, 6},
           {2, 2, 2, 10, 6, 8, 9, 11, 11, 1, 9, 3, 5, 4, 11, 11, 4, 8, 8, 7, 11, 9, 2, 1, 9, 8, 5, 11, 5, 11, 3, 4, 2, 2, 7, 11, 6, 7, 3, 1, 1, 5, 5, 4, 4, 6, 6},
           {2, 2, 2, 10, 8, 7, 7, 11, 11, 1, 7, 3, 5, 4, 11, 11, 4, 9, 9, 8, 11, 8, 2, 1, 6, 6, 3, 11, 3, 11, 4, 5, 2, 2, 9, 11, 7, 9, 4, 1, 1, 3, 3, 5, 5, 6, 6},
           {2, 2, 2, 10, 9, 9, 7, 11, 11, 1, 7, 5, 4, 5, 11, 11, 5, 7, 7, 7, 11, 6, 2, 1, 8, 6, 4, 11, 4, 11, 3, 5, 2, 2, 6, 11, 9, 8, 4, 1, 1, 3, 3, 3, 3, 8, 8}
       }
   },
    jp_data = {
        ["325"] = {
            rapid10 = {
                {20, 267535},
                {10700000000, 5337}
            },
            rapid8_yin = {
                {20, 111373},
                {10700000000, 641908}
            },
            rapid5_yin = {
                {20, 18236},
                {10700000000, 3558}
            },
            rapid7_yang = {
                {20, 40430},
                {10700000000, 3202}
            },
            rapid9_yin = {
                {20, 556866},
                {10700000000, 3209541}
            },
            rapid5_yang = {
                {20, 18236},
                {10700000000, 3558}
            },
            rapid6_yang = {
                {20, 16172},
                {10700000000, 1280}
            },
            rapid6_yin = {
                {20, 16172},
                {10700000000, 1280}
            },
            rapid8_yang = {
                {20, 111373},
                {10700000000, 641908}
            },
            rapid7_yin = {
                {20, 40430},
                {10700000000, 3202}
            },
            rapid9_yang = {
                {20, 556866},
                {10700000000, 3209541}
            }
        }
    },
    theme_id = 325,
    map_info = {
        avg_bet = 30000,
        yang_wild = 0,
        wager = 1570000,
        wager_count = 45,
        map_level = 0,
        remove_low_symbol = 0,
        expanding_wild = 0,
        extra_sticky = 0,
        extra_fg = 0,
        pre_free_status = {},
        yin_wild = 0,
        extra_wild = 0,
        all_win_multi = 1,
        cur_free_status = {},
        map_level_accu = 0,
        map_points = 73,
        booster_count = 0
    },
    max_lines = 25,
    default_bet = 12000,
    bet_per_line = {1000, 3000, 6000, 9000, 12000, 15000, 18000, 30000, 45000, 50000, 60000}	
}

return loadData