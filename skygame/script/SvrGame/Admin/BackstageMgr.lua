require("engine.develop.BaseServer")
require("engine.develop.mysql.DBTool")
local luajson = require("engine.develop.LuaJson")

--@SuperType [engine.develop.BaseServer#BaseServer]
BackstageMgr = class("BackstageMgr", BaseServer)
function BackstageMgr:ctor()
    BaseServer.ctor(self)
end

function BackstageMgr:TimeProcGMCommond()
    local res = xDBTool:DBQueryCenter("SELECT * FROM "..xSvrInfo.DBCENTER..".gmbackstageinfo;")
    if CheckSqlR(res) then
        for i,v in ipairs(res) do
            local func = self[v.GMCommond]
            if func then
                local jsondata = luajson.json2table(v.JsonData)
                if jsondata then
                    local result = func(self, jsondata)
                    DBLOG_OUT("GMBACKSTAGEPROC", {Commond=v.GMCommond, JsonData=v.JsonData, Result=result})
                    LOG("GMBACKSTAGEPROC", "GMCommond："..v.GMCommond, "JsonData："..v.JsonData, "Result：", result)
                end
            end
        end
        self:ClearGMCommond()
    end
end

function BackstageMgr:ClearGMCommond( )
    xDBTool:DBQueryCenter("DELETE FROM "..xSvrInfo.DBCENTER..".gmbackstageinfo;")
end

function BackstageMgr:Run() 
    self:ClearGMCommond()   --启动时先把GM命令清空
    self:BindTimer(10, self.TimeProcGMCommond, self)  --10秒执行一次GM命令
end

-------------------------------------------------------------
----------------------------GM功能---------------------------
-------------------------------------------------------------

--@表示必须参数 *表示可选参数 ?表示单选参数
--[[BackNewSysMail 添加系统邮件
@Title      标题 string
@Info       内容 string
@StartTime  开始时间 timet
@OverTime   结束时间 timet
*Item       附件 ID:NUM,ID:NUM
*Type       类型 int
*SysID      系统ID int
]]
function BackstageMgr:BackNewSysMail(parm)
    if not table.verify(parm, true, "Title", "Info", "StartTime", "OverTime") then return false end
    --插入系统邮件到数据库
    xDBTool:DBQueryCenter("INSERT INTO sysmailinfo (Title,Info,Item,Type,SysID,StartTime,OverTime) VALUES ('%s','%s','%s',%d,%d,'%s','%s')", 
        parm.Title, parm.Info, parm.Item or "", parm.Type or 0, parm.SysID or 0, timetostr(parm.StartTime), timetostr(parm.OverTime))
    --通知所有服务器刷新
    return true
end

--[[BackNewPlayerMail 添加指定用户邮件
@Title      标题 string
@Info       内容 string
@MatchUID   匹配的用户数组 [1000,1002]
@MatchSvrID 对应的服务器ID [1,4]
*Item       附件 ID:NUM,ID:NUM
*Type       类型 int
*SysID      系统ID int
]]
function BackstageMgr:BackNewPlayerMail(parm)
    if not table.verify(parm, true, "Title", "Info", "MatchUID", "MatchSvrID") then return false end
    local arryUID = string.splitarray(parm.MatchUID)
    local arrySvrID = string.splitarray(parm.MatchSvrID)
    if #arryUID <= 0 or #arrySvrID <= 0 or #arryUID ~= #arrySvrID then return false end
    for i=1,#arryUID do
        self:SendGameUser(arrySvrID[i], arryUID[i], SEND.DETAIL, "RemoteMailNew", parm.Title, parm.Info, parm.Item or "", parm.Type or 0, parm.SysID or 0)
    end
    return true
end

--[[BackKickPlayer 踢人，清除登录缓存
@SvrID      服务器ID
@uid        用户ID int
]]
function BackstageMgr:BackKickPlayer(parm)
    if not table.verify(parm, true, "SvrID", "uid") then return false end
    return true
end

--[[BackBannedPlayer 踢人，清除登录缓存，封号
@SvrID      服务器ID
@duration   封禁时间 timet -1：永久 0：解除封号 其他：时间戳
@uid        用户ID int
]]
function BackstageMgr:BackBannedPlayer(parm)
    if not table.verify(parm, true, "SvrID", "uid", "duration") then return false end
    return true
end

--[[BackMaintain 服务器维护， 收到消息后禁止登录，禁止开启战斗，并在kicktime到达后踢掉所有用户
@SvrID      服务器ID， 填0表示全服
@kicktime   强制用户下线时间 timet
@duration   维护结束时间 timet -1：手动停止 0：结束维护 其他：时间戳
]]
function BackstageMgr:BackMaintain(parm)
    if not table.verify(parm, true, "SvrID", "kicktime", "duration") then return false end
    if parm.SvrID == 0 then --全服维护
    else
    end
    return true
end

BackstageMgr.new():Start(xSvrInfo.SERVICE.GMBACKSTAGE)