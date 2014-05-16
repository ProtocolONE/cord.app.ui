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

Row {
    property alias firstText: bigText.text
    property alias secondText: smallText.text

    spacing: 2

    Text {
        id: bigText

        color: '#ffcc00'
        font { pixelSize: 20 }
    }

    Text {
        id: smallText

        anchors { bottom: parent.bottom; bottomMargin: 1 }
        color: '#f8f8f6'
        font { pixelSize: 14 }
    }
}



