--[[
功能: 无逻辑，只是为了自动创建账号表
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

require("engine.develop.BaseDB")
--@SuperType [engine.develop.BaseDB#BaseDB]
AutoSqlUserInfo = class("AutoSqlUserInfo", BaseDB)

function AutoSqlUserInfo:ctor()
    BaseDB.ctor(self)
    
    self:DBInit(xSvrInfo.DBCENTER, "userinfo", "UID")
    self:DBAutoAdd("UID", 1000)

    self:DBData("UID", "number", 0)                 --用户ID    
    self:DBData("GameSvrID", "number", 0)           --服务器ID
    self:DBData("UserName", "string", "")           --用户名
    self:DBData("BannedTime", "time", 0)            --封禁时间
    self:DBData("EodGuestToken", "string", "")      --EOD游客ID
    self:DBData("AgreementVesion", "string", "")    --是否同意协议
end