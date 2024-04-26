--[[
Author: xiongmeng
Date: 2020-12-11 14:32:44
LastEditors: xiongmeng
LastEditTime: 2021-01-27 18:36:25
Description: 
--]]
local parentClass = ThemeBaseViewControlDelegate
local cls  = class("KingOfEgypt_JackpotDialogControl", parentClass)

function cls:ctor(bonus, bonusControl, _mainViewCtl, data)
	parentClass.ctor(self, _mainViewCtl)
	self.bonus = bonus
	self.bonusControl = bonusControl
	self.data = data
	self.jackpotData = self.data.core_data.jackpot_bonus
    self.gameConfig = self:getGameConfig()
    self.saveDataKey   = "jackpotDailog"
	self.tryResume 		= self.bonus.data[self.saveDataKey] and true or false
	self.gameData 		= tool.tableClone(self.bonus.data[self.saveDataKey]) or {}
    self.lastItemList  = self.data.core_data["item_list"] or self._mainViewCtl.item_list
    self.gameMasterJpId = 10
    self.theme = self
	self:saveBonus()
end
function cls:addData(key,value)
	self.gameData[key] = value
	self:saveBonus()
end
function cls:saveBonus()
	self.bonus:addData(self.saveDataKey, self.gameData)
end
function cls:enterBonusGame(tryResume)
    -- 恢复原始的symbol
    if self.tryResume and self.lastItemList then 
        self._mainViewCtl:resetBoardCellsByItemList(self.lastItemList)
    end
    self:updateJackpotData()
end
function cls:updateJackpotData()
    local jackpotBonus = self.jackpotData
    self.jpWinJp = jackpotBonus.win_jp
	self.jpWinList = jackpotBonus.jp_win_list
	self.moonTotalWin = jackpotBonus.yin_total_win or 0
    self.sunTotalWin = jackpotBonus.yang_total_win or 0
	self.moonNums = self:getMoonSymbolNums(self.lastItemList)
    self.sunNums = self:getSunSymbolNums(self.lastItemList)
    self.winPosList = self.jackpotData["win_pos_list"] 
    self.win_lines = self.jackpotData["win_lines"] 
    self.baseWin   = self.jackpotData["base_win"]
    self.data.addJpCoins = self.data.addJpCoins or 0
	self.data.dialogPro = self.data.dialogPro or 0
    self.isGameMaster = self._mainViewCtl:getFreeVCtl():gameMasterFlagStatus()
    self:saveBonus()
    self:playBonusAnimate()
    self:setSunMoonCount()
    self:getNormalAward()
    self:playDialogByFirstStep()
end
function cls:playBonusAnimate()
    self._mainViewCtl:playJpBonusAnimate(self.jackpotData, self.lastItemList)
    self.bonusAniList = self._mainViewCtl.mainView.bonusAniList
    self:playBonusAnimateByType("hide")
end
function cls:playBonusAnimateByType(stype)
    stype = stype or "hide"
    -- hide, show, moon, sun
    if self.bonusAniList then 
        for col, colList in pairs(self.bonusAniList) do 
            for row, list in pairs(colList) do 
                if list and bole.isValidNode(list) then 
                    local cell = list.cell
                    local enable = false
                    if stype == "show" then 
                        enable = true
                    elseif list.rapidType == stype then 
                        enable = true
                    elseif list.rapidType == "double" then 
                        enable = true
                    end
                    list:setVisible(enable)
                    if cell and bole.isValidNode(cell) then 
                        cell:setVisible(not enable)
                    end
                end
            end
        end
    end
