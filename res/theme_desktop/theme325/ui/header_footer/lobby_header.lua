return 
{
    {
        plist = {
            "theme325/header_footer/packs/header.plist",
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
                position = {
                    y = -38,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "bg_node",
                children = {
                    {
                        content_size = {
                            width = 670,
                            height = 80,
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
                            height = 80,
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
                    x = -549.403,
                    z = 0,
                },
                frame_normal = "icon_zhuye.png",
                type = "BLButton",
                children = {
                },
                target = 11,
            },
            {
                content_size = {
                    width = 88,
                    height = 98,
                },
                frame = "head.png",
                type = "BLSprite",
                name = "player_head",
                position = {
                    y = -36.792,
                    x = -548.998,
                    z = 0,
                },
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
                    y = -34.085,
                    x = 560.312,
                    z = 0,
                },
                frame_normal = "icon_shezhi.png",
                type = "BLButton",
                children = {
                },
                target = 21,
            },
            {
                name = "btn_ad",
                frame_disable = "icon_ad.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "icon_ad.png",
                position = {
                    y = -32.859,
                    x = 214.968,
                    z = 0,
                },
                frame_normal = "icon_ad.png",
                type = "BLButton",
                children = {
                },
                target = 28,
            },
            {
                name = "btn_collect",
                frame_disable = "icon_collect.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "icon_collect.png",
                position = {
                    y = -32.859,
                    x = 341.968,
                    z = 0,
                },
                frame_normal = "icon_collect.png",
                type = "BLButton",
                children = {
                },
                target = 35,
            },
            {
                name = "btn_friend",
                frame_disable = "icon_friend.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "icon_friend.png",
                position = {
                    y = -33.699,
                    x = 455.968,
                    z = 0,
                },
                frame_normal = "icon_friend.png",
                type = "BLButton",
                children = {
                },
                target = 42,
            },
            {
                scale = {
                    y = 0.5,
                    x = 0.5,
                },
                name = "lock_2",
                content_size = {
                    width = 48,
                    height = 71,
                },
                frame = "lock_2.png",
                position = {
                    y = -28.988,
                    x = 340.989,
                    z = 0,
                },
                type = "BLSprite",
            },
            {
                scale = {
                    y = 0.5,
                    x = 0.5,
                },
                name = "lock_2",
                content_size = {
                    width = 48,
                    height = 71,
                },
                frame = "lock_2.png",
                position = {
                    y = -29.828,
                    x = 456.221,
                    z = 0,
                },
                type = "BLSprite",
            },
            {
                name = "btn_getcoin",
                frame_disable = "free coin.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "free coin.png",
                position = {
                    y = -34.289,
                    x = 83.664,
                    z = 0,
                },
                frame_normal = "free coin.png",
                type = "BLButton",
                children = {
                },
                target = 55,
            },
            {
                position = {
                    y = -236.729,
                    x = 344.752,
                    z = 0,
                },
                type = "BLNode",
                name = "tip_node",
                children = {
                    {
                        content_size = {
                            width = 240,
                            height = 172,
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
                            height = 50,
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
                        font_name = "theme325/lobby/fonts/tip_num.fnt",
                    },
                },
            },
            {
                name = "starAnim",
                spine = {
                    defaultSkin = "default",
                    isLoop = false,
                    animation = "",
                    name = "theme325/login/spines/star/Tongyong_xingxing",
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