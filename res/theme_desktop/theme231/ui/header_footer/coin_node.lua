return 
{
    {
        plist = {
            "theme231/header_footer/packs/header.plist",
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
                    width = 228,
                    height = 43,
                },
                frame = "kuang_2.png",
                type = "BLSprite",
                name = "coin_bg",
            },
            {
                content_size = {
                    width = 54,
                    height = 54,
                },
                frame = "icon_coin.png",
                type = "BLSprite",
                name = "sp_coin",
                position = {
                    y = -1.648,
                    x = -94.318,
                    z = 0,
                },
            },
            {
                horizontal_align = 0,
                font_size = 32,
                name = "label_coins",
                content_size = {
                    width = 40,
                    height = 32,
                },
                vertical_align = 1,
                text = "123",
                lineHeight = 32,
                position = {
                    y = 1.123,
                    x = 2.431,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme231/ad_reward/fonts/coin_num.fnt",
            },
            {
                name = "starAnim",
                spine = {
                    defaultSkin = "default",
                    isLoop = false,
                    animation = "",
                    name = "theme231/login/spines/star/Tongyong_xingxing",
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