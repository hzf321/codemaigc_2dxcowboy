return 
{
    {
        plist = {
            "theme188/header_footer/packs/header.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_setting",
            },
            {
                path = "root.facebook_node.btn_facebook",
            },
        },
        name = "lobby_header",
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
                    y = -38,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "bg_node",
                children = {
                    {
                        content_size = {
                            width = 780,
                            height = 76,
                        },
                        frame = "dating_1.png",
                        type = "BLSprite",
                        name = "left_bg",
                        position = {
                            y = 0.0,
                            x = -390.0,
                            z = 0,
                        },
                    },
                    {
                        scale = {
                            y = 1,
                            x = -1,
                        },
                        name = "right_bg",
                        content_size = {
                            width = 780,
                            height = 76,
                        },
                        frame = "dating_1.png",
                        position = {
                            y = 0.0,
                            x = 390.0,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                },
            },
            {
                content_size = {
                    width = 98,
                    height = 89,
                },
                frame = "head.png",
                type = "BLSprite",
                name = "player_head",
                position = {
                    y = -44.5,
                    x = -569.0,
                    z = 0,
                },
            },
            {
                name = "btn_setting",
                frame_disable = "icon_shezhi.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "icon_shezhi.png",
                position = {
                    y = -39.0,
                    x = 575.0,
                    z = 0,
                },
                frame_normal = "icon_shezhi.png",
                type = "BLButton",
                children = {
                },
                target = 14,
            },
            {
                position = {
                    y = -35,
                    x = 447.5,
                    z = 0,
                },
                type = "BLNode",
                name = "facebook_node",
                children = {
                    {
                        content_size = {
                            width = 96,
                            height = 62,
                        },
                        type = "BLSprite",
                        name = "facebook_node",
                        texture = "theme188/header_footer/textures/freecoins.png",
                    },
                    {
                        scale = {
                            y = 7,
                            x = 8.5,
                        },
                        name = "btn_facebook",
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
                        target = 25,
                    },
                },
            },
        },
    },
}