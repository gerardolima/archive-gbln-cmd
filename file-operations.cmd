
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

CHCP 65001 > NUL
:: ATTENTION: this file MUST enconded as "UTF-8 WITHOUT BOM"

:: Code sample to handle resourses that must be released.
:: run this test as $> file-operations.cmd

  CALL :COPY foo bar
  CALL :COPY *.q bar
  CALL :COPY file-operations.cmd .\bar\
  CALL :COPY file-operations.cmd \\bar
  CALL :COPY file-operations.cmd L:

  CALL :MOVE foo bar
  CALL :MOVE *.q bar
  CALL :MOVE file-operations.cmd .\bar\
  CALL :MOVE file-operations.cmd \\bar
  CALL :MOVE file-operations.cmd L:

  :CLEANUP
  :: no cleanup required
GOTO:EOF

:COPY <source> <target>
  :: ========================================================================================
  :: This routine copies <source> to <target> and provides a proper error message to error 
  :: stream on fauilure
  :: ========================================================================================
  IF NOT EXIST "%~f1"         ( ECHO Cannot find source "%~f1". & EXIT /B 1 )
  IF NOT EXIST "%~dp2"        ( ECHO Cannot find target "%~f2". & EXIT /B 2 )
  COPY "%~f1" "%~f2" 2>NUL || ( ECHO Cannot copy "%~f1" to "%~f2" & EXIT /B 3 )
  GOTO:EOF

:MOVE <source> <target>
  :: ========================================================================================
  :: This routine moves <source> to <target> and provides a proper error message to error 
  :: stream on fauilure
  :: ========================================================================================
  IF NOT EXIST "%~f1"         ( ECHO Cannot find source "%~f1". & EXIT /B 1 )
  IF NOT EXIST "%~dp2"        ( ECHO Cannot find target "%~f2". & EXIT /B 2 )
  MOVE "%~f1" "%~f2" 2>NUL || ( ECHO Cannot move "%~f1" to "%~f2" & EXIT /B 3 )
  GOTO:EOF
