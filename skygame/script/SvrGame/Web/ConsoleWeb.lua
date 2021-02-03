require("engine.develop.net.HTTPAgent")
--@SuperType [engine.develop.net.HTTPAgent#HTTPAgent]
ConsoleWeb = class("ConsoleWeb", HTTPAgent)
function ConsoleWeb:ctor()
    HTTPAgent.ctor(self)
    self.Protocol = "http"
end

function ConsoleWeb:Succeed(parm)
    if not table.verify(parm, true, "Func") then
        self:Response(parm.SOCK, {msg="Parm func error."})
        return
    else
        local func = self[parm.Func]
        if func then
            func(self, parm)
        else
            self:Response(parm.SOCK, {msg="Func is nil."})
        end
    end
end

function ConsoleWeb:OnlinePlayer(parm)
    if not parm.SvrID or parm.SvrID == 0 then
    else
    end
end

ConsoleWeb.new():Start()