return 
{
    {
        plist = {
            "theme174/header_footer/packs/header.plist",
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
                    width = 223,
                    height = 47,
                },
                frame = "kuang_2.png",
                type = "BLSprite",
                name = "coin_bg",
            },
            {
                name = "kuang_3",
                content_size = {
                    width = 200,
                    height = 41,
                },
                frame = "kuang_3.png",
                visible = false,
                position = {
                    y = -2.124,
                    x = 3.745,
                    z = 0,
                },
                type = "BLSprite",
            },
            {
                content_size = {
                    width = 47,
                    height = 53,
                },
                frame = "icon_coin.png",
                type = "BLSprite",
                name = "sp_coin",
                position = {
                    y = -1.648,
                    x = -101.312,
                    z = 0,
                },
            },
            {
                horizontal_align = 0,
                font_size = 32,
                name = "label_coins",
                content_size = {
                    width = 85,
                    height = 32,
                },
                vertical_align = 1,
                text = "12,35,46",
                lineHeight = 32,
                position = {
                    y = 3.94,
                    x = 2.431,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme174/ad_reward/fonts2/coin_num.fnt",
            },
            {
                name = "starAnim",
                spine = {
                    defaultSkin = "default",
                    isLoop = false,
                    animation = "",
                    name = "theme174/login/spines/star/Tongyong_xingxing",
                },
                content_size = {
                    width = 270.5,
                    height = 270.5,
                },
                visible = false,
                position = {
                    y = 14.317,
                    x = -78.973,
                    z = 0,
                },
                type = "BLSpine",
            },
        },
    },
}