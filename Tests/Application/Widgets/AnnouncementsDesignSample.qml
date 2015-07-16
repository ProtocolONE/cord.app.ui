import QtQuick 2.4

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core 1.0
import Dev 1.0

import "../../../Application/Blocks"
import "../../../Application/Widgets/Announcements"

//  ChatNotify, используемый в оверлее
import "../../../Application/Widgets/Overlay/View/Chat"

Rectangle {
    id: sampleRoot

    width: 800
    height: 600

    color: "#DDDDDD"

    function getGameItem() {
        //  BS
        return {
            "gameId":71,
            "serviceId":"300003010000000000",
            "name":"BS.ru",
            "gaName":"BloodAndSoul",
            "gameType":"standalone",
            "genre":"MMORPG",
            "genreId":3,
            "genrePosition":1,
            "imageSmall":"https://images.gamenet.ru/pics/app/service/1421682897544.png",
            "imageHorizontalSmall":"https://images.gamenet.ru/pics/app/service/1418739837872.png",
            "imageLogoSmall":"https://images.gamenet.ru/pics/app/service/1418739840565.png",
            "imagePopupArt":"https://images.gamenet.ru/pics/app/service/1418739843767.png",
            "forumUrl":"https://forum.gamenet.ru/forumdisplay.php?f=4",
            "guideUrl":"/games/bs/guides/",
            "blogUrl":"/games/bs/blog/",
            "licenseUrl":"/games/bs/rules/",

            "maintenanceProposal1":"300002010000000000",
            "maintenanceProposal2":"300012010000000000",

            "logoText":"Романтическая игра",
            "aboutGame":"Мочи козлов в BS!!!",

            "miniToolTip":"Это тупо БС",
            "shortDescription":"БС епта",

            "secondAllowed":true,

            "isPublishedInApp":true,
            "isRunnable":true,
            "iconInApp":"https://images.gamenet.ru/pics/app/service/1421926626182.ico",
            "typeShortcut":"",

            "sortPositionInApp":4,
            "hasOverlay":true,

            "socialNet":[{"id":"vk","name":"VK","link":"http://vk.com/bloodandsoul"},{"id":"fb","name":"Facebook","link":""},{"id":"ok","name":"?????????????","link":""},{"id":"mm","name":"??????","link":""},{"id":"gp","name":"Google+","link":""},{"id":"tw","name":"Twitter","link":""},{"id":"yt","name":"YouTube","link":"http://www.youtube.com/bloodandsoulru"}],
            "backgroundInApp":"https://images.gamenet.ru/pics/app/service/1432643400180.jpg"
        };

    }


    function showArtPopup() {
        var gameItem = getGameItem();

        var page = ('/silenceMode/reminder/art/%1').arg("300003010000000000")

        var popupOptions = {
            gameItem: gameItem,
            buttonCaption: "Играть",
            message: "Игра установлена, но вы не разу не пробовали играть"
        };

        var trayPopup = TrayPopup.showPopup(artPopup, popupOptions, "artPopup");
    }


    function showGamePopup() {
        var gameItem = getGameItem();

        var page = ('/silenceMode/reminder/art/%1').arg("300003010000000000")

        var popupOptions = {
            gameItem: gameItem,
            buttonCaption: "Играть",
            message: "Не жмись, купи очередной ненужный артефакт!",
            announceItem: "645"
        };

        var trayPopup = TrayPopup.showPopup(announceGameItemPopUp, popupOptions, "gamePopup");
    }

    Component {
        id: artPopup

        ArtPopup {
        }
    }

    Component {
        id: announceGameItemPopUp

        GamePopup {
            id: announcePopUp

            property variant announceItem
        }
    }

    Row {
        spacing: 10

        Button {
            width: 200
            height: 30
            text: "Art popup"
            onClicked: {
                sampleRoot.showArtPopup();
            }
        }

        Button {
            width: 200
            height: 30
            text: "Game item popup"
            onClicked: {
                sampleRoot.showGamePopup();
            }
        }

        Button {
            width: 200
            height: 30
            text: "Overlay ChatNotify"
            onClicked: {
                chatNotify.opacity = 1;
                notifyTimerClose.start();
            }
        }
    }

    Timer {
        id: notifyTimerClose

        interval: 5000
        onTriggered: chatNotify.opacity = 0;
    }

    ChatNotify {
        id: chatNotify

        width: 240
        height: 92

        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 5
        }

        opacity: 0
        text: qsTr("Чтобы открыть чат GameNet используете хоткей %1").arg("Ctrl+Alt+Del")

        Behavior on opacity { NumberAnimation { duration: 200 } }

        MouseArea {
            anchors.fill: parent
            onClicked: chatNotify.opacity = 0;
        }
    }
}
