--[[
Author: xiongmeng
Date: 2021-05-08 17:46:45
LastEditors: xiongmeng  
LastEditTime: 2021-05-24 20:37:51
Description: 
--]]

local parentClass = ThemeBaseViewControlDelegate
local view = require (bole.getDesktopFilePath("Theme/Respin/MightyC_RespinView"))  
 
local cls = class("MightyC_RespinViewControl", parentClass)
function cls:ctor(_mainViewCtl)
    parentClass.ctor(self, _mainViewCtl)
    self.bonusCoinsList = self.gameConfig["bonus_coin"]
    self.saveDataKey = "respin_info"
end
function cls:initLayout(...)
    self.respinView = view.new(self, ...)
end
function cls:checkCollectBtnCanTouch( ... )
	return self._mainViewCtl:getCanTouchFeature()
end
function cls:collectBtnClickEvent()
    if not self._mainViewCtl:getCollectViewCtl():icLockCollect() then
        return
    end
    local unLockBetList = self.gameConfig.unlockBetList
    self._mainViewCtl:featureUnlockBtnClickEvent(unLockBetList["Collect"])
end
function cls:setRespinTipEnabled(enable)
    self.respinView:setRespinTipEnabled(enable)
end
function cls:onSpinStart()
    self.respinView:hideRespinTip(true)
end
function cls:collectRespinCtl(stopRet)
    self.bonusYellowAward = false
    local themeInfo = stopRet["theme_info"]
    if themeInfo and themeInfo["bonus2_flag"] and themeInfo["bonus2_flag"] == 1 then
        self:setBonus2Flag(true)
    end
    if stopRet["bonus_game"] and 
        stopRet["bonus_game"]["theme_respin"] and 
        stopRet["bonus_game"]["theme_respin"]["respin_type"] == 2 then
            self.bonusYellowAward = true
    end
end
------------ bonus2 start ------------
function cls:getWinBonus2Type()
    return self.bonusYellowAward
end
function cls:getBonus1Pic()
    return self._mainViewCtl.pics[12]
end
function cls:getBonus2Pic()
    return self._mainViewCtl.pics[13]
end
function cls:getBonus2Flag()
    return self.bonusYellowFlag
end
function cls:setBonus2Flag(enable)
    self.bonusYellowFlag = enable
end
function cls:getFlyLayer()
    return self._mainViewCtl:getFlyLayer()
end
function cls:addBonus2Collect(rets, endFunc)
    --向上收集的动画
    local collectDelay = 1.5
    if self:getWinBonus2Type() then
        collectDelay = 2.5
    end
    local bonus2 = 220
    local bonus1 = 120
    local itemList = rets and rets["item_list"] or {}
    local isFirst = true
    if itemList and #itemList > 0 then
        for col, list in ipairs(itemList) do
            for row, item in ipairs(list) do
                if item >= bonus2 then
                    local cellNode = self._mainViewCtl:getCellNode(col, row)
                    local pos = bole.getWorldPos(cellNode)
                    self.respinView:collectYellowSymbol(pos, isFirst, self.bonusYellowAward)
                    isFirst = false
                end
                if item >= bonus1 then
                    if self.bonusYellowAward then
                        if item >= bonus1 and item < bonus2 then
                            local cellNode = self._mainViewCtl:getCellNode(col, row)
                            self.respinView:blueDiamondChange(cellNode)
                        end
                    else 
                        if item >= bonus2 then
                            local cellNode = self._mainViewCtl:getCellNode(col, row)
                            self.respinView:yellowDiamondChange(cellNode)
                        end
                    end
                end
            end
        end
    end
    self:setBonus2Flag(false)
    self:laterCallBack(collectDelay, function ()
        if endFunc then
            endFunc()
        end
    end)
end

------------ bonus2 end ------------

------------ respintip start ------
function cls:updateRespinTip(pType)
    self.respinView:updateRespinTip(pType)
