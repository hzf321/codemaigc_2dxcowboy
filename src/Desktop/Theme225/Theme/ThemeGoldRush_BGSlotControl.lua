

ThemeGoldRush_BGSlotControl = class("ThemeGoldRush_BGSlotControl")
local cls = ThemeGoldRush_BGSlotControl

require (bole.getDesktopFilePath("Theme/ThemeGoldRush_BGSlotView")) 

function cls:ctor(bonusParent, bonusControl, themeCtl, data, tryResume) -- bonusControl, themeCtl, csbPath, data, callback

	self.bonusParent 	= bonusParent
	self.bonusControl 	= bonusControl
	self.themeCtl 		= themeCtl
	self.data          	= data
	self.isTryResume 	= tryResume

	self.jackpotVCtl = self.themeCtl:getJpViewCtl()
	self.audioCtl = self.themeCtl:getAudioCtl()
	self.gameConfig = self:getGameConfig()
	self.slot_config = self.gameConfig.classic_config

	self.node = cc.Node:create()
    self:curSceneAddToContent(self.node)
	self:initData()

	self:initGameLayout()
end

function cls:initData()
	self.slotSaveData = self.data.slot_save_data or {}

    self.winItemList 	    = self.themeCtl:getRetMatrix() or tool.tableClone(self.data.core_data.item_list)
    self.miniSlotInfoList   = tool.tableClone(self.data.core_data.slots_info)
    self.jpWinData 			= tool.tableClone(self.data.core_data.win_jp_temp)
    self.curBonusBet 		= self.themeCtl:getCurBet()

    self.miniSlotMap        = tool.tableClone(self.data.core_data.ls_map)
    -- for _, slot_info in pairs(self.miniSlotInfoList) do 
    --     slot_info.slots_type = slot_info.slots_type - self.slot_config.start_idx
    -- end

    self.progressiveData = tool.tableClone(self.data.core_data.progressive_list)

    self:initWinData()
    self:initSlotDataResume()
end

function cls:getNextJackpotWinValue( )
	local item
	if self.jpWinData and self.jpWinData[1] and self.jpWinData[1].jp_win then 
		item = table.remove(self.jpWinData,1)
	end
	return item
end

function cls:initWinData( ... )
	self.respinWin = self.themeCtl.totalWin-- 加钱操作
    -- self.themeCtl.totalWin = 0 
    self.onlyBonusWin = 0

    for _, slotInfo in pairs(self.miniSlotInfoList) do 
    	if slotInfo and slotInfo.slots_win then 
    		self.onlyBonusWin = self.onlyBonusWin + slotInfo.slots_win
    	end
    end

    if self.jpWinData and #self.jpWinData > 0 then 
    	for _, _jpData in pairs(self.jpWinData) do 
    		if _jpData and _jpData.jp_win then 
    			self.onlyBonusWin = self.onlyBonusWin + _jpData.jp_win
    		end
    	end
    end
end

