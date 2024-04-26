return 
{
    {
        plist = {
            "theme325/header_footer/packs/header.plist",
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
                    height = 40,
                },
                frame = "kuang_2.png",
                type = "BLSprite",
                name = "diamond_bg",
            },
            {
                content_size = {
                    width = 53,
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
                horizontal_align = 0,
                font_size = 32,
                name = "label_diamonds",
                content_size = {
                    width = 123,
                    height = 32,
                },
                vertical_align = 0,
                text = "123,256,897",
                lineHeight = 32,
                position = {
                    y = 4.453,
                    x = 9.907,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme325/ad_reward/fonts/coin_num.fnt",
            },
            {
                name = "starAnim",
                spine = {
                    defaultSkin = "default",
                    isLoop = false,
                    animation = "",
                    name = "theme325/login/spines/star/Tongyong_xingxing",
                },
                content_size = {
                    width = 270.5,
                    height = 270.5,
                },
                visible = false,
                position = {
                    y = 12.534,
                    x = -74.163,
                    z = 0,
                },
                type = "BLSpine",
            },
        },
    },
}