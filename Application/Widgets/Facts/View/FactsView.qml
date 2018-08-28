import QtQuick 2.4

import GameNet.Components.Widgets 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0
import "FactsView.js" as FactsView

WidgetView {
    id: root

    property variant currentItem: AppJs.currentGame()
    property int index
    property bool hasFacts: false

    function filter() {
        var allFacts = model.getAllFacts();
        showNextFact.stop();

        if (!root.currentItem) {
            return;
        }

        FactsView.filteredFacts = allFacts.filter(function(e) {
            return e.gameId == currentItem.gameId;
        });

        root.index = -1;
        root.hasFacts = FactsView.filteredFacts.length > 0;

        if (FactsView.filteredFacts.length > 0) {
            switchAnim.start();
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
    implicitHeight: hasFacts ? 40 : 0

    clip: true
    onCurrentItemChanged: filter()

    Connections {
        target: model
        onFactsChanged: filter();
    }

    ContentBackground {
        anchors.fill: parent
    }

    Rectangle {
        anchors.fill: parent

        opacity: 0.15
        color: Styles.light
    }

    Row {
        id: textRow

        spacing: 5
        anchors {
            leftMargin: 10
            fill: parent
        }

        Text {
            id: value

            anchors.verticalCenter: textRow.verticalCenter
            opacity: 0.8
            color: Styles.textAttention
            font { family: "Open Sans Light"; pixelSize: 30 }
        }

        Text {
            id: text

            anchors.verticalCenter: textRow.verticalCenter
            opacity: 0.8
            color: Styles.lightText
            font { family: "Open Sans Light"; pixelSize: 20 }
        }
    }

    SequentialAnimation {
        id: switchAnim

        ScriptAction { script: {
                root.hasFacts = FactsView.filteredFacts.length > 0;
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
}
