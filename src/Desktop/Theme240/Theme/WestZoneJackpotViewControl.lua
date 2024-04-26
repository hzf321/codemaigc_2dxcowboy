
local jpView =require (bole.getDesktopFilePath("Theme/WestZoneJackpotView")) 
 
local cls = class("WestZoneJackpotViewControl", ThemeBaseJackpotControl)

function cls:ctor(mainCtl)
	ThemeBaseJackpotControl.ctor(self, mainCtl)
	self.gameConfig = self._mainViewCtl:getGameConfig()
	self.audiList = self.gameConfig.audioList
	self.audioCtl = self._mainViewCtl:getAudioCtl()

end

function cls:initLayout( jpRoot )
	self.jpView = jpView.new(self, jpRoot)
    self.jackpotLabels = self.jpView:getJackpotLabels()
	self:initialJackpotNode() 
end

function cls:jpBtnClickEvent( index )
	index = index or 1
	local unLockBetList = self.gameConfig.unlockBetList
    self._mainViewCtl:featureUnlockBtnClickEvent(unLockBetList["Jackpot" .. index])
end

function cls:changeUnlockJpBet( theBet )
	if not self.jpView then return end
	local unlock_count = 0
    local lock_count = 0
    local unlock_status = false
    local lock_status = false
    local _AllJpCount = self.gameConfig.jackpotViewConfig.count
    local _tipBetList = self._mainViewCtl.tipBetList
    local _currentUnlockBet = self._mainViewCtl.currentUnlockBet
    local status = self:_getLockStatus(_currentUnlockBet, theBet)
    local unLockBetList = self.gameConfig.unlockBetList
    self.jackpotUnlockLabels = self.jpView.jackpotUnlockLabels
    for key = 1, _AllJpCount do
        local jackpot = key
        local betKey = "Jackpot" .. jackpot
        local tipBet = _tipBetList[unLockBetList[betKey]]
        local parent = self.jackpotUnlockLabels[key]
        if theBet < tipBet then
            lock_count = lock_count + 1
            if not parent.isLocked then
                lock_status = true
                self:setJackpotPartState(key, true)
            end
        else
            if parent.isLocked then
                unlock_status = true
                self:setJackpotPartState(key, false)
            end
            unlock_count = unlock_count + 1
        end
        parent.isLocked = theBet < tipBet
    end
    -- to show bubble
    if self._mainViewCtl:noFeatureLeft() then
        if status == 1 or status == 2 then
            self:setJackPotTipState(status, lock_status, lock_count)
        else
            self:setJackPotTipState(status, unlock_status, lock_count)
        end
    end
end
function cls:_getLockStatus( beforeBet, theBet )
	local status = 0
    if not beforeBet then
        status = 1
    elseif beforeBet > theBet then
        status = 2
    else
        status = 3
    end
    return status
end
function cls:setJackPotTipState( status, status2, count )
    if status == 1 then
        if status2 then
            self:showjpTipNode(count, 1)
        end
    elseif status == 2 then
        if status2 then
            self:showjpTipNode(count, 1)
            -- self:playMusicByName("jp_lock")
        end
    elseif status == 3 then
        if status2 then
            local jpIndex = count + 1
            self:showjpTipNode(jpIndex, 2)
            -- self:playMusicByName("jp_unlock")
        end
    end
end
function cls:getJpLockStatus(index)
    if (not index) or (not self.jackpotUnlockLabels) then return true end
    local jpNode = self.jackpotUnlockLabels[index]
    if jpNode then
        return jpNode.isLocked
    end
    return true
end
function cls:showjpTipNode( count, index )
    local parent = self.jackpotUnlockLabels[count]
    self.jpView:showjpTipNode(parent, index)
end
function cls:setJackpotPartState( index, isLock )
    local parent = self.jackpotUnlockLabels[index]
    if self._mainViewCtl:noFeatureLeft() then
        self.jpView:setJackpotPartState(parent, index, isLock)
    end
    self:changeJpStyle(index, isLock)
end
function cls:changeJpStyle( index, isLock )
    local unlockLabels = self.jackpotUnlockLabels[index]
    self.jackpotLabels = self.jpView:getJackpotLabels()
    local labels = self.jackpotLabels[index]
    self.jpView:changeJpStyle(unlockLabels, labels, index, isLock)
    -- bole.shrinkLabel(labels, labels.maxWidth, labels.baseScale)
end
function cls:addJpAwardAnimation( jpWinType )
    self.jpView:addJpAwardAnimation(jpWinType)
end
function cls:removeJpAwardAnimation( jpWinType )
    self.jpView:removeJpAwardAnimation(jpWinType)
end



function cls:lockJackpotValue( data )
    data = data or {0,0,0}
    local jpLabels = self.jpView.jackpotLabels
    local progressive_data = self:getJackpotValue(data)
    for i=1, #data do
        if jpLabels[i] then
            jpLabels[i]:setString(self:formatJackpotMeter(progressive_data[i]))
            bole.shrinkLabel(jpLabels[i], jpLabels[i].maxWidth, jpLabels[i].baseScale)
        end
    end
end
function cls:getGameConfig( ... )
	return self.gameConfig
end

function cls:getPic( name )
	return self._mainViewCtl:getPic(name)
end

function cls:playMusicByName( name)
	self._mainViewCtl:playMusicByName(name)
end

function cls:getSpineFile( file_name )
	return self._mainViewCtl:getSpineFile(file_name)
end

function cls:getFntFilePath( file_name )
	return self._mainViewCtl:getFntFilePath(file_name)
end

function cls:checkJackpotBtnCanTouch( ... )
	return self._mainViewCtl:getCanTouchFeature()
end

function cls:getJackpotBgAni( ... )
	return self._mainViewCtl.mainView.down_node:getChildByName("jp_bg"):getChildByName("ani_node")
end

return cls