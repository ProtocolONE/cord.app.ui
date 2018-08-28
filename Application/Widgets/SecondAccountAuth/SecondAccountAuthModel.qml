import QtQuick 2.4
import Tulip 1.0

import GameNet.Components.Widgets 1.0

import Application.Core 1.0

WidgetModel {
    id: root

    property string secondNickname: User.getSecondNickname()
    property string savePrefix: "second_"

    function secondLogout() {
        User.resetSecond();
        CredentialStorage.resetEx(root.savePrefix);
        App.terminateSecondService();
    }

    function autoLogin() {
        var savedAuth = CredentialStorage.loadEx(root.savePrefix);
        if (!savedAuth || !savedAuth.userId || !savedAuth.appKey || !savedAuth.cookie) {
            return;
        }

        SignalBus.secondAuthDone(savedAuth.userId, savedAuth.appKey, savedAuth.cookie);
    }

   Connections {
       target: SignalBus

       onAuthDone: root.autoLogin();
       onLogoutRequest: root.secondLogout();
       onLogoutSecondRequest: root.secondLogout();
       onPremiumExpired: App.terminateSecondService();
   }


   Connections {
       target: App.mainWindowInstance()
       onWrongCredential: {
           if (userId === User.secondUserId()) {
               root.secondLogout();
           }
       }
   }
}
