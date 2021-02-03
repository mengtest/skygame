--[[
功能: 
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

require("script.SvrGame.GameModule")
require("engine.develop.user.BaseUserData")
--@SuperType [engine.develop.user.BaseUserData#BaseUserData]
UserData = class("UserData", BaseUserData)
function UserData:ctor( )
    BaseUserData.ctor(self)

    self.PLAYER = PlayerLogic.new() --玩家对象
end