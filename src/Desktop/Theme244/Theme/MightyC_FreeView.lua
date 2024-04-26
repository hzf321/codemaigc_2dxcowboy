-- @Author: xiongmeng
-- @Date:   2021-03-23 10:35:58
-- @Last Modified by:   xiongmeng
-- @Last Modified time: 2021-03-23 21:53:48
local cls = class("MightyC_FreeView")
function cls:ctor(ctl)
	self.ctl = ctl
	self.gameConfig = self.ctl:getGameConfig()
end

function cls:stopDrawAnimate( ... )
    
end

function cls:hideFreeSpinNode( ... )
    
end
return cls

