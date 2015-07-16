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
import GameNet.Components.Widgets 1.0

import Application.Core 1.0
import Application.Core.MyGames 1.0

WidgetModel {
    id: root


    property alias listModelAlias: listModel

    function fillModel() {
        listModel.clear();

        for (var i = 0; i < App.gamesListModel.count; ++i) {
            var item = App.gamesListModel.get(i);

            if (!item || !item.isPublishedInApp) {
                continue;
            }

            var enabled = MyGames.isShownInMyGames(item.serviceId);
            if (enabled) {
                listModel.append({item: item});
            }
        }
    }

    ListModel {
        id: listModel
    }

    Connections {
        target: SignalBus

        onServiceUpdated: root.fillModel();
        onAuthDone: root.fillModel();
    }
}
