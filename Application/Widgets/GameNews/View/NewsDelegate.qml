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
import "../../../Core/Styles.js" as Styles
import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics
import "../../../../GameNet/Core/Strings.js" as Strings

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
        App.openExternalUrlWithAuth("https://www.gamenet.ru/games/" + gameShortName + "/post/" + eventId);

        GoogleAnalytics.trackEvent("/GameNews/",
                              "Game " + gameShortName,
                              "News clicked",
                              eventId);
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
            width: parent.width + 10
            color: Qt.darker(Styles.style.newsBackground, Styles.style.darkerFactor)
            visible: shouldShowDelimited
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
                cache: true
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
                    color: Styles.style.newsCommentCountText
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
                        color: mouser.containsMouse ? Styles.style.newsGameTextHover :
                                                      Styles.style.newsGameTextNormal
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
                        color: mouser.containsMouse ? Styles.style.newsTimeTextHover :
                                                      Styles.style.newsTimeTextNormal

                        font { family: 'Arial'; pixelSize: 12 }

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                }

                Text {
                    height: 23
                    width: parent.width - 30
                    text: title
                    color: mouser.containsMouse ? Styles.style.newsTitleTextHover :
                                                  Styles.style.newsTitleTextNormal
                    elide: Text.ElideRight
                    font { family: 'Arial'; pixelSize: 18; bold: true }

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Text {
                    function clearText(text) {
                        var tmp = Strings.stripTags(text);
                        tmp = Strings.htmlDecode(tmp);

                        return tmp.replace(/\s+/g, ' ').trim();
                    }

                    text: clearText(announcementText)
                    height: 86
                    width: parent.width - 35
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    maximumLineCount: 4
                    clip: true
                    color: mouser.containsMouse ? Styles.style.newsAnnouncementTextHover :
                                                  Styles.style.newsAnnouncementTextNormal
                    font { family: 'Arial'; pixelSize: 14 }
                    lineHeight: 20
                    lineHeightMode: Text.FixedHeight
                    onLinkActivated: App.openExternalUrl(link);

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }
        }
    }
}
