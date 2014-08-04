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

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../Models/Messenger.js" as MessengerJs
import "./Blocks/ContactList"
import "../../../Core/Styles.js" as Styles
import "../../../../Application/Core/App.js" as App

WidgetView {
    id: root

    property bool isSearching: false

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
            root.isSearching = false;
            if (searchContactItem.localSearch) {
                searchContactItem.searchText = '';
            }
            target.selectCurrentUser();
        }
    }

    QtObject {
        id: d

        property bool contactReceived: false
        property bool hasContacts: MessengerJs.users().count > 1 // INFO 1 - GameNet user.
    }

    Connections {
        target: MessengerJs.instance()
        onRosterRecieved: d.contactReceived = true;
    }

    Connections {
        target: App.signalBus()
        onLogoutDone: d.contactReceived = false;
    }

    Rectangle {
        anchors {
            fill: parent
            leftMargin: 1
        }

        color: searchContactItem.localSearch ? Styles.style.messengerContactsBackground :
                                               Styles.style.messengerWebSearchBackground

        Behavior on color {
            ColorAnimation { duration: 250 }
        }

        Column {
            anchors.fill: parent

            Search {
                id: searchContactItem

                width: parent.width
                onSearchTextChanged: {
                    if (searchContactItem.localSearch) {
                        root.isSearching = (searchText.length > 0);
                        if (root.isSearching) {
                            searchContactList.updateFilter(searchText);
                        }
                    }
                }
                onLocalSearchChanged: searchText = '';
            }

            Item {
                width: parent.width
                height: parent.height - searchContactItem.height - bottomBar.height

                EmptyContactListInfo {
                    visible: !d.hasContacts && !root.isSearching && d.contactReceived
                    anchors.fill: parent
                    opacity: (!root.isSearching && searchContactItem.localSearch) ? 1 : 0

                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                Item {
                    id: contactListItem

                    anchors.fill: parent
                    visible: !root.isSearching && d.hasContacts && searchContactItem.localSearch

                    ContactsTypeTabs {
                        id: tabView

                        width: parent.width
                        height: 20
                        recentUnreadedContacts: recentConversation.unreadContactCount
                    }

                    Item {
                        anchors {
                            fill: parent
                            topMargin: 20
                        }

                        PlainContacts {
                            id: allContacts

                            anchors.fill: parent
                            visible: tabView.isContactsVisible
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

                    opacity: (root.isSearching && searchContactItem.localSearch) ? 1 : 0
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
            }

            BottomBar {
                id: bottomBar
            }
        }

        AnimatedImage {
            anchors.centerIn: parent
            visible: !d.contactReceived
            source: installPath + "Assets/Images/Application/Widgets/Messenger/wait.gif"
        }
    }

    Rectangle {
        width: 1
        height: parent.height
        color: Qt.lighter(Styles.style.messengerContactsBackground, Styles.style.lighterFactor)
    }
}
