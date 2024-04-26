---@program src
---@description:  theme220
---@author: rwb
---@create: : 2020/11/23 21:16:16
local view = require (bole.getDesktopFilePath("Theme/ThemeApollo_FreeView")) 
local dialogLine = require (bole.getDesktopFilePath("Theme/ThemeApollo_MapDialogLine")) 
local parentClass = ThemeBaseFreeControl
local cls = class("ThemeApollo_FreeControl", parentClass)
function cls:ctor(_mainViewCtl)
    parentClass.ctor(self, _mainViewCtl)
    self.themeCtl = self._mainViewCtl
    self.fs_show_type = self.gameConfig.fs_show_type
end
function cls:checkIsMapFree()
    return self.fgType and self.fgType == 2
end
function cls:clearFreeSpinInfo()
    self.fgType = nil
    self.freeData = nil
    self.beginWildPos = nil
    self.exWildFinalPos = nil
    self.wildNextBeginPos = nil
    self.wildStickList = nil
    self.realItem_list = nil
    self.mapStickGame = nil
    self.mapExtraGame = nil
    self.mapMovingGame = nil
    self.freeView:clearMapFreeNode()

end
function cls:setFreeSpinInfo(free_game)
    self.freeData = free_game
    self.fgType = free_game.fg_type
    --if self:checkIsMapFree() then
    --    self.exWildFinalPos = tool.tableClone(self.freeData.final_wild_pos) -- "final_wild_pos": [ [ 4, 2 ], [ 3, 3 ], [ 5, 3 ] ]
    --end
end
function cls:dealFreeGameResumeRet(retData)
    parentClass.dealFreeGameResumeRet(self, retData)
    if retData.free_game then
        self:setFreeSpinInfo(retData.free_game)
    end
    if self:checkIsMapFree() then
        if retData.begin_wild_pos then
            self.beginWildPos = retData.begin_wild_pos
        end
        if retData.final_wild_pos then
            self.wildNextBeginPos = tool.tableClone(retData.final_wild_pos) -- "final_wild_pos": [ [ 4, 2 ], [ 3, 3 ], [ 5, 3 ] ]
            self.exWildFinalPos = tool.tableClone(retData.final_wild_pos) -- "final_wild_pos": [ [ 4, 2 ], [ 3, 3 ], [ 5, 3 ] ]
        end
        if retData.sticky_wild then
            self.wildStickList = tool.tableClone(retData.sticky_wild)
        end
    end


end
function cls:initLayout(...)
    self.freeView = view.new(self, ...)
end
function cls:playTransition(...)
    self._mainViewCtl:playTransition(...)
end

function cls:getMapConfig()
    return self:getGameConfig().map_config
end
function cls:playFadeToMinVlomeMusic(...)
    self._mainViewCtl:playFadeToMinVlomeMusic()
end
function cls:getFreeReelItem(col, row)

    if self.realItem_list and self.realItem_list[col] and self.realItem_list[col][row] then
        return self.realItem_list[col][row]
    end
    return nil
end
function cls:_changeRealBoard(item_list, final_wild_pos)
    local specialSymbol = self:getGameConfig().special_symbol
    local realItem_list = tool.tableClone(item_list)
    if final_wild_pos and #final_wild_pos > 0 then
        local myBoardList = final_wild_pos
        for key, myItem in ipairs(myBoardList) do
            local realCol = myItem[1]
            local realrow = myItem[2]
            realItem_list[realCol][realrow] = specialSymbol.goldWild
        end
    end
    return realItem_list
end
------------ map free wild start--------------------------

function cls:initMapFreeBoard()
    if self:checkIsMovingWild() then
        self:playMoveWildAppear(1)
    elseif self:checkIsStickWild() then
        self:playStickWildAppear()
    end
end
function cls:playMoveWildAppear(from)
    if from == 2 then
        self.exWildFinalPos = self.wildNextBeginPos
    end
    self.freeView:playMoveWildAppear(from)
end
function cls:playStickWildAppear()
    self.freeView:playStickWildAppear()
end
function cls:playMapFreeStopControl(stopRet, stopCallFun)
    self.realItem_list = nil
    if self:checkIsMovingWild() then
        self:playStopCtlMovingWild(stopRet, stopCallFun)

    elseif self:checkIsStickWild() then
        self:playStopCtlStickWild(stopRet)
        stopCallFun()
    else
        stopCallFun()
    end
end
--- extra wild
function cls:checkHaveExtraWild(wild_type)

    if wild_type == 1 then
        if self.freeData.random_wild1 and self.freeData.random_wild1 > 0 then
            return self.freeData.random_wild1
        end
        return 0
    else
        if self.freeData.random_wild2 and self.freeData.random_wild2 > 0 then
            return self.freeData.random_wild2
        end
        return 0
    end
    return false
