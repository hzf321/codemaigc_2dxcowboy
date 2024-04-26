return 
{
    {
        plist = {
            "theme186/ad_reward/packs/ad_reward.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_close",
            },
            {
                path = "root.btn_collect",
            },
        },
        name = "ad_reward_pop",
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
                    defaultSkin = "",
                    isLoop = true,
                    animation = "",
                    name = "theme186/ad_reward/spines/bg_h/spine",
                },
                content_size = {
                    width = 2560,
                    height = 2560,
                },
                type = "BLSpine",
                name = "bg_spine",
            },
            {
                name = "btn_close",
                frame_disable = "close.png",
                content_size = {
                    width = 68,
                    height = 70,
                },
                texture_normal = "theme186/ad_reward/textures/close.png",
                frame_down = "close.png",
                position = {
                    y = 256.405,
                    x = 311.072,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 6,
            },
            {
                horizontal_align = 0,
                font_size = 52,
                name = "label_coins",
                content_size = {
                    width = 218.52,
                    height = 52,
                },
                vertical_align = 0,
                text = "982,234",
                lineHeight = 52,
                position = {
                    y = -154.098,
                    x = 0.0,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme186/ad_reward/fonts/guide.fnt",
            },
            {
                name = "btn_collect",
                texture_disable = "theme186/ad_reward/textures/button.png",
                content_size = {
                    width = 405,
                    height = 95,
                },
                texture_normal = "theme186/ad_reward/textures/button.png",
                texture_down = "theme186/ad_reward/textures/button.png",
                position = {
                    y = -297.471,
                    x = 0.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 15,
            },
        },
    },
}