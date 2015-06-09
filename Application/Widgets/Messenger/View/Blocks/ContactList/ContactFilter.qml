import QtQuick 1.1
import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../../../../Core/Styles.js" as Styles

Item {
    id: root

    property bool showAll: true

    Row {
        anchors.fill: parent

        ContactFilterButton {
            id: allButton

            width: Math.floor((root.width - 1) / 2)
            height: parent.height

            text: qsTr("CONTACT_FILTER_ALL") // "Все"

            enabled: !root.showAll
            onClicked: root.showAll = true;
        }

        ContentStroke {
            height: parent.height
        }

        ContactFilterButton {
            id: playingButton

            width: Math.floor((root.width - 1) / 2)
            height: parent.height
            text: qsTr("CONTACT_FILTER_IN_GAME") // "В игре"
            enabled: root.showAll
            onClicked: root.showAll = false;
        }
    }

    ContentThinBorder {}
}
