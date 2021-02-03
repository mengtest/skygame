--[[
功能: 计时器基类
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

BaseTimer = class("BaseTimer")

function BaseTimer:ctor()
    self.TimeIndex = 0
    self.TimerList = {}
    self.IsOpenTimer = false
    self.IsPauseTimer = true
    self.TimerOnlyID = 0
    
    self.IntervalSecond = 0
end

--[[
	@desc: 延迟调用
	--@seconds: 秒
	--@callback: 回调函数
	--@binder:  self
]]
function BaseTimer:Timeout(seconds, callback, binder)
    local Sec = math.floor(seconds*100)
    SKY.timeout(Sec, function()
        callback(binder)
    end) --延迟调用变循环
end

--[[
	@desc: 添加计时器
	--@second: 秒
	--@callback: 回调
	--@binder: self
	--@AtOnce: 是否立即调用
]]
function BaseTimer:BindTimer(second, callback, binder, AtOnce) --绑定后等待时间调用
    if not self.IsOpenTimer then    --没有启动计时器
        self.IsOpenTimer = true
        self.IntervalSecond = math.floor(second*100)
        self:RestoreTimer(false)
    end 

    self.TimeIndex = self.TimeIndex + 1
    self.TimerList[self.TimeIndex] = {time=math.floor(second*100),func=callback,last=SKY.now(),Binder=binder}  --避免第一次绑定立即调用
    if AtOnce then
        callback(binder)
    end
    return self.TimeIndex
end

--[[
	@desc: 取消时间绑定
	--@timerid: 时间ID
]]
function BaseTimer:KillTimer(timerid)
    if not self.IsOpenTimer then return end --没有启动计时器
    self.TimerList[timerid] = nil
end

function BaseTimer:PauseTimer()
    if not self.IsOpenTimer then return end --没有启动计时器
    if self.IsPauseTimer then return end    --不要重复暂停
    
    self.IsPauseTimer = true
    self.TimerOnlyID = self.TimerOnlyID + 1
end

--[[
	@desc: 恢复计时器
	--@IsAtOnce: 立即执行一次
]]
function BaseTimer:RestoreTimer(IsAtOnce)
    if not self.IsOpenTimer then return end  --没有启动计时器
    if not self.IsPauseTimer then return end --没有暂停不要执行
    
    self.TimerOnlyID = self.TimerOnlyID+1
    local id = self.TimerOnlyID
    local _TimeProc
    _TimeProc = function()
        if id ~= self.TimerOnlyID then return end
        local now = SKY.now()
        for k,v in pairs(self.TimerList) do
            if now - v.last >= v.time then
                v.last = now
                v.func(v.Binder)
            end
        end
        SKY.timeout(self.IntervalSecond, _TimeProc)
    end
    SKY.timeout(self.IntervalSecond, _TimeProc) --延迟调用变循环

    if AtOnce then
        _TimeProc()
    end

    self.IsPauseTimer = false
end