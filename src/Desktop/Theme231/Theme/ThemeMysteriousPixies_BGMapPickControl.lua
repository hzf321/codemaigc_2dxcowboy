


local ThemeMysteriousPixies_BGMapPickControl = class("ThemeMysteriousPixies_BGMapPickControl")
local cls = ThemeMysteriousPixies_BGMapPickControl

local bgPickNumCtl =  require  (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_BGPickNumControl"))   
local bgPickView =  require  (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_BGMapPickView")) 

function cls:ctor(bonusParent, data, tryResume)

	self.bonusParent 	= bonusParent
	self.bonusControl 	= bonusParent.bonusControl
	self.themeCtl 		= bonusParent.themeCtl
	self.data          	= data
	self.isTryResume 	= tryResume

	self.jackpotVCtl = self.themeCtl:getJpViewCtl()
	self.collectVCtl = self.themeCtl:getCollectViewCtl()
	

	self.gameConfig = self:getGameConfig()
	self.config = self.gameConfig.pick_config

	self.node = cc.Node:create()
    self:curSceneAddToContent(self.node)
	self:initData()

	self:initGameLayout()
end

function cls:initGameLayout( )
	local nodesList = self.themeCtl:getSpecialFeatureRoot("bet_bonus")
	self._view = bgPickView.new(self, nodesList)

	self._view:initPickItems(self.stateList)

	self:setPickLeft(self.haveLeft, true)
end

function cls:initData()
	self.curBonusData 	= self.data.core_data.map_pick
    
    self.jpWinData 		= tool.tableClone(self.curBonusData.jp_win_temp)
    self.posList 		= self.curBonusData.pos_list -- 上次点击过的位置
    self.moneyList 		= self.curBonusData.money_list or {} -- 上次点击过的位置
    self.pickList 		= self.curBonusData.pick_list -- 当次点击的结果
    self.pickNum 		= self.curBonusData.pick_num -- pick 次数
    self.multiList 		= self.curBonusData.multi_list or {} -- 翻倍数据
    self.pageLevel 		= self.curBonusData.page_level or 1 -- page页信息
    self.curBonusBet 	= self.curBonusData.avg_bet
    self.totalWinList 	= self.curBonusData.total_win_list or {}

    self.progressiveData = tool.tableClone(self.data.core_data.progressive_list)

    self:initWinData()
    self:initDataResume()
end

function cls:getNextJackpotWinValue( )
	local item
	if self.jpWinData and self.jpWinData[1] and self.jpWinData[1].jp_win then 
		item = table.remove(self.jpWinData,1)
	end
	return item
end

function cls:initWinData( ... )
	self.bonusWin = self.themeCtl.totalWin-- 加钱操作
    self.onlyBonusWin = self.curBonusData.total_win or 0

    for _, jpWinData in pairs(self.jpWinData) do 
    	if jpWinData and jpWinData.jp_win then 
    		self.onlyBonusWin = self.onlyBonusWin + (jpWinData.jp_win or 0)
    	end
    end
end

function cls:refrshCollectWin( theNum, isReset )
	if isReset then 
   		self.themeCtl:setFooterWinCoins(self.bonusWin, 0, 0)
   	else
   		self.themeCtl:setFooterWinCoins( theNum or 0 , self.bonusWin, 0.5 )
   	end
   	self.bonusWin = self.bonusWin + theNum
end

function cls:initDataResume( )

	self.curSaveData 		= self.data.pick_save_data or {}
	self.curPickOverList 	= self.curSaveData.pick_over_list or {}
	self.haveLeft 			= self.pickNum - table.nums(self.curPickOverList)

	self:resetStateList(self.posList, self.curPickOverList)

	local curOnlyBonusWin = 0
	for k = 1, table.nums(self.curPickOverList) do 
		if self.totalWinList[k] then 
			curOnlyBonusWin = self.totalWinList[k]
		end
	end
	
	self.bonusWin = self.bonusWin + curOnlyBonusWin
	self:refrshCollectWin(0, true)
end

function cls:resetStateList( posList, pickOverPos )
	pickOverPos = tool.tableClone(pickOverPos) or {}
	local pickOverPosNew = tool.tableClone(pickOverPos)
	local item_state = self.config.item_state

	if not self.stateList then 
		self.stateList = {}

		for i, value in pairs(posList) do 
			local state = value == 0 and item_state.can_open or item_state.old_open
			local value = value or 0

			local itemData = {
				value = value,
				state = state,
				open_type = self:getItemOpenType(value)
			}
			self.stateList[i] = itemData

			local open_type = self:getItemOpenType(value)
			if open_type == "coins" and self.moneyList and self.moneyList[i] and self.moneyList[i]~=0 then
				self.stateList[i]["coins_value"] = self.moneyList[i]
			end

		end
	end

	if table.nums(pickOverPos) > 0 then 
		local count = table.nums(pickOverPos)
		for i = 1, count do 
			local pos = 1
			if table.nums(pickOverPos) > 0 then 
				pos = table.remove(pickOverPos, 1)
			end

			local state = item_state.new_open
			local value = 0

			if table.nums(self.pickList) > 0 then 
				value = table.remove(self.pickList, 1)
				local open_type = self:getItemOpenType(value)

				if open_type == "next" then 
					self:resetStateListByNext(pickOverPos)
					return 
				end
				if open_type == "multi" then 
					self:resetStateListByMulti(i, pickOverPosNew)
				end
				if open_type == "pick_up" then 
					self.haveLeft = self.haveLeft + 1
				end
				if open_type == "pick_down" then 
					self.haveLeft = self.haveLeft - 1
				end
				if open_type == "jp" then -- 删除一组jp数据
					self:getNextJackpotWinValue()
				end
			end

			local itemData = {
				value = value,
				state = state,
				open_type = self:getItemOpenType(value)
			}
			self.stateList[pos] = itemData
		end
	end
end

function cls:resetStateListByNext( pickOverPos )
	self.stateList = nil

	local posList = {
		0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,
	}
	self.moneyList = {
		0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,
	}
	self:resetStateList( posList, pickOverPos )

	self.pageLevel = self.pageLevel + 1
	if self.pageLevel > self.config.page_count then 
		self.pageLevel = self.pageLevel - self.config.page_count
	end
end

function cls:resetStateListByMulti( endIndex, pickOverPosNew )
	if self.stateList and table.nums(self.multiList) > 0 then 
		local curMultiList = table.remove(self.multiList)
		local valueList = curMultiList[1] or {}
		-- local multiWin = curMultiList[2]
		for i, posId in pairs(pickOverPosNew) do 
			if endIndex > i then 
				if table.nums(valueList)>0 and self.stateList[posId].open_type == "coins" then 
					local newValue = table.remove(valueList, 1)
					if newValue then 
						self.stateList[posId].value = newValue
					end
				end
			end
		end
	end
end

function cls:getFeatureBet( ... )
	return self.curBonusBet
end

function cls:addData(key, value)
	self.curSaveData = self.curSaveData or {}
	self.curSaveData[key] = value

	self.bonusParent:addData("pick_save_data", self.curSaveData)
end

function cls:saveBonus(key, data)
	self.bonusParent:addData(key, data)
end

function cls:enterBonusGame(tryResume)
	self.themeCtl:stopDrawAnimate()
	-- self.themeCtl:stopAllLoopMusic()

    self.themeCtl:saveBonusData(self.themeCtl.rets)

    local function playIntro()
        -- 第一次进入
		self:enterPickNumGame()
    end

    local function snapIntro()
        if not self.data.num_save_data or not self.data.num_save_data.over_num_bonus then 
        	self:enterPickNumGame()
        else
        	self:enterMapPickGame()
        end
    end

    if self.bonusParent:isOverSingleBonus("map_pick") then 
    	self:enterBonusByEnd()
    else
		if tryResume then
		    snapIntro()
		else
		    playIntro()
		end
	end
end

function cls:enterBonusByEnd( ... )
	self.themeCtl:setWinCoins_noHandle( self.onlyBonusWin )
	self.themeCtl:addCoinsToHeader()
	self:finshPickGame( true )
end

function cls:enterPickNumGame(tryResume)
	self.pickNumBonus = bgPickNumCtl.new(self, self.data, tryResume)
	self.pickNumBonus:enterBonusGame(tryResume)
end

function cls:isOverNumPickGame()
	self:enterMapPickGame()
end

function cls:enterMapPickGame( ... )
	self.themeCtl:setPointBet(self.curBonusBet)
	self.themeCtl:setFooterShowTotalBetLayout(false)

	self.jackpotVCtl:changeJackpotLabelsState(true, self.progressiveData)

	if not self.curSaveData.over_pick_start then -- 展示 pick_num 开始弹窗
		self:showStartDialog()
	elseif not self.curSaveData.over_pick_show then -- 直接展示pick界面
		self:showPickNode()
	elseif not self.curSaveData.over_pick then -- 打开点击事件
		self:showPickNode(true)
		self:openPickBtnEvent()
	else -- 直接展示pick结果界面
		self:showPickNode(true)
		self.node:runAction(
			cc.Sequence:create(
				cc.DelayTime:create(1),
				cc.CallFunc:create(function ( ... )
					self:showCollectDialog()
				end)
			))
	end
end

function cls:showStartDialog()	
    self.themeCtl:stopAllLoopMusic()

	local closeDelay = 30/30
	local autoClickDelay = 4
	local pos = cc.p(0, 0)

	local data = {}
	data.click_event = function ( ... )

        self:addData("over_pick_start", true)

		self.themeCtl:playMusicByName("common_click")
		-- self.themeCtl:playMusicByName("pop_out")

		self.node:runAction(
			cc.Sequence:create(
				cc.DelayTime:create(closeDelay),
				cc.CallFunc:create(function ( ... )
					self:showPickNode()
				end)
				))
	end
	local dialog = self.themeCtl:showThemeDialog(data, 1, "d_pick")
	dialog:setPosition(pos)

    self:playMusicByName("map_start_show")
end

function cls:showCollectDialog()
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
					self:playRollUpCoins()
				end)
				))
	end
	local dialog = self.themeCtl:showThemeDialog(data, 3, "d_pick")
	dialog:setPosition(pos)

    self:playMusicByName("map_end_show")

    self.collectVCtl:updateMapDataAndShowByEndMapFeature()
    self._view:closePickScreen()
	self:changeJPZorder( 0 )
