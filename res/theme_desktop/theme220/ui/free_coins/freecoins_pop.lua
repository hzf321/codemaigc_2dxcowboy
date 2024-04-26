return 
{
    {
        plist = {
            "theme220/free_coins/packs/freeCoinsImg.plist",
            "theme220/ad_reward/packs/ad_reward.plist",
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
                texture = "theme220/ad_reward/textures/kuang_2.png",
                children = {
                    {
                        content_size = {
                            width = 434,
                            height = 92,
                        },
                        frame = "title.png",
                        type = "BLSprite",
                        name = "title",
                        position = {
                            y = 664.585,
                            x = 430.644,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 528,
                            height = 39,
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
                            width = 448,
                            height = 108,
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
                            width = 105,
                            height = 99,
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
                    y = 269.172,
                    x = 320.808,
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
                    width = 322.88,
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
                font_name = "theme220/ad_reward/fonts/guide.fnt",
            },
            {
                content_size = {
                    width = 400,
                    height = 31,
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
                    width = 64.06,
                    height = 32,
                },
                vertical_align = 1,
                text = "4567",
                lineHeight = 32,
                position = {
                    y = -337.522,
                    x = 73.04,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme220/free_coins/fonts/freeLabel.fnt",
            },
        },
    },
}