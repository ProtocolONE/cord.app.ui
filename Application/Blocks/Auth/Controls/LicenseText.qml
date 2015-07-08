import QtQuick 1.1
import Application.Controls 1.0

import "../../../Core/Styles.js" as Styles

Column {
    id: root

    height: 48
    width: 280
    spacing: 5

    signal clicked();

    Text {
        anchors { baseline: parent.top; baselineOffset: 20 }
        width: parent.width
        font {family: "Arial"; pixelSize: 11}
        color: Styles.style.infoText
        text: qsTr("REGISTER_BODY_LICENSE_PART1")
    }

    TextButton {
        font { pixelSize: 11 }
        text: qsTr("REGISTER_BODY_LICENSE_PART2")
        onClicked: root.clicked()
        analytics {
            category: 'Auth'
            action: 'outer link'
            label: 'License'
        }
    }
}
