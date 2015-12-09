import QtQuick 2.4

import GameNet.Core 1.0
import GameNet.Controls 1.0

import Application.Controls 1.0
import Application.Controls.MessagePopup 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0

import "../Models/Messenger.js" as MessengerJs
import "./MessageReceived.js" as Js

TrayPopupBase {
    id: root

    signal closeButtonClicked()

    property string jid
    property string playingGameServiceId: MessengerJs.userPlayingGame(root)
    property int newHeight: bodyItem.height + 60 + (playingRow.visible ? playingRow.height : 0)

    property variant lastItem;

    function addMessage(from, body, message) {
        root.restartDestroyTimer();

        if (bodyItem.isCropped) {
            return;
        }

        var lastMessageFrom = lastItem ? lastItem.from : "";
        var messageDate = Date.now();
        if (data.stamp != "Invalid Date") {
            messageDate = +(Moment.moment(data.stamp));
        }

        var item = tst.createObject(messageContainer, {
                             from: from,
                             body: body,
                             messageDate: messageDate,
                             showAvatarAndNickname: lastMessageFrom !== from
                         });

        lastItem = item;
    }

    width: 240
    height: Math.max(newHeight, 92)

    Component {
        id: tst

        MessageReceivedDelegate {
            property string from
            property string body
            property variant messageDate

            function getNickname(from) {
                var user = MessengerJs.getUser(from);
                if (!user.isValid()) {
                    return from;
                }

                if (user.isGroupChat) {
                    return MessengerJs.getGroupTitle({jid: from});
                }

                if (user.nickname) {
                    return user.nickname;
                }

                return from;
            }

            function getAvatar(from) {
                return MessengerJs.userAvatar({jid: from});
            }

            date: messageDate
            bodyText: AppStringHelper.prepareText(body, {
                                               hyperLinkStyle: Styles.messengerChatDialogHyperlinkColor,
                                               smileResolver: EmojiOne.ns.toImage,
                                               serviceResolver: App.serviceItemByServiceId
                                           })
            avatar: getAvatar(from)
            nickname: getNickname(from)
            width: parent.width

            onLinkActivated: {
                MessengerJs.instance().messageLinkActivated({jid: root.jid}, link);
                root.anywhereClickDestroy();
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Styles.trayPopupBackground

        Column {
            spacing: 1
            anchors {
                fill: parent
                margins: 1
            }

            Rectangle {
                width: parent.width
                height: 25

                color: Styles.trayPopupHeaderBackground

                Image {
                    anchors {
                        left: parent.left
                        leftMargin: 6
                        verticalCenter: parent.verticalCenter
                    }

                    source: installPath + "Assets/Images/Application/Widgets/Announcements/logo.png"
                }

                ImageButton {
                    id: closeButtonImage

                    anchors {
                        right: parent.right
                        rightMargin: 6
                        verticalCenter: parent.verticalCenter
                    }
                    width: 12
                    height: 12

                    style {
                        normal: "#00000000"
                        hover: "#00000000"
                        disabled: "#00000000"
                    }
                    styleImages {
                        normal: installPath + "Assets/Images/Application/Widgets/Announcements/closeButton.png"
                    }

                    opacity: containsMouse ? 1 : 0.5
                    onClicked: {
                        root.closeButtonClicked();
                        root.shadowDestroy();
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 250
                        }
                    }
                }
            }

            Item {
                id: bodyItem

                property bool isCropped: messageContainer.childrenRect.height > maxContainerHeight
                property int cropItemHeight: isCropped ? 10 : 0;
                property int maxContainerHeight: 200

                width: parent.width
                height: Math.min(messageContainer.height + cropItemHeight, maxContainerHeight)

                Column {
                    id: messageContainer

                    clip: true
                    height: Math.min(childrenRect.height, bodyItem.maxContainerHeight - bodyItem.cropItemHeight)

                    anchors {
                        left: parent.left
                        top: parent.top
                        topMargin: 12
                        right: parent.right
                        leftMargin: 10
                        rightMargin: 10
                    }
                }

                MessageCropElement {
                    anchors {
                        top: messageContainer.bottom
                        topMargin: 12
                        horizontalCenter: parent.horizontalCenter
                    }

                    visible: bodyItem.isCropped
                }
            }
        }
    }

    MessagePlayingRow {
        id: playingRow

        anchors {
            left: parent.left
            leftMargin: 10
            bottom: parent.bottom
            bottomMargin: 6
        }

        playingGameServiceId: root.playingGameServiceId
    }

    Rectangle {
        width: parent.width
        height: 2
        anchors {
            margins: 1
            bottom: parent.bottom
        }
        color: Styles.trayPopupHeaderBackground
    }
}
