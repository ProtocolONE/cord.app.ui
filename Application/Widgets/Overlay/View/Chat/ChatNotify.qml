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

Rectangle {
    id: root

    property alias text: textElement.text

    color: "#243148"

    Image {
        anchors {
            top: parent.top
            left: parent.left
            margins: 5
        }

        asynchronous: true
        source: installPath + "Assets/Images/Application/Blocks/Header/GamenetLogo.png"
    }

    Text {
        id: textElement

        anchors {
            left: parent.left
            top: parent.top
            leftMargin: 5
            topMargin: 35
        }

        color: "#FAFAFA"
        elide: Text.ElideRight
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        maximumLineCount: 3
        font { pixelSize: 14; family: "Arial"}
        anchors { fill: parent; margins: 10 }
    }
}