function cls:initSlotDataResume( ... )
    self.themeCtl.rets.theme_respin = tool.tableClone(self.miniSlotInfoList)
    self.respinOverCnt = self.slotSaveData["respin_over_cnt"] or 0
    local win_info_list = nil
    if self.respinOverCnt and self.respinOverCnt > 0 then
        for i = 1, self.respinOverCnt do
            if #self.themeCtl.rets.theme_respin <= 0 then
                break
            end
            if self.slotSaveData.show_coin and i == self.respinOverCnt then
                break
            end
            win_info_list = table.remove(self.themeCtl.rets.theme_respin, 1)
            self.respinWin = self.respinWin + win_info_list.slots_win
            if win_info_list.is_jackpot then
            	local _jpWinData = self:getNextJackpotWinValue()
                self.respinWin = self.respinWin + _jpWinData.jp_win
            end
        end
    end

    local cnt = 0
    local curIndex = 0
    self.totalSpinSum = table.nums(self.miniSlotInfoList)

    for k, v in pairs(self.miniSlotMap) do
        cnt = cnt + v
        if v > 0 and cnt >= self.respinOverCnt then
            curIndex = self.respinOverCnt - (cnt - v)
            if curIndex == v and #self.themeCtl.rets.theme_respin > 0 then
                -- 如果还有下一组数据 就显示下一组
                if self.slotSaveData.show_coin then
                    local curWinInfo = self.themeCtl.rets.theme_respin[1]
                    self.respinTimes = curIndex or 0
                    self.curSlotIndex = curWinInfo["slots_type"]
                    self.respinSum = curIndex or 0
                else
                    local nextWinInfo = self.themeCtl.rets.theme_respin[1]
                    self.respinTimes = 0
                    self.curSlotIndex = nextWinInfo["slots_type"]
                    self.respinSum = self.miniSlotMap[nextWinInfo["slots_type"]] or 0
                end
            else
                -- 没有下一组 或者每超出 正常显示
                self.respinTimes = curIndex
                self.respinSum = v or 0
                self.curSlotIndex = k
            end
            break
        end
    end

    -- self.themeCtl.reelStopMusicTagList = self.themeCtl.reelStopMusicTagList or {}    -- 音效播放标志位
    self.themeCtl.cacheSpinRet = self.themeCtl.cacheSpinRet or self.themeCtl.rets-- spin 结果数据和 显示stop 按钮有关
end

function cls:getPayValueByIndex( index )
	local value = ""
	if index and self.slot_config.pay_list[index] and self.curBonusBet then 
		value = self.slot_config.pay_list[index] * self.curBonusBet
	end
	return value
end

function cls:getMiniSlotMapData( ... )
	return self.miniSlotMap
end

function cls:getSlotIndex( ... )
	return self.curSlotIndex
end

function cls:getRespinTime( ... )
    return self.respinTimes
end

function cls:initGameLayout( )
	local nodesList = self.themeCtl:getSpecialFeatureRoot("mini_slot")
	self._view = ThemeGoldRush_BGSlotView.new(self, nodesList)
end

function cls:addData(key, value)
	self.slotSaveData = self.slotSaveData or {}
	self.slotSaveData[key] = value

	self.bonusParent:addData("slot_save_data", self.slotSaveData)
end

function cls:saveBonus()
	self.bonusParent:addData("slot_save_data", self.slotSaveData)
end

function cls:enterBonusGame(tryResume)
    self.themeCtl:saveBonusData(self.themeCtl.rets)
    self.themeCtl:changeRespinLayerState(true)
	self.jackpotVCtl:changeJackpotLabelsState(true, self.progressiveData)

    self:initWinItemList()
	-- 
    local function playIntro()
        -- 第一次进入
        self:addData("respin_over_cnt", 0) --	第一次进入初始化为0
        local delay = self._view:playWinBonusAnim(self.miniSlotMap, self.themeCtl:getMiniSlotPos())

		self.node:runAction(
			cc.Sequence:create(
				cc.DelayTime:create(delay),
				cc.CallFunc:create(function ( ... )
                    self:playMusicByName("fortune_pot_jackpot")
					self.themeCtl:playBonusItemAnim()
				end),
				cc.DelayTime:create(2.5),
				cc.CallFunc:create(function(...)
					self._view:playSlotCntAnim(nil, "hide")
				end),
				cc.DelayTime:create(0.5),
				cc.CallFunc:create(function(...)
					self:showStartDialog()
				end)
			)
		)
    end

    local function snapIntro()
        local function startSpin()

            self:initShowNode(true)

			self.node:runAction(cc.Sequence:create(
				cc.DelayTime:create(1), 
				cc.CallFunc:create(function(...)
					if self.slotSaveData.show_coin and #self.themeCtl.rets.theme_respin > 0 then
						local slot_info = table.remove(self.themeCtl.rets.theme_respin, 1)
						local nextFunc = function(...)
							self:checkPlayRespin()
						end

						self:showWinCoins(slot_info, nextFunc)
					else
						self:checkPlayRespin(tryResume)
					end
			    end)))
        end
        self.callback = function(...)
            self.ctl.isProcessing = true
  			self.themeCtl:setFooterBtnsEnable(false)
            self.oldCallBack()
            self.ctl.isProcessing = false
        end
        startSpin()
    end

    if self.slotSaveData.click_start then
        snapIntro()
    else
        playIntro()
    end
