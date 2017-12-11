@echo off

if "%OS%" == "Windows_NT" setlocal

if not exist %ORACLE_HOME%\j2ee\home\ojspc.jar goto error

java -Djava.compiler=NONE -Doracle.home=%ORACLE_HOME%  -jar %ORACLE_HOME%\j2ee\home\ojspc.jar -extend com.orionserver.http.OrionHttpJspPage %*
goto end

:error
@echo ERROR: %%ORACLE_HOME%%\j2ee\home\ojspc.jar not found.  Please set ORACLE_HOME to point to an OC4J or OracleAS instance and retry.

:end
if "%OS%" == "Windows_NT" endlocal

