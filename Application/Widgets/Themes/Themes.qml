import QtQuick 2.4

import Tulip 1.0

import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Core 1.0

WidgetModel {
    id: root

    property alias dataModel: list

    property bool available: false

    Connections {
        target: SignalBus
        onAuthDone: {
            root.available = false;

            console.log('Query themes');

            RestApi.Theme.getList(dataReceived);
        }
    }

    function dataReceived(code, data) {
        if (!RestApi.ErrorEx.isSuccess(code)) {
            console.log('Themes load error', code);
            return;
        }

        var themes = data.map(function(e){
            return {
                name: e.name,
                preview: e.image,
                theme: e.file,
                // UNDONE not enough info from api
                showOrder: 0, //e.showOrder,
                updateDate: 0 //e.updatedate
            };
        });

        themes.sort(function(a, b) {
            return a.showOrder - b.showOrder;
        });

        list.clear();
        themes.forEach(function(e) {
            list.append(e);
        });

        root.available = list.count > 0;
    }

    function errorOccured(data) {
        console.log('Themes load error', JSON.stringify(data));
    }

    ListModel {
        id: list
    }
}
