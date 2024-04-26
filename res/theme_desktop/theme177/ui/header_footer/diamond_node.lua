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
                    height = 44,
                },
                frame = "kuang_2.png",
                type = "BLSprite",
                name = "diamond_bg",
            },
            {
                content_size = {
                    width = 43,
                    height = 50,
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
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme177/header_footer/spines/chip/spine",
                },
                content_size = {
                    width = 140,
                    height = 140,
                },
                type = "BLSpine",
                name = "anim",
                position = {
                    y = -0.39,
                    x = -84.006,
                    z = 0,
                },
            },
            {
                horizontal_align = 0,
                font_size = 32,
                name = "label_diamonds",
                content_size = {
                    width = 116,
                    height = 32,
                },
                vertical_align = 0,
                text = "123,256,897",
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