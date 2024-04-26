


local parentCls = ThemeBaseView
ThemeMysteriousPixies_MainView = class("ThemeMysteriousPixies_MainView", parentCls)
local cls = ThemeMysteriousPixies_MainView

function cls:ctor( ctl )
	self._mainViewCtl = ctl
	self.gameConfig = self._mainViewCtl:getGameConfig()

	parentCls.ctor(self, ctl)

end

--------------------------------------------------------------------------------------------------------------
-- @ csb 界面初始化
function cls:initScene()

	self:_initBaseNode()

	self:_initJackpotNode() -- 初始化jackpot

	self:_initCollectFeatureNode() -- 收集相关
	
	self:_initFreeGameNode()

	self:_initBetFeatureNode()

	self:_initLogoNode()

	self:_initBgTouchEvent()

	self:_initWelcomDialog()
end

function cls:_initBaseNode( ... )
	local path = self._mainViewCtl:getCsbPath("base")

	self.mainThemeScene = cc.CSLoader:createNode(path)
	self.down_node 		= self.mainThemeScene:getChildByName("down_node")
	self.down_child 	= self.down_node:getChildByName("down_node")

	self.bgRoot 		= self.mainThemeScene:getChildByName("theme_bg")
	self.bgAnim 		= self.bgRoot:getChildByName("bg_anim")
	self.baseBg 		= self.bgRoot:getChildByName("base")
	self.freeBg 		= self.bgRoot:getChildByName("free")
	self.superBg 		= self.bgRoot:getChildByName("super")
	self.baseBg:setVisible(true)
	self.curBg = self.baseBg
	self.freeBg:setVisible(false)
	self.superBg:setVisible(false)
	
	self.bigWinNode 		= self.mainThemeScene:getChildByName("big_win_node")

	self.reelRoot 			= self.down_child:getChildByName("reel_root_node")

	self.boardAniParent 	= self.down_child:getChildByName("base_root")
	self.boardAniParent2 	= self.down_child:getChildByName("top_root")
	-- self.reelBgAnimNode 	= self.boardAniParent:getChildByName("board_bg")
	self.boardRoot 			= self.boardAniParent:getChildByName("board_root")

	self.animateNode 		= self.boardAniParent2:getChildByName("animate")
	self.scatterAnimNode 	= self.boardAniParent2:getChildByName("scatter_anim_node")
	self.collectFlyNode 	= self.boardAniParent2:getChildByName("fly_node")
	self.reelNotifyNode 	= self.boardAniParent2:getChildByName("reel_notify")
	self.themeAnimateKuang 	= self.boardAniParent2:getChildByName("animate_kuang")

	self.featureDialogDimmer = self.mainThemeScene:getChildByName("dialog_dimmer")
	self.featureDialogDimmer:setVisible(false)
	self.reelDimmer = self.down_child:getChildByName("reel_dimmer")
	self.reelDimmer:setVisible(false)

	bole.adaptScale(self.mainThemeScene,false)
	bole.adaptBottomHorizontal(self.down_node, 2)

	self.shakyNode:addChild(self.mainThemeScene)

	local baseBGSize = self.baseBg:getContentSize()
	bole.addSpineAnimationInTheme(self.bgAnim, nil, self._mainViewCtl:getSpineFile("bg_loop1"), cc.p(0, 0), "animation", nil, nil, nil, true, true)
	bole.addSpineAnimationInTheme(self.bgAnim, nil, self._mainViewCtl:getSpineFile("bg_loop2"), cc.p(0, 0), "animation", nil, nil, nil, true, true)
	local _, _bgs = bole.addSpineAnimationInTheme(self.baseBg, nil, self._mainViewCtl:getSpineFile("bg_loop3"), cc.p(baseBGSize.width/2, baseBGSize.height/2), "animation", nil, nil, nil, true, true)
	_bgs:setScale(0.8)
	bole.addSpineAnimationInTheme(self.reelRoot, nil, self._mainViewCtl:getSpineFile("reel_loop"), cc.p(640, 360), "animation", nil, nil, nil, true, true)
	
	-- self:initChestEvent()
