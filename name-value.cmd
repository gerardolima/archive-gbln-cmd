
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

CHCP 65001 > NUL
:: ATTENTION: this file MUST enconded as "UTF-8 WITHOUT BOM"

:: this script is based on [http://www.dostips.com/DtTipsStringManipulation.php#Snippets.MapLookup]


CALL :LOOKUP VALUE "Jun" "Jan-01;Feb-02;Mar-03;Apr-04;Mai-05;Jun-06;Jul-07;Aug-08;Sep-09;Oct-10;Nov-11;Dec-12"
ECHO %VALUE%

CALL :LOOKUP VALUE "fri" "mon-Monday;tue-Tuesday;wed-Wednesday;thu-Thursday;fri-Friday;sat-Saturday;sun-Sunday"
ECHO %VALUE%


GOTO:EOF


:LOOKUP <out.value> <in.key> <in.collection>
  :: ========================================================================================
  :: This routine returns the value corresponing to a key on a name-value collection, mapped
  :: as a string (i.e see samples)
  :: ========================================================================================
  SETLOCAL

    SET key=%~2
    SET map=%~3
    SET val=.

    :: CALL SET val=%%map:*%key%-=%%
    CALL SET val=%%map:*%key%-=%%
    SET val=%val:;=&rem.%

  ENDLOCAL & SET %1=%val%

  GOTO:EOF
