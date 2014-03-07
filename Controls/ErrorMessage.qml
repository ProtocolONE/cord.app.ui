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
    height: visible ? (errorText.height + 10) : 0

    Text {
        id: errorText

        wrapMode: Text.WordWrap

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 5
        }

        font { pixelSize: 12; family: "Arial" }

        color: control.style.text
        smooth: false
    }
}
