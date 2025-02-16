@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo 激活虚拟环境..
call venv\Scripts\activate.bat

echo 安装必要的包...
pip install -r requirements.txt
pip install pyinstaller

echo 清理旧的构建文件...
rmdir /s /q dist build 2>nul
del /f /q *.spec 2>nul

echo 准备打包环境...
mkdir temp_build 2>nul

echo 下载并准备浏览器...
python -m playwright install chromium
xcopy /E /I /Y browsers temp_build\browsers\ 2>nul

echo 准备配置文件...
if not exist "config\config.ini" (
    echo 错误：缺少配置文件 config\config.ini
    pause
    exit /b 1
)
xcopy /E /I /Y config temp_build\config\ 2>nul

echo 开始打包...
pyinstaller --clean ^
    --add-data "temp_build\browsers;browsers" ^
    --add-data "temp_build\config;config" ^
    --add-data "README.md;." ^
    --add-data "LICENSE;." ^
    --add-data "version_check.ps1;." ^
    --add-data "check_env.ps1;." ^
    --hidden-import configparser ^
    --hidden-import playwright ^
    --hidden-import openpyxl ^
    --hidden-import requests ^
    --hidden-import python-dateutil ^
    --icon "config/icon.ico" ^
    --name "HebeiPensionQuery" ^
    --onefile ^
    searchinfo.py

echo 创建发布程序?..
mkdir "dist\HebeiPensionQuery" 2>nul
mkdir "dist\HebeiPensionQuery\data" 2>nul
mkdir "dist\HebeiPensionQuery\logs" 2>nul
mkdir "dist\HebeiPensionQuery\results" 2>nul
mkdir "dist\HebeiPensionQuery\chrome_data" 2>nul

move "dist\HebeiPensionQuery.exe" "dist\HebeiPensionQuery\" 2>nul
copy "README.md" "dist\HebeiPensionQuery\" 2>nul
copy "LICENSE" "dist\HebeiPensionQuery\" 2>nul
xcopy /E /I /Y "config" "dist\HebeiPensionQuery\config\" 2>nul

echo 创建启动程序?..
echo   - 复制启动脚本...
copy /Y "templates\launcher.bat" "dist\HebeiPensionQuery\启动程序.bat" >nul
echo   - 复制快捷方式脚本...
copy /Y "templates\shortcut.vbs" "dist\HebeiPensionQuery\创建快捷方式.vbs" >nul

echo 打包完整程序...
echo   - 正在压缩文件（可能需要几分钟）...
echo   - 等待文件释放（5秒）...
timeout /t 5 /nobreak >nul

powershell -NoProfile -Command "Write-Host '    开始压缩...'; $progress = 0; Get-ChildItem 'dist\HebeiPensionQuery\*' | ForEach-Object { $progress++; Write-Progress -Activity '压缩文件' -Status $_.Name -PercentComplete (($progress / (Get-ChildItem 'dist\HebeiPensionQuery\*').Count) * 100) }; Compress-Archive -Path 'dist\HebeiPensionQuery\*' -DestinationPath 'dist\HebeiPensionQuery_v1.2.0.zip' -Force; Write-Host '    压缩完成'"

if not exist "dist\HebeiPensionQuery_v1.2.0.zip" (
    echo   - 首次压缩失败，重试中...
    timeout /t 3 /nobreak >nul
    powershell -NoProfile -Command "Compress-Archive -Path 'dist\HebeiPensionQuery\*' -DestinationPath 'dist\HebeiPensionQuery_v1.2.0.zip' -Force"
)

echo 清理临时文件...
echo   - 删除临时目录...
if exist temp_build rmdir /s /q temp_build
echo   - 删除发布目录...
timeout /t 2 /nobreak >nul
if exist dist\HebeiPensionQuery rmdir /s /q dist\HebeiPensionQuery

echo 打包完成?
echo 发布文件：dist\HebeiPensionQuery_v1.2.0.zip

pause