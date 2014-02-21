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
import Tulip 1.0

import "../../js/Core.js" as Core
import "../../js/UserInfo.js" as UserInfo
import "../../Proxy/App.js" as App

Item {
    id: root

    signal backgroundMousePressed(int mouseX, int mouseY);
    signal backgroundMousePositionChanged(int mouseX, int mouseY);

    implicitWidth: Core.clientWidth
    implicitHeight: Core.clientHeight    

    /*
    //Uncomment for debug
    Component.onCompleted: {
        Settings.setValue("qml/features/guide/", "showCount", 0);
        start()
    }
    */

    function start() {
        if (runTimer.running || !App.isAnyLicenseAccepted()) {
            return;
        }

        runTimer.start();
    }

    Timer {
        id: runTimer

        interval: 1000
        onTriggered: d.start()
    }

    Guide {
        id: d

        onBackgroundMousePressed: root.backgroundMousePressed(mouseX, mouseY)
        onBackgroundMousePositionChanged: root.backgroundMousePositionChanged(mouseX, mouseY)

        function start() {
            if (!App.isWindowVisible() ) {
                return;
            }

            if (App.isSilentMode()) {
                return;
            }

            d.show();
        }
    }
}