end

function cls:playRollUpCoins( ... )
	self.jackpotVCtl:changeJackpotLabelsState(false)
	
	local rolloverFunc = function()
	    self:finshPickGame()
	end

	self.node:runAction(cc.Sequence:create(
	        cc.DelayTime:create(0.5),
	        cc.CallFunc:create(function(...)
	            self.themeCtl:startRollup(self.onlyBonusWin, rolloverFunc)
	        end)
	))
end

function cls:finshPickGame( byEnd )

	self.bonusWin = 0
	self.onlyBonusWin = 0

	self.bonusParent:setSingleBonusOver( "map_pick" )
	
	self.themeCtl:removePointBet()
	self.themeCtl:setFooterShowTotalBetLayout(true, true) -- 控制 lounge 提示不展示

	local data = {
		pos_list = tool.tableClone(self.curPickOverList)
	}

	self.themeCtl:dealMusic_ExitBonusGame()
	-- if not byEnd then 
	-- 	self._view:closePickScreen()
	-- 	self:changeJPZorder( 0 )
	-- 	-- self.node:runAction(cc.Sequence:create( -- self.callback()
	-- 	-- 	cc.DelayTime:create(0.3),
	-- 	-- 	cc.CallFunc:create(function ()
	-- 	-- 		self.bonusParent:checkIsOverBonus(data)
	-- 	-- 	end)))
	-- else
		self.bonusParent:checkIsOverBonus(data)
	-- end
