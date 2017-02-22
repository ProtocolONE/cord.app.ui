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
import Application.Blocks.Popup 1.0

import GameNet.Components.Widgets 1.0

import Application.Core 1.0

PopupBase {
    id: root

    property variant gameItem

    width: Math.max(implicitWidth, internalContainer.width + defaultMargins * 2)

    title: qsTr("GAME_EXECUTING_HEADER").arg(root.gameItem.name)

    Component.onCompleted: {
        root.gameItem = App.currentGame();
        hack1.start()
    }


    // INFO Так как мы хотим в методе startExecuting показать новые попапы,
    // то этот метод надо вызхвать чуть попозже, когда этот попап доинициализируется.
    // Иначе закрытие обработает не корретно.
    Timer {
        id: hack1

        running: false
        repeat: false
        interval: 10
        onTriggered: model.startExecuting(root.gameItem.serviceId)
    }

    Timer {
        interval: 5000
        running: root.visible
                 && root.model.internalPopupId == -1
                 && root.model.internalP2PTransferPopupId == -1

        onTriggered: {
            root.close();
        }
    }

    WidgetContainer {
        id: internalContainer

        widget: gameItem.widgets.gameStarting
        visible: widget
    }

    Connections {
        target: root.model
        onCloseView: root.close();
    }
}
