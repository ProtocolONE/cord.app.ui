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
import Tulip 1.0
import GameNet.Controls 1.0

Button {
    id: root

    property string source

    implicitWidth: 16
    implicitHeight: 14

    style {
        normal: "#00000000"
        hover: "#00000000"
        disabled: "#00000000"
    }

    Image {
        id: icon

        anchors.centerIn: parent

        source: root.containsMouse
                ? root.source.replace('.png', 'Hover.png') :
                  root.source
    }
}
