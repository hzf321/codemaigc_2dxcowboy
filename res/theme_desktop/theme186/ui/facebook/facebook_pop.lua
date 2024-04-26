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
                    animation = "",
                    name = "theme186/facebook/spines/bg/spine",
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
                font_size = 52,
                name = "label_diamonds",
                content_size = {
                    width = 92.9,
                    height = 52,
                },
                vertical_align = 0,
                text = "100",
                lineHeight = 52,
                position = {
                    y = -54.395,
                    x = 0.0,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme186/ad_reward/fonts/guide.fnt",
            },
            {
                name = "btn_connect",
                texture_disable = "theme186/facebook/textures/facebook_btn.png",
                content_size = {
                    width = 405,
                    height = 95,
                },
                texture_normal = "theme186/facebook/textures/facebook_btn.png",
                texture_down = "theme186/facebook/textures/facebook_btn.png",
                position = {
                    y = -189.816,
                    x = 0.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 9,
            },
            {
                name = "btn_close",
                texture_disable = "theme186/facebook/textures/delete_btn.png",
                content_size = {
                    width = 68,
                    height = 70,
                },
                texture_normal = "theme186/facebook/textures/delete_btn.png",
                texture_down = "theme186/facebook/textures/delete_btn.png",
                position = {
                    y = 236.638,
                    x = 317.235,
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