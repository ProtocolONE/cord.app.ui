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
import GameNet.Controls 1.0

Button {
    id: root

    property alias source: icon.source

    width: 16
    height: 14
    opacity: root.containsMouse ? 1 : 0.2

    style: ButtonStyleColors {
        normal: "#00000000"
        hover: "#00000000"
        disabled: "#00000000"
    }

    Image {
        id: icon

        anchors.centerIn: parent
    }

    Behavior on opacity {
        NumberAnimation { duration: 250 }
    }
}
