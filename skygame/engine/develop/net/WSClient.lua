
--[[
功能: WS客户端， 一般用于机器人
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--
local websocket = require("engine.lualib.http.websocket")
local service = require "skynet.service"
local skynet = require "skynet"
local sockethelper = require "http.sockethelper"
local socket = require "skynet.socket"

--@SuperType [engine.develop.net.WSBase#WSBase]
WSClient = class("WSClient", WSBase)

function WSClient:ctor()
    local sprotoloader = require "sprotoloader"
    self.host = sprotoloader.load(1):host "package"
    self.request = self.host:attach(sprotoloader.load(1))
    self.SessionFuncList = {}
    self.session = 0
    self.fd = nil --连接
end

function WSClient:Connect(ip, port, CallBack)
    self.fd = websocket.connect(string.format("ws://%s:%d", ip, port))
    local function _Proc()
        while true do
            local resp, close_reason = websocket.read(self.fd)   
            if not resp then
                print("echo server close.")
                self:DisConnect()
                break
            else
                self:RecvServerMsg(self.fd, resp)
            end
            skynet.sleep(1)
        end 
    end

    skynet.fork(function() pcall(_Proc) end)
    skynet.fork(CallBack)
end

function WSClient:NetMsgProc(name, data) --处理服务器主动消息
    local f = self["PROC_"..name]
    if f then
        LOG("Recv Msg:",name)
        SafeCall(f, self, data)
    end
end

function WSClient:RecvServerMsg(sock, msg) 
    local function _procrecvmsg(sock, ok, type, ...)
    if not ok then return end
        --处理服务器请求
        local function _proc_request(name, args, response, userdata)
            self:NetMsgProc(name, args)
        end
        --处理服务器的回答
		local function _proc_response(session, args, userdata)
            local f = self.SessionFuncList[session]
            if f then
                f(args)
            end
        end
        if type == "REQUEST" then   --服务器的请求
            local result  = _proc_request(...)
            if result then   --回答客户端的请求（RPC模式）
                --self.net:send_binary(sock, result)
            end
        elseif type == "RESPONSE" then  --服务器的回应
            _proc_response(...)
        end
    end
    _procrecvmsg(sock, pcall(self.host.dispatch, self.host, msg))
end

function WSClient:Send(name, args, func)
    if not self.fd then
        LOG("Send error, connect is error. CMD: "..name)
        return
    end
    self.session = self.session + 1
    local str = self.request(name, args or {}, self.session)
    websocket.write(self.fd, str, "binary")
    if func then
        self.SessionFuncList[self.session] = func
    end
end

function WSClient:IsConnect()
    return self.fd
end

function WSClient:DisConnect(func)
    if self.fd then
        socket.close(self.fd)
        self.fd = nil
        if func then
            func()
        end
    end
end