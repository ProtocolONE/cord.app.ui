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
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import "../../../Core/App.js" as App
import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

WidgetView {
    id: root

    property variant gameItem: App.currentGame()
    property bool isPause: false

    signal pause();

    onPause: {
        if (root.isPause) {
            App.downloadButtonStart(root.gameItem.serviceId);

            GoogleAnalytics.trackEvent('/game/' + root.gameItem.gaName,
                                       'Game ' + root.gameItem.gaName, 'Play', 'Big Green');
        } else {
            App.downloadButtonPause(root.gameItem.serviceId);

            GoogleAnalytics.trackEvent('/game/' + root.gameItem.gaName,
                                       'Game ' + root.gameItem.gaName, 'Pause', 'Big Green');
        }

        root.isPause = !root.isPause;
    }

    implicitWidth: 630

    Connections {
        target: mainWindow

        ignoreUnknownSignals: true
        onDownloaderFinished: {
            if (service == App.currentGame().serviceId) {
                root.close();
            }
        }

        onSelectService: root.close();
    }

    Rectangle {
        anchors.fill: parent
        color: '#f0f5f8'
    }

    onVisibleChanged: stateGroup.state = 'Normal';

    Component.onCompleted: root.isPause = (root.gameItem.status === 'Paused');

    Column {
        anchors {
            fill: parent
            margins: 20
        }

        Item {
            id: headBlock

            width: parent.width
            height: 35

            HorizontalSplit {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                style: SplitterStyleColorsPrivate {}
            }

            Text {
                id: headText

                anchors {
                    top: parent.top
                    left: parent.left
                }

                font {
                    family: 'Arial'
                    pixelSize: 18
                }

                color: '#343537'
                smooth: true
                text: qsTr("GAME_LOAD_VIEW_HEADER_TEXT").arg(App.currentGame().name)
            }
        }

        Item {
            id: centerBlock

            width: parent.width

            Text {
                font {
                    family: "Arial"
                    pixelSize: 14
                }
                anchors {
                    left: parent.left
                    top: parent.top
                    topMargin: 15
                }

                smooth: true
                color: '#5d6f7b'
                text: model.headerText
            }

            Rectangle {
                width: 500
                height: 22
                color: '#00000000'
                border { color: '#e1e5e8' }

                anchors {
                    left: parent.left
                    top: parent.top
                    topMargin: 40
                }

                ProgressBar {
                    anchors {
                        fill: parent
                        margins: 6
                    }
                    style: ProgressBarStyleColors {
                        background: "#0d5144"
                        line: '#32cfb2'
                    }

                    progress: model.progress
                }

                TextButton {
                    anchors {
                        left: parent.right
                        leftMargin: 7
                        top: parent.top
                        topMargin: 3
                    }

                    text: !root.isPause ? qsTr("GAME_LOAD_PAUSE") : qsTr("GAME_LOAD_CONTINUE")
                    fontSize: 14
                    style: TextButtonStyle {}
                    onClicked: root.pause();
                }
            }

            TextButton {
                id: showStatButton

                anchors {
                    left: parent.left
                    top: parent.top
                    topMargin: 81
                }

                text: qsTr("SHOW_STATISTICS")
                fontSize: 14
                style: TextButtonStyle {}

                analytics: GoogleAnalyticsEvent {
                    page: '/GameLoad/'
                    category: 'Loading game ' + root.gameItem.gaName
                    action: 'Show game loading details'
                }

                onClicked: stateGroup.state = "Detailed";
            }

            ProgressWidget {
                id: progressWidget

                totalWantedDone: model.totalWantedDone
                totalWanted: model.totalWanted
                directTotalDownload: model.directTotalDownload
                peerTotalDownload: model.peerTotalDownload
                payloadTotalDownload: model.payloadTotalDownload
                peerPayloadDownloadRate: model.peerPayloadDownloadRate
                payloadDownloadRate: model.payloadDownloadRate
                directPayloadDownloadRate: model.directPayloadDownloadRate
                payloadUploadRate: model.payloadUploadRate
                totalPayloadUpload: model.totalPayloadUpload

                anchors {
                    left: parent.left
                    top: parent.top
                    topMargin: 83
                }
            }


            HorizontalSplit {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                style: SplitterStyleColorsPrivate {}
            }

            Item {
                anchors {
                    top: parent.bottom
                    topMargin: 20
                }
                width: 590
                height: 150

                WidgetContainer {
                    anchors.fill: parent
                    widget: root.gameItem.widgets.gameDownloading
                    visible: widget
                }
            }
        }

        StateGroup {
            id: stateGroup

            state: 'Normal'

            states: [
                State {
                    name: "Normal"
                    when: stateGroup.state == "Normal" || root.visible == false
                    PropertyChanges { target: centerBlock; height: 115 }
                    PropertyChanges { target: root; implicitHeight: 360 }
                    PropertyChanges { target: progressWidget; visible: false }
                    PropertyChanges { target: showStatButton; visible: true }
                },
                State {
                    name: "Detailed"
                    when: stateGroup.state == "Detailed"
                    PropertyChanges { target: centerBlock; height: 255 }
                    PropertyChanges { target: root; implicitHeight: 502 }
                    PropertyChanges { target: progressWidget; visible: true }
                    PropertyChanges { target: showStatButton; visible: false }
                }
            ]
        }
    }
}