end

------------------------------------------------------------------------------------------------------------------------------------------------
function cls:initChestEvent( ... )

	local touchFunc1 = function ( ... )
		self.isChestTremble = false
		self:playBigWinEffect()
	end
	local touchFunc2 = function ( ... )
		self.isChestTremble = true
		self:playBigWinEffect()
		self.isChestTremble = false
	end

	local touchFunc3 = function ( ... )
		self._mainViewCtl:getCollectViewCtl():fullCollectAnimation()
	end

	local touchFunc4 = function ( ... )
		self.down_child:setVisible(false)
	end

	local touchFunc5 = function ( ... )
		self.down_child:setVisible(true)
	end

	local funcList = {
		touchFunc1, touchFunc2, touchFunc3, touchFunc4, touchFunc5 
	}
	local imgList = {
		"theme231_s_1.png", 
		"theme231_s_2.png",
		"theme231_s_3.png",
		"theme231_s_4.png",
		"theme231_s_5.png",
	}
	self.touchBtnList = {}
	local baseY = 243
	for i = 1, table.nums(imgList) do
		local touchBtn = Widget.newButton(funcList[i], imgList[i], imgList[i], imgList[i], true) --10
		self.touchBtnList[i] = touchBtn
		touchBtn:setPosition(650, baseY + (-120*(i-1)))
		self.mainThemeScene:addChild(touchBtn, 200)
	end
end
-------------------------------------------------------------------------------------------
function cls:addBgTouchAnim( pos )

	local pos = self.bgRoot:convertToNodeSpace(pos)

	local p1 = cc.ParticleSystemQuad:create(self._mainViewCtl:getParticleFile("bg_click"))
	self.bgRoot:addChild(p1)
	p1:setPosition(pos)
	p1:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			p1:setEmissionRate(0)
			self.bgCanPick = true
		end),
		cc.RemoveSelf:create()
	))
end


function cls:_initBgTouchEvent()
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)

	local function onTouchBegan (touch, event)
        if self.bgCanPick then
            self.bgStartPosition = cc.p(touch:getLocation())
            return true
        end
        return true
    end
    local function onTouchCancelled (touch, event)
        self.bgStartPosition = nil
    end

	local function onTouchEnded (touch, event)
		--并且在某个范围内才行
        if self.bgStartPosition and self.bgCanPick then
            local target = event:getCurrentTarget()
			local location = touch:getLocation()
			if self:judgmentEffectiveCon(location) then 
				self:addBgTouchAnim(location)
			end
        end
    end

	self.bgCanPick = true
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED) -- 同楼上
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = self.baseBg:getEventDispatcher() -- 通过它管理当前节点（场景、层、精灵等）的所有事件的分发。
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.baseBg)-- 添加一个事件监听器到事件派发器
end

function cls:judgmentEffectiveCon(pos)
	if not pos then return false end 
	local topHeight = 67 * HEADER_FOOTER_SCALE
	local bottomHeight = 93 * HEADER_FOOTER_SCALE
	if (pos.y <= FRAME_HEIGHT - topHeight) and (pos.y >= bottomHeight) then 
		return true
	end
	return false
end

-------------------------------------------------------------------------------------------------

function cls:_initJackpotNode( ... )

	local nodeList = self:getSpecialFeatureRoot("jackpot") 
	if nodeList then 
	    self._mainViewCtl:getJpViewCtl():initLayout(nodeList)
	end
end

function cls:_initCollectFeatureNode( )
	local nodesList = self:getSpecialFeatureRoot("collect") 
	if nodesList then 
	    self._mainViewCtl:getCollectViewCtl():initLayout(nodesList)
	end
end

function cls:_initFreeGameNode(  )
	local nodesList = self:getSpecialFeatureRoot("free") 
	if nodesList then 
	    self._mainViewCtl:getFreeVCtl():initLayout(nodesList)
	end
