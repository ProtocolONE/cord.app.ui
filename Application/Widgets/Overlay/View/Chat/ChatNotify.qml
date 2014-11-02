/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1

import "../../../../Core/Styles.js" as Styles

Item {
    id: root

    property alias text: textElement.text

    Rectangle {
        anchors {
            fill: parent
            rightMargin: 1
            bottomMargin: 1
        }
        color: Styles.style.trayPopupBackground
        border.color: Styles.style.trayPopupBackgroundBorder
    }

    Column {
        anchors.fill: parent

        Item {
            width: parent.width
            height: 50

            Row {
                anchors { fill: parent; margins: 10 }
                spacing: 8

                Image {
                    source: installPath + "Assets/Images/Application/Widgets/Overlay/gamenetLogo.png"
                    width: 32
                    height: 32
                    cache: true
                    asynchronous: true
                }

                Text {
                    text: 'GameNet'
                    color: Styles.style.trayPopupTextHeader
                    width: 160
                    elide: Text.ElideRight
                    anchors.verticalCenter: parent.verticalCenter
                    font { pixelSize: 18; family: "Arial"}
                }
            }
        }

        Item {
            id: bodyItem

            width: parent.width
            height: root.height

            Text {
                id: textElement

                x: 8
                width: parent.width - 10 - 42
                text: model.body
                color: Styles.style.trayPopupText
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font { pixelSize: 13; family: "Arial"}
            }

        }
    }
}

