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

import "../../../../../../Core/Styles.js" as Styles
import "../../../../../../Core/App.js" as App

import "../../Group" as GroupEdit

Rectangle {
    id: root

    property string userId: ""
    property alias nickname : nicknameText.text
    property alias avatar: avatarImage.source
    property string status: ""
    property string extendedStatus: ""
    property alias presenceStatus: presenceIcon.status

    property bool extendedInfoEnabled: false
    property bool showInformationIcon: true

    property bool isCurrent: false
    property bool isUnreadMessages: false
    property bool isHighlighted: false

    property bool editMode: false
    property bool checked: false

    signal clicked()
    signal rightButtonClicked(variant mouse);
    signal nicknameChangeRequest(string value);

    implicitWidth: 78
    implicitHeight: 40

    color: root.getBgColor()

    function startEdit() {
        editNickname.text = root.nickname;
        editNickname.visible = true
        editNickname.selectAll();
        editNickname.forceActiveFocus();
    }

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
                topMargin: 4
                bottomMargin: 4
            }

            Item {
                width: 32
                height: 32

                Image {
                    id: avatarImage

                    width: 32
                    height: 32
                    cache: false
                    asynchronous: true
                }

                GroupEdit.EditCheckBox {
                    checked: root.checked
                    visible: root.editMode
                }
            }

            Item {
                width: 28
                height: parent.height

                PresenceIcon {
                    id: presenceIcon

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
                            visible: !editNickname.visible
                            textFormat: Text.PlainText
                        }

                        TextInput {
                            id: editNickname

                            visible: false
                            height: 20
                            color: Styles.style.messengerContactNickname

                            font {
                                family: "Arial"
                                pixelSize: 14
                            }

                            width: parent.width - (informationIcon.width + 8)
                            Keys.onEnterPressed: {
                                root.nicknameChangeRequest(editNickname.text);
                                editNickname.visible = false;
                            }

                            Keys.onReturnPressed: {
                                root.nicknameChangeRequest(editNickname.text);
                                editNickname.visible = false;
                            }

                            Keys.onEscapePressed: editNickname.visible = false;

                            onActiveFocusChanged: {
                                if (!activeFocus) {
                                    editNickname.visible = false;
                                }
                            }
                        }

                        ImageButton {
                            id: informationIcon

                            visible: root.showInformationIcon && d.extendedInfoVisible

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
