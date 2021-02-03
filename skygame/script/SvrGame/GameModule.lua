require("script.Frame.Common.Common")    
require("script.Frame.Common.ServerInit") --服务器初始化
require("script.Frame.Common.DropReckon") --掉落

--自动数据库
require("script.Frame.AutoSqlTable.AutoSqlUserInfo")
require("script.Frame.AutoSqlTable.AutoSqlGmbackstageinfo")
require("script.Frame.Common.GlobalData", false)

--模块
require("script.SvrGame.Player.PlayerLogic") 
require("script.SvrGame.Player.PlayerProc") 