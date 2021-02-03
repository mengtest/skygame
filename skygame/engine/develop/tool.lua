--[[
功能: 
Email: 407088968@qq.com
Github: https://github.com/lsx1994
create by EOD.LSX
]]--

xTool = {}

--@RefType[engine.lualib.md5#core]
xTool.md5 = require("md5")

--@RefType[engine.lualib.http.httpc#httpc]
xTool.httpc = require("http.httpc")

local base64Temp = {}
function base64Temp.base64decode(text)  --解密
end
function base64Temp.base64encode(text)  --加密
end
--@RefType[engine.develop.tool#base64Temp]
xTool.base64 = require("skynet.crypt")