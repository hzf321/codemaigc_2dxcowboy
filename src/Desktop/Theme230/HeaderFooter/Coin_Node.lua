local BLNode      = require("UI/CreatorUI/BLNode")

local getSpinePath = function(name)
	return string.format("theme_desktop/theme%d/lobby/%s/", THEME_DESKTOP_ID, name)
end
local Coin_Node = class("Coin_Node", BLNode)

function Coin_Node:ctor(isPortrait)
    self.isPortrait  = bole.isThemeScene()
    self.start_scale = 0.95
    self.width       = 179
    self.nPos        = self.isPortrait and cc.p(-121, -38) or cc.p(-94.317, 9)
    self.csb         = "ui/header_footer/coin_node"
    self.node        = CreatorUITools:getInstance():createUi(self.csb);
    self:addChild(self.node)
    self:loadControls()
end

function Coin_Node:loadControls()
    self.root = self.node.root

    self.coin_node = self.root
    self.coin_node:setPosition(self.nPos)

    self.sp_coin   = self.root.sp_coin

    self.label_coins = self.root.label_coins

    local tongyongDi = self.root.kuang_3
    local coin_bg = self.root.coin_bg

    if  self.isPortrait then
        tongyongDi:setVisible(true)
        coin_bg:setVisible(false)
        local file = getSpinePath("fonts2") .. "tip_num.fnt"
        self.label_coins:setFntFile(file)
    else
        tongyongDi:setVisible(false)
        coin_bg:setVisible(true)
        local file = getSpinePath("fonts") .. "tip_num.fnt"
        self.label_coins:setFntFile(file)
    end
    


    local coin = User:getInstance():getCoins()
    self.label_coins:setString(FONTS.format(coin, true))

    inherit(self.label_coins, LabelNumRoll)
    local parserFunc = function (n)
        return FONTS.format(n, true)
    end
    self.label_coins:nrInit(coin, 25, parserFunc)
end


return Coin_Node