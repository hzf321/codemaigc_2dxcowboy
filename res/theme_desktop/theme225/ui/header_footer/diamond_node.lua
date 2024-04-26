return 
{
    {
        plist = {
            "theme225/header_footer/packs/header.plist",
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
                    width = 184,
                    height = 41,
                },
                frame = "kuang_3.png",
                type = "BLSprite",
                name = "diamond_bg",
            },
            {
                content_size = {
                    width = 35,
                    height = 52,
                },
                frame = "icon_zuanshi.png",
                type = "BLSprite",
                name = "sp_diamond",
                position = {
                    y = -0.4,
                    x = -84.793,
                    z = 0,
                },
            },
            {
                horizontal_align = 0,
                font_size = 32,
                name = "label_diamonds",
                content_size = {
                    width = 14,
                    height = 32,
                },
                vertical_align = 0,
                text = "0",
                lineHeight = 32,
                position = {
                    y = 2.019,
                    x = -0.028,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme225/ad_reward/fonts/coin_num.fnt",
            },
        },
    },
}