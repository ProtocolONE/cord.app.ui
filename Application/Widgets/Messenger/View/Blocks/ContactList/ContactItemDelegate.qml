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

import "./ContactItem"
import "../../../Models/Messenger.js" as Messenger
import "../../../Models/User.js" as User
import "../../../../../Core/moment.js" as Moment

import "../../../../../Core/App.js" as App
import "../../../../../../GameNet/Core/lodash.js" as Lodash
import "../../../../../../GameNet/Controls/ContextMenu.js" as ContextMenu

Item {
    id: root

    property variant user

    property string view: ""

    property bool isHighlighted: false

    function select() {
        Messenger.selectUser(root.user || "");
    }

    implicitHeight: childrenRect.height

    QtObject {
        id: d

        property string imageRoot: installPath + "Assets/Images/Application/Widgets/Messenger/ContactItem/"

        function nickName() {
            if (!root.user) {

                return "";
            }

            return Messenger.getNickname(root.user)
        }

        function avatar() {
            if (!root.user) {
                return "";
            }

            return Messenger.userAvatar(root.user);
        }

        function status() {
            if (!root.user) {
                return "";
            }

            if (User.isOnline(root.presenceStatus)) {
                var serviceId = Messenger.gamePlayingByUser(root.user);
                if (serviceId) {
                    var gameInfo = App.serviceItemByServiceId(serviceId);
                    if (gameInfo) {
                        return qsTr("MESSENGER_CONTACT_ITEM_PLAYING_STATUS_INFO").arg(gameInfo.name);
                    }
                }

                return Messenger.userStatusMessage(root.user) || "";
            }

            var lastActivity = Messenger.userLastActivity(root.user);
            if (!lastActivity) {
                return "";
            }

            var currentTime = Math.max(Messenger.getCurrentTime() * 1000, Date.now());

            return qsTr("LAST_ACTIVITY_PLACEHOLDER").arg(Moment.moment(lastActivity * 1000).from(currentTime));
        }

        function presenceStatus() {
            if (!root.user) {
                return "";
            }

            return Messenger.userPresenceState(root.user) || "";
        }

        function hasUnreadMessages() {
            if (!root.user) {
                return false;
            }

            return Messenger.hasUnreadMessages(root.user) || false;
        }

        function isCurrent() {
            if (!root.user) {
                return false;
            }

            return Messenger.isSelectedUser(root.user);
        }

        function userId() {
            if (!root.user) {
                return "";
            }

            return Messenger.jidToUser(root.user.jid);
        }

        function getView() {
            var userItem;
            if (!root.user) {
                return null;
            }

            userItem = Messenger.getUser(root.user.jid);
            if (!userItem.isValid()) {
                return null;
            }

            if (root.view === "header") {
                return userItem.isGroupChat ? groupHeaderChatContactItem : normalHeaderChatContactItem;
            }

            return userItem.isGroupChat ? groupContactItem : normalContactItem;
        }

        function contextClicked(user, action) {
            switch(action) {
            case 'open':
                Messenger.selectUser(user || "");
                break;
            case 'destroy':
                d.destroyRoom(user);
                break;
            }

            ContextMenu.hide();
        }

        function destroyRoom(user) {
            var userItem;
            if (!root.user) {
                return;
            }

            userItem = Messenger.getUser(user.jid);
            if (!userItem.isValid()) {
                return;
            }

            console.log(user.jid, userItem.isGroupChat)
            userItem.destroyRoom();
        }

        function occupant() {
            var userItem;
            if (!root.user) {
                return [];
            }

            userItem = Messenger.getUser(root.user.jid);
            if (!userItem.isValid() || !userItem.isGroupChat) {
                return [];
            }

            for(var i = 0; i < userItem.participants.count; ++i) {
                console.log(JSON.stringify(userItem.participants.get(i)))
            }

            return userItem.participants;
        }
    }

    Component {
        id: normalContactItem

        ContactItem {
            nickname: d.nickName()
            avatar: d.avatar()
            status: d.status()
            presenceStatus: d.presenceStatus()

            isUnreadMessages: !root.isCurrent && d.hasUnreadMessages();
            isCurrent: d.isCurrent()
            isHighlighted: root.isHighlighted
            userId: d.userId()
            onClicked: root.select()

            onRightButtonClicked: {
                ContextMenu.show(mouse, root, contextMenu, {user: root.user});
            }
        }
    }

    Component {
        id: groupContactItem

        ContactItem {
            anchors.fill: parent

            nickname: d.nickName()
            avatar: d.imageRoot + 'groupChatAvatar.png';
            status: d.status()
            presenceStatus: d.presenceStatus()
            isUnreadMessages: !root.isCurrent && d.hasUnreadMessages();
            isCurrent: d.isCurrent()
            isHighlighted: root.isHighlighted
            userId: d.userId()
            onClicked: root.select()

            onRightButtonClicked: {
                ContextMenu.show(mouse, root, contextMenu, {user: root.user});
            }
        }
    }

    Component {
        id: normalHeaderChatContactItem

        ContactItemHeader {
            nickname: d.nickName()
            avatar: d.avatar()
            status: d.status()
            extendedStatus: ''
            presenceStatus: d.presenceStatus()
            userId: d.userId()
        }
    }

    Component {
        id: groupHeaderChatContactItem

        GroupContactItemHeader {
//            nickname: d.nickName()
//            avatar: d.imageRoot + 'groupChatAvatar.png';
//            status: d.status()
//            extendedStatus: ''
//            presenceStatus: d.presenceStatus()
//            userId: d.userId()


            occupantModel: d.occupant();
            onGroupButtonClicked: {
                var current =  Messenger.isGroupChatConfigOpen();
                Messenger.setIsGroupChatConfigOpen(!current);
            }
        }
    }

    Component {
        id: contextMenu

        Rectangle {
            id: contextMenuItem

            property variant user

            width: 155
            height: actionModel.count * 27 + 2
            color: "#19384a"

            ListModel {
                id: actionModel

                ListElement {
                    action: "open"
                    name: "Открыть"
                }

                ListElement {
                    action: "destroy"
                    name: "Удалить чат"
                }
            }

            Rectangle {
                anchors {
                    fill: parent
                    bottomMargin: 1
                    rightMargin: 1
                }

                color: "#00000000"
                border {
                    width: 1
                    color: "#324e5e"
                }
            }

            Item {
                anchors {
                    fill: parent
                    margins: 1
                }

                ListView {
                    id: actionListView
                    anchors.fill: parent
                    model: actionModel
                    delegate: Item {
                        width: actionListView.width
                        height: 27

                        Text {
                            anchors.centerIn: parent
                            color: "#FFFFFF"
                            text: model.name
                        }

                        CursorMouseArea {
                            anchors.fill: parent
                            onClicked: d.contextClicked(contextMenuItem.user, model.action)
                        }
                    }
                }
            }

        }
    }

    Loader {
        id: loader

        width: parent.width
        sourceComponent: d.getView()
    }
}
