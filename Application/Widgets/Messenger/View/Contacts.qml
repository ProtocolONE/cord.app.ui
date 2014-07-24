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

WidgetView {
    id: root

    property bool isSearching: false

    implicitWidth: parent.width
    implicitHeight: parent.height

    Rectangle {
        anchors {
            fill: parent
            leftMargin: 1
        }

        color: Styles.style.messengerContactsBackground

        Column {
            anchors.fill: parent

            Search {
                id: searchContactItem

                width: parent.width
                onSearchTextChanged: {
                    root.isSearching = (searchText.length > 0);
                    if (root.isSearching) {
                        searchContactList.updateFilter(searchText);
                    }
                }
            }

            Item {
                width: parent.width
                height: parent.height - searchContactItem.height - bottomBar.height

                PlainContacts {
                    anchors.fill: parent
                    visible: !root.isSearching
                }

                SearchContactList {
                    id: searchContactList

                    visible: root.isSearching
                    anchors.fill: parent
                    onUserClicked: searchContactItem.searchText = "";
                }
            }

            BottomBar {
                id: bottomBar
            }
        }

        AnimatedImage {
            anchors.centerIn: parent
            visible: MessengerJs.isConnecting()
            source: installPath + "Assets/Images/Application/Widgets/Messenger/wait.gif"
        }
    }

    Rectangle {
        width: 1
        height: parent.height
        color: Qt.lighter(Styles.style.messengerContactsBackground, Styles.style.lighterFactor)
    }
}
