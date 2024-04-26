--[[
Author: xiongmeng
Date: 2020-12-11 14:30:22
LastEditors: xiongmeng
LastEditTime: 2021-01-14 18:24:28
Description: 
--]]
local cls = class("KingOfEgypt_WheelView")

function cls:ctor(ctl, curScene)
	self.ctl = ctl
    self.gameConfig = self.ctl:getGameConfig()
    self.wheelConfig = self.ctl:getWheelConfig()
    self.curScene = curScene
    self:_initNode()
	self:_initLayout()
end

function cls:_initNode()
    local csbList = self.gameConfig.csb_list
	local path = self.ctl:getPic(csbList.wheel)
    self.wheelRoot = libUI.createCsb(path)
    local moveY = self:getWideMoveY()
    self.wheelRoot:setPositionY(moveY)
    -- self.curScene:addToContent(self.wheelRoot)
    self.curScene:addToContentFooter(self.wheelRoot)
end

function cls:getWideMoveY()
    if bole.isWidescreen() then
        local moveY = -FRAME_HEIGHT * (1 - bole.getAdaptScale()) / 2
        return moveY
    end
    return 0
end

function cls:_initLayout()
    -- 展示界面
    self.dimmer = self.wheelRoot:getChildByName("dimmer")
    self.dimmer:setOpacity(0)
    self.bgNode = self.wheelRoot:getChildByName("bg_node")
    self.root = self.wheelRoot:getChildByName("root")
    self.sunWheel = self.root:getChildByName("sun")
    self.moonWheel = self.root:getChildByName("moon")
    self.pointNode = self.root:getChildByName("point")
    self.sunWheel:setVisible(false)
    self.moonWheel:setVisible(false)
    self:addPointAni()
end

function cls:_addWheelBgSpine(animationName, isLoop)
    if animationName then 
        if not self.bgSpine then 
            local file = self.ctl:getSpineFile("wheel_bg")
            local _, s = bole.addSpineAnimation(self.bgNode, nil, file, cc.p(0,0), animationName, nil, nil, nil, true, isLoop)
            self.bgSpine = s
        else 
            bole.spChangeAnimation(self.bgSpine, animationName, isLoop)
        end
    end
    if isLoop then 
        self.dimmer:setOpacity(200)
        self:changeFireSpine({"small_show", "small_loop"})
    end
end

function cls:changeFireSpine(animList)
    -- fire_anim = {
    --     small_show = "animation3",
    --     small_loop = "animation4",
    --     small_to_big = "animation5",
    --     big_show = "animation1",
    --     big_loop = "animation2",
    -- }
    if not bole.isValidNode(self.bgFireSpine) then 
        local file2 = self.ctl:getSpineFile("wheel_bg2")
        local _, s2 = bole.addSpineAnimation(self.bgNode, nil, file2, cc.p(0,0), "animation1", nil, nil, nil, true)
        self.bgFireSpine = s2
    end
    local isFirst = true
    for i, animKey in pairs(animList)  do
        local animName = self.wheelConfig.fire_anim[animKey]
        if animName then
            if isFirst then 
                isFirst = false
                self.bgFireSpine:setAnimation(0, animName, i == table.nums(animList))
            else
                self.bgFireSpine:addAnimation(0, animName, i == table.nums(animList))
            end
        end
    end
end

function cls:addPointAni()
    local file = self.ctl:getSpineFile("wheel_point")
    local _, spine1 = bole.addSpineAnimation(self.pointNode, nil, file, cc.p(0,0), "animation", nil, nil, nil, true, true)
    self.pointNodeSpine = spine1
end

