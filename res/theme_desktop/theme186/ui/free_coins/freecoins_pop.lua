return 
{
    {
        plist = {
            "theme186/free_coins/packs/freeCoinsImg.plist",
            "theme186/ad_reward/packs/ad_reward.plist",
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
                    width = 872,
                    height = 786,
                },
                frame = "kuang_v.png",
                type = "BLSprite",
                name = "bg",
                children = {
                    {
                        content_size = {
                            width = 306,
                            height = 80,
                        },
                        frame = "title.png",
                        type = "BLSprite",
                        name = "title",
                        position = {
                            y = 675.085,
                            x = 450.644,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 471,
                            height = 34,
                        },
                        frame = "font1.png",
                        type = "BLSprite",
                        name = "font1",
                        position = {
                            y = 585.344,
                            x = 449.354,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 309,
                            height = 295,
                        },
                        frame = "chest.png",
                        type = "BLSprite",
                        name = "chest",
                        position = {
                            y = 408.16,
                            x = 436.0,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 564,
                            height = 221,
                        },
                        frame = "chest1.png",
                        type = "BLSprite",
                        name = "chest1",
                        position = {
                            y = 254.355,
                            x = 436.0,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 471,
                            height = 103,
                        },
                        frame = "kuang.png",
                        type = "BLSprite",
                        name = "kuang",
                        position = {
                            y = 245.954,
                            x = 474.448,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 91,
                            height = 101,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 249.333,
                            x = 232.022,
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
                    y = 269.172,
                    x = 320.808,
                    z = 0,
                },
                frame_normal = "close.png",
                type = "BLButton",
                children = {
                },
                target = 24,
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
                    y = -280.357,
                    x = 2.5,
                    z = 0,
                },
                frame_normal = "button.png",
                type = "BLButton",
                children = {
                },
                target = 31,
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
                    y = -147.463,
                    x = 21.074,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme186/free_coins/fonts/guide.fnt",
            },
            {
                content_size = {
                    width = 363,
                    height = 21,
                },
                frame = "font2.png",
                type = "BLSprite",
                name = "des_seconds",
                position = {
                    y = -367.363,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                horizontal_align = 1,
                font_size = 32,
                name = "label_seconds",
                content_size = {
                    width = 57,
                    height = 32,
                },
                vertical_align = 1,
                text = "3600",
                lineHeight = 32,
                position = {
                    y = -367.441,
                    x = 65.232,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme186/free_coins/fonts/freeLabel.fnt",
            },
        },
    },
}