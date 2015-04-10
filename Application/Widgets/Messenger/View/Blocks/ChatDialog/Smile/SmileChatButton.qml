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
        id: hoverRect

        anchors.fill: parent
        color: Styles.style.messengerSmilePanelHover
        border.color: Styles.style.messengerSmileChatButtonHover
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
