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

Item {
    id: checkListBoxId
    height: 30

    property string buttonText;
    property string textWidth: mainClickText.width
    property string buttonCheckListBoxText;

    property int checkListBoxX
    property int checkListBoxWidth
    property bool checkBoxType; // false - textEdit, true - dropListBox
    property int curIndex;

    property bool isListActive: checkListBoxRectangle.height != checkListBoxId.height

    property ListModel listModel;
    property Component componentDelegate;

    signal itemClicked(string lang);
    signal listDropped();

    function switchAnimation() {
        if (checkListBoxRectangle.height == checkListBoxId.height) {
            listDropped();
            checkListBoxRectangle.border.width = 1;
            checkListBoxRectangle.color = "#ea8a07";  //f28a0d
            checkListBoxRectangle.height = checkListBoxId.height + listViewId.height;
        }
        else {
            checkListBoxRectangle.border.width = 0;
            checkListBoxRectangle.color = "white";
            checkListBoxRectangle.height = checkListBoxId.height;
            mainClickText.opacity = 0.8;
            checkListBoxRectangle.opacity = 0.8;
        }

        listViewId.visible = !listViewId.visible;
    }

    function getCheckBoxX() {
        if (checkListBoxX < 0)
            return mainClickText.width + 10;

            return checkListBoxX;
    }

    Text {
        id: mainClickText

        text: buttonText
        style: Text.Normal
        anchors { left: parent.left; verticalCenter: parent.verticalCenter }
        font { family: "Segoe UI Semibold"; bold: false; pixelSize: 14; weight: "Normal" }
        opacity: 0.8
        smooth: true
        color: "#FFFFFF"
    }

    Rectangle {
        id: checkListBoxRectangle

        color: "#FFFFFF"
        anchors { top: parent.top; left: parent.left; leftMargin: getCheckBoxX() }
        opacity: 0.8
        height: parent.height
        width: checkListBoxWidth

        border { color: "#ea8a07"; width: 0 }

        Text {
            id: buttonCheckListBoxTextId

            text: buttonCheckListBoxText
            anchors { left: parent.left; top: parent.top; leftMargin: 10; topMargin: 5 }
            font { family: "Segoe UI Semibold"; bold: false; pixelSize: 14 }
            smooth: true
            color: "#000000"
        }

        Image {
            source: installPath + "Assets/Images/downArrow.png"
            anchors { right: parent.right; top: parent.top; verticalCenterOffset: 1 }
            anchors { rightMargin: 5; topMargin: 12 }
            visible: checkBoxType
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true;
            onEntered: {
                mainClickText.opacity = 1;
                checkListBoxRectangle.opacity = 1;
            }
            onExited: {
                if (!isListActive) {
                    mainClickText.opacity = 0.8;
                    checkListBoxRectangle.opacity = 0.8;
                }
            }
            onClicked: switchAnimation();
        }

        ListView {
            id: listViewId

            anchors { top: parent.top; left: parent.left; right: parent.right; topMargin: 30 }
            height: listViewId.count * 30
            interactive: false
            currentIndex: curIndex
            visible: false

            delegate: componentDelegate
            model: listModel
        }
    }
}
