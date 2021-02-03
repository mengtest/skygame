@set serverConfig=%~1
@set clientConfig=%~2

@setlocal enabledelayedexpansion
@set classpath=
@for %%c in (%clientConfig%\*.lua) do @(
    IF defined classpath (
        @set classpath=!classpath!,%%~nc
    ) ELSE (
        @set classpath=%%~nc
    )
)
@powershell ../tool/generateConfig/lua53.exe ../tool/generateConfig/generate.lua %serverConfig% %clientConfig% %classpath%