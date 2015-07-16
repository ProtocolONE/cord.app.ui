/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2015, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0

Rectangle {
    anchors.fill: parent
    color: Styles.popupBlockBackground

    ContentThinBorder {}

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
    }
}

