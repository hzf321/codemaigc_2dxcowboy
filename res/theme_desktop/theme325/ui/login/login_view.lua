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
                texture = "theme325/login/textures/login_bg.png",
                children = {
                    {
                        content_size = {
                            width = 355,
                            height = 112,
                        },
                        type = "BLSprite",
                        name = "yun_1",
                        texture = "theme325/login/textures/yun_1.png",
                        position = {
                            y = 506.796,
                            x = 362.068,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 333,
                            height = 106,
                        },
                        type = "BLSprite",
                        name = "yun_2",
                        texture = "theme325/login/textures/yun_2.png",
                        position = {
                            y = 507.212,
                            x = 1198.869,
                            z = 0,
                        },
                    },
                },
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme325/login/spines/mist/Tongyong_baowu",
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
                    width = 919,
                    height = 720,
                },
                texture = "theme325/login/textures/login_man.png",
                position = {
                    y = 0.0,
                    x = 94.709,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        spine = {
                            defaultSkin = "default",
                            isLoop = true,
                            animation = "",
                            name = "theme325/login/spines/star/Tongyong_xingxing",
                        },
                        content_size = {
                            width = 270.5,
                            height = 270.5,
                        },
                        type = "BLSpine",
                        name = "starAnim",
                        position = {
                            y = 642.109,
                            x = 345.445,
                            z = 0,
                        },
                    },
                },
            },
            {
                name = "btn_play",
                texture_disable = "theme325/login/textures/btn_img.png",
                content_size = {
                    width = 410,
                    height = 101,
                },
                texture_normal = "theme325/login/textures/btn_img.png",
                texture_down = "theme325/login/textures/btn_img.png",
                position = {
                    y = -248.22,
                    x = 0.221,
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
                            name = "theme325/login/spines/star/Tongyong_xingxing",
                        },
                        content_size = {
                            width = 270.5,
                            height = 270.5,
                        },
                        visible = false,
                        position = {
                            y = 106.5,
                            x = 58.0,
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
                            name = "theme325/login/spines/star/Tongyong_xingxing",
                        },
                        content_size = {
                            width = 270.5,
                            height = 270.5,
                        },
                        visible = false,
                        position = {
                            y = 106.5,
                            x = 339.019,
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
                            name = "theme325/login/spines/star/Tongyong_xingxing",
                        },
                        content_size = {
                            width = 270.5,
                            height = 270.5,
                        },
                        visible = false,
                        position = {
                            y = 50.5,
                            x = 205.0,
                            z = 0,
                        },
                        type = "BLSpine",
                    },
                },
                target = 21,
            },
        },
    },
}