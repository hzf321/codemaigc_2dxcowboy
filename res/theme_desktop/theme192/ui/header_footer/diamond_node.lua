return 
{
    {
        plist = {
            "theme192/header_footer/packs/header.plist",
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
                    height = 50,
                },
                frame = "kuang_2.png",
                type = "BLSprite",
                name = "diamond_bg",
            },
            {
                content_size = {
                    width = 50,
                    height = 58,
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
                    width = 13,
                    height = 32,
                },
                vertical_align = 0,
                text = "0",
                lineHeight = 32,
                position = {
                    y = 3.019,
                    x = -0.028,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme192/ad_reward/fonts/coin_num.fnt",
            },
        },
    },
}