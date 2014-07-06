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

import "../../../Core/App.js" as App
import "../../../Core/moment.js" as Moment

Item {
    id: delegate

    function openNews(gameShortName, eventId) {
        App.openExternalUrlWithAuth("http://www.gamenet.ru/games/" + gameShortName + "/post/" + eventId);
    }

    CursorMouseArea {
        anchors {
            fill: parent
            margins: 10
        }
        onClicked: delegate.openNews(gameShortName, eventId);
    }

    Column {
        anchors {
            fill: parent
            margins: 10
        }

        spacing: 8

        Rectangle {
            height: 1
            width: parent.width + 10
            color: '#e1e5e8'
            visible: index != 0
        }

        Row {
            height: parent.height
            width: parent.width

            spacing: 10

            Image {
                height: 130
                width: 160
                source: App.serviceItemByGameId(gameId) ?
                            installPath + App.serviceItemByGameId(gameId).imageSmall : ''

                Image {
                    anchors {
                        right: commentCountText.left
                        bottom: parent.bottom
                        bottomMargin: 3
                        rightMargin: 5
                    }

                    source: installPath + 'Assets/Images/Application/Widgets/GameNews/commentCount.png'
                }

                Text {
                    id: commentCountText

                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                        margins: 5
                        bottomMargin: 3
                    }
                    font {
                        family: 'Arial'
                        pixelSize: 12
                    }
                    color: '#f5755a'
                    text: commentCount
                }

                CursorMouseArea {
                    anchors.fill: parent
                    onClicked: root.openNews(gameShortName, eventId);
                }
            }

            Column {
                width: delegate.width - 140
                height: parent.height
                spacing: 6

                Item {
                    width: 1
                    height: -4
                }

                Row {
                    height: 12
                    width: parent.width
                    spacing: 10

                    Text {
                        height: 12
                        text: App.serviceItemByGameId(gameId) ? App.serviceItemByGameId(gameId).name : ''
                        color: '#4ac6aa'
                        font { family: 'Arial'; pixelSize: 12 }
                        visible: !root.isSingleMode
                    }

                    Text {
                        id: timeText

                        Timer {
                            interval: 60000
                            triggeredOnStart: true
                            running: true
                            onTriggered: timeText.text = Moment.moment(time * 1000).lang('ru').fromNow();
                        }

                        height: 12
                        color: '#7e99ae'
                        font { family: 'Arial'; pixelSize: 12 }
                    }
                }



                Text {
                    height: 23
                    width: parent.width - 30
                    text: title
                    color: '#2b6a9d'
                    elide: Text.ElideRight
                    font { family: 'Arial'; pixelSize: 18; bold: true }
                }

                Text {
                    text: announcement
                    height: 86
                    width: parent.width - 35
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    maximumLineCount: 4
                    clip: true
                    color: '#5e7182'
                    font { family: 'Arial'; pixelSize: 14 }
                    lineHeight: 20
                    lineHeightMode: Text.FixedHeight
                    onLinkActivated: App.openExternalUrl(link);
                }
            }
        }
    }
}
