/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import Application.Controls 1.0

import Tulip 1.0

import "../../../Core/App.js" as App
import "../../../Core/Popup.js" as Popup
import "../../../Core/User.js" as User
import "../../../Core/Styles.js" as Styles

import "../../../../GameNet/Controls/ContextMenu.js" as ContextMenu
import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

WidgetView {
    id: root

    property bool nicknameValid: model.nickname.indexOf('@') == -1
    property bool isLoginConfirmed: model.isLoginConfirmed

    implicitWidth: 230
    implicitHeight: 92

    QtObject {
        id: d

        function getGameNetProfileUrl() {
            return "https://gamenet.ru/users/" + (User.getTechName() || User.userId()) + "/";
        }

        function contextMenuClicked(action) {
            ContextMenu.hide();

            switch(action) {
            case "information":
                d.showInformation();
                break;
            case "profile":
                d.openProfile();
                break;
            case "money":
                App.replenishAccount();
                break;
            }

            GoogleAnalytics.trackEvent('/UserProfile',
                                      'MouseRightClick',
                                      action);
        }

        function fillContextMenu(menu) {
            var options = [];
            options.push({
                             name: qsTr("USER_PROFILE_CONTEXT_MENU_INFORAMTION"),// "Информация",
                             action: "information"
                         });

            if (root.nicknameValid) {
                options.push({
                                 name: qsTr("USER_PROFILE_CONTEXT_MENU_PROFILE"),// "Профиль",
                                 action: "profile"
                             });

                options.push({
                                 name: qsTr("USER_PROFILE_CONTEXT_MENU_MONEY"),// "Пополнить счет",
                                 action: "money"
                             });
            }

            menu.fill(options);
        }

        function showInformation() {
            App.openDetailedUserInfo({
                                        userId: User.userId(),
                                        nickname: User.getNickname(),
                                        status: "online"
                                    });
        }

        function openProfile() {
            App.openExternalUrlWithAuth(d.getGameNetProfileUrl());
        }
    }

    ContentBackground {
        anchors.fill: parent
    }

    CursorMouseArea {
        id: rootMouse

        anchors.fill: parent
        hoverEnabled: true
        cursor: CursorArea.ArrowCursor
        acceptedButtons: Qt.RightButton
        onClicked: {
            ContextMenu.show(mouse, rootMouse, userProfileContextMenuComponent, { });
        }

        Column {
            anchors.fill: parent

            Item {
                width: parent.width
                height: 22

                Rectangle {
                    anchors.fill: parent
                    color: Styles.style.light
                    opacity: 0.15
                }

                Row {
                    anchors {
                        fill: parent
                        leftMargin: 13
                    }

                    Item {
                        id: topItem

                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 83
                        height: baseText.height

                        Row {
                            id: topRow

                            anchors.verticalCenter: parent.verticalCenter
                            height: baseText.height
                            spacing: 5

                            Text {
                                id: baseText

                                color: Styles.style.textBase
                                font { family: "Arial"; pixelSize: 12 }
                                text: qsTr("GAMENET_BALANCE")
                            }

                            Text {
                                color: Styles.style.menuText
                                font { family: "Arial"; pixelSize: 12 }
                                text: model.balance
                            }

                            Image {
                                y: 2
                                source: installPath + "Assets/Images/Application/Widgets/UserProfile/coins.png"
                            }

                            Text {
                                color: Styles.style.chatInactiveText
                                font { family: "Arial"; pixelSize: 12 }
                                text: qsTr("PROFILE_MONEY_TEXT")
                                visible: (x + width + topRow.spacing) < topItem.width
                            }
                        }
                    }

                    Item {
                        width: 83
                        height: parent.height

                        Rectangle {
                            anchors.fill: parent
                            color: Styles.style.light
                            opacity: addMoneyMouseArea.containsMouse
                                    ? 0.25
                                    : 0.10
                        }

                        Text {
                            anchors.centerIn: parent
                            text: qsTr("PROFILE_ADD_MONEY_TEXT")

                            color: Styles.style.bannerInfoText
                            font.pixelSize: 12
                        }

                        CursorMouseArea {
                            id: addMoneyMouseArea

                            anchors.fill: parent
                            hoverEnabled: true
                            toolTip: qsTr("PROFILE_ADD_MONEY_TULTIP")
                            tooltipGlueCenter: true
                            onClicked: {
                                App.replenishAccount();
                            }
                        }
                    }
                }
            }

            Item {
                width: parent.width
                height: parent.height - 22

                Item {
                    anchors {
                        fill: parent
                        leftMargin: 10
                        rightMargin: 10
                        topMargin: 10
                    }

                    ImageButton {
                        function getText() {
                            var durationInDays = Math.floor(model.premiumDuration / 86400);
                            if (durationInDays > 0) {
                                return qsTr("ADVANCED_ACCOUNT_HINT_IN_DAYS").arg(durationInDays);
                            } else {
                                return qsTr("ADVANCED_ACCOUNT_HINT_TODAY");
                            }
                        }

                        anchors {
                            right: parent.right
                            top: parent.top
                            rightMargin: 2
                            topMargin: 5
                        }

                        width: 21
                        height: 21

                        toolTip: User.isPremium() ? (qsTr("PREMIUM_TOOLTIP") + ". " + getText())
                                                  : qsTr("PROFILE_EXTENDED_ACCOUNT_TEXT")

                        style: ButtonStyleColors {
                            normal: "#00000000"
                            hover: normal
                            disabled: normal
                        }

                        styleImages: ButtonStyleImages {
                            property string active: installPath + 'Assets/images/Application/Widgets/UserProfile/premium_active.png'

                            normal: User.isPremium() ? active :
                                                       installPath + 'Assets/images/Application/Widgets/UserProfile/premium.png'
                            hover: installPath + 'Assets/images/Application/Widgets/UserProfile/premium_hover.png'
                            disabled: normal
                        }
                        onClicked: {
                            Popup.show('PremiumShop', 'PremiumShopView')

                            GoogleAnalytics.trackEvent('/UserProfile',
                                                       'UserProfileView',
                                                       'ShowPremiumPopup');
                        }
                    }

                    Row {
                        anchors.fill: parent
                        spacing: 10

                        WebImage {
                            id: avatarImage

                            width: 48
                            height: 48
                            asynchronous: true
                            source: model.avatarMedium != undefined
                                    ? model.avatarMedium
                                    : installPath + "Assets/Images/Application/Widgets/UserProfile/defaultAvatar.png"

                            CursorMouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                toolTip: qsTr("YOUR_AVATAR")
                                tooltipGlueCenter: true
                                acceptedButtons: Qt.LeftButton
                                onClicked: App.openExternalUrlWithAuth('https://gamenet.ru/edit/#edit-avatar')
                            }
                        }

                        Item {
                            width: parent.width - 10 - avatarImage.width
                            height: parent.height

                            Column {
                                anchors {
                                    fill: parent
                                    topMargin: 5
                                }

                                spacing: 8

                                NicknameEdit {
                                    width: 150 - 30
                                    height: 18
                                    color: root.nicknameValid ? Styles.style.mainMenuText :
                                                                Styles.style.infoText

                                    nickname: root.nicknameValid ? model.nickname : qsTr("NO_NICKNAME")
                                    tooltip: root.nicknameValid ? qsTr("YOUR_NICKNAME") : qsTr("SET_NICKNAME")
                                    onNicknameClicked: {
                                        if (!nicknameValid) {
                                            Popup.show('NicknameEdit');
                                        } else {
                                            d.openProfile()
                                        }

                                        GoogleAnalytics.trackEvent('/UserProfile',
                                                                   'UserProfileView',
                                                                   'nickname clicked');
                                    }
                                }

                                Item {
                                    width: parent.width
                                    height: 20

                                    visible: root.state === 'DefaultNickname'

                                    Row {
                                        id: row

                                        height: parent.height
                                        spacing: 5

                                        Image {
                                            source: installPath  + "Assets/Images/Application/Widgets/UserProfile/attention.png"
                                        }

                                        Text {
                                            text: qsTr("PROFILE_CHOISE_NICKNAME")
                                            color: Styles.style.textBase
                                            font.pixelSize: 12
                                        }
                                    }

                                    CursorMouseArea {
                                        width: row.width
                                        height: row.height
                                        toolTip: qsTr("PROFILE_CHOISE_NICKNAME_TULTIP")
                                        onClicked: Popup.show('NicknameEdit');
                                        acceptedButtons: Qt.LeftButton
                                    }
                                }

                                Item {
                                    width: parent.width
                                    height: 20

                                    visible: root.state === 'ConfirmEmail'

                                    Row {
                                        id: row1

                                        height: parent.height
                                        spacing: 5

                                        Image {
                                            source: installPath  + "Assets/Images/Application/Widgets/UserProfile/attention.png"
                                        }

                                        Text {
                                            text: qsTr("PROFILE_CONFIRM_LOGIN")
                                            color: Styles.style.textBase
                                            font.pixelSize: 12
                                        }
                                    }

                                    CursorMouseArea {
                                        width: row1.width
                                        height: row1.height
                                        toolTip: qsTr("PROFILE_CONFIRM_LOGIN_TULTIP")
                                        onClicked: App.openExternalUrlWithAuth("https://gamenet.ru/edit/#edit-reginfo");
                                        acceptedButtons: Qt.LeftButton
                                    }
                                }

                                Item {
                                    width: parent.width
                                    height: 20
                                    visible: root.state === 'Normal'

                                    Row {
                                        height: parent.height
                                        spacing: 4

                                        Image {
                                            anchors.verticalCenter: parent.verticalCenter
                                            source: installPath  + "Assets/Images/Application/Widgets/UserProfile/level.png"
                                        }

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: User.getLevel()
                                            color: Styles.style.textBase
                                            font.pixelSize: 12
                                        }

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: qsTr("PROFILE_LEVEL_TEXT")
                                            color: Styles.style.textBase
                                            font.pixelSize: 12
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: userProfileContextMenuComponent

        ContextMenuView {
            id: contextMenu

            onContextClicked: d.contextMenuClicked(action)
            Component.onCompleted: d.fillContextMenu(contextMenu);
        }
    }

    Rectangle {
        width: 1
        height: parent.height
        color: Styles.style.light
        opacity: Styles.style.blockInnerOpacity
    }

    Rectangle {
        anchors.right: parent.right
        width: 1
        height: parent.height
        color: Styles.style.light
        opacity: Styles.style.blockInnerOpacity
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Styles.style.light
        opacity: Styles.style.blockInnerOpacity
    }

    states: [
        State { name: 'DefaultNickname'; when: !root.nicknameValid},
        State { name: 'ConfirmEmail'; when: root.nicknameValid && !root.isLoginConfirmed},
        State { name: 'Normal'; when: root.nicknameValid && root.isLoginConfirmed}
    ]
}
