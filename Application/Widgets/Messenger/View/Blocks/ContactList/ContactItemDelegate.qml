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

import "../../../../../../GameNet/Core/lodash.js" as Lodash
import "../../../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics
import "../../../../../../GameNet/Controls/ContextMenu.js" as ContextMenu

import "../../../../../Core/moment.js" as Moment
import "../../../../../Core/MessageBox.js" as MessageBox
import "../../../../../Core/App.js" as App

import "../../../Models/Messenger.js" as Messenger
import "../../../Models/User.js" as User

import "./ContactItem"

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

        signal startEditNickname(string jid);

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

            return Messenger.getFullStatusMessage(root.user);
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

        function unreadMessagesCount() {
            if (!root.user) {
                return 0;
            }

            return Messenger.unreadMessagesCount(root.user)|0;
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
                if (Messenger.editGroupModel().isActive()) {
                    return groupEditHeaderChatContactItem;
                }

                return userItem.isGroupChat ? groupHeaderChatContactItem : normalHeaderChatContactItem;
            }

            return userItem.isGroupChat ? groupContactItem : normalContactItem;
        }

        function contextClicked(user, action) {
            switch(action) {
            case 'dump':
                d.dump(user);
                break;
            case 'open':
                Messenger.selectUser(user || "");
                break;
            case 'leave':
                Messenger.leaveGroup(user.jid);
                break;
            case 'destroy':
                d.destroyRoom(user);
                break;
            case "information":
                d.showInformation(user);
                break;
            case "rename":
                d.rename(user);
                break;
            case "deleteContact":
                Messenger.removeContact(user);
                break;
            }

            ContextMenu.hide();

            GoogleAnalytics.trackEvent('/ContactItem',
                                      'MouseRightClick',
                                      action);
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

            MessageBox.show(qsTr("MESSENGER_DESTROY_ROOM_ALERT_TITLE"),
                            qsTr("MESSENGER_DESTROY_ROOM_ALERT_BODY"),
                            MessageBox.button.Ok | MessageBox.button.Cancel, function(result) {
                                if (result != MessageBox.button.Ok) {
                                    return;
                                }

                                userItem.destroyRoom();
                            });
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

            return userItem.participants;
        }

        function showInformation(user) {
            var item = Messenger.getUser(user.jid);
            App.openDetailedUserInfo({
                                        userId: item.userId,
                                        nickname: item.nickname,
                                        status: item.presenceState
                                    });
        }

        function rename(user) {
            d.startEditNickname(user.jid);
        }

        function dump(user) {
            var item = Messenger.users().getById(user.jid);
            console.log('[ContextMenu] Dump\n', JSON.stringify(item, null, 2));
            for (var i = 0; i < item.participants.count; ++i) {
                console.log(JSON.stringify(item.participants.get(i), null, 2))
            }
        }
    }

    Component {
        id: normalContactItem

        ContactItem {
            id: normalContactInstance

            nickname: d.nickName()
            avatar: d.avatar()
            status: d.status()
            presenceStatus: d.presenceStatus()

            isUnreadMessages: !root.isCurrent && d.hasUnreadMessages();
            unreadMessageCount: d.unreadMessagesCount()
            isCurrent: d.isCurrent()
            isHighlighted: root.isHighlighted
            userId: d.userId()
            onClicked: root.select()

            editMode: Messenger.editGroupModel().isActive()
            checked: Messenger.editGroupModel().isSelected(root.user.jid)

            onRightButtonClicked: {
                ContextMenu.show(mouse, root, contextMenu, {user: root.user});
            }

            onNicknameChangeRequest: Messenger.renameUser(root.user, value);

            CursorMouseArea {
                anchors.fill: parent
                visible: Messenger.editGroupModel().isActive()

                onClicked: {
                    if (normalContactInstance.checked) {
                        if (!Messenger.editGroupModel().owner()
                            && !Messenger.editGroupModel().canDelete(root.user.jid)) {
                            return;
                        }

                        Messenger.editGroupModel().removeUser(root.user.jid);
                    } else {
                        Messenger.editGroupModel().addUser(root.user.jid)
                    }
                }
            }

            Connections {
                target: d
                onStartEditNickname: normalContactInstance.startEdit();
            }
        }
    }

    Component {
        id: groupContactItem

        ContactItem {
            id: groupContactInstance

            anchors.fill: parent

            nickname: Messenger.getGroupTitle(root.user)
            avatar: d.imageRoot + 'groupChatAvatar.png';
            status: d.status()
            presenceStatus: d.presenceStatus()
            isUnreadMessages: !root.isCurrent && d.hasUnreadMessages();
            isCurrent: d.isCurrent()
            isHighlighted: root.isHighlighted
            userId: d.userId()
            onClicked: root.select()

            showInformationIcon: false
            onRightButtonClicked: {
                var item = Messenger.getUser(root.user.jid);
                if (item.inContacts) {
                    ContextMenu.show(mouse, groupContactInstance, contextMenu, {user: root.user});
                }
            }

            onNicknameChangeRequest: Messenger.changeGroupTopic(root.user.jid, value);

            CursorMouseArea {
                anchors.fill: parent
                visible: Messenger.editGroupModel().isActive()
            }

            Connections {
                target: d
                onStartEditNickname: groupContactInstance.startEdit();
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

            onGroupButtonClicked: {
                if (Messenger.editGroupModel().isActive()) {
                    Messenger.editGroupModel().close();
                    return;
                }

                Messenger.editGroupModel().createRoom(root.user.jid);
            }
        }
    }

    Component {
        id: groupHeaderChatContactItem

        GroupContactItemHeader {
            title: Messenger.getGroupTitle(root.user)
            occupantModel: d.occupant();
            onGroupButtonClicked: {
                if (Messenger.editGroupModel().isActive()) {
                    Messenger.editGroupModel().close();
                    return;
                }

                Messenger.editGroupModel().startEdit(root.user.jid);
            }
        }
    }

    Component {
        id: groupEditHeaderChatContactItem

        GroupEditHeader {
            occupantModel: Messenger.editGroupModel().occupants()
            title: Messenger.editGroupModel().groupTitle();
            onGroupButtonClicked: {
                Messenger.editGroupModel().close();
            }
        }
    }

    Component {
        id: contextMenu

        ContextMenuView {
            property variant user

            onContextClicked: d.contextClicked(user, action)


            Component.onCompleted: {
                contextMenuPrivate.fillItems();
            }

            QtObject {
                id: contextMenuPrivate

                function fillItems() {
                    var item = Messenger.getUser(user.jid);
                    if (!item.isValid()) {
                        return;
                    }

                    if (item.isGroupChat) {
                        contextMenuPrivate.fillForGroup(item);
                    } else {
                        contextMenuPrivate.fillForUser(item);
                    }
                }

                function fillForGroup(item) {
                    var i
                        , isOwner = false
                        , selfJid = Messenger.authedUser().jid
                        , options = [];

//                    options.push({
//                                           action: "dump",
//                                           name: "Dump Group",
//                                       });


                    for(i = 0; i < item.participants.count; ++i) {
                        var occupant = item.participants.get(i);
                        if (occupant.jid == selfJid) {
                            isOwner = (occupant.affiliation === "owner");
                            break;
                        }
                    }

                    if (isOwner) {
                        options.push({
                                               action: "destroy",
                                               name: qsTr("CONTACT_CONTEXT_MENU_DESTROY_ROOM"), //"Распустить",
                                           });
                    } else {
                        options.push({
                                               action: "leave",
                                               name: qsTr("CONTACT_CONTEXT_MENU_LEAVE"), //"Выйти",
                                           });
                    }

                    options.push({
                                     name: qsTr("CONTACT_CONTEXT_MENU_RENAME"),// "Переименовать",
                                     action: "rename"
                                 });

                    fill(options);
                }

                function fillForUser(item) {
                    var options = [];
//                    options.push({
//                                           action: "dump",
//                                           name: "Dump User",
//                                       });

                    options.push({
                                     name: qsTr("CONTACT_CONTEXT_MENU_INFORAMTION"),// "Информация",
                                     action: "information"
                                 });

                    if (item.inContacts) {
                        options.push({
                                         name: qsTr("CONTACT_CONTEXT_MENU_RENAME"),// "Переименовать",
                                         action: "rename"
                                     });

                        options.push({
                                         name: qsTr("CONTACT_CONTEXT_MENU_DELETE"),// "Удалить",
                                         action: "deleteContact"
                                     });
                    }
                    fill(options);
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
