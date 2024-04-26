local Ad_Reward_Node = require (bole.getDesktopFilePath("AdReward/Ad_Reward_Node"))
local Coin_Node      = require (bole.getDesktopFilePath("HeaderFooter/Coin_Node"))
local Diamond_Node   = require (bole.getDesktopFilePath("HeaderFooter/Diamond_Node"))
local BLNode         = require("UI/CreatorUI/BLNode")

local Header_Node = class("Header_Node", BLNode)

function Header_Node:ctor(theCtl, isPortrait)
    self.themeCtl   = theCtl
    self.isPortrait = isPortrait
    self.ctl        = HeaderFooterControl:getInstance()
    self.csb        = string.format("ui/header_footer/%s", self.isPortrait and "theme_header" or "lobby_header")
    self.node       = CreatorUITools:getInstance():createUi(self.csb);
    self:addChild(self.node)
    self:initButtonListToNode(false)
    self:loadControls()
    self:initFaceBook()
end

function Header_Node:loadControls()
    self.root = self.node.root
    
    self:configCoinNode()
    self:configDiamondNode()
    if not bole.isThemeScene() then
        self:addAdRewardNode()
    end
end

function Header_Node: initFaceBook()
    local state = User:getInstance():isloginFB()
    local facebook_node = self.root.facebook_node
    if facebook_node then
        if state then
            facebook_node:setVisible(false)
         else
             facebook_node:setVisible(true)
         end
    end
end

-- 配置金币
function Header_Node:configCoinNode()
    self.coin_node = self:createHeaderCoinNode()
end

-- 创建金币节点
function Header_Node:createHeaderCoinNode(is_self)
    if is_self and self.coin_node then
        return self.coin_node
    end

    local ui_coin = Coin_Node.new(self.isPortrait)
    self.ui_coins   = self.ui_coins or {}
    self.ui_coins[#self.ui_coins + 1] = ui_coin
    self.root:addChild(ui_coin)

    return ui_coin
end

--[[
* 名称：addCoins
* 功能：1s将金币加到金币栏
* 参数：
	- start：金币初始值
	- off：金币增加值
* 返回值：无
]]--
function Header_Node:addCoins(start, off)
    local dur 			= 1
    self:setCoinsScale(start, start + off)

    if self.ui_coins then
        for k, ui in pairs(self.ui_coins) do
            if ui and libUI.isValidNode(ui.label_coins) then
                ui.label_coins:nrStartRoll(nil, start + off, dur, nil)
            end
        end
    end
end

function Header_Node:setCoinsScale(before, after)
    if self.ui_coins then
        for k, coin_node in pairs(self.ui_coins) do
            if libUI.isValidNode(coin_node) then
                coin_node.label_coins:setString(self.ctl:formatCoin(after))
                bole.shrinkLabel(coin_node.label_coins, coin_node.width, coin_node.start_scale)
                coin_node.label_coins:setString(self.ctl:formatCoin(before))
            end
        end
    end
end

--[[
* 名称：addChips
* 功能：1s将金币加到金币栏
* 参数：
	- start：金币初始值
	- off：金币增加值
* 返回值：无
]]--
function Header_Node:addChips(start, off)
    local dur 			= 1
    self:setChipsScale(start, start + off)

    if self.ui_diamonds then
        for k, ui in pairs(self.ui_diamonds) do
            if ui and libUI.isValidNode(ui.label_diamonds) then
                ui.label_diamonds:nrStartRoll(nil, start + off, dur, nil)
            end
        end
    end
end

function Header_Node:getDiamondNode()
    return self.diamond_node
end

function Header_Node:setChipsScale(before, after)
    if self.ui_diamonds then
        for k, Diamond_Node in pairs(self.ui_diamonds) do
            if libUI.isValidNode(Diamond_Node) then
                Diamond_Node.label_diamonds:setString(self.ctl:formatCoin(after))
                bole.shrinkLabel(Diamond_Node.label_diamonds, Diamond_Node.width, Diamond_Node.start_scale)
                Diamond_Node.label_diamonds:setString(self.ctl:formatCoin(before))
            end
        end
    end
end


-- 配置钻石
function Header_Node:configDiamondNode()
    -- if self.isPortrait then return end
    self.diamond_node = self:createHeaderDiamondNode()
end

-- 创建钻石节点
function Header_Node:createHeaderDiamondNode(is_self)
    if is_self and self.diamond_node then
        return self.diamond_node
    end

    local ui_diamond = Diamond_Node.new()
    self.ui_diamonds = self.ui_diamonds or {}
    self.ui_diamonds[#self.ui_diamonds + 1] = ui_diamond
    self.root:addChild(ui_diamond)

    return ui_diamond
end

-- 添加广告奖励
function Header_Node:addAdRewardNode()
    local pos = self.isPortrait and cc.p(-56, -40) or cc.p(-11, -37)
    local ad_node = Ad_Reward_Node.new(pos, self.isPortrait)
    self.root:addChild(ad_node)
end

-- 入场动画
function Header_Node:enterAction(isFromTheme)
    if isFromTheme then return end
    
    local posGap = 200
    self.node:setPositionY(self.node:getPositionY() + posGap);
    self.node:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(0.5),
            cc.MoveBy:create(0.8, cc.p(0, -posGap))
        )
    )

end


function Header_Node:LobbyBtnState()
end

-- 返回大厅
function Header_Node:onBtnLobbyClicked()
    self.themeCtl:unregisterPotpCmds()
	self.themeCtl.theme:unloadThemeMusics()

	local screenCtl = ScreenControl:getInstance()
    screenCtl:setScreenOrientation(false)
    bole.playSounds("click")
    local Lobby_Scene = require (bole.getDesktopScenePath("Lobby"))
    local scene = Lobby_Scene.new("Play")
    scene:run()
    HttpManager:getInstance():doReport(ReportConfig.btn_backlobby_play)
end

function Header_Node:onBtnCloseClicked()
    
end

-- 打开脸书弹窗
function Header_Node:onBtnFacebookClicked()
    bole.playSounds("click")
    local hideBtnCallBackBtn = function ()
        User:getInstance():updateLoginFBState(1)
        local facebook_node = self.root.facebook_node
        if condition then
            facebook_node:setVisible(false)
        end
    end
    -- PopupController:getInstance():popupDialogDirectly("facebook",{hideCallBack = hideBtnCallBackBtn})
    PopupController:getInstance():popupDialogDirectly("freecoins")
    HttpManager:getInstance():doReport(ReportConfig.btn_facebook_lobby)
end

-- 打开设置弹窗
function Header_Node:onBtnSettingClicked()
	bole.playSounds("click")
    local wPos = bole.getWorldPos(self.root.btn_setting)
    PopupController:getInstance():popupDialogDirectly("setting", {pos = wPos})
end

return Header_Node