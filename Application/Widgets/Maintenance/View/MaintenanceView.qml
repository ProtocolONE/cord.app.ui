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
import GameNet.Controls 1.0

import "../../../../Application/Core/App.js" as AppJs

WidgetView {
    id: root

    property int interval: AppJs.currentGame().maintenanceInterval

    width: 590
    height: 150

    Rectangle {
        anchors.fill: parent
        color: '#082135'
    }

    Row {
        anchors { fill: parent; margins: 10 }
        spacing: 10

        Item {
            width: 160
            height: 130

            Rectangle {
                anchors { fill: parent  }

                color: '#082135'

                border { color: '#e53b24'; width: 2 }
            }

            Text {
                anchors {
                    baseline: parent.top;
                    baselineOffset: 25;
                    horizontalCenter: parent.horizontalCenter
                }
                text: qsTr("MAINTENANCE_LABEL")
                color: '#fff9ea'
                font { pixelSize: 14 }
            }

            Rectangle {
                anchors {
                    baseline: parent.top
                    baselineOffset: 38
                    left: parent.left
                    right: parent.right
                    margins: 8
                }

                color: '#162f43'
                height: 1
            }

            Text {
                anchors { baseline: parent.top; baselineOffset: 75; horizontalCenter: parent.horizontalCenter }
                text: qsTr("MAINTENANCE_LABEL_END")
                color: '#8ba1b6'
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

                text: qsTr("MAINTENANCE_PROPOSAL_GAME_TEXT").arg(AppJs.currentGame().name)
                color: '#8ea4b9'
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font { family: 'Arial'; pixelSize: 16 }
            }

            Row {
                width: parent.width
                height: 90

                spacing: 10

                GameItem {
                    gameItem: AppJs.serviceItemByServiceId(AppJs.currentGame().maintenanceProposal1)

                    onActivate: {
                        App.navigate('mygame');
                        App.activateGameByServiceId(serviceItem.serviceId)
                    }
                }

                GameItem {
                    gameItem: AppJs.serviceItemByServiceId(AppJs.currentGame().maintenanceProposal2)

                    onActivate: {
                        App.navigate('mygame');
                        App.activateGameByServiceId(serviceItem.serviceId)
                    }
                }
            }
        }
    }
}
