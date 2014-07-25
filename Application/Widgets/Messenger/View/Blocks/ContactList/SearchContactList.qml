/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../../Models/Messenger.js" as MessengerJs
import "../../../../../Core/Styles.js" as Styles

Item {
    id: root

    property alias model: view.model

    signal userClicked(string jid);

    clip: true

    implicitWidth: 228
    implicitHeight: 400

    function sortFunction(a, b) {
        if (a.value > b.value) {
            return 1;
        }

        return -1;
    }

    function updateFilter(text) {
        var res = []
            , item
            , filterText = text.toLowerCase();

        searchContactModel.clear();

        MessengerJs.eachUser(function(user) {
            if (0 !== user.nickname.toLowerCase().indexOf(filterText)) {
                return;
            }

            item = {
                jid: user.jid,
                value: user.nickname
            };

            res.push(item);
        });

        res.sort(sortFunction);

        res.forEach(function(e) {
            searchContactModel.append({jid: e.jid});
        });
    }

    ListView {
        id: view

        model: searchContactModel
        anchors {
            fill: parent
            rightMargin: 10
        }

        boundsBehavior: Flickable.StopAtBounds
        delegate: ContactItem {
            width: root.width
            height: 53
            nickname: MessengerJs.getNickname(model)
            avatar: MessengerJs.userAvatar(model)
            status: MessengerJs.userStatusMessage(model)
            presenceStatus: MessengerJs.userPresenceState(model)
            isPresenceVisile: !MessengerJs.isGamenetUser(model)
            isCurrent: MessengerJs.isSelectedUser(model)
            isUnreadMessages: !isCurrent && MessengerJs.hasUnreadMessages(model);
            onClicked: {
                root.userClicked(model.jid);
                MessengerJs.selectUser(model);
            }
        }
    }

    ListModel {
        id: searchContactModel
    }

    ListViewScrollBar {
        anchors.left: view.right
        height: view.height
        width: 10
        listView: view
        cursorMaxHeight: view.height
        cursorMinHeight: 50
        color: Qt.darker(Styles.style.messengerContactsBackground, Styles.style.darkerFactor);
        cursorColor: Qt.darker(Styles.style.messengerContactsBackground, Styles.style.darkerFactor * 1.5);
    }
}
