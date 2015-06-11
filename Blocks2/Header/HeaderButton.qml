/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0

import "../../Core/Styles.js" as Styles

Button {
    id: root

    property string icon
    property alias text: captionText.text

    implicitWidth: icon.width + 10 + captionText.width + 40
    implicitHeight: parent.height

    style {
        normal: "#00000000"
        hover: "#00000000"
        disabled: "#00000000"
    }

    Row {
        anchors {
            fill: parent
            leftMargin: 10
        }
        spacing: 10

        Image {
            id: icon

            anchors.verticalCenter: parent.verticalCenter
            source: root.containsMouse
                    ? root.icon.replace('.png', 'Hover.png') :
                      root.icon
        }

        Text {
            id: captionText

            color: Styles.style.mainMenuText
            font { family: "Arial"; pixelSize: 16 }
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
