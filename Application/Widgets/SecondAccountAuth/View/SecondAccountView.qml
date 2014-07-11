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
import "../../../Core/User.js" as User
import "../../../Core/Popup.js" as Popup

WidgetView {
    id: root

    implicitWidth: 180
    height: (!User.isSecondAuthorized() ? addAccountBlock.height : 0)
            + (User.isSecondAuthorized() ? secondAccountBlock.height : 0)
    clip: true

    Rectangle {
        anchors.fill: parent
        color: '#082135'
    }

    Rectangle {
        id: addAccountBlock

        color: '#082135'

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

                style: ButtonStyleColors {
                    normal: "#1ABC9C"
                    hover: "#019074"
                }

                text: "PREMIUM_ADD_ACCOUNT"
                onClicked: Popup.show('SecondAccountAuth', 'SecondAccountAuthView')
            }

        }
    }

    Rectangle {
        id: secondAccountBlock

        color: "#253149"
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

                        color: '#597082'
                        text: qsTr("SECOND_GAME_BLOCK_PREMIUM_TITLE")
                    }
                }

                Item {
                    width: parent.width
                    height: 12

                    Text {
                        anchors.baseline: parent.bottom
                        font {
                            family: 'Arial'
                            pixelSize: 12
                        }

                        color: '#ffffff'
                        text: User.getSecondNickname()
                    }

                    ImageButton {
                        width: 24
                        height: 24
                        onClicked: App.logoutSecondRequest();
                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                        }

                        style: ButtonStyleColors {
                            normal: "#00000000"
                            hover: "#00000000"
                            disabled: "#00000000"
                        }

                        styleImages: ButtonStyleImages {
                            normal: installPath + "/Assets/Images/Application/Widgets/SecondAccountAuth/logout.png"
                            hover: installPath + "/Assets/Images/Application/Widgets/SecondAccountAuth/logout.png"
                            disabled: installPath + "/Assets/Images/Application/Widgets/SecondAccountAuth/logout.png"
                        }
                    }
                }
            }

            Button {
                id: playSecondAccount

                width: parent.width
                height: 24
                anchors.bottom: parent.bottom

                style: ButtonStyleColors {
                    normal: "#1ABC9C"
                    hover: "#019074"
                }

                text: qsTr("SECOND_GAME_BLOCK_PREMIUM_PLAY");
                onClicked: {
                    App.executeSecondService(App.currentGame().serviceId, User.secondUserId() , User.secondAppKey());
                }
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
