@echo It's necessary for QmlExtensionX86.
@echo Copy SettingsX86.dll to qmlviewer directory
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\Settings\trunk\bin\SettingsX86.dll" "%QTDIR%\bin"
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\Core\trunk\bin\CoreX86.dll" "%QTDIR%\bin"
@echo Done.

@%QTDIR%\bin\qmlplugindump -path ./plugin > ./plugin/plugins.qmltypes