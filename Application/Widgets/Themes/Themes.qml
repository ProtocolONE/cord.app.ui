/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4

import Tulip 1.0
import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0

import Application.Core 1.0

WidgetModel {
    id: root

    property alias dataModel: list

    Connections {
        target: SignalBus
        onAuthDone: {
            console.log('Query themes');
            RestApi.Core.execute('games.getThemes', {}, false, dataReceived, errorOccured);
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
