# Cord.App.UI
![License](https://img.shields.io/hexpm/l/plug.svg)

## Description
This project is UI for [Cord.App](https://github.com/ProtocolONE/cord.app). 

## Prerequisites
 * [Qt](http://download.qt.io/official_releases/qt/) ( >=5.5.1)
 * [Qt Creator](http://download.qt.io/official_releases/qtcreator/) (>=4.2.2)
 * [conan.io](https://conan.io/downloads.html) (>= 1.7.2)  

## Getting started

Install [conan.io](https://conan.io/downloads.html)

Download Qt from [official site](http://download.qt.io/official_releases/qt/) or use prebuild version from conan:
```sh
conan install Qt/5.5.1@common/stable -pr conan/msvcprofile
```

Define environment variable `QTDIR` to qt install root folder.

Download dependencies by conan:
```sh
conan install ./conanfile.py -pr ./conan/msvcprofile
```

Open `Launcher.qmlproject` in QtCreator. Add run configuration for `Qml Scene` to open main qml file: `QmlViewer.qml`.
In commandline arguments for qmlscene add few arguments:
 * `-translation "<sourceRoot>/i18n/qml_en.qm"` - it's full path for translation.
 * `-I "<sourceRoot>"` - include path that used for plugins search
 * `-I "/var installPath=<sourceRoot>"` - it's a trick arguments used by `plugin\Dev`. This plugin add context property
   by next format `-I "/var <ProperyName>=<ProperyValue>"`. Property `installPath` used in qml to define full path of assets. 

Full command line example:
```sh
-I "/var installPath=C:/github/cord.app.ui" -translation "C:/github/cord.app.ui/i18n/qml_en.qm" -I "C:/github/cord.app.ui"
```

Now you can run UI in qml scene. (Ctrl+R by default in QtCreator)

## Config
You can specify custom auth and api server and configure some other features in `Config.yaml`. 
Check `Launcher Configuration` in [manual](https://github.com/ProtocolONE/cord.app/wiki)

## Translation
Translation can be updated by `i18n.bat` script. Also you can add more languages and translate it by  
[Qt Linguist](http://doc.qt.io/qt-5/qtlinguist-index.html)