end

function cls:initWinItemList( )
    if self.winItemList then 
        self.themeCtl:resetBoardCellsByItemList(self.winItemList)
    end
end

function cls:checkPlayRespin(tryResume)
	if #self.themeCtl.rets.theme_respin >0 then 
		self.themeCtl:handleResult()
	else -- 是否有小游戏的相关逻辑在 主题里面自行判断
		self.themeCtl.respinStep = self.gameConfig.ReSpinStep.Over
		
        self:onRespinFinish(tryResume)
        -- self.themeCtl.rets.theme_deal_show = true
        -- self.themeCtl:handleResult()
		
	end
end

function cls:initShowNode(isResume)

    self.themeCtl:changeSpinBoard("Bonus")

    -- self.themeCtl:dealMusic_EnterBonusGame()

	-- self.themeCtl.footer:changeFreeSpinLayout()
	-- self.themeCtl.footer:setFreeSpinLabel(self.respinSum - self.respinTimes, self.respinSum)

    self.themeCtl:setFooterWinCoins(self.respinWin, 0, 0)

    self._view:showCurMiniSlot()
    self:updateCurMiniReel()

    self._view:showSlotNodeByAnim()
    
    if isResume then
        local item_list
        if self.data.core_data and self.data.core_data.slots_info and self.data.core_data.slots_info[self.respinOverCnt] and self.data.core_data.slots_info[self.respinOverCnt].item_list then
            item_list = self.data.core_data.slots_info[self.respinOverCnt].item_list
        end
        self:updateCurMiniReel(item_list)
    end
end

function cls:updateCurMiniReel(item_list)
    local item_list = item_list or {}
    local randomList = self.slot_config.random_reel
    local randomLen = table.nums(randomList)
    if #item_list == 0 then
        for i = 1, 3 do
            item_list[i] = { randomList[math.random(1, randomLen)], randomList[math.random(1, randomLen)], randomList[math.random(1, randomLen)] }
        end
    end

    self.themeCtl:resetBoardCellsByItemList(item_list)
end

function cls:changeSpinLayerNotHide(slot_index)
	local slot_index = slot_index or self.curSlotIndex
	self.themeCtl:changeSpinLayerNotHide(slot_index)
end


function cls:freshRespinNum(cur, sum)
    -- self.ctl.footer:setFreeSpinLabel(sum - cur, sum)
    -- self.ctl.footer:changeFreeSpinLayout()
    self._view:freshRespinNum(cur, sum)
end

function cls:saveRespinCnt(...)
    self.respinOverCnt = self.respinOverCnt + 1
    if self.respinOverCnt > self.totalSpinSum then
        self.respinOverCnt = self.totalSpinSum
    end
    self.slotSaveData.show_coin = true
    self.slotSaveData.respin_over_cnt = self.respinOverCnt
    self:saveBonus()
end

function cls:onRespinStart()
    self._view:playRespinStartAnim()

	self.themeCtl.respinStep = self.gameConfig.ReSpinStep.Playing  -- 用来更改 不在 Start 状态
    self.respinTimes = self.respinTimes + 1
    self:freshRespinNum(self.respinTimes, self.respinSum) -- 更新计数
end

function cls:onRespinFinish(tryResume)
    if self.themeCtl.respinStep == self.gameConfig.ReSpinStep.Over then
        self.themeCtl:setFooterBtnsEnable(false) -- 禁用 spin 按钮
        self.themeCtl:changeRespinLayerState(false)

        self._view:playSlotCntAnim(self.curSlotIndex, "hide" )
        -- 播放结束 respin 音效
        
        self.themeCtl:laterCallBack(1, function()
            -- self._view:playSlotCntAnim(nil, "hide")
            self:showCollectBonusDialog(tryResume) -- 显示collect弹窗
        end)
    end
end

