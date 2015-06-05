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

Item {
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
    property int unreadMessageCount: 0
    property bool isHighlighted: false

    property bool editMode: false
    property bool checked: false

    signal clicked()
    signal rightButtonClicked(variant mouse);
    signal nicknameChangeRequest(string value);

    implicitWidth: 78
    implicitHeight: 40

    Rectangle {
        visible: root.isCurrent
        anchors.fill: parent
        color: Styles.style.light
        opacity: 0.10
    }

    function startEdit() {
        editNickname.text = root.nickname;
        editNickname.visible = true
        editNickname.selectAll();
        editNickname.forceActiveFocus();
    }

    QtObject {
        id: d

        property string imageRoot: installPath + "Assets/Images/Application/Widgets/Messenger/ContactItem/"
        property bool extendedInfoVisible: mouser.containsMouse
    }

    Rectangle {
        anchors {
            fill: parent
            rightMargin: 1
        }

        color: "#00000000"

        smooth: false
        opacity: 0.25
        border {
            width: 1
            color: Styles.style.light
        }
        visible: root.isHighlighted
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
                    containsMouse: mouser.containsMouse
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
                                if (root.isUnreadMessages) {
                                    return Styles.style.bannerInfoText;
                                }

                                return Styles.style.menuText;
                            }

                            anchors.left: parent.left

                            font {
                                family: "Arial"
                                pixelSize: 14
                            }

                            height: 20
                            width: parent.width - (unreadMessageCountText.visible ? unreadMessageCountText.width + 14 : 0)
                            color: nicknameText.getTextColor()
                            elide: Text.ElideRight
                            visible: !editNickname.visible
                            textFormat: Text.PlainText
                        }

                        TextInput {
                            id: editNickname

                            visible: false
                            height: 20
                            color: Styles.style.menuText

                            font {
                                family: "Arial"
                                pixelSize: 14
                            }

                            width: nicknameText.width
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

                        Text {
                            id: unreadMessageCountText

                            anchors {
                                right: parent.right
                                rightMargin: 10
                                baseline: nicknameText.baseline
                            }

                            text: root.unreadMessageCount > 99 ? "99+" : root.unreadMessageCount
                            color: Styles.style.bannerInfoText
                            font {
                                pixelSize: 12
                                family: "Arial"
                            }

                            visible: root.isUnreadMessages
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

                                color: Styles.style.textBase
                                opacity: 0.5
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
