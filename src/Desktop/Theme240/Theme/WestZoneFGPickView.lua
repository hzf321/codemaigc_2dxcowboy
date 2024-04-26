
local fgPick =class("WestZoneFGPickView")
local fgPickAniList = nil

function fgPick:ctor(freeCtl, curScene, theme, data)
    self.freeCtl = freeCtl
    self.curScene = curScene
    self.data = data
    self._mainViewCtl = theme
    self.animateNode = self._mainViewCtl.mainView.animateNode
    self.gameConfig = self._mainViewCtl:getGameConfig()
    self.pickNode = self._mainViewCtl.mainView.pickNode
    fgPickAniList = self.gameConfig.fgPickAniCfg
    self.isSuper = self._mainViewCtl:getSuperFreeStatus() and "_super" or ""
end

function fgPick:enterFgPickBonus( tryResume ) 
    self._mainViewCtl:setCurCollectLevel(self._mainViewCtl.fg_level, self._mainViewCtl.specials)
    local delay = self.gameConfig.scatterAniCfg["zj_delay"]  -- 中奖动画
    local delay1 = 1
    if self._mainViewCtl.fg_level == 10 then delay1 = delay1 + 1 delay = delay + 1 end
    self._mainViewCtl:laterCallBack(delay1, function ()
        self._mainViewCtl:stopAllLoopMusic()
        self._mainViewCtl:playMusicByName("trigger_bell")
        self._mainViewCtl:playScatterAnimate(self._mainViewCtl.specials, true)
    end)
    self.animateNode:runAction(cc.Sequence:create(
        cc.DelayTime:create(delay + 1),
        cc.CallFunc:create(function ( ... )
            self._mainViewCtl:showBaseBlackCover(180)
            self:showFgPickDialog()
        end)
    ))
end

function fgPick:showFgPickDialog()
    self._mainViewCtl:playMusicByName("fg_dialog_start")
    local csbPath = self._mainViewCtl:getPic("csb/dialog_fg_pick.csb")
    local dialog = cc.CSLoader:createNode(csbPath)
    self.fgPickDialog = dialog
    local showNode = dialog:getChildByName("root")
    local bntNode = showNode:getChildByName("btn_node")
    self._mainViewCtl.curScene:addToContentFooter(dialog)
    bntNode:setPosition(cc.p(0, -55))
    self.btnList = {}
    for i = 1,2 do
        local btn = bntNode:getChildByName("btn"..i)
        btn.index = i
        btn:setOpacity(0)
        self.btnList[i] = btn
        self:initBtnEvent(btn, i)
    end
    self:allBtnEnabled(false)
    local file = self._mainViewCtl:getPic(fgPickAniList["path"])
    local file1 = self._mainViewCtl:getPic(fgPickAniList["path1"])
    self._mainViewCtl:playMusicByName("free_pick_popup")
    local _,s1 = self._mainViewCtl:addSpineAnimation(self.pickNode, nil, file, cc.p(0,0), fgPickAniList["startAni"..self.isSuper], nil, nil, nil, true)
    local _,s2 = self._mainViewCtl:addSpineAnimation(self.pickNode, nil, file1, cc.p(0,0), fgPickAniList["startAni"], nil, nil, nil, true)
    self.fgPickBgSpine = s1
    self.fgPickUserSpine = s2
    s1:runAction(cc.Sequence:create(
        cc.CallFunc:create(function ( ... )
            self.fgPickSpine = s1
            s1:runAction(cc.Sequence:create(
                cc.DelayTime:create(fgPickAniList["show_delay"]),
                cc.CallFunc:create(function ( ... )
                    s1:addAnimation(0, fgPickAniList["loopAni"..self.isSuper], true)
                    s2:addAnimation(0, fgPickAniList["loopAni"], true)
                    self:allBtnEnabled(true)
                end)
                ))
        end)
        ))
end

