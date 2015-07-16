/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import GameNet.Core 1.0
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0
import Application.Blocks.Popup 1.0
import Application.Controls 1.0
import Application.Core 1.0

PopupBase {
    id: root

    property variant gameItem: model ? model.currentGame : null
    property bool isPause: false

    signal pause();

    onPause: {
        if (root.isPause) {
            App.downloadButtonStart(root.gameItem.serviceId);
            Ga.trackEvent('GameLoad', 'play', root.gameItem.gaName);
        } else {
            App.downloadButtonPause(root.gameItem.serviceId);
            Ga.trackEvent('GameLoad', 'pause', root.gameItem.gaName);
        }

        root.isPause = !root.isPause;
    }

    implicitWidth: Math.max(innerWidget.width + defaultMargins * 2, 630)
    title: qsTr("GAME_LOAD_VIEW_HEADER_TEXT").arg(App.currentGame().name)

    Connections {
        target: App.mainWindowInstance()

        ignoreUnknownSignals: true
        onDownloaderFinished: {
            if (service == App.currentGame().serviceId) {
                root.close();
            }
        }

        onSelectService: root.close();
    }

    onVisibleChanged: stateGroup.state = 'Normal';

    Component.onCompleted: {
        root.isPause = (root.gameItem.status === 'Paused');
    }

    Column {
        id: centerBlock

        spacing: 20

        anchors {
            left: parent.left
            right: parent.right
        }

        Column {
           width: parent.width
           spacing: 10

           Text {
               font {family: "Arial"; pixelSize: 14}
               smooth: true
               color: defaultTextColor
               text: model ? model.headerText : ""
           }

           Row {
               width: parent.width
               spacing: 6

               Item {
                   id: progressBarContainer

                   height: 22
                   width: parent.width - 100

                   ContentThinBorder{}

                   DownloadProgressBar {
                       anchors {
                           fill: parent
                           margins: 6
                       }

                       progress: model ? model.progress : 0
                   }
               }

               TextButton {
                   width: 100
                   text: !root.isPause ? qsTr("GAME_LOAD_PAUSE") : qsTr("GAME_LOAD_CONTINUE")
                   fontSize: 14
                   onClicked: root.pause();
               }
           }
        }

        TextButton {
            id: showStatButton

            text: qsTr("SHOW_STATISTICS")
            fontSize: 14
            analytics {
                category: 'GameLoad'
                action: 'details'
                label: root.gameItem ? root.gameItem.gaName : ""
            }
            onClicked: stateGroup.state = "Detailed";
        }

        ProgressWidget {
            id: progressWidget

            totalWantedDone: model ? model.totalWantedDone : 0
            totalWanted: model ? model.totalWanted : 0
            directTotalDownload: model ? model.directTotalDownload : 0
            peerTotalDownload: model ? model.peerTotalDownload : 0
            payloadTotalDownload: model ? model.payloadTotalDownload : 0
            peerPayloadDownloadRate: model ? model.peerPayloadDownloadRate : 0
            payloadDownloadRate: model ? model.payloadDownloadRate : 0
            directPayloadDownloadRate: model ? model.directPayloadDownloadRate : 0
            payloadUploadRate: model ? model.payloadUploadRate : 0
            totalPayloadUpload: model ? model.totalPayloadUpload : 0
        }

        PopupHorizontalSplit {
            visible: showStatButton.visible
        }

        WidgetContainer {
            id: innerWidget

            widget: root.gameItem ? root.gameItem.widgets.gameDownloading : ""
            visible: widget
        }
    }

    StateGroup {
        id: stateGroup

        state: 'Normal'
        states: [
            State {
                name: "Normal"
                when: stateGroup.state == "Normal" || root.visible == false
                PropertyChanges { target: progressWidget; visible: false }
                PropertyChanges { target: showStatButton; visible: true }
            },
            State {
                name: "Detailed"
                when: stateGroup.state == "Detailed"
                PropertyChanges { target: progressWidget; visible: true }
                PropertyChanges { target: showStatButton; visible: false }
            }
        ]
    }
}
