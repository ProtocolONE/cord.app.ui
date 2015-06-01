import QtQuick 1.1

import GameNet.Controls 1.0
import Application.Controls 1.0
import Application.Controls.MessagePopup 1.0

import "../../../Core/App.js" as App
import "../../../Core/Styles.js" as Styles
import "../../../Core/moment.js" as Moment
import "../../../Core/EmojiOne.js" as EmojiOne
import "../../../Core/StringHelper.js" as StringHelper

import "../Models/Messenger.js" as MessengerJs

TrayPopupBase {
    id: root

    signal closeButtonClicked()

    property string jid
    property string playingGameServiceId: MessengerJs.userPlayingGame(root)
    property int newHeight: bodyItem.height + 60 + (playingRow.visible ? playingRow.height : 0)
    property bool isCropped: false

    function addMessage(from, body, message) {
        var messageDate = Date.now(),
                lastDelegateHeight,
                maximumHeight,
                maximumListViewHeight = 200 - (playingRow.visible ? playingRow.height + 12 : 0);

        var lastMessageFrom = listModel.count > 0 ? listModel.get(listModel.count - 1).from : "";
        var avatar = d.getAvatar(from);
        var nickname = d.getNickname(from);

        root.restartDestroyTimer();

        if (root.isCropped) {
            return;
        }

        if (data.stamp != "Invalid Date") {
            messageDate = +(Moment.moment(data.stamp));
        }

        listModel.append({
                             from: from,
                             body: body,
                             messageDate: messageDate,
                             avatar: avatar,
                             nickname: nickname,
                             showAvatarAndNickname: lastMessageFrom !== from,
                             maximumHeight: -1
                         });

        if (listViewMessage.calcHeight() > maximumListViewHeight) {
            lastDelegateHeight = listViewMessage.delegateHeights[listViewMessage.count - 1];
            maximumHeight = maximumListViewHeight - (listViewMessage.calcHeight() - lastDelegateHeight);

            listModel.setProperty(listViewMessage.count - 1, 'maximumHeight', maximumHeight);
            root.isCropped = true;
        }

    }

    width: 240
    height: Math.max(newHeight, 92)

    QtObject {
        id: d

        function getNickname(from) {
            var user = MessengerJs.getUser(from);
            if (user.isGroupChat) {
                return MessengerJs.getGroupTitle({jid: from});
            }

            return user.nickname;
        }

        function getAvatar(from) {
            return MessengerJs.userAvatar({jid: from});
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Styles.style.trayPopupBackground

        Column {
            spacing: 1
            anchors {
                fill: parent
                margins: 1
            }

            Rectangle {
                width: parent.width
                height: 25

                color: Styles.style.trayPopupHeaderBackground

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

                width: parent.width
                height: listViewMessage.height + 12

                ListView {
                    id: listViewMessage

                    property variant delegateHeights: {}

                    function refreshHeight() {
                        listViewMessage.height = calcHeight() + 1;
                    }

                    onDelegateHeightsChanged: refreshHeight();

                    function calcHeight() {
                        var result = 0
                        , i;

                        for (i in listViewMessage.delegateHeights) {
                            result += listViewMessage.delegateHeights[i];
                        }

                        return Math.max(40, result);
                    }

                    anchors {
                        left: parent.left
                        top: parent.top
                        topMargin: 12
                        right: parent.right
                        leftMargin: 10
                        rightMargin: 10
                    }

                    interactive: false

                    model: ListModel {
                        id: listModel
                    }

                    delegate: MessageReceivedDelegate {
                        externalMaximumHeight: model.maximumHeight || -1
                        date: model.messageDate
                        body: StringHelper.prepareText(model.body, {
                                                           hyperLinkStyle: Styles.style.messengerChatDialogHyperlinkColor,
                                                           smileResolver: EmojiOne.ns.toImage,
                                                           serviceResolver: App.serviceItemByServiceId
                                                       })
                        avatar: model.avatar
                        nickname: model.nickname
                        showAvatarAndNickname: model.showAvatarAndNickname

                        maximumHeight: model.maximumHeight

                        width: listViewMessage.width

                        onHeightChanged: {
                            var tmp = listViewMessage.delegateHeights;
                            tmp[index] = height;
                            listViewMessage.delegateHeights = tmp;
                        }

                        onLinkActivated: {
                            MessengerJs.instance().messageLinkActivated({jid: root.jid}, link);
                            root.forceDestroy();
                        }
                    }
                }

                MessageCropElement {
                    anchors {
                        top: listViewMessage.bottom
                        topMargin: 12
                        horizontalCenter: parent.horizontalCenter
                    }

                    visible: root.isCropped
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
        color: Styles.style.trayPopupHeaderBackground
    }
}
