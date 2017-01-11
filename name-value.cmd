
@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

CHCP 65001 > NUL
:: ATTENTION: this file MUST enconded as "UTF-8 WITHOUT BOM"

:: run this test as $> name-value.cmd

CALL :LOOKUP VALUE "4" "1-AAA;2-BBB;3-CCC;4-DDD;5-EEE;6-FFF;7-GGG;8-HHH;9-III;10-JJJ"
ECHO VALUE="%VALUE%"

CALL :LOOKUP VALUE "x" "1-AAA;2-BBB;3-CCC;4-DDD;5-EEE;6-FFF;7-GGG;8-HHH;9-III;10-JJJ"
ECHO VALUE="%VALUE%"

CALL :LOOKUP VALUE "Jun" "Jan-01;Feb-02;Mar-03;Apr-04;Mai-05;Jun-06;Jul-07;Aug-08;Sep-09;Oct-10;Nov-11;Dec-12"
ECHO VALUE="%VALUE%"

CALL :LOOKUP VALUE "fri" "mon-Monday;tue-Tuesday;wed-Wednesday;thu-Thursday;fri-Friday;sat-Saturday;sun-Sunday"
ECHO VALUE="%VALUE%"

GOTO:EOF


:LOOKUP <out.value> <in.key> <in.map>
  :: this is just a forward for switching the implementation
  GOTO :LOOKUP_FOR
GOTO:EOF

  
:LOOKUP_FOR <out.value> <in.key> <in.map>
:: ========================================================================================
:: This routine returns the value corresponing to a key on a name-value collection, mapped
:: as a string in the following pattern "name1-value1;name2-value2;name3-value3;" ...
:: ========================================================================================
  SETLOCAL

  :: this routine replaces each ";" separator for a line-break, then uses 'FOR /F' operator
  :: to iterate over the options and, again, to parse each name-value pairs; if the key is
  :: found, this routine returns its value; otherwise, returns empty.

  :: [http://ss64.com/nt/for_f.html]
  :: [http://ss64.com/nt/syntax-replace.html]

  REM IMPORTANT!!! there should be two empty lines after the following line
  SET CRLF=^


  SET "text=%~3"
  SET "text=%text:;=!CRLF!%"
  SET "value="
 
  FOR /F "usebackq tokens=* delims=;" %%G IN ('!text!') DO ( REM ECHO line is %%G
    FOR /F "usebackq tokens=1,2 delims=-" %%H IN ('%%G') DO ( REM ECHO pair is {%%H: %%I}
        IF "%%H"=="%~2" ( SET "value=%%I" & GOTO :EOF_LOOKUP_FOR )
    )
  )

  :EOF_LOOKUP_FOR

  ENDLOCAL & SET %1=%value%
  GOTO:EOF


:LOOKUP_STR <out.value> <in.key> <in.map>
:: ========================================================================================
:: This routine returns the value corresponing to a key on a name-value collection, mapped
:: as a string in the following pattern "name1-value1;name2-value2;name3-value3;" ...
:: ========================================================================================

  :: this routine works on string substitution and the 'macro' behavior of statements in
  :: cmd scripts; i try to explain how to get the value from "2" in "1-AA;2-BB;3-CC;"
  :: 1.remove text until the given key
  ::   SET value = remove("%1-AA;2-BB;3-CC;", "*;2-") => "BB;3-CC;"
  :: 2.replace the separator by "& REM" breaking the SET command evaluation
  ::   SET value=BB & REM 3-CC & REM => "BB"

  :: [http://www.dostips.com/DtTipsStringManipulation.php#Snippets.MapLookup]
  :: [http://scripts.dragon-it.co.uk/scripts.nsf/docs/batch-search-replace-substitute]
  :: [http://ss64.com/nt/syntax-replace.html]
  SETLOCAL

  SET key=%~2
  SET value=;%~3;
  SET value=!value:*;%key%-=!
  SET value=%value:;=&REM %

  ENDLOCAL & SET %1=%value%
  GOTO:EOF
