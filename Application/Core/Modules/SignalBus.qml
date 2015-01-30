/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1

QtObject {
    property bool isAnySecondServiceRunning

    signal updateFinished();

    signal authDone(string userId, string appKey, string cookie);
    signal secondAuthDone(string userId, string appKey, string cookie);

    signal logoutDone();
    signal logoutRequest();

    signal logoutSecondRequest();

    signal setGlobalState(string name);
    signal setGlobalProgressVisible(bool value, int timeout);

    signal backgroundMousePressed(int mouseX, int mouseY);
    signal backgroundMousePositionChanged(int mouseX, int mouseY);
    signal progressChanged(variant gameItem);

    signal openPurchaseOptions(variant purchaseOptions);
    signal openBuyGamenetPremiumPage();
    signal premiumExpired();

    signal hideMainWindow();
    signal exitApplication();
    signal serviceInstalled(variant gameItem);
    signal serviceStarted(variant gameItem);
    signal serviceFinished(variant gameItem);
    signal serviceUpdated(variant gameItem);
    signal downloaderStarted(variant gameItem);
    signal navigate(string link, string from);
    signal publicTestIconClicked();
    signal balanceChanged(int amount);
    signal needPakkanenVerification();
    signal selectService(string serviceId);

    signal leftMousePress(variant rootItem, int x, int y);
    signal leftMouseRelease(variant rootItem, int x, int y);
    signal settingsChange(string path, string key, string value);

    signal setTrayIcon(string source);
    signal setAnimatedTrayIcon(string source);
    signal updateTaskbarIcon(string source);
    signal unreadContactsChanged(int contacts);

    signal uninstallRequested(string serviceId);
    signal uninstallStarted(string serviceId);
    signal uninstallProgressChanged(string serviceId, int progress);
    signal uninstallFinished(string serviceId);

    signal openDetailedUserInfo(variant opt);
    signal closeDetailedUserInfo();

    signal servicesLoaded();
}
