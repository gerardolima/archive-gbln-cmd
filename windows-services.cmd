
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

CHCP 65001 > NUL
:: ATTENTION: this file MUST enconded as "UTF-8 WITHOUT BOM"

:: run this test as $> window-services.cmd

  CALL :STARTSERVICE localhost AdobeARMservice
  CALL :STOPSERVICE localhost AdobeARMservice

GOTO:EOF

:WAIT <seconds>
:: ========================================================================================
:: This routine waits <seconds> and then returns.
:: ========================================================================================

  :: This routine is a replacement for TIMEOUT command, as this cannot be run by background
  :: processes, like TFS agents; see also [http://ss64.com/nt/waitfor.html]

  IF "%1"==""   EXIT /B 1
  IF %1 LSS 1   EXIT /B 2

  SETLOCAL

  SET /A "SECONDS=%1 +1"
  PING -n %SECONDS% 127.0.0.1 > nul

  ENDLOCAL
  GOTO:EOF


:STOPSERVICE <server> <service>
:: ========================================================================================
:: This routine uses sc.exe to STOP the given windows <service> on the ginven <server>;
:: because this tool is assynchronous, it uses a loop to check the status of the service
:: a given number of times; returns 0 for success or 1 for fail
:: ========================================================================================

  SETLOCAL
  SET SERVER=%~1
  SET SERVICE=%~2
  SET WAIT=2
  SET TRY_MAX=5
  SET TRY_CUR=1

  :STOPSERVICE_BEGIN
    ECHO stopping the windows service '%SERVICE%' on server '%SERVER%' [try %TRY_CUR%]...
    sc.exe \\%SERVER% STOP "%SERVICE%" 1>NUL 2>NUL

    IF %ERRORLEVEL% EQU 1062  GOTO STOPSERVICE_SUCCESS    & REM service is stopped
    IF %ERRORLEVEL% EQU 0     GOTO STOPSERVICE_CONTINUE   & REM service accepted the request
    IF %ERRORLEVEL% EQU 1061  GOTO STOPSERVICE_CONTINUE   & REM service is between states
    
    :: otherwise handle as error: 5=access is denied; 172=server unavailable; 1060=service doesn't exist, ...
    NET HELPMSG %ERRORLEVEL%
    EXIT /B 1

    :STOPSERVICE_CONTINUE

    :: check for give-up condition
    IF %TRY_CUR% GTR %TRY_MAX%  (
      ECHO "the service did not stop after [%TRY_MAX%] seconds" >&2
      EXIT /B 2
    )

    :: wait, increment the counter and try again
    CALL :WAIT %WAIT%
    SET /A "TRY_CUR+=1"
    GOTO STOPSERVICE_BEGIN

  :STOPSERVICE_SUCCESS
  ENDLOCAL
  GOTO:EOF


:STARTSERVICE <server> <service>
:: ========================================================================================
:: This routine uses sc.exe to START the given windows <service> on the ginven <server>;
:: because this tool is assynchronous, it uses a loop to check the status of the service
:: a given number of times, until success or error

  SETLOCAL
  SET SERVER=%~1
  SET SERVICE=%~2
  SET WAIT=2
  SET TRY_MAX=5
  SET TRY_CUR=1

  :STARTSERVICE_BEGIN
    ECHO starting the windows service '%SERVICE%' on server '%SERVER%' [try %TRY_CUR%]...
    sc.exe \\%SERVER% START "%SERVICE%" 1>NUL 2>NUL

    IF %ERRORLEVEL% EQU 1056  GOTO STARTSERVICE_SUCCESS    & REM service is running
    IF %ERRORLEVEL% EQU 0     GOTO STARTSERVICE_CONTINUE   & REM service accepted the request
    IF %ERRORLEVEL% EQU 1061  GOTO STARTSERVICE_CONTINUE   & REM service is between states
    
    :: otherwise handle as error: 5=access is denied; 172=server unavailable; 1060=service doesn't exist, ...
    NET HELPMSG %ERRORLEVEL%
    EXIT /B 1

    :STARTSERVICE_CONTINUE

    :: check for give-up condition
    IF %TRY_CUR% GTR %TRY_MAX%  (
      ECHO "the service did not start after [%TRY_MAX%] seconds" >&2
      EXIT /B 2
    )

    :: wait, increment the counter and try again
    CALL :WAIT %WAIT%
    SET /A "TRY_CUR+=1"
    GOTO STARTSERVICE_BEGIN

  :STARTSERVICE_SUCCESS
  ENDLOCAL
  GOTO:EOF
