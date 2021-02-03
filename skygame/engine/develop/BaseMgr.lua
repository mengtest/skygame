--[[
功能: 模块管理基类
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--
require("engine.develop.BaseSend")
require("engine.develop.BaseTimer")
--@SuperType [engine.develop.BaseSend#BaseSend|engine.develop.BaseTimer#BaseTimer]
BaseMgr = class("BaseMgr", BaseSend, BaseTimer)

function BaseMgr:ctor()
    BaseSend.ctor(self)
    BaseTimer.ctor(self)

    xEvent:BindEvent(EVENT_USER.OnPauseTimer, self.PauseTimer, self)
    xEvent:BindEvent(EVENT_USER.OnRestoreTimer, self.RestoreTimer, self)
end

function BaseMgr:LogicLoadFromDB()
    if not self:DBAutoRead("UID", GUSER.UID) then
        self:DBRegInsert({UID=GUSER.UID})
    end
end

--[[
	@desc: 公共数据推送
	--@PushNetMsg:
	--@datalist:
	--@PackNetame: 
]]
function BaseMgr:BasePushData(PushNetMsg, datalist, PackNetame)
    local pushlist = {}
    for id, v in pairs(datalist) do
        table.insert(pushlist, v[PackNetame](v))
    end
    GPROC:SendToClient(PushNetMsg, {data=pushlist})
end

--[[
	@desc: 公共数据变化
	--@ChangeNetMsg:
	--@DeleteNetMsg:
	--@list:
	--@PackNetame:
	--@args: 
]]
function BaseMgr:BaseSendChange(ChangeNetMsg, DeleteNetMsg, list, PackNetame, ...)
    local idlist = {...}
    if type(idlist[1]) == "table" then
        local newt = idlist[1]
        for i, id in ipairs(idlist) do
            if i > 1 then
                table.push(newt, id)
            end
        end
        idlist = newt
    end
    local change = {}
    local deleteIDList = {}
    local idRecord = {} --避免重复的ID重复处理
    for _,id in pairs(idlist) do
        if not idRecord[id] then
            local v = list[id]
            if v then
                if ChangeNetMsg then
                    table.insert(change, v[PackNetame](v))
                end
            else
                if DeleteNetMsg then
                    table.insert(deleteIDList, id)
                end
            end
            idRecord[id] = true --避免重复
        end
    end
    if #change > 0 then
        GPROC:SendToClient(ChangeNetMsg, {data=change}) 
    end
    if #deleteIDList > 0 then
        GPROC:SendToClient(DeleteNetMsg, {data=deleteIDList})
    end
end

--for mgr go
--for mgr end