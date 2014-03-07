@rem /////////////////////////////////////////
@rem 
@set QTDIR=E:\Qt\4.8.5_src

@set CoreArea=trunk
@set SettingsArea=trunk
@set QxmppArea=0.7.6_qt4.8.5
@set OverlayArea=trunk
@set QmlExtensionArea=trunk

@echo It's necessary for QmlExtensionX86.
@echo Copy SettingsX86.dll to qmlviewer directory
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\Settings\%SettingsArea%\bin\SettingsX86.dll" "%QTDIR%\bin"
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\Core\%CoreArea%\bin\CoreX86.dll" "%QTDIR%\bin"
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\Qxmpp\%QxmppArea%\bin\qxmppx860.dll" "%QTDIR%\bin"

@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\Overlay\%OverlayArea%\bin\QmlOverlayX86.dll" .\plugin\
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\QmlExtension\%QmlExtensionArea%\bin\QmlExtensionX86.dll" .\plugin\

@rem New plugins model:
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\Settings\%SettingsArea%\bin\SettingsX86.dll" .\plugin\Tulip\
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\Core\%CoreArea%\bin\CoreX86.dll" .\plugin\Tulip\
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\Qxmpp\%QxmppArea%\bin\qxmppx860.dll" .\plugin\Tulip\

@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\Overlay\%OverlayArea%\bin\QmlOverlayX86.dll" .\plugin\Tulip\
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\QmlExtension\%QmlExtensionArea%\bin\QmlExtensionX86.dll" .\plugin\Tulip\


@echo Done.