end
function cls:checkIsMovingWild()

    --if self.mapMovingGame == nil then
    local mapLevel = self._mainViewCtl:getMapLevel()
    if mapLevel == 0 then
        mapLevel = 100
    end
    local mapConfig = self:getGameConfig().map_config
    if mapLevel == 0 then
        mapLevel = 100
    end
    local mapfree_type = mapConfig.all_node_type[mapLevel]

    local mapFreeTypeList = mapConfig.map_type_list[mapfree_type]
    for key = 1, #mapFreeTypeList do
        if mapFreeTypeList[key] == 4 then
            self.mapMovingGame = true
            return true
            --break
        end
    end
    --self.mapMovingGame = false
    --end
    return false
    --print("rwb_mapMovingGame",self.mapMovingGame)
    --return self.mapMovingGame

end
function cls:checkIsStickWild()
    --if self.mapStickGame == nil then
    local mapLevel = self._mainViewCtl:getMapLevel()
    if mapLevel == 0 then
        mapLevel = 100
    end
    local mapConfig = self:getGameConfig().map_config
    local mapfree_type = mapConfig.all_node_type[mapLevel]
    local mapFreeTypeList = mapConfig.map_type_list[mapfree_type]
    for key = 1, #mapFreeTypeList do
        if mapFreeTypeList[key] == 5 then
            --self.mapStickGame = true
            --break
            return true
        end
    end
    --self.mapStickGame = false
    --end
    --return self.mapStickGame
    return false

end
function cls:checkIsExtraWild()
    --if self.mapExtraGame == nil then
    local mapLevel = self._mainViewCtl:getMapLevel()
    if mapLevel == 0 then
        mapLevel = 100
    end
    local mapConfig = self:getGameConfig().map_config
    local mapfree_type = mapConfig.all_node_type[mapLevel]
    local mapFreeTypeList = mapConfig.map_type_list[mapfree_type]
    for key = 1, #mapFreeTypeList do
        if mapFreeTypeList[key] == 3 or mapFreeTypeList[key] == 6 then
            return true
        end
    end
    return false
    --self.mapExtraGame = false
    --end
    --return self.mapExtraGame
end
function cls:getExreaWild()
    local mapLevel = self._mainViewCtl:getMapLevel()
    if mapLevel == 0 then
        mapLevel = 100
    end
    local mapConfig = self:getGameConfig().map_config
    --local mapfree_type = mapConfig.all_node_type[mapLevel]
    --local mapFreeTypeList = mapConfig.map_type_list[mapfree_type]
    local big_node_config = mapConfig.big_node_config[mapLevel]

    return big_node_config.extra or 0
end
------------ Moving start
---@param final_wild_pos : 所有wild的最终位置
---@param begin_wild_pos : 会动的wild的最终位置
function cls:playStopCtlMovingWild(stopRet, stopCallFun)
    if not stopRet["theme_info"] then
        return
    end
    --self.themeCtl:setMaskNodeStatus(1, true, true)
    local _theme_info = stopRet["theme_info"]
    self.realItem_list = self:_changeRealBoard(stopRet.item_list, _theme_info["final_wild_pos"])
    self.realItem_list = self._mainViewCtl:getNewItemList(self.realItem_list, stopRet.map_wild_info)
    if _theme_info.final_wild_pos and #_theme_info.final_wild_pos ~= 0 then
        self.wildNextBeginPos = tool.tableClone(_theme_info.final_wild_pos)
    end
    self.wildTotalCount = 0
    if _theme_info.begin_wild_pos then
        local count = #_theme_info.begin_wild_pos
        self.wildTotalCount = count
        if count > 0 then
            self.curWildMoveEndPos = tool.tableClone(_theme_info.begin_wild_pos)
            self.beginWildPos = _theme_info.begin_wild_pos
        end
    end
    if self.wildTotalCount > 0 then
        self:moveNextPos(stopCallFun)
    else
        if stopCallFun then
            stopCallFun()
        end
    end
end

function cls:moveNextPos(stopCallFun)
    local moveWildTime = 15 / 30
    local changeToWildTime = 20 / 30
    --self:playMusicByName("")
    local find = false
    if self.curWildMoveEndPos and #self.curWildMoveEndPos > 0 then
        self.freeView:moveNextPos()
        --self.themeCtl:setMaskNodeStatus(1, true, true)
        self.node:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(moveWildTime + changeToWildTime),
                        cc.CallFunc:create(function()
                            --self.themeCtl:setMaskNodeStatus(1, false, true)
                            stopCallFun()
                        end
                        )
                )

        )
    end
