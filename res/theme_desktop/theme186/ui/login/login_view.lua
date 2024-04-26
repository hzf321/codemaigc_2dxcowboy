return 
{
    {
        plist = {
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_play",
            },
        },
        name = "login_view",
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
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "",
                    name = "theme186/login/spines/rearBg/spine",
                },
                content_size = {
                    width = 0,
                    height = 0,
                },
                type = "BLSpine",
                name = "rearBg",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "Loading",
                    name = "theme186/login/spines/frontBg/spine",
                },
                content_size = {
                    width = 0,
                    height = 0,
                },
                type = "BLSpine",
                name = "frontBg",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "",
                    name = "theme186/login/spines/logoAnim/spine",
                },
                content_size = {
                    width = 425.65,
                    height = 1374.42,
                },
                type = "BLSpine",
                name = "logoAnim",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "",
                    name = "theme186/login/spines/loginBtn/spine",
                },
                content_size = {
                    width = 699.29,
                    height = 414.82,
                },
                type = "BLSpine",
                name = "btnAnim",
                position = {
                    y = -307.607,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                scale = {
                    y = 11.349,
                    x = 41.679,
                },
                name = "btn_play",
                texture_disable = "commonpics/kong.png",
                content_size = {
                    width = 10,
                    height = 10,
                },
                texture_normal = "commonpics/kong.png",
                texture_down = "commonpics/kong.png",
                position = {
                    y = -305.081,
                    x = 0.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 15,
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "",
                    name = "theme186/login/spines/tansition/spine",
                },
                content_size = {
                    width = 3605.13,
                    height = 3733.08,
                },
                type = "BLSpine",
                name = "tansitionAnim",
            },
        },
    },
}