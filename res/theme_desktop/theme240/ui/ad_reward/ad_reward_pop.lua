return 
{
    {
        plist = {
            "theme240/ad_reward/packs/ad_reward.plist",
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
                    width = 945,
                    height = 601,
                },
                type = "BLSprite",
                name = "kuang_2",
                texture = "theme240/ad_reward/texture_atlas/ad_reward/kuang_2.png",
            },
            {
                content_size = {
                    width = 498,
                    height = 155,
                },
                frame = "freebonus.png",
                type = "BLSprite",
                name = "freebonus",
                position = {
                    y = 237.968,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 415,
                    height = 28,
                },
                frame = "text_2.png",
                type = "BLSprite",
                name = "text_2",
                position = {
                    y = 150.823,
                    x = 11.309,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 396,
                    height = 25,
                },
                frame = "text_3.png",
                type = "BLSprite",
                name = "text_3",
                position = {
                    y = -316.389,
                    x = 16.227,
                    z = 0,
                },
            },
            {
                name = "kuang",
                content_size = {
                    width = 474,
                    height = 103,
                },
                frame = "kuang.png",
                position = {
                    y = -100.041,
                    x = 29.815,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        content_size = {
                            width = 116,
                            height = 112,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 51.5,
                            x = -15.37,
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
                    y = 196.372,
                    x = 339.099,
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
                    width = 315.56,
                    height = 72,
                },
                vertical_align = 0,
                text = "6.000.000",
                lineHeight = 72,
                position = {
                    y = -97.207,
                    x = 28.472,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme240/ad_reward/fonts/guide.fnt",
            },
            {
                name = "btn_collect",
                frame_disable = "free_collect.png",
                content_size = {
                    width = 405,
                    height = 95,
                },
                frame_down = "free_collect.png",
                position = {
                    y = -247.637,
                    x = 17.028,
                    z = 0,
                },
                frame_normal = "free_collect.png",
                type = "BLButton",
                children = {
                },
                target = 30,
            },
        },
    },
}