end
function cls:changeMoveAnimaiton()
    if self.moveWildSpine and #self.moveWildSpine > 0 then
        for index, temp in pairs(self.moveWildSpine) do
            bole.changeSpineNormal(temp, "animation1", true)
        end
    end
end
function cls:playStopCtlStickWild(stopRet)
    self.wildStickList = stopRet.theme_info.sticky_wild
end

---@desc 排面结束，重置排面
function cls:updateMoveWildBoard()

end

----------------------------dialog start -------------------------------------
function cls:playStartFreeSpinDialog(theData)
    local end_event = theData.end_event
    local changeLayer_event = theData.changeLayer_event
    theData.changeLayer_event = nil
    theData.end_event = nil
    self:hideActivitysNode()
    self:setFooterBtnsEnable(false)
    local click_event = theData.click_event
    local free_start_music
    if self:checkIsMapFree() then
        free_start_music = "super_dialog_start"
    else
        free_start_music = "free_dialog_start"
    end
    self:playMusicByName(free_start_music)
    local fgType = self:getGameConfig().dialog_type.free
    if self:checkIsMapFree() then
        fgType = self:getGameConfig().dialog_type.super
    end
    local transitionDelay = self.gameConfig.transition_config[fgType]
    theData.click_event = function()
        self:stopMusicByName(free_start_music)
        if click_event then
            click_event()
        end
        self.node:runAction(
                cc.Sequence:create(
                        cc.DelayTime:create(1),
                        cc.CallFunc:create(function()
                            self:playTransition(nil, fgType)
                        end
                        ),
                        cc.DelayTime:create(transitionDelay.onCover),
                        cc.CallFunc:create(function()
                            if changeLayer_event then
                                changeLayer_event()
                            end
                            if end_event then
                                end_event()
                            end
                            self:setFooterBtnsEnable(false)
                        end
                        ),
                        cc.DelayTime:create(transitionDelay.onEnd - transitionDelay.onCover),
                        cc.CallFunc:create(function()

                            self:showActivitysNode()
                        end
                        ),
                        cc.DelayTime:create(0.5),
                        cc.CallFunc:create(function()
                            self._mainViewCtl:dealMusic_PlayFreeSpinLoopMusic()
                        end)
                )
        )
    end

    --theData.img_count = theData.count
    if self:checkIsMapFree() then
        if theData.count >= 10 then
            theData.count = 9
        end
    end
    local dialog = self._mainViewCtl:showThemeDialog(theData, self.fs_show_type.start, fgType)
    if self:checkIsMapFree() then
        local parent = dialog.startRoot:getChildByName("label_node2"):getChildByName("root")
        local mapLevel = self._mainViewCtl:getMapLevel()
        if mapLevel == 0 then
            mapLevel = 100
        end
        dialogLine.new(self, parent, mapLevel, 1)
    end
end

function cls:playMoreFreeSpinDialog(theData)
    self:hideActivitysNode()
    local dialog_music = "free_dialog_more"
    self:playMusicByName(dialog_music)
    local end_event = theData.end_event
    local changeLayer_event = theData.changeLayer_event
    theData.changeLayer_event = nil
    theData.end_event = nil
    theData.click_event = function()
        self:stopMusicByName(dialog_music)
        self.node:runAction(cc.Sequence:create(
                cc.DelayTime:create(2),
                cc.CallFunc:create(function(...)
                    if end_event then
                        end_event()
                    end
                    if changeLayer_event then
                        changeLayer_event()
                    end
                    self:showActivitysNode()
                end)
        ))
    end
    self:playMusicByName("free_dialog_more")
    theData.img_count = theData.count

    local fgType = "free"
    if theData.count == 3 then
        theData.bg = 1
    else
        theData.bg = 2
    end
    self._mainViewCtl:showThemeDialog(theData, self.fs_show_type.more, fgType)

end

