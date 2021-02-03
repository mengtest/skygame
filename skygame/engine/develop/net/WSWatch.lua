--[[
功能: 客户端网关 负责接受客户端的连接与消息并转发
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

require("engine.develop.BaseServer")

local skynet = require("skynet")
local socket = require("skynet.socket")
local socketdriver = require("skynet.socketdriver")
local websocket = require("http.websocket")

--@SuperType [engine.develop.BaseServer#BaseServer]
WSWatch = class("WSWatch", BaseServer, BaseTimer)

function WSWatch:ctor()
    BaseServer.ctor(self)

    --基础网络数据
    self.protocol = xSvrInfo:GetV("wsmode") --网络模式
    local sprotoloader = require("sprotoloader")
    local netmsg = sprotoloader.load(1)
    self.host = netmsg:host("package")      --消息解析器

    self.TagGateBind = {}   --网关绑定
    self.SockTranBind = {}  --跨服绑定

    self:InitHandler()
end

--初始化消息回调
function WSWatch:InitHandler()
    self.handler = {}       --网络消息
    function self.handler.connect(sock)
        --连接成功
        for tag, gate in pairs(self.TagGateBind) do
            self:Send(gate, "OpenClient", sock) 
        end
    end
    function self.handler.message(sock, msg) 
        --消息分发
        local ok, proto, msgdata, header = pcall(self.host.dispatch2, self.host, msg)
        if ok then --消息解析准正确
            local BindServerID = nil
            local tag = string.sub(proto.name, 1, 1)
            local translist = self.SockTranBind[sock]
            if translist then
                BindServerID = translist[tag]
            end
            if BindServerID then --有绑定， 转发
                self:SendRemote(xSvrInfo.NAME..BindServerID, xSvrInfo.SERVICE.WATCH, "DistributeClientMsg", tag, sock, header, proto, msgdata, xSvrInfo.ID)
            else
                self:DistributeClientMsg(tag, sock, header, proto, msgdata, xSvrInfo.ID)
            end
        end
    end
    local function _close(sock)
        --连接断开
        for tag, gate in pairs(self.TagGateBind) do
            self:Send(gate, "CloseClient", sock) 
        end
    end
    function self.handler.close(sock, code, reason)
        _close(sock)
    end
    function self.handler.error(sock)
        _close(sock)
    end
    function self.handler.ping(id)
    end
    function self.handler.pong(id)
    end
    function self.handler.handshake(sock, header, url)
    end
end

function WSWatch:DistributeClientMsg(tag, sock, header, proto, msgdata, ProxySvrID )
    local gate = self.TagGateBind[tag]
    if gate then --分发消息到不同的模块
        self:Send(gate, "RecvClientMsg", sock, header, proto, msgdata, ProxySvrID)
    end
end

--绑定网关
function WSWatch:BindGate(tag, gate)
    self.TagGateBind[tag] = gate
end

--检测sock
function WSWatch:CheckSock(sock)
    return sock and not socket.invalid(sock) and not socket.disconnected(sock)
end

--主动关闭网络
function WSWatch:CloseSock(sock)
    self.handler.close(sock)
    websocket.close(sock)
end

--发送二进制消息
function WSWatch:SendBinary(sock, data)
    websocket.write(sock, data, "binary")
end

--转发二进制消息
function WSWatch:TranBinary(serverid, sock, data)
    self:SendRemote(xSvrInfo.NAME..serverid, xSvrInfo.SERVICE.WATCH, "SendBinary", sock, data)
end

WSWatch.new():Start(xSvrInfo.SERVICE.WATCH, function(self)
    local addr = xSvrInfo:GetV("address")
    local isNodelay = xSvrInfo:GetV("NoDelay")
    local listenid = socket.listen( table.unpack(string.split(addr, ":")) )
    if isNodelay == "true" then
        socketdriver.nodelay(listenid)   --无延迟模式
    end
    LOG("Listening address:", addr, "NoDelay:", isNodelay, "Mode:", self.protocol)
    socket.start(listenid, function(clientid, clientaddr)
        websocket.accept(clientid, self.handler, self.protocol, clientaddr)
    end)
end)