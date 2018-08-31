import QtQuick 2.4
import ProtocolOne.Controls 1.0
import Application.Controls 1.0

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
        anchors.fill: parent
        border {
            color: '#e1c376'
            width: 2
        }

        color: '#00000000'

        opacity: delegate.hovered ? 1 : 0

        Behavior on opacity { NumberAnimation { duration: 125 } }
    }

    ContentThinBorder {
        visible: !delegate.hovered
    }
}
