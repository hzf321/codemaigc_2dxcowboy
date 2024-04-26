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
                path = "root.btn_setting",
            },
            {
                path = "root.btn_ad.btn_fadvertise",
            },
            {
                path = "root.warehouse_node.btn_adventure",
            },
            {
                path = "root.warehouse_node.btn_vip",
            },
            {
                path = "root.warehouse_node.btn_treasure",
            },
            {
                path = "root.facebook_node.btn_facebook",
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
                    width = 728,
                    height = 210,
                },
                frame = "dating_1.png",
                type = "BLSprite",
                name = "bg",
            },
            {
                spine = {
                    defaultSkin = "",
                    isLoop = true,
                    animation = "",
                    name = "theme186/header_footer/spines/headAnim/spine",
                },
                content_size = {
                    width = 210.84,
                    height = 280,
                },
                type = "BLSpine",
                name = "player_head",
                position = {
                    y = -23.926,
                    x = -296.663,
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
                    y = 3.409,
                    x = 271.839,
                    z = 0,
                },
                frame_normal = "icon_shezhi.png",
                type = "BLButton",
                children = {
                },
                target = 9,
            },
            {
                position = {
                    y = -94.653,
                    x = -71.971,
                    z = 0,
                },
                type = "BLNode",
                name = "btn_ad",
                children = {
                    {
                        spine = {
                            defaultSkin = "",
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
                        target = 20,
                    },
                },
            },
            {
                position = {
                    y = -70,
                    x = 102,
                    z = 0,
                },
                type = "BLNode",
                name = "warehouse_node",
                children = {
                    {
                        name = "btn_adventure",
                        frame_disable = "icon_6.png",
                        content_size = {
                            width = 79,
                            height = 77,
                        },
                        frame_down = "icon_6.png",
                        position = {
                            y = -14.891,
                            x = -83.173,
                            z = 0,
                        },
                        frame_normal = "icon_6.png",
                        type = "BLButton",
                        children = {
                            {
                                scale = {
                                    y = 0.4,
                                    x = 0.4,
                                },
                                name = "lock_2",
                                content_size = {
                                    width = 55,
                                    height = 81,
                                },
                                frame = "lock_2.png",
                                position = {
                                    y = 38.5,
                                    x = 39.5,
                                    z = 0,
                                },
                                type = "BLSprite",
                            },
                        },
                        target = 29,
                    },
                    {
                        name = "btn_vip",
                        frame_disable = "icon_8.png",
                        content_size = {
                            width = 79,
                            height = 77,
                        },
                        frame_down = "icon_8.png",
                        position = {
                            y = -16.888,
                            x = 8.695,
                            z = 0,
                        },
                        frame_normal = "icon_8.png",
                        type = "BLButton",
                        children = {
                            {
                                scale = {
                                    y = 0.4,
                                    x = 0.4,
                                },
                                name = "lock_2",
                                content_size = {
                                    width = 55,
                                    height = 81,
                                },
                                frame = "lock_2.png",
                                position = {
                                    y = 38.5,
                                    x = 39.5,
                                    z = 0,
                                },
                                type = "BLSprite",
                            },
                        },
                        target = 39,
                    },
                    {
                        name = "btn_treasure",
                        frame_disable = "icon_7.png",
                        content_size = {
                            width = 79,
                            height = 77,
                        },
                        frame_down = "icon_7.png",
                        position = {
                            y = -15.813,
                            x = 98.746,
                            z = 0,
                        },
                        frame_normal = "icon_7.png",
                        type = "BLButton",
                        children = {
                            {
                                scale = {
                                    y = 0.4,
                                    x = 0.4,
                                },
                                name = "lock_2",
                                content_size = {
                                    width = 55,
                                    height = 81,
                                },
                                frame = "lock_2.png",
                                position = {
                                    y = 38.5,
                                    x = 39.5,
                                    z = 0,
                                },
                                type = "BLSprite",
                            },
                        },
                        target = 49,
                    },
                },
            },
            {
                position = {
                    y = -94.653,
                    x = 289.788,
                    z = 0,
                },
                type = "BLNode",
                name = "facebook_node",
                children = {
                    {
                        content_size = {
                            width = 100,
                            height = 72,
                        },
                        frame = "freecoins.png",
                        type = "BLSprite",
                        name = "freecoins",
                        position = {
                            y = 6.835,
                            x = 10.787,
                            z = 0,
                        },
                    },
                    {
                        scale = {
                            y = 7,
                            x = 8.5,
                        },
                        name = "btn_facebook",
                        texture_disable = "commonpics/kong.png",
                        content_size = {
                            width = 10,
                            height = 10,
                        },
                        texture_normal = "commonpics/kong.png",
                        texture_down = "commonpics/kong.png",
                        position = {
                            y = 0.0,
                            x = 10.011,
                            z = 0,
                        },
                        type = "BLButton",
                        children = {
                        },
                        target = 64,
                    },
                },
            },
            {
                position = {
                    y = -176,
                    x = 203.271,
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