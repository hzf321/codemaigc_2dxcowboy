return 
{
    {
        plist = {
            "theme177/header_footer/packs/header.plist",
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
                            height = 85,
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
                            height = 85,
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
                    width = 86,
                    height = 99,
                },
                frame = "head.png",
                type = "BLSprite",
                name = "player_head",
                position = {
                    y = -36.792,
                    x = -555.511,
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
                    y = -29.929,
                    x = 561.898,
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
                    y = -34.289,
                    x = 29.025,
                    z = 0,
                },
                type = "BLNode",
                name = "facebook_node",
                children = {
                    {
                        content_size = {
                            width = 105,
                            height = 58,
                        },
                        type = "BLSprite",
                        name = "freecoin_icon",
                        texture = "theme177/header_footer/packs/freecoin.png",
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