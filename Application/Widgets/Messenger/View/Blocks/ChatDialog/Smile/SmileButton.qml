import QtQuick 1.1

import GameNet.Controls 1.0

import Tulip 1.0

Item {
    id: root

    signal clicked();

    width: image.width
    height: image.height

    Image {
        id: image

        source: installPath + 'Assets/Images/Application/Widgets/Messenger/smileButtonHover.png'
        visible: mouseArea.containsMouse
    }

    Image {
        anchors.centerIn: parent

        source: installPath + 'Assets/Images/Application/Widgets/Messenger/smileButton.png'
    }

    CursorMouseArea {
        id: mouseArea

        anchors.fill: parent
        cursor: CursorArea.PointingHandCursor
        onClicked: root.clicked();
    }
}
