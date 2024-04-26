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
                path = "root.btn_lobby",
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
                position = {
                    y = -37,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "bg_node",
                children = {
                    {
                        name = "right_bg",
                        content_size = {
                            width = 360,
                            height = 152,
                        },
                        frame = "header_bg_golden.png",
                        position = {
                            y = 16.0,
                            x = 0,
                            z = 0,
                        },
                        type = "BLSprite",
                        anchor = {
                            y = 0.5,
                            x = 0,
                        },
                    },
                    {
                        scale = {
                            y = 1,
                            x = -1,
                        },
                        name = "left_bg",
                        content_size = {
                            width = 360,
                            height = 152,
                        },
                        frame = "header_bg_golden.png",
                        position = {
                            y = 16.0,
                            x = 0,
                            z = 0,
                        },
                        type = "BLSprite",
                        anchor = {
                            y = 0.5,
                            x = 0,
                        },
                    },
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
                    y = -50.34,
                    x = -311.0,
                    z = 0,
                },
                frame_normal = "icon_zhuye.png",
                type = "BLButton",
                children = {
                },
                target = 11,
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
                    y = -51.34,
                    x = 311.0,
                    z = 0,
                },
                frame_normal = "icon_shezhi.png",
                type = "BLButton",
                children = {
                },
                target = 18,
            },
        },
    },
}