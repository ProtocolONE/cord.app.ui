/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import GameNet.Components.Widgets 1.0
import Application.Core 1.0

WidgetModel {
    id: root

    property bool isPremium: User.isPremium()
    property bool isLoginConfirmed: User.isLoginConfirmed()
    property int premiumDuration: User.getPremiumDuration()
    property int balance: User.getBalance()

    property string nickname: User.getNickname()
    property string level: User.getLevel()
    property string avatarMedium: User.getAvatarMedium()

    property bool isGuest: User.isGuest()

    property bool isPromoActionActive: User.isPromoActionActive()
}
