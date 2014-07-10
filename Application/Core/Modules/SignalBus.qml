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

    signal needAuth();
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
    signal downloaderStarted(variant gameItem);
    signal navigate(string link, string from);
    signal publicTestIconClicked();
    signal prolongPremium();
    signal balanceChanged(int amount);
    signal needPakkanenVerification();
    signal selectService(string serviceId);

    signal openApplicationSettings();
    signal openGameSettings();

    signal leftMouseClick(variant rootItem, int x, int y);
}
