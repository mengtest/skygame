require("lfs")
require("tool")

local servername = ...
local readpath = "../../"..servername.."/netmsg"
local ServerCodeDir = "../../"..servername.."/netmsgHint/"
local ClientCodeDir = "../bin/netmsgClient/"

local ServerMsgFile = "../../"..servername.."/res/netmsg.lua"

local SprotoALL = "../sproto/netmsg.lua"
local SprotoCSharp = "../sproto/netmsgCS.lua"
local SprotoLUA = "../sproto/netmsgLUA.lua"

--删除文件夹
-- os.execute("rm -rf "..ClientCodeDir)	
-- os.execute("rm -rf "..ServerCodeDir)
--创建文件夹	
-- os.execute("mkdir "..ClientCodeDir)
-- os.execute("mkdir "..ServerCodeDir)

local NormalValueType = {integer=1, boolean=1, string=1, binary=1, ["*integer"]=1, ["*boolean"]=1, ["*string"]=1, ["*binary"]=1}

local CodeHint = {}         --代码提示
local StructDesc = {}       --结构备注
local StructFileName = {}   --结构所在文件
local MODETYPE = {
    CS = 1,     -- TAG 1 ~ 5000 for C# NetMsg
    LUA = 2,    -- TAG 5001 ~ MAX for LUA NetMsg
}
local IsAllStruct = false
local NetMsgIndexSection = {[MODETYPE.CS]=1, [MODETYPE.LUA]=5001}
local CSNetMsgIndex = 0         --网络消息索引
local LUANetMsgIndex = 0        --网络消息索引

local AttributeIndex = 0    --消息属性索引
local NetMsgData = ""       --消息协议文件
local NetMsgData_CS = ""    --客户端CS模块
local NetMsgData_LUA = ""   --客户端LUA模块
for filename in lfs.dir(readpath) do
    if filename ~= '.' and filename ~= '..' then
        CodeHint[filename] = {}
        CodeHint[filename].tabsort = {}
        local tableName = ""
        local backtab = ""
        local file = io.open(readpath.."/"..filename, "r")
        local modetype = MODETYPE.LUA
        local msgdata = ""      --全部协议
        local msgdata_cs = ""   --cs专用
        local msgdata_lua = ""  --lua专用
        for line in file:lines() do
            line = string.gsub(line, "\13", "") --去掉错误字符
            local isIgnore = false--是否忽略这一行
            local msgline = line
            local attributePos = string.find(line, ":")
            if string.find(line, "{") then  --属性索引归0
                AttributeIndex = 0
            elseif string.find(line, "@CS_GO") then  --模式切换
                modetype = MODETYPE.CS
                isIgnore = true
            elseif string.find(line, "@CS_END") then  --模式切换
                modetype = MODETYPE.LUA
                isIgnore = true
            elseif string.find(line, "@ALL_GO") then  --模式切换
                IsAllStruct = true
                isIgnore = true
            elseif string.find(line, "@ALL_END") then  --模式切换
                IsAllStruct = false
                isIgnore = true
            elseif attributePos then    --属性索引自加
                --代码提示逻辑
                local attributeData = ""
                local codeDesc = nil
                local descindex = string.find(line, "#")
                if descindex then
                    attributeData = string.sub(line, 1, descindex-1)
                    codeDesc = string.sub(line, descindex+1, string.len(line))
                else
                    attributeData = string.sub(line, 1, string.len(line))
                end
                attributeData = string.gsub(attributeData, " ", "") --去掉空格
                local data = string.split(attributeData, ":")
                table.insert(CodeHint[filename][tableName], {key=data[1], value=data[2], desc=codeDesc})
                --自动添加索引
                msgline = string.gsub(line, ":", " "..AttributeIndex.." : ")
                AttributeIndex = AttributeIndex+1
            elseif string.find(line, "@") then  --消息索引
                --代码提示逻辑
                local titleNameData = ""
                local codeDesc = nil
                local descindex = string.find(line, "#")
                if descindex then
                    titleNameData = string.sub(line, 2, descindex-1)    --从2开始去掉@
                    codeDesc = string.sub(line, descindex+1, string.len(line)) --保存消息备注  
                else
                    titleNameData = string.sub(line, 2, string.len(line))
                end
                titleNameData = string.gsub(titleNameData, " ", "") --去掉空格
                
                tableName = titleNameData
                backtab = tableName
                StructDesc[tableName] = codeDesc
                --自动添加索引
                local _tempindex = 0
                if modetype == MODETYPE.LUA then
                    _tempindex = LUANetMsgIndex
                    LUANetMsgIndex = LUANetMsgIndex + 1
                elseif modetype == MODETYPE.CS then
                    _tempindex = CSNetMsgIndex
                    CSNetMsgIndex = CSNetMsgIndex + 1
                end
                msgline = titleNameData.." "..(_tempindex + NetMsgIndexSection[modetype]).." \t\t\t#"..(codeDesc or "")
            elseif string.find(line, "%.") then --数据结构
                --代码提示逻辑
                local codeDesc = nil
                local descindex = string.find(line, "#")
                if descindex then
                    tableName = string.sub(line, 1, descindex-1)
                    codeDesc = string.sub(line, descindex+1, string.len(line)) --保存消息备注  
                else
                    tableName = string.sub(line, 1, string.len(line))
                end
                tableName = string.gsub(tableName, "%.", "") --去掉.
                tableName = string.gsub(tableName, " ", "") --去掉空格
                StructDesc[tableName] = codeDesc
                CodeHint[filename][tableName] = {}
                table.insert(CodeHint[filename].tabsort, tableName)
                --保存文件名
                StructFileName[tableName] = string.gsub(filename, ".net", "")
            elseif string.find(line, "request") then
                tableName = backtab
                CodeHint[filename][tableName] = {}
                table.insert(CodeHint[filename].tabsort, tableName)
            elseif string.find(line, "response") then
                tableName = backtab.."_reply"
                CodeHint[filename][tableName] = {}
                table.insert(CodeHint[filename].tabsort, tableName)
            end
            if not isIgnore then
                --服务器用的
                msgdata = msgdata..msgline.."\n"    
                --Unity用的
                if modetype == MODETYPE.CS or IsAllStruct then
                    msgdata_cs = msgdata_cs..msgline.."\n"
                end
                if modetype == MODETYPE.LUA or IsAllStruct then
                    msgdata_lua = msgdata_lua..msgline.."\n"
                end
            end
        end
        NetMsgData = NetMsgData..msgdata.."\n"
        NetMsgData_LUA = NetMsgData_LUA..msgdata_lua.."\n"
        NetMsgData_CS = NetMsgData_CS..msgdata_cs.."\n"
        io.close(file)
    end
