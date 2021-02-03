require("engine.develop.BaseDB")
require("engine.develop.BaseMgr")
--@SuperType [engine.develop.BaseDB#BaseDB|engine.develop.BaseMgr#BaseMgr]
PlayerLogic = class("PlayerLogic", BaseDB, BaseMgr)

function PlayerLogic:ctor()
    BaseDB.ctor(self)
    BaseMgr.ctor(self)
    
    self:DBInit(xSvrInfo.DBGAME, "playerinfo", "UID")
    self.DB_UID = self:DBData("UID", "number", 0)
    self.DB_UserName = self:DBData("UserName", "string", "")
    self.DB_LastOnlineTime = self:DBData("LastOnlineTime", "time", 0)
    self.DB_RegisterTime = self:DBData("RegisterTime", "time", 0)
    self.DB_DeviceType = self:DBData("DeviceType", "string", "")
    self.DB_Platform = self:DBData("Platform", "string", "")

    xEvent:BindEvent(EVENT_USER.OnLoadCreate, self.OnLoadCreate, self)
    xEvent:BindEvent(EVENT_USER.OnLoadFromDB, self.OnLoadFromDB, self)
end

function PlayerLogic:OnLoadCreate()
    self.DB_UserName.set(GUSER.UID)
    self.DB_RegisterTime.set(os.time())
    self:DBRegInsert({UID=GUSER.UID}) --插入新玩家

    -- self.DB_UID.set
end

function PlayerLogic:OnLoadFromDB()
    self:LogicLoadFromDB()
end