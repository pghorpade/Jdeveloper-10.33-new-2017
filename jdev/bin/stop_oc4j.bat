@echo off
set ADMINURL=ormi://localhost:23791
if "%1"=="" goto :usage
if "%2"=="" goto :usage
if "%JAVA_HOME%" == "" goto :defaultJDK

:validateJDK
if exist "%JAVA_HOME%\bin\java.exe" goto :stopOC4J
@echo %JAVA_HOME%\bin\java.exe does not exist!
@echo Set the JAVA_HOME variable to define the root of a JDK.
goto :end

:stopOC4J
cd ..\..\j2ee\home
set JAVA_COMMAND="%JAVA_HOME%\bin\java.exe" %OPTS% -jar admin.jar %ADMINURL% %1 %2 -shutdown
@echo Stopping OC4J with command: %JAVA_COMMAND%
%JAVA_COMMAND%
cd ..\..\jdev\bin
goto :end

:defaultJDK
set JAVA_HOME=..\..\jdk
goto :validateJDK

:usage
   echo.
   echo -----------------------------------------------------------------------
   echo  Usage:  
   echo        %0 {ADMIN_USER} {ADMIN_PASSWORD}
   echo.
   echo       {ADMIN_USER}      Username to use as the "admin"
   echo       {ADMIN_PASSWORD}  Password for the "admin" user
   echo.            
   echo  Example:
   echo        %0 admin welcome
   echo.            
   echo -----------------------------------------------------------------------

@echo %0 {admin user} {admin password}
:end
