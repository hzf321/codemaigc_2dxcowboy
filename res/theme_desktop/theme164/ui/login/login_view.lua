return 
{
    {
        plist = {
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_play",
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
                    height = 720,
                },
                type = "BLSprite",
                name = "login_bg",
                texture = "theme164/login/textures/login_bg.png",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme164/login/spines/mist/Tongyong_baowu",
                },
                content_size = {
                    width = 1448.73,
                    height = 603.7,
                },
                type = "BLSpine",
                name = "mist",
            },
            {
                name = "login_man",
                content_size = {
                    width = 1082,
                    height = 779,
                },
                texture = "theme164/login/textures/login_man.png",
                position = {
                    y = 0.0,
                    x = 29.087,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        spine = {
                            defaultSkin = "default",
                            isLoop = true,
                            animation = "",
                            name = "theme164/login/spines/star/Tongyong_xingxing",
                        },
                        content_size = {
                            width = 270.5,
                            height = 270.5,
                        },
                        type = "BLSpine",
                        name = "starAnim",
                        position = {
                            y = 577.472,
                            x = 508.668,
                            z = 0,
                        },
                    },
                },
            },
            {
                name = "btn_play",
                texture_disable = "theme164/login/textures/btn_img.png",
                content_size = {
                    width = 410,
                    height = 101,
                },
                texture_normal = "theme164/login/textures/btn_img.png",
                texture_down = "theme164/login/textures/btn_img.png",
                position = {
                    y = -248.22,
                    x = 0.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                    {
                        name = "starAnim1",
                        spine = {
                            defaultSkin = "default",
                            isLoop = true,
                            animation = "",
                            name = "theme164/login/spines/star/Tongyong_xingxing",
                        },
                        content_size = {
                            width = 270.5,
                            height = 270.5,
                        },
                        visible = false,
                        position = {
                            y = 64.13,
                            x = 352.976,
                            z = 0,
                        },
                        type = "BLSpine",
                    },
                    {
                        name = "starAnim2",
                        spine = {
                            defaultSkin = "default",
                            isLoop = true,
                            animation = "",
                            name = "theme164/login/spines/star/Tongyong_xingxing",
                        },
                        content_size = {
                            width = 270.5,
                            height = 270.5,
                        },
                        visible = false,
                        position = {
                            y = 167.41,
                            x = 175.393,
                            z = 0,
                        },
                        type = "BLSpine",
                    },
                    {
                        name = "starAnim3",
                        spine = {
                            defaultSkin = "default",
                            isLoop = true,
                            animation = "",
                            name = "theme164/login/spines/star/Tongyong_xingxing",
                        },
                        content_size = {
                            width = 270.5,
                            height = 270.5,
                        },
                        visible = false,
                        position = {
                            y = 55.643,
                            x = 128.824,
                            z = 0,
                        },
                        type = "BLSpine",
                    },
                },
                target = 15,
            },
        },
    },
}