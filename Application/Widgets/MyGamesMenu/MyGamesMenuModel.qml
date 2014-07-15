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

import "../../Core/App.js" as App

WidgetModel {
    id: root


    property alias listModelAlias: listModel

    function fillModel() {
        listModel.clear();

        for (var i = 0; i < App.gamesListModel.count; ++i) {
            var item = App.gamesListModel.get(i);

            if (!item || !item.enabled) {
                continue;
            }

            var enabled = App.isShownInMyGames(item.serviceId);
            if (enabled) {
                listModel.append({item: item});
            }
        }
    }

    ListModel {
        id: listModel
    }

    Connections {
        target: App.signalBus()

        onServiceUpdated: root.fillModel();
    }

    Component.onCompleted: root.fillModel();
}
