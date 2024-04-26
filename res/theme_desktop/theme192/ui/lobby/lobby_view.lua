return 
{
    {
        plist = {
            "theme192/lobby/packs/lobby.plist",
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
                scale = {
                    y = 1.3,
                    x = 1.3,
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
                                    width = 720,
                                    height = 1560,
                                },
                                type = "BLSprite",
                                name = "bg_2",
                                texture = "theme192/lobby/textures/bg2.png",
                                position = {
                                    y = -1559.9,
                                    x = 0.0,
                                    z = 0,
                                },
                            },
                            {
                                content_size = {
                                    width = 720,
                                    height = 1560,
                                },
                                type = "BLSprite",
                                name = "bg_1",
                                texture = "theme192/lobby/textures/bg1.png",
                                children = {
                                    {
                                        name = "man",
                                        content_size = {
                                            width = 820,
                                            height = 1209,
                                        },
                                        texture = "theme192/login/textures/apolo.png",
                                        visible = false,
                                        position = {
                                            y = 780.0,
                                            x = 360.0,
                                            z = 0,
                                        },
                                        type = "BLSprite",
                                    },
                                },
                            },
                        },
                    },
                    {
                        name = "lobby_bg",
                        content_size = {
                            width = 720,
                            height = 1560,
                        },
                        texture = "theme192/lobby/textures/bg3.png",
                        position = {
                            y = -3120.0,
                            x = 0.0,
                            z = 0,
                        },
                        type = "BLSprite",
                        children = {
                            {
                                spine = {
                                    defaultSkin = "default",
                                    isLoop = true,
                                    animation = "animation",
                                    name = "theme192/login/spines/Tongyong_baowu",
                                },
                                content_size = {
                                    width = 1448.73,
                                    height = 603.7,
                                },
                                type = "BLSpine",
                                name = "mist",
                                position = {
                                    y = 780.0,
                                    x = 360.0,
                                    z = 0,
                                },
                            },
                        },
                    },
                },
            },
            {
                position = {
                    y = 255.664,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "themePlay",
                children = {
                    {
                        content_size = {
                            width = 683,
                            height = 438,
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
                    y = 255.664,
                    x = 0.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 27,
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
                    y = -218.592,
                    x = 0.0,
                    z = 0,
                },
                type = "BLScrollView",
            },
            {
                scale = {
                    y = 200,
                    x = 100,
                },
                name = "noclick",
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
                target = 42,
            },
        },
    },
}