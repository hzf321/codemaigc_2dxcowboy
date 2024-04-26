-- @Author: xiongmeng
-- @Date:   2020-11-12 17:59:15
-- @Last Modified by:   xiongmeng
-- @Last Modified time: 2020-12-03 13:46:44
local cls = class("KingOfEgypt_MapView")

function cls:ctor( ctl, mapParent )
	self.ctl = ctl
	self.gameConfig = self.ctl:getGameConfig()
	self.mapConfig = self.gameConfig.map_config
	self.mapPathConfig = self.mapConfig.map_path_config
    self.mapPosConfig = self.mapConfig.map_pos_config
    self.userStartPos = self.mapPosConfig.userStartPos
    self.panelDisX = self.mapPosConfig.panelDisX
    self.buildingStype = self.mapConfig.map_stype
    self.offSetY = 120
	self.mapParent = mapParent
	-- self:_initNode()
	-- self:_initLayout()
end
function cls:_initNode( ... )
	local csbList = self.gameConfig.csb_list
	local path = self.ctl:getPic(csbList.map)
	self.mapRoot = libUI.createCsb(path)
	self.mapParent:addChild(self.mapRoot)
end
function cls:_initLayout( ... )
    self.dimmerNode = self.mapRoot:getChildByName("dimmer_node")
    self.dimmer = self.dimmerNode:getChildByName("dimmer")

    self.root = self.mapRoot:getChildByName("root")
    self.rootPanel = self.root:getChildByName("show_panel")

    self.rootParent = self.rootPanel:getChildByName("map_parent")
    self.root_child = self.rootParent:getChildByName("root_child")

    self:addOutSizeUserNode()

    -- local root_child = self.root:getChildByName("root_child")
    local bg_panel = self.root_child:getChildByName("bg_panel")
    local bg_node  = bg_panel:getChildByName("map_bg")
    local map_node = bg_panel:getChildByName("map_node")
    local user_node = bg_panel:getChildByName("user_node")
    bg_panel:setContentSize(self.mapPosConfig.contentSize)

    self.userAniNode = user_node:getChildByName("theme325_map_2")

    self.bgAniNode = map_node:getChildByName("bg_ani_node")
    self.mapStepNode = map_node:getChildByName("step_node")
    self.backMapBtn = self.root_child:getChildByName("btn_close")

    self.mapContainerNode = bg_panel
    self.mapContainerInnerNode = self.mapContainerNode:getInnerContainer()
    self:addConScroll()
    bg_panel:setScrollBarEnabled(false) -- 设置两侧的栏不展示
    bg_panel:setClippingEnabled(true)
    self:_addBtnSpine()
    self:_addBgSpine()
    -- self:_addUserAniSpine()
    self:_createMapRoadBuild()
    self:_addMapBtnEvent()
    self:_adaptMapBG()
end
function cls:addConScroll()
    local function scrollViewDidScroll()
        if self.userOtherNode then
            local pos = self:getOtherUserPos()
            self.userOtherNode:setPosition(pos)
        end
    end
    -- 该回调函数将会在视图发生滚动时触发。
    self.mapContainerNode:addEventListenerScrollView(scrollViewDidScroll)
end
function cls:addOutSizeUserNode()
    self.userPanel = self.root_child:getChildByName("user_panel")
    self.userOtherNode = self.userPanel:getChildByName("user_node")
    local userFile = self.ctl:getSpineFile("map_user")
    local _, spine = bole.addSpineAnimation(self.userOtherNode, nil, userFile, cc.p(0,-40), "animation1", nil, nil, nil, true, true)
    self.userOtherNode.userSpine = spine
    self.userPanel:setSwallowTouches(false)
end
function cls:_addBtnSpine( ... )
    if self.backMapBtn then
        -- local file = self.ctl:getSpineFile("map_back_btn")
        -- local size = self.backMapBtn:getContentSize()
        -- local pos = cc.p(size.width/2, size.height/2)
        -- bole.addSpineAnimation(self.backMapBtn, nil, file, pos, "animation", nil, nil, nil, true, true)
    end
