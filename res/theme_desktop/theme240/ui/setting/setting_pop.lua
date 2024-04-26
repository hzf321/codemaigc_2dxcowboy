return 
{
    {
        plist = {
            "theme240/setting/packs/setting.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_close",
            },
            {
                path = "root.contrl_node.music_node.btn_music",
            },
            {
                path = "root.contrl_node.sound_node.btn_sound",
            },
            {
                path = "root.btn_privacy",
            },
            {
                path = "root.btn_service",
            },
        },
        name = "setting_pop",
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
                    width = 902,
                    height = 619,
                },
                frame = "prize_wholebg.png",
                type = "BLSprite",
                name = "bg",
                position = {
                    y = -5.0,
                    x = -11.0,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 171,
                    height = 40,
                },
                frame = "settings_tittle.png",
                type = "BLSprite",
                name = "sp_title",
                position = {
                    y = 264.495,
                    x = -9.728,
                    z = 0,
                },
            },
            {
                name = "btn_close",
                frame_disable = "delete_btn.png",
                content_size = {
                    width = 70,
                    height = 70,
                },
                frame_down = "delete_btn.png",
                position = {
                    y = 280.555,
                    x = 395.366,
                    z = 0,
                },
                frame_normal = "delete_btn.png",
                type = "BLButton",
                children = {
                },
                target = 9,
            },
            {
                position = {
                    y = 0,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "contrl_node",
                children = {
                    {
                        position = {
                            y = 0,
                            x = 0,
                            z = 0,
                        },
                        type = "BLNode",
                        name = "music_node",
                        children = {
                            {
                                content_size = {
                                    width = 206,
                                    height = 67,
                                },
                                frame = "text_music.png",
                                type = "BLSprite",
                                name = "text_music",
                                position = {
                                    y = 74.5,
                                    x = -199.46,
                                    z = 0,
                                },
                            },
                            {
                                content_size = {
                                    width = 182,
                                    height = 50,
                                },
                                frame = "switch_on.png",
                                type = "BLSprite",
                                name = "bg",
                                position = {
                                    y = 73.5,
                                    x = 154.5,
                                    z = 0,
                                },
                            },
                            {
                                content_size = {
                                    width = 85,
                                    height = 52,
                                },
                                frame = "switchicon.png",
                                type = "BLSprite",
                                name = "move",
                                position = {
                                    y = 71.5,
                                    x = 154.921,
                                    z = 0,
                                },
                            },
                            {
                                scale = {
                                    y = 7,
                                    x = 24,
                                },
                                name = "btn_music",
                                texture_disable = "commonpics/kong.png",
                                content_size = {
                                    width = 10,
                                    height = 10,
                                },
                                texture_normal = "commonpics/kong.png",
                                texture_down = "commonpics/kong.png",
                                position = {
                                    y = 73.667,
                                    x = 153.261,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 27,
                            },
                        },
                    },
                    {
                        position = {
                            y = 0,
                            x = 0,
                            z = 0,
                        },
                        type = "BLNode",
                        name = "sound_node",
                        children = {
                            {
                                content_size = {
                                    width = 230,
                                    height = 64,
                                },
                                frame = "text_sounds.png",
                                type = "BLSprite",
                                name = "text_sound",
                                position = {
                                    y = -46.0,
                                    x = -187.0,
                                    z = 0,
                                },
                            },
                            {
                                content_size = {
                                    width = 182,
                                    height = 50,
                                },
                                frame = "switch_on.png",
                                type = "BLSprite",
                                name = "bg",
                                position = {
                                    y = -43.5,
                                    x = 154.5,
                                    z = 0,
                                },
                            },
                            {
                                content_size = {
                                    width = 85,
                                    height = 52,
                                },
                                frame = "switchicon.png",
                                type = "BLSprite",
                                name = "move",
                                position = {
                                    y = -45.5,
                                    x = 213.5,
                                    z = 0,
                                },
                            },
                            {
                                scale = {
                                    y = 7,
                                    x = 24,
                                },
                                name = "btn_sound",
                                texture_disable = "commonpics/kong.png",
                                content_size = {
                                    width = 10,
                                    height = 10,
                                },
                                texture_normal = "commonpics/kong.png",
                                texture_down = "commonpics/kong.png",
                                position = {
                                    y = -42.097,
                                    x = 153.261,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 45,
                            },
                        },
                    },
                },
            },
            {
                name = "btn_privacy",
                frame_disable = "text_privacy policy.png",
                content_size = {
                    width = 204,
                    height = 33,
                },
                frame_down = "text_privacy policy.png",
                position = {
                    y = -190.5,
                    x = -182.0,
                    z = 0,
                },
                frame_normal = "text_privacy policy.png",
                type = "BLButton",
                children = {
                },
                target = 54,
            },
            {
                name = "btn_service",
                frame_disable = "text_terms of service.png",
                content_size = {
                    width = 233,
                    height = 33,
                },
                frame_down = "text_terms of service.png",
                position = {
                    y = -190.5,
                    x = 174.5,
                    z = 0,
                },
                frame_normal = "text_terms of service.png",
                type = "BLButton",
                children = {
                },
                target = 61,
            },
        },
    },
}