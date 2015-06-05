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

import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import Application.Controls 1.0

import "."
import "../../../../Core/restapi.js" as RestApi
import "../../../../Core/App.js" as App
import "../../../../Core/Styles.js" as Styles

import "../../../../../GameNet/Core/lodash.js" as Lodash

Item {
    id: root

    property int gameCount: 0
    property variant playingGames
    property variant lastPlayList

    signal finished();

    function update(userId) {
        d.clear();

        root.gameCount = root.lastPlayList.length
        RestApi.Core.execute('user.getChars',
                             {
                                 targetId: userId
                             },
                             true, d.parseChars, d.parseChars);
    }

    implicitWidth: parent.width
    implicitHeight: blockHeader.height + contentItem.height

    QtObject {
        id: d

        function clear() {
            var i;
            for (i = gameCharsColumn.children.length - 1; i >=0; --i) {
                gameCharsColumn.children[i].destroy();
            }
        }

        function getCaption() {
            var translate = {
                textSingle: qsTr('DETAILED_USER_INFO_GAME_CHARS_TITLE_SINGLE'),
                textDouble: qsTr('DETAILED_USER_INFO_GAME_CHARS_TITLE_DOUBLE'),
                textMultiple: qsTr('DETAILED_USER_INFO_GAME_CHARS_TITLE_MULTIPLE')
            };

            var longModulo = root.gameCount % 100;
            var shortModulo = longModulo % 10;
            var template = "";

            if ((longModulo < 10 || longModulo > 20) && shortModulo > 1 && shortModulo < 5) {
                template = translate['textDouble'];
            } else if (shortModulo == 1 && longModulo != 11) {
                template = translate['textSingle'];
            } else {
                template = translate['textMultiple'];
            }

            return template.arg(Styles.style.textBase + "")
                .arg(Styles.style.lightText + "").arg(root.gameCount);
        }

        function isPlaying(gameId) {
            return root.playingGames.indexOf(gameId) !== -1;
        }

        function parseChars(response) {
            var chars = {};

            if (Array.isArray(response)) {
                chars = Lodash._.groupBy(response, 'gameId');
            }

            Lodash._.chain(root.lastPlayList)
                .map(function(g) {
                    return {
                        gameId: g.gameId,
                        played: g.time,
                        isPlayingNow: d.isPlaying(g.gameId)
                    };
                 })
                .sortByAll(['isPlaying', 'lastOnline'])
                .reverse()
                .map(function(g) {
                    var item = gameCharsComponent.createObject(gameCharsColumn, g);
                    item.appendChars(chars[g.gameId]);
                    return item;
                })
                .value()

            root.finished();
        }
    }

    Component {
        id: gameCharsComponent

        GameChars { }
    }

    Column {
        width: parent.width

        BlockHeader {
            id: blockHeader

            text: d.getCaption()
        }

        Item {
            id: contentItem

            width: parent.width
            height: gameCharsColumn.childrenRect.height

            Column {
                id: gameCharsColumn

                width: parent.width
            }
        }
    }
}
