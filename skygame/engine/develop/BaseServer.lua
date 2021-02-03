--[[
功能: 服务基类
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--
require("script.Frame.Common.Common")
require("engine.develop.BaseSend")
require("engine.develop.BaseTimer")
require("config.clustercfg")
--@SuperType [engine.develop.BaseSend#BaseSend|engine.develop.BaseTimer#BaseTimer]
BaseServer = class("BaseServer", BaseSend, BaseTimer)    --服务框架

function BaseServer:ctor()
    BaseSend.ctor(self)
    BaseTimer.ctor(self)
end

function BaseServer:Run()
end

function BaseServer:Start(RegisterName, DIYFunc)
    --监听消息
    local function _Proc(...)
        --执行自定义函数
        if DIYFunc then
            DIYFunc(self, ...)
        end
        --服务消息
        SKY.dispatch("lua", function(session, address, cmd, ...)
            local f = self[cmd] --查询cmd命令的具体处理方法
            if f then
                local ok,r1, r2, r3, r4, r5, r6, r7, r8, r9, r10 = SafeCall(f, self, ...)
                if ok then
                    SKY.retpack(r1, r2, r3, r4, r5, r6, r7, r8, r9, r10) --回应
                else
                    LOG("dispatch error cmd:", cmd, "RegisterName:", RegisterName, "parm:", table.tabtostr({...}), "result:", r1, r2, r3, r4, r5, r6, r7, r8, r9, r10)
                end
            else
                LOG("CMD not found cmd:", cmd, "RegisterName:", RegisterName, "parm:", table.tabtostr({...}))
            end
        end)
        --注册别名
        if RegisterName then    
            SKY.register(RegisterName)
        end
        --随机数种子
        math.randomseed(os.time())
        --全局数据表
        xCfgMgr:UNPACK()
        --启动函数
        self:Run()
    end
    SKY.start(_Proc)
    return self
end