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
import GameNet.Components.Widgets 1.0

WidgetView {
    width: 100
    height: 100

    Rectangle {
        anchors.fill: parent
        color: "green"

        Text {
            anchors.centerIn: parent
            text: model.counter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: model.counter -= 10
        }
    }
}
