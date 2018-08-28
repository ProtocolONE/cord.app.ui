import QtQuick 2.4
import Tulip 1.0

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Blocks.Auth 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0
import Application.Core.Popup 1.0
import Application.Core.Authorization 1.0

WidgetView {
    id: root

    property variant gameItem: App.currentGame()

    implicitWidth: 220
    height: User.isSecondAuthorized() ? 120 : 90
    clip: true

    CursorMouseArea {
        cursor: Qt.ArrowCursor
        anchors.fill: parent
        acceptedButtons: Qt.RightButton | Qt.LeftButton
    }

    Text {
        x: 14
        y: 10
        text: qsTr("SECOND_GAME_BLOCK_PREMIUM_TITLE")
        color: Styles.infoText
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
            analytics {
                category: 'SecondAccountAuth';
                label: 'Add second account'
            }
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
                    color: Styles.lightText
                    elide: Text.ElideRight
                    font {family: 'Arial'; pixelSize: 12}
                    clip: true
                }

                ImageButton {
                    width: 24
                    height: 24
                    onClicked: SignalBus.logoutSecondRequest();
                    anchors { verticalCenter: parent.verticalCenter; right: parent.right }
                    style { normal: "#00000000"; hover: "#00000000"; disabled: "#00000000"}
                    styleImages {
                        normal: installPath + Styles.secondAccountAuthLogoutIcon
                        hover: installPath + Styles.secondAccountAuthLogoutIcon.replace('.png', '_hover.png')
                        disabled: installPath + Styles.secondAccountAuthLogoutIcon
                    }
                    analytics {
                        category: 'SecondAccountAuth';
                        label: 'Logout second account'
                    }
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
                    category: 'SecondAccountAuth'
                    action: 'play'
                    label: root.gameItem ? root.gameItem.gaName : ""
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
