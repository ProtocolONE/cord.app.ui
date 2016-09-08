@rem echo "%CmdCmdLine%"  >> qrc_build.log

set BUILD_PATH=.\..\!build
if _%1_ neq __ (
   @call :unquote BUILD_PATH %1
)

if exist "%BUILD_PATH%" (
    rmdir /S /Q "%BUILD_PATH%"
)

mkdir "%BUILD_PATH%"
for /f %%i in ("%0") do set CUR_PATH=%%~dpi

@rem Вероятно проблема с пробелами в пути, но нельзя поставить кавычки
set EXCLUDEFILE=%CUR_PATH%build_exclude.txt

xcopy "%CUR_PATH%*.*" "%BUILD_PATH%" /S /E /H /R /Y /EXCLUDE:%EXCLUDEFILE%

call "%BUILD_PATH%\GenerateQrc.cmd"
if %errorlevel% neq 0 goto rccFailed

@rem call "%BUILD_PATH%\build_fix_cc.cmd" %BUILD_PATH%  >> qrc_build.log
                                  
"%QTDIR%\bin\rcc.exe" -compress 3 -threshold 4 -binary  "%BUILD_PATH%\qGNA.qrc" -o "%BUILD_PATH%\qGNA.tmp"
if %errorlevel% neq 0 goto rccFailed

"%QTDIR%\bin\ert" e "%BUILD_PATH%\qGNA.tmp" "%BUILD_PATH%\qGNA.rcc"
del /F /Q "%BUILD_PATH%\qGNA.tmp"

set DST_PATH=.\

if _%2_ neq __ (
   @call :unquote DST_PATH %2
)

if not exist "%DST_PATH%" (
    mkdir "%DST_PATH%"
)

xcopy /I /Q /R /Y "%BUILD_PATH%\qGNA.rcc" "%DST_PATH%"
xcopy /I /Q /R /Y "%QGNAQMLDIR%\smiles.rcc" "%DST_PATH%"

rmdir /S /Q %BUILD_PATH%

goto end

:rccFailed
echo ============
echo RCC Failed: %ERRORLEVEL%
echo ============
exit /B 1


:unquote
@set %1=%~2
@goto :EOF


:end
exit /B 0