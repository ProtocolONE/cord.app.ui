import QtQuick 2.4
import Tulip 1.0

TextInput {
    id: inputBehavior

    property int fontSize: 16
    property string language: ''
    property bool capsLock: false
    property bool error: false

    property alias toolTip: mouseArea.toolTip
    property alias tooltipPosition: mouseArea.tooltipPosition
    property alias tooltipGlueCenter: mouseArea.tooltipGlueCenter

    signal keyPressed(variant keyEvent)
    signal focusLost()

    clip: true
    font { family: "Arial"; pixelSize: inputBehavior.fontSize }
    selectByMouse: true
    onFocusChanged: {
        if (!focus) {
            inputBehavior.focusLost();
        }
    }

    Keys.onPressed: {
        keyPressed(event);
    }

    CursorMouseArea {
        id: mouseArea

        acceptedButtons: Qt.NoButton
        cursorShape: Qt.IBeamCursor
        anchors.fill: parent
    }
}

