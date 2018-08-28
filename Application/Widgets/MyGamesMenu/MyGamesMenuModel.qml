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
