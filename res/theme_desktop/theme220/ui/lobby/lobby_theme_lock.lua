return 
{
    {
        plist = {
            "theme220/lobby/packs/lobby.plist",
            "theme220/header_footer/packs/header.plist",
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
                    width = 341,
                    height = 381,
                },
                frame = "rukou_2.png",
                type = "BLSprite",
                name = "theme_logo",
            },
            {
                name = "lock_spine",
                content_size = {
                    width = 312,
                    height = 152,
                },
                frame = "lock_1.png",
                position = {
                    y = -98.319,
                    x = -4.0,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        content_size = {
                            width = 53,
                            height = 80,
                        },
                        frame = "lock_2.png",
                        type = "BLSprite",
                        name = "lock",
                        position = {
                            y = 76.0,
                            x = 156.0,
                            z = 0,
                        },
                    },
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
                target = 12,
            },
            {
                position = {
                    y = -214.332,
                    x = -135.874,
                    z = 0,
                },
                type = "BLNode",
                name = "tip_node",
                children = {
                    {
                        content_size = {
                            width = 261,
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
                        font_name = "theme220/lobby/fonts/tip_num.fnt",
                    },
                },
            },
        },
    },
}