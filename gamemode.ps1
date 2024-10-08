$host.ui.RawUI.WindowSize = New-Object Management.Automation.Host.Size(80, 10)
$host.ui.RawUI.BackgroundColor = "Black"
$host.ui.RawUI.ForegroundColor = "White"
Clear-Host

$configPath = Join-Path $PSScriptRoot 'config.cfg'
$config = Get-Content -Path $configPath | ConvertFrom-Json

Write-Host "Starting Steam Big Picture Mode..."
Start-Process -FilePath $config.SteamExePath -ArgumentList "-start steam://open/bigpicture"
Write-Host "Killing explorer.exe..."
taskkill /F /IM explorer.exe

Start-Sleep -Seconds 5

while ($true) {
    if (Get-Process | Where-Object { $_.MainWindowTitle -eq "Steam Big Picture Mode" }) {
        Write-Host "Waiting for Steam Big Picture to close..."
        Start-Sleep -Seconds 10
    } else {
        Write-Host "Big Picture closed, returning to desktop..."
		Start-Process explorer
        exit
    }
}