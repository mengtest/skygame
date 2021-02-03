--[[
功能: 配置表管理
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--
local sharedata = require "skynet.sharedata"    --sharedata只能在start之后执行
local LuaJson = require("engine.develop.LuaJson")
CfgMgr = class("CfgMgr") --静态类

--获取整张表
function CFGTAB(tabname)
    if not tabname then return {} end
    return xCfgMgr.CfgTab[tabname] or {}
end
--获取表数据
function CFGDATA(tabname, keyname, colname) --获取X表X行X列
    local function outerror()
        LOG("CFGDATA ERROR......", tabname, keyname, colname)
    end
    if not tabname then
        outerror()
        return
    end
    local tab = xCfgMgr.CfgTab[tabname]
    if not tab then outerror() return end
    if keyname then
        local col = tab[keyname]
        if not col then outerror() return end
        if colname then
            local data = col[colname]
            if not data then outerror() return end
            return data
        else
            return col
        end
    else
        outerror()
    end 
end
--获取表的行数
function CFGSIZE(tab)
    if not tab then return 0 end
    return table.nums(xCfgMgr.CfgTab[tab])
end
--自定义参数表, 每一行的类型都不一样
function CFGPARM(key)
    if not key then return 0 end
	return CFGDATA(xCfgMgr.CfgTab.SHARE_PARMNAME, 1)[key]
end

--构造函数
function CfgMgr:ctor()
    self.CfgTab = {}  --数据
    self.CfgTab.SHARE_PARMNAME = ""    --全局参数数表
end

function CfgMgr:SetShareData(key, data)
    self.CfgTab["SHARE_"..key] = data
end

function CfgMgr:GetShareData(key)
    return self.CfgTab["SHARE_"..key]
end

--[[
	@desc: 加载表
	--@tabname: 表名
]]
function CfgMgr:Load(tabname)
    local data = require("res.config."..tabname)
    self.CfgTab[tabname] = data[1]
    return data[1], data[2]
end

--[[
	@desc: 自动加载配置表
	--@CfgList: 加载列表
    --@PARMNAME: 参数表名字
    类型概括：
    int     0 == 0
    string  test == test
    array   [0,1,2,3] == {0, 1, 2, 3}
    map     {1:2,3:4} == {1=2, 3=4}
    maps    {1:2:3,4:5:6:7} == {1={2,3}, 4={5,6,7}}
    time    年/月/日/时/分/秒 == timet
    times   年/月/日/时/分/秒-年/月/日/时/分/秒 == {begin=timet, over=timet}
]]
function CfgMgr:AutoLoad(CfgList, PARMNAME)
    if PARMNAME then
        self.CfgTab.SHARE_PARMNAME = PARMNAME  --参数表
    end
    local function arraytotime(value)
        if value == nil or value == 0 or value == "0" or value == "" then
            return 0
        end
        local _time = string.split(value, "/")
        return tabtotime({year=_time[1], month=_time[2], day=_time[3], hour=_time[4], minute=_time[5], second=_time[6]})
    end

    for key, tabname in pairs(CfgList) do
        local tab, types = self:Load(tabname)
        if PARMNAME == tabname then --如果是参数表
            local newtab = {}
            local newtypes = {}
            for k,v in pairs(tab) do
                newtab[v.id] = tonumber(v.value) or v.value
                newtypes[v.id] = v.type
            end
            tab = {newtab}
            types = newtypes
            self.CfgTab[tabname] = tab
        end
        for id,data in pairs(tab) do
            for keyname,value in pairs(data) do
                local t = types[keyname]
                if t == "none" then
                    LOG("error config type:", t, tabname, keyname)
                else
                    data[keyname] = value
                end
            end
        end
    end

    LOG("AutoLoad Config OK, PARMNAME: "..(PARMNAME or "nil").."......")
end

function CfgMgr:PACK()
    return self.CfgTab
end

function CfgMgr:UNPACK()
    --共享内存只能读取
    self.CfgTab = sharedata.query("CfgMgr")
end


xCfgMgr = CfgMgr.new()