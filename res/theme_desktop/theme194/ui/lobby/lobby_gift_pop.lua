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
                    name = "theme194/lobby/spines/gift/spine",
                },
                content_size = {
                    width = 739.04,
                    height = 674.35,
                },
                type = "BLSpine",
                name = "gift_spine",
            },
            {
                spine = {
                    defaultSkin = "",
                    isLoop = true,
                    animation = "",
                    name = "theme194/lobby/spines/hand/spine",
                },
                content_size = {
                    width = 208.41,
                    height = 216.59,
                },
                type = "BLSpine",
                name = "hand_spine",
            },
            {
                content_size = {
                    width = 454,
                    height = 228,
                },
                type = "BLSprite",
                name = "label_guide",
                texture = "theme194/lobby/textures/kuang.png",
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
                font_size = 108,
                name = "label_coins",
                content_size = {
                    width = 642,
                    height = 108,
                },
                visible = false,
                vertical_align = 0,
                text = "123,456,789",
                lineHeight = 108,
                position = {
                    y = 43.084,
                    x = 0.0,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme194/ad_reward/fonts/guide.fnt",
            },
        },
    },
}