function fgPick:initBtnEvent(btnNode, index)
    local function btnOnTouch( obj, eventType )
        if eventType == ccui.TouchEventType.ended then
            self:allBtnEnabled(false)
            -- self.clickTime
            self.chooseRequestTime = cc.utils:gettime()

        --     local startTime = self.spinRequestTime
        -- local currentTime = cc.utils:gettime()
        -- local disTime = currentTime - startTime


            self.index = obj.index
            if self.index == 2 then 
                self._mainViewCtl:playMusicByName("fg_spin")
            else
                self._mainViewCtl:playMusicByName("spin_woman")
            end
            self._mainViewCtl:laterCallBack(1,function ()
                self._mainViewCtl:playMusicByName("fg_move")
            end)
            -- self._mainViewCtl:playMusicByName("dialog_close")
            if self.fgPickBgSpine and bole.isValidNode(self.fgPickBgSpine) then
                bole.spChangeAnimation(self.fgPickBgSpine, fgPickAniList["choose"..self.index..self.isSuper])
            end
            if self.fgPickUserSpine and bole.isValidNode(self.fgPickUserSpine) then
                bole.spChangeAnimation(self.fgPickUserSpine, fgPickAniList["choose"..self.index])
            end
            local file = self.index == 1 and "#theme240_s_13.png" or "#theme240_s_12.png"
            self._mainViewCtl.wildType = self.index
            bole.updateSpriteWithFile(self._mainViewCtl.mainView.wildTypeNode, file)
            self:collectFgPickBonus(self.index)
        end
    end
    btnNode:addTouchEventListener(btnOnTouch)
end

function fgPick:hidePickDialog()
    local chooseIndex = self.index or 1
    if self.fgPickBgSpine and bole.isValidNode(self.fgPickBgSpine) then
        bole.spChangeAnimation(self.fgPickBgSpine, fgPickAniList["hide"..chooseIndex..self.isSuper])
    end
    if self.fgPickUserSpine and bole.isValidNode(self.fgPickUserSpine) then
        bole.spChangeAnimation(self.fgPickUserSpine, fgPickAniList["hide"..chooseIndex])
    end
    self._mainViewCtl:hideBaseBlackCover(15/30, 35/30)
end

function fgPick:removeChooseNode()
    local currentTime = cc.utils:gettime()
    local disTime = currentTime - self.chooseRequestTime
    -- 0.84102988243103
    local hideTime = 37/30
    if disTime > 55/30 then
        disTime = 0
    else 
        disTime = 55/30 - disTime
    end
    local a1 = cc.DelayTime:create(disTime)
    local a2 = cc.CallFunc:create(function ()
        self._mainViewCtl:stopAllLoopMusic()
        self._mainViewCtl:playMusicByName("dialog_close")
        self:hidePickDialog()
    end)
    local a3 = cc.DelayTime:create(hideTime)
    local a4 = cc.RemoveSelf:create()
    local a5 = cc.Sequence:create(a1, a2, a3, a4)
    self.fgPickDialog:runAction(a5)
    return hideTime + disTime
end
-- function fgPick:removeChooseNode()
--     local fgPickDialog = self.fgPickDialog
--     if fgPickDialog and bole.isValidNode(fgPickDialog) then
--         if bole.isValidNode(self.fgPickSpine) then 
--             local aniName = self.gameConfig.fgPickAniCfg["exit_"..self.index]
--                 self.fgPickSpine:runAction(cc.Sequence:create(
--                     cc.CallFunc:create(function ( ... )
--                         bole.spChangeAnimation(self.fgPickSpine, aniName, false)
--                     end), 
--                     cc.CallFunc:create(function ( ... )
--                         -- self._mainViewCtl:playMusicByName(self.gameConfig.audioList.fg_unpick)  -- 其他三种 变暗音效 
--                     end)
--                     ))
--             end
--         -- self._mainViewCtl:hideBaseBlackCover(15/30, 35/30)
--         -- bole.setEnableRecursiveCascading(fgPickDialog, true)
--         -- local a0 = cc.DelayTime:create(35/30)
--         -- local a1 = cc.FadeOut:create(15/30)
--         -- local a2 = cc.RemoveSelf:create()
--         -- local a3 = cc.CallFunc:create(function ()
--         --     fgPickDialog = nil
--         -- end)
--         -- local a4 = cc.Sequence:create(a0,a1,a2,a3)
--         -- libUI.runAction(fgPickDialog, a4)
        
--     end
--     self.fgPickDialog = nil
--     return 48/60
-- end

function fgPick:allBtnEnabled(enable)
    for i = 1,2 do
        self.btnList[i]:setTouchEnabled(enable)
    end
end

function fgPick:collectFgPickBonus(index)
    self.freeCtl:collectCoins(index + 1) --2是twins1（key = 13），3是twins2（key = 12）
end

return fgPick