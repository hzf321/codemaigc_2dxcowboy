local Inspect_Ad_Dialog = class("Inspect_Ad_Dialog", CreatorNode)

function Inspect_Ad_Dialog:ctor(data, callback)
    self.isPortrait = ScreenControl:getInstance().isPortrait
    self.ctl        = AdRewardControl:getInstance()
    self.adCoins    = self.ctl:getAdRewardCoins()
	self.csb        = "ui/inspect/inspect_ad_pop"
    CreatorNode.ctor(self, self.csb .. (self.isPortrait and "_v" or ""))
    self:initButtonList(true)
end

function Inspect_Ad_Dialog:loadControls()
    self.root = self.node.root

end

function Inspect_Ad_Dialog:show( ... )
    
    if self.isPortrait then
        self.node:setScale(SHRINKSCALE_H)
        self:setPosition(FRAME_HEIGHT/2,FRAME_WIDTH/2)
    else
        self.node:setScale(SHRINKSCALE_H)
        self:setPosition(FRAME_WIDTH/2,FRAME_HEIGHT/2)
    end

    self:showActions()
    bole.scene:addChild(self, 1000)
    self:showMask(self.isPortrait, 0)
end

function Inspect_Ad_Dialog:hide()
    if self.isHiding then return end

    if self.callback then self.callback() end
    self:hideActions(true)
    bole.closeDialog(self, bole.popExitWin)
end


function Inspect_Ad_Dialog:onBtnCloseOkClicked()
    bole.playSounds("click")
    self:hide()
end

function Inspect_Ad_Dialog:onBtnCloseClicked()
    bole.playSounds("click")
    self:hide()
end

return Inspect_Ad_Dialog