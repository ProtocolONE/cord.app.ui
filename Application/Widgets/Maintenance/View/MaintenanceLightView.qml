import QtQuick 2.4

import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0

WidgetView {
    id: root

    property variant gameItem: App.currentGame()
    property int interval: root.gameItem ? root.gameItem.maintenanceInterval : 0

    implicitWidth: 590
    implicitHeight: 112

    QtObject {
        id: d

        property bool valid: root.gameItem && root.gameItem.maintenanceSettings

        property string title: (d.valid ? root.gameItem.maintenanceSettings.title : "")
                               || qsTr("MAINTENANCE_LIGHT_LABEL")

        property string newsTitle: (d.valid ? root.gameItem.maintenanceSettings.newsTitle : "") || ""
        property string newsText: (d.valid ? root.gameItem.maintenanceSettings.newsText : "") || ""
        property string newsLink: (d.valid ? root.gameItem.maintenanceSettings.newsLink : "") || ""

        property bool isNewsView: !!d.newsText && !!d.newsTitle
        property bool hasLink: !!d.newsLink
    }

    ContentBackground {}

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
                    anchors.fill: parent
                    color: "#00000000"
                    border { color: Styles.textAttention; width: 2 }
                }

                Text {
                    anchors {
                        baseline: parent.top;
                        baselineOffset: 22
                    }

                    text: d.title
                    color: Styles.lightText
                    font { pixelSize: 14 }
                    width: parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignHCenter
                    height: 36
                    clip: true
                }

                ContentStroke {
                    anchors {
                        baseline: parent.top
                        baselineOffset: 52
                        left: parent.left
                        right: parent.right
                        margins: 8
                    }
                }

                Row {
                    id: row

                    anchors {
                        baseline: parent.bottom
                        baselineOffset: -50 + 16
                        horizontalCenter: parent.horizontalCenter
                    }
                    spacing: 7

                    function format(value) {
                        if (value < 10) {
                            return '0' + value;
                        }

                        return value;
                    }

                    property bool hasDay: Math.floor(root.interval / 3600) >= 24

                    TimeTextLabel {
                        visible: row.hasDay
                        firstText: Math.floor(root.interval / 3600 / 24);
                        secondText: qsTr("д.")
                    }

                    TimeTextLabel {
                        firstText: Math.floor((root.interval % (3600*24))/ 3600);
                        secondText: qsTr("HOUR_MAINTENANCE_LABEL")
                    }

                    TimeTextLabel {
                        firstText: row.format(Math.floor((root.interval % 3600) / 60));
                        secondText: qsTr("MINUTE_MAINTENANCE_LABEL")
                    }

                    TimeTextLabel {
                        visible: !row.hasDay
                        firstText: row.format(root.interval % 60)
                        secondText: qsTr("SECONDS_MAINTENANCE_LABEL")
                    }

                }
            }

            Item {
                id: proposalRect

                width: 390
                height: parent.height
                visible: !d.isNewsView

                ContentStroke {
                    anchors.fill: parent
                }

                property variant proposalGameItem: App.serviceItemByServiceId(root.gameItem ?
                                                                                  root.gameItem.maintenanceProposal1 : '')

                Row {
                    anchors { fill: parent; margins: 10 }
                    spacing: 10

                    Image {
                        width: 70
                        height: 70

                        source: proposalRect.proposalGameItem && proposalRect.proposalGameItem.imageSmall ?
                                proposalRect.proposalGameItem.imageSmall : ''
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
                            color: Styles.textBase
                            font { family: 'Arial'; pixelSize: 14 }
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        }

                        Text {
                            anchors {
                                bottom: parent.bottom
                            }
                            text: proposalRect.proposalGameItem ? proposalRect.proposalGameItem.name : ''
                            color: Styles.menuText
                            font { family: 'Arial'; pixelSize: 18 }
                        }
                    }

                }

                CursorMouseArea {
                    anchors { fill: parent }
                    onClicked: {
                        var currentGame = root.gameItem;
                        var proposalGameItem = proposalRect.proposalGameItem;

                        if (!currentGame) {
                            return;
                        }

                        if (!proposalGameItem) {
                            return;
                        }

                        App.activateGameByServiceId(proposalGameItem.serviceId);
                        SignalBus.navigate('mygame', '');

                        if (proposalGameItem.gameType === "browser") {
                            App.downloadButtonStart(proposalGameItem.serviceId);
                        }

                        Ga.trackEvent('Maintenance Light', 'play', proposalGameItem.gaName);
                    }
                }
            }

            Item {
                id: newsRect

                width: 390
                height: parent.height
                visible: d.isNewsView
                clip: true

                Text {
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }

                    width: parent.width
                    text: d.newsTitle
                    color: Qt.darker(Styles.titleText, mouser.containsMouse ? 1.5: 0)
                    font { family: 'Arial'; pixelSize: 18 }
                    wrapMode: Text.NoWrap
                    clip: true
                }

                Text {
                    anchors {
                        fill: parent
                        topMargin: 30
                    }

                    text: d.newsText
                    color: Qt.darker(Styles.infoText, mouser.containsMouse ? 1.5: 0)
                    font { family: 'Arial'; pixelSize: 13 }
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    clip: true
                    elide: Text.ElideRight
                    lineHeight: 20
                    lineHeightMode: Text.FixedHeight
                }

                CursorMouseArea {
                    id: mouser

                    visible: d.hasLink
                    anchors { fill: parent; }
                    onClicked: App.openExternalUrl(d.newsLink)
                }
            }
        }
    }
}
