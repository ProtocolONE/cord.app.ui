import QtQuick 2.4

import Application.Core 1.0
import Application.Core.Styles 1.0

Item {
    height: 10

    Row {
        width: 25
        height: 10

        anchors.centerIn: parent

        spacing: 5

        Rectangle {
            color: Styles.trayPopupTextHeader
            width: 5
            height: width
            radius: height / 2
        }

        Rectangle {
            color: Styles.trayPopupTextHeader
            width: 5
            height: width
            radius: height / 2
        }

        Rectangle {
            color: Styles.trayPopupTextHeader
            width: 5
            height: width
            radius: height / 2
        }
    }
}
