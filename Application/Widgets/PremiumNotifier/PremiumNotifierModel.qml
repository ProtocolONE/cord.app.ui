/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import Tulip 1.0
import Application.Blocks 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../GameNet/Core/Analytics.js" as Ga

import "../../Core/App.js" as App
import "../../Core/TrayPopup.js" as TrayPopup
import "../../Core/Popup.js" as Popup

WidgetModel {
    id: premiumNotifier

    settings: WidgetSettings {
        namespace: 'PremiumNotifier'

        property bool premiumExpiredNotification: true
    }

    Connections {
        target: App.signalBus()

        onPremiumExpired: {
            if (!premiumNotifier.settings.premiumExpiredNotification) {
                return;
            }

            var gameItem = App.serviceItemByServiceId(0),
                popUpOptions = {
                    gameItem: gameItem,
                    buttonCaption: qsTr("PREMIUM_EXPIRED_BUTTON_CAPTION"),
                    message: qsTr("PREMIUM_EXPIRED_MESSAGE")
                };

            TrayPopup.showPopup(premiumExpiredPopup, popUpOptions, 'premiumExpiredNotification');
            Ga.trackEvent('Announcement PremiumExpired', 'show');
        }
    }

    Component {
        id: premiumExpiredPopup

        GamePopup {
            id: popUp

            onPlayClicked: {
                App.activateWindow();
                Popup.show('PremiumShop');

                Ga.trackEvent('Announcement PremiumExpired', 'buy');
            }
            onAnywhereClicked: Ga.trackEvent('Announcement PremiumExpired', 'miss click');
            onCloseButtonClicked: Ga.trackEvent('Announcement PremiumExpired', 'close');
        }
    }
}
