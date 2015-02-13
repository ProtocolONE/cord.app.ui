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
    anchors.fill: parent
    color: Styles.style.detailedUserInfoBackground

    Rectangle {
        anchors {
            fill: parent
            rightMargin: 1
            bottomMargin: 1
        }
        color: "#00000000"
        border {
            color: Styles.style.detailedUserInfoBackgroundBorder
            width: 1
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
    }
}

