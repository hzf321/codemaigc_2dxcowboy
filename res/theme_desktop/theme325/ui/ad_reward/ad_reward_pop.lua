return 
{
    {
        plist = {
            "theme325/ad_reward/packs/ad_reward.plist",
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
                    width = 977,
                    height = 635,
                },
                type = "BLSprite",
                name = "kuang_2",
                texture = "theme325/ad_reward/texture_atlas/ad_reward/kuang_2.png",
            },
            {
                content_size = {
                    width = 567,
                    height = 112,
                },
                frame = "freebonus.png",
                type = "BLSprite",
                name = "freebonus",
                position = {
                    y = 232.973,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 479,
                    height = 30,
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
                    width = 468,
                    height = 24,
                },
                frame = "text_3.png",
                type = "BLSprite",
                name = "text_3",
                position = {
                    y = -249.988,
                    x = 16.227,
                    z = 0,
                },
            },
            {
                name = "kuang",
                content_size = {
                    width = 541,
                    height = 94,
                },
                frame = "kuang.png",
                position = {
                    y = -57.586,
                    x = 29.815,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        content_size = {
                            width = 110,
                            height = 102,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 47.0,
                            x = 18.13,
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
                    y = 235.036,
                    x = 387.619,
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
                    width = 331.88,
                    height = 72,
                },
                vertical_align = 0,
                text = "6.000.000",
                lineHeight = 72,
                position = {
                    y = -54.752,
                    x = 47.274,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme325/ad_reward/fonts/guide.fnt",
            },
            {
                name = "btn_collect",
                frame_disable = "collect.png",
                content_size = {
                    width = 405,
                    height = 95,
                },
                frame_down = "collect.png",
                position = {
                    y = -182.438,
                    x = 17.028,
                    z = 0,
                },
                frame_normal = "collect.png",
                type = "BLButton",
                children = {
                },
                target = 30,
            },
        },
    },
}