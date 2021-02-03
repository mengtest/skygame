--用户处理服务
require("engine.develop.net.WSAgent")

--@SuperType [engine.develop.net.WSAgent#WSAgent]
BaseUserProc = class("BaseUserProc", WSAgent)

function BaseUserProc:ctor()
    WSAgent.ctor(self)
end

--[[
	@desc: 加载完整玩家数据
	--@UID: 用户ID
	--@accountInfo: 账号信息
]]
function BaseUserProc:RemoteLoadDetail(UID, accountInfo) --登录成功进入游戏
    GUSER.UID = UID --注意!这个是内存的UID，不是数据库里面的
    local res = xDBTool:DBQueryGame("SELECT UID FROM playerinfo WHERE UID=%d", UID)
    if CheckSqlR(res) then 
        GUSER:OnLoadFromDB()    --已经存在，直接加载
    else    
        GUSER:OnLoadCreate()    --创建新用户
    end
    --加载完成
    GUSER:OnLoadSucceed()
end

function BaseUserProc:OpenClient() --连接成功
end

function BaseUserProc:CloseClient() --断开连接
    --有效账号离线
    if GUSER.UID > 0 then    
        GUSER:OnPauseTimer()    --暂停计时器
        GUSER:OnDisconnect()    --断线
    end
    self.BackupSock = nil
    GUSER.SOCK = nil
end

function BaseUserProc:RemoteLoginSucceed() --登录成功
end

function BaseUserProc:CheckRepeatLogin(sock)
    local kicksock = nil
    if GUSER.SOCK ~= sock and self:Call(xSvrInfo.SERVICE.WATCH, "CheckSock", GUSER.SOCK) then  --重复登录了
        LOG("CheckRepeatLogin error, sock is repeat.", GUSER.SOCK, sock)
        --通知客户端重复登录
        self:SendNotice(NOTICE.RepeatLogin, GUSER.SOCK)
        kicksock = GUSER.SOCK
    end
    GUSER.SOCK = sock
    return kicksock
end

function BaseUserProc:Run()
    --写数据库, 关服的时候要按流程走， 避免数据库数据丢失。
    self:BindTimer(1, xDBMgr.AutoProc, xDBMgr)
end

