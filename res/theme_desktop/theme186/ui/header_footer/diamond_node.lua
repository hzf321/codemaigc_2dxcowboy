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
                    width = 181,
                    height = 41,
                },
                frame = "kuang_2.png",
                type = "BLSprite",
                name = "diamond_bg",
            },
            {
                content_size = {
                    width = 52,
                    height = 55,
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
                    name = "theme186/header_footer/spines/chip/spine",
                },
                content_size = {
                    width = 120,
                    height = 120,
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
                font_size = 21,
                name = "label_diamonds",
                content_size = {
                    width = 14,
                    height = 21,
                },
                vertical_align = 0,
                text = "0",
                lineHeight = 21,
                position = {
                    y = -2.246,
                    x = 7.0,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme186/ad_reward/fonts/coin_num.fnt",
            },
        },
    },
}