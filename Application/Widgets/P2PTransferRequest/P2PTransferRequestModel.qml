/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2017, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4

import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Settings 1.0
import Application.Core.Popup 1.0

WidgetModel {
    id: root

    property string startingServiceId
    property string licenseIdForBDO : "390"

    property bool inProgress: false

    signal checkLicensedResult(string serviceId, bool shouldShow);

    signal proceed(string serviceId);

    function isLicenseCancelled() {
        return AppSettings.isAppSettingsEnabled(
                    "P2PTransferRequest_QGNA1709",
                    root.startingServiceId,
                    0);
    }

    function setLicenseCancelled() {
        AppSettings.setAppSettingsValue(
                            "P2PTransferRequest_QGNA1709",
                            root.startingServiceId,
                            1);
    }

    function checkTransfer(serviceId) {
        if (serviceId != "30000000000") {
            // INFO Сейчас обработана только одна игра, но можно расширить.
            root.checkLicensedResult(serviceId, false);
            return;
        }

        root.startingServiceId = serviceId;
        var hadSubscruption = User.hadSubscriptionsByService("30000000000");
        if (!hadSubscruption) {
            root.checkLicensedResult(serviceId, false);
            return;
        }

        if (root.isLicenseCancelled()) {
            root.checkLicensedResult(serviceId, false);
            return;
        }

        RestApi.Core.execute('user.isLicenseAccepted',
                             {
                                 serviceId : root.startingServiceId,
                                 licenseId: root.licenseIdForBDO
                             },
                             true, root.checkLisenceResponse
                             , root.checkLisenceResponse);
    }



    function checkLisenceResponse(response) {
        if (!!!response || !response.hasOwnProperty("result")) {
            root.checkLicensedResult(root.startingServiceId, false);
            return;
        }

        if (response.result) {
            root.checkLicensedResult(root.startingServiceId, false);
            return;
        }

        root.checkLicensedResult(root.startingServiceId, true);
    }

    function acceptLicenseClick() {
        RestApi.Core.execute('user.acceptLicense',
                             {
                                 serviceId : root.startingServiceId,
                                 licenseId: root.licenseIdForBDO
                             },
                             true, function(response) {
                                 User.refreshUserInfo();
                             });

        root.proceed(root.startingServiceId);
    }

    function rejectLicenseClick() {
        root.setLicenseCancelled();
        root.proceed(root.startingServiceId);
    }

    function skipLicenseClick() {
        root.proceed(root.startingServiceId);
    }
}