end

--输出代码提示 GO
-- for filename,CodeTipsTab in pairs(CodeHint) do
--     local ServerCodeTips = ""
--     local ClientCodeTips = "declare namespace net {\n"
--     for i, name in ipairs(CodeTipsTab.tabsort) do
--         local msgdata = CodeTipsTab[name]
--         local CustomTypeList = {}

--         --客户端ts提示 GO
--         if StructDesc[name] then
--             ClientCodeTips = ClientCodeTips.."\t//"..StructDesc[name].."\n"
--         end
--         ClientCodeTips = ClientCodeTips.."\texport class "..name.." {\n"
--         for _,v in pairs(msgdata) do
--             local tempValue = string.gsub(v.value, "%*", "")    --去掉*号
--             local IsArray = string.find(v.value, "%*")
--             if tempValue == "integer" then
--                 tempValue = "number"
--             elseif tempValue == "binary" then
--                 tempValue = "string"
--             end
--             if IsArray then
--                 tempValue = tempValue.."[]"
--             end
--             ClientCodeTips = ClientCodeTips.."\t\t"..v.key.." : "..tempValue..";\t\t\t//"..(v.desc or "").."\n"
--         end
--         ClientCodeTips = ClientCodeTips.."\t".."}\n"
--         --客户端ts提示 END

--         --服务器lua提示 GO
--         if StructDesc[name] then
--             ServerCodeTips = ServerCodeTips.."--"..StructDesc[name].."\n"
--         end
--         ServerCodeTips = ServerCodeTips..name.." = {\n"
--         for _,v in pairs(msgdata) do
--             if not NormalValueType[v.value] then
--                 table.insert(CustomTypeList, v)
--             end
--             ServerCodeTips = ServerCodeTips.."\t"..v.key.." = \""..v.value.."\",\t\t\t--"..(v.desc or "").."\n"
--         end
--         ServerCodeTips = ServerCodeTips.."}\n"
--         for _,v in pairs(CustomTypeList) do
--             if string.find(v.value, "*") then
--                 local file = string.gsub(v.value, "%*", "")
--                 ServerCodeTips = ServerCodeTips..string.format("--@RefType [netmsgHint.%s#%s<>]\n", StructFileName[file], file)
--             else
--                 ServerCodeTips = ServerCodeTips..string.format("--@RefType [netmsgHint.%s#%s]\n", StructFileName[v.value], v.value)
--             end
--             ServerCodeTips = ServerCodeTips..name.."."..v.key.." = \""..v.value.."\"\n"
--         end
--         ServerCodeTips = ServerCodeTips.."\n"
--         --服务器lua提示 END
--     end
--     --保存客户端ts代码提示
--     ClientCodeTips = ClientCodeTips.."}"
--     local saveClient = io.open(ClientCodeDir..string.gsub("NetHint_"..filename, ".net", ".ts"), "w")
--     saveClient:write(ClientCodeTips)
--     io.close(saveClient)

--     --保存服务器lua代码提示
--     local saveServer = io.open(ServerCodeDir..string.gsub(filename, ".net", ".lua"), "w")
--     saveServer:write(ServerCodeTips)
--     io.close(saveServer)
-- end
--输出代码提示 END

--生成全配置
local saveALL = io.open(SprotoALL, "w")
saveALL:write("return [[\n"..NetMsgData.."\n]]")
io.close(saveALL)
--复制
os.execute("cp "..SprotoALL.." "..ServerMsgFile)
print("Merge ", SprotoALL)

--生成C#
local saveCS = io.open(SprotoCSharp, "w")
saveCS:write(NetMsgData_CS)
io.close(saveCS)
print("Merge ", SprotoCSharp)

--生成lua
local saveLUA = io.open(SprotoLUA, "w")
saveLUA:write("return [[\n"..NetMsgData_LUA.."\n]]")
io.close(saveLUA)
print("Merge ", SprotoLUA)

print("Merge all file succeed.")

