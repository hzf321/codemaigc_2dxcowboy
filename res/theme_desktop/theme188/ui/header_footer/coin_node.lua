return 
{
    {
        plist = {
            "theme188/header_footer/packs/header.plist",
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
                    width = 188,
                    height = 37,
                },
                frame = "kuang_3.png",
                type = "BLSprite",
                name = "coin_bg",
            },
            {
                content_size = {
                    width = 44,
                    height = 40,
                },
                frame = "icon_coin.png",
                type = "BLSprite",
                name = "sp_coin",
                position = {
                    y = -0.4,
                    x = -82.0,
                    z = 0,
                },
            },
            {
                horizontal_align = 0,
                font_size = 21,
                name = "label_coins",
                content_size = {
                    width = 34.13,
                    height = 21,
                },
                vertical_align = 1,
                text = "123",
                lineHeight = 21,
                position = {
                    y = 1.5,
                    x = 3.265,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme188/ad_reward/fonts/coin_num.fnt",
            },
        },
    },
}