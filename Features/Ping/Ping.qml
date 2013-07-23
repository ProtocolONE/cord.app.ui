/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**
** @author Nikolay Bindarenko <nikolay.bondarenko@syncopate.ru>
** @see https://jira.gamenet.ru:8443/browse/QGNA-180
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0
import "../../Blocks" as Blocks

Blocks.MoveUpPage {
    id: root

    property bool internetAvailable: true
    property bool gameNetAvailable: true
    property bool mustBeShown: !internetAvailable || !gameNetAvailable

    function start() {
        gameNetCheck.start();
        inetCheck.start();
    }

    openHeight: height
    openBackgroundOpacity: 0.85
    onMustBeShownChanged: {
        if (mustBeShown) {
            root.openMoveUpPage();
        } else {
            root.closeMoveUpPage();
        }
    }

    Timer {
        id: gameNetCheck

        interval: d.gamenetFailCount == 0 ? 30000 : 5000
        repeat: false
        running: root.internetAvailable
        onTriggered: d.checkGameNet()
    }

    Timer {
        id: inetCheck

        interval: root.internetAvailable ? 5000 : 1000
        repeat: false
        onTriggered: d.checkInternet();
    }

    QtObject {
        id: d

        property int currentIndex: (Math.random() * checkList.length) % checkList.length
        property int maxIndex: checkList.length
        property int failCount: 0
        property int gamenetFailCount: 0
        property variant checkList: [
            'google.ru',
            'wordpress.com',
            'ya.ru',
            'baidu.com',
            'mail.ru',
            'yahoo.com',
            'www.gismeteo.ru',
            'bing.com',
            'rutube.ru',
            'vk.com',
            'live.com',
            'liveinternet.ru',
            'twitter.com',
            'wikipedia.org',
            'youtube.com',
            'i.ua',
            'www.facebook.com',
            'myspace.com',
            'ukr.net',
            'blogspot.com',
            'ebay.ru',
            'skype.com'
        ]

        function checkInternet() {
            inetCheck.stop();
            ping.start(checkList[++currentIndex % maxIndex]);
        }

        function checkGameNet() {
            gameNetPing.start('test.gamenet.ru');
        }
    }

    PingEx {
        id: ping

        onSuccess: {
            d.failCount = 0;
            root.internetAvailable = true;
            inetCheck.restart();
        }

        onFailed: {
            if (++d.failCount < 3) {
                d.checkInternet();
                return;
            }

            root.internetAvailable = false;
            inetCheck.restart();
        }
    }

    PingEx {
        id: gameNetPing

        onSuccess: {
            d.gamenetFailCount = 0;
            root.gameNetAvailable = true;
            gameNetCheck.restart();
        }

        onFailed: {
            if (++d.gamenetFailCount < 3) {
                d.checkGameNet();
                return;
            }

            root.gameNetAvailable = false;
            gameNetCheck.restart();
        }
    }

    Column {
        spacing: 20
        anchors {
            top: parent.top; topMargin: 26;
            left: parent.left; leftMargin: 42;
            right: parent.right; rightMargin: 42
        }

        Text {
            id: headerTitle

            property int index: 0

            function repeat(n) {
                var r = '';
                for (var a = 0; a < n; a++) {
                    r += '.';
                }
                return r;
            }

            text: "<b>" + qsTr("HEADER_TITLE") + repeat(headerTitle.index) + "</b>"
            font { family: "Segoe UI Light"; pixelSize: 42 }
            color: "#ffffff"
            textFormat: Text.StyledText

            Timer {
                running: root.isOpen
                repeat: true
                interval: 500
                onTriggered: headerTitle.index = ++headerTitle.index % 4
            }
        }

        Text {
            anchors { left: parent.left; right: parent.right }
            text: (root.internetAvailable && !root.gameNetAvailable)
                  ? qsTr("MESSAGE_GAMENET_UNAVAILABLE")
                  : qsTr("MESSAGE_INTERNET_UNAVAILABLE")

            font { family: "Segoe UI Light"; pixelSize: 16 }
            color: "#ffffff"
            textFormat: Text.StyledText
            wrapMode: Text.WordWrap
        }
    }
}
