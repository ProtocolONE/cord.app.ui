import QtQuick 2.4

import GameNet.Controls 1.0

import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0

FocusScope {
    id: searchContactItem

    property alias searchText: searchContactInput.text
    property bool localSearch: true

    width: parent.width
    height: 54

    Rectangle {
        id: background

        anchors.fill: parent
        color: Styles.contentBackgroundLight
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
            icon: installPath + (searchContactItem.localSearch
                                 ? Styles.messengerLocalSearchIcon
                                 : Styles.messengerWebSearchIcon)

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

            icon: installPath + Styles.messengerChatSearchIcon
            clearOnEsc: true
            placeholder: localSearch ? qsTr("MESSENGER_SEARCH_FRIEND_PLACE_HOLDER") :
                                       qsTr("MESSENGER_WEB_SEARCH_PLACE_HOLDER")

            onIconClicked: searchContactInput.forceActiveFocus()
        }
    }
}

