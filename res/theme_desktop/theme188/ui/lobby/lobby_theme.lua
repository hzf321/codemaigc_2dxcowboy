return 
{
    {
        plist = {
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
                content_size = {
                    width = 293,
                    height = 465,
                },
                type = "BLSprite",
                name = "hera-UI",
                texture = "theme188/lobby/textures/hera-UI.png",
                position = {
                    y = 19.344,
                    x = -18.377,
                    z = 0,
                },
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "loop",
                    name = "theme188/lobby/spines/enter/spine",
                },
                content_size = {
                    width = 457.02,
                    height = 724.98,
                },
                type = "BLSpine",
                name = "spine",
                position = {
                    y = -76.508,
                    x = -59.901,
                    z = 0,
                },
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "loop",
                    name = "theme188/lobby/spines/enterZeus/spine",
                },
                content_size = {
                    width = 403.55,
                    height = 396,
                },
                type = "BLSpine",
                name = "spine",
                position = {
                    y = -95.754,
                    x = -11.607,
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
                    y = 29.0,
                    x = -17.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 12,
            },
            {
                scale = {
                    y = 66.2,
                    x = 43.5,
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
                    y = 29.0,
                    x = -17.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 19,
            },
        },
    },
}