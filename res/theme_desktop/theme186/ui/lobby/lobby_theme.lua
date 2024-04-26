return 
{
    {
        plist = {
            "theme186/lobby/packs/lobby.plist",
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
                    width = 673,
                    height = 358,
                },
                frame = "rukou_1.png",
                type = "BLSprite",
                name = "theme_logo",
            },
            {
                scale = {
                    y = 28.754,
                    x = 64.56,
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
                    y = -33.0,
                    x = 0.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 6,
            },
        },
    },
}