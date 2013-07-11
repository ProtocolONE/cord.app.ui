@rem /////////////////////////////////////////
@rem @set QTDIR=E:\Qt\4.8.5_2

@echo It's necessary for QmlExtensionX86.
@echo Copy SettingsX86.dll to qmlviewer directory
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\Settings\trunk\bin\SettingsX86.dll" "%QTDIR%\bin"
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\Core\trunk\bin\CoreX86.dll" "%QTDIR%\bin"
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\Overlay\trunk\bin\QmlOverlayX86.dll" .\plugin\
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\QmlExtension\trunk\bin\QmlExtensionX86.dll" .\plugin\
@echo Done.

%QTDIR%\bin\qmlplugindump -path ./plugin > ./plugin/plugins.qmltypes
%QTDIR%\bin\qmlplugindump -path ./plugin/Tulip > ./plugin/Tulip/plugins.qmltypes