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

Button {
    id: root

    property alias icon: icon.source
    property alias text: captionText.text

    width: content.width + 42
    height: parent.height

    style: ButtonStyleColors {
        normal: "#092135"
        hover: "#243148"
    }

    Rectangle {
        anchors.left: parent.left
        width: 1
        height: parent.height
        color: root.containsMouse ? "#243148" : "#162E43"
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

    Rectangle {
        anchors.right: parent.right
        width: 1
        height: parent.height
        color: root.containsMouse ? "#243148" : "#171C2C"
    }
}
