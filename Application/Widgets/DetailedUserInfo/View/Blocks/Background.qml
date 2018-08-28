import QtQuick 2.4
import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0

Rectangle {
    anchors.fill: parent
    color: Styles.popupBlockBackground

    ContentThinBorder {}

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
    }
}