end
function cls:changeRespinTipBet(theBet)
    local unLockBetList = self.gameConfig.unlockBetList
    local tipBet = self._mainViewCtl.tipBetList[unLockBetList.Collect]
    if self.isLockFeature == nil then
        if theBet >= tipBet then
            self.isLockFeature = true
        else
            self.isLockFeature = false
        end
    end
    local isLock = theBet < tipBet
    if self.isLockFeature ~= isLock then
        self.respinView:changeRespinBoardTip(isLock, true)
        self.isLockFeature = isLock
    end
end
function cls:getHighBet()
    return not self.isLockFeature
end
------------ respintip end ------

------------------------ respinBonus start ------------------------
function cls:saveBonus()
    self.bonusCtl:addData(self.saveDataKey, self.saveData)
end
function cls:setBonusInfo(bonus, tryResume)
    -- 可以根据类型来判断当前数据哪种类型的bonus
    self.bonusCtl = bonus
    self.myData = self.bonusCtl.data.core_data
    self.saveData = self.bonusCtl.data[self.saveDataKey] or {}
    self.reSpinData = tool.tableClone(self.myData.theme_respin)
    self.jackpotLock = self.reSpinData.lock
    self.initItemList = self.reSpinData.init_item_list
    self.respinItemList = self.reSpinData.respin_item_list
    self.initRespinCount = self.reSpinData.init_respin_count  --初始的次数
    self.respinType = self.reSpinData.respin_type
    self.extraSpin = self.reSpinData.extra_spin
    self.extraWinList = self.reSpinData.extra_win_list or {}
    self.jpWinList = self.reSpinData.jp_win_list or {}
    self.jpHadWin = {0,0,0,0,0} --查看jp的钱是否已经添加过了
    self.respinLevel = self.reSpinData.respin_level or 0
    self.avgBet = self.reSpinData.avg_bet
    self.enterBet = self.bonusCtl.data.bet or self._mainViewCtl:getCurTotalBet()
    self.bonusItem = self._mainViewCtl.item_list or self.bonusCtl.data.core_data.item_list
    
    self:cleanRespinStatus()
    self:updateItemListData()

    self:initExtraAddCoins()
    self:initNormalRespinData()
    self:setInitBoardList()
    self:initJackpotInfo()
    self.respinView:updateRespinTimes(self:getCurSpinCount(), self:getCurTotalCount())
end
function cls:initJackpotInfo()
    local betMul = self.gameConfig.jackpotViewConfig.betMul
    self.jackpotInfo = {}
    for key, val in ipairs(self.jpWinList) do
        if self:getDoubleFeature() then
            local betCoins = self:getSymbolCoins(betMul[val.jp_win_type + 1])  
            val.jp_win = val.jp_win - betCoins
        end
        self.jackpotInfo[val.jp_win_type + 1] = self.jackpotInfo[val.jp_win_type + 1] or {}
        table.insert(self.jackpotInfo[val.jp_win_type + 1], val)
    end
    for key = 1, 5 do
        if self.jackpotInfo[key] and #self.jackpotInfo[key] > 0 then
            table.sort(self.jackpotInfo[key], function ( a, b )
	        	return (a.jp_win or 0) > (b.jp_win or 0)
	        end)
        end
    end
end
function cls:getJackpotInfo(jpType)
    if not jpType then return 0 end
    if self.jackpotInfo and self.jackpotInfo[jpType] then
        if self.jpHadWin[jpType] == 0 then
            return self.jackpotInfo[jpType][1]
        else 
            return self.jackpotInfo[jpType][2]
        end
    end
    return 0
end
function cls:initExtraAddCoins()
    self.extraAllCoinsInfo = {}
    if self.extraWinList and #self.extraWinList > 0 then
        for colIndex, val in ipairs(self.extraWinList) do
            local addCoins = 0
            for col, extrawin in ipairs(val) do
                for row, coins in ipairs(extrawin) do
                    if coins and coins > 0 then
                        addCoins = addCoins + 1
                    end
                end
            end
            self.extraAllCoinsInfo[colIndex] = addCoins
        end
    end
