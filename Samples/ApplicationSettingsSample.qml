import QtQuick 1.1
import Tulip 1.0

import "../Pages" as Pages
import "../Blocks2" as Blocks2

Rectangle {
    id: sampleRoot

    color: "black"
    width: 1000
    height: 600

    //  HACK: эмулируем сигнал для того чтобы ловить клик вне выпадающего списка
    //  в отладке из QtCreator
    MouseArea {
        id: mainWindow

        signal leftMouseClick(int x, int y);

        hoverEnabled: true
        anchors.fill: parent
        onClicked: mainWindow.leftMouseClick(mouse.x, mouse.y);
    }

    Pages.ApplicationSettings {
        id: gameSettings

        width: parent.width
        height: 558
        anchors {
            bottom: parent.bottom
        }
        onAccepted: {
            console.log("Application settings accepted!");
        }
    }
}
