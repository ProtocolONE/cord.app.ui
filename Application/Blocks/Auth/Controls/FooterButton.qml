import QtQuick 2.4
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Row {
    id: root

    property alias title: footerItemText.text
    property alias text: footerButtonText.text

    signal clicked();

    height: 20
    width: childrenRect.width
    spacing: 5

    Text {
        id: footerItemText

        color: Styles.lightText
        font { family: "Open Sans Regular"; pixelSize: 15 }
    }

    TextButton {
        id: footerButtonText

        font { family: "Open Sans Regular"; pixelSize: 15 }
        onClicked: root.clicked()
    }
}
