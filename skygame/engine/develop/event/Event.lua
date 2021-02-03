--[[
功能: 
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

require("engine.develop.class")
require("engine.develop.event.DevEventDef")

Event = class("Event", Event)

function Event:ctor( )
    self.eventList = {}
end

function Event:FireEvent(eventdef, ...) --触发事件
    local list = self.eventList[eventdef]
    if list then
        for binder,func in pairs(list) do
            func(binder, ...)
        end
    end
end

function Event:BindEvent(eventdef, func, binder) --绑定事件
    local list = self.eventList[eventdef]
    if not list then
        list = {}
        self.eventList[eventdef] = list
    end
    list[binder] = func
end

function Event:DelEvent(eventdef, binder) --移除事件
    if eventdef and binder then
        local list = self.eventList[eventdef]
        if list then
            list[binder] = nil
        end
    elseif eventdef and not binder then
        self.eventList[eventdef] = nil
    end
end

xEvent = Event.new()