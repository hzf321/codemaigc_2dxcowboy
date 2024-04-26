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
                    width = 977,
                    height = 635,
                },
                type = "BLSprite",
                name = "bg",
                texture = "theme325/ad_reward/texture_atlas/ad_reward/kuang_2.png",
                children = {
                    {
                        content_size = {
                            width = 534,
                            height = 112,
                        },
                        type = "BLSprite",
                        name = "title",
                        texture = "theme325/ad_reward/texture_atlas/ad_reward/freecoin.png",
                        position = {
                            y = 546.719,
                            x = 503.144,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 597,
                            height = 35,
                        },
                        frame = "freecoin_2.png",
                        type = "BLSprite",
                        name = "font1",
                        position = {
                            y = 466.469,
                            x = 501.854,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 541,
                            height = 94,
                        },
                        frame = "kuang.png",
                        type = "BLSprite",
                        name = "kuang",
                        position = {
                            y = 256.67,
                            x = 488.5,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 110,
                            height = 102,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 260.049,
                            x = 253.065,
                            z = 0,
                        },
                    },
                },
            },
            {
                name = "btn_close",
                texture_disable = "theme325/ad_reward/texture_atlas/ad_reward/close.png",
                content_size = {
                    width = 68,
                    height = 70,
                },
                texture_normal = "theme325/ad_reward/texture_atlas/ad_reward/close.png",
                texture_down = "theme325/ad_reward/texture_atlas/ad_reward/close.png",
                position = {
                    y = 225.315,
                    x = 389.228,
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
                    y = -175.5,
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
                    width = 327.38,
                    height = 72,
                },
                vertical_align = 0,
                text = "5.000.000",
                lineHeight = 72,
                position = {
                    y = -56.861,
                    x = 23.081,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme325/ad_reward/fonts/guide.fnt",
            },
            {
                content_size = {
                    width = 430,
                    height = 24,
                },
                frame = "freecoin_3.png",
                type = "BLSprite",
                name = "des_seconds",
                position = {
                    y = -249.909,
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
                    y = -248.929,
                    x = 75.643,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme325/ad_reward/fonts/freeLabel.fnt",
            },
        },
    },
}