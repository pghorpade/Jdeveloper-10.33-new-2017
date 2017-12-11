@echo off
@setlocal

rem
rem oc4j.cmd - batch file for invoking OC4J basic operations.
rem 
rem Usage:  oc4j.cmd [Options]
rem
rem       Options:
rem        -start                : start OC4J
rem        -shutdown -port <ORMI port> -password <password>
rem                              : stop OC4J
rem        -version              : display the version
rem        -help                 : display this message
rem
rem Copyright (c) 2004, 2005, Oracle. All rights reserved.  
rem

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::: START CONFIGURATION SECTION ::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set J2EE_HOME=%ORACLE_HOME%\j2ee\home

rem Any persistent arguments to specify at the JVM level can be set here 
rem By default this will be read from the operating system environment
set JVMARGS=%OC4J_JVM_ARGS%

set CMDARGS=
set VERBOSE=%VERBOSE%

set ORMI_URL=ormi://localhost
set ORMI_USER=oc4jadmin

set OC4J_JAR=%J2EE_HOME%\oc4j.jar
set ADMIN_JAR=%J2EE_HOME%\admin.jar
set SERVER_XML=%J2EE_HOME%\config\server.xml

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::  END CONFIGURATION SECTION  ::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::

rem OC4J Command Shell Script
rem
rem Supports start, version commands

if "%JAVA_HOME%"=="" (
  echo Error: JAVA_HOME environment variable is not defined.
  echo        We cannot execute java.
  goto end
)

if NOT exist "%JAVA_HOME%\bin\java.exe" (
  echo Error: Can not find java executable in %JAVA_HOME%\bin. 
  echo        Please make sure the JAVA_HOME environment variable is defined correctly.
  goto end
)

if "%ORACLE_HOME%"=="" (
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
if not exist "%SERVER_XML%" (
  echo Error: Can not find %SERVER_XML%.
  goto end
) 
echo Starting OC4J from %J2EE_HOME% ...
set CMDARGS=-config "%SERVER_XML%"
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
if not EXIST "%OC4J_JAR%" (
  echo Error: Can not find %OC4J_JAR%.
  goto end
)
"%JAVA_HOME%\bin\java" %JVMARGS% -jar "%OC4J_JAR%" %CMDARGS% 
goto end

rem
rem execute admin.jar command
rem
:admin
if /I "%VERBOSE%"=="on" (
  echo Executing: %JAVA_HOME%\bin\java %JVMARGS% -jar "%ADMIN_JAR%" %CMDARGS%
  echo.
)
if not EXIST "%ADMIN_JAR%" (
  echo Error: Can not find %ADMIN_JAR%.
  goto end
)

"%JAVA_HOME%\bin\java" %JVMARGS% -jar "%ADMIN_JAR%" %CMDARGS%
goto end

:end
@endlocal
