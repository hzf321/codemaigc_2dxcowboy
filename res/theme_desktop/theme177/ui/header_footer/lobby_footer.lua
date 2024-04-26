return 
{
    {
        plist = {
            "theme177/header_footer/packs/footer.plist",
            "theme177/header_footer/packs/header.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.warehouse_node.btn_club",
            },
            {
                path = "root.warehouse_node.btn_world",
            },
            {
                path = "root.warehouse_node.btn_arena",
            },
            {
                path = "root.warehouse_node.btn_collection",
            },
            {
                path = "root.warehouse_node.btn_missions",
            },
            {
                path = "root.warehouse_node.btn_lounge",
            },
            {
                path = "root.warehouse_node.btn_friends",
            },
        },
        name = "lobby_footer",
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
                        content_size = {
                            width = 780,
                            height = 75,
                        },
                        frame = "dating_2.png",
                        type = "BLSprite",
                        name = "left_bg",
                        position = {
                            y = 38.5,
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
                            height = 75,
                        },
                        frame = "dating_2.png",
                        position = {
                            y = 38.5,
                            x = 390.0,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                },
            },
            {
                position = {
                    y = 0,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "warehouse_node",
                children = {
                    {
                        name = "btn_club",
                        frame_disable = "icon_1.png",
                        content_size = {
                            width = 133,
                            height = 145,
                        },
                        frame_down = "icon_1.png",
                        position = {
                            y = 50.76,
                            x = -533.147,
                            z = 0,
                        },
                        frame_normal = "icon_1.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 12,
                    },
                    {
                        name = "btn_world",
                        frame_disable = "icon_2.png",
                        content_size = {
                            width = 122,
                            height = 109,
                        },
                        frame_down = "icon_2.png",
                        position = {
                            y = 36.98,
                            x = -361.886,
                            z = 0,
                        },
                        frame_normal = "icon_2.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 18,
                    },
                    {
                        name = "btn_arena",
                        frame_disable = "icon_4.png",
                        content_size = {
                            width = 122,
                            height = 101,
                        },
                        frame_down = "icon_3.png",
                        position = {
                            y = 42.265,
                            x = -229.275,
                            z = 0,
                        },
                        frame_normal = "icon_3.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 25,
                    },
                    {
                        name = "btn_collection",
                        frame_disable = "icon_6.png",
                        content_size = {
                            width = 122,
                            height = 105,
                        },
                        frame_down = "icon_6.png",
                        position = {
                            y = 65.508,
                            x = -0.992,
                            z = 0,
                        },
                        frame_normal = "icon_6.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 32,
                    },
                    {
                        name = "btn_missions",
                        frame_disable = "icon_4.png",
                        content_size = {
                            width = 122,
                            height = 109,
                        },
                        frame_down = "icon_4.png",
                        position = {
                            y = 47.38,
                            x = 238.107,
                            z = 0,
                        },
                        frame_normal = "icon_4.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 39,
                    },
                    {
                        name = "btn_lounge",
                        frame_disable = "icon_5.png",
                        content_size = {
                            width = 122,
                            height = 107,
                        },
                        frame_down = "icon_5.png",
                        position = {
                            y = 43.213,
                            x = 366.418,
                            z = 0,
                        },
                        frame_normal = "icon_5.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 46,
                    },
                    {
                        name = "btn_friends",
                        frame_disable = "icon_9.png",
                        content_size = {
                            width = 127,
                            height = 135,
                        },
                        frame_down = "icon_9.png",
                        position = {
                            y = 54.744,
                            x = 543.086,
                            z = 0,
                        },
                        frame_normal = "icon_9.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 53,
                    },
                },
            },
            {
                position = {
                    y = 89.54,
                    x = -360.56,
                    z = 0,
                },
                type = "BLNode",
                name = "tip_node",
                children = {
                    {
                        content_size = {
                            width = 236,
                            height = 172,
                        },
                        frame = "unlock_2.png",
                        type = "BLSprite",
                        name = "tip_bg",
                        position = {
                            y = 67.0,
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
                            width = 43,
                            height = 50,
                        },
                        frame = "icon_zuanshi.png",
                        position = {
                            y = 65.254,
                            x = -28.128,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                    {
                        horizontal_align = 0,
                        font_size = 30,
                        name = "label_diamonds",
                        content_size = {
                            width = 58.13,
                            height = 30,
                        },
                        vertical_align = 0,
                        text = "1000",
                        lineHeight = 30,
                        position = {
                            y = 59.457,
                            x = 22.919,
                            z = 0,
                        },
                        overflow = 0,
                        type = "BLBMFont",
                        font_name = "theme177/lobby/fonts/tip_num.fnt",
                    },
                },
            },
        },
    },
}