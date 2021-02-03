--[[
功能: 游戏日志
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--
require("engine.develop.BaseServer")

local mongo = require "skynet.db.mongo"
--@SuperType [engine.develop.BaseServer#BaseServer]
DBLogGame = class("DBLogGame", BaseServer)

local dbname = xSvrInfo:GetV("LOGDBNAME_GAME")
function DBLogGame:ctor()
    BaseServer.ctor(self)
    self.tabkey = os.date("%Y%m%d", os.time())
end

function DBLogGame:OutPutLog(data)
    self.db[dbname][self.tabkey]:safe_insert(data)
end

function DBLogGame:Run()
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

DBLogGame.new():Start(xSvrInfo.SERVICE.DBLOGGAME)