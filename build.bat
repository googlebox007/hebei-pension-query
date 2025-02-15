@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

rem 使用8.3短路径格式
set "PROJ_ROOT=%~dp0"
set "PROJ_ROOT=%PROJ_ROOT:\养老待~1=%"
set "BUILD_DIR=%PROJ_ROOT%\dist"
set "APP_NAME=PensionCertTool"

echo 正在清理旧构建...
rmdir /s /q "%BUILD_DIR%" 2>nul

echo 生成浏览器驱动...
python -m playwright install chromium

echo 获取浏览器实际路径...
set "CHROME_PATH=%PROJ_ROOT%\bin\chromium-1098\chrome-win\chrome.exe"

if not exist "%CHROME_PATH%" (
    echo 错误：自动获取浏览器路径失败！
    echo 请手动检查目录：%PROJ_ROOT%\bin
    pause
    exit /b 1
)

echo 修复requirements.txt...
powershell -Command "(Get-Content 'requirements.txt') -replace '澶勭悊Excel.*', '# 处理Excel日期格式需要' | Out-File 'requirements.txt' -Encoding UTF8"

echo 安装依赖...
pip install -r requirements.txt --force-reinstall --no-cache-dir --user

echo 打包程序...
pyinstaller --onefile ^
  --add-data "%CHROME_PATH%;bin" ^
  --add-data "%PROJ_ROOT%\config\config.ini;config" ^
  --hidden-import=openpyxl.cell._writer ^
  --noconsole ^
  --icon="%PROJ_ROOT%\docs\icon.ico" ^
  --name %APP_NAME% ^
  "%PROJ_ROOT%\searchinfo.py"

echo 复制运行时文件...
if not exist "%PROJ_ROOT%\bin\chrome_data" (
    echo 错误：chrome_data目录不存在！
    pause
    exit /b 1
)
robocopy "%PROJ_ROOT%\bin\chrome_data" "%BUILD_DIR%\runtime\chrome_data" /E /XD *.log /NJH /NJS /NDL /NC /NS /NP

echo 复制配置文件...
if not exist "config\config.ini" (
    echo 正在生成默认配置文件...
    copy "config\config.example.ini" "config\config.ini"
)
copy "config\config.ini" "%BUILD_DIR%\runtime\"

echo 生成启动脚本...
(echo @echo off
echo chcp 65001 > nul
echo title 河北省养老认证查询工具 v1.0
echo cd /d "%%~dp0\runtime"
echo if not exist %APP_NAME%.exe (
echo    echo 错误：未找到主程序！
echo    pause
echo    exit /b 1
echo )
echo start "" "%APP_NAME%.exe"
) > "%BUILD_DIR%\start.bat"

echo 构建完成！输出目录: "%BUILD_DIR%\"
pause 