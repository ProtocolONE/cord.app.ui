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

import "../../../../js/Core.js" as CoreJs

WidgetView {
    id: root

    property variant currentItem: CoreJs.currentGame()
    
    function update() {
        if (currentItem) {
            infoText.text = model.getInfo(currentItem.gameId);
        }
    }

    anchors.fill: parent
    clip: true
    onCurrentItemChanged: update();

    Connections {
        target: model
        onInfoChanged: update();
    }

    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"
    }

    Text {
        id: infoText

        wrapMode: Text.WordWrap
        anchors {
            fill: parent
            margins: 20
        }
        smooth: true
        font { family: "Arial"; pixelSize: 14;}
    }
}
