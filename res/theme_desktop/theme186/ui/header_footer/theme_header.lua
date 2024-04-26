return 
{
    {
        plist = {
            "theme186/header_footer/packs/header.plist",
            "theme186/lobby/packs/lobby.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_lobby",
            },
            {
                path = "root.advertise_node.btn_fadvertise",
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
                scale = {
                    y = 0.8,
                    x = 0.8,
                },
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
                position = {
                    y = -39.936,
                    x = 62.467,
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
                        spine = {
                            defaultSkin = "default",
                            isLoop = true,
                            animation = "",
                            name = "theme186/header_footer/spines/advertise/spine",
                        },
                        content_size = {
                            width = 220.83,
                            height = 177.18,
                        },
                        type = "BLSpine",
                        name = "advertise_node",
                        position = {
                            y = 8.301,
                            x = 0.0,
                            z = 0,
                        },
                    },
                    {
                        scale = {
                            y = 7,
                            x = 8.5,
                        },
                        name = "btn_fadvertise",
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
                    y = -33.604,
                    x = 158.435,
                    z = 0,
                },
                frame_normal = "icon_8.png",
                type = "BLButton",
                children = {
                    {
                        scale = {
                            y = 0.5,
                            x = 0.5,
                        },
                        name = "lock_2",
                        content_size = {
                            width = 55,
                            height = 81,
                        },
                        frame = "lock_2.png",
                        position = {
                            y = 47.832,
                            x = 39.5,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                },
                target = 25,
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
                target = 35,
            },
            {
                position = {
                    y = -102.333,
                    x = 157.547,
                    z = 0,
                },
                type = "BLNode",
                name = "tip_node",
                children = {
                    {
                        content_size = {
                            width = 232,
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
                            width = 52,
                            height = 55,
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
                            y = -75.704,
                            x = 25.826,
                            z = 0,
                        },
                        overflow = 0,
                        type = "BLBMFont",
                        font_name = "theme186/lobby/fonts/tip_num.fnt",
                    },
                },
            },
        },
    },
}