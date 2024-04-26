return 
{
    {
        plist = {
            "theme225/free_coins/packs/freeCoinsImg.plist",
            "theme225/ad_reward/packs/ad_reward.plist",
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
                    width = 832,
                    height = 765,
                },
                type = "BLSprite",
                name = "bg",
                texture = "theme225/ad_reward/texture_atlas/ad_reward/kuang_2.png",
                children = {
                    {
                        content_size = {
                            width = 463,
                            height = 80,
                        },
                        frame = "title.png",
                        type = "BLSprite",
                        name = "title",
                        position = {
                            y = 638.047,
                            x = 430.644,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 566,
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
                            width = 427,
                            height = 91,
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
                            width = 101,
                            height = 101,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 272.507,
                            x = 212.022,
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
                    y = 257.798,
                    x = 304.885,
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
                    x = 18.801,
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
                    width = 296.44,
                    height = 72,
                },
                vertical_align = 0,
                text = "5,000,000",
                lineHeight = 72,
                position = {
                    y = -109.789,
                    x = 27.128,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme225/ad_reward/fonts/guide.fnt",
            },
            {
                content_size = {
                    width = 410,
                    height = 33,
                },
                frame = "font2.png",
                type = "BLSprite",
                name = "des_seconds",
                position = {
                    y = -337.234,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                horizontal_align = 1,
                font_size = 25,
                name = "label_seconds",
                content_size = {
                    width = 61.72,
                    height = 32,
                },
                vertical_align = 1,
                text = "3600",
                lineHeight = 32,
                position = {
                    y = -336.844,
                    x = 74.982,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme225/free_coins/fonts/freeLabel.fnt",
            },
        },
    },
}