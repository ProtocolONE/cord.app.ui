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

Item {
    property SplitterStyleColors style: SplitterStyleColors {}

    implicitWidth: 2
    implicitHeight: 100

    Rectangle {
        width: 1
        height: parent.height
        color: style.main
    }

    Rectangle {
        x: 1
        width: 1
        height: parent.height
        color: style.shadow
    }
}
