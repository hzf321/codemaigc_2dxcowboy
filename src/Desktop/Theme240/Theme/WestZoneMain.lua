--Author:李天旸 art:董如楠;  math:丁一峰  策划:李沫
--2021年3月10日 16:00
--Using:主题 ThemeOriental_RichesMainViewControl


local parentClass = ThemeBaseViewControl -- ThemeBaseViewControl
-- WestZoneMain =  -- 
local cls = class("WestZoneMain", parentClass)
 
local mainView = require (bole.getDesktopFilePath("Theme/WestZoneView"))   
local collectViewCtl = require (bole.getDesktopFilePath("Theme/WestZoneCollectViewControl"))    
local jpViewCtl = require (bole.getDesktopFilePath("Theme/WestZoneJackpotViewControl"))  
local freeViewCtl = require (bole.getDesktopFilePath("Theme/WestZoneFreeViewControl")) 
local themeConfig = require (bole.getDesktopFilePath("Theme/WestZoneConfig")) 
local ThemeBaseDialog = require "Themes/base/ThemeBaseDialog"
 
 

------------------------------------ 资源异步加载相关 ----------------------------------------
function cls:ctor(themeid, theScene)
    self.gameConfig = themeConfig
	self.baseBet = self.gameConfig.init_config.baseBet
	self.UnderPressure = self.gameConfig.init_config.underPressure
    self.themeResourceId = themeid
	self.ThemeConfig = tool.tableClone(self.gameConfig.theme_config.reel_symbol)
    self.musicVolumeConfig = self.gameConfig.music_volume
    self.LowSymbolList = self.gameConfig.symbol_config.low_symbol_list
    self.majorSymbolList = self.gameConfig.symbol_config.major_symbol_list
	local ret = parentClass.ctor(self, themeid, self.gameConfig.isPortrait, theScene)
	return ret
end

function cls:getJpLockStatus(jpwinType)
    return self.jpViewCtl:getJpLockStatus(jpwinType)
end

function cls:addJpAwardAnimation(jpWinType)
    self.jpViewCtl:addJpAwardAnimation(jpWinType)
end

function cls:removeJpAwardAnimation(jpWinType)
    self.jpViewCtl:removeJpAwardAnimation(jpWinType)
end
function cls:playTransition(endCallBack, tType)
    self.mainView:playTransition( endCallBack, tType)
end

function cls:initGameControlAndMainView( ... )
	self.mainView = mainView.new(self)
    self.jpViewCtl = jpViewCtl.new(self)
    self.collectViewCtl = collectViewCtl.new(self)
    self.freeCtl = freeViewCtl.new(self)
	parentClass.initGameControlAndMainView(self)
end

function cls:setFooterBtnsEnable(enable)
    if not enable then
        self.footer:displayAutoplayInterface(false)
    end
    self.footer:setSpinButtonState(not enable)
    self.footer:enableOtherBtns(enable)
end

function cls:finshSpin( ... )
    if (not self.freewin) and (not self.autoSpin) and (not self.bonus) then
        self:enableMapInfoBtn(true)
    end
end

function cls:enableMapInfoBtn( enable )
    self.isCanFeatureClick = enable
end

function cls:refreshNotEnoughMoney(enable)
    self:enableMapInfoBtn(true)
end

function cls:getCanTouchFeature( ... )
    return self.isCanFeatureClick
end

function cls:getMusicVConfig( ... )
    return self.musicVolumeConfig
end

function cls:getBoardConfig( ... )
	if self.boardConfigList then
		return self.boardConfigList 
	end
	local borderConfig = tool.tableClone(self.ThemeConfig["boardConfig"])
    local _cellWidth = self.gameConfig.G_CELL_WIDTH
    local _cellHeight =self.gameConfig.G_CELL_HEIGHT
    local newBoardConfig = {}
    local _boardConfig = borderConfig[1]
    local _reelConfig  = _boardConfig.reelConfig
    local _basePos     = self.gameConfig.basePos
    local _lineWidth   = self.gameConfig.lineWidth
    local _lineHeight  = self.gameConfig.lineHeight
    newBoardConfig[1] = {}
    newBoardConfig[1].allow_over_range = _boardConfig.allow_over_range
    newBoardConfig[1].show_parts = _boardConfig.show_parts
    newBoardConfig[1].reelConfig = {}
    for col = 1, borderConfig[1].colCnt do
        local oneConfig = {}
        oneConfig.base_pos = table.copy(_reelConfig[col]["base_pos"])
        oneConfig.cellHeight  = _cellHeight
        if col > 3 and col < 7 then
            oneConfig.cellHeight  = _cellHeight +  _lineWidth - 1.2
            oneConfig.base_pos = cc.pSub(_reelConfig[col]["base_pos"], cc.p(0,(_lineWidth - 1.2)/ 2))
        end
        oneConfig.cellWidth = _cellWidth
        oneConfig.lineWidth = _lineWidth
        oneConfig.symbolCount = _reelConfig[col]["symbolCount"]
        table.insert(newBoardConfig[1].reelConfig, oneConfig)
    end
    newBoardConfig[2] = {}
    newBoardConfig[2].allow_over_range = _boardConfig.allow_over_range
    newBoardConfig[2].reelConfig = {}
    for col, list in ipairs(self.gameConfig.respinLineHeight) do
        for row = 1, list do 
            local oneConfig = {}
            local oldX = (col - 1) * _cellWidth + _basePos.x + (col - 1) * _lineHeight
            local oldY = math.floor((list - row) * _cellHeight + _basePos.y + (list - row) * _lineHeight)
            -- oneConfig["base_pos"] = cc.p(oldX,oldY)
            -- if col > 1 and col < 5 then
            --     oneConfig.cellHeight  = _cellHeight - 1
            --     oneConfig["base_pos"] = cc.p(oldX,oldY - 1)
            -- else 
                oneConfig.cellHeight  = _cellHeight
                oneConfig["base_pos"] = cc.p(oldX,oldY)
            -- end
            oneConfig.cellWidth   = _cellWidth
            oneConfig.symbolCount = 1
            oneConfig.lineHeight = _lineHeight
            oneConfig.lineWidth = _lineWidth
            table.insert(newBoardConfig[2].reelConfig, oneConfig)
        end
    end
    newBoardConfig[2].single = true
    self.boardConfigList = newBoardConfig
    return self.boardConfigList
end

function cls:getFreeReel( ... )
    if self:getSuperFreeStatus() then 
        if self.wildType == 1 then 
            return table.copy(self.gameConfig.theme_reels.superfree_reel_1)
        else
            return table.copy(self.gameConfig.theme_reels.superfree_reel_2)
        end
    else 
        if self.wildType == 1 then 
            return table.copy(self.gameConfig.theme_reels.free_reel_1)
        else
            return table.copy(self.gameConfig.theme_reels.free_reel_2)
        end
    end
end

function cls:updateSpecailReel(pCol)
    self.currentReels = self.currentReels or {}
    self.currentReels[pCol] = table.copy(self.theme_reels["respin_jili"])
    self:setChangeRespinStatus(true)
end
function cls:getChangeRespinStatus()
    return self.changeRespinReelStatus
end
function cls:setChangeRespinStatus(enable)
    self.changeRespinReelStatus = enable
end
function cls:getMainReel()
    return table.copy(self.theme_reels["main_reel"])
