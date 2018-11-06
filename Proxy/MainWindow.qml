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
import "../Blocks"

Item {
    id: root

    signal windowActivate()
    signal windowDeactivate()
    signal leftMouseClick()

    Connections {
        target: mainWindow

        onLeftMouseClick: root.leftMouseClick();
        onWindowActivate: root.windowActivate();
        onWindowDeactivate: root.windowDeactivate();
    }
}

