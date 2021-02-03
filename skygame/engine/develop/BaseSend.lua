--[[
功能: 消息基类， 服务器内部或者跨服通信
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--
local cluster = require "skynet.cluster"

BaseSend = class("BaseSend")
local ProxyList = {}    --代理缓存
function BaseSend:ctor()
end

function BaseSend:DelayCall(sec, func) --秒
    local close = false
    local function cancel(  )
        close = true
    end
    SKY.timeout(sec*100, function()
        if close then return end
        func()
    end)
    return cancel
end

--[[发送给本地服务
    @server: 服务名
    @FuncName: 函数名
]]
function BaseSend:Send(server, FuncName, ...)   --异步
    local ok = pcall(SKY.send, server, "lua", FuncName, ...)
    if not ok then
        return SERVERERROR
    end
end

function BaseSend:Call(server, FuncName, ...)   --阻塞,注意对self指针的影响
    local ok, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10 = pcall(SKY.call, server, "lua", FuncName, ...)
    if ok then 
        return r1, r2, r3, r4, r5, r6, r7, r8, r9, r10
    else
        return SERVERERROR
    end
end

--[[发送给远程服务
    @RemoteName: 节点名
    @LocalName: 服务名
    @FuncName: 函数名
]]
function BaseSend:SendRemote(RemoteName, LocalName, FuncName, ...)
    if not self:CheckSvrExist(RemoteName) then
        LOG("SendRemote error,", RemoteName)
        return
    end

    if RemoteName == xSvrInfo.NAME then   --就是自己
        return self:Send(LocalName, FuncName, ...)
    else
        local key = RemoteName..LocalName
        local proxy = ProxyList[key]
        if not proxy then
            proxy = cluster.proxy(RemoteName, LocalName)
            ProxyList[key] = proxy
        end
        return self:Send(proxy, FuncName, ...)
    end
end

function BaseSend:CallRemote(RemoteName, LocalName, FuncName, ...)  --判断是否断开
    if not self:CheckSvrExist(RemoteName) then
        LOG("CallRemote error,", RemoteName)
        return
    end

    if RemoteName == xSvrInfo.NAME then   --就是自己
        return self:Call(LocalName, FuncName, ...)
    else
        local key = RemoteName..LocalName
        local proxy = ProxyList[key]
        if not proxy then
            proxy = cluster.proxy(RemoteName, LocalName)
            ProxyList[key] = proxy
        end
        return self:Call(proxy, FuncName, ...)
    end
end

function BaseSend:GetGlobal(keyname)
    return self:Call(xSvrInfo.SERVICE.GLOBAL, "RemoteGetData", keyname)
end

function BaseSend:SetGlobal(keyname, value)
    return self:Call(xSvrInfo.SERVICE.GLOBAL, "RemoteSetData", keyname, value)
end

function BaseSend:CheckSvrExist(svrname)
    return _G[svrname]
end