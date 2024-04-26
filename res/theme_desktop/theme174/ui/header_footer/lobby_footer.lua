return 
{
    {
        plist = {
            "theme174/header_footer/packs/footer.plist",
            "theme174/header_footer/packs/header.plist",
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
                    y = -10,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "bg_node",
                children = {
                    {
                        scale = {
                            y = 1,
                            x = -1,
                        },
                        name = "right_bg",
                        content_size = {
                            width = 1560,
                            height = 81,
                        },
                        frame = "dating_2.png",
                        position = {
                            y = 38.5,
                            x = 0.0,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                },
            },
            {
                position = {
                    y = 19.52,
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
                            y = 35.742,
                            x = -543.732,
                            z = 0,
                        },
                        frame_normal = "icon_1.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 9,
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
                            y = 35.742,
                            x = -379.718,
                            z = 0,
                        },
                        frame_normal = "icon_2.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 15,
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
                            y = 35.742,
                            x = -215.236,
                            z = 0,
                        },
                        frame_normal = "icon_3.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 22,
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
                            y = 49.951,
                            x = -0.93,
                            z = 0,
                        },
                        frame_normal = "icon_6.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 29,
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
                            y = 35.742,
                            x = 217.062,
                            z = 0,
                        },
                        frame_normal = "icon_4.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 36,
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
                            y = 35.742,
                            x = 381.311,
                            z = 0,
                        },
                        frame_normal = "icon_5.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 43,
                    },
                    {
                        name = "btn_friends",
                        frame_disable = "icon_7.png",
                        content_size = {
                            width = 127,
                            height = 135,
                        },
                        frame_down = "icon_7.png",
                        position = {
                            y = 35.742,
                            x = 546.393,
                            z = 0,
                        },
                        frame_normal = "icon_7.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 50,
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
                        scale = {
                            y = 0.8,
                            x = 0.8,
                        },
                        name = "tip_bg",
                        content_size = {
                            width = 204,
                            height = 137,
                        },
                        frame = "unlock_2.png",
                        position = {
                            y = 67.0,
                            x = 0.0,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                    {
                        scale = {
                            y = 0.6,
                            x = 0.6,
                        },
                        name = "icon_diamond",
                        content_size = {
                            width = 48,
                            height = 52,
                        },
                        frame = "icon_zuanshi.png",
                        position = {
                            y = 59.317,
                            x = -33.987,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                    {
                        horizontal_align = 0,
                        font_size = 26,
                        name = "label_diamonds",
                        content_size = {
                            width = 57.75,
                            height = 26,
                        },
                        vertical_align = 0,
                        text = "1000",
                        lineHeight = 26,
                        position = {
                            y = 58.293,
                            x = 27.631,
                            z = 0,
                        },
                        overflow = 0,
                        type = "BLBMFont",
                        font_name = "theme174/lobby/fonts/tip_num.fnt",
                    },
                },
            },
        },
    },
}