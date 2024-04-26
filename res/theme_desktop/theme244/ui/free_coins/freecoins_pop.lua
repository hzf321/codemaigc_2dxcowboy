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
                    width = 982,
                    height = 612,
                },
                type = "BLSprite",
                name = "bg",
                texture = "theme244/ad_reward/texture_atlas/ad_reward/kuang_2.png",
                children = {
                    {
                        content_size = {
                            width = 516,
                            height = 83,
                        },
                        frame = "freecoin.png",
                        type = "BLSprite",
                        name = "freecoin",
                        position = {
                            y = 577.666,
                            x = 491.0,
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
                            y = 517.867,
                            x = 491.0,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 469,
                            height = 79,
                        },
                        frame = "kuang.png",
                        type = "BLSprite",
                        name = "kuang",
                        position = {
                            y = 195.628,
                            x = 491.0,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 82,
                            height = 81,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 193.695,
                            x = 278.141,
                            z = 0,
                        },
                    },
                },
            },
            {
                name = "btn_close",
                texture_disable = "theme244/ad_reward/texture_atlas/ad_reward/close.png",
                content_size = {
                    width = 68,
                    height = 70,
                },
                texture_normal = "theme244/ad_reward/texture_atlas/ad_reward/close.png",
                texture_down = "theme244/ad_reward/texture_atlas/ad_reward/close.png",
                position = {
                    y = 277.032,
                    x = 446.304,
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
                    y = -206.65,
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
                    width = 270,
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
                font_name = "theme244/ad_reward/fonts/guide.fnt",
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
                    y = -313.448,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                horizontal_align = 1,
                font_size = 32,
                name = "label_seconds",
                content_size = {
                    width = 72,
                    height = 32,
                },
                vertical_align = 1,
                text = "3600",
                lineHeight = 32,
                position = {
                    y = -312.468,
                    x = 75.204,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme244/ad_reward/fonts/freeLabel.fnt",
            },
        },
    },
}