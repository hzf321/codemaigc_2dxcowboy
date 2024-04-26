
ThemeGoldRush_FreeView = class("ThemeGoldRush_FreeView")
local cls = ThemeGoldRush_FreeView

function cls:ctor(ctl, nodeList)
	self.vCtl = ctl
	self.gameConfig = self.vCtl:getGameConfig()

	self.freeNode = nodeList[1]
    self.collectFlyNode = nodeList[2]

	self:_initLayout()
end

function cls:_initLayout( ... )
	if self.freeNode then 
        self.freeTipParent  = self.freeNode:getChildByName("tip_node")
        self.freeTipOver    = self.freeTipParent:getChildByName("over")
        self.freeTipCollect = self.freeTipParent:getChildByName("collect")

        self.freeBoardLb    = self.freeTipCollect:getChildByName("board_count")
        self.freeCollectLb  = self.freeTipCollect:getChildByName("collect_count")


        local data = {}
        data.file = self.vCtl:getSpineFile("f_icon")
        data.parent = self.freeTipParent
        data.isLoop = true
        data.pos = cc.p(208.5, 1)
        data.animateName = "animation"
        local _, s = bole.addAnimationSimple(data)
        self.fIcon = s

        local data = {}
        data.file = self.vCtl:getSpineFile("f_collect_loop")
        data.parent = self.freeTipParent
        data.isLoop = true
        data.animateName = "animation2"
        local _, s2 = bole.addAnimationSimple(data)
        self.fKuang = s2
	end
end

function cls:resetBoardShowByFeature( boardType, boardCnt )
	
	self.freeTipParent:setVisible(false)

    if boardType ~= self.gameConfig.SpinBoardType.Normal and boardType ~= self.gameConfig.SpinBoardType.Bonus then
        self.freeTipParent:setVisible(true)

        self.fIcon:setPosition(cc.p(208.5, 1))
        self.freeTipOver:setVisible(false)
        self.freeTipCollect:setVisible(true)
        
        self:resetFreeTipPos(boardCnt)
        bole.spChangeAnimation(self.fKuang, "animation2", true)
        
    end
end

function cls:refreshFreeTip( boardNext, leftCount, fullLeft )
    if boardNext and leftCount then 
        self.freeTipOver:setVisible(false)
        self.freeTipCollect:setVisible(true)

        leftCount = leftCount <= 0 and 0 or leftCount

        local boardPath = string.format("#theme225_fg_num%s.png", boardNext)
        bole.updateSpriteWithFile(self.freeBoardLb, boardPath)
        self.freeCollectLb:setString(leftCount)

        self.fIcon:setPosition(cc.p(208.5, 1))
        bole.spChangeAnimation(self.fKuang, "animation2", true)
    else
        self.freeTipOver:setVisible(true)
        self.freeTipCollect:setVisible(false)
        self.fIcon:setPosition(cc.p(161, 1))
        bole.spChangeAnimation(self.fKuang, "animation1", true)
    end

    if fullLeft then 
        local data = {}
        data.parent = self.freeTipParent
        data.file = self.vCtl:getSpineFile("f_collect_full")
        data.zOrder = 50
        bole.addAnimationSimple(data)

        self.vCtl:playMusicByName("fg_count")

        local delay = 17/30

        if fullLeft ~= leftCount then
            self.freeTipParent:runAction(
                cc.Sequence:create(
                    cc.DelayTime:create(delay),
                    cc.CallFunc:create(function ( ... )
                        self:refreshFreeCountByFull( fullLeft )            
                    end)))
            delay = delay + 17/30
        end

        return delay
    end
end

function cls:refreshFreeCountByFull( fullLeft )
    local data = {}
    data.parent = self.freeTipParent
    data.file = self.vCtl:getSpineFile("f_collect_arr_num")
    data.zOrder = 50
    data.pos = cc.p(136, 0)
    data.animateName = "animation"
    bole.addAnimationSimple(data)

    self.freeCollectLb:setString(fullLeft)
end

function cls:showFreeCollectArrAnim( )
    local data = {}
    data.parent = self.freeTipParent
    data.file = self.vCtl:getSpineFile("f_collect_arr")
    data.zOrder = 50
    data.animateName = "animation2"
    bole.addAnimationSimple(data)

    local data = {}
    data.parent = self.freeTipParent
    data.file = self.vCtl:getSpineFile("f_collect_arr_leaf")
    data.zOrder = 50
    data.pos = cc.p(208.5, 1)
    data.animateName = "animation"
    bole.addAnimationSimple(data)
end

function cls:resetFreeTipPos( boardCnt )
    local tipPos = self.gameConfig.board_config[boardCnt] and self.gameConfig.board_config[boardCnt].tip_pos or cc.p(0,0)
    self.freeTipParent:setPosition(tipPos)
end

function cls:showScatterFlyToUp( theSpecials )
    self.collectFlyNode:removeAllChildren()

    if not theSpecials then return end

    local endPosW = bole.getWorldPos(self.fIcon)
    local endPosN = bole.getNodePos(self.collectFlyNode, endPosW)

    local _f_config = self.gameConfig.free_config
    local scatter_pos = self.gameConfig.symbol_config.scatter_config.scatter_pos
    self.vCtl:playMusicByName("scatter_fly")

    for col, rowTagList in pairs(theSpecials) do
        for row, tagValue in pairs(rowTagList) do

            local cell = self.vCtl:getCellItem(col, row)
            if bole.isValidNode(cell.up) then
                cell.up:removeAllChildren()
            end
            if bole.isValidNode(cell.tipNode2) then
                cell.tipNode2:removeAllChildren()
            end

            local pos = cc.pAdd(self.vCtl:getCellPos(col, row), scatter_pos)
            local s = cc.Node:create()
            s:setPosition(pos)
            self.collectFlyNode:addChild(s)
            local p_file1 = self.vCtl:getParticleFile("free_c1")
            local p_file2 = self.vCtl:getParticleFile("free_c2")
            local _particle1 = cc.ParticleSystemQuad:create(p_file1)
            local _particle2 = cc.ParticleSystemQuad:create(p_file2)
            s:addChild(_particle2, -2)
            s:addChild(_particle1, -1)
            _particle1:setVisible(false)
            _particle2:setVisible(false)

            s:runAction(cc.Sequence:create(
                -- cc.DelayTime:create(10/30),
                cc.CallFunc:create(function ( ... )
                    _particle1:setVisible(true)
                    _particle2:setVisible(true)
                end),
                cc.MoveTo:create(_f_config.fly_up_time, endPosN), --  - 10/30
                cc.CallFunc:create(function()
                    _particle1:setEmissionRate(0) -- 设置发射速度为不发射
                    _particle2:setEmissionRate(0) -- 设置发射速度为不发射
                end),
                cc.DelayTime:create(0.5),
                cc.RemoveSelf:create()))
        end
    end
end

function cls:clearFreeFeatureAnim( byHideFree )
    if byHideFree then
        
    end
end
