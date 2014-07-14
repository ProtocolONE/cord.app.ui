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

    property bool shouldShowDelimited: index != 0
    property string announcementText: announcement
    property string previewImage

    clip: true
    implicitWidth: 590
    implicitHeight: index == 0 ? 130 : 139

    onAnnouncementTextChanged: {
        var imageMatch = /<\!--p=(.+?)-->/.exec(announcementText);
        if (imageMatch) {
            previewImage = imageMatch[1];
        }
    }

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
        anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
        spacing: 8

        Rectangle {
            height: 1
            width: parent.width + 10
            color: '#e1e5e8'
            visible: shouldShowDelimited
        }

        Row {
            height: parent.height
            width: parent.width

            spacing: 10

            Image {
                id: newsImage

                visible: previewImage !== ''
                height: 130
                width: 160
                source: previewImage
                cache: false
                asynchronous: true

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
            }

            Column {
                anchors.top: parent.top
                anchors.topMargin: 2

                height: 128
                width: newsImage.visible ? 430 : 600
                spacing: 6

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
                    property string clearText: announcementText.replace(/<\!--(.+?)-->/, '')

                    text: clearText
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
