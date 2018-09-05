@rem Для использования необходимо положить батник в корень проекта.
@rem Имя файла с результатом должно быть написано тут:

Set TargetQrcName=Launcher.qrc
set CUR_PATH=%~dp0

SET WinDirNet=%WinDir%\Microsoft.NET\Framework
IF EXIST "%WinDirNet%\v3.5\csc.exe" (
    SET msbuild="%WinDirNet%\v3.5\msbuild.exe"
    SET csc="%WinDirNet%\v3.5\csc.exe"
)
IF EXIST "%WinDirNet%\v4.0.30319\csc.exe" (
    SET msbuild="%WinDirNet%\v4.0.30319\msbuild.exe"
    SET csc="%WinDirNet%\v4.0.30319\csc.exe"
)

IF EXIST "%ProgramFiles(x86)%\MSBuild\12.0\Bin\MSBuild.exe" (
    SET msbuild="%ProgramFiles(x86)%\MSBuild\12.0\Bin\MSBuild.exe"
    SET csc="%ProgramFiles(x86)%\MSBuild\12.0\Bin\csc.exe"
)

ECHO.
ECHO     Using msbuild = %msbuild%
ECHO     Using csc = %csc%
ECHO.

%csc% /nologo /out:"%CUR_PATH%GenerateQrc.cs.exe" "%CUR_PATH%GenerateQrc.cs"
if not exist "%CUR_PATH%GenerateQrc.cs.exe" exit /b 1

"%CUR_PATH%GenerateQrc.cs.exe" %TargetQrcName%
del "%CUR_PATH%GenerateQrc.cs.exe"

exit /b 0