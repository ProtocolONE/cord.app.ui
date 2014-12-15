import QtQuick 1.1
import Tulip 1.0

import Application.Blocks 1.0

Rectangle {
    id: sampleRoot

    color: "black"
    width: 1000
    height: 600

    //  HACK: эмулируем сигнал для того чтобы ловить клик вне выпадающего списка
    //  в отладке из QtCreator
//    MouseArea {
//        id: mainWindow

//        signal leftMouseRelease(int x, int y);

//        hoverEnabled: true
//        anchors.fill: parent
//        onClicked: mainWindow.leftMouseRelease(mouse.x, mouse.y);
//    }

    ApplicationSettings {
        id: gameSettings

        width: parent.width
        height: 558
        anchors {
            bottom: parent.bottom
        }
    }
}
