/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.0
import "../Blocks" as Blocks

import "../js/GoogleAnalytics.js" as GoogleAnalytics
import "../js/Core.js" as Core

Blocks.Home {
    id: homeModel
    signal testAndCloseSignal();

    onMouseItemClicked: {
        homeModel.closeAnimationStart();
        userInfoBlock.closeMenu();
        Core.activateGame(item);
        qGNA_main.state = "GamesSwitchPage";
        GoogleAnalytics.trackPageView('/game/' + item.gaName);
    }
}
