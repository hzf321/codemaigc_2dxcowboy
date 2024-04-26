return 
{
    {
        plist = {
            "theme231/inspect/packs/inspect.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_close",
            },
            {
                path = "root.btn_close_ok",
            },
        },
        name = "inspect_ad_pop",
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
                    width = 790,
                    height = 509,
                },
                frame = "prize_wholebg.png",
                type = "BLSprite",
                name = "prize_wholebg",
            },
            {
                content_size = {
                    width = 85,
                    height = 29,
                },
                frame = "TIPS.png",
                type = "BLSprite",
                name = "TIPS",
                position = {
                    y = 230.385,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 619,
                    height = 231,
                },
                frame = "font_ad.png",
                type = "BLSprite",
                name = "font_ad",
                position = {
                    y = 26.702,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                name = "btn_close",
                frame_disable = "delete_btn.png",
                content_size = {
                    width = 68,
                    height = 70,
                },
                frame_down = "delete_btn.png",
                position = {
                    y = 220.176,
                    x = 365.829,
                    z = 0,
                },
                frame_normal = "delete_btn.png",
                type = "BLButton",
                children = {
                },
                target = 12,
            },
            {
                name = "btn_close_ok",
                frame_disable = "ok_btn.png",
                content_size = {
                    width = 335,
                    height = 114,
                },
                frame_down = "ok_btn.png",
                position = {
                    y = -177.467,
                    x = 0.0,
                    z = 0,
                },
                frame_normal = "ok_btn.png",
                type = "BLButton",
                children = {
                },
                target = 18,
            },
        },
    },
}