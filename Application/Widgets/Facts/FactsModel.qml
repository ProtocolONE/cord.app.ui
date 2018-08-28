import QtQuick 2.4
import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0

import Application.Core 1.0
import "FactsModel.js" as FactsModel

WidgetModel {
    id: root

    property int counter: 0
    signal factsChanged();

    function getAllFacts() {
        return FactsModel.allFacts;
    }

    Timer {
        interval: 900000 //each 30 minutes
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            RestApi.Games.getFacts(function(response) {
                if (!response.hasOwnProperty('facts')) {
                    return;
                }

                if (response.facts.length === 0) {
                    return;
                }

                FactsModel.allFacts = response.facts;
                root.factsChanged();
            });
        }
    }
}
