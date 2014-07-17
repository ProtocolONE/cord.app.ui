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
import "../../../../Application/Core/App.js" as AppJs
import "FactsView.js" as FactsView

WidgetView {
    id: root

    property variant currentItem: AppJs.currentGame()
    property int index
    property bool hasFacts: false

    function filter() {
        var allFacts = model.getAllFacts();
        if (!root.currentItem) {
            return;
        }

        FactsView.filteredFacts = allFacts.filter(function(e) {
            return e.gameId == currentItem.gameId;
        });

        root.index = -1;
        switchAnim.complete();

        if (FactsView.filteredFacts.length > 0) {
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
        root.index = (root.index + 1) % FactsView.filteredFacts.length;
        value.text = formatNumber(FactsView.filteredFacts[root.index].value);
        text.text = FactsView.filteredFacts[root.index].text;
    }

    implicitWidth: 590
    implicitHeight: hasFacts ? 50 : 0

    clip: true
    onCurrentItemChanged: filter()

    Connections {
        target: model
        onFactsChanged: filter();
    }

    Rectangle {
        anchors.fill: parent

        opacity: 0.3
        color: "#092135"
    }

    Row {
        id: textRow

        spacing: 10
        anchors {
            leftMargin: 10
            fill: parent
        }

        Text {
            id: value

            anchors.verticalCenter: textRow.verticalCenter
            opacity: 0.8
            color: "#ff6555"
            font { family: "Arial"; pixelSize: 30 }
        }

        Text {
            id: text

            anchors.verticalCenter: textRow.verticalCenter
            opacity: 0.8
            color: "#fafafa"
            font { family: "Arial"; pixelSize: 18 }
        }
    }

    SequentialAnimation {
        id: switchAnim

        ScriptAction { script: {
                root.hasFacts = true;
                showNextFact.stop()
            }
        }
        NumberAnimation { target: textRow; property: "opacity"; to: 0; duration: 250 }
        ScriptAction { script: refreshText() }
        NumberAnimation { target: textRow; property: "opacity"; to: 1; duration: 250 }
        ScriptAction {
            script: {
                if (FactsView.filteredFacts.length > 1) {
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
        ScriptAction { script: root.hasFacts = false }
    }
}
