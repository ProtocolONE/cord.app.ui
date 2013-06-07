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
import "../../../Elements" as Elements

Rectangle {
    property int circleRadius: 30
    property alias source: image.source
    property alias toolTip: mouser.toolTip
    property alias enabled: mouser.visible

    signal clicked();

    width: circleRadius
    height: circleRadius
    radius: circleRadius / 2

    opacity: enabled ? (mouser.containsMouse ? 1 : 0.75) : 0.5
    Behavior on opacity {
        NumberAnimation { duration: 250 }
    }

    Image {
        id: image
        anchors.centerIn: parent
    }

    Elements.CursorMouseArea {
        id: mouser

        anchors.fill: parent
        onClicked: parent.clicked();
    }
}
