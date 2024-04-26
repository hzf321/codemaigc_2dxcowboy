return 
{
    {
        plist = {
            "theme230/free_coins/packs/freeCoinsImg.plist",
            "theme230/ad_reward/packs/ad_reward.plist",
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
                texture = "theme230/ad_reward/textures/kuang_2.png",
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
                            y = 640.668,
                            x = 430.644,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 554,
                            height = 38,
                        },
                        frame = "font1.png",
                        type = "BLSprite",
                        name = "font1",
                        position = {
                            y = 577.584,
                            x = 429.354,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 394,
                            height = 69,
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
                            width = 110,
                            height = 99,
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
                texture_disable = "theme230/ad_reward/textures/button2.png",
                content_size = {
                    width = 405,
                    height = 95,
                },
                texture_normal = "theme230/ad_reward/textures/button2.png",
                texture_down = "theme230/ad_reward/textures/button2.png",
                position = {
                    y = -224.82,
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
                font_size = 18,
                name = "label_coins",
                content_size = {
                    width = 303.75,
                    height = 18,
                },
                vertical_align = 0,
                text = "5,000,000",
                lineHeight = 18,
                position = {
                    y = -111.24,
                    x = 38.03,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme230/ad_reward/fonts/guide.fnt",
            },
            {
                content_size = {
                    width = 433,
                    height = 32,
                },
                frame = "font2.png",
                type = "BLSprite",
                name = "des_seconds",
                position = {
                    y = -318.054,
                    x = -17.835,
                    z = 0,
                },
            },
            {
                horizontal_align = 1,
                font_size = 30,
                name = "label_seconds",
                content_size = {
                    width = 76.88,
                    height = 32,
                },
                vertical_align = 1,
                text = "3600",
                lineHeight = 32,
                position = {
                    y = -316.565,
                    x = 58.75,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme230/free_coins/fonts/freeLabel.fnt",
            },
        },
    },
}