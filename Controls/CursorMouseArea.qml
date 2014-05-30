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
import Tulip 1.0

import "../../GameNet/Controls/Tooltip.js" as Tooltip

MouseArea {
    id: mouser

    property alias cursor: cursorArea.cursor
    property string toolTip
    property string tooltipPosition
    property bool tooltipGlueCenter: false

    hoverEnabled: true
    Component.onCompleted: Tooltip.track(mouser)
    Component.onDestruction: Tooltip.release(mouser)

    CursorArea {
        id: cursorArea

        cursor: CursorArea.PointingHandCursor

        anchors.fill: parent

        // UNDONE этот биндигн сильно мешает - хочется пример когда он нужен или убрать
        visible: mouser.containsMouse
    }
}
