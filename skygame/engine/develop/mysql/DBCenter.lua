--[[
功能: DB服务， 接收所有的数据修改，并定时写入数据库
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

require("engine.develop.BaseServer")
--@SuperType [engine.develop.BaseServer#BaseServer]
DBCenter = class("DBCenter", BaseServer)

function DBCenter:ctor()
    BaseServer.ctor(self)

    self.mysql = require "skynet.db.mysql"
end

function DBCenter:Query(dbname, sqlstr) --执行数据库语句的时候会让出携程使用权
    local res
    if dbname == xSvrInfo.DBCENTER then
        res = self.DBCenter:query(sqlstr)
    elseif dbname == xSvrInfo.DBGAME then
        res = self.DBGame:query(sqlstr)
    end
    if res and res.badresult then
        LOG("=================SQLError GO=================")
        LOG("DB:",dbname, " SQL:", sqlstr, "SvrName:", xSvrInfo.NAME)
        table.log(res)
        LOG("=================SQLError END=================")
        return nil
    else 
        return res
    end
end

function DBCenter:ConnectDBCenter()
    self.DBCenter = self.mysql.connect({
        database = xSvrInfo.DBCENTER,
        host = xSvrInfo:GetV("DBCenterHost"),
        port = xSvrInfo:GetV("DBCenterPort"),
        user = xSvrInfo:GetV("DBCenterUser"),
        password = xSvrInfo:GetV("DBCenterPassword"),
        max_packet_size = xSvrInfo:GetV("DBMax_Packet_Size"),
        on_connect = function() 
            LOG("connect centerdb ok") 
        end
    })       
end

function DBCenter:ConnectDBGame()
    self.DBGame = self.mysql.connect({
        database = xSvrInfo.DBGAME,
        host = xSvrInfo:GetV("DBGameHost"),
        port = xSvrInfo:GetV("DBGamePort"),
        user = xSvrInfo:GetV("DBGameUser"),
        password = xSvrInfo:GetV("DBGamePassword"),
        max_packet_size = xSvrInfo:GetV("DBMax_Packet_Size"),
        on_connect = function()   
            LOG("connect gamedb ok") 
        end
    })
end

function DBCenter:Run()
    --检查数据库是否存在
    local checkdb = self.mysql.connect({
        host = xSvrInfo:GetV("DBGameHost"),
        port = xSvrInfo:GetV("DBGamePort"),
        user = xSvrInfo:GetV("DBGameUser"),
        password = xSvrInfo:GetV("DBGamePassword"),
        max_packet_size = xSvrInfo:GetV("DBMax_Packet_Size"),
    })
    checkdb:query(string.format("CREATE DATABASE IF NOT EXISTS %s DEFAULT CHARACTER SET='utf8mb4';", xSvrInfo.DBCENTER))
    checkdb:query(string.format("CREATE DATABASE IF NOT EXISTS %s DEFAULT CHARACTER SET='utf8mb4';", xSvrInfo.DBGAME))
end

DBCenter.new():Start(xSvrInfo.SERVICE.DBC)