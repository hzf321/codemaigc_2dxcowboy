return 
{
    {
        plist = {
            "theme325/lobby/packs/lobby.plist",
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
                    width = 484,
                    height = 508,
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
                type = "BLSpine",
                name = "starAnim",
                position = {
                    y = 201.948,
                    x = -145.8,
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
                target = 9,
            },
            {
                content_size = {
                    width = 428,
                    height = 198,
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