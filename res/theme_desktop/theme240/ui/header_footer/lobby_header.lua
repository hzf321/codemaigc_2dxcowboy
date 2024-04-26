return 
{
    {
        plist = {
            "theme240/header_footer/packs/header.plist",
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
                path = "root.btn_ad",
            },
            {
                path = "root.btn_collect",
            },
            {
                path = "root.btn_friend",
            },
            {
                path = "root.btn_getcoin",
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
                    width = 1560,
                    height = 94,
                },
                frame = "dating_1.png",
                type = "BLSprite",
                name = "bg_node",
                position = {
                    y = -38.062,
                    x = 0.0,
                    z = 0,
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
                    y = -32.659,
                    x = -549.403,
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
                    y = 0.9,
                    x = -0.9,
                },
                name = "player_head",
                content_size = {
                    width = 107,
                    height = 103,
                },
                frame = "head.png",
                position = {
                    y = -52.439,
                    x = -545.51,
                    z = 0,
                },
                type = "BLSprite",
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
                    y = -35.568,
                    x = 578.977,
                    z = 0,
                },
                frame_normal = "icon_shezhi.png",
                type = "BLButton",
                children = {
                },
                target = 16,
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
                    y = -34.017,
                    x = 464.821,
                    z = 0,
                },
                frame_normal = "icon_ad.png",
                type = "BLButton",
                children = {
                },
                target = 23,
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
                    y = -33.442,
                    x = 70.18,
                    z = 0,
                },
                frame_normal = "icon_collect.png",
                type = "BLButton",
                children = {
                },
                target = 30,
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
                    y = -34.243,
                    x = 195.106,
                    z = 0,
                },
                frame_normal = "icon_friend.png",
                type = "BLButton",
                children = {
                },
                target = 37,
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
                    y = -35.887,
                    x = 332.3,
                    z = 0,
                },
                frame_normal = "free coin.png",
                type = "BLButton",
                children = {
                },
                target = 44,
            },
            {
                position = {
                    y = -229.337,
                    x = 344.752,
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
                            width = 49,
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
                            width = 54,
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
                        font_name = "theme240/lobby/fonts/tip_num.fnt",
                    },
                },
            },
            {
                name = "starAnim",
                spine = {
                    defaultSkin = "default",
                    isLoop = false,
                    animation = "",
                    name = "theme240/login/spines/star/Tongyong_xingxing",
                },
                content_size = {
                    width = 270.5,
                    height = 270.5,
                },
                visible = false,
                position = {
                    y = -9.444,
                    x = 47.182,
                    z = 0,
                },
                type = "BLSpine",
            },
        },
    },
}