set BUILD_PATH=.\..\!build
if "%1" neq "" (
   set BUILD_PATH=%1 
)

if exist %BUILD_PATH% (
    rmdir /S /Q %BUILD_PATH%
)
mkdir %BUILD_PATH%

xcopy *.* %BUILD_PATH% /S /E /H /EXCLUDE:build_exclude.txt

START /wait build_fix_cc.cmd %BUILD_PATH%
START /wait %BUILD_PATH%\GenerateQrc.bat
                                  
%QTDIR%\bin\rcc.exe -compress 3 -threshold 4 -binary  "%BUILD_PATH%\qGNA.qrc" -o "%BUILD_PATH%\_qGNA.qrc"
%QTDIR%\bin\ert e "%BUILD_PATH%\_qGNA.qrc" "%BUILD_PATH%\qGNA.qrc"
del /F /Q "%BUILD_PATH%\_qGNA.qrc"

