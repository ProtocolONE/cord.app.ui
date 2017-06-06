import QtQuick 2.4
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Settings 1.0
import Application.Core.Styles 1.0
import Application.Core.MessageBox 1.0

Rectangle {
    property variant targetInput

    color: targetInput.style.background
    anchors {
        fill: targetInput
        margins: 2
    }

    visible: targetInput.visible
             && !targetInput.inputFocus
             && targetInput.text == "0"

    Text {
        text: qsTr("SPEED_UNLIMITED")
        anchors {
            left: parent.left
            leftMargin: 10
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        color: targetInput.style.placeholder
        elide: Text.ElideRight
        font { family: "Arial"; pixelSize: targetInput.fontSize }
    }
}

