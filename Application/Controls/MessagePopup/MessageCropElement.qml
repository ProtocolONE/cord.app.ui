import QtQuick 1.1

import "../../Core/Styles.js" as Styles

Item {
    height: 10

    Row {
        width: 25
        height: 10

        anchors.centerIn: parent

        spacing: 5

        Rectangle {
            color: Styles.style.trayPopupTextHeader
            width: 5
            height: width
            radius: height / 2
        }

        Rectangle {
            color: Styles.style.trayPopupTextHeader
            width: 5
            height: width
            radius: height / 2
        }

        Rectangle {
            color: Styles.style.trayPopupTextHeader
            width: 5
            height: width
            radius: height / 2
        }
    }
}
