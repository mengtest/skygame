require("engine.develop.BaseServer")

--服务器网关

--@SuperType  [engine.develop.BaseServer#BaseServer]
WSGate = class("WSGate", BaseServer)
function WSGate:ctor( )
    BaseServer.ctor(self)

    self.SockAgentBind = {}
    self.DefaultAgent = nil
end

function WSGate:InitGate(Tag, Gate, DefaultAgentFile)
    if DefaultAgentFile then
        self.DefaultAgent = SKY.newservice(DefaultAgentFile)
    end
    if Tag and Gate then
        self:Send(xSvrInfo.SERVICE.WATCH, "BindGate", Tag, Gate)
    end
end

function WSGate:OpenClient(sock)
    local bindAgent = self.SockAgentBind[sock]
    if bindAgent then
        self:Send(bindAgent, "OpenClient", sock)
    elseif self.DefaultAgent then
        self:Send(self.DefaultAgent, "OpenClient", sock)
    end
end

function WSGate:CloseClient(sock)
    local bindAgent = self.SockAgentBind[sock]
    if bindAgent then
        self:Send(bindAgent, "CloseClient", sock)
    elseif self.DefaultAgent then
        self:Send(self.DefaultAgent, "CloseClient", sock)
    end
end

--[[
	@desc: 处理客户端消息
	--@sock: sock
	--@header: 头
	--@proto: 消息头
	--@msgdata: 携带的数据
	--@ProxySvrID: 转发服务器ID
]]
function WSGate:RecvClientMsg(sock, header, proto, msgdata, ProxySvrID)
    local bindAgent = self.SockAgentBind[sock]
    if bindAgent then
        self:Send(bindAgent, "ProcClientMsg", sock, header, proto, msgdata, ProxySvrID)
    elseif self.DefaultAgent then
        self:Send(self.DefaultAgent, "ProcClientMsg", sock, header, proto, msgdata, ProxySvrID)
    end
end

function WSGate:BindAgent(sock, agent)
    self.SockAgentBind[sock] = agent
end

function WSGate:UnBindAgent(sock)
    self.SockAgentBind[sock] = nil
end