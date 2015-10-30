/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4

import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0

import Application.Core 1.0
import Application.Core.Popup 1.0
import Application.Core.MessageBox 1.0
import Application.Blocks 1.0

WidgetModel {
    id: root

    property string serviceId

    function update() {
        var minDuration = Number.MAX_VALUE,
            interval;

        User.getSubscriptions().forEach(function(e) {
            var serviceItem = App.serviceItemByServiceId(e.serviceId),
                remainDays;

            if (!serviceItem || !serviceItem.hasPremiumServer) {
                return;
            }

            remainDays = User.getSubscriptionRemainTime(e.serviceId);
            if (remainDays >= 0 && remainDays < minDuration) {
                minDuration = remainDays;
                root.serviceId = e.serviceId;
            }
        });

        if (minDuration == Number.MAX_VALUE) {
            return;
        }

        interval = Moment.moment()
            .add(minDuration, 'days')
            .endOf('day')
            .add(10, 'seconds')
            .diff(Date.now(), 'milliseconds');

        if (interval <= 2147483647) {
            //INFO Интервал таймера это знаковый int32. Так, что 24 дня максимум того, что в него можно впихнуть.
            //Впрочем у нас на текущий момент нет аптайма приложения в 24 дня. Так что просто игнорируем проблему.
            subscrTimer.interval = interval;
            subscrTimer.restart();
        }
    }

    Connections {
        target: User
        onSubscriptionsChanged: root.update();
    }

    Timer {
        id: subscrTimer

        repeat: false
        onTriggered: {
            var popUpOptions = {
                gameItem: App.serviceItemByServiceId(root.serviceId),
                buttonCaption: qsTr("Восстановить"),
                message: qsTr("Доступ к премиум серверу приостановлен")
            };

            User.refreshUserInfo();
            TrayPopup.showPopup(premiumServerExpiredPopup, popUpOptions, 'premiumServerExpiredNotification');
            Ga.trackEvent('Announcement PremiumServerExpired', 'show');
        }
    }

    Component {
        id: premiumServerExpiredPopup

        GamePopup {
            onPlayClicked: {
                App.activateWindow();
                App.activateGameByServiceId(root.serviceId);
                Popup.show('PremiumServer');

                Ga.trackEvent('Announcement PremiumServerExpired', 'buy');
            }
            onAnywhereClicked: Ga.trackEvent('Announcement PremiumServerExpired', 'miss click');
            onCloseButtonClicked: Ga.trackEvent('Announcement PremiumServerExpired', 'close');
            onTimeoutClosed: Ga.trackEvent('Announcement PremiumServerExpired', 'timeout close');
            onClosed: root.update();
        }
    }
}
