

local ThemeMysteriousPixies_BGBetFeatureControl = class("ThemeMysteriousPixies_BGBetFeatureControl")
local cls = ThemeMysteriousPixies_BGBetFeatureControl

function cls:ctor(bonusParent, data, tryResume)

	self.bonusParent 	= bonusParent
	self.bonusControl 	= bonusParent.bonusControl
	self.themeCtl 		= bonusParent.themeCtl
	self.data          	= data

	self.betFeatureCtl = self.themeCtl:getBetFeatureVCtl()

	self.gameConfig = self:getGameConfig()

	self.node = cc.Node:create()
    self:curSceneAddToContent(self.node)
	self:initData()
end

function cls:initData()
    self.betFeatureData     = self.data.core_data.bet_bonus
    self.bonusType          = self.data.core_data.bonus_type
    self.winItemList 	    = tool.tableClone(self.betFeatureData.item_list_new)
    self.curBonusBet 		= self.themeCtl:getCurBet()

    self:initWinData()
end

function cls:initWinData( ... )

end

function cls:enterBonusGame(tryResume)
    self:initWinItemList()

    if self.bonusType == 1 then 
        self.themeCtl:addCoinsToHeader()
    end
    
    self.bonusParent:setSingleBonusOver( "bet_bonus" )

    self.bonusParent:checkIsOverBonus()
end

function cls:initWinItemList( )
    if self.winItemList then 
        self.themeCtl:resetBoardCellsByItemList(self.winItemList)
    end
end

function cls:onExit( )
    if bole.isValidNode(self.node) then 
        self.node:removeFromParent()
    end
end

function cls:getGameConfig( )
	return self.themeCtl:getGameConfig()
end

function cls:curSceneAddToContent( node )
    self.themeCtl:curSceneAddToContent(node)
end

return cls
