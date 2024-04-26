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
        name = "lobby_view",
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
                    width = 720,
                    height = 1560,
                },
                type = "BLSprite",
                name = "bg",
                texture = "theme186/lobby/textures/bg.png",
            },
            {
                position = {
                    y = 0,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "animBox",
            },
            {
                position = {
                    y = 265.242,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "themePlay",
                children = {
                    {
                        content_size = {
                            width = 673,
                            height = 358,
                        },
                        frame = "rukou_1.png",
                        type = "BLSprite",
                        name = "rukou",
                        position = {
                            y = 33.625,
                            x = 0.0,
                            z = 0,
                        },
                    },
                },
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
                    y = 263.043,
                    x = 0.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 13,
            },
            {
                name = "theme_sv",
                content_size = {
                    width = 677,
                    height = 609,
                },
                scrollView = {
                    viewSize = {
                        width = 677,
                        height = 609,
                    },
                    direction = 1,
                    inertia = true,
                    elastic = true,
                },
                position = {
                    y = -187.538,
                    x = 4.0,
                    z = 0,
                },
                type = "BLScrollView",
            },
        },
    },
}