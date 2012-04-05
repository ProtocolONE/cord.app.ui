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
import "." as Elements

Rectangle {
    id: textAreaMain
    width: 455
    height: 140
    color: "#00000000"

    property string textarea_text;
    property alias textElement: textAreaText
    property alias flicElement: textAreaFlickable

    Rectangle {
        id: textAreaScreen
        width: textAreaMain.width
        height: textAreaMain.height
        color: "#00000000"

        Flickable {
            id: textAreaFlickable
            anchors.fill: parent
            contentWidth: textAreaText.width
            contentHeight: textAreaText.height
            flickableDirection: Flickable.VerticalFlick
            clip: true

            TextEdit {
                id: textAreaText
                width: textAreaScreen.width
                wrapMode: TextEdit.Wrap
                readOnly: true
                color: "#fff"
                font.family: "Arial"
                font.pixelSize: 12
                text: textarea_text
            }
        }
    }
}
