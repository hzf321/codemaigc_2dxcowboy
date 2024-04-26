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
                path = "root.btn_lobby",
            },
            {
                path = "root.advertise_node.btn_freecoin",
            },
            {
                path = "root.btn_themevip",
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
                content_size = {
                    width = 720,
                    height = 152,
                },
                frame = "header_bg_golden.png",
                type = "BLSprite",
                name = "bg",
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
                    y = -33.438,
                    x = -306.304,
                    z = 0,
                },
                frame_normal = "icon_zhuye.png",
                type = "BLButton",
                children = {
                },
                target = 6,
            },
            {
                scale = {
                    y = 0.8,
                    x = 0.8,
                },
                name = "advertise_node",
                visible = false,
                position = {
                    y = -39.936,
                    x = 62.467,
                    z = 0,
                },
                type = "BLNode",
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
                        target = 14,
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
                visible = false,
                position = {
                    y = -33.604,
                    x = 158.435,
                    z = 0,
                },
                frame_normal = "icon_8.png",
                type = "BLButton",
                children = {
                },
                target = 22,
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
                    y = -35.233,
                    x = 264.153,
                    z = 0,
                },
                frame_normal = "icon_shezhi.png",
                type = "BLButton",
                children = {
                },
                target = 29,
            },
            {
                position = {
                    y = -102.333,
                    x = 157.547,
                    z = 0,
                },
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
                        font_name = "theme220/lobby/fonts/tip_num.fnt",
                    },
                },
                type = "BLNode",
                name = "tip_node",
                visible = false,
            },
        },
    },
}