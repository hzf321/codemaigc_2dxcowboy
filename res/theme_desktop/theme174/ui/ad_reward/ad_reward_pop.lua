return 
{
    {
        plist = {
            "theme174/ad_reward/packs/ad_reward.plist",
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
                    width = 969,
                    height = 495,
                },
                type = "BLSprite",
                name = "kuang_2",
                texture = "theme174/ad_reward/packs/kuang_2.png",
            },
            {
                content_size = {
                    width = 549,
                    height = 96,
                },
                type = "BLSprite",
                name = "freebonus",
                texture = "theme174/ad_reward/texture_atlas/ad_reward/freebonus.png",
                position = {
                    y = 230.168,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 504,
                    height = 26,
                },
                frame = "text_2.png",
                type = "BLSprite",
                name = "text_2",
                position = {
                    y = 170.814,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 512,
                    height = 23,
                },
                frame = "text_3.png",
                type = "BLSprite",
                name = "text_3",
                position = {
                    y = -288.909,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                name = "kuang",
                content_size = {
                    width = 472,
                    height = 104,
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
                            width = 100,
                            height = 111,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 51.447,
                            x = 28.412,
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
                    y = 222.535,
                    x = 318.437,
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
                    width = 256.88,
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
                font_name = "theme174/ad_reward/fonts/guide.fnt",
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
                    y = -213.407,
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