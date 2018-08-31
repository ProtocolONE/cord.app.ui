import QtQuick 2.4
import Tulip 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Core 1.0
import Application.Core.Settings 1.0
import Application.Core.Authorization 1.0

WidgetModel {

    Timer {
        running: true
        interval: 3600000
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            if (!User.isAuthorized()) {
                return;
            }

            var lastRefresh = AppSettings.value("qml/auth/", "refreshDate", -1);
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
                                false);

                    AppSettings.setValue("qml/auth/", "refreshDate", currentDate);
                }
            })
        }
    }
}