end

function cls:_initBetFeatureNode(  )
	local nodesList = self:getSpecialFeatureRoot("bet_feature") 
	if nodesList then 
	    self._mainViewCtl:getBetFeatureVCtl():initLayout(nodesList)
	end
end

function cls:_initLogoNode( ... )
	self.longLogoNode = self.down_child:getChildByName("long_logo_node")

	if bole.getAdaptationWidthScreen(0.78) then 
		self.longLogoNode:setVisible(true)
		
		bole.addSpineAnimationInTheme(self.longLogoNode, nil, self._mainViewCtl:getSpineFile("logo_name"), cc.p(0, 370), "animation", nil, nil, nil, true, true)
    else
		self.longLogoNode:setVisible(false) 
	end
	
end
----------------------------------------------------------------------------------------
function cls:_initWelcomDialog(  )
	self.welcomeNode = self.down_child:getChildByName("welcome")
	self.welcomeCloseBtn = self.welcomeNode:getChildByName("w_close_btn")
	self.welcomeNode:setVisible(false)

    local function tipCloseOnTouch(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
			self:closeWelcomeTip()
        end
    end
	self.welcomeCloseBtn:addTouchEventListener(tipCloseOnTouch)	
	self.welcomeCloseBtn:setSwallowTouches(true)
end

function cls:playWelcomeDialog()
	self:showFeatureBoardDimmer( "board", "show", nil, 255 )
	self.welcomeNode:setVisible(true)
	local data = {}
	data.file = self._mainViewCtl:getSpineFile("dialog_welcome")
	data.parent = self.welcomeNode
	data.animateName = "animation2"
	local _, s = bole.addAnimationSimple(data)
	self.welcomeD = s

	self.showWelcomeTip = true

	self.welcomeD:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(38/30),
			cc.CallFunc:create(function ( ... )
				self.welcomeCloseBtn:setTouchEnabled(true)
			end),
			cc.DelayTime:create((159-15-38)/30),
			cc.CallFunc:create(function ( ... )
				self:showFeatureBoardDimmer( "board", "hide", nil, 255 )
			end),
			cc.DelayTime:create(15/30),
			cc.CallFunc:create(function ( ... )
				self.showWelcomeTip = false
				self.welcomeCloseBtn:setTouchEnabled(false)
				self.welcomeNode:setVisible(false)
			end)
		))
end

function cls:closeWelcomeTip( showNode)
	self.welcomeCloseBtn:setTouchEnabled(false)

	if not bole.isValidNode(self.welcomeD) then return end
	if not self.showWelcomeTip then return end
	
	self:showFeatureBoardDimmer( "board", "hide" )

	self.welcomeD:runAction(
		cc.Sequence:create(
			cc.FadeOut:create(0.2),
			cc.RemoveSelf:create()))

	self.showWelcomeTip = false
end

function cls:onSpinStartMainView( ... )
	self:closeWelcomeTip()
end
-------------------------------------------------------------------------------------------
function cls:getSpecialFeatureRoot( rType )
	if rType == "jackpot" then 
		return {
			self.down_child:getChildByName("jp_parent1"), 
			self.down_child:getChildByName("jp_parent2"),
			self.down_child:getChildByName("jp_tip_parent"),
		}

	elseif rType == "collect" then 
		return {
			self.down_child:getChildByName("collect_node"), 
			self.collectFlyNode,
			self.down_child:getChildByName("c_tip_node"), 
		} -- , tip_node, tip_btn
	
	elseif rType == "bet_feature" then 
		return {
			self.boardAniParent:getChildByName("symbol_down"), 
			self.boardAniParent2:getChildByName("symbol_up"),
			self.boardAniParent2:getChildByName("symbol_explode")
		}

	elseif rType == "free" then 
		local freeNode = self.down_child:getChildByName("free_tip_node")
		return {freeNode, self.collectFlyNode}
		
	elseif rType == "bet_bonus" then 
		return {self.down_child:getChildByName("map_node")}
	elseif rType == "wheel_bonus" then 
		return {self.down_child:getChildByName("map_node")}
		
	end
