require("engine.develop.net.WSAgent")
require("engine.develop.BaseTimer")

--@SuperType [engine.develop.net.WSAgent#WSAgent|engine.develop.BaseTimer#BaseTimer]
SystemProc = class("SystemProc", WSAgent, BaseTimer)
function SystemProc:ctor()
    WSAgent.ctor(self)
    BaseTimer.ctor(self)

    self.HeartbeatList = {} --心跳列表
end

function SystemProc:OpenClient(sock)
    self.HeartbeatList[sock] = os.time()

    --self:SendToClient("SYSTEM_SC_TESTMSG", {servertime=os.time(), teststr="helloworld"}, sock)
end

function SystemProc:CloseClient(sock)
    self.HeartbeatList[sock] = nil
end

function SystemProc:SYSTEM_CS_TESTMSG(data, sock)
    table.log(data, "recv msg")
end

--握手消息， 绑定消息转发
function SystemProc:SYSTEM_CS_HANDSHAKE(data, sock)
    data.token = 0 --固定算法 年月+加密+固定字符串+位运算
    --通知watch 这个sock绑定的服务器
end

--心跳，获取服务器时间
function SystemProc:SYSTEM_CS_HEARTBEAT(data, sock)
    local now = os.time()
    self.HeartbeatList[sock] = now
    return { ServerTimeTick = now }
end

--重连
function SystemProc:SYSTEM_CS_RECONNECT(data, sock)
    self.HeartbeatList[sock] = os.time()
end

function SystemProc:Run()
    -- self:BindTimer(60, function()
    --     local now = os.time()
    --     for sock, v in pairs(self.HeartbeatList) do
    --         local t = now - v
    --         if t >= 60 then  --心跳超时
    --             LOG("Heartbeat lag,", "sock:"..sock, "time:"..t)
    --             self:Send(xSvrInfo.SERVICE.WATCH, "CloseSock", sock)
    --         end
    --     end
    -- end)
end

SystemProc.new():Start()