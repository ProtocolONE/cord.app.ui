import QtQuick 1.1
import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../../Core/Styles.js"  as Styles
import "../../../Core/App.js" as App

Item {
    id: root

    implicitHeight: 30

    ContentBackground {
        color: Styles.style.contentBackgroundDark
    }

    Image {
        anchors {
            left: parent.left
            leftMargin: 8
            verticalCenter: parent.verticalCenter
        }
        source: installPath + Styles.style.headerGameNetLogo
    }

    ImageButton {
        width: 32
        height: 30
        anchors { right: parent.right; verticalCenter: parent.verticalCenter }
        style {normal: "#00000000"; hover: "#00000000"; disabled: "#00000000"}
        styleImages {
            normal: installPath + Styles.style.headerClose
            hover: installPath + Styles.style.headerClose.replace('.png', 'Hover.png')
        }
        toolTip: qsTr("HEADER_BUTTON_CLOSE")
        tooltipGlueCenter: true
        analytics {
            category: 'Auth';
            label: 'Header Close'
        }
        onClicked: App.hideMainWindow();
    }

    Row {
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            leftMargin: 365
            topMargin: 5
        }
        spacing: 15

        HeaderNavigateItem {
            num: '1'
            width: 140
            text: root.state === 'registration'
               ? qsTr("REGISTRATION_NAVIGATE_CREATE_ACCOUNT_TEXT")
               : qsTr("AUTHORIZATION_NAVIGATE_LOGIN_ACCOUNT_TEXT")

            borderColor: Styles.style.checkedButtonActive
            textColor: Styles.style.lightText
        }

        Image {
            anchors.verticalCenterOffset: -2
            anchors.verticalCenter: parent.verticalCenter
            source: installPath + 'Assets/Images/Application/Blocks/Auth/arrow.png'
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
            disabled: true
            borderColor: Styles.style.lightText
            textColor: Styles.style.lightText
        }
    }
}