end

----------------------------------------------------------------------

function cls:getShakyNode( ... )
	return self.shakyNode
end

function cls:resetBoardShowNode( pType , isAnimate )
	local board_type_config = self.gameConfig.SpinBoardType

	local boardType = board_type_config[pType]
	
    local showBg
    if boardType == board_type_config.Normal then -- normal情况下 需要更改棋盘底板
    	showBg = self.baseBg

    elseif boardType == board_type_config.FreeSpin then
    	showBg = self.freeBg
    end

    if showBg then 
		if self.curBg ~= showBg then 
			self.curBg:setVisible(false)
			showBg:setVisible(true)
			self.curBg = showBg
		end
    end
end

--------------------------------------------------------------------------------------------------------------

function cls:getBoardNodeList( ... )
	return self.boardNodeList
end

---------------------------------------------------------------------------
function cls:showFeatureBoardDimmer( dType, state, root, animData )
	if dType == "board" then 
		self:dialogPlayLineAnim(state, self.reelDimmer, root, animData)
	-- elseif dType == "random" then 
	-- 	self:dialogPlayLineAnim(state, self.featurDimmer)
	-- elseif dType == "down_child" then 
	-- 	self:dialogPlayLineAnim(state, self.childDialogDimmer)
	-- else
	elseif dType == "scene" then 
		self:dialogPlayLineAnim(state, self.featureDialogDimmer, root, animData)
	end
end

----------------------------------------------------------------------------------------------------------------------------------
--@ cell 相关

-- function cls:adjustWithTheCellSpriteUpdate( theCellNode, key, col ) -- 删除掉 tip 动画
-- 	parentCls.adjustWithTheCellSpriteUpdate(self, theCellNode, key, col)

-- 	if bole.isValidNode(theCellNode.tipNode) then 
-- 		theCellNode.tipNode:removeAllChildren()
-- 	end
-- 	if bole.isValidNode(theCellNode.coinSprite) then 
-- 		theCellNode.coinSprite:removeAllChildren()
-- 	end

-- end

function cls:updateCellSprite(theCellNode, key, col, isShowResult, isReset, isNotChange)

	local theCellFile = self._mainViewCtl.pics[key]

	local keyData = self._mainViewCtl:checkUpdateSymbolKey(key)
	if keyData then 
		key = keyData.fileKey
		theCellFile = self._mainViewCtl.pics[keyData.fileKey]
	end

	if not theCellFile then 
		print("whj: key, theCellFile", key, theCellFile)
	end

	local theCellSprite = theCellNode.sprite
	bole.updateSpriteWithFile(theCellSprite, theCellFile)
	theCellNode.key 	  = key
	theCellNode.curZOrder = 0

	------------------------------------------------------------
	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col, isShowResult, isReset )	

	local theKey = theCellNode.key

	theCellSprite:setAnchorPoint(cc.p(0.5, 0.5))
	if self._mainViewCtl.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self._mainViewCtl.symbolZOrderList[theKey]
	end
	if self._mainViewCtl.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self._mainViewCtl.symbolPosAdjustList[theKey])
	else
		theCellSprite:setPosition(cc.p(0,0))
	end	
end

function cls:changeCellSpriteByPos( col, row, key )
	local cell = self:getCurSpinLayer().spins[col]:getRetCell(row)
	self:updateCellSprite(cell, key, col, true, true, true)
	cell.sprite:setVisible(true)
	cell:setVisible(true)
