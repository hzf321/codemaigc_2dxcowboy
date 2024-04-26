return 
{
    {
        plist = {
            "theme188/inspect/packs/inspect.plist",
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
                    width = 716,
                    height = 550,
                },
                frame = "bg_v.png",
                type = "BLSprite",
                name = "prize_wholebg",
            },
            {
                content_size = {
                    width = 100,
                    height = 47,
                },
                frame = "TIPS.png",
                type = "BLSprite",
                name = "TIPS",
                position = {
                    y = 226.184,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 559,
                    height = 203,
                },
                frame = "font_ad_v.png",
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
                    y = 225.751,
                    x = 287.751,
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