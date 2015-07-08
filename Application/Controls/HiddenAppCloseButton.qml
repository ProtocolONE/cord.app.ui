/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1

import "../Core/App.js" as App

import "../../GameNet/Core/Analytics.js" as Ga

MouseArea {
    width: 20
    height: 20

    onDoubleClicked: {
        Ga.trackEvent('HiddenAppClose', 'click', 'Quit');
        App.exitApplication();
    }
}
