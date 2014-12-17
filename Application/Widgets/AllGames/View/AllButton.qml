import QtQuick 1.1
import GameNet.Controls 1.0

Item {
    id: root

    property int iconRotation

    signal clicked()

    width: row.width + 30
    height: row.height + 4

    Rectangle {
        anchors.fill: parent
        color: '#113344'
        visible: mouseArea.containsMouse
    }

    Row {
        id: row

        anchors.centerIn: parent

        spacing: 7

        Text {
            text: 'Все игры GameNet'
            color: mouseArea.containsMouse ? '#f3d173' : '#ff6555'
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
