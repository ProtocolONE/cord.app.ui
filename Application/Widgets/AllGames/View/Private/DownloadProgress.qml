import QtQuick 2.4
import ProtocolOne.Controls 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

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

    DownloadProgressBar {
        id: progressBar

        height: 4
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
            color: Styles.lightText
            text: d.getStatusText();
            smooth: true
        }
    }
}
