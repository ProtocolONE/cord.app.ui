/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
pragma Singleton
import QtQuick 2.4

Item {
    id: root

    signal updateFinished();

    signal authDone(string userId, string appKey, string cookie);
    signal secondAuthDone(string userId, string appKey, string cookie);

    signal profileUpdated();

    signal logoutDone();
    signal logoutRequest();

    signal logoutSecondRequest();

    signal setGlobalState(string name);
    signal setGlobalProgressVisible(bool value, int timeout);

    signal progressChanged(variant gameItem);

    signal premiumExpired();

    signal hideMainWindow();
    signal exitApplication();

    signal serviceInstalled(variant gameItem);
    signal serviceStarted(variant gameItem);
    signal serviceFinished(variant gameItem);
    signal serviceUpdated(variant gameItem);
    signal serviceCanceled(variant gameItem)

    signal downloaderStarted(variant gameItem);
    signal navigate(string link, string from);
    signal needPakkanenVerification();
    signal selectService(string serviceId);

    signal leftMousePress(variant rootItem, int x, int y);
    signal leftMouseRelease(variant rootItem, int x, int y);

    signal setTrayIcon(string source);
    signal setAnimatedTrayIcon(string source);
    signal trayIconClicked();

    signal updateTaskbarIcon(string source);
    signal unreadContactsChanged(int contacts);

    signal uninstallRequested(string serviceId);
    signal uninstallStarted(string serviceId);
    signal uninstallProgressChanged(string serviceId, int progress);
    signal uninstallFinished(string serviceId);

    signal openDetailedUserInfo(variant opt);
    signal closeDetailedUserInfo();

    signal servicesLoaded();

    signal beforeCloseUI();

    signal applicationActivated();
    signal applicationDeactivated();

    signal buyGame(string serviceId);

    function cancelDownload(gameItem) {
        serviceCanceled(gameItem);
    }

    Item {
        id: applicationStateHandler

        property int oldApplicationState: -1

        Connections {
            target: Qt.application

            onStateChanged: {
                var oldActive = applicationStateHandler.oldApplicationState === Qt.ApplicationActive;
                var newActive = Qt.application.state === Qt.ApplicationActive;
                applicationStateHandler.oldApplicationState = Qt.application.state;
                if (oldActive != newActive) {
                    if (newActive) {
                        root.applicationActivated();
                    } else {
                        root.applicationDeactivated();
                    }
                }
            }
        }
    }
}
