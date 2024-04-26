return 
{
    {
        plist = {
        },
        controllerList = {
        },
        buttonList = {
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
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme177/lobby/spines/bg/spine",
                },
                content_size = {
                    width = 2662.16,
                    height = 1470.46,
                },
                type = "BLSpine",
                name = "bgAnim",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "",
                    name = "theme177/login/spines/cloud/spine",
                },
                content_size = {
                    width = 2590,
                    height = 2362,
                },
                type = "BLSpine",
                name = "cloudAnim",
                visible = false,
            },
            {
                content_size = {
                    width = 1280,
                    height = 720,
                },
                type = "BLScrollView",
                name = "theme_sv",
                scrollView = {
                    viewSize = {
                        width = 220,
                        height = 400,
                    },
                    direction = 0,
                    inertia = true,
                    elastic = true,
                },
            },
        },
    },
}