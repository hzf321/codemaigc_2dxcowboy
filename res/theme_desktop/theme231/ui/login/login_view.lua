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
                    height = 720,
                },
                type = "BLSprite",
                name = "login_bg",
                texture = "theme231/login/textures/login_bg.png",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme231/login/spines/mist/Tongyong_baowu",
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
                    width = 871,
                    height = 711,
                },
                texture = "theme231/login/textures/login_man.png",
                position = {
                    y = 0.0,
                    x = -111.107,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        spine = {
                            defaultSkin = "default",
                            isLoop = true,
                            animation = "",
                            name = "theme231/login/spines/star/Tongyong_xingxing",
                        },
                        content_size = {
                            width = 270.5,
                            height = 270.5,
                        },
                        type = "BLSpine",
                        name = "starAnim",
                        position = {
                            y = 645.562,
                            x = 429.602,
                            z = 0,
                        },
                    },
                },
            },
            {
                name = "btn_play",
                texture_disable = "theme231/login/textures/btn_img.png",
                content_size = {
                    width = 410,
                    height = 101,
                },
                texture_normal = "theme231/login/textures/btn_img.png",
                texture_down = "theme231/login/textures/btn_img.png",
                position = {
                    y = -156.183,
                    x = 0.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 15,
            },
            {
                name = "btn_google",
                texture_disable = "theme231/login/textures/google.png",
                content_size = {
                    width = 410,
                    height = 101,
                },
                texture_normal = "theme231/login/textures/google.png",
                texture_down = "theme231/login/textures/google.png",
                position = {
                    y = -244.915,
                    x = 0.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 22,
            },
            {
                name = "btn_googleout",
                texture_disable = "theme231/login/textures/google2.png",
                content_size = {
                    width = 410,
                    height = 101,
                },
                texture_normal = "theme231/login/textures/google2.png",
                texture_down = "theme231/login/textures/google2.png",
                position = {
                    y = -244.915,
                    x = 0.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 29,
            },
        },
    },
}