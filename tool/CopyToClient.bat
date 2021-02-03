set clientAssets=%~1

powershell -c copy ../tool/bin/netmsg.bin %clientAssets%/resources/netspb/netmsg.bin

for /r %clientAssets%/script/netmsgClient %%i in (*.ts) do (
  powershell -c del %%i
)

powershell -c copy ../tool/bin/netmsgClient %clientAssets%/script -recurse -force

echo "copy file over..."