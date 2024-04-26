return 
{
    {
        plist = {
            "theme220/header_footer/packs/header.plist",
            "theme220/lobby/packs/lobby.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_setting",
            },
            {
                path = "root.btn_adv",
            },
            {
                path = "root.warehouse_node.btn_adventure",
            },
            {
                path = "root.warehouse_node.btn_vip",
            },
            {
                path = "root.warehouse_node.btn_treasure",
            },
            {
                path = "root.btn_freecoin",
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
                content_size = {
                    width = 720,
                    height = 208,
                },
                frame = "dating_1.png",
                type = "BLSprite",
                name = "bg",
                position = {
                    y = 68.0,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 102,
                    height = 128,
                },
                frame = "head.png",
                type = "BLSprite",
                name = "head",
                position = {
                    y = -18.688,
                    x = -280.0,
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
                    y = 3.063,
                    x = 304.248,
                    z = 0,
                },
                frame_normal = "icon_shezhi.png",
                type = "BLButton",
                children = {
                },
                target = 9,
            },
            {
                name = "btn_adv",
                frame_disable = "icon_6.png",
                content_size = {
                    width = 79,
                    height = 77,
                },
                frame_down = "icon_6.png",
                position = {
                    y = -85.653,
                    x = -83.651,
                    z = 0,
                },
                frame_normal = "icon_6.png",
                type = "BLButton",
                children = {
                },
                target = 16,
            },
            {
                position = {
                    y = -70,
                    x = 102,
                    z = 0,
                },
                type = "BLNode",
                name = "warehouse_node",
                children = {
                    {
                        name = "btn_adventure",
                        frame_disable = "icon_7.png",
                        content_size = {
                            width = 79,
                            height = 77,
                        },
                        frame_down = "icon_7.png",
                        position = {
                            y = -15.628,
                            x = -88.333,
                            z = 0,
                        },
                        frame_normal = "icon_7.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 24,
                    },
                    {
                        name = "btn_vip",
                        frame_disable = "icon_8.png",
                        content_size = {
                            width = 79,
                            height = 77,
                        },
                        frame_down = "icon_8.png",
                        position = {
                            y = -16.888,
                            x = 8.695,
                            z = 0,
                        },
                        frame_normal = "icon_8.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 31,
                    },
                    {
                        name = "btn_treasure",
                        frame_disable = "icon_9.png",
                        content_size = {
                            width = 79,
                            height = 77,
                        },
                        frame_down = "icon_9.png",
                        position = {
                            y = -16.484,
                            x = 107.696,
                            z = 0,
                        },
                        frame_normal = "icon_9.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 38,
                    },
                },
            },
            {
                name = "btn_freecoin",
                frame_disable = "icon_10.png",
                content_size = {
                    width = 79,
                    height = 77,
                },
                frame_down = "icon_10.png",
                position = {
                    y = -85.692,
                    x = 307.91,
                    z = 0,
                },
                frame_normal = "icon_10.png",
                type = "BLButton",
                children = {
                },
                target = 46,
            },
            {
                position = {
                    y = -176,
                    x = 203.271,
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
                            width = 45,
                            height = 53,
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
                            width = 58,
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
                        font_name = "theme220/lobby/fonts/tip_num.fnt",
                    },
                },
            },
        },
    },
}