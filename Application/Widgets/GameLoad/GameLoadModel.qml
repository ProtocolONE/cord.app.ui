import QtQuick 2.4
import GameNet.Components.Widgets 1.0
import Application.Core 1.0

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
        target: App.mainWindowInstance()

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
