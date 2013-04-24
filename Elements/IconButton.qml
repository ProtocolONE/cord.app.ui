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

Rectangle {
    property alias text: text.text;
    property alias toolTip: mouser.toolTip
    property alias source: image.source
    property bool isUnderline: false

    signal clicked();

    width: image.width
    height: image.height + text.height

    color: "#00000000"

    Image {
        id: image

        anchors.horizontalCenter: parent.horizontalCenter
        opacity: (mouser.containsMouse || isUnderline)? 1 : 0.60

        Behavior on opacity {
            PropertyAnimation { duration: 200 }
        }
    }

    Text {
        id: text

        anchors { top: image.bottom; topMargin: 2; horizontalCenter: parent.horizontalCenter }
        color: isUnderline? "#FE9900" : "#FFFFFF"
        smooth: true
        font {  family: "Segoe UI Light"; pixelSize: 11; letterSpacing: 0.7 }
    }

    CursorMouseArea {
        id: mouser

        anchors.fill: parent
        onClicked: parent.clicked();
    }
}
