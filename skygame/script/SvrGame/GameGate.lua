require("engine.develop.net.WSGate")

--@SuperType [engine.develop.net.WSGate#WSGate]
GameGate = class("GameGate", WSGate)
function GameGate:ctor( )
    WSGate.ctor(self)

    self.UserAgentList = {}
end

--[[
	@desc:  创建新的用户服务
	--@SOCK:
	--@UID:
	--@accountInfo: 登录后的结构
]]
function GameGate:NewUserAgent(SOCK, UID, accountInfo)
    local _UserAgent = self.UserAgentList[UID]
    --加载数据库
    if not _UserAgent then --已经存在
        _UserAgent = SKY.newservice("script/SvrGame/User/UserProc") --不存在， 创建新服务并加载数据库
        self.UserAgentList[UID] = _UserAgent
        self:Call(_UserAgent, "RemoteExecuteFunc", "RemoteLoadDetail", UID, accountInfo)
    end
    --检测重复登录,并绑定新的sock
    local kicksock = self:Call(_UserAgent, "CheckRepeatLogin", SOCK)
    if kicksock then
        self:UnBindAgent(kicksock)
        self:Call(xSvrInfo.SERVICE.GATE, "CloseSock", kicksock)
    end
    --绑定新的SOCK
    self:BindAgent(SOCK, _UserAgent)
    --进入游戏
    self:Call(_UserAgent, "RemoteExecuteFunc", "RemoteLoginSucceed")
end

GameGate.new():Start(xSvrInfo.GATE.GAME, function(self)
    self:InitGate("G", xSvrInfo.GATE.GAME)
end)