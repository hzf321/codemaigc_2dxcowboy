return 
{
    {
        plist = {
            "theme194/free_coins/packs/freeCoinsImg.plist",
            "theme194/ad_reward/packs/ad_reward.plist",
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
                name = "bg",
                content_size = {
                    width = 832,
                    height = 765,
                },
                texture = "theme194/ad_reward/textures/kuang_2.png",
                position = {
                    y = 0.0,
                    x = -17.835,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        content_size = {
                            width = 355,
                            height = 78,
                        },
                        frame = "title.png",
                        type = "BLSprite",
                        name = "title",
                        position = {
                            y = 636.101,
                            x = 430.644,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 559,
                            height = 38,
                        },
                        frame = "font1.png",
                        type = "BLSprite",
                        name = "font1",
                        position = {
                            y = 574.844,
                            x = 429.354,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 455,
                            height = 86,
                        },
                        frame = "kuang.png",
                        type = "BLSprite",
                        name = "kuang",
                        position = {
                            y = 269.128,
                            x = 454.448,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 87,
                            height = 89,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 272.507,
                            x = 259.348,
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
                    y = 228.172,
                    x = 320.417,
                    z = 0,
                },
                frame_normal = "close.png",
                type = "BLButton",
                children = {
                },
                target = 18,
            },
            {
                name = "btn_collect",
                texture_disable = "theme194/ad_reward/textures/button2.png",
                content_size = {
                    width = 405,
                    height = 95,
                },
                texture_normal = "theme194/ad_reward/textures/button2.png",
                texture_down = "theme194/ad_reward/textures/button2.png",
                position = {
                    y = -247.653,
                    x = 0.966,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 25,
            },
            {
                horizontal_align = 0,
                font_size = 60,
                name = "label_coins",
                content_size = {
                    width = 298.89,
                    height = 60,
                },
                vertical_align = 0,
                text = "5,000,000",
                lineHeight = 60,
                position = {
                    y = -104.854,
                    x = 24.588,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme194/ad_reward/fonts/guide.fnt",
            },
            {
                content_size = {
                    width = 451,
                    height = 31,
                },
                frame = "font2.png",
                type = "BLSprite",
                name = "des_seconds",
                position = {
                    y = -337.234,
                    x = -17.835,
                    z = 0,
                },
            },
            {
                horizontal_align = 1,
                font_size = 30,
                name = "label_seconds",
                content_size = {
                    width = 72.19,
                    height = 32,
                },
                vertical_align = 1,
                text = "3600",
                lineHeight = 32,
                position = {
                    y = -335.745,
                    x = 58.75,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme194/free_coins/fonts/freeLabel.fnt",
            },
        },
    },
}