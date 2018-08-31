import QtQuick 2.4
import Tulip 1.0

import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Blocks 1.0
import Application.Core 1.0
import Application.Core.Popup 1.0

WidgetModel {
    id: premiumNotifier

    settings: WidgetSettings {
        namespace: 'PremiumNotifier'

        property bool premiumExpiredNotification: true
    }

    Connections {
        target: SignalBus

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
            onTimeoutClosed: Ga.trackEvent('Announcement PremiumExpired', 'timeout close');
        }
    }
}
