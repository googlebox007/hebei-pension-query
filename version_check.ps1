$browsers_dir = Join-Path (Get-Location).Path "browsers"
$versions = Get-ChildItem -Directory -Path "$browsers_dir\chromium-*" | Sort-Object Name -Descending

if ($versions.Count -eq 0) {
    Write-Host "未检测到浏览器版本，执行安装..." -ForegroundColor Red
    $env:PLAYWRIGHT_BROWSERS_PATH=$browsers_dir
    python -m playwright install chromium
    exit
}

$latest = $versions[0].Name
Write-Host "当前最新浏览器版本: $latest" -ForegroundColor Green 