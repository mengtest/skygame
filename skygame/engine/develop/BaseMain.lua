--[[
功能: main文件基类
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

local sprotoparser = require "sprotoparser"
local sprotoloader = require "sprotoloader"
local sharedata = require "skynet.sharedata"
local cluster = require "skynet.cluster"
local netmsg = require("res.netmsg")

require("script.Frame.Common.Common")
require("script.Frame.Common.ServerInit")
BaseMain = class("BaseMain")    --主文件框架

function BaseMain:Start(init, start, module)
    local function _Init()
        --加载配置文件
        LoadCfgFile(xCfgMgr)
        sharedata.new("CfgMgr", xCfgMgr:PACK())
        xCfgMgr:UNPACK()
        --启动数据库服务
        SKY.newservice("develop/mysql/DBCenter") 
        init(self)
    end
    SKY.init(_Init)

    local function _Start()
        --集群模式
        if xSvrInfo:IsV("IsOpenCluster") then
            cluster.open(xSvrInfo.NAME)
        end
        --加载消息文件
        sprotoloader.save(sprotoparser.parse(netmsg), 1)
        
        if module then
            _G["autocheckmysqltable"] = {}

            require(module)

            local newfunc = false
            local functab = {}
            
            for name,class in pairs(_G["autocheckmysqltable"]) do
                local temp = class.new()
                if temp:DBCheckMySql() then
                    newfunc = true
                end
                functab[temp.DBName] = functab[temp.DBName] or {}
                table.insert(functab[temp.DBName], temp.TableName)
            end

            if newfunc then
                for dbname,list in pairs(functab) do
                    local sql = "CREATE PROCEDURE _DropServerDB() BEGIN/*\n"
                    for i,v in ipairs(list) do
                        sql = sql.."\tDROP TABLE IF EXISTS "..v..";\n"
                    end
                    sql = sql.."*/END;"
                    xDBTool:DBQuery(dbname, "DROP PROCEDURE IF EXISTS _DropServerDB;")
                    xDBTool:DBQuery(dbname, sql)
                end 
                EODERROR("Mysql database has changed.")
            end
        end
        --启动调试控制台
        local DebugConsolePort = xSvrInfo:GetV("DebugConsolePort")
        if DebugConsolePort ~= nil then
            LOG("---------------Open Debug---------------")
            LOG("Debug Port:", DebugConsolePort)
            SKY.newservice("debug_console", DebugConsolePort)
            LOG("---------------Open Debug---------------")
        end
        start(self)
    end
    SKY.start(_Start)
end