end

function cls:showPickNode( tryResume )
	self.themeCtl:dealMusic_EnterBonusGame()
	
	self._view:showPickNode( self.pageLevel, tryResume )
end

function cls:openPickBtnEvent( ... )
    if self.haveLeft > 0 then 
        self:setTouchPickItem(true)
        self._view:changePickGameTipState( true )
    else
    	self._view:changePickGameTipState( )
        self:pickAllItemOver()
    end
end

function cls:getNextNoPickPos( )
	local list = {}
	for id, tempInfo in pairs(self.stateList) do 
		if tempInfo and tempInfo.state and tempInfo.state == 0 then 
			table.insert(list, id)
		end
	end

	local randomCount = math.ceil(table.nums(list)/6)
	local randomList = {}
	
	if randomCount > 0 then 
		for i = 1, randomCount do 
			table.insert(randomList, table.randomPop(list))
		end
	end

	return randomList
end

function cls:onTouchOnItem( posIndex )
	if self:canTouchPickItem(posIndex) then
		self:dealOpenPickItem(posIndex)
	end
end

function cls:getNextPickValue( ... )
	if self.pickList and table.nums(self.pickList) > 0 then 
		return table.remove(self.pickList, 1)
	end
end

function cls:getColAndRowByIndex( index )
	local col = (index - 1) % self.config.item_config.col_count + 1 
	local row = math.ceil(index/self.config.item_config.col_count)

	return col , row