end
function cls:getBonusReel()
    local bonusReel = table.copy(self.theme_reels["respin_reel"])
    if bonusReel and #bonusReel == 1 then
        local maxCol = 18
        for col = 1, maxCol do
            bonusReel[col] = table.copy(self.theme_reels["respin_reel"][1])
        end
        self.theme_reels["respin_reel"] = bonusReel
    end
    return bonusReel
end

function cls:getThemeJackpotConfig()
    local jackpot_config_list = self.gameConfig.jackpotCtlConfig
    return jackpot_config_list
end

function cls:getSpineFile(file_name)
    local path2 = self.gameConfig.spine_path[file_name]
    local path = string.format("theme_resource/theme%d/spine/%s", self.themeResourceId, path2)
    return path
end

function cls:getFntFilePath( file_name )
    local path = string.format("theme_resource/theme%d/font/%s", self.themeResourceId, file_name)
    return path
end

function cls:getCsbPath( file_name )
    local path2 = self.gameConfig.csb_list[file_name]
    local path = string.format("theme_resource/theme%d/%s", self.themeResourceId, path2)
    return path
end

function cls:isLowSymbol( item )
    if not item then return false end
    if self.LowSymbolList[item] then
        return true
    end
    return false
end

function cls:getSpinConfig( ... )
	local spinConfig = {}
    local respinReelCol = {3, 7, 11, 15, 18}
    if self.showReSpinBoard then
        for col = 1, 18 do
			local tempCol = col
			for key, val in ipairs(respinReelCol) do
				if tempCol <= val then
					tempCol = key
					break
				end
			end
            local theStartAction = self:getSpinColStartAction(tempCol, col)
            local theReelConfig = {
                ["col"] = col,
                ["action"] = theStartAction,
            }
            table.insert(spinConfig, theReelConfig)
		end
    else
        for col, _ in pairs(self.mainView.spinLayer.spins) do
            local theStartAction = self:getSpinColStartAction(col)
            local theReelConfig = {
                ["col"] = col,
                ["action"] = theStartAction,
            }
            table.insert(spinConfig, theReelConfig)
        end
    end

    return spinConfig
end

function cls:getStopConfig( ret, spinTag ,interval )
	local stopConfig  = {}
    local respinReelCol = {3, 7, 11, 15, 18}
	if self.showReSpinBoard then
		for col = 1, 18 do
			-- local tempCol = col
			-- for key, val in ipairs(respinReelCol) do
			-- 	if tempCol <= val then
			-- 		tempCol = key
			-- 		break
			-- 	end
			-- end
            local theAction = self:getSpinColStopAction(ret["theme_info"], col, interval)
            table.insert(stopConfig, { col, theAction})
		end
	else
		for i = 1, 9 do
            local theAction = self:getSpinColStopAction(ret["theme_info"], i ,interval)
            table.insert(stopConfig, {i, theAction})
        end
	end
	return stopConfig
end

function cls:getSpinColStartAction( pCol, reelCol)
    local config = self.gameConfig.reel_spin_config
	if self.isTurbo then
		config.maxSpeed = config.fastSpeed
	else
		config.maxSpeed = config.normalSpeed
	end
	local spinAction = {}
	spinAction.delay = config.delay*(pCol-1)
	spinAction.upBounce = config.upBounce
	spinAction.upBounceMaxSpeed = config.upBounceMaxSpeed
	spinAction.upBounceTime = config.upBounceTime
	spinAction.speedUpTime = config.speedUpTime
	spinAction.maxSpeed = config.maxSpeed
	if self.showReSpinBoard and self.lockedReels[reelCol] then
        spinAction.locked = true
    end
	return spinAction
end

function cls:getSpinColStopAction(themeInfoData, pCol, interval)
    local _reelSpinConfig = self.gameConfig.reel_spin_config
    if pCol == 1 then -- 同时下落的时候 进行的 延迟 重置
        self.DelayStopTime = 0
        -- self.canFastStop = false
    end
    local checkNotifyTag = self:checkNeedNotify(pCol)
    if not self:checkSpecialFeature(themeInfoData) and checkNotifyTag then 
        self.DelayStopTime = self.DelayStopTime + _reelSpinConfig.extraReelTime
        -- if isRespin then
        --     self:updateSpecailReel(pCol)
        -- end
    end
    -- if self.checkRespinNotifyTag and self.checkRespinNotifyTag == pCol then 
    --     self.DelayStopTime = self.DelayStopTime + _reelSpinConfig.extraReelTime
    --     self:updateSpecailReel(pCol)
    -- end
    if self:getRespinGranAnticaption(pCol) then
        self.DelayStopTime = self.DelayStopTime + _reelSpinConfig.extraReelTime
        self:updateSpecailReel(pCol)
    end

    -- 判断需不需要额外的添加时间
    local temp = interval - _reelSpinConfig.speedUpTime - _reelSpinConfig.upBounceTime
    local timeleft = _reelSpinConfig.rotateTime - temp > 0 and _reelSpinConfig.rotateTime - temp or 0
    
    local spinAction = {}
    spinAction.actions = {}
    local _stopDelay = _reelSpinConfig.stopDelay
    local _downBonusT = _reelSpinConfig.downBounceTime
    spinAction.stopDelay = timeleft+(pCol-1)*_stopDelay + self.DelayStopTime
    self.ExtraStopCD = _reelSpinConfig.spinMinCD - temp > 0 and _reelSpinConfig.spinMinCD - temp or 0
    spinAction.maxSpeed = _reelSpinConfig.maxSpeed
    spinAction.speedDownTime = _reelSpinConfig.speedDownTime
    -- if self.checkRespinNotifyTag and self.checkRespinNotifyTag == pCol then 
    --     spinAction.speedDownTime = _reelSpinConfig.speedDownTime * 3
    -- end
    if not self:getRespinStatus() and pCol > 3 and pCol < 7 then
        spinAction.maxSpeed = _reelSpinConfig.maxSpeed * 11/8
        -- spinAction.speedDownTime = spinAction.speedDownTime * 8.5/8  --8/5
        -- self.DelayStopTime = self.DelayStopTime + spinAction.speedDownTime * 3/8 
    end

    if self.isTurbo then
        if self:getRespinStatus() then
            spinAction.speedDownTime = spinAction.speedDownTime * 5/8
        elseif pCol > 3 and pCol < 7 then
            spinAction.speedDownTime = spinAction.speedDownTime * 8/11
        else
            spinAction.speedDownTime = spinAction.speedDownTime * 5/8
        end
    end
    spinAction.downBounce = _reelSpinConfig.downBounce
    spinAction.downBounceMaxSpeed = _reelSpinConfig.downBounceMaxSpeed
    spinAction.downBounceTime = _downBonusT
    spinAction.stopType = 1
    return spinAction
end

function cls:getRespinGranAnticaption(pCol)
    if self.respinCtl and self.respinCtl.getGrandExcitation then
        local col = self.respinCtl:getGrandExcitation()
        if col and col > 0 and col == pCol then
            return true
        end
        return false
    end
    return false
end

function cls:isAutoSpinNodeShow( ... )
    local show = false
    if self.footer and self.footer.autoSpinNode then
        show = self.footer.autoSpinNode:isVisible()
    end
    return show
end


function cls:onSpinStart( ... )
    if self.collectViewCtl then
        self.collectViewCtl:onSpinStart()
    end
    self.mainView:onSpinStart()
    self:enableMapInfoBtn(false)
    parentClass.onSpinStart(self)
end

function cls:onSpinStop(ret)
	if self.showReSpinBoard then
		self:fixRet(ret)
	end
	parentClass.onSpinStop(self, ret)
end

