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

    property alias infoText: infoTextElement.text
    property alias detailedText: detailedTextElement.text

    border { color: '#dee2e5' }
    color: '#00000000'

    Text {
        id: infoTextElement

        anchors {
            left: parent.left
            leftMargin: 12
            verticalCenter: parent.verticalCenter
        }

        font {
            family: "Arial"
            pixelSize: 12
        }

        color: '#606e7b'
    }

    Text {
        id: detailedTextElement

        anchors {
            right: parent.right
            rightMargin: 12
            verticalCenter: parent.verticalCenter
        }

        font {
            family: "Arial"
            pixelSize: 12
        }

        color: '#fa6956'
    }
}