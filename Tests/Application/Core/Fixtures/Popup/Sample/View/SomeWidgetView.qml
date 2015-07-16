/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

WidgetView {
    id: root

    width: 630
    height: 360

    Rectangle {
        anchors { fill: parent }

        color: '#00000000'
    }

    Text {
        anchors.centerIn: parent
        text: 'BLAASDASDFASFASFASFASf'
        color: '#111111'
    }

    Component.onCompleted: console.log('Constructor ', root)
    Component.onDestruction:  console.log('Destructor ', root)

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.close();
        }
    }
}
