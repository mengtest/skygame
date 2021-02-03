--[[
功能: DB工具
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--
require("engine.develop.BaseSend")
--@SuperType [engine.develop.BaseSend#BaseSend]
DBTool = class("DBTool", BaseSend)

function DBTool:ctor()
    BaseSend.ctor(self)
end

function DBTool:DBBeginTran(dbname) --开始事务
    return self:Call(xSvrInfo.SERVICE.DBC, "Query", dbname, "start transaction;")
end

function DBTool:DBCommitTran(dbname)  --提交事务
    return self:Call(xSvrInfo.SERVICE.DBC, "Query", dbname, "commit;")
end

function DBTool:DBRollbackTran(dbname) --失败回滚
    return self:Call(xSvrInfo.SERVICE.DBC, "Query", dbname, "rollback;")
end

function DBTool:DBQuery(dbname, sql, ...)    --数据库 dnname是为了给指定的数据库线程抛数据
    return self:Call(xSvrInfo.SERVICE.DBC, "Query", dbname, string.format(sql, ...))
end

function DBTool:DBQueryGame(sql, ...)
    return self:Call(xSvrInfo.SERVICE.DBC, "Query", xSvrInfo.DBGAME, string.format(sql, ...))
end

function DBTool:DBQueryCenter(sql, ...)
    return self:Call(xSvrInfo.SERVICE.DBC, "Query", xSvrInfo.DBCENTER, string.format(sql, ...))
end

--自动生成SQL表结构
function DBTool:CheckSqlTab()
    -- require("engine.common.Box.BoxLogic")
    -- local test = BoxLogic.new()
end

xDBTool = DBTool.new()