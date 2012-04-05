/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
//import qGNA.Library 1.0

Rectangle {
    id: checkListBoxId
    height: 28

    color: "#00000000"

    property string buttonText;
    property string textWidth: mainClickText.width
    property string buttonCheckListBoxText: buttonCheckListBoxTextId.text;
    property int checkListBoxX
    property int checkListBoxWidth
    property alias textInputElement: buttonCheckListBoxTextId

    property bool isListActive: checkListBoxRectangle.height != checkListBoxId.height

    signal textChanged(string text);

    function getCheckBoxX() {
        if (checkListBoxX < 0)
            return mainClickText.width + 10;

            return checkListBoxX;
    }

    Text {
        id: mainClickText
        text: buttonText
        style: Text.Normal
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        font.family: "Segoe UI Semibold"
        font.bold: false
        font.pixelSize: 14
        font.weight: "Normal"
        opacity: 0.8
        smooth: true
        color: "white"
    }

    Rectangle {
        id: checkListBoxRectangle
        anchors.top: parent.top
        anchors.topMargin: 0
        color: "white"
        anchors.left: parent.left
        anchors.leftMargin: getCheckBoxX()
        opacity: 0.8
        height: parent.height
        width: checkListBoxWidth

        border { color: "#ea8a07"; width: 0 }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true;
            onEntered: {
                mainClickText.opacity = 1;
                checkListBoxRectangle.opacity = 1;
            }
            onExited: {
                if (!isListActive && buttonCheckListBoxTextId.focus == false) {
                    mainClickText.opacity = 0.8;
                    checkListBoxRectangle.opacity = 0.8;
                }
            }
            onClicked: buttonCheckListBoxTextId.focus = true;
        }

        TextInput {
            id: buttonCheckListBoxTextId
            text: buttonCheckListBoxText
            selectByMouse: true
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 3
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            font.family: "Segoe UI Semibold"
            font.bold: false
            font.pixelSize: 14
            //font.weight: "Light"
            smooth: true
            color: "black"

            onTextChanged: checkListBoxId.textChanged(buttonCheckListBoxTextId.text);

            onFocusChanged: {
                if (focus) {
                    mainClickText.opacity = 1;
                    checkListBoxRectangle.opacity = 1;
                } else
                {
                    mainClickText.opacity = 0.8;
                    checkListBoxRectangle.opacity = 0.8;
                }
            }
        }
    }
}
