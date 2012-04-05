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
//import qGNA.Library 1.0
import "../Models" as Models

Rectangle {
    id: contextMenu
    width: 147
    height: 85
    border.color: "#ff9901"
    border.width: 1
    color: "#ffffff"

    signal inputCut();
    signal inputCopy();
    signal inputPaste();


    Rectangle {
        id: contextMenuCut

        width: 146
        height: 28
        color: contextMenuCutArea.containsMouse ? "#ffc773" : "#ffffff"
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.top: parent.top
        anchors.topMargin: 1

        Text {
            text: "Вырезать"
            color: "#000000";
            font.pixelSize: 16
            anchors.top: parent.top
            anchors.topMargin: 2
            anchors.left: parent.left
            anchors.leftMargin: 8
        }

        MouseArea {
            id: contextMenuCutArea
            anchors.fill: parent
            visible: parent.visible
            hoverEnabled: true

            onClicked: {
                inputCut();
                console.log("inputCut");
            }
        }
   }


    Rectangle {
        id: contextMenuCopy

        width: 146
        height: 28
        color: contextMenuCopyArea.containsMouse ? "#ffc773" : "#ffffff"
        anchors.top: parent.top
        anchors.topMargin: 29
        anchors.left: parent.left
        anchors.leftMargin: 1

        Text {
            text: "Копировать"
            color: "#000000";
            font.pixelSize: 16
            anchors.top: parent.top
            anchors.topMargin: 2
            anchors.left: parent.left
            anchors.leftMargin: 8
        }

        MouseArea {
            id: contextMenuCopyArea
            anchors.fill: parent
            visible: parent.visible
            hoverEnabled: true

            onClicked: {
                inputCopy();
                console.log("inputCopy");
            }
        }
   }


    Rectangle {
        id: contextMenuPaste

        width: 146
        height: 28
        color: contextMenuPasteArea.containsMouse ? "#ffc773" : "#ffffff"
        anchors.top: parent.top
        anchors.topMargin: 57
        anchors.left: parent.left
        anchors.leftMargin: 1

        Text {
            text: "Вставить"
            color: "#000000";
            font.pixelSize: 16
            anchors.top: parent.top
            anchors.topMargin: 2
            anchors.left: parent.left
            anchors.leftMargin: 8
        }

        MouseArea {
            id: contextMenuPasteArea
            anchors.fill: parent
            visible: parent.visible
            hoverEnabled: true

            onClicked: {
                inputPaste();
                console.log("inputPaste");
            }
        }
   }





    // для инпута
//    Elements.ContextMenu {
//        id: contextMenu
//        anchors.left: parent.left
//        anchors.leftMargin: 11
//        anchors.top: parent.top
//        anchors.topMargin: 23
//        visible: false;

//        onInputCut: {
//            console.log("inputCut");
//            textInputLogin.cut();
//        }

//        onInputCopy: {
//            console.log("inputCopy");
//            textInputLogin.copy();
//        }

//        onInputPaste: {
//            console.log("inputPaste");
//            textInputLogin.paste();
//        }


//        MouseArea {
//            onClicked: {

//            }
//        }
//    }



}
