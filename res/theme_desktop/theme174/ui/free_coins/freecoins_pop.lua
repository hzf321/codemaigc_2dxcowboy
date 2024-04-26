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
        name = "freecoins_pop",
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
                name = "bg",
                texture = "theme174/ad_reward/texture_atlas/ad_reward/kuang_2.png",
                children = {
                    {
                        content_size = {
                            width = 549,
                            height = 96,
                        },
                        frame = "freecoin.png",
                        type = "BLSprite",
                        name = "freecoin",
                        position = {
                            y = 478.45,
                            x = 484.5,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 602,
                            height = 22,
                        },
                        frame = "freecoin_2.png",
                        type = "BLSprite",
                        name = "font1",
                        position = {
                            y = 415.839,
                            x = 473.606,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 472,
                            height = 104,
                        },
                        frame = "kuang.png",
                        type = "BLSprite",
                        name = "kuang",
                        position = {
                            y = 137.128,
                            x = 484.5,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 100,
                            height = 111,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 143.098,
                            x = 289.343,
                            z = 0,
                        },
                    },
                },
            },
            {
                name = "btn_close",
                texture_disable = "theme174/ad_reward/texture_atlas/ad_reward/close.png",
                content_size = {
                    width = 68,
                    height = 70,
                },
                texture_normal = "theme174/ad_reward/texture_atlas/ad_reward/close.png",
                texture_down = "theme174/ad_reward/texture_atlas/ad_reward/close.png",
                position = {
                    y = 220.875,
                    x = 313.42,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 18,
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
                    y = -221.689,
                    x = 2.5,
                    z = 0,
                },
                frame_normal = "free_collect.png",
                type = "BLButton",
                children = {
                },
                target = 25,
            },
            {
                horizontal_align = 0,
                font_size = 15,
                name = "label_coins",
                content_size = {
                    width = 256.41,
                    height = 50,
                },
                vertical_align = 0,
                text = "5.000.000",
                lineHeight = 50,
                position = {
                    y = -104.213,
                    x = 0.0,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme174/ad_reward/fonts/guide.fnt",
            },
            {
                content_size = {
                    width = 528,
                    height = 22,
                },
                frame = "freecoin_3.png",
                type = "BLSprite",
                name = "des_seconds",
                position = {
                    y = -285.45,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                horizontal_align = 1,
                font_size = 32,
                name = "label_seconds",
                content_size = {
                    width = 61,
                    height = 32,
                },
                vertical_align = 1,
                text = "3600",
                lineHeight = 32,
                position = {
                    y = -283.971,
                    x = 108.385,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme174/ad_reward/fonts/freeLabel.fnt",
            },
        },
    },
}