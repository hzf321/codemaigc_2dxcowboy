return 
{
    {
        plist = {
            "theme164/lobby/packs/lobby.plist",
            "theme164/header_footer/packs/header.plist",
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
                    width = 304,
                    height = 504,
                },
                frame = "rukou_2.png",
                type = "BLSprite",
                name = "theme_logo",
            },
            {
                name = "lock_spine",
                content_size = {
                    width = 250,
                    height = 121,
                },
                frame = "lock_1.png",
                position = {
                    y = -142.014,
                    x = 0.0,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        content_size = {
                            width = 57,
                            height = 73,
                        },
                        frame = "lock_2.png",
                        type = "BLSprite",
                        name = "lock",
                        position = {
                            y = 60.5,
                            x = 125.0,
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
                    width = 10,
                    height = 10,
                },
                texture_normal = "commonpics/kong.png",
                texture_down = "commonpics/kong.png",
                type = "BLButton",
                children = {
                },
                target = 12,
            },
            {
                position = {
                    y = -134.567,
                    x = 58.218,
                    z = 0,
                },
                type = "BLNode",
                name = "tip_node",
                children = {
                    {
                        content_size = {
                            width = 256,
                            height = 154,
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
                            width = 53,
                            height = 50,
                        },
                        frame = "icon_zuanshi.png",
                        position = {
                            y = -20.851,
                            x = 101.008,
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
                            y = -21.858,
                            x = 162.923,
                            z = 0,
                        },
                        overflow = 0,
                        type = "BLBMFont",
                        font_name = "theme164/lobby/fonts/tip_num.fnt",
                    },
                },
            },
        },
    },
}