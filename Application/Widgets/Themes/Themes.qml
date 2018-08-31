import QtQuick 2.4

import Tulip 1.0
import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Core 1.0

WidgetModel {
    id: root

    property alias dataModel: list

    Connections {
        target: SignalBus
        onAuthDone: {
            console.log('Query themes');
            RestApi.Games.getThemes(dataReceived, errorOccured);
        }
    }

    function dataReceived(data) {
        var themes = data.themes.map(function(e){
            return {
                name: e.name,
                preview: e.preview,
                theme: e.theme,
                showOrder: e.showOrder,
                updateDate: e.updatedate
            };
        });

        themes.sort(function(a, b) {
            return a.showOrder - b.showOrder;
        });

        list.clear();
        themes.forEach(function(e) {
            list.append(e);
        });
    }

    function errorOccured(data) {
        console.log('Themes load error', JSON.stringify(data));
    }

    ListModel {
        id: list
    }
}
