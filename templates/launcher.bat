@echo off
chcp 65001 > nul
title 河北省养老认证查询工具
cd /d %~dp0
if not exist data mkdir data
if not exist logs mkdir logs
if not exist results mkdir results
if not exist chrome_data mkdir chrome_data

if not exist config\config.ini (
    echo 错误：配置文件丢失！
    pause
    exit /b 1
)

if not exist HebeiPensionQuery.exe (
    echo 错误：程序文件丢失！
    pause
    exit /b 1
)

echo 正在启动程序...
start "" "HebeiPensionQuery.exe" 