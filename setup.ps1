$host.ui.RawUI.WindowSize = New-Object Management.Automation.Host.Size(80, 10)
$host.ui.RawUI.BackgroundColor = "Black"
$host.ui.RawUI.ForegroundColor = "White"
Clear-Host

Add-Type -AssemblyName System.Windows.Forms
$steamExeDialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('ProgramFilesX86')
    Filter = 'Executable files (*.exe)|*.exe'
    Title = 'select steam.exe file'
}
$steamExeDialog.ShowDialog() | Out-Null
$steamExePath = $steamExeDialog.FileName

if (!$steamExePath) { exit }

$configPath = Join-Path $PSScriptRoot 'config.cfg'
@{ SteamExePath = $steamExePath } | ConvertTo-Json | Set-Content -Path $configPath

$installPath = Join-Path $env:APPDATA 'sdgamewin'
New-Item -ItemType Directory -Path $installPath -Force
Copy-Item -Path 'gamemode.ps1' -Destination $installPath
Copy-Item -Path 'config.cfg' -Destination $installPath
$scriptPath = Join-Path $installPath 'gamemode.ps1'
$shortcutPath = Join-Path $installPath 'Gamemode.lnk'
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-File `"$scriptPath`""
$shortcut.IconLocation = $steamExePath
$shortcut.Save()
Move-Item -Path $shortcutPath -Destination ([Environment]::GetFolderPath('Desktop'))

Write-Host "do you want to set up the script to start on login? (y/n)"
$response = Read-Host
if ($response -eq 'y') {
    $task = New-ScheduledTask -Action (New-ScheduledTaskAction -Execute 'powershell.exe' -ArgumentList @('-File', $scriptPath)) -Trigger (New-ScheduledTaskTrigger -AtLogOn) -Description 'Starts gamemode.ps1 on login'
    Register-ScheduledTask -TaskName 'Gamemode Startup' -TaskPath '\' -Force
} else {
    Write-Host "note: you can always add the script to start on login later by running the following command in powershell:"
    Write-Host "schtasks /create /tn 'gamemode startup' /tr 'powershell.exe -File "$env:APPDATA\sdgamewin\gamemode.ps1"' /sc onlogon /rl highest"
}

$uninstallPath = Join-Path $installPath 'uninstall.ps1'
@"
Remove-Item -Path $env:APPDATA\sdgamewin -Recurse -Force
Unregister-ScheduledTask -TaskName 'Gamemode Startup' -Confirm:`$false
"@ | Set-Content -Path $uninstallPath

Remove-Item -Path 'setup.ps1'

Write-Host "setup complete!"