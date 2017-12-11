@echo off

set JAVA_COMMAND=
set VM_OPTS=-XX:MaxPermSize=256m
set OC4J_OPTS=

if "%1" == "debug_ojvm" goto :debugOJVM
if "%1" == "debug_hotspot" goto :debugHOTSPOT
if "%1" == "install" set OC4J_OPTS=-install
if "%JAVA_HOME%" == "" goto :defaultJDK

:validateJDK
if exist "%JAVA_HOME%\bin\java.exe" goto :StartOC4J
@echo %JAVA_HOME%\bin\java.exe does not exist!
@echo Set the JAVA_HOME variable to define the root of a JDK.
goto :end

:startOC4J
title Oracle Containers for J2EE 10g
set JAVA_COMMAND="%JAVA_HOME%\bin\java.exe" %VM_OPTS% -jar oc4j.jar %OC4J_OPTS%
@echo Starting OC4J with command: %JAVA_COMMAND%
cd ..\..\j2ee\home
%JAVA_COMMAND%
cd ..\..\jdev\bin
title %ComSpec%
goto :end

:defaultJDK
set JAVA_HOME=..\..\jdk
goto :validateJDK 

:debugOJVM
set VM_OPTS=-ojvm -XXdebug,port4000,detached,quiet
goto :validateJDK 

:debugHOTSPOT
set VM_OPTS=-hotspot -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=4000
goto :validateJDK 

:end
