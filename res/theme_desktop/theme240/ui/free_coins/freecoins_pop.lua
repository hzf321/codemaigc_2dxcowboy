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
                    height = 601,
                },
                type = "BLSprite",
                name = "bg",
                texture = "theme240/ad_reward/texture_atlas/ad_reward/kuang_2.png",
                children = {
                    {
                        content_size = {
                            width = 468,
                            height = 155,
                        },
                        type = "BLSprite",
                        name = "title",
                        texture = "theme240/ad_reward/texture_atlas/ad_reward/freecoin.png",
                        position = {
                            y = 540.849,
                            x = 487.144,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 500,
                            height = 31,
                        },
                        frame = "freecoin_2.png",
                        type = "BLSprite",
                        name = "font1",
                        position = {
                            y = 445.188,
                            x = 485.854,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 474,
                            height = 103,
                        },
                        frame = "kuang.png",
                        type = "BLSprite",
                        name = "kuang",
                        position = {
                            y = 190.868,
                            x = 472.5,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 116,
                            height = 112,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 194.247,
                            x = 237.065,
                            z = 0,
                        },
                    },
                },
            },
            {
                name = "btn_close",
                texture_disable = "theme240/ad_reward/texture_atlas/ad_reward/close.png",
                content_size = {
                    width = 68,
                    height = 70,
                },
                texture_normal = "theme240/ad_reward/texture_atlas/ad_reward/close.png",
                texture_down = "theme240/ad_reward/texture_atlas/ad_reward/close.png",
                position = {
                    y = 185.931,
                    x = 339.57,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 18,
            },
            {
                name = "btn_collect",
                frame_disable = "button_2.png",
                content_size = {
                    width = 405,
                    height = 95,
                },
                frame_down = "button_2.png",
                position = {
                    y = -244.252,
                    x = 2.5,
                    z = 0,
                },
                frame_normal = "button_2.png",
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
                    width = 314.44,
                    height = 72,
                },
                vertical_align = 0,
                text = "5.000.000",
                lineHeight = 72,
                position = {
                    y = -105.663,
                    x = 23.081,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme240/ad_reward/fonts/guide.fnt",
            },
            {
                content_size = {
                    width = 369,
                    height = 25,
                },
                frame = "freecoin_3.png",
                type = "BLSprite",
                name = "des_seconds",
                position = {
                    y = -314.475,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                horizontal_align = 1,
                font_size = 32,
                name = "label_seconds",
                content_size = {
                    width = 62,
                    height = 32,
                },
                vertical_align = 1,
                text = "3600",
                lineHeight = 32,
                position = {
                    y = -313.495,
                    x = 65.298,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme240/ad_reward/fonts/freeLabel.fnt",
            },
        },
    },
}