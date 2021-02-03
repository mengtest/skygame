--[[
功能: 二进制
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--
require("engine.develop.class")
Binary = class("Binary")
--二进制转int
function Binary:BTOUINT32(num1, num2, num3, num4)
    local num = 0
    num = num + self:leftShift(num1, 24)
    num = num + self:leftShift(num2, 16)
    num = num + self:leftShift(num3, 8)
    num = num + num4
    return num
end

-- int转二进制
function Binary:UINT32TOB(num)
    local str = ""
    str = str .. self:numToAscii(self:rightShift(num, 24))
    str = str .. self:numToAscii(self:rightShift(num, 16))
    str = str .. self:numToAscii(self:rightShift(num, 8))
    str = str .. self:numToAscii(num)
    return str
end
 
-- 二进制转shot
function Binary:BTOUIN16(num1, num2)
    local num = 0
    num = num + self:leftShift(num1, 8)
    --if num2 then
        num = num + num2
    --end
    return num
end
 
-- shot转二进制
function Binary:UINT16TOB(num)
    local str = ""
    str = str .. self:numToAscii(self:rightShift(num, 8))
    str = str .. self:numToAscii(num)
    return str
end
 
-- 左移
function Binary:leftShift(num, shift)
    num = num + 0
    return math.floor(num * (2 ^ shift))
end
 
-- 右移
function Binary:rightShift(num, shift)
    num = num + 0
    return math.floor(num / (2 ^ shift))
end
-- 转成Ascii
function Binary:numToAscii(num)
    num = num % 256
    return string.char(num)
end

local _convertTable = {
    [0] = "0",
    [1] = "1",
    [2] = "2",
    [3] = "3",
    [4] = "4",
    [5] = "5",
    [6] = "6",
    [7] = "7",
    [8] = "8",
    [9] = "9",
    [10] = "A",
    [11] = "B",
    [12] = "C",
    [13] = "D",
    [14] = "E",
    [15] = "F",
    [16] = "G",
}
local function GetNumFromChar(char)
    for k, v in pairs(_convertTable) do
        if v == char then
            return k
        end
    end
    return 0
end
local function Convert(dec, x)

    local function fn(num, t)
        if(num < x) then
            table.insert(t, num)
        else
            fn( math.floor(num/x), t)
            table.insert(t, num%x)
        end
    end

    local x_t = {}
    fn(dec, x_t, x)

    return x_t
end
--值->字符串 x为具体进制
function Binary:ConvertDec2X(dec, x)
    local x_t = Convert(dec, x)

    local text = ""
    for k, v in ipairs(x_t) do
        text = text.._convertTable[v]
    end
    return text
end
--字符串->值 x为具体进制
function Binary:ConvertStr2Dec(text, x)
    local x_t = {}
    local len = string.len(text)
    local index = len
    while ( index > 0) do
        local char = string.sub(text, index, index)
        x_t[#x_t + 1] = GetNumFromChar(char)
        index = index - 1
    end

    local num = 0
    for k, v in ipairs(x_t) do
        num = num + v * x^(k - 1)
    end
    return num
end

xBinary = Binary.new()

return xBinary