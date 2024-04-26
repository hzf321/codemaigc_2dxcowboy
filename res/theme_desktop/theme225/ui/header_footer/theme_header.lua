return 
{
    {
        plist = {
            "theme225/header_footer/packs/header.plist",
            "theme225/lobby/packs/lobby.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_lobby",
            },
            {
                path = "root.advertise_node.btn_freecoin",
            },
            {
                path = "root.btn_themevip",
            },
            {
                path = "root.btn_hunting",
            },
            {
                path = "root.btn_adv",
            },
            {
                path = "root.btn_setting",
            },
        },
        name = "header_node",
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
                scale = {
                    y = 1,
                    x = -1,
                },
                name = "bg_right",
                content_size = {
                    width = 780,
                    height = 81,
                },
                frame = "lobby_header_back01.png",
                position = {
                    y = -30.785,
                    x = 389.0,
                    z = 0,
                },
                type = "BLSprite",
            },
            {
                content_size = {
                    width = 780,
                    height = 81,
                },
                frame = "lobby_header_back01.png",
                type = "BLSprite",
                name = "bg_left",
                position = {
                    y = -30.785,
                    x = -390.0,
                    z = 0,
                },
            },
            {
                name = "btn_lobby",
                frame_disable = "icon_zhuye.png",
                content_size = {
                    width = 58,
                    height = 58,
                },
                frame_down = "icon_zhuye.png",
                position = {
                    y = -34.036,
                    x = -525.812,
                    z = 0,
                },
                frame_normal = "icon_zhuye.png",
                type = "BLButton",
                children = {
                },
                target = 9,
            },
            {
                position = {
                    y = -33.551,
                    x = 465.149,
                    z = 0,
                },
                scale = {
                    y = 0.8,
                    x = 0.8,
                },
                type = "BLNode",
                name = "advertise_node",
                children = {
                    {
                        name = "btn_freecoin",
                        frame_disable = "icon_10.png",
                        content_size = {
                            width = 10,
                            height = 10,
                        },
                        frame_down = "icon_10.png",
                        position = {
                            y = 7.073,
                            x = 0.0,
                            z = 0,
                        },
                        frame_normal = "icon_10.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 17,
                    },
                },
            },
            {
                scale = {
                    y = 0.8,
                    x = 0.8,
                },
                name = "btn_themevip",
                frame_disable = "icon_8.png",
                content_size = {
                    width = 79,
                    height = 77,
                },
                frame_down = "icon_8.png",
                position = {
                    y = -28.563,
                    x = 345.343,
                    z = 0,
                },
                frame_normal = "icon_8.png",
                type = "BLButton",
                children = {
                },
                target = 25,
            },
            {
                scale = {
                    y = 0.8,
                    x = 0.8,
                },
                name = "btn_hunting",
                frame_disable = "icon_7.png",
                content_size = {
                    width = 79,
                    height = 77,
                },
                frame_down = "icon_7.png",
                position = {
                    y = -28.544,
                    x = 226.869,
                    z = 0,
                },
                frame_normal = "icon_7.png",
                type = "BLButton",
                children = {
                },
                target = 32,
            },
            {
                scale = {
                    y = 0.8,
                    x = 0.8,
                },
                name = "btn_adv",
                frame_disable = "icon_6.png",
                content_size = {
                    width = 79,
                    height = 77,
                },
                frame_down = "icon_6.png",
                position = {
                    y = -27.534,
                    x = 111.816,
                    z = 0,
                },
                frame_normal = "icon_6.png",
                type = "BLButton",
                children = {
                },
                target = 39,
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
                    y = -31.116,
                    x = 566.669,
                    z = 0,
                },
                frame_normal = "icon_shezhi.png",
                type = "BLButton",
                children = {
                },
                target = 46,
            },
            {
                position = {
                    y = -113.333,
                    x = 157.547,
                    z = 0,
                },
                type = "BLNode",
                name = "tip_node",
                children = {
                    {
                        content_size = {
                            width = 261,
                            height = 203,
                        },
                        frame = "unlock_3.png",
                        type = "BLSprite",
                        name = "tip_bg",
                        position = {
                            y = -44.0,
                            x = 0.0,
                            z = 0,
                        },
                    },
                    {
                        scale = {
                            y = 0.9,
                            x = 0.9,
                        },
                        name = "icon_diamond",
                        content_size = {
                            width = 35,
                            height = 52,
                        },
                        frame = "icon_zuanshi.png",
                        position = {
                            y = -72.285,
                            x = -32.885,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                    {
                        horizontal_align = 0,
                        font_size = 32,
                        name = "label_diamonds",
                        content_size = {
                            width = 67,
                            height = 32,
                        },
                        vertical_align = 0,
                        text = "1000",
                        lineHeight = 32,
                        position = {
                            y = -68.32,
                            x = 25.826,
                            z = 0,
                        },
                        overflow = 0,
                        type = "BLBMFont",
                        font_name = "theme225/lobby/fonts/tip_num.fnt",
                    },
                },
            },
        },
    },
}