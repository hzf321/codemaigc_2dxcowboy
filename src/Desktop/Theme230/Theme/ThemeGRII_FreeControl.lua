---@program src
---@description:  theme230
---@author: rwb
---@create: : 2020/12/29 21:16:16

local parentClass = ThemeBaseFreeControl
local cls = class("ThemeGRII_FreeControl", parentClass)
local freeTypeList
function cls:ctor(_mainViewCtl)
    parentClass.ctor(self, _mainViewCtl)
    self.themeCtl = self._mainViewCtl
    freeTypeList = self.themeCtl:getGameConfig().freeTypeList
    self.fs_show_type = self.gameConfig.fs_show_type
end
function cls:checkIsSuperFree()
    return self.isSuper
end
function cls:getSuperWheelIndex()
    return self.freeData.super_wheel
end
function cls:clearFreeSpinInfo()
    self.fgType = nil
    self.freeData = nil
    self.wildStickList = nil
    --self.freeView:clearMapFreeNode()
    --self:clearSuperWheelStatus()

end
function cls:setFreeSpinInfo(free_game)
    self.freeData = free_game
    if free_game.fg_type > 2 then
        self.isSuper = true
    else
        self.isSuper = false
    end
    self.fgType = free_game["fg_type"]
    --self.themeCtl:setFreeCurDiskData(free_game)
end
function cls:dealFreeGameResumeRet(retData)
    if retData.free_game then
        self:setFreeSpinInfo(retData.free_game)
    end
    parentClass.dealFreeGameResumeRet(self, retData)

end

function cls:initLayout(...)
    --self.freeView = view.new(self, ...)
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
------ free 弹窗
function cls:playStartFreeSpinDialog(theData)
    parentClass.playStartFreeSpinDialog(self, theData)
    self:dealMusic_PlayFreeSpinLoopMusic()
end
function cls:playCollectFreeSpinDialog(theData)
    self:hideActivitysNode()
    local click_event = theData.click_event
    local end_event = theData.end_event
    local changeLayer_event = theData.changeLayer_event
    theData.changeLayer_event = nil
    theData.end_event = nil

    theData.enter_event = function()
        self:setFooterBtnsEnable(false) -- 禁用spin 按钮
        self._mainViewCtl:dealMusic_FadeLoopMusic(0.3, 1, 0)
    end
    local dialog_type = self.gameConfig.dialog_type
    local fgType = dialog_type.free
    local free_collect_music

    if self:checkIsSuperFree() then
        fgType = dialog_type.map
        free_collect_music = "mapfree_dialog_collect_show"
    else
        free_collect_music = "free_dialog_collect_show"
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
                    self:showActivitysNode()
                end)
        ))
    end
    self._mainViewCtl:showThemeDialog(theData, self.fs_show_type.collect, fgType)
end
function cls:setFreeStickyWild(fg_info)
    self.freeStickyWild = fg_info
end
function cls:getFreeStickyWild(fg_type)
    local fg_info = self.freeStickyWild
    if fg_type == freeTypeList.stickWild then
        if fg_info then
            return fg_info.fg1_info
        end
    end
    if fg_type == freeTypeList.stickRandom then
        if fg_info then
            return fg_info.fg2_info
        end
    end
    if fg_type == freeTypeList.mapRandom then
        if fg_info then
            return fg_info.map1_info
        end
    end
    if fg_type == freeTypeList.mapSticky then
        if fg_info then
            return fg_info.map3_info
        end
    end
    if fg_type == freeTypeList.mapMoving then
        if fg_info then
            return fg_info.map5_info
        end
    end
    return nil
end
-- 播放free games的背景音乐
function cls:dealMusic_PlayFreeSpinLoopMusic()
    -- 播放背景音乐
    local music
    if self:checkIsSuperFree() then
        music = self._mainViewCtl:getAudioFile("mapfree_background")
    else
        music = self._mainViewCtl:getAudioFile("free_background")
    end
    self.audioCtl:dealMusic_PlayGameLoopMusic(music)
end
-- freespin音效相关
function cls:dealMusic_PlayFSEnterMusic()
end
function cls:dealMusic_StopFSEnterMusic()
end
function cls:dealMusic_PlayFSEnterClickMusic()
end

function cls:dealMusic_PlayFSCollectMusic()

end
function cls:dealMusic_StopFSCollectMusic()
end
function cls:dealMusic_PlayFSCollectClickMusic()

end
function cls:dealMusic_PlayFSCollectEndMusic()
end
------------------ map free end ---------------------------------


return cls