function cls:stopControl( stopRet, stopCallFun )
    self.item_list = nil
    self.item_list = stopRet["item_list"]
    self.currentSpecailType = nil
    local delayTime = 0

    if stopRet["bonus_level"] then
        self.tipBetList = stopRet["bonus_level"]
        self.bonusLevelChange = true
    end
    if self.freeCtl then
        self.freeCtl:stopFreeControl(stopRet)
    end

    if stopRet.theme_info then
        local stopThemeInfo = stopRet.theme_info
        if self.showBaseSpinBoard then
            if stopThemeInfo.map_info and stopThemeInfo.map_info.map_level then 
                self.fg_level = stopThemeInfo.map_info.map_level
            end
        end       
    end
    if self:checkSpecialFeature(stopRet["theme_info"]) then
        self.currentSpecailType = true
        delayTime = self.mainView:addSpecailJili()
    end
    if delayTime > 0 then
        self:laterCallBack(delayTime, function ()
            if stopCallFun then 
                stopCallFun()
            end
        end)
    else 
        if stopCallFun then 
            stopCallFun()
        end
    end
end

function cls:dealMusic_PlayReelStopMusic()
    
end

---------------------激励相关---------------------------
function cls:onReelFallBottom( pCol )
    self.reelStopMusicTagList[pCol] = true
    -- self:dealMusic_StopReelNotifyMusic(pCol)

    -- if self.showReSpinBoard then 
	-- 	-- self:dealMusic_PlayShortNotifyMusic(pCol)
	-- else
	-- 	if not self:checkPlaySymbolNotifyEffect(pCol) then
	-- 		self:dealMusic_PlayReelStopMusic(pCol)
	-- 	end
	-- end

    -- self:stopReelNotifyEffect(pCol)
    -- self:stopRespinReelNotifyEffect(pCol)

    self:playColLandEffect(pCol)
    if self:checkSpeedUp(pCol + 1) then
        self:onReelNotifyStopBeg(pCol + 1)
    -- elseif self:checkRespinSpeedUp(pCol+1) then
	-- 	self:playRespinReelNotifyEffect(pCol+1)
	end
end

function cls:onReelFastFallBottom( pCol )
    self.reelStopMusicTagList[pCol] = true
	self.fastStopMusicTag = self.fastStopMusicTag or "allow_music"
	-- self:dealMusic_StopReelNotifyMusic(pCol)

	-- -- self.fastStopMusicTag = self.fastStopMusicTag or "allow_music"
	-- if not self:checkPlaySymbolNotifyEffect(pCol) then
	-- 	self:dealMusic_PlayReelStopMusic(pCol)
	-- end

	-- self:stopReelNotifyEffect(pCol)
	-- self:stopRespinReelNotifyEffect(pCol)
    self:playColLandEffect(pCol)
end

function cls:playColLandEffect(pCol)
    self:setReelStopMusic(pCol) --设置当列音效可以停止播放
    self:dealMusic_StopReelNotifyMusic(pCol) -- 设置之前的音效停止
    self:checkPlaySymbolNotifyEffect(pCol)
    self:dealMusic_PlayReelStopMusic(pCol) -- 播放列停音效
    self:stopReelNotifyEffect(pCol) -- 删掉之前的激励动画
    self:stopRespinReelNotifyEffect(pCol)
end

function cls:dealMusic_PlayReelStopMusic(pCol)
    if self.reelStopMusic and self.reelStopMusic[pCol] then 
        if not self:getRespinStatus() then
            self.audioCtl:playEffectWithInterval(self.audio_list["reel_stop"],0.1,false)
        end
    end
end

function cls:setReelStopMusic(pCol)
    self.reelStopMusic = self.reelStopMusic or {}
    self.reelStopMusic[pCol] = true
end

function cls:setReelSpecailLandMusic(pCol)
    self.reelStopMusic = self.reelStopMusic or {}
    self.reelStopMusic[pCol] = false
end

function cls:cleanReelStopMusic()
    self.reelStopMusic = {}
end

function cls:checkRespinSpeedUp(checkCol) -- 控制出现特殊的龙 虎 预示好事发生的动画的时候 取消单个轴的 加速操作
	-- local isNeedSpeedUp = false
	-- if self.speedRespinUpState and self.speedRespinUpState[checkCol] and bole.getTableCount(self.speedRespinUpState[checkCol])>0 then
	-- 	isNeedSpeedUp = true
	-- end
    -- if self.currentSpecailType then
    --     isNeedSpeedUp = false
    -- end
	-- return isNeedSpeedUp
end

function cls:checkSpeedUp( checkCol)
    local isNeedSpeedUp = false
    if not self.ctl.specialSpeed and self.speedUpState and self.speedUpState[checkCol] and bole.getTableCount(self.speedUpState[checkCol])>0 then
        isNeedSpeedUp = true
    end
    if self.currentSpecailType then
        isNeedSpeedUp = false
    end
	return isNeedSpeedUp
end

function cls:checkNeedNotify( pCol )
	local checkNotifyTag = self:checkSpeedUp(pCol)
    -- local isRespin = nil
	-- if not checkNotifyTag then
	-- 	checkNotifyTag = self:checkRespinSpeedUp(pCol)
    --     isRespin = checkNotifyTag
	-- end
	return checkNotifyTag
end

function cls:genSpecialSymbolState( rets )
    rets = rets or self.ctl.rets -- 复制 通用逻辑
	if not self.checkItemsState then
		self.checkItemsState = {}  -- 都已列作为项， 各列各个sybmol相关状态，分为后面有可能，单列就有可能中，已经中了，后续没有可能中了
		self.speedUpState 	 = {}  -- 加速的列控制
        self.respinMusicLevel = 0
		-- self.speedRespinUpState = {} -- respin 加速的列控制
		self.notifyState 	 = {}  -- 播放特殊symbol滚轴停止的时候的动画位置
		self:genSpecialSymbolStateInNormal(rets) -- base 情况 配置 scatter、bonus
	end
end

