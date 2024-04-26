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
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "",
                    name = "theme186/lobby/spines/gift/spine",
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
                    name = "theme186/lobby/spines/hand/spine",
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
                    width = 394,
                    height = 228,
                },
                type = "BLSprite",
                name = "label_guide",
                texture = "theme186/lobby/textures/kuang.png",
                position = {
                    y = -228.298,
                    x = -10.524,
                    z = 0,
                },
            },
            {
                scale = {
                    y = 156,
                    x = 72,
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
                font_size = 89,
                name = "label_coins",
                content_size = {
                    width = 564,
                    height = 89,
                },
                visible = false,
                vertical_align = 0,
                text = "123,456,789",
                lineHeight = 89,
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme186/ad_reward/fonts/guide.fnt",
            },
        },
    },
}