function cls:addSpineIdleAni()
    local spinIdle = self.ctl:getSpineFile("wheel_spin_idle")
    local bgIdle = self.ctl:getSpineFile("wheel_idle")
    self.wheelBtn:removeAllChildren()
    self.wheelIdleNode:removeAllChildren()
    bole.addSpineAnimation(self.wheelIdleNode, nil, bgIdle, cc.p(0,0), "animation", nil, nil, nil, true, true)
    local wheelSize = self.wheelBtn:getContentSize()
    bole.addSpineAnimation(self.wheelBtn, nil, spinIdle, cc.p(wheelSize.width/2,wheelSize.height/2), "animation1", nil, nil, nil, true, true)
    self:playSpineIdleAni()
end
function cls:playSpineIdleAni()
    local scale1 = 1
    local scale2 = 1.25
    local time = 1
    local opca = 255
    self.wheelBtn:stopAllActions()
    -- local a1 = cc.ScaleTo:create(time, scale2)
    -- local a2 = cc.ScaleTo:create(time, scale1)
    -- local a3 = cc.Sequence:create(a1,a2)
    -- local a4 = cc.RepeatForever:create(a3)
    -- libUI.runAction(self.wheelBtn, a4)
    self.wheelBtn:setColor(cc.c3b(opca,opca,opca))
end
function cls:stopSpineIdleAni()
    local bgClick = self.ctl:getSpineFile("wheel_spin_click")
    self.wheelBtn:stopAllActions()
    self.wheelBtn:removeAllChildren()
    self.wheelAni:removeAllChildren()
    self.wheelIdleNode:removeAllChildren()
    bole.addSpineAnimation(self.wheelIdleNode, nil, bgClick, cc.p(0,0), "animation")
    self.wheelBtn:runAction(cc.ScaleTo:create(0.3, 1))
end
function cls:wheelStartUp()
    -- 判断开始上升
    local startPos = cc.p(0, -1257 + 69)
    local centerPos = cc.p(0, -49 + 69)
    local endPos = cc.p(0, 0)
    self.root:setPosition(startPos)
    local a1 = cc.DelayTime:create(0/30)
    local a2 = cc.MoveTo:create(13/30, centerPos)
    local a3 = cc.MoveTo:create(12/30, endPos)
    local a4 = cc.CallFunc:create(function ()
        -- self:enableWheelbtnClick(true)
        self:_addWheelBgSpine("animation2", true)
        self.ctl:enterWheelByStep()
        self.ctl._mainViewCtl:dealMusic_EnterBonusGame()
    end)
    local a5 = cc.Sequence:create(a1,a2,a3,a4)
    libUI.runAction(self.root, a5)
    self:_addWheelBgSpine("animation1")
    self.ctl:playMusicByName("transition_wheel1")
    self.wheelBtn:setColor(cc.c3b(255,255,255))
    -- self.dimmer:setOpacity(0)
    self.dimmer:runAction(cc.FadeTo:create(0.3, 200))
    -- self:addSpineIdleAni()
end

function cls:initWheelNode()
    self.targetWheel = self:getCurrentWheel()
    self.targetWheel:setVisible(true)
    self.wheelRapid  = self.targetWheel:getChildByName("wheel_rapid")
    self.wheelMul    = self.targetWheel:getChildByName("wheel_mul")
    local w_multi_pos = self.wheelConfig.w_multi_pos
    self.wheelMul:setPosition(w_multi_pos.start_pos)

    self.wheelNode = self.wheelRapid:getChildByName("wheel_node")
    self.wheelBtn  = self.wheelRapid:getChildByName("wheel_btn")
    self.wheelAni  = self.wheelRapid:getChildByName("wheel_ani")
    -- self.wheelCover = self.wheelNode:getChildByName("wheel_cover")
    self.wheelIdleNode = self.wheelNode:getChildByName("wheel_idle")
    -- self.wheelCover:setVisible(false)
    
    self.multiWheelNode = self.wheelMul:getChildByName("wheel_node")
    self.multiWheelBGAni = self.wheelMul:getChildByName("wheel_bg_anim")
    self.multiWheelAni  = self.wheelMul:getChildByName("wheel_ani")

    self:enableWheelbtnClick(false)
    self:initWheelEvent()
