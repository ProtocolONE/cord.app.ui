import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0

import "../../../../../../Core/Styles.js" as Styles

Item {
    id: rootButton

    signal clicked()

    property string shortname
    property string imageSource

    width: 30
    height: 30

    Rectangle {
        anchors {
            fill: parent
            rightMargin: 1
            bottomMargin: 1
        }

        color: "#00000000"
        border {
            width: 1
            color: Styles.style.checkedButtonActive
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
        cursor: CursorArea.ArrowCursor
        hoverEnabled: true
        anchors.fill: parent
        onClicked: rootButton.clicked();
    }
}
