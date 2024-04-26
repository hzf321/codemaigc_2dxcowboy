return 
{
    {
        plist = {
            "theme164/header_footer/packs/header.plist",
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
                    width = 202,
                    height = 41,
                },
                frame = "kuang_2.png",
                type = "BLSprite",
                name = "coin_bg",
            },
            {
                content_size = {
                    width = 52,
                    height = 51,
                },
                frame = "icon_coin.png",
                type = "BLSprite",
                name = "sp_coin",
                position = {
                    y = -0.4,
                    x = -85.58,
                    z = 0,
                },
            },
            {
                horizontal_align = 0,
                font_size = 32,
                name = "label_coins",
                content_size = {
                    width = 15,
                    height = 32,
                },
                vertical_align = 1,
                text = "0",
                lineHeight = 32,
                position = {
                    y = 4.453,
                    x = 2.431,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme164/ad_reward/fonts/coin_num.fnt",
            },
            {
                name = "starAnim",
                spine = {
                    defaultSkin = "default",
                    isLoop = false,
                    animation = "",
                    name = "theme164/login/spines/star/Tongyong_xingxing",
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