import QtQuick 1.1
import "../Blocks2/GameLoad" as GameLoad

Rectangle {
    width: 800
    height: 800
    color: '#111111'

    GameLoad.Main {
        anchors.centerIn: parent

        headerText: qsTr("GAMELOAD_STARTING_GAME_NAME_HEADER")
        bannerImageUrl: installPath + '/images/games/bs_icon_horizontal.png'

        totalWantedDone: '73316'
        totalWanted: '345345'
        directTotalDownload: '7457457'
        peerTotalDownload: '234234'
        payloadTotalDownload: '5623463463526'
        peerPayloadDownloadRate: '562346343526'
        payloadDownloadRate: '562323526'
        directPayloadDownloadRate: '66'
        payloadUploadRate: '345345'
        totalPayloadUpload: '534534'

        onPause: console.log('pause')
        onClose: console.log('close');
    }
}
