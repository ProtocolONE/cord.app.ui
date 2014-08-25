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

import "../../Core/App.js" as App
import "../../Core/TrayPopup.js" as TrayPopup
import "../../Core/Popup.js" as Popup
import "../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

WidgetModel {
    id: premiumNotifier

    Connections {
        target: App.signalBus()

        onPremiumExpired: {
            var gameItem = App.serviceItemByServiceId(0),
                popUpOptions = {
                    gameItem: gameItem,
                    buttonCaption: qsTr("PREMIUM_EXPIRED_BUTTON_CAPTION"),
                    message: qsTr("PREMIUM_EXPIRED_MESSAGE")
                };

            TrayPopup.showPopup(premiumExpiredPopup, popUpOptions, 'premiumExpiredNotification');
        }
    }

    Component {
        id: premiumExpiredPopup

        GamePopup {
            id: popUp

            state: "Green"

            onPlayClicked: {
                App.activateWindow();
                Popup.show('PremiumShop');
                GoogleAnalytics.trackEvent('/announcement/premiumExpired', 'Announcement', 'Action on Announcement');
            }
            onAnywhereClicked: {
                GoogleAnalytics.trackEvent('/announcement/premiumExpired', 'Announcement', 'Miss Click On Announcement');
            }
            onCloseButtonClicked: {
                GoogleAnalytics.trackEvent('/announcement/premiumExpired', 'Announcement', 'Close Announcement');
            }
            Component.onCompleted: {
                GoogleAnalytics.trackEvent('/announcement/premiumExpired', 'Announcement', 'Close Announcement');
            }
        }
    }
}
