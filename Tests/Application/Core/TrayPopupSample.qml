/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4

import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Blocks 1.0
import Application.Core 1.0
import Application.Controls 1.0

import QtQuick.Window 2.2

import Dev 1.0

import "../Widgets"

Item {
    id: root

    width: 1000
    height: 600

    property int fakePopupIndex: 0

    Component.onCompleted: TrayPopup.rootWindow = root;

    RequestServices {
        onReady: {
            App.activateGame(App.serviceItemByGameId("92"));
            showPopupTimer.start();
        }
    }

    Row {
        x: 10
        y: 10

        spacing: 10

        Button {
            text: "show many"
            onClicked:  {
                var gameItem = App.serviceItemByGameId("92");
                var popUpOptions;

                popUpOptions = {
                    gameItem: gameItem,
                    //destroyInterval: 5000,
                    buttonCaption: "Играть!",
                    message: "Зарубись прям тут!"
                };

                TrayPopup.showPopup(gameDownloadingPopup2, popUpOptions, 'fakePopup ' + root.fakePopupIndex);
                root.fakePopupIndex++;
            }
        }

        Button {
            text: "show single"
            onClicked:  {
                var gameItem = App.serviceItemByGameId("92");
                var popUpOptions;

                popUpOptions = {
                    gameItem: gameItem,
                    destroyInterval: 5000,
                    buttonCaption: "Играть!",
                    message: "Зарубись прям тут!"
                };

                TrayPopup.showPopup(gameDownloadingPopup, popUpOptions, 'gameDownloading' + gameItem.serviceId);
            }
        }

        Button {
            text: "hide fakePopup 1"
            onClicked: TrayPopup.hidePopup('fakePopup 1')
        }
    }

    Timer {
        id: showPopupTimer

        repeat: false
        interval: 2000
        onTriggered:  {
            return;

            var gameItem = App.serviceItemByGameId("92");
            var popUpOptions;

            popUpOptions = {
                gameItem: gameItem,
                destroyInterval: 5000,
                buttonCaption: "Играть!",
                message: "Зарубись прям тут!"
            };

            TrayPopup.showPopup(gameDownloadingPopup, popUpOptions, 'gameDownloading' + gameItem.serviceId);
        }
    }

    Component {
        id: gameDownloadingPopup2

        TrayPopupBase {
            id: tt

            property bool small : true;
            width: 240
            height: small ? 100 : 300

            Rectangle {
                anchors.fill: parent
                color: "red"
            }

            Button {
                text: "qweqweqwe"
                onClicked: tt.small = !tt.small;
            }

            onAnywhereClicked: console.log('anyware clicked')
            onTimeoutClosed: console.log('timeoute closed')
        }
    }

    Component {
        id: gameDownloadingPopup

        GamePopup {
            id: popUp

            onPlayClicked: console.log('play clicked')
            onCloseButtonClicked: console.log('close clicked')
            onAnywhereClicked: console.log('anyware clicked')
            onTimeoutClosed: console.log('timeoute closed')
        }
    }

}
