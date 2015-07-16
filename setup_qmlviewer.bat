@rem /////////////////////////////////////////

@rem @set QTDIR=D:\Qt\550bd
@rem @set QML_IMPORT_TRACE=0

@set CoreArea=trunk
@set SettingsArea=trunk
@set GameNetQxmppArea=0.8.5
@set OverlayArea=trunk
@set QmlExtensionArea=trunk
@set QxmppDeclarativeArea=1.1.4

@rem @set plugindump=%QTDIR%\bin\qml1plugindump
@set plugindump=%QTDIR%\bin\qmlplugindump.exe

@echo It's necessary for QmlExtensionX86.
@echo Copy SettingsX86.dll to qmlviewer directory
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\Settings\%SettingsArea%\bin\SettingsX86.dll" "%QTDIR%\bin"
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\Core\%CoreArea%\bin\CoreX86.dll" "%QTDIR%\bin"
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GameNet\qxmpp\%GameNetQxmppArea%\bin\qxmpp0.dll" "%QTDIR%\bin"

@rem New plugins model:
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\Settings\%SettingsArea%\bin\SettingsX86.dll" .\plugin\Tulip\
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\Core\%CoreArea%\bin\CoreX86.dll" .\plugin\Tulip\

@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\Overlay\%OverlayArea%\bin\QmlOverlayX86.dll" .\plugin\Tulip\
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\QmlExtension\%QmlExtensionArea%\bin\QmlExtensionX86.dll" .\plugin\Tulip\

@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GameNet\qxmpp\%GameNetQxmppArea%\bin\qxmpp0.dll" .\plugin\QXmpp\
@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GameNet\qxmpp-declarative\%QxmppDeclarativeArea%\bin\qxmpp-declarative.dll" .\plugin\QXmpp\

@rem %plugindump% -path ./plugin/QmlViewerDevHelper > ./plugin/QmlViewerDevHelper/plugins.qmltypes

%plugindump% Tulip 1.0 ./plugin > ./plugin/Tulip/plugins.qmltypes
%plugindump% Dev 1.0 ./plugin > ./plugin/Dev/plugins.qmltypes
%plugindump% QXmpp 1.0 ./plugin > ./plugin/QXmpp/plugins.qmltypes

@rem %plugindump% -path ./plugin/Tulip > ./plugin/Tulip/plugins.qmltypes
@rem %plugindump% -path ./plugin/QXmpp > ./plugin/QXmpp/plugins.qmltypes
@echo Done.

