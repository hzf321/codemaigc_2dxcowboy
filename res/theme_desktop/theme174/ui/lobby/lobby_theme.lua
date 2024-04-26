return 
{
    {
        plist = {
            "theme174/lobby/packs/lobby.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_enter",
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
                content_size = {
                    width = 439,
                    height = 520,
                },
                frame = "rukou_1.png",
                type = "BLSprite",
                name = "theme_logo",
                position = {
                    y = -6.0,
                    x = -59.0,
                    z = 0,
                },
            },
            {
                name = "starAnim",
                spine = {
                    defaultSkin = "default",
                    isLoop = false,
                    animation = "",
                    name = "theme174/login/spines/star/Tongyong_xingxing",
                },
                content_size = {
                    width = 270.5,
                    height = 270.5,
                },
                visible = false,
                position = {
                    y = -148.299,
                    x = -78.89,
                    z = 0,
                },
                type = "BLSpine",
            },
            {
                scale = {
                    y = 52.8,
                    x = 38.3,
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
                    y = -7.93,
                    x = -59.897,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 9,
            },
            {
                content_size = {
                    width = 394,
                    height = 162,
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
        },
    },
}