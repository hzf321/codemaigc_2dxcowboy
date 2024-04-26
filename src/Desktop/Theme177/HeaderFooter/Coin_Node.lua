local BLNode      = require("UI/CreatorUI/BLNode")

local Coin_Node = class("Coin_Node", BLNode)

function Coin_Node:ctor(isPortrait)
    self.isPortrait  = isPortrait
    self.start_scale = 0.95
    self.width       = 179
    self.nPos        = self.isPortrait and cc.p(-169.306, -50.5) or cc.p(-177, -34)
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
    local coin = User:getInstance():getCoins()
    self.label_coins:setString(FONTS.format(coin, true))

    inherit(self.label_coins, LabelNumRoll)
    local parserFunc = function (n)
        return FONTS.format(n, true)
    end
    self.label_coins:nrInit(coin, 25, parserFunc)
end


return Coin_Node