function cls:genSpecialSymbolStateInNormal(rets)
	local cItemList   = rets.item_list
	local checkConfig = self.specialItemConfig
    local limitRow = 4
	local respinConfig = {
		["min_cnt"] = 6,
		["col_set"] = {
			[1] = 1,[2] = 1,[3] = 1,
			[4] = 4,[5] = 4,[6] = 4,
			[7] = 3,[8] = 2,[9] = 1,
		},
	}
    if self:getSuperFreeStatus() then
        respinConfig["min_cnt"] = 4
        limitRow =  3
    end
	if self.showReSpinBoard then
	else
		for itemKey,theItemConfig in pairs(checkConfig) do
			local itemType     = theItemConfig["type"]
			local itemCnt  	   = 0
			local respinItemCnt= 0
			-- local isBreak 	   = false
			if itemType then
				for col=1, #self.mainView.spinLayer.spins do
                    local colItemList  = cItemList[col]
                    local colRowCnt    = self.mainView.spinLayer.spins[col].row
                    local curColMaxCnt = theItemConfig["col_set"][col] or colRowCnt
                    -- local respinColMaxCnt = respinConfig["col_set"][col] or colRowCnt
                    local willGetFeatureInAfterCols = false
                    local willGetRespinInAfterCols = false
                    local sumCnt = 0
                    local respinSumCnt = 0
                    for tempCol = col, #self.mainView.spinLayer.spins do
                        sumCnt = sumCnt + (theItemConfig["col_set"][tempCol] or colRowCnt)
                        if tempCol < 7 then
                            respinSumCnt = respinSumCnt + respinConfig["col_set"][tempCol] 
                        else
                            respinSumCnt = respinSumCnt + 1
                        end
                    end
                    if sumCnt>0 and (itemCnt+sumCnt)>= theItemConfig["min_cnt"] then
                        willGetFeatureInAfterCols = true
                    end

                    if (curColMaxCnt > 0) and (itemCnt+curColMaxCnt)>= theItemConfig["min_cnt"] then  -- 控制加速的列
                        self.speedUpState[col] = self.speedUpState[col] or {}
                        self.speedUpState[col][itemKey] = true
                    end

                    self.notifyState[col] = self.notifyState[col] or {}
                    if curColMaxCnt > 0 then  -- 这里是用于落地动画
                        for row, theItem in pairs(colItemList) do
                            if theItem == self.gameConfig.special_symbol["scatter"] then
                                self.notifyState[col][theItem] = self.notifyState[col][theItem] or {}
                                table.insert(self.notifyState[col][theItem], {col, row, theItem, willGetFeatureInAfterCols})
                            end
                        end
                    end
                    
                    if  (respinItemCnt + respinSumCnt) >= respinConfig["min_cnt"] then
                        willGetRespinInAfterCols = true
                    end
                    -- if respinItemCnt >= limitRow and (respinItemCnt + respinColMaxCnt) >= respinConfig["min_cnt"] then
                    --     self.speedRespinUpState[col] = self.speedRespinUpState[col] or {}
                    --     self.speedRespinUpState[col][11] = true
                    -- end
                    for row, theItem in pairs(colItemList) do
                        if theItem >= 22 then
                            self.notifyState[col][11] = self.notifyState[col][11] or {}
                            local count = 0  
                            for index = 1, row - 1  do if colItemList[index] >= 22 then count = count + 1 end end
                            if not self:getSuperFreeStatus() then
                                if col == 6 and row >= 3 then
                                    if row == 3 and respinItemCnt + count >= 1 then 
                                        table.insert(self.notifyState[col][11], {col, row, theItem, true})
                                    elseif row == 4 and respinItemCnt + count >= 2 then
                                        table.insert(self.notifyState[col][11], {col, row, theItem, true})
                                    else
                                        table.insert(self.notifyState[col][11], {col, row, theItem, false})
                                    end
                                else
                                    table.insert(self.notifyState[col][11], {col, row, theItem, willGetRespinInAfterCols})
                                end
                            else
                                
                                if col > 6 then
                                    if  respinItemCnt + count >= col - 6 then 
                                        table.insert(self.notifyState[col][11], {col, row, theItem, true})
                                    else
                                        table.insert(self.notifyState[col][11], {col, row, theItem, false})
                                    end
                                else
                                    table.insert(self.notifyState[col][11], {col, row, theItem, willGetRespinInAfterCols})
                                end
                            end
                        end
                    end

                    for row, theItem in ipairs(colItemList) do
                        if theItem >= 22 then
                            respinItemCnt = respinItemCnt + 1
                        end
                        
                        if theItem == 10 then
                            itemCnt = itemCnt + 1
                        end
                    end
				end
			end
		end
	end
end

function cls:checkPlaySymbolNotifyEffect( pCol )
    self.notifyState = self.notifyState or {}
    local reelSymbolState = self.notifyState[pCol]
    -- if not self.fastStopMusicTag and reelSymbolState and bole.getTableCount(reelSymbolState)>0 then -- 判断是否播放特殊symbol的动画
        self:dealMusic_PlaySpecialSymbolStopMusic(pCol)
    --     return true
    -- else
    --     self:dealMusic_PlaySpecialSymbolStopMusic(pCol)
    --     return false
    -- end
end

function cls:dealMusic_PlaySpecialSymbolStopMusic( pCol )
    local basepCol = pCol
    self.notifyState = self.notifyState or {}
    if (not self.notifyState[pCol]) or bole.getTableCount(self.notifyState[pCol]) == 0 then
        return false
    end
    local ColNotifyState = self.notifyState[pCol]
    local haveSymbolLevel = 4
    if ColNotifyState[self.gameConfig.special_symbol["scatter"]] 
    or ColNotifyState[11] then
        haveSymbolLevel = 1
        self:playSymbolNotifyEffect(pCol, true)
        self.notifyState[pCol] = {}
    end
    if haveSymbolLevel < 4 then
        return true
    end
end

function cls:getNormalStopAddCount()
    local config = self.gameConfig.reel_spin_config
    local addHeight = config.downBounce + self.gameConfig.G_CELL_HEIGHT * 0.5
    local extra = math.ceil(addHeight / self.gameConfig.G_CELL_HEIGHT)
    return extra
end

function cls:dealMusic_StopReelNotifyMusic( pCol )
	if not self.playR1Col then return end
	self.playR1Col = nil
	self.audioCtl:stopMusic(self.audio_list.reel_scatter,true)
	-- self.audioCtl:stopMusic(self.audio_list.reel_bonus,true)
	-- self.audioCtl:stopMusic(self.audio_list.reel_scatter_3,true)
	-- self.audioCtl:stopMusic(self.audio_list.reel_scatter_4,true)
	-- self.audioCtl:stopMusic(self.audio_list.reel_scatter_5,true)
end

function cls:playReelNotifyEffect( pCol )
    self:playFadeToMinVlomeMusic()
    self.reelNotifyEffectList = self.reelNotifyEffectList or {}
    self.speedUpState = self.speedUpState or {}
    self.speedUpState[pCol] = self.speedUpState[pCol] or {}
    if self.speedUpState[pCol][self.gameConfig.special_symbol.scatter] then 
        self:playMusicByName("reel_scatter", true)
        local pos = self:getCellPos(pCol,2)
        pos = cc.pSub(pos, cc.p(0, (self.gameConfig.G_CELL_HEIGHT + self.gameConfig.lineWidth)/2))
        local animName = "animation" 
        local spineFile = "scatter_jili"
        local bg_file = self:getSpineFile(spineFile)
        local _,s1 = self:addSpineAnimation(self.mainView.jpReelAnimate, 21, bg_file, pos, animName,nil,nil,nil,true,true)
        self.reelNotifyEffectList[pCol] = s1
    end
    self.playR1Col = pCol
end

function cls:playRespinReelNotifyEffect(pCol)  -- 播放滚轴激励效果
    -- self:playFadeToMinVlomeMusic()
	-- local animation = "animation"
	-- self.reelRespinNotifyEffectList = self.reelRespinNotifyEffectList or {}
	-- local pos = cc.p(0,0)
	-- if pCol > 6 then
	-- 	animation = "animation2"
    --     pos = self:getCellPos(8, 1)
	-- else
	-- 	pos = cc.pAdd(self:getCellPos(pCol, 2), cc.p(0, -(self.gameConfig.G_CELL_HEIGHT + self.gameConfig.lineWidth)/2))
	-- end
	-- local file = self:getSpineFile("bonus_reel_excitation")
 	-- local _,s1 = self:addSpineAnimation(self.mainView.bonusReelAnimate, 21, file, pos, animation,nil,nil,nil,true,true)
 	-- self.reelRespinNotifyEffectList[pCol] = s1
 	-- self:playMusicByName("reel_bonus", true)
    --  self.playR1Col = pCol
end

