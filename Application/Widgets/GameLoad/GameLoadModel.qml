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
import "../../Core/App.js" as App

WidgetModel {
    id: root

    property variant currentGame
    property string headerText: currentGame.statusText
    property int progress: currentGame.progress

    property string totalWantedDone
    property string totalWanted
    property string directTotalDownload
    property string peerTotalDownload
    property string payloadTotalDownload
    property string peerPayloadDownloadRate
    property string payloadDownloadRate
    property string directPayloadDownloadRate
    property string payloadUploadRate
    property string totalPayloadUpload

    Component.onCompleted: {
        root.currentGame = App.currentGame();
    }

    onCurrentGameChanged: {
        root.totalWantedDone = '0';
        root.totalWanted = '0';
        root.directTotalDownload = '0';
        root.peerTotalDownload = '0';
        root.payloadTotalDownload = '0';
        root.peerPayloadDownloadRate = '0';
        root.payloadDownloadRate = '0';
        root.directPayloadDownloadRate = '0';
        root.payloadUploadRate = '0';
        root.totalPayloadUpload = '0';
    }

    Connections {
        target: mainWindow

        ignoreUnknownSignals: true

        onDownloadProgressChanged: {
            if (root.currentGame && (serviceId != root.currentGame.serviceId)) {
                return;
            }

            root.totalWantedDone = totalWantedDone;
            root.totalWanted = totalWanted;
            root.directTotalDownload = directTotalDownload;
            root.peerTotalDownload = peerTotalDownload;
            root.payloadTotalDownload = payloadTotalDownload;
            root.peerPayloadDownloadRate = peerPayloadDownloadRate;
            root.payloadDownloadRate = payloadDownloadRate;
            root.directPayloadDownloadRate = directPayloadDownloadRate;
            root.payloadUploadRate = payloadUploadRate;
            root.totalPayloadUpload = totalPayloadUpload;
        }
    }
}
