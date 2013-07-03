/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (В©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**
** @author: Nikolay Bondarenko <nikolay.bondarenko@syncopate.ru>
** @since: 1.1
****************************************************************************/

import QtQuick 1.1

Item {
    property alias text: text.text;
    property alias toolTip: mouser.toolTip
    property alias tooltipPosition: mouser.tooltipPosition
    property alias tooltipGlueCenter: mouser.tooltipGlueCenter
    property alias source: image.source
    property bool isActive: false

    signal clicked();

    width: image.width
    height: image.height + text.height + 2

    Image {
        id: image

        anchors.horizontalCenter: parent.horizontalCenter
        opacity: (mouser.containsMouse || isActive)? 1 : 0.80

        Behavior on opacity {
            PropertyAnimation { duration: 100 }
        }
    }

    Text {
        id: text

        anchors { top: image.bottom; topMargin: 2; horizontalCenter: parent.horizontalCenter }
        color: isActive ? "#FE9900" : "#FFFFFF"
        smooth: true
        font {  family: "Arial"; pixelSize: 11; }
    }

    CursorMouseArea {
        id: mouser

        anchors.fill: parent
        onClicked: parent.clicked();
    }
}
