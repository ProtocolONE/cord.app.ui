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

Window {
    id: root

    property int spacing: 5

    function getPopupContentParent() {
        return popupColumn;
    }

    x: Desktop.primaryScreenAvailableGeometry.width - width + Desktop.primaryScreenAvailableGeometry.x - spacing
    y: Desktop.primaryScreenAvailableGeometry.height - height + Desktop.primaryScreenAvailableGeometry.y - spacing

    flags: Qt.Window | Qt.FramelessWindowHint | Qt.Tool | Qt.WindowMinimizeButtonHint
           | Qt.WindowMaximizeButtonHint | Qt.WindowSystemMenuHint | Qt.WindowStaysOnTopHint

    width: popupColumn.width
    height: 800
    deleteOnClose: false
    visible: popupColumn.children.length > 0
    topMost: true

    Item {
        anchors.fill: parent

        Column {
            id: popupColumn

            anchors.top: parent.bottom
            width: 250
            spacing: 10
            transform: Rotation { angle: 180 }

            move: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}
