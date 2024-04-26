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
                texture = "theme244/login/textures/login_bg.png",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme244/login/spines/mist/Tongyong_baowu",
                },
                content_size = {
                    width = 1448.73,
                    height = 603.7,
                },
                type = "BLSpine",
                name = "mist",
            },
            {
                content_size = {
                    width = 862,
                    height = 676,
                },
                type = "BLSprite",
                name = "login_man",
                texture = "theme244/login/textures/login_man.png",
                position = {
                    y = 0.0,
                    x = -111.107,
                    z = 0,
                },
            },
            {
                name = "btn_play",
                texture_disable = "theme244/login/textures/btn_img.png",
                content_size = {
                    width = 410,
                    height = 101,
                },
                texture_normal = "theme244/login/textures/btn_img.png",
                texture_down = "theme244/login/textures/btn_img.png",
                position = {
                    y = -157.597,
                    x = 0.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 12,
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme244/login/spines/star/Tongyong_xingxing",
                },
                content_size = {
                    width = 270.5,
                    height = 270.5,
                },
                type = "BLSpine",
                name = "starAnim",
                position = {
                    y = -128.076,
                    x = -31.176,
                    z = 0,
                },
            },
            {
                name = "btn_google",
                texture_disable = "theme244/login/textures/signin.png",
                content_size = {
                    width = 410,
                    height = 101,
                },
                texture_normal = "theme244/login/textures/signin.png",
                texture_down = "theme244/login/textures/signin.png",
                position = {
                    y = -268.0,
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
                texture_disable = "theme244/login/textures/signout.png",
                content_size = {
                    width = 410,
                    height = 101,
                },
                texture_normal = "theme244/login/textures/signout.png",
                texture_down = "theme244/login/textures/signout.png",
                position = {
                    y = -268.0,
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