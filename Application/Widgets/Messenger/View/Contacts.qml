import QtQuick 2.4
import Tulip 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import Application.Controls 1.0

import "../Models/Messenger.js" as MessengerJs
import "./Blocks/ContactList"
import Application.Core 1.0
import Application.Core.Styles 1.0

WidgetView {
    id: root

    property bool isSearching: searchContactItem.searchText.length > 0

    implicitWidth: parent.width
    implicitHeight: parent.height

    Keys.onEscapePressed: MessengerJs.closeChat()

    Keys.onPressed: {
        var target = searchContactItem.localSearch ? searchContactList : webSearch;
        var actions = {};

        actions[Qt.Key_Up] = 'decrementIndex';
        actions[Qt.Key_Down] = 'incrementIndex';
        actions[Qt.Key_Home] = 'scrollToStart';
        actions[Qt.Key_End] = 'scrollToEnd';
        actions[Qt.Key_PageUp] = 'decrementIndexPgUp';
        actions[Qt.Key_PageDown] = 'incrementIndexPgDown';

        if (actions.hasOwnProperty(event.key) && target.hasOwnProperty(actions[event.key])) {
            target[actions[event.key]].apply(target);
            return;
        }

        if (target.isAnyItemHighlighted() &&
           (event.key == Qt.Key_Enter || event.key == Qt.Key_Return)) {
            target.selectCurrentUser();
            if (searchContactItem.localSearch) {
                searchContactItem.searchText = '';
            }
        }
    }

    QtObject {
        id: d

        property bool hasContacts: allContacts.hasContacts || recentConversation.hasContacts
        property string imageRoot: installPath + "Assets/Images/Application/Widgets/Messenger/"
    }

    Item {
        anchors {
            fill: parent
            leftMargin: 1
        }

        ContentBackground {
            anchors.fill: parent
        }

        Column {
            anchors.fill: parent

            Search {
                id: searchContactItem

                width: parent.width
                onLocalSearchChanged: searchText = '';

                Keys.onPressed: {
                    if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                        var target = searchContactItem.localSearch ? searchContactList : webSearch;
                        target.selectFirstUser();
                    }
                }
            }

            Item {
                width: parent.width
                height: parent.height - searchContactItem.height

                EmptyContactListInfo {
                    function isVisible() {
                        if (!MessengerJs.isContactReceived()) {
                            return false;
                        }

                        if (!searchContactItem.localSearch) {
                            return false;
                        }

                        return (!d.hasContacts && !root.isSearching)
                            || (root.isSearching && showSearchTipOnly);
                    }

                    visible: isVisible()
                    anchors.fill: parent
                    showSearchTipOnly: searchContactItem.localSearch && searchContactList.nothingFound
                }

                Item {
                    id: contactListItem

                    anchors.fill: parent
                    visible: !root.isSearching && d.hasContacts && searchContactItem.localSearch

                    ContactsTypeTabs {
                        id: tabView

                        width: parent.width
                        height: 38
                        recentUnreadedContacts: MessengerJs.getRecentConversationItem().unreadContactCount
                        onMarkAllRead:MessengerJs.markAllMessagesRead()
                    }

                    Item {
                        anchors {
                            fill: parent
                            topMargin: 38
                        }

                        Item {
                            id: contactsTabItem

                            anchors.fill: parent
                            visible: tabView.isContactsVisible

                            Item {
                                width: parent.width
                                height: 46

                                CheckedButton {
                                    id: editGroupButton

                                    width: 32
                                    height: 22
                                    icon: installPath + Styles.messengerGroupIcon
                                    checked: MessengerJs.editGroupModel().isActive()

                                    anchors {
                                        left: parent.left
                                        leftMargin: 12
                                        verticalCenter: parent.verticalCenter
                                    }

                                    analytics {
                                        category: "Messenger EditGroup"
                                        action: 'toggle'
                                        label: "OpenGroupEdit"
                                        value: checked|0
                                    }

                                    onClicked: {
                                        if (editGroupButton.checked) {
                                            MessengerJs.editGroupModel().close();
                                            return;
                                        }

                                        MessengerJs.editGroupModel().createRoom();
                                    }
                                }

                                ContactFilter {
                                    id: contactFilter

                                    anchors {
                                        left: parent.left
                                        leftMargin: 12 + 32 + 10
                                        right: parent.right
                                        rightMargin: 12
                                        verticalCenter: parent.verticalCenter
                                    }

                                    height: 22
                                }
                            }

                            Item {
                                anchors {
                                    fill: parent
                                    topMargin: 46
                                }

                                AllContactView {
                                    id: allContacts

                                    anchors.fill: parent
                                    visible: contactFilter.showAll
                                }

                                PlayingGameContacts {
                                    anchors.fill: parent
                                    visible: !contactFilter.showAll
                                }
                            }
                        }

                        RecentConversation {
                            id: recentConversation

                            anchors.fill: parent
                            visible: tabView.isRecentVisible
                        }
                    }
                }

                SearchContactList {
                    id: searchContactList

                    searchText: searchContactItem.localSearch
                                ? searchContactItem.searchText
                                : ""

                    opacity: (root.isSearching && searchContactItem.localSearch) ? 1 : 0
                    visible: opacity > 0
                    anchors.fill: parent
                    onUserClicked: searchContactItem.searchText = "";

                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                WebSearch {
                    id: webSearch

                    anchors.fill: parent
                    visible: !searchContactItem.localSearch
                    searchText: searchContactItem.searchText
                }

                Splash {
                    visible: MessengerJs.getStatus() === MessengerJs.ROSTER_RECEIVING;
                    text: qsTr("MESSENGER_STATUS_RECEIVING_CONTACTS")
                    anchors.fill: parent
                    waitTopMargin: 107
                }
            }
        }

        Splash {
            property bool reconnecting: MessengerJs.getStatus() === MessengerJs.RECONNECTING

            visible: MessengerJs.getStatus() === MessengerJs.CONNECTING
                     || MessengerJs.getStatus() === MessengerJs.RECONNECTING
            text: reconnecting ? qsTr("MESSENGER_STATUS_RECONNECTING")
                      : qsTr("MESSENGER_STATUS_CONNECTING")
            anchors {
                fill: parent
                topMargin: 1
            }
        }
    }

    ContentStroke {
        height: parent.height
    }

    ContentStroke {
        anchors.right: parent.right
        height: parent.height
    }
}
