require("engine.develop.mysql.DBMgr")

BaseUserData = class("BaseUserData", BaseSend)

function BaseUserData:ctor()
    BaseSend.ctor(self)
    
    self.SOCK = nil             --用户SOCK
    self.UID = 0                --用户UID
end

--创建新用户
function BaseUserData:OnLoadCreate()
    LOG("OnLoadCreate")
    xDBMgr:BeginTransaction() --开始事务
    xEvent:FireEvent(EVENT_USER.OnLoadCreate)
    xDBMgr:CloseTransaction() --结束事务
end

function BaseUserData:OnLoadFromDB()
    LOG("OnLoadFromDB")
    xEvent:FireEvent(EVENT_USER.OnLoadFromDB)
end

--加载完成，只会执行一次
function BaseUserData:OnLoadSucceed()
    LOG("OnLoadSucceed")
    xEvent:FireEvent(EVENT_USER.OnLoadSucceed)
end

--登录进入游戏, 数据未发送
function BaseUserData:OnEnterGame()
    LOG("OnEnterGame")
    xEvent:FireEvent(EVENT_USER.OnEnterGame)
end

--登录进入游戏，数据已发送
function BaseUserData:OnBeginGame()
    LOG("OnBeginGame")
    xEvent:FireEvent(EVENT_USER.OnBeginGame)
end

--重新连线
function BaseUserData:OnReconnection()
    LOG("OnReconnection")
    xEvent:FireEvent(EVENT_USER.OnReconnection)
end

--玩家离线
function BaseUserData:OnDisconnect()
    LOG("OnDisconnect")
    xEvent:FireEvent(EVENT_USER.OnDisconnect)
end

--暂停计时器
function BaseUserData:OnPauseTimer()
    LOG("OnPauseTimer")
    xEvent:FireEvent(EVENT_USER.OnPauseTimer)
end

--恢复计时器
function BaseUserData:OnRestoreTimer()
    LOG("OnRestoreTimer")
    xEvent:FireEvent(EVENT_USER.OnRestoreTimer, true)
end