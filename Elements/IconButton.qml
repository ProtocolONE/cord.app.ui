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
    property alias source: image.source

    signal clicked();

    width: Math.max(image.width, text.width)
    height: image.height + text.height

    Column {
        Image {
            id: image

            anchors.horizontalCenter: parent.horizontalCenter
            opacity: mouser.containsMouse ? 1 : 0.60

            Behavior on opacity {
                PropertyAnimation { duration: 200 }
            }
        }

        Text {
            id: text

            anchors.horizontalCenter: parent.horizontalCenter
            color: "#FFFFFF"
            font { family: "Segoe UI Light"; bold: true; pixelSize: 12; weight: Font.DemiBold }
        }
    }

    CursorMouseArea {
        id: mouser

        anchors.fill: parent
        onClicked: parent.clicked();
    }
}
