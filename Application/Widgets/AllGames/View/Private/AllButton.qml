import QtQuick 2.4
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

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

        visible: mouseArea.containsMouse
        color: Styles.light
        opacity: Styles.blockInnerOpacity
    }

    Row {
        id: row

        anchors.centerIn: parent
        spacing: 8

        Text {
            text: qsTr("ALL_GAMES_GRID_TITLE_TEXT")
            color: mouseArea.containsMouse ? Styles.premiumInfoText :
                                             Styles.textAttention
            font {
                pixelSize: 16
                family: "Open Sans Light"
            }
        }

        Image {
            id: crossImage

            anchors.verticalCenter: parent.verticalCenter
            source: installPath + Styles.allGamesDropDown
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
