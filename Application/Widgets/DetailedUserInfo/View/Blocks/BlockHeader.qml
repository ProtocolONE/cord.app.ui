/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2015, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import "../../../../Core/Styles.js" as Styles

Rectangle {
    property alias text: captionText.text

    implicitWidth: parent.width
    implicitHeight: 35
    color: Styles.style.applicationBackground

    Text {
        id: captionText

        anchors {
            left: parent.left
            leftMargin: 15
            verticalCenter: parent.verticalCenter
        }

        color: Styles.style.lightText
        textFormat: Text.RichText
    }
}

