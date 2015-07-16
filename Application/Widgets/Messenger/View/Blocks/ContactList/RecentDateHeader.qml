/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import Application.Core.Styles 1.0

Item {
    property alias caption: captionText.text

    implicitWidth: 100
    implicitHeight: 30

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

        color: Styles.chatInactiveText
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
        color: Styles.light
    }
}
