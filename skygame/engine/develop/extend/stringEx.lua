--[[
功能: string扩展功能
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

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

function string.splitmap(szFullString)
    local tab = {}
    local arr = string.split(szFullString, ",")
    for k,v in ipairs(arr) do
        local d = string.split(v, ":")
        tab[d[1]] = d[2]
    end

    return tab
end

function string.splitarray(szFullString)
    local s = string.UnHeadTail(szFullString)
    return string.split(s, ",")
end

function string.UnHeadTail(str)
    if string.len(str) < 2 then
        return str
    end
    return string.sub(str, 2, -2)
end
function string.UnTail(str)
    if string.len(str) < 1 then
        return str
    end
    return string.sub(str, 1, -2)
end

local mysqlEscapeMode = "[%z\'\"\\\26\b\n\r\t%%]";
local mysqlEscapeReplace = {['\0']='\\0', ['\'']='\\\'', ['\"']='\\\"', ['\\']='\\\\', ['\26']='\\z', ['\b']='\\b', ['\n']='\\n', ['\r']='\\r', ['\t']='\\t', ['%']='%%'};
function string.mysqlEscape(s)    --防止出现特殊符号
    return string.gsub(s, mysqlEscapeMode, mysqlEscapeReplace);
end

function string.checktype(str, AllowLetter, AllowNum, AllowChinese, AllowSpecial)
    for i=1,#str do
        local curByte = string.byte(str, i)
        if curByte >= 48 and curByte <= 57 then --数字
            if not AllowNum then return false end
        elseif (curByte >= 65 and curByte <= 90) or (curByte >= 97 and curByte <= 122) then --字母
            if not AllowLetter then return false end
        elseif curByte >= 127 then --汉字
            if not AllowChinese then return false end
        else
            if not AllowSpecial then return false end
        end
    end
    return true
end

function string.randomLetter(len)
    local rt = ""
    for i = 1, len, 1 do
        rt = rt..string.char(math.random(97,122))
    end
    return rt
end

function string.lastchar(str)
    local len = string.len(str)
    return string.sub(str, len, len)
end