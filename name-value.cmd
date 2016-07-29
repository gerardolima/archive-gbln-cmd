
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

CHCP 65001 > NUL
:: ATTENTION: this file MUST enconded as "UTF-8 WITHOUT BOM"

:: this script is based on [http://www.dostips.com/DtTipsStringManipulation.php#Snippets.MapLookup]


CALL :LOOKUP VALUE "1" "1-AAA;2-BBB;3-CCC;4-DDD;5-EEE;6-FFF;7-GGG;8-HHH;9-III;10-JJJ"
ECHO VALUE="%VALUE%"

CALL :LOOKUP VALUE "x" "1-AAA;2-BBB;3-CCC;4-DDD;5-EEE;6-FFF;7-GGG;8-HHH;9-III;10-JJJ"
ECHO VALUE="%VALUE%"

CALL :LOOKUP VALUE "Jun" "Jan-01;Feb-02;Mar-03;Apr-04;Mai-05;Jun-06;Jul-07;Aug-08;Sep-09;Oct-10;Nov-11;Dec-12"
ECHO VALUE="%VALUE%"

CALL :LOOKUP VALUE "fri" "mon-Monday;tue-Tuesday;wed-Wednesday;thu-Thursday;fri-Friday;sat-Saturday;sun-Sunday"
ECHO VALUE="%VALUE%"

GOTO:EOF


:LOOKUP <out.value> <in.key> <in.map>
  :: ========================================================================================
  :: This routine returns the value corresponing to a key on a name-value collection, mapped
  :: as a string (i.e see samples)
  :: ========================================================================================
  SETLOCAL
    SET local.value=
    SET in.key=%~2
    SET in.map=;%~3
    CALL SET local.value=%%in.map:*%in.key%-=%%
    SET local.value=%local.value:;=&REM %
  ENDLOCAL & SET %1=%local.value%

  GOTO:EOF
