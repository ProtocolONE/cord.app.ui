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
import Tulip 1.0

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Blocks.Auth 1.0

import "../../../Core/Authorization.js" as Authorization
import "../../../Core/App.js" as App
import "../../../Core/Styles.js" as Styles
import "../../../Core/User.js" as User
import "../../../Core/Popup.js" as Popup
import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

WidgetView {
    id: root

    property variant gameItem: App.currentGame()

    implicitWidth: 180
    height: (!User.isSecondAuthorized() ? addAccountBlock.height : 0)
            + (User.isSecondAuthorized() ? secondAccountBlock.height : 0)
    clip: true

    Rectangle {
        anchors.fill: parent
        color: Styles.style.secondAccountBaseBackground
    }

    Rectangle {
        id: addAccountBlock

        color: Styles.style.secondAccountAddAccountBackground

        width: 180
        height: 34
        visible: opacity > 0
        opacity: !User.isSecondAuthorized() ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 250 }
        }

        Item {
            id: addAccountItem

            height: 34
            anchors {
                left: parent.left
                leftMargin: 10
                right: parent.right
                rightMargin: 10
            }

            Button {
                id: addAccountButton

                width: parent.width
                height: 24
                style {
                    normal: Styles.style.secondAccountAddAccountButtonHormal
                    hover: Styles.style.secondAccountAddAccountButtonHover
                }
                textColor: Styles.style.secondAccountAddAccountButtonText
                text: qsTr("PREMIUM_ADD_ACCOUNT")
                analytics: GoogleAnalyticsEvent {
                    page: '/SecondAccountAuth/'
                    category: 'Auth'
                    action: 'add account'
                }

                onClicked: Popup.show('SecondAccountAuth', 'SecondAccountAuthView')
            }

        }
    }

    Rectangle {
        id: secondAccountBlock

        color: Styles.style.secondAccountBackground
        width: parent.width
        height: 88

        visible: opacity > 0
        opacity: User.isSecondAuthorized() ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 250 }
        }

        Item {
            anchors {
                fill: parent
                margins: 10
            }

            Column {
                anchors.fill: parent
                spacing: 8

                Item {
                    width: parent.width
                    height: 12

                    Text {
                        anchors.baseline: parent.bottom
                        font {
                            family: 'Arial'
                            pixelSize: 12
                        }

                        color: Styles.style.secondAccountTitle
                        text: qsTr("SECOND_GAME_BLOCK_PREMIUM_TITLE")
                    }
                }

                Item {
                    width: parent.width
                    height: 12

                    Text {
                        id: nickText

                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                            rightMargin: 22
                        }

                        font {
                            family: 'Arial'
                            pixelSize: 12
                        }

                        color: Styles.style.secondAccountNickname
                        text: User.getSecondNickname()
                        clip: true
                    }

                    Rectangle {
                        width: 16
                        height: 19
                        visible: nickText.paintedWidth >= nickText.width
                        anchors {
                            right: nickText.right
                            verticalCenter: nickText.verticalCenter
                        }
                        rotation: -90

                        gradient: Gradient {
                            GradientStop {
                                position: 0.00
                                color: "#00000000"
                            }
                            GradientStop {
                                position: 0.455
                                color: Styles.style.secondAccountBackground
                            }
                            GradientStop {
                                position: 1.00
                                color: Styles.style.secondAccountBackground
                            }
                        }
                    }

                    ImageButton {
                        width: 24
                        height: 24
                        onClicked: App.logoutSecondRequest();
                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                        }

                        style {
                            normal: "#00000000"
                            hover: "#00000000"
                            disabled: "#00000000"
                        }

                        styleImages {
                            normal: installPath + "/Assets/Images/Application/Widgets/SecondAccountAuth/logout.png"
                            hover: installPath + "/Assets/Images/Application/Widgets/SecondAccountAuth/logout.png"
                            disabled: installPath + "/Assets/Images/Application/Widgets/SecondAccountAuth/logout.png"
                        }

                        analytics: GoogleAnalyticsEvent {
                            page: '/SecondAccountAuth'
                            category: 'Auth'
                            action: 'logout second'
                        }
                    }
                }
            }

            Button {
                id: playSecondAccount

                width: parent.width
                height: 24
                anchors.bottom: parent.bottom

                style {
                    normal: Styles.style.secondAccountPlayButtonNormal
                    hover: Styles.style.secondAccountPlayButtonHover
                    disabled: Styles.style.secondAccountPlayButtonDisabled
                }
                textColor: Styles.style.secondAccountPlayButtonText
                text: qsTr("SECOND_GAME_BLOCK_PREMIUM_PLAY");
                enabled: !!App.currentRunningMainService() && !App.currentRunningSecondService() && !root.gameItem.locked
                analytics: GoogleAnalyticsEvent {
                    page: '/SecondAccountAuth'
                    category: 'Auth'
                    action: 'play second'
                    label: root.gameItem ? 'game: ' + root.gameItem.serviceId : ""
                }

                onClicked: {
                    App.executeSecondService(root.gameItem.serviceId, User.secondUserId() , User.secondAppKey());
                }
            }

            CursorMouseArea {
                width: parent.width
                height: 24
                anchors.bottom: parent.bottom
                visible: !playSecondAccount.enabled
                toolTip: qsTr("SECOND_GAME_BLOCK_PREMIUM_PLAY_TULTIP")
            }
        }
    }

    Behavior on height {
        NumberAnimation { duration: 250 }
    }

    Connections {
        target: App.signalBus()

        onPremiumExpired: App.terminateSecondService();
    }
}