end
function cls:getExtraAddCoinsData()
    local counts = self:getCurSpinCount()
    if self:getDoubleFeature() then
        counts = 1
    end
    return table.copy(self.extraWinList[counts])
end
function cls:getDoubleFeature()
    local maxTimes = 15
    if self:getStartSymbolCount() == maxTimes then 
        return true
    end
    return false
end
function cls:adjustExtraStatus()
    -- 使用的次数 
    if self.extraSpin and self.extraSpin > 0 then
        if not self:getExtraStatus() then
            if self:getCurSpinCount() == self:getCurTotalCount() then
                self:setExtraDialogStatus(true)
            end
        elseif self:getCurSpinCount() == #self.respinItemList then 
            self:setCollectStatus(true)
        end
    elseif self:getCurSpinCount() == #self.respinItemList then
        self:setCollectStatus(true)
    end
end
function cls:getRespinType()
    return self.respinType
end
function cls:getSuperRespinType()
    if self.respinLevel and self.respinLevel == 2 then
        return true
    end
    return false
end
function cls:getJackpotUnLock(pType)
    if not pType or not self.jackpotLock then return false end 
    if self.jackpotLock[pType] and self.jackpotLock[pType] == 1 then
        return true
    end
    return false
end
function cls:initNormalRespinData()
    local allData = tool.tableClone(self.respinItemList)
    self._mainViewCtl.rets = self._mainViewCtl.rets or {}
    self._mainViewCtl.rets["theme_respin"] = allData
end
function cls:recoverBonusSpinState()
    local removeCount = self:getCurSpinCount()
    if self._mainViewCtl.rets["theme_respin"] then
        for i = 1, removeCount do
            table.remove(self._mainViewCtl.rets["theme_respin"], 1)
        end
    end
end
function cls:getStartSymbolCount()
    return self.saveData.startBonusSymbolTimes or 0
end
function cls:setStartSymbolCount(count)
    self.saveData.startBonusSymbolTimes = count
end
function cls:getCurSpinCount()
    return self.saveData.spin_count or 0
end
function cls:setCurSpinCount(count)
    self.saveData.spin_count = count
end
function cls:getCurTotalCount()
    if not self.saveData.spin_allCount then
        self.saveData.spin_allCount = self.initRespinCount
    end
    return self.saveData.spin_allCount
end
function cls:setCurTotalCount(count)
    self.saveData.spin_allCount = self.saveData.spin_allCount + count
end
function cls:cleanRespinStatus()
    -- self.saveData.spin_count = 0
    -- self.saveData.extraPick = false
    -- self.saveData.collectStatus = false
    -- self.saveData.symbolBoardList = {}
end
function cls:getClickEpicStart()
    return self.saveData.click_start
end
function cls:setClickEpicStart(status)
    self.saveData.click_start = status
    self:saveBonus()
end
function cls:getExtraStatus()
    return self.saveData.extraStatus
end
function cls:setExtraStatus(enabel)
    self.saveData.extraStatus = enabel
end
function cls:getExtraDialogStatus()
    return self.saveData.extraPick
end
function cls:setExtraDialogStatus(enabel)
    self.saveData.extraPick = enabel
end

function cls:getCollectStatus()
    return self.saveData.collectStatus
end
function cls:setCollectStatus(enabel)
    self.saveData.collectStatus = enabel
end
function cls:setInitBoardList()
    local allCol = 15
    local bonus1 = 120
    self.saveData.symbolBoardList = self.saveData.symbolBoardList or {}
    if #self.saveData.symbolBoardList == 0 then
        local allCouns = 0
        for col, list in ipairs(self.initItemList) do
            for row, item in ipairs(list) do
                local symbolID = self.initItemList[col][row]
                local colIndex = (row - 1) * 5 + col
                local symbolInfo = {}
                symbolInfo.coins = 0  -- 原本symbol上coins携带的钱
                symbolInfo.jp = 0 -- jp 的类型
                symbolInfo.addCoins = 0 -- 增加的所有钱，包括2倍的钱数
                if item >= bonus1 then  
                    self:setDiamondSymbolList(item, symbolInfo)
                    allCouns = allCouns + 1
                end
                self.saveData.symbolBoardList[colIndex] = symbolInfo
            end
        end
        self:setStartSymbolCount(allCouns)
        self:saveBonus()
    end
