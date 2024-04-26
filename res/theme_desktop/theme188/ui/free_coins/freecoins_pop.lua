return 
{
    {
        plist = {
            "theme188/free_coins/packs/freeCoinsImg.plist",
            "theme188/ad_reward/packs/ad_reward.plist",
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
                    width = 771,
                    height = 694,
                },
                frame = "bg.png",
                type = "BLSprite",
                name = "bg",
                children = {
                    {
                        content_size = {
                            width = 335,
                            height = 55,
                        },
                        frame = "title.png",
                        type = "BLSprite",
                        name = "title",
                        position = {
                            y = 651.305,
                            x = 400.144,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 498,
                            height = 33,
                        },
                        frame = "font1.png",
                        type = "BLSprite",
                        name = "font1",
                        position = {
                            y = 568.533,
                            x = 398.854,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 243,
                            height = 250,
                        },
                        frame = "chest.png",
                        type = "BLSprite",
                        name = "chest",
                        position = {
                            y = 414.589,
                            x = 385.5,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 575,
                            height = 97,
                        },
                        frame = "kuang.png",
                        type = "BLSprite",
                        name = "kuang",
                        position = {
                            y = 286.17,
                            x = 385.5,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 109,
                            height = 99,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 289.549,
                            x = 150.065,
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
                    y = 268.714,
                    x = 345.386,
                    z = 0,
                },
                frame_normal = "close.png",
                type = "BLButton",
                children = {
                },
                target = 21,
            },
            {
                name = "btn_collect",
                frame_disable = "button.png",
                content_size = {
                    width = 405,
                    height = 95,
                },
                frame_down = "button.png",
                position = {
                    y = -175.5,
                    x = 2.5,
                    z = 0,
                },
                frame_normal = "button.png",
                type = "BLButton",
                children = {
                },
                target = 28,
            },
            {
                horizontal_align = 0,
                font_size = 15,
                name = "label_coins",
                content_size = {
                    width = 301.88,
                    height = 72,
                },
                vertical_align = 0,
                text = "5,000,000",
                lineHeight = 72,
                position = {
                    y = -60.084,
                    x = 21.074,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme188/free_coins/fonts/guide.fnt",
            },
            {
                content_size = {
                    width = 360,
                    height = 21,
                },
                frame = "font2.png",
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
                    width = 14,
                    height = 32,
                },
                vertical_align = 1,
                text = "0",
                lineHeight = 32,
                position = {
                    y = -249.987,
                    x = 64.106,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme188/free_coins/fonts/freeLabel.fnt",
            },
        },
    },
}