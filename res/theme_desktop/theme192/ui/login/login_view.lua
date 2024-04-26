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
                texture = "theme192/login/textures/background.png",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme192/login/spines/Tongyong_baowu",
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
                    width = 918,
                    height = 1334,
                },
                type = "BLSprite",
                name = "login_man",
                texture = "theme192/login/textures/apolo.png",
                position = {
                    y = -107.773,
                    x = -28.453,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 720,
                    height = 353,
                },
                type = "BLSprite",
                name = "cloud",
                texture = "theme192/login/textures/cloud.png",
                position = {
                    y = -587.469,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                name = "btn_play",
                texture_disable = "theme192/login/textures/button.png",
                content_size = {
                    width = 10,
                    height = 10,
                },
                texture_normal = "theme192/login/textures/button.png",
                texture_down = "theme192/login/textures/button.png",
                position = {
                    y = -355.178,
                    x = 4.857,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 15,
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme192/login/spines/Tongyong_xingxing",
                },
                content_size = {
                    width = 270.5,
                    height = 270.5,
                },
                type = "BLSpine",
                name = "star",
                position = {
                    y = -321.705,
                    x = -37.018,
                    z = 0,
                },
            },
            {
                name = "btn_google",
                texture_disable = "theme192/login/textures/google.png",
                content_size = {
                    width = 10,
                    height = 10,
                },
                texture_normal = "theme192/login/textures/google.png",
                texture_down = "theme192/login/textures/google.png",
                position = {
                    y = -493.051,
                    x = 4.857,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 25,
            },
        },
    },
}