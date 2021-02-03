--[[
功能: 数据库基类， 自动创建表，自动读写，自动更新。
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

require("engine.develop.Binary")
require("engine.develop.mysql.DBMgr")
require("engine.develop.mysql.DBTool")

--添加类型要注意 BaseDB.LinkData
--注意mysql默认不区分大小写
local GAMETOMYSQL = {
    number = "int(11)", bool = "tinyint(4)", time = "datetime", 
    string = "varchar(255)", text = "text", diy = "longtext", map="longtext",
    bigint = "longtext",
}

BaseDB = class("BaseDB")

BaseDB.__IsDB = true

function BaseDB:ctor()
    self.Key = {}   --一般是UID
    self.TableName = "" --表名
    self.DBName = ""  --数据库名字
    self.DBBindData = {}
    self.DBBindTable = {}
    self.Change = {}

    self.DBAutoAddName = {}
    self.DBAutoAddNum = 0
end

--[[初始化
    @DBName 数据库名字
    @Tablename 表明 "eod_"..
    @... 语句条件key， 可变参
]]
function BaseDB:DBInit(DBName, Tablename, ...)
    self.DBName = DBName
    self.TableName = Tablename
    self.Key = {...}
end

--[[
	@desc: 设置某个字段为自增
    --@key: 字段名
    --@value：自增起始值
]]
function BaseDB:DBAutoAdd(key, value)
    self.DBAutoAddName[key] = true
    self.DBAutoAddNum = value
end

--[[ 绑定数据库值
    @name key
    @type 类型 number bool time string text 
    @value 值
]]
function BaseDB:DBData(name, type, value)    --key， 默认值 (只支持字符串和整形)
    local DBData = {}
    local self = self

    self.DBBindData[name] = {type=type, value=value, db=DBData}   --禁止直接访问
    
    --修改
    function DBData.set(num)  
        if type == "time" or type == "number" then
            self.DBBindData[name].value = math.floor(num)
        else
            self.DBBindData[name].value = num
        end
        self:DBRegUpdate(name)
    end

    --加 / 减
    function DBData.add(num)  
        local value = self.DBBindData[name].value + num
        self.DBBindData[name].value = value
        self:DBRegUpdate(name)
    end
    
    --乘 / 除
    function DBData.mul(num)
        local value = self.DBBindData[name].value * num
        self.DBBindData[name].value = value
        self:DBRegUpdate(name)
    end

    --获取值
    function DBData.get()  
        return self.DBBindData[name].value
    end

    return DBData
end

--[[
    绑定自定义结构
    @name: 名字
    @KeyTag: 用做索引的key "id" or "num"...
    @KeyAry: 类型键值 {"id","num"...}
]]
function BaseDB:DBMap(name, KeyTag, KeyAry)
    local p 
    if KeyTag then 
        p = pairs   --无序表
    else    
        p = ipairs  --有序表
    end
    local KEYNUM = #KeyAry
    local self = self
    local KeyTagIndex = 0
    if KeyTag then
        for i,v in ipairs(KeyAry) do
            if v == KeyTag then
                KeyTagIndex = i
                break
            end
        end
    end
    local DBMap = {}

    self.DBBindData[name] = {type="map", value="", name=name, db=DBMap} --保存名字， 存储的时候取到对应的tab
    self.DBBindTable[name] = {}
    
    --字符串解析为表
    function DBMap._unpack()
        local data = {}
        local list = string.split(self.DBBindData[name].value, "|", false)
        for k,v in ipairs(list) do
            if v ~= "" then
                local obj = {}
                local value = string.split(v, ",", true)
                for i,keyname in ipairs(KeyAry) do
                    obj[keyname] = value[i]
                end
                if KeyTag then
                    data[obj[KeyTag]] = obj
                else
                    table.insert(data, obj)
                end
            end
        end
        self.DBBindTable[name] = data
    end

    --打包成字符串，用于数据库写入
    function DBMap._pack()
        local str = ""
        for k, tab in p(self.DBBindTable[name]) do
            for i,keyname in ipairs(KeyAry) do
                str = str..tab[keyname]
                if KEYNUM ~= i then
                    str = str..","
                end
            end
            str = str.."|"
        end
        if str ~= "" then
            str = string.UnTail(str)
        end
        self.DBBindData[name].value = str  --修改后保存到value
        return str
    end

    --清空容器
    function DBMap.clear()
        self.DBBindTable[name] = {}
        
        self:DBRegUpdate(name)
    end

    --删除元素
    function DBMap.del(key)
        if KeyTag then
            self.DBBindTable[name][key] = nil
        else
            table.remove(self.DBBindTable[name], key)
        end
        
        self:DBRegUpdate(name)
    end
    
    --查找数据
    function DBMap.find(key)
        return self.DBBindTable[name][key]
    end

    --插入数据
    function DBMap.push(...)
        local iter = {...}
        if #iter ~= KEYNUM then
            LOG("push "..name.." error, value nums faild!")
            return
        end
        if KeyTag then
            self.DBBindTable[name][iter[KeyTagIndex]] = iter
        else
            table.insert(self.DBBindTable[name], iter)
        end
    end

     --获取数量
    function DBMap.count()
        if KeyTag then    --无序的
            return table.nums(self.DBBindTable[name])
        else
            return #self.DBBindTable[name]
        end
    end

    --提取某个元素,做成list
    function DBMap.keytolist(key)
        local t = {}
        for k,v in p(self.DBBindTable[name]) do
            table.insert(t, v[key])
        end  
        return t
    end

    --记录修改
    function DBMap.change()
        self:DBRegUpdate(name)
    end
    
    return DBMap
end

function BaseDB:LinkData(data)
    if data.type == "number" then
        return data.value or 0
    elseif data.type == "time" then
        return "'"..timetostr(data.value).."'"
    elseif data.type == "string" or data.type == "text" then
        return "'"..(data.value or "").."'"
    elseif data.type == "bool" then
        if data.value then
            return 1
        else
            return 0
        end
    elseif data.type == "diy" or data.type == "map" then
        return "'"..data.db._pack().."'"
    elseif data.type == "bigint" then
        return "'"..(data.value or "").."'"
    else
        LOG("LinkData error", data.type, data.value)
    end
end

function BaseDB:_DBAutoReadSel(...)
    if table.nums(self.DBBindData) <= 0 then return end
    local kv = {...}
    local sql = "SELECT "
    for name, data in pairs(self.DBBindData) do
        sql = sql..name..","
    end
    sql = string.sub(sql, 1, -2)
    sql = sql.." FROM "..self.DBName.."."..self.TableName
    if #self.Key > 0 and #kv > 0 then --有条件
        sql = sql.." WHERE "
        for i=1, #kv, 2 do
            self.DBBindData[kv[i]].value = kv[i+1]
            sql = sql..kv[i].."="..self:LinkData(self.DBBindData[kv[i]])
            if i+1 < #kv then
                sql = sql.." AND "
            end
        end
    end
    return xDBTool:DBQuery(self.DBName, sql)
end

function BaseDB:DBAutoReadInit()
end

function _ReadData(datatab, value, self)
    if datatab.type == "bigint" then
        datatab.value = bn(value)
    else
        if datatab.type == "bool" then
            value = (value == 1)
        elseif datatab.type == "time" then
            value = strtotime(value)
        end
        datatab.value = value
        if datatab.type == "diy" or datatab.type == "map" then
            datatab.db._unpack()
        end
    end 
end

--传入read的条件
function BaseDB.DBAutoReadArry(cls, ...)    --静态函数， 里面不能有self
    local reslut = {}
    local temp = cls.new() --只是为了创建查询语句
    local res = temp:_DBAutoReadSel(...)
    for i, v in pairs(res) do
        local newdata = cls.new()
        table.insert(reslut, newdata)
        for k, d in pairs(v) do
            local datatab = newdata.DBBindData[k]
            _ReadData(datatab, d, newdata)
        end
        newdata:DBAutoReadInit()
    end
    return reslut
end

function BaseDB:DBAutoRead(...)  --使用前要先按顺序设置key的值,DBAutoRead(kv1，kv2)
    local res = self:_DBAutoReadSel(...)
    if CheckSqlR(res) then
        for i, v in pairs(res[1]) do
            local datatab = self.DBBindData[i]
            _ReadData(datatab, v, self)
        end
        self:DBAutoReadInit()
        return true
    else
        return false
    end
end

function BaseDB:_DBAutoUpdate()
    if table.nums(self.Change) <= 0 then return true end
    local sql = "UPDATE "..self.DBName.."."..self.TableName.." SET "
    for i, v in pairs(self.Change) do
        sql = sql..i.."="..self:LinkData(v)..","
    end
    sql = string.sub(sql, 1, -2)
    if #self.Key > 0 then
        sql = sql.." WHERE "
        for i, key in ipairs(self.Key) do
            sql = sql..key.."="..self:LinkData(self.DBBindData[key])
            if i < #self.Key then
                sql = sql.." AND "
            end
        end 
    end

    self.Change = {}

    local res = xDBTool:DBQuery(self.DBName, sql)
    if not CheckSql(res) then
        LOG("_DBAutoUpdate error. SQL: "..sql)
        return false
    end
    return true
end

function BaseDB:_DBAutoInsert(args)
    if table.nums(self.DBBindData) <= 0 then return true end
    if args then
        for k,v in pairs(args) do
            self.DBBindData[k].value = v
        end
    end
    local keystr, valstr = "", ""
    for name, data in pairs(self.DBBindData) do
        keystr = keystr..name..","
        valstr = valstr..self:LinkData(data)..","
    end
    keystr = string.sub(keystr, 1, -2)
    valstr = string.sub(valstr, 1, -2)

    local sql = "INSERT INTO "..self.DBName.."."..self.TableName.." ("..keystr..") VALUES("..valstr..")"
    local res = xDBTool:DBQuery(self.DBName, sql)
    if not CheckSql(res) then
        LOG("_DBAutoInsert error. SQL: "..sql)
        return false
    end
    return true
end

function BaseDB:_DBAutoDelete()
    local sql = "DELETE FROM "..self.DBName.."."..self.TableName
    if #self.Key > 0 then
        sql = sql.." WHERE "
        for i, key in ipairs(self.Key) do
            sql = sql..key.."="..self:LinkData(self.DBBindData[key])
            if i < #self.Key then
                sql = sql.." AND "
            end
        end 
    end
    local res = xDBTool:DBQuery(self.DBName, sql)
    if not CheckSql(res) then
        LOG("_DBAutoDelete error. SQL: "..sql)
        return false
    end
    return true
end

function BaseDB:DBRegUpdate(propname)
    self.Change[propname] = self.DBBindData[propname]   --记录修改的属性
    xDBMgr:RegUpdate(self)
end

function BaseDB:DBRegInsert(args)
    if args then
        for k,v in pairs(args) do
            self.DBBindData[k].value = v
        end
    end
    xDBMgr:RegInsert(self)
end

function BaseDB:DBRegDelete()
    xDBMgr:RegDelete(self)
end

function BaseDB:_CreateNewTable()
    local sql = string.format("CREATE TABLE %s (", self.TableName)
    for name, data in pairs(self.DBBindData) do
        sql = sql..name.." "..GAMETOMYSQL[data.type]
        local autoaddnum = self.DBAutoAddName[name]
        if autoaddnum then
            sql = sql.." AUTO_INCREMENT,"
        else
            sql = sql..","
        end
    end
    if #self.Key > 0 then
        local keystr = ""
        for i,v in ipairs(self.Key) do
            keystr = keystr..v..","
        end
        keystr = string.sub(keystr, 1, -2)
        sql = sql.."PRIMARY KEY("..keystr..") )"
    else
        sql = string.sub(sql, 1, -2)
        sql = sql..")"
    end
    if table.nums(self.DBAutoAddName) > 0 then  --有自加字段
        sql = sql.." AUTO_INCREMENT="..self.DBAutoAddNum
    end
    LOG("new sqltab:",sql)
    xDBTool:DBQuery(self.DBName, sql)
end

function BaseDB:CheckTabExists()
    local col = xDBTool:DBQuery(self.DBName, "SELECT COLUMN_NAME,COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='%s' AND TABLE_NAME='%s';", self.DBName, self.TableName)
    if CheckSqlR(col) then   --表存在
        return true
    end
    return false
end

--自动对比字段修改，为避免数据丢失不会自动删除不存在的字段。
function BaseDB:DBCheckMySql()
    if not self.DBName or not self.TableName then
        LOG("ERROR DBName or TableName")
        return false
    end
    
    local reslut = false
    if table.nums(self.DBBindData) <= 0 then 
        LOG("DBBindData is null. ", self.DBName, self.TableName)
        return false 
    end

    --查询表是否存在
    local col = xDBTool:DBQuery(self.DBName, "SELECT COLUMN_NAME,COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='%s' AND TABLE_NAME='%s';", self.DBName, self.TableName)
    if not CheckSqlR(col) then   --表不存在，直接创建
        self:_CreateNewTable()
        reslut = true
    else
        local tempmaping = {}
        for k,v in pairs(col) do
            tempmaping[v.COLUMN_NAME] = v.COLUMN_TYPE
        end
        local errortype = {}
        local undefine = {}
        for name,v in pairs(self.DBBindData) do
            local mytype = GAMETOMYSQL[v.type]
            if not tempmaping[name] then    --字段不存在
                undefine[name] = mytype
            elseif tempmaping[name] ~= mytype then    --类型不一样
                errortype[name] = mytype
            end
        end
        --类型不一样
        if table.nums(errortype) > 0 then
            local setsql = "ALTER TABLE "..self.TableName
            for name, mytype in pairs(errortype) do
                setsql = string.format("%s MODIFY %s %s,", setsql, name, mytype)
            end
            setsql = string.sub(setsql, 1, -2)
            xDBTool:DBQuery(self.DBName, setsql)
            reslut = true
        end
        --字段不存在
        if table.nums(undefine) > 0 then
            local addsql = "ALTER TABLE "..self.TableName
            for name, mytype in pairs(undefine) do
                addsql = string.format("%s ADD %s %s,", addsql, name, mytype)
            end
            addsql = string.sub(addsql, 1, -2)
            xDBTool:DBQuery(self.DBName, addsql)
            reslut = true
        end
    end

    return reslut
end


function BaseDB:BaseSendProperty(NetMsg, SendType, SendBuffer, ...)
    local SendPropertyList = {}
    for k,data in pairs({...}) do
        --@Property: [netmsgHint.Common#Property]
        local Property = {}
        local value = nil
        if type(data) == "table" then
            local keyname = table.getonekey(data)
            Property.Key = keyname
            value = data[keyname]
        else
            Property.Key = data
            local _DBData = self["DB_"..data]
            if _DBData then
                if _DBData.get then
                    value = _DBData.get()
                else
                    value = 0
                    WARN("BaseSendProperty", NetMsg, SendType, SendBuffer, ...)
                end
            else
                value = self[data]
            end
        end

        local type = type(value)
        if type == "string" then
            Property.Type = "s"
            Property.String = value
        elseif type == "number"  then
            Property.Type = "n"
            Property.Number = value
        elseif type == "boolean" then
            Property.Type = "b"
            Property.Bool = value
        elseif type == "table" and value.__bigint then
            Property.Type = "l"
            Property.String = ubn(value)
        else
            LOG("BaseSendProperty error", data, type)
            break
        end
        table.insert(SendPropertyList, Property)
    end
    SendBuffer.Type = SendType
    SendBuffer.PropertyList = SendPropertyList
    GPROC:SendToClient(NetMsg, SendBuffer)
end