end
function cls:setSunMoonCount( ... )
    self.sunSymbolCount = 0
    self.moonSymbolCount = 0
    if self.bonusAniList then 
        for col, colList in pairs(self.bonusAniList) do 
            for row, list in pairs(colList) do 
                if list and bole.isValidNode(list) then 
                    if list.rapidType == "double" then 
                        self.moonSymbolCount =  self.moonSymbolCount + 1
                        self.sunSymbolCount =  self.sunSymbolCount + 1
                    elseif list.rapidType == "sun" then 
                        self.sunSymbolCount =  self.sunSymbolCount + 1
                    elseif list.rapidType == "moon" then
                        self.moonSymbolCount =  self.moonSymbolCount + 1
                    end
                end
            end
        end
    end   
    if self.isGameMaster then 
        self.sunSymbolCount = self.sunSymbolCount + 1
        self.moonSymbolCount = self.moonSymbolCount + 1
    end
end
function cls:getUnLockStatus()
    if self.jpWinJp and #self.jpWinJp > 0 then 
        local index = 0
        for key, val in ipairs(self.jpWinJp) do
            local i = (val.jp_win_type + 1 - 1)% 5 + 1
            if index < i then 
                index = i
            end
        end
        return index
    end
    return -1
end

function cls:getNormalAward()
    self.dialogList = {}
    -- local lockStatus = self:getUnLockStatus()
    if self.jpWinList and #self.jpWinList > 0 then 
        for key, val in ipairs(self.jpWinList) do
            local info = {}
            local sType = "normal"
            if val.jp_win_type == self.gameMasterJpId then 
                if self.sunSymbolCount > 9 then 
                    sType = "sun"
                else 
                    sType = "moon"
                end
            else 
                local index = (val.jp_win_type + 1 - 1) % 5 + 1
                if val.jp_win_id then 
                    if val.jp_win_type > 4 then 
                        sType = "moon"
                    else 
                        sType = "sun"
                    end
                end
            end
            info = {
                jp_win_payout = val.jp_win_payout or val.jp_win or 0, -- pay_out 情况下 jp弹窗展示赢钱
                coins = val.jp_win, -- pay_out 情况下，真实赢钱1.15倍
                types = val["jp_win_type"],
                dialog_type = sType,
                jp_win_type = val.jp_win_type
            }
            table.insert(self.dialogList, info)
        end
    end
    if self.dialogList and #self.dialogList > 1 then 
        table.sort(self.dialogList, function ( a, b )
			return a.coins > b.coins
		end)
    end
end
function cls:playDialogByFirstStep()
    self:addFooterCoins(self.data.addJpCoins)
    self._mainViewCtl:updateFooterCoin()
    self:playDialogByStep()
end

function cls:addFooterCoins(allCoins)
    allCoins = allCoins or 0
    self._mainViewCtl.totalWin = self._mainViewCtl.totalWin + allCoins
    if self._mainViewCtl.freeCtl and self._mainViewCtl.freeCtl.freewin then 
        self._mainViewCtl.freeCtl.freewin = self._mainViewCtl.freeCtl.freewin + allCoins
    end
end
function cls:setJackpotPro()
	self.data.dialogPro = self.data.dialogPro + 1
	self:saveBonus()
end
function cls:setJackCoins(coins)
	coins = coins or 0
	self.data.addJpCoins = self.data.addJpCoins + coins
	self:saveBonus()
end

