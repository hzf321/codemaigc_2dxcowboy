local loadData = {}

loadData.img_data = {
    "theme_desktop/theme186/login/spines/tansition/spine.png",   
    "theme_desktop/theme186/lobby/spines/rukouBg/spine.png",   
    "theme_desktop/theme186/lobby/spines/rukouKing/spine.png",   
}

loadData.enterGame = {
        bonus_level= 15000,
        bonus_info= {
            wager_count= 15,
            wild_count= 22,
            wager= 170000
        },
        coins= 756200,
        theme_reels= {
            wild_reel= {
                {1, 1, 1, 1, 1, 5, 5, 9, 9, 2, 2, 2, 2, 7, 7, 7, 6, 6, 1, 1, 1, 1, 1, 1, 1, 6, 8, 8, 9, 9, 2, 2, 1, 1, 1, 1, 1, 1, 7, 9, 9, 1, 1, 9, 9, 9, 9},
                {2, 2, 2, 2, 6, 1, 1, 1, 1, 1, 1, 2, 2, 2, 4, 4, 4, 1, 1, 1, 9, 9, 9, 1, 5, 5, 5, 5, 8, 8, 8, 1, 1, 1, 1, 1, 5, 5, 9, 9, 4, 1, 4, 7, 7},
                {3, 3, 2, 3, 3, 7, 7, 7, 7, 2, 1, 2, 1, 1, 1, 1, 1, 1, 5, 5, 1, 1, 8, 8, 8, 9, 9, 9, 6, 6, 6, 1, 1, 9, 1, 7, 7, 1, 1, 1, 1, 1, 1, 1, 8, 8, 8},
                {5, 5, 5, 5, 7, 7, 7, 9, 9, 1, 1, 1, 1, 2, 4, 4, 4, 6, 1, 1, 1, 1, 1, 4, 2, 2, 2, 2, 6, 6, 8, 8, 9, 2, 2, 1, 1, 1, 1, 1, 3, 5, 5, 5, 5},
                {3, 1, 1, 1, 1, 1, 9, 1, 2, 2, 7, 7, 2, 5, 1, 1, 4, 4, 3, 1, 1, 1, 1, 5, 5, 1, 7, 7, 7, 9, 8, 8, 8, 9, 9, 6, 6, 7, 7, 9, 2, 2, 2, 6, 6}
            },
            free_reel= {
                {6, 9, 11, 7, 3, 2, 7, 1, 7, 11, 5, 3, 11, 11, 9, 1, 6, 7, 4, 10, 8, 10, 2, 6, 10, 1, 9, 8, 6, 5, 8, 9, 8, 4, 10, 1},
                {6, 10, 8, 8, 6, 3, 10, 1, 7, 11, 2, 5, 7, 11, 10, 1, 6, 9, 3, 9, 7, 9, 4, 4, 10, 1, 11, 11, 6, 2, 8, 9, 7, 5, 8, 1},
                {5, 11, 8, 11, 6, 6, 7, 1, 8, 11, 2, 4, 8, 10, 10, 1, 6, 9, 4, 9, 7, 11, 3, 3, 8, 1, 9, 10, 5, 2, 10, 7, 7, 6, 9, 1},
                {3, 11, 9, 9, 2, 3, 10, 1, 8, 7, 6, 5, 10, 10, 8, 1, 6, 8, 2, 7, 9, 11, 5, 6, 8, 1, 9, 7, 4, 4, 10, 11, 7, 6, 11, 1},
                {2, 10, 9, 10, 3, 5, 8, 1, 7, 7, 2, 5, 7, 8, 10, 1, 6, 8, 4, 8, 9, 10, 3, 6, 11, 1, 11, 11, 4, 6, 9, 11, 9, 6, 7, 1}
            },
            main_reel= {
                {6, 9, 11, 13, 3, 2, 7, 1, 7, 11, 5, 3, 11, 11, 9, 1, 6, 7, 4, 13, 8, 10, 2, 6, 10, 1, 9, 8, 6, 5, 8, 9, 8, 4, 10, 1},
                {6, 10, 8, 8, 6, 3, 10, 1, 2, 11, 2, 5, 7, 11, 10, 1, 6, 9, 3, 9, 7, 9, 4, 4, 10, 1, 11, 11, 6, 2, 8, 9, 7, 5, 8, 1},
                {5, 11, 8, 11, 6, 6, 7, 1, 13, 11, 2, 4, 8, 10, 10, 1, 13, 9, 4, 9, 7, 11, 3, 3, 8, 1, 9, 10, 5, 2, 10, 7, 7, 6, 9, 1},
                {3, 11, 9, 9, 2, 3, 10, 1, 8, 7, 6, 5, 10, 10, 8, 1, 6, 8, 2, 7, 9, 11, 5, 6, 8, 1, 9, 7, 4, 4, 10, 11, 7, 6, 11, 1},
                {2, 10, 9, 10, 3, 5, 8, 1, 7, 7, 2, 5, 7, 13, 10, 1, 6, 8, 4, 8, 9, 10, 3, 6, 11, 1, 11, 11, 4, 13, 9, 11, 9, 6, 7, 1}
            },
            prize_reel= {
                {6, 9, 11, 12, 3, 2, 7, 1, 7, 12, 5, 3, 11, 11, 9, 1, 12, 7, 4, 10, 8, 10, 2, 6, 10, 1, 9, 8, 6, 5, 8, 9, 8, 4, 10, 1},
                {6, 10, 8, 8, 6, 3, 10, 1, 7, 11, 2, 5, 7, 11, 10, 1, 6, 9, 3, 9, 12, 9, 4, 4, 10, 1, 11, 12, 6, 2, 8, 9, 7, 5, 8, 1},
                {5, 11, 12, 11, 6, 6, 7, 1, 8, 11, 2, 4, 8, 12, 10, 1, 6, 9, 4, 9, 7, 12, 3, 3, 8, 1, 9, 10, 5, 2, 10, 7, 7, 6, 9, 1},
                {3, 11, 9, 9, 12, 3, 10, 1, 8, 7, 6, 5, 10, 10, 8, 1, 6, 8, 2, 7, 9, 11, 5, 6, 8, 1, 9, 7, 12, 4, 10, 11, 7, 6, 11, 1},
                {2, 10, 9, 10, 3, 5, 12, 1, 7, 7, 12, 5, 7, 8, 10, 1, 6, 8, 4, 8, 9, 10, 3, 6, 11, 1, 11, 11, 4, 6, 9, 11, 9, 6, 7, 1}
            }
        },
        experience= 58696,
        vouchers_mini_bet_idx= 0,
        theme_map= {
            wager_count= 4,
            credits= 415,
            wager= 60000
        },
        jp_bet= 15000,
        jp_data= {
            ["186"] = {
                mega= {
                    {20, 542099}
                },
                mini= {
                    {20, 10852}
                },
                major= {
                    {20, 108419}
                },
                grand= {
                    {20, 641152}
                },
                minor= {
                    {20, 13514}
                }
            }
        },
        theme_info= {
            bonus_info= {
                wager_count= 15,
                wild_count= 22,
                wager= 170000
            },
            theme_map= {
                wager_count= 4,
                credits= 415,
                wager= 60000
            }
        },
        theme_id= 186,
        max_lines= 40,
        default_bet= 15000,
        bet_per_line= {1000, 20000, 30000, 40000, 60000}
    
}

return loadData