end
function cls:enableWheelRoot(enable)
    self.wheelRoot:setVisible(true)
    -- self.wheelRoot:setVisible(enable)
end
function cls:showWheelCoverNode(isAni)
    if not self.wheelRapid then return end
    local darkColor = cc.c3b(50, 50, 50)
    if isAni then
        self.wheelRapid:setColor(cc.c3b(255,255,255))
        self.wheelRapid:runAction(cc.TintTo:create(0.3, darkColor))
    else
        self.wheelRapid:setColor(darkColor)
    end
end
function cls:hideWheelCoverNode()
    if not self.wheelRapid then return end
    self.wheelRapid:setColor(cc.c3b(255, 255, 255))
end
function cls:initWheelEvent()
    local function onTouch2(obj, eventType)
        if eventType == ccui.TouchEventType.ended then
            self:wheelBtnClick("btn")
        end
    end
    self.wheelBtn:addTouchEventListener(onTouch2)-- 设置按钮
end

function cls:wheelBtnClick( click_from )
    if self.wheelClick then return end

    local info = {current = "wheel_btn", click_from = click_from, tid = self.ctl.themeCtl.themeid}
    bole.send_codeInfo(Splunk_Type.ACTION, info, false)

    self.wheelClick = true
    self.ctl:playMusicByName("wheel_click")
    self:enableWheelbtnClick(false)

    self:stopSpineIdleAni()
    self:setWheelMulHidePos(true)
    self:setStartRoll()

        local pushData = {
            touch_from = "wheel_spin",
            touch_func = nil
        }
        self.ctl:copyFuncToKeyBoard(pushData)
end

function cls:setStartRoll()
    -- self.ctl._mainViewCtl:playFadeToMinVlomeMusic()
    local a1 = cc.DelayTime:create(26/30)
    local a2 = cc.CallFunc:create(function ()
        self:spinWheel()
    end)
    local a3 = cc.Sequence:create(a1, a2)
    libUI.runAction(self.wheelRoot, a3)
    if self.ctl.data.wheelStep == 0 then 
        -- self:_addWheelBgSpine("animation2", nil)
        -- if self.bgSpine then 
        --     self.bgSpine:addAnimation(0, "animation4", true)
        -- end
    end
end
-- isAni for reconect
-- isSuper for wheel
-- isMul for wheelMuilti
function cls:playAwardAni(isAni, isSuper, isMul)

    local animate1 = "animation2_1"
    local animate2 = "animation2_2"
    local pos = cc.p(0,0)
    local parent = self.wheelAni
    if isSuper then 
        animate1 = "animation1_1"
        animate2 = "animation1_2"
        self:addWheelShaker()
    elseif isMul then 
        parent = self.multiWheelAni
        animate1 = "animation3_1"
        animate2 = "animation3_2"
    end
    local file = self.ctl:getSpineFile("wheel_mul_award")
    parent:removeAllChildren()
    if isAni then 
        -- local _, s = bole.addSpineAnimation(parent, nil, file, pos, animate1, nil, nil, nil, true)
        -- s:addAnimation(0, animate2, true)
        bole.addSpineAnimation(parent, nil, file, pos, animate1, nil, nil, nil, true)
        bole.addSpineAnimation(parent, nil, file, pos, animate2, nil, nil, nil, true, true)
    else 
        bole.addSpineAnimation(parent, nil, file, pos, animate2, nil, nil, nil, true, true)
    end
end

function cls:addWheelShaker()
    local function shakeEnd()
        self.wheelShaker = nil
    end

    local time = 1
    self.wheelShaker = ScreenShaker.new(self.targetWheel,time,shakeEnd)
    self.wheelShaker:run()
end

function cls:stopScreenShaker()
    if self.wheelShaker then
        self.wheelShaker:stop()
        self.wheelShaker = nil
    end
end

