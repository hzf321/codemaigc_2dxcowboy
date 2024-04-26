return 
{
    {
        plist = {
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
                texture = "theme192/ad_reward/textures/kuang_2.png",
                position = {
                    y = 0.0,
                    x = -15.053,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 412,
                    height = 75,
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
                    width = 540,
                    height = 47,
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
                    width = 667,
                    height = 52,
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
                    width = 419,
                    height = 99,
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
                            width = 97,
                            height = 102,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 49.5,
                            x = -1.383,
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
                    y = 227.198,
                    x = 302.198,
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
                font_size = 18,
                name = "label_coins",
                content_size = {
                    width = 269.44,
                    height = 72,
                },
                vertical_align = 0,
                text = "6.000.000",
                lineHeight = 72,
                position = {
                    y = -102.874,
                    x = 19.84,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme192/ad_reward/fonts/guide.fnt",
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
                    y = -249.809,
                    x = 1.975,
                    z = 0,
                },
                frame_normal = "button.png",
                type = "BLButton",
                children = {
                },
                target = 30,
            },
        },
    },
}