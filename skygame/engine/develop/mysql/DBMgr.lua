--[[
功能: DB管理
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--
require("engine.develop.mysql.DBTool")
DBMgr = class("DBMgr")

function DBMgr:ctor()
    self.TransactionKey = nil  --事务key
    self.TransactionList = {}   --事务列表

    self.EventList = {}
    self.HashList = {}

    self.TransactionIndex = 0
end

function DBMgr:BeginTransaction()
    self.TransactionIndex = self.TransactionIndex + 1
    
    self.TransactionKey = self.TransactionIndex.."_"..os.time() --避免重复
end
function DBMgr:CloseTransaction()
    self.TransactionKey = nil
end

function DBMgr:_Proc(sqldata)
    if sqldata.insert then
        if not sqldata.obj:_DBAutoInsert() then
            return false
        end
    end
    if sqldata.update then
        if not sqldata.obj:_DBAutoUpdate() then
            return false
        end
    end
    if sqldata.delete then
        if not sqldata.obj:_DBAutoDelete() then
            return false
        end
    end
    if sqldata.DIYQUERY then
        local res
        if sqldata.obj.DBName == xSvrInfo.DBCENTER then
            res = xDBTool:DBQueryCenter(sqldata.obj.sqlstr, table.unpack(sqldata.obj.args))
        elseif sqldata.obj.DBName == xSvrInfo.DBGAME then
            res = xDBTool:DBQueryGame(sqldata.obj.sqlstr, table.unpack(sqldata.obj.args))
        end
        if not CheckSql(res) then
            return false
        end
    end
    return true
end

function DBMgr:AutoProc()
    for TransactionKey, list in pairs(self.TransactionList) do
        local succeed = true;
        local commitList = {}   --提交列表， 事务中可能存在其它数据库
        for k,sqldata in ipairs(list) do
            --@RefType [engine.develop.BaseDB#BaseDB]
            local dbobj = sqldata.obj
            if not commitList[dbobj.DBName] then    --新的事务组
                table.push(commitList, dbobj.DBName, dbobj)
                xDBTool:DBBeginTran(dbobj.DBName)
            end
            succeed = self:_Proc(sqldata)
            if not succeed then break end
        end
        if succeed then   
            --事务全部成功，全部提交
            for DBName,dbobj in pairs(commitList) do
                xDBTool:DBCommitTran(DBName)
            end
        else  
            --有一个事务失败了，全部回滚
            for DBName,dbobj in pairs(commitList) do
                xDBTool:DBRollbackTran(DBName)
            end  
        end
    end
    self.TransactionList = {}

    if #self.EventList > 0 then
        for k,sqldata in ipairs(self.EventList) do
            self:_Proc(sqldata)
        end
        self.HashList = {}
        self.EventList = {}
    end
end

function DBMgr:Bind(data)
    if self.TransactionKey then  --事务处理
        local list = self.TransactionList[self.TransactionKey]
        if not list then
            list = {}
            self.TransactionList[self.TransactionKey] = list
        end
        local sqldata = {obj=data}
        table.insert(list, sqldata)
        return sqldata
    else
        if not self.HashList[data] then
            local sqldata = {obj=data}
            self.HashList[data] = sqldata
            table.insert(self.EventList, sqldata)
            return sqldata
        else
            return self.HashList[data]
        end
    end
end

function DBMgr:RegInsert(data)
    local sqldata = self:Bind(data)
    sqldata.insert = true
end

function DBMgr:RegDelete(data)
    local sqldata = self:Bind(data)
    sqldata.delete = true
end

function DBMgr:RegUpdate(data)
    local sqldata = self:Bind(data)
    sqldata.update = true
end

function DBMgr:RegQuery(DBName, sqlstr, ...)
    local obj = {DBName=DBName, sqlstr=sqlstr, args=table.pack(...)}
    local sqldata = self:Bind(obj)
    sqldata.DIYQUERY = true
end

xDBMgr = DBMgr.new()