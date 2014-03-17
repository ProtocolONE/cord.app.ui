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

import "../../Controls" as Controls

Controls.Button {
    property alias icon: icon.source
    property alias text: captionText.text

    width: content.width + 40
    height: parent.height

    style: Controls.ButtonStyleColors {
        normal: "#092135"
        hover: "#243148"
    }

    Item {
        id: content

        width: height + textContainer.width + 10
        height: 24
        anchors.centerIn: parent

        Row {
            anchors.fill: parent
            spacing: 10

            Item {
                width: height
                height: parent.height

                Image {
                    id: icon

                    anchors.centerIn: parent
                }
            }

            Item {
                id: textContainer

                height: parent.height
                width: captionText.width

                Text {
                    id: captionText

                    color: "#FFFFFF"
                    font { family: "Arial"; pixelSize: 16 }
                    anchors.centerIn: parent
                }
            }
        }
    }
}
