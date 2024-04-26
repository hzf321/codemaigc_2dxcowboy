--- @program src
--- @description: theme220 map game
--- @author: rwb
--- @create: 2020/11/23 16:00

local parentClass = ThemeBaseViewControlDelegate
local view = require (bole.getDesktopFilePath("Theme/ThemeApollo_MapView")) 
 
local cls = class("ThemeApollo_MapControl", parentClass)

function cls:ctor(_mainViewCtl)
    parentClass.ctor(self, _mainViewCtl)
    self.themeCtl = _mainViewCtl
    self.mapConfig = self:getGameConfig().map_config

end

function cls:initLayout(mapParent)
    self.mapParent = mapParent

    --self.mapView = view.new(self, mapParent)
end
function cls:getMapLevel()
    return self.themeCtl:getMapLevel()
end
function cls:getMapInfo()
    return self.themeCtl:getMapInfo()
end
function cls:setMapLevel(level)
    self.mapLevel = level
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
function cls:addExtraFgByBonus()
    self:playMusicByName("mapfg_add")
    local nextLevel = self:getMapLevel()
    local extraFg = self:getRealExtraFg()
    self.mapView:mapItemAddExtraFg(nextLevel, extraFg, true)
end
function cls:getAddExtraFg(byBonus)
    local addFg = self:getMapInfo().extra_fg
    if byBonus and self.themeCtl.bonus then
        local wheelCtl = self.themeCtl.bonus.wheelCtl
        local bonus_add_fg = wheelCtl.myBonusData.extra_fg
        addFg = self:getMapInfo().extra_fg - bonus_add_fg
    end
    return addFg
end
function cls:getRealExtraFg()
    local addFg = self:getMapInfo().extra_fg
    return addFg
end
function cls:showMapScene(byScatter, isAni, totalFg)
    self.isOpenMapStatus = true
    self._mainViewCtl:hideActivitysNode()
    self._mainViewCtl:setFooterBtnsEnable(false)
    self._mainViewCtl:enableMapInfoBtn(false)
    --self:updateMapData(self._mainViewCtl:getMapInfoData())
    if not self.mapView then
        self.mapView = view.new(self, self.mapParent)
        if byScatter then
            if isAni then
                self.mapView:resetToUnopen(self:getMapLevel())
            end
            local extra_fg = self:getAddExtraFg(true)
            if byScatter == 2 and totalFg then
                extra_fg = totalFg - 5
            end
            self.mapView:mapItemAddExtraFg(self:getMapLevel(), extra_fg)
        end
    else
        self.mapView:update100Node(byScatter, isAni, totalFg)
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
        self._mainViewCtl:showActivitysNode()
        self._mainViewCtl:setFooterBtnsEnable(true)
        self._mainViewCtl:enableMapInfoBtn(true)
    end
end
function cls:getMapConfig()
    return self._mainViewCtl:getGameConfig().map_config
end
function cls:checkInFeature()
    return self.isOpenMapStatus
end
return cls

