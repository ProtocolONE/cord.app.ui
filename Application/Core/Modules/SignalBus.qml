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

    signal authDone(string userId, string appKey, string cookie)
    signal needAuth();
    signal logoutDone();
    signal logoutRequest();

    signal setGlobalState(string name);
    signal setGlobalProgressVisible(bool value, int timeout);

    signal backgroundMousePressed(int mouseX, int mouseY);
    signal backgroundMousePositionChanged(int mouseX, int mouseY);
    signal progressChanged(variant gameItem);
    signal serviceInstalled(variant gameItem);
    signal serviceStarted(variant gameItem);
    signal serviceFinished(variant gameItem);
    signal downloaderStarted(variant gameItem);
    signal navigate(string link, string from);
    signal publicTestIconClicked();
    signal prolongPremium();
    signal balanceChanged(int amount);

    signal openApplicationSettings();
    signal openGameSettings();
}
