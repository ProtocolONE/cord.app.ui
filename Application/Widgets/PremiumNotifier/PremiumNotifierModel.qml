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

import "../../Core/App.js" as AppJs
import "../../Core/TrayPopup.js" as TrayPopupJs
import "../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: premiumNotifier

    QtObject {
        id: d

        function showPremiumExpiredPopup() {
            var gameItem = AppJs.serviceItemByServiceId(0);
            var popUpOptions = {
                gameItem: gameItem,
                buttonCaption: qsTr("PREMIUM_EXPIRED_BUTTON_CAPTION"), // "Продлить",
                message: qsTr("PREMIUM_EXPIRED_MESSAGE")    //"Действие расширенного аккаунта закончилось."
            };

            TrayPopupJs.showPopup(premiumExpiredPopup, popUpOptions, 'premiumExpiredNotification');
        }
    }

    Connections {
        target: AppJs.signalBus()

        onPremiumExpired: {
            d.showPremiumExpiredPopup();
        }
    }

    Component {
        id: premiumExpiredPopup

        GamePopup {
            id: popUp

            state: "Green"

            onPlayClicked: {
                AppJs.prolongPremium();
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
