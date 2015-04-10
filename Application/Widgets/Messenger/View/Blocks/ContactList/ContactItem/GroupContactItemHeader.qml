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

import "../../../../Models/Messenger.js" as Messenger

Rectangle {
    id: root

//    property alias nickname : nicknameText.text
//    property alias avatar: avatarImage.source
//    property string status: ""
//    property string extendedStatus: ""
//    property bool extendedInfoEnabled: false

//    property alias presenceStatus: presenceIcon.status

//    property string userId: ""

    property alias occupantModel: occupantView.model

    signal nicknameClicked()
    signal clicked()
    signal rightButtonClicked(variant mouse);

    signal groupButtonClicked();

    implicitWidth: 78
    implicitHeight: 68

    color: Styles.style.messengerContactBackgroundSelected

    QtObject {
        id: d

        property string imageRoot: installPath + "Assets/Images/Application/Widgets/Messenger/ContactItem/"
        property bool extendedInfoVisible: mouser.containsMouse

        function getAvatar(user) {
            var q = Messenger.userAvatar(user);
            console.log('--- GORUP HEADER AVATAR REQUEST', JSON.stringify(user), q);
            return q;
        }


    }

    CursorMouseArea { // UNDONE подумать можету брать эту mouseArea
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

        enabled: false

        Row {
            anchors {
                fill: parent
                leftMargin: 12
                topMargin: 12
                bottomMargin: 12
            }

            spacing: 7

            Rectangle {
                width: 200
                height: parent.height
                color: "red"
            }

            Rectangle {
                width: 248
                height: parent.height
                color: "red"

                ListView {
                    id: occupantView

                    anchors.fill: parent
                    spacing: 7
                    interactive: false
                    orientation: ListView.Horizontal

                    delegate: Item {
                        width: 44
                        height: 44
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            width: 44
                            height: 44
                            source: d.getAvatar(model);
                        }

                        Rectangle { // star for woner
                            color: "yellow"
                            width: 14
                            height: 14

                            visible: model.affiliation === "owner"

                            anchors {
                                top: parent.top
                                right: parent.right
                            }
                        }

                        PresenceIcon {
                            status: model.presenceState
                        }

                        CursorMouseArea {
                            visible: model.jid != Messenger.authedUser().jid
                            anchors.fill: parent
                            onClicked: Messenger.selectUser(model);
                        }

                    }
                }
            }


//            Image {
//                id: avatarImage

//                width: 43
//                height: 43
//                cache: false
//                asynchronous: true

//                CursorMouseArea {
//                    toolTip: qsTr("CONTACT_ITEM_NICKNAME_TOOLTIP").arg(nicknameText.text)
//                    anchors.fill: parent
//                    onClicked: root.nicknameClicked();
//                }
//            }

//            Item {
//                width: 28
//                height: parent.height

//                PresenceIcon {
//                    id: presenceIcon

//                    anchors {
//                        horizontalCenter: parent.horizontalCenter
//                        top: parent.top
//                        topMargin: 2
//                    }
//                }

//                Rectangle {
//                    anchors.fill: parent
//                    color: "green"
//                    opacity: 0.5
//                }
//            }

//            Item {
//                height: parent.height
//                width: parent.width - 60

//                Column {
//                    anchors.fill: parent

//                    Item {
//                        width: parent.width
//                        height: nicknameText.height
//                        clip: true

//                        Text {
//                            id: nicknameText

//                            function getTextColor() {
//                                var map = {
//                                    unread: Styles.style.messengerContactNicknameUnread,
//                                    selected: Styles.style.messengerContactNicknameSelected,
//                                    normal: Styles.style.messengerContactNickname,
//                                }

//                                return map[root.state] || Styles.style.messengerContactNickname;
//                            }

//                            anchors.left: parent.left

//                            font {
//                                family: "Arial"
//                                pixelSize: 14
//                            }

//                            height: 20
//                            width: parent.width
//                            color: nicknameText.getTextColor()
//                            elide: Text.ElideRight

//                            CursorMouseArea {
//                                toolTip: qsTr("CONTACT_ITEM_NICKNAME_TOOLTIP").arg(nicknameText.text)
//                                width: parent.paintedWidth
//                                height: parent.height
//                                onClicked: root.nicknameClicked();
//                            }
//                        }
//                    }

//                    Item {
//                        width: parent.width
//                        height: statusText.height

//                        // INFO Тут немнго нелогичное поведение для контрола ScrollText
//                        // Требуется выйти за границы дефолтного места текста, для этого расширим клип зону.
//                        Item {
//                            clip: true
//                            anchors {
//                                fill: parent
//                                leftMargin: -22
//                            }

//                            ScrollText {
//                                id: statusText

//                                clip: false
//                                anchors {
//                                    left: parent.left
//                                    leftMargin: 22
//                                }

//                                width: parent.width - 4 - 22
//                                text: (mouser.containsMouse && root.extendedInfoEnabled)
//                                        ? root.extendedStatus
//                                        : root.status

//                                color: Styles.style.messengerContactStatusText
//                                font {
//                                    family: "Arial"
//                                    pixelSize: 12
//                                }

//                                textMoveDuration: 2000
//                            }
//                        }
//                    }
//                }


//                Rectangle {
//                    anchors.fill: parent
//                    color: "yellow"
//                    opacity: 0.2
//                }


//                Button {
//                    width: 44
//                    height: 44

//                    anchors {
//                        right: parent.right
//                        rightMargin: 27
//                        top: parent.top
//                    }

//                    onClicked: root.groupButtonClicked();
//                }
//            }
        }
    }
}
