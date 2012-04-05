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
import qGNA.Library 1.0
import "." as Elements

Rectangle {
    property string fontFamily: "Century Gothic"
    property int fontSize: 16
    property color textColor: "#000"
    property alias searchText: textInputPassword.text

    property color inputColor: "#eaf5e5"
    property color inputColorHover: "#fff"

    signal searchEntered(string text)

    function clear() {
        textInputPassword.text = "";
    }

    width: 250
    height: 32

    Rectangle {
        id: inputEditorPassword;

        width: parent.width; height: parent.height
        color: inputColor
    }

    Text {
        id: placeholderText

        anchors {fill: parent; leftMargin: 8}
        verticalAlignment: Text.AlignVCenter
        text: qsTr("password")
        color: textColor
        opacity: 0.5
        font {family: fontFamily; pixelSize: 14}
    }

    Elements.CursorMouseArea {
        anchors.fill: parent
        onClicked: input.focus = true
    }

    TextInput {
        id: textInputPassword

        anchors { left: parent.left; leftMargin: 8; right: clear.left; rightMargin: 8; verticalCenter: parent.verticalCenter}
        focus: false
        selectByMouse: true
        color: textColor
        font.family: fontFamily
        font.pixelSize: fontSize
        onAccepted: { input.opacity = 0; input.searchEntered(text); clear.opacity = 0 }
        echoMode: TextInput.Password
        onFocusChanged: {
            if(focus) {
                inputEditorPassword.color = inputColorHover
            }else {
                inputEditorPassword.color = inputColor
            }
        }
    }

    Image {
        id: clear
        width: 12; height: 12
        smooth: true
        anchors { right: parent.right; rightMargin: 8; verticalCenter: parent.verticalCenter }
        source: installPath + "delete.png"
        opacity: 0

        MouseArea {
            anchors.fill: parent
            onClicked: { textInput.text = ''; input.focus = true }
        }
    }

    states: State {
        name: "hasText"; when: textInput.text != ''
        PropertyChanges { target: placeholderText; opacity: 0 }
        PropertyChanges { target: clear; opacity: 0.8 }
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