end

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--@动画相关
function cls:drawPayLineItem(reel, row, specials, itemList, effectStatus, tipIndex,parent)
	local sprite = cc.Sprite:create()
	sprite:setPosition(self._mainViewCtl:getCellPos(reel,row))
	local tt 		= itemList[reel][row]
	local action    = self:getItemAnimate(tt, reel, row, effectStatus,parent) -- 获得相应动画
	if action then	
		local s = self.spinLayer.spins[reel]:getRetCell(row) -- 获得相应位置 
		s:setCascadeOpacityEnabled(true) -- 子节点透明度随父节点变化
		if type(action) == "table" then
			local i = action[2]
			s = s:getChildren()[i]
			action = action[1]
		end
		s:runAction(action)
	end
	self:playCellRoundEffect(sprite, tt, reel, row, effectStatus) -- 播放中奖连线 调用每个主题本身的方法, 直接播放spine 动画来实现
	return sprite
end

function cls:getItemAnimate(item, col, row, effectStatus,parent)
	local spineItemsSet = Set({ 
		1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	})

	local itemData = self._mainViewCtl:checkUpdateSymbolKey(item)

	if self._mainViewCtl:getBetFeatureVCtl():playStackWildWinAnim( col, row ) then 
    elseif (itemData and spineItemsSet[itemData.fileKey]) or spineItemsSet[item] then 
		if effectStatus == "all_first" then
			self:playItemAnimation(item, col, row, parent)
		else
			self:playOldAnimation(col,row)
		end
		return nil
	else
		return self:getItemAnimateScale_120(item)
	end
end


function cls:playItemAnimation(item, col, row, parent) -- 修改这个方法，让有动画的symbol 在animationNode上面播放动画
	local animateName = "animation"
	local itemData = self._mainViewCtl:checkUpdateSymbolKey(item, true)
	local fileName = itemData and itemData.fileKey or item

	local cell = self.spinLayer.spins[col]:getRetCell(row)
	local pos		= self._mainViewCtl:getCellPos(col,row)
	local spineFile = self._mainViewCtl:getPic("spine/item/" .. fileName .. "/spine")

	local _, s1	= bole.addSpineAnimationInTheme(parent, row, spineFile, pos, animateName, nil, nil, nil, true)

	self.animNodeList = self.animNodeList or {}
	 
	self.animNodeList[col.."_"..row] = {}
	self.animNodeList[col.."_"..row][1] = s1 
	self.animNodeList[col.."_"..row][2] = animateName

	cell:setVisible(false) -- cell.sprite:setVisible(false)
end

function cls:playOldAnimation(col,row)
	self.animNodeList = self.animNodeList or {}
	if self.animNodeList[col.."_"..row] then 
		local temp = self.animNodeList[col.."_"..row]
		local node = temp[1]
		local animationName = temp[2]

		if bole.isValidNode(node) and animationName then 
			bole.spChangeAnimation(node, animationName, false)
		end

		local node2 = temp[3]
		local animationName2 = temp[4]

		if bole.isValidNode(node2) and animationName2 then 
			bole.spChangeAnimation(node2, animationName2, false)
		end
	end
end

function cls:addReelNotifyEffectAnim( pos, spineFile )
	local _, s1 = bole.addSpineAnimationInTheme(self.reelNotifyNode, 20, spineFile, pos, "animation", nil, nil, nil, true, true) -- , true
	local p1
	-- if a_name == "scatter" then 
	-- 	p1 = bole.createSpriteWithFile("#theme225_baes_13.png")
	-- 	p1:setPosition(pos)
	-- 	p1:setScale(2.05)
	-- 	self.reelBgAnimNode:addChild(p1)
	-- end
	self:playSymbolAnticState("antic")

	return s1, p1
end

function cls:stopDrawAnimate() -- 可能存在 手动调用的可能
	if bole.isValidNode(self.scatterAnimNode) then 
		self.scatterAnimNode:removeAllChildren()
		self.reelNotifyNode:removeAllChildren()
		-- self.collectFlyNode:removeAllChildren()
		
		self.animNodeList = nil
		self.scatterTipList = nil

		parentCls.stopDrawAnimate(self)

		self:clearBGEffect()
	end
end

