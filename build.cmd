set BUILD_PATH=.\..\!build
if "%1" neq "" (
   set BUILD_PATH=%1 
)

if exist %BUILD_PATH% (
    rmdir /S /Q %BUILD_PATH%
)
mkdir %BUILD_PATH%

START /wait GenerateQrc.bat

xcopy *.* %BUILD_PATH% /S /E /H /EXCLUDE:build_exclude.txt
            
START /wait build_fix_cc.cmd %BUILD_PATH%
                                  
%QTDIR%\bin\rcc.exe -compress 3 -threshold 4 -binary  "%BUILD_PATH%\qGNA.qrc" -o "%BUILD_PATH%\qGNA.tmp"
%QTDIR%\bin\ert e "%BUILD_PATH%\qGNA.tmp" "%BUILD_PATH%\qGNA.rcc"
del /F /Q "%BUILD_PATH%\qGNA.tmp"

set DST_PATH=.\

if "%2" neq "" (
    set DST_PATH=%2   
)

xcopy /I /Q "%BUILD_PATH%\qGNA.rcc" "%DST_PATH%"

rmdir /S /Q %BUILD_PATH%