end
function cls:getSymbolInfoByIndex(colIndex)
    if colIndex and self.saveData.symbolBoardList and self.saveData.symbolBoardList[colIndex] then
        return self.saveData.symbolBoardList[colIndex]
    end
    return {}
end
function cls:setDiamondSymbolList(item, symbolInfo, addCoins)
    local itemId = item%100
    local limitId = 30
    local maxId = 35
    if itemId >= limitId then
        symbolInfo.jp = maxId - itemId
    else 
        symbolInfo.coins = self:getSymbolCoins(self.bonusCoinsList[item])
    end
    if addCoins then
        symbolInfo.addCoins = symbolInfo.addCoins + addCoins
    end
end
function cls:getSymbolCoins(multi)
    multi = multi or 0
	local bet = self.avgBet or self:getCurTotalBet()
	return bet * multi
end
function cls:getAddCoinsToSymbol()
    local counts = self:getCurSpinCount()
    if self:getDoubleFeature() then
        counts = 1
    end
    if self.extraAllCoinsInfo and self.extraAllCoinsInfo[counts] ~= 0 then
        return self.extraAllCoinsInfo[counts]
    end
    return false
end
function cls:addCoinsToSymbolData()
    -- 假设有落地动画的symbol，也需要被添加上
    local count = self:getCurSpinCount()
    local itemList = {}
    if self:getDoubleFeature() then
        count = 1
        itemList = self:getFixLandRet(self.initItemList)
    else 
        itemList = self:getFixLandRet(self.respinItemList[count])
    end
    local addCoinsList = {}
    if self:getAddCoinsToSymbol() then
        addCoinsList = self:getFixLandRet(self.extraWinList[count])
    end
    local row = 1
    local bonus1 = 120
    for col, val in ipairs(itemList) do
        local symbolId = itemList[col][row]
        local addCoins = 0
        if addCoinsList and addCoinsList[col] and addCoinsList[col][row] then
            addCoins = addCoinsList[col][row]
        end
        if symbolId >= bonus1 then  
            self:setDiamondSymbolList(symbolId, self.saveData.symbolBoardList[col], addCoins)
        end
    end
end
function cls:enterEpicBonus(tryResume)
    if tryResume then
        self._mainViewCtl:resetBoardCellsByItemList(self.bonusItem)
    end
    if not self:getClickEpicStart() then
        self:showEpicStartDialog()
    else
        self._mainViewCtl:dealMusic_EnterBonusGame(self:getSuperRespinType())
        self:recoverBonusSpinState()
        self:changeSpinBoard()
        self:enterEpicBonusByStep()
    end
end
function cls:updateItemListData()
    if self.initItemList and self.bonusItem then
        for col, val in ipairs(self.initItemList) do
            for row, item in ipairs(val) do
                if item >= 120 then
                    self.bonusItem[col][row] = item
                end
            end
        end
    end
end
function cls:enterEpicBonusByStep()
    if self:getDoubleFeature() then
        self:playFadeToMinVlomeMusic()
        self.doubleCurrent = true
        local count = self.extraAllCoinsInfo[1] or 0
        local delay = 0
        if count > 0 then
            self:addCoinsToSymbolData()
            delay = self.respinView:addCoinsToSymbolAni(count)
        end
        self:laterCallBack(delay, function ()
            self.respinView:collectDoubleDiamondStep()
        end)
    elseif self:getCollectStatus() then
        self:playFadeToMinVlomeMusic()
        self:collectDiamondStep()
    elseif self:getExtraDialogStatus() then
        self.respinView:playExtraPickDailog()
    else 
        self._mainViewCtl:handleResult()
    end
end

function cls:finishExtraAdd()
    self:setExtraStatus(true)
    self:setExtraDialogStatus(false)
    self:setCurTotalCount(self.extraSpin)
    self.respinView:updateRespinTimes(self:getCurSpinCount(), self:getCurTotalCount())
    self:saveBonus()
    self:laterCallBack(1, function ()
        self:enterEpicBonusByStep()
    end)
