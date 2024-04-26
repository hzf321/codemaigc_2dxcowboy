return 
{
    {
        plist = {
            "theme220/header_footer/packs/header.plist",
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
                    width = 177,
                    height = 39,
                },
                frame = "kuang_2.png",
                type = "BLSprite",
                name = "coin_bg",
            },
            {
                content_size = {
                    width = 50,
                    height = 48,
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
                font_size = 32,
                name = "label_coins",
                content_size = {
                    width = 77,
                    height = 32,
                },
                vertical_align = 1,
                text = "123456",
                lineHeight = 32,
                position = {
                    y = 3.019,
                    x = -0.028,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme220/ad_reward/fonts/coin_num.fnt",
            },
        },
    },
}