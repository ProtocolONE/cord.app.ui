import QtQuick 1.1
import GameNet.Controls 1.0

import "../../../../Core/Styles.js" as Styles

Item {
    id: root

    property int iconRotation

    signal clicked()

    width: row.width + 30
    height: row.height + 10

    Rectangle {
        anchors {
            fill: parent
            margins: 2
        }
        color: Styles.style.messengerAllButtonGridHover
        visible: mouseArea.containsMouse
    }

    Row {
        id: row

        anchors {
            centerIn: parent
        }

        spacing: 8

        Text {
            text: qsTr("ALL_GAMES_GRID_TITLE_TEXT")
            color: mouseArea.containsMouse ? Styles.style.messengerAllButtonGridTextHover :
                                             Styles.style.messengerAllButtonGridTextNormal
            font.pixelSize: 17
        }

        Image {
            id: crossImage

            anchors.verticalCenter: parent.verticalCenter
            source: installPath + 'Assets/Images/Application/Widgets/AllGames/crossButton.png'
            transform: Rotation {
                origin {
                  x: crossImage.width / 2
                  y: crossImage.height / 2
                }

                axis { x: 1; y: 0; z: 0 }

                angle: root.iconRotation
            }
        }
    }

    CursorMouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked();
    }
}
