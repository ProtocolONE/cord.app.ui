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

import "../../../../../Core/Styles.js" as Styles

Item {
    id: root

    property bool isContactsVisible: false
    property bool isRecentVisible: false

    property int recentUnreadedContacts: 0

    width: parent.width
    height: 20

    Row {
        anchors.fill: parent
        spacing: 2

        Button {
            id: contactsButton

            width: root.width / 2 - 1
            height: root.height
            text: qsTr("CONTACT_LIST_TABS_CONTACTS")
            style: ButtonStyleColors {
                normal:Styles.style.messengerContactsTabNormal
                hover: Styles.style.messengerContactsTabHover
                disabled: Styles.style.messengerContactsTabSelected
            }
            onClicked: contactViewState.state = "AllContacts"
            enabled: true
        }

        Button {
            id: recentButton

            width: root.width / 2 - 1
            height: root.height
            text: qsTr("CONTACT_LIST_TABS_RECENT")
            style: ButtonStyleColors {
                normal: enabled ? Styles.style.messengerContactsTabNormal
                                : Styles.style.messengerContactsTabSelected

                hover: enabled ? Styles.style.messengerContactsTabHover
                               : Styles.style.messengerContactsTabSelected
                disabled: Styles.style.messengerContactsTabSelected
            }
            onClicked: contactViewState.state = "RecentConversation"
            enabled: true

            Rectangle {
                visible: root.recentUnreadedContacts > 0
                color: Styles.style.messengerRecentContactsUnreadIcon
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
                    textColor: Styles.style.messengerContactsTabText
                    enabled: false
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
                    textColor: Styles.style.messengerContactsTabText
                    enabled: false
                }
            }
        ]
    }
}
