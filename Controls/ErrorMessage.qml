/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1

Rectangle {
    id: control

    property ErrorMessageStyle style: ErrorMessageStyle {}
    property alias text: errorText.text

    color: style.background
    visible: message.length > 0

    width: parent.width
    height: 30

    Text {
        id: errorText

        wrapMode: Text.WordWrap
        width: parent.width - 10
        height: parent.height - 5
        anchors.centerIn: parent
        color: control.style.text
    }
}
