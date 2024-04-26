return 
{
    {
        plist = {
            "theme225/header_footer/packs/footer.plist",
            "theme225/header_footer/packs/header.plist",
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
                    y = -29.525,
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
                            y = 21.75,
                            x = -275.869,
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
                            y = 21.814,
                            x = -136.344,
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
                            y = 16.649,
                            x = 2.689,
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
                            y = 21.411,
                            x = 153.987,
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
                            y = 21.534,
                            x = 270.428,
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
                    x = -274.405,
                    z = 0,
                },
                type = "BLNode",
                name = "tip_node",
                children = {
                    {
                        scale = {
                            y = 0.75,
                            x = 0.75,
                        },
                        name = "tip_bg",
                        content_size = {
                            width = 261,
                            height = 202,
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
                            y = 58.725,
                            x = -32.481,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                    {
                        horizontal_align = 0,
                        font_size = 25,
                        name = "label_diamonds",
                        content_size = {
                            width = 53.66,
                            height = 25,
                        },
                        vertical_align = 0,
                        text = "1000",
                        lineHeight = 25,
                        position = {
                            y = 58.304,
                            x = 24.722,
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