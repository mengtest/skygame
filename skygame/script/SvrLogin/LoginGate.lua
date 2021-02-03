require("engine.develop.net.WSGate")

--@SuperType [engine.develop.net.WSGate#WSGate]
LoginGate = class("LoginGate", WSGate)
function LoginGate:ctor( )
    WSGate.ctor(self)
end

LoginGate.new():Start(xSvrInfo.GATE.LOGIN, function(self)
    self:InitGate("L", xSvrInfo.GATE.LOGIN, "script/SvrLogin/LoginProc")
end)