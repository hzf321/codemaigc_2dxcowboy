local loadData = {}

loadData.img_data = {
    "theme_desktop/theme174/lobby/textures/bg1.png",
    "theme_desktop/theme174/lobby/textures/bg2.png",
    "theme_desktop/theme174/lobby/textures/bg3.png",
}

loadData.enterGame = {
    theme_reels = {
        free_reel = {
           {7, 8, 2, 2, 2, 9, 13, 10, 3, 3, 3, 11, 12, 4, 4, 4, 7, 13, 8, 1, 9, 2, 10, 3, 11, 2, 12, 4, 7, 2, 8, 5, 9, 2, 10, 13, 13, 13, 6, 11, 3, 12, 4, 7, 3, 8, 5, 9, 3, 10, 6, 13, 11, 4, 12, 5, 7, 4, 8, 6, 9, 5, 10, 6, 13, 13, 11, 1, 12, 2, 2, 7, 8, 3, 3, 9, 10, 4, 4, 11, 13, 12, 5, 5, 7, 8, 6, 6, 9, 10, 1, 1},
           {9, 10, 2, 2, 2, 11, 13, 12, 3, 3, 3, 7, 8, 4, 4, 4, 9, 13, 10, 1, 11, 2, 12, 3, 7, 2, 8, 4, 9, 2, 10, 5, 11, 2, 12, 13, 13, 13, 6, 7, 3, 8, 4, 9, 3, 10, 5, 11, 3, 12, 6, 13, 7, 4, 8, 5, 9, 4, 10, 6, 11, 5, 12, 6, 13, 13, 7, 1, 8, 2, 2, 9, 10, 3, 3, 11, 12, 4, 4, 7, 13, 8, 5, 5, 9, 10, 6, 6, 11, 12, 1, 1},
           {11, 12, 2, 2, 2, 7, 13, 8, 3, 3, 3, 9, 10, 4, 4, 4, 11, 13, 12, 1, 7, 2, 8, 3, 9, 2, 10, 4, 11, 2, 12, 5, 7, 2, 8, 13, 13, 13, 6, 9, 3, 10, 4, 11, 3, 12, 5, 7, 3, 8, 6, 13, 9, 4, 10, 5, 11, 4, 12, 6, 7, 5, 8, 6, 13, 13, 9, 1, 10, 2, 2, 11, 12, 3, 3, 7, 8, 4, 4, 9, 13, 10, 5, 5, 11, 12, 6, 6, 7, 8, 1, 1},
           {7, 8, 2, 2, 2, 9, 13, 10, 3, 3, 3, 11, 12, 4, 4, 4, 7, 13, 8, 1, 9, 2, 10, 3, 11, 2, 12, 4, 7, 2, 8, 5, 9, 2, 10, 13, 13, 13, 6, 11, 3, 12, 4, 7, 3, 8, 5, 9, 3, 10, 6, 13, 11, 4, 12, 5, 7, 4, 8, 6, 9, 5, 10, 6, 13, 13, 11, 1, 12, 2, 2, 7, 8, 3, 3, 9, 10, 4, 4, 11, 13, 12, 5, 5, 7, 8, 6, 6, 9, 10, 1, 1},
           {9, 10, 2, 2, 2, 11, 13, 12, 3, 3, 3, 7, 8, 4, 4, 4, 9, 13, 10, 1, 11, 2, 12, 3, 7, 2, 8, 4, 9, 2, 10, 5, 11, 2, 12, 13, 13, 13, 6, 7, 3, 8, 4, 9, 3, 10, 5, 11, 3, 12, 6, 13, 7, 4, 8, 5, 9, 4, 10, 6, 11, 5, 12, 6, 13, 13, 7, 1, 8, 2, 2, 9, 10, 3, 3, 11, 12, 4, 4, 7, 13, 8, 5, 5, 9, 10, 6, 6, 11, 12, 1, 1}
       },
        main_reel = {
           {7, 8, 2, 2, 2, 9, 13, 10, 3, 3, 3, 11, 12, 4, 4, 4, 7, 13, 8, 1, 9, 2, 10, 3, 11, 2, 12, 4, 7, 2, 8, 5, 9, 2, 10, 13, 13, 13, 6, 11, 3, 12, 4, 7, 3, 8, 5, 9, 3, 10, 6, 13, 11, 4, 12, 5, 7, 4, 8, 6, 9, 5, 10, 6, 13, 13, 11, 1, 12, 2, 2, 7, 8, 3, 3, 9, 10, 4, 4, 11, 13, 12, 5, 5, 7, 8, 6, 6, 9, 10, 1, 1},
           {9, 10, 2, 2, 2, 11, 13, 12, 3, 3, 3, 7, 8, 4, 4, 4, 9, 13, 10, 1, 11, 2, 12, 3, 7, 2, 8, 4, 9, 2, 10, 5, 11, 2, 12, 13, 13, 13, 6, 7, 3, 8, 4, 9, 3, 10, 5, 11, 3, 12, 6, 13, 7, 4, 8, 5, 9, 4, 10, 6, 11, 5, 12, 6, 13, 13, 7, 1, 8, 2, 2, 9, 10, 3, 3, 11, 12, 4, 4, 7, 13, 8, 5, 5, 9, 10, 6, 6, 11, 12, 1, 1},
           {11, 12, 2, 2, 2, 7, 13, 8, 3, 3, 3, 9, 10, 4, 4, 4, 11, 13, 12, 1, 7, 2, 8, 3, 9, 2, 10, 4, 11, 2, 12, 5, 7, 2, 8, 13, 13, 13, 6, 9, 3, 10, 4, 11, 3, 12, 5, 7, 3, 8, 6, 13, 9, 4, 10, 5, 11, 4, 12, 6, 7, 5, 8, 6, 13, 13, 9, 1, 10, 2, 2, 11, 12, 3, 3, 7, 8, 4, 4, 9, 13, 10, 5, 5, 11, 12, 6, 6, 7, 8, 1, 1},
           {7, 8, 2, 2, 2, 9, 13, 10, 3, 3, 3, 11, 12, 4, 4, 4, 7, 13, 8, 1, 9, 2, 10, 3, 11, 2, 12, 4, 7, 2, 8, 5, 9, 2, 10, 13, 13, 13, 6, 11, 3, 12, 4, 7, 3, 8, 5, 9, 3, 10, 6, 13, 11, 4, 12, 5, 7, 4, 8, 6, 9, 5, 10, 6, 13, 13, 11, 1, 12, 2, 2, 7, 8, 3, 3, 9, 10, 4, 4, 11, 13, 12, 5, 5, 7, 8, 6, 6, 9, 10, 1, 1},
           {9, 10, 2, 2, 2, 11, 13, 12, 3, 3, 3, 7, 8, 4, 4, 4, 9, 13, 10, 1, 11, 2, 12, 3, 7, 2, 8, 4, 9, 2, 10, 5, 11, 2, 12, 13, 13, 13, 6, 7, 3, 8, 4, 9, 3, 10, 5, 11, 3, 12, 6, 13, 7, 4, 8, 5, 9, 4, 10, 6, 11, 5, 12, 6, 13, 13, 7, 1, 8, 2, 2, 9, 10, 3, 3, 11, 12, 4, 4, 7, 13, 8, 5, 5, 9, 10, 6, 6, 11, 12, 1, 1},
           {15, 19, 18, 19, 16, 19, 17, 19, 18, 19}
       }
   },
   bonus_level = 60000,
   coins = 39092584,
   experience = "1851896",
   vouchers_mini_bet_idx = 0,
   jp_data = {
       ["174"] = {
           grand = {
               {20, 728329},
               {10700000000, 4937072}
           },
           mini = {
               {20, 14084},
               {10700000000, 35582}
           },
           minor = {
               {20, 21883},
               {10700000000, 89667}
           },
           major = {
               {20, 94145},
               {10700000000, 2117159}
           }
       }
   },
   theme_id = 174,
   map_info = {
       wager_count = 0,
       map_level_accu = 0,
       map_level = 0,
       map_points = 0,
       wager = 0
   },
   max_lines = 50,
   default_bet = 1000,
   bet_per_line = {1000, 3000, 6000, 9000, 12000, 15000, 18000, 30000, 45000, 50000, 60000}	
}

return loadData