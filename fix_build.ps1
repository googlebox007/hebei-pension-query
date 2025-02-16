# 使用PowerShell创建ANSI编码的build.bat
# 确保输出目录存在
if (!(Test-Path "dist")) {
    New-Item -ItemType Directory -Path "dist"
}

$content = @'
@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo 激活虚拟环境...
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
    copy "config\config.example.ini" "config\config.ini"
)
xcopy /E /I /Y config temp_build\config\ 2>nul

echo 开始打包...
pyinstaller --clean ^
    --add-data "temp_build\browsers\*;browsers/" ^
    --add-data "temp_build\config\*;config/" ^
    --add-data "README.md;." ^
    --add-data "LICENSE;." ^
    --add-data "version_check.ps1;." ^
    --add-data "check_env.ps1;." ^
    --icon "config/icon.ico" ^
    --name "HebeiPensionQuery" ^
    --noconsole ^
    --onefile ^
    searchinfo.py

echo 创建发布包...
mkdir "dist\HebeiPensionQuery" 2>nul
mkdir "dist\HebeiPensionQuery\data" 2>nul
mkdir "dist\HebeiPensionQuery\logs" 2>nul
mkdir "dist\HebeiPensionQuery\results" 2>nul
mkdir "dist\HebeiPensionQuery\chrome_data" 2>nul

move "dist\HebeiPensionQuery.exe" "dist\HebeiPensionQuery\" 2>nul
copy "README.md" "dist\HebeiPensionQuery\" 2>nul
copy "LICENSE" "dist\HebeiPensionQuery\" 2>nul
xcopy /E /I /Y "config" "dist\HebeiPensionQuery\config\" 2>nul

echo 创建启动器...
echo   - 复制启动脚本...
copy /Y "templates\launcher.bat" "dist\HebeiPensionQuery\启动程序.bat" >nul
echo   - 复制快捷方式脚本...
copy /Y "templates\shortcut.vbs" "dist\HebeiPensionQuery\创建快捷方式.vbs" >nul

echo 打包完整程序...
echo   - 正在压缩文件（可能需要几分钟）...
powershell -NoProfile -Command "Write-Host '    开始压缩...'; $progress = 0; Get-ChildItem 'dist\HebeiPensionQuery\*' | ForEach-Object { $progress++; Write-Progress -Activity '压缩文件' -Status $_.Name -PercentComplete (($progress / (Get-ChildItem 'dist\HebeiPensionQuery\*').Count) * 100) }; Compress-Archive -Path 'dist\HebeiPensionQuery\*' -DestinationPath 'dist\HebeiPensionQuery_v1.2.0.zip' -Force; Write-Host '    压缩完成'"

echo 清理临时文件...
echo   - 删除临时目录...
if exist temp_build rmdir /s /q temp_build
echo   - 删除发布目录...
if exist dist\HebeiPensionQuery rmdir /s /q dist\HebeiPensionQuery

echo 打包完成！
echo 发布文件：dist\HebeiPensionQuery_v1.2.0.zip

pause
'@

# 使用ANSI编码保存文件
$bytes = [System.Text.Encoding]::GetEncoding(936).GetBytes($content)
[System.IO.File]::WriteAllBytes("build.bat", $bytes)

Write-Host "build.bat has been created successfully with ANSI encoding."