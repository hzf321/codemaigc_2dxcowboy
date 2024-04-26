

local ThemeMysteriousPixies_BGWheelControl = class("ThemeMysteriousPixies_BGWheelControl")
local cls = ThemeMysteriousPixies_BGWheelControl

local randomWheelView = require (bole.getDesktopFilePath("Theme/ThemeMysteriousPixies_BGWheelView")) 

function cls:ctor(bonusParent, data, tryResume)
	
	self.bonusParent 	= bonusParent
	self.bonusControl 	= bonusParent.bonusControl
	self.themeCtl 		= bonusParent.themeCtl
	self.data          	= data
	self.isTryResume 	= tryResume

	self.jackpotVCtl = self.themeCtl:getJpViewCtl()
	
	self.gameConfig = self:getGameConfig()
	self.config = self.gameConfig.wheel_config

	self.node = cc.Node:create()
    self:curSceneAddToContent(self.node)
	self:initData()

	self:initGameLayout()
end

function cls:initGameLayout( )
	local nodesList = self.themeCtl:getSpecialFeatureRoot("wheel_bonus")
	self._view = randomWheelView.new(self, nodesList)

	self._view:initWheelLb( self.wheelReel )
end


function cls:initData()
	self.curBonusData 	= self.data.core_data.wheel_bonus
    
    self.jpWinData 		= tool.tableClone(self.curBonusData.jp_win_temp)
    self.wheelReel 		= self.curBonusData.wheel_list -- 上次点击过的位置
    self.wheelIndexList = self.curBonusData.wheel_index_list -- 当次点击的结果
    self.nearMiss 		= self.curBonusData.near_miss -- pick 次数

    self.progressiveData = tool.tableClone(self.data.core_data.progressive_list)

    self:initWinData()
    self:initDataResume()
end

function cls:initWinData( ... )
	self.bonusWin = self.themeCtl.totalWin-- 加钱操作

	self.onlyBonusWin = 0
	for _, jpData in pairs(self.jpWinData) do 
		if jpData and jpData.jp_win then 
			self.onlyBonusWin = self.onlyBonusWin + jpData.jp_win
		end
	end
end

function cls:initDataResume( )
	self.curSaveData = self.data.wheel_save_data or {}
	self.wheelOverCount   = self.curSaveData.wheel_over_count or 0
	self.hasLeft 	 = table.nums(self.wheelIndexList)

	self.curWinData = {} 
	for k = 1, self.wheelOverCount do 
		self.hasLeft = self.hasLeft -1
		if table.nums(self.wheelIndexList) > 0 then 
			local win = table.remove(self.wheelIndexList, 1)
			self.curWinData["win"] = win
		end
		if table.nums(self.nearMiss) > 0 then 
			local _nearMiss = table.remove(self.nearMiss, 1)
			self.curWinData["nearMiss"] = _nearMiss
		end

		if table.nums(self.jpWinData) > 0 then 
			local _jpWinData = table.remove(self.jpWinData, 1)
			local jpWinValue = _jpWinData.jp_win or 0 
			self:refrshCollectWin( jpWinValue, true )
		end
	end

end

function cls:getNextJackpotWinValue( )
	local item
	if self.jpWinData and self.jpWinData[1] and self.jpWinData[1].jp_win then 
		item = table.remove(self.jpWinData,1)
	end
	return item
end


function cls:refrshCollectWin( theNum, isReset )
	if isReset then 
   		self.themeCtl:setFooterWinCoins(theNum, self.bonusWin, 0)
   		self.themeCtl:setWinCoins_noHandle( theNum )
   	else
   		local callback = function ( ... )
   			self:finshPlayOneWheel()
   		end
   		self.themeCtl:startRollup(theNum, callback)

   		-- 改成自动的rollUp
   		-- self.themeCtl:setFooterWinCoins( theNum or 0 , self.bonusWin, 0.5 )
   		-- self.themeCtl:setWinCoins_noHandle( theNum )
   	end
   	self.bonusWin = self.bonusWin + theNum
end

function cls:addData(key, value)
	self.curSaveData = self.curSaveData or {}
	self.curSaveData[key] = value

	self.bonusParent:addData("wheel_save_data", self.curSaveData)
end

function cls:enterBonusGame()
	self.themeCtl:stopDrawAnimate()
	self.jackpotVCtl:changeJackpotLabelsState(true, self.progressiveData)

	if self.bonusParent:isOverSingleBonus("fg_wheel") then 
		self:enterBonusByEnd()
	else
		self.themeCtl:dealMusic_EnterBonusGame()

		if not self.curSaveData.feature_show then -- 直接展示界面
			self:showFeatureNode()
		elseif not self.curSaveData.feature_over then -- 打开点击事件
			self:showFeatureNode(true)
			self:openFeatureBtnEvent()
		else -- 直接展示结果界面
			self:showFeatureNode(true)
			self.node:runAction(
				cc.Sequence:create(
					cc.DelayTime:create(1),
					cc.CallFunc:create(function ( ... )
						self:playCollectWinFree()
					end)
				))
		end
	end
end

