local loadData = {}

loadData.img_data = {
    "theme_desktop/theme244/lobby/textures/bg1.png",
    "theme_desktop/theme244/lobby/textures/bg2.png",
    "theme_desktop/theme244/lobby/textures/bg3.png",
}

loadData.enterGame = {
    theme_reels={
        main_reel={
           {2, 2, 228, 1, 1, 10, 3, 3, 131, 8, 8, 1, 1, 128, 123, 123, 4, 4, 4, 9, 4, 228, 2, 2, 2, 7, 11, 5, 5, 128, 124, 3, 3, 5, 5, 228, 4, 4, 4, 14, 2, 2, 9, 7, 10, 123, 2, 133, 3, 3, 3, 1, 1, 1, 9, 4, 4, 4, 123, 1, 121},
           {2, 2, 223, 1, 1, 10, 3, 3, 133, 8, 8, 1, 1, 123, 124, 124, 4, 4, 4, 9, 4, 223, 2, 2, 2, 7, 11, 5, 5, 123, 121, 3, 3, 1, 1, 228, 4, 4, 4, 14, 2, 2, 9, 7, 10, 128, 2, 132, 3, 3, 3, 1, 1, 1, 9, 4, 4, 4, 128, 1, 123},
           {2, 2, 227, 1, 1, 10, 3, 3, 132, 8, 8, 1, 1, 127, 121, 121, 4, 4, 4, 9, 4, 226, 2, 2, 2, 7, 11, 5, 5, 126, 125, 3, 3, 1, 1, 228, 4, 4, 4, 14, 2, 2, 9, 7, 10, 123, 1, 134, 3, 3, 3, 1, 1, 1, 9, 4, 4, 4, 123, 1, 124},
           {2, 2, 224, 1, 1, 10, 3, 3, 130, 8, 8, 1, 1, 124, 123, 123, 4, 4, 4, 9, 4, 224, 2, 2, 2, 7, 11, 5, 5, 124, 121, 3, 3, 1, 1, 228, 4, 4, 4, 14, 2, 2, 9, 7, 10, 127, 7, 130, 3, 3, 3, 1, 1, 1, 9, 4, 4, 4, 127, 1, 121},
           {2, 2, 228, 1, 1, 10, 3, 3, 134, 8, 8, 1, 1, 128, 124, 124, 4, 4, 4, 9, 4, 222, 2, 2, 2, 7, 11, 5, 5, 122, 123, 3, 3, 5, 5, 223, 4, 4, 4, 14, 2, 2, 9, 7, 10, 124, 5, 131, 3, 3, 3, 1, 1, 1, 9, 4, 4, 4, 124, 1, 123}
       },
        respin_reel1={
           {2, 2, 228, 5, 5, 3, 3, 3, 234, 3, 3, 5, 5, 229, 5, 227, 4, 4, 4, 230, 2, 2, 2, 5, 5, 3, 3, 5, 5, 227, 4, 4, 4, 2, 2, 4, 5, 231, 3, 3, 3, 6, 6, 6, 4, 4, 4, 4, 224, 2}
       },
        respin_reel={
           {2, 2, 128, 5, 5, 3, 3, 3, 134, 3, 3, 5, 5, 129, 5, 127, 4, 4, 4, 130, 2, 2, 2, 5, 5, 3, 3, 5, 5, 127, 4, 4, 4, 2, 2, 4, 5, 131, 3, 3, 3, 6, 6, 6, 4, 4, 4, 4, 124, 2}
       }
   },
   bonus_level = {10000, 10000, 10000, 10000, 10000, 10000},
   coins = 23140300,
   experience = "1596896",
   vouchers_mini_bet_idx = 0,
   theme_info = {
       map_info = {
           map_level = 0,
           avg_bet = 0
       }
   },
   theme_id = 244,
   jp_data = {
       ["244"] = {
           mini = {
               {20, 3380},
               {10700000000, 44833}
           },
           major = {
               {20, 7539},
               {10700000000, 594049}
           },
           grand = {
               {20, 86821},
               {10700000000, 4252821}
           },
           minor = {
               {20, 4523},
               {10700000000, 116248}
           },
           maxi = {
               {20, 43410},
               {10700000000, 2126410}
           }
       }
   },
   default_bet = 1000,
   map_info = {
       wager_count = 0,
       map_level = 0,
       avg_bet = 0,
       wager = 0
   },
   max_lines = 50,
   badge_info = {0, 0, 0, 0, 0, 0},
   bet_per_line = {1000, 3000, 6000, 9000, 12000, 15000, 18000, 30000, 45000, 50000, 60000}	
}

return loadData