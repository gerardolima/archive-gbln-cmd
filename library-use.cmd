
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

CHCP 65001 > NUL
:: ATTENTION: this file MUST enconded as "UTF-8 WITHOUT BOM"

:: Code sample to user a sub-routine library in CMD
:: run this test as $> cmd /c library-use.cmd

CALL library-serve.cmd :ADD 7 2
ECHO %ERRORLEVEL% 

CALL library-serve.cmd :HELLO SAY WORLD
ECHO %SAY%

CALL cmd /c library-serve.cmd :RAISEERROR
ECHO %ERRORLEVEL%

ECHO END OF TESTS
GOTO:EOF
