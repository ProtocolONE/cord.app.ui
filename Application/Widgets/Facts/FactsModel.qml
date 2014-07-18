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

import "../../Core/restapi.js" as RestApiJs
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
            RestApiJs.Games.getFacts(function(response) {
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
