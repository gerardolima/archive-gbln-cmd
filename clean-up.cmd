
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

CHCP 65001 > NUL
:: ATTENTION: this file MUST enconded as "UTF-8 WITHOUT BOM"

:: Code sample to handle resourses that must be released.
:: run this test as $> cmd /c clean-up.cmd 0
:: run this test as $> cmd /c clean-up.cmd 5
    
  SET /A "PARAM_TRIGGER=0%~1"
  SET /A "CONST_ALLWAYS=0"

  ECHO PARAM_TRIGGER: %PARAM_TRIGGER%
  ECHO CONST_ALLWAYS: %CONST_ALLWAYS%
  
  ECHO * STEP 1: ACQUIRE RESOURCE *
  ECHO * STEP 2: ERROR HAPPENS *
  CALL :ERROR %PARAM_TRIGGER% 97 "Conditional error message" & REM this error will happen when the parameter is not zero
  CALL :ERROR %CONST_ALLWAYS% 98 "Always error message"      & REM this error will always happen
  
  ECHO * STEP 3: NOT EXECUTED *

  :CLEANUP
  ECHO * STEP 4: ALWAYS RELSEASE RESOURCE *
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
  