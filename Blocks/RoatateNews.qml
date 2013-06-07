/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1

import "../js/restapi.js" as RestApi
import "../js/DateHelper.js" as DateHelper
import "../js/Core.js" as Core

import "../Models" as Models
import "../Elements" as Elements

Item {
    signal openWebPage(string url)

    height: 64
    width: 930

    Image {
        id: back

        anchors { left: parent.left; top: parent.top }
        source : installPath + "images/news.png"
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.3
    }

    Item {
        id: newsItem

        anchors { fill: parent; leftMargin: 16 + back.width }

        Elements.CursorMouseArea {
            id: mouser

            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (d.currentItem) {
                    openWebPage("http://www.gamenet.ru/games/" + d.currentItem.gameShortName + "/post/" + d.currentItem.eventId);
                }
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter

            Text {
                opacity: 0.7
                text: d.currentItem ? DateHelper.toLocaleFormat(new Date(d.currentItem.time * 1000), '%d %m'): ""
                font { family: 'Arial'; pixelSize: 14 }
                color: "#ffffff"
                wrapMode: Text.WordWrap
            }

            Row {
                spacing: 5

                Text {
                    text: d.currentItem ? Core.serviceItemByGameId(d.currentItem.gameId).name + ":" : ""
                    font { family: 'Tahoma'; pixelSize: 16; bold: true }
                    color: "#ffffff"
                    wrapMode: Text.WordWrap
                }

                Text {
                    text: d.currentItem ? d.currentItem.title : ""
                    font { family: 'Tahoma'; pixelSize: 16 }
                    color: "#ffffff"
                    elide: Text.ElideRight
                }
            }
        }
    }

    Item {
        anchors { right: parent.right; rightMargin: 30; top: parent.top; topMargin: 22 }
        width: arrows.width

        Column {
            id: arrows

            spacing: 5

            Image {
                source: installPath + "images/controlarrow.png"
                opacity: mouserUp.containsMouse ? 1: 0.5
                rotation: 180

                Elements.CursorMouseArea {
                    id: mouserUp

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (refreshAnim.running) {
                            return;
                        }

                        timer.stop();
                        d.setUp(true);
                        refreshAnim.start();
                        delay.restart();
                    }
                }
            }

            Image {
                source: installPath + "images/controlarrow.png"
                opacity: mouserDown.containsMouse ? 1: 0.5

                Elements.CursorMouseArea {
                    id: mouserDown

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (refreshAnim.running) {
                            return;
                        }

                        timer.stop();
                        d.setUp(false);
                        refreshAnim.start();
                        delay.restart();
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        DateHelper.setMonthNames([qsTr("JANUARY"), qsTr("FEBRUARY"), qsTr("MARCH"), qsTr("APRIL"), qsTr("MAY"),
                                  qsTr("JUNE"), qsTr("JULY"), qsTr("AUGUST"), qsTr("SEPTEMBER"), qsTr("OCTOBER"),
                                  qsTr("NOVEMBER"), qsTr("DECEMBER")]);
        news.reloadNews();
    }

    Models.NewsModel {
        id: news

        onAllNewsReady: timer.start();
    }

    SequentialAnimation {
        id: refreshAnim

        PropertyAnimation {
            target: newsItem;
            easing.type: Easing.Linear;
            property: "opacity";
            from: 1;
            to: 0;
            duration: 250
        }

        ScriptAction { script: d.refresh(); }

        PropertyAnimation {
            target: newsItem;
            easing.type: Easing.Linear;
            property: "opacity";
            from: 0;
            to: 1;
            duration: 250
        }
    }

    Timer {
        id: timer

        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            d.setUp(false);
            refreshAnim.start();
        }
    }

    Timer {
        id: delay

        interval: 4000
        running: true
        repeat: false
        onTriggered: timer.start()
    }

    QtObject {
        id: d

        property int currentIndex: 0
        property variant currentItem
        property bool isUp: false
        property int counterBadNews: 100 // защита от переполнения стека (на всякий пожарный)

        function setUp(up) {
            isUp = up;
        }

        function refresh() {
            if (counterBadNews == 0) {
                return;
            }

            if (isUp) {
                up();
            } else {
                down();
            }

            // дальше хак, потому что restapi присылает старые несуществующие игры
            var item = news.allGames.get(d.currentIndex);

            if (Core.serviceItemByGameId(item.gameId)) {
                counterBadNews = 100;
                currentItem = item;
            } else {
                counterBadNews--;
                refresh();
            }
        }

        function up() {
            if (currentIndex == 0) {
                currentIndex = news.allGames.count - 1;
            } else {
                currentIndex--;
            }
        }

        function down() {
            if (currentIndex == news.allGames.count - 1) {
                currentIndex = 0;
            } else {
                currentIndex++;
            }
        }
    }
}
