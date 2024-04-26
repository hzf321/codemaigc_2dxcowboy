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
                    width = 720,
                    height = 1560,
                },
                type = "BLSprite",
                name = "login_bg",
                texture = "theme225/login/textures/background.png",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme225/login/spines/Tongyong_baowu",
                },
                content_size = {
                    width = 1448.73,
                    height = 603.7,
                },
                type = "BLSpine",
                name = "mist",
                position = {
                    y = 173.598,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 976,
                    height = 1247,
                },
                type = "BLSprite",
                name = "login_man",
                texture = "theme225/login/textures/apolo.png",
                position = {
                    y = -69.902,
                    x = 64.09,
                    z = 0,
                },
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme225/login/spines/Tongyong_xingxing",
                },
                content_size = {
                    width = 270.5,
                    height = 270.5,
                },
                type = "BLSpine",
                name = "star",
                position = {
                    y = 339.603,
                    x = 5.305,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 720,
                    height = 488,
                },
                type = "BLSprite",
                name = "cloud",
                texture = "theme225/login/textures/cloud.png",
                position = {
                    y = -587.469,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                name = "btn_play",
                texture_disable = "theme225/login/textures/button.png",
                content_size = {
                    width = 10,
                    height = 10,
                },
                texture_normal = "theme225/login/textures/button.png",
                texture_down = "theme225/login/textures/button.png",
                position = {
                    y = -389.644,
                    x = 4.857,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 18,
            },
            {
                name = "btn_google",
                texture_disable = "theme225/login/textures/google.png",
                content_size = {
                    width = 10,
                    height = 10,
                },
                texture_normal = "theme225/login/textures/google.png",
                texture_down = "theme225/login/textures/google.png",
                position = {
                    y = -523.333,
                    x = 4.857,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 25,
            },
            {
                name = "btn_googleout",
                texture_disable = "theme225/login/textures/google2.png",
                content_size = {
                    width = 10,
                    height = 10,
                },
                texture_normal = "theme225/login/textures/google2.png",
                texture_down = "theme225/login/textures/google2.png",
                position = {
                    y = -523.333,
                    x = 4.857,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 32,
            },
        },
    },
}