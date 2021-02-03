set clientAssets=%~1

powershell -c copy ../tool/bin/netmsg.cs %clientAssets%/csharp/netmsg.cs
powershell -c copy ../tool/sproto/netmsgLUA.lua %clientAssets%/lua/netmsg.lua

echo "copy file over..."