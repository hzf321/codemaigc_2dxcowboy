return 
{
    {
        plist = {
            "theme174/lobby/packs/lobby.plist",
            "theme174/header_footer/packs/header.plist",
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
                    width = 281,
                    height = 471,
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
                    y = -117.339,
                    x = 0.0,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        content_size = {
                            width = 50,
                            height = 70,
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
                            width = 224,
                            height = 118,
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
                            y = 0.8,
                            x = 0.8,
                        },
                        name = "diamonds_logo",
                        content_size = {
                            width = 48,
                            height = 52,
                        },
                        frame = "icon_zuanshi.png",
                        position = {
                            y = -18.497,
                            x = 82.548,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                    {
                        horizontal_align = 0,
                        font_size = 32,
                        name = "label_diamonds",
                        content_size = {
                            width = 69,
                            height = 32,
                        },
                        vertical_align = 1,
                        text = "1000",
                        lineHeight = 32,
                        position = {
                            y = -18.996,
                            x = 148.705,
                            z = 0,
                        },
                        overflow = 0,
                        type = "BLBMFont",
                        font_name = "theme174/lobby/fonts/tip_num.fnt",
                    },
                },
            },
        },
    },
}