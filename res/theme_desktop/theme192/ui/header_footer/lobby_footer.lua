return 
{
    {
        plist = {
            "theme192/header_footer/packs/footer.plist",
            "theme192/header_footer/packs/header.plist",
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
                path = "root.warehouse_node.btn_lounge",
            },
            {
                path = "root.warehouse_node.btn_arena",
            },
            {
                path = "root.warehouse_node.btn_missions",
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
                    width = 720,
                    height = 216,
                },
                frame = "dating_2.png",
                type = "BLSprite",
                name = "dating_2",
                position = {
                    y = -81.0,
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
                        name = "btn_club",
                        frame_disable = "icon_1.png",
                        content_size = {
                            width = 133,
                            height = 145,
                        },
                        frame_down = "icon_1.png",
                        position = {
                            y = 4.219,
                            x = -284.738,
                            z = 0,
                        },
                        frame_normal = "icon_1.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 7,
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
                            y = 3.676,
                            x = -144.716,
                            z = 0,
                        },
                        frame_normal = "icon_2.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 13,
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
                            y = 7.287,
                            x = 1.753,
                            z = 0,
                        },
                        frame_normal = "icon_5.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 20,
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
                            y = 5.422,
                            x = 157.293,
                            z = 0,
                        },
                        frame_normal = "icon_3.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 27,
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
                            y = 3.598,
                            x = 281.426,
                            z = 0,
                        },
                        frame_normal = "icon_4.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 34,
                    },
                },
            },
            {
                position = {
                    y = 77.444,
                    x = -247.405,
                    z = 0,
                },
                type = "BLNode",
                name = "tip_node",
                children = {
                    {
                        content_size = {
                            width = 261,
                            height = 202,
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
                            width = 50,
                            height = 58,
                        },
                        frame = "icon_zuanshi.png",
                        position = {
                            y = 58.725,
                            x = -32.481,
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
                            y = 60.418,
                            x = 26.836,
                            z = 0,
                        },
                        overflow = 0,
                        type = "BLBMFont",
                        font_name = "theme192/lobby/fonts/tip_num.fnt",
                    },
                },
            },
        },
    },
}