require("engine.develop.BaseServer")

--@SuperType [engine.develop.BaseServer#BaseServer]
WSAgent = class("WSAgent", BaseServer)

function WSAgent:ctor()
    BaseServer.ctor(self)

    local sprotoloader = require("sprotoloader")
    self.netmsg = sprotoloader.load(1)
    self.host = self.netmsg:host("package")         --消息解析
    self.request = self.host:attach(self.netmsg)    --主动发送

    self.BackupProxySvrID = nil
    self.BackupSock = nil --上一个通信者的sock，游戏服中一个agent代表一个玩家， 战斗服中代表一个房间
    self.SendFailCache = {} --发送不成功的缓存

    self.NoticeNetMsgName = "SYSTEM_SC_NOTICE"
end

function WSAgent:OpenClient(sock)
end

function WSAgent:CloseClient(sock)
end

function WSAgent:ProcClientMsg(sock, header, proto, msgdata, ProxySvrID)
    local _Func = self[proto.name]
    if _Func then
        self.BackupSock = sock
        self.BackupProxySvrID = ProxySvrID
        local default = self.netmsg:default(proto.name, "REQUEST")    --创建消息缺省表
        table.merge(default, msgdata) --没有默认值， 需要判断客户端缺省的内容是否为空。
        local reslut = _Func(self, default, sock)
        --自动回复消息
        if header.session and reslut then
            local response = self.host:getresponse(proto.response, header.session)
            self:SendBinary(sock, response(reslut))
        end
    else
        WARN("ProcClientMsg not found msg function.", proto.name)
    end
end

--发送二进制消息
function WSAgent:SendBinary(sock, msgdata)
    if self.BackupProxySvrID == xSvrInfo.ID then
        self:Send(xSvrInfo.SERVICE.WATCH, "SendBinary", sock, msgdata)
    else
        self:Send(xSvrInfo.SERVICE.WATCH, "TranBinary", self.BackupProxySvrID, sock, msgdata)
    end
end

function WSAgent:SendRequest(sock, name, args)--服服务端主动发消息 sock 函数名 内容表 回调函数 数据指针
    local msgdata = self.request(name, args)
    self:SendBinary(sock, msgdata)
end

function WSAgent:SendToClient(name, data, sock, callback)
    if self.BackupSock then   --在线
        self:SendRequest(L(sock, self.BackupSock), name, data, callback)
        return true
    else
        table.insert( self.SendFailCache, {name=name, data=data, callback=callback} )
        return false
    end
end

--发送通知
function WSAgent:SendNotice(noticeID, sock)
    if self.BackupSock then
        self:SendRequest(L(sock, self.BackupSock), self.NoticeNetMsgName, {NoticeID=noticeID})
    end
end

--[[
	@desc: 远程执行函数
	--@FuncName:
	--@args: 
]]
function WSAgent:RemoteExecuteFunc(FuncName, ...)
    local func = self[FuncName] --查询具体处理方法
    if func then
        local ok,result = SafeCall(func, self, ...)
        if ok then
            return result--回应
        else
            WARN(result)
        end
    end
end