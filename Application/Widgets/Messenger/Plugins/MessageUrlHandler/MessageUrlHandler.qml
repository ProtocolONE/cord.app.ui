import QtQuick 2.4

import Application.Core 1.0

Item {
    id: root

    property variant messenger

    function urlActivated(user, link) {
        var serviceMatch
        , serviceId
        , subscriptionResult
        , protocolOnePattern = /^https?:\/\/(www\.|support\.|rewards\.)?protocol\.one/ig
        , startServicePattern = /protocolone:\/\/startservice\/(\d*)/
        , subscriptionResultPattern = /protocolone:\/\/subscription\/(decline|accept)/

        if (protocolOnePattern.test(link)) {
            App.openExternalUrlWithAuth(link);
            return;
        }

        serviceMatch = link.match(startServicePattern);
        if (serviceMatch) {
            serviceId = serviceMatch[1];
            if (App.serviceExists(serviceId)) {
                SignalBus.selectService(serviceId);
                App.downloadButtonStart(serviceId);
            }
            return;
        }

        subscriptionResult = link.match(subscriptionResultPattern);
        if (subscriptionResult) {
            if (subscriptionResult[1] === "accept") {
                root.messenger.getJabberClient().rosterManager.acceptSubscription(user.jid, "");
                root.messenger.addContact(user.jid);
            } else {
                root.messenger.getJabberClient().rosterManager.refuseSubscription(user.jid, "");
            }

            return;
        }

        App.openExternalUrl(link);
    }

    Connections {
        target: messenger
        onMessageLinkActivated: root.urlActivated(user, link);
    }
}
