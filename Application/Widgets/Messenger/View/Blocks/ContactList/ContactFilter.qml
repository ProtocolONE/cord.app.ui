import QtQuick 1.1
import GameNet.Controls 1.0

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

        Rectangle {
            width: 1
            height: parent.height
            color: Styles.style.light
            opacity: Styles.style.blockInnerOpacity
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

    Rectangle {
        anchors {
            fill: parent
            rightMargin: 1
            bottomMargin: 1
        }

        color: "#00000000"
        opacity: Styles.style.blockInnerOpacity
        border {
            color: Styles.style.light
            width: 1
        }

        radius: 1
    }
}
