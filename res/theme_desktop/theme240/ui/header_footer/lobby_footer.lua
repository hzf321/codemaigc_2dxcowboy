return 
{
    {
        plist = {
            "theme240/header_footer/packs/footer.plist",
            "theme240/header_footer/packs/header.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.warehouse_node.btn_friends",
            },
            {
                path = "root.warehouse_node.btn_lounge",
            },
            {
                path = "root.warehouse_node.btn_world",
            },
            {
                path = "root.warehouse_node.btn_collection",
            },
            {
                path = "root.warehouse_node.btn_arena",
            },
            {
                path = "root.warehouse_node.btn_missions",
            },
            {
                path = "root.warehouse_node.btn_club",
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
                content_size = {
                    width = 1560,
                    height = 74,
                },
                frame = "dating_2.png",
                type = "BLSprite",
                name = "bg_node",
                position = {
                    y = 28.5,
                    x = 0.0,
                    z = 0,
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
                        name = "btn_friends",
                        frame_disable = "icon_7.png",
                        content_size = {
                            width = 127,
                            height = 135,
                        },
                        frame_down = "icon_7.png",
                        position = {
                            y = 54.783,
                            x = -500.0,
                            z = 0,
                        },
                        frame_normal = "icon_7.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 7,
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
                            y = 54.084,
                            x = -354.459,
                            z = 0,
                        },
                        frame_normal = "icon_5.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 14,
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
                            y = 54.499,
                            x = -208.566,
                            z = 0,
                        },
                        frame_normal = "icon_2.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 21,
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
                            y = 49.411,
                            x = 1.008,
                            z = 0,
                        },
                        frame_normal = "icon_6.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 28,
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
                            y = 54.027,
                            x = 205.89,
                            z = 0,
                        },
                        frame_normal = "icon_3.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 35,
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
                            y = 54.084,
                            x = 350.809,
                            z = 0,
                        },
                        frame_normal = "icon_4.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 42,
                    },
                    {
                        name = "btn_club",
                        frame_disable = "icon_1.png",
                        content_size = {
                            width = 133,
                            height = 145,
                        },
                        frame_down = "icon_1.png",
                        position = {
                            y = 54.44,
                            x = 494.0,
                            z = 0,
                        },
                        frame_normal = "icon_1.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 49,
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
                            width = 242,
                            height = 174,
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
                            width = 49,
                            height = 47,
                        },
                        frame = "icon_zuanshi.png",
                        position = {
                            y = 59.533,
                            x = -44.019,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                    {
                        horizontal_align = 0,
                        font_size = 32,
                        name = "label_diamonds",
                        content_size = {
                            width = 57,
                            height = 32,
                        },
                        vertical_align = 0,
                        text = "1000",
                        lineHeight = 32,
                        position = {
                            y = 59.457,
                            x = 22.919,
                            z = 0,
                        },
                        overflow = 0,
                        type = "BLBMFont",
                        font_name = "theme240/lobby/fonts/tip_num.fnt",
                    },
                },
            },
        },
    },
}