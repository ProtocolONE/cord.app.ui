import QtQuick 1.1
import GameNet.Controls 1.0

import "../../../Core/Styles.js" as Styles

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

        color: Styles.style.lightText
        font { family: "Open Sans Regular"; pixelSize: 15 }
    }

    TextButton {
        id: footerButtonText

        font { family: "Open Sans Regular"; pixelSize: 15 }
        style {
            normal: Styles.style.linkText
            hover: Styles.style.linkText
        }
        onClicked: root.clicked()
    }
}