function cls:showStartDialog()	
    self.themeCtl:stopAllLoopMusic()

	local closeDelay = 30/30
	local autoClickDelay = 4
	local pos = cc.p(0, 0)

	local t_end_event = function ( ... )
		self.themeCtl:handleResult()
	end

	local t_changeLayer_event = function ( ... )
		self:initShowNode()
	end

	local data = {}
	data.click_event = function ( ... )

        self:addData("click_start", true)

		self.themeCtl:playMusicByName("common_click")
		-- self.themeCtl:playMusicByName("pop_out")

		self.node:runAction(
			cc.Sequence:create(
				cc.DelayTime:create(closeDelay),
				cc.CallFunc:create(function ( ... )
					self.themeCtl:playTransition(t_end_event, "bonus", t_changeLayer_event)-- 转场动画
				end)
				))
	end
	local dialog = self.themeCtl:showThemeDialog(data, 1, "classic", self.themeDownChild)
	dialog:setPosition(pos)

    self:playMusicByName("bonus_start_show")
	-- dialog:runAction(
	-- 	cc.Sequence:create(
	-- 		cc.DelayTime:create(autoClickDelay),
	-- 		cc.CallFunc:create(function()
	-- 			if dialog then
	-- 				dialog:clickStartBtn()
	-- 			end
	-- 		end)
	--     )
	-- )
end

function cls:showCollectBonusDialog()
	self.themeCtl:stopAllLoopMusic()
    
	local closeDelay = 30/30
	local autoClickDelay = 4
	local pos = cc.p(0, 0)

	local data = {}
	data.coins = self.onlyBonusWin
	data.click_event = function ( ... )

		self.themeCtl:playMusicByName("common_click")
		-- self.themeCtl:playMusicByName("pop_out")

		self.node:runAction(
			cc.Sequence:create(
				cc.DelayTime:create(closeDelay),
				cc.CallFunc:create(function ( ... )
					self:collectOverFunc()
				end)
				))
	end
	local dialog = self.themeCtl:showThemeDialog(data, 3, "classic", self.themeDownChild)
	dialog:setPosition(pos)

    self:playMusicByName("bonus_end_show")
end

function cls:respinOver()
    self._view:recoverSlotAndBoard() -- recoverSlotAnim
    self.themeCtl:changeSpinBoard("Normal")

    self.themeCtl:hideBonusNode()
    self.themeCtl:outBonusStage() -- 恢复牌面 和 中奖两线
    -- 解锁jackpot meter
    self.jackpotVCtl:changeJackpotLabelsState(false)
    self.themeCtl:onRespinOver()-- 激活spin按钮
    self.themeCtl:setFooterWinCoins(self.themeCtl.totalWin, 0, 0) -- 返回base 直接加上

    self.themeCtl.isRespin = false -- 设置 变量 控制在返回base 庆祝赢钱的时候 stop 按钮 仅可以用来做暂停rollup 使用
    self.themeCtl.rets["theme_respin"] = nil

    local rolloverFunc = function()
        self.respinWin = 0
        self.onlyBonusWin = 0
        self.bonusParent:clearBonusData()
    end

    self.node:runAction(cc.Sequence:create(
            cc.DelayTime:create(0.5),
            cc.CallFunc:create(function(...)
            	self.themeCtl:dealMusic_PlayNormalLoopMusic()
                -- self.themeCtl.totalWin = self.respinWin - self.onlyBonusWin
                self.themeCtl:startRollup(self.onlyBonusWin, rolloverFunc)
            end)
    ))
end

function cls:collectOverFunc()

    self.themeCtl:stopDrawAnimate()

    local t_changeLayer_event = function ( ... )
    	self:respinOver()
    end
    self.themeCtl:playTransition(nil, "bonus", t_changeLayer_event)-- 转场动画
end

function cls:showWinCoins(slot_info, nextFunc)
    -- 自主庆祝赢钱
    local curWin = 0
    local laterFunc = function(...)
        self.themeCtl:dealMusic_FadeLoopMusic(0.3, 0, 1)
        self:addData("show_coin", false)
        self:checkNextSpin(nextFunc)
    end

    if slot_info.is_jackpot then 
        self:playWinJp(slot_info, laterFunc)

    elseif slot_info.slots_win and slot_info.slots_win > 0 then
        self:playWinLine(slot_info, laterFunc)

    else
        self:addData("show_coin", false)
        self.themeCtl:laterCallBack(1, function ( ... )
            self:checkNextSpin(nextFunc)
        end)
    end
