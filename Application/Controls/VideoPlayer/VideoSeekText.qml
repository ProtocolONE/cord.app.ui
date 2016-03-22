/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2016, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4

Text {
    id: seekText
    color: "#FFFFFF"

    Rectangle {
        anchors.centerIn: parent
        radius: 2
        width: parent.paintedWidth + 10
        height: parent.paintedHeight + 5
        color: "#000000"
        opacity: 0.7
    }
}

