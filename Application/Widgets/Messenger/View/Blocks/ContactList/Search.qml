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
import Application.Controls 1.0

import "../../../../../Core/Styles.js" as Styles
import "../../../../../../GameNet/Controls/Tooltip.js" as Tooltip

FocusScope {
    id: searchContactItem

    property alias searchText: searchContactInput.text
    property bool localSearch: true

    width: parent.width
    height: 54

    Rectangle {
        id: background

        anchors.fill: parent
        color: "#4ca8db"
        opacity: 0.15
    }

    Row {
        anchors {
            fill: parent
            margins: 10
            topMargin: 11
            bottomMargin: 11
        }

        spacing: 10

        CheckedButton {
            id: button

            width: 32
            height: 32
            boldBorder: true
            onClicked: searchContactItem.localSearch = !searchContactItem.localSearch;
            icon: (installPath + "Assets/Images/Application/Widgets/Messenger/")
                    + (searchContactItem.localSearch ? "localSearch.png" : "webSearch.png")

            StateGroup {
                states: [
                    State {
                        name: "LocalSearch"
                        when: searchContactItem.localSearch
                    },
                    State {
                        name: "WebSearch"
                        when: !searchContactItem.localSearch
                    }
                ]

                transitions: [
                    Transition {
                        from: "*"
                        to: "WebSearch"

                        SequentialAnimation {
                            PauseAnimation { duration: Tooltip.animationDuration() }
                            ScriptAction {
                                script: button.toolTip = qsTr("LOCAL_SEARCH_BUTTON_TULTIP");
                            }
                        }
                    },
                    Transition {
                        from: "*"
                        to: "LocalSearch"

                        SequentialAnimation {
                            PauseAnimation { duration: Tooltip.animationDuration() }

                            ScriptAction {
                                script: button.toolTip = qsTr("WEBSEARCH_BUTTON_TULTIP");
                            }
                        }
                    }
                ]
            }
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
}

