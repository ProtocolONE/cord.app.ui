/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0
import GameNet.Components.Widgets 1.0

import "../../Core/User.js" as User
import "../../Core/Authorization.js" as Authorization

WidgetModel {

    Timer {
        running: true
        interval: 3600000
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            if (!User.isAuthorized())
                return;

            var lastRefresh = Settings.value("qml/auth/", "refreshDate", -1);
            var currentDate = Math.floor(+new Date() / 1000);

            if (lastRefresh != -1 && (currentDate - lastRefresh < 432000)) {
                return;
            }

            Authorization.refreshCookie(User.userId(), User.appKey(), function(error, response) {
                if (Authorization.isSuccess(error)) {
                    CredentialStorage.save(
                                User.userId(),
                                User.appKey(),
                                response.cookie,
                                User.isGuest());

                    Settings.setValue("qml/auth/", "refreshDate", currentDate);
                }
            })
        }
    }
}
