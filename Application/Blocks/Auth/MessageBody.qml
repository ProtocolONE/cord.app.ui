import QtQuick 1.1
import GameNet.Controls 1.0

Item {
    id: root

    property alias message: messageText.text

    implicitHeight: 473
    implicitWidth: 500

    signal clicked();

    Column {
        anchors.fill: parent
        spacing: 20

        Item {
            width: parent.width
            height: 35

            Text {
                font {
                    pixelSize: 18
                }
                anchors.baseline: parent.bottom
                color: "#363636"
                text: qsTr("MESSAGE_TITLE");
            }
        }

        Text {
            id: messageText

            width: parent.width
            font {
                pixelSize: 15
            }

            color: "#6A768E"
            wrapMode: Text.WordWrap
        }

        Row {
            width: parent.width
            height: 48
            spacing: 30

            Button {
                width: 200
                height: parent.height
                text: qsTr("OK_BUTTON_LABEL");
                onClicked: root.clicked();
            }
        }
    }
}
