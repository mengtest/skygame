--[[
功能: 无逻辑，只是为了自动创建表
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

require("engine.develop.BaseDB")
--@SuperType [engine.develop.BaseDB#BaseDB]
AutoSqlGmbackstageinfo = class("AutoSqlGmbackstageinfo", BaseDB)

function AutoSqlGmbackstageinfo:ctor()
    BaseDB.ctor(self)
    
    self:DBInit(xSvrInfo.DBCENTER, "gmbackstageinfo")

    self:DBData("GMCommond", "string", "")
    self:DBData("JsonData", "string", "")    
end