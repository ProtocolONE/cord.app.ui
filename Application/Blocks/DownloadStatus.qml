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
import GameNet.Controls 1.0

Column {
    property alias style: progressBar.style
    property alias textColor: text.color
    property variant serviceItem

    spacing: 4
    height: 36

    ProgressBar {
        id: progressBar

        height: 4
        style: ProgressBarStyleColors {
            background: "#0d5043"
            line: "#35cfb1"
        }
        anchors { left: parent.left; right: parent.right}
        progress: serviceItem ? serviceItem.progress : 75
    }

    Text {
        id: text

        font { family: 'Arial'; pixelSize: 12 }
        color: '#eff0f0'
        text: serviceItem ? serviceItem.statusText : 'Mocked text about downloding...'
    }
}
