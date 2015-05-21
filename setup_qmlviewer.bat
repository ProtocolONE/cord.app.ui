@rem /////////////////////////////////////////

@rem @set QTDIR=E:\Qt\Qt5.2.1\5.2.1\msvc2010

@set CoreArea=trunk
@set SettingsArea=trunk
@set GameNetQxmppArea=0.8.4
@set OverlayArea=trunk
@set QmlExtensionArea=trunk
@set QxmppDeclarativeArea=1.1.3

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

%QTDIR%\bin\qml1plugindump -path ./plugin/Tulip > ./plugin/Tulip/plugins.qmltypes
%QTDIR%\bin\qml1plugindump -path ./plugin/QXmpp > ./plugin/QXmpp/plugins.qmltypes
@echo Done.

