import QtQuick 1.1

import Tulip 1.0
import GameNet.Controls 1.0

import "../../../Models/Messenger.js" as Messenger
import "../../../../../Core/Styles.js" as Styles

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
            color: Styles.style.dark
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
                color: Styles.style.light
                width: 1
            }

            opacity: root.containsMouse ? 1 : 0.5
        }
    }

    Item {
        anchors.fill: parent
        visible: root.checked

        Rectangle {
            color: Styles.style.checkedButtonActive
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
                color: Styles.style.dark
                opacity: 0.50
            }

            Rectangle {
                color: "#00000000"
                anchors {
                    fill: parent
                    rightMargin: 1
                    bottomMargin: 1
                }

                border {
                    color: Styles.style.checkedButtonActive
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
