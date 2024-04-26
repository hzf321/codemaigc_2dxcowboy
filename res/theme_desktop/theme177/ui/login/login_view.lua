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
                texture = "theme177/login/textures/login_bg.png",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme177/login/spines/sunlight/spine",
                },
                content_size = {
                    width = 1953.28,
                    height = 1671.14,
                },
                type = "BLSpine",
                name = "sunlight",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme177/login/spines/dragon/spine",
                },
                content_size = {
                    width = 705,
                    height = 688,
                },
                type = "BLSpine",
                name = "dragon",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme177/login/spines/dust/spine",
                },
                content_size = {
                    width = 1168.94,
                    height = 468.27,
                },
                type = "BLSpine",
                name = "dust",
            },
            {
                name = "btn_play",
                texture_disable = "theme177/login/textures/btn_img.png",
                content_size = {
                    width = 410,
                    height = 101,
                },
                texture_normal = "theme177/login/textures/btn_img.png",
                texture_down = "theme177/login/textures/btn_img.png",
                position = {
                    y = -258.0,
                    x = 0.0,
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
                    animation = "",
                    name = "theme177/login/spines/cloud/spine",
                },
                content_size = {
                    width = 2590,
                    height = 2362,
                },
                type = "BLSpine",
                name = "cloudAnim",
                visible = false,
            },
        },
    },
}