return 
{
    {
        plist = {
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
        name = "ad_reward_pop",
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
                name = "kuang_2",
                texture = "theme194/ad_reward/textures/kuang_2.png",
                position = {
                    y = 0.0,
                    x = -15.053,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 384,
                    height = 78,
                },
                frame = "text_1.png",
                type = "BLSprite",
                name = "freebonus",
                position = {
                    y = 253.64,
                    x = 10.78,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 450,
                    height = 30,
                },
                frame = "text_2.png",
                type = "BLSprite",
                name = "text_2",
                position = {
                    y = 191.071,
                    x = -3.744,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 629,
                    height = 36,
                },
                frame = "text_3.png",
                type = "BLSprite",
                name = "text_3",
                position = {
                    y = -346.395,
                    x = 1.174,
                    z = 0,
                },
            },
            {
                name = "kuang",
                content_size = {
                    width = 455,
                    height = 86,
                },
                frame = "kuang.png",
                position = {
                    y = -105.708,
                    x = 14.762,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        content_size = {
                            width = 87,
                            height = 89,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 43.0,
                            x = 16.617,
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
                    y = 226.538,
                    x = 322.991,
                    z = 0,
                },
                frame_normal = "close.png",
                type = "BLButton",
                children = {
                },
                target = 21,
            },
            {
                horizontal_align = 0,
                font_size = 60,
                name = "label_coins",
                content_size = {
                    width = 301.67,
                    height = 60,
                },
                vertical_align = 0,
                text = "6,000,000",
                lineHeight = 60,
                position = {
                    y = -99.499,
                    x = 19.84,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme194/ad_reward/fonts/guide.fnt",
            },
            {
                name = "btn_collect",
                texture_disable = "theme194/ad_reward/textures/button.png",
                content_size = {
                    width = 405,
                    height = 95,
                },
                texture_normal = "theme194/ad_reward/textures/button.png",
                texture_down = "theme194/ad_reward/textures/button.png",
                position = {
                    y = -237.841,
                    x = 1.975,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 30,
            },
        },
    },
}