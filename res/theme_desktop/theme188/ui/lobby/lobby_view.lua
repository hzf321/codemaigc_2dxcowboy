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
                position = {
                    y = 0,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "bg_node",
                children = {
                    {
                        position = {
                            y = 0,
                            x = 0,
                            z = 0,
                        },
                        type = "BLNode",
                        name = "bg_temp",
                        children = {
                            {
                                content_size = {
                                    width = 1560,
                                    height = 720,
                                },
                                type = "BLSprite",
                                name = "bg_2",
                                texture = "theme188/lobby/textures/bg_2.jpg",
                                position = {
                                    y = 0.0,
                                    x = 1560.0,
                                    z = 0,
                                },
                            },
                            {
                                content_size = {
                                    width = 1560,
                                    height = 719,
                                },
                                type = "BLSprite",
                                name = "bg_1",
                                texture = "theme188/lobby/textures/bg_1.jpg",
                                children = {
                                    {
                                        spine = {
                                            defaultSkin = "default",
                                            isLoop = true,
                                            animation = "stop",
                                            name = "theme188/login/spines/god/spine",
                                        },
                                        content_size = {
                                            width = 776.08,
                                            height = 1231.1,
                                        },
                                        type = "BLSpine",
                                        name = "spine",
                                        position = {
                                            y = 359.5,
                                            x = 780.0,
                                            z = 0,
                                        },
                                    },
                                },
                            },
                        },
                    },
                    {
                        content_size = {
                            width = 1560,
                            height = 720,
                        },
                        type = "BLSprite",
                        name = "lobby_bg",
                        texture = "theme188/lobby/textures/bg_3.jpg",
                        position = {
                            y = 0.0,
                            x = 3120.0,
                            z = 0,
                        },
                    },
                },
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