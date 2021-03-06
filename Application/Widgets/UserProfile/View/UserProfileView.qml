import QtQuick 2.4
import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0
import Application.Controls 1.0

import Tulip 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0
import Application.Core.Popup 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Config 1.0

WidgetView {
    id: root

    property bool nicknameValid: model.nickname.indexOf('@') == -1
    property bool isLoginConfirmed: model.isLoginConfirmed
    property bool isPromoActionActive: model.isPromoActionActive

    implicitWidth: 230
    implicitHeight: 92

    QtObject {
        id: d

        function getProtocolOneProfileUrl() {
            return Config.site("/users/" + (User.getTechName() || User.userId()) + "/");
        }

        function contextMenuClicked(action) {
            ContextMenu.hide();

            switch(action) {
            case "information":
                d.showInformation();
                break;
            case "setname":
                Popup.show('NicknameEdit');
                break;
            case "confirmemail":
                App.openExternalUrlWithAuth(Config.site("/my-settings/email/"));
                break;
            case "profile":
                d.openProfile();
                break;
            case "money":
                App.replenishAccount();
                break;
            case "security":
                App.openExternalUrlWithAuth(Config.site("/my-settings/security/"));
                break;
            case "logout":
                if (!App.currentRunningMainService() && !App.currentRunningSecondService()) {
                        SignalBus.logoutRequest();
                        return;
                    }

                    MessageBox.show(qsTr("LOGOUT_ALERT_HEADER"),
                                    qsTr("LOGOUT_ALERT_BODY"),
                                    MessageBox.button.ok | MessageBox.button.cancel, function(result) {
                                        if (result != MessageBox.button.ok) {
                                            return;
                                        }

                                        SignalBus.logoutRequest();
                                    });
                break;
            }

            Ga.trackEvent('UserProfile', 'context menu click', action);
        }

        function fillContextMenu(menu) {
            var options = [];
            options.push({
                             name: qsTr("USER_PROFILE_CONTEXT_MENU_INFORAMTION"),// "Информация",
                             action: "information"
                         });

            if (!root.nicknameValid) {
                options.push({
                                 name: qsTr("USER_PROFILE_CONTEXT_MENU_NAME"),// "Задать никнейм",
                                 action: "setname"
                             });
            }

            if (root.state === 'ConfirmEmail') {
                options.push({
                                 name: qsTr("USER_PROFILE_CONTEXT_MENU_MAIL"),// "Подтвердить почту",
                                 action: "confirmemail",
                                 iconLink : Styles.linkIconTray
                             });
            }

            options.push({
                             name: qsTr("USER_PROFILE_CONTEXT_MENU_PROFILE"),// "Профиль",
                             action: "profile",
                             iconLink : Styles.linkIconTray
                         });

            options.push({
                             name: qsTr("USER_PROFILE_CONTEXT_MENU_MONEY"),// "Пополнить счет",
                             action: "money",
                             iconLink : Styles.linkIconTray
                         });

            options.push({
                            name: qsTr("USER_PROFILE_CONTEXT_MENU_SECURITY"),// "Безопасность"
                            action: "security",
                            iconLink : Styles.linkIconTray
                        });

            options.push({
                            name: qsTr("USER_PROFILE_CONTEXT_MENU_LOGOUT"),// "Выйти"
                            action: "logout"
                        });

            menu.fill(options);
        }

        function showInformation() {
            SignalBus.openDetailedUserInfo({
                                        userId: User.userId(),
                                        nickname: User.getNickname(),
                                        status: "online"
                                    });
        }

        function openProfile() {
            App.openExternalUrlWithAuth(d.getProtocolOneProfileUrl());
        }
    }

    ContentBackground {
        anchors.fill: parent
    }

    CursorMouseArea {
        id: rootMouse

        anchors.fill: parent
        hoverEnabled: true
        cursor: Qt.ArrowCursor

        Column {
            anchors.fill: parent

            Item {
                width: parent.width
                height: 22

                Rectangle {
                    anchors.fill: parent
                    color: Styles.light
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

                                color: Styles.textBase
                                font { family: "Arial"; pixelSize: 12 }
                                text: qsTr("PROTOCOLONE_BALANCE")
                            }

                            Text {
                                color: Styles.menuText
                                font { family: "Arial"; pixelSize: 12 }
                                text: model.balance
                            }

                            Image {
                                y: 2
                                source: installPath + "Assets/Images/Application/Widgets/UserProfile/coins.png"
                            }

                            Text {
                                color: Styles.chatInactiveText
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
                            color: Styles.light
                            opacity: addMoneyMouseArea.containsMouse
                                    ? 0.25
                                    : 0.10
                        }

                        Text {
                            id: addMonyeText

                            anchors {
                                verticalCenter : parent.verticalCenter
                                left: parent.left
                                leftMargin: 5
                            }

                            text: qsTr("PROFILE_ADD_MONEY_TEXT")

                            color: Styles.premiumInfoText
                            font.pixelSize: 12
                        }

                        Image {
                            id: iconLink

                            anchors {
                                bottom: addMonyeText.bottom
                                left: addMonyeText.right
                                leftMargin: 3
                                bottomMargin: 2
                            }

                            source: installPath + Styles.linkIconUserProfile
                        }

                        CursorMouseArea {
                            id: addMoneyMouseArea

                            anchors.fill: parent
                            hoverEnabled: true
                            toolTip: isPromoActionActive ? qsTr("В два раза больше GN-монет за те же деньги")
                                        : qsTr("PROFILE_ADD_MONEY_TULTIP")

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
                            if (durationInDays > 2000) {
                                return qsTr("ADVANCED_ACCOUNT_HINT_MORE_THAN_2000_DAYS");
                            } else if (durationInDays > 0) {
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
                            normal: User.isPremium()
                                    ? installPath + Styles.userProfilePremiumIcon.replace('.png', '_active.png')
                                    : installPath + Styles.userProfilePremiumIcon
                            hover: installPath + Styles.userProfilePremiumIcon.replace('.png', '_hover.png')
                            disabled: normal
                        }
                        onClicked: {
                            Popup.show('PremiumShop', 'PremiumShopView')
                            Ga.trackEvent('UserProfile', 'click', 'Premium Shop');
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
                                onClicked: {
                                    App.openExternalUrlWithAuth(Config.site('/edit/#edit-avatar'))
                                }
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
                                    color: root.nicknameValid ? Styles.menuText :
                                                                Styles.infoText

                                    nickname: root.nicknameValid
                                              ? model.nickname
                                              : qsTr("NO_NICKNAME")

                                    tooltip: root.nicknameValid
                                             ? qsTr("YOUR_NICKNAME")
                                             : qsTr("SET_NICKNAME")

                                    onNicknameClicked: {
                                        ContextMenu.show(mouse, area, userProfileContextMenuComponent, { });
                                        Ga.trackEvent('UserProfile', 'click', 'nickname');
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
                                            color: Styles.textBase
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
                                            color: Styles.textBase
                                            font.pixelSize: 12
                                        }
                                    }

                                    CursorMouseArea {
                                        width: row1.width
                                        height: row1.height
                                        toolTip: qsTr("PROFILE_CONFIRM_LOGIN_TULTIP")
                                        onClicked: App.openExternalUrlWithAuth(Config.site("/my-settings/email/"));
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
                                            color: Styles.textBase
                                            font.pixelSize: 12
                                        }

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: qsTr("PROFILE_LEVEL_TEXT")
                                            color: Styles.textBase
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

    ContentStroke {
        height: parent.height
    }

    ContentStroke {
        anchors.right: parent.right
        height: parent.height
    }

    ContentStroke {
        width: parent.width
    }

    states: [
        State { name: 'DefaultNickname'; when: !root.nicknameValid},
        State { name: 'ConfirmEmail'; when: root.nicknameValid && !root.isLoginConfirmed},
        State { name: 'Normal'; when: root.nicknameValid && root.isLoginConfirmed}
    ]
}