end

function cls:playWinJp(slot_info, laterFunc)
    
    self:playMusicByName("jp_active")

    local delay = self._view:playSlotJpItemAnim(slot_info)
    local tempJpWinData = self:getNextJackpotWinValue()

    local checkFunc = function ( winNum )

        slot_info.slots_win = (slot_info.slots_win or 0) + (tempJpWinData.jp_win or 0)
        if slot_info.slots_win > 0 then
            local jpWinType = tempJpWinData.jp_win_type
            self.jackpotVCtl:playWinJpAnim(jpWinType)
            self:playWinLine(slot_info, laterFunc)
        else
            laterFunc()
        end
    end

    self.node:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(delay),
            cc.CallFunc:create(function()
                self:playCollectWinJackpot(tempJpWinData, checkFunc) -- 显示 jackpot 赢钱弹窗
            end
            )
        )
    )
end

function cls:playCollectWinJackpot( tempJpWinData, endFunc )
	self.jackpotVCtl:showWinJackpotDialog(tempJpWinData, endFunc)
end

function cls:playWinLine( slot_info, laterFunc )
    self._view:playSlotItemAnim(slot_info)

    self:setBonusWinCoins( slot_info.slots_win, laterFunc )
end

function cls:setBonusWinCoins( winNum, laterFunc, isJp )

    if winNum then 
        self.themeCtl:dealMusic_FadeLoopMusic(0.3, 1, 0)

        if isJp then
            self.themeCtl:setFooterWinCoins( 0 , self.respinWin, 0.5 )
        else
            self.themeCtl:setFooterWinCoinsEffect(winNum, self.respinWin, self.curBonusBet, laterFunc)
        end
        self.respinWin = (self.respinWin or 0) + winNum
    end
end

function cls:checkNextSpin(nextFunc)
    if self.themeCtl.rets.theme_respin and self.themeCtl.rets.theme_respin[1] and self.themeCtl.rets.theme_respin[1].slots_type ~= self.curSlotIndex then
        -- 更改 棋盘动画
        self.themeCtl:stopDrawAnimate()

        local _curSlotIndex = self.curSlotIndex
        local nextIndex = self.themeCtl.rets.theme_respin[1].slots_type

		-- 更新 记录数据
		self.respinTimes = 0
		self.curSlotIndex = nextIndex
		self.respinSum = self.miniSlotMap[nextIndex] or 0

        self._view:playChangeSlotAnim(_curSlotIndex, nextIndex, nextFunc)

    else
        nextFunc()
    end
end

function cls:stopLineAnimate( ... )
	self._view:stopLineAnimate()
end

function cls:onExit( )
    if bole.isValidNode(self.node) then 
        self.node:removeFromParent()
    end
end

----------------------------------------------------------------------------------------------------------------------------------
function cls:playJPArriveAnim( jpType )
	self.jackpotVCtl:playJPArriveAnim(jpType)
end
----------------------------------------------------------------------------------------------------------------------------------
function cls:getCsbPath(file_name)
    return self.themeCtl:getCsbPath(file_name)
end

function cls:getGameConfig( )
	return self.themeCtl:getGameConfig()
end

function cls:changeRespinLayerState(state)
	self.themeCtl:changeRespinLayerState(state)
end

function cls:playMusicByName(name, singleton, loop)
	self.themeCtl:playMusicByName(name, singleton, loop)
end

function cls:getCellPos(col, row)
	return self.themeCtl:getCellPos(col, row)
end

function cls:getPic(name)
	return self.themeCtl:getPic(name)
end

function cls:getSpineFile(file_name, notPathSpine)
    return self.themeCtl:getSpineFile(file_name, notPathSpine)
end

function cls:curSceneAddToContent( node )
    self.themeCtl:curSceneAddToContent(node)
end