function cls:stopRespinReelNotifyEffect(pCol)
    -- self:playMusicByName("reel_stop")
    self:playFadeToMaxVlomeMusic()
	self.reelRespinNotifyEffectList = self.reelRespinNotifyEffectList or {}
	if self.reelRespinNotifyEffectList[pCol] and (not tolua.isnull(self.reelRespinNotifyEffectList[pCol])) then
		self.reelRespinNotifyEffectList[pCol]:removeFromParent()
	end
	self.reelRespinNotifyEffectList[pCol] = nil
end

function cls:onRespinStart()
    if self.showReSpinBoard and self.respinCtl then
        self.respinCtl:onRespinStart()
    end
    parentClass:onRespinStart(self)
end


function cls:onRespinStop( ret )
    if self.showReSpinBoard and self.respinCtl then
        self.respinCtl:beforeRespinStop(ret)
    end
    parentClass:onRespinStop(self, ret)
end

function cls:getSymbolLabel(num)
	local coins = 0
	num = num or 0
	local currentBet = self.ctl:getCurBet()
	coins = currentBet * num
	return coins 
end


function cls:finishSpin( )
	if (not self.ctl.freewin) and (not self.ctl.autoSpin) and not self.bonus then
        self:enableMapInfoBtn(true)
    end
end

function cls:theme_deal_show( ret )
	ret.theme_deal_show = nil
	if self.respinStep == self.gameConfig.ReSpinStep.Over then
		self.respinCtl:onRespinStop(ret)
	end
end

function cls:getJackpotValue(incrementList,mul)
	if self.jpViewCtl then 
		return self.jpViewCtl:getJackpotValue(incrementList,mul)
	end
end
function cls:formatJackpotMeter(list)
	if self.jpViewCtl then 
		return self.jpViewCtl:formatJackpotMeter(list)
	end
end

function cls:theme_respin( rets )
	self.node:runAction(
            cc.Sequence:create(
                    cc.DelayTime:create(0.5),
                    cc.CallFunc:create(
                            function()
                                local respinList = rets["theme_respin"]
                                if respinList and #respinList > 0 then
                                    local itemList = self.respinCtl:fixRespinResult()
                                    rets["item_list"] = itemList
                                    rets["theme_respin"] = {}
                                    local respinStopDelay = 1
                                    self:stopDrawAnimate()
                                    self.ctl:respin(respinStopDelay)
                                else
                                    rets["theme_respin"] = nil
                                    rets["item_list"] = nil
                                end
                            end
                    )
            )
    )
end

function cls:getTheRespinEndDealFunc( rets )
	local retDealFunc = function(outDealFunc)
        if outDealFunc then
            outDealFunc()
        end
    end
    return retDealFunc
end

-- function cls:addBoardShakerI(time, dix)
--     local function shakeEnd()
--         self.shakerI = nil
--     end
--     time = time or 5
--     dix = dix or 3
--     self:playMusicByName("sharke_jili")
--     self:stopScreenShakerI()
--     self.shakerI = ScreenShaker.new(self.mainView.shake_node,time,shakeEnd)
--     self.shakerI:setMaxAmplitude(dix)
-- 	self.shakerI:run()
-- end
-- function cls:stopScreenShakerI()
--     if self.shakerI then
--         self.shakerI:stop()
--         self.shakerI = nil
--     end
-- end

function cls:onReelStop( pCol )
    if self.showReSpinBoard and self.respinCtl then
		self.respinCtl:respin_onReelStop(pCol)
    end
end
function cls:onAllReelStop()
    if self:getChangeRespinStatus() then
        self:setChangeRespinStatus(false)
        if self:getRespinStatus() then
            self:resetCurrentReels(nil, true)
        elseif self:getNormalStatus() then
            self:resetCurrentReels()
        else
            self:resetCurrentReels(true)
        end
    end
    parentClass.onAllReelStop(self)
end
function cls:getRespinStatus()
    return self.showReSpinBoard
end



function cls:stopReelNotifyEffect( pCol )
    -- self:playMusicByName("reel_stop")
    self.reelNotifyEffectList = self.reelNotifyEffectList or {}
    if self.reelNotifyEffectList[pCol] and (not tolua.isnull(self.reelNotifyEffectList[pCol])) then
        self.reelNotifyEffectList[pCol]:removeFromParent()
    end
    self.reelNotifyEffectList[pCol] = nil
end
------------结果特殊处理 end ----------
function cls:onThemeInfo( specialData, callFunc )
    -- 禁止点击按钮
    self:setBeforeWinShow(specialData)
    self.ctl.footer:setSpinButtonState(true)
    self.themeInfoCallFunc = callFunc
    self:checkHasWinInThemeInfo(specialData)
end

---------- 设置合成动画 start -----------
function cls:setBeforeWinShow(specialData)
    if specialData["base_win"] and specialData["base_win"] > 0 then
        specialData["before_win_show"] = true
    end
end

function cls:beforeWinShow(ret, onEnd)
    --先处理结果
    --首先判断是否在fg中，fg中需要添加wild动画, 需要合成的动画
    local winPosList = ret["win_pos_list"]
    local itemList = ret["item_list"]
    local finalResult, wildResult, changeAni = self:getResultList(winPosList, itemList)
    local delay = 0
    if changeAni then
        -- self.resultLongSymbolList = finalResult
        -- self.twinSymbolResult = wildResult
        self.mainView:addCombineAni(finalResult, wildResult)
        delay = 25/30
        if self:getNormalStatus() then delay = 15/30 end
    end
    self:laterCallBack(delay, function ()
        if onEnd then
            onEnd()
        end
    end)
end
function cls:getResultList(winPosList, itemList)
    local finalResult = {{{},{}},{{},{}},{{},{}}}
    local fgTwinResult = {}
	local wildResult = {}
    local changeAni = false
    local isTwinSymbol = self:getFgTwinSymbol()
	for _,pos in ipairs(winPosList) do
		local col = pos[1]
		local row = pos[2]
		local key = itemList[col][row]
		if col > 3 and col < 7  and (key == 12 or key == 13) then
			local startRow, endRow = self:getStartRow(col, row, itemList)
			if endRow - startRow > 0 then
				finalResult[col - 3][key - 11]["startRow"] = startRow
				finalResult[col - 3][key - 11]["endRow"] = endRow
				finalResult[col - 3][key - 11]["item"] = key
                if isTwinSymbol and isTwinSymbol == key then
                    finalResult[col - 3][key - 11]["changeWild"] = 1
                end
                changeAni = true
            elseif endRow - startRow == 0 and 
                isTwinSymbol and 
                key == isTwinSymbol then
                    table.insert(wildResult, {col, row, isTwinSymbol})
                    
                    changeAni = true
			end
        elseif isTwinSymbol and 
            (col <= 3 or col >= 7) and 
            isTwinSymbol == key then
                table.insert(wildResult, {col, row, isTwinSymbol})
                
                changeAni = true
		end
	end
	return finalResult, wildResult, changeAni
end
function cls:getStartRow(col, row, item_list)
	local span = row
	while span - 1 > 0  do
		if item_list[col][span] == item_list[col][span - 1] then
			span = span - 1
		else
			break
		end
	end
	while row + 1 < 5 do
		if item_list[col][row] == item_list[col][row + 1] then
			row = row + 1
		else
			break
		end
	end
	return span, row
end
---------- 设置合成动画 end -----------

function cls:checkHasWinInThemeInfo( specialData )
    specialData = specialData or {}
    local endCallFun = function ()
        if self.themeInfoCallFunc then 
            self.themeInfoCallFunc()
            self.themeInfoCallFunc = nil
        end
    end
    endCallFun()
end

