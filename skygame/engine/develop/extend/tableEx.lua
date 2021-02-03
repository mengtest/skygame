--[[
功能: table扩展
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

function table.packmap(tab)
    local itemstr = ""
    for id,num in pairs(tab) do
        itemstr = itemstr..id..":"..num..","
    end
    return string.UnTail(itemstr)
end

function table.merge(t1, t2)  --合并无序表
    for k,v in pairs(t2) do
        t1[k] = v
    end
end

--是否有内容
function table.exist(tab)
    if not table.check(tab) then return false end
    for i,v in pairs(tab) do
        return true
    end
    return false
end

--校验表格
function table.check(tab)
    if tab and type(tab) == "table" then 
        return true
    else
        return false
    end
end
--获取表格内容数量
function table.nums(tab)
    local num = 0;
    for i,v in pairs(tab) do
        num = num + 1;
    end
    return num;
end

--[[
	@desc: 克隆数据，只会拷贝 table string number
	--@object:
	--@IsOrder: 
]]
function table.clone(object, IsOrder)
    local pi
    if IsOrder then
        pi = ipairs
    else
        pi = pairs
    end
    local newTab = {}
    for i,v in pi(object) do
        local t = type(v)
        if t == "table" then
            newTab[i] = table.clone(v, IsOrder)
        elseif t == "string" or t == "number" then
            newTab[i] = v
        end
    end
    return newTab
end
function table.iclone(object)
    return table.clone(object, true)
end

--检查单数组是否有重复的内容
function table.checkrepeat(tab)
    local temp = {}
    for k,v in pairs(tab) do
        if temp[v] then
            return true
        else
            temp[v] = 1
        end
    end
    return false
end

--表格序列号
function table.serialize(obj, index)
    if index ~= nil then
        index = index + 1
    else
        index = 1
    end

    local function indexToT(idx)
        local va = ""
        for i=1, idx do
            va = va.."   "
        end
        return va
    end

	local lua = ""
	local t = type(obj)
	if t == "number" then
		lua = lua..obj
	elseif t == "boolean" then
		lua = lua..tostring(obj)
	elseif t == "string" then
		lua = lua..string.format("%q", obj)
    elseif t == "table" then
		lua = lua.."{\n"..indexToT(index)
        for k, v in pairs(obj) do
            if type(v) ~= "function" and  k ~= "__index" and k ~= "__supers" and k ~= "skynet" and k ~= "class" then
                lua = lua.."["..table.serialize(k, index).."]="..table.serialize(v, index)..",\n"..indexToT(index)
            end
        end
		lua = lua.."}"
	elseif t == "nil" then
		return "nil"
    else
        lua = lua..t
	end
	return lua
end
 --表格反序列号
function table.unserialize(lua)
	local t = type(lua)
	if t == "nil" or lua == "" then
		return nil
	elseif t == "number" or t == "string" or t == "boolean" then
		lua = tostring(lua)
	else
		error("can not unserialize a " .. t .. " type.")
	end
	lua = "return " .. lua
	local func = loadstring(lua)
	if func == nil then
		return nil
	end
	return func()
end
--打印表数据
function table.log(tab, tag, deep)
    LOG("@@@@@@@@@@@@@@@@@@@@@ TablePrint Start @@@@@@@@@@@@@@@@@")
    if tag then
        LOG("@TableName:", tag)
    end
    if not table.check(tab) then return end
    LOG("@TableCount:", table.nums(tab))
    if deep or deep == nil then
        LOG(table.serialize(tab))
    else
        LOG("{")
        for k,v in pairs(tab) do
            LOG(k, v)
        end
        LOG("}")
    end
    LOG("@@@@@@@@@@@@@@@@@@@@@ TablePrint End @@@@@@@@@@@@@@@@@")
end

function table.keys(tab)  
    local tmpKeyT={}
    for k in pairs(tab) do
        table.insert(tmpKeyT, k)
    end
    return tmpKeyT
end

function table.irand(tab, isDel)
    if #tab <= 0 then return end
    local index = math.random(1,#tab)
    local value = tab[index]
    if isDel then
        table.remove( tab, index )
    end
    return value
end

function table.rand(tab, isDel)
    local tmpKeyT = table.keys(tab)
    if #tmpKeyT <= 0 then return end
    local key = tmpKeyT[math.random(1, #tmpKeyT)]
    local value = tab[key]
    if isDel then
        tab[key] = nil
    end
    return value
end

function table.randtab(_table, _num)
    local _result = {}
    local _index = 1
    local _num = _num or #_table
    while #_table ~= 0 do
        local ran = math.random(0, #_table)
        if _table[ran] ~= nil then
            _result[_index] = _table[ran]
            table.remove(_table,ran)
            _index = _index + 1
            if _index > _num then 
                break
            end 
        end
    end
    return _result
end

function table.push(tab, item, data)  --避免重复
    tab[item] = data or item
end

function table.seq(tab) --转为有序表
    local new = {}
    for k,v in pairs(tab) do
        table.insert(new, v)
    end
    return new
end

function table.tabtostr(tab)
    local str = ""
    if not tab then return "null" end
    for k,d in pairs(tab) do
        local temp = ""
        local type = type(d)
        if type == "table" then
            temp = "{"..table.tabtostr(d).."}"
        elseif type == "boolean" then
            temp = tostring(d)
        elseif type == "number" then
            temp = d
        elseif type == "string" then
            temp = d
        end
        if str == "" then
            str = k..":'"..temp.."'"
        else
            str = str..", "..k..":'"..temp.."'"
        end
    end
    return str
end

function table.verify(t, istonum, ...)
    local key = {...}
    for i,v in ipairs(key) do
        local data = t[v]
        if not data then
            return false
        elseif istonum then
            t[v] = tonumber(data) or data
        end
    end
    return true
end

function table.getonekey(tab)
    for k,v in pairs(tab) do
        return k
    end
end

function table.getonedata(tab)
    for k,v in pairs(tab) do
        return v
    end
end

function table.numadd(tab, key, num)
    if tab[key] then
        tab[key] = tab[key] + num
    else
        tab[key] = num 
    end
end

function table.nummul(tab, key, num)
    if tab[key] then
        tab[key] = tab[key] * num
    else
        tab[key] = num 
    end
end

--[[
    @desc: 建立权重表
    --@weightArray: 权重数组
	--@dataArray: 数据数组，可以是nil
]]
local WeightReslut = {index=nil, weight=nil, data=nil}
function table.CreateWeight(weightArray, dataArray)
    if dataArray ~= nil and #dataArray ~= #weightArray then
        ERROR("table.CreateWeight fail, #dataArray is not equal #weightArray")
        return
    end
    local oddsTab = {oddsmax=0, sortodds={}}
    for i=1,#weightArray do
        oddsTab.oddsmax = oddsTab.oddsmax + weightArray[i]
        local Reslut = {index=i, weight=weightArray[i], data=(dataArray and dataArray[i])}
        table.insert( oddsTab.sortodds, {reslut=Reslut, countOdds=oddsTab.oddsmax} )
    end
    return oddsTab
end
--@return [engine.develop.extend.tableEx#WeightReslut]
function table.RandWeight(weightTab)
    if not weightTab.oddsmax or not weightTab.sortodds then
        WARN("table.RandWeight fail, weightTab is illegal.")
        return
    end
    if #weightTab.sortodds <= 0 then
        WARN("table.RandWeight fail, sortodds is nil")
        return
    end
    local randnum = math.random(0, math.floor(weightTab.oddsmax)) --权重可能出现小数点， 要容错
    for i,v in ipairs(weightTab.sortodds) do
        if v.countOdds > 0 and v.countOdds >= randnum then
            return v.reslut
        end
    end
    --随机没出结果， 出错了
    ERROR("table.RandWeight reslut error, please check.")
end

--[[
	@desc: 批量随机权重
	--@weightArray: 权重
	--@dataArray: 数据
	--@count: 次数
	--@IsCanRepeat: 是否可以重复
]]
--@return [engine.develop.extend.tableEx#WeightReslut<>]
function table.RandWeightMore(weightArray, dataArray, count, IsCanRepeat)
    if IsCanRepeat == nil then
        IsCanRepeat = true
    end
    weightArray = table.clone(weightArray, true)
    dataArray = table.clone(dataArray, true)
    local reslut = {}
    local weightList = nil
    for i=1,count do
        if not weightList or not IsCanRepeat then   --不存在，或者不能重复
            weightList = table.CreateWeight(weightArray, dataArray)
        end
        local rand = table.RandWeight(weightList)
        table.insert(reslut, rand)
        if not IsCanRepeat then --不能重复
            table.remove(weightArray, rand.index)
            table.remove(dataArray, rand.index)
        end
    end
    return reslut
end

function table.ArrayToMap(array)
    if not array then return {} end
    local map = {}
    for i,v in ipairs(array) do
        map[v] = v
    end

    return map
end

function table.IsHave(t, value)
    for k,v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end