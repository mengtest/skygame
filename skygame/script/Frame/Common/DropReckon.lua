--掉落计算
require("script.Frame.Common.Common")

DropReckon = class("DropReckon") --静态

function DropReckon:ctor()
end

function DropReckon:DropOnce(DropID)
    local reslut = {}
    local CfgDrop = CFGDATA(CFG.DROP, DropID)
    if not CfgDrop then LOG(DropID) return {} end
    local data = table.oddsrand(CfgDrop.numdata)
    if not data[1] or not data[2] then LOG(DropID) return {} end
    local dropnum = math.random(data[1], data[2])
    for i=1, dropnum do
        local GroupID = table.oddsrand(CfgDrop.groupdata)
        local CfgGroup = CFGDATA(CFG.GROUP, GroupID)
        if not CfgGroup then LOG(DropID,GroupID) return {} end
        local itemdata = table.oddsrand(CfgGroup.itemdata)
        local numdata = table.oddsrand(CfgGroup.numdata)
        if not numdata[1] or not numdata[2] then LOG(DropID,GroupID) return {} end
        local numcount = itemdata[2] * math.random(numdata[1], numdata[2])
        table.insert(reslut, {id=itemdata[1], num=numcount})
    end

    return reslut
end

xDropReckon = DropReckon.new()