import QtQuick 1.1
import GameNet.Controls 1.0

import "../../Core/Styles.js"  as Styles
import "../../Core/App.js" as App
import "../Header"

Rectangle {
    id: root

    implicitHeight: 62
    color: Styles.style.authHeaderBackground

    Image {
        anchors {
            left: parent.left
            leftMargin: 15
            verticalCenter: parent.verticalCenter
        }

        source: installPath + "Assets/Images/Auth/GamenetLogo.png"
    }

    Rectangle {
        height: 1
        color: Qt.darker(Styles.style.authHeaderBackground, Styles.style.darkerFactor)
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 1
        }
    }

    Rectangle {
        height: 1
        color: Qt.lighter(Styles.style.authHeaderBackground, Styles.style.lighterFactor)
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }

    Item {
        width: 120
        height: parent.height
        anchors { right: parent.right; rightMargin: 10 }


        Row {
            anchors.fill: parent
            layoutDirection: Qt.RightToLeft

            HeaderControlButton {
                width: 26
                height: parent.height
                source: installPath + "Assets/Images/Application/Blocks/Header/Close.png"
                anchors.verticalCenter: parent.verticalCenter
                toolTip: qsTr("HEADER_BUTTON_CLOSE")
                tooltipGlueCenter: true
                analytics: GoogleAnalyticsEvent {
                    page: '/Header/AuthScreen'
                    category: 'Navigation'
                    action: 'Close application'
                }

                onClicked: App.hideMainWindow();
            }

        }
    }

    Row {
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            leftMargin: 255
            topMargin: 15
        }

        spacing: 10
        visible: root.state === 'registration'

        HeaderNavigateItem {
            num: '1'
            text: qsTr("REGISTRATION_NAVIGATE_CREATE_ACCOUNT_TEXT")
            color: Styles.style.authRegistrationNavigateItemHover
            borderColor: Styles.style.authRegistrationNavigateItem
            textColor: Styles.style.authRegistrationNavigateItem
        }

        Rectangle {
            y: 20
            width: 28
            height: 1
            color: Styles.style.authRegistrationNavigateItem

            Rectangle {
                anchors {
                    right: parent.right
                    top: parent.top
                    topMargin: -2
                    rightMargin: -1
                }

                rotation: 45

                width: 7
                height: 1
                color: Styles.style.authRegistrationNavigateItem
            }

            Rectangle {
                anchors {
                    right: parent.right
                    top: parent.top
                    topMargin: 2
                    rightMargin: -1
                }

                rotation: -45

                width: 7
                height: 1
                color: Styles.style.authRegistrationNavigateItem
            }
        }

        Item {
            width: 15
            height: 1
        }

        HeaderNavigateItem {
            function playText() {
                var serviceId = App.startingService() || '0';
                if (!serviceId || serviceId == '0') {
                    return qsTr("REGISTRATION_NAVIGATE_PLAY_IN_TEXT");
                }

                var gameName = App.serviceItemByServiceId(serviceId).name;

                return qsTr("REGISTRATION_NAVIGATE_PLAY_IN_WITH_GAME_TEXT").arg(gameName);
            }

            num: '2'
            text: playText()
            borderColor: Styles.style.authRegistrationNavigateItemDisabled
            textColor: Styles.style.authRegistrationNavigateItem
            color: '#00000000'
        }
    }
}
