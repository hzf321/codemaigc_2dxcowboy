return 
{
    {
        plist = {
            "theme188/login/packs/login.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_play",
            },
            {
                path = "root.btn_google",
            },
            {
                path = "root.btn_googleout",
            },
        },
        name = "login_view",
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
                    height = 719,
                },
                type = "BLSprite",
                name = "login_bg",
                texture = "theme188/login/textures/login_bg.jpg",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme188/login/spines/sea/spine",
                },
                content_size = {
                    width = 0,
                    height = 0,
                },
                type = "BLSpine",
                name = "sea_spine",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme188/login/spines/sky/spine",
                },
                content_size = {
                    width = 2408.89,
                    height = 444,
                },
                type = "BLSpine",
                name = "sky_spine",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "stop",
                    name = "theme188/login/spines/god/spine",
                },
                content_size = {
                    width = 776.08,
                    height = 1231.1,
                },
                scale = {
                    y = 0.8,
                    x = 0.8,
                },
                type = "BLSpine",
                name = "god_spine",
            },
            {
                position = {
                    y = 0,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "process_node",
                children = {
                    {
                        content_size = {
                            width = 1185,
                            height = 41,
                        },
                        frame = "loading_font_bg.png",
                        type = "BLSprite",
                        name = "label_bg",
                        position = {
                            y = -282.44,
                            x = 0.0,
                            z = 0,
                        },
                    },
                    {
                        name = "process_bg",
                        content_size = {
                            width = 1056,
                            height = 48,
                        },
                        frame = "loading_di.png",
                        position = {
                            y = -316.0,
                            x = 0.0,
                            z = 0,
                        },
                        type = "BLScale9Sprite",
                        cap_insets = {
                            y = 0,
                            x = 57,
                            height = 48,
                            width = 40,
                        },
                    },
                    {
                        name = "progress_bar",
                        content_size = {
                            width = 1036,
                            height = 34,
                        },
                        progressBar = {
                            type = 1,
                            percentage = 10.0,
                            changeRate = {
                                y = 1,
                                x = 1,
                            },
                            mid = {
                                y = 0,
                                x = 0,
                            },
                            frame = "loading_progressbar.png",
                        },
                        position = {
                            y = -316.0,
                            x = 0.0,
                            z = 0,
                        },
                        type = "BLProgressBar",
                        cap_insets = {
                            y = 0,
                            x = 0,
                            height = 34,
                            width = 1036,
                        },
                    },
                    {
                        content_size = {
                            width = 45,
                            height = 48,
                        },
                        frame = "loading_trim.png",
                        type = "BLSprite",
                        name = "decoration_left",
                        position = {
                            y = -317.0,
                            x = -500.0,
                            z = 0,
                        },
                    },
                    {
                        scale = {
                            y = 1,
                            x = -1,
                        },
                        name = "decoration_right",
                        content_size = {
                            width = 45,
                            height = 48,
                        },
                        frame = "loading_trim.png",
                        position = {
                            y = -317.0,
                            x = 501.0,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                    {
                        spine = {
                            defaultSkin = "default",
                            isLoop = true,
                            animation = "animation",
                            name = "theme188/login/spines/bolt/spine",
                        },
                        content_size = {
                            width = 162,
                            height = 97,
                        },
                        type = "BLSpine",
                        name = "bolt_spine",
                        position = {
                            y = -316.8,
                            x = -414.0,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 282,
                            height = 27,
                        },
                        frame = "prompt.png",
                        type = "BLSprite",
                        name = "sp_prompt",
                        position = {
                            y = -279.5,
                            x = -25.0,
                            z = 0,
                        },
                    },
                    {
                        horizontal_align = 0,
                        font_size = 32,
                        name = "process_num",
                        content_size = {
                            width = 44,
                            height = 25,
                        },
                        vertical_align = 0,
                        text = "58%",
                        lineHeight = 25,
                        position = {
                            y = -275.3,
                            x = 120.897,
                            z = 0,
                        },
                        overflow = 0,
                        type = "BLBMFont",
                        anchor = {
                            y = 0.5,
                            x = 0,
                        },
                        font_name = "theme188/login/fonts/process_num.fnt",
                    },
                },
            },
            {
                name = "btn_play",
                frame_disable = "login_new_user_btn.png",
                content_size = {
                    width = 410,
                    height = 101,
                },
                frame_down = "login_new_user_btn.png",
                visible = false,
                position = {
                    y = -258.0,
                    x = 0.0,
                    z = 0,
                },
                frame_normal = "login_new_user_btn.png",
                type = "BLButton",
                children = {
                },
                target = 44,
            },
            {
                name = "play_spine",
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme188/login/spines/play/spine",
                },
                content_size = {
                    width = 0,
                    height = 0,
                },
                visible = false,
                position = {
                    y = -250.0,
                    x = 0.0,
                    z = 0,
                },
                type = "BLSpine",
            },
            {
                name = "btn_google",
                texture_disable = "theme188/login/textures/signin.png",
                content_size = {
                    width = 410,
                    height = 101,
                },
                texture_normal = "theme188/login/textures/signin.png",
                visible = false,
                texture_down = "theme188/login/textures/signin.png",
                position = {
                    y = -4.145,
                    x = -480.583,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 54,
            },
            {
                name = "btn_googleout",
                texture_disable = "theme188/login/textures/signout.png",
                content_size = {
                    width = 410,
                    height = 101,
                },
                texture_normal = "theme188/login/textures/signout.png",
                visible = false,
                texture_down = "theme188/login/textures/signout.png",
                position = {
                    y = -4.145,
                    x = -480.583,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 61,
            },
        },
    },
}