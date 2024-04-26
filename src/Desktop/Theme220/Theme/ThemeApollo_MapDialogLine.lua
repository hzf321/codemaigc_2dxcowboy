---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2020/11/30 18:55
---
local LINE_TYPE = {
    mapNode    = 0,
    dialogNode = 1
}
local cls = class("ThemeApollo_MapDialogLine")
function cls:ctor(ctl, node, index, from)
    self.ctl = ctl
    self.node = node
    self.lineChilds = self.node:getChildren()
    local config = self.ctl:getGameConfig().map_config
    self.index = index
    local lineType = config.all_node_type[self.index]
    local showList = config.map_type_list[lineType]
    local big_node_config = config.big_node_config[self.index]
    local big_node_type_list = config.big_node_type_list
    self.from = from
    self.cellHeight = 35
    if self.from == LINE_TYPE.dialogNode then
        self.cellHeight = 60
    end
    self:resetLine(showList, big_node_config, big_node_type_list)
end

function cls:resetLine(showList, big_node_config, big_node_type_list)
    for key = 2, #self.lineChilds do
        local child = self.lineChilds[key]
        local index = 0
        for key2 = 2, #showList do
            if key == showList[key2] then
                index = key2
                break
            end
        end
        if index == 0 then
            child:setVisible(false)
        else
            local map_type = big_node_type_list[key]
            if map_type.key and big_node_config[map_type.key] then
                local key2 = map_type.key
                local cnt = child:getChildByName("fnt")
                local str = big_node_config[key2]
                if cnt and str then
                    if key2 == "multi" then
                        str = str .. "X"
                    end
                    cnt:setString(str)
                end
            end
            child:setVisible(true)
            child:setPositionY(-self.cellHeight * (index - 1))
        end
    end
end

return cls


