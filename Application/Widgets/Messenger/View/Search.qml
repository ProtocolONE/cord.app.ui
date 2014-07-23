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
import GameNet.Controls 1.0

import "../../../Core/Styles.js" as Styles

Rectangle {
    id: searchContactItem

    property alias searchText: searchContactInput.text
    property bool localSearch: true

    width: parent.width
    height: 54
    color: Styles.style.messengerSearchBackground

    Rectangle {
        height: 1
        width: parent.width
        color: Qt.lighter(parent.color, Styles.style.lighterFactor)
        anchors.top: parent.top
    }

    Row {
        anchors {
            fill: parent
            margins: 10
            topMargin: 11
            bottomMargin: 11
        }

        spacing: 10

        Button {
            width: 32
            height: 32

            style: ButtonStyleColors {
                normal: Styles.style.messengerSearchButtonNormal
                hover: Styles.style.messengerSearchButtonHover
            }

            Image {
                anchors.centerIn: parent
                source: installPath + "Assets/Images/Application/Widgets/Messenger/add_friend.png"
            }

            onClicked: localSearch = !localSearch;
        }

        Input {
            id: searchContactInput

            height: parent.height
            width: parent.width - 42

            icon: installPath + "/Assets/Images/Application/Widgets/Messenger/chat_search.png"

            placeholder: qsTr("MESSENGER_SEARCH_FRIEND_PLACE_HOLDER")
            fontSize: 14
            showCapslock: false
            showLanguage: false
            style: InputStyleColors {
                normal: Styles.style.messengerSearchInputNormal
                active: Styles.style.messengerSearchInputActive
                hover: Styles.style.messengerSearchInputHover
                placeholder: Styles.style.messengerSearchInputPlaceholder
            }
        }
    }

    Rectangle {
        height: 1
        width: parent.width
        color: Qt.darker(parent.color, Styles.style.darkerFactor)
        anchors.bottom: parent.bottom
    }
}
