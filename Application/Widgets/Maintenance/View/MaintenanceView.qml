import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

WidgetView {
    id: root

    property variant gameItem: App.currentGame()
    property int interval: root.gameItem ? root.gameItem.maintenanceInterval : 0

    width: 590
    height: 150

    ContentBackground {}

    Row {
        anchors { fill: parent; margins: 10 }
        spacing: 10

        Item {
            width: 160
            height: 130

            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                border { color: Styles.textAttention; width: 2 }
            }

            Text {
                anchors {
                    baseline: parent.top;
                    baselineOffset: 25;
                    horizontalCenter: parent.horizontalCenter
                }
                text: qsTr("MAINTENANCE_LABEL")
                color: Styles.lightText
                font { pixelSize: 14 }
            }

            ContentStroke {
                anchors {
                    baseline: parent.top
                    baselineOffset: 38
                    left: parent.left
                    right: parent.right
                    margins: 8
                }
            }

            Text {
                anchors { baseline: parent.top; baselineOffset: 75; horizontalCenter: parent.horizontalCenter }
                text: qsTr("MAINTENANCE_LABEL_END")
                color: Styles.textBase
                font { pixelSize: 14 }
            }


            Row {
                id: row

                anchors { baseline: parent.bottom; baselineOffset: -50; horizontalCenter: parent.horizontalCenter }
                spacing: 7

                function format(value) {
                    if (value < 10) {
                        return '0' + value;
                    }

                    return value;
                }

                TimeTextLabel {
                    firstText: Math.floor(root.interval / 3600);
                    secondText: qsTr("HOUR_MAINTENANCE_LABEL")
                }

                TimeTextLabel {
                    firstText: row.format(Math.floor((root.interval % 3600) / 60));
                    secondText: qsTr("MINUTE_MAINTENANCE_LABEL")
                }

                TimeTextLabel {
                    firstText: row.format(root.interval % 60)
                    secondText: qsTr("SECONDS_MAINTENANCE_LABEL")
                }
            }
        }

        Column {
            y: -4
            width: 590 - 160 - 20
            height: parent.height
            spacing: 10

            Text {
                width: parent.width - 30
                height: 35

                text: qsTr("MAINTENANCE_PROPOSAL_GAME_TEXT").arg(root.gameItem ? root.gameItem.name : "")
                color: Styles.textBase
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font { family: 'Arial'; pixelSize: 16 }
            }

            Row {
                width: parent.width
                height: 90

                spacing: 10

                GameItem {
                    currentGameItem: root.gameItem
                    maintenanceGameItem: App.serviceItemByServiceId(root.gameItem ?
                                                         root.gameItem.maintenanceProposal1 : '')

                }

                GameItem {
                    currentGameItem: root.gameItem
                    maintenanceGameItem: App.serviceItemByServiceId(root.gameItem ?
                                                         root.gameItem.maintenanceProposal2 : '')
                }
            }
        }
    }
}
