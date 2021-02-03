local _IsService = ...

require("engine.develop.BaseDB")
require("engine.develop.BaseServer")
require("engine.develop.Schedule")

--@SuperType [engine.develop.BaseDB#BaseDB]
GlobalData = class("GlobalData", BaseDB, BaseServer)
function GlobalData:ctor()
    BaseDB.ctor(self)
    BaseServer.ctor(self)

    self:DBInit(xSvrInfo.DBCENTER, "GlobalData")  --无KEY

    --名字屏蔽库
    self.SensitiveMgr = require("engine.develop.sensitiveword.SensitiveMgr").new()
end

function GlobalData:RemoteGetData(keyname)
    if string.find(keyname, "DB_") then
        local db = self[keyname]
        return db.get()
    else
        return self[keyname]
    end
end

function GlobalData:RemoteSetData(keyname, value)
    if string.find(keyname, "DB_") then
        local db = self[keyname]
        db.set(value)
    else
        self[keyname] = value
    end
end

function GlobalData:RemoteCheckSensitive(str)
    return self.SensitiveMgr:Check(str)
end

function GlobalData:Run()
    self:DBAutoRead() --初始化加载全局数据
end

if _IsService == "true" then
    GlobalData.new():Start(xSvrInfo.SERVICE.GLOBAL)
end