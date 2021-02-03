--[[
功能: HTTP对象
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--
require("engine.develop.BaseServer")

local socket = require("skynet.socket")
local httpd = require("http.httpd")
local sockethelper = require("http.sockethelper")
local urllib = require("http.url")
local httpmode = xSvrInfo:GetV("httpmode") or "http"
local luajson = require("engine.develop.LuaJson")
--@SuperType [engine.develop.BaseServer#BaseServer]
HTTPAgent = class("HTTPAgent", BaseServer)
function HTTPAgent:ctor()
    BaseServer.ctor(self)
    self.Protocol = nil

    self.IsResponse = false --不管结果如何必须有返回
    self.BackWrite = nil
    self.BackCode = nil
    self.BackUrl = nil

    self.SockList = {}
end

function HTTPAgent:NewSock(sock, write, code, url)
    local data = {
        IsResponse = false,
        BackWrite = write,
        BackCode = code,
        BackUrl = url,
    }
    self.SockList[sock] = data
    return data
end

function HTTPAgent:DelSock(sock)
    socket.close(sock)
    self.SockList[sock] = nil
end

function HTTPAgent:Response(sock, tab)
    local sockdata = self.SockList[sock]
    if not sockdata then
        LOG("Response sockdata error...")
        return
    end
    if not table.check(tab) then
        LOG("Response tab error,", sockdata.BackUrl, sockdata.BackCode)
        return
    end
    sockdata.IsResponse = true
    local headers = {
        ['Access-Control-Allow-Origin'] = '*', -- 这里写允许访问的域名就可以了，允许所有人访问的话就写*
        ['Access-Control-Allow-Credentials'] = true,
    } 
    local ok, err = httpd.write_response(sockdata.BackWrite, sockdata.BackCode, luajson.table2json(tab), headers)
    if not ok then
        LOG("Response write error,", sockdata.BackUrl, sockdata.BackCode)
    end
end

function HTTPAgent:Succeed(parm)
    self:Response(parm.SOCK, {msg="Succeed"})
end

function HTTPAgent:ProcMsg(sock)
    socket.start(sock) -- 开始接收一个 socket
    local interface = self:gen_interface(sock)
    if not interface then 
        LOG("gen_interface error, pls check.")
        return
    end
    local code, url, method, header, body = httpd.read_request(interface.read, 8192)
    local sockdata = self:NewSock(sock, interface.write, code, url)
    if code then
        if code ~= 200 then -- 如果协议解析有问题，就回应一个错误码 code 。
            self:Response(sock, {msg="Error"})
        else
            local path, query = urllib.parse(url)
            local parm = urllib.parse_query(query) --获取请求的参数
            if parm and table.nums(parm) > 0 then
                parm.SOCK = sock
                self:Succeed(parm)
            end
            if not sockdata.IsResponse then --如果重写的函数没返回，保底返回一次
                self:Response(sock, {msg="Http Succeed, But not do anything."})
            end
        end
    else
        -- 如果抛出的异常是 sockethelper.socket_error 表示是客户端网络断开了。
        if url == sockethelper.socket_error then
            LOG("socket closed")
        else
            LOG(url)
        end
    end
    self:DelSock(sock)
    if interface.close then
        interface.close()
    end
end

local SSLCTX_SERVER = nil
function HTTPAgent:gen_interface(fd)

    local p = self.Protocol or httpmode

	if p == "http" then
		return {
			close = nil,
			read = sockethelper.readfunc(fd),
			write = sockethelper.writefunc(fd),
		}
	elseif p == "https" then
        local function proc()
            local tls = require "http.tlshelper"
            if not SSLCTX_SERVER then
                SSLCTX_SERVER = tls.newctx()
                -- gen cert and key
                -- openssl req -x509 -newkey rsa:2048 -days 3650 -nodes -keyout server-key.pem -out server-cert.pem
                local certfile = SKY.getenv("certfile") or "./server-cert.pem"
                local keyfile = SKY.getenv("keyfile") or "./server-key.pem"
                SSLCTX_SERVER:set_cert(certfile, keyfile)
            end
            local tls_ctx = tls.newtls("server", SSLCTX_SERVER)
            local init = tls.init_responsefunc(fd, tls_ctx)
            init()
            return {
                close = tls.closefunc(tls_ctx),
                read = tls.readfunc(fd, tls_ctx),
                write = tls.writefunc(fd, tls_ctx),
            }
        end
        local ok, reslut = pcall(proc)
        if ok then
            return reslut
        else
            LOG("certfile error, pls check.")
        end
	else
		LOG(string.format("Invalid protocol: %s", self.Protocol))
	end
end