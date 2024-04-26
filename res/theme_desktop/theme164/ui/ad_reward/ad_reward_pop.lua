return 
{
    {
        plist = {
            "theme164/ad_reward/packs/ad_reward.plist",
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
                    height = 635,
                },
                type = "BLSprite",
                name = "kuang_2",
                texture = "theme164/ad_reward/texture_atlas/ad_reward/kuang_2.png",
            },
            {
                content_size = {
                    width = 596,
                    height = 115,
                },
                frame = "freebonus.png",
                type = "BLSprite",
                name = "freebonus",
                position = {
                    y = 216.226,
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
                    y = 139.806,
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
                    y = -326.189,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                name = "kuang",
                content_size = {
                    width = 514,
                    height = 102,
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
                            width = 111,
                            height = 106,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 51.0,
                            x = 4.63,
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
                    y = 215.903,
                    x = 338.298,
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
                    width = 316.69,
                    height = 72,
                },
                vertical_align = 0,
                text = "6.000.000",
                lineHeight = 72,
                position = {
                    y = -51.866,
                    x = 34.28,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme164/ad_reward/fonts/guide.fnt",
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
                    y = -247.622,
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