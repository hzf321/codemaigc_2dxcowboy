-- @Author: xiongmeng
-- @Date:   2020-11-20 10:36:45
-- @Last Modified by:   xiongmeng
-- @Last Modified time: 2020-12-03 11:58:16
local _freeView = require (bole.getDesktopFilePath("Theme/KingOfEgypt_FreeView"))  
local parentClass = ThemeBaseFreeControl
local ThemeBaseDialog = require "Themes/base/ThemeBaseDialog"
local cls = class("KingOfEgypt_FreeViewControl", parentClass)

function cls:ctor(_mainViewCtl)
	parentClass.ctor(self, _mainViewCtl)
	self.fs_show_type = self.gameConfig.fs_show_type
	self.MapFreeWildType = self.gameConfig.MapFreeWildType
	self.theme = self
	self.curScene = self._mainViewCtl:getCurScene()
	-- self.wildKongId = 0
	self.wildSymbolId = 1
	self.showRaffleFinishFree = true
end

function cls:initLayout( nodesList )
	self.freeView = _freeView.new(self, nodesList)
end

function cls:checkIsSuperFree()
	-- return self.fgType and self.fgType ~= self.gameConfig.FreeGameType.Normal
end
function cls:onSpinStart( ... )
	-- if self:isMultiGame() then
	-- 	self.freeView:showBigWildMask()
	-- end
	-- self.randomWildPos = nil
	-- self.curWildMoveEndPos = nil
	-- self.multiWildNum = nil
	self.addNewWild = nil
	self.mapFgWildReel = nil
	self:addMapFgWildAnticipate()
	if self:getMapFreeStatus() and self:getStickWildStatus() then 
		self.freeView:playStackWildAppear()
	end
end
function cls:onAllReelStop( ... )
	-- if self.randomWildPos then
	-- 	for key, val in ipairs(self.randomWildPos) do
	-- 		local cell = self:getCellItem(val[1]+1, val[2]+1)
	-- 		self._mainViewCtl:updateCellSprite(cell, val[1]+1, true, self.wildSymbolId, true)
	-- 	end
	-- end
	self.hadMapDelaytime = nil
    self.startData = nil
end

function cls:stopFreeControl( stopRet )
	if not stopRet["item_list"] then return end

	self.item_list = nil
	self.item_list = table.copy(stopRet["item_list"])
	if self._mainViewCtl:getNormalStatus() then
		local freeGameInfo = stopRet["free_game"]
		if freeGameInfo then
			self.FreeGameType = freeGameInfo["fg_type"]
			self.mapAvgBet = freeGameInfo["avg_bet"]
			self.curFreeStatus = freeGameInfo["cur_free_status"]
			self.freeGameBgType = freeGameInfo["free_style"]
			self.mapFgRemoveLowSymbol = freeGameInfo["remove_low_symbol"]
			self.mapFgExtraWild = freeGameInfo["extra_wild"]
			self.mapFgYinSymbol = freeGameInfo["yin_wild"]
			self.mapFgYangSymbol = freeGameInfo["yang_wild"]
			self.mapFgStickyWild = freeGameInfo["sticky_wild"]
			self.gameMasterFlag  = freeGameInfo["game_master_flag"]
		end
	else
		if self:getMapFreeStatus() then
			local themeInfo = stopRet["theme_info"]
			local mapWildInfo = themeInfo and themeInfo["map_wild_info"]
			if mapWildInfo and mapWildInfo["sticky_wild"] then 
				self.mapFgStickyWild = mapWildInfo["sticky_wild"]
			end
			if mapWildInfo and mapWildInfo["wild_reel"] then 
				for key, val in ipairs(mapWildInfo["wild_reel"]) do 
					if val > 0 then 
						self.FeatureFree = true
					end
				end
				if self.FeatureFree then 
					self.mapFgWildReel = mapWildInfo["wild_reel"] 
				end
			end
		end
	end
end

---------------- 获取gameMasterFlag ----------------
function cls:gameMasterFlagStatus()
	if self.gameMasterFlag and self.gameMasterFlag == 1 then
		return true
	end
	return false
end
---------------- 获取lowsymbol ----------------
function cls:removeLowSymbolStatus()
	if self.mapFgRemoveLowSymbol and self.mapFgRemoveLowSymbol == 1 then 
		return true
	end	
	return false
end
---------------- 获取addWILD ----------------
function cls:getAddWildStatus()
	if self.mapFgExtraWild and self.mapFgExtraWild == 1 then 
		return true
	end
	return false
end
---------------- 获取yin symbol修改成yinwild ----------------
function cls:getYinSymbolStatus()
	if self.mapFgYinSymbol and self.mapFgYinSymbol == 1 then 
		return true
	end
	return false
end
---------------- 获取yang symbol修改成yangwild --------------
function cls:getYangSymbolStatus()
	if self.mapFgYangSymbol and self.mapFgYangSymbol == 1 then 
		return true
	end
	return false
end

function cls:getStickWildStatus()
	if self.mapFgStickyWild and #self.mapFgStickyWild > 0 then 
		return true
	end 
	return false
end

function cls:getItemListStickWild()
	local itemList = {}
	if self:getStickWildStatus() then
		for col = 1, 6 do 
			itemList[col] = itemList[col] or {}
			for row = 1, 3 do
				itemList[col][row] = 0
			end
		end
		for key, item in ipairs(self.mapFgStickyWild) do
			if item and item[1] and item[2] and itemList[item[1]+1] and itemList[item[1]+1][item[2]+1] then 
				itemList[item[1]+1][item[2]+1] = 1
			end
		end
	end
	return itemList
end
function cls:checkHasFeatureFree( ... )
	return self.FeatureFree
end
function cls:updateFreeReelsStop( ret, endFunc )
	self.FeatureFree = nil
	-- if self:getMapFreeStatus() and self:getStickWildStatus() then 
	-- 	self._mainViewCtl.rets.after_win_show = 1
	-- end 
	if self.mapFgWildReel then 
		self.freeView:nudgeExpendWildBoard(ret)
		self:laterCallBack(40/35, function ()
			if endFunc then 
				endFunc()
			end
		end)
	else
		if endFunc then 
			endFunc()
		end
	end
end
function cls:getMapFreeWildTime( ... )
	local delay = 0
	if self:isAddWildAni() then 
		delay = self:getMapFgWildAnticipateTime()
	end
	return delay
end
function cls:getItemWildAnimate( col, row, effectStatus )
	if self.freeView.stickWildNodeList and self.freeView.stickWildNodeList[col] and self.freeView.stickWildNodeList[col][row] then
		if effectStatus and effectStatus == "all_first" then
			self._mainViewCtl.mainView:playItemAnimation(self.wildSymbolId, col, row)
			return true
		end
	end
	return false
end
function cls:getMapFgWildAnticipateTime()
	local dataTime = os.time() * 1000
	local delay = 0
	if self.startData then
        local dis = math.floor((dataTime - self.startData)/1000 )* 60
        if dis < (self.hadMapDelaytime * 60) then
            delay = (self.hadMapDelaytime * 60 - dis)/60
        end
    else
        delay = self.hadMapDelaytime
	end
	return delay
end
function cls:addMapFgWildAnticipate()
	if self:isAddWildAni() then 
		self.startData = os.time() * 1000 -- 求当前的毫秒数
		self.hadMapDelaytime = self.gameConfig.reel_spin_config.extraAddWildTime
		self.freeView:addMapFreeMoreWildAnticipate()
		-- self:playMusicByName("map_wild_add")
	end
end
function cls:isAddWildAni()
	if self:getAddWildStatus() then 
		if self.freespin and self.sumFreeSpinCnt then 
			if self.freespin + 1 == self.sumFreeSpinCnt then 
				return true
			end
		end
	end
	return false
end
-- function cls:addJpAwardAnimation(jpWinType)
-- 	self.freeView:addJpAwardAnimation(jpWinType)
-- end
function cls:stopDrawAnimate( ... )
	self.randomWildPos = nil
	self.curWildMoveEndPos = nil
	self.freeView:stopDrawAnimate()
end
function cls:getNormalFgStatus( ... )
	return not self.mapAvgBet
end
function cls:getMapFreeStatus()
	return self.mapAvgBet
end
function cls:getFreeBgType()
	-- 是阴或者阳
	if self.freeGameBgType and self.freeGameBgType == 1 then 
		return 3
	end
	return 2
end

function cls:after_win_show( ... )
	-- if self:getMapFreeStatus() then 
	-- 	self.freeView:playStackWildAppear()
	-- 	self._mainViewCtl:handleResult()
	-- else 
		self._mainViewCtl:getCollectViewCtl():showCollectFullAnimation()
		local delay = 5
		self._mainViewCtl:showMapFeature()
		self:laterCallBack(delay, function ()
			self._mainViewCtl:handleResult()
		end)
	-- end
end
function cls:dealFreeGameResumeRet( data )
	if data["free_game"] then 
		self.FreeGameType = data["free_game"]["fg_type"]
		self.mapAvgBet = data["free_game"]["avg_bet"]
		self.freeGameBgType = data["free_game"]["free_style"]
		self.curFreeStatus = data["free_game"]["cur_free_status"]

		self.mapFgExtraWild = data["free_game"]["extra_wild"]
		self.mapFgRemoveLowSymbol = data["free_game"]["remove_low_symbol"]
		self.mapFgYinSymbol = data["free_game"]["yin_wild"]
		self.mapFgYangSymbol = data["free_game"]["yang_wild"]
		self.mapFgStickyWild = data["free_game"]["sticky_wild"]
		self.gameMasterFlag  = data["free_game"]["game_master_flag"]

		if data["free_game"]["free_spins"] and data["free_game"]["free_spins"] >= 0 then
			if not self.mapAvgBet then 
				if data["free_game"]["item_list"] then
					local realItemList = data["free_game"]["item_list"]
					data["free_game"]["item_list"] = tool.tableClone(realItemList)
					self.freeSpeical = self._mainViewCtl:getSpecialTryResume(realItemList)
				end
			else
				if data["free_game"]["free_spins"] == data["free_game"]["free_spin_total"] then 
					data["first_free_game"] = tool.tableClone(data["free_game"])
					data["free_game"] = nil
				elseif data["free_game"]["item_list"] then 
					local realItemList = data["free_game"]["item_list"]
					data["free_game"]["item_list"] = tool.tableClone(realItemList)
					self.freeSpeical = self._mainViewCtl:getSpecialTryResume(realItemList)
				end
			end
			-- if data["free_game"]["free_spins"] == data["free_game"]["free_spin_total"] then 
			-- 	data["first_free_game"] = tool.tableClone(data["free_game"])
			-- 	data["free_game"] = nil
			-- elseif data["free_game"]["item_list"] then 
			-- 	local realItemList = data["free_game"]["item_list"]
			-- 	data["free_game"]["item_list"] = tool.tableClone(realItemList)
			-- 	self.freeSpeical = self._mainViewCtl:getSpecialTryResume(realItemList)
			-- end
			-- if data["free_game"]["item_list"] then
			-- 	local realItemList = data["free_game"]["item_list"]
			-- 	data["free_game"]["item_list"] = tool.tableClone(realItemList)
			-- 	self.freeSpeical = self._mainViewCtl:getSpecialTryResume(realItemList)
			-- end
		end
	end
end
function cls:showFreeSpinNode( ... )
	if self:getNormalFgStatus() then
		self._mainViewCtl:changeSpinBoard("FreeSpin")
	else
		self._mainViewCtl:changeSpinBoard("MapFreeSpin")
	end
	self:initMapFreeBoard()
end
function cls:resetPointBet( ... )
	if self.mapAvgBet then
		self._mainViewCtl:setPointBet(self.mapAvgBet)
	end
end
function cls:hideFreeSpinNode( ... )
	if self.mapAvgBet then
		self._mainViewCtl.mapPoints = 0
		self._mainViewCtl:showCurrentCollectShow()
		if self._mainViewCtl.mapLevel == self.gameConfig.collectData.maxMapLevel then
			self._mainViewCtl.mapLevel = 0
			self._mainViewCtl.preMapStatus = {}
        	self._mainViewCtl.curMapStatus = {}
		else 
			local all = 0
			if self._mainViewCtl.curMapStatus then 
				for key, val in ipairs(self._mainViewCtl.curMapStatus) do 
					all = all + val
				end
			end
			if self._mainViewCtl.preMapStatus then 
				table.insert(self._mainViewCtl.preMapStatus, all)
			end
		end
	end

	self.freeView:hideFreeSpinNode()
	if self._mainViewCtl.footer then
		self._mainViewCtl.footer:changeNormalLayout2()
	end

	-- move
	self.wildStickList = nil
	self.curFreeStatus = nil
	self.mapAvgBet = nil
	self.mapFgExtraWild = nil
	self.mapFgRemoveLowSymbol = nil
	self.mapFgYinSymbol = nil 
	self.mapFgYangSymbol = nil
	self.mapFgStickyWild = nil
	self.FreeGameType = 1
	self.gameMasterFlag = nil
end
function cls:initMapFreeBoard( ... )
	if self.mapFgStickyWild and #self.mapFgStickyWild then 
		self.freeView:playStackWildAppear()
	end
end
function cls:exitWildChangeSymbol( ... )
	-- local lockCol = 3
    -- local maxRow = 8
	-- for col = 1, 5 do 
	-- 	for row = 1, maxRow do 
	-- 		local random = math.random(2, 11)
	-- 		local cell = self:getCellItem(col, row)
	-- 		self._mainViewCtl:updateCellSprite(cell, col, true, random, true)
	-- 	end
	-- end
end
----------------------------dialog start -------------------------------------
function cls:playStartFreeSpinDialog( theData )
	if self:getNormalFgStatus() then
		if theData.enter_event then 
			theData.enter_event()
		end
		if theData.click_event then 
			theData.click_event()
		end
		if theData.changeLayer_event then 
			theData.changeLayer_event()
		end
		if theData.end_event then 
			theData.end_event()
		end
	else
		-- 地图的fg展示情况
		local end_event = theData.end_event
		local changeLayer_event = theData.changeLayer_event
		theData.changeLayer_event = nil
		theData.end_event = nil
		self:hideActivitysNode()
		self:setFooterBtnsEnable(false)
		local click_event = theData.click_event
		self:playMusicByName("free_dialog_start")
		local transitionDelay = self.gameConfig.transition_config.wheel
		local dialogType = "map_free_start"
		local csbPath = "dialog_mapfree"
		theData.click_event = function()
	        self:stopMusicByName("free_dialog_start")
	        if click_event then
	            click_event()
	        end
	        self.node:runAction(
	            cc.Sequence:create(
	                    cc.DelayTime:create(1),
	                    cc.CallFunc:create(function()
							self._mainViewCtl:playTransition(nil, "wheel")
							self._mainViewCtl:setFooterEnable(false)
							self._mainViewCtl:setHeaderEnable(false)
	                    end
	                    ),
	                    cc.DelayTime:create(transitionDelay.onCover),
	                    cc.CallFunc:create(function()
	                        if changeLayer_event then
	                            changeLayer_event()
							end
							self:updateMapFgSymbol()
	                        self:showFreeSpinNode()
							self:setFooterBtnsEnable(false)
	                    end
	                    ),
	                    cc.DelayTime:create(transitionDelay.onEnd - transitionDelay.onCover),
						cc.CallFunc:create(function()
							self._mainViewCtl:setFooterEnable(true)
							self._mainViewCtl:setHeaderEnable(true)

							self:showActivitysNode()
	                    end
	                    ),
	                    cc.DelayTime:create(0.5),
	                    cc.CallFunc:create(function()
							self:dealMusic_PlayFreeSpinLoopMusic()
							if end_event then
	                            end_event()
	                        end
	                    end)
	            )
	        )
		end
		local dialog = self._mainViewCtl:showThemeDialog(theData, 1, csbPath, dialogType)
		self:dealWithMapFreeStart(dialog)
		local startRoot = dialog.startRoot
		if startRoot then 
			local gamemaster_icon = startRoot:getChildByName("gamemaster_icon")
			local enable = false
			if self:gameMasterFlagStatus() then 
				enable = true
			end
			if gamemaster_icon and bole.isValidNode(gamemaster_icon) then 
				gamemaster_icon:setVisible(enable)
			end
		end
	end
end
function cls:updateMapFgSymbol()
	for col = 1, 6 do 
		local cell1 = self:getCellItem(col, 0)
		if cell1 then 
			self._mainViewCtl:updateCellSprite(cell1, col, true, math.random(3,5), true)
		end
		for row = 1, 3 do
			local cell = self:getCellItem(col, row)
			if cell then 
				self._mainViewCtl:updateCellSprite(cell, col, true, math.random(3,5), true)
			end
		end
	end
end
function cls:dealWithMapFreeStart(dialog)
	if not dialog then return end
	local startRoot = dialog.startRoot
	local boosterNode = startRoot:getChildByName("booster_node")
	-- local boosterBg = boosterNode:getChildByName("bg")
	-- boosterBg:setVisible(true)
	local statusLen = #self.curFreeStatus
	local levelConfig = self:getPickLevelConfig()
	if statusLen > #levelConfig then 
		statusLen = #levelConfig
	end
	for key = 1, 6 do
			local boosterItem = boosterNode:getChildByName("booster"..key)
			bole.setEnableRecursiveCascading(boosterItem, true)
			if key > statusLen then
				boosterItem:setVisible(false)
			else
				local result = levelConfig[key]
				local getImage = boosterItem:getChildByName("get")
				bole.updateSpriteWithFile(getImage, "#theme325_popup_get"..result..".png")
				if result == 2 then
					local nums = self:getStickNums()
					if nums ~= 1 then
						bole.updateSpriteWithFile(getImage, "#theme325_popup_get"..result.."s.png")
					end
				end
				if result == 1 or result == 2 or result == 6 or result == 8 then
					getImage:setPositionY(-2)
				else 
					getImage:setPositionY(0)
				end
				if self:getSpecailResult(result) then
					local nums
					local image
					local pos
					local scale
					nums,image,pos,scale = self:getSpecailResult(result)
					local theSpriteFile = string.format(image, nums)
					local image = bole.createSpriteWithFile(theSpriteFile)
					image:setPosition(pos)
					image:setScale(scale)
					boosterItem:addChild(image)
				end
				boosterItem:setVisible(true)
				if self.curFreeStatus[key] == 0 then
					boosterItem:setColor(cc.c3b(100,100,100))
				end
			end
	end
end

function cls:playMoreFreeSpinDialog( theData )
	self:hideActivitysNode()
	if theData.enter_event then
        theData.enter_event()
	end
	theData.enter_event = nil
    local end_event = theData.end_event
    theData.end_event = nil
	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end
		self:laterCallBack(1, function ()
			if end_event then
				end_event()
			end
			self:showActivitysNode()
		end)
	end
	self._mainViewCtl:showThemeDialog(theData, self.fs_show_type.more, "dialog_free", "free_more")
end

function cls:playCollectFreeSpinDialog( theData )
	self._mainViewCtl:stopAllLoopMusic()
	local fgTranType = "free"
	if not self:getNormalFgStatus() then
		fgTranType = "wheel"
	end
	local transitionDelay = self.gameConfig.transition_config[fgTranType]
	
    local enter_event = theData.enter_event
    local end_event = theData.end_event
    theData.end_event = nil
    local changeLayer_event = theData.changeLayer_event
    theData.changeLayer_event = nil
    theData.enter_event = function()
        if enter_event then
            enter_event()
        end
    end
    self:hideActivitysNode()
	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end
		local a1 = cc.DelayTime:create(1)
		local a2 = cc.CallFunc:create(function ( ... )
			self._mainViewCtl:playTransition(nil, fgTranType)
			self._mainViewCtl:setFooterEnable(false)
			self._mainViewCtl:setHeaderEnable(false)
		end)
		local a3 = cc.DelayTime:create(transitionDelay.onCover)
		local a4 = cc.CallFunc:create(function ( ... )
			self:exitWildChangeSymbol()
			if changeLayer_event then
			    changeLayer_event()
			end
			self:setFooterBtnsEnable(false)
		end)
		local a5 = cc.DelayTime:create(transitionDelay.onEnd - transitionDelay.onCover)
		local a6 = cc.CallFunc:create(function ( ... )
			self._mainViewCtl:setFooterEnable(true)
			self._mainViewCtl:setHeaderEnable(true)

			self:showActivitysNode()
		end)
		local a61 = cc.DelayTime:create(0.5)
		local a62 = cc.CallFunc:create(function ( ... )
			-- 修改牌面
			if end_event then
				end_event()
			end
			self._mainViewCtl:finshSpin()
		end)
		local a7 = cc.Sequence:create(a1,a2,a3,a4,a5,a6,a61,a62)
		self.node:runAction(a7)
	end
	local csbPath     = "dialog_free"
	local dialogType = "free_collect"
	if not self:getNormalFgStatus() then
		csbPath     = "dialog_mapfree"
		dialogType = "map_free_collect"
	end
	self._mainViewCtl:showThemeDialog(theData, self.fs_show_type.collect, csbPath, dialogType)
end
----------------------------dialog end --------------------------------------


------------------------------------------------------------------------------
function cls:getPickLevelConfig()
    local level = self._mainViewCtl.mapLevel
    local map_booster_config = self.gameConfig.map_config.map_booster_config
	local map_building_config = self.gameConfig.map_config.map_building_config
	self.pickLevelConfig = {}
	local lastIndex = 0
	if level > lastIndex then
		for key, val in ipairs(map_booster_config) do
    	    if level <= val then
    	        self.pickLevelConfig = map_building_config[val]
    	        break
    	    end
    	    lastIndex = val
		end
	end
	return self.pickLevelConfig 
end
function cls:getSpecailResult(result)
    result = result or 1
    if result == 2 then
        return self:getStickNums(), "#theme325_popup_stick%s.png", cc.p(-44.5, 0), 0.55
    elseif result == 8 then
        return self:getAllWinsMul(), "#theme325_popup_allwin%s.png", cc.p(4, 0), 1
    end
    return false
end
function cls:getStickNums()
    return self._mainViewCtl.mapViewCtl:getStickNums()
end
function cls:getAllWinsMul()
    return self._mainViewCtl.mapViewCtl:getAllWinsMul()
end

function cls:playFeatureDimmerAnim(dType, state)
	return self._mainViewCtl:playFeatureDimmerAnim(dType, state)
end

function cls:playNodeShowAction( node, actionData )
	return self._mainViewCtl:playNodeShowAction( node, actionData )
end

-- function cls:addMultiFont(fontType, scale)
--     scale = scale or 1
--     local file = self:getPic(self.gameConfig.label_fnt[fontType])
--     local fntLabel = ccui.TextBMFont:create()
--     fntLabel:setFntFile(file)
--     fntLabel:setScale(scale)
--     return fntLabel
-- end

function cls:playFadeToMinVlomeMusic( ... )
	self._mainViewCtl:playFadeToMinVlomeMusic()
end
function cls:playFadeToMaxVlomeMusic( ... )
	self._mainViewCtl:playFadeToMaxVlomeMusic()
end
function cls:getCsbPath( file_name )
	return self._mainViewCtl:getCsbPath(file_name)
end


-----------------free 音效相关-------------------
-- 播放free games的背景音乐
function cls:dealMusic_PlayFreeSpinLoopMusic() -- 播放背景音乐
	-- dealMusic_PlayFreeSpinLoopMusic
	self._mainViewCtl:dealMusic_PlayFreeSpinLoopMusic()
	-- if self:getMapFreeStatus() then
	-- 	self.audioCtl:dealMusic_PlayGameLoopMusic(self._mainViewCtl:getAudioFile("mapfree_background"))
	-- else
	-- 	self.audioCtl:dealMusic_PlayGameLoopMusic(self._mainViewCtl:getAudioFile("free_background"))
	-- end
end

-- freespin音效相关
function cls:dealMusic_PlayFSEnterMusic( ) -- 进入freespin 弹窗显示的音效
	if self:getMapFreeStatus() then
		self:playMusicByName("mapfree_dialog_start_show")
	else
		self:playMusicByName("free_dialog_start_show")
	end
	
end
function cls:dealMusic_StopFSEnterMusic( )
	if self:getMapFreeStatus() then
		self:stopMusicByName("mapfree_dialog_start_show")
	else
		self:stopMusicByName("free_dialog_start_show")
	end
end
function cls:dealMusic_PlayFSEnterClickMusic( )
	self:playMusicByName("free_dialog_start_close")
end

-- retrigger
function cls:dealMusic_PlayFSMoreMusic( )
	if self:getMapFreeStatus() then
		self:playMusicByName("mapfree_dialog_start_show")
	else
		self:playMusicByName("free_dialog_start_show")
	end
end

function cls:dealMusic_StopFSMoreMusic( )
end

function cls:dealMusic_PlayFSMoreClickMusic( )
	self:playMusicByName("free_dialog_more_close")
end

--Free Game 收集音乐
function cls:dealMusic_PlayFSCollectMusic( )
	if self:getMapFreeStatus() then
		self:playMusicByName("mapfree_dialog_collect_show")
	else
		self:playMusicByName("free_dialog_collect_show")
	end
end
function cls:dealMusic_StopFSCollectMusic( )
	if self:getMapFreeStatus() then
		self:stopMusicByName("mapfree_dialog_collect_show")
	else
		self:stopMusicByName("free_dialog_collect_show")
	end
end
function cls:dealMusic_PlayFSCollectClickMusic()
	self:playMusicByName("free_dialog_collect_click")
	self:playMusicByName("free_dialog_collect_close")
end
function cls:dealMusic_PlayFSCollectEndMusic( )
	
end

return cls