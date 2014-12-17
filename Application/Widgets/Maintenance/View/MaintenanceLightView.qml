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
import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics
import "../../../Core/Styles.js" as Styles

WidgetView {
    id: root

    property variant gameItem: App.currentGame()
    property int interval: root.gameItem ? root.gameItem.maintenanceInterval : 0

    implicitWidth: 560
    implicitHeight: 112

    Rectangle {
        anchors.fill: parent
        color: Styles.style.maintenanceBackground
    }

    Item {
        anchors {
            fill: parent
            leftMargin: 15
            rightMargin: 15
            topMargin: 10
            bottomMargin: 10
        }

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

                width: 390
                height: parent.height

                color: '#253149'

                property variant proposalGameItem: App.serviceItemByServiceId(root.gameItem ?
                                                                                  root.gameItem.maintenanceProposal1 : '')

                Row {
                    anchors { fill: parent; margins: 10 }
                    spacing: 10

                    Image {
                        width: 70
                        height: 70

                        source: proposalRect.proposalGameItem && proposalRect.proposalGameItem.imageSmall ?
                                App.host() + proposalRect.proposalGameItem.imageSmall : ''
                    }

                    Item {
                        height: parent.height
                        width: parent.width - 80

                        Text {
                            anchors {
                                top: parent.top
                            }

                            width: parent.width
                            text: qsTr("MAINTENANCE_LIGHT_PROSOSAL_START_TEXT").arg(proposalRect.proposalGameItem ?
                                                                                        proposalRect.proposalGameItem.miniToolTip : '')
                            color: '#8fa1b7'
                            font { family: 'Arial'; pixelSize: 14 }
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        }

                        Text {
                            anchors {
                                bottom: parent.bottom
                            }
                            text: proposalRect.proposalGameItem ? proposalRect.proposalGameItem.name : ''
                            color: '#ffffff'
                            font { family: 'Arial'; pixelSize: 18 }
                        }
                    }
                }

                CursorMouseArea {
                    anchors { fill: parent }
                    onClicked: {
                        App.navigate('mygame');

                        if (proposalRect.proposalGameItem) {
                            App.activateGameByServiceId(proposalRect.proposalGameItem.serviceId);
                        }

                        GoogleAnalytics.trackEvent('/Maintenance/',
                                                   'Game ' + root.gameItem.gaName,
                                                   'Activate Game ' + proposalRect.proposalGameItem.gaName,
                                                   'MaintenanceLightView');
                    }
                }

            }
        }
    }
}