end

function cls:getPickItemPos( index )
	local item_config = self.config.item_config
	local col, row = self:getColAndRowByIndex(index)
	local addPos = cc.p((col - 1)*item_config.c_width, -(row-1)*item_config.c_height)
	local pos = cc.pAdd(item_config.base_pos, addPos)

	return pos
end
   		

function cls:getItemOpenType( value )
	if not value then return end
	for open_type , setList in pairs(self.config.open_state) do 
		if setList[value] then 
			return open_type 
		end
	end
end

function cls:dealOpenPickItem(posIndex)
    if not self.stateList or not self.stateList[posIndex] or self.stateList[posIndex].state ~= 0 then
    	self:setTouchPickItem(true)
        return
    end
    if not self.stateList or not self.stateList[posIndex] or self.stateList[posIndex].state ~= 0 then
    	self:setTouchPickItem(true)
        return
    end

    local value = self:getNextPickValue()
    local open_type = self:getItemOpenType(value)

    if not value or not open_type then 
    	self:setTouchPickItem(true)
    	return
    end

    self:setTouchPickItem(false)

    self:setPickLeft(self:getPickLeft() - 1)
    
    self.stateList[posIndex].value = value
    self.stateList[posIndex].state = self.config.item_state.new_open -- self.stateList[posIndex].value > 0 and "coins" or "jp"
    self.stateList[posIndex].open_type = open_type
    -- self:addData("state_list", self.stateList)

    local delay = self._view:showPickValue(posIndex, self.stateList[posIndex], true) or 1

	self.node:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(delay), -- 延迟展示动画的时间
			cc.CallFunc:create(function()
				self:playPickItemValue( posIndex, self.stateList[posIndex] )
				
			end)
		))
end

function cls:playPickItemValue( posIndex, themeInfo )
	local open_type = themeInfo.open_type
	if open_type == "coins" then
		self:playCollectCoins(posIndex, themeInfo)
	elseif open_type == "jp" then 
		self:playCollectJp(posIndex, themeInfo)
	elseif open_type == "multi" then 
		self:playCollectMulti(posIndex, themeInfo)
	elseif open_type == "pick_up" then
		self:playCollectCount( self:getPickLeft() + 1 ) 
	elseif open_type == "pick_down" then 
		self:playCollectCount( self:getPickLeft() - 1 )
	elseif open_type == "next" then 
		self:playCollectNext(posIndex, self:getPickLeft() - 1)
	end

	table.insert(self.curPickOverList, posIndex)
	self:addData("pick_over_list", self.curPickOverList)
end

function cls:playCollectCoins( posIndex, themeInfo )
	self._view:collectCoinsToFooter( posIndex, themeInfo )
end

function cls:playCollectJp(posIndex, dataInfo)
    
    local tempJpWinData = self:getNextJackpotWinValue()
    local jpWinType = tempJpWinData.jp_win_type
    local jpWinValue = tempJpWinData.jp_win

	local endFunc = function ( winNum )
		self:refrshCollectWin( jpWinValue )

		self.themeCtl:laterCallBack(self.config.footer_roll_delay, function ( ... )
			self:finshPlayOneItem()
		end)
	end

	self.jackpotVCtl:playWinJpAnim(jpWinType)
	self.jackpotVCtl:showWinJackpotDialog(tempJpWinData, endFunc)
end

