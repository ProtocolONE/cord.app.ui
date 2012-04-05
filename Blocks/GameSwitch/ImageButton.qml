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
import "../../Elements"

Image {
    property string name;
    property string serviceId;

    signal clicked(string serviceId);

    Rectangle {
        anchors {left: parent.left; right: parent.right; bottom: parent.bottom}
        height: 30
        color: "#227700"
        opacity: mouser.containsMouse ? 1 : 0.80

        Behavior on opacity {
            PropertyAnimation { duration: 200 }
        }

        Text {
            anchors.centerIn: parent
            color: "#FFFFFF"
            text: currentItem ? qsTr("MAINTENANCE_IMAGE_BUTTON_TEXT").arg(name): ""
            font { family: "Segoe UI Light"; bold: false; pixelSize: 18; weight: "Normal" }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#00000000"
        border { color: "#c2c1c0"; width: 1 }
    }

    CursorMouseArea {
        id: mouser

        anchors.fill: parent
        onClicked: parent.clicked(serviceId);
    }
}
