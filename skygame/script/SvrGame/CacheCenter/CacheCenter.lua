require("script.SvrGame.User.UserProc")
require("engine.develop.mysql.DBMgr")
--@SuperType [script.SvrGame.User.UserProc#UserProc]
CacheCenter = class("CacheCenter", UserProc)

local WAITING_LOAD = "_waitingforload"
--给不在线的玩家发消息都到这里，　玩家上线后删除这里的缓存
function CacheCenter:ctor()
    BaseServer.ctor(self)

    self.UserControlList = {}
end

function CacheCenter:RemoveUserCache(UID)    --这个玩家上线了，保存并清空缓存
    xDBMgr:AutoProc()
    self.UserControlList[UID] = nil
end

function CacheCenter:CacheLocalMsg(Type, UID, FuncName, ...)
    local userctrl = self.UserControlList[UID]

    if userctrl == WAITING_LOAD then --这个地方要优化
        while true do
            userctrl = self.UserControlList[UID]
            if userctrl ~= WAITING_LOAD then
                break
            end
            SKY.sleep(10)   --100MS skynet时间单位 100是1秒
        end
    end

    if not userctrl then    --没有缓存
        local res = xDBTool:DBQueryGame("SELECT UID FROM playerinfo WHERE UID=%d", UID)
        if not CheckSqlR(res) then return end --玩家不存在

        userctrl = UserControl.new()
        userctrl:CreateNewUser(true)
        --缓存中心全局对象切换
        GPROC = userctrl
        GUSER = userctrl.USER

        self.UserControlList[UID] = WAITING_LOAD
        if Type == SEND.BASE then
            userctrl["LoadBase"](userctrl, UID)
        elseif Type == SEND.DETAIL then
            userctrl["LoadDetail"](userctrl, UID, {})
        end
        --注意， 数据库会让出线程， 必须等待, 同时访问某个用户注意重复加载的问题
        self.UserControlList[UID] = userctrl
    else
        --缓存中心全局对象切换
        GPROC = userctrl
        GUSER = userctrl.USER
    end
    --如果类型不匹配
    if Type == SEND.DETAIL and userctrl.LoadType ~= SEND.DETAIL then 
        userctrl["LoadDetail"](userctrl, UID, {})
    end
    local f = assert(userctrl[FuncName]) --查询具体处理方法
    if f then
        local ok,result = SafeCall(f, userctrl, ...)
        if ok then
            return result   --回应
        else
            LOG(result)
        end
    end
end

CacheCenter.new():Start()