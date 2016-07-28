
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

CHCP 65001 > NUL
:: ATTENTION: this file MUST enconded as "UTF-8 WITHOUT BOM"

:: ========================================================================================
:: This script shows how to return data from variables SET in local scope block
:: ========================================================================================

SET AA=a
SET BB=b

:: ==================================================================
:: block 1: top-level
:: - do not declare CC yet
:: ==================================================================
SET AA=%AA%/1
SET BB=%BB%/1

ECHO "TOP" %AA%, %BB%, %CC%

:: ==================================================================
:: block 2: local scope naive 
:: - all changes are abandoned after ENDLOCAL
:: ==================================================================
SETLOCAL
  SET CC=c

  SET AA=%AA%/2
  SET BB=%BB%/2
  SET CC=%CC%/2
  ECHO "B.2" %AA%, %BB%, %CC%
ENDLOCAL

ECHO "TOP" %AA%, %BB%, %CC%

:: ==================================================================
:: block 3: local scope handling ENDLOCAL
:: ==================================================================
SETLOCAL
  SET CC=c

  SET AA=%AA%/3
  SET BB=%BB%/3
  SET CC=%CC%/3
  ECHO "B.3" %AA%, %BB%, %CC%
ENDLOCAL & SET AA=%AA% & SET CC=%CC%

ECHO "TOP" %AA%, %BB%, %CC%

GOTO:EOF
