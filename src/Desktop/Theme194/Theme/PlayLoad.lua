local loadData = {}

loadData.img_data = {
    "theme_desktop/theme194/lobby/textures/bg1.png",
    "theme_desktop/theme194/lobby/textures/bg2.png",
    "theme_desktop/theme194/lobby/textures/bg3.png",
}

loadData.enterGame = {
    bonus_level = {10000, 10000, 10000, 10000, 10000, 10000},
    coins = 23204300,
    experience = "1606896",
    vouchers_mini_bet_idx = 0,
    jp_bet = 10000,
    theme_reels = {
        free_reel = {
           {11, 10, 11, 2, 2, 2, 2, 7, 8, 9, 3, 3, 3, 3, 10, 11, 7, 4, 4, 4, 4, 8, 9, 10, 5, 5, 5, 5, 11, 7, 8, 6, 6, 6, 6, 9, 10, 11, 2, 7, 3, 8, 2, 7, 4, 9, 2, 7, 5, 10, 2, 7, 6, 11, 3, 8, 4, 9, 3, 8, 5, 10, 3, 8, 6, 11, 4, 9, 5, 10, 4, 9, 6},
           {7, 8, 7, 2, 2, 2, 2, 11, 10, 9, 3, 3, 3, 3, 8, 7, 11, 4, 4, 4, 4, 10, 9, 8, 5, 5, 5, 5, 7, 11, 10, 6, 6, 6, 6, 9, 8, 7, 2, 11, 3, 10, 2, 11, 4, 9, 2, 11, 5, 8, 2, 11, 6, 7, 3, 10, 4, 9, 3, 10, 5, 8, 3, 10, 6, 7, 4, 9, 5, 8, 4, 9, 6},
           {11, 10, 11, 2, 2, 2, 2, 7, 8, 9, 3, 3, 3, 3, 10, 11, 7, 4, 4, 4, 4, 8, 9, 10, 5, 5, 5, 5, 11, 7, 8, 6, 6, 6, 6, 9, 10, 11, 2, 7, 3, 8, 2, 7, 4, 9, 2, 7, 5, 10, 2, 7, 6, 11, 3, 8, 4, 9, 3, 8, 5, 10, 3, 8, 6, 11, 4, 9, 5, 10, 4, 9, 6},
           {7, 8, 7, 2, 2, 2, 2, 11, 10, 9, 3, 3, 3, 3, 8, 7, 11, 4, 4, 4, 4, 10, 9, 8, 5, 5, 5, 5, 7, 11, 10, 6, 6, 6, 6, 9, 8, 7, 2, 11, 3, 10, 2, 11, 4, 9, 2, 11, 5, 8, 2, 11, 6, 7, 3, 10, 4, 9, 3, 10, 5, 8, 3, 10, 6, 7, 4, 9, 5, 8, 4, 9, 6},
           {11, 10, 11, 2, 2, 2, 2, 7, 8, 9, 3, 3, 3, 3, 10, 11, 7, 4, 4, 4, 4, 8, 9, 10, 5, 5, 5, 5, 11, 7, 8, 6, 6, 6, 6, 9, 10, 11, 2, 7, 3, 8, 2, 7, 4, 9, 2, 7, 5, 10, 2, 7, 6, 11, 3, 8, 4, 9, 3, 8, 5, 10, 3, 8, 6, 11, 4, 9, 5, 10, 4, 9, 6}
       },
        main_reel = {
           {11, 10, 14, 11, 2, 2, 2, 2, 7, 8, 9, 3, 3, 3, 3, 10, 11, 14, 7, 4, 4, 4, 4, 8, 9, 10, 5, 5, 5, 5, 11, 14, 7, 8, 6, 6, 6, 6, 9, 10, 11, 2, 7, 14, 3, 8, 2, 7, 4, 9, 2, 7, 5, 10, 14, 2, 7, 6, 11, 3, 8, 4, 9, 3, 8, 5, 14, 10, 3, 8, 6, 11, 4, 9, 5, 10, 14, 4, 9, 6},
           {7, 8, 7, 14, 2, 2, 2, 2, 11, 10, 9, 3, 3, 3, 3, 8, 7, 11, 14, 4, 4, 4, 4, 10, 9, 8, 5, 5, 5, 5, 7, 11, 14, 10, 6, 6, 6, 6, 9, 8, 7, 2, 11, 3, 14, 10, 2, 11, 4, 9, 2, 11, 5, 8, 14, 2, 11, 6, 7, 3, 10, 4, 9, 3, 10, 14, 5, 8, 3, 10, 6, 7, 4, 9, 5, 8, 14, 4, 9, 6},
           {11, 10, 14, 11, 2, 2, 2, 2, 7, 8, 9, 3, 3, 3, 3, 10, 11, 14, 7, 4, 4, 4, 4, 8, 9, 10, 5, 5, 5, 5, 11, 14, 7, 8, 6, 6, 6, 6, 9, 10, 11, 2, 7, 14, 3, 8, 2, 7, 4, 9, 2, 7, 5, 10, 14, 2, 7, 6, 11, 3, 8, 4, 9, 3, 8, 5, 14, 10, 3, 8, 6, 11, 4, 9, 5, 10, 14, 4, 9, 6},
           {7, 8, 7, 14, 2, 2, 2, 2, 11, 10, 9, 3, 3, 3, 3, 8, 7, 11, 14, 4, 4, 4, 4, 10, 9, 8, 5, 5, 5, 5, 7, 11, 14, 10, 6, 6, 6, 6, 9, 8, 7, 2, 11, 3, 14, 10, 2, 11, 4, 9, 2, 11, 5, 8, 14, 2, 11, 6, 7, 3, 10, 4, 9, 3, 10, 14, 5, 8, 3, 10, 6, 7, 4, 9, 5, 8, 14, 4, 9, 6},
           {11, 10, 14, 11, 2, 2, 2, 2, 7, 8, 9, 3, 3, 3, 3, 10, 11, 14, 7, 4, 4, 4, 4, 8, 9, 10, 5, 5, 5, 5, 11, 14, 7, 8, 6, 6, 6, 6, 9, 10, 11, 2, 7, 14, 3, 8, 2, 7, 4, 9, 2, 7, 5, 10, 14, 2, 7, 6, 11, 3, 8, 4, 9, 3, 8, 5, 14, 10, 3, 8, 6, 11, 4, 9, 5, 10, 14, 4, 9, 6}
       }
   },
    jp_data = {
        ["194"] = {
            mega = {
                {20, 214236},
                {10700000000, 676067}
            },
            mini = {
                {20, 14084},
                {10700000000, 35582}
            },
            major = {
                {20, 60601},
                {10700000000, 306899}
            },
            grand = {
                {20, 803386},
                {10700000000, 5537527}
            },
            minor = {
                {20, 5070},
                {10700000000, 147311}
            }
        }
    },
    theme_id = 194,
    map_info = {
        wager_count = 1,
        extra_fg = 0,
        map_level = 0,
        map_points = 0,
        avg_bet = 0,
        map_level_accu = 0,
        wager = 10000
    },
    max_lines = 40,
    default_bet = 1000,
    bet_per_line = {1000, 3000, 6000, 9000, 12000, 15000, 18000, 30000, 45000, 50000, 60000}	
}


return loadData