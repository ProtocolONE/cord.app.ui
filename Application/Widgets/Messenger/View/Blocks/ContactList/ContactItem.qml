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

Rectangle {
    id: root

    property alias nickname : nicknameText.text
    property alias avatar: avatarImage.source
    property alias status: statusText.text
    property alias isPresenceVisile: presenceIcon.visible
    property alias mouseEnabled: mouser.enabled

    property bool isCurrent: false
    property bool isUnreadMessages: false
    property bool isHighlighted: false

    property string presenceStatus: ""

    signal nicknameClicked()
    signal clicked()

    implicitWidth: 78
    implicitHeight: 53

    color: root.getBgColor()

    function getBgColor() {
        var map = {
            unread: Styles.style.messengerContactBackgroundUnread,
            selected: Styles.style.messengerContactBackgroundSelected,
            normal: Styles.style.messengerContactBackground,
        }

        return map[root.state] || Styles.style.messengerContactBackground;
    }

    Rectangle {
        anchors {
            fill: parent
            margins: 4
            rightMargin: 14
        }
        color: root.color

        border {
            width: 1
            color: Styles.style.messengerContactBackgroundHightlighted
        }
        visible: root.isHighlighted && !root.isCurrent
    }

    Rectangle {
        id: upperDelimiter

        height: 1
        width: parent.width
        color: Qt.lighter(root.color, Styles.style.lighterFactor)
        anchors.top: parent.top
    }

    CursorMouseArea {
        id: mouser

        enabled: !root.interactiveNickname
        anchors.fill: parent
        onClicked: root.clicked();
    }

    Item {
        anchors {
            fill: parent
            topMargin: 1
            bottomMargin: 1
        }

        Row {
            anchors.fill: parent

            Item {
                height: parent.height
                width: parent.height

                Image {
                    id: avatarImage

                    width: 32
                    height: 32
                    anchors.centerIn: parent
                    cache: true
                    asynchronous: true

                    CursorMouseArea {
                        toolTip: qsTr("CONTACT_ITEM_NICKNAME_TOOLTIP").arg(nicknameText.text)
                        visible: !root.mouseEnabled
                        anchors.fill: parent
                        onClicked: root.nicknameClicked();
                    }
                }
            }

            Column {
                height: parent.height
                width: parent.width - parent.height

                anchors {
                    top: parent.top
                    margins: 8
                }

                Item {
                    width: parent.width
                    height: nicknameText.height

                    Rectangle {
                        id: presenceIcon

                        function presenceStatusToColor(status) {
                            switch(status) {
                            case "online":
                            case "chat":
                                return Styles.style.messengerContactPresenceOnline;
                            case "dnd":
                            case "away":
                            case "xa":
                                return Styles.style.messengerContactPresenceDnd;
                            case "offline":
                            default:
                                return Styles.style.messengerContactPresenceOffline;
                            }

                            return map[root.state] || Styles.style.messengerContactNickname;
                        }

                        width: 8
                        height: 8
                        border {
                            width: 1
                            color: Qt.darker(presenceIcon.color, Styles.style.darkerFactor)
                        }
                        color: presenceStatusToColor(root.presenceStatus)

                        anchors {
                            verticalCenter: nicknameText.baseline
                            verticalCenterOffset: -4
                            left: parent.left
                            leftMargin: 2
                        }
                    }

                    Text {
                        id: statusText

                        anchors {
                            left: parent.left
                            leftMargin: 20
                        }

                        color: Styles.style.messengerContactStatusText
                        font {
                            family: "Arial"
                            pixelSize: 14
                            bold: root.isUnreadMessages
                        }

                        height: 20
                        color: nicknameText.getTextColor()

                        CursorMouseArea {
                            toolTip: qsTr("CONTACT_ITEM_NICKNAME_TOOLTIP").arg(nicknameText.text)
                            visible: !root.mouseEnabled
                            anchors.fill: parent
                            onClicked: root.nicknameClicked();
                        }
                    }
                }

                Text {
                    id: statusText

                    function presenceStatusToColor(status) {
                        switch(status) {
                        case "online":
                        case "chat":
                            return Styles.style.messengerContactPresenceOnline;
                        case "dnd":
                        case "away":
                        case "xa":
                            return Styles.style.messengerContactPresenceDnd;
                        case "offline":
                        default:
                            return Styles.style.messengerContactPresenceOffline;
                        }
                    }

                    color: Styles.style.messengerContactStatusText
                    font {
                        family: "Arial"
                        pixelSize: 12
                    }
                }

            }
        }
    }

    Rectangle {
        id: bottomDelimiter

        height: 1
        width: parent.width
        color: Qt.darker(root.color, Styles.style.darkerFactor)
        anchors.bottom: parent.bottom
    }

    states: [
        State {
            name: "unread"
            when: root.isUnreadMessages
        },
        State {
            name: "selected"
            when: root.isCurrent && !root.isUnreadMessages
        },
        State {
            name: "normal"
        }
    ]
}
