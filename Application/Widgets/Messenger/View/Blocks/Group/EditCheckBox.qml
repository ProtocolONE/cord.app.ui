import QtQuick 2.4

import Tulip 1.0
import GameNet.Controls 1.0

import "../../../Models/Messenger.js" as Messenger
import Application.Core 1.0
import Application.Core.Styles 1.0

Item {
    id: root

    property bool checked: false
    property bool containsMouse: false

    implicitWidth: 32
    implicitHeight: 32

    Item {
        anchors.fill: parent
        visible: !root.checked

        Rectangle {
            color: Styles.dark
            opacity: 0.68
            anchors.fill: parent
        }

        Rectangle {
            color: "#00000000"
            anchors {
                fill: parent
                margins: 8
            }

            border {
                color: Styles.light
                width: 1
            }

            opacity: root.containsMouse ? 1 : 0.5
        }
    }

    Item {
        anchors.fill: parent
        visible: root.checked

        Rectangle {
            color: Styles.checkedButtonActive
            opacity: 0.68
            anchors.fill: parent
        }

        Item {
            anchors {
                fill: parent
                leftMargin: 8
                topMargin: 8
                rightMargin: 9
                bottomMargin: 9
            }

            Rectangle {
                anchors.fill: parent
                color: Styles.dark
                opacity: 0.50
            }

            Rectangle {
                color: "#00000000"
                anchors.fill: parent

                border {
                    color: Styles.checkedButtonActive
                    width: 1
                }
            }
        }

        Image {
            source: installPath + 'Assets/Images/Application/Widgets/Messenger/groupEditCheckBox.png'
            anchors.centerIn: parent
        }
    }
}
