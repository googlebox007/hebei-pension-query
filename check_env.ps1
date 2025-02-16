$required_dirs = @("browsers", "venv", "logs", "data")
foreach ($dir in $required_dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
}

# 检查浏览器是否存在
$chrome_path = "browsers\chromium-1117\chrome-win\chrome.exe"
if (-not (Test-Path $chrome_path)) {
    Write-Host "错误：缺失浏览器文件，执行安装命令..." -ForegroundColor Red
    $env:PLAYWRIGHT_BROWSERS_PATH=(Get-Location).Path + "\browsers"
    python -m playwright install chromium
} 