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

import Application.Core 1.0

Item {
    Connections {
        target: App
        ignoreUnknownSignals: true

        onOpenAuthUrlRequest: {
            var originalUrl = url; // исправляет удаление строки в колбеке рестапишного запроса

            function parseResp(resp) {
                var authUrl = originalUrl;
                try {
                    if (!!resp && !!resp.token) {
                        authUrl = Config.GnUrl.login("/redirect?userId=") + User.userId();

                        if (!User.isAnotherComputer()) {
                            authUrl += "&trustedLocation=1";
                        }

                        authUrl += "&token="+ resp.token + "&url=" + encodeURIComponent(originalUrl)
                    }
                } catch(e) {
                }

                App.openExternalUrl(authUrl);
            }

            RestApi.Auth.getRedirectToken(parseResp, parseResp);
        }
    }
}
