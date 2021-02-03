--[[
功能: 
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--
require("engine.develop.user.BaseUserProc")
require("script.SvrGame.User.UserData")
--@SuperType [engine.develop.user.BaseUserProc#BaseUserProc]
UserProc = class("UserProc", BaseUserProc)
function UserProc:ctor( )
    BaseUserProc.ctor(self)

    GUSER = UserData.new()
    GPROC = self
end

UserProc.new():Start()