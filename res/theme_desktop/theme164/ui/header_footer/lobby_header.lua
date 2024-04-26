return 
{
    {
        plist = {
            "theme164/header_footer/packs/header.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_zhuye",
            },
            {
                path = "root.btn_setting",
            },
            {
                path = "root.btn_getcoin",
            },
            {
                path = "root.btn_ad",
            },
            {
                path = "root.btn_collect",
            },
            {
                path = "root.btn_friend",
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
                position = {
                    y = -34.476,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "bg_node",
                children = {
                    {
                        content_size = {
                            width = 670,
                            height = 70,
                        },
                        frame = "dating_1.png",
                        type = "BLSprite",
                        name = "left_bg",
                        position = {
                            y = 0.0,
                            x = -335.0,
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
                            width = 670,
                            height = 70,
                        },
                        frame = "dating_1.png",
                        position = {
                            y = 0.0,
                            x = 335.0,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                },
            },
            {
                name = "btn_zhuye",
                frame_disable = "icon_zhuye.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "icon_zhuye.png",
                position = {
                    y = -33.13,
                    x = -471.381,
                    z = 0,
                },
                frame_normal = "icon_zhuye.png",
                type = "BLButton",
                children = {
                },
                target = 11,
            },
            {
                scale = {
                    y = 0.9,
                    x = 0.9,
                },
                name = "player_head",
                content_size = {
                    width = 132,
                    height = 151,
                },
                frame = "head.png",
                position = {
                    y = -30.528,
                    x = -470.976,
                    z = 0,
                },
                type = "BLSprite",
            },
            {
                scale = {
                    y = 0.85,
                    x = 0.85,
                },
                name = "btn_setting",
                frame_disable = "icon_shezhi.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "icon_shezhi.png",
                position = {
                    y = -33.628,
                    x = 484.775,
                    z = 0,
                },
                frame_normal = "icon_shezhi.png",
                type = "BLButton",
                children = {
                },
                target = 21,
            },
            {
                scale = {
                    y = 0.85,
                    x = 0.85,
                },
                name = "btn_getcoin",
                frame_disable = "free coin.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "free coin.png",
                position = {
                    y = -31.119,
                    x = 68.153,
                    z = 0,
                },
                frame_normal = "free coin.png",
                type = "BLButton",
                children = {
                },
                target = 28,
            },
            {
                scale = {
                    y = 0.85,
                    x = 0.85,
                },
                name = "btn_ad",
                frame_disable = "icon_ad.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "icon_ad.png",
                position = {
                    y = -29.689,
                    x = 179.536,
                    z = 0,
                },
                frame_normal = "icon_ad.png",
                type = "BLButton",
                children = {
                },
                target = 35,
            },
            {
                scale = {
                    y = 0.85,
                    x = 0.85,
                },
                name = "btn_collect",
                frame_disable = "icon_collect.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "icon_collect.png",
                position = {
                    y = -29.689,
                    x = 292.739,
                    z = 0,
                },
                frame_normal = "icon_collect.png",
                type = "BLButton",
                children = {
                },
                target = 42,
            },
            {
                scale = {
                    y = 0.85,
                    x = 0.85,
                },
                name = "btn_friend",
                frame_disable = "icon_friend.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "icon_friend.png",
                position = {
                    y = -30.529,
                    x = 405.128,
                    z = 0,
                },
                frame_normal = "icon_friend.png",
                type = "BLButton",
                children = {
                },
                target = 49,
            },
            {
                position = {
                    y = -236.729,
                    x = 277.61,
                    z = 0,
                },
                type = "BLNode",
                name = "tip_node",
                children = {
                    {
                        content_size = {
                            width = 238,
                            height = 171,
                        },
                        frame = "unlockTop.png",
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
                            width = 53,
                            height = 47,
                        },
                        frame = "icon_zuanshi.png",
                        position = {
                            y = 38.079,
                            x = -38.335,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                    {
                        horizontal_align = 0,
                        font_size = 30,
                        name = "label_diamonds",
                        content_size = {
                            width = 58.69,
                            height = 30,
                        },
                        vertical_align = 0,
                        text = "1000",
                        lineHeight = 30,
                        position = {
                            y = 38.003,
                            x = 28.603,
                            z = 0,
                        },
                        overflow = 0,
                        type = "BLBMFont",
                        font_name = "theme164/lobby/fonts/tip_num.fnt",
                    },
                },
            },
            {
                name = "starAnim",
                spine = {
                    defaultSkin = "default",
                    isLoop = false,
                    animation = "",
                    name = "theme164/login/spines/star/Tongyong_xingxing",
                },
                content_size = {
                    width = 270.5,
                    height = 270.5,
                },
                visible = false,
                position = {
                    y = -36.992,
                    x = 91.664,
                    z = 0,
                },
                type = "BLSpine",
            },
        },
    },
}