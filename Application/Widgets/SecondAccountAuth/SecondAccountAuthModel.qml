/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0

import GameNet.Components.Widgets 1.0

import "../../Core/App.js" as App
import "../../Core/User.js" as User

WidgetModel {
    id: root

    property string secondNickname: User.getSecondNickname()
    property string savePrefix: "second_"

    function secondLogout() {
        User.resetSecond();
        CredentialStorage.resetEx(root.savePrefix);
    }

    function autoLogin() {
        var savedAuth = CredentialStorage.loadEx(root.savePrefix);
        if (!savedAuth || !savedAuth.userId || !savedAuth.appKey || !savedAuth.cookie) {
            return;
        }

        App.secondAuthDone(savedAuth.userId, savedAuth.appKey, savedAuth.cookie);
    }

   Connections {
       target: App.signalBus()

       onAuthDone: root.autoLogin();
       onLogoutRequest: root.secondLogout();
       onLogoutSecondRequest: root.secondLogout();
   }


}