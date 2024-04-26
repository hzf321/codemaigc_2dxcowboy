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
                    width = 945,
                    height = 635,
                },
                type = "BLSprite",
                name = "bg",
                texture = "theme164/ad_reward/texture_atlas/ad_reward/kuang_2.png",
                children = {
                    {
                        content_size = {
                            width = 570,
                            height = 115,
                        },
                        type = "BLSprite",
                        name = "title",
                        texture = "theme164/ad_reward/texture_atlas/ad_reward/freecoin.png",
                        position = {
                            y = 535.263,
                            x = 472.5,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 569,
                            height = 36,
                        },
                        frame = "freecoin_2.png",
                        type = "BLSprite",
                        name = "font1",
                        position = {
                            y = 466.469,
                            x = 472.5,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 514,
                            height = 102,
                        },
                        frame = "kuang.png",
                        type = "BLSprite",
                        name = "kuang",
                        position = {
                            y = 256.67,
                            x = 472.5,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 111,
                            height = 106,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 260.049,
                            x = 237.065,
                            z = 0,
                        },
                    },
                },
            },
            {
                name = "btn_close",
                texture_disable = "theme164/ad_reward/texture_atlas/ad_reward/close.png",
                content_size = {
                    width = 68,
                    height = 70,
                },
                texture_normal = "theme164/ad_reward/texture_atlas/ad_reward/close.png",
                texture_down = "theme164/ad_reward/texture_atlas/ad_reward/close.png",
                position = {
                    y = 225.315,
                    x = 337.227,
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
                    y = -257.323,
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
                font_size = 18,
                name = "label_coins",
                content_size = {
                    width = 316.69,
                    height = 72,
                },
                vertical_align = 0,
                text = "5.000.000",
                lineHeight = 72,
                position = {
                    y = -54.679,
                    x = 7.806,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme164/ad_reward/fonts/guide.fnt",
            },
            {
                content_size = {
                    width = 407,
                    height = 27,
                },
                frame = "freecoin_3.png",
                type = "BLSprite",
                name = "des_seconds",
                position = {
                    y = -336.469,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                horizontal_align = 1,
                font_size = 32,
                name = "label_seconds",
                content_size = {
                    width = 66,
                    height = 32,
                },
                vertical_align = 1,
                text = "3600",
                lineHeight = 32,
                position = {
                    y = -335.489,
                    x = 76.204,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme164/ad_reward/fonts/freeLabel.fnt",
            },
        },
    },
}