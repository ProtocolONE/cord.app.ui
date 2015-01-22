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

import "../../../Core/App.js" as App
import "../../../Core/Popup.js" as Popup
import "../../../Core/User.js" as User
import "../../../Core/Styles.js" as Styles

import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

WidgetView {
    id: root

    property bool nicknameValid: model.nickname.indexOf('@') == -1

    implicitWidth: 230
    implicitHeight: 92

    function getGameNetProfileUrl() {
        return "https://gamenet.ru/users/" + (User.getTechName() || User.userId()) + "/";
    }

    Rectangle {
        anchors.fill: parent
        color: Styles.style.profileBackground
    }

    Column {
        anchors.fill: parent

        Rectangle {
            width: parent.width
            height: 21
            color: Styles.style.profileBackgroundTop

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

                            color: Styles.style.profileBaseText
                            font { family: "Arial"; pixelSize: 12 }
                            text: qsTr("GAMENET_BALANCE")
                        }

                        Text {
                            color: Styles.style.profileBalanceText
                            font { family: "Arial"; pixelSize: 12 }
                            text: model.balance
                        }

                        Image {
                            y: 2
                            source: installPath + "Assets/Images/Application/Widgets/UserProfile/coins.png"
                        }

                        Text {
                            color: Styles.style.profileBaseText
                            font { family: "Arial"; pixelSize: 12 }
                            text: qsTr("PROFILE_MONEY_TEXT")
                            visible: (x + width + topRow.spacing) < topItem.width
                        }
                    }
                }

                Rectangle {
                    width: 83
                    height: parent.height
                    color: addMoneyMouseArea.containsMouse ? Styles.style.profileAddMoneyHover :
                                                             Styles.style.profileAddMoneyNormal

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("PROFILE_ADD_MONEY_TEXT")
                        color: addMoneyMouseArea.containsMouse ? Styles.style.profileBackgroundTop :
                                                                 Styles.style.profileAddMoneyTextHover

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
            height: parent.height - 21

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

                    Image {
                        id: avatarImage

                        asynchronous: true
                        source: model.avatarMedium != undefined ?
                                    model.avatarMedium : installPath + "Assets/Images/Application/Widgets/UserProfile/defaultAvatar.png"

                        CursorMouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            toolTip: qsTr("YOUR_AVATAR")
                            tooltipGlueCenter: true
                            onClicked: App.openExternalUrlWithAuth('https://gamenet.ru/edit/')
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
                                color: root.nicknameValid ? Styles.style.profileNicknameTextNormal :
                                                            Styles.style.profileNicknameTextNotValid

                                nickname: root.nicknameValid ? model.nickname : qsTr("NO_NICKNAME")
                                tooltip: root.nicknameValid ? qsTr("YOUR_NICKNAME") : qsTr("SET_NICKNAME")
                                onNicknameClicked: {
                                    if (!nicknameValid) {
                                        Popup.show('NicknameEdit');
                                    } else {
                                        App.openExternalUrlWithAuth(root.getGameNetProfileUrl());
                                    }

                                    GoogleAnalytics.trackEvent('/UserProfile',
                                                               'UserProfileView',
                                                               'nickname clicked');
                                }
                            }

                            Item {
                                width: parent.width
                                height: 20

                                visible: !root.nicknameValid

                                Row {
                                    id: row

                                    height: parent.height
                                    spacing: 5

                                    Image {
                                        source: installPath  + "Assets/Images/Application/Widgets/UserProfile/attention.png"
                                    }

                                    Text {
                                        text: qsTr("PROFILE_CHOISE_NICKNAME")
                                        color: Styles.style.profileBaseText
                                        font.pixelSize: 12
                                    }
                                }

                                CursorMouseArea {
                                    width: row.width
                                    height: row.height
                                    toolTip: qsTr("PROFILE_CHOISE_NICKNAME_TULTIP")
                                    onClicked: Popup.show('NicknameEdit');
                                }
                            }

                            Item {
                                width: parent.width
                                height: 20
                                visible: root.nicknameValid

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
                                        color: Styles.style.profileBaseText
                                        font.pixelSize: 12
                                    }

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: qsTr("PROFILE_LEVEL_TEXT")
                                        color: Styles.style.profileBaseText
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
