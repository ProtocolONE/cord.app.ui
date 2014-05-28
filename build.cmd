set BUILD_PATH=.\..\!build
if "%1" neq "" (
   set BUILD_PATH=%1
)

if exist %BUILD_PATH% (
    rmdir /S /Q %BUILD_PATH%
)
mkdir %BUILD_PATH%

for /f %%i in ("%0") do set CUR_PATH=%%~dpi

call %CUR_PATH%GenerateQrc.bat

xcopy %CUR_PATH%*.* %BUILD_PATH% /S /E /H /R /Y /EXCLUDE:%CUR_PATH%build_exclude.txt
            
call %CUR_PATH%build_fix_cc.cmd %BUILD_PATH%
                                  
%QTDIR%\bin\rcc.exe -compress 3 -threshold 4 -binary  "%BUILD_PATH%\qGNA.qrc" -o "%BUILD_PATH%\qGNA.tmp"
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

rmdir /S /Q %BUILD_PATH%
