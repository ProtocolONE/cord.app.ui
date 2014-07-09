import QtQuick 1.1
import GameNet.Controls 1.0

Rectangle {
    id: delegate

    signal clicked();

    property bool hovered

    color: '#00000000'

    Rectangle {
        anchors {
            fill: parent
            margins: -5
        }
        color: '#ff6555'
        opacity: delegate.hovered ? 1 : 0

        Behavior on opacity { NumberAnimation { duration: 125 } }

        Rectangle {
            width: 14
            height: 14
            rotation: 45
            anchors {
                top: parent.top
                topMargin: -7
                horizontalCenter: parent.horizontalCenter
            }
            color: '#ff6555'
        }
    }

    WebImage {
        anchors.fill: parent
        source: preview

        CursorMouseArea {
            id: cursorMouseArea

            anchors.fill: parent
            onClicked: {
                listView.currentIndex = index;
                delegate.clicked();
            }
        }
    }
}
