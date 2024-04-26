return 
{
    {
        plist = {
            "theme192/free_coins/packs/freeCoinsImg.plist",
            "theme192/ad_reward/packs/ad_reward.plist",
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
                texture = "theme192/ad_reward/textures/kuang_2.png",
                position = {
                    y = 0.0,
                    x = -17.835,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        content_size = {
                            width = 401,
                            height = 75,
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
                            width = 552,
                            height = 54,
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
                            width = 419,
                            height = 99,
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
                            width = 97,
                            height = 102,
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
                    y = 224.91,
                    x = 293.235,
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
                frame_disable = "button.png",
                content_size = {
                    width = 405,
                    height = 95,
                },
                frame_down = "button.png",
                position = {
                    y = -247.653,
                    x = 0.966,
                    z = 0,
                },
                frame_normal = "button.png",
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
                    width = 270.56,
                    height = 72,
                },
                vertical_align = 0,
                text = "5,000,000",
                lineHeight = 72,
                position = {
                    y = -107.131,
                    x = 17.058,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme192/ad_reward/fonts/guide.fnt",
            },
            {
                content_size = {
                    width = 450,
                    height = 47,
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
                font_size = 21,
                name = "label_seconds",
                content_size = {
                    width = 65.63,
                    height = 32,
                },
                vertical_align = 1,
                text = "3600",
                lineHeight = 32,
                position = {
                    y = -335.27,
                    x = 56.138,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme192/free_coins/fonts/freeLabel.fnt",
            },
        },
    },
}