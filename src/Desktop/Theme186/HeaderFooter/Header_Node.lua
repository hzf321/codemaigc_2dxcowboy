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
    self: initFaceBook()

end

function Header_Node:loadControls()
    self.root = self.node.root
    
    self:configCoinNode()
    self:configDiamondNode()
    -- self:addAdRewardNode()
    self:lobbyBtnlistenEvent()
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
    if self.isPortrait then return end
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
    local pos = self.isPortrait and cc.p(-56, -50) or cc.p(130, -37)
    local ad_node = Ad_Reward_Node.new(pos, self.isPortrait)
    self.root:addChild(ad_node)
end

-- 入场动画
function Header_Node:enterAction(delayTime)
    -- if isFromTheme then return end
    
    local posGap = 200
    self.node:setPositionY(self.node:getPositionY() + posGap);
    self.node:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(delayTime),
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
    screenCtl:setScreenOrientation(true)
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

-- 打开广告奖励弹窗
function Header_Node:onBtnFadvertiseClicked()
    bole.playSounds("click")
    -- PopupController:getInstance():popupDialogDirectly("ad_reward")
    PopupController:getInstance():popupDialogDirectly("ad_reward")
    HttpManager:getInstance():doReport(ReportConfig.btn_video_lobby)
end

-- 大厅按钮监听
function Header_Node:lobbyBtnlistenEvent()
    local index = 0
    local warehouse_node = self.root.warehouse_node
    if warehouse_node then
        for _, btn in pairs(warehouse_node:getChildren()) do
            index = index + 1
            local num = index
            -- local posX, posY = btn:getPosition()
            local pos = btn:getParent():convertToWorldSpace(cc.p(btn:getPosition()))
            local pos  = self:convertToNodeSpace(pos)

            local function onShowTip()
                bole.playSounds("click")
                if num == 1 then
                    HttpManager:getInstance():doReport(ReportConfig.btn_top_6_lobby)
                elseif num == 2 then
                    HttpManager:getInstance():doReport(ReportConfig.btn_top_7_lobby)
                else
                    HttpManager:getInstance():doReport(ReportConfig.btn_top_8_lobby)
                end
                if libUI.isValidNode(self) and libUI.isValidNode(btn) then
                    self:showTip(pos.x, pos.y, num)
                end
            end
            bole.ctorUIComponent(btn, UIComponent.CommonButton, UIComponent.CommonButton.Enum.ONLY_GRAY)
            self:addTouchEvent(btn, onShowTip)
        end
    end
    local tip_node = self.root.tip_node
	if tip_node then
		tip_node:setVisible(false)
    end
end

-- 弹窗气泡窗
function Header_Node:showTip(posX, posY, index)
	local tip_node = self.root.tip_node
    local unlockArr = {500,600,650,700,750,800,900,950,1000}
	if tip_node then
        local label_diamonds = tip_node.label_diamonds
        label_diamonds:setString(unlockArr[index])

		tip_node:setVisible(true)
		tip_node:stopAllActions()
		tip_node:setOpacity(0)
		tip_node:setScale(0)
        tip_node:setPosition(posX, posY - 80)
		tip_node:runAction(
			cc.Sequence:create(
				cc.Spawn:create(cc.FadeIn:create(0.2), cc.ScaleTo:create(0.2, 1)),
				cc.DelayTime:create(1.5),
				cc.Spawn:create(cc.FadeOut:create(0.2), cc.ScaleTo:create(0.2, 0)),
				cc.CallFunc:create(function ()
					tip_node:setVisible(false)
				end)
			)
		)
	end
	bole.playSounds("click")
end


function Header_Node:onBtnThemevipClicked()
    local pos = cc.p(self.root.btn_themevip:getPosition())
    self:showTip(pos.x, pos.y, 2)
end

 

return Header_Node