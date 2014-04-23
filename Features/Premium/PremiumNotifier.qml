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

import "../../js/PopupHelper.js" as PopupHelper
import "../../Elements" as Elements
import "../../js/Core.js" as Core
import "../../js/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: premiumNotifier

    function showPremiumExpiredPopup() {
        var gameItem = Core.serviceItemByServiceId(0);
        var popUpOptions = {
            gameItem: gameItem,
            buttonCaption: qsTr("PREMIUM_EXPIRED_BUTTON_CAPTION"), // "Продлить",
            message: qsTr("PREMIUM_EXPIRED_MESSAGE")    //"Действие расширенного аккаунта закончилось."
        };

        PopupHelper.showPopup(premiumExpiredPopup, popUpOptions, 'premiumExpiredNotification');
    }

    Component {
        id: premiumExpiredPopup

        Elements.GameItemPopUp {
            id: popUp

            state: "Green"

            onPlayClicked: {
                Core.openBuyGamenetPremiumPage();
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
