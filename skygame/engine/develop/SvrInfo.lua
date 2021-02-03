--[[
功能: 
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--
SvrInfo = class("SvrInfo")

function SvrInfo:ctor()
    self.NAME = self:GetV("SvrName")  	--服务器名字+ID
    self.ID = self:GetV("SvrID")        --服务器ID
	self.AREA = self:GetV("SvrArea")	--服务器地区
    self.IP = self:GetV("ipaddress")	--对外服务器地址
    
    self.AgreementVersion = self:GetV("AgreementVersion")
    
    self.IsOpenLog = self:IsV("IsOpenLog") --是否打印普通日志
    self.IsOpenBigint = self:IsV("IsOpenBigint") --是否开启大数字

    self.DBCENTER = self:GetV("DBCenterName")        --中央数据库
    self.DBGAME = self:GetV("DBGameName")..self.ID   --游戏数据库
    --服务
    self.SERVICE = {
        WATCH = ".wswatch",
        DBC = ".DBCenter",
        GLOBAL = ".globaldata",
        GMBACKSTAGE = ".GMBackStage",
        DBLOGGAME = ".DBLogGame",
        DBLOGCHAT = ".DBLogChat",
        DBLOGBATTLE = "DBLogBattle"
    }

    --网关
    self.GATE = {
        SYSTEM = ".systemgate",
        LOGIN = ".logingate",
        GAME = ".gamegate",
        ROOM = ".roomgate",
        BATTLE = ".battlegate",
        CHAT = ".chatgate",
    }
end

function SvrInfo:GetV(key)
    local v = SKY.getenv(key)
    if v == nil then return end
    return tonumber(v) or v
end

function SvrInfo:IsV(key)
    if SKY.getenv(key) == "true" then
        return true
    else
        return false
    end
end

xSvrInfo = SvrInfo.new()