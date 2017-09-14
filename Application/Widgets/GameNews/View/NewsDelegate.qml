/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import GameNet.Core 1.0
import GameNet.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Item {
    id: delegate

    property bool shouldShowDelimited: index != 0
    property string announcementText: announcement
    property string previewImage: ''

    clip: true
    implicitWidth: 590
    implicitHeight: index == 0 ? 130 : 139

    onAnnouncementTextChanged: {
       var imageMatch = /<\!--p=(.+?)-->/.exec(announcementText);

        if (imageMatch && imageMatch.length >= 2) {
            delegate.previewImage = imageMatch[1];
        } else {
            delegate.previewImage = '';
        }
    }

    function openNews(gameShortName, eventId) {
        App.openExternalUrlWithAuth(Config.GnUrl.site("/games/") + gameShortName + "/post/" + eventId + "/");

        Ga.trackEvent('GameNews', 'outer link', eventId);
    }

    CursorMouseArea {
        id: mouser

        anchors { fill: parent; leftMargin: 10; rightMargin: 10; topMargin: shouldShowDelimited ? 9 : 0}
        onClicked: openNews(gameShortName, eventId);
    }

    Column {
        anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
        spacing: 8

        Rectangle {
            height: 1
            width: parent.width
            color: Styles.light
            visible: shouldShowDelimited
            opacity: 0.15
        }

        Row {
            height: parent.height
            width: parent.width

            spacing: 10

            WebImage {
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
                    cache: true
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
                    color: Styles.textAttention
                    text: commentCount
                }
            }

            Column {
                anchors.top: parent.top
                anchors.topMargin: 2

                height: 128
                width: newsImage.visible ? 430 : 600
                spacing: 6

                Column {
                    width: parent.width
                    spacing: 5

                    Row {
                        height: 12
                        width: parent.width
                        spacing: 10

                        Text {
                            height: 12
                            text: App.serviceItemByGameId(gameId) ? App.serviceItemByGameId(gameId).name : ''
                            color: Qt.darker(Styles.textTime, mouser.containsMouse ? 1.5: 0)
                            font { family: 'Arial'; pixelSize: 12 }
                            visible: !root.isSingleMode

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }

                        Text {
                            id: timeText

                            Timer {
                                interval: 60000
                                triggeredOnStart: true
                                running: true
                                onTriggered: timeText.text = Moment.moment(time * 1000).fromNow();
                            }

                            height: 12
                            color: Qt.darker(Styles.chatInactiveText, mouser.containsMouse ? 1.5: 0)

                            font { family: 'Arial'; pixelSize: 12 }

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }
                    }

                    Item {
                        id: rootNewsHeader

                        width: parent.width
                        height: newsHeader.height

                        Text {
                            id: newsHeader
                            anchors.verticalCenter: parent.verticalCenter

                            height: 23
                            width: 355
                            text: title
                            color: Qt.darker(Styles.titleText, mouser.containsMouse ? 1.5: 0)
                            elide: Text.ElideRight
                            font { family: 'Open Sans Light'; pixelSize: 20; bold: false }

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }

                        Image {
                            id: iconLink
                            anchors.verticalCenter: parent.verticalCenter

                            x: newsHeader.paintedWidth + 5
                            y: 2

                            source: installPath + Styles.linkIconNews
                        }

                        CursorMouseArea {
                            anchors.fill: parent
                            toolTip: newsHeader.text
                            hoverEnabled: newsHeader.truncated
                        }
                    }
                }

                Text {
                    function clearText(text) {
                        var tmp = StringHelper.stripTags(text);
                        tmp = StringHelper.htmlDecode(tmp);

                        return tmp.replace(/\s+/g, ' ').trim();
                    }

                    text: clearText(announcementText)
                    height: 86
                    width: parent.width - 35
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    maximumLineCount: 4
                    clip: true
                    color: Qt.darker(Styles.infoText, mouser.containsMouse ? 1.5: 0)
                    font { family: 'Arial'; pixelSize: 13 }
                    lineHeight: 20
                    lineHeightMode: Text.FixedHeight
                    onLinkActivated: App.openExternalUrlWithAuth(link);

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }
        }
    }
}
