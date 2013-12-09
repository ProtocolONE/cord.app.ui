/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import "../../../Elements" as Elements

Rectangle {
    id: container

    property bool isExpanded: false
    property string collapsedText: qsTr("CA_SHOP_EXPAND")
    property string expandedText: qsTr("CA_SHOP_COLLAPSE")

    signal expanded()
    signal collapsed()

    width: buttonLabel.width + 60
    height: 28
    border { color: "#71695E"; width: 1 }
    color: mouseArea.containsMouse ? "#72551F" : "#00000000"

    Image {
        id: leftArrow

        width: 15
        anchors {
            right: buttonLabel.left
            rightMargin: 10
            verticalCenter: buttonLabel.verticalCenter
        }
        source: installPath + "images/arrow.png"
        rotation: isExpanded ? 180: 0
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: buttonLabel

        text: isExpanded ? expandedText : collapsedText
        anchors { centerIn: parent; verticalCenterOffset: 1 }
        font { family: "Tahoma"; pixelSize: 16; bold: false }
        smooth: true
        opacity: 1
        color: "#FFFFFF"
    }

    Image {
        id: rightArrow

        width: 15
        anchors {
            left: buttonLabel.right
            leftMargin: 10
            verticalCenter: buttonLabel.verticalCenter
        }
        source: installPath + "images/arrow.png"
        rotation: isExpanded ? 0 : 180
        fillMode: Image.PreserveAspectFit
    }

    Elements.CursorMouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            if (isExpanded) {
                isExpanded = false;
                container.collapsed();
            } else {
                isExpanded = true;
                container.expanded();
            }
        }
    }
}
