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
import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

WidgetView {
    id: root

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: "#243148"
    }

    Row{
        x: 9
        y: 8
        spacing: 10

        Column {
            Item {
                width: 48
                height: 48

                Image {
                    id: avatarImage

                    asynchronous: true
                    anchors.fill: parent
                    source: model.avatarMedium != undefined ? model.avatarMedium : installPath + "Assets/Images/avatar.png"
                }

                CursorMouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    toolTip: qsTr("YOUR_AVATAR")
                    tooltipGlueCenter: true
                }
            }

            Row {
                Rectangle {
                    width: 24
                    height: 24
                    color: "#31415D"

                    Image {
                        anchors.centerIn: parent
                        source: installPath + "Assets/Images/Application/Widgets/UserProfile/" +
                                (model.isPremium ? "premium_active.png" : "premium.png")
                    }

                    CursorMouseArea {

                        function getText() {
                            var durationInDays = Math.floor(model.premiumDuration / 86400);
                            if (durationInDays > 0) {
                                return qsTr("ADVANCED_ACCOUNT_HINT_IN_DAYS").arg(durationInDays);
                            } else {
                                return qsTr("ADVANCED_ACCOUNT_HINT_TODAY");
                            }
                        }

                        anchors.fill: parent
                        hoverEnabled: true
                        toolTip: model.isPremium ? (qsTr("PREMIUM_TOOLTIP") + ". " + getText())
                                                 : qsTr("PREMIUM_NO_TOOLTIP")
                        tooltipGlueCenter: true
                        onClicked: {
                            Popup.show('PremiumShop', 'PremiumShopView')

                            GoogleAnalytics.trackEvent('/PremiumShop/',
                                                       'Premium',
                                                       'show');
                        }
                    }
                }

                Rectangle {
                    width: 24
                    height: 24
                    color: "#364D76"

                    Text {
                        text: model.level
                        width: parent.width
                        height: 16
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        color: "#FAFAFA"
                        font { family: "Arial"; pixelSize: 14 }
                    }

                    CursorMouseArea {
                        anchors.fill: parent
                        toolTip: qsTr("YOUR_GAMENET_LEVEL")
                        tooltipGlueCenter: true
                    }
                }
            }
        }

        Column {
            y: 6
            spacing: 3

            NicknameEdit {
                width: 150
                height: 18

                nickname: model.nickname
                onNicknameClicked: App.openEditNicknameDialog();
            }

            Row {
                spacing: 4
                Text {
                    id: balanceLabel

                    height: 18
                    color: "#FAFAFA"
                    font { family: "Arial"; pixelSize: 14 }
                    text: qsTr("GAMENET_BALANCE").arg(model.balance)
                }

                Image {
                    anchors { bottom: balanceLabel.baseline; bottomMargin: -2 }
                    source: installPath + "Assets/Images/Application/Widgets/UserProfile/coins.png"
                    CursorMouseArea {
                        anchors.fill: parent
                        toolTip: qsTr("GN_MONEY")
                        tooltipGlueCenter: true
                    }
                }
            }

            Button {
                width: 150
                height: 24
                text: qsTr("ADD_MONEY")

                style: ButtonStyleColors {
                    normal: "#567DD8"
                    hover: "#305ec8"
                }

                onClicked: App.replenishAccount()
            }
        }
    }
}
