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
                scale = {
                    y = 1,
                    x = -1,
                },
                type = "BLSprite",
                name = "login_bg",
                texture = "theme240/login/textures/login_bg.png",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme240/login/spines/mist/Tongyong_baowu",
                },
                content_size = {
                    width = 1448.73,
                    height = 603.7,
                },
                type = "BLSpine",
                name = "mist",
            },
            {
                scale = {
                    y = 1,
                    x = -1,
                },
                name = "login_man",
                content_size = {
                    width = 1159,
                    height = 700,
                },
                texture = "theme240/login/textures/login_man.png",
                type = "BLSprite",
                children = {
                    {
                        spine = {
                            defaultSkin = "default",
                            isLoop = true,
                            animation = "",
                            name = "theme240/login/spines/star/Tongyong_xingxing",
                        },
                        content_size = {
                            width = 270.5,
                            height = 270.5,
                        },
                        type = "BLSpine",
                        name = "starAnim",
                        position = {
                            y = 508.985,
                            x = 238.482,
                            z = 0,
                        },
                    },
                },
            },
            {
                name = "btn_play",
                texture_disable = "theme240/login/textures/btn_img.png",
                content_size = {
                    width = 410,
                    height = 101,
                },
                texture_normal = "theme240/login/textures/btn_img.png",
                texture_down = "theme240/login/textures/btn_img.png",
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
                            name = "theme240/login/spines/star/Tongyong_xingxing",
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
                            name = "theme240/login/spines/star/Tongyong_xingxing",
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
                            name = "theme240/login/spines/star/Tongyong_xingxing",
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
                target = 15,
            },
        },
    },
}