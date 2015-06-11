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

import "../../../../Core/Styles.js" as Styles

Column {
    id: root

    property alias style: progressBar.style
    property alias textColor: text.color
    property variant serviceItem

    spacing: 4

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

            return serviceItem.statusText;
        }
    }

    ProgressBar {
        id: progressBar

        height: 4
        style {
            background: Styles.style.downloadStatusProgressBackground
            line: Styles.style.downloadStatusProgressLine
        }
        animated: true
        width: parent.width
        progress: serviceItem ? serviceItem.progress : 75
        visible: !d.isError()
    }

    Item {
        clip: true
        width: parent.width
        height: text.height

        Text {
            id: text

            property int offset: 0
            property int offsetDuration: 0

            font { family: 'Arial'; pixelSize: 12 }
            color: Styles.style.lightText
            text: d.getStatusText();
            smooth: true
        }
    }
}
