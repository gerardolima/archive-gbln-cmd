
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

CHCP 65001 > NUL
:: ATTENTION: this file MUST enconded as "UTF-8 WITHOUT BOM"

:: Code sample to handle resourses that must be released.
:: run this test as $> cmd /c run-except.cmd pattern             >> echoes all files in current dir that dont contain 'pattern' in its name 
:: run this test as $> cmd /c run-except.cmd [ab] ECHO .         >> echoes all files in current dir that dont contain 'a' or 'b' in its name 
:: run this test as $> cmd /c run-except.cmd keep "DEL /S" *.tmp >> deletes recursively all .tmp files, except those with 'keep' on the name

  CALL :RUN_EXCEPT %1 %2 %3

  :CLEANUP
  REM no cleanup required
GOTO:EOF



:RUN_EXCEPT <pattern> <command> <directory>
  :: ========================================================================================
  :: This routine runs the <command> on all files into the <directory> that do NOT macth
  :: the <pattern> on FINDSTR. Default values follow
  ::   <pattern>   : mandatory
  ::   <command>   : "ECHO"
  ::   <directory> : "."
  :: ========================================================================================
  SETLOCAL

  SET PAT=%~1
  SET CMD=%~2
  SET DIR=%~3

  IF "%PAT%"==""   CALL :ERROR 0 1 "Missing parameter [1:pattern]"
  IF "%CMD%"==""   SET CMD=ECHO
  IF "%DIR%"==""   SET DIR=.
  
  FOR /f "tokens=1" %%N IN ('DIR /b "%DIR%" ^| FINDSTR /I /V "%PAT%"') DO (
    %CMD% %%N
  )
  GOTO:EOF


:ERROR <err.trigger> <err.number> <err.message>
  :: ========================================================================================
  :: This routine is a helper to handle error conditions; if %ERRORLEVEL% is equal or greater
  :: than <err.trigger>, it calls the :CLEANUP label, writes the given <err.message> to error
  :: stream (stderr) and abort the script with the given <err.number>.
  :: ========================================================================================
  IF %ERRORLEVEL% LSS %1 (IF %ERRORLEVEL% GTR 0 (GOTO:EOF))

  CALL :CLEANUP
  ECHO ERROR: %~3 [%2] [ERRORLEVEL=%ERRORLEVEL%] >&2
  EXIT %2
  