/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import Application.Core 1.0
import Application.Core.Styles 1.0
import Application.Controls 1.0
import GameNet.Controls 1.0

Item {
    id: root

    property bool isContactsVisible: false
    property bool isRecentVisible: false

    property int recentUnreadedContacts: 0

    width: parent.width
    height: 20
    signal markAllRead();

    function contextMenuClicked(action) {
        if (action === 'mark_all_read')
            markAllRead();
    }

    Connections {
        target: SignalBus
        ignoreUnknownSignals: true

        onTrayIconClicked: {
            if (root.recentUnreadedContacts > 0) {
                contactViewState.state = "RecentConversation"
            }
        }
    }

    Row {
        anchors.fill: parent
        spacing: 2

        ContactsTypeTab {
            id: contactsButton

            width: root.width / 2 - 1
            height: root.height

            text: qsTr("CONTACT_LIST_TABS_CONTACTS")
            onClicked: contactViewState.state = "AllContacts"
        }

        ContactsTypeTab {
            id: recentButton

            width: root.width / 2 - 1
            height: root.height

            text: qsTr("CONTACT_LIST_TABS_RECENT")
            onClicked: contactViewState.state = "RecentConversation"

            CursorMouseArea {
                id: recentMouse

                anchors.fill: parent
                hoverEnabled: true
                cursor: Qt.ArrowCursor
                acceptedButtons: Qt.RightButton
                onClicked: {
                    ContextMenu.show(mouse, recentMouse, recentContextMenu, { });
                }
            }

            Rectangle {
                visible: root.recentUnreadedContacts > 0
                color: Styles.messengerRecentContactsUnreadIcon
                radius: 4
                width: 8
                height: 8
                anchors {
                    right: parent.right
                    rightMargin: 5
                    verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    StateGroup {
        id: contactViewState

        state: "AllContacts"

        states: [
            State {
                name: "AllContacts"

                PropertyChanges {
                    target: root
                    isContactsVisible: true
                    isRecentVisible: false
                }

                PropertyChanges {
                    target: contactsButton
                    selected: true
                }
            },
            State {
                name: "RecentConversation"

                PropertyChanges {
                    target: root
                    isContactsVisible: false
                    isRecentVisible: true
                }

                PropertyChanges {
                    target: recentButton
                    selected: true
                }
            }
        ]
    }

    Component {
        id: recentContextMenu

        ContextMenuView {
            id: contextMenu

            onContextClicked: {
                root.contextMenuClicked(action)
                ContextMenu.hide();
            }

            Component.onCompleted: {
                var options = [];
                options.push({
                                 name: qsTr("RECENT_CONTEXT_MENU_MARK_ALL_READ"),
                                 action: "mark_all_read"
                             });

                fill(options);
            }
        }
    }
}
