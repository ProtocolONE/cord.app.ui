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
import Tulip 1.0

import "../../../../../Core/Styles.js" as Styles

Rectangle {
    property alias caption: captionText.text

    implicitWidth: 100
    implicitHeight: 30
    color: Styles.style.messengerRecentContactGroupBackground

    Text {
        id: captionText

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 12
        }

        font {
            family: "Arial"
            pixelSize: 12
        }

        opacity: 0.5
        color: Styles.style.messengerRecentContactGroupName
    }

    Rectangle {
        height: 1
        anchors {
            bottom: parent.bottom
            left: parent.left
            leftMargin: 12
            right: parent.right
        }

        opacity: 0.2
        color: Styles.style.messengerRecentContactGroupName
    }
}
