--[[
功能: 消息处理基类
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--
require("engine.develop.Schedule")
require("engine.develop.mysql.DBTool")
--@SuperType [engine.develop.BaseSend#BaseSend]
BaseProc = class("BaseProc", BaseSend)

function BaseProc:ctor()
    BaseSend.ctor(self)
end