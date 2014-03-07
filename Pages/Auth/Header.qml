import QtQuick 1.1

Item {
    implicitHeight: 62

    Image {
        anchors {
            left: parent.left
            leftMargin: 15
            verticalCenter: parent.verticalCenter
        }

        source: installPath + "images/Auth/GamenetLogo.png"
    }

    Rectangle {
        height: 1
        color: "#ECECEC"
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 1
        }
    }

    Rectangle {
        height: 1
        color: "#FFFFFF"
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}
