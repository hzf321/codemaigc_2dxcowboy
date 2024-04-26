return 
{
    {
        plist = {
            "theme225/ad_reward/packs/ad_reward.plist",
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
                    width = 832,
                    height = 765,
                },
                type = "BLSprite",
                name = "kuang_2",
                texture = "theme225/ad_reward/texture_atlas/ad_reward/kuang_2.png",
            },
            {
                content_size = {
                    width = 463,
                    height = 80,
                },
                frame = "text_1.png",
                type = "BLSprite",
                name = "freebonus",
                position = {
                    y = 253.64,
                    x = 25.833,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 537,
                    height = 47,
                },
                frame = "text_2.png",
                type = "BLSprite",
                name = "text_2",
                position = {
                    y = 191.071,
                    x = 11.309,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 602,
                    height = 38,
                },
                frame = "text_3.png",
                type = "BLSprite",
                name = "text_3",
                position = {
                    y = -346.395,
                    x = 16.227,
                    z = 0,
                },
            },
            {
                name = "kuang",
                content_size = {
                    width = 427,
                    height = 91,
                },
                frame = "kuang.png",
                position = {
                    y = -105.708,
                    x = 29.815,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        content_size = {
                            width = 101,
                            height = 101,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 45.5,
                            x = -8.131,
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
                    y = 258.351,
                    x = 302.696,
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
                    width = 321.19,
                    height = 72,
                },
                vertical_align = 0,
                text = "6.000.000",
                lineHeight = 72,
                position = {
                    y = -102.874,
                    x = 47.274,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme225/ad_reward/fonts/guide.fnt",
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
                    y = -249.809,
                    x = 17.028,
                    z = 0,
                },
                frame_normal = "button.png",
                type = "BLButton",
                children = {
                },
                target = 30,
            },
        },
    },
}