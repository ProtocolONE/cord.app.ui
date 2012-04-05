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

Rectangle {
    id: selectMw2ServerDelegate

    property bool isSelected: false;

    signal itemSelected();
    signal startGame();

    color: rowItem.containsMouse ? "#2e6293"
         : isSelected ? "#083c6d" : "#00000000"

    height: 24
    width: 379
    anchors { left: parent.left; leftMargin: 1 }

    MouseArea {
        id: rowItem

        anchors.fill: parent
        visible: parent.visible
        hoverEnabled: true

        onClicked: itemSelected();
        onDoubleClicked: startGame();
    }

    Image {
        id: rowPinned

        width: parent.width
        height: parent.height
        source: installPath + "images/select-bg.png"
        fillMode: Image.Tile
        visible: isPinned && !rowItem.containsMouse && (isSelected ? false : true);
    }

    function stateIdToStringConverter(value)
    {
        switch(value) {
        case 0: return "Свободен";
        case 1: return "Загружен";
        case 2: return "Заполнен";
        case 3: return "Недоступен";
        }
    }

    function stateIdToColorConverter(value)
    {
        switch(value) {
        case 0: return "#33ff00";
        case 1: return "#aeff00";
        case 2: return "#ffff00";
        case 3: return "#ff3333";
        }
    }

    Row {
        spacing: 15

        Rectangle {
            height: parent.height
            width: 25;

            Text {
                color: "#ffffff";
                text: position
                font.pixelSize: 14
                anchors { top: parent.top; left: parent.left; topMargin: 3; leftMargin: 6 }
            }
        }

        Rectangle {
            height: parent.height
            width: 80;

            Text {
                color: "#ffffff";
                text: name
                font.pixelSize: 14
                anchors { top: parent.top; topMargin: 3 }
            }
        }

        Rectangle {
            height: parent.height
            width: 90;

            Text {
                color: stateIdToColorConverter(status);
                text: stateIdToStringConverter(status);                
                font.pixelSize: 14
                anchors { top: parent.top; topMargin: 3 }
            }
        }

        Rectangle {
            height: parent.height
            width: 85;
            Text {
                color: "#ffffff";
                text: charCount
                font.pixelSize: 14
                anchors { top: parent.top; topMargin: 3 }
            }
        }
    }
}
