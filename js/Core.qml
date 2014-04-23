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

    signal needAuth();
    signal openPurchaseOptions(variant purchaseOptions);

    signal openBuyGamenetPremiumPage();
    signal premiumExpired();

    signal hideMainWindow();
}
