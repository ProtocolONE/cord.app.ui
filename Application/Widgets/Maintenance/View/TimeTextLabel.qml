import QtQuick 2.4
import Application.Core.Styles 1.0

Row {
    property alias firstText: bigText.text
    property alias secondText: smallText.text

    spacing: 2

    Text {
        id: bigText

        color:  Styles.premiumInfoText
        font { pixelSize: 20 }
    }

    Text {
        id: smallText

        anchors { bottom: parent.bottom; bottomMargin: 1 }
        color: Styles.lightText
        font { pixelSize: 14 }
    }
}



