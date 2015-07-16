import QtQuick 2.4
import GameNet.Controls 1.0
import Application.Core.Styles 1.0

Item {
    id: rootButton

    signal clicked()

    property string shortname
    property string imageSource

    width: 30
    height: 30

    Rectangle {
        anchors.fill: parent
        color: "#00000000"
        border {
            width: 1
            color: Styles.checkedButtonActive
        }
        visible: mouseArea.containsMouse
    }

    Image {
        width: 20
        height: 20
        smooth: true
        cache: false
        asynchronous: false
        anchors.centerIn: parent
        smooth: true

        source: rootButton.imageSource ? rootButton.imageSource : ''
    }

    CursorMouseArea {
        id: mouseArea

        toolTip: rootButton.shortname
        cursor: Qt.ArrowCursor
        hoverEnabled: true
        anchors.fill: parent
        onClicked: rootButton.clicked();
    }
}