function cls:playFadeToMaxVlomeMusic(  )
    local mvC = self.musicVolumeConfig
    self.audioCtl:dealMusic_FadeLoopMusic(mvC.time_volume, mvC.min_volume, mvC.max_volume)
end

function cls:playFadeToMinVlomeMusic(  )
    local mvC = self.musicVolumeConfig
    self.audioCtl:dealMusic_FadeLoopMusic(mvC.time_volume, mvC.max_volume, mvC.min_volume)
end

function cls:getNormalStatus( ... )
    if self.showFreeSpinBoard then
        return false
    end
    return true
end

function cls:getFreeVCtl( ... )
    return self.freeCtl
end

function cls:getJpViewCtl( ... )
    return self.jpViewCtl
end

function cls:getCollectViewCtl( ... )
    return self.collectViewCtl
end

function cls:lockJackpotValue( data )
    data = data or {0,0,0,0}
    if self.jpViewCtl then
        self.jpViewCtl:lockJackpotValue(data)
    end
end

function cls:showBaseBlackCover(opacity, dimmer)
    self.mainView:showBaseBlackCover(opacity, dimmer)
    -- local node = dimmer or self.mainView.transitionDimmer
    -- node:setOpacity(0)
    -- node:setVisible(true)
    -- node:stopAllActions()
    -- local a1 = cc.FadeTo:create(0.5, opacity or 200)
    -- node:runAction(a1)
end

function cls:hideBaseBlackCover( delay, wiatDelay ,dimmer)
    self.mainView:hideBaseBlackCover(delay, wiatDelay ,dimmer)
    -- local node = dimmer or self.mainView.transitionDimmer
    -- wiatDelay = wiatDelay or 0
    -- local a0 = cc.DelayTime:create(wiatDelay)
    -- local a1 = cc.FadeTo:create(delay or 0.5 , 0)
    -- local a2 = cc.DelayTime:create(delay or 0.5)
    -- local a3 = cc.CallFunc:create(function(...)
    --    node:setVisible(false)
    --    node = nil
    -- end)
    -- local a4 = cc.Sequence:create(a0, a1, a2, a3)
    -- node:stopAllActions()
    -- node:runAction(a4)
end

function cls:checkSpecialFeature(themeInfo, pCol )
    if not self.showReSpinBoard and themeInfo and themeInfo["special_type"] and (themeInfo["special_type"] == 1) then
        return true
    end
    return false
end
--------------------------------bet start----------------------------------
function cls:featureUnlockBtnClickEvent( _unLockType )
    if self.tipBetList and self.tipBetList[_unLockType] then
        if self:getCurBet() < self.tipBetList[_unLockType] then
            self:setBet(self.tipBetList[_unLockType])
        end
    end
end
--@bet change
function cls:dealAboutBetChange( theBet, isPointBet )
    if (not self.tipBetList) or (not self.loadFinish) then
        return
    end
    theBet = theBet or self:getCurTotalBet()
    local maxBet = self:getMaxBet()
    self:changeCollectBet(theBet) 
    if maxBet >= theBet then
        self:changeUnlockJpBet(theBet) --放在前面是以防升级的时候,jp解锁的情况
    end
    if self.currentUnlockBet and (self.currentUnlockBet == theBet) then
        return
    end
    self.currentUnlockBet = theBet
end

function cls:changeCollectBet( theBet )   
    self.collectViewCtl:changeCollectBet(theBet)
end

function cls:changeUnlockJpBet( theBet )
    self.jpViewCtl:changeUnlockJpBet(theBet)
end
--------------------------------bet end  ----------------------------------

function cls:showBonusNode( ... )
    -- self:resetCurrentReels(false, false)
    self:resetCurrentReels(false, true)
end

function cls:dealSpecialFeatureRet( data )
    self.tipBetList = data.bonus_level               
end

-- function cls:enterThemeByBonus(theBonusGameData, endCallFunc)
-- 	self.ctl:open_old_bonus_game(theBonusGameData, endCallFunc)
-- end

function cls:dealBonusGameResumeRet(data)
    if data["bonus_game"] then
        if data.bonus_game.choice and data.bonus_game.choice == 0 then
            self.isPickChooseRecover = true
        end
        self.item_list = data.bonus_game.item_list
    end
    if data["free_game"] then
        self.wildType = data.free_game.twins_symbol
    end
    if data["map_info"] then 
        self.fg_level  = data["map_info"]["map_level"]
        -- self.fg_type   = data["map_info"]["fg_type"]
        -- self.fgAvgBet  = data["map_info"]["avg_bet"]
        if self.showFreeSpinBoard then
            self.item_list = data["map_info"]["item_list"]
        end
    end
end
function cls:saveBonusCheckData( bonusData ) -- 没有断线的情况下进入bonus时候, 判断存在bonus_id校验字段, 直接赋值存储,同时覆盖掉原来的数据(每个主题里面单独控制是否需要清空数据)
	local data = {}
	data["bonus_id"] = bonusData.bonus_id
	LoginControl:getInstance():saveBonus(self.themeid, data)
end

function cls:cleanBonusSaveData( data ) -- 断线的情况下进入bonus时候, 判断bonus_id校验字段本地与服务器不一致, 清除原来的数据(每个主题里面单独控制是否需要清空数据)
	LoginControl:getInstance():saveBonus(self.themeid, nil)
end

function cls:saveBonusData()
	if self.ctl.rets then
		-- self.ctl.bonusItem 	= tool.tableClone(self.ctl.rets.item_list)
		self.ctl.bonusRet 	= self.ctl.rets
		self.bonusSpeical = self.ctl.specials
		-- self.item_list = self.ctl.rets.item_list
	end
end

function cls:outBonusStage(list)
	if self.bonusSpeical then
		self.ctl.specials = self.bonusSpeical
	end
	if list then
		self:recoverBoardItem(list)
	end
	self.ctl.bonusRet = nil
end