function cls:enterBonusByEnd( ... )
	self.themeCtl:addCoinsToHeader()
	
	self.bonusParent:setSingleBonusOver( "fg_wheel" )
	self.bonusParent:checkIsOverBonus()
end

function cls:showFeatureNode( tryResume )
	self._view:showFeatureNode( tryResume )
end

function cls:openFeatureBtnEvent( ... )
    if self.hasLeft > 0 then 
        self:setBtnTouchState(true)
        self._view:changeFeatureTipState( "tip" )
    else
    	self._view:changeFeatureTipState( )
        self:wheelAllTimeOver()
    end
end

function cls:isOverWheel( ... )
	return table.nums(self.wheelIndexList) <= 0
end

function cls:updateLeftCount( ... )
	self.hasLeft = self.hasLeft - 1

	self.wheelOverCount = self.wheelOverCount + 1
	self:addData("wheel_over_count", self.wheelOverCount)
end

function cls:getNextWheelResult( ... )
	self.curWinData = {} 
	if table.nums(self.wheelIndexList) > 0 then 
		local win = table.remove(self.wheelIndexList, 1)
		self.curWinData["win"] = win
	end
	if table.nums(self.nearMiss) > 0 then 
		local _nearMiss = table.remove(self.nearMiss, 1)
		self.curWinData["nearMiss"] = _nearMiss
	end

	return self.curWinData
end

function cls:setBtnTouchState(status)
	self._view:setBtnTouchState(status)
	self.canClick = status
end

function cls:checkCanClick(status)
	return self.canClick
end

function cls:getWinWheelValue( ... )
	if self.curWinData and self.curWinData.win then 
		local winValue = self.wheelReel[(self.curWinData.win + 1)]
		return winValue
	end
end

function cls:playWheelResule()
	self:updateLeftCount()
	local winValue = self:getWinWheelValue()
	if winValue then 
		if winValue <= self.config.jp_max_id then 
			self:playCollectWinJp()
		else
			self:playCollectWinFree()
		end
	else
		self:openFeatureBtnEvent()
	end
end

function cls:playCollectWinFree( ... ) -- 结束

	self.themeCtl:stopAllLoopMusic()
	self.bonusParent:setSingleBonusOver( "fg_wheel" )

	local t_end_event = function ( ... )
		self.bonusParent:checkIsOverBonus()
	end

	local t_changeLayer_event = function ( ... )
		self.themeCtl:changeSpinBoard("FreeSpin")
		self._view:closeFeatureScreen()
		self:changeJPZorder( 0 )

		self.jackpotVCtl:changeJackpotLabelsState(false)
	end

	self.themeCtl:playTransition(t_end_event, "free_in", t_changeLayer_event)-- 转场动画
end

function cls:playCollectWinJp(posIndex, dataInfo)
    
    local tempJpWinData = self:getNextJackpotWinValue()
    if tempJpWinData then 
	    local jpWinType = tempJpWinData.jp_win_type
	    local jpWinValue = tempJpWinData.jp_win

	 --    local isUnlock = self.themeCtl:checkFeatureIsLock(self.gameConfig.jp_config.jp_level[jpWinType])
		-- if isUnlock then 
		-- 	self:dealMusic_FadeLoopMusic(0.2, 1, 0.3)
		-- end

		local endFunc = function ( winNum )
			-- if isUnlock then 
				
			-- end
			-- self:dealMusic_FadeLoopMusic(0.2, 0.3, 1)
			self:refrshCollectWin( jpWinValue )
		end

		self.jackpotVCtl:playWinJpAnim(jpWinType)
		self.jackpotVCtl:showWinJackpotDialog(tempJpWinData, endFunc)

	else
		self:finshPlayOneWheel()
	end
end

function cls:finshPlayOneWheel( ... )
	self:openFeatureBtnEvent()
end

function cls:wheelAllTimeOver( ... )
	self:addData("feature_over", true)
	
	self.node:runAction(
			cc.Sequence:create(
				cc.DelayTime:create(1),
				cc.CallFunc:create(function ( ... )
					self:playCollectWinFree()
				end)
			))
end

function cls:onExit( )
	if self._view and self._view.onExit then 
		self._view:onExit()
	end
end
-----------------------------------------------------------------------------------------------

function cls:getGameConfig( )
	return self.themeCtl:getGameConfig()
end

function cls:playMusicByName(name, singleton, loop)
	self.themeCtl:playMusicByName(name, singleton, loop)
end

function cls:getCsbPath(file_name)
    return self.themeCtl:getCsbPath(file_name)
end

function cls:getSpineFile(file_name, notPathSpine)
    return self.themeCtl:getSpineFile(file_name, notPathSpine)
end

-- function cls:getParticleFile(file_name)
--     return self.themeCtl:getParticleFile(file_name)
-- end

function cls:curSceneAddToContent( node )
    self.themeCtl:curSceneAddToContent(node)
end

function cls:dealMusic_FadeLoopMusic( duration, beginVolume, endVolume, delay )
	self.themeCtl:dealMusic_FadeLoopMusic(duration, beginVolume, endVolume, delay)
end
--------------------------------------------------------------------------------------------------
function cls:changeJPZorder( zType )
    self.jackpotVCtl:changeJPZorder(zType)
end


return cls