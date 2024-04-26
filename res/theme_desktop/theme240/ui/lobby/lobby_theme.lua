return 
{
    {
        plist = {
            "theme240/lobby/packs/lobby.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_enter",
            },
            {
                path = "root.noclick",
            },
        },
        name = "lobby_theme",
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
                name = "theme_logo",
                content_size = {
                    width = 683,
                    height = 510,
                },
                frame = "rukou_1.png",
                position = {
                    y = -6.0,
                    x = -59.0,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        content_size = {
                            width = 279,
                            height = 162,
                        },
                        frame = "rukou_1_02.png",
                        type = "BLSprite",
                        name = "rukou_1_02",
                        position = {
                            y = 112.056,
                            x = 341.5,
                            z = 0,
                        },
                    },
                },
            },
            {
                spine = {
                    defaultSkin = "",
                    isLoop = false,
                    animation = "",
                    name = "theme240/login/spines/star/Tongyong_xingxing",
                },
                content_size = {
                    width = 270.5,
                    height = 270.5,
                },
                type = "BLSpine",
                name = "starAnim",
                position = {
                    y = 151.338,
                    x = 174.43,
                    z = 0,
                },
            },
            {
                scale = {
                    y = 50,
                    x = 30,
                },
                name = "btn_enter",
                texture_disable = "commonpics/kong.png",
                content_size = {
                    width = 10,
                    height = 10,
                },
                texture_normal = "commonpics/kong.png",
                texture_down = "commonpics/kong.png",
                position = {
                    y = -12.93,
                    x = -121.897,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 12,
            },
            {
                content_size = {
                    width = 430,
                    height = 201,
                },
                frame = "unlock_1.png",
                type = "BLSprite",
                name = "tips",
                position = {
                    y = -108.0,
                    x = 158.0,
                    z = 0,
                },
            },
            {
                scale = {
                    y = 60,
                    x = 50,
                },
                name = "noclick",
                texture_disable = "commonpics/kong.png",
                content_size = {
                    width = 10,
                    height = 10,
                },
                texture_normal = "commonpics/kong.png",
                texture_down = "commonpics/kong.png",
                position = {
                    y = -12.93,
                    x = -121.897,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 22,
            },
        },
    },
}