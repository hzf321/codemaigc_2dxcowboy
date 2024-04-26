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
                    width = 720,
                    height = 1560,
                },
                type = "BLSprite",
                name = "login_bg",
                texture = "theme220/login/textures/background.png",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme220/login/spines/Tongyong_baowu",
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
                    width = 820,
                    height = 1209,
                },
                type = "BLSprite",
                name = "login_man",
                texture = "theme220/login/textures/apolo.png",
                position = {
                    y = -107.773,
                    x = -28.453,
                    z = 0,
                },
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme220/login/spines/Tongyong_xingxing",
                },
                content_size = {
                    width = 270.5,
                    height = 270.5,
                },
                type = "BLSpine",
                name = "star",
                position = {
                    y = -155.021,
                    x = 46.732,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 720,
                    height = 764,
                },
                type = "BLSprite",
                name = "cloud",
                texture = "theme220/login/textures/cloud.png",
                position = {
                    y = -587.469,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                name = "btn_play",
                texture_disable = "theme220/login/textures/button.png",
                content_size = {
                    width = 10,
                    height = 10,
                },
                texture_normal = "theme220/login/textures/button.png",
                texture_down = "theme220/login/textures/button.png",
                position = {
                    y = -456.099,
                    x = 4.857,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 18,
            },
        },
    },
}