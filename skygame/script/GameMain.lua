require("engine.develop.BaseMain")
--@SuperType [engine.develop.BaseMain#BaseMain]

GameMain = class("GameMain", BaseMain)
GameMain.new():Start(
    function(self)
        --启动数据库连接
        SKY.call(xSvrInfo.SERVICE.DBC, "lua", "ConnectDBCenter")
        SKY.call(xSvrInfo.SERVICE.DBC, "lua", "ConnectDBGame")
    end,
    function(self)
        --启动全局数据服务
        SKY.newservice("script/Frame/Common/GlobalData", "true")
        --启动连接监听
        SKY.newservice("engine/develop/net/WSWatch")
        
        --启动系统服
        SKY.newservice("script/SvrSystem/SystemGate")
        --启动登录服
        SKY.newservice("script/SvrLogin/LoginGate")
        --启动游戏服
        SKY.newservice("script/SvrGame/GameGate")
        
        --启动后台处理
        -- SKY.newservice("script/SvrGame/Admin/BackstageMgr")
        --启动控制台
        -- SKY.webnewservice("script/SvrGame/Web/ConsoleWeb", xSvrInfo:GetV("ControlPort"))

        LOG("GameSvr Start.........")
    end, 
    "script.SvrGame.GameModule"
)