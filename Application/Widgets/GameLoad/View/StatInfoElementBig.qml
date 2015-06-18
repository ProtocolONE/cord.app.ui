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
import Application.Controls 1.0

import "../../../Core/Styles.js" as Styles

Item {
    property alias infoText: infoTextElement.text
    property alias detailedText: detailedTextElement.text

    ContentThinBorder {
        anchors {
            fill: parent
            bottomMargin: 0
            rightMargin: 0
        }
    }

    Text {
        id: infoTextElement

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 9
        }

        font {
            family: "Arial"
            pixelSize: 12
        }

        color: Styles.style.popupText
    }

    Text {
        id: detailedTextElement

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 8
        }

        font {
            family: "Arial"
            pixelSize: 12
        }

        color: Styles.style.lightText
    }
}
