return 
{
    {
        plist = {
            "theme240/lobby/packs/lobby.plist",
            "theme240/header_footer/packs/header.plist",
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
                scale = {
                    y = 1,
                    x = -1,
                },
                name = "theme_logo",
                content_size = {
                    width = 306,
                    height = 451,
                },
                frame = "rukou_5.png",
                position = {
                    y = 0.0,
                    x = -53.186,
                    z = 0,
                },
                type = "BLSprite",
            },
            {
                name = "lock_spine",
                content_size = {
                    width = 250,
                    height = 121,
                },
                frame = "lock_1.png",
                position = {
                    y = -131.853,
                    x = -27.0,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        content_size = {
                            width = 51,
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
                position = {
                    y = 0.0,
                    x = -18.132,
                    z = 0,
                },
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
                            width = 260,
                            height = 157,
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
                            width = 49,
                            height = 47,
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
                            width = 57,
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
                        font_name = "theme240/lobby/fonts/tip_num.fnt",
                    },
                },
            },
        },
    },
}