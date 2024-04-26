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
                    width = 193,
                    height = 48,
                },
                frame = "kuang_2.png",
                type = "BLSprite",
                name = "diamond_bg",
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
                    width = 49,
                    height = 56,
                },
                frame = "icon_zuanshi.png",
                type = "BLSprite",
                name = "sp_diamond",
                position = {
                    y = -0.4,
                    x = -84.529,
                    z = 0,
                },
            },
            {
                horizontal_align = 0,
                font_size = 32,
                name = "label_diamonds",
                content_size = {
                    width = 73,
                    height = 32,
                },
                vertical_align = 0,
                text = "123,12",
                lineHeight = 32,
                position = {
                    y = 5.746,
                    x = -0.028,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme230/ad_reward/fonts/coin_num.fnt",
            },
        },
    },
}