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

import "../../../../../Core/Styles.js" as Styles

FocusScope {
    id: searchContactItem

    property alias searchText: searchContactInput.text
    property bool localSearch: true

    width: parent.width
    height: 54

    Rectangle {
        id: background

        anchors.fill: parent
        color: Styles.style.messengerSearchBackground
    }

    Rectangle {
        height: 1
        width: parent.width
        color: Qt.lighter(background.color, Styles.style.lighterFactor)
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
            id: button

            width: 32
            height: 32

            style {
                normal: Styles.style.messengerSearchButtonNormal
                hover: Styles.style.messengerSearchButtonHover
            }

            Image {
                function getImage() {
                    if (searchContactItem.localSearch) {
                        if (button.containsMouse) {
                            return (installPath + "Assets/Images/Application/Widgets/Messenger/norm_search_active.png");
                        }

                        return installPath + "Assets/Images/Application/Widgets/Messenger/norm_search.png";
                        return;
                    }

                    if (button.containsMouse) {
                        return installPath + "Assets/Images/Application/Widgets/Messenger/web_search_active.png";
                    }

                    return installPath + "Assets/Images/Application/Widgets/Messenger/web_search.png";
                }

                anchors.centerIn: parent
                source: getImage()
            }

            onClicked: localSearch = !localSearch;
        }

        SearchInput {
            id: searchContactInput

            height: parent.height
            width: parent.width - 42

            icon: installPath + "/Assets/Images/Application/Widgets/Messenger/chat_search.png"
            clearOnEsc: true
            placeholder: localSearch ? qsTr("MESSENGER_SEARCH_FRIEND_PLACE_HOLDER") :
                                       qsTr("MESSENGER_WEB_SEARCH_PLACE_HOLDER")

            onIconClicked: searchContactInput.forceActiveFocus()

            fontSize: 12
            showCapslock: false
            showLanguage: false
            style {
                normal: Styles.style.messengerSearchInputNormal
                active: Styles.style.messengerSearchInputActive
                hover: Styles.style.messengerSearchInputHover
                background: Styles.style.messengerSearchInputBackground
                placeholder: Styles.style.messengerSearchInputPlaceholder
                text: Styles.style.messengerSearchInputText

                property color textNormal: Styles.style.messengerSearchInputText
                property color textActive: Styles.style.messengerSearchInputTextHover

                property color backgroundActive: Styles.style.messengerSearchInputBackgroundHover
            }
        }
    }

    Rectangle {
        height: 1
        width: parent.width
        color: Qt.darker(background.color, Styles.style.darkerFactor)
        anchors.bottom: parent.bottom
    }
}

