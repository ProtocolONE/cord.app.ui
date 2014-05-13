import QtQuick 1.1
import Tulip 1.0

import "../Controls" as Controls

Rectangle {
    id: root

    property string sampleError: root.generateError();

    function generateError() {
        var result = "";

        for (var i = 0; i <  100; ++i) {
            result += "123 ";
        }
        return result;
    }

    width: 800
    height: 600

    Column {
        anchors.fill: parent
        spacing: 10

        Rectangle {
            width: 300
            height: 20
            color: "green"
        }

        Controls.TopErrorContainer {
            id: error1

            width: 300
            errorMessage: root.sampleError

            Rectangle {
                width: parent.width
                height: 48
                color: "red"
            }

            style: Controls.ErrorMessageStyle {
                text: "#FF2E44"
                background: "blue"
            }
        }

        Controls.ErrorContainer {
            id: error2

            width: 300
            errorMessage: root.sampleError

            Rectangle {
                width: parent.width
                height: 48
                color: "red"
            }

            style: Controls.ErrorMessageStyle {
                text: "#FF2E44"
                background: "blue"
            }
        }

        Rectangle {
            width: 300
            height: 20
            color: "green"
        }
    }


    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if (mouse.button == Qt.LeftButton) {
                error1.error = !error1.error
            } else {
                error2.error = !error2.error
            }
        }
    }
}
