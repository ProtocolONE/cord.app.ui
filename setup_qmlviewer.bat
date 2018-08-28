@rem /////////////////////////////////////////

@rem @set QTDIR=D:\Qt\Qt5.11.1\5.11.1\msvc2015
@set QML_IMPORT_TRACE=0
@set QT_QML_DEBUG=0
@set QT_DEBUG_PLUGINS=0

@rem @set QGNACOMMONDIR=E:\Common\commonbundle2

@set QmlExtensionArea=trunk

@set plugindump=%QTDIR%\bin\qmlplugindump.exe

@xcopy /Y /I /R /E "%QGNACOMMONDIR%\GGS\QmlExtension\%QmlExtensionArea%\bin\QmlExtensionX86.dll" .\plugin\Tulip\

%plugindump% Tulip 1.0 ./plugin > ./plugin/Tulip/plugins.qmltypes
%plugindump% Dev 1.0 ./plugin > ./plugin/Dev/plugins.qmltypes

@echo Done.

