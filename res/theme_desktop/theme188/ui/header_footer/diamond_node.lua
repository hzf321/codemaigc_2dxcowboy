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
                    width = 188,
                    height = 37,
                },
                frame = "kuang_3.png",
                type = "BLSprite",
                name = "diamond_bg",
            },
            {
                content_size = {
                    width = 45,
                    height = 43,
                },
                frame = "icon_zuanshi.png",
                type = "BLSprite",
                name = "sp_diamond",
                position = {
                    y = -0.4,
                    x = -84.0,
                    z = 0,
                },
            },
            {
                horizontal_align = 0,
                font_size = 21,
                name = "label_diamonds",
                content_size = {
                    width = 13.13,
                    height = 21,
                },
                vertical_align = 0,
                text = "0",
                lineHeight = 21,
                position = {
                    y = 1.5,
                    x = 3.074,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme188/ad_reward/fonts/coin_num.fnt",
            },
        },
    },
}