/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1

import "Helper.js" as Js
import "../../js/restapi.js" as RestApi
import "../../js/Core.js" as Core

Item {
    property variant currentItem: Core.currentGame()
    property int index

    function filter() {
        if (!currentItem) {
            return;
        }

        Js.gameFacts = Js.allFacts.filter(function(e) {
            return e.gameId == currentItem.gameId;
        });

        index = -1;
        switchAnim.complete();

        if (Js.gameFacts.length > 0) {
            switchAnim.start();
        } else {
            switchToEmptyAnim.start();
        }
    }

    function formatNumber(num) {
        var str = num.toString()
            , count = str.length % 3
            , total = (str.length / 3)|0
            , result = str.substr(0, count)
            , i = 0;

        while(i < total) {
            result += " " + str.substr(count + 3 * i++, 3);
        }

        return result;
    }

    function refreshText() {
        index = (index + 1) % Js.gameFacts.length;
        value.text = formatNumber(Js.gameFacts[index].value);
        text.text = Js.gameFacts[index].text;
    }

    implicitWidth: 450
    implicitHeight: 30

    onCurrentItemChanged: filter()

    Row {
        id: textRow

        spacing: 4
        opacity: 0
        anchors.fill: parent

        Text {
            id: value

            anchors.verticalCenter: textRow.verticalCenter
            opacity: 0.8
            color: "#FFFFFF"
            font.pixelSize: 30;
        }

        Text {
            id: text

            anchors { verticalCenter: textRow.verticalCenter; verticalCenterOffset: 6 }
            opacity: 0.8
            color: "#FFFFFF"
            font.pixelSize: 16;
        }
    }

    SequentialAnimation {
        id: switchAnim

        ScriptAction { script: showNextFact.stop() }
        NumberAnimation { target: textRow; property: "opacity"; to: 0; duration: 250 }
        ScriptAction { script: refreshText() }
        NumberAnimation { target: textRow; property: "opacity"; to: 1; duration: 250 }
        ScriptAction {
            script: {
                if (Js.gameFacts.length > 1) {
                    showNextFact.restart()
                }
            }
        }
    }

    Timer {
        id: showNextFact

        repeat: false
        interval: 5000
        onTriggered: switchAnim.start();
    }

    SequentialAnimation {
        id: switchToEmptyAnim

        ScriptAction { script: showNextFact.stop() }
        NumberAnimation { target: textRow; property: "opacity"; to: 0; duration: 250 }
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

                Js.allFacts = response.facts;
                filter();
            });
        }
    }
}