function cls:addItemSpine(item, col, row, isLoop)
	local layer			= self.scatterAnimNode
	local animName		= "animation"..self.gameConfig.symbol_config.anim_suffix.win
	local pos			= self._mainViewCtl:getCellPos(col, row)
	local spineFile		= self._mainViewCtl:getSpineFile(item)

	local cell = self.spinLayer.spins[col]:getRetCell(row)
	cell:setVisible(false)

	local _, s1 = bole.addSpineAnimationInTheme(layer, 100, spineFile, pos, animName, nil, nil, nil, isLoop, isLoop)
end

function cls:playBGEffectByCol(key, pCol)
end

function cls:clearBGEffect()
	-- self.reelDownAnimNode:removeAllChildren()
end

function cls:playSymbolNotifyEffect( pCol, reelSymbolState ) 

	local symbol_config = self.gameConfig.symbol_config
	for  key , list in pairs(self._mainViewCtl.notifyState[pCol]) do
		
		for _, crPos in pairs(list) do
			local cell = nil
			if self._mainViewCtl:checkIsFastStop() then 
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2])
			else
				cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2]+1)
			end

			if cell and bole.isValidNode(cell.tipNode) then
				local animParent = cell.tipNode
				cell.tipNode:removeAllChildren()

				local tipAnim = self:playSpecialSymbolAnim(animParent, crPos[3] or key, symbol_config.anim_suffix.notify)
				cell.symbolTipAnim = tipAnim
				cell.sprite:setVisible(false)

				local data = {}
				data.file = self._mainViewCtl:getSpineFile("item11bg")
				data.parent = animParent
				data.animateName = "animation"
				data.zOrder = -1
				local _, s = bole.addAnimationSimple(data)

				local posN = self._mainViewCtl:getCellPos(crPos[1], crPos[2])
				tipAnim:runAction(cc.Sequence:create(
					cc.DelayTime:create(7 / 30), -- 触底的时间延迟
					cc.CallFunc:create(function ( ... )
						if key == self.gameConfig.special_symbol.scatter and bole.isValidNode(tipAnim) then
							-- local posW = bole.getWorldPos(tipAnim)
							-- local posN = bole.getNodePos(self.animateNode, posW)

							bole.changeParent(tipAnim, self.animateNode)
							tipAnim:setPosition(posN)
						end

						if bole.isValidNode(s) then 
							bole.changeParent(s, self.animateNode, -1)
							s:setPosition(posN)
						end
					end)
				))
				tipAnim:addAnimation(0, tipAnim.firstName..symbol_config.anim_suffix.loop, true)
				
				self.scatterTipList = self.scatterTipList or {}
				table.insert(self.scatterTipList, tipAnim)
			end	
		end
		-- self:playBGEffectByCol(key, pCol)
	end
end

function cls:playSymbolStopLoopEffect(pCol)
	local checkHasLoopList = {}
	if pCol == 1 or pCol == 3 or pCol == 5 then 
		checkHasLoopList = {
			{pCol, 1}, 
			{pCol, 2}, 
			{pCol, 3},
			{pCol, 4},
			{pCol, 5},
		}
	end

	local symbol_config = self.gameConfig.symbol_config
	for _, crPos in pairs(checkHasLoopList) do
		local cell = nil
		if self._mainViewCtl:checkIsFastStop() then 
			cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2])
		else
			cell = self.spinLayer.spins[crPos[1]]:getRetCell(crPos[2]+1)
		end

		if 
			cell 
			and symbol_config.loop_symbol_list[cell.key] 
			and not(bole.isValidNode(cell.symbolTipAnim)) 
			and bole.isValidNode(cell.tipNode) 
			then
			
			cell.tipNode:removeAllChildren()

			local animParent = cell.tipNode

			local tipAnim = self:playSpecialSymbolAnim(animParent, cell.key, symbol_config.anim_suffix.loop, nil, nil, true )
			cell.sprite:setVisible(false)
			cell.symbolTipAnim = tipAnim

			local posN = self._mainViewCtl:getCellPos(crPos[1], crPos[2])
			tipAnim:runAction(cc.Sequence:create(
				cc.DelayTime:create(7 / 30), -- 触底的时间延迟
				cc.CallFunc:create(function ( ... )
					if cell.key == self.gameConfig.special_symbol.scatter and bole.isValidNode(tipAnim) then
						-- local posW = bole.getWorldPos(tipAnim)
						-- local posN = bole.getNodePos(self.animateNode, posW)

						bole.changeParent(tipAnim, self.animateNode)
						tipAnim:setPosition(posN)
					end
				end)
			))
		end	
	end
