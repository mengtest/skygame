--[[
功能: HTTP网关 负责处理客户端的连接与断开， 创建并管理agent 
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

require("engine.develop.BaseServer")
local SERVICE_NAME, IP, PORT = ...
--@SuperType [engine.develop.BaseServer#BaseServer]
HTTPGate = class("HTTPGate", BaseServer)
function HTTPGate:ctor( )
    BaseServer.ctor(self)
end

HTTPGate.new():Start(nil, function(self)
    local agent = SKY.newservice(SERVICE_NAME)
    -- 监听端口
    local socket = require "skynet.socket"
    local id = socket.listen(IP, PORT)
    socket.start(id, function(id, addr)
        self:Send(agent, "ProcMsg", id)
    end)
end)