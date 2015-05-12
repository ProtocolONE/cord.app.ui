import QtQuick 1.1

import Tulip 1.0
import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../../../../Core/App.js" as App
import "../../../../../Core/Styles.js" as Styles
import "../../../../../Core/MessageBox.js" as MessageBox

import "../../../../../../GameNet/Controls/ContextMenu.js" as ContextMenu
import "../../../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

import "../../../Models/Messenger.js" as Messenger

import "../ContactList"
import "../../Styles"

Item {
    width: 237
    height: 392

    QtObject {
        id: d

        function contextMenuClicked(user, action) {
            switch(action) {
            case "information":
                d.showInformation(user);
                break;
            case "delete":
                Messenger.editGroupModel().removeUser(user.jid)
                break;
            case "changeOwner":
                d.changeOwner(user);
                break;
            }

            GoogleAnalytics.trackEvent('/GroupEditView',
                                      'MouseRightClick',
                                      action);
        }

        function showInformation(user) {
            var item = Messenger.getUser(user.jid);
            App.openDetailedUserInfo({
                                        userId: item.userId,
                                        nickname: item.nickname,
                                        status: item.presenceState
                                    });
        }

        function canDelete(model) {
            return !model.self && (d.isOwner() || model.canDelete);
        }

        function isOwner() {
            return Messenger.editGroupModel().owner();
        }

        function changeOwner(user) {
            var nickName = Messenger.getNickname(user);
            MessageBox.show(qsTr("MESSENGER_CHANGE_OWNER_ALERT_TITLE"),
                            qsTr("MESSENGER_CHANGE_OWNER_ALERT_BODY").arg(nickName),
                            MessageBox.button.Ok | MessageBox.button.Cancel, function(result) {
                                if (result != MessageBox.button.Ok) {
                                    return;
                                }

                                Messenger.changeOwner(Messenger.editGroupModel().targetJid, user);
                                Messenger.editGroupModel().close();
                            });
        }
    }


    Connections {
        target: Messenger.editGroupModel()

        onEditStarted: {
            topicInput.text = Messenger.editGroupModel().topic;
        }
    }

    CursorMouseArea {
        cursor: CursorArea.ArrowCursor
        anchors.fill: parent
        hoverEnabled: true
    }

    EditViewBackground {
        anchors.fill: parent
    }

    Item { // content
        id: contentContainer

        anchors {
            fill: parent
            rightMargin: 1 + 12
            bottomMargin: 1 + 12
            leftMargin: 1 + 12
            topMargin: 13 + 8
        }

        Column {
            anchors.fill: parent
            spacing: 10

            GroupNameInput {
                id: topicInput

                width: parent.width
                height: 29
                placeholder: qsTr("GROUP_EDIT_TOPIC_PLACEHOLDER") // "Название группы"
                style {
                    normal: Styles.style.messengerGroupEditInputNormal
                    placeholder: Styles.style.messengerGroupEditInputPlaceholder
                    text: Styles.style.messengerGroupEditInputText
                    background: Styles.style.messengerGroupEditInputBackground
                }
            }

            Item {
                width: parent.width
                height: contentContainer.height -
                        topicInput.height -
                        saveButton.height - parent.spacing*2
                clip: true

                ListView {
                    id: membersView

                    anchors.fill: parent
                    boundsBehavior: Flickable.StopAtBounds

                    model: Messenger.editGroupModel().occupants();

                    delegate: MemberItem {
                        id: memberItem

                        width: membersView.width
                        status: Messenger.getFullStatusMessage(model) || ""
                        avatar: Messenger.userAvatar(model)
                        nickname: Messenger.getNickname(model)
                        canDelete: d.canDelete(model)
                        owner: (model.affiliation === "owner")

                        onDeleteClicked: Messenger.editGroupModel().removeUser(model.jid)
                        onRightButtonClicked: ContextMenu.show(mouse, memberItem, membetItemContextMenu, { targetUser: model });
                    }
                }
            }

            BorderedButton {
                id: saveButton

                width: 139
                height: 31

                anchors.horizontalCenter: parent.horizontalCenter
                style: ActiveButtonStyle {}

                analytics {
                    page: "/GroupEditView"
                    category: "Clicked"
                    action: "SaveGroup"
                }

                fontSize: 12
                text: qsTr("GROUP_EDIT_SAVE_CHANGE") // "Сохранить группу"
                textColor: Styles.style.messengerMessageInputSendButtonText

                onClicked: {
                    var editModel = Messenger.editGroupModel();
                    editModel.topic = topicInput.text;
                    editModel.apply();
                }
            }
        }

        Component {
            id: membetItemContextMenu

            ContextMenuView {

                property variant targetUser

                onContextClicked: {
                    d.contextMenuClicked(targetUser, action)
                    ContextMenu.hide();
                }

                Component.onCompleted: {
                    var options = [];
                    options.push({
                                     name: qsTr("GROUP_EDIT_CONTEXT_MENU_INFORAMTION"),// "Информация",
                                     action: "information"
                                 });

                    if (d.canDelete(targetUser)) {
                        options.push({
                                         name: qsTr("GROUP_EDIT_CONTEXT_MENU_KICK"),//"Выгнать",
                                         action: "delete"
                                     });
                    }

                    if (d.isOwner() && targetUser.affiliation !== "owner") {
                        options.push({
                                         name: qsTr("GROUP_EDIT_CONTEXT_MENU_CHANGE_OWNER"), //"Сделать владельцем",
                                         action: "changeOwner"
                                     });
                    }

                    fill(options);
                }
            }

        }
    }
}
