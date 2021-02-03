--[[
功能: 战场数据记录，操作排名等。
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

require("engine.develop.BaseServer")
local mongo = require "skynet.db.mongo"
--@SuperType [engine.develop.BaseServer#BaseServer]
DBLogBattle = class("DBLogBattle", BaseServer)

local dbname = xSvrInfo:GetV("LOGDBNAME_BATTLE")
function DBLogBattle:ctor()
    BaseServer.ctor(self)
    self.tabkey = os.date("%Y%m%d", os.time())
end

--safeinsert 不能插入递归表， 要注意只能用bson
function DBLogBattle:OutPutLog(data) 
    self.db[dbname][self.tabkey]:safe_insert(data)
end

function DBLogBattle:FindBattleLog()
end

function DBLogBattle:GetLastRoomID(BattleSvrID)
end

-- function DBLogBattle:FindLast(selector, number)
--     local data = {}
--     local ret = self.db[dbname][self.tabkey]:find(selector)
--     if ret:count() > number then
--         ret = ret:skip(ret:count() - number)
--     end
--     while ret and ret:hasNext() do
--         table.insert(data, ret:next()) 
--     end
--     return data
-- end

-- function DBLogBattle:FindScope(selector, day)
--     local now = os.time()
--     local data = {}
--     for i=day-1, 0, -1 do
--         local tabkey = os.date("%Y%m%d", os.time()-i*24*60*60)
--         local ret = self.db[dbname][tabkey]:find(selector)
--         while ret:hasNext() do
--             table.insert(data, ret:next())
--         end
--     end
--     return data
-- end

function DBLogBattle:Run()
    self.db = mongo.client(
        {
            host = xSvrInfo:GetV("LOGDBHOST"), 
            port = xSvrInfo:GetV("LOGDBPORT"),
            username = xSvrInfo:GetV("LOGDBUSERNAME"), 
            password = xSvrInfo:GetV("LOGDBPASSWORD"),
			authdb = dbname,
        }
    )

    self:BindTimer(60, function()
        self.tabkey = os.date("%Y%m%d", os.time()) --刷新日志表名
    end, self, true)
end

DBLogBattle.new():Start(xSvrInfo.SERVICE.DBLOGBATTLE)