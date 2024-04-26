---@program src
---@description:  theme230
---@author: rwb
---@create: : 2021/01/05 21:58
local parentClass = ThemeBaseViewControlDelegate
local cls = class("ThemeGRII_MapControl", parentClass)
local view = require (bole.getDesktopFilePath("Theme/ThemeGRII_MapView"))    

function cls:ctor(_mainViewCtl)
    parentClass.ctor(self, _mainViewCtl)
    self.themeCtl = _mainViewCtl
    self.mapConfig = self:getGameConfig().map_config
end

function cls:initLayout(mapParent)
    self.mapParent = mapParent
end
function cls:getMapLevel()
    return self.themeCtl:getMapLevel()
end
function cls:getMapInfo()
    return self.themeCtl:getMapInfo()
end
function cls:mapForward()
    self:playMusicByName("ui_move")
    local nextLevel = self:getMapLevel()
    self.mapView:showMapForwardPosition(nextLevel)
    self.mapView:showUserIconForwardAni(nextLevel)
end
function cls:mapItemLighten()
    local nextLevel = self:getMapLevel()
    self.mapView:mapItemLighten(nextLevel)
end

function cls:showMapScene(byScatter, isAni)
    self.themeCtl:dealMusic_FadeLoopMusic(0.2, 1, 0)
    self.isOpenMapStatus = true
    self._mainViewCtl:hideActivitysNode()
    self._mainViewCtl:setFooterBtnsEnable(false)
    self._mainViewCtl:enableMapInfoBtn(false)
    local nextLevel = self:getMapLevel()
    if not self.mapView then
        self.mapView = view.new(self, self.mapParent)
        if byScatter then
            if isAni then
                self.mapView:resetToOpened(nextLevel - 1)
            end
        end
    else
        self.mapView:updateItemNode(byScatter, isAni)
    end
    self.mapView:showMapScene(byScatter, isAni)
end
function cls:exitMapScene(byBonus)
    if not self.mapView or not self.isOpenMapStatus then
        return
    end

    self.mapView:exitMapScene(byBonus)
end
function cls:exitMapSceneFinish(byBonus)
    self.isOpenMapStatus = false
    if not byBonus then
        self.themeCtl:showActivitysNode()
        self.themeCtl:setFooterBtnsEnable(true)
        self.themeCtl:enableMapInfoBtn(true)
        --self.themeCtl:dealMusic_FadeLoopMusic(0.2, 0, 1)
    end
end
function cls:getMapConfig()
    return self.themeCtl:getGameConfig().map_config
end
function cls:checkInFeature()
    return self.isOpenMapStatus
end
function cls:getDialogSpineType()
    local mapLevel = self:getMapLevel()
    local map_config = self:getMapConfig()
    local node_type = self:getMapLevelType(mapLevel)
    local map_free_type = map_config.map_free_type
    local dialog_spine = map_config.dialog_spine
    if node_type == map_free_type.random then
        return dialog_spine.random
    end
    if node_type == map_free_type.sticky then
        return dialog_spine.sticky
    end
    if node_type == map_free_type.move then
        return dialog_spine.move
    end
    return dialog_spine.multi
end
function cls:showMapFreeDialog(bonusData)
    local map_config = self:getMapConfig()
    local img_node = self:getDialogSpineType()
    local data = {}
    data.img_node = img_node
    local fgType = "map"
    local transitionDelay = self:getGameConfig().transition_config[fgType]
    local changeLayer_event = bonusData.change_layer
    local end_event = bonusData.end_event

    self:playMusicByName("mapfree_dialog_start_show")
    data.click_event = function()
        self:stopMusicByName("mapfree_dialog_start_show")
        bonusData.click_event()
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
    local dialog_spine = map_config.dialog_spine
    local dialog_type = "map"
    if img_node == dialog_spine.multi then

        dialog_type = "map_multi"
    end
    local dialog = self.themeCtl:showThemeDialog(data, 1, dialog_type)
    if img_node == dialog_spine.multi then
        local mini, max = self:getMapMulti()
        local label2 = dialog.startRoot:getChildByName("label_node2")
        local font_1 = label2:getChildByName("font_1")
        local font_2 = label2:getChildByName("font_2")
        font_1:setString(mini .. "X")
        font_2:setString(max .. "X")
    end
end
function cls:getMapMulti()
    local level = self:getMapLevel()
    local map_config = self:getMapConfig()
    local map_type = self:getMapLevelType(level)
    local big_node_config = map_config.big_node_config
    local mini = big_node_config[map_type].multi_1
    local max = big_node_config[map_type].multi_2
    return mini, max
end
function cls:getMapLevelType(level)
    local map_config = self:getGameConfig().map_config
    local node_type = map_config.all_node_type[level]
    return node_type
end
function cls:playTransition(...)
    self.themeCtl:playTransition(...)
end
function cls:checkIsBigNode(level)
    local buildingLevel = self.mapConfig.build_level
    if buildingLevel[level] then
        return true
    end
    return false
end
return cls






