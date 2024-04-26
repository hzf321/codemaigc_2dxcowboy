return 
{
    {
        plist = {
            "theme186/header_footer/packs/header.plist",
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
                    width = 181,
                    height = 41,
                },
                frame = "kuang_2.png",
                type = "BLSprite",
                name = "coin_bg",
            },
            {
                content_size = {
                    width = 50,
                    height = 55,
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
                    name = "theme186/header_footer/spines/coin/spine",
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
                font_size = 21,
                name = "label_coins",
                content_size = {
                    width = 76,
                    height = 21,
                },
                vertical_align = 1,
                text = "123456",
                lineHeight = 21,
                position = {
                    y = -2.114,
                    x = 12.16,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme186/ad_reward/fonts/coin_num.fnt",
            },
        },
    },
}