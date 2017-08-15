/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import Tulip 1.0
import GameNet.Controls 1.0

import Application.Core 1.0

ImageButton {
    id: root

    property variant gameItem

    clip: true

    styleImages: ButtonStyleImages {
        normal: root.gameItem ? root.gameItem.imageHorizontalSmall : ""
        hover: root.gameItem ? root.gameItem.imageHorizontalSmall : ""
        disabled: root.gameItem ? root.gameItem.imageHorizontalSmall : ""
    }

    Item {
        visible: containsMouse
        width: parent.width
        height: caption.height + 8
        anchors.bottom: parent.bottom

        Rectangle {
            opacity: 0.5
            color: "#092135"
            anchors.fill: parent
        }

        Text {
            id: caption

            y: 4
            opacity: 0.8
            color: "#fafafa"
            font { family: "Arial"; pixelSize: 14 }

            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap

            text: root.gameItem ? qsTr("PROPOSAL_BUTTON_TEXT").arg(root.gameItem.name) : ""
        }
    }

    onClicked: {
        if (!root.gameItem) {
            return;
        }

        var startServiceId = root.gameItem.serviceId;
        SignalBus.navigate('mygame', '');
        App.activateGameByServiceId(startServiceId);
        App.downloadButtonStart(startServiceId);
    }
}
