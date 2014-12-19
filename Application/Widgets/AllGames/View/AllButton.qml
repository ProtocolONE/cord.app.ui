import QtQuick 1.1
import GameNet.Controls 1.0

import "../../../Core/Styles.js" as Styles

Item {
    id: root

    property int iconRotation

    signal clicked()

    width: row.width + 30
    height: row.height + 8

    Rectangle {
        anchors {
            fill: parent
            margins: 2
        }
        color: Styles.style.messengerAllButtonGridHover //'#113344'
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
                       //'#f3d173' : '#ff6555'
            font.pixelSize: 17
        }

        Image {
            id: crossImage

            y: (parent.height / 2) - height / 2
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
