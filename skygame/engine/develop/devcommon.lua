--[[
功能: 通用的方法
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--
require("engine.develop.class")
require("engine.develop.cfg.CfgMgr")
require("engine.develop.SvrInfo")
require("engine.develop.extend.tableEx")
require("engine.develop.extend.stringEx")
require("engine.develop.tool")

if xSvrInfo.IsOpenBigint then
    require("engine.develop.extend.bn")
end

nilfunc = function()end --不能用来判断， 地址不一样

function SKY.sec()
	return math.floor(SKY.now()/100)
end

function SKY.webnewservice(webname, port)
    SKY.newservice("develop/net/HTTPGate", webname, "0.0.0.0", port)
end

---------table扩展功能--------------
function LOG(...)
    if not xSvrInfo.IsOpenLog then return end
    if GUSER and GUSER.UID then
        SKY.error("("..os.date("%Y-%m-%d %H:%M:%S", os.time())..", "..GUSER.UID..") LOG:", ...)
    else
        SKY.error("("..os.date("%Y-%m-%d %H:%M:%S", os.time())..") LOG:", ...)
    end 
end
function WARN(...)
    if GUSER and GUSER.UID then
        SKY.error("("..os.date("%Y-%m-%d %H:%M:%S", os.time())..", "..GUSER.UID..") WARN:", ...)
    else
        SKY.error("("..os.date("%Y-%m-%d %H:%M:%S", os.time())..") WARN:", ...)
    end
end
function ERROR(...)
    if GUSER and GUSER.UID then
        SKY.error("("..os.date("%Y-%m-%d %H:%M:%S", os.time())..", "..GUSER.UID..") ERROR:", ...)
        SKY.error(debug.traceback())
    else
        SKY.error("("..os.date("%Y-%m-%d %H:%M:%S", os.time())..") ERROR:", ...)
        SKY.error(debug.traceback())
    end
end

function EODERROR(error)
    LOG("************************************************")
    LOG("****************SERVER ERROR********************") 
    LOG(error)
    LOG("***************PLEASE RESTART*******************") 
    LOG("************************************************")
end

function SafeCall(func, ...)
    return xpcall(func, function(error) 
        ERROR("SafeCall=>", error)
    end, ...)
end

local _xLogOutputList = {} --输出日志记录表
function DBLOG_BEGIN()
    _xLogOutputList = {}
end
function DBLOG_LATE(key, data)
    local value = _xLogOutputList[key]
    if value then
        _xLogOutputList[key] = value.." | "..data
    else
        _xLogOutputList[key] = data
    end
end
function DBLOG_OUT(event, tab, IsOutLateList) -- 事件，内容，是否输出延迟表
    tab = tab or {}
    if not table.check(tab) then
        error("DBLOG_OUT tab is not table")
    end
    if IsOutLateList then
        for k,v in pairs(tab) do
            DBLOG_LATE(k, v)
        end
        tab = _xLogOutputList
        _xLogOutputList = {}
    end
    tab["time"] = timetostr(os.time())
    tab["event"] = event
    SKY.send(xSvrInfo.SERVICE.DBLOGGAME, "lua", "OutPutLog", tab)
end





function CheckSql(res)   --验证SQL语句是否成功
    if not res or type(res) ~= "table" then
        return false
    end
    return true
end

function CheckSqlR(res)   --验证SQL的select是否有返回内容
    if not CheckSql(res) or not CheckSql(res[1]) then
        return false
    end
    return true
end

time = {}
ZEROTIME= "0000-01-01 00:00:00"
TIMEDEF = {["9999-01-01 00:00:01"]=-1, ["0000-01-01 00:00:00"]=0, ["0000-01-01 00:00:01"]=1, [-1]="9999-01-01 00:00:01", [0]="0000-01-01 00:00:00", [1]="0000-01-01 00:00:01"}     
function time.str2tab(timeString)
    local _fun = string.gmatch( timeString, "%d+")
    return {year=_fun(), month=_fun(), day=_fun(), hour=_fun(),min=_fun(),sec=_fun()}
end

function time.str2time()
end

function time.tab2time()
end

function strtotime(timeString)
    local _def = TIMEDEF[timeString]
    if _def ~= nil then return _def end --特殊的时间宏定义
    if type(timeString) ~= 'string' then return 0 end
    local _fun = string.gmatch( timeString, "%d+")
    return os.time({year=_fun(), month=_fun(), day=_fun(), hour=_fun(),min=_fun(),sec=_fun()})
end

function timetostr(time)
    local _def = TIMEDEF[time]
    if _def then 
        return _def --特殊的时间宏定义
    else
        return os.date("%Y-%m-%d %H:%M:%S", time)
    end
end

function tabtotime(tab)
    return os.time({year=tab.year, month=tab.month, day=tab.day, hour=tab.hour, minute=tab.minute, second=tab.second})
end

function timetotab(unixTime)
    if unixTime and unixTime >= 0 then
        local tb = {}
        tb.year = tonumber(os.date("%Y",unixTime))
        tb.month =tonumber(os.date("%m",unixTime))
        tb.day = tonumber(os.date("%d",unixTime))
        tb.wday = tonumber(os.date("%w",unixTime))  --星期几
        tb.hour = tonumber(os.date("%H",unixTime))
        tb.minute = tonumber(os.date("%M",unixTime))
        tb.second = tonumber(os.date("%S",unixTime))
        return tb
    end
end

function timetotabex(unixTime, cover)
    if unixTime and unixTime >= 0 then
        local tb = timetotab(unixTime)
        for k,v in pairs(cover) do
            tb[k] = v
        end
        return tabtotime(tb)
    end
    return 0
end

function LoadTXTCfg(filename)
    local data = {}
    local file = io.open(filename, "r")
    for l in file:lines() do
        if string.sub(l, 1, 1) ~= "#" then
            local temp = string.split(l, "=", false)
            data[temp[1]] = temp[2]
        end
    end
    file:close()
    return data
end

bool = {}
function bool.tostring(IsOK)
    if IsOK then
        return "true"
    else
        return "false"
    end
end

function bool.tonumber(IsOK)
    if IsOK then
        return 1
    else
        return 0
    end
end

function TimeLegal(now, begin, over) --时间合法
    if over == nil then
        over = begin.over
        begin = begin.begin
    end

    if now >= begin and (now <= over or over == 0) then
        return true
    end
    return false
end
--[[
function math.Ceil(value)
    return math.ceil(value-0.000000001)
end

function math.Floor(value)
    return math.floor(value+0.000000001)
end]]
--段位分数处理
function ScoreToGrade(score)
    local grade = 1 
    local cfgGrade = CFGTAB(CFG.GRADE)
    for i,v in ipairs(cfgGrade) do
        if score >= v.star and i < #cfgGrade then
            score = score - v.star
            grade = grade + 1
        else
            break
        end
    end
    local star = score
    return grade, star
end
function GradeToScore(grade, star)
    local score = 0
    local cfgGrade = CFGTAB(CFG.GRADE)
    for i,v in ipairs(cfgGrade) do
        if grade > i then
            score = score + v.star
        else
            break
        end
    end
    return score + star
end