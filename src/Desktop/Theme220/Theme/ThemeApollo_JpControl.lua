---@program src
---@description:  theme220
---@author: rwb
---@create: : 2020-11-23 21:15:16
local view = require (bole.getDesktopFilePath("Theme/ThemeApollo_JpView")) 
local cls = class("ThemeApollo_JpControl", ThemeBaseJackpotControl)
function cls:ctor(mainCtl)
    ThemeBaseJackpotControl.ctor(self, mainCtl)
    self.gameConfig = self._mainViewCtl:getGameConfig()
    self.jpConfig = self.gameConfig.jackpot_config
    self.audiList = self.gameConfig.audioList
    self.audioCtl = self._mainViewCtl:getAudioCtl()
    self.jpLockStatus = {}
end

function cls:initLayout(jpRoot, jpTipRoot)
    self.jpView = view.new(self, jpRoot, jpTipRoot)
    self:initialJackpotNode() -- jp的显示
end

function cls:jpBtnClickEvent(index)
    index = index or 1
    if self._mainViewCtl:getCanTouchFeature() then
        local unLockBetList = self.gameConfig.unlockBetList
        self._mainViewCtl:featureUnlockBtnClickEvent(unLockBetList["Jackpot" .. index])
    end
end
function cls:addWinJpAni(index)
    self.jpView:addWinJpAni(index)
end
function cls:removeJpAni(index)
    self.jpView:removeJpAni(index)
end
function cls:resetProgressiveList(tail_list)
    local link_config = self._mainViewCtl:getThemeJackpotConfig().link_config
    local jpLabels = self.jpView:getJackpotLabels()
    if tail_list then
        for i = 1, #tail_list do
            if jpLabels[i] then
                local jackpotNum = self:getJackpotNum(link_config[i])
                if tail_list[i] then
                    jackpotNum = jackpotNum + tail_list[i]
                end
                jpLabels[i]:setString(self:formatJackpotMeter(jackpotNum))
                bole.shrinkLabel(jpLabels[i], jpLabels[i].maxWidth, jpLabels[i].baseScale)
            end
        end
    end
end
function cls:getJackpotNum(jpIndex)
    local jackpotController = JackpotControl:getInstance()
    local multi = jackpotController:getJackpotMulti(self._mainViewCtl.themeid, jpIndex)
    return self._mainViewCtl:getCurTotalBet() * multi
end

---@desc change
---@param theBet /:current bet
function cls:changeUnlockJpBet(theBet)
    local unlock_count = 0
    local lock_count = 0
    local unlock_status = false
    local lock_status = false
    local _AllJpCount = self.jpConfig.count
    local _tipBetList = self._mainViewCtl.tipBetList
    local UNLOCK_BET_LIST = self.gameConfig.unlockBetList
    local status = self:_getLockStatus(self.beforeBet, theBet)
    for key = 1, _AllJpCount do
        local jackpot = key
        local betKey = "Jackpot" .. jackpot
        local tipBet = _tipBetList[UNLOCK_BET_LIST[betKey]]
        local lockStatus = self.jpLockStatus[key]
        if theBet < tipBet then
            lock_count = lock_count + 1
            if not lockStatus then
                lock_status = true
                self.jpView:setJackpotPartState(key, true)
            end
        else
            if lockStatus then
                unlock_status = true
                self.jpView:setJackpotPartState(key, false)
            end
            unlock_count = unlock_count + 1
        end
        self.jpLockStatus[key] = theBet < tipBet
    end
    if status == 1 or status == 2 then
        self:setJackPotTipState(status, lock_status, lock_count)
    else
        self:setJackPotTipState(status, unlock_status, lock_count)
    end
    self.beforeBet = theBet
end
function cls:_getLockStatus(beforeBet, theBet)
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
function cls:setJackPotTipState(status, status2, count)
    if status == 1 then
        if status2 then
            self.jpView:showjpTipNode(count, 1)
        end
    elseif status == 2 then
        if status2 then
            self.jpView:showjpTipNode(count, 1)
            self:playMusicByName("jp_lock")
        end
    elseif status == 3 then
        if status2 then
            local jpIndex = count
            self.jpView:showjpTipNode(jpIndex + 1, 2)
            self:playMusicByName("jp_unlock")
        end
    end
end
function cls:getGameConfig(...)
    return self.gameConfig
end

function cls:getPic(name)
    return self._mainViewCtl:getPic(name)
end

function cls:playMusicByName(name, singleton, loop)
    self._mainViewCtl:playMusicByName(name, singleton, loop)
end
function cls:playMusicByOnce(file_name)
    self._mainViewCtl:playMusicByOnce(file_name)
end

function cls:getSpineFile(file_name)
    return self._mainViewCtl:getSpineFile(file_name)
end

function cls:getFntFilePath(file_name)
    return self._mainViewCtl:getFntFilePath(file_name)
end
function cls:getCsbPath(file_name)
    return self._mainViewCtl:getCsbPath(file_name)
end
function cls:getGameConfig()
    return self._mainViewCtl:getGameConfig()
end
function cls:getJackpotConfig()
    local gameConfig = self:getGameConfig()
    return gameConfig.jackpot_config
end

function cls:checkJackpotBtnCanTouch(...)
    return self._mainViewCtl:getCanTouchFeature()
end
return cls
