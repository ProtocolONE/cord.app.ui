/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.0
import "." as Elements

Rectangle {
    id: input
    property string fontFamily: "Century Gothic"
    property int fontSize: 16
    property color textColor: "#000"
    property alias searchText: textInputLogin.text

    property bool failState: false;
    property color inputColor: "#eaf5e5"
    property color inputColorHover: "#fff"

    property string inputMask;
    property int maximumLength:  32767;

    property string editDefaultText: qsTr("Login")
    property string editText: textInputLogin.text
    property int textEchoMode: TextInput.Normal
    property alias textEditComponent: textInputLogin

    property bool editFocus: false

    property bool readOnly: false

    property bool acceptableInput: textInputLogin.acceptableInput

    signal searchEntered(string text)
    signal enterPressed()
    signal tabPressed()

    width: 250
    height: 32

    function clear() {
        textInputLogin.text = "";
    }

    Rectangle {
        id: inputEditor;
        width: parent.width; height: parent.height
        color: inputColor
        border { width: failState ? 1 : 0; color: "#E5392D" }
    }

    Text {
        id: placeholderText
        anchors {fill: parent; leftMargin: 8}
        verticalAlignment: Text.AlignVCenter
        text: editDefaultText
        color: textColor
        opacity: 0.5
        font {family: fontFamily; pixelSize: 14}
    }

    MouseArea {
        anchors.fill: parent
        onClicked: input.focus = true
    }

    property variant validator;

    onValidatorChanged: textInputLogin.validator = validator;

    TextInput {
        id: textInputLogin
        anchors { left: parent.left; leftMargin: 8; right: clear.left; rightMargin: 8; verticalCenter: parent.verticalCenter}
        selectByMouse: true
        maximumLength: input.maximumLength
        inputMask: input.inputMask
        readOnly: input.readOnly
        color: failState ? "#E5392D" :textColor
        font { family: fontFamily; pixelSize: fontSize }
        focus: editFocus
        onAccepted: { input.opacity = 0; input.searchEntered(text); clear.opacity = 0 }
        echoMode: textEchoMode
        onFocusChanged: {
            if (focus) {
                inputEditor.color = inputColorHover
            } else {
                inputEditor.color = inputColor
            }
        }

        Keys.onPressed: {
            failState = false;
            if (event.key == Qt.Key_Return  || event.key == Qt.Key_Enter) {
                enterPressed();
                event.accepted = true;
            }
            else if (event.key == Qt.Key_Tab) {
                tabPressed();
                event.accepted = true;
            }
        }
    }

    Image {
        id: clear

        width: 12; height: 12
        smooth: true
        anchors { right: parent.right; rightMargin: 8; verticalCenter: parent.verticalCenter }
        source: installPath + "images/delete.png"
        opacity: 0

        NumberAnimation { id: opacityUp; running: false; target: clear; property: "opacity"; from: 0.65; to: 1.0; duration: 175; }
        NumberAnimation { id: opacityDown; running: false; target: clear; property: "opacity"; from: 1; to: 0.65; duration: 175; }

        Elements.CursorMouseArea {
            id: clearMouser

            anchors.fill: parent
            hoverEnabled: true
            onClicked: { textInputLogin.text = ''; input.focus = true; failState = false; }
            onEntered: { if (input.state == "hasText") opacityUp.start(); }
            onExited: { if (input.state == "hasText") opacityDown.start(); }
        }
    }

    states: State {
        name: "hasText"; when: textInputLogin.text != ''
        PropertyChanges { target: placeholderText; opacity: 0 }
        PropertyChanges { target: clear; opacity: 0.75 }
    }

    transitions: [
        Transition {
            from: ""; to: "hasText"
            NumberAnimation { exclude: placeholderText; properties: "opacity" }
        },
        Transition {
            from: "hasText"; to: ""
            NumberAnimation { properties: "opacity" }
        }
    ]
}
