/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import Tulip 1.0

import GameNet.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

import "../../" as Blocks

Item {
    id: root

    property alias nickname : nicknameText.text
    property alias avatar: avatarImage.source
    property string status: ""
    property string extendedStatus: ""
    property bool extendedInfoEnabled: false

    property alias presenceStatus: presenceIcon.status

    property string userId: ""
    property alias isGameNetMember: shieldItem.visible

    signal nicknameClicked()
    signal clicked()
    signal rightButtonClicked(variant mouse);
    signal informationClicked();

    signal groupButtonClicked();

    implicitWidth: 78
    implicitHeight: 72

    onNicknameClicked: d.openProfile()

    QtObject {
        id: d

        property bool isGameNetUser: !root.userId // у GameNet пользователя userId пустой
        property string imageRoot: installPath + "Assets/Images/Application/Widgets/Messenger/ContactItem/"

        function openProfile() {
            if (!root.userId) {
                return;
            }

            App.openProfile(root.userId);
        }
    }

    Row {
        anchors {
            fill: parent
            leftMargin: 12
            topMargin: 12
            bottomMargin: 12
        }

        Image {
            id: avatarImage

            width: 48
            height: 48
            cache: false
            asynchronous: true

            CursorMouseArea {
                visible: !d.isGameNetUser
                toolTip: qsTr("CONTACT_ITEM_NICKNAME_TOOLTIP").arg(nicknameText.text)
                anchors.fill: parent
                onClicked: root.nicknameClicked();
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
            width: parent.width - (76 + 48 + 8)

            Column {
                anchors.fill: parent

                Item {
                    id: nickRowItem

                    width: parent.width
                    height: nicknameText.height
                    clip: true

                    Text {
                        id: nicknameText

                        font {
                            family: "Arial"
                            pixelSize: 14
                        }

                        height: 20
                        width: nickRowItem.width -
                               (shieldItem.visible ? (shieldItem.width + 5) : 0)
                        color: Styles.menuText
                        elide: Text.ElideRight
                        textFormat: Text.PlainText

                        CursorMouseArea {
                            visible: !d.isGameNetUser
                            toolTip: qsTr("CONTACT_ITEM_NICKNAME_TOOLTIP").arg(nicknameText.text)
                            width: nickRowItem.paintedWidth
                            height: nickRowItem.height
                            onClicked: root.nicknameClicked();
                        }
                    }

                    Blocks.GameNetShield {
                        id: shieldItem

                        anchors {
                            left: parent.left
                            leftMargin: nicknameText.paintedWidth + 5
                        }
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
                            text: root.status

                            color: Styles.textBase
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

    EditGroupButton {
        anchors {
            top: parent.top
            topMargin: 12
            right: parent.right
        }

        visible: !d.isGameNetUser
        checked: false
        onClicked: root.groupButtonClicked()
    }
}
