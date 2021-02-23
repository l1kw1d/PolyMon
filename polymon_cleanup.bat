@echo off

NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    ECHO Administrator PRIVILEGES Detected! 
) ELSE (
   echo ######## ########  ########   #######  ########  
   echo ##       ##     ## ##     ## ##     ## ##     ## 
   echo ##       ##     ## ##     ## ##     ## ##     ## 
   echo ######   ########  ########  ##     ## ########  
   echo ##       ##   ##   ##   ##   ##     ## ##   ##   
   echo ##       ##    ##  ##    ##  ##     ## ##    ##  
   echo ######## ##     ## ##     ##  #######  ##     ## 
   echo.
   echo.
   echo ####### ERROR: ADMINISTRATOR PRIVILEGES REQUIRED #########
   echo This script must be run as administrator to work properly!  
   echo ##########################################################
   echo.
   PAUSE
   EXIT /B 1
)

REM Stop Polymon if running

tasklist /FI "IMAGENAME eq plgx_mon_agent.exe" 2>NUL | find /I /N "plgx_mon_agent.exe">NUL
if "%ERRORLEVEL%"=="0" (
	echo "Stopping Polymon"
	taskkill /F /IM plgx_mon_agent.exe >nul 2>&1
)

echo "Waiting for services to get unloaded. It can take a few seconds..."

REM Stop plgx_osqueryd if running
for /F "tokens=3 delims=: " %%H in ('sc query plgx_osqueryd ^| findstr "        STATE"') do (
  if /I "%%H" EQU "RUNNING" (
   echo "Stopping plgx_osqueryd service"
   sc stop plgx_osqueryd >nul 2>&1
  )
)

set check=0

REM check if vast is still not unloaded
:wait1
for /F "tokens=3 delims=: " %%H in ('sc query vast ^| findstr "        STATE"') do (
  if /I "%%H" EQU "RUNNING" (
   if %check% EQU 3 (
   echo "The cleanup is not able to unload the drivers...exiting"
   exit /B 1
   ) else (
	 REM Wait for 5 seconds for vast to get unloaded
	 sc stop vast >nul 2>&1
     timeout /T 5 /NOBREAK >nul 2>&1
     set /a check=check+1
     goto wait1
	 )
  )
)

set check=0

REM check if vastnw is still not unloaded
:wait2
for /F "tokens=3 delims=: " %%H in ('sc query vastnw ^| findstr "        STATE"') do (
  if /I "%%H" EQU "RUNNING" (
   if %check% EQU 3 (
   echo "The cleanup is not able to unload the drivers...exiting"
   exit /B 1
   ) else (
	 REM Wait for 5 seconds for vastnw to get unloaded
	 sc stop vastnw >nul 2>&1
     timeout /T 5 /NOBREAK >nul 2>&1
     set /a check=check+1
     goto wait2
	 )
  )
)

set check=0

REM check if Everything needs to be unloaded
IF EXIST "%ProgramFiles%\plgx_osquery\Everything\" (
    set ERRORLEVEL=0
	tasklist /FI "IMAGENAME eq Everything.exe" 2>NUL | find /I /N "Everything.exe">NUL
	if "%ERRORLEVEL%"=="0" (
		taskkill /F /IM Everything.exe
	)

:wait3
	for /F "tokens=3 delims=: " %%H in ('sc query everything ^| findstr "        STATE"') do (
	  if /I "%%H" EQU "RUNNING" (
	   if %check% EQU 3 (
	   echo "The cleanup is not able to stop Everything service...exiting"
	   exit /B 1
	   ) else (
		 REM Wait for 5 seconds for extension to get unloaded
		 sc stop everything >nul 2>&1
		 sc delete everything >nul 2>&1
		 timeout /T 5 /NOBREAK >nul 2>&1
		 set /a check=check+1
		 goto wait3
		 )
	  )
	)
)


REM plgx_osqueryd, vast and vastnw should be removed
sc stop plgx_osqueryd >nul 2>&1
sc delete plgx_osqueryd >nul 2>&1
sc stop vast >nul 2>&1
sc delete vast >nul 2>&1
del /F /Q /S "%SystemRoot%\System32\drivers\vast.sys" >nul 2>&1
sc stop vastnw >nul 2>&1
sc delete vastnw >nul 2>&1
del /F /Q /S "%SystemRoot%\System32\drivers\vastnw.sys" >nul 2>&1

echo "Cleaning the files.."

REM cleanup event channels
wevtutil cl PlgxRealTimeFileEvents/Log >nul 2>&1
wevtutil cl PlgxRealTimeProcessEvents/Log >nul 2>&1
wevtutil cl PlgxRealTimeRemoteThreadEvents/Log >nul 2>&1
wevtutil cl PlgxRealTimeProcessOpenEvents/Log >nul 2>&1
wevtutil cl PlgxRealTimeRemovableMediaEvents/Log >nul 2>&1
wevtutil cl PlgxRealTimeImageLoadEvents/Log >nul 2>&1
wevtutil cl PlgxRealTimeImageLoadProcessMapEvents/Log >nul 2>&1
wevtutil cl PlgxRealTimeHttpEvents/Log >nul 2>&1
wevtutil cl PlgxRealTimeSslEvents/Log >nul 2>&1
wevtutil cl PlgxRealTimeSocketEvents/Log >nul 2>&1
wevtutil cl PlgxRealTimeDnsEvents/Log >nul 2>&1
wevtutil cl PlgxRealTimeDnsResponseEvents/Log >nul 2>&1
wevtutil cl PlgxRealTimeRegistryEvents/Log >nul 2>&1
wevtutil cl PlgxRealTimeYaraEvents/Log >nul 2>&1
wevtutil cl PlgxRealTimeLogEvents/Log >nul 2>&1
wevtutil cl PlgxRealTimeFileTimestompEvents/Log >nul 2>&1
wevtutil cl PlgxRealTimePefileEvents/Log >nul 2>&1
wevtutil um "%ProgramFiles%\plgx_osquery\PolyEvents.man" >nul 2>&1

REM Clean up installation folder
rmdir /S /Q "%ProgramFiles%\plgx_osquery" >nul 2>&1

REM clean up the temp folder
rmdir /S /Q "%SystemDrive%\plgx-temp" >nul 2>&1

REM clean up registries
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\PlgxAgentUI /f >nul 2>&1

REM cleanup shortcuts
del /F /S /Q "%PUBLIC%\Desktop\Polylogyx Agent.lnk" >nul 2>&1
del /F /S /Q "%ProgramData%\Microsoft\Windows\Start Menu\Programs\ApplicationPrograms\Polylogyx Agent.lnk" >nul 2>&1

REM delete scheduled task
SCHTASKS.exe /Delete /TN "PlgxMonAgentStart" /F >nul 2>&1

REM run msi uninstallers once finally
MsiExec.exe /X{04307B2E-2F50-43F3-9719-98D692E99669} /qn 

IF EXIST PolyMon_setup.exe (
PolyMon_setup.exe /uninstall /quiet
) ELSE (
echo "PolyMon_setup.exe not found in current directory. Run 'PolyMon_setup.exe /uninstall' once to complete the cleanup."
)

echo "All done. You can begin installing Polymon again.."