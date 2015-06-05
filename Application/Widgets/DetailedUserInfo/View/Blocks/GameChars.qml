/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2015, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import GameNet.Controls 1.0
import Tulip 1.0

import "../../../../Core/App.js" as App
import "../../../../Core/moment.js" as Moment
import "../../../../Core/Styles.js" as Styles

import "../../../../../GameNet/Core/lodash.js" as Lodash

Item {
    id: root

    property string gameId: ""
    property bool isPlayingNow: true
    property string played

    function appendChars(chars) {
        d.appendChars(chars);
    }

    implicitWidth: parent.width
    implicitHeight: contentItem.height + 15

    QtObject {
        id: d

        property string imageRoot: installPath + "Assets/Images/Application/Widgets/DetailedUserInfo/"

        function getGameAvatar() {
            var gameItem = App.serviceItemByGameId(root.gameId);

            if (!gameItem) {
                return "";
            }

            return gameItem.imageSmall
        }

        function getGameName() {
            var gameItem = App.serviceItemByGameId(root.gameId);

            if (!gameItem) {
                return "";
            }

            return gameItem.name
        }

        function appendChars(chars) {
            Lodash._.chain(Lodash._.isArray(chars) ? chars : [])
                .map(function(character) {
                        return {
                            name: character.name || "",
                            level: character.level || 1,
                            serverName: character.serverName || "",
                            className: character['class'] || "",
                            isFriend: (character.isFriend === 1) || false,
                            guildLevel: character.guildLevel || 0,
                            guildMembers: character.guildMembers || 0,
                            guildName: character.guildName || "",
                        };
                    })
                .sortByAll(['isFriend', 'level'])
                .reverse()
                .value()
                .forEach(charsModel.append);
        }

        function lastPlayed() {
            return Moment.moment(root.played*1000).fromNow()
        }
    }

    ListModel {
        id: charsModel
    }

    Item {
        id: contentItem

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            leftMargin: 15
            topMargin: 15
            rightMargin: 15
        }

        height: childrenRect.height

        Item {
            id: item1

            width: parent.width
            height: childrenRect.height

            Image {
                source: d.getGameAvatar()
                width: 42
                height: 42

                CursorMouseArea {
                    anchors.fill: parent
                    toolTip: qsTr("DETAILED_USER_INFO_GAME_CHARS_GAME_TOOLTIP")
                    onClicked: {
                        App.activateGame(App.serviceItemByGameId(root.gameId))
                        App.navigate('mygame', 'GameItem');
                        App.closeDetailedUserInfo();
                    }
                }
            }

            Column {
                id: charsColumn

                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 42
                }
                height: childrenRect.height

                Item {
                    width: parent.width
                    height: 16

                    Row {
                        anchors.fill: parent

                        Item {
                            width: 20
                            height: parent.height

                            Rectangle {
                                anchors {
                                    horizontalCenter: parent.horizontalCenter
                                    bottom: parent.bottom
                                    bottomMargin: 8
                                }

                                width: 6
                                height: 6
                                radius: 3
                                color: Styles.style.detailedUserInfoGameCharsPlayingIcon
                                visible: root.isPlayingNow
                            }
                        }

                        Item {
                            width: parent.width - 105
                            height: parent.height

                            Text {
                                text: d.getGameName()
                                anchors {
                                    baseline: parent.bottom
                                    baselineOffset: -6
                                }

                                font {
                                    family: "Arial"
                                    pixelSize: 14
                                }

                                color: Styles.style.lightText
                            }
                        }

                        Item {
                            width: 85
                            height: parent.height

                            Text {
                                anchors {
                                    baseline: parent.bottom
                                    baselineOffset: -6
                                    right: parent.right
                                    rightMargin: 10

                                }
                                text: root.isPlayingNow
                                      ? qsTr("DETAILED_USER_INFO_GAME_CHARS_PLAYING_NOW")
                                      : d.lastPlayed()
                                font {
                                    family: "Arial"
                                    pixelSize: 11
                                }

                                color: Styles.style.textBase
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: 13 + charsListView.height

                    Item { // table header
                        width: parent.width
                        height: 13
                        visible: charsListView.count > 0

                        Rectangle {
                            anchors {
                                fill: parent
                                leftMargin: 16
                            }

                            color: Styles.style.applicationBackground
                            opacity: 0.5

                            Row {
                                anchors {
                                    fill: parent
                                    leftMargin: 4
                                }

                                Item {
                                    width: 96
                                    height: parent.height

                                    Text {
                                        color: Styles.style.textBase
                                        font {
                                            pixelSize: 10
                                            capitalization: Font.AllUppercase
                                        }

                                        text: qsTr("DETAILED_USER_INFO_GAME_CHARS_COLUMN_NAME") // "Персонаж"
                                    }
                                }

                                Item {
                                    width: 102
                                    height: parent.height

                                    Text {
                                        color: Styles.style.textBase
                                        font {
                                            pixelSize: 10
                                            capitalization: Font.AllUppercase
                                        }

                                        text: qsTr("DETAILED_USER_INFO_GAME_CHARS_COLUMN_LEVEL") // "Уровень"
                                    }
                                }

                                Item {
                                    width: 58
                                    height: parent.height

                                    Text {
                                        color: Styles.style.textBase
                                        font {
                                            pixelSize: 10
                                            capitalization: Font.AllUppercase
                                        }

                                        text: qsTr("DETAILED_USER_INFO_GAME_CHARS_COLUMN_SERVER") // "Сервер"
                                    }
                                }
                            }
                        }
                    }

                    ListView {
                        id: charsListView

                        width: parent.width
                        height: count > 0 ? count * 18 : 1
                        interactive: false
                        anchors {
                            top: parent.top
                            topMargin: 13
                        }

                        model: charsModel
                        visible: charsListView.count > 0
                        delegate: Item {
                            width: charsListView.width
                            height: 18

                            Row {
                                anchors {
                                    fill: parent
                                }

                                Item {
                                    width: 20
                                    height: parent.height

                                    Image {
                                        visible: model.isFriend
                                        source: d.imageRoot + "friendChar.png"
                                        anchors {
                                            centerIn: parent
                                        }
                                    }
                                }

                                Item {
                                    width: 96
                                    height: parent.height

                                    Text {
                                        color: model.isFriend
                                               ? Styles.style.detailedUserInfoGameCharsTableFriendText
                                               : Styles.style.lightText
                                        font {
                                            pixelSize: 12
                                        }

                                        text: model.name
                                        width: parent.width
                                        elide: Text.ElideRight
                                    }
                                }

                                Item {
                                    width: 102
                                    height: parent.height

                                    Text {

                                        function getText() {
                                            return "<span style='color: " +
                                                    (model.isFriend
                                                        ? Styles.style.detailedUserInfoGameCharsTableFriendText
                                                        : Styles.style.lightText)
                                                    + "'>" + model.level + " <span style='color: " +
                                                    (model.isFriend
                                                     ? Styles.style.detailedUserInfoGameCharsTableFriendText
                                                     : Styles.style.textBase) +
                                                    "'>" + model.className + "</span></span>";
                                        }

                                        color: model.isFriend
                                               ? Styles.style.detailedUserInfoGameCharsTableFriendText
                                               : Styles.style.lightText
                                        font {
                                            pixelSize: 12
                                        }

                                        text: getText();
                                    }
                                }

                                Item {
                                    width: 58
                                    height: parent.height

                                    Text {
                                        color: model.isFriend
                                               ? Styles.style.detailedUserInfoGameCharsTableFriendText
                                               : Styles.style.lightText
                                        font {
                                            pixelSize: 12
                                        }

                                        text: model.serverName
                                    }
                                }
                            }

                            CursorMouseArea {
                                anchors.fill: parent
                                cursor: CursorArea.ArrowCursor
                                toolTip:
                                    qsTr("DETAILED_USER_INFO_GAME_CHARS_CHAR_TOOLTIP_1").arg(model.name)
                                        + (model.guildName ?
                                              qsTr("DETAILED_USER_INFO_GAME_CHARS_CHAR_TOOLTIP_2").arg(model.guildName).arg(model.guildLevel).arg(model.guildMembers)
                                            : qsTr("DETAILED_USER_INFO_GAME_CHARS_CHAR_TOOLTIP_2_NO_GUILD"))
                            }
                        }
                    }
                }
            }
        }

        Item {
            width: parent.width
            height: 10
            anchors.top : item1.bottom

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: Styles.style.applicationBackground
            }
        }
    }
}