function cls:playCollectMulti( posIndex, dataInfo )
	local curMultiList
	if table.nums(self.multiList) > 0 then 
		curMultiList = table.remove(self.multiList, 1)
	end

	if curMultiList then 

		local valueList = curMultiList[1] or {}
		local multiWin = curMultiList[2]
		for i, posId in pairs(self.curPickOverList) do 

			if table.nums(valueList)>0 and self.stateList[posId].open_type == "coins" then 
				local newValue = table.remove(valueList, 1)
				if newValue then 
					self._view:updatePosIdValue(posId, self.stateList[posId], newValue)
					self.stateList[posId].value = newValue
				end
			end
		end

		-- self:addData("state_list", self.stateList)

		self.node:runAction(cc.Sequence:create(
			cc.DelayTime:create(1),
			cc.CallFunc:create(function ( ... ) -- 翻倍特效
				self._view:playFooterWinMulti()
			end),
			cc.DelayTime:create(1),
			cc.CallFunc:create(function ( ... ) -- 赢钱翻倍
				self:refrshCollectWin( multiWin - self.bonusWin )
			end),
			cc.DelayTime:create(self.config.footer_roll_delay),
			cc.CallFunc:create(function ( ... ) -- 赢钱翻倍
				self:finshPlayOneItem()
			end)))
	else
		self:finshPlayOneItem()
	end
end

function cls:playCollectCount( count )
	self:setPickLeft(count)

	self:finshPlayOneItem()
end

function cls:playCollectNext( ... )

	self:resetStateListByNext( )
	-- self:addData("state_list", self.stateList)
		
	-- self.pageLevel = self.pageLevel + 1
	-- if self.pageLevel > self.config.page_count then 
	-- 	self.pageLevel = self.pageLevel - self.config.page_count
	-- end
	-- self:addData("page_level", self.pageLevel)


	local showNextWin = 45/30
	local showBgTime = 40/30
	local showItemTime = (self.config.item_max - 1)*self.config.item_show_delay + self.config.item_show_time

	self.node:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(showNextWin),
			cc.CallFunc:create(function ( ... )
				self._view:playShowNextPageBgAnim(self.pageLevel )
			end),
			cc.DelayTime:create(showBgTime),
			cc.CallFunc:create(function ( ... )
				self._view:initPickItems( self.stateList )
				self._view:showPickItem()
			end),
			cc.DelayTime:create(showItemTime),
			cc.CallFunc:create(function ( ... )
				self:finshPlayOneItem()
			end)))
	
end

function cls:finshPlayOneItem( ... )

	self:openPickBtnEvent()
end

function cls:pickAllItemOver( ... )
	self:addData("over_pick", true)
	
	self.node:runAction(
			cc.Sequence:create(
				cc.DelayTime:create(1),
				cc.CallFunc:create(function ( ... )
					self:showCollectDialog()
				end)
			))
end

function cls:canTouchPickItem()
    return self.canClickItem and self.haveLeft > 0
end

function cls:setTouchPickItem(status)
    self.canClickItem = status
end

function cls:setPickLeft(count, isReset)
	if count < 0 then 
		count = 0
	end

	local _old = self.haveLeft
    self.haveLeft = count

    local isAnim = _old and _old < self.haveLeft
    
    if isReset then 
    	isAnim = false
    end

    if self._view then 
    	self._view:updatePickLeft( count,  isAnim)
    end
end

function cls:getPickLeft()
    return self.haveLeft
end
----------------------------------------------------------------------------------------------------------------------------------

function cls:getGameConfig( )
	return self.themeCtl:getGameConfig()
end

function cls:playMusicByName(name, singleton, loop)
	self.themeCtl:playMusicByName(name, singleton, loop)
end

function cls:getFooterWinWordPos()
    return self.themeCtl:getFooterWinWordPos()
end

function cls:getCsbPath(file_name)
    return self.themeCtl:getCsbPath(file_name)
end

function cls:getFntFilePath(file_name)
    return self.themeCtl:getFntFilePath(file_name)
end

function cls:getSpineFile(file_name, notPathSpine)
    return self.themeCtl:getSpineFile(file_name, notPathSpine)
end

function cls:getParticleFile(file_name)
    return self.themeCtl:getParticleFile(file_name)
end

function cls:curSceneAddToContent( node )
    self.themeCtl:curSceneAddToContent(node)
end

function cls:curSceneAddToTop( node )
    self.themeCtl:curSceneAddToTop(node)
end

-----------------------------------------------------------------------------------------------
function cls:changeJPZorder( zType )
    self.jackpotVCtl:changeJPZorder(zType)
end


return cls

