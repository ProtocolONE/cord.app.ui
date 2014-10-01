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
import Tulip 1.0
import GameNet.Controls 1.0

import "../../../Core/App.js" as App

ImageButton {
    id: root

    property variant gameItem

    styleImages: ButtonStyleImages {
        normal: root.gameItem ? installPath + root.gameItem.imageHorizontalSmall : ""
        hover: root.gameItem ? installPath + root.gameItem.imageHorizontalSmall : ""
        disabled: root.gameItem ? installPath + root.gameItem.imageHorizontalSmall : ""
    }

    Item {
        height: 30
        width: parent.width
        anchors {
            bottom: parent.bottom
        }
        visible: containsMouse

        Rectangle {
            opacity: 0.3
            color: "#092135"
            anchors.fill: parent
        }

        Text {
            opacity: 0.8
            color: "#fafafa"
            font { family: "Arial"; pixelSize: 14 }
            anchors.centerIn: parent
            text: root.gameItem ? qsTr("PROPOSAL_BUTTON_TEXT").arg(root.gameItem.name) : ""
        }
    }

    onClicked: {
        if (!root.gameItem) {
            return;
        }

        var startServiceId = root.gameItem.serviceId;
        App.navigate('mygame');
        App.activateGameByServiceId(startServiceId);
        App.downloadButtonStart(startServiceId);
    }
}
