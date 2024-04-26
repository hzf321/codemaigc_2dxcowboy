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
        name = "diamond_node",
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
                    width = 200,
                    height = 41,
                },
                frame = "kuang_3.png",
                type = "BLSprite",
                name = "kuang_3",
                position = {
                    y = -2.124,
                    x = 3.745,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 223,
                    height = 47,
                },
                frame = "kuang_2.png",
                type = "BLSprite",
                name = "diamond_bg",
            },
            {
                content_size = {
                    width = 48,
                    height = 52,
                },
                frame = "icon_zuanshi.png",
                type = "BLSprite",
                name = "sp_diamond",
                position = {
                    y = -0.4,
                    x = -98.444,
                    z = 0,
                },
            },
            {
                horizontal_align = 0,
                font_size = 32,
                name = "label_diamonds",
                content_size = {
                    width = 16,
                    height = 32,
                },
                vertical_align = 0,
                text = "0",
                lineHeight = 32,
                position = {
                    y = 3.94,
                    x = 1.705,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme174/ad_reward/fonts/coin_num.fnt",
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
                    y = 12.534,
                    x = -87.867,
                    z = 0,
                },
                type = "BLSpine",
            },
        },
    },
}