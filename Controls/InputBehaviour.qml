/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import Tulip 1.0

TextInput {
    id: inputBehavior

    property int fontSize: 16
    property string language: ''
    property bool capsLock: false
    property bool error: false

    signal keyPressed(variant keyEvent)
    signal focusLost()

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

    MouseArea {
        acceptedButtons: Qt.NoButton
        cursorShape: Qt.IBeamCursor
        anchors.fill: parent
    }
}

