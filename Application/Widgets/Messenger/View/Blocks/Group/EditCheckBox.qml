import QtQuick 1.1

import Tulip 1.0
import GameNet.Controls 1.0

import "../../../Models/Messenger.js" as Messenger
import "../../../../../Core/Styles.js" as Styles


Item {
    id: root

    property bool checked: false

    width: 32
    height: 32

    Item {
        anchors.fill: parent
        visible: !root.checked

        Rectangle {
            color: Styles.style.messengerEditGroupCheckboxNotCheckedBackground
            opacity: 0.68
            anchors.fill: parent
        }

        Rectangle {
            color: "#00000000"
            anchors {
                fill: parent
                leftMargin: 8
                topMargin: 8
                rightMargin: 9
                bottomMargin: 9
            }

            border {
                color: Styles.style.messengerEditGroupCheckboxNotCheckedBorder
                width: 1
            }

            opacity: 0.74
        }
    }

    Item {
        anchors.fill: parent
        visible: root.checked

        Rectangle {
            color: Styles.style.messengerEditGroupCheckboxCheckedBackground
            opacity: 0.68
            anchors.fill: parent
        }

        Rectangle {
            color: Styles.style.messengerEditGroupCheckboxCheckedCenterBackground
            anchors {
                fill: parent
                leftMargin: 8
                topMargin: 8
                rightMargin: 9
                bottomMargin: 9
            }

            border {
                color: Styles.style.messengerEditGroupCheckboxCheckedBorder
                width: 1
            }

            opacity: 0.74
        }

        Image {
            source: installPath + 'Assets/Images/Application/Widgets/Messenger/groupEditCheckBox.png'
            anchors.centerIn: parent
        }
    }
}
