import QtQuick 1.1
import GameNet.Controls 1.0

import "../../Core/Styles.js" as Styles

Item {
    id: miniButtonBlock

    property alias source: miniButtonImage.source
    property alias text: miniButtonInfoText.text
    property bool containsMouse: false

    signal clicked();

    Row {
         spacing: 6

         Rectangle {
             id: miniButton

             width: 16
             height: 16

             color: miniButtonBlock.containsMouse
                    ? Styles.style.primaryButtonHover
                    : Styles.style.primaryButtonNormal

             visible: miniButtonImage.source !== ''

             Image {
                 id: miniButtonImage

                 anchors.centerIn: parent
             }
         }

         Text {
            id: miniButtonInfoText

            font { family: 'Arial'; pixelSize: 12 }
            smooth: true
            opacity: 0.5
            color: Styles.style.textBase
         }
    }
}
