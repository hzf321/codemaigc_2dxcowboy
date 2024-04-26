return 
{
    {
        plist = {
            "theme244/header_footer/packs/footer.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.totalbet_node.btn_subbet",
            },
            {
                path = "root.totalbet_node.btn_addbet",
            },
            {
                path = "root.maxbet_node.btn_maxbet",
            },
            {
                path = "root.spin_node.auto_node.btn_disappear",
            },
            {
                path = "root.spin_node.auto_node.btn_fast",
            },
            {
                path = "root.spin_node.auto_node.btn_500",
            },
            {
                path = "root.spin_node.auto_node.btn_100",
            },
            {
                path = "root.spin_node.auto_node.btn_50",
            },
            {
                path = "root.spin_node.auto_node.btn_20",
            },
            {
                path = "root.spin_node.auto_node.btn_10",
            },
            {
                path = "root.spin_node.btn_spin",
            },
            {
                path = "root.spin_node.btn_autostop",
            },
        },
        name = "theme_footer",
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
                    y = -20,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "bg_node",
                children = {
                    {
                        scale = {
                            y = 1,
                            x = -1,
                        },
                        name = "left_bg",
                        content_size = {
                            width = 780,
                            height = 100,
                        },
                        frame = "big_back_half.png",
                        position = {
                            y = 68.2,
                            x = -389.0,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                    {
                        content_size = {
                            width = 780,
                            height = 100,
                        },
                        frame = "big_back_half.png",
                        type = "BLSprite",
                        name = "right_bg",
                        position = {
                            y = 68.2,
                            x = 389.0,
                            z = 0,
                        },
                    },
                },
            },
            {
                position = {
                    y = 44.268,
                    x = -429.625,
                    z = 0,
                },
                type = "BLNode",
                name = "totalbet_node",
                children = {
                    {
                        content_size = {
                            width = 347,
                            height = 82,
                        },
                        frame = "wnzi_back.png",
                        type = "BLSprite",
                        name = "totalbet_bg",
                    },
                    {
                        content_size = {
                            width = 347,
                            height = 82,
                        },
                        frame = "wnzi_back.png",
                        type = "BLSprite",
                        name = "small_bg",
                    },
                    {
                        horizontal_align = 0,
                        font_size = 32,
                        name = "label_totalbet",
                        content_size = {
                            width = 166,
                            height = 32,
                        },
                        vertical_align = 1,
                        text = "6.000.000",
                        lineHeight = 32,
                        position = {
                            y = 6.448,
                            x = -7.935,
                            z = 0,
                        },
                        overflow = 0,
                        type = "BLBMFont",
                        font_name = "theme244/header_footer/fonts/coins_font03.fnt",
                    },
                    {
                        name = "btn_subbet",
                        frame_disable = "minus_h03.png",
                        content_size = {
                            width = 71,
                            height = 40,
                        },
                        frame_down = "minus_h02.png",
                        position = {
                            y = -1.774,
                            x = -135.563,
                            z = 0,
                        },
                        frame_normal = "minus_h01.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 21,
                    },
                    {
                        name = "btn_addbet",
                        frame_disable = "plus_h03.png",
                        content_size = {
                            width = 71,
                            height = 40,
                        },
                        frame_down = "plus_h02.png",
                        position = {
                            y = -0.753,
                            x = 134.418,
                            z = 0,
                        },
                        frame_normal = "plus_h01.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 28,
                    },
                    {
                        content_size = {
                            width = 93,
                            height = 15,
                        },
                        frame = "totalbetzit.png",
                        type = "BLSprite",
                        name = "sp_totalbet",
                        position = {
                            y = -28.381,
                            x = -6.258,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 0,
                            height = 0,
                        },
                        scale = {
                            y = 5,
                            x = 5,
                        },
                        type = "BLParticle",
                        name = "max_bet_particle",
                        particle = {
                            path = "theme244/header_footer/particles/max_bet_liziwenjian01_1.plist",
                            playOnLoad = false,
                            texture = "",
                        },
                    },
                    {
                        position = {
                            y = 0,
                            x = 0,
                            z = 0,
                        },
                        type = "BLNode",
                        name = "max_bet_choosed",
                    },
                },
            },
            {
                position = {
                    y = 51.294,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "totalwin_node",
                children = {
                    {
                        name = "win_particle",
                        particle = {
                            path = "theme244/header_footer/particles/winParticle.plist",
                            playOnLoad = false,
                            texture = "",
                        },
                        content_size = {
                            width = 0,
                            height = 0,
                        },
                        visible = false,
                        position = {
                            y = 2.0,
                            x = 0.0,
                            z = 0,
                        },
                        type = "BLParticle",
                    },
                    {
                        content_size = {
                            width = 97,
                            height = 17,
                        },
                        frame = "totalwin.png",
                        type = "BLSprite",
                        name = "sp_totalwin",
                        position = {
                            y = -36.14,
                            x = 0.0,
                            z = 0,
                        },
                    },
                    {
                        position = {
                            y = 3.949,
                            x = 0,
                            z = 0,
                        },
                        type = "BLNode",
                        name = "coin_node",
                    },
                    {
                        position = {
                            y = 5.127,
                            x = 0,
                            z = 0,
                        },
                        type = "BLNode",
                        name = "win_node",
                        children = {
                            {
                                horizontal_align = 0,
                                font_size = 32,
                                name = "label_win",
                                content_size = {
                                    width = 151,
                                    height = 43,
                                },
                                vertical_align = 1,
                                text = "10,100",
                                lineHeight = 43,
                                position = {
                                    y = 17.374,
                                    x = 0.0,
                                    z = 0,
                                },
                                overflow = 0,
                                type = "BLBMFont",
                                font_name = "theme244/header_footer/fonts/winCoins.fnt",
                            },
                            {
                                horizontal_align = 0,
                                font_size = 32,
                                name = "label_win2",
                                content_size = {
                                    width = 151,
                                    height = 32,
                                },
                                vertical_align = 1,
                                text = "10,100",
                                lineHeight = 32,
                                position = {
                                    y = 17.374,
                                    x = 0.0,
                                    z = 0,
                                },
                                overflow = 0,
                                type = "BLBMFont",
                                font_name = "theme244/header_footer/fonts/winCoins.fnt",
                            },
                        },
                    },
                },
            },
            {
                position = {
                    y = 41.151,
                    x = 308.048,
                    z = 0,
                },
                type = "BLNode",
                name = "maxbet_node",
                children = {
                    {
                        target = 63,
                        frame_disable = "maxbet_03.png",
                        content_size = {
                            width = 110,
                            height = 83,
                        },
                        frame_down = "maxbet_02.png",
                        frame_normal = "maxbet_01.png",
                        type = "BLButton",
                        children = {
                        },
                        name = "btn_maxbet",
                    },
                },
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme244/header_footer/spines/reward_effect/zhousi_jianglilanlizi",
                },
                content_size = {
                    width = 711.04,
                    height = 281.98,
                },
                type = "BLSpine",
                name = "reward_effect",
                position = {
                    y = 45.468,
                    x = -2.15,
                    z = 0,
                },
            },
            {
                position = {
                    y = 44.196,
                    x = 502.738,
                    z = 0,
                },
                type = "BLNode",
                name = "spin_node",
                children = {
                    {
                        position = {
                            y = 170,
                            x = 0,
                            z = 0,
                        },
                        children = {
                            {
                                content_size = {
                                    width = 189,
                                    height = 269,
                                },
                                frame = "freegamespin_back.png",
                                type = "BLSprite",
                                name = "auto_bg",
                            },
                            {
                                scale = {
                                    y = 120,
                                    x = 160,
                                },
                                name = "btn_disappear",
                                texture_disable = "commonpics/kong.png",
                                content_size = {
                                    width = 10,
                                    height = 10,
                                },
                                texture_normal = "commonpics/kong.png",
                                texture_down = "commonpics/kong.png",
                                position = {
                                    y = 157.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 79,
                            },
                            {
                                name = "btn_fast",
                                frame_disable = "anxia_fast.png",
                                content_size = {
                                    width = 180,
                                    height = 44,
                                },
                                texture_normal = "theme244/header_footer/textures/kong13345.png",
                                frame_down = "anxia_fast.png",
                                position = {
                                    y = 110.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 86,
                            },
                            {
                                name = "btn_500",
                                frame_disable = "anxia_500.png",
                                content_size = {
                                    width = 180,
                                    height = 44,
                                },
                                texture_normal = "theme244/header_footer/textures/kong13345.png",
                                frame_down = "anxia_500.png",
                                position = {
                                    y = 65.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 93,
                            },
                            {
                                name = "btn_100",
                                frame_disable = "anxia_100.png",
                                content_size = {
                                    width = 180,
                                    height = 44,
                                },
                                texture_normal = "theme244/header_footer/textures/kong13345.png",
                                frame_down = "anxia_100.png",
                                position = {
                                    y = 20.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 100,
                            },
                            {
                                name = "btn_50",
                                frame_disable = "anxia_50.png",
                                content_size = {
                                    width = 180,
                                    height = 44,
                                },
                                texture_normal = "theme244/header_footer/textures/kong13345.png",
                                frame_down = "anxia_50.png",
                                position = {
                                    y = -25.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 107,
                            },
                            {
                                name = "btn_20",
                                frame_disable = "anxia_20.png",
                                content_size = {
                                    width = 180,
                                    height = 44,
                                },
                                texture_normal = "theme244/header_footer/textures/kong13345.png",
                                frame_down = "anxia_20.png",
                                position = {
                                    y = -70.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 114,
                            },
                            {
                                name = "btn_10",
                                frame_disable = "anxia_10.png",
                                content_size = {
                                    width = 180,
                                    height = 44,
                                },
                                texture_normal = "theme244/header_footer/textures/kong13345.png",
                                frame_down = "anxia_10.png",
                                position = {
                                    y = -115.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 121,
                            },
                        },
                        type = "BLNode",
                        name = "auto_node",
                        visible = false,
                    },
                    {
                        name = "btn_spin",
                        frame_disable = "spin_03.png",
                        content_size = {
                            width = 255,
                            height = 83,
                        },
                        frame_down = "spin_02.png",
                        position = {
                            y = -5.0,
                            x = -2.0,
                            z = 0,
                        },
                        frame_normal = "spin_01.png",
                        type = "BLButton",
                        children = {
                            {
                                scale = {
                                    y = 0.9,
                                    x = 0.9,
                                },
                                name = "label_spin",
                                content_size = {
                                    width = 116,
                                    height = 44,
                                },
                                frame = "SPIN.png",
                                position = {
                                    y = 52.5,
                                    x = 127.5,
                                    z = 0,
                                },
                                type = "BLSprite",
                            },
                            {
                                content_size = {
                                    width = 119,
                                    height = 14,
                                },
                                frame = "HOLDFORAUTO.png",
                                type = "BLSprite",
                                name = "label_hold",
                                position = {
                                    y = 21.57,
                                    x = 128.0,
                                    z = 0,
                                },
                            },
                            {
                                scale = {
                                    y = 0.9,
                                    x = 0.9,
                                },
                                name = "label_stop",
                                content_size = {
                                    width = 131,
                                    height = 44,
                                },
                                frame = "STOP.png",
                                position = {
                                    y = 52.5,
                                    x = 127.5,
                                    z = 0,
                                },
                                type = "BLSprite",
                            },
                        },
                        target = 129,
                    },
                    {
                        name = "btn_autostop",
                        frame_disable = "spin_03.png",
                        content_size = {
                            width = 255,
                            height = 83,
                        },
                        frame_down = "spin_02.png",
                        position = {
                            y = -5.0,
                            x = -2.0,
                            z = 0,
                        },
                        frame_normal = "spin_01.png",
                        type = "BLButton",
                        children = {
                            {
                                scale = {
                                    y = 0.9,
                                    x = 0.9,
                                },
                                name = "label_stop",
                                content_size = {
                                    width = 131,
                                    height = 44,
                                },
                                frame = "STOP.png",
                                position = {
                                    y = 49.976,
                                    x = 127.5,
                                    z = 0,
                                },
                                type = "BLSprite",
                            },
                            {
                                scale = {
                                    y = 0.9,
                                    x = 0.9,
                                },
                                name = "label_stopfast",
                                content_size = {
                                    width = 131,
                                    height = 44,
                                },
                                frame = "STOP.png",
                                position = {
                                    y = 49.308,
                                    x = 127.5,
                                    z = 0,
                                },
                                type = "BLSprite",
                            },
                            {
                                horizontal_align = 0,
                                font_size = 32,
                                name = "label_normal",
                                content_size = {
                                    width = 25,
                                    height = 32,
                                },
                                vertical_align = 0,
                                text = "09",
                                lineHeight = 32,
                                position = {
                                    y = 22.725,
                                    x = 127.5,
                                    z = 0,
                                },
                                overflow = 0,
                                type = "BLBMFont",
                                font_name = "theme244/header_footer/fonts/auto_fnt01.fnt",
                            },
                            {
                                horizontal_align = 0,
                                font_size = 32,
                                name = "label_pressed",
                                content_size = {
                                    width = 25,
                                    height = 32,
                                },
                                vertical_align = 0,
                                text = "09",
                                lineHeight = 32,
                                position = {
                                    y = 22.725,
                                    x = 127.5,
                                    z = 0,
                                },
                                overflow = 0,
                                type = "BLBMFont",
                                font_name = "theme244/header_footer/fonts/auto_fnt01.fnt",
                            },
                        },
                        target = 145,
                    },
                },
            },
        },
    },
}