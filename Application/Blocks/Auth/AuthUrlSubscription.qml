import QtQuick 2.4

import ProtocolOne.Core 1.0

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
