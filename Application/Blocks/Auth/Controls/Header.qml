import QtQuick 2.4
import GameNet.Controls 1.0
import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0
Item {
    id: root

    implicitHeight: 30

    ContentBackground {
        color: Styles.contentBackgroundDark
    }

    Image {
        anchors {
            left: parent.left
            leftMargin: 8
            verticalCenter: parent.verticalCenter
        }
        source: installPath + Styles.headerGameNetLogo
    }

    ImageButton {
        width: 32
        height: 30
        anchors { right: parent.right; verticalCenter: parent.verticalCenter }
        style {normal: "#00000000"; hover: "#00000000"; disabled: "#00000000"}
        styleImages {
            normal: installPath + Styles.headerClose
            hover: installPath + Styles.headerClose.replace('.png', 'Hover.png')
        }
        toolTip: qsTr("HEADER_BUTTON_CLOSE")
        tooltipGlueCenter: true
        analytics {
            category: 'Auth';
            label: 'Header Close'
        }
        onClicked: SignalBus.hideMainWindow();
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

            borderColor: Styles.checkedButtonActive
            textColor: Styles.lightText
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
            borderColor: Styles.lightText
            textColor: Styles.lightText
        }
    }
}