end

function cls:playSpecialSymbolAnim( node, key, _addName, pos, zOrder, isLoop )
	local firstName = "animation"
	local fileKey = "item"..key
	local pos = pos or cc.p(0,0)
	local zOrder = zOrder or 10

	local spineFile	= self._mainViewCtl:getSpineFile(fileKey)

	local animNameAdd = _addName or ""
	local animateName = firstName..animNameAdd

	local _, s = bole.addSpineAnimationInTheme(node, zOrder, spineFile, pos, animateName,nil,nil,nil,true, isLoop)
	s.firstName = firstName

	return s
end

function cls:playSymbolAnticState( aType )
	if not aType then return end
	if not self.scatterTipList then return end

	local animType = self.gameConfig.symbol_config.anim_suffix[aType]
	for _, node in pairs(self.scatterTipList) do 
		if bole.isValidNode(node) and node.firstName then 
			node:setAnimation(0, node.firstName..animType, true)
		end
	end
end
--------------------------------------------------------------------------------------------------------------------------------

function cls:initBoardTouchBtn(boardConfigList, pBoardNodeList)
	for boardIndex, theConfig in pairs(boardConfigList) do
		
		local colReelCnt = theConfig["colReelCnt"]
		local boardBasePos, boardW, boardH
		for reelIndex, config in pairs(theConfig["reelConfig"]) do
			if (reelIndex - 1)%self.gameConfig.theme_config.base_col_cnt + 1 == 1 then
				boardBasePos = config["base_pos"]
				boardW = config["cellWidth"]*colReelCnt
				boardH = config["cellHeight"]*config["symbolCount"]
				self:initTouchSpinBtn(boardBasePos, boardW, boardH, pBoardNodeList[boardIndex])
			end
		end
	end
end

--点击棋盘进行spin
function cls:initTouchSpinBtn(base_pos, boardW, boardH, parent)
    local unitSize = 10
    local parent = parent or self.boardRoot
    local img = "commonpics/kong.png"
    local touchSpin = function()
    	self._mainViewCtl:footerCopySpinBtnEvent()
    end
    local touchBtn = Widget.newButton(touchSpin, img, img, img, false) --10
    touchBtn:setPosition(base_pos)
    touchBtn:setAnchorPoint(cc.p(0, 0))
    touchBtn:setScaleX(boardW / unitSize)
    touchBtn:setScaleY(boardH / unitSize)
    parent:addChild(touchBtn)
end
----

function cls:initBoardNodesByReelSingle( reelNodes, theConfig, reelZorder, theBoardNode, boardIndex )
	local colReelCnt = theConfig["colReelCnt"]
	self.clipData["reel_single"] = {}

	local clipNode = nil
	local reelNode = nil

	for reelIndex,config in ipairs(theConfig["reelConfig"]) do
		if (reelIndex-1)%colReelCnt == 0 then 
			reelNode = cc.Node:create()
			reelNode:setLocalZOrder(reelZorder)
			
			local vex = {
				config["base_pos"], -- 第一个轴的左下角  下左边界
				cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*colReelCnt, 0)),  -- 下右边界
				cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*colReelCnt, config["cellHeight"]*config["symbolCount"])),-- 上右边界
				cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"]*config["symbolCount"])),-- 上左边界
			}
			if theConfig["allow_over_range"] then
				vex[1] = cc.pAdd(vex[1], cc.p(-config["cellWidth"], 0))
				vex[4] = cc.pAdd(vex[4], cc.p(-config["cellWidth"], 0))

				vex[2] = cc.pAdd(vex[2], cc.p(config["cellWidth"], 0))
				vex[3] = cc.pAdd(vex[3], cc.p(config["cellWidth"], 0))
			end
			local stencil = cc.DrawNode:create()
			stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))

			local clipAreaNode = cc.Node:create()
			clipAreaNode:addChild(stencil)
			clipNode = cc.ClippingNode:create(clipAreaNode)
			   
			theBoardNode:addChild(clipNode)	
			clipNode:addChild(reelNode)
			self:addBoardMaskNode(reelNode, config["base_pos"], reelIndex)

		end

		reelNodes[reelIndex] = reelNode

	end
end
--------------------------------------------------------------------------------------------------------------------------------
function cls:activeNodeWordPos( )
	if bole.isValidNode(self.activePosNode) then 
		return bole.getWorldPos(self.activePosNode)
	end
end
--------------------------------------------------------------------------------------------------------------------------------
-- big_win 
function cls:playBigWinEffect( ... )

	self._mainViewCtl:playMusicByName("big_win")

	local data = {} -- 播放动画,
	data.file = self._mainViewCtl:getSpineFile("big_win")
	data.parent = self.bigWinNode
	bole.addAnimationSimple(data)

	local data = {} -- 播放动画,
	data.file = self._mainViewCtl:getSpineFile("big_win2")
	data.parent = self.down_child
	bole.addAnimationSimple(data)

	self.superBg:runAction(
		cc.Sequence:create(
			cc.Show:create(),
			cc.FadeIn:create(0.3),
			cc.DelayTime:create(1.1),
			cc.FadeOut:create(0.6),
			cc.Hide:create()))

	-- if self.isChestTremble then 
	-- 	self.footerTremble = ScreenShaker.new(self._mainViewCtl.footer, 1, function() self.footerTremble = nil end)
	-- 	self.footerTremble:run()
	-- 	self.headerTremble = ScreenShaker.new(self._mainViewCtl.header, 1.5, function() self.headerTremble = nil end)
	-- 	self.headerTremble:run()
	-- end

	-- self.sceneTremble = ScreenShaker.new(self.shakyNode, 1.5, function() self.reelTremble = nil end)
	-- self.sceneTremble:run()
	-- self.reelTremble = ScreenShaker.new(self.reelRoot, 1.5, function() self.reelTremble = nil end)
	-- self.reelTremble:run()
	-- self.logoTremble = ScreenShaker.new(self.longLogoNode, 1.5, function() self.reelTremble = nil end)
	-- self.logoTremble:run()
end

function cls:stopBigWinEffect( ... )
	self.bigWinNode:removeAllChildren()

	-- if self.footerTremble then 
	-- 	self.footerTremble:stop()
	-- end
	-- if self.headerTremble then 
	-- 	self.headerTremble:stop()
	-- end
	-- if self.sceneTremble then 
	-- 	self.sceneTremble:stop()
	-- end
	-- if self.reelTremble then 
	-- 	self.reelTremble:stop()
	-- end
end
--------------------------------------------------------------------------------------------------------------------------------
function cls:addSpecialSpeed(specialTag)
	-- 添加出特效音效控制 

	self._mainViewCtl:playMusicByName("anticipation2") -- 播放龙的动画 暂时放在动画层上面 播放
	
	local data = {} -- 播放动画,
	data.file = self._mainViewCtl:getSpineFile("special_speed")
	data.parent = self.down_child
	local _,s = bole.addAnimationSimple(data)

	self:showFeatureBoardDimmer( "board", "show", nil, 255)
	
	s:runAction(
		cc.Sequence:create(
			cc.DelayTime:create((70-15)/30),
			cc.CallFunc:create(function ( ... )
				self:showFeatureBoardDimmer( "board", "hide", nil, 255 )
			end)
		))

end

function cls:getDownChildNode(  )
	return self.down_child
end

--------------------------------------------------------------------------------------------------------------------------------

function cls:onExit( ... )
	if self.reelTremble then
		self.reelTremble:stop()
	end
end



