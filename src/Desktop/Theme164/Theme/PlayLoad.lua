local loadData = {}

loadData.img_data = {
    "theme_desktop/theme164/lobby/textures/bg1.png",
    "theme_desktop/theme164/lobby/textures/bg2.png",
    "theme_desktop/theme164/lobby/textures/bg3.png",
}

loadData.enterGame = {
        bonus_level = 60000,
        coins = 10075400,
        experience = "1161896",
        theme_reels = {
            free_reel ={
               {6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 21, 22, 23, 24},
               {9, 10, 6, 2, 2, 2, 2, 6, 7, 8, 3, 3, 3, 3, 10, 6, 7, 4, 4, 4, 4, 7, 8, 9, 5, 5, 5, 5, 10, 9, 8, 6, 6, 6, 6, 3, 8, 4, 7, 7, 7, 7, 2, 9, 5, 8, 8, 8, 8, 3, 10, 4, 9, 9, 9, 9, 2, 6, 5, 10, 10, 10, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 7, 8, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 6, 9, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 21, 22, 23, 24},
               {6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 21, 22, 23, 24},
               {9, 10, 6, 2, 2, 2, 2, 6, 7, 8, 3, 3, 3, 3, 10, 6, 7, 4, 4, 4, 4, 7, 8, 9, 5, 5, 5, 5, 10, 9, 8, 6, 6, 6, 6, 3, 8, 4, 7, 7, 7, 7, 2, 9, 5, 8, 8, 8, 8, 3, 10, 4, 9, 9, 9, 9, 2, 6, 5, 10, 10, 10, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 7, 8, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 6, 9, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 21, 22, 23, 24},
               {6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 21, 22, 23, 24}
           },
            bonus_reel ={
               {11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0},
               {11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0},
               {11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
               {11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
               {11, 11, 11, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 12, 12, 12, 12, 12, 0, 0, 0, 0, 0, 0, 0, 0}
           },
            main_reel ={
               {6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 12, 12, 12, 12, 12, 12, 12, 12, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 12, 12, 12, 12, 12, 12, 12, 12, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 24, 23, 22, 21},
               {9, 10, 6, 2, 2, 2, 2, 6, 7, 8, 3, 3, 3, 3, 10, 6, 7, 4, 4, 4, 4, 7, 8, 9, 5, 5, 5, 5, 10, 9, 8, 6, 6, 6, 6, 3, 8, 4, 7, 7, 7, 7, 2, 9, 5, 8, 8, 8, 8, 3, 10, 4, 9, 9, 9, 9, 2, 6, 5, 10, 10, 10, 10, 3, 7, 8, 4, 12, 12, 12, 12, 12, 12, 12, 12, 9, 10, 2, 7, 8, 5, 9, 10, 6, 7, 8, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 6, 12, 12, 12, 12, 12, 12, 12, 12, 9, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 24, 23, 22, 21},
               {6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 12, 12, 12, 12, 12, 12, 12, 12, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 12, 12, 12, 12, 12, 12, 12, 12, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 24, 23, 22, 21},
               {9, 10, 6, 2, 2, 2, 2, 6, 7, 8, 3, 3, 3, 3, 10, 6, 7, 4, 4, 4, 4, 7, 8, 9, 5, 5, 5, 5, 10, 9, 8, 6, 6, 6, 6, 3, 8, 4, 7, 7, 7, 7, 2, 9, 5, 8, 8, 8, 8, 3, 10, 4, 9, 9, 9, 9, 2, 6, 5, 10, 10, 10, 10, 3, 7, 8, 4, 12, 12, 12, 12, 12, 12, 12, 12, 9, 10, 2, 7, 8, 5, 9, 10, 6, 7, 8, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 6, 12, 12, 12, 12, 12, 12, 12, 12, 9, 10, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 3, 7, 8, 4, 9, 10, 2, 7, 8, 5, 9, 10, 6, 24, 23, 22, 21},
               {6, 7, 8, 2, 2, 2, 2, 9, 10, 6, 3, 3, 3, 3, 7, 8, 9, 4, 4, 4, 4, 10, 6, 7, 5, 5, 5, 5, 8, 9, 10, 6, 6, 6, 6, 2, 8, 5, 7, 7, 7, 7, 3, 9, 4, 8, 8, 8, 8, 2, 10, 5, 9, 9, 9, 9, 3, 6, 4, 10, 10, 10, 10, 2, 7, 8, 5, 12, 12, 12, 12, 12, 12, 12, 12, 9, 10, 3, 7, 8, 4, 9, 10, 6, 7, 8, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 6, 12, 12, 12, 12, 12, 12, 12, 12, 9, 10, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 2, 7, 8, 5, 9, 10, 3, 7, 8, 4, 9, 10, 6, 24, 23, 22, 21}
           }
       } ,
        vouchers_mini_bet_idx = 0,
        jp_bet = 10000,
        jp_data = {
            ["164"] = {
                mini = {
                    {20, 8895},
                    {10700000000, 53373}
                },
                major = {
                    {20, 252274},
                    {10700000000, 350265}
                },
                grand = {
                    {20, 1009097},
                    {10700000000, 1401061}
                },
                minor = {
                    {20, 800},
                    {10700000000, 134501}
                },
                maxi = {
                    {20, 336365},
                    {10700000000, 2468536}
                }
            }
        },
        theme_id = 164,
        map_info = {
            sticky_wild_pos = {},
            extra_fg = 0,
            avg_bet = 0,
            wager = 0,
            booster_count = 0,
            wager_count = 0,
            sticky_wild = 0,
            map_level_accu = 0,
            extra_wild = 0,
            reel_count = 0,
            map_level = 0,
            map_points = 0,
            row_count = 0
        },
        max_lines = 50,
        default_bet = 1000,
        bet_per_line = {1000, 3000, 6000, 9000, 12000, 15000, 18000, 30000, 45000, 50000, 60000}	
}

return loadData