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
import GameNet.Controls 1.0

import "../../../../Core/Styles.js" as Styles

Item {
    id: root

    property alias text: textElement.text

    Rectangle {
        anchors.fill: parent
        color: Styles.style.trayPopupBackground

        Column {
            spacing: 1
            anchors {
                fill: parent
                margins: 1
            }

            Rectangle {
                width: parent.width
                height: 25

                color: Styles.style.trayPopupHeaderBackground

                Image {
                    anchors {
                        left: parent.left
                        leftMargin: 6
                        verticalCenter: parent.verticalCenter
                    }

                    source: installPath + "Assets/Images/Application/Widgets/Announcements/logo.png"
                }
            }

            Item {
                id: bodyItem

                width: parent.width
                height: textElement.height

                Text {
                    id: textElement

                    anchors {
                        left: parent.left
                        top: parent.top
                        topMargin: 12
                        right: parent.right
                        leftMargin: 10
                        rightMargin: 10
                    }

                    text: model.body
                    color: Styles.style.trayPopupText
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font {
                        pixelSize: 13
                        family: "Arial"
                    }
                }
            }

        }
    }

    Rectangle {
        width: parent.width
        height: 2
        anchors {
            margins: 1
            bottom: parent.bottom
        }
        color: Styles.style.trayPopupHeaderBackground
    }
}

