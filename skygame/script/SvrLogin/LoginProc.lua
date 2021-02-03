require("engine.develop.net.WSAgent")
require("engine.develop.mysql.DBMgr")

--@SuperType [engine.develop.net.WSAgent#WSAgent]
LoginProc = class("LoginProc", WSAgent)
function LoginProc:ctor()
    WSAgent.ctor(self)
end

function LoginProc:GenerateUserToken()
end

function LoginProc:LOGIN_CS_EODGUEST(data, sock)
    local IsShowAgreement = false
    local res = xDBTool:DBQueryCenter("SELECT * FROM userinfo WHERE EodGuestToken='%s'", data.token)
    if CheckSqlR(res) then
        IsShowAgreement = (xSvrInfo.AgreementVersion ~= res[1].AgreementVesion)
    else
        xDBTool:DBQueryCenter("INSERT INTO userinfo (GameSvrID, BannedTime, AgreementVesion, EodGuestToken) VALUES (%d, '%s', '%s', '%s')", xSvrInfo.ID, ZEROTIME, xSvrInfo.AgreementVersion, data.token)
        res = xDBTool:DBQueryCenter("SELECT * FROM userinfo WHERE EodGuestToken='%s'", data.token)
        if not CheckSqlR(res) then
            ERROR("LOGIN_CS_EODGUEST error.")
        end
    end

    local accountInfo = res[1]
    self:Send(xSvrInfo.GATE.GAME, "NewUserAgent", sock, accountInfo.UID, accountInfo)    --创建一个新的服务

    return { IsShowAgreement = IsShowAgreement, UID = accountInfo.UID }
end

function LoginProc:LOGIN_CS_AGREEMENT(data, sock)
    xDBTool:DBQueryCenter("UPDATE userinfo SET AgreementVesion='%s' WHERE UID=%d", xSvrInfo.AgreementVersion, data.UID)
end

LoginProc.new():Start()