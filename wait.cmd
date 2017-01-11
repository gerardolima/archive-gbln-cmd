
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

CHCP 65001 > NUL
:: ATTENTION: this file MUST enconded as "UTF-8 WITHOUT BOM"

:: run this test as $> wait.cmd
:: run this test as $> wait.cmd 2

  IF "%1"=="" ( SET /A "PARAM_WAIT=0" ) ELSE ( SET /A "PARAM_WAIT=%~1" )
 
  ECHO * WILL WAIT FOR %PARAM_WAIT% SECONDS *
  CALL :WAIT %PARAM_WAIT%
  ECHO * WAIT IS COMPLETE *

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
