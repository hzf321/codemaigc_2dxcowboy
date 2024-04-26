return 
{
    {
        plist = {
            "theme186/lobby/packs/lobby.plist",
            "theme186/header_footer/packs/header.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_lock",
            },
        },
        name = "lobby_theme_lock",
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
                    width = 344,
                    height = 339,
                },
                frame = "rukou_2.png",
                type = "BLSprite",
                name = "theme_logo",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "",
                    name = "theme186/lobby/spines/lock/spine",
                },
                content_size = {
                    width = 327.11,
                    height = 256,
                },
                type = "BLSpine",
                name = "lock_spine",
                position = {
                    y = -54.319,
                    x = -4.0,
                    z = 0,
                },
            },
            {
                scale = {
                    y = 45,
                    x = 25,
                },
                name = "btn_lock",
                texture_disable = "commonpics/kong.png",
                content_size = {
                    width = 12,
                    height = 5,
                },
                texture_normal = "commonpics/kong.png",
                texture_down = "commonpics/kong.png",
                position = {
                    y = -23.0,
                    x = -3.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 9,
            },
            {
                position = {
                    y = -156.332,
                    x = -119.874,
                    z = 0,
                },
                type = "BLNode",
                name = "tip_node",
                children = {
                    {
                        content_size = {
                            width = 232,
                            height = 203,
                        },
                        frame = "unlock_3.png",
                        type = "BLSprite",
                        anchor = {
                            y = 0.5,
                            x = 0,
                        },
                        name = "tip_bg",
                    },
                    {
                        scale = {
                            y = 0.9,
                            x = 0.9,
                        },
                        name = "diamonds_logo",
                        content_size = {
                            width = 52,
                            height = 55,
                        },
                        frame = "icon_zuanshi.png",
                        position = {
                            y = -32.629,
                            x = 81.667,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                    {
                        horizontal_align = 0,
                        font_size = 32,
                        name = "label_diamonds",
                        content_size = {
                            width = 62,
                            height = 32,
                        },
                        vertical_align = 1,
                        text = "1000",
                        lineHeight = 32,
                        position = {
                            y = -37.818,
                            x = 142.175,
                            z = 0,
                        },
                        overflow = 0,
                        type = "BLBMFont",
                        font_name = "theme186/lobby/fonts/tip_num.fnt",
                    },
                },
            },
        },
    },
}