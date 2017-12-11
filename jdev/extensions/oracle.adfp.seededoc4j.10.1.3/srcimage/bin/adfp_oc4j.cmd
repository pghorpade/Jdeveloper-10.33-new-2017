@echo off
@setlocal

rem
rem oc4j_jdev.cmd - batch file for invoking ADF Portal Dev Kit OC4J 
rem 
rem Usage:  oc4j.cmd JAVA_HOME ORACLE_HOME EXT_DIR [Options]
rem
rem       Options:
rem        -start                : start OC4J
rem        -shutdown -port <ORMI port> -password <password>
rem                              : stop OC4J
rem        -version              : display the version
rem        -help                 : display this message
rem
rem Copyright (c) 2006, Oracle. All rights reserved.  
rem

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Dev-kit OC4J init
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set JAVA_HOME=%1%
shift
set ORACLE_HOME=%1%
shift
set EXT_DIR=%1%
shift
set SERVER_XML=%EXT_DIR%\j2ee\home\config\server.xml

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Install wsrp if not exists
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if NOT exist %EXT_DIR%\j2ee\home\shared-lib\oracle.wsrp\1.0 (
  echo wsrp not installed 
  echo installing wsrp......
  mkdir %EXT_DIR%\javacache
  mkdir %EXT_DIR%\javacache\admin
  cd %EXT_DIR%\j2ee\home\
  %JAVA_HOME%\bin\java -jar %ORACLE_HOME%\adfp\lib\portlet-server-install.jar
  cd %EXT_DIR%\bin
)

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Create default WebCliping repository path if not exists
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if NOT exist %ORACLE_HOME%\portal\portletdata\tools\webClipping (
  echo Create WebClipping repository path 
  mkdir %ORACLE_HOME%\portal
  mkdir %ORACLE_HOME%\portal\portletdata
  mkdir %ORACLE_HOME%\portal\portletdata\tools
  mkdir %ORACLE_HOME%\portal\portletdata\tools\webClipping
)

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Copy portal/conf/* to ORACLE_HOME
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if NOT exist %ORACLE_HOME%\portal\conf\ca-bundle.crt (
  echo Create portal conf
  mkdir %ORACLE_HOME%\portal
  mkdir %ORACLE_HOME%\portal\conf
  copy %EXT_DIR%\portal\conf\* %ORACLE_HOME%\portal\conf
)

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::: START CONFIGURATION SECTION ::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set J2EE_HOME=%ORACLE_HOME%\j2ee\home

rem Any persistent arguments to specify at the JVM level can be set here 
set JVMARGS=-XX:MaxPermSize=128m -Xmx512m

set CMDARGS=
set VERBOSE=on

set ORMI_URL=ormi://127.0.0.1
set ORMI_USER=oc4jadmin

set OC4J_JAR=%J2EE_HOME%\oc4j.jar
set ADMIN_JAR=%J2EE_HOME%\admin.jar

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::  END CONFIGURATION SECTION  ::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::

rem OC4J Command Shell Script
rem
rem Supports start, version commands

if %JAVA_HOME%=="" (
  echo Error: JAVA_HOME environment variable is not defined.
  echo        We cannot execute java.
  goto end
)

if NOT exist %JAVA_HOME%\bin\java.exe (
  echo Error: Can not find java executable in %JAVA_HOME%\bin. 
  echo        Please make sure the JAVA_HOME environment variable is defined correctly.
  goto end
)

if %ORACLE_HOME%=="" (
  echo Error: The ORACLE_HOME environment variable must be set before executing this script. Set this to the directory into which you unzipped oc4j_extended.zip.
  goto end
)

set CMD=%1%

if /I "%CMD%"=="-start" ( goto start )
if /I "%CMD%"=="-shutdown" ( goto shutdown )
if /I "%CMD%"=="-version" ( goto version )
if /I "%CMD%"=="-help" ( goto help )
if /I "%CMD%"=="-?" ( goto help )
if /I "%CMD%"=="" ( goto help )
goto error

rem
rem ERROR Command
rem 
:error
echo.
echo Error: The option '%CMD%' was not recognized.
goto help

rem
rem HELP Command
rem 
:help
echo.
echo Usage: oc4j.cmd [Options]
echo.
echo Options:
echo.
echo  -start                  : start OC4J 
echo  -shutdown -port ^<ORMI port^> -password ^<password^>
echo                          : stop OC4J
echo  -version                : display the version
echo  -help                   : display this message
echo.
goto end

rem
rem START Command
rem
:start
if not exist %SERVER_XML% (
  echo Error: Can not find %SERVER_XML%.
  goto end
) 
echo Starting OC4J from %J2EE_HOME% ...
set CMDARGS=-config %SERVER_XML%
if "%2%"=="" ( 
  goto oc4j
) else (
  echo.
  echo Error: The option %2% was not recognized.
  goto help
)

rem
rem SHUTDOWN Command
rem 
:shutdown
if "%2%"=="" goto next
if /I "%2%"=="-port" (
  if "%3%"=="" (
    echo.
    echo Error: You must specify the ORMI port value.
    goto help
  ) else (
    set ORMI_PORT=%3%
    shift
    shift
    goto shutdown
  )
)
if /I "%2%"=="-password" (
  if "%3%"=="" (
    echo.
    echo Error: You must supply a password to use.
    goto help 
  ) else (
    set ORMI_PASSWORD=%3%
    shift
    shift
    goto shutdown
  )
)
:next
if "%ORMI_PORT%"=="" (
  echo.
  echo Error: You must specify the ORMI port using the -port switch.
  echo        The port value can be found in %J2EE_HOME%\config\rmi.xml.
  goto help
)
if "%ORMI_PASSWORD%"=="" (
  echo.
  echo Error: You must specify the ORMI password using the -password switch.
  goto help 
)

echo Shutdown OC4J instance...
set CMDARGS=%ORMI_URL%:%ORMI_PORT% %ORMI_USER% %ORMI_PASSWORD% -shutdown
goto admin 

rem
rem VERSION Command
rem 
:version
echo Getting the version of OC4J instance...
set CMDARGS=-version
goto oc4j 

rem
rem execute oc4j.jar command
rem
:oc4j
if /I "%VERBOSE%"=="on" (
  echo Executing: %JAVA_HOME%\bin\java %JVMARGS% -jar "%OC4J_JAR%" %CMDARGS%
  echo.
)
if not EXIST %OC4J_JAR% (
  echo Error: Can not find %OC4J_JAR%.
  goto end
)

%JAVA_HOME%\bin\java %JVMARGS% -jar %OC4J_JAR% %CMDARGS% 

goto end

rem
rem execute admin.jar command
rem
:admin
if /I "%VERBOSE%"=="on" (
  echo Executing: %JAVA_HOME%\bin\java -jar "%ADMIN_JAR%" %CMDARGS%
  echo.
)
if not EXIST %ADMIN_JAR% (
  echo Error: Can not find %ADMIN_JAR%.
  goto end
)

%JAVA_HOME%\bin\java -jar %ADMIN_JAR% %CMDARGS%
goto end

:end

echo Stop OC4J command finished.

@endlocal