function cls:playCollectFreeSpinDialog(theData)
    self:hideActivitysNode()
    self._mainViewCtl:showAllStickLeftWild()
    local click_event = theData.click_event
    local end_event = theData.end_event
    local changeLayer_event = theData.changeLayer_event
    theData.changeLayer_event = nil
    theData.end_event = nil
    local dialog_type = self.gameConfig.dialog_type
    local fgType = dialog_type.free
    local free_collect_music

    if self:checkIsMapFree() then
        fgType = dialog_type.super
        free_collect_music = "super_dialog_collect"
    else
        free_collect_music = "free_dialog_collect"
    end
    local transitionDelay = self:getGameConfig().transition_config[fgType]
    self:playMusicByName(free_collect_music)
    theData.click_event = function()
        self:stopMusicByName(free_collect_music)
        if click_event then
            click_event()
        end
        self.node:runAction(cc.Sequence:create(
                cc.DelayTime:create(1.5),
                cc.CallFunc:create(function(...)
                    self:playTransition(nil, fgType)
                end),
                cc.DelayTime:create(transitionDelay.onCover),
                cc.CallFunc:create(function(...)
                    if changeLayer_event then
                        changeLayer_event()
                    end
                    if end_event then
                        end_event()
                    end
                    self:setFooterBtnsEnable(false)
                end),
                cc.DelayTime:create(transitionDelay.onEnd - transitionDelay.onCover),
                cc.CallFunc:create(function(...)
                    --self:freeEndEvent()
                    self:showActivitysNode()
                end)
        ))
    end
    self:playMusicByName("free_dialog_collect")
    self._mainViewCtl:showThemeDialog(theData, self.fs_show_type.collect, fgType)
end
function cls:freeStartClicked(callback, isMore)
    if isMore then
        callback()
        return
    end
    local transitionDelay = self:getGameConfig().transition_config.free
    local transDelay = transitionDelay.onEnd - transitionDelay.onCover
    local a1 = cc.DelayTime:create(transDelay)
    local actionList = {}
    table.insert(actionList, a1)
    local call2 = function()
        self:playWildFallInFree()
        callback()
    end
    local a2 = cc.CallFunc:create(call2)
    table.insert(actionList, a2)
    self.node:runAction(cc.Sequence:create(unpack(actionList)))
end
function cls:playWildFallInFree()
    local extra = 0
    local actionList = {}
    if self:checkIsMapFree() then
        if self.freeData then
            local cnt = self:checkHaveExtraWild(1)
            local cnt2 = self:checkHaveExtraWild(2)
            if cnt > 0 then
                extra = cnt
            elseif cnt2 > 0 then
                extra = cnt2
            end
        end
    else
        extra = 15
    end
    if extra > 0 then
        self.needExtraStopTime = os.time() + extra * 0.1 + 2
        if extra > 0 then
            local a2_1 = cc.CallFunc:create(function()
                if not self:checkIsMapFree() then
                    self:playWildFall(15, 1)
                elseif self:checkHaveExtraWild(1) > 0 then

                    self:playWildFall(extra, 1)
                elseif self:checkHaveExtraWild(2) > 0 then
                    self:playWildFall(extra, 2)
                end
            end)
            table.insert(actionList, a2_1)
        end
        if not self:checkIsMapFree() then
            local a2 = cc.DelayTime:create(extra * 0.1 + 1)
            local a3 = cc.CallFunc:create(
                    function()

                        self:playMusicByName("free_open")

                    end)
            table.insert(actionList, a2)
            table.insert(actionList, a3)
        end
        self.node:runAction(cc.Sequence:create(unpack(actionList)))
    end
end
function cls:playWildFall(count, wildType)
    self.themeCtl:setMaskNodeStatus(1, true, true)
    self.freeView:playWildFall(count, wildType)

end
function cls:hideMapFreeWild(...)
    self.freeView:hideMapFreeWild(...)
end
function cls:fallFinish()
    if not self.themeCtl.stopControlData then
        self.themeCtl:setMaskNodeStatus(1, false, true)
    end
end
function cls:checkIsHaveGoldWild(col, row)
    if self:checkIsStickWild() then
        if self.freeView.stickWildNodeList and self.freeView.stickWildNodeList[col] and self.freeView.stickWildNodeList[col][row] then
            return true
        end
        return false
    elseif self:checkIsMovingWild() then

        if self.beginWildPos and #self.beginWildPos > 0 then
            for key = 1, #self.beginWildPos do
                local info = self.beginWildPos[key]
                if col == info[1] and row == info[2] then
                    return true
                end
            end
            return false
        end
        return false
    else
        return false
    end
end
--function cls:dealMusic_PlayFreeSpinLoopMusic()
--    if self:checkIsMapFree() then
--        self:playBgmByName("super_background")
--    else
--        self:playBgmByName("free_background")
--    end
--end
----------------------------dialog end --------------------------------------

function cls:testMovingAppear()
    self.exWildFinalPos = { { 1, 1 }, { 3, 3 } }
    self.freeView:playMoveWildAppear()
end
function cls:testStickAppear()
    self.wildStickList = { { 1, 1 }, { 3, 3 } }
    self.freeView:playStickWildAppear()
end
function cls:testMoveNextPos()
    self.curWildMoveEndPos = { { 2, 2 }, { 4, 4 } }
    self.freeView:moveNextPos()
end


------------------ map free start ---------------------------------
--function cls:initMapFreeWild()
--
--end

------------------ map free end ---------------------------------


return cls




