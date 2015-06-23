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
import Application.Blocks.Popup 1.0
import Application.Controls 1.0

import "../../../Core/App.js" as App
import "../../../Core/Styles.js" as Styles
import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

PopupBase {
    id: root

    property variant gameItem: model.currentGame
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

    implicitWidth: Math.max(innerWidget.width + defaultMargins * 2, 630)
    title: qsTr("GAME_LOAD_VIEW_HEADER_TEXT").arg(App.currentGame().name)

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
               text: model.headerText
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

                       progress: model.progress
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
        }

        PopupHorizontalSplit {
            visible: showStatButton.visible
        }

        WidgetContainer {
            id: innerWidget

            widget: root.gameItem.widgets.gameDownloading
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
