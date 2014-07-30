import QtQuick 1.1

import "../../Core/Styles.js"  as Styles


Rectangle {
    implicitHeight: 62
    color: Styles.style.authHeaderBackground

    Image {
        anchors {
            left: parent.left
            leftMargin: 15
            verticalCenter: parent.verticalCenter
        }

        source: installPath + "Assets/Images/Auth/GamenetLogo.png"
    }

    Rectangle {
        height: 1
        color: Qt.darker(Styles.style.authHeaderBackground, Styles.style.darkerFactor)
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 1
        }
    }

    Rectangle {
        height: 1
        color: Qt.lighter(Styles.style.authHeaderBackground, Styles.style.lighterFactor)
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}
