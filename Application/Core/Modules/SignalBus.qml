pragma Singleton
import QtQuick 2.4

Item {
    id: root

    signal updateFinished();

    signal authDone();
    signal authTokenChanged();
    signal authTokenExpired();

    signal profileUpdated();

    signal logoutDone();
    signal logoutRequest();

    signal logoutSecondRequest();

    signal setGlobalState(string name);
    signal setGlobalProgressVisible(bool value, int timeout);

    signal progressChanged(variant gameItem);

    signal premiumExpired();

    signal hideMainWindow();
    signal collapseMainWindow();
    signal exitApplication();

    signal serviceInstalled(variant gameItem);
    signal serviceStarted(variant gameItem);
    signal serviceFinished(variant gameItem);
    signal serviceUpdated(variant gameItem);
    signal serviceCanceled(variant gameItem)

    signal downloaderStarted(variant gameItem);
    signal navigate(string link, string from);

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

    signal requestUpdateService();

    // INFO Jabber special message about standalone game.
    signal buyGameCompleted(string serviceId, string message);

    signal terminateGame(string serviceId, string message);
    signal terminateAllGame(string message);

    signal anotherComputerChanged(bool value);

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
