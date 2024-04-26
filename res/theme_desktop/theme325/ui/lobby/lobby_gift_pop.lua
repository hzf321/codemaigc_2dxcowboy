return 
{
    {
        plist = {
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_collect",
            },
        },
        name = "lobby_gift_pop",
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
                    name = "theme325/lobby/spines/gift/spine",
                },
                content_size = {
                    width = 739.04,
                    height = 679.77,
                },
                type = "BLSpine",
                name = "gift_spine",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "",
                    name = "theme325/lobby/spines/hand/spine",
                },
                content_size = {
                    width = 0,
                    height = 0,
                },
                type = "BLSpine",
                name = "hand_spine",
            },
            {
                content_size = {
                    width = 408,
                    height = 178,
                },
                type = "BLSprite",
                name = "label_guide",
                texture = "theme325/lobby/textures/kuang.png",
                position = {
                    y = 100.0,
                    x = 350.0,
                    z = 0,
                },
            },
            {
                scale = {
                    y = 72,
                    x = 156,
                },
                name = "btn_collect",
                texture_disable = "commonpics/kong.png",
                content_size = {
                    width = 10,
                    height = 10,
                },
                texture_normal = "commonpics/kong.png",
                texture_down = "commonpics/kong.png",
                type = "BLButton",
                children = {
                },
                target = 12,
            },
            {
                horizontal_align = 0,
                font_size = 40,
                name = "label_coins",
                content_size = {
                    width = 622.5,
                    height = 150,
                },
                visible = false,
                vertical_align = 0,
                text = "1800000",
                lineHeight = 150,
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme325/ad_reward/fonts/guide.fnt",
            },
        },
    },
}