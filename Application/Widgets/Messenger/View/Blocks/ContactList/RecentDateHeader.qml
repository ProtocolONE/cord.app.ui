import QtQuick 1.1
import Tulip 1.0

import "../../../../../Core/Styles.js" as Styles

Item {
    property alias caption: captionText.text

    implicitWidth: 100
    implicitHeight: 33

    Column {
        anchors.fill: parent

        Rectangle {
            height: 1
            width: parent.width
            color: Qt.lighter(groupTitle.color, Styles.style.lighterFactor)
        }

        Rectangle {
            id: groupTitle

            width: parent.width
            height: 31
            color: Styles.style.messengerRecentContactGroupBackground

            Text {
                id: captionText

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                }

                font {
                    family: "Arial"
                    pixelSize: 12
                }

                color: Styles.style.messengerRecentContactGroupName
            }
        }

        Rectangle {
            height: 1
            width: parent.width
            color: Qt.darker(groupTitle.color, Styles.style.darkerFactor)
        }

    }
}
