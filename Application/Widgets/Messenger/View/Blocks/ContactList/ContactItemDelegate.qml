import QtQuick 2.4

import GameNet.Core 1.0
import GameNet.Controls 1.0

import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.MessageBox 1.0

import "../../../Models/Messenger.js" as Messenger

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

        function getGroupTitle() {
            if (!root.user) {
                return "";
            }

            return Messenger.getGroupTitle(root.user);
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

        function isGameNetMember() {
            if (!root.user) {
                return false;
            }

            return Messenger.isGameNetMember(root.user)
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
            case "addContact":
                Messenger.addContact(user.jid)
                break;
            case "giftExtendedAccount":
                App.openProfile(Messenger.jidToUser(user.jid), 'gift');
                break;
            case "blockContact":
                d.blockContact(user);
                break;
            case "unblockContact":
                d.unblockContact(user);
                break;
            case "clearHistory":
                d.clearHistory(user);
                break;
            }

            ContextMenu.hide();

            Ga.trackEvent('Messanger ContactItem', 'context menu click', action);
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
                            MessageBox.button.ok | MessageBox.button.cancel, function(result) {
                                if (result != MessageBox.button.ok) {
                                    return;
                                }

                                userItem.destroyRoom();
                            });
        }

        // INFO Дубликат сортировки есть в GroupEditModel.qml
        function occupantSortFunction(a, b) {
            if (a.affiliation === "owner") {
                return -1;
            }

            if (b.affiliation === "owner") {
                return 1;
            }

            return a.jid.localeCompare(b.jid);
        }

        function targetUser() {
            if (!root.user) {
                return null;
            }

            return Messenger.getUser(root.user.jid);
        }

        function showInformation(user) {
            var item = Messenger.getUser(user.jid);
            SignalBus.openDetailedUserInfo({
                                        userId: item.userId,
                                        nickname: item.nickname,
                                        status: item.presenceState
                                    });
        }

        function rename(user) {
            d.startEditNickname(user.jid);
        }

        function blockContact(user) {
            Messenger.blockUser(user);
        }

        function unblockContact(user) {
            Messenger.unblockUser(user);
        }

        function clearHistory(user) {
            Messenger.clearUserHistory(user);
        }

        function dump(user) {
            var item = Messenger.users().getById(user.jid);
            console.log('[ContextMenu] Dump\n');
            for (var i = 0; i < item.participants.count; ++i) {
                console.log(JSON.stringify(item.participants.getByIndex(i), null, 2))
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
            onClicked:  {
                if (!Messenger.editGroupModel().isActive()) {
                    root.select()
                    return;
                }

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

            editMode: Messenger.editGroupModel().isActive()
            checked: Messenger.editGroupModel().isSelected(root.user.jid)

            onRightButtonClicked: {
                ContextMenu.show(mouse, root, contextMenu, {user: root.user});
            }

            onNicknameChangeRequest: Messenger.renameUser(root.user, value);

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

            nickname: d.getGroupTitle()
            avatar: d.imageRoot + 'groupChatAvatar.png';
            status: d.status()
            presenceStatus: d.presenceStatus()
            isUnreadMessages: !root.isCurrent && d.hasUnreadMessages();
            unreadMessageCount: d.unreadMessagesCount()

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
            isGameNetMember: d.isGameNetMember()

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
            id: groupContactHeaderInstance

            function updateModel() {
                occupantSortModel.clear();

                var userItem = Messenger.getUser(root.user.jid);
                if (!userItem || !userItem.isValid()) {
                    return;
                }

                var participants = userItem.participants;
                if (!participants) {
                    return;
                }

                var keys = participants.keys();
                var tmp = [];
                keys.forEach(function(k) {
                    var q = participants.getById(k);
                    tmp.push({
                                 jid: q.jid,
                                 presenceState: q.presenceState,
                                 affiliation: q.affiliation,
                             });
                });

                tmp.sort(d.occupantSortFunction);
                tmp.forEach(function(k) {
                    occupantSortModel.append(k);
                });
            }

            function sortPropertyChanged(jid) {
                var userItem = Messenger.getUser(root.user.jid);
                if (!userItem || !userItem.isValid()) {
                    return;
                }

                var participants = userItem.participants;
                if (!participants) {
                    return;
                }

                if (!participants.contains(jid)) {
                    return;
                }

                groupContactHeaderInstance.updateModel();
            }

            function participantsChanged(jid) {
                if (!root.user) {
                    return;
                }

                if (root.user.jid != jid) {
                    return;
                }

                groupContactHeaderInstance.updateModel();
            }

            title: d.getGroupTitle()
            occupantModel: occupantSortModel
            onGroupButtonClicked: {
                if (Messenger.editGroupModel().isActive()) {
                    Messenger.editGroupModel().close();
                    return;
                }

                Messenger.editGroupModel().startEdit(root.user.jid);
            }

            Component.onCompleted: groupContactHeaderInstance.updateModel();

            ListModel {
                id: occupantSortModel
            }

            Connections {
                target: root
                onUserChanged: groupContactHeaderInstance.updateModel();
            }

            Connections {
                target: Messenger.instance()

                onNicknameChanged: groupContactHeaderInstance.sortPropertyChanged(jid);
                onParticipantsChanged: groupContactHeaderInstance.participantsChanged(jid);
            }
        }
    }

    Component {
        id: groupEditHeaderChatContactItem

        GroupEditHeader {
            anchors.fill: parent
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

                    for(i = 0; i < item.participants.count(); ++i) {
                        var occupant = item.participants.getByIndex(i);
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

                    options.push({
                                     name: qsTr("CONTACT_CONTEXT_MENU_CLEAR_HISTORY"),// "Очистить историю",
                                     action: "clearHistory"
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

                    options.push({
                                     name: qsTr("Подарить расширенный аккаунт"),
                                     action: "giftExtendedAccount"
                                 });

                    options.push({
                                     name: qsTr("CONTACT_CONTEXT_MENU_CLEAR_HISTORY"),// "Очистить историю",
                                     action: "clearHistory"
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
                    } else {
                        options.push({
                                         name: qsTr("CONTACT_CONTEXT_MENU_ADD_CONTACT"),// "Добавить в контакт",
                                         action: "addContact"
                                     });
                    }

                    if (Messenger.isUserBlocked(item)) {
                        options.push({
                                         name: qsTr("Разблокировать"),
                                         action: "unblockContact"
                                    });
                    } else {
                        options.push({
                                         name: qsTr("Заблокировать"),
                                         action: "blockContact"
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
