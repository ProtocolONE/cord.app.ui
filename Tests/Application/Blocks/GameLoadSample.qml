/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import Application.Blocks.GameLoad 1.0 as GameLoad

Rectangle {
    width: 800
    height: 800
    color: '#111111'

    MouseArea {
        anchors.fill: parent
        onClicked: gameLoadMain.visible = true;
    }

    GameLoad.GameLoad {
        id: gameLoadMain

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
        onClose: {
            visible = false;
            console.log('close');
        }
    }
}
