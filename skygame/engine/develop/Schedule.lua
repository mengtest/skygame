--[[
功能: 日程管理， 用于任务等时间节点逻辑
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--
Schedule = class("Schedule")

function Schedule:ctor()
end
 
function Schedule:GetMonthDay(time) --获取某个月有多少天
    local mon = tonumber(os.date("%m",time))
    local year = tonumber(os.date("%Y",time))
    local mday = {}
    if year % 4 == 0 then   --闰年二月29天
        mday = { 31,29,31,30,31,30,31,31,30,31,30,31 }
    else
        mday = { 31,28,31,30,31,30,31,31,30,31,30,31 }
    end
    return mday[mon]
end

function Schedule:IsInterval(BackTime, Time)
    local NowTime = os.time()
    local Count = 0
    local NextTime = 0
    if NowTime > BackTime then
        if BackTime == 0 then
            Count = 1
        else
            Count = math.floor((NowTime - BackTime) / Time + 1)
        end
        NextTime = NowTime + Time
    end
    return Count, NextTime
end

--[[
    @BackTime: 上次的时间
    @EventID: 计时器ID
    @RepairSecond: 修复时间
    @return-> 计数，下次时间
]]
function Schedule:IsOnTime(BackTime, EventID, RepairSecond)
    RepairSecond = L(RepairSecond, 0)
    local NowTime = os.time()
    local NowTimeTab = timetotab(NowTime)
    local CfgData = CFGDATA(CFG.SCHEDULE, EventID)
    local iInterval = self:GetInterval(EventID)
    local Count = 0
    local NextTime = 0
    if CfgData.Type == SCHEDULEDEF.TIME then
        if NowTime > BackTime + RepairSecond then
            if BackTime == 0 then
                Count = 1
            else
                Count = math.floor((NowTime - BackTime) / iInterval + 1)
            end
            NextTime = NowTime + iInterval
        end
    else
        if CfgData.Type == SCHEDULEDEF.CLOCK then 
            if NowTime > BackTime + RepairSecond then
                if BackTime == 0 then
                    NowTimeTab.hour = CfgData.Clock
                    NowTimeTab.minute = 0
                    NowTimeTab.second = 0
                end
            end
        elseif CfgData.Type == SCHEDULEDEF.WEEK then
            if NowTime > BackTime + RepairSecond then
                if BackTime == 0 then
                    local err = math.abs(NowTimeTab.wday - CfgData.DayOrWeek)
                    if NowTimeTab.wday > CfgData.DayOrWeek then
                        NowTimeTab.day = NowTimeTab.day - err
                    elseif NowTimeTab.wday < CfgData.DayOrWeek then
                        NowTimeTab.day = NowTimeTab.day + err
                    end
                    NowTimeTab.hour = CfgData.Clock
                    NowTimeTab.minute = 0
                    NowTimeTab.second = 0
                end
            end
        elseif CfgData.Type == SCHEDULEDEF.DAY then
            if NowTime > BackTime + RepairSecond then
                if BackTime == 0 then
                    NowTimeTab.day = CfgData.DayOrWeek
                    NowTimeTab.hour = CfgData.Clock
                    NowTimeTab.minute = 0
                    NowTimeTab.second = 0
                end
            end
        elseif CfgData.Type == SCHEDULEDEF.TIMEDAY then
            if NowTime > BackTime + RepairSecond then
                if BackTime == 0 then
                    NowTimeTab.day = CfgData.DayOrWeek
                    NowTimeTab.hour = CfgData.Clock
                    NowTimeTab.minute = 0
                    NowTimeTab.second = 0
                end
            end
        end
    
        if BackTime == 0 then
            Count = 1
            NextTime = tabtotime(NowTimeTab)
        else
            Count = math.floor((NowTime - BackTime) / iInterval + 1)
            NextTime = BackTime
        end

        if NextTime <= NowTime then --新的时间不够，再加一轮
            NextTime = NextTime + Count * iInterval --时间戳+一天的秒数
        end
    end

    return Count, NextTime
end

function Schedule:GetInterval(EventID)
    local time = os.time()
    local CfgData = CFGDATA(CFG.SCHEDULE, EventID)
    if CfgData.Type == SCHEDULEDEF.TIME then
        return CfgData.Time * 60 --配置是分钟
    elseif CfgData.Type == SCHEDULEDEF.CLOCK then
        return 24 * 60 * 60
    elseif CfgData.Type == SCHEDULEDEF.WEEK then
        return 7 * 24 * 60 * 60
    elseif CfgData.Type == SCHEDULEDEF.DAY then
        return self:GetMonthDay(time) * 24 * 60 * 60
    elseif CfgData.Type == SCHEDULEDEF.TIMEDAY then
        return CfgData.Time * 60
    end

    return 0
end

xSchedule = Schedule.new()