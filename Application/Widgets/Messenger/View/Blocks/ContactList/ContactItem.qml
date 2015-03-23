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
import "../../../../../Core/App.js" as App

Rectangle {
    id: root

    property int modelIndex: 0

    property alias nickname : nicknameText.text
    property alias avatar: avatarImage.source
    property string status: ""
    property string extendedStatus: ""

    property alias isPresenceVisile: presenceIcon.visible
    property alias mouseEnabled: mouser.enabled

    property bool isCurrent: false
    property bool isUnreadMessages: false
    property bool isHighlighted: false

    property string presenceStatus: ""

    property bool extendedInfoEnabled: false
    property string userId: ""
    property bool isBigItem: false

    signal nicknameClicked()
    signal clicked()
    signal rightButtonClicked(variant mouse);
    signal informationClicked();

    implicitWidth: 78
    implicitHeight: 40

    color: root.getBgColor()

    function getBgColor() {
        var map = {
            unread: Styles.style.messengerContactBackgroundUnread,
            selected: Styles.style.messengerContactBackgroundSelected,
            normal: Styles.style.messengerContactBackground,
        }

        return map[root.state] || Styles.style.messengerContactBackground;
    }

    QtObject {
        id: d

        property string imageRoot: installPath + "Assets/Images/Application/Widgets/Messenger/ContactItem/"
        property bool extendedInfoVisible: mouser.containsMouse || informationIcon.containsMouse
    }

    Rectangle {
        anchors {
            fill: parent
            topMargin: 1
            leftMargin: 1
            bottomMargin: 2
            rightMargin: 2
        }
        color: root.color

        radius: 1
        border {
            width: 1
            color: Styles.style.messengerContactBackgroundHightlighted
        }
        visible: root.isHighlighted && !root.isCurrent
    }

    CursorMouseArea {
        id: mouser

        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent
        onClicked: {
            if (mouse.button === Qt.RightButton) {
                root.rightButtonClicked(mouse);
            }

            if (mouse.button === Qt.LeftButton) {
                root.clicked();
            }
        }

        Row {
            anchors {
                fill: parent
                leftMargin: 12
                topMargin: root.isBigItem ? 10 : 4
                bottomMargin: 4
            }

            Image {
                id: avatarImage

                width: root.isBigItem ? 43 : 32
                height: root.isBigItem ? 43 : 32
                cache: false
                asynchronous: true

                CursorMouseArea {
                    toolTip: qsTr("CONTACT_ITEM_NICKNAME_TOOLTIP").arg(nicknameText.text)
                    visible: !root.mouseEnabled
                    anchors.fill: parent
                    onClicked: root.nicknameClicked();
                }
            }

            Item {
                width: 28
                height: parent.height

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
                    }

                    width: 12
                    height: 12
                    radius: 6
                    color: presenceStatusToColor(root.presenceStatus)

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: 2
                    }
                }
            }

            Item {
                height: parent.height
                width: parent.width - 60

                Column {
                    anchors.fill: parent

                    Item {
                        width: parent.width
                        height: nicknameText.height
                        clip: true

                        Text {
                            id: nicknameText

                            function getTextColor() {
                                var map = {
                                    unread: Styles.style.messengerContactNicknameUnread,
                                    selected: Styles.style.messengerContactNicknameSelected,
                                    normal: Styles.style.messengerContactNickname,
                                }

                                return map[root.state] || Styles.style.messengerContactNickname;
                            }

                            anchors.left: parent.left

                            font {
                                family: "Arial"
                                pixelSize: 14
                                bold: root.isUnreadMessages
                            }

                            height: 20
                            width: parent.width - (informationIcon.visible ? informationIcon.width + 8 : 0)
                            color: nicknameText.getTextColor()
                            elide: Text.ElideRight

                            CursorMouseArea {
                                toolTip: qsTr("CONTACT_ITEM_NICKNAME_TOOLTIP").arg(nicknameText.text)
                                visible: !root.mouseEnabled
                                width: parent.paintedWidth
                                height: parent.height
                                onClicked: root.nicknameClicked();
                            }
                        }

                        ImageButton {
                            id: informationIcon

                            visible: d.extendedInfoVisible

                            width: 11
                            height: 11
                            anchors {
                                top: parent.top
                                topMargin: 2
                                right: parent.right
                                rightMargin: 4
                            }

                            analytics {
                                page: "/messenger"
                                category: "ContactList"
                                action: "OpenDetailedUserInfo"
                            }

                            style {
                                normal: "#00000000"
                                hover: "#00000000"
                                disabled: "#00000000"
                            }

                            styleImages {
                               normal: d.imageRoot + "infoIconNormal.png"
                               hover: d.imageRoot + "infoIconHover.png"
                            }

                            onClicked: App.openDetailedUserInfo({
                                                                    userId: root.userId,
                                                                    nickname: root.nickname,
                                                                    status: root.presenceStatus
                                                                });
                        }
                    }

                    Item {
                        width: parent.width
                        height: statusText.height

                        // INFO Тут немнго нелогичное поведение для контрола ScrollText
                        // Требуется выйти за границы дефолтного места текста, для этого расширим клип зону.
                        Item {
                            clip: true
                            anchors {
                                fill: parent
                                leftMargin: -22
                            }

                            ScrollText {
                                id: statusText

                                clip: false
                                anchors {
                                    left: parent.left
                                    leftMargin: 22
                                }

                                width: parent.width - 4 - 22
                                text: (mouser.containsMouse && root.extendedInfoEnabled)
                                        ? root.extendedStatus
                                        : root.status

                                color: Styles.style.messengerContactStatusText
                                font {
                                    family: "Arial"
                                    pixelSize: 12
                                }

                                textMoveDuration: 2000
                            }
                        }
                    }
                }
            }
        }
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
            when: !root.isCurrent && !root.isUnreadMessages
        }
    ]
}
