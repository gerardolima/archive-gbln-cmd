
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

CHCP 65001
:: ATTENTION: this file MUST enconded as "UTF-8 WITHOUT BOM"

:: Code sample to handle resourses that must be released.
:: run this test as $> cmd /c try.cmd

SETLOCAL
    
  ECHO * STEP 1: ACQUIRE RESOURCE *
  ECHO * STEP 2: ERROR HAPPENS *
  CALL :ERROR 98 "An error message"

  
  ECHO * STEP 3: NOT EXECUTED *

  :CLEANUP
  ECHO * STEP 4: ALWAYS RELSEASE RESOURCE *
GOTO:EOF


:ERROR err.number err.message
  :: this routine is resposible to call :CLEANUP before exit
  CALL :CLEANUP

  ECHO ERROR: %~2 [%1]
  EXIT %1
