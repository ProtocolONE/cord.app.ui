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

    ButtonStyleColors {
        id: unpushedStyle

        normal: Qt.darker(Styles.style.messengerContactsTypeTabBackground, Styles.style.darkerFactor * 1.2)
        hover: Qt.darker(Styles.style.messengerContactsTypeTabBackground, Styles.style.darkerFactor * 1.4)
        disabled: Styles.style.messengerContactsTypeTabBackground
    }

    ButtonStyleColors {
        id: pushedStyle

        normal: Styles.style.messengerContactsTypeTabBackground
        hover: Styles.style.messengerContactsTypeTabBackground
        disabled: Styles.style.messengerContactsTypeTabBackground
    }

    Row {
        anchors.fill: parent
        spacing: 2

        Button {
            id: contactsButton

            width: root.width / 2 - 1
            height: root.height
            text: qsTr("CONTACT_LIST_TABS_CONTACTS")
            onClicked: contactViewState.state = "AllContacts"
            style: unpushedStyle
            enabled: true
        }

        Button {
            id: recentButton

            width: root.width / 2 - 1
            height: root.height
            text: qsTr("CONTACT_LIST_TABS_RECENT")
            style: unpushedStyle
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
                    style: pushedStyle
                    textColor: Styles.style.messengerContactGroupName
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
                    style: pushedStyle
                    textColor: Styles.style.messengerContactGroupName
                    enabled: false
                }
            }
        ]
    }
}
