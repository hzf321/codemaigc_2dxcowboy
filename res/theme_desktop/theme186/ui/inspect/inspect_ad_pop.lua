return 
{
    {
        plist = {
            "theme186/inspect/packs/inspect.plist",
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
                    width = 708,
                    height = 532,
                },
                frame = "prize_wholebg.png",
                type = "BLSprite",
                name = "prize_wholebg",
            },
            {
                content_size = {
                    width = 93,
                    height = 46,
                },
                frame = "tips_tittle.png",
                type = "BLSprite",
                name = "TIPS",
                position = {
                    y = 224.544,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 552,
                    height = 171,
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
                    y = 233.439,
                    x = 299.539,
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
                    width = 405,
                    height = 95,
                },
                frame_down = "ok_btn.png",
                position = {
                    y = -189.709,
                    x = 0.5,
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