import QtQuick 1.1
import GameNet.Controls 1.0

Item {
    id: delegate

    signal clicked();

    property bool hovered

    WebImage {
        anchors.fill: parent
        source: preview

        smooth: true
        asynchronous: true
        cache: false

        CursorMouseArea {
            id: cursorMouseArea

            anchors.fill: parent
            onClicked: {
                listView.currentIndex = index;
                delegate.clicked();
            }
        }
    }

    Rectangle {
        anchors {
            fill: parent
            margins: 1
        }
        border {
            color: '#e1c376'
            width: 2
        }

        color: '#00000000'

        opacity: delegate.hovered ? 1 : 0

        Behavior on opacity { NumberAnimation { duration: 125 } }
    }

    Rectangle {
        anchors {
            fill: parent
            bottomMargin: 1
            rightMargin: 1
        }
        color: '#00000000'
        border.color: '#ffffff'
        opacity: 0.15
        visible: !delegate.hovered
    }
}