function cls:recoverBoardItem(itemList, type)
	itemList = itemList or self.item_list
    if not type or type ~= "free" then
        if self.showFreeSpinBoard then 
            itemList = itemList[1]
        elseif type == "enter" then
        else
            itemList = itemList[#itemList]
        end
    end
	if itemList and (#itemList > 0) then
        local index = 0
		for col, list in ipairs(self.gameConfig.dataAdapt) do
            local cellUp = self.mainView.spinLayer.spins[col]:getRetCell(0)
            local cellDown = self.mainView.spinLayer.spins[col]:getRetCell(list + 1)
            if cellUp then
                self.mainView:updateCellSprite(cellUp, math.random(2,9), col, true, true)
            end
            if cellDown then
                self.mainView:updateCellSprite(cellDown, math.random(2,9), col, true, true)
            end
            for row = 1, list do
                index = index + 1
                local cell = self.mainView.spinLayer.spins[col]:getRetCell(row)
                if type and type == "free" or type == "enter" then
                    self.mainView:updateCellSprite(cell, itemList[col][row], col, true, true)
                else
                    self.mainView:updateCellSprite(cell, itemList[index], col, true, true)
                end
            end
		end
	end
	self.old_item_list = nil
end

function cls:adjustTheme(data)
    -- local SpinBoardType = self.gameConfig.SpinBoardType
    -- if data.bonus_game then
	-- 	if data.bonus_game.choice == 0 and data.first_free_game then
    -- --         if  data.first_free_game then
    -- --             self:recoverBoardItem(data.first_free_game.item_list, "free")
    --             self:changeSpinBoard(self.gameConfig.SpinBoardType.Normal)
    -- --         end  
    --     elseif not self.respinCtl then
    --         -- self:recoverBoardItem(nil, "enter")
	-- 	end
	-- elseif data.free_game then
    -- --     self.wildType = data["free_game"]["twins_symbol"]
    -- else
	-- 	-- self:changeSpinBoard(1)
        self:changeSpinBoard(self.gameConfig.SpinBoardType.Normal)
    --     self:recoverBoardItem(data.welcome_item_list,"enter")
	-- end


	self.isOverInitGame = true
    self.loadFinish = true
    if not self:noFeatureResume(data) then
        self:enableMapInfoBtn(false)
    else 
        self.mainView:addFirstBoardItem()
        self:enableMapInfoBtn(true)
        self:playWelcomeDialog()
    end
    if self.fg_level then
        if self:noFeatureResume(data) then
            self:setCurCollectLevel(self.fg_level)
        end
    end
end

function cls:noFeatureResume( data )
	local no_feature_resume = true
	if data and (data["bonus_game"] or data["free_random_pick"] or data["free_game"] or data["first_free_game"]) then 
		no_feature_resume = false 
	end
	return no_feature_resume

end

function cls:playWelcomeDialog() 
	self.mainView:playWelcomeDialog()
    self:playMusicByName("base_welcome")
   
end

function cls:changeSpinBoard( pType )
   	self.initBoardIndex = 1
	if pType == self.gameConfig.SpinBoardType.Normal then
		-- self:updateLogoState(true)
		self.showBaseSpinBoard = true
		self.showFreeSpinBoard = false
		self.showReSpinBoard = false
		self.mainView:changeSpinBoard(pType)
		-- self:lockTopBar()
	elseif pType == self.gameConfig.SpinBoardType.FreeSpin then
		-- self:updateLogoState()
		self.showFreeSpinBoard = true
		self.showBaseSpinBoard = false
		self.showReSpinBoard = false
        self.footer:changeFreeSpinLayout()
		self.mainView:changeSpinBoard(pType)

	elseif pType == self.gameConfig.SpinBoardType.Respin then
		if self.showReSpinBoard then return end
        self.showReSpinBoard = true
        self.lockedReels = {}
		self.mainView:changeSpinBoard(pType)
	end
end

function cls:drawLinesThemeAnimate( lines, layer, rets, specials)
	local timeList = {3, 3}
	self.mainView:drawLinesThemeAnimate(lines, layer, rets, specials,timeList)
end

function cls:stopDrawAnimate( ... )
    self:cleanReelStopMusic()
    self.mainView:stopDrawAnimate()
end
-- ---------------- bonus conection start------------------
function cls:playBonusAnimate( theGameData )
    local delay = 3
    -- self:stopDrawAnimate()
    -- if theGameData and theGameData["wheel_bonus"] then
        -- self:playMusicByName("trigger_bell")
        if not theGameData.respin_info then
            -- self:playScatterAnimate(self.specials, true)
            delay = 0
        else
            self:playMusicByName("bonus_bell")
            self:playRespinAnimate()
        end
    -- else 
    --     delay = 0
    -- end
    return delay
end

function cls:getRespinFlyNode()
    return self.mainView.flyNode
end

function cls:getRespinCollectMultiNode()
    return self.mainView.collect_muti_node
end

function cls:playRespinAnimate()
    self.mainView:playRespinAnimate(self.item_list)
end


function cls:continueNextBouns(data)
    if self.bonus then
        self.bonus:submitLastBonusData(data)
    end
end
---------------- free conection start  ------------------
function cls:getFreeStatus()
    return self.showFreeSpinBoard
end

function cls:getFgTwinSymbol()
    if self.wildType then
        if self.wildType == 1 then
            return 13
        elseif self.wildType == 2 then
            return 12
        end
    end
    return false
end

function cls:getMajorSymbol()
    local len = #self.majorSymbolList
    return self.majorSymbolList[math.random(1, len)]
end

function cls:getSuperFreeStatus()
    if self.freeCtl then 
        return self.freeCtl:getSuperFgStatus()
    else 
        return false 
    end
    -- if self.showFreeSpinBoard then
    --     if self.fg_type then
    --         return self.fg_type == 2 and true or false
    --     end
    --     return false
    -- end
    -- return false
end

function cls:enterFreeSpin( isResume )
    if self.isFreeGameRecoverState == true then  -- self.isFreeGameRecoverState theme中
        self.isFreeGameRecoverState = false
        if isResume then  -- 断线重连的逻辑
            self:changeSpinBoard(self.gameConfig.SpinBoardType.FreeSpin)
            if self:getSuperFreeStatus() then
                self:dealMusic_PlayMapFreeLoopMusic()
            else
                self:dealMusic_PlayFreeSpinLoopMusic()-- 切换背景音乐
            end
            self.mainView:updateSuperFgLowSymbol(nil, true)
            -- self.freeCtl.freeView:recoverFreeState()
        end
    end
    self.mainView:showAllItem()
    self.playNormalLoopMusic = false --commonMusic: freespin背景音乐
end

function cls:showFreeSpinNode( count, sumCount, first )
    parentClass.showFreeSpinNode(self, count, sumCount, first)
    self:changeSpinBoard(self.gameConfig.SpinBoardType.FreeSpin)
    self:resetPointBet()
    -- if self.fg_type and self.fg_type == 2 then
        -- self:resetPointBet()
    -- end
end

function cls:setCurCollectLevel(level, enterFree)
    self.collectViewCtl:setCurCollectLevel(level, enterFree)
end

function cls:hideFreeSpinNode( ... )
    if self:getSuperFreeStatus() then 
        self:setCurCollectLevel(0)
    else
        self:setCurCollectLevel(self.fg_level)
    end
    -- self.fgAvgBet = nil
    -- self.mainView:recoverCoverFrameParent()
    if self.showReSpinBoard then
        self:changeSpinBoard(self.gameConfig.SpinBoardType.Respin)
        -- self:changeSpinBoard(3)
    else 
        self:changeSpinBoard(self.gameConfig.SpinBoardType.Normal)
        -- self:changeSpinBoard(1)
    end
    self:removePointBet()
    self:setDealFreeCollectState()
    if self.freeCtl then
        self.freeCtl:hideFreeSpinNode()
    end
    self.wildType = nil
    parentClass.hideFreeSpinNode(self, ...)
end

function cls:setDealFreeCollectState()
    self.ctl.spin_processing = true
    self.ctl.isProcessing = true
end

function cls:resetPointBet( ... )
    self.freeCtl:resetPointBet()
    -- if self.fgAvgBet and self.fg_type == 2 then
	-- 	self:setPointBet(self.fgAvgBet)
	-- end
end

function cls:playStartFreeSpinDialog( theData )
    if self.freeCtl then 
        self.freeCtl:playStartFreeSpinDialog(theData)
    end
end


function cls:playMoreFreeSpinDialog( theData )
    if self.freeCtl then 
        self.freeCtl:playMoreFreeSpinDialog(theData)
    end
end

function cls:playCollectFreeSpinDialog( theData )
    if self.freeCtl then 
        self.freeCtl:playCollectFreeSpinDialog(theData)
    end
end

function cls:playBackBaseGameSpecialAnimation(theSpecials, enterType) -- 71free  完成free 恢复中奖
    -- self:playFreeSpinItemAnimation(theSpecials, enterType)
end

function cls:playFreeSpinItemAnimation( theSpecials ,enterType )
    if (not theSpecials) then
        return 0
    end
    self:stopDrawAnimate()
    local delay = 0
    if enterType ~= 'free_spin' then
        delay = 3
        self:playMusicByName("trigger_bell")
        self:playScatterAnimate(theSpecials)
    end
    return delay
end

function cls:playScatterAnimate(theSpecials, notLoop)
    self.mainView:playScatterAnimate(theSpecials, notLoop)
end

function cls:setFooterStyle(footer_type, from_free)
    if footer_type == 0 then
        self.footer:isShowTotalBetLayout(false, true)-- 隐藏掉  footer bet
    elseif footer_type == 1 then
        if from_free then
            if from_free == 2 then
                self.footer:changeNormalLayout2(true, true)
            elseif from_free == 1 then
                self.footer:changeFreeSpinLayout()
            end
        else
            self:removePointBet()
            self.footer:changeNormalLayout2()
        end
    elseif footer_type == 2 then
        self.footer:changeFreeSpinLayout3()
    elseif footer_type == 3 then
        self.footer:changeFreeSpinLayout()
    end
end

function cls:getGameConfig()
	return self.gameConfig
end

function cls:dealMusic_PlayMapFreeLoopMusic()
    local mvC = self.musicVolumeConfig
    AudioControl:stopGroupAudio("music")
    self:playLoopMusic(self.audio_list.superFree_background)
    AudioControl:volumeGroupAudio(mvC.max_volume)
end

-- 播放free games的背景音乐
function cls:dealMusic_PlayFreeSpinLoopMusic() -- 播放背景音乐
    local mvC = self.musicVolumeConfig
    AudioControl:stopGroupAudio("music")
    if self.freeCtl then
        self.audioCtl:dealMusic_PlayGameLoopMusic(self.audio_list.free_background)
    end
    AudioControl:volumeGroupAudio(mvC.max_volume)
end

function cls:dealMusic_PlayNormalLoopMusic( ... )
    local mvC = self.musicVolumeConfig
	AudioControl:stopGroupAudio("music")
	self:playLoopMusic(self.audio_list.base_background)
	AudioControl:volumeGroupAudio(mvC.max_volume)
end

function cls:dealMusic_PlayRespinLoopMusic(stype)
    local mvC = self.musicVolumeConfig
	AudioControl:stopGroupAudio("music")
    if stype == 1 then
	    self:playLoopMusic(self.audio_list.respin_background1)
    elseif stype == 2 then
        self:playLoopMusic(self.audio_list.respin_background2)
    end
	AudioControl:volumeGroupAudio(mvC.max_volume)
end

-- function cls:dealMusic_StopNormalLoopMusic()
--     AudioControl:stopGroupAudio("music")
--     AudioControl:volumeGroupAudio(0)
-- end
--------------- bigwin start stop ---------------
-- function cls:stopRollUpFunction(mul)
--     parentClass.stopRollUpFunction(self, mul)
-- end

function cls:playRollupSound(mul)
    if mul >= 5 then 
        self:playFadeToMinVlomeMusic()
   end
   parentClass.playRollupSound(self, mul)
end


function cls:addBigwinFlower()
    -- local spineFile = self:getSpineFile("encourage_bigwin")
    -- self:playMusicByName("base_bigwin_qinzhu")
    -- local _, spine = self:addSpineAnimation(self.mainView.themeAnimateKuang, 2, spineFile, cc.p(640,360),"animation",nil,nil,nil,true,true)
    -- local a1 = cc.DelayTime:create(2)
    -- local a2 = cc.FadeTo:create(0.3, 0)
    -- local a3 = cc.RemoveSelf:create()
    -- local a4 = cc.Sequence:create(a1,a2,a3)
    -- spine:runAction(a4)
end

function cls:getBigWinStatus(baseWin)
    baseWin = baseWin or 0
    local mul = baseWin / self:getCurTotalBet()
    if mul >= 10 then 
        return true
    end
    return false
end

-- function cls:addScreenShaker()
--     local function shakeEnd()
--         self.shaker = nil
--         self:stopMusicByName("trigger_bell")
--     end
--     local time = 2
--     -- self:playMusicByName("trigger_bell")
--     self.shaker = ScreenShaker.new(self.mainView.mainThemeScene,time,shakeEnd)
-- 	self.shaker:run()
-- end

function cls:stopScreenShaker()
    if self.shaker then
        self.shaker:stop()
        self.shaker = nil
    end
end

function cls:getMainView( ... )
    return self.mainView
end

function cls:showThemeDialog(theData, sType, csbName, dialogType)
    self:playFadeToMinVlomeMusic()
    local end_event = theData.click_event
    local theDialog = nil
    local fs_show_type = self.gameConfig.fs_show_type
    theData.click_event = function()
        self:playFadeToMaxVlomeMusic()
        if end_event then
            end_event()
        end
        if sType == fs_show_type.start or sType == fs_show_type.collect then
            self:playMusicByName("common_click")
            -- 获取按钮
            if theDialog and theDialog.startRoot and theDialog.startRoot.btnStart then 
                theDialog.startRoot.btnStart:removeAllChildren()
            end
            -- 获取按钮
            if theDialog and theDialog.collectRoot and theDialog.collectRoot.btnCollect then 
                theDialog.collectRoot.btnCollect:removeAllChildren()
            end
        end
    end
    local config = {}
    config["csb_file"] = self:getCsbPath(csbName)
    config["frame_config"] = {
        ["start"]   = { nil, 1, nil, 2 },
        ["more"]    = {{0, 70}, 3,  {80, 105},1,0,0,1},
        ["collect"] = { nil, 1, nil, 2 },
    }
    config.dialog_config = themeConfig.dialog_config[dialogType]
    theDialog = ThemeBaseDialog.new(self.ctl, config, themeConfig.dialog_config["black_common"])

    if sType == fs_show_type.start then
        theDialog:showStart(theData)
    elseif sType == fs_show_type.more then
        theDialog:showMore(theData)
    elseif sType == fs_show_type.collect then
        theDialog:showCollect(theData)
    end
    return theDialog
end

function cls:updatedFreeSpinCount(remainingCount,totalCount)
    self.freeSpinRemaining = remainingCount
    parentClass.updatedFreeSpinCount(self, remainingCount, totalCount)
end

-- function cls:clearChooseBouns ( data )
-- end

function cls:configAudioList()
    parentClass.configAudioList(self)
    for music_key, music_path in pairs(self.gameConfig.audioList) do
        self.audio_list[music_key] = music_path
    end
end

function cls:getLoadMusicList()
    local loadMuscList = {}
    table.insert(loadMuscList, self.audio_list.base_welcome)
    for music_key, music_path in pairs(self.audio_list) do
        table.insert(loadMuscList, music_path)
    end
    return loadMuscList
end

function cls:onExit()
    -- self:stopScreenShaker()
    -- self:stopScreenShakerI()
    parentClass.onExit(self)
end

function cls:getJPLabelMaxWidth(index)
	return self.gameConfig.jackpotViewConfig.width[index]
end

-- function cls:dealMusic_playRespinLoopMusic()
-- 	-- 播放背景音乐
-- 	AudioControl:stopGroupAudio("music")
-- 	self:playLoopMusic(self.audio_list.respin_background)
-- 	AudioControl:volumeGroupAudio(1)
-- end

function cls:enableAllFooterBtns( flag )
	self.ctl.footer:setSpinButtonState(flag) -- 开启 footer按钮
    self.ctl.footer:enableOtherBtns(not flag)
end

return cls
