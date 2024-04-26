return 
{
    {
        plist = {
            "theme177/header_footer/packs/header.plist",
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
                    height = 44,
                },
                frame = "kuang_2.png",
                type = "BLSprite",
                name = "coin_bg",
            },
            {
                content_size = {
                    width = 48,
                    height = 47,
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
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme177/header_footer/spines/coin/spine",
                },
                content_size = {
                    width = 84,
                    height = 84,
                },
                type = "BLSpine",
                name = "anim",
                position = {
                    y = 1.874,
                    x = -81.053,
                    z = 0,
                },
            },
            {
                horizontal_align = 0,
                font_size = 32,
                name = "label_coins",
                content_size = {
                    width = 118,
                    height = 32,
                },
                vertical_align = 1,
                text = "123,456,789",
                lineHeight = 32,
                position = {
                    y = 0.0,
                    x = 7.0,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme177/ad_reward/fonts/coin_num.fnt",
            },
        },
    },
}