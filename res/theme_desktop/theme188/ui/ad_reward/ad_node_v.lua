return 
{
    {
        plist = {
            "theme188/ad_reward/packs/ad_reward.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_open",
            },
            {
                path = "root.box_node.box_5.btn_reward",
            },
            {
                path = "root.box_node.box_10.btn_reward",
            },
            {
                path = "root.box_node.box_15.btn_reward",
            },
        },
        name = "ad_node_v",
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
                name = "ad_progress",
                content_size = {
                    width = 228,
                    height = 16,
                },
                frame = "ad_5.png",
                position = {
                    y = -14.0,
                    x = 178.0,
                    z = 0,
                },
                type = "BLSpriteBar",
                cap_insets = {
                    y = 0,
                    x = 8,
                    height = 16,
                    width = 8,
                },
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme188/ad_reward/spines/progress/spine",
                },
                content_size = {
                    width = 448,
                    height = 84,
                },
                type = "BLSpine",
                name = "progress_spine",
                position = {
                    y = -14.0,
                    x = 178.0,
                    z = 0,
                },
            },
            {
                name = "ad_icon",
                content_size = {
                    width = 57,
                    height = 63,
                },
                frame = "ad_1.png",
                position = {
                    y = 2.5,
                    x = 39.5,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        content_size = {
                            width = 78,
                            height = 27,
                        },
                        frame = "ad_2.png",
                        type = "BLSprite",
                        name = "ad_coin",
                        position = {
                            y = 12.619,
                            x = 29.0,
                            z = 0,
                        },
                    },
                },
            },
            {
                scale = {
                    y = 7,
                    x = 30.6,
                },
                name = "btn_open",
                texture_disable = "commonpics/kong.png",
                content_size = {
                    width = 10,
                    height = 10,
                },
                texture_normal = "commonpics/kong.png",
                texture_down = "commonpics/kong.png",
                position = {
                    y = 2.0,
                    x = 176.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 18,
            },
            {
                position = {
                    y = 0,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "box_node",
                children = {
                    {
                        position = {
                            y = 7,
                            x = 140.152,
                            z = 0,
                        },
                        type = "BLNode",
                        name = "box_5",
                        children = {
                            {
                                spine = {
                                    defaultSkin = "default",
                                    isLoop = true,
                                    animation = "baoxiang1_daiji",
                                    name = "theme188/ad_reward/spines/box/spine",
                                },
                                content_size = {
                                    width = 140.39,
                                    height = 142.76,
                                },
                                type = "BLSpine",
                                name = "box_spine",
                                position = {
                                    y = -7.0,
                                    x = 2.0,
                                    z = 0,
                                },
                            },
                            {
                                content_size = {
                                    width = 32,
                                    height = 18,
                                },
                                frame = "ad_3.png",
                                type = "BLSprite",
                                name = "bg",
                                position = {
                                    y = -26.5,
                                    x = 2.0,
                                    z = 0,
                                },
                            },
                            {
                                horizontal_align = 0,
                                font_size = 20,
                                name = "label_count",
                                content_size = {
                                    width = 9.36,
                                    height = 20,
                                },
                                vertical_align = 1,
                                text = "5",
                                lineHeight = 20,
                                position = {
                                    y = -29.0,
                                    x = 2.0,
                                    z = 0,
                                },
                                overflow = 3,
                                type = "BLBMFont",
                                font_name = "theme188/ad_reward/fonts/coin_num.fnt",
                            },
                            {
                                scale = {
                                    y = 6,
                                    x = 6,
                                },
                                name = "btn_reward",
                                texture_disable = "commonpics/kong.png",
                                content_size = {
                                    width = 10,
                                    height = 10,
                                },
                                texture_normal = "commonpics/kong.png",
                                texture_down = "commonpics/kong.png",
                                position = {
                                    y = -4.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 36,
                            },
                        },
                    },
                    {
                        position = {
                            y = 7,
                            x = 216.076,
                            z = 0,
                        },
                        type = "BLNode",
                        name = "box_10",
                        children = {
                            {
                                spine = {
                                    defaultSkin = "default",
                                    isLoop = true,
                                    animation = "baoxiang2_daiji",
                                    name = "theme188/ad_reward/spines/box/spine",
                                },
                                content_size = {
                                    width = 140.39,
                                    height = 142.76,
                                },
                                type = "BLSpine",
                                name = "box_spine",
                                position = {
                                    y = -5.0,
                                    x = 3.0,
                                    z = 0,
                                },
                            },
                            {
                                content_size = {
                                    width = 32,
                                    height = 18,
                                },
                                frame = "ad_3.png",
                                type = "BLSprite",
                                name = "bg",
                                position = {
                                    y = -26.5,
                                    x = 2.0,
                                    z = 0,
                                },
                            },
                            {
                                horizontal_align = 0,
                                font_size = 20,
                                name = "label_count",
                                content_size = {
                                    width = 21.25,
                                    height = 20,
                                },
                                vertical_align = 1,
                                text = "10",
                                lineHeight = 20,
                                position = {
                                    y = -29.0,
                                    x = 2.0,
                                    z = 0,
                                },
                                overflow = 0,
                                type = "BLBMFont",
                                font_name = "theme188/ad_reward/fonts/coin_num.fnt",
                            },
                            {
                                scale = {
                                    y = 6,
                                    x = 6,
                                },
                                name = "btn_reward",
                                texture_disable = "commonpics/kong.png",
                                content_size = {
                                    width = 10,
                                    height = 10,
                                },
                                texture_normal = "commonpics/kong.png",
                                texture_down = "commonpics/kong.png",
                                position = {
                                    y = -4.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 54,
                            },
                        },
                    },
                    {
                        position = {
                            y = 6,
                            x = 292,
                            z = 0,
                        },
                        type = "BLNode",
                        name = "box_15",
                        children = {
                            {
                                spine = {
                                    defaultSkin = "default",
                                    isLoop = true,
                                    animation = "baoxiang3_daiji",
                                    name = "theme188/ad_reward/spines/box/spine",
                                },
                                content_size = {
                                    width = 140.39,
                                    height = 142.76,
                                },
                                type = "BLSpine",
                                name = "box_spine",
                                position = {
                                    y = -6.0,
                                    x = 0.0,
                                    z = 0,
                                },
                            },
                            {
                                content_size = {
                                    width = 32,
                                    height = 18,
                                },
                                frame = "ad_3.png",
                                type = "BLSprite",
                                name = "bg",
                                position = {
                                    y = -26.5,
                                    x = 2.0,
                                    z = 0,
                                },
                            },
                            {
                                horizontal_align = 0,
                                font_size = 20,
                                name = "label_count",
                                content_size = {
                                    width = 21.25,
                                    height = 20,
                                },
                                vertical_align = 1,
                                text = "15",
                                lineHeight = 20,
                                position = {
                                    y = -29.0,
                                    x = 2.0,
                                    z = 0,
                                },
                                overflow = 0,
                                type = "BLBMFont",
                                font_name = "theme188/ad_reward/fonts/coin_num.fnt",
                            },
                            {
                                scale = {
                                    y = 6,
                                    x = 6,
                                },
                                name = "btn_reward",
                                texture_disable = "commonpics/kong.png",
                                content_size = {
                                    width = 10,
                                    height = 10,
                                },
                                texture_normal = "commonpics/kong.png",
                                texture_down = "commonpics/kong.png",
                                position = {
                                    y = -4.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 72,
                            },
                        },
                    },
                },
            },
        },
    },
}