end

function cls:onRespinStart()
    self:setCurSpinCount(self:getCurSpinCount() + 1)
    self.respinView:updateRespinTimes(self:getCurSpinCount(), self:getCurTotalCount())
    self:adjustExtraStatus()
    self:addCoinsToSymbolData()  -- 需要对结果进行处理,增加的钱数啥的
    self:saveBonus()
    self._mainViewCtl.DelayStopTime = 0
    self._mainViewCtl:cleanReelStopMusic()
end

function cls:onReelStop(col)
    
end
function cls:respin_symbolLand(cell, col, item)
    self.isChange = true
    self._mainViewCtl:setLockedReels(col, 1)
    self.respinView:respin_symbolLand(cell, col, item)
    local featureId = 12
    if self:getRespinType() == 2 then
        featureId = 13
    end
    self._mainViewCtl:playSymbolLandMusic(true, featureId, col, true)
end
function cls:onAllReelStop()
    local delay = 0
    if self.isChange then
        delay = 1
    end
    self.isChange = false
    self._mainViewCtl:setFooterBtnsEnable(false)
    local superJpDelay = self:getSuperAdditionJp(delay)

    local callBack = function ()
        local addCoinsDelay = 0
        if self:getAddCoinsToSymbol() then
            addCoinsDelay = self.respinView:addCoinsToSymbolAni(self:getAddCoinsToSymbol())
        end
        self:laterCallBack(addCoinsDelay + 0.5, function ()
            self:enterEpicBonusByStep()
        end)
    end

    local a1 = cc.DelayTime:create(delay + superJpDelay)
    local a2 = cc.CallFunc:create(function ()
        callBack()
    end)
    local a3 = cc.Sequence:create(a1, a2)
    self.node:runAction(a3)
end
function cls:getSuperAdditionJp(delay)
    if self.additionJp and #self.additionJp > 0 then
        return 1
    end
    return 0
end
function cls:getRespinFinishStatus()
    if not self._mainViewCtl.rets["theme_respin"] or #self._mainViewCtl.rets["theme_respin"] == 0 then
        return true
    end
    return false
end
function cls:onRespinFinish(ret, isAnimation)
    
end
function cls:getFixLandRet(itemList)
    local new_item_list = {}
    if itemList then
        for key = 1, 15 do
            local col = 1 + (key - 1) % 5
            local row = 1 + math.floor((key - 1) / 5)
            local itemKey = itemList[col][row]
            new_item_list[key] = { itemKey }
        end
    end
    return new_item_list
end
function cls:getFixRet(ret)
    self.additionJp = {}
    local item_list_up = {}
    local item_list_down = {}
    
    local itemsList = ret.item_list
    local resultCache = {}
    local new_item_list = {}
    for i = 1, 15 do
        item_list_up[i] = { math.random(2, 6) }
        item_list_down[i] = {}
        for j = 1, 6 do
            item_list_down[i][j] = math.random(2, 6)
        end
        local col = 1 + (i - 1) % 5
        local row = 1 + math.floor((i - 1) / 5)
        local itemKey = itemsList[col][row]
        if self:adjustHighSymbolType(itemKey) then
            new_item_list[i] = { itemKey - 1 }
            table.insert(self.additionJp, {i, itemKey})
            resultCache[i] = { self._mainViewCtl:getMajorSymbol(), itemKey - 1 }
        else 
            new_item_list[i] = { itemKey }
            resultCache[i] = { self._mainViewCtl:getMajorSymbol(), itemKey }
        end
        
        local symbols = nil
        if self:getRespinType() == 2 then 
            symbols = self._mainViewCtl:getSuperBonusReel()
        else 
            symbols = self._mainViewCtl:getBonusReel()
        end
        local key = math.random(2, #symbols[col])

        local extraCount = 6
        if self._mainViewCtl:getIsTrubo() then
            extraCount = 3
        end
        for k = 1, extraCount do
            if k == 1 then
                table.insert(resultCache[i], self._mainViewCtl:getMajorSymbol())
            else
                key = 1 + (key + k - 1) % #symbols
                table.insert(resultCache[i], symbols[col][key])
            end
        end
    end
    if self._mainViewCtl.cacheSpinRet then
		self._mainViewCtl.cacheSpinRet["item_list_up"] = item_list_up
		self._mainViewCtl.cacheSpinRet["item_list_down"] = item_list_down
	end
    return resultCache, new_item_list
end
function cls:adjustHighSymbolType(item)
    if self:getSuperRespinType() and self:getExtraStatus() and self._mainViewCtl:getHighDiamondSymbol(item) then 
        return true
    end 
    return false
end

function cls:showEpicStartDialog()
    self.respinView:showEpicStartDialog()
end
function cls:changeSpinBoard()
    local pType = "Respin"
    if self:getSuperRespinType() then
        pType = "SuperRespin"
        if self.avgBet then
		    self._mainViewCtl:setPointBet(self.avgBet)
        end
    end
    self._mainViewCtl:changeSpinBoard(pType)
    if self:getRespinType() == 2 then
        self._mainViewCtl:showBonusNode(false, true)
    else 
        self._mainViewCtl:showBonusNode(true)
    end
    self.bonusCtl:lockJackpotValue()
    self:initCoinsLockOnBoard()
end
function cls:initCoinsLockOnBoard()
    local spinCount = self:getCurSpinCount()
    
    
    local itemList = {}
    local isFirst = true
    if spinCount == 0 then
        itemList = table.copy(self.initItemList)
    else 
        isFirst = false
        itemList = table.copy(self.respinItemList[spinCount])
    end
    local bonus1 = 120
    for col = 1, #itemList do
        for row = 1, #itemList[col] do
            local symbolID = itemList[col][row]
            local indexCol = (row - 1) * 5 + col
            local cell = self._mainViewCtl:getCellNode(indexCol, 1)
            if cell then
                self._mainViewCtl:updateCellSprite(cell, indexCol, true, symbolID, true)
                if symbolID >= bonus1 then
                    self._mainViewCtl:setLockedReels(indexCol, 1)
                    local pos = self._mainViewCtl:getCellPos(indexCol, 1)
                    local node = self._mainViewCtl:getDiamondHighZorder(symbolID, indexCol, 1, nil, pos, true)
                    if not isFirst then
                        local symbolInfo = self:getSymbolInfoByIndex(indexCol)
                        local addCoins = symbolInfo.addCoins
                        if addCoins and addCoins > 0 then
                            self.respinView:addOtherCoinsInJpSymbol(node, addCoins, 0)
                        end
                    end
                end
            end
            local cellUp = self._mainViewCtl:getCellNode(indexCol, 0)
            if cellUp then
                self._mainViewCtl:updateCellSprite(cellUp, indexCol, true, math.random(2,6), true)
            end
            for down = 1, 6 do
                local cellDown = self._mainViewCtl:getCellNode(indexCol, down + 1)
                if cellDown then
                    self._mainViewCtl:updateCellSprite(cellDown, indexCol, true, math.random(2,6), true)
                end
            end
        end
    end
end
function cls:collectDiamondStep()
    local doNext = nil
    local colIndex = 0
    self.totalRespinCoins = 0
    doNext = function ( ... )
        if colIndex == #self.saveData.symbolBoardList then
            self:exitEpicBonus()
        else
            colIndex = colIndex + 1
            self:diamondCoinsFly(colIndex, doNext)
        end
	end
    self.respinView:lightAllDiamondSymbol()
    self:laterCallBack(1, function ()
        doNext()
    end)
end
function cls:diamondCoinsFly(colIndex, doNext)
    local symbolInfo = self.saveData.symbolBoardList[colIndex]
    if symbolInfo then
        local jpIndex = symbolInfo.jp
        if jpIndex ~= 0 then
            if self:getJackpotUnLock(jpIndex) then 
                self:playMusicByName("trigger_bell")
                self._mainViewCtl:getJpViewCtl():addJpAwardAnimation(jpIndex)
                self.respinView:addCollectJpLight(colIndex)
                self:laterCallBack(2, function ()
                    self.respinView:playJackpotDialog(jpIndex, colIndex, doNext)
                end)
            else
                -- 就在这里修改数据
                local jackpotInfo = self:getJackpotInfo(jpIndex)
                local singleJpCoins = jackpotInfo.jp_win  -- 真实的钱数了
                self.jpHadWin[jpIndex] = 1
                symbolInfo.coins = singleJpCoins
                self.respinView:collectCoinsToFooter(colIndex, doNext)
            end
        elseif symbolInfo.coins ~= 0 then
            self.respinView:collectCoinsToFooter(colIndex, doNext)
        else 
            if doNext then
                doNext()
            end
        end
    else 
        if doNext then
            doNext()
        end
    end
end
function cls:setLockJackpotValue(jpType)
    if self.bonusCtl and self.bonusCtl.progressive_list then
        self.bonusCtl.progressive_list[jpType] = 0
        self._mainViewCtl:lockJackpotValue(self.bonusCtl.progressive_list)
    end
end
function cls:addFooterCoins(coins, doNext)
    coins = coins or 0
    self.totalRespinCoins = self.totalRespinCoins + coins
    self._mainViewCtl.totalWin = self._mainViewCtl.totalWin + coins
    local rollTime = 0.3
    self._mainViewCtl.footer:setWinCoins(coins, self._mainViewCtl.totalWin - coins, rollTime)
    if doNext then
        doNext()
    end
end
function cls:getWinFooterWorldPos(parentLabel)
    local endWPos = self._mainViewCtl:getFooterWinWordPos()
    local endNPos = bole.getNodePos(parentLabel, endWPos)
    return endNPos
end
function cls:exitEpicBonus()
    -- self:collectNotice()
    local onCover = function ()
        self._mainViewCtl:stopDrawAnimate()
        if self._mainViewCtl:isInFG() then
            self._mainViewCtl:changeSpinBoard("FreeSpin")
            if self:getSuperRespinType() then
                if self.enterBet then
		            self._mainViewCtl:setPointBet(self.enterBet)
                end
                self._mainViewCtl:setFooterStyle(4)
            end
        else
            self._mainViewCtl:changeSpinBoard("Normal")
            self._mainViewCtl:setFooterStyle(1)
        end
        if self:getSuperRespinType() then
            self._mainViewCtl:collectRestData()
        end
        self._mainViewCtl:resetBoardCellsByItemList(self.bonusItem)
    end
    local onEnd = function ()
        self:collectNotice()
        self._mainViewCtl.totalWin = self._mainViewCtl.totalWin - self.totalRespinCoins
        self.bonusCtl:finishBonusGame(self.totalRespinCoins)
    end
    self:laterCallBack(1, function ()
        self.respinView:playStartTransition(onEnd, onCover)
    end)
end
function cls:collectNotice()
    self._mainViewCtl:collectCoins(1)
    self.bonusCtl.data["end_game"] = true
    self.bonusCtl:saveBonus()
end
function cls:clearBonusInfo()
    self.bonusCtl = nil
    self.myData = nil
    self.totalRespinCoins = 0
    self.doubleCurrent = nil
    self.avgBet = nil
    self.bonusItem = nil
    self.additionJp = nil
    self.enterBet = nil
end

function cls:playDialogMusic(name)
    self:playFadeToMinVlomeMusic()
    self:playMusicByName(name)
end
function cls:stopDialogMusic(name)
    self:stopMusicByName(name)
    -- self:playMusicByName("dialog_popUp")
end
function cls:playFadeToMinVlomeMusic()
    self._mainViewCtl:playFadeToMinVlomeMusic()
end
function cls:playFadeToMaxVlomeMusic()
    self._mainViewCtl:playFadeToMaxVlomeMusic()
end

------------------------ respinBonus end ------------------------

return cls
