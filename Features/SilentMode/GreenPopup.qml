import QtQuick 1.1
import Tulip 1.0
import "../../Elements" as Elements

import "../../Proxy/App.js" as App

Elements.GameItemPopUp {
    id: popUp

    property alias message: messageText.text

    state: "Green"

    Item {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 60
        }

        height: 79

        Text {
            id: messageText

            textFormat: Text.RichText
            wrapMode: Text.WordWrap
            anchors.fill: parent
            anchors.margins: 5
            horizontalAlignment: Text.AlignHCenter
            color: "#FFFFFF"
            onLinkActivated: App.openExternalUrl(link)
        }
    }

}
