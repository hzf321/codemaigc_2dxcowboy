return 
{
    {
        plist = {
            "theme244/ad_reward/packs/ad_reward.plist",
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
                    width = 982,
                    height = 612,
                },
                type = "BLSprite",
                name = "kuang_2",
                texture = "theme244/ad_reward/packs/kuang_2.png",
            },
            {
                content_size = {
                    width = 536,
                    height = 83,
                },
                type = "BLSprite",
                name = "freebonus",
                texture = "theme244/ad_reward/texture_atlas/ad_reward/freebonus.png",
                position = {
                    y = 271.77,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 513,
                    height = 31,
                },
                frame = "text_2.png",
                type = "BLSprite",
                name = "text_2",
                position = {
                    y = 212.416,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 502,
                    height = 28,
                },
                frame = "text_3.png",
                type = "BLSprite",
                name = "text_3",
                position = {
                    y = -319.976,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                name = "kuang",
                content_size = {
                    width = 469,
                    height = 79,
                },
                frame = "kuang.png",
                position = {
                    y = -92.212,
                    x = 0.0,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        content_size = {
                            width = 82,
                            height = 81,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 38.947,
                            x = 26.912,
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
                    y = 276.283,
                    x = 455.07,
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
                font_size = 15,
                name = "label_coins",
                content_size = {
                    width = 271.41,
                    height = 50,
                },
                vertical_align = 0,
                text = "6.000.000",
                lineHeight = 50,
                position = {
                    y = -85.64,
                    x = 0.0,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme244/ad_reward/fonts/guide.fnt",
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
                    y = -199.862,
                    x = 0.0,
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