function cls:spinWheel()
    self.randomMore = math.random(10, 20)
    local function finishSpin()
        self.miniWheel = nil
        local time = 81/30
        if self.ctl:getHadMulWheel() then 
            time = self:setWheelTurnPos(true) + time
        end
        local a1 = cc.RotateBy:create(0.5, -self.randomMore)
        local a2 = cc.DelayTime:create(0.5)
        local a3 = cc.CallFunc:create(function ()
            self.ctl:playMusicByName("wheel_option")
            self.ctl:setRapidWheelStatus()
            if self.ctl:getHadMulWheel() then 
                self:playAwardAni(true, true)
            else 
                self:playAwardAni(true)
            end
            if not self.ctl:getHadMulWheel() then 
                self.ctl:setMulWheelStatus()
            end
        end)
        local a4 = cc.DelayTime:create(time)
        local a5 = cc.CallFunc:create(function ()
            self.ctl:enterWheelByStep()
        end)
        local a6 = cc.Sequence:create(a1,a2,a3,a4,a5)
        self.wheelNode:runAction(a6)

        -- self.ctl:playMusicByName("wheel_option")
        -- local time = 81/30
        -- if self.ctl:getHadMulWheel() then
        --     self:playAwardAni(true, true)
        --     time = self:setWheelTurnPos(true) + time
        -- else
        --     self:playAwardAni(true)
        --     self.ctl:setMulWheelStatus()
        -- end
        -- local a1 = cc.DelayTime:create(time)
        -- local a2 = cc.CallFunc:create(function() 
        --     self.ctl:enterWheelByStep()
        -- end)
        -- local a3 = cc.Sequence:create(a1,a2)
        -- self.ctl.node:runAction(a3)
    end
    self.ctl:playMusicByName("wheel_roll")
    local speed = self.ctl:getWheelConfig().speed_config
    local wheelData = tool.tableClone(speed)
    wheelData.endAngle = self.ctl.stopAngle + self.randomMore
    self.miniWheel = BaseWheelExtend.new(self, self.wheelNode, nil, wheelData, finishSpin)
    self.miniWheel:start()
end
function cls:spinMulWheel()
    local function finishSpin()
        self.miniMulWheel = nil
        self.ctl:setMulWheelStatus()
        local time = 81/30
        self.ctl:playMusicByName("wheel_mul_option")
        self:playAwardAni(true, nil, true)
        local a1 = cc.DelayTime:create(time)
        local a2 = cc.CallFunc:create(function() 
            self.ctl:enterWheelByStep()
        end)
        local a3 = cc.Sequence:create(a1,a2)
        self.ctl.node:runAction(a3)
    end
    self.ctl:playMusicByName("wheel_mul_roll")
    local speed = self.ctl:getWheelConfig().multi_speed_config
    local wheelData = tool.tableClone(speed)
    wheelData.endAngle = self.ctl.mulStopAngle
    self.miniMulWheel = BaseWheelExtend.new(self, self.multiWheelNode, nil, wheelData, finishSpin)
    self.miniMulWheel:start()
    self.wheelAni:removeAllChildren()
end

function cls:setWheelMulHidePos(isAni)
    local hidePos = self:getWheelMulHidePos()
    if not self.wheelMul then return end
    self:hideWheelCoverNode()
    self.wheelMul:stopAllActions()
    if isAni then
        local currentPosY = self.wheelMul:getPositionY()
        local time = math.abs(hidePos.y - currentPosY)/1000
        self.wheelMul:runAction(cc.MoveTo:create(time, hidePos))
    else
        self.wheelMul:setPosition(hidePos)
    end
end
function cls:setWheelTurnPos(isAni)
    local turnPos = self.wheelConfig.w_multi_pos.end_pos
    if not self.wheelMul then return end
    -- 添加特效
    
    local file = self.ctl:getSpineFile("wheel_mul_spin_idle")
    local _,s = bole.addSpineAnimation(self.multiWheelBGAni, -1, file, cc.p(0, 26), "animation", nil, nil, nil, true, true)
    if isAni then
        local currentPosY = self.wheelMul:getPositionY()
        local turnPos2 = cc.p(turnPos.x, turnPos.y+30)
        local time = math.abs(turnPos.y - currentPosY)/1000
        local a1 = cc.DelayTime:create(81/30 + 0.5)
        local a11 = cc.CallFunc:create(function ()
            self:showWheelCoverNode(isAni)
            self:changeFireSpine({"small_to_big", "big_loop"})

            self.ctl:playMusicByName("wheel_up")
        end)
        local a2 = cc.MoveTo:create(time*4/5, turnPos2)
        local a21 = cc.MoveTo:create(time/5, turnPos)
        local a3 = cc.Sequence:create(a1,a11,a2,a21)
        self.wheelMul:runAction(a3)

        return time
    else
        self:showWheelCoverNode(isAni)
        self.wheelMul:setPosition(turnPos)

        self:changeFireSpine({"big_loop"})
    end
end
function cls:setWheelStartPos(isAni)
    local startPos = self.wheelConfig.w_multi_pos.start_pos
    if not self.wheelMul then return end
    if isAni then
        self.multiWheelAni:removeAllChildren()
        local currentPosY = self.wheelMul:getPositionY()
        local time = math.abs(startPos.y - currentPosY)/1000
        local a1 = cc.DelayTime:create(1)
        local a2 = cc.MoveTo:create(time, startPos)
        local a3 = cc.Sequence:create(a1,a2)
        self.wheelMul:runAction(a3)
        return time
    else
        self.wheelMul:setPosition(startPos)
    end
end
function cls:getWheelMulHidePos()
    local pos = cc.p(0, -500)
    local height = DESIGN_WIDTH > DESIGN_HEIGHT and DESIGN_HEIGHT or DESIGN_WIDTH
    pos = cc.p(0, -height/2 - 300)
    return pos
end
function cls:setRapidWheelRo(pro)
    if not self.wheelNode then return end
    pro = pro or self.ctl.stopAngle
    if not pro then 
        pro = 0
    end
    self.wheelNode:setRotation(pro)
end
function cls:setMulWheelRo(pro)
    if not self.multiWheelNode then return end
    pro = pro or self.ctl.mulStopAngle
    if not pro then 
        pro = 0
    end
    self.multiWheelNode:setRotation(pro)
end
function cls:enableWheelbtnClick( enable )
    self.wheelClick = not enable

	self.wheelBtn:setTouchEnabled(enable)
    -- self.wheelBtn:setBright(enable)
    local opca = 150
    if enable then
        opca = 255
    end
    self.wheelBtn:setColor(cc.c3b(opca,opca,opca))

    if enable then
        local pushData = {
            touch_from = "wheel_spin",
            touch_func = function ()
                self:wheelBtnClick("key_board")
            end
        }
        self.ctl:copyFuncToKeyBoard(pushData)
    end
end
function cls:getCurrentWheel()
    if self.ctl.choiceIndex and self.ctl.choiceIndex == 1 then
        return self.moonWheel
    end
    return self.sunWheel
end
function cls:dimmerOut(parent, spentTm)
    if not parent then return end
    parent:setOpacity(180)
    parent:setVisible(true)
    parent:runAction(cc.FadeOut:create(spentTm))
end
function cls:dimmerIn(parent, spentTm)
    if not parent then return end
    parent:setOpacity(0)
    parent:setVisible(true)
    parent:runAction(cc.FadeTo:create(spentTm, 180))
end
function cls:removeFromParent()
    if self.wheelRoot and bole.isValidNode(self.wheelRoot) then
        self.wheelRoot:removeFromParent()
        self.wheelRoot = nil
    end
end

