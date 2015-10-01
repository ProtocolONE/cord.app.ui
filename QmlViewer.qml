import QtQuick 2.4
import QtQuick.Window 2.2

// INFO It's exports install path
import Dev 1.0

import GameNet.Controls 1.0

import Application.Core 1.0
import Application.Core.RootWindow 1.0

Window {
    id: root

    width: main.width
    height: main.height
    color: "transparent"

    title: "GameNet" + App.fileVersion()
    flags: Qt.Window
           | Qt.FramelessWindowHint
           | Qt.WindowMinimizeButtonHint
           | Qt.WindowSystemMenuHint

    Component.onCompleted: {
        RootWindow.rootWindow = root;
    }

    onClosing: {
        Qt.quit();
    }

    Connections {
        target: App.mainWindowInstance()
        onHide: root.hide()
        onWindowActivated: root.show()
    }

    Main {
        id: main
    }
}
