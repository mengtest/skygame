1.创建mongo数据库
-------创建管理员-------
use admin;
db.createUser({ user: "admin", pwd: "eodmima11223", roles: [{ role: "userAdminAnyDatabase", db:"admin" }] });
-------创建日志库-------
use skygame_gamelog;
db.createUser({ user: "eoduser", pwd: "eodpass@123", roles: [{ role: "dbOwner", db: "skygame_gamelog"}] });

use skygame_battlelog
db.createUser({ user: "eoduser", pwd: "eodpass@123", roles: [{ role: "dbOwner", db: "skygame_battlelog"}] });

use skygame_chatlog
db.createUser({ user: "eoduser", pwd: "eodpass@123", roles: [{ role: "dbOwner", db: "skygame_chatlog"}] });
