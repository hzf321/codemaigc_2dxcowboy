return 
{
    {
        plist = {
            "theme188/lobby/packs/lobby.plist",
            "theme188/header_footer/packs/header.plist",
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
                    width = 229,
                    height = 451,
                },
                frame = "rukou_2.png",
                type = "BLSprite",
                name = "theme_logo",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "stop",
                    name = "theme188/lobby/spines/lock/spine",
                },
                content_size = {
                    width = 230.39,
                    height = 116.69,
                },
                type = "BLSpine",
                name = "lock_spine",
                position = {
                    y = -13.0,
                    x = 0.0,
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
                    width = 10,
                    height = 10,
                },
                texture_normal = "commonpics/kong.png",
                texture_down = "commonpics/kong.png",
                type = "BLButton",
                children = {
                },
                target = 9,
            },
            {
                position = {
                    y = -23,
                    x = 71.5,
                    z = 0,
                },
                type = "BLNode",
                name = "tip_node",
                children = {
                    {
                        content_size = {
                            width = 216,
                            height = 115,
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
                            width = 45,
                            height = 43,
                        },
                        frame = "icon_zuanshi.png",
                        position = {
                            y = -14.216,
                            x = 89.022,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                    {
                        horizontal_align = 0,
                        font_size = 32,
                        name = "label_diamonds",
                        content_size = {
                            width = 47,
                            height = 32,
                        },
                        vertical_align = 1,
                        text = "1000",
                        lineHeight = 32,
                        position = {
                            y = -19.405,
                            x = 138.899,
                            z = 0,
                        },
                        overflow = 0,
                        type = "BLBMFont",
                        font_name = "theme188/lobby/fonts/tip_num.fnt",
                    },
                },
            },
        },
    },
}