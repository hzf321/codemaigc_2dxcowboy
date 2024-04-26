return 
{
    {
        plist = {
            "theme174/header_footer/packs/header.plist",
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
                path = "root.btn_settinghall",
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
                            width = 1560,
                            height = 86,
                        },
                        frame = "dating_1.png",
                        type = "BLSprite",
                        name = "left_bg",
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
                        visible = false,
                        position = {
                            y = 0.0,
                            x = 308.807,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                },
            },
            {
                name = "gameBg",
                content_size = {
                    width = 1560,
                    height = 89,
                },
                frame = "lobby_header_back01.png",
                visible = false,
                position = {
                    y = -26.661,
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
                name = "btn_zhuye",
                frame_disable = "icon_zhuye.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "icon_zhuye.png",
                position = {
                    y = -31.13,
                    x = -550.934,
                    z = 0,
                },
                frame_normal = "icon_zhuye.png",
                type = "BLButton",
                children = {
                },
                target = 14,
            },
            {
                content_size = {
                    width = 132,
                    height = 108,
                },
                frame = "head.png",
                type = "BLSprite",
                name = "player_head",
                position = {
                    y = -59.351,
                    x = -549.313,
                    z = 0,
                },
            },
            {
                scale = {
                    y = 0.75,
                    x = 0.75,
                },
                name = "btn_setting",
                frame_disable = "icon_shezhi.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "icon_shezhi.png",
                position = {
                    y = -28.725,
                    x = 581.539,
                    z = 0,
                },
                frame_normal = "icon_shezhi.png",
                type = "BLButton",
                children = {
                },
                target = 24,
            },
            {
                scale = {
                    y = 0.75,
                    x = 0.75,
                },
                name = "btn_settinghall",
                frame_disable = "icon_shezhi1.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "icon_shezhi1.png",
                position = {
                    y = -28.725,
                    x = 581.539,
                    z = 0,
                },
                frame_normal = "icon_shezhi1.png",
                type = "BLButton",
                children = {
                },
                target = 31,
            },
            {
                scale = {
                    y = 0.7,
                    x = 0.7,
                },
                name = "btn_getcoin",
                frame_disable = "free coin.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "free coin.png",
                position = {
                    y = -28.805,
                    x = 134.386,
                    z = 0,
                },
                frame_normal = "free coin.png",
                type = "BLButton",
                children = {
                },
                target = 38,
            },
            {
                scale = {
                    y = 0.7,
                    x = 0.7,
                },
                name = "btn_ad",
                frame_disable = "icon_ad.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "icon_ad.png",
                position = {
                    y = -28.805,
                    x = 245.928,
                    z = 0,
                },
                frame_normal = "icon_ad.png",
                type = "BLButton",
                children = {
                },
                target = 45,
            },
            {
                scale = {
                    y = 0.7,
                    x = 0.7,
                },
                name = "btn_collect",
                frame_disable = "icon_collect.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "icon_collect.png",
                position = {
                    y = -28.805,
                    x = 361.211,
                    z = 0,
                },
                frame_normal = "icon_collect.png",
                type = "BLButton",
                children = {
                },
                target = 52,
            },
            {
                scale = {
                    y = 0.7,
                    x = 0.7,
                },
                name = "btn_friend",
                frame_disable = "icon_friend.png",
                content_size = {
                    width = 58,
                    height = 60,
                },
                frame_down = "icon_friend.png",
                position = {
                    y = -29.396,
                    x = 472.217,
                    z = 0,
                },
                frame_normal = "icon_friend.png",
                type = "BLButton",
                children = {
                },
                target = 59,
            },
            {
                position = {
                    y = -72.697,
                    x = 290.202,
                    z = 0,
                },
                type = "BLNode",
                name = "tip_node",
                children = {
                    {
                        content_size = {
                            width = 204,
                            height = 137,
                        },
                        frame = "unlockTop.png",
                        type = "BLSprite",
                        name = "tip_bg",
                        position = {
                            y = -73.319,
                            x = 0.0,
                            z = 0,
                        },
                    },
                    {
                        scale = {
                            y = 0.8,
                            x = 0.8,
                        },
                        name = "icon_diamond",
                        content_size = {
                            width = 48,
                            height = 52,
                        },
                        frame = "icon_zuanshi.png",
                        position = {
                            y = -97.113,
                            x = -41.056,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                    {
                        horizontal_align = 0,
                        font_size = 30,
                        name = "label_diamonds",
                        content_size = {
                            width = 56.25,
                            height = 30,
                        },
                        vertical_align = 0,
                        text = "1000",
                        lineHeight = 30,
                        position = {
                            y = -97.189,
                            x = 27.653,
                            z = 0,
                        },
                        overflow = 0,
                        type = "BLBMFont",
                        font_name = "theme174/lobby/fonts/tip_num.fnt",
                    },
                },
            },
            {
                name = "starAnim",
                spine = {
                    defaultSkin = "default",
                    isLoop = false,
                    animation = "",
                    name = "theme174/login/spines/star/Tongyong_xingxing",
                },
                content_size = {
                    width = 270.5,
                    height = 270.5,
                },
                visible = false,
                position = {
                    y = -23.843,
                    x = 133.194,
                    z = 0,
                },
                type = "BLSpine",
            },
        },
    },
}