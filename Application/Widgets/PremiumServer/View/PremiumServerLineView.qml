import QtQuick 2.4
import GameNet.Core 1.0
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Core 1.0
import Application.Controls 1.0
import Application.Core.Styles 1.0
import Application.Core.Popup 1.0

WidgetView {
    id: root

    width: 590
    height: 25

    property variant duration: (function(){
        var currentGame = App.currentGame();

        return currentGame
            ? User.getSubscriptionRemainTime(currentGame.serviceId)
            : null;
    })()

    property bool unlimitAccess: (function(){
        var currentGame = App.currentGame();

        return currentGame
            ? User.hasUnlimitedSubscription(currentGame.serviceId)
            : false
    })();

    ContentBackground {}

    Row {
        layoutDirection: Qt.RightToLeft
        anchors.fill: parent

        Item {
            width: 125
            height: parent.height
            visible: !unlimitAccess

            Rectangle {
                anchors.fill: parent
                color: Styles.light
                opacity: accessMouseArea.containsMouse
                        ? 0.25
                        : 0.10
            }

            Text {
                anchors.centerIn: parent
                text: qsTr("Продлить доступ")
                color: Styles.premiumInfoText
            }

            CursorMouseArea {
                id: accessMouseArea

                anchors.fill: parent
                hoverEnabled: true
                toolTip: qsTr("Нажмите, чтобы активировать доступ на премиум сервер игры")
                tooltipGlueCenter: true
                onClicked: Popup.show('PremiumServer')
            }
        }

        Item {
            width: 20
            height: 1
        }

        Text {
            anchors {
                baseline: parent.verticalCenter
            }

            color: Styles.lightText
            textFormat: Text.RichText
            text: (function(){
                anchors.baselineOffset = 4;
                if (root.duration === null) {
                    return qsTr("У вас нет доступа к премиум серверу");
                }

                var localDuration = Math.abs(root.duration),
                    plural;

                if (root.unlimitAccess) {
                    return qsTr("Доступ к премиум серверу навсегда");
                }

                if (root.duration === 0) {
                    return qsTr("Доступ к премиум серверу истекает сегодня");
                }

                anchors.baselineOffset = 0;
                plural = StringHelper.pluralForm(localDuration, [qsTr("день"), qsTr("дня"), qsTr("дней")]);
                if (root.duration > 0) {
                    return qsTr("Доступ к премиум серверу истекает через <span style=\"font-size: 14px;\">%1</span> %2")
                        .arg(localDuration)
                        .arg(plural);
                }

                return qsTr("Доступ к премиум серверу закончился <span style=\"font-size: 14px;\">%1</span> %2 назад")
                    .arg(localDuration)
                    .arg(plural);
            })()
        }

        Item {
            width: 2
            height: 1
        }

        Image {
            anchors{
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: -1
            }
            source: installPath + Styles.gameMenuPremiumIcon
        }
    }
}
