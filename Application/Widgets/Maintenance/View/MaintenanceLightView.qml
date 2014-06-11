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

import "../../../Core/App.js" as App

WidgetView {
    id: root

    property int interval: App.currentGame().maintenanceInterval

    width: 560
    height: 90

    Row {
        anchors { fill: parent }
        spacing: 10

        Item {
            width: 160
            height: 90

            Rectangle {
                anchors { fill: parent  }

                color: '#082135'

                border { color: '#e53b24'; width: 2 }
            }

            Text {
                anchors {
                    baseline: parent.top;
                    baselineOffset: 22
                }
                text: qsTr("MAINTENANCE_LIGHT_LABEL")
                color: '#fff9ea'
                font { pixelSize: 14 }
                width: parent.width
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                anchors {
                    baseline: parent.top
                    baselineOffset: 52
                    left: parent.left
                    right: parent.right
                    margins: 8
                }

                color: '#162f43'
                height: 1
            }

            Row {
                id: row

                anchors { baseline: parent.bottom; baselineOffset: -50 + 16; horizontalCenter: parent.horizontalCenter }
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

        Rectangle {
            id: proposalRect

            width: 590 - 160 - 20
            height: parent.height

            color: '#253149'

            property variant gameItem: App.serviceItemByServiceId(App.currentGame().maintenanceProposal1)

            Row {
                anchors { fill: parent; margins: 10 }
                spacing: 10

                Image {
                    width: 70
                    height: 70

                    source: installPath + proposalRect.gameItem.imageSmall
                }

                Item {
                    height: parent.height
                    width: parent.width - 80

                    CursorMouseArea {
                        anchors { fill: parent }
                        onClicked: App.activateGame(proposalRect.gameItem.serviceId);
                    }

                    Text {
                        anchors {
                            top: parent.top
                        }

                        width: parent.width
                        text: qsTr("MAINTENANCE_LIGHT_PROSOSAL_START_TEXT").arg(proposalRect.gameItem.miniToolTip)
                        color: '#8fa1b7'
                        font { family: 'Arial'; pixelSize: 14 }
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }

                    Text {
                        anchors {
                            bottom: parent.bottom
                        }

                        text: proposalRect.gameItem.name
                        color: '#ffffff'
                        font { family: 'Arial'; pixelSize: 18 }
                    }
                }



            }

        }
    }
}
