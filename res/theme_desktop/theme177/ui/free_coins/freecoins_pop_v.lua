return 
{
    {
        plist = {
            "theme177/free_coins/packs/freeCoinsImg.plist",
            "theme177/ad_reward/packs/ad_reward.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_close",
            },
            {
                path = "root.btn_collect",
            },
        },
        name = "freecoins_pop_v",
    },
    {
        position = {
            y = 0,
            x = 0,
            z = 0,
        },
        type = "BLNode",
        name = "root",
        children = {
            {
                content_size = {
                    width = 843,
                    height = 715,
                },
                type = "BLSprite",
                name = "bg",
                texture = "theme177/free_coins/texture_atlas/freeCoinsImg/kuang_v.png",
                children = {
                    {
                        content_size = {
                            width = 455,
                            height = 110,
                        },
                        frame = "title.png",
                        type = "BLSprite",
                        name = "title",
                        position = {
                            y = 629.099,
                            x = 436.144,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 478,
                            height = 54,
                        },
                        frame = "font1.png",
                        type = "BLSprite",
                        name = "font1",
                        position = {
                            y = 549.844,
                            x = 434.854,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 348,
                            height = 225,
                        },
                        frame = "chest.png",
                        type = "BLSprite",
                        name = "chest",
                        position = {
                            y = 425.089,
                            x = 421.5,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 551,
                            height = 104,
                        },
                        frame = "kuang.png",
                        type = "BLSprite",
                        name = "kuang",
                        position = {
                            y = 296.67,
                            x = 421.5,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 103,
                            height = 102,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 300.049,
                            x = 186.065,
                            z = 0,
                        },
                    },
                },
            },
            {
                name = "btn_close",
                frame_disable = "close.png",
                content_size = {
                    width = 68,
                    height = 70,
                },
                frame_down = "close.png",
                position = {
                    y = 107.318,
                    x = 320.808,
                    z = 0,
                },
                frame_normal = "close.png",
                type = "BLButton",
                children = {
                },
                target = 21,
            },
            {
                name = "btn_collect",
                frame_disable = "button.png",
                content_size = {
                    width = 405,
                    height = 95,
                },
                frame_down = "button.png",
                position = {
                    y = -175.5,
                    x = 2.5,
                    z = 0,
                },
                frame_normal = "button.png",
                type = "BLButton",
                children = {
                },
                target = 28,
            },
            {
                horizontal_align = 0,
                font_size = 18,
                name = "label_coins",
                content_size = {
                    width = 268.88,
                    height = 72,
                },
                vertical_align = 0,
                text = "123456",
                lineHeight = 72,
                position = {
                    y = -61.247,
                    x = 21.074,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme177/free_coins/fonts/guide.fnt",
            },
            {
                content_size = {
                    width = 415,
                    height = 21,
                },
                frame = "font2.png",
                type = "BLSprite",
                name = "des_seconds",
                position = {
                    y = -249.909,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                horizontal_align = 1,
                font_size = 32,
                name = "label_seconds",
                content_size = {
                    width = 64,
                    height = 32,
                },
                vertical_align = 1,
                text = "3600",
                lineHeight = 32,
                position = {
                    y = -249.987,
                    x = 75.643,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme177/free_coins/fonts/freeLabel.fnt",
            },
        },
    },
}