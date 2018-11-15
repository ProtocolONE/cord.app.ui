import QtQuick 2.4
import Tulip 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Button {
    id: root

    property string icon
    property string iconLink

    property alias text: captionText.text

    implicitWidth: icon.width + 10 + captionText.width + 40
    implicitHeight: parent.height

    style {
        normal: "#00000000"
        hover: "#00000000"
        disabled: "#00000000"
    }

    Row {
        anchors {
            fill: parent
        }
        spacing: 10

        Image {
            id: icon

            anchors.verticalCenter: parent.verticalCenter
            source: root.containsMouse
                    ? root.icon.replace('.png', 'Hover.png') :
                      root.icon
        }

        Item {

            width: parent.width - 25
            height: parent.height

            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: captionText

                color: Styles.mainMenuText
                font { family: "Arial"; pixelSize: 16 }
                anchors.verticalCenter: parent.verticalCenter
            }

            Image {
                id: iconLink

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: captionText.right
                    leftMargin: 4
                }

                source: root.iconLink
            }
        }
    }
}
