pragma Singleton

import QtQuick 2.4
import "./MyGames.js" as Js

import Application.Core 1.0
import Application.Core.Settings 1.0

Item {

    function isShownInMyGames(serviceId) {
        if (Js.serviceStartButtonClicked[serviceId]) {
            return true;
        }

        return AppSettings.value("gameInstallBlock/serviceStartButtonOnceClicked", serviceId, 0) == 1;
    }

    function setShowInMyGames(serviceId, value) {
        if (value && !Js.serviceStartButtonClicked.hasOwnProperty(serviceId)) {
            AppSettings.setValue("gameInstallBlock/serviceStartButtonOnceClicked", serviceId, 1);
            Js.serviceStartButtonClicked[serviceId] = true;
            SignalBus.serviceUpdated(App.serviceItemByServiceId(serviceId));
        }

        if (!value && Js.serviceStartButtonClicked.hasOwnProperty(serviceId)) {
            AppSettings.setValue("gameInstallBlock/serviceStartButtonOnceClicked", serviceId, 0);
            delete Js.serviceStartButtonClicked[serviceId];
            SignalBus.serviceUpdated(App.serviceItemByServiceId(serviceId));
        }
    }
}
