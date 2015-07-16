echo %CmdCmdLine%  >> qrc_build.log

set BUILD_PATH=.\..\!build
if "%1" neq "" (
   set BUILD_PATH=%1
)

if exist %BUILD_PATH% (
    rmdir /S /Q %BUILD_PATH%
)
mkdir %BUILD_PATH% 

for /f %%i in ("%0") do set CUR_PATH=%%~dpi

xcopy %CUR_PATH%*.* %BUILD_PATH% /S /E /H /R /Y /EXCLUDE:%CUR_PATH%build_exclude.txt  >> qrc_build.log

call "%BUILD_PATH%\GenerateQrc.cmd"  >> qrc_build.log
@rem call "%BUILD_PATH%\build_fix_cc.cmd" %BUILD_PATH%  >> qrc_build.log
                                  
%QTDIR%\bin\rcc.exe -compress 3 -threshold 4 -binary  "%BUILD_PATH%\qGNA.qrc" -o "%BUILD_PATH%\qGNA.tmp"
if %errorlevel% neq 0 goto rccFailed

%QTDIR%\bin\ert e "%BUILD_PATH%\qGNA.tmp" "%BUILD_PATH%\qGNA.rcc"
del /F /Q "%BUILD_PATH%\qGNA.tmp"

set DST_PATH=.\

if "%2" neq "" (
    set DST_PATH=%2
)

if not exist %DST_PATH% (
    mkdir %DST_PATH%
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

:end

exit /B 0