end
function cls:_addBgSpine( ... )
    -- local file = self.ctl:getSpineFile("map_water")
    -- local _, spine = bole.addSpineAnimation(self.bgAniNode, nil, file, cc.p(0,1090), "animation", nil, nil, nil, true, true)
    -- spine:setScale(0.5)
    -- local boxFile = self.ctl:getSpineFile("map_box")
    -- bole.addSpineAnimation(self.bgAniNode, nil, boxFile, cc.p(-191,248), "animation", nil, nil, nil, true, true)
end

function cls:showParentEnable( enable )
	self.mapParent:setVisible(enable)
end
-- function cls:_addUserAniSpine( ... )
--     -- self.userAniNode:removeAllChildren()
--     -- local aniFile = self.ctl:getSpineFile("map_user")
--     -- local _, spine = bole.addSpineAnimation(self.userAniNode, nil, aniFile, cc.p(0,30), "animation2", nil, nil, nil, true, true)
--     -- self.userAniNode.userSpine = spine
-- end
function cls:_createMapRoadBuild( ... )
    local buildingConfig = self.mapConfig.map_building_config
    local map_building_user_pos = self.mapConfig.map_building_user_pos
    self.mapStepList = {}
    self.mapBuildingList = {}
    local index = 1
    for key = 1, self.mapConfig.buildingLevel do
        local node = self.mapStepNode:getChildByName("step"..key)
        local oldPosX = node:getPositionX()
        node:setPositionX(oldPosX + 100)
        if buildingConfig[key] then -- 说明是大节点
            self.mapBuildingList[index] = node
            self:_createBigBuild(node, key, buildingConfig[key])
            node.userAddPosY = map_building_user_pos[#buildingConfig[key]]
            node.bigBuildIndex = index
            index = index + 1
        else
            self:_createSmallBuild(node, key)
        end
        self.mapStepList[key] = node
    end
end
function cls:_createBigBuild( node, key, boosterInfo )
    local map_wild_up = self.mapConfig.map_wild_up
    local map_wild_down = self.mapConfig.map_wild_down
    local map_wild_down0 = self.mapConfig.map_wild_down0
    local map_wild_down1 = self.mapConfig.map_wild_down1
    local map_wild_pos = self.mapConfig.map_wild_pos
    local getImage = self.mapConfig.map_image.booster_get_image
    
    local imgBg = node:getChildByName("image_top")
    local finishCover = node:getChildByName("cover")
    local labelCurrent = node:getChildByName("label_current") -- 当前的数量
    local labelStep = node:getChildByName("label_step")
    local labelNum = labelStep:getChildByName("label") 
    local image_wild = node:getChildByName("image_wild")
    local step_target = node:getChildByName("step_target")
    local stepList = {}
    local infoLen = #boosterInfo
    if image_wild then
        bole.updateSpriteWithFile(image_wild, "#theme325_map_"..key..".png")
        local basePosY = image_wild:getPositionY()
        if map_wild_up[key] then
            image_wild:setPositionY(basePosY + map_wild_pos.up)
        elseif map_wild_down0[key] then
            image_wild:setPositionY(basePosY + map_wild_pos.down0)
        elseif map_wild_down[key] then
            image_wild:setPositionY(basePosY + map_wild_pos.down)
        elseif map_wild_down1[key] then
            image_wild:setPositionY(basePosY + map_wild_pos.down1)
        end
    end
    for skey, sval in ipairs(boosterInfo) do
        local stepNode = step_target:getChildByName("step"..skey)
        if stepNode then
            local spriteGet = bole.createSpriteWithFile(getImage)
            local spriteWrong = bole.createSpriteWithFile("commonpics/common_black.png")
            -- if skey == 1 then 
            --     spriteGet:setPositionY(-1)
            -- end
            local _getSpSize = spriteGet:getContentSize()
            local _wrongSpSize = spriteWrong:getContentSize()
            spriteGet:setScale(4.25*_wrongSpSize.width/_getSpSize.width, 0.46*_wrongSpSize.height/_getSpSize.height)
            spriteGet:setVisible(false)
            step_target:addChild(spriteGet, -1)
            spriteGet:setPosition(stepNode:getPositionX() + 1, stepNode:getPositionY())

            spriteWrong:setScale(4.25, 0.46)
            spriteWrong:setVisible(false)
            spriteWrong:setOpacity(150)
            stepNode:addChild(spriteWrong, 1)

            stepNode.spriteGet = spriteGet
            stepNode.spriteWrong = spriteWrong
            bole.setEnableRecursiveCascading(stepNode, true)
            local getTip = stepNode:getChildByName("get")
            bole.updateSpriteWithFile(getTip, "#theme325_map_get"..sval..".png")
            if sval == 2 then
                local stickNum = self.ctl:getStickNums(key)
                local spriteNum = bole.createSpriteWithFile("#theme325_map_stick"..stickNum..".png")
                stepNode:addChild(spriteNum)
                
                if stickNum ~= 1 then
                    spriteNum:setPosition(-20, 1)
                    bole.updateSpriteWithFile(getTip, "#theme325_map_get"..sval.."s.png")
                else 
                    spriteNum:setPosition(-20, 1)
                end
            elseif sval == 8 then
                local winMul = self.ctl:getAllWinsMul(key)
                local spriteNum = bole.createSpriteWithFile("#theme325_map_allwin"..winMul..".png")
                stepNode:addChild(spriteNum)
                spriteNum:setPosition(13, 1)
            end
            stepList[skey] = stepNode
        end
    end
    -- boosterInfo 的信息
    labelNum:setString(key)
    labelCurrent:setString("0")
    finishCover:setVisible(false)

    node.stepList = stepList
    node.labelCurrent = labelCurrent
    node.finishCover = finishCover
    node.imgBg = imgBg
end
function cls:_createSmallBuild( node, key )
    local labelStep = node:getChildByName("label_step")
    local labelNum = labelStep:getChildByName("label") 
    local currentImage = node:getChildByName("image1")
    labelNum:setString(key)
    node.currentImage = currentImage
end
function cls:_addMapBtnEvent( ... )
	local onTouch = function ( obj, eventType )
        if eventType == ccui.TouchEventType.ended then
            if (not self.ctl.isOpenMapStatus) then
                return
            end
            self.ctl:playMusicByName("common_click")
            self:enableMapbtnClick(false)
            self.ctl:exitMapScene()
        end
    end
    self.backMapBtn:addTouchEventListener(onTouch)
end
function cls:_adaptMapBG( ... )
    -- bole.adaptScale(self.mapRoot)
end
--@user jump
function cls:updateUserAniSpine( ... )
	self.userOtherNode.userSpine:setAnimation(0, "animation2", false)
    self.userOtherNode.userSpine:addAnimation(0, "animation1", true)
end
function cls:setUserIconPosition( index )
    local pos = self:getCurrentUsetPos(index)
    self.userAniNode:setVisible(false)
    self.userAniNode:setPosition(pos)
    self.userOtherNode:setPosition(self:getOtherUserPos())
end
function cls:getOtherUserPos()
    local pos = bole.getWorldPos(self.userAniNode)
    local otherPos = bole.getNodePos(self.userPanel, pos)
    return otherPos
end
function cls:getCurrentUsetPos(index)
    if index and index > 0 then
        local offSetY = self.offSetY
        if self.mapStepList[index].userAddPosY then
            offSetY = self.mapStepList[index].userAddPosY
        end
        local pos = cc.pAdd(cc.p(self.mapStepList[index]:getPosition()), cc.p(0, offSetY))
        return pos
    else
        return self.userStartPos
    end
end
function cls:showUserIconForwardPosition( next_index )
    local start_pos = self:getCurrentUsetPos(next_index - 1)
    local endPosUser = self:getCurrentUsetPos(next_index)
    local disX = endPosUser.x - start_pos.x
    local disY = endPosUser.y - start_pos.y
    self.userAniNode:setPosition(start_pos)
    local start_pos1 = self:getOtherUserPos()
    self.userOtherNode:setPosition(start_pos1)
    local endPos = cc.p(start_pos1.x + disX, start_pos1.y + disY)

    local jumpDisY = math.abs(start_pos1.y - endPos.y) * 2 

   
    local delay = 0.5
    local a1 = cc.DelayTime:create(delay)
    local a2 = cc.CallFunc:create(function ( ... )
        self.ctl:playMusicByName("map_user")
    	self:updateUserAniSpine()
    end)
    local a3 = cc.DelayTime:create(5/30)
    local a4 = cc.CallFunc:create(function ( ... )
        -- self:showMapForwardPosition(next_index)
        self.userAniNode:setPosition(endPosUser)
    end)
    local a5 = cc.JumpTo:create(8/30, endPos, 0, jumpDisY)
    local a6 = cc.Sequence:create(a1,a2,a3,a4,a5)
    self.userOtherNode:runAction(a6)
end
function cls:setMapPosition( step_index )
	step_index = step_index > 0 and step_index or 1
    local posx = self:getContainerPosX(step_index)
    local container_node = self.mapContainerNode:getInnerContainer()
    local posy = container_node:getPositionY()
    container_node:setPosition(cc.p(posx, posy))
end
function cls:getContainerPosX(step_index)
    local step_index = step_index or 1
    local _offset = 0
    if self.mapStepList[step_index] and bole.isValidNode(self.mapStepList[step_index]) then
        local sizex = self.mapContainerNode:getContentSize().width - self.mapContainerNode:getInnerContainerSize().width 
        _offset = self.mapContainerNode:getContentSize().width / 2 - self.panelDisX - self.mapStepList[step_index]:getPositionX()
        if _offset > 0 then
            _offset = 0
        elseif _offset < sizex then
            _offset = sizex
        end
    end
    return _offset
end
function cls:showMapForwardPosition( next_index )
    if next_index == 0 or next_index - 1 == 0 then
        return
    end
    local mapIndex = next_index - 1
    local container_node = self.mapContainerNode:getInnerContainer()
    self:setMapPosition(next_index - 1)
    local posX = self:getContainerPosX(next_index)
    local posY = container_node:getPositionY()
    container_node:runAction(cc.MoveTo:create(0.2, cc.p(posX, posY)))
end
-- feature = 1, --未来
-- current_start = 2, --开始播放当前的动画
-- current_finish = 3, --播放循环的动画
-- finish  = 4, -- 完成的状态
function cls:updateMapBuilding( isAnimation )
	local buildingConfig = self.mapConfig.map_building_config
	local buildingLevel  = self.mapConfig.buildingLevel
	local indexLevel = self.ctl.mapLevel
	if isAnimation then
		indexLevel = indexLevel - 1
	end
	for index = 1, buildingLevel do
		local build = self.mapStepList[index]
		local sType = self.buildingStype.feature
        if index < indexLevel then
			self:updateMapBuildingI(index, self.buildingStype.finish)
		elseif (index == indexLevel) then
			self:updateMapBuildingI(index, self.buildingStype.current_finish)
		else
			self:updateMapBuildingI(index, self.buildingStype.feature)
		end
	end
end
function cls:updateMapBuildingI( index, pType )
	local buildingConfig = self.mapConfig.map_building_config
	if buildingConfig[index] then
		self:updateBigBuilding(index, buildingConfig[index], pType)
	else
		self:updateSmallBuilding(index, pType)
	end
end
function cls:updateBigBuilding( index, buildIndex, pType )
    local buildNode = self.mapStepList[index]
    local finishCover = buildNode.finishCover
    local imgBg = buildNode.imgBg
    local pos = cc.p(0,0)
    if bole.isValidNode(imgBg) then
        pos.x, pos.y = imgBg:getPosition()
    end
    self:updateBoosterShow(buildNode, index, buildIndex, pType)
    if pType == self.buildingStype.finish then
        finishCover:setVisible(true)
    elseif pType == self.buildingStype.current_start then
        finishCover:setVisible(false)
        self:addBuildBigAwardSpine(buildNode, #buildIndex, pos)
    elseif pType == self.buildingStype.current_finish then
        finishCover:setVisible(true)
    elseif pType == self.buildingStype.feature then
        finishCover:setVisible(false)
    end
end
function cls:updateBoosterShow(buildNode, index, buildIndex, pType)
    if not buildNode then return end
    local boosterList = buildNode.stepList
    local labelCurrent = buildNode.labelCurrent
    local bigBuildIndex = buildNode.bigBuildIndex
    local buildStatus = {}
    local nextIndex = self.ctl:getPickLevelConfig()
    if pType == self.buildingStype.finish or pType == self.buildingStype.current_finish then
        buildStatus = 0
        buildStatus = self.ctl:getPreBigBuildStatus(bigBuildIndex)
        labelCurrent:setString(buildStatus)
        for key, val in ipairs(boosterList) do
            val.spriteGet:setVisible(false)
            val.spriteWrong:setVisible(false)
        end
    elseif index > nextIndex then
        labelCurrent:setString(0)
        for key, val in ipairs(boosterList) do
            val.spriteGet:setVisible(false)
            val.spriteWrong:setVisible(false)
        end
    else
        buildStatus = self.ctl:getCurBigBuildStatus(bigBuildIndex)
        labelCurrent:setString(self.ctl:getBoosterNums(buildStatus))
        for key, val in ipairs(boosterList) do
            if buildStatus and buildStatus[key] and buildStatus[key] > 0 then
                val.spriteGet:setVisible(true)
                val.spriteWrong:setVisible(false)
            elseif buildStatus and buildStatus[key] and buildStatus[key] == 0 then
                val.spriteGet:setVisible(false)
                val.spriteWrong:setVisible(true)
            else
                val.spriteWrong:setVisible(false)
                val.spriteGet:setVisible(false)
            end
        end
    end
end
function cls:updateSmallBuilding( index, pType )
    local buildNode = self.mapStepList[index]
    local currentImage = buildNode.currentImage
    local smallImage = self.mapConfig.map_image.small_image
    if pType == self.buildingStype.finish then
        bole.updateSpriteWithFile(currentImage, smallImage.finish)
    elseif pType == self.buildingStype.current_start then
        bole.updateSpriteWithFile(currentImage, smallImage.feature)
        self:addBuildSmallAwardSpine(buildNode)
    elseif pType == self.buildingStype.current_finish then
        bole.updateSpriteWithFile(currentImage, smallImage.finish)
    elseif pType == self.buildingStype.feature then
        bole.updateSpriteWithFile(currentImage, smallImage.feature)
    end
end
function cls:addBuildBigAwardSpine(buildNode, buildIndex, pos)
    if not buildNode then return end
    pos = pos or cc.p(0,0)
    self.ctl:playMusicByName("map_big")
    local file = self.ctl:getSpineFile("map_big")
    -- buildIndex = (buildIndex - 1) or 1
    local animName = self.mapConfig.map_big_arr_anim[buildIndex] or "animation5"
    bole.addSpineAnimation(buildNode, 10, file, pos, animName)
end
function cls:addBuildSmallAwardSpine(buildNode)
    if not buildNode then return end
    self.ctl:playMusicByName("map_small")
    local file = self.ctl:getSpineFile("map_small")
    bole.addSpineAnimation(buildNode, 10, file, cc.p(0,0), "animation")
end
function cls:showIncreaseAnimation( ... )
    if self.ctl.mapLevel < 1 then return end
    local buildingConfig = self.mapConfig.map_building_config
    local bgAniDelay = 60 / 30
    local activeStepTime = 0
    local refreshTime = 0
    if buildingConfig[self.ctl.mapLevel] then
        refreshTime = 1.5
        activeStepTime = 17/30 + 15/30
    else
        activeStepTime = 17/30 + 15/30
    end
    -- 禁止转动
    local a1 = cc.CallFunc:create(function ( ... )
    	self:showUserIconForwardPosition(self.ctl.mapLevel)
    end)
    local a2 = cc.DelayTime:create(activeStepTime)
    local a3 = cc.CallFunc:create(function ( ... )
        if self.ctl.mapLevel - 1 > 0 then
            local indexLevel = self.ctl.mapLevel - 1
            self:updateMapBuildingI(indexLevel, self.buildingStype.finish)
        end
     	self:updateMapBuildingI(self.ctl.mapLevel, self.buildingStype.current_start)
    end)
    local a4 = cc.Sequence:create(a1,a2,a3)
    self.ctl.node:runAction(a4)
end

function cls:hideMapAni( isAnimation, fromBonus )
    if fromBonus or (not isAnimation) then
		self.ctl:playMusicByName("map_close")
    end
    self.ctl.isOpenMapStatus = false
	local hideBtnDelay = isAnimation and 0 or 0.3
	local duration1 = 0.3
	local duration2 = 0.15
	local mapHidePos = self.mapPosConfig.panelHidePos
	if not isAnimation then
		self:hideBackBtnAni()
	end
	self.mapContainerNode:stopAutoScroll()
    -- self.mapContainerNode:setScrollBarEnabled(true)
	local a1 = cc.DelayTime:create(hideBtnDelay)
    local a2 = cc.CallFunc:create(function ( ... )
        self.rootPanel:setClippingEnabled(true)
		self.rootParent:runAction(cc.MoveTo:create(duration1, mapHidePos))
	end)
	local a3 = cc.DelayTime:create(duration2)
	local a4 = cc.CallFunc:create(function ( ... )
		self.dimmer:runAction(cc.FadeOut:create(duration2))
	end)
	local a5 = cc.DelayTime:create(duration1 - duration2)
	local a6 = cc.CallFunc:create(function ( ... )
        if not isAnimation then
            self.ctl._mainViewCtl:showActivitysNode()
		    self.ctl._mainViewCtl:setFooterBtnsEnable(true)
        end
        self.ctl._mainViewCtl:setFeatureState(self.gameConfig.FeatureName.OpenMap, false)-- self.ctl._mainViewCtl:enableMapInfoBtn(true)
        self:showParentEnable(false)
	end)
	self.ctl.node:runAction(cc.Sequence:create(
		a1,a2,a3,a4,a5,a6
		-- a1,a2,a3,a4,a6
		))
end
function cls:showMapAni( fromClick, isAnimate, fromBonus )
	local duration1 = 0.15
    -- local duration2 = 0.5
    local duration2 = 0.3
    local showBtnDelay = fromClick and 0.35 or 0
    local mapShowPos = self.mapPosConfig.panelStartPos
    local mapHidePos = self.mapPosConfig.panelHidePos
    -- self.mapContainerNode:scrollEnabled(false)
    self.backMapBtn:setScale(0)
	self:showParentEnable(true)
    self.rootParent:setPosition(mapHidePos)

    if fromClick then
        self.mapContainerNode:setTouchEnabled(true)
    else
        self.mapContainerNode:setTouchEnabled(false)
    end

    local a1 = cc.CallFunc:create(function ( ... )
        self.dimmer:setOpacity(0)
        self.dimmer:setVisible(true)
        self.dimmer:runAction(cc.FadeTo:create(duration1 * 2, 150))
    end)
    local a2 = cc.DelayTime:create(duration1)
    local a3 = cc.CallFunc:create(function ( ... )
        self.rootParent:runAction(cc.MoveTo:create(duration2, mapShowPos))
    end)
    local a4 = cc.DelayTime:create(duration2 + 0.1)
    local a5 = cc.CallFunc:create(function ( ... )
        self.rootPanel:setClippingEnabled(false)
        self.rootParent:setPosition(mapShowPos)
        if fromClick then
        	self:showBackBtnAni()
        end
    end)
    local a6 = cc.DelayTime:create(showBtnDelay)
    local a7 = cc.CallFunc:create(function ( ... )
        if isAnimate then
            self:showIncreaseAnimation()
        end
    end)
    local a8 = cc.Sequence:create(a1,a2,a3,a4,a5,a6,a7)
    self.ctl.node:runAction(a8)
end
function cls:showBackBtnAni( )
	self.backMapBtn:stopAllActions()
    self.backMapBtn:setScale(0)
    self.backMapBtn:setVisible(true)
    local a1 = cc.ScaleTo:create(0.2, 1.25)
    local a2 = cc.ScaleTo:create(0.15, 1)
    local a3 = cc.CallFunc:create(function ( ... )
        self:enableMapbtnClick(true)
    end)
    local a4 = cc.Sequence:create(a1,a2,a3)
    self.backMapBtn:runAction(a4)
end
function cls:hideBackBtnAni( ... )
	self.backMapBtn:stopAllActions()
    local a1 = cc.ScaleTo:create(0.15, 0)
    self.backMapBtn:runAction(a1)
end
function cls:enableMapbtnClick( enable )
	self.backMapBtn:setTouchEnabled(enable)
end




return cls