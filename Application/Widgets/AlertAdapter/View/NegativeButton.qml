import QtQuick 1.1
import GameNet.Controls 1.0 as Controls

Item {
    id: root

    width: 40 + button.width
    height: 46

    property alias text: button.text
    property int buttonId
    signal buttonClick(int button)

    Rectangle {
        id: spliterButtons

        color: '#cccccc'
        height: parent.height
        width: 1
        anchors {
            left: parent.left
            bottom: parent.bottom
        }
    }

    Controls.TextButton {
        id: button

        anchors {
            left: parent.left
            leftMargin: 30
            verticalCenter: parent.verticalCenter
        }

        onClicked: root.buttonClick(buttonId);

        style: Controls.ButtonStyleColors {
            normal: "#cccccc"
            hover: "#ffffff"
        }

        fontSize: 14
    }
}