------------------------- dialog start -----------------------
function cls:playFreeSpinDialog( result )
    local theData = {}
    result = result or 8
	theData.sType = 1
	theData.count = result
	theData.click_event = function ( ... )
		self.ctl:collectNotice()
        self.ctl:exitFgReelViewBonus()
        self.ctl:playMusicByName("free_dialog_start_close")
	end
    self.ctl:playMusicByName("free_dialog_start_show")
    local dialog = self.ctl._mainViewCtl:showThemeDialog(theData, 1, "dialog_free", "free_start")
    local startRoot = dialog.startRoot
    if startRoot then 
        local gamemaster_icon = startRoot:getChildByName("gamemaster_icon")
        local enable = false
        if self.ctl._mainViewCtl:getFreeVCtl():gameMasterFlagStatus() then 
            enable = true
        end
        if gamemaster_icon and bole.isValidNode(gamemaster_icon) then 
            gamemaster_icon:setVisible(enable)
        end
    end
end

function cls:playJpDialogCollect( result, isSuper )
    local theData = {}
    local dialog = nil
    local collectRoot = nil
    local showRapid = false
    theData.coins = self.ctl.totalWinPayOut -- self.ctl.totalWin
    local startCoins = self.ctl.totalWinPayOut -- self.ctl.totalWin
    if isSuper and self.ctl.mulResult then
        local jp_index = 11   
        if result >= 5 and result <= 9 then 
            jp_index = 9 - result + 1
        end

        local prossive = self.ctl.progressive_list[jp_index] or 0
        if self.ctl:getJpLockStatus() then  
            prossive = 0
        end
        startCoins = math.floor((startCoins - prossive)/self.ctl.mulResult) + prossive
        theData.coins = startCoins
    end
    
    theData.bg = 3
    theData.top = 3
    self.ctl:playMusicByName("dialog_wheel_collect")
    theData.click_event = function ( ... )
        if result < 9 then 
            self.ctl:addStepData()
            self.ctl:addWheelCoins()
            self:setWheelStartPos(true)
            self:setMulWheelRo()
            -- 加钱的操作
            self.ctl:laterCallBack(1, function ()
                self.ctl:enterWheelByStep()
            end)
        else 
            self.ctl:collectNotice()
            self.ctl:exitJpReelViewBonus()
        end
    end
    -- collectRoot
    -- 特殊处理一下是否是锁住的jp
    local dialog_type = "small"
    if self.ctl.choiceIndex and self.ctl.choiceIndex == 1 then 
        theData.bg = 2
        theData.top = 2
    else 
        theData.bg = 1
        theData.top = 1
    end
    if result < 5 then 
        dialog_type = "small"
        showRapid = true
        dialog = self.ctl._mainViewCtl:showThemeDialog(theData, 3, "dialog_wheel", "wheel_quick_collect")
    else
        if self.ctl:getJpLockStatus() then
            dialog_type = "jp_lock"
            showRapid = true
            dialog = self.ctl._mainViewCtl:showThemeDialog(theData, 3, "dialog_wheel", "lock_jp_collect")
        else
            ----- facebook
            local fbData = ActivityCenterControl:getInstance():getFbShareData() or {}
            local shareLink = self.gameConfig.share_link.other
            if result and result >=9 then
                shareLink = self.gameConfig.share_link.grand
            end
            local share_data = {
                share_id = shareLink[math.random(1, #shareLink)],
                share_tracker_id = fbData.share_tracker_id or 0,
            }
            theData.share_fb = share_data
            ----- facebook
    
            dialog_type = "jp"
            showRapid = true
            dialog = self.ctl._mainViewCtl:showThemeDialog(theData, 3, "dialog_wheel", "wheel_collect")
        end
    end
    collectRoot = dialog.collectRoot
    local multi_node = collectRoot:getChildByName("multi_node")
    local rapid_node = collectRoot:getChildByName("rapid_node")
    local rapid_count = rapid_node:getChildByName("rapid_count")
    if bole.isValidNode(rapid_count) and showRapid then 
        rapid_count:setString(result)
        local fntFile = self.ctl:getFntFilePath("font/theme325_sum_count.fnt")
        if self.ctl.choiceIndex == 1 then -- moon
            fntFile = self.ctl:getFntFilePath("font/theme325_moon_count.fnt")
        end
        if dialog_type == "jp_lock" then
            fntFile = self.ctl:getFntFilePath("font/theme325_sun_new.fnt")
        end
        rapid_count:setFntFile(fntFile)

        if self.gameConfig.dialog_jp_pos and self.gameConfig.dialog_jp_pos[dialog_type] then
            local dialog_pos = self.gameConfig.dialog_jp_pos[dialog_type]
            if bole.isValidNode(rapid_node) and dialog_pos.rapid_node then
                rapid_node:setPosition(dialog_pos.rapid_node)
            end
            if dialog_type == "jp_lock" and dialog_pos.multi[result] then
                rapid_count:setString(dialog_pos.multi[result].."X")
            end
        end
    end
    rapid_node:setVisible(showRapid)

    if bole.isValidNode(multi_node) then 
        if isSuper and self.ctl.mulResult then

            multi_node:getChildByName("wheel_bg"):setVisible(false)
            multi_node:getChildByName("wheel_bg2"):setVisible(false)
            multi_node:setLocalZOrder(1)
            local mulFile = self.ctl:getSpineFile("dialog_jackpot_multi")

            local data2 = {}
            data2.file = mulFile
            data2.parent = collectRoot
            data2.isRetain = true
            data2.animateName = "animation1"
            local _,s = bole.addAnimationSimple(data2)
            self.multiSpine = s
            self.multiSpine:addAnimation(0, "animation2", true)

            local label = multi_node:getChildByName("label")
            label:setString(self.ctl.mulResult.."X")
            multi_node:setVisible(true)
            collectRoot.btnCollect:setTouchEnabled(false)
            local a1 = cc.DelayTime:create(2 + 1)
            local a11 = cc.CallFunc:create(function ()
                self.ctl:playMusicByName("wheel_dialog_double")
                if bole.isValidNode(self.multiSpine) then
                    self.multiSpine:setAnimation(0, "animation3", false)
                end
            end)
            local a2 = cc.Spawn:create(
                cc.Sequence:create(
                    cc.ScaleTo:create(0/30, 1),
                    cc.ScaleTo:create(5/30, 0.8),
                    cc.ScaleTo:create(5/30, 1.2),
                    cc.ScaleTo:create(5/30, 2),
                    cc.ScaleTo:create(4/30, 0.5)
                ),
                cc.Sequence:create(
                    cc.MoveTo:create(10/30, cc.p(375, 98)),
                    cc.MoveTo:create(5/30, cc.p(0, -31))
                )
            )
            local a22 = cc.Hide:create()
            local a23 = cc.DelayTime:create(10/30)
            local a3 = cc.CallFunc:create(function ()
                multi_node:setVisible(false)
                if collectRoot.labelWin then
                    if collectRoot.labelWin.nrOverRoll then
                        collectRoot.labelWin:nrOverRoll()
                    end
                    collectRoot.labelWin:setString(FONTS.format(dialog.fsData["coins"], true))
                    dialog:rollCoinsAgain(startCoins, self.ctl.totalWinPayOut)
                    -- collectRoot.labelWin:nrStartRoll(startCoins, self.ctl.totalWinPayOut, 2)
                end
                dialog.fsData["coins"] = self.ctl.totalWinPayOut
            end)
            local a4 = cc.DelayTime:create(1)
            local a5 = cc.CallFunc:create(function ()
                collectRoot.btnCollect:setTouchEnabled(true)
            end)
            local a6 = cc.Sequence:create(a1,a11,a2,a22,a23,a3,a4,a5)
            multi_node:runAction(a6)
        else
            multi_node:setVisible(false)
        end
    end
end
------------------------- dialog end   -----------------------

return cls