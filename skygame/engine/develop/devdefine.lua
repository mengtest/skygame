--[[
功能: 通用的宏定义
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

--@RefType [engine.lualib.skynet#skynet]
SKY = require "skynet"
require "skynet.manager"
require("engine.develop.event.Event")

SERVERERROR = "SERVERERROR"

GPROC = nil
GUSER = nil

--类型定义
NUMBER = 1
BOOL = 2
STRING = 3

function L(data, default)   --函数默认参数， 只有为0才赋值
    if data == nil then
        return default
    else
        return data
    end
end

--创建枚举对象 中间插入int表示强制改值 a,b,100,c,d -> c=100,d=101
function CreatEnum(tbl, index) 
    local enumtbl = {} 
    local enumindex = L(index, 0)
	for i, v in ipairs(tbl) do 
		if type(v) == "number" then
			enumindex = v
		else
			enumtbl[v] = enumindex
			enumindex = enumindex+1
		end
    end 
    return enumtbl 
end 

--跨服发送类型
SEND = {
	NONE = 0,		--不在线不做任何处理
	ONLINE = 1,		--只给在线的发
	BASE = 2,		--不在线加载基础信息
	DETAIL = 3,		--不在线加载全部信息
}

--随机发送类型
RANDSEND = {
	NONE = 0,		--任意
	ONLINE = 1,		--在线
	RISK = 2,		--在线冒险
}

--日程表
SCHEDULEDEF = {
	TIME = 1,		--固定间隔
	CLOCK = 2,		--每天几点
	WEEK = 3,		--某星期几点
	DAY = 4,		--每月某号几点
	TIMEDAY = 5,	--每月某号几点+间隔（配置多个月）
	TIME_DIY = 6,		--自定义间隔时间
}