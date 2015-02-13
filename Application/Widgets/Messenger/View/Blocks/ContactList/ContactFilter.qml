import QtQuick 1.1
import GameNet.Controls 1.0

import "../../../../../Core/Styles.js" as Styles

Item {
    id: root

    property bool showAll: true

    QtObject {
        id: d

        function textColor(enabled, hover) {
             if (!enabled) {
                 return Styles.style.messengerContactFilterDisabledButtonText;
             }

             return hover
                     ? Styles.style.messengerContactFilterHoverButtonText
                     : Styles.style.messengerContactFilterButtonText;
        }
    }

    ButtonStyleColors {
        id: selectedTab

        normal: Styles.style.messengerContactFilterSelectedButtonNormal
        hover: Styles.style.messengerContactFilterSelectedButtonHover
        disabled: Styles.style.messengerContactFilterSelectedButtonDisabled
    }

    ButtonStyleColors {
        id: unSelectedTab

        normal: Styles.style.messengerContactFilterUnselectedButtonNormal
        hover: Styles.style.messengerContactFilterUnselectedButtonHover
        disabled: Styles.style.messengerContactFilterUnselectedButtonDisabled
    }

    Row {
        anchors.fill: parent

        Button {
            id: allButton

            width: (root.width - 1) / 2
            height: parent.height

            style: selectedTab
            textColor: d.textColor(allButton.enabled, allButton.containsMouse)

            text: qsTr("CONTACT_FILTER_ALL") // "Все"
            fontSize: 12

            onClicked: root.showAll = true;

            Behavior on textColor {
                PropertyAnimation { duration: 250 }
            }
        }

        Rectangle {
            width: 1
            height: parent.height
            color: Styles.style.messengerContactFilterBorder
        }

        Button {
            id: playingButton

            width: (root.width - 1) / 2
            height: parent.height
            style: unSelectedTab
            textColor: d.textColor(playingButton.enabled, playingButton.containsMouse)

            text: qsTr("CONTACT_FILTER_IN_GAME") // "В игре"
            fontSize: 12
            onClicked: root.showAll = false;

            Behavior on textColor {
                PropertyAnimation { duration: 250 }
            }
        }
    }

    Rectangle {
        anchors {
            fill: parent
            rightMargin: 1
            bottomMargin: 1
        }

        color: "#00000000"
        border {
            color: Styles.style.messengerContactFilterBorder
            width: 1
        }

        radius: 1
    }

    StateGroup {
        id: filterState

        states: [
            State {
                name: "All"
                when: root.showAll
                PropertyChanges { target: allButton; style: selectedTab; enabled: false }
                PropertyChanges { target: playingButton; style: unSelectedTab; enabled: true }
            },
            State {
                name: "Playing"
                when: !root.showAll
                PropertyChanges { target: allButton; style: unSelectedTab; enabled: true }
                PropertyChanges { target: playingButton; style: selectedTab; enabled: false }
            }
        ]
    }
}
