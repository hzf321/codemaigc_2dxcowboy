return 
{
    {
        plist = {
            "theme325/inspect/packs/inspect.plist",
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
        name = "inspect_facebook_pop",
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
                    width = 804,
                    height = 529,
                },
                frame = "prize_wholebg.png",
                type = "BLSprite",
                name = "prize_wholebg",
            },
            {
                content_size = {
                    width = 97,
                    height = 42,
                },
                frame = "TIPS.png",
                type = "BLSprite",
                name = "TIPS",
                position = {
                    y = 216.732,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 708,
                    height = 225,
                },
                frame = "font_Fb.png",
                type = "BLSprite",
                name = "font_ad",
                position = {
                    y = 21.275,
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
                    y = 245.758,
                    x = 382.331,
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