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

        interval: root.gameNetAvailable ? 30000 : 5000
        repeat: true
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
        property variant checkList: [
            'http://google.ru',
            'http://wordpress.com',
            'http://ya.ru',
            'http://baidu.com',
            'http://mail.ru',
            'http://yahoo.com',
            'http://www.gismeteo.ru',
            'http://bing.com',
            'http://rutube.ru',
            'http://vk.com',
            'http://live.com',
            'http://liveinternet.ru',
            'http://twitter.com',
            'http://wikipedia.org',
            'http://youtube.com',
            'http://i.ua',
            'http://www.facebook.com/',
            'http://myspace.com',
            'http://ukr.net',
            'http://blogspot.com',
            'http://ebay.ru',
            'http://skype.com'
        ]

        function checkInternet() {
            isUrlAvailable(checkList[++currentIndex % maxIndex], function(isAvailable) {
                if (!isAvailable && ++failCount < 3) {
                    checkInternet();
                    return;
                }

                failCount = 0;
                root.internetAvailable = isAvailable;
                inetCheck.restart();
            });
        }

        function checkGameNet() {
            isUrlAvailable('http://gamenet.ru', function(isAvailable) {
                root.gameNetAvailable = isAvailable;
            });
        }

        function isUrlAvailable(url, fn) {
            var http = new XMLHttpRequest();
            http.onreadystatechange = function() {
                if (http.readyState !== XMLHttpRequest.DONE) {
                    return;
                }

                fn(http.status > 0 && http.status !== 404)
            };

            http.open('HEAD', url);
            http.send();
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
