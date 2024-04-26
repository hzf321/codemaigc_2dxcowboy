return 
{
    {
        plist = {
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_connect",
            },
            {
                path = "root.btn_close",
            },
        },
        name = "facebook_pop",
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
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "2_loop",
                    name = "theme188/facebook/spines/bg/spine",
                },
                content_size = {
                    width = 2560,
                    height = 2560,
                },
                type = "BLSpine",
                name = "bg_spine",
                position = {
                    y = 2.0,
                    x = 12.0,
                    z = 0,
                },
            },
            {
                horizontal_align = 0,
                font_size = 18,
                name = "label_diamonds",
                content_size = {
                    width = 295.31,
                    height = 72,
                },
                vertical_align = 0,
                text = "982,324",
                lineHeight = 72,
                position = {
                    y = -63.769,
                    x = 3.53,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme188/ad_reward/fonts/guide.fnt",
            },
            {
                name = "btn_connect",
                texture_disable = "theme188/facebook/textures/facebook_btn.png",
                content_size = {
                    width = 405,
                    height = 95,
                },
                texture_normal = "theme188/facebook/textures/facebook_btn.png",
                texture_down = "theme188/facebook/textures/facebook_btn.png",
                position = {
                    y = -197.102,
                    x = -11.5,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 9,
            },
            {
                name = "btn_close",
                texture_disable = "theme188/facebook/textures/delete_btn.png",
                content_size = {
                    width = 68,
                    height = 70,
                },
                texture_normal = "theme188/facebook/textures/delete_btn.png",
                texture_down = "theme188/facebook/textures/delete_btn.png",
                position = {
                    y = 220.634,
                    x = 349.44,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 16,
            },
        },
    },
}