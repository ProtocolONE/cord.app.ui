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
import Application.Blocks.Popup 1.0

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import "../../../Core/App.js" as App
import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

PopupBase {
    id: root

    property variant gameItem: App.currentGame()

    title: qsTr("GAME_EXECUTING_HEADER").arg(root.gameItem.name)

    onVisibleChanged: {
        if (visible) {
            model.startExecuting(root.gameItem.serviceId);
        }
    }

    Timer {
        interval: 5000
        running: root.visible
        onTriggered: {
            root.close();
        }
    }

    Item {
        width: 630
        height: childrenRect.height

        WidgetContainer {
            anchors.horizontalCenter: parent.horizontalCenter
            widget: gameItem.widgets.gameStarting
            visible: widget
        }
    }
}