-- -- 不管有没有弹窗都进入准备弹窗
function cls:playDialogByStep()
    if (self.dialogList and #self.dialogList == 0) or (self.dialogList and self.data.dialogPro >= #self.dialogList) then -- 直接可以退出游戏
        self:playBonusWinLine()
        self:exitJpBonus()
        return
    end
    local index = self.data.dialogPro + 1
    local val = self.dialogList[index]
    local jp_win_type = val.jp_win_type

    self:playMusicByName("trigger_bell")
    -- dialog_type
    if jp_win_type == self.gameMasterJpId then 
        self:playBonusAnimateByType(val.dialog_type)
    else 
       if jp_win_type >= 5 then
            self:playBonusAnimateByType("moon")
        else
            self:playBonusAnimateByType("sun")
        end 
    end
    
    if val.dialog_type ~= "normal" then 
        self._mainViewCtl.jpViewCtl:addJpAwardAnimation(jp_win_type)
    end
    self:laterCallBack(2, function ()
        if val.dialog_type == "normal" then 
            self:playNormalDialog(val, jp_win_type)
        else 
            self:playJpDialog(val, jp_win_type) 
        end
    end)
end 
function cls:playNormalDialog(data, jp_win_type)
    data = data or {}
	local theData = {}
	theData.coins = data.jp_win_payout or 0
    theData.bg = 3
    theData.top = 3
    -- self.ctl:playFadeToMinVlomeMusic()
    self._mainViewCtl:playMusicByName("dialog_wheel_collect")
    theData.click_event = function ( ... )
        -- self.ctl:playFadeToMaxVlomeMusic()
		self:setJackpotPro()
		self:setJackCoins(data.coins)
        self:addFooterCoins(data.coins)
        local rollTime = 0.3
        self._mainViewCtl.footer:setWinCoins(data.coins, self._mainViewCtl.totalWin - data.coins, rollTime)
		self._mainViewCtl:laterCallBack(2, function()
			self:playDialogByStep()
		end)
    end
    local dialog = self._mainViewCtl:showThemeDialog(theData, 3, "dialog_wheel", "lock_jp_collect")
    local collectRoot = dialog.collectRoot
    local multi_node = collectRoot:getChildByName("multi_node")
    local rapid_node = collectRoot:getChildByName("rapid_node")
    local rapid_count = rapid_node:getChildByName("rapid_count")
    local dialog_type = "jp_lock"
    if bole.isValidNode(multi_node) then
        multi_node:setVisible(false)
    end
    local fntFile = self._mainViewCtl:getFntFilePath("font/theme325_sun_new.fnt")
    rapid_count:setFntFile(fntFile)

    if self.gameConfig.dialog_jp_pos and self.gameConfig.dialog_jp_pos[dialog_type] then
        local dialog_pos = self.gameConfig.dialog_jp_pos[dialog_type]
        if bole.isValidNode(rapid_node) and dialog_pos.rapid_node then
            rapid_node:setPosition(dialog_pos.rapid_node)
        end

        local count = 9 - jp_win_type
        if jp_win_type == self.gameMasterJpId then
            count = jp_win_type
        elseif jp_win_type >= 5 then 
            count = 9 - jp_win_type + 5
        end
        if dialog_type == "jp_lock" and dialog_pos.multi[count] then
            rapid_count:setString(dialog_pos.multi[count].."X")
        end
    end
end
function cls:playJpDialog(data, jp_win_type)
    data = data or {}
	local theData = {}
	theData.coins = data.jp_win_payout or 0
	theData.bg = 2
	theData.top = 2
    local count = 9 - jp_win_type
    if jp_win_type == self.gameMasterJpId then
        count = jp_win_type
    elseif jp_win_type >= 5 then 
        count = 9 - jp_win_type + 5
    end
    local stype = data.dialog_type
    local countFnt = "font/theme325_moon_count.fnt"
	if stype and stype == "sun" then 
        theData.bg = 1
        theData.top = 1
        countFnt = "font/theme325_sum_count.fnt"
    end
    self._mainViewCtl:playMusicByName("dialog_wheel_collect")
    theData.click_event = function ( ... )
        self:setJackpotPro()
        self:setJackCoins(data.coins)
        self:addFooterCoins(data.coins)
        self._mainViewCtl.jpViewCtl:removeJpAwardAnimation(jp_win_type)
        local rollTime = 0.3
        self._mainViewCtl.footer:setWinCoins(data.coins, self._mainViewCtl.totalWin - data.coins, rollTime)
		self._mainViewCtl:laterCallBack(2, function()
			self:playDialogByStep()
		end)
    end
    
    local dialog_type = "small"
    local dialog

    ----- facebook
    local fbData = ActivityCenterControl:getInstance():getFbShareData() or {}
    local shareLink = self.gameConfig.share_link.other
    if count and count >=9 then
        shareLink = self.gameConfig.share_link.grand
    end
    local share_data = {
        share_id = shareLink[math.random(1, #shareLink)],
        share_tracker_id = fbData and fbData.share_tracker_id or 0,
    }
    theData.share_fb = share_data
	----- facebook

    dialog_type = "jp"
    dialog = self._mainViewCtl:showThemeDialog(theData, 3, "dialog_wheel", "wheel_collect")
    dialog:setPositionY(22)
	local collectRoot = dialog.collectRoot
	local rapid_node = collectRoot:getChildByName("rapid_node")
    local rapid_count = rapid_node:getChildByName("rapid_count")
    local multi_node = collectRoot:getChildByName("multi_node")
    if bole.isValidNode(multi_node) then
        multi_node:setVisible(false)
    end
    if rapid_count and count then 
        rapid_count:setFntFile(self._mainViewCtl:getFntFilePath(countFnt))
        rapid_count:setString(count)

        if self.gameConfig.dialog_jp_pos and self.gameConfig.dialog_jp_pos[dialog_type] then
            local dialog_pos = self.gameConfig.dialog_jp_pos[dialog_type]
            if bole.isValidNode(rapid_node) and dialog_pos.rapid_node then
                rapid_node:setPosition(dialog_pos.rapid_node)
            end
        end
    end
end
function cls:playBonusWinLine()
    local rets = {}
    self:playBonusAnimateByType("show")
    if self.winPosList and #self.winPosList > 0 then 
        rets["win_pos_list"] = self.winPosList
        rets["win_lines"] = self.win_lines
        rets["item_list"] = table.copy(self.lastItemList)
        self._mainViewCtl:adjustRecData(rets)
        self._mainViewCtl:drawAnimate(rets)
    end
end
function cls:exitJpBonus()
    self:collectNotice()
    -- 再次添加滚动的过程
    if self.baseWin and self.baseWin > 0 then 
        local rollTime = 0.3
        self:addFooterCoins(self.baseWin)
        self._mainViewCtl.footer:setWinCoins(self.baseWin, self._mainViewCtl.totalWin - self.baseWin, rollTime)
        self:setJackCoins(self.baseWin)
        self:laterCallBack(0.5, function ()
            self.bonus:exitJpBonus(self.data.addJpCoins) 
        end)
    else 
        self.bonus:exitJpBonus(self.data.addJpCoins)  
    end
end
-- -- 先滚钱
function cls:getMoonSymbolNums(item_list)
	if not item_list then return 0 end
	local nums = 0
	local special_symbol = self._mainViewCtl.gameConfig.special_symbol
	for col, item in pairs(item_list) do
		for row, moonId in pairs(item) do
			if moonId == special_symbol.double_rapid or 
				moonId == special_symbol.moon_wild or 
					moonId == special_symbol.moon then
						nums = nums + 1
			end
        end
	end
	return nums
end
function cls:getSunSymbolNums(item_list)
	if not item_list then return end
	local nums = 0
	local special_symbol = self._mainViewCtl.gameConfig.special_symbol
	for col, item in pairs(item_list) do
		for row, sunId in pairs(item) do
			if sunId == special_symbol.double_rapid or 
				sunId == special_symbol.sun_wild or 
					sunId == special_symbol.sun then
						nums = nums + 1
			end
        end
	end
	return nums
end

function cls:collectNotice()
    self.bonus.themeCtl:collectCoins(1)
    self.bonus.data["end_game"] = true
    self.bonus:saveBonus()
end

function cls:getCsbPath( file_name )
    return self._mainViewCtl:getCsbPath(file_name)
end

function cls:getFntFilePath( file_name )
    return self._mainViewCtl:getFntFilePath(file_name)
end

function cls:playFadeToMinVlomeMusic( ... )
	self._mainViewCtl:playFadeToMinVlomeMusic()
end
function cls:playFadeToMaxVlomeMusic( ... )
	self._mainViewCtl:playFadeToMaxVlomeMusic()
end

return cls