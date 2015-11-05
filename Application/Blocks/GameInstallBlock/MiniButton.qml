import QtQuick 2.4
import GameNet.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

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

             color:
                 miniButtonBlock.enabled ?
                    miniButtonBlock.containsMouse
                        ? Styles.primaryButtonHover
                        : Styles.primaryButtonNormal
                    : Styles.primaryButtonDisabled

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
            color: Styles.textBase
         }
    }
}
