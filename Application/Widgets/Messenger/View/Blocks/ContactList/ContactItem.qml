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

    property bool isCurrent: false
    property bool isUnreadMessages: false

    property string presenceStatus: ""

    signal clicked()

    implicitWidth: 78
    implicitHeight: 53

    Rectangle {
        id: upperDelimiter

        height: 1
        width: parent.width
        color: Qt.lighter(root.color, Styles.style.lighterFactor)
        anchors.top: parent.top
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
                }
            }

            Item {
                height: parent.height
                width: parent.width - parent.height

                Item {
                    anchors.fill: parent
                    anchors.rightMargin: 33

                    Text {
                        id: nicknameText

                        anchors {
                            baseline: parent.top
                            baselineOffset: 22
                        }

                        font {
                            family: "Arial"
                            pixelSize: 14
                            bold: root.isUnreadMessages
                        }

                        width: parent.width
                        elide: Text.ElideRight
                    }

                    Text {
                        id: newMessageStatus

                        anchors {
                            baseline: parent.bottom
                            baselineOffset: -10
                        }

                        visible: root.isUnreadMessages && !root.isCurrent
                        text: qsTr("CONTACT_NEW_MESSAGE")
                        color: Styles.style.messengerContactNewMessageStatusText
                        font {
                            family: "Arial"
                            pixelSize: 12
                        }
                    }

                    Text {
                        id: statusText

                        anchors {
                            baseline: parent.bottom
                            baselineOffset: -10
                        }

                        visible: !newMessageStatus.visible
                        color: Styles.style.messengerContactStatusText
                        font {
                            family: "Arial"
                            pixelSize: 12
                        }
                    }
                }

                Rectangle {
                    id: presenceIcon

                    function presenceStatusToColor(status) {
                        if (status === "online") {
                            return Styles.style.messengerContactPresenceOnline;
                        }

                        if (status === "dnd") {
                            return Styles.style.messengerContactPresenceDnd;
                        }

                        return Styles.style.messengerContactPresenceOffline;
                    }

                    width: 7
                    height: 7
                    radius: 7
                    color: presenceStatusToColor(root.presenceStatus)

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 16
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

    CursorMouseArea {
        anchors.fill: parent
        onClicked: root.clicked();
    }

    states: [
        State {
            name: "unread"
            when: root.isUnreadMessages
            PropertyChanges { target: root; color: Styles.style.messengerContactBackgroundUnread }
            PropertyChanges { target: nicknameText; color: Styles.style.messengerContactNicknameUnread }
        },
        State {
            name: "selected"
            when: root.isCurrent && !root.isUnreadMessages
            PropertyChanges { target: root; color: Styles.style.messengerContactBackgroundSelected }
            PropertyChanges { target: nicknameText; color: Styles.style.messengerContactNicknameSelected }
        },
        State {
            name: "normal"
            PropertyChanges { target: root; color: Styles.style.messengerContactBackground }
            PropertyChanges { target: nicknameText; color: Styles.style.messengerContactNickname }
        }
    ]

}
