return 
{
    {
        plist = {
            "theme230/header_footer/packs/header.plist",
        },
        controllerList = {
        },
        buttonList = {
        },
        name = "coin_node",
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
                    width = 193,
                    height = 48,
                },
                frame = "kuang_2.png",
                type = "BLSprite",
                name = "coin_bg",
            },
            {
                content_size = {
                    width = 200,
                    height = 41,
                },
                frame = "kuang_3.png",
                type = "BLSprite",
                name = "kuang_3",
                position = {
                    y = 0.0,
                    x = -4.358,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 58,
                    height = 52,
                },
                frame = "icon_coin.png",
                type = "BLSprite",
                name = "sp_coin",
                position = {
                    y = -0.4,
                    x = -94.829,
                    z = 0,
                },
            },
            {
                horizontal_align = 0,
                font_size = 32,
                name = "label_coins",
                content_size = {
                    width = 125,
                    height = 32,
                },
                vertical_align = 1,
                text = "133,606,490",
                lineHeight = 32,
                position = {
                    y = 5.746,
                    x = 7.806,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme230/ad_reward/fonts2/coin_num.fnt",
            },
        },
    },
}