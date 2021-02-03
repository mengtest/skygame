--字符串分割
function string.split(szFullString, sep, tonum) 
    if tonum == nil then tonum = true end
    if szFullString == "" or not sep then return {} end
    local t={}
    for str in string.gmatch(szFullString, "([^"..sep.."]+)") do
        if tonum then
            table.insert(t, tonumber(str) or str)
        else
            table.insert(t, str)
        end
    end
    return t
end
--字符串计数
function table.nums(tab)
    local num = 0;
    for i,v in pairs(tab) do
        num = num + 1;
    end
    return num;
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
		lua = lua..obj
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
--打印表数据
function table.log(tab, tag, deep)
    print("@@@@@@@@@@@@@@@@@@@@@ TablePrint Start @@@@@@@@@@@@@@@@@")
    if tag then
        print("@TableName:", tag)
    end

    print("@TableCount:", table.nums(tab))
    if deep or deep == nil then
        print(table.serialize(tab))
    else
        print("{")
        for k,v in pairs(tab) do
            print(k, v)
        end
        print("}")
    end
    print("@@@@@@@@@@@@@@@@@@@@@ TablePrint End @@@@@@@@@@@@@@@@@")
end