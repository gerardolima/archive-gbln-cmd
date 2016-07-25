
@ECHO OFF


CHCP 65001 > NUL
:: ATTENTION: this file MUST enconded as "UTF-8 WITHOUT BOM"

:: Code sample to implement a sub-routine library in CMD
:: run this test as $> cmd /c library-serve.cmd :sub-routine arg1 arg2 arg3 ...

:: the following line just forwards the call to its label
CALL %*

GOTO:EOF

:ADD <numberA> <numberB>
  SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

  :: this routine returns on ERRORLEVEL
  :: example
  ::   CALL :ADD 7 2
  ::   ECHO %ERRORLEVEL%

  SET /a "RESULT = %1 + %2"
  EXIT /b %RESULT%

:HELLO <result> <name>
  :: this routine returns on the variable referenced by %result%
  :: SETLOCAL can NOT be set, otherwise the reference to %result% is lost
  :: example
  ::   CALL :HELLO SAY WORLD
  ::   ECHO %SAY%

  SET %1=HELLO %2
  GOTO:EOF
 