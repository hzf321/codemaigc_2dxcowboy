local BLNode      = require("UI/CreatorUI/BLNode")

local Diamond_Node = class("Coin_Node", BLNode)

function Diamond_Node:ctor(isPortrait)
    self.isPortrait  = bole.isThemeScene()
    self.start_scale = 0.95
    self.width       = 179
    self.nPos        = self.isPortrait and cc.p(100, -36.5) or cc.p(-403, -34)
    self.csb         = "ui/header_footer/diamond_node"
    self.node        = CreatorUITools:getInstance():createUi(self.csb);
    self:addChild(self.node)
    self:loadControls()
end

function Diamond_Node:loadControls()
    self.root = self.node.root

    self.diamond_node = self.root
    self.diamond_node:setPosition(self.nPos)

    self.sp_diamond   = self.root.sp_diamond

    self.label_diamonds = self.root.label_diamonds
    local diamonds = User:getInstance():getDiamonds()
    self.label_diamonds:setString(FONTS.format(diamonds, true))

    inherit(self.label_diamonds, LabelNumRoll)
    local parserFunc = function (n)
        return FONTS.format(n, true)
    end
    self.label_diamonds:nrInit(diamonds, 25, parserFunc)
end


return Diamond_Node