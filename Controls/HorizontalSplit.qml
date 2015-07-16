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

Item {
    property variant style: SplitterStyleColors {}

    implicitWidth: 100
    implicitHeight: 2

    Rectangle {
        height: 1
        width: parent.width
        color: style.main
    }

    Rectangle {
        y: 1
        height: 1
        width: parent.width
        color: style.shadow
    }
}
