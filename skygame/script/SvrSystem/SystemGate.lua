require("engine.develop.net.WSGate")

--@SuperType [engine.develop.net.WSGate#WSGate]
SystemGate = class("SystemGate", WSGate)
function SystemGate:ctor( )
    WSGate.ctor(self)
end

SystemGate.new():Start(xSvrInfo.GATE.SYSTEM, function(self)
    self:InitGate("S", xSvrInfo.GATE.SYSTEM, "script/SvrSystem/SystemProc")
end)