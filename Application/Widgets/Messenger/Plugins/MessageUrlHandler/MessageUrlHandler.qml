import QtQuick 1.1

import "../../../../Core/App.js" as App

Item {
    id: root

    property variant messenger

    function urlActivated(user, link) {
        var serviceMatch
        , serviceId
        , subscriptionResult
        , gameNetPattern = /^https?:\/\/(www\.|support\.|rewards\.)?gamenet\.ru/ig
        , startServicePattern = /gamenet:\/\/startservice\/(\d*)/
        , subscriptionResultPattern = /gamenet:\/\/subscription\/(decline|accept)/

        if (gameNetPattern.test(link)) {
            App.openExternalUrlWithAuth(link);
            return;
        }

        serviceMatch = link.match(startServicePattern);
        if (serviceMatch) {
            serviceId = serviceMatch[1];
            if (App.serviceExists(serviceId)) {
                App.selectService(serviceId);
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