local BLNode      = require("UI/CreatorUI/BLNode")

local Diamond_Node = class("Coin_Node", BLNode)

local getSpinePath = function(name)
	return string.format("theme_desktop/theme%d/lobby/%s/", THEME_DESKTOP_ID, name)
end

function Diamond_Node:ctor(isPortrait)
    self.isPortrait  = bole.isThemeScene()
    self.start_scale = 0.95
    self.width       = 179
    self.nPos        = self.isPortrait and cc.p(110, -38) or cc.p(127.474, 9)
    self.csb         = "ui/header_footer/diamond_node"
    self.node        = CreatorUITools:getInstance():createUi(self.csb);
    self:addChild(self.node)
    self:loadControls()
end

function Diamond_Node:loadControls()
    self.root = self.node.root
    print(self.isPortrait, "self.isPortraitself.isPortrait")
    self.diamond_node = self.root
    self.diamond_node  :setPosition(self.nPos)
    self.sp_diamond   = self.root.sp_diamond

    
    self.label_diamonds = self.root.label_diamonds

    local tongyongDi = self.root.kuang_3
    local diamond_bg = self.root.diamond_bg
    if  self.isPortrait then
        tongyongDi:setVisible(true)
        diamond_bg:setVisible(false)

        local file = getSpinePath("fonts2") .. "tip_num.fnt"
        self.label_diamonds:setFntFile(file)
    else
        tongyongDi:setVisible(false)
        diamond_bg:setVisible(true)

        local file = getSpinePath("fonts") .. "tip_num.fnt"
        self.label_diamonds:setFntFile(file)
    end
 
    local diamonds = User:getInstance():getDiamonds()
    self.label_diamonds:setString(FONTS.format(diamonds, true))

    inherit(self.label_diamonds, LabelNumRoll)
    local parserFunc = function (n)
        return FONTS.format(n, true)
    end
    self.label_diamonds:nrInit(diamonds, 25, parserFunc)
end


return Diamond_Node