local outDir,ConfigDir,fileList = ...

--清空文件夹
os.execute("del /Q "..outDir)	 

TYPE_NUMBER_DEFAULT = "number"
TYPE_STRING_DEFAULT = "string"
TYPE_TABLE_DEFAULT = "table"
TYPE_BOOL_DEFAULT = "bool"
None = "none"

function tablenum(t)
    local i = 0
    for k,v in pairs(t) do
        i = i + 1
    end
    return i
end

function strsplit(szFullString, sep, tonum) 
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

function keytostr(tab, keytab)
    if not tab then return "{}" end
    local str = "{"
    for index,key in ipairs(keytab) do
        local v = tab[index]
        if v == "None" then
            print("Warn: key type error.", key)
        end
        local _temp = key.."=\""..v.."\""
        if str == "{" then
            str = str.._temp
        else
            str = str..", ".._temp
        end
    end
    return str.."}"
end

function SafeStr(str)
    local s = string.gsub(str, "\n", "\\n")
    s = string.gsub(s, "\t", "\\t")
    s = string.gsub(s, "\"", "\\\"")
    return s
end

function tabtostr(tab, keytab, index)
    if not tab then return "{}" end

    index = index or 0
    index = index + 1

    local str = "{"
    if index == 1 then
        str = str.."\n"
    end

    local realNum = tablenum(tab)
    local IsIntPair = realNum == #tab    --是不是数组

    local i = 0
    for k,d in pairs(tab) do
        i = i + 1
        local temp = ""
        local T = type(d)
        if T == "table" then
            temp = tabtostr(d, keytab, index)
        elseif T == "boolean" then
            temp = tostring(d)
        elseif T == "number" then
            temp = d
        elseif T == "string" then
            temp = "\""..SafeStr(d).."\""
        end
        if index == 1 then
            k = "["..d[1].."]"
        elseif index == 2 then
            k = keytab[k]
            if not k then
                print("error key:", k)
            end
        else
            if type(k) == "string" then
                k = "[\""..SafeStr(k).."\"]"
            else
                if IsIntPair then
                    k = nil
                else
                    k = "["..k.."]"
                end
            end
        end

        if k then
            str = str..k.."="..temp..","
        else
            str = str..temp..","
        end

        if i == realNum then
            str = string.sub(str,1,string.len(str)-1)
        end

        if index == 1 then
            str = str.."\n"
        end
    end
    return str.."}"
end

function table.makereadonly()
end

local AllConfig = {}
ConfigMgr = {}
ConfigMgr.CreateConfigClass = function(moduleName)
    AllConfig[moduleName] = {}
    return AllConfig[moduleName]
end

--加载lua
fileList = strsplit(fileList, ",", false)
for k,name in pairs(fileList) do
    package.path = ConfigDir.."/"..name..".lua"
    require(name)
end

for filename,tab in pairs(AllConfig) do
    local keytab = {}
    for k,index in pairs(tab._fieldIndexs) do
        if type(k) == "string" then
            keytab[index] = k
        end
    end

    local configstr = "local types = "..keytostr(tab._fieldIndexs, keytab).."\n"..
    "local table = "..tabtostr(tab._listConfig, keytab).."\n"..
    "return {table, types}"
    
    local saveServer = io.open(outDir.."/"..string.gsub(filename, "CfgMgr", "")..".lua", "w")
    saveServer:write(configstr)
    io.close(saveServer)
end

print("config generate ok!")