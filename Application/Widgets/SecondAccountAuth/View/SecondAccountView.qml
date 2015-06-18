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
import Application.Controls 1.0

import "../../../Core/Authorization.js" as Authorization
import "../../../Core/App.js" as App
import "../../../Core/Styles.js" as Styles
import "../../../Core/User.js" as User
import "../../../Core/Popup.js" as Popup
import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

WidgetView {
    id: root

    property variant gameItem: App.currentGame()

    implicitWidth: 220
    height: User.isSecondAuthorized() ? 120 : 90
    clip: true

    Text {
        x: 14
        y: 10
        text: qsTr("SECOND_GAME_BLOCK_PREMIUM_TITLE")
        color: Styles.style.infoText
        font {family: 'Arial'; pixelSize: 12}
    }

    Item {
        anchors {fill: parent; margins: 10; topMargin: 22 }

        AuxiliaryButton {
            id: addAccountButton

            visible: opacity > 0
            opacity: !User.isSecondAuthorized() ? 1 : 0
            width: parent.width
            height: 42
            anchors.bottom: parent.bottom
            text: qsTr("PREMIUM_ADD_ACCOUNT")
            analytics { page: '/SecondAccountAuth/'; category: 'Auth'; action: 'add account'}
            onClicked: Popup.show('SecondAccountAuth', 'SecondAccountAuthView')

            Behavior on opacity {
                NumberAnimation { duration: 250 }
            }
        }

        Item {
            visible: opacity > 0
            opacity: User.isSecondAuthorized() ? 1 : 0
            anchors {fill: parent; topMargin: 15}

            Behavior on opacity {
                NumberAnimation { duration: 250 }
            }

            Item {
                width: parent.width
                height: 16

                Text {
                    x: 4
                    text: User.getSecondNickname()
                    width: 180
                    color: Styles.style.lightText
                    elide: Text.ElideRight
                    font {family: 'Arial'; pixelSize: 12}
                    clip: true
                }

                ImageButton {
                    width: 24
                    height: 24
                    onClicked: App.logoutSecondRequest();
                    anchors { verticalCenter: parent.verticalCenter; right: parent.right }
                    style { normal: "#00000000"; hover: "#00000000"; disabled: "#00000000"}
                    styleImages {
                        normal: installPath + "/Assets/Images/Application/Widgets/SecondAccountAuth/logout.png"
                        hover: installPath + "/Assets/Images/Application/Widgets/SecondAccountAuth/logout_hover.png"
                        disabled: installPath + "/Assets/Images/Application/Widgets/SecondAccountAuth/logout.png"
                    }
                    analytics {page: '/SecondAccountAuth'; category: 'Auth'; action: 'logout second'}
                }
            }

            AuxiliaryButton {
                id: playSecondAccount

                height: 42
                width: parent.width
                anchors.bottom: parent.bottom
                text: qsTr("SECOND_GAME_BLOCK_PREMIUM_PLAY");
                enabled: !!App.currentRunningMainService() && !App.currentRunningSecondService()
                analytics {
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
                anchors.fill: playSecondAccount
                visible: !playSecondAccount.enabled
                toolTip: qsTr("SECOND_GAME_BLOCK_PREMIUM_PLAY_TULTIP")
            }
        }
    }
}
