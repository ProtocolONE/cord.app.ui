import QtQuick 1.1
import GameNet.Controls 1.0
import "../../../../../Core/Styles.js" as Styles

Item {
    id: root

    signal clicked();
    signal inviteFriend();

    property string searchText
    property bool isActive
    property variant charsList
    property bool isHighlighted: false
    property bool isInviteToFriendSended: false
    property bool isFriend: false

    property string nickname
    property string avatar
    property string charsText

    property bool inviteMaximumLimitSended: false

    implicitWidth: 78
    height: 57 + textInfoColumn.height

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }

    Rectangle {
        id: background

        anchors.fill: parent
        color: root.isActive ? Styles.style.messengerContactBackgroundSelected :
                               Styles.style.messengerContactBackground
    }

    Rectangle {
        anchors {
            fill: parent
            margins: 4
            rightMargin: 14
        }
        color: background.color

        border {
            width: 1
            color: Qt.darker(background.color, Styles.style.darkerFactor * 1.5)
        }
        visible: root.isHighlighted && !root.isActive
    }

    Rectangle {
        id: upperDelimiter

        height: 1
        width: parent.width
        color: Qt.lighter(background.color, Styles.style.lighterFactor)
        anchors.top: parent.top
    }

    Item {
        height: 42
        width: parent.width

        Row {
            anchors {
                fill: parent
                margins: 10
            }
            spacing: 8

            Image {
                id: avatarImage

                width: 32
                height: 32

                cache: false
                asynchronous: true
                source: root.avatar
            }

            Column {
                width: parent.width
                height: parent.height

                Text {
                    id: nicknameText

                    font {
                        family: "Arial"
                        pixelSize: 14
                    }

                    height: 18
                    width: parent.width - 40
                    elide: Text.ElideRight
                    text: root.nickname
                    color: root.isActive ? Styles.style.messengerContactNicknameSelected :
                                           Styles.style.messengerContactNickname
                }

                TextButton {
                    width: parent.width - 40
                    height: 16

                    text: root.inviteMaximumLimitSended ? qsTr("INVITE_MAXIMUM_LIMIT_SENDED") :
                          root.isInviteToFriendSended ? qsTr("INVITE_TO_FRIEND_SENDED") : qsTr("SEND_INVITE_TO_FRIEND")
                    fontSize: 11
                    visible: !root.isFriend
                    enabled: !root.isInviteToFriendSended && !root.inviteMaximumLimitSended
                    style {
                        normal: "#3498db"
                        hover: "#3670DC"
                        disabled: "#3498db"
                    }

                    font.family: 'Tahoma'

                    onClicked: root.inviteFriend();
                }
            }
        }
    }

    Column {
        id: textInfoColumn

        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
            rightMargin: 10
            leftMargin: 10
            topMargin: 49
        }
        spacing: 3

        Text {
            font {
                family: 'Tahoma'
                pixelSize: 11
            }
            text: root.charsText
            wrapMode: Text.WordWrap
            width: parent.width
            color: root.isActive ? Styles.style.messengerContactNicknameSelected :
                                   Styles.style.messengerContactNickname
        }
    }

    Rectangle {
        id: bottomDelimiter

        height: 1
        width: parent.width
        color: Qt.darker(background.color, Styles.style.darkerFactor)
        anchors.bottom: parent.bottom
    }
}
