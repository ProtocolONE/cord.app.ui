/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Core/Styles.js" as Styles

Item {
    id: root

    property alias nickname: nickText.text
    property alias tooltip: cursorArea.toolTip
    property alias color: nickText.color

    signal nicknameClicked()

    Text {
        id: nickText

        anchors.fill: parent
        color: "#1ABC9C"
        font { family: "Arial"; pixelSize: 16 }
        clip: true
        elide: Text.ElideRight
    }

    CursorMouseArea {
        id: cursorArea

        acceptedButtons: Qt.LeftButton
        anchors.fill: parent
        hoverEnabled: true
        tooltipGlueCenter: false
        tooltipPosition: "N"
        onClicked: {
            root.nicknameClicked()
        }
    }
}
