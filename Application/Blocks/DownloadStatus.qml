/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import GameNet.Controls 1.0

Column {
    id: root

    property alias style: progressBar.style
    property alias textColor: text.color
    property variant serviceItem

    spacing: 4
    height: 36

    QtObject {
        id: d

        function isError() {
            if (!root.serviceItem) {
                return false;
            }

            return root.serviceItem.status === "Error";
        }

        function getStatusText() {
            if (d.isError()) {
                return qsTr("DOWNLOAD_STATUS_ERROR");
            }

            if (!root.serviceItem) {
                return 'Mocked text about downloding...';
            }

            return serviceItem.statusText;
        }

    }

    ProgressBar {
        id: progressBar

        height: 4
        style: ProgressBarStyleColors {
            background: "#0d5043"
            line: "#35cfb1"
        }
        animated: true
        anchors { left: parent.left; right: parent.right}
        progress: serviceItem ? serviceItem.progress : 75
        visible: !d.isError()
    }

    Text {
        id: text

        font { family: 'Arial'; pixelSize: 12 }
        color: '#eff0f0'
        text: d.getStatusText();
    }
}
