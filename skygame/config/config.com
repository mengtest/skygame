include "config.ip"
include "config.path"
include "config.db"

thread = 8      --线程数
logpath = "."
harbor = 0                      --0-单节点模式 1-master slave
bootstrap = "snlua bootstrap"	-- The service for bootstrap
cluster = "config/clustercfg.lua"  --集群文件
certfile = "EODCERT.pem"
keyfile = "EODKEY.pem"
wsmode = "ws"