/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4

import GameNet.Core 1.0
import Application.Core 1.0

MouseArea {
    width: 20
    height: 20

    onDoubleClicked: {
        Ga.trackEvent('HiddenAppClose', 'click', 'Quit');
        SignalBus.exitApplication();
    }
}
