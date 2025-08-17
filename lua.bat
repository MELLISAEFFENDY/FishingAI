@echo off
setlocal

:: Versi Lua yang mau dipasang
set LUA_VERSION=5.4.7
set LUA_URL=https://downloads.sourceforge.net/luabinaries/lua-%LUA_VERSION%_Win64_bin.zip

:: Lokasi install
set LUA_DIR=C:\Lua\%LUA_VERSION%

echo ===========================================
echo   Installer Lua %LUA_VERSION% for Windows
echo ===========================================

:: Buat folder tujuan
if not exist %LUA_DIR% (
    mkdir %LUA_DIR%
)

:: Download Lua
echo [1/3] Downloading Lua binaries...
powershell -Command "Invoke-WebRequest -Uri %LUA_URL% -OutFile %TEMP%\lua.zip"

:: Extract zip
echo [2/3] Extracting...
powershell -Command "Expand-Archive -Path %TEMP%\lua.zip -DestinationPath %LUA_DIR% -Force"

:: Tambahkan ke PATH (User Environment)
echo [3/3] Adding Lua to PATH...
setx PATH "%PATH%;%LUA_DIR%"

echo.
echo ===========================================
echo Lua %LUA_VERSION% installed successfully!
echo Please restart your terminal or VS Code.
echo Test with:  lua -v   and   luac -v
echo ===========================================

endlocal
pause
