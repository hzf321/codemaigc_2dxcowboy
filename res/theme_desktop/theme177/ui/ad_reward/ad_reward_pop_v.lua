return 
{
    {
        plist = {
            "theme177/ad_reward/packs/ad_reward.plist",
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
        name = "ad_reward_pop_v",
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
                    name = "theme177/ad_reward/spines/bg_v/spine",
                },
                content_size = {
                    width = 2560,
                    height = 2560,
                },
                type = "BLSpine",
                name = "bg_spine",
                position = {
                    y = -1.0,
                    x = -1.0,
                    z = 0,
                },
            },
            {
                horizontal_align = 0,
                font_size = 18,
                name = "label_coins",
                content_size = {
                    width = 262.13,
                    height = 72,
                },
                vertical_align = 0,
                text = "123456",
                lineHeight = 72,
                position = {
                    y = -62.014,
                    x = 22.188,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme177/ad_reward/fonts/guide.fnt",
            },
            {
                name = "btn_close",
                frame_disable = "close.png",
                content_size = {
                    width = 68,
                    height = 70,
                },
                frame_down = "close.png",
                position = {
                    y = 129.784,
                    x = 325.544,
                    z = 0,
                },
                frame_normal = "close.png",
                type = "BLButton",
                children = {
                },
                target = 9,
            },
            {
                name = "btn_collect",
                frame_disable = "collect.png",
                content_size = {
                    width = 405,
                    height = 95,
                },
                frame_down = "collect.png",
                position = {
                    y = -196.636,
                    x = 2.5,
                    z = 0,
                },
                frame_normal = "collect.png",
                type = "BLButton",
                children = {
                },
                target = 15,
            },
        },
    },
}