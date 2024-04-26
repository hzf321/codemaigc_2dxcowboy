


local parentClass = ThemeBaseFreeControl
ThemeGoldRush_FreeControl = class("ThemeGoldRush_FreeControl", ThemeBaseFreeControl)
local cls = ThemeGoldRush_FreeControl

require (bole.getDesktopFilePath("Theme/ThemeGoldRush_FreeView")) 
function cls:ctor(_mainViewCtl)
	parentClass.ctor(self, _mainViewCtl)

	self.fBoardCount = 1
	self.fCollectCount = 0
end

function cls:initLayout( nodesList )
	self._view = ThemeGoldRush_FreeView.new(self, nodesList)
end

function cls:checkIsSuperFree()
	return self.fgType and self.fgType ~= self.gameConfig.FreeGameType.Normal
end

-- 数据分析
function cls:checkDealSpecialFreeData( data ) -- 断线重连
	if data.free_game then 
		self.fgType = 1
		self.fgAvgBet = data.free_game.avg_bet
		if data.free_game.free_type then 
			self.fgType = data.free_game.free_type
		end

		self.isResmeFree = true
    end

    self:resetFreeData(data.map_info)
end

function cls:getFreeBoardCnt(  )
	return self.fBoardCount or 1
end

function cls:resetFreeData( map_info )
	if map_info then
		self.fCollectCount = map_info["free_collect_count"]
		self.fBoardCount = map_info["free_boards_count"]

		if self:checkIsSuperFree() then 
			self.fgAvgBet = map_info["avg_bet"]
		end
	end 
end

function cls:checkStopCtlSpecialFreeData( stopRet ) -- stopControl
	self.isWinMoreFree = false
	self.isResmeFree = false
	if stopRet.free_spins and stopRet.free_game then
		if (not self:isInFG()) then
			self.fgType = stopRet.free_game.free_type or 0
			self:resetFreeData(stopRet.theme_info.map_info)
		else
			self.isWinMoreFree = true
		end
	end

	self.newCollectCount = 0
	self.oldBoardCount = self.fBoardCount or 1

	if (not self:isMaxBoard()) and self:isInFG() and stopRet.theme_info and stopRet.theme_info.map_info then

		self.newCollectCount = stopRet.theme_info.map_info["free_collect_count"] - (self.fCollectCount or 0)
		self:resetFreeData(stopRet.theme_info.map_info)
	end

end

function cls:isMaxBoard()
	return self.fBoardCount == self.gameConfig.free_config.max_board_count
end

function cls:checkIsInFreeStop( ... )
    return self.newCollectCount and self.newCollectCount > 0
end

function cls:checkHasAvgBet( ... )
    return self.fgAvgBet
end

function cls:checkIsResumeFree()
    return self.isResmeFree
end

function cls:clearFreeFeatureData( byHideFree )
    self.fgType = nil
    self.fgAvgBet = nil
    self._view:clearFreeFeatureAnim(byHideFree)
end

function cls:changeFreeItemSpecial( )

	local scatter_config = self.gameConfig.symbol_config.scatter_config
	if self.freeItem then 
		local _c_free_item = tool.tableClone(self.freeItem)
		for col, colList in pairs(_c_free_item) do 
			for row, item in pairs(colList) do 
				if item > scatter_config.scatter_add then 
					self.freeItem[col][row] = item%scatter_config.scatter_add
				end
			end
		end
	end
end
---------
function cls:resetBoardShowByFeature( state, boardCount )
	boardCount = boardCount or self.fBoardCount
	self._view:resetBoardShowByFeature(  state, boardCount)
	self:refreshFreeTip(boardCount)
end

function cls:refreshFreeTip( boardCount, fCCount, byAnim, isFull )
	local boardCount = boardCount or self.fBoardCount
	local fCCount = fCCount or self.fCollectCount
	local nextFullCount = 0
	if byAnim and self.oldBoardCount then 
		boardCount = self.oldBoardCount
	end

	if not boardCount then return end
    local free_config = self.gameConfig.free_config

    local nextBoardCount
    local leftCount
    if boardCount < free_config.max_board_count then 
		
		local curIndex = tool.getKeyByTableItem(free_config.board_count, boardCount)
		local nextIndex = curIndex + 1

		nextBoardCount = free_config.board_count[nextIndex]
		local nextT = free_config.collect_count[nextBoardCount] or 0
		leftCount = nextT - fCCount

		nextFullCount = nextT - (free_config.collect_count[boardCount] or 0)
	end

	if not isFull then 
		self._view:refreshFreeTip( nextBoardCount, leftCount, isFull)
	else
		return self._view:refreshFreeTip( nextBoardCount, nextFullCount, leftCount)
	end
end

function cls:refreshBoardShow( )
	self:playMusicByName("reset_board"..self.fBoardCount)
	self:changeFreeSpinBoard()

	self._mainViewCtl:resetCurrentReels(true)
end

function cls:showCollectProgress( list, endFunc )
	local _f_config = self.gameConfig.free_config
	self.newCollectCount = nil
	local _moreFree = self.isWinMoreFree

	-- if not _moreFree then 
	-- 	endFunc()
	-- end

	local boardCount = self.fBoardCount
	local fCCount = self.fCollectCount
	self.node:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ( ... )
			self:showScatterFlyToUp(list) -- 显示收集动画
		end),
		cc.DelayTime:create(_f_config.fly_up_time),
		cc.CallFunc:create(function ( ... )
			
			self:refreshFreeTip(boardCount, fCCount, true)
			self._view:showFreeCollectArrAnim()

			-- if _moreFree then 
				endFunc()
			-- end
		end)))
end

function cls:showScatterFlyToUp(list)
	self._view:showScatterFlyToUp(list)
end

---------
function cls:changeFreeSpinBoard( ... )
	local boardType = self.fgType == self.gameConfig.FreeGameType.Normal and "FreeSpin" or "SFree"..self.fgType

	self._mainViewCtl:changeSpinBoard(boardType)
end

function cls:getFreeTransitionType( ... )
	local fgTypeConfig = self.gameConfig.FreeGameType
	local transitionType = self.fgType == fgTypeConfig.Normal and "free" or "sfree"
	return transitionType
end
-- 弹窗
function cls:playStartFreeSpinDialog( theData )
	self._mainViewCtl:stopAllLoopMusic()
	
	local fgType = self.fgType
	local fgTypeConfig = self.gameConfig.FreeGameType
	local transitionType = self:getFreeTransitionType()
	
	self:hideActivitysNode()
	local endEvent = theData.end_event
	theData.end_event = nil
	local t_end_event = function ( ... )
		self._mainViewCtl:dealMusic_PlayFreeSpinLoopMusic()
		if endEvent then 
			endEvent()
		end
		self:showActivitysNode()
	end

	local changeLayer_event = theData.changeLayer_event
	theData.changeLayer_event = nil
	local t_changeLayer_event = function()
		if changeLayer_event then
			changeLayer_event()
		end

		self:changeFreeSpinBoard()
	end

	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end
		
		self:setFooterBtnsEnable(false)

		self.node:runAction(cc.Sequence:create(
			cc.DelayTime:create(40/30),
			cc.CallFunc:create(function ( ... )
			    self._mainViewCtl:playTransition(t_end_event, transitionType, t_changeLayer_event)-- 转场动画
			end)))
	end

	local dName = transitionType
	local dType = self.gameConfig.fs_show_type.start
	theData.num_sp = theData.count
	theData.bg = fgType
	self._mainViewCtl:showThemeDialog(theData, dType, dName)

end

function cls:playMoreFreeSpinDialog( theData )

	self:hideActivitysNode()
	self._mainViewCtl:dealMusic_FadeLoopMusic(0.2, 1, 0)

	local moreParent = cc.Node:create()
    bole.scene:addToTop(moreParent)

    local end_event = theData.end_event
    theData.end_event = nil
    local d_end_event = function()
        self:refreshBoardShow() -- 刷新棋盘 
        local delay = self:refreshFreeTip( nil, nil, nil, true ) or 0 -- 刷新计数

        self.node:runAction(
			cc.Sequence:create(
				cc.DelayTime:create(delay),
				cc.CallFunc:create(function ( ... )
					if end_event then
						end_event()
					end
					self._mainViewCtl:dealMusic_FadeLoopMusic(0.2, 0, 1)
					self:showActivitysNode()
				end)))
    end

	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end

		self.node:runAction(cc.Sequence:create(
			cc.DelayTime:create(0.5 + 0.5),
			cc.CallFunc:create(function ( ... )
			    if d_end_event then 
			    	d_end_event()
			    end
			end)))
	end

	local dName = "free"
	local dType = self.gameConfig.fs_show_type.more

	local dialog = self._mainViewCtl:showThemeDialog(theData, dType, dName, moreParent)

	local endPosW = self._mainViewCtl:getFooterNodesPos("free_count")
	local endPosN = bole.getNodePos(dialog:getParent(), endPosW) or cc.p(0,0)
	
	dialog:runAction(cc.Sequence:create(
		cc.DelayTime:create(55/30),
		cc.MoveTo:create(10/30, endPosN),
		cc.CallFunc:create(function ( ... )
			self:adjustWithFreeSpin()

	        local data = {}
	        data.file = self:getSpineFile("f_footer_arr")
	        data.parent = dialog
	        data.animateName = "animation"
	        local _, s = bole.addAnimationSimple(data)
	        self.fIcon = s
		end)
		)
	)
end

function cls:playCollectFreeSpinDialog( theData )
	self._mainViewCtl:stopAllLoopMusic()
	self:hideActivitysNode()

	local fgType = self.fgType
	local transitionType = self:getFreeTransitionType()

    local enter_event = theData.enter_event
    theData.enter_event = function()
        if enter_event then
            enter_event()
        end
    end

	local changeLayer_event = theData.changeLayer_event
	theData.changeLayer_event = nil
	local t_changeLayer_event = function()
		if changeLayer_event then
			changeLayer_event()
		end
	end

    local end_event = theData.end_event
    theData.end_event = nil
    local d_end_event = function()

        if end_event then
            end_event()
        end
        self:showActivitysNode()
    end

	local click_event = theData.click_event
	theData.click_event = function()
		if click_event then
			click_event()
		end

		self.node:runAction(cc.Sequence:create(
			cc.DelayTime:create(40/30),
			cc.CallFunc:create(function ( ... )
			    self._mainViewCtl:playTransition(d_end_event, transitionType, t_changeLayer_event)-- 转场动画
			end)))
	end


	local dName = transitionType
	local dType = self.gameConfig.fs_show_type.collect
	self._mainViewCtl:showThemeDialog(theData, dType, dName)
end


------------------------------------------------------------------------------

-- freespin音效相关
function cls:dealMusic_PlayFSEnterMusic( ) -- 进入freespin 弹窗显示的音效
	if self:checkIsSuperFree() then 
		self:playMusicByName("dialog_sfg_start")
	else
		self:playMusicByName("dialog_fg_start")
	end
end
function cls:dealMusic_PlayFSEnterClickMusic( )
	self:playMusicByName("common_click")
	-- self:playMusicByName("popup_out")
end

-- retrigger
function cls:dealMusic_PlayFSMoreMusic( )
	self:playMusicByName("spin_fly")
end

--Free Game 收集音乐
function cls:dealMusic_PlayFSCollectMusic( )
	if self:checkIsSuperFree() then 
		self:playMusicByName("dialog_sfg_collect")
	else
		self:playMusicByName("dialog_fg_collect")
	end
end
function cls:dealMusic_PlayFSCollectClickMusic()
	self:playMusicByName("common_click")
	-- self:playMusicByName("popup_out")
end

------------------------------------------------------------------------------
function cls:playFeatureDimmerAnim(dType, state)
	return self._mainViewCtl:playFeatureDimmerAnim(dType, state)
end

function cls:playNodeShowAction( node, actionData )
	return self._mainViewCtl:playNodeShowAction